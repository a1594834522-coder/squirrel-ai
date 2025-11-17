# Repository Guidelines

## Project Structure & Module Organization
`sources/` hosts the Swift app logic, with UI assets under `Assets.xcassets` and shared resources in `resources/`. Vendor engines and data live in `librime/`, `plum/`, and their generated outputs (`lib/`, `bin/`, `data/`). Packaging logic, Sparkle bits, and installer scripts are contained in `package/`, while helper automation sits inside `scripts/` and `action-*.sh`. Keep experimental output inside `build/` only.

## Build, Test, and Development Commands
- `make deps`: compile librime/OpenCC/plum and copy their binaries and YAML into place.
- `make debug` / `make release`: invoke `xcodebuild` for the Squirrel scheme; results land in `build/Build/Products/<Config>/Squirrel.app`.
- `make package`: assemble assets via `package/add_data_files` and emit `package/Squirrel.pkg` (set `DEV_ID="Developer ID Application:…"` to sign).
- `make install-release`: push the release app into `/Library/Input Methods` and re-run `scripts/postinstall`.
- `make clean` or `make clean-deps`: remove DerivedData or fully reset vendor outputs when switching environments.

## Coding Style & Naming Conventions
Swift files use two-space indentation, explicit access control, and descriptive camelCase members/PascalCase types. SwiftLint rules are enforced, so favor local fixes and keep `// swiftlint:disable:next …` scoped to a single statement. Keep ObjC bridging helpers in `BridgingFunctions.swift` prefixed with `Rime`, store localized strings as UTF-8, and mirror existing file names when adding YAML schemas in `data/`.

## Testing Guidelines
No XCTest target exists, so rely on manual validation. After `make debug`, enable the built `Squirrel.app`, type through a candidate cycle, toggle inline preedit, and switch between Tahoe/native themes. Any script or deployment change must be followed by `make install-release` on a clean account plus a check that `bin/rime_deployer` and `bin/rime_dict_manager` are executable. Attach repro steps, screenshots, or relevant `Console.app` snippets to PRs.

## Commit & Pull Request Guidelines
Use short imperative commit summaries similar to `feat(ui): adopt system appearance` or `[Fix] Tahoe panel offset`, and append `(#1234)` when closing an issue. Limit each commit to one logical change and refresh `CHANGELOG.md` when the UX shifts. PRs should list motivation, validation commands (`make release`, manual QA), and screenshots for UI or data changes. Call out whenever vendor data (`data/plum/*`, `data/opencc/*`) or Sparkle submodules were regenerated.

## Release & Configuration Tips
Configure `ARCHS` or `MACOSX_DEPLOYMENT_TARGET` when targeting additional Macs, and export credentials via `DEV_ID` for signing/notarization. Before tagging, run `make package archive` so installers, Sparkle appcasts, and `package/appcast.xml` match the intended CDN URLs.
