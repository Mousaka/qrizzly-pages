# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Commands

```bash
npm install        # Install dependencies (also runs elm-tooling install)
npm start          # Dev server on port 1234 (INCLUDE_DRAFTS=true)
npm run build      # Build static site to dist/
```

For linting, elm-review config lives in `review/`:
```bash
npx elm-review    # Run from project root
```

## Architecture

This is a personal blog/website built with **Elm Pages v3** (elm-pages 10.0.3). It generates a fully static site deployed to Netlify.

### Routing

Routes live in `app/Route/` and map directly to URL paths. Elm Pages uses file-based routing:
- `app/Route/Index.elm` → `/`
- `app/Route/Blog/Slug_.elm` → `/blog/:slug`
- `app/Route/Tags/Slug_.elm` → `/tags/:slug`

Routes use `RouteBuilder.preRender` with a `BackendTask` to enumerate all pages at build time. Data loading happens **at build time only**, not at runtime.

### Content System

Blog posts are markdown files in `content/blog/` with YAML frontmatter. `src/Content/Blogpost.elm` uses `BackendTask.Glob` to find all `.md` files and extract metadata (title, description, tags, authors, published date). The `Status` type distinguishes drafts from published posts — drafts are excluded unless `INCLUDE_DRAFTS=true`.

Authors are defined in `content/authors/`.

### Layout

`src/Layout.elm` provides the global header/nav/footer wrapper. Blog post rendering uses `src/Layout/Markdown.elm` backed by `elm-markdown`. Styling is Tailwind CSS with the Nord color scheme defined in `tailwind.config.js` — Nord dark tones are `nord-0` through `nord-3`, light tones `nord-4` through `nord-6`, accent colors `nord-7` through `nord-15`.

### Site Settings

`src/Settings.elm` holds the canonical URL, site title, author name, and locale. Edit this file when changing site-wide identity.

### Effect System

`app/Effect.elm` wraps side effects. `app/Shared.elm` holds global layout state (e.g. mobile menu open/closed). `app/Site.elm` configures site-wide SEO defaults.

### Code Generation

`codegen/` contains elm-codegen scripts. `script/src/AddRoute.elm` is a helper to scaffold new route files.
