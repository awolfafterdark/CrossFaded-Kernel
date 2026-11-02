# CrossFaded / Zooted feature-completeness ledger

Every item below is in scope for investigation and a decision. **Planned** does not mean integrated, enabled, or promised for the stable profile.

Status key: `Source-locked`, `Source-traced`, `Needs source trace`, `Needs device validation`, `Not started`.

## 1. Base, compatibility and packaging

| Requirement | Status | Delivery condition |
|---|---|---|
| CP3A.261005.005 Pixel 8 Pro compatibility | Source-locked baseline | Exact shusky + GKI manifests, KMI/ABI and stock-equivalent build |
| Pixel 8 shiba equivalent Android 17 support | Needs source trace | Separate shiba build/config and test evidence |
| Android 17 breadth without breaking CP3A | Planned | Release manifest matrix and profile compatibility policy |
| KMI/ABI/vendor modules/DLKM | Source-traced | ABI check plus module load/dependency review |
| boot/vendor_kernel_boot/dtbo/vendor_dlkm/system_dlkm/init_boot relationships | Source-traced | Partition ownership map; no package until verified |
| AnyKernel3 | Needs source trace | Standards-compliant packaging after partition proof |
| KernelFlasher compatibility | Needs source trace | Image-format/A-B/ramdisk test matrix; no fork lock-in |
| Get My Kernel Format logic | Needs source trace | Validation-only reuse/reimplementation decision |
| GPL/source distribution | Planned | Source, manifests, patches, configs and notices published per release |

## 2. Performance, scheduler, memory and thermal

| Requirement | Status | Delivery condition |
|---|---|---|
| Sultan Capacity Aware Superset Scheduler | Needs source trace | Commit-level diff, Tensor scheduler conflict review, benchmark gate |
| Tensor AIO | Source-traced | Optional device-specific layer; devfreq/cpufreq/thermal regression gate |
| Simple LMK | Source-traced | Modern Android memory-management conflict analysis and pressure test |
| Sultan thermal changes | Needs source trace | Pixel thermal HAL/vendor behavior and sustained-load validation |
| Single-/multi-core, gaming, battery and stability work | Planned | Individual upstream/donor commits, benchmark and battery gates |
| polq latest-LTS candidates | Needs source trace | Backport provenance and KMI/config validation |
| CleanSlate K.AdAway | Needs source trace | Exact files/config/userspace dependency validation |
| CleanSlate Vibration Booster | Needs source trace | Device haptics/driver dependency and safety validation |

## 3. Root, security and networking

| Requirement | Status | Delivery condition |
|---|---|---|
| Inline KernelSU-Next | Source-traced | Pinned upstream revision, optional profile, config/KMI/security review |
| KernelSU LKM comparison | Planned | Explicit inline-versus-LKM decision and image/ramdisk implications |
| SUSFS / susfs4ksu | Source-traced | Pinned patch/module compatibility and security review |
| GKI file-I/O block bypass | Needs source trace | Exact hook assessment; not default and no blind KMI export mutation |
| Play Integrity Fix/Next distinction | Planned | Document as userspace/root-module functionality; no kernel guarantee |
| WireGuard | Planned | Kconfig/module/Android userspace validation |
| BBRv3 | Needs source trace | Backport provenance and TCP regression test |
| Baseband Guard | Needs source trace | LSM/conflict review; partition-protection test |
| nftables/netfilter/IPSet/NAT/TTL/traffic shaping | Planned | Isolated networking config layer and regression suite |

## 4. DroidSpaces

| Requirement | Status | Delivery condition |
|---|---|---|
| namespaces, cgroups, binder/binderfs | Planned | Kconfig + Android compatibility review |
| net namespaces, veth, bridge, routing, NAT/nftables | Planned | Container networking test with Android userspace |
| overlayfs, seccomp, BPF | Planned | Required configuration and policy evidence |
| Android userspace/SELinux/policy | Planned | Userspace package and policy design; not kernel-only |
| polq/Wild patches | Needs source trace | Minimal patch selection, not wholesale donor merge |

## 5. USB, Type-C and gadget subsystem

| Requirement | Status | Delivery condition |
|---|---|---|
| USB host, xHCI, DWC3, OTG/role switching | Planned | Stock topology and hardware regression tests |
| USB-C/Type-C/PD/powered hubs | Planned | Hub/PD/charging/suspend test matrix |
| storage, HID, Ethernet, serial, audio, cameras | Planned | Per-class enumeration/function test |
| ConfigFS, FunctionFS, ECM, NCM, RNDIS, ACM, HID gadget | Source-traced | Config fragment + USB HAL/init/SELinux review |
| USB Arsenal/composite gadgets | Source-traced | Optional lab profile, explicit userspace/init dependencies |
| USB-C DisplayPort Alt Mode/output | Planned | Separate kernel/DT/framework/property feasibility decision |

## 6. External Wi-Fi

| Requirement | Status | Delivery condition |
|---|---|---|
| Netgear A9000 / claimed MT7925U | Planned | Verify exact USB ID/chipset, USB transport, firmware and driver before code |
| upstream mt76 / Morrownr mt76 | Planned | Confirm USB support; do not infer from PCI code |
| MT7925 backports to 6.1 | Planned | KMI/module/performance/stability review |
| TXE5400UH/Axes400 revision/chipset | Planned | Hardware-revision and USB-ID evidence |
| RTL8832CU vs RTL8852CU | Planned | Exact chipset/ID decision before driver choice |
| Morrownr rtl8852cu / rtw89 comparison | Planned | Build/in-tree/DDK decision and firmware integration |
| managed mode | Planned | Enumeration and normal networking test |
| monitor mode | Planned | Explicit capability test |
| authorized-lab injection | Planned | Separate explicit capability test; never inferred from compilation |

## 7. Filesystem and general networking

| Requirement | Status | Delivery condition |
|---|---|---|
| filesystem optimizations | Needs source trace | Individual change inventory and storage regression tests |
| NTFS3/exFAT | Source-traced donor reference | Config/module and Android mount behavior tests |
| generic network optimizations | Needs source trace | Individual patch/config inventory and regression tests |
| wireless injection/mac80211 modifications | Source-traced donor reference | Patch review plus external-adapter test only |

## 8. Release engineering and validation

| Requirement | Status | Delivery condition |
|---|---|---|
| manifest/commit/compiler pinning | In progress | Provenance lockfiles and reproducible build record |
| Kleaf/Bazel cache strategy | Planned | Manifest-hash cache and clean/cold-build comparison |
| stable/debug/development profiles | Planned | Config/patch composition rules and artifact naming |
| module ABI checks | Planned | KMI/ABI CI gate |
| checksums/provenance/SBOM/changelog | Planned | Release workflow implementation |
| A/B, rollback and anti-rollback | Planned | Known-good recovery evidence before any deployment |
| full requested device test matrix | Planned | Test cases tracked by profile and hardware feature |

## Explicit exclusions from the default stable profile

These are not dropped. They require separate optional profiles and extra evidence: KernelSU/SUSFS, GKI bypasses, security-lab USB gadgets, monitor/injection drivers, Baseband Guard, DroidSpaces, BBRv3 backports, aggressive scheduler/thermal/LMK changes, and all packaging/deployment tooling.

## Rule for completion

No row can be marked complete merely because it compiles. Each feature needs: source provenance, patch/config review, dependency and conflict decision, build/KMI evidence, and the relevant physical-device or userspace validation.
