# USB role ownership: implementation requirements

Status: source-backed architecture; not implemented or device-validated.

## User requirement

During brokered or full-control sessions, CrossFaded controls software data-role requests. Android framework/HAL policy must not independently override that session. Charging and electrical safety remain operational.

## Verified production-line source

- https://android.googlesource.com/kernel/devices/google/shusky/+/refs/heads/android-gs-shusky-6.1-android16/dts/zuma-shusky-typec.dtsi
- https://android.googlesource.com/kernel/devices/google/zuma/+/refs/heads/android-gs-shusky-6.1-android16/dts/zuma-typec.dtsi
- https://android.googlesource.com/kernel/devices/google/zuma/+/refs/heads/android-gs-shusky-6.1-android16/dts/max777x9-tcpc.dtsi

Shusky includes the shared Zuma Type-C configuration, extends max77759tcpc, declares ovp-present and assigns the SBU mux GPIO. Shared configuration defines dual data and power roles, sink preference, usb-role-switch, charging power-supply references and DisplayPort SVID 0xff01.

The source PDO is 5V/900mA. Its comment explains the external boost limitation. Sink PDOs include 5V/3A, 9V/2.2A and PPS 5–11V/3A. These are declarations in this branch, not measured CP3A power guarantees. Preserve them until matching firmware/DT evidence warrants changes.

The DisplayPort declaration supports investigating the existing Alt Mode path; it does not alone prove end-to-end firmware/framework display operation.

## Proposed ownership contract (engineering inference)

Implement a privileged control service with explicit session ownership. Track data-role policy separately from power-role negotiation and protection.

- Stock mode: existing Android policy owns requests.
- Brokered session: the service authorizes and serializes requested transitions.
- Full-control session: an owner-approved app can request the supported data roles through the service.
- Physical detach, fault protection and mandatory protocol recovery invalidate incompatible requests.
- On process death or service restart, reconcile actual connector state before restoring stock policy. Never replay a stale role command.

Exact arbitration belongs at every relevant HAL/sysfs request path, not merely at the app UI. Keep notifications available to Android. A kernel alone cannot guarantee this ownership if stock userspace retains a competing write path.

## Implementation gates

1. Trace max77759 role callbacks, DWC3 role provider, Android USB HAL writes, init and SELinux domains in the exact target.
2. Enumerate competing role, gadget-bind and USB-data-enable paths.
3. Design narrow service permissions and a recoverable lease protocol.
4. Unit-test session acquisition, revocation, competing requests and crash recovery in CI.
5. Build the service and required policy alongside the kernel profile.
6. Physical validation remains separately authorized: PD charging through compatible hubs, host+sink combinations, detach, resume, HAL restart and faults.

Charging while hosting peripherals depends on the hub/cable/partner supporting the necessary power and data roles. Software cannot promise charging from every attached accessory.
