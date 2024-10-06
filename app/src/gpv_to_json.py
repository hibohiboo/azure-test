import pygrib

from lib import util
from lib import grib
from lib import output


def run(param: dict) -> None: 
    lat = param["lat"]
    lon = param["lon"]
    LAT_STEP = param["LAT_STEP"]
    LON_STEP = param["LON_STEP"]
    FILE_NAME = param["FILE_NAME"]
    gpv_file = pygrib.open("/app/data/" + FILE_NAME + ".bin")

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
    result_csv = output.toOutputCSV(temperature, radiation, pressure, mslp, uwind, vwind, rh,rain,lcloud,mcloud,hcloud,tcloud, analDate)

    return [result_json, result_csv]