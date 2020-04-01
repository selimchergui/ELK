import boto3
import logging
import re
import time
import sys
import uuid
from urllib.parse import unquote_plus
from datetime import datetime 
import os
import traceback
from io import StringIO


s3_client = boto3.client('s3')

def transform_file(download_path,upload_path):
    inputfile = open(download_path, 'r+')
    outputfile = open(upload_path,'a+')
    first_line=inputfile.readline()
    if "Summary" not in first_line:
        print("not a patch summary: ignored")
        return {'statusCode': 200};
    output_line=re.sub('Patch\sSummary\sfor\s*(\S*)\n',r'InstanceId=\1', first_line)
    for l in inputfile.readlines():
        l=re.sub('\s+:\s+(.*)',r'=\1', l)
        l=re.sub('\n+','', l)
        l=re.sub('^(\S+)\s*\-\s*AWS\-ApplyPatchBaseline\s*Assessment\s*Results\s*\-\s*(\S+)',r'InstanceName=\1;ResultTime=\2', l)
        if "no missing updates" in l:
            l='UpToDate=true'
        elif "updates missing" in l:
            l='UpToDate=false'
        l=re.sub('\s',',',l)
        if "KB" in l:
            l=re.sub(r'(KB.*)',r'KBs=[\1]',l)
            l=re.sub(r' ',r',',l)
        if len(l)>1:
            output_line=output_line+';'+l 
    output_line=output_line+";AccountName=Vesaprod;AccountId=895005297952"
    outputfile.write(output_line)




def lambda_handler(event, context):
    for record in event['Records']:
        bucket = record['s3']['bucket']['name']
        key = unquote_plus(record['s3']['object']['key'])
        if "stderr" in key:
            print("stderr file: ignored"),
            return {'statusCode': 200}
        tmpkey = key.replace('/', '')
        download_path = '/tmp/{}{}'.format(uuid.uuid4(), tmpkey)
        upload_path = '/tmp/resized-{}'.format(tmpkey)
        s3_client.download_file(bucket, key, download_path)
        transform_file(download_path, upload_path)
        s3_client.upload_file(upload_path, os.environ['TARGET_BUCKET'], key,ExtraArgs={'ACL': 'bucket-owner-full-control'})    
        print("stdout file: uploaded")
    return {
        'statusCode': 200
    }

