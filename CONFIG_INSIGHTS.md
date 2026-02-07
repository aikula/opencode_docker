# OpenCode Configuration Insights

## Current baseline
- Date: 2026-02-07
- OpenCode version: `1.1.53`
- Default unified image for scripts: `opencode-python:latest`

## Key findings
- `opencode-web-pdf_ocr_v3` was started from `ghcr.io/anomalyco/opencode:latest`, not from the custom image.
- In that runtime, `git` and `python3` were missing (`rg` was present).
- `/workspace` mount was valid and files were visible from shell/agent.
- Container port was bound to loopback (`127.0.0.1:7777`), so external IP access was blocked.
- Project `/root/dev/pdf_ocr_v3` had no `.git` directory.
- `bun-pty` in web mode can fail on Alpine with `ERR_DLOPEN_FAILED` if glibc loader is missing.

## Why side panels can be empty while shell sees files
- UI-side features often depend on git/project indexing context.
- If `git` is missing in container, right-side file panels may fail.
- If project is not a git repo (`.git` missing), file-context panels may be partially broken.
- Browser-side stale session/cache can preserve broken panel state.

## Applied configuration decisions
- Unified both launch scripts to use one image variable:
  - `OPENCODE_IMAGE="${OPENCODE_IMAGE:-opencode-python:latest}"`
- Updated both scripts to run container from `"$OPENCODE_IMAGE"`.
- `opencode-web` runs with `--hostname 0.0.0.0` and configurable port via `OPENCODE_SERVER_PORT`.
- Added Alpine compatibility packages to custom image:
  - `gcompat`
  - `libc6-compat`
  This provides `/lib/ld-linux-x86-64.so.2` required by `bun-pty`.

## Incident note: bun-pty loader failure
- Symptom in logs:
  - `Failed to open library ...`
  - `Error loading shared library ld-linux-x86-64.so.2`
  - `code: "ERR_DLOPEN_FAILED"`
- Root cause:
  - Alpine runtime lacked glibc loader required by native PTY library.
- Resolution:
  - Rebuild `opencode-python:latest` with `gcompat` and `libc6-compat`.
  - Restart `opencode-web` from updated image.
- Result:
  - Loader error disappeared from container logs.

## Recommended run pattern
- Web:
  - `./opencode-web -d`
- CLI:
  - `./opencode`
- Optional explicit image override:
  - `OPENCODE_IMAGE=ghcr.io/anomalyco/opencode:latest ./opencode-web -d`

## External access checklist
- Verify container publish is not loopback-only:
  - Expected: `0.0.0.0:7777->7777/tcp`
  - Not expected for external access: `127.0.0.1:7777->7777/tcp`
- Verify host firewall/security group allows TCP `7777`.

## Sidebar troubleshooting checklist
1. Ensure runtime has `git` (`docker exec <ctr> sh -lc 'command -v git'`).
2. Ensure project is a git repo (`git init` if needed).
3. Restart web container.
4. Clear browser site data for the web host and hard-reload.
5. Check container logs for repeated server errors.
