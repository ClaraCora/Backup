## 目录 [自用命令，收集于网上各位大佬的教程]
[检测VPS内存是否超售](#检测VPS内存是否超售)</br>
[ServerStatus安装](#ServerStatus安装)</br>
[爱快状态监控套装](#爱快状态监控套装)</br>
[群晖安装哪吒监控](#群晖安装哪吒监控)</br>
[NginxProxyManager反向代理工具](#NginxProxyManager反向代理工具)</br>
[3X-UI安装](#3X-UI安装)</br>
[HY2安装](#HY2安装)</br>
[SNELL安装](#SNELL安装)</br>
[服务器测速脚本](#服务器测速脚本)</br>
[X-UI 安装脚本](#X-UI安装脚本)</br>
[Docker安装脚本](#Docker安装脚本)</br>
[安装运行Nginx容器](#安装运行Nginx容器)</br>
[巨魔用户屏蔽系统OTA](#巨魔用户屏蔽系统OTA)</br>


## 检测VPS内存是否超售<a name="检测VPS内存是否超售"></a>
```bash
curl https://raw.githubusercontent.com/uselibrary/memoryCheck/main/memoryCheck.sh | bash
```
## ServerStatus安装<a name="ServerStatus安装"></a>
ServerStatus安装
```bash
wget https://raw.githubusercontent.com/CokeMine/ServerStatus-Hotaru/master/status.sh && chmod +x status.sh
```
安装客户端
```bash
bash status.sh c
```
服务端管理菜单
```bash
bash status.sh s
```
## 爱快状态监控套装<a name="爱快状态监控套装"></a>
安装iKuai Exporter 
```bash
docker run -d -p 9222:9090 -e IK_URL=http://路由器地址 -e IK_USER=用户 -e IK_PWD=密码 \
  jakes/ikuai-exporter:latest
```
安装Prometheus
```bash
docker run -d -p 9090:9090 --name=prometheus \
 -v  /root/prometheus/conf/prometheus.yml:/etc/prometheus/prometheus.yml  \
prom/prometheus 
```
在 Prometheus 的配置文件 prometheus.yml 中增加如下配置：
```bash
scrape_configs:
  - job_name: 'ikuai_exporter'
    scrape_interval: 2s
    scrape_timeout: 2s
    relabel_configs:
      - source_labels: [__address__]
        target_label: instance
      - target_label: __address__
        replacement: 192.168.0.100:9222  # exporter.
    static_configs:
      - targets:
          - 192.168.0.1
```
上面的配置中，192.168.0.1 是爱快的路由器 IP 地址，192.168.0.100:9222 是 Exporter 容器的地址。

安装Grafana （默认 admin  admin）
```bash
docker run -d -p 3000:3000 grafana/grafana-enterprise
```
连接Prometheus数据库，搜Prometheus，填入 http://192.168.0.100:9090
```bash
http://192.168.0.100:3000/connections/add-new-connection
```
导入模板，库里Grafana模板.json  如果显示错误，编辑模块，run queries一下

## 群晖安装哪吒监控<a name="群晖安装哪吒监控"></a>
群晖 docker 目录创建 neza 文件夹，里面再创建 data 文件夹，上传库里的config.yaml </br>
neza 文件夹上传库里的docker-compose.yaml </br>
参考 docker 安装docker-compose  </br>
ssh 到群晖sudo su 后， cd 到neza 文件夹  </br>
安装容器
```bash
docker-compose up -d
```


## NginxProxyManager反向代理工具<a name="NginxProxyManager反向代理工具"></a>

创建 docker-compose.yaml
```bash
version: '3'
services:
  app:
    image: 'jc21/nginx-proxy-manager:latest'
    restart: unless-stopped
    ports:
      - '80:80'              # 不建议修改端口
      - '81:81'              # 可以把冒号左边的 81 端口修改成你服务器上没有被占用的端口
      - '443:443'            # 不建议修改端口
    volumes:
      - ./data:/data         # 点号表示当前文件夹，冒号左边的意思是在当前文件夹下创建一个 data 目录，用于存放数据，如果不存在的话，会自动创建
      - ./letsencrypt:/etc/letsencrypt  # 点号表示当前文件夹，冒号左边的意思是在当前文件夹下创建一个 letsencrypt 目录，用于存放证书，如果不存在的话，会自动创建
    # network_mode: "host"
```
安装容器
```bash
docker-compose up -d
```
默认登陆的用户名：admin@example.com 密码：changeme


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
```bash
wget -O snell.sh --no-check-certificate https://raw.githubusercontent.com/getsomecat/Snell/master/snell_new.sh && chmod +x snell.sh && ./snell.sh
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

流媒体检测
```bash
   bash <(curl -L -s media.ispvps.com)
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
运行以下命令以下载 Docker Compose 的当前稳定版本：
```bash
sudo curl -L "https://github.com/docker/compose/releases/download/v2.2.2/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose
```
将可执行权限应用于二进制文件：
```bash
sudo chmod +x /usr/local/bin/docker-compose
```
创建软链：
```bash
sudo ln -s /usr/local/bin/docker-compose /usr/bin/docker-compose
```
测试是否安装成功：
```bash
docker-compose version
```

## 安装运行Nginx容器<a name="安装运行Nginx容器"></a>
```bash
sudo docker run -d -p 80:80 --name mynginx -v /root/html:/usr/share/nginx/html nginx
```
在容器中编辑 Nginx 配置文件：
```bash
sudo docker exec -it mynginx /bin/bash
```
在容器中执行以下命令：（改域名和目录名）
```bash
echo "server {
    listen 80 default_server;
    server_name _;

    return 403;
}

server {
    listen 80;
    server_name 域名;

    location / {
        alias /usr/share/nginx/html/目录名/;
        index index.html;
    }
}" > /etc/nginx/conf.d/mywebsite.conf
```
重新加载 Nginx 配置:
```bash
nginx -s reload
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
