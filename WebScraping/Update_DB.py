import firebase_admin
from firebase_admin import credentials
from firebase_admin import db
from scrap import *

def write_data(ref, data):
    for i, shoes in enumerate(data):
        ref.update({f'Shoes{i}': shoes})
def updateDB():
    try:
        firebase_admin.get_app()
    except ValueError:
        DB_URL = '비공개'
        cred = credentials.Certificate('비공개')
        firebase_admin.initialize_app(cred, {
            'databaseURL': DB_URL
        })

    articles_data = scrapy_articles()
    nike_data = scrapy_shoes('Nike')
    newbal_data = scrapy_shoes('Newbalance')

    articles_ref = db.reference('Articles')
    nike_ref = db.reference('Nike')
    newbal_ref = db.reference('Newbalance')

    # Write Articles
    for i, news in enumerate(articles_data):
        articles_ref.update({f'Articles{i}': news})

    write_data(nike_ref, nike_data)
    write_data(newbal_ref, newbal_data)