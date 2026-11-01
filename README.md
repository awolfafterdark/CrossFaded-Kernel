# CrossFaded Kernel — Zooted

Original, evidence-driven custom-kernel project for Google Pixel 8 Pro (`husky`) and Pixel 8 (`shiba`).

## Target lock

- Primary firmware: Android 17 `CP3A.261005.005`
- Verified baseline handset: Pixel 8 Pro / `husky`
- Running kernel: `6.1.162-android14-11`
- Production source lane: `android-gs-shusky-6.1-android16` plus `android14-6.1` GKI
- Status: GitHub compile-smoke and source-lock phase

## Safety model

The phone is used only to collect target facts. GitHub Actions performs source and compile work. No workflow or script flashes, unlocks, reboots, or alters the phone.

See [target lock](target-lock/CP3A.261005.005/README.md) and [build policy](docs/BUILD_POLICY.md).