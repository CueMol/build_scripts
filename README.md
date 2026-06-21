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
| CGAL    | 6.1     | static | GMP disabled, no Qt5 / ImageIO |
| GLEW    | 2.1.0 (POSIX, from source) / 2.2.0 (Windows, prebuilt) | static | |
| lcms2   | 2.17    | static | |
| FFTW    | 3.3.10  | static | single precision (`--enable-float`) |
| LZMA (xz) | 5.2.12 | static | Windows only |

## Repository layout

```
.github/workflows/build.yml   CI: build deplibs on every platform, release on tag
build_deplibs_posix/          Composite GitHub Action — deplibs for macOS / Linux
build_deplibs_windows/        Composite GitHub Action — deplibs for Windows
```

## Continuous integration

`.github/workflows/build.yml` builds the deplibs bundle on every push across a
platform matrix and uploads each result as a workflow artifact:

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
(boost → cgal → glew → lcms2 → fftw3). Each script takes the same arguments:

```sh
bash build_deplibs_posix/build_boost.sh <basedir> <os> <arch>
```

- `<basedir>` — install root; each library installs into `<basedir>/<name>-<ver>`
  (e.g. `<basedir>/boost_1_84_0`, `<basedir>/CGAL-6.1`).
- `<os>` — `macOS` or `Linux` (selects compiler / `-fPIC` flags).
- `<arch>` — passed through for naming (e.g. `X64`, `ARM64`).

Prerequisites: `automake` on macOS; `libgl-dev libglu1-mesa-dev` on Linux
(see the CI `Install prerequisites` steps).

### Windows

See [`build_deplibs_windows/README.md`](build_deplibs_windows/README.md). In an
Administrator shell with `wget`/`unzip`/`7z` available, run each `.bat` with the
same `<deplibs_dir> Windows X64` arguments, e.g.:

```bat
build_deplibs_windows\build_boost.bat <deplibs_dir> Windows X64
```

## Releases

The `release_build` job collects all platform artifacts and publishes them to a
GitHub Release when the pushed ref is a tag. Release versions are tagged manually
— pushing a `vX.Y.Z` tag triggers the release.
