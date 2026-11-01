# CP3A.261005.005 source-lock actions

This note locks the evidence required before a CrossFaded device-specific
`husky`/`shiba` artifact is even *considered*. It does not authorize flashing.

## Verified facts

| Claim | Evidence |
|---|---|
| The primary handset is Android 17 `CP3A.261005.005`, Pixel 8 Pro (`husky`), running `6.1.162-android14-11-g9dd05ae3a1de-ab16261587`. | Read-only Termalin collection, 2026-11-01. |
| Google maps Pixel 8/Pixel 8 Pro (`shiba`/`husky`) to `android-gs-shusky-6.1-android16` and the `android14-6.1` GKI generation. | [Build Pixel kernels](https://source.android.com/docs/setup/build/building-pixel-kernels) |
| Android 17 supports the `android14-6.1` GKI generation; a platform release label does not imply a 6.18 migration. | [Android common kernels](https://source.android.com/docs/core/architecture/kernel/android-common) |
| Google lists `6.1.162` on the `android14-6.1-2026-03` release family. | [android14-6.1 release builds](https://source.android.com/docs/core/architecture/kernel/gki-android14-6_1-release-builds) |
| Release artifacts include a pinned `manifest_$BID.xml`, `Image`, `System.map`, `vmlinux`, `vmlinux.symvers`, module metadata and a system-DLKM staging archive. | [android14-6.1 release builds](https://source.android.com/docs/core/architecture/kernel/gki-android14-6_1-release-builds) |
| Pixel 8/8 Pro kernel partition mapping includes `boot`, `dtbo`, `vendor_kernel_boot`, dynamic `vendor_dlkm`, and dynamic `system_dlkm`. | [Build Pixel kernels](https://source.android.com/docs/setup/build/building-pixel-kernels) |
| KMI stability applies only inside the same Android release/LTS family and uses the manifest-supplied hermetic toolchain. | [Maintain a stable KMI](https://source.android.com/docs/core/architecture/kernel/stable-kmi) |

## Exact lock procedure

1. Download the matching `husky` and `shiba` factory/OTA entries from the
   official [Factory Images](https://developers.google.com/android/images) and
   [Full OTA Images](https://developers.google.com/android/ota) pages. Record
   URL, release date, archive SHA-256, build fingerprint, bootloader and radio
   versions. The current research did **not** find an official page row that
   maps `CP3A.261005.005` directly to one published archive; do not infer it.
2. From the Android 14-6.1 releases page, select the release manifest whose
   kernel release and Google build metadata reproduce `6.1.162-android14-11`.
   Download `manifest_$BID.xml`, not merely a moving branch tip.
3. Initialize the GKI checkout from that manifest:

   ```bash
   repo init -u https://android.googlesource.com/kernel/manifest
   mv manifest_$BID.xml .repo/manifests/manifest.xml
   repo init -m manifest.xml
   repo sync -c --no-tags
   repo manifest -r -o resolved-gki-manifest.xml
   ```

   This is Google's documented release-manifest flow:
   [GKI release builds](https://source.android.com/docs/core/architecture/kernel/gki-release-builds).
4. Independently sync `android-gs-shusky-6.1-android16` with the Google kernel
   manifest. Store its fully resolved manifest and every project revision.
   Do not claim it is CP3A-exact until the factory/OTA and device source
   revisions have been correlated.
5. Compare the release `vmlinux.symvers`, KMI ABI reports/symbol lists, module
   lists and the shusky vendor-module build outputs. Treat a new unresolved
   module symbol or a changed protected export as a stop condition.
6. Build compile-only first. The official GKI aarch64 Kleaf target is:

   ```bash
   tools/bazel run //common:kernel_aarch64_dist -- --destdir="$DIST_DIR"
   ```

   Reference: [Build kernels](https://source.android.com/docs/setup/build/building-kernels).

## Required repository evidence

- `target-lock/CP3A.261005.005/factory-husky.json`
- `target-lock/CP3A.261005.005/factory-shiba.json`
- `target-lock/CP3A.261005.005/gki-manifest.xml`
- `target-lock/CP3A.261005.005/shusky-resolved-manifest.xml`
- `target-lock/CP3A.261005.005/gki-artifact-inventory.txt`
- `target-lock/CP3A.261005.005/kmi-abi-comparison.md`
- `target-lock/CP3A.261005.005/partition-ownership.md`
- hashes for every imported source/artifact.

## GitHub work items

1. Issue #1: add a script that fetches only declared official artifact URLs,
   verifies supplied SHA-256 values and emits JSON provenance; never hard-code
   guessed CP3A URLs.
2. Add a `source-lock` workflow that rejects missing manifests, floating refs,
   absent checksums and unreviewed `vendor_kernel_boot`/DLKM ownership.
3. Add KMI/ABI comparison as a required check before any optional feature
   profile can package modules.
4. Keep the `android14-6.1` GKI smoke build separate from the future shusky
   mixed/device build; a successful common-kernel compile is not a compatibility
   claim for CP3A.

## Blocking unknowns

- Exact official factory/OTA row and archive checksum for both CP3A devices.
- Exact CP3A-correlated shusky project revisions and matching GKI release
  manifest/BID.
- Stock `vendor_kernel_boot`, `vendor_dlkm`, `system_dlkm`, DTBO and module
  ownership/contents under the target build.
- Vendor module ABI/KMI compatibility report against the selected GKI release.

Until all four are resolved, CrossFaded may compile and run static validation,
but it must not call an artifact device-compatible or installable.
