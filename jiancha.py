import os
import requests
from datetime import datetime

def send_get_request(url):
    try:
        response = requests.get(url)
        # 检查响应状态码
        if response.status_code == 200:
            print("GET 请求成功！")
            # 打印响应内容
            print(response.text)
        else:
            print(f"GET 请求失败！状态码: {response.status_code}")
    except requests.exceptions.RequestException as e:
        print(f"GET 请求发生异常: {e}")

# 要访问的 URL
url = "https://api.day.app/改自己链接/转换出错/出错了出错了"

def get_latest_log_file(directory):
    latest_file = None
    latest_time = datetime.min

    # 检查指定目录下的所有文件
    for root, dirs, files in os.walk(directory):
        for file_name in files:
            if file_name.endswith(".log"):  # 确保文件是以.log结尾的日志文件
                file_path = os.path.join(root, file_name)
                try:
                    # 获取文件的最后修改时间并转换为datetime对象
                    modified_time = datetime.fromtimestamp(os.path.getmtime(file_path))
                    print(f"文件 {file_path} 最后修改时间: {modified_time}")
                    if modified_time > latest_time:
                        latest_time = modified_time
                        latest_file = file_path
                except OSError as e:
                    print(f"无法获取文件 {file_path} 的信息: {e}")

    return latest_file

def search_latest_log_for_traceback(directory):
    latest_log = get_latest_log_file(directory)
    if latest_log:
        try:
            print(f"正在搜索文件: {latest_log}")
            with open(latest_log, 'r', encoding='utf-8') as file:
                for line in file:
                    if "Traceback (most recent call last)" in line:
                        print(f"在文件 {latest_log} 中找到 Traceback！")
                        send_get_request(url)
                        return  # 找到后立即返回
        except OSError as e:
            print(f"无法打开文件 {latest_log}: {e}")
    else:
        print("未找到日志文件")

# 指定要搜索的目录
directory_to_search = '/ql/data/log/6dylan6_jdpro_jd_wsck'

# 执行搜索最新日期的日志文件
search_latest_log_for_traceback(directory_to_search)
