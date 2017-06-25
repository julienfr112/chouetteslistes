stores=[1966,1923, 1857,1886,1871,1767,1838,1790,1823,1917]


import requests
import requests_cache
import json
from pprint import pprint
requests_cache.install_cache('datagram')
url = "https://datagram-products-v1.p.mashape.com/stores/1870/products/"#1871
headers = {
    'x-mashape-key': "vJpcBxsOd0mshQhiA5WzWt780Qx0p1ZR1vzjsnl3zHA9dKPcuf",
    'accept':       "application/json",
    'cache-control': "no-cache",
    'postman-token': "6d56d562-8fa1-fa04-da55-42ad69a4a23e"
    }

def get_chains():
    url = "https://datagram-products-v1.p.mashape.com/chains/"
    r = requests.get( url, headers=headers)
    return json.loads(r.text)


def get_stores(chain):
    url = "https://datagram-products-v1.p.mashape.com/chains/"+str(str(c['id']))+"/stores/"
    r = requests.get(url, headers=headers)
    res=json.loads(r.text)
    if r.status_code!=200:
        print(r.text)
    print(r.from_cache,r.status_code,chain['name'],len(res))
    return res


def get_prices(idstore=1870):
    url = "https://datagram-products-v1.p.mashape.com/stores/"+str(idstore)+"/products/"#1871
    r = requests.get( url, headers=headers)
    #return json.loads(r.text)
    products=json.loads(r.text)
    return [p for p in products if p['price'] is not None]

def get_product_info(idproduct):
    url='https://datagram-products-v1.p.mashape.com/products/'+str(idproduct)+'/'
    r=requests.get(url, headers=headers)
    return json.loads(r.text)

def get_promotions(idstore=1870):
    url = "https://datagram-products-v1.p.mashape.com/stores/"+str(idstore)+"/promotions/"#1871
    r = requests.get( url, headers=headers)
    return json.loads(r.text)

def get_ingredients(qurl):
    url='https://datagram-products-v1.p.mashape.com/recipes/'
    r3=requests.get(url, {
        'url':qurl,
        'scope':'ingredient'},headers=headers)
    return json.loads(r3.text)




if __name__=='__main__':
    import pickle
    prodids=set()
    for s in stores:
        print(s)
        try:
            prodids|=set(p['id'] for p in get_prices(s))
            get_promotions(s)
        except Exception as e:
            print(e)
            del stores[stores.index(s)]
    print(stores)
    products={}
    print('pdoids',len(prodids))
    for n,i in enumerate(list(prodids)[:]):
        print(n,i)
        try:
            products[i]=get_product_info(i)
            print(products[i]['name'])
        except Exception as e:
            print(e)
    import pickle
    pickle.dump(products,open('products.pkl','wb'))
