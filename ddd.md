好的，当然可以。

这里是一份为您精心编写的、从零开始在全新的 Debian/Ubuntu 服务器上部署并运行您这个 Flask + Selenium 项目的完整流程指南。我已经将所有我们在调试过程中遇到的“坑”和最终的解决方案都整合了进去。

请将以下内容保存为一个 `.md` 文件（例如 `deployment_guide.md`），方便您查阅和使用。

---

# Flask + Selenium 抖音解析项目部署指南

本指南将引导您从一个全新的、最小化安装的 Debian 或 Ubuntu 服务器开始，一步步完成项目的部署、配置，并最终使用 Gunicorn 和 Systemd 实现稳定运行。

## 部署流程概览

1.  **服务器基础环境准备**: 更新系统，安装 Python、pip 和 venv。
2.  **上传项目文件**: 将您的代码和配置文件上传到服务器。
3.  **安装系统级依赖**: 安装 Google Chrome 浏览器及运行所需的所有库。
4.  **配置 ChromeDriver**: 手动下载并配置与 Chrome 版本匹配的 ChromeDriver。
5.  **创建并配置虚拟环境**: 隔离项目依赖，安装 `requirements.txt` 中的 Python 包。
6.  **测试运行**: 直接运行 `app.py` 验证所有配置是否正确。
7.  **生产环境部署**: 使用 Gunicorn + Systemd 实现应用的稳定、后台及开机自启动运行。

---

## 第一步：服务器基础环境准备

首先，通过 SSH 登录到您的服务器。

### 1.1 更新系统并安装基础工具

这是一个好习惯，确保所有软件包都是最新的，并安装一些常用工具。

```bash
sudo apt-get update
sudo apt-get upgrade -y
sudo apt-get install -y python3 python3-pip python3-venv git unzip wget
```

### 1.2 验证 Python 和 Pip

检查 Python 和 Pip 是否安装成功。

```bash
python3 --version
pip3 --version
```
您应该能看到它们的版本号。

---

## 第二步：上传项目文件

### 2.1 创建项目目录

我们将在 `root` 用户的主目录下创建一个项目文件夹。

```bash
# 回到主目录
cd ~
# 创建项目文件夹
mkdir ddd
cd ddd
```

### 2.2 上传文件

您可以通过两种方式将文件上传到刚刚创建的 `/root/ddd` 目录：

*   **方式一 (推荐): 使用 Git**
    如果您的代码在 GitHub/Gitee 等仓库，直接克隆。
    ```bash
    git clone <your_repository_url> .
    ```
    *(注意后面的 `.` 表示克隆到当前目录)*

*   **方式二: 使用 SCP 或 SFTP**
    使用 FileZilla, WinSCP 等工具，将您本地的 `app.py`, `requirements.txt`, `templates/` 目录等文件，上传到服务器的 `/root/ddd` 目录。

---

## 第三步：安装系统级依赖 (关键步骤)

这一步是为了确保 Selenium 可以成功驱动无头 Chrome 浏览器。

### 3.1 安装 Google Chrome 浏览器

```bash
# 下载 Chrome 安装包
wget https://dl.google.com/linux/direct/google-chrome-stable_current_amd64.deb

# 使用 apt 安装，它会自动处理部分依赖
sudo apt install ./google-chrome-stable_current_amd64.deb -y

# 清理安装包
rm google-chrome-stable_current_amd64.deb
```

### 3.2 安装 Chrome 运行所需的全部共享库

这是解决“浏览器启动卡住”问题的核心。

```bash
sudo apt-get install -y \
    libglib2.0-0 \
    libnss3 \
    libgconf-2-4 \
    libfontconfig1 \
    libx11-6 \
    libx11-xcb1 \
    libxcb1 \
    libxcomposite1 \
    libxcursor1 \
    libxdamage1 \
    libxext6 \
    libxfixes3 \
    libxi6 \
    libxrandr2 \
    libxrender1 \
    libxss1 \
    libxtst6 \
    libasound2 \
    libatk-bridge2.0-0 \
    libatk1.0-0 \
    libcairo2 \
    libcups2 \
    libdbus-1-3 \
    libgbm1 \
    libgtk-3-0 \
    libpango-1.0-0 \
    --no-install-recommends
```

---

## 第四步：手动配置 ChromeDriver (关键步骤)

由于 Selenium 的自动管理功能在服务器上可能不稳定，我们采用最可靠的手动配置方法。

### 4.1 检查已安装的 Chrome 版本

```bash
google-chrome --version
```
您会得到一个版本号，例如 `Google Chrome 125.0.6422.112`。**记下这个版本号，特别是主版本号 `125`**。

### 4.2 下载对应的 ChromeDriver

1.  访问官方的 **Chrome for Testing** 下载仪表盘：
    [https://googlechromelabs.github.io/chrome-for-testing/](https://googlechromelabs.github.io/chrome-for-testing/)

2.  在页面上找到与您的 Chrome 版本最匹配的 **Stable (稳定版)** 条目。

3.  在对应的条目中，找到 `chromedriver` -> `linux64`，右键点击并复制其链接地址。

4.  回到服务器终端，使用 `wget` 下载，并解压。
    ```bash
    # !!! 下面的链接仅为示例，请务必替换为您复制的真实链接 !!!
    wget https://storage.googleapis.com/chrome-for-testing-public/125.0.6422.78/linux64/chromedriver-linux64.zip

    # 解压
    unzip chromedriver-linux64.zip

    # 清理 zip 文件
    rm chromedriver-linux64.zip
    ```
    操作完成后，您的 `/root/ddd` 目录下应该会有一个名为 `chromedriver-linux64` 的文件夹。

---

## 第五步：创建并配置 Python 虚拟环境

### 5.1 创建虚拟环境

在项目目录 (`/root/ddd`) 中执行：

```bash
python3 -m venv venv
```

### 5.2 激活虚拟环境

```bash
source venv/bin/activate
```
成功后，您的命令行提示符前会出现 `(venv)`。

### 5.3 安装 Python 依赖包

```bash
# 确保您已激活 venv 环境
pip install -r requirements.txt
```
这会自动安装 Flask, Selenium, requests 等所有必要的 Python 库。

---

## 第六步：测试运行

在正式部署前，先用简单方式运行一下，确保所有配置都已生效。

```bash
# 确保您已激活 venv 环境
python3 app.py
```
如果一切顺利，您会看到 Flask 的启动信息。现在，打开您的本地浏览器，访问 `http://<你的服务器IP地址>:5002`，尝试解析一个链接。

同时观察服务器终端的日志输出，如果能看到 `[任务成功]` 的日志，并且前端正常显示结果，说明所有配置都已成功！

按 `Ctrl + C` 停止测试运行。

---

## 第七步：生产环境部署 (Gunicorn + Systemd)

直接用 `python3 app.py` 运行应用，当您关闭 SSH 连接后程序就会中止。我们需要一个更健壮的方式。

### 7.1 安装 Gunicorn

Gunicorn 是一个专业的 WSGI服务器，用于运行 Python Web 应用。

```bash
# 确保您已激活 venv 环境
pip install gunicorn
```

### 7.2 创建 Systemd 服务文件

Systemd 是现代 Linux 系统的标准服务管理器，它可以管理应用的启动、停止、重启和开机自启。

创建一个新的服务文件：
```bash
sudo nano /etc/systemd/system/douyin_parser.service
```

将以下内容**完整地**粘贴到文件中。

```ini
[Unit]
Description=Gunicorn instance to serve Douyin Parser App
After=network.target

[Service]
# 使用 root 用户运行，与我们当前设置一致
User=root
# 您也可以指定一个非 root 用户
Group=www-data

# 设置工作目录为您的项目目录
WorkingDirectory=/root/ddd

# 启动命令的核心
# 指向 venv 中的 gunicorn，并告诉它运行 app.py 中的 app 实例
# -w 4 表示启动4个工作进程，可以根据您服务器CPU核心数调整
# -b 0.0.0.0:5002 监听在5002端口
ExecStart=/root/ddd/venv/bin/gunicorn --workers 4 --bind 0.0.0.0:5002 app:app

# 如果服务失败，自动重启
Restart=always

[Install]
WantedBy=multi-user.target
```

保存并退出 (`Ctrl + X` -> `Y` -> `Enter`)。

### 7.3 管理服务

现在，您可以使用 `systemctl` 命令来控制您的应用了。

```bash
# 重新加载 systemd 配置，使其识别新创建的服务
sudo systemctl daemon-reload

# 启动您的应用服务
sudo systemctl start douyin_parser

# 设置服务开机自启动
sudo systemctl enable douyin_parser

# 查看服务运行状态
sudo systemctl status douyin_parser
```

如果 `status` 命令的输出显示 `active (running)`，并且是绿色的，那么恭喜您，您的项目已经成功部署并稳定运行了！

### 7.4 查看应用日志

如果服务启动失败或运行出错，可以使用以下命令查看详细日志：

```bash
sudo journalctl -u douyin_parser -f
```

现在，您的应用已经在后台稳定运行，并且会在服务器重启后自动启动。部署完成！
