import pygrib
import pandas as pd

from lib import util
from lib import grib
from lib import output


def run(param: dict) -> None: 
    lat = param["lat"]
    lon = param["lon"]
    LAT_STEP = param["LAT_STEP"]
    LON_STEP = param["LON_STEP"]
    FILE_NAME = "Z__C_RJTD_20171205000000_MSM_GPV_Rjp_Lsurf_FH00-15_grib2"
    gpv_file = pygrib.open("/grib2/" + FILE_NAME + ".bin")

    analDate = grib.getBaseData(gpv_file, lat, lon,  LAT_STEP, LON_STEP)

    temperature = grib.getParamData(gpv_file, "Temperature", lat, lon, LAT_STEP, LON_STEP)
    radiation = grib.getParamData(gpv_file, "Downward short-wave radiation flux", lat, lon, LAT_STEP, LON_STEP)
    pressure = grib.getParamData(gpv_file, "Pressure", lat, lon, LAT_STEP, LON_STEP)
    mslp = grib.getParamData(gpv_file, "Pressure reduced to MSL", lat, lon, LAT_STEP, LON_STEP)
    uwind = grib.getParamData(gpv_file, "u-component of wind", lat, lon, LAT_STEP, LON_STEP)
    vwind = grib.getParamData(gpv_file, "v-component of wind", lat, lon, LAT_STEP, LON_STEP)
    rh = grib.getParamData(gpv_file, "Relative humidity", lat, lon, LAT_STEP, LON_STEP)
    rain = grib.getParamData(gpv_file, "Total precipitation", lat, lon, LAT_STEP, LON_STEP)
    lcloud = grib.getParamData(gpv_file, "Low cloud cover", lat, lon, LAT_STEP, LON_STEP)
    mcloud = grib.getParamData(gpv_file, "Medium cloud cover", lat, lon, LAT_STEP, LON_STEP)
    hcloud = grib.getParamData(gpv_file, "High cloud cover", lat, lon, LAT_STEP, LON_STEP)
    tcloud = grib.getParamData(gpv_file, "Total cloud cover", lat, lon, LAT_STEP, LON_STEP)

    # print(radiation_data)

    result_json = output.toOutputJson(temperature, radiation, pressure, mslp, uwind, vwind, rh,rain,lcloud,mcloud,hcloud,tcloud, analDate)

    with open("/dist/" + FILE_NAME + ".json", 'w') as file:
        # ファイルに書き込む
        file.write(result_json)

    result_csv = output.toOutputCSV(temperature, radiation, pressure, mslp, uwind, vwind, rh,rain,lcloud,mcloud,hcloud,tcloud, analDate)
    df = pd.DataFrame(* result_csv, columns=['validDate','Latitude', 'Longitude', 'analDate', 'temperature', 'Radiation', 'pressure', 'mslp', 'uwind', 'vwind', 'rh', 'rain', 'lcloud', 'mcloud', 'hcloud', 'tcloud'])
    print(df)

    with open("/dist/" + FILE_NAME + ".csv", 'w') as file:
        # ファイルに書き込む
        file.write(df.to_csv(index=False)) # index=False で行番号を出力しない
