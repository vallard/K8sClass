#!/usr/bin/env python
from flask import Flask, render_template
import os
import boto3 # required for getting AWS resources
import botocore

dynamodb = boto3.resource('dynamodb') # dynamo client
app = Flask(__name__)
@app.route('/')
def index():

    table = dynamodb.Table(os.getenv('DYNAMODB_TABLE', 'dynamoUsers'))
    results = []
    error = ""
    try:
        results = table.scan()
    except botocore.exceptions.ClientError as e:
        error = str(e)
        print("client error: ", e)
        pass

    print(results)
    return render_template('index.html',
            error = error,
            items = results['Items'])

if __name__ == '__main__':
   app.run(debug = True)
