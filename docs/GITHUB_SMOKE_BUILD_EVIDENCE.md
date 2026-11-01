# GitHub Actions compile-smoke evidence

## Decision

Use an Android Common Kernel (ACK) `common-android14-6.1` aarch64 Kleaf distribution as the first GitHub Actions compile smoke test. It is off-device and not a flashable `husky` package.

## Official lane

- AOSP lists `common-android14-6.1` as Kleaf-supported and says `build/build.sh` is unsupported for Android 14 common kernels. [Kernel branches and build systems](https://source.android.com/docs/setup/reference/bazel-support)
- AOSP specifies `repo init -u https://android.googlesource.com/kernel/manifest -b BRANCH`, then `repo sync`, for source, toolchain and build scripts. [Build kernels](https://source.android.com/docs/setup/build/building-kernels)
- The documented aarch64 invocation is `tools/bazel run //common:kernel_aarch64_dist -- --destdir="$DIST_DIR"`. It emits the image, modules and supporting artifacts. [Build kernels](https://source.android.com/docs/setup/build/building-kernels)

## Acceptance evidence

1. Resolved `manifest.xml` from the successful run.
2. `Image`, artifact inventory and SHA-256 file.
3. Runner/tool output and kernel common revision.
4. No deployment command, signing key or phone connection.

A green smoke build proves the hermetic Kleaf lane, not CP3A binary compatibility. The later `husky` build requires CP3A-correlated shusky and GKI manifests plus KMI/ABI/vendor-module gates.
