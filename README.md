# 42-devbox

## Description

A Docker development environment for 42 Singapore projects. Includes Ubuntu,
GCC/G++, Clang, Make, CMake, GDB, Valgrind, and Norminette. The optional Codex
image adds Node.js and OpenAI Codex CLI.

Keep this repository alongside your projects:

```text
workspace/
├── 42-devbox/
│   ├── .env
│   ├── Dockerfile
│   ├── docker-compose.yml
│   ├── install-norminette.sh
│   └── README.md
├── libft/
├── minishell/
├── philosophers/
└── ...
```

Compose mounts the parent directory at `/workspace`, exposing this repository
and its sibling projects. The container shell starts in `/workspace`.

## Instructions

Run commands from `workspace/42-devbox` with Docker running.

### Configure

Copy the example configuration if you need local overrides. This preserves an
existing `.env`:

```sh
cp -n .env.example .env
```

Compose reads `.env` automatically. Exported shell variables take precedence;
omitted or empty settings use the defaults below. No `.env` file is required
to run with these defaults.

```dotenv
# Host folder mounted at /workspace; relative to this repository.
WORKSPACE_DIR=..

# Local image names and tags.
DEV_IMAGE=42-devbox:dev
CODEX_IMAGE=42-devbox:codex

# Build and runtime architecture.
DOCKER_PLATFORM=linux/amd64

# Persistent Codex configuration and credentials.
CODEX_VOLUME_NAME=42-devbox-codex-data

# Base image release.
UBUNTU_VERSION=22.04

# Compiler major versions; GCC_VERSION also selects G++.
GCC_VERSION=12
CLANG_VERSION=12

# Pinned Norminette version.
NORMINETTE_VERSION=3.3.60

# Codex image: Node.js major release and pinned CLI version.
NODE_MAJOR=22
CODEX_VERSION=0.171.0
```

Set `WORKSPACE_DIR` to an absolute path to mount a different workspace. Compiler
versions must be available in the selected Ubuntu release. After updating
versions, rebuild with the relevant command below. Changing `CODEX_VOLUME_NAME`
selects a different volume; data remains in the previous volume.

### Run the development container

Build the image and open a shell:

```sh
docker compose run --rm --build 42-dev
```

Build a project from the mounted workspace:

```sh
cd /workspace/<project-name>
make
```

### Run with Codex

Build the Codex image and open a shell:

```sh
docker compose run --rm --build 42-codex
```

Run `codex` inside the container. Configuration and credentials persist at
`/root/.codex` through the named volume. The `codex` profile excludes this service
from a plain `docker compose up`; targeting `42-codex` explicitly enables it.

### Exit

Run `exit` to stop and remove the temporary container. Workspace files and the
Codex volume persist; changes elsewhere in the container are discarded.
