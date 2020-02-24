#!/usr/bin/env python
from flask import Flask, render_template
import os
import boto3 # required for getting AWS resources
import botocore

app = Flask(__name__)
@app.route('/')
def index():
    try:
        dynamodb = boto3.resource('dynamodb', region_name=os.environ['REGION']) # dynamo client
    except Exception as e: 
        error = str(e)
        return render_template('index.html', error = error, items = [])

    try:
        table = dynamodb.Table(os.getenv('DYNAMODB_TABLE', 'dynamoUsers'))
    except Exception as e: 
        error = str(e)
        return render_template('index.html', error = error, items = [])

    results = {}
    error = ""
    try:
        results = table.scan()
    except botocore.exceptions.ClientError as e:
        error = str(e)
        print("client error: ", e)
        return render_template('index.html', error = error, items = [])


    return render_template('index.html',
            error = error,
            items = results['Items'])

if __name__ == '__main__':
   app.run(debug = True, host='0.0.0.0', port=80)
