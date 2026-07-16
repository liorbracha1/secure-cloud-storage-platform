from flask import Flask, request, jsonify
import boto3
import os

from botocore.config import Config
from botocore.exceptions import ClientError


app = Flask(__name__)


# AWS Retry Configuration
retry_config = Config(
    retries={
        "max_attempts": 5,
        "mode": "standard"
    }
)


# Create S3 client
s3_client = boto3.client(
    "s3",
    config=retry_config
)


# Bucket name from environment variable
S3_BUCKET = os.getenv(
    "S3_BUCKET",
    "secure-cloud-storage"
)


# -----------------------------
# Health Endpoint
# -----------------------------

@app.route("/health", methods=["GET"])
def health():

    return jsonify(
        {
            "status": "healthy"
        }
    ), 200



# -----------------------------
# Upload Endpoint
# -----------------------------

@app.route("/upload", methods=["POST"])
def upload_file():

    try:

        # Get JSON body
        data = request.get_json()

        # Validate JSON
        if not data:
            return jsonify(
                {
                    "error": "Invalid JSON payload"
                }
            ), 400


        filename = data.get("filename")
        content = data.get("content")


        # Validate required fields
        if not filename or not content:

            return jsonify(
                {
                    "error": "filename and content are required"
                }
            ), 400



        # Upload file to S3
        s3_client.put_object(
            Bucket=S3_BUCKET,
            Key=filename,
            Body=content,
            ContentType="text/plain"
        )


        return jsonify(
            {
                "message": "File uploaded successfully",
                "filename": filename
            }
        ), 200



    except ClientError as error:

        return jsonify(
            {
                "error": str(error)
            }
        ), 500



# -----------------------------
# Application Entry Point
# -----------------------------

if __name__ == "__main__":

    app.run(
        host="0.0.0.0",
        port=5000
    )
