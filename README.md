## Openwrt sysupgrade upgrade process - loop test

- Random waiting time added, between each upgrade restart and the next upgrade;
- Firmware automatically uploads and verifies MD5;

## 使用说明
1. 下载固件, 放同级目录,如: MS1200S.xxxx.v1.0
2. 计算固件md5, md5sum MS1200S.xxxx.v1.0 > md5sum.txt
3. ./sysupgrade-stable-test.sh <MS1200S.xxxx.v1.0> <设备IP> <密码> <默认初始等待间隔时间(随机基数)>


```bash
sysupgrade-stable-test.sh <MS1200S.202403101407-v1.0> <192.168.10.114> <60>

```

