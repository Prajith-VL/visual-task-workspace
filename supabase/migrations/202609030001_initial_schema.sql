create extension if not exists pgcrypto;

create table public.profiles (
  id uuid primary key references auth.users(id) on delete cascade,
  username text not null unique check (username ~ '^[a-zA-Z0-9_]{3,32}$'),
  display_name text,
  avatar_url text,
  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now()
);

create table public.workspaces (
  id uuid primary key default gen_random_uuid(),
  user_id uuid not null references auth.users(id) on delete cascade,
  name text not null check (char_length(trim(name)) between 1 and 80),
  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now()
);

create table public.nodes (
  id uuid primary key default gen_random_uuid(),
  workspace_id uuid not null references public.workspaces(id) on delete cascade,
  type text not null check (type in ('master', 'text', 'checklist', 'resource')),
  title text not null check (char_length(trim(title)) between 1 and 160),
  content text not null default '',
  position_x double precision not null default 0,
  position_y double precision not null default 0,
  width double precision,
  height double precision,
  rating smallint not null default 0 check (rating between 0 and 5),
  data jsonb not null default '{}'::jsonb,
  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now()
);

create table public.edges (
  id uuid primary key default gen_random_uuid(),
  workspace_id uuid not null references public.workspaces(id) on delete cascade,
  source_node_id uuid not null references public.nodes(id) on delete cascade,
  target_node_id uuid not null references public.nodes(id) on delete cascade,
  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now(),
  check (source_node_id <> target_node_id)
);

create index workspaces_user_id_idx on public.workspaces(user_id);
create index nodes_workspace_id_idx on public.nodes(workspace_id);
create index edges_workspace_id_idx on public.edges(workspace_id);

create or replace function public.handle_new_user()
returns trigger
language plpgsql
security definer set search_path = public
as $$
begin
  insert into public.profiles (id, username, display_name)
  values (
    new.id,
    coalesce(new.raw_user_meta_data ->> 'username', 'user_' || substr(replace(new.id::text, '-', ''), 1, 12)),
    new.raw_user_meta_data ->> 'username'
  );
  insert into public.workspaces (user_id, name) values (new.id, 'Untitled workspace');
  return new;
exception when unique_violation then
  raise exception 'That username is already taken.' using errcode = '23505';
end;
$$;

create or replace trigger on_auth_user_created
  after insert on auth.users
  for each row execute procedure public.handle_new_user();

alter table public.profiles enable row level security;
alter table public.workspaces enable row level security;
alter table public.nodes enable row level security;
alter table public.edges enable row level security;

create policy "Users can read their profile" on public.profiles for select using (auth.uid() = id);
create policy "Users can update their profile" on public.profiles for update using (auth.uid() = id) with check (auth.uid() = id);
create policy "Users can create their profile" on public.profiles for insert with check (auth.uid() = id);

create policy "Users can read their workspaces" on public.workspaces for select using (auth.uid() = user_id);
create policy "Users can create their workspaces" on public.workspaces for insert with check (auth.uid() = user_id);
create policy "Users can update their workspaces" on public.workspaces for update using (auth.uid() = user_id) with check (auth.uid() = user_id);
create policy "Users can delete their workspaces" on public.workspaces for delete using (auth.uid() = user_id);

create policy "Users can read workspace nodes" on public.nodes for select using (exists (select 1 from public.workspaces where workspaces.id = nodes.workspace_id and workspaces.user_id = auth.uid()));
create policy "Users can create workspace nodes" on public.nodes for insert with check (exists (select 1 from public.workspaces where workspaces.id = nodes.workspace_id and workspaces.user_id = auth.uid()));
create policy "Users can update workspace nodes" on public.nodes for update using (exists (select 1 from public.workspaces where workspaces.id = nodes.workspace_id and workspaces.user_id = auth.uid())) with check (exists (select 1 from public.workspaces where workspaces.id = nodes.workspace_id and workspaces.user_id = auth.uid()));
create policy "Users can delete workspace nodes" on public.nodes for delete using (exists (select 1 from public.workspaces where workspaces.id = nodes.workspace_id and workspaces.user_id = auth.uid()));

create policy "Users can read workspace edges" on public.edges for select using (exists (select 1 from public.workspaces where workspaces.id = edges.workspace_id and workspaces.user_id = auth.uid()));
create policy "Users can create workspace edges" on public.edges for insert with check (exists (select 1 from public.workspaces where workspaces.id = edges.workspace_id and workspaces.user_id = auth.uid()));
create policy "Users can update workspace edges" on public.edges for update using (exists (select 1 from public.workspaces where workspaces.id = edges.workspace_id and workspaces.user_id = auth.uid())) with check (exists (select 1 from public.workspaces where workspaces.id = edges.workspace_id and workspaces.user_id = auth.uid()));
create policy "Users can delete workspace edges" on public.edges for delete using (exists (select 1 from public.workspaces where workspaces.id = edges.workspace_id and workspaces.user_id = auth.uid()));
