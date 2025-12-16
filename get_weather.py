import urllib.request
import time
import os

# 你想查询的城市
CITIES = ["Hefei", "Luoyang", "Wuxi"]
# 输出文件路径 (必须和 Conky 里写的一样)
OUTPUT_FILE = "/tmp/weather.json"

def fetch_weather():
    print(f"正在更新天气到 {OUTPUT_FILE} ...")
    weather_data = []
    for city in CITIES:
        try:
            # 使用 wttr.in 接口，format 3 格式为：City: ⛅ +15°C
            url = f"https://wttr.in/{city}?format=%l|%c|%t"
            # 设置超时防止卡死
            response = urllib.request.urlopen(url, timeout=10).read().decode('utf-8')
            weather_data.append(response)
        except Exception as e:
            print(f"获取 {city} 失败: {e}")
            weather_data.append(f"{city}: N/A")

    # 写入文件
    with open(OUTPUT_FILE, "w", encoding="utf-8") as f:
        f.write("\n".join(weather_data))
    print("更新完成。")

if __name__ == "__main__":
    # 启动时先更新一次
    fetch_weather()

    # 这是一个死循环，每隔 1800 秒 (30分钟) 更新一次
    while True:
        time.sleep(1800) 
        fetch_weather()
