# Build policy

## First GitHub build

The first automated build is a compile-only Android Common Kernel `android14-6.1` aarch64 distribution. It proves the compatible GKI build lane and records tool output, source revision, artifact names and hashes.

It is deliberately **not** a flashable Pixel package.

## Device-specific gate

A `husky`/`shiba` device build begins only after the source lock contains the exact Google manifest/revisions, stock artifact checksums, module/KMI evidence and partition ownership evidence for CP3A.261005.005.

The phone supplies facts only. No GitHub workflow has Termalin credentials or a deployment step.
