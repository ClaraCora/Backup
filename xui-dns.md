## 目录 [自用命令，收集于网上]
[3x-ui开启dns识别+分流+设置](#3x-ui开启dns识别+分流+设置)</br>



## 3x-ui开启dns识别+分流+设置<a name="3x-ui开启dns识别+分流+设置"></a>
替换inbounds部分，开启流量识别功能
```bash
  "inbounds": [
    {
      "tag": "api",
      "listen": "127.0.0.1",
      "port": 62789,
      "protocol": "dokodemo-door",
      "settings": {
        "address": "127.0.0.1"
      },
      "sniffing": {
        "enabled": true,
        "destOverride": [
          "http",
          "tls"
        ]
      }
    }
  ],
```
在 outbounds 段内的首项配置中添加 "domainStrategy": "UseIP" 以使用内置的DNS功能
```bash
  "outbounds": [
    {
      "tag": "direct",
      "protocol": "freedom",
      "settings": {
        "domainStrategy": "UseIP",
        "redirect": "",
        "noises": []
      }
    },
```
在配置文件末尾最后的括号内添加要走DNS解锁的分流网站域名规则等
```bash
  "dns": {
    "servers": [
      "1.1.1.1",
      "8.8.8.8",
      {
        "address": "182.255.35.151",
        "domains": [
          "geosite:netflix",
          "geosite:tiktok",
          "geosite:disney",
          "geosite:openai"
        ],
        "expectIPs": [],
        "queryStrategy": "UseIP",
        "skipFallback": true
      }
    ],
    "queryStrategy": "UseIP",
    "tag": "dns_inbound"
  },
  "fakedns": null
}
```
