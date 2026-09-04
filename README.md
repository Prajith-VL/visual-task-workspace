# Northstar

Northstar is a visual task-management workspace built with Next.js, React Flow, TypeScript, Zustand, and Supabase.

## Local development

```bash
npm install
npm run dev
```

Copy `.env.example` to `.env.local` and set the public Supabase project URL plus either `NEXT_PUBLIC_SUPABASE_PUBLISHABLE_KEY` or `NEXT_PUBLIC_SUPABASE_ANON_KEY`. Never place a service-role key in browser-exposed environment variables.

## Database

Apply the versioned migration in `supabase/migrations/` to the Supabase project. It defines profiles, workspaces, nodes, edges, ownership RLS, auth profile creation, and the initial workspace trigger.

## Checks

```bash
npm run lint
npm run build
```

Deploy the Next.js application to Vercel with the same public Supabase environment variables. Configure the production site URL and authentication redirect URLs in Supabase Auth before using password reset in production.
