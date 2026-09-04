# Northstar

> A visual task-management workspace for organizing complex work as connected, interactive workflows.

Northstar is a full-stack visual task-management application built around an infinite canvas. Instead of managing tasks through a traditional linear list, Northstar lets users visually organize work into connected nodes, creating flexible task workflows that resemble a knowledge graph or visual planning board.

The application is designed to be purely visual — connections represent relationships between tasks and do not execute code, automate actions, or behave like an automation engine.

---

## ✨ Features

### 🧩 Visual Workflow Workspace

- Infinite canvas powered by React Flow
- Drag, pan, zoom, and reposition nodes freely
- Create multiple independent workflows inside a workspace
- Connect any node to any other node
- Multiple incoming and outgoing connections supported
- Self-connections prevented
- Visual connections only — no workflow execution

### 🗂️ Workspace Management

- Create multiple workspaces
- Rename workspaces
- Delete workspaces
- Switch between workspaces
- Workspace-specific nodes and connections
- Automatic cloud persistence
- Stale canvas state is cleared when switching workspaces

### 🧱 Node System

Northstar currently supports four node types:

| Node | Purpose |
|------|---------|
| **Master** | Starting point / root of a workflow |
| **Text** | Free-form notes and task information |
| **Checklist** | Structured tasks with completion tracking |
| **Resource** | Store useful external links |

Each node supports:

- Editable title
- Node-specific content
- 0–5 star rating
- Dragging and repositioning
- Connections
- Deletion
- Persistent state

### ✅ Checklist Nodes

Checklist nodes support structured task items with:

- Unique item IDs
- Task text
- Completion state
- Ordering
- Add item
- Edit item
- Toggle completion
- Delete item

### 🔗 Resource Nodes

Resource nodes allow users to store external materials as links.

Each resource contains:

```text
Title
URL
