from bs4 import BeautifulSoup
import requests

class Shoes:
    def __init__(self, rank, brand, name, originPrice, discountPrice, img, src, like = False):
        self.rank = rank
        self.brand = brand
        self.name = name
        self.originPrice = originPrice
        self.discountPrice = discountPrice
        self.img = img
        self.src = src
        self.like = like

    
    def to_json(self):
        data = {
            "rank": self.rank,
            "brand": self.brand,
            "name": self.name,
            "originPrice": self.originPrice,
            "discountPrice": self.discountPrice,
            "like": self.like,
            "img": self.img,
            "src": self.src
        }
        return data


def extract_rate(rate):
    if rate:
        tmp = rate[5:7]
        return int(tmp) / 100
    return 0

def price_to_int(price):
    return int(price.replace(',', '').replace('원',''))


def separate_price(price):
    origin_and_discount = price.split(' ')
    try:
        if origin_and_discount[1]:
            origin_price = origin_and_discount[0]
            discount_price = origin_and_discount[1]
            return list(map(price_to_int, [origin_price, discount_price]))
    except:
        origin_price = price_to_int(origin_and_discount[0])
        discount_price = -1
        return [origin_price, discount_price]

class News:
    def __init__(self, id, time, title, img, src):
        self.id = id
        self.title = title
        self.img = img
        self.src = src
        self.time = time

    def to_json(self):
        data = {
            "id": self.id,
            "time": self.time,
            "title": self.title,
            "img": self.img,
            "src": self.src
        }
        return data

def extract_img(img_src):
    temp_list = img_src.split(' ')
    primary_img_src = temp_list[0]

    return primary_img_src

def extract_time(time_tag):
    time = time_tag.find('time')
    datetime = time.get('datetime')

    if datetime: return translate_time(datetime)
    return time.text

def translate_time(datetime):
    month_dict = {
        '01': 'Jan',
        '02': 'Feb',
        '03': 'Mar',
        '04': 'Apr',
        '05': 'May',
        '06': 'Jun',
        '07': 'Jul',
        '08': 'Aug',
        '09': 'Sep',
        '10': 'Oct',
        '11': 'Nov',
        '12': 'Dec'
    }
    split_date_time = datetime.split('-')

    year = split_date_time[0]
    month = month_dict[split_date_time[1]]
    day = split_date_time[2][:2]

    return f'{month} {day},{year}'
