## 目录 [自用命令，收集于网上各位大佬的教程]
[3X-UI安装](#3X-UI安装)</br>
[服务器测速脚本](#服务器测速脚本)</br>
[X-UI 安装脚本](#X-UI安装脚本)</br>
[Docker安装脚本](#Docker安装脚本)</br>
[巨魔用户屏蔽系统OTA](#巨魔用户屏蔽系统OTA)</br>




## 3X-UI安装<a name="3X-UI安装"></a>
3X-UI安装 <a href="https://github.com/MHSanaei/3x-ui">Github源码</a>
```bash
   bash <(curl -Ls https://raw.githubusercontent.com/mhsanaei/3x-ui/master/install.sh)
```


## 服务器测速脚本<a name="服务器测速脚本"></a>

官网：bench.sh（秋水逸冰大佬）
使用以下命令来查看Linux系统信息，测试网络带宽及硬盘读写速率
```bash
   wget -qO- bench.sh | bash
```
或者
```bash
   curl -Lso- bench.sh | bash
```
国内三网测速脚本
```bash
   bash <(curl -Lso- https://raw.githubusercontent.com/BlueSkyXN/SpeedTestCN/main/superspeed.sh)
```
三网路由回程
```bash
   curl https://raw.githubusercontent.com/zhucaidan/mtr_trace/main/mtr_trace.sh|bash
```
<a href="http://Ping.pe">搬瓦工丢包测试Ping.pe</a>

## X-UI 安装脚本<a name="X-UI安装脚本"></a>
X-UI 安装脚本
```bash
   bash <(curl -Ls https://raw.githubusercontent.com/vaxilu/x-ui/master/install.sh)
```

## Docker安装脚本<a name="Docker安装脚本"></a>
Docker安装脚本
```bash
   bash <(curl -sSL https://gitee.com/SuperManito/LinuxMirrors/raw/main/DockerInstallation.sh)
```

## 巨魔用户屏蔽系统OTA<a name="巨魔用户屏蔽系统OTA"></a>
巨魔用户屏蔽系统OTA，将下面命令复制到剪切板，然后使用 Filza 找到 /usr/bin/vm_stat 点击运行，然后粘贴下面命令并回车运行
```bash
   killall -9 softwareupdateservicesd & killall -9 softwareupdated & killall -9 com.apple.MobileSoftwareUpdate.CleanupPreparePathService & killall -9 Preferences & chflags -R noschg,noschange,nosimmutable '/var/MobileSoftwareUpdate/MobileAsset/' & mkdir -p '/var/MobileSoftwareUpdate/MobileAsset/AssetsV2/' && rm -rf '/var/MobileSoftwareUpdate/MobileAsset/AssetsV2/' && mkdir -p '/var/MobileSoftwareUpdate/MobileAsset/AssetsV2/' && chmod -R 0777 '/var/MobileSoftwareUpdate/MobileAsset/AssetsV2/' && chown -R mobile:mobile '/var/MobileSoftwareUpdate/MobileAsset/AssetsV2/' && chflags schg,schange,simmutable '/var/MobileSoftwareUpdate/MobileAsset/AssetsV2/'
```
后续重新启用请在 Filza 运行下面的命令
```bash
   chflags -R noschg,noschange,nosimmutable '/var/MobileSoftwareUpdate/MobileAsset/'
```
