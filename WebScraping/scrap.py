from BASE import *

def scrapy_articles():
    URL = 'https://hypebeast.kr/footwear'
    response = requests.request("GET", URL)
    html_src = BeautifulSoup(response.text, 'html.parser')
    card_data = html_src.find('div', {"class" : "posts"})

    time_tag = card_data.find_all('div', {"class" : "post-box-meta-author-time"})
    img_and_title_tag = card_data.find_all("img")
    src_tag = card_data.find_all('a', {"class" : "thumbnail"})

    time_list = [extract_time(time) for time in time_tag]
    img_list = [extract_img(img.get('data-srcset')) for img in img_and_title_tag]
    title_list = [title.get('alt') for title in img_and_title_tag]
    src_list = [src.get("href") for src in src_tag]

    crawling_data = [News(i, news[0], news[1], news[2], news[3]).to_json()
                     for i, news in enumerate(zip(time_list, title_list, img_list, src_list))]

    return crawling_data

def scrapy_shoes(brand):
    select = {
        'Nike' : "https://display.musinsa.com/display/brands/nike?category2DepthCodes=&category1DepthCode=018&colorCodes=&startPrice=&endPrice=&exclusiveYn=&includeSoldOut=&saleGoods=&timeSale=&includeKeywords=&sortCode=3m&tags=&page=1&size=90&listViewType=small&saleCampaign=",
        'Newbalance' : "https://display.musinsa.com/display/brands/newbalance?category2DepthCodes=&category1DepthCode=018&colorCodes=&startPrice=&endPrice=&exclusiveYn=&includeSoldOut=&saleGoods=&timeSale=&includeKeywords=&sortCode=3m&tags=&page=1&size=90&listViewType=small&saleCampaign="
        }
    URL = select[brand]
    response = requests.request("GET", URL)
    html_src = BeautifulSoup(response.text, 'html.parser')
    card_data = html_src.find('ul', {"class": "snap-article-list boxed-article-list article-list center list goods_small_media8"})


    name_and_src_tag = card_data.find_all('a', {"class": "img-block"})
    price_tag = card_data.find_all('p', {"class": "price"})
    img_tag = card_data.find_all('img', {"class": "lazyload lazy"})

    name_list = [name.get('title') for name in name_and_src_tag[:25]]
    src_list = [f'https:{src.get("href")}' for src in name_and_src_tag[:25]]
    img_list = [f'https:{img.get("data-original")}' for img in img_tag[:25]]
    price_list = [separate_price(price.text.strip()) for price in price_tag[:25]] # index = 0 -> originPrice, index = 1 -> discountPrice

    crawling_data = [Shoes(i+1, brand, shoes[0], shoes[1][0], shoes[1][1], shoes[2], shoes[3]).to_json()
                     for i, shoes in enumerate(zip(name_list, price_list, img_list, src_list))]

    return crawling_data