import os

def lambda_handler(event, context):
    print(f"event received: {event}")
    print(f"{os.environ.get("stage")}")
    return {"statusCode": "200"}