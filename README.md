Openwrt sysupgrade upgrade process - loop test

- Random waiting time added, between each upgrade restart and the next upgrade;
- Firmware automatically uploads and verifies MD5;

```bash
sysupgrade-stable-test.sh <MS1200S.202403101407-v1.0> <192.168.10.114> <60>

```
