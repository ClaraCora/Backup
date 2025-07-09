好的，这是一个关于如何在 VPS 上安装测速工具、搜索指定地区测速点并进行测速的完整流程指南。本指南将主要介绍两种流行的方法：`Speedtest CLI`（官方命令行工具）和 `YABS`（一个流行的综合性能测试脚本）。

---

# VPS 网络测速完全指南：安装、区域筛选与测速流程

本文档将指导您如何在 Linux VPS (Virtual Private Server) 上安装和使用网络测速工具，特别是如何筛选指定国家或城市的测速节点，以获得更精确的测速结果。

## 目录

1.  [准备工作](#1-准备工作)
2.  [方法一：使用 Speedtest® CLI (官方命令行工具)](#2-方法一使用-speedtest-cli-官方命令行工具)
    *   [2.1 安装 Speedtest CLI](#21-安装-speedtest-cli)
    *   [2.2 基本测速](#22-基本测速)
    *   [2.3 搜索指定地区的测速服务器](#23-搜索指定地区的测速服务器)
    *   [2.4 对指定服务器进行测速](#24-对指定服务器进行测速)
3.  [方法二：使用 YABS (Yet-Another-Bench-Script) 脚本](#3-方法二使用-yabs-yet-another-bench-script-脚本)
    *   [3.1 YABS 简介](#31-yabs-简介)
    *   [3.2 执行 YABS 脚本](#32-执行-yabs-脚本)
    *   [3.3 解读测速结果](#33-解读测速结果)
4.  [总结与对比](#4-总结与对比)

---

## 1. 准备工作

在开始之前，请确保您具备以下条件：

*   一台正在运行的 Linux VPS。
*   通过 SSH 客户端（如 PuTTY, Xshell, Terminus 或系统自带的终端）成功登录到您的 VPS。
*   拥有 `root` 用户权限或一个可以执行 `sudo` 命令的普通用户。

## 2. 方法一：使用 Speedtest® CLI (官方命令行工具)

`Speedtest CLI` 是由 Ookla (Speedtest.net 的母公司) 官方提供的命令行工具。它功能强大，拥有全球最广泛的测速节点网络，非常适合进行精确的、有针对性的测速。

### 2.1 安装 Speedtest CLI

根据您的 VPS 的操作系统，选择对应的安装方式。

**对于 Debian / Ubuntu 系统:**

```bash
# 确保系统已安装 curl 和 gnupg
sudo apt-get update
sudo apt-get install -y curl gnupg

# 添加 Ookla 的 GPG 密钥
curl -s https://packagecloud.io/install/repositories/ookla/speedtest-cli/script.deb.sh | sudo bash

# 安装 speedtest-cli
sudo apt-get install speedtest
```

**对于 CentOS / RHEL / Fedora 系统:**

```bash
# 添加 Ookla 的仓库
curl -s https://packagecloud.io/install/repositories/ookla/speedtest-cli/script.rpm.sh | sudo bash

# 安装 speedtest-cli (使用 dnf 或 yum)
sudo dnf install speedtest
# 或者
sudo yum install speedtest
```

安装完成后，您可以运行 `speedtest --version` 来验证是否安装成功。

### 2.2 基本测速

安装完成后，直接在命令行输入 `speedtest` 即可开始一次标准的测速。它会自动选择一个延迟最低的服务器。

```bash
speedtest
```

首次运行时，它会要求您接受许可协议，输入 `YES` 并回车即可。

测速结果会显示 **Ping (延迟)**, **Jitter (抖动)**, **Download (下载速度)** 和 **Upload (上传速度)**。

```
   Speedtest by Ookla

     Server: China Telecom JiangSu 5G - Nanjing (id = 30125)
        ISP: China Telecom
    Latency:     2.35 ms   (0.12 ms jitter)
   Download:   935.45 Mbps (data used: 1.1 GB)
     Upload:   940.89 Mbps (data used: 1.2 GB)
Packet Loss:     0.0%
 Result URL: https://www.speedtest.net/result/c/xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx
```

### 2.3 搜索指定地区的测速服务器

这是本指南的核心步骤。`speedtest` 命令可以列出所有可用的服务器，我们可以通过结合 `grep` 命令来筛选出我们想要的地区。

**命令格式:**
`speedtest -L | grep "关键词"`

*   `-L` 或 `--list`：表示列出所有可用的服务器列表。
*   `|`：这是管道符，将前一个命令的输出作为后一个命令的输入。
*   `grep "关键词"`：在输入中搜索包含 "关键词" 的行。关键词可以是城市名、国家名或运营商名称。

**示例：搜索位于上海 (Shanghai) 的测速点**

```bash
speedtest -L | grep "Shanghai"
```

输出可能如下所示：
```
 27594) China Mobile (Shanghai, China)
 17424) China Unicom (Shanghai, China)
  3633) China Telecom (Shanghai, China)
 50157) China Telecom 5G (Shanghai, China)
```

输出的第一列数字是 **服务器 ID**，这是我们下一步进行指定测速的关键。

**示例：搜索位于日本东京 (Tokyo) 的测速点**

```bash
speedtest -L | grep "Tokyo"
```

**示例：搜索德国 (Germany) 的测速点**

```bash
speedtest -L | grep "Germany"
```

### 2.4 对指定服务器进行测速

获取到目标服务器的 ID 后，使用 `-s` 参数来指定该服务器进行测速。

**命令格式:**
`speedtest -s <服务器ID>`

**示例：使用上面找到的上海电信节点 (ID: 3633) 进行测速**

```bash
speedtest -s 3633
```

这样，`speedtest` 就会强制连接到 ID 为 `3633` 的服务器进行完整的下载和上传测试，从而得到您的 VPS 到上海电信的网络速度。

## 3. 方法二：使用 YABS (Yet-Another-Bench-Script) 脚本

`YABS` 是一个非常流行的一键式服务器性能测试脚本。它不仅测试网络速度，还包括了磁盘 I/O 和 CPU 性能测试。它的网络测试部分会自动选择全球多个地区的知名节点进行测试，非常适合快速了解 VPS 的综合网络性能。

### 3.1 YABS 简介

*   **优点**：一键执行，无需安装，提供全面的性能报告（CPU, 磁盘, 网络），自动测试全球多地节点。
*   **缺点**：无法像 `Speedtest CLI` 那样自由选择任意测速点，定制化程度较低。

### 3.2 执行 YABS 脚本

只需一行命令即可运行。

```bash
curl -sL yabs.sh | bash
```

或者，如果您想指定测试项目（例如，只测试网络，不测试磁盘I/O），可以添加参数：

```bash
# -i 参数会跳过磁盘性能测试
curl -sL yabs.sh | bash -s -- -i
```

脚本会自动下载并执行，整个过程通常需要几分钟。

### 3.3 解读测速结果

YABS 的报告非常直观。在报告的末尾，您会看到 `Network Speed` 部分，它会列出到不同地区（如美国、欧洲、亚洲）节点的测速结果。

```
 Network Speed
[...]
 Location                        | Send Speed    | Recv Speed    | Ping
---------------------------------|---------------|---------------|-----------
 C*net, Amsterdam, NL            |   90.56 MB/s  |   87.43 MB/s  | 145.2 ms
 Online.net, Paris, FR           |   91.11 MB/s  |   88.92 MB/s  | 150.1 ms
 Clouvider, London, UK           |   92.01 MB/s  |   89.55 MB/s  | 141.5 ms
 Edgenap, Miami, FL, US          |   75.34 MB/s  |   68.21 MB/s  | 210.8 ms
 Softlayer, Dallas, TX, US       |   60.15 MB/s  |   55.78 MB/s  | 180.3 ms
 Clouvider, Los Angeles, CA, US  |   45.88 MB/s  |   42.10 MB/s  | 25.4 ms
 China Telecom, Shanghai, CN     |   10.22 MB/s  |    5.87 MB/s  | 188.9 ms
 China Unicom, Beijing, CN       |   12.50 MB/s  |    8.13 MB/s  | 212.4 ms
 China Mobile, Guangzhou, CN     |    9.78 MB/s  |    4.55 MB/s  | 205.6 ms
```

通过这个列表，您可以快速评估您的 VPS 到全球主要区域，特别是到中国大陆三大运营商（电信、联通、移动）的线路质量。

## 4. 总结与对比

| 特性         | Speedtest CLI                                    | YABS (Yet-Another-Bench-Script)                  |
| :----------- | :----------------------------------------------- | :----------------------------------------------- |
| **用途**     | 精确、有针对性的网络测速                         | 快速、全面的服务器综合性能评估                   |
| **安装**     | 需要手动安装                                     | 无需安装，一键执行                               |
| **灵活性**   | **极高**，可搜索并指定全球任意 Ookla 节点      | **较低**，自动选择预设的多个地区节点           |
| **信息全面性** | 专注于网络速度（Ping, Jitter, Down, Up）         | 包含网络、CPU、内存、磁盘 I/O 等多项指标         |
| **推荐场景** | 验证 VPS 到特定城市或运营商的连接质量。          | 购买新 VPS 后，快速了解其整体性能和全球网络状况。 |

---

根据您的具体需求，选择合适的方法即可。如果您想知道 VPS 到您本地网络的连接速度，使用 `Speedtest CLI` 并选择一个离您最近的测速点是最佳选择。如果您想评估 VPS 的整体性能以决定是否购买或续费，`YABS` 则更加方便快捷。
