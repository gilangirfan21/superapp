# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Commands

- `npm run dev` — start the Vite dev server
- `npm run build` — production build to `dist/` (also the fastest way to catch syntax/import errors across the whole app — there is no separate typecheck/lint step yet)
- `npm run preview` — serve the production build locally

There is no lint, format, or test setup yet. Adding ESLint + Prettier + Vitest is planned.

## What this is

A hub / launcher that lists and opens the other apps in this account (`todolist`, `babytracker`), plus apps built later. It is deliberately **not** a monorepo shell: existing apps stay in their own repos and open in a new tab. New apps should be built inside this repo as routes.

## Architecture

Vue 3 (Composition API, `<script setup>`) + Vite, Tailwind CSS v4, Supabase (Postgres + Auth + RLS), deployed as a static site to GitHub Pages.

**Layering**: `services/*.js` are the only files that import the Supabase client (`src/lib/supabase.js`) — they wrap raw table queries and throw on error. `stores/*.js` (Pinia) call services and hold reactive state; components/views never call services or the Supabase client directly, only stores. When adding a data operation, add it to the relevant service first, then wrap it in the store. This mirrors the todolist repo — keep it.

**Auth boot sequence**: `stores/auth.js`'s `init()` (restores session, subscribes to `onAuthStateChange`) is awaited in `main.js` *before* `app.mount()`. The router's `beforeEach` guard reads `auth.user` synchronously, so if init isn't awaited first, the guard runs against a not-yet-loaded auth state.

**Routing**: `createWebHashHistory`, deliberately — GitHub Pages has no server-side rewrite, so history-mode routing 404s on refresh/deep-link. Don't switch this without also solving that.

**Tailwind v4**: configured via the `@tailwindcss/vite` plugin in `vite.config.js` — there is no `tailwind.config.js` or `postcss.config.js`. Theme lives in `src/style.css` (`@import "tailwindcss"`, `@custom-variant dark (&:where(.dark, .dark *))`, and an `@theme` block defining `--color-brand-*` from the brand orange `#ff6b35`).

## The single-sign-on trick (load-bearing)

All of these apps are served from the **same origin**, `https://gilangirfan21.github.io` — only the path differs (`/superapp/`, `/todolist/`, `/welcome-page/`). `localStorage` is origin-scoped, and `supabase-js` persists the session under `sb-<project-ref>-auth-token`. So **same origin + same Supabase project = one login for everything**, with no OAuth flow between apps.

Two things this depends on. Don't break either without a replacement plan:

1. Every app points at the same Supabase project. `.env` here uses the todolist project (`djeomfyh…`), which is the designated host. babytracker still points at `bznjrtpo…` and has to be migrated over (see below).
2. Every app stays on `gilangirfan21.github.io`. Moving one to Vercel or a custom domain puts it on a different origin and silently ends the shared session.

The dark-mode key in `composables/useDarkMode.js` is `theme`, matching todolist, for the same reason — the theme choice carries across apps.

## Data model

Migrations live in `supabase/migrations/` and are applied by hand (Supabase SQL Editor) or via `supabase db push`. They are not run automatically.

- `0001_hub_init.sql` — `profile_admin`, `apps`, `app_favorites`, `app_launches` + RLS.
- `0002_rename_profiles_baby.sql` — renames babytracker's `profiles` (the mother's pregnancy profile: `hpht`, `baby_name`) to `profiles_baby`. Guarded and idempotent.
- `supabase/seed.sql` — the initial catalog rows. It resolves the owner by looking up an email in `auth.users`, because `auth.uid()` is NULL in the Supabase SQL Editor (it runs as `postgres`, not as a signed-in user) — the `default auth.uid()` on `apps.owner_id` only works for inserts made from the app.

The hub's identity table is `profile_admin`. It is **not** a rename of `profiles` — that table belongs to babytracker and holds the mother's pregnancy profile, a different concept from account identity. `profiles` is renamed to `profiles_baby` only to make ownership legible now that several apps share one database; it was safe to do because the live babytracker still points at the old project (`bznjrtpo…`), leaving the copy here unused. **When babytracker is migrated over (phase 2), its `js/db.js` must switch `.from('profiles')` to `.from('profiles_baby')`.** `measurements`, `todos` and `categories` keep their names — todolist is live against the latter two.

Every table gets RLS in the same migration that creates it. There is no server between the browser and Postgres, so a table without a policy is an open table.

## Catalog

`apps` rows drive the grid. `src/data/apps.json` is a fallback the store falls back to when the query fails, so the hub still renders when logged out or when the DB is unreachable — `usingFallback` then disables favorites and launch logging. Keep the JSON roughly in sync with the seed.

Card icons are keyed by string through `src/lib/icons.js`, an explicit name → component map (not `import * as`, so the bundle only carries what's used). Adding an app with a new icon means adding one line there.

## Deploy

`.github/workflows/deploy.yml` builds and deploys `dist/` to GitHub Pages on push to `main`. Requires, one time and manually in GitHub settings:

- Pages source set to "GitHub Actions"
- repo secrets `VITE_SUPABASE_URL` and `VITE_SUPABASE_ANON_KEY`

`vite.config.js`'s `base` is hardcoded to `/superapp/` to match the repo name; update it if the repo is renamed.

## Roadmap position

Phases 0 and 1 of the plan are built (scaffold, CI, auth, catalog, search/filter, profile, dark mode, favorites, recents). Auth is email/password through Supabase only — GitHub OAuth was deliberately dropped, so do not reintroduce a provider button. Not yet done: merging babytracker into this Supabase project, admin CRUD panel, command palette, PWA, cross-app widgets.
