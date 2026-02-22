# Next.js Project Initialization Guide

This guide creates a production-ready Next.js + shadcn/ui project scaffolding.

## Prerequisites

- Node.js 18+
- pnpm (recommended) or npm
- Git

---

## Step 1: Get Project Name

**Ask the user:**

```
Enter project name (will be used as directory name):
```

Project name rules:
- Lowercase letters, numbers, and hyphens only
- Must start with a letter
- Examples: `my-blog`, `dashboard`, `content-hub`

Save the user input as `<PROJECT_NAME>` for all subsequent steps.

---

## Step 2: Tech Stack

| Category | Technology |
|----------|------------|
| Framework | Next.js 16 (App Router, SSR) |
| UI | React 19 + TypeScript + Tailwind CSS |
| Components | shadcn/ui |
| i18n | next-intl (en/zh) |
| Theme | next-themes (dark/light) |
| Deployment | Cloudflare Workers |
| Code Quality | ESLint, Prettier, Commitlint, lint-staged, Husky |

---

## Step 3: Initialize Project

### 3.1 Create Next.js Project

```bash
pnpm dlx create-next-app@latest <PROJECT_NAME> --typescript --tailwind --eslint --app --no-src-dir --use-pnpm --import-alias "@/*"
cd <PROJECT_NAME>
```

### 3.2 Install Core Dependencies

```bash
# shadcn/ui
pnpm dlx shadcn@latest init -d

# Internationalization
pnpm add next-intl

# Theme
pnpm add next-themes

# Code Quality Tools
pnpm add -D prettier eslint-config-prettier eslint-plugin-prettier
pnpm add -D @commitlint/cli @commitlint/config-conventional
pnpm add -D lint-staged husky
```

### 3.3 Update components.json

Ensure `components.json` is configured correctly:

```json
{
  "$schema": "https://ui.shadcn.com/schema.json",
  "style": "default",
  "rsc": true,
  "tsx": true,
  "tailwind": {
    "config": "tailwind.config.ts",
    "css": "app/globals.css",
    "baseColor": "neutral",
    "cssVariables": true,
    "prefix": ""
  },
  "aliases": {
    "components": "@/components",
    "utils": "@/lib/utils",
    "ui": "@/components/ui",
    "lib": "@/lib",
    "hooks": "@/hooks"
  }
}
```

---

## Step 4: Create Project Structure

```
<PROJECT_NAME>/
├── app/
│   ├── [locale]/
│   │   ├── layout.tsx
│   │   └── page.tsx
│   └── layout.tsx
├── components/
│   ├── ui/
│   ├── theme-provider.tsx
│   └── theme-toggle.tsx
├── i18n/
│   ├── request.ts
│   └── routing.ts
├── lib/
│   └── utils.ts
├── messages/
│   ├── en.json
│   └── zh.json
├── public/
├── proxy.ts
├── next.config.ts
├── open-next.config.ts
├── wrangler.jsonc
├── tailwind.config.ts
├── tsconfig.json
├── features.json
├── progress.md
└── package.json
```

---

## Step 5: Configuration Files

### 5.1 Internationalization

#### `i18n/routing.ts`

```typescript
import { defineRouting } from 'next-intl/routing'

export const routing = defineRouting({
  locales: ['en', 'zh'],
  defaultLocale: 'en'
})
```

#### `i18n/request.ts`

```typescript
import { getRequestConfig } from 'next-intl/server'
import { routing } from './routing'

export default getRequestConfig(async ({ requestLocale }) => {
  let locale = await requestLocale

  if (!locale || !routing.locales.includes(locale as any)) {
    locale = routing.defaultLocale
  }

  return {
    locale,
    messages: (await import(`../messages/${locale}.json`)).default
  }
})
```

#### `messages/en.json`

```json
{
  "common": {
    "title": "Welcome",
    "description": "A Next.js application"
  }
}
```

#### `messages/zh.json`

```json
{
  "common": {
    "title": "欢迎",
    "description": "一个 Next.js 应用"
  }
}
```

#### `proxy.ts` (root)

```typescript
import createMiddleware from 'next-intl/middleware'
import { routing } from './i18n/routing'

export default createMiddleware(routing)

export const config = {
  matcher: ['/', '/(en|zh)/:path*']
}
```

#### `next.config.ts`

```typescript
import createNextIntlPlugin from 'next-intl/plugin'

const withNextIntl = createNextIntlPlugin('./i18n/request.ts')

const nextConfig = {}

export default withNextIntl(nextConfig)
```

### 5.2 Theme System

#### `components/theme-provider.tsx`

```tsx
'use client'

import * as React from 'react'
import { ThemeProvider as NextThemesProvider } from 'next-themes'

export function ThemeProvider({
  children,
  ...props
}: React.ComponentProps<typeof NextThemesProvider>) {
  return <NextThemesProvider {...props}>{children}</NextThemesProvider>
}
```

#### `components/theme-toggle.tsx`

```tsx
'use client'

import * as React from 'react'
import { Moon, Sun } from 'lucide-react'
import { useTheme } from 'next-themes'
import { Button } from '@/components/ui/button'

export function ThemeToggle() {
  const { setTheme, theme } = useTheme()

  return (
    <Button
      variant="ghost"
      size="icon"
      onClick={() => setTheme(theme === 'light' ? 'dark' : 'light')}
    >
      <Sun className="h-[1.5rem] w-[1.5rem] rotate-0 scale-100 transition-all dark:-rotate-90 dark:scale-0" />
      <Moon className="absolute h-[1.5rem] w-[1.5rem] rotate-90 scale-0 transition-all dark:rotate-0 dark:scale-100" />
      <span className="sr-only">Toggle theme</span>
    </Button>
  )
}
```

### 5.3 Tailwind Dark Mode

#### `tailwind.config.ts`

```typescript
import type { Config } from 'tailwindcss'

const config: Config = {
  darkMode: 'class',
  content: [
    './pages/**/*.{js,ts,jsx,tsx,mdx}',
    './components/**/*.{js,ts,jsx,tsx,mdx}',
    './app/**/*.{js,ts,jsx,tsx,mdx}',
  ],
  theme: {
    extend: {},
  },
  plugins: [],
}
export default config
```

### 5.4 Code Quality Tools

#### `.prettierrc`

```json
{
  "semi": false,
  "singleQuote": true,
  "tabWidth": 2,
  "trailingComma": "es5",
  "printWidth": 100
}
```

#### `commitlint.config.js`

```javascript
module.exports = {
  extends: ['@commitlint/config-conventional']
}
```

#### `.lintstagedrc.js`

```javascript
module.exports = {
  '*.{js,jsx,ts,tsx}': ['eslint --fix', 'prettier --write'],
  '*.{json,md}': ['prettier --write']
}
```

---

## Step 6: Set Up Git Hooks

```bash
pnpm dlx husky init
echo "pnpm lint-staged" > .husky/pre-commit
echo "pnpm commitlint --edit \$1" > .husky/commit-msg
```

---

## Step 7: Cloudflare Workers Deployment

### 7.1 Install Dependencies

```bash
pnpm add @opennextjs/cloudflare
pnpm add -D wrangler
```

### 7.2 Create Wrangler Configuration

#### `wrangler.jsonc`

```jsonc
{
  "$schema": "./node_modules/wrangler/config-schema.json",
  "main": ".open-next/worker.js",
  "name": "<PROJECT_NAME>",
  "compatibility_date": "2026-02-22",
  "compatibility_flags": ["nodejs_compat"],
  "assets": {
    "directory": ".open-next/assets",
    "binding": "ASSETS"
  }
}
```

### 7.3 Create OpenNext Configuration

#### `open-next.config.ts`

```typescript
import { defineCloudflareConfig } from '@opennextjs/cloudflare'

export default defineCloudflareConfig()
```

### 7.4 Update `package.json` Scripts

Add the following scripts:

```json
{
  "scripts": {
    "preview": "opennextjs-cloudflare build && opennextjs-cloudflare preview",
    "deploy": "opennextjs-cloudflare build && opennextjs-cloudflare deploy",
    "cf-typegen": "wrangler types --env-interface CloudflareEnv cloudflare-env.d.ts"
  }
}
```

---

## Step 8: Create Project Files

### `features.json`

```json
{
  "project": {
    "name": "<PROJECT_NAME>",
    "description": "A Next.js application with shadcn/ui",
    "tech_stack": ["next.js", "shadcn/ui", "typescript", "tailwind"],
    "created_at": "<DATE>"
  },
  "sprints": [],
  "metadata": {
    "version": "1.0.0",
    "last_updated": "<DATE>"
  }
}
```

### `progress.md`

```markdown
# Progress Log

## Session 0: Project Initialization

### Completed
- [x] Initialize Next.js 16 with App Router
- [x] Configure TypeScript and Tailwind CSS
- [x] Set up shadcn/ui component library
- [x] Add internationalization (next-intl)
- [x] Add theme support (next-themes)
- [x] Configure code quality tools
- [x] Set up Git hooks
- [x] Configure Cloudflare deployment

### Notes
- Project scaffolded successfully
- Ready for Sprint Agent to define features
```

---

## Step 9: Initial Git Commit

```bash
git add .
git commit -m "chore: initialize Next.js project with shadcn/ui

- Set up Next.js 16 with App Router
- Configure shadcn/ui component library
- Add internationalization with next-intl
- Add dark/light theme support
- Configure Cloudflare deployment
- Add ESLint, Prettier, Commitlint, lint-staged"
```

---

## Step 10: Verification

```bash
pnpm dev     # Start development server
pnpm build   # Production build
pnpm lint    # Run linting
```

---

## Completion Output

```
## Scaffolding Complete

### Project Structure
- Next.js 16 + App Router
- shadcn/ui configured
- i18n (en/zh) ready
- Theme system (dark/light) configured
- Cloudflare deployment ready
- Code quality tools configured

### Quick Start
1. cd <PROJECT_NAME>
2. pnpm dev
3. pnpm build
4. pnpm lint

### Next Steps
1. Run Sprint Agent to define feature list
2. Start Coding Agent sessions
```

---

## Important Principles

1. **Scaffolding Only**: Do NOT implement any business features
2. **Production Ready**: All configurations should be production-grade
3. **Well Documented**: Add README.md with setup instructions
4. **Working State**: The app should run without errors after initialization
5. **Clean Structure**: Follow Next.js best practices
