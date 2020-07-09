import boto3
import requests
from requests_aws4auth import AWS4Auth

host = 'https://vpc-production.us-west-1.es.amazonaws.com/'
region = 'us-west-1' # For example, us-west-1
service = 'es'
credentials = boto3.Session().get_credentials()
awsauth = AWS4Auth(credentials.access_key, credentials.secret_key, region, service, session_token=credentials.token)

# Register repository
path = '_snapshot/my-snapshot-repo' # the Elasticsearch API endpoint
url = host + path

payload = {
  "type": "s3",
  "settings": {
    "bucket": "google-snapshot-es",
    "region": "us-west-1",
    "role_arn": "arn:aws:iam::aws_account_id:role/TheSnapshotRole"
  }
}

headers = {"Content-Type": "application/json"}

r = requests.put(url, auth=awsauth, json=payload, headers=headers)

print(r.status_code)
print(r.text)


###Setting up the environment###
#yum install python34 python34-pip -y
#python3 -m venv my_venv && source my_venv/bin/activate
#pip install boto3 requests requests_aws4auth
