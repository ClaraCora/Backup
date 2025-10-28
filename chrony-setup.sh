#!/bin/bash

###############################################
# Chrony 一键安装和配置脚本
# 自动安装、配置、启用Chrony时间同步
# 并进行完整验证
###############################################

set -e

# 颜色定义
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# 打印彩色输出
print_info() {
    echo -e "${BLUE}[INFO]${NC} $1"
}

print_success() {
    echo -e "${GREEN}[SUCCESS]${NC} $1"
}

print_warning() {
    echo -e "${YELLOW}[WARNING]${NC} $1"
}

print_error() {
    echo -e "${RED}[ERROR]${NC} $1"
}

# 检查是否为root用户
if [[ $EUID -ne 0 ]]; then
   print_error "此脚本必须以root身份运行"
   exit 1
fi

print_info "开始安装和配置Chrony时间同步服务..."
echo ""

# ============================================
# 第一步：更新系统包
# ============================================
print_info "第一步：更新系统包管理器..."
if command -v apt-get &> /dev/null; then
    apt-get update -y > /dev/null 2>&1
    print_success "系统包更新完成 (Debian/Ubuntu系统)"
elif command -v yum &> /dev/null; then
    yum update -y > /dev/null 2>&1
    print_success "系统包更新完成 (CentOS/RHEL系统)"
else
    print_warning "无法识别的包管理器，跳过系统更新"
fi
echo ""

# ============================================
# 第二步：安装Chrony
# ============================================
print_info "第二步：安装Chrony..."
if command -v chrony &> /dev/null; then
    print_warning "Chrony已安装，跳过安装步骤"
else
    if command -v apt-get &> /dev/null; then
        apt-get install -y chrony > /dev/null 2>&1
    elif command -v yum &> /dev/null; then
        yum install -y chrony > /dev/null 2>&1
    fi
    print_success "Chrony安装完成"
fi
echo ""

# ============================================
# 第三步：配置NTP服务器
# ============================================
print_info "第三步：配置NTP服务器..."

# 备份原配置文件
if [ -f /etc/chrony/chrony.conf ]; then
    cp /etc/chrony/chrony.conf /etc/chrony/chrony.conf.bak
    print_success "原配置文件已备份到 /etc/chrony/chrony.conf.bak"
fi

# 创建新的chrony配置
cat > /etc/chrony/chrony.conf << 'EOF'
# NTP服务器池（多个来源提高精度）
pool pool.ntp.org iburst maxsources 4
pool ntp.aliyun.com iburst maxsources 2
pool cn.pool.ntp.org iburst maxsources 2

# 允许本地客户端连接
allow 127.0.0.1
allow ::1

# 本地时钟作为后备
local stratum 10

# 记录文件
keyfile /etc/chrony/chrony.keys
driftfile /var/lib/chrony/chrony.drift
logdir /var/log/chrony

# 其他配置
initstepslew 10 pool.ntp.org

# 启用实时时钟同步
rtcsync

# 性能优化
makestep 1.0 3
EOF

print_success "NTP配置已更新"
echo ""

# ============================================
# 第四步：启动并启用Chrony服务
# ============================================
print_info "第四步：启动Chrony服务..."

# 停止旧的ntp服务（如果存在）
if systemctl is-active --quiet ntp 2>/dev/null; then
    systemctl stop ntp
    systemctl disable ntp
    print_success "已停止NTP服务"
fi

# 停止systemd-timesyncd（如果正在运行）
if systemctl is-active --quiet systemd-timesyncd 2>/dev/null; then
    systemctl stop systemd-timesyncd
    systemctl disable systemd-timesyncd
    print_success "已禁用systemd-timesyncd"
fi

# 启动Chrony
systemctl enable chrony > /dev/null 2>&1
systemctl start chrony > /dev/null 2>&1
print_success "Chrony服务已启动并设置为开机自启"
echo ""

# ============================================
# 第五步：启用timedatectl NTP同步
# ============================================
print_info "第五步：配置systemd时间同步..."
timedatectl set-ntp true 2>/dev/null || true
print_success "systemd NTP同步已启用"
echo ""

# ============================================
# 第六步：等待时间同步
# ============================================
print_info "第六步：等待Chrony同步时间（约20秒）..."
sleep 5

# 强制同步一次
chronyc -a makestep > /dev/null 2>&1 || true
print_info "已请求强制时间同步..."

# 等待同步完成
SYNC_WAIT=0
while [ $SYNC_WAIT -lt 30 ]; do
    if chronyc tracking 2>/dev/null | grep -q "Leap status.*Normal"; then
        print_success "时间已同步到NTP服务器"
        break
    fi
    sleep 1
    SYNC_WAIT=$((SYNC_WAIT + 1))
done

if [ $SYNC_WAIT -eq 30 ]; then
    print_warning "时间同步仍在进行中，请稍候..."
fi
echo ""

# ============================================
# 第七步：完整验证
# ============================================
print_info "第七步：执行完整验证..."
echo ""

print_info "7.1 检查Chrony服务状态..."
if systemctl is-active --quiet chrony; then
    print_success "✓ Chrony服务运行中"
else
    print_error "✗ Chrony服务未运行"
    exit 1
fi
echo ""

print_info "7.2 检查systemd时间同步状态..."
SYNC_STATUS=$(timedatectl | grep "System clock synchronized")
if echo "$SYNC_STATUS" | grep -q "yes"; then
    print_success "✓ 系统时钟已同步"
else
    print_warning "⚠ 系统时钟未完全同步（仍在同步中）"
fi
echo "$SYNC_STATUS"
echo ""

print_info "7.3 显示完整的timedatectl状态..."
timedatectl
echo ""

print_info "7.4 Chrony同步详细信息..."
chronyc tracking
echo ""

print_info "7.5 Chrony同步源..."
chronyc sources -v
echo ""

print_info "7.6 当前系统时间..."
echo "系统时间: $(date '+%Y-%m-%d %H:%M:%S %Z')"
echo "UTC时间:  $(date -u '+%Y-%m-%d %H:%M:%S UTC')"
echo ""

# ============================================
# 第八步：显示时间偏移
# ============================================
print_info "7.7 时间偏移检查..."
OFFSET=$(chronyc tracking | grep "System time" | awk '{print $4}')
OFFSET_ABS=${OFFSET#-}  # 获取绝对值
print_success "时间偏移: $OFFSET"

# 检查偏移是否在可接受范围内（<1秒）
if (( $(echo "$OFFSET_ABS < 1" | bc -l) )); then
    print_success "✓ 时间偏移在可接受范围内（<1秒）"
else
    print_warning "⚠ 时间偏移可能较大，请等待更多时间同步"
fi
echo ""

# ============================================
# 第九步：显示后续操作建议
# ============================================
print_info "验证完成！"
echo ""
echo -e "${GREEN}====== 后续操作 =====${NC}"
echo ""
echo "1. 如果你使用S-UI面板，请执行："
echo -e "   ${BLUE}systemctl restart sui${NC}"
echo ""
echo "2. 实时监控时间同步状态，执行："
echo -e "   ${BLUE}watch -n 1 'chronyc tracking'${NC}"
echo ""
echo "3. 查看Chrony同步源，执行："
echo -e "   ${BLUE}chronyc sources${NC}"
echo ""
echo "4. 强制时间同步，执行："
echo -e "   ${BLUE}chronyc -a makestep${NC}"
echo ""
echo "5. 查看Chrony日志，执行："
echo -e "   ${BLUE}tail -f /var/log/chrony/tracking.log${NC}"
echo ""

# ============================================
# 第十步：自动修复和建议
# ============================================
STRATUM=$(chronyc tracking 2>/dev/null | grep "Stratum" | awk '{print $3}')

if [ -z "$STRATUM" ] || [ "$STRATUM" -gt 10 ]; then
    print_warning "检测到可能的问题："
    echo ""
    echo "问题：Chrony似乎还未完全同步"
    echo "解决方案："
    echo "1. 请等待2-3分钟让Chrony完成首次同步"
    echo "2. 执行: chronyc -a makestep 强制同步"
    echo "3. 重新运行此脚本进行验证"
    echo ""
fi

print_success "安装和配置完成！"
print_success "时间同步服务已正常启动"
echo ""
