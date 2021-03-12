import json
from Update_DB import *


def lambda_handler(event, context):
    updateDB()
    return {
        'statusCode' : 200,
        'body': json.dumps('Shoes Data Complete')
    }