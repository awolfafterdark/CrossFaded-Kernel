# CrossFaded feature-selection matrix

This is the decision input for Zooted, not a promise that a feature is already
enabled. The production target remains Android 17 CP3A.261005.005 on `husky`
and `shiba`, using Google's `android-gs-shusky-6.1-android16` topology and the
`android14-6.1` KMI family.

## Decision rules

1. Prefer upstream Linux/AOSP or the feature owner's maintained source over a
   donor-kernel copy.
2. Pin every selected source to a reviewable revision.
3. Preserve KMI unless a device-specific module rebuild and ABI evidence make a
   change safe.
4. Treat userspace, firmware, Android init and SELinux as first-class
   dependencies; a kernel compile is never sufficient evidence.
5. When a stable-profile solution is unavailable, retain the feature in an
   opt-in performance, lab or experimental profile rather than silently
   dropping it.

## Base and release engineering

| Requested capability | Named reference | Current/better candidate | Recommendation and gate |
|---|---|---|---|
| Android 17 Pixel 8/Pro base | Google/AOSP shusky | Official Google manifest branch plus resolved GKI release manifest | **Select official source.** No donor base. Match CP3A KMI/release and source manifests before device build. [AOSP Pixel build docs](https://source.android.com/docs/setup/build/building-pixel-kernels) |
| Kleaf/Bazel reproducibility | Tweaker workflow | Official manifest-provided hermetic Kleaf tooling | **Select official manifest sync.** The first ACK smoke build already passed; next gate is shusky manifest resolution. [AOSP kernel build docs](https://source.android.com/docs/setup/build/building-kernels) |
| AnyKernel3/KernelFlasher | stoag AnyKernel3, flasher forks | Standards-compliant AnyKernel3 plus image-format validation; do not depend on a flasher fork | **Unresolved until CP3A partition ownership is locked.** Packaging is a separate artifact profile, never a build side-effect. |
| KMI/ABI/modules/DLKM | GKI donor workflows | AOSP ABI/KMI tooling and matching vendor-module evidence | **Select AOSP KMI gates.** No symbol-list bypass as a stable solution. [Stable KMI](https://source.android.com/docs/core/architecture/kernel/stable-kmi) |

## Performance, scheduler, memory and haptics

| Capability | Named reference | Current/better candidate | Recommendation and gate |
|---|---|---|---|
| Tensor AIO | Sultan | Sultan's maintained Tensor-specific implementation, traced at `drivers/devfreq/tensor_aio.c`, Kconfig and Exynos cpufreq/thermal hooks | **Candidate, performance profile only.** It is more appropriate than generic scheduler tweaks but is tightly coupled to Google SoC code. Compare target shusky ancestry; test idle, thermal, suspend and sustained performance. [source](https://github.com/kerneltoast/android_kernel_google_tensynos) |
| Scheduler changes/CASS | Sultan | Individual upstreamable scheduler fixes plus measurable Tensor-aware changes | **Do not import a scheduler bundle.** Build a commit ledger and accept only isolated changes with frame-time/thermal/battery evidence. |
| Simple LMK | Sultan | Stock Android `lmkd`/PSI/reclaim behavior is the baseline; Sultan Simple LMK is an optional experiment | **Experimental only.** `drivers/android/simple_lmk.c` exists in Sultan, but competing Android memory policy makes it unsuitable as a default. [source](https://github.com/kerneltoast/android_kernel_google_tensynos/tree/16.0.0-sultan/drivers/android) |
| Thermal improvements | Sultan | Target's stock Tensor thermal driver/HAL coordination plus narrowly audited improvements | **Needs per-commit trace.** Never alter thermal policy without HAL-aware stress and charge tests. |
| K.AdAway | CleanSlate | DNS/VPN/userspace filtering is generally more portable; kernel implementation still needs extraction | **Needs source trace.** Select only if exact hook preserves VPN/WireGuard/netfilter behavior. |
| Vibration Booster | CleanSlate | Target vibrator/haptics-driver-aware implementation | **Needs source trace.** Do not infer compatibility from a feature label; validate all stock haptic effects. |

## Root, filesystem and security profile

| Capability | Named reference | Current/better candidate | Recommendation and gate |
|---|---|---|---|
| KernelSU | Tweaker/Wild | Maintained [KernelSU-Next](https://github.com/KernelSU-Next/KernelSU-Next), with current `android14-6.1` LKM releases as a comparison point | **Select KernelSU-Next evaluation first.** Decide inline versus LKM only after CP3A KMI and boot topology are locked; default profile remains root-free. |
| SUSFS/susfs4ksu | Wild | Current KernelSU-Next SUSFS/LKM support rather than a frozen donor patch stack | **Optional experimental profile.** Pin matching manager/kernel/module revisions; no Play Integrity claim. [KernelSU-Next releases](https://github.com/KernelSU-Next/KernelSU-Next/releases) |
| GKI file-I/O bypass | Tweaker | Avoid bypass by preferring proper in-tree/DDK module design or isolated module interfaces | **Not a stable-profile solution.** Source-trace exact need first; any bypass requires a security/KMI exception review. |
| Baseband Guard | polq/Wild | Maintained BBG implementation only after LSM review | **Experimental security profile.** Validate against OTA, radio, block/partition policy and recovery paths. [Wild release evidence](https://github.com/WildKernels/GKI_KernelSU_SUSFS/releases/tag/r8) |
| Filesystem features/NTFS3/exFAT | Tweaker | Upstream in-tree filesystems/configs | **Prefer upstream configs/modules.** Validate Android mount policy and storage regression before enabling. |
| Play Integrity Fix/Next | requested ecosystem | Userspace/root-module concern, not kernel functionality | **Explicitly out of kernel feature claims.** No compatibility or integrity-bypass guarantee. |

## Networking and container profile

| Capability | Named reference | Current/better candidate | Recommendation and gate |
|---|---|---|---|
| WireGuard | Tweaker/Wild | Upstream WireGuard configuration/module | **Select upstream config path** after KMI/module review; userspace VPN validation required. |
| BBRv3 | polq/Wild | Upstream/backport candidate must be identified and reviewed against 6.1 | **Needs source trace.** Treat Wild availability claims as comparison material, not proof of a safe Pixel 6.1 backport. |
| NAT/nftables/IPSet/CAKE/TTL | Tweaker/Wild | Upstream netfilter, qdisc and congestion-control configs | **Layered lab/network profile.** Test stock networking, VPN, tethering and DroidSpaces NAT separately. |
| DroidSpaces | polq/Wild | Maintained [DroidSpaces-OSS](https://github.com/ravindu644/Droidspaces-OSS) and its published kernel-configuration requirements | **Select DroidSpaces-OSS as the userspace reference.** It requires root plus namespaces/cgroups/binderfs/netns/veth/bridge/NAT/overlayfs/SELinux; use a dedicated profile, not a kernel-only claim. |
| NTSync | Wild | Upstream NTSync where compatible with target source | **Needs 6.1 backport and Android regression review.** |

## USB and gadget profile

| Capability | Named reference | Current/better candidate | Recommendation and gate |
|---|---|---|---|
| Host/OTG/DWC3/xHCI/Type-C/PD/hubs | Tweaker/stock | Stock Pixel device topology, with additive upstream drivers only | **Preserve stock first.** Test charging, role-switch, hub power, suspend and every class before modifications. |
| ConfigFS, ECM/NCM/RNDIS, ACM, HID, mass storage, FunctionFS | Tweaker USB Arsenal | In-tree USB gadget ConfigFS functions, plus Android USB HAL/init/SELinux policy | **Select in-tree functions.** Kernel configs alone do not expose a safe gadget; derive userspace/init/policy requirements before profile release. |
| USB Arsenal/composites | Tweaker | Modular, explicit gadget compositions rather than one universal mutable configuration | **Lab profile only.** Validate each composition against stock Android USB behavior. |
| USB-C DisplayPort Alt Mode | XDA reference | Stock firmware/DT/framework capability determination | **Needs platform trace.** A custom kernel alone cannot create missing hardware, DT, PD-controller or framework support. |

## External Wi-Fi profile

| Adapter/requirement | Named reference | Current/better candidate | Recommendation and gate |
|---|---|---|---|
| A9000 / claimed MT7925U | Morrownr mt76/upstream mt76 | Confirm USB ID and USB transport in upstream/newer mt76 before selecting any driver | **Unresolved hardware identity.** Do not use MT7925 PCI support as evidence of USB support; require `lsusb` ID, firmware and USB transport proof. |
| RTL8832CU/RTL8852CU | Morrownr vendor driver | [morrownr/rtw89](https://github.com/morrownr/rtw89) is modern mac80211-oriented but declares Linux 6.6+; [rtl8852cu](https://github.com/morrownr/rtl8852cu-20251113) supports 5.15-6.14 but explicitly lacks monitor mode | **Select after exact USB ID.** For Pixel 6.1, vendor driver may compile but does not satisfy monitor-mode requirement; rtw89 needs a major backport. Keep both as alternatives. |
| Monitor mode/injection | Tweaker/mac80211 patches | Upstream mac80211-capable driver and adapter-specific validation | **Separate acceptance criterion.** Compilation, enumeration and managed mode never prove monitor/injection. Test only authorized lab traffic. |
| Firmware/module packaging | Tweaker | Firmware in correct vendor/system location plus target-KMI-built modules | **No data-overlay shortcut as stable design.** Validate firmware load, SELinux labels and module dependencies. |

## Explicit profiles and integration order

1. **stable:** exact source lock; unmodified shusky build; only proven upstream/config changes.
2. **performance:** Tensor AIO and selected scheduler/thermal work, one change at a time.
3. **network-root:** WireGuard, then KernelSU-Next; SUSFS only as experimental.
4. **lab-usb-wifi:** ConfigFS composites and each external adapter independently.
5. **droidspaces:** kernel capability config plus the required Android userspace/SELinux components.
6. **packaging:** AnyKernel3 and flasher compatibility only after partition and rollback evidence.

Each candidate must produce a source pin, Kconfig/Kleaf integration description,
conflict decision, ABI/KMI result, build artifact and the listed functional test
before it is merged into any release profile.
