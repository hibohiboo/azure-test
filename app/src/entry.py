import json

import gpv_to_json
import os
from azure.storage.queue import QueueServiceClient, QueueClient

connection_string = os.getenv("AZURE_STORAGE_CONNECTION_STRING")
queue_name = os.getenv("AZURE_STORAGE_QUEUE_NAME")

def main():
    queue_service_client = QueueServiceClient.from_connection_string(connection_string)
    queue_client = queue_service_client.get_queue_client(queue_name)
    
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

    # json_str = '{"lat":35.6745,"lon":139.7169}'
    json_str = message.content
    json_obj = json.loads(json_str)
    lat = json_obj["lat"]
    lon = json_obj["lon"]

    gpv_to_json.run({"lat": lat, "lon": lon, "LAT_STEP": LAT_STEP, "LON_STEP": LON_STEP})

    # 3. Delete the message from the queue
    queue_client.delete_message(message.id, message.pop_receipt)
    print("Message processed")

    # 4. Exit

if __name__ == "__main__":
    main()



