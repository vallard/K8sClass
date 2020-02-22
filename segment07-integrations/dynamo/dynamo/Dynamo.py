#!/usr/bin/env python3
import boto3
import os
import base64
import boto3
from boto3.dynamodb.conditions import Key, Attr

def update_status(user_id, entry_id, status, column_value=None, column_name=None):
    """
    Take the record and update the status for the record. 
    """
    dynamodb = boto3.resource('dynamodb', region_name='us-east-1')

    update_expr = "SET #st = :stat"
    expr_vals = {':stat': status }
    expr_attrs = { "#st" : "status" }
    if column_value:
        update_expr = "SET #column_name = :column_name, #st = :stat"
        expr_attrs = { "#st" : "status" , "#column_name" : column_name }
        expr_vals = {':stat': status, ':column_name': column_value }

        
    table = dynamodb.Table('zds')
    table.update_item(
            Key = {
                'userId': user_id,
                'id': entry_id
            },
            UpdateExpression=update_expr,
            ExpressionAttributeNames=expr_attrs,
            ExpressionAttributeValues = expr_vals
    )

def get_row(user_id, entry_id):
    dynamodb = boto3.resource('dynamodb', region_name='us-east-1')
    table = dynamodb.Table('zds')
    result = table.query(
        KeyConditionExpression=Key('userId').eq(user_id) & Key('id').eq(entry_id)
    )
    if 'Items' in result and isinstance(result['Items'], list):
        return result['Items'][0]
    return None
