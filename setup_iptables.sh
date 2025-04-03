#!/bin/bash

echo "=== 检查并安装 iptables ==="
if ! command -v iptables &> /dev/null; then
    echo "iptables 未安装，正在安装..."
    sudo apt update && sudo apt install -y iptables
else
    echo "iptables 已安装，继续执行..."
fi

echo "=== 设定 iptables 规则 ==="

# 确保 /etc/iptables 目录存在
sudo mkdir -p /etc/iptables

# 清除旧规则
sudo iptables -D INPUT -p tcp --dport 42255 -j DROP 2>/dev/null
sudo iptables -D INPUT -s 127.0.0.1/32 -p tcp --dport 42255 -j ACCEPT 2>/dev/null
sudo iptables -D INPUT -p tcp --dport 42255 -s 156.226.171.179 -j ACCEPT 2>/dev/null
sudo iptables -D INPUT -p tcp --dport 42255 -s 47.238.204.223 -j ACCEPT 2>/dev/null

# 允许指定的 IP 访问 42255 端口
sudo iptables -A INPUT -p tcp --dport 42255 -s 156.226.171.179 -j ACCEPT
sudo iptables -A INPUT -p tcp --dport 42255 -s 47.238.204.223 -j ACCEPT

# 阻止其他所有 IP 访问 42255
sudo iptables -A INPUT -p tcp --dport 42255 -j DROP

# 保存规则
sudo iptables-save | sudo tee /etc/iptables/rules.v4

# 创建开机自动加载规则的脚本
echo '#!/bin/sh
/sbin/iptables-restore < /etc/iptables/rules.v4' | sudo tee /etc/network/if-pre-up.d/iptables

# 赋予执行权限
sudo chmod +x /etc/network/if-pre-up.d/iptables

echo "=== iptables 规则设置完成！ ==="
echo "当前规则："
sudo iptables -L -n --line-numbers
