## 目录
[服务器测速脚本](#服务器测速脚本)</br>
[X-UI 安装脚本](#X-UI安装脚本)</br>
[Docker安装脚本](#Docker安装脚本)</br>

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
