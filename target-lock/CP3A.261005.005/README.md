# CP3A.261005.005 target lock

## Observed baseline — 2026-11-01

| Fact | Observed value |
|---|---|
| Product | `husky` |
| Model | Pixel 8 Pro |
| Android build | `CP3A.261005.005` |
| Android release | `17` |
| Fingerprint | `google/husky/husky:17/CP3A.261005.005/16271449:user/release-keys` |
| Running kernel | `6.1.162-android14-11-g9dd05ae3a1de-ab16261587` |
| Active slot | `_b` |
| Verified boot | `green` |
| Bootloader | locked |
| Dynamic partitions | true |

This is read-only evidence, not a signal to flash. `/dev/block/by-name` is not exposed to the unprivileged Termalin session.

## Required before a device-specific artifact

- official factory/OTA URL and checksums;
- exact shusky manifest and component revisions;
- GKI release tag / ABI-KMI report;
- `vendor_kernel_boot`, `dtbo`, module and partition ownership evidence;
- approved recovery/rollback plan;
- separate authorization for any device deployment.
