import json
import os
import pandas as pd

import gpv_to_json

from azure.identity import DefaultAzureCredential
from azure.storage.queue import QueueServiceClient, QueueClient

default_credential = DefaultAzureCredential()

storage_account_name = os.getenv("STORAGE_ACCOUNT_NAME")
queue_name = os.getenv("AZURE_STORAGE_QUEUE_NAME")

account_url = "https://" + storage_account_name + ".queue.core.windows.net"

def main():
    queue_client = queue_client = QueueClient(account_url, queue_name=queue_name ,credential=default_credential)
    
    # 1. Dequeue one message from the queue
    response = queue_client.receive_messages(messages_per_page=1, visibility_timeout=60)

    messages = list(response)
    if not messages:
        print("No message received. Exiting...")
        return

    message = messages[0]
    print(f"Processing message: {message.content}")

    # 2. Process the message here
    # メッシュの刻み幅
    # https://www.data.jma.go.jp/suishin/cgi-bin/catalogue/make_product_page.cgi?id=MesModel の MSM格子点データ（ファイル形式） より
    LAT_STEP=0.05 / 2 # 緯度
    LON_STEP=0.0625 / 2 # 経度
    FILE_NAME = "Z__C_RJTD_20171205000000_MSM_GPV_Rjp_Lsurf_FH00-15_grib2"

    # json_str = '{"lat":35.6745,"lon":139.7169}'
    json_str = message.content
    json_obj = json.loads(json_str)
    lat = json_obj["lat"]
    lon = json_obj["lon"]

    [result_json, result_csv] = gpv_to_json.run({"lat": lat, "lon": lon, "LAT_STEP": LAT_STEP, "LON_STEP": LON_STEP, "FILE_NAME": FILE_NAME})
    df = pd.DataFrame(* result_csv, columns=['validDate','Latitude', 'Longitude', 'analDate', 'temperature', 'Radiation', 'pressure', 'mslp', 'uwind', 'vwind', 'rh', 'rain', 'lcloud', 'mcloud', 'hcloud', 'tcloud'])
    print(df)

    # 3. Delete the message from the queue
    queue_client.delete_message(message.id, message.pop_receipt)
    print("Message processed")

    # 4. Exit

if __name__ == "__main__":
    main()



