## 目录 [自用命令，收集于网上各位大佬的教程]

[3X-UI安装](#3X-UI安装)</br>
[HY2安装](#HY2安装)</br>
[SNELL安装](#SNELL安装)</br>
[SSH密钥配置](#SSH密钥配置)</br>
[iptables防火墙配置](#iptables防火墙配置)</br>
[iptables端口转发](#iptables端口转发)</br>
[nezhaV1禁止webssh](#nezhaV1禁止webssh)</br>
[服务器测速脚本](#服务器测速脚本)</br>
[路由回程测试](#路由回程测试)</br>
[IP质量检测](#IP质量检测)</br>
[流媒体检测](#流媒体检测)</br>

---

## 3X-UI安装<a name="3X-UI安装"></a>
3X-UI安装 <a href="https://github.com/MHSanaei/3x-ui">Github源码</a>
```bash
bash <(curl -Ls https://raw.githubusercontent.com/mhsanaei/3x-ui/master/install.sh)
```

## HY2安装<a name="HY2安装"></a>
HY2安装 
```bash
wget -P /root -N --no-check-certificate "https://raw.githubusercontent.com/mack-a/v2ray-agent/master/install.sh" && chmod 700 /root/install.sh && /root/install.sh
```

## SNELL安装<a name="SNELL安装"></a>
SNELL安装
```bash
wget -O snell.sh --no-check-certificate https://git.io/Snell.sh && chmod +x snell.sh && ./snell.sh
```

## SSH密钥配置<a name="SSH密钥配置"></a>
一键ssh改密钥+禁止密码
```bash
bash <(curl -fsSL git.io/key.sh) -og ClaraCora -p 2256 -d
```

## iptables防火墙配置<a name="iptables防火墙配置"></a>
一键禁止其他ip访问42255
```bash
wget -O /root/setup_iptables.sh https://raw.githubusercontent.com/ClaraCora/Backup/refs/heads/main/setup_iptables.sh && chmod +x /root/setup_iptables.sh && /root/setup_iptables.sh
```

## iptables端口转发<a name="iptables端口转发"></a>
iptables端口转发一键脚本
```bash
wget https://raw.githubusercontent.com/ClaraCora/port-forward/main/port-forward.sh && chmod +x port-forward.sh && sudo ./port-forward.sh
```
或使用curl
```bash
curl -O https://raw.githubusercontent.com/ClaraCora/port-forward/main/port-forward.sh && chmod +x port-forward.sh && sudo ./port-forward.sh
```

## nezhaV1禁止webssh<a name="nezhaV1禁止webssh"></a>
```bash
sed -i 's/disable_command_execute: false/disable_command_execute: true/' /opt/nezha/agent/config.yml && systemctl restart nezha-agent
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

## 路由回程测试<a name="路由回程测试"></a>
三网路由回程
```bash
curl https://raw.githubusercontent.com/zhanghanyun/backtrace/main/install.sh -sSf | sh
```

nexttrace路由回程测试
```bash
curl nxtrace.org/nt | bash
```

## IP质量检测<a name="IP质量检测"></a>
```bash
bash <(curl -sL IP.Check.Place)
```

<a href="http://Ping.pe">搬瓦工丢包测试Ping.pe</a>

## 流媒体检测<a name="流媒体检测"></a>
流媒体检测
```bash
bash <(curl -L -s media.ispvps.com)
```

流媒体（奈飞&迪斯尼等）一键修改解锁DNS脚本
```bash
wget https://raw.githubusercontent.com/Jimmyzxk/DNS-Alice-Unlock/refs/heads/main/dns-unlock.sh && bash dns-unlock.sh
```
