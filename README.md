# build_scripts

Build scripts for the third-party **dependency libraries** ("deplibs") that
[CueMol2](https://github.com/CueMol/cuemol2) links against. GitHub Actions builds
each library from source on macOS, Linux, and Windows and publishes the results
as per-platform release tarballs.

> This repository builds **only the dependency libraries**. CueMol2 itself is
> built from the [`cuemol2`](https://github.com/CueMol/cuemol2) repository, which
> downloads the tarballs released here.

## Dependency libraries

| Library | Version | Build | Notes |
| --- | --- | --- | --- |
| Boost   | 1.84.0  | shared | `date_time`, `filesystem`, `iostreams`, `system`, `thread`, `chrono`, `timer`, `program_options` |
| TBB     | 2023.0.0 | static | oneTBB; static (upstream-discouraged scheduler-duplication caveat accepted) |
| Embree  | 4.4.1   | static | `EMBREE_STATIC_LIB=ON`, TBB tasking; minimal ISA only — SSE2 (x86) / NEON (arm64) |
| OIDN    | 2.5.0   | static | `OIDN_STATIC_LIB=ON`, CPU-only (GPU devices OFF), TBB tasking, default ISA; ISPC is a build-time-only dep (not bundled) |
| CGAL    | 6.1     | static | GMP disabled, no Qt5 / ImageIO |
| GLEW    | 2.2.0   | static | POSIX from source, Windows prebuilt |
| lcms2   | 2.17    | static | |
| FFTW    | 3.3.10  | static | single precision (`--enable-float`) |
| LZMA (xz) | 5.2.12 | static | Windows only |

All versions are defined centrally in [`deplibs.env`](deplibs.env). Each build
script sources it, and the file is bundled into every tarball as
`target/deplibs.env` so downstream builds can read the exact versions.

## Repository layout

```
.github/workflows/build.yml   CI: build on main/PR/tag, publish Release on tag
build_deplibs_posix/          Composite GitHub Action — deplibs for macOS / Linux
build_deplibs_windows/        Composite GitHub Action — deplibs for Windows
deplibs.env                   Centralized dependency-library versions
Taskfile.yml                  Release automation (go-task): bump + tag + push
```

## Continuous integration

`.github/workflows/build.yml` builds the deplibs bundle across a platform matrix
on pushes to `main`, on pull requests, and on `vX.Y.Z` tags (tags also publish a
Release). Each job uploads its result as a workflow artifact:

| Job | Runner | Artifact |
| --- | --- | --- |
| `build_mac_arm64` | `macos-15`        | `deplibs_mac_arm64` |
| `build_mac_x64`   | `macos-15-intel`  | `deplibs_mac_x64` |
| `build_linux_x64` | `ubuntu-22.04`    | `deplibs_linux_x64` |
| `build_win_x64`   | `windows-2022`    | `deplibs_windows_x64` |

The macOS/Linux jobs use the `build_deplibs_posix` composite action and the
Windows job uses `build_deplibs_windows`. Each produces a
`deplibs_<os>_<arch>.tar.bz2` tarball whose contents are the installed libraries
under `target/`.

## Building deplibs locally

### macOS / Linux

The composite action runs the per-library scripts in order
(boost → tbb → embree → oidn → cgal → glew → lcms2 → fftw3). Each script takes the
same arguments:

```sh
bash build_deplibs_posix/build_boost.sh <basedir> <os> <arch>
```

- `<basedir>` — install root; each library installs into `<basedir>/<name>-<ver>`
  (e.g. `<basedir>/boost_1_84_0`, `<basedir>/CGAL-6.1`).
- `<os>` — `macOS` or `Linux` (selects compiler / `-fPIC` flags).
- `<arch>` — passed through for naming (e.g. `X64`, `ARM64`).

The CMake-based libraries (TBB, Embree, OIDN, CGAL) build with the **Ninja**
generator, so `ninja` must be on `PATH`.

Prerequisites: `automake` + `ninja` on macOS; `libgl-dev libglu1-mesa-dev` +
`ninja-build` on Linux (see the CI `Install prerequisites` steps).

### Windows

See [`build_deplibs_windows/README.md`](build_deplibs_windows/README.md). In an
Administrator shell with `wget`/`unzip`/`7z` available, run each `.bat` with the
same `<deplibs_dir> Windows X64` arguments, e.g.:

```bat
build_deplibs_windows\build_boost.bat <deplibs_dir> Windows X64
```

## Releases

Releases are cut with [go-task](https://taskfile.dev) from the `main` branch.
Pushing a `vX.Y.Z` tag triggers the workflow, which builds all four platform
tarballs and publishes a GitHub Release with auto-generated notes.

```sh
task current                    # show the latest release tag
task release:dry-run BUMP=patch # preview the next version (no tag/push)
task release:patch              # bump patch, create + push an annotated tag
task release:minor              # bump minor
task release:major              # bump major
```

The version is derived from the latest git tag (`git describe`) — no manual
editing. `task release:*` refuses to run unless the working tree is clean, you
are on `main`, and `main` is in sync with `origin`.

Once the tag is pushed, GitHub Actions builds `deplibs_<os>_<arch>.tar.bz2` on
each platform, creates the Release via `softprops/action-gh-release`, attaches
all `*.tar.bz2` files, and generates the release notes automatically — no GitHub
web-UI steps required.
