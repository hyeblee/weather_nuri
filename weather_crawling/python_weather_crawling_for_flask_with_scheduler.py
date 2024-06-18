import os
import sys

# import할 필요한 패키지 중 설치가 필요하면 설치
try:
    import flask
    import pytz
    import selenium
    import webdriver_manager
    import googlemaps
    import schedule
    import requests
    import bs4
    import pandas
except ImportError:
    os.system(f"{sys.executable} -m pip install flask pytz selenium webdriver_manager googlemaps schedule requests bs4 pandas")

from flask import Flask, jsonify, request, abort
import schedule
import time
import threading
import requests
from selenium import webdriver
from selenium.webdriver.common.by import By
from selenium.webdriver.chrome.service import Service
from webdriver_manager.chrome import ChromeDriverManager
from bs4 import BeautifulSoup as bs
import pandas as pd
from datetime import datetime
import re
from pytz import timezone
import logging

app = Flask(__name__)

latitude = None
longitude = None

# flutter로부터 사용자의 위도/경도 받아옴
@app.route('/latitude_longitude', methods=['POST'])
def receive_floats():
    global latitude, longitude
    data = request.get_json()
    latitude = data.get('latitude')
    longitude = data.get('longitude')
    if latitude is None or longitude is None:
        return jsonify({'error': 'Invalid input'}), 400

    # 1초 후에 작업 실행
    threading.Timer(1, fetch_weather_data, args=(latitude, longitude)).start()
    return jsonify({'latitude': latitude, 'longitude': longitude}), 200

# 위경도->주소 변환
GM_API_KEY = '' #googlemap api

data_list = []

def get_address_from_lat_lng(latitude, longitude, api_key):
    url = f"https://maps.googleapis.com/maps/api/geocode/json?latlng={latitude},{longitude}&key={api_key}&language=ko"
    response = requests.get(url)
    data = response.json()

    if 'results' in data and len(data['results']) > 0:
        address = data['results'][0]['formatted_address']
        return address
    else:
        return "Address not found"


# '시/도' ~ '동' 까지만 나오게 주소 자르기
def get_address_components(address):
    # 주소를 공백으로 분리
    components = address.split()
    #print(components)

    extracted_address = ' '.join(components[1:3])

    return extracted_address


#현재시간
now = datetime.now(timezone('Asia/Seoul'))
hour = int(now.strftime("%H"))
print(hour)

from datetime import datetime
from pytz import timezone
from selenium import webdriver
from selenium.webdriver.common.by import By
from selenium.webdriver.support.ui import WebDriverWait
from selenium.webdriver.support import expected_conditions as EC

# 기온 값 소수점 뒤 자리수 조정 + '℃' 붙이기
def format_temperature(temp_str):
    temp_float = float(temp_str)
    if temp_float.is_integer():
        return f"{int(temp_float)}℃"
    else:
        return f"{temp_float:.1f}℃"

# 네이버날씨로 최저/최고/현재날씨/현재기온 구하기
def get_weather_temperatures(region):
    options = webdriver.ChromeOptions()
    options.add_argument('--headless')
    options.add_argument('--no-sandbox')
    options.add_argument('--disable-dev-shm-usage')
    driver = webdriver.Chrome(options=options)

    url = f"https://search.naver.com/search.naver?query={region}+날씨"
    driver.get(url)

    try:
        driver.implicitly_wait(10)
        wait = WebDriverWait(driver, 10)

        # 최저/최고 기온
        today_section = driver.find_element(By.CSS_SELECTOR, 'li.week_item.today')
        day_data = today_section.find_element(By.CSS_SELECTOR, 'div.day_data')
        cell_temperature = day_data.find_element(By.CSS_SELECTOR, 'div.cell_temperature')

        lowest_temp_raw = cell_temperature.find_element(By.CSS_SELECTOR, 'span.lowest').text.replace('최저기온\n', '').replace('°', '')
        highest_temp_raw = cell_temperature.find_element(By.CSS_SELECTOR, 'span.highest').text.replace('최고기온\n', '').replace('°', '')

        lowest_temp = format_temperature(lowest_temp_raw)
        highest_temp = format_temperature(highest_temp_raw)

        # 현재 날씨/기온
        weather_main = wait.until(EC.presence_of_element_located((By.CSS_SELECTOR, 'div.weather_main')))
        weather_condition = weather_main.find_element(By.CSS_SELECTOR, 'span.blind').text

        temperature_text = driver.find_element(By.CSS_SELECTOR, 'div.temperature_text')
        span_blinds = temperature_text.find_elements(By.CSS_SELECTOR, 'span.blind')

        current_temperature_raw = None
        if len(span_blinds) > 1:
            current_temperature_raw = span_blinds[1].text.replace('°', '')
        else:
            current_temperature_raw = temperature_text.text.split()[-1].replace('°', '')

        current_temperature = format_temperature(current_temperature_raw)

        driver.quit()

        # 시간대에 따른 이미지 매핑
        now = datetime.now(timezone('Asia/Seoul'))
        formatted_hour = now.strftime("%H:%M")

        weather_map_day = {'맑음': 'sun', '구름 조금': 'day_cloud', '흐림': 'day_cloud', '비': 'rain', '눈': 'snow'}
        weather_map_night = {'맑음': 'moon', '구름 조금': 'night_cloud', '흐림': 'night_cloud', '비': 'rain', '눈': 'snow'}

        hour = int(now.strftime("%H"))
        if 20 <= hour <= 24 or 0 <= hour <= 6:  # 밤 시간대
            image_key = weather_map_night.get(weather_condition, 'night_cloud')
        else:  # 낮 시간대
            image_key = weather_map_day.get(weather_condition, 'day_cloud')

        return {
            "현재기온": current_temperature,
            "최저기온": lowest_temp,
            "최고기온": highest_temp,
            'hour': formatted_hour,
            'image': image_key
        }
    except Exception as e:
        print(f"Error extracting weather data: {e}")
        driver.quit()
        return None

# 기상청 & openweatherapi 크롤링 & 디비 적재 함수
def fetch_weather_data(latitude, longitude):
    global data_list
    data_list=[]

    weather_url = f'https://www.weather.go.kr/w/wnuri-fct2021/main/current-aws.do?code=4100000000&lat={latitude}&lon={longitude}&unit=m%2Fs'
    forecast_url = f'https://www.weather.go.kr/w/wnuri-fct2021/main/digital-forecast.do?code=1159068000&unit=m%2Fs&hr1=Y&lat={latitude}&lon={longitude}'

    # 현재 날씨 요약
    res = requests.get(weather_url)
    soup = bs(res.text, "html.parser")
    body = soup.select('table')
    locs = soup.select_one('div.aws-data-head').text

    col_list = [i.text for i in soup.select('th')]
    value_list = [i.text for i in soup.select('td')]

    df_result = pd.DataFrame([value_list], columns=col_list)
    # print(f"현재 위치: {locs}")
    # print("오늘 날씨 요약")
    print(df_result)

    # 현재, 최저, 최고기온
    # 위도,경도로 주소 구하기
    address = get_address_from_lat_lng(latitude, longitude, GM_API_KEY)
    region = get_address_components(address)
    current_weather = get_weather_temperatures(region)
    print(current_weather)

    # 미세먼지 크롤링
    res = requests.get(forecast_url)
    soup = bs(res.text, "html.parser")
    dust_info = [i.text.replace('범례보기', '') for i in soup.select('strong.air-level.val')]
    df_result['미세먼지'], df_result['초미세먼지'] = dust_info[:2]

    # 예보 크롤링 및 json 반환
    forecast_data = soup.select('div.dfs-slider')
    date_list = ['오늘', '내일', '모레', '글피', '그글피', '중기']
    all_data = []
    for index, day_data in enumerate(forecast_data[0].select('div.slide'), start=1):
        df_day = parse_day_data(day_data)
        print(f"{date_list[index-1]}")
        print(df_day)
        if index==1:
            today_data = df_day
        elif index==2:
            tommorrow_data = df_day

    combined_df = pd.concat([today_data, tommorrow_data.iloc[:24-len(today_data)]])
    combined_df = combined_df.head(24)

    # 현재 날씨 정보 추가
    data_list.append({
        "current_weather": current_weather
    })

    #json변환
    # 시간대에 따라 날씨 이미지 매핑 변경
    weather_map_day = {'맑음': 'sun', '구름 조금': 'day_cloud', '흐림': 'day_cloud', '비': 'rain', '눈': 'snow'}
    weather_map_night = {'맑음': 'moon', '구름 조금': 'night_cloud', '흐림': 'night_cloud', '비': 'rain', '눈': 'snow'}

    for _, row in combined_df.iterrows():
        # 시각에서 숫자만 추출하여 시간으로 변환
        hour_str = re.search(r'\d+', row['시각'])
        if hour_str:
            hour = int(hour_str.group())  # 추출된 시간을 정수로 변환
        else:
            continue  # 시각 데이터가 없는 경우 다음 행으로

        # 시간대를 "%H:%M" 형식으로 변환
        formatted_hour = f"{hour:02d}:00"

        # 시간대에 따라 날씨 이미지 매핑 선택
        if 20 <= hour <= 24 or 0 <= hour <= 6:  # 밤 시간대
            image_key = weather_map_night.get(row['날씨'], 'night_cloud')
        else:  # 낮 시간대
            image_key = weather_map_day.get(row['날씨'], 'day_cloud')

        actual_temp = re.search(r"(\d+)℃", row['기온(체감온도)'])
        actual_temperature = actual_temp.group(1) + "℃" if actual_temp else 'NA'

        data_list.append({
            "hour": formatted_hour,
            "image": image_key,
            "degree": actual_temperature
        })
    print(data_list)
    return data_list



def parse_day_data(day):
    data = {
        '날짜': [], '시각': [], '날씨': [], '기온(체감온도)': [], '강수확률': [], '바람': [], '습도': []
    }
    for item in day.find_all('ul', class_='item'):
        date = item.attrs['data-date']
        # 데이터 초기화
        temp_data = {
            '시각': 'NA', '날씨': 'NA', '기온(체감온도)': 'NA', '강수확률': 'NA', '바람': 'NA', '습도': 'NA'
        }

        # 각 시간대별 데이터를 추출
        for li in item.select('li'):
            if '시각:' in li.text:
                temp_data['시각'] = li.text.replace('시각:', '').strip()
            elif '날씨:' in li.text:
                temp_data['날씨'] = li.text.replace('날씨:', '').strip()
            elif '기온(체감온도)' in li.text:
                temp_data['기온(체감온도)'] = li.text.replace('기온(체감온도)', '').strip()
            elif '강수확률:' in li.text:
                temp_data['강수확률'] = li.text.replace('강수확률:', '').strip()
            elif '바람:' in li.text:
                temp_data['바람'] = li.text.replace('바람:', '').strip()
            elif '습도:' in li.text:
                temp_data['습도'] = li.text.replace('습도:', '').strip()

        # 날짜 데이터 저장 및 임시 데이터에서 각 값 추출하여 저장
        data['날짜'].append(date)
        data['시각'].append(temp_data['시각'])
        data['날씨'].append(temp_data['날씨'])
        data['기온(체감온도)'].append(temp_data['기온(체감온도)'])
        data['강수확률'].append(temp_data['강수확률'])
        data['바람'].append(temp_data['바람'])
        data['습도'].append(temp_data['습도'])

    return pd.DataFrame(data)


@app.route('/', methods=['GET'])
def get_weather_data():
    return jsonify(data_list)

@app.route('/trigger_schedule', methods=['POST'])
def trigger_schedule():
    schedule.run_pending()
    return jsonify({'status': 'Schedule triggered'}), 200

if __name__ == '__main__':
    if latitude is not None and longitude is not None:
        fetch_weather_data(latitude, longitude)

    schedule.every().hour.at(":00").do(fetch_weather_data, latitude, longitude)

    # 스케줄러를 별도의 스레드에서 실행
    def run_scheduler():
        while True:
            schedule.run_pending()
            time.sleep(1)

    scheduler_thread = threading.Thread(target=run_scheduler, daemon=True)
    scheduler_thread.start()

    # Flask 애플리케이션 실행
    app.run(host='0.0.0.0', port=3500)
