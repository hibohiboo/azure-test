import json
import sys
import pandas as pd

from lib import output
import gpv_to_json

# メッシュの刻み幅
# https://www.data.jma.go.jp/suishin/cgi-bin/catalogue/make_product_page.cgi?id=MesModel の MSM格子点データ（ファイル形式） より
LAT_STEP=0.05 / 2 # 緯度
LON_STEP=0.0625 / 2 # 経度
FILE_NAME = "Z__C_RJTD_20171205000000_MSM_GPV_Rjp_Lsurf_FH00-15_grib2"

json_str = sys.argv[1]
json_obj = json.loads(json_str)
lat = json_obj["lat"]
lon = json_obj["lon"]

[result_json, result_csv] = gpv_to_json.run({"lat": lat, "lon": lon, "LAT_STEP": LAT_STEP, "LON_STEP": LON_STEP, "FILE_NAME": FILE_NAME})

with open("/dist/" + FILE_NAME + ".json", 'w') as file:
    # ファイルに書き込む
    file.write(result_json)

df = pd.DataFrame(* result_csv, columns=['validDate','Latitude', 'Longitude', 'analDate', 'temperature', 'Radiation', 'pressure', 'mslp', 'uwind', 'vwind', 'rh', 'rain', 'lcloud', 'mcloud', 'hcloud', 'tcloud'])
print(df)

with open("/dist/" + FILE_NAME + ".csv", 'w') as file:
    # ファイルに書き込む
    file.write(df.to_csv(index=False)) # index=False で行番号を出力しない
