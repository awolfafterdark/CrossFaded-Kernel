# CrossFaded feature-integration backlog

This is an integration *backlog*, not a claim that these features are already present. CrossFaded remains an Android 17 `husky`/`shiba` project on the Google shusky 6.1 / `android14-6.1` GKI lineage. Every item must be rebased, source-traced, KMI-reviewed and tested independently before it can enter a release profile.

## Policy and ordering

1. Lock the CP3A manifest, GKI release manifest, KMI/ABI and module list.
2. Build an unmodified `husky`/`shiba` distribution reproducibly.
3. Land one isolated feature layer at a time: config check, compile, ABI/KMI check, boot/lab validation and regression test.
4. Keep `stable`, `performance`, `lab` and `experimental` profiles separate. No feature reaches `stable` because it merely compiles.

## Evidence-backed candidates

| Candidate | Verified source evidence | Likely implementation/config surface | Risk / conflict | CrossFaded plan and validation |
|---|---|---|---|---|
| Sultan Tensor AIO | Sultan source contains `drivers/devfreq/tensor_aio.c`, `include/linux/tensor_aio.h`, `CONFIG_ARM_TENSOR_AIO_DEVFREQ` in `drivers/devfreq/Kconfig`, and hooks in Google `exynos-acme`. [source](https://github.com/kerneltoast/android_kernel_google_tensynos/tree/16.0.0-sultan) | `drivers/devfreq/`, Google SoC cpufreq modules; `CONFIG_ARM_TENSOR_AIO_DEVFREQ` depends on `ANDROID_VENDOR_HOOKS` and `SOC_GOOGLE`. | High: directly coupled to Tensor/Exynos cpufreq and thermal behavior. | `patches/performance/tensor-aio/`; first compare commit ancestry and config against target shusky. Validate suspend/resume, thermal throttle, per-cluster clocks, sustained load and idle drain. |
| Sultan Simple LMK | `drivers/android/simple_lmk.c`, `drivers/android/Kconfig` (`CONFIG_ANDROID_SIMPLE_LMK`) and `drivers/android/Makefile` are present in Sultan. [source](https://github.com/kerneltoast/android_kernel_google_tensynos/tree/16.0.0-sultan/drivers/android) | Android memory-reclaim/oom code and `include/linux/oom.h`. | High: can conflict with modern Android userspace lmkd/PSI/MGLRU expectations. | Experimental-only. Establish stock memory-pressure baseline; add no scheduler or LMK change in the same build; validate kill latency, foreground survival, camera/game memory pressure and reclaim stalls. |
| Sultan scheduler and thermal claims | The Sultan branch is a real source donor, but feature labels alone do not identify a safe patch set. Its README is ACK patch-policy text, not a feature contract. [branch](https://github.com/kerneltoast/android_kernel_google_tensynos/tree/16.0.0-sultan) | Commit-by-commit diff against Google shusky, especially `kernel/sched/`, `kernel/cgroup/`, thermal and Google modules. | Very high: conflicts with Google Tensor scheduler/thermal HAL assumptions. | Create a commit ledger before importing anything; first candidate may be a measurable, single scheduler change only. Validate scheduler tracing, frame-time, thermals and battery separately. |
| Tweaker USB Arsenal / ConfigFS / external Wi-Fi / KSU | Tweaker states it syncs `android-gs-shusky-6.1-android16`, uses Bazel, integrates inline KernelSU-Next, mac80211 injection work, Realtek/MT76 modules, ConfigFS/ECM/ACM and AnyKernel3. It documents Android 16 CP1A testing, not CP3A. [README](https://github.com/stoag/shusky-nethunter-builder) | Expected areas: `drivers/usb/gadget/`, `drivers/net/wireless/`, mac80211/cfg80211, out-of-tree module build rules, Kconfig fragments, packaging scripts. | High: target mismatch, vendor DLKM/KMI risk, gadget/USB HAL conflict, security exposure. | Split into `patches/usb/`, `drivers/external/`, `patches/root/`; inspect exact commits and workflow before import. Build modules against target KMI; test host storage/Ethernet/serial, gadget composition and each adapter separately. |
| Tweaker KernelSU-Next / stock init_boot claim | Tweaker explicitly says inline `CONFIG_KSU=y` keeps the `init_boot` ramdisk factory stock. [README](https://github.com/stoag/shusky-nethunter-builder) | KernelSU source/Kconfig and inline kernel hooks; no inference about CP3A package behavior. | High: root hooks/security patches and target boot-image topology need independent proof. | Optional root profile only; use current KernelSU-Next upstream integration guide and target source. Compile/ABI first; never claim or package `init_boot` preservation until CP3A partition evidence is locked. |
| CleanSlate K.AdAway / Vibration Booster | CleanSlate has a shusky branch, but the root README is generic ACK policy; feature locations/configs require source-file/commit extraction. [branch](https://github.com/tbalden/kernel_common/tree/cleanslate-shusky-u) | **Needs code verification**: likely networking/filter hook and vibrator/LED or input interfaces; do not infer file paths from feature names. | Medium/high: ad-blocking can conflict with netfilter/VPN/DNS behavior; vibration can conflict with vendor haptics HAL. | `patches/cleanslate/` investigation branch only. Identify commits/config symbols first, then validate DNS/VPN/WireGuard and all stock haptic patterns. |
| polq1200 DroidSpaces / BBRv3 / Baseband Guard | Requested repository needs branch/commit discovery before source claims; direct README fetch of guessed branch `17` returned 404 in this investigation. | **Needs code verification**: DroidSpaces spans namespaces, binderfs, cgroups, veth/bridge/netfilter/overlayfs/SELinux/userspace; BBRv3 is TCP congestion control; Baseband Guard may touch partition/block policy. | Very high: container SELinux/userspace dependency; BBR backport/version conflict; baseband protection must not alter radio/OTA behavior. | Separate `patches/droidspaces/`, `patches/network/`, `patches/security/`. Start with a capability/config matrix and userspace policy proof; test container networking/iptables-nft/overlay/binderfs before any release profile. |
| Wild GKI KernelSU/SUSFS/WireGuard/DroidSpaces | Wild README advertises KernelSU variants, susfs4ksu, Baseband Guard, WireGuard/BBR, BPF and DroidSpaces, and names upstream/donor projects. [README](https://github.com/WildKernels/GKI_KernelSU_SUSFS) | Generic GKI patch/config workflow and third-party patch bundles. | High: generic GKI compatibility is not device-specific module compatibility; SUSFS/root concealment patches have security, maintenance and policy consequences. | Use as comparison material only. Choose one root implementation and one patch set; never combine overlapping KSU/SUSFS hooks. WireGuard may be a separate audited network option. |

## Cross-cutting validation gates

- **KMI/ABI:** use matching manifest/toolchain; fail on unexplained symbol-list or module-load changes.
- **USB:** host mode, OTG/role switch, hub, storage, Ethernet, serial, audio, Wi-Fi and each gadget composition are separate tests.
- **External Wi-Fi:** compilation, USB enumeration, managed networking, monitor mode and authorized-lab injection are distinct outcomes.
- **Root/SUSFS:** test root lifecycle, module compatibility, SELinux/enforcement and update/rollback independently; no Play Integrity guarantee.
- **DroidSpaces:** container boot, binder/binderfs, cgroup v2, netns/veth/bridge/NAT/nftables, overlayfs and SELinux policy must all pass.
- **Performance/thermal:** use repeatable stock-vs-feature measurements for idle drain, sustained CPU/GPU load, gaming frame time, thermal throttling and memory pressure.

## Primary sources

- [Google Pixel kernel build documentation](https://source.android.com/docs/setup/build/building-pixel-kernels)
- [Android Common Kernel / KMI documentation](https://source.android.com/docs/core/architecture/kernel/android-common)
- [Sultan branch](https://github.com/kerneltoast/android_kernel_google_tensynos/tree/16.0.0-sultan)
- [Tweaker repository](https://github.com/stoag/shusky-nethunter-builder)
- [CleanSlate branch](https://github.com/tbalden/kernel_common/tree/cleanslate-shusky-u)
- [Wild GKI repository](https://github.com/WildKernels/GKI_KernelSU_SUSFS)
