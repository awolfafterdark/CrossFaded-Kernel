# External USB Wi-Fi source evidence

## Verified source findings

Upstream Linux drivers/net/wireless/mediatek/mt76/mt7925/usb.c was inspected directly through GitHub. Observed blob SHA: f97f787b2198b1272b1db5a292ba0230624ed80d. This is a file blob, not a pinned repository commit.

Source: https://github.com/torvalds/linux/blob/master/drivers/net/wireless/mediatek/mt76/mt7925/usb.c

The USB table explicitly identifies Netgear A9000 as 0846:9072 and A8500 as 0846:9050. It also contains MediaTek 0e8d:7925 and 0e8d:6639. The implementation registers a usb_driver, uses MT76_BUS_USB and USB bulk transport, and has suspend, resume and disconnect handlers. This establishes genuine USB support rather than inferring it from PCI code.

Firmware is declared through MT7925_FIRMWARE_WM and MT7925_ROM_PATCH. Resolve these macros in the selected pinned revision before packaging firmware.

## Realtek alternative

Sources:
- https://github.com/morrownr/rtl8852cu-20251113/blob/main/README.md (observed blob 1e8289b7434c31d71e2b3f77aefd4207efa74151)
- https://github.com/morrownr/rtl8852cu-20251113/blob/main/supported-device-IDs (observed blob a794766bbd682fd62d17dfa29a92e90aa8d71f4b)

The maintainer explicitly states monitor mode is unsupported. The advertised kernel range includes 6.1, but compiler tests listed are GCC; this does not prove Android Clang/Kleaf compatibility.

Listed IDs: 0bda:c832, 0bda:c85a, 0bda:c85d, 0db0:991d, 3574:6251, 35b2:0502, 35bc:0101 and 35bc:0102. The named TXE5400UH must still be matched by actual hardware revision and USB ID. Product names alone do not establish RTL8832CU versus RTL8852CU.

## Integration decision

A9000 is a credible upstream USB-driver backport candidate. No 6.1 build compatibility, monitor-mode functionality, injection behavior or physical-device success is claimed by this source inspection.

Before selecting a patch:
1. Pin the driver repository commit and firmware revision.
2. Resolve mt792x, mt76, cfg80211 and mac80211 dependency closure against the locked Pixel source.
3. Check KMI exports and symbol namespaces; do not disable ABI checks to obtain a passing build.
4. Compile the smallest compatible driver/module set.
5. Validate enumeration, firmware load, managed networking and suspend/resume separately.
6. Track monitor capability independently from managed mode; physical testing requires separate authorization.

The Realtek vendor implementation cannot satisfy the requested monitor capability. Keep the maintained rtw89 alternative under investigation, with its backport cost explicit.

## Build baseline finding

Google's shusky build_shusky.sh uses //private/devices/google/shusky:zuma_shusky_dist with --config=stamp and --config=shusky. BUILD_AOSP_KERNEL=1 is deprecated; the script directs users to --kernel_package=@//aosp.

Source: https://android.googlesource.com/kernel/devices/google/shusky/+/refs/heads/android-gs-shusky-6.1-android16/build_shusky.sh

CrossFaded's baseline workflow uses the supported argument. This selects source compilation; it does not establish that the branch matches CP3A.261005.005.
