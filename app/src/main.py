import json
import sys

import gpv_to_json

# メッシュの刻み幅
# https://www.data.jma.go.jp/suishin/cgi-bin/catalogue/make_product_page.cgi?id=MesModel の MSM格子点データ（ファイル形式） より
LAT_STEP=0.05 / 2 # 緯度
LON_STEP=0.0625 / 2 # 経度

json_str = sys.argv[1]
json_obj = json.loads(json_str)
lat = json_obj["lat"]
lon = json_obj["lon"]

gpv_to_json.run({"lat": lat, "lon": lon, "LAT_STEP": LAT_STEP, "LON_STEP": LON_STEP})
