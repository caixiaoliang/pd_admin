# -*- coding: utf-8 -*
import json
import login
import csv

UPLOAD_URL = "https://www.groupon.com/goods-gateway/proxy/gpapi/v2/products"


def upload_image(g_session, img_url, product_info, main_img=False):
    print "hhahah"
    img = {
        "imageServiceUri": None,
        "sourceUri": img_url,
        "uuid": None
    }
    header = {
        'User-Agent': login.AGENT,
        'Content-Type': 'application/json'
    }

    if product_info is None:
        print "error product is not present "
        return False
        # 商品ID存在

    # delete_extral_key(product_info)

    if not main_img:
        product_info['product']['items'][0]['images'].append(img)
    else:
        product_info['product']['images'].append(img)

    r = g_session.post(UPLOAD_URL, data=json.dumps(product_info), headers=header, verify=False)

    print " post for data %s " % json.dumps(product_info)
    if r.status_code == 201:
        print "img uploaded success"
        return True
    else:
        print "err: %s" % r.text
        return False


def laodimages_from_csv(file_name):
    images = []
    products_json_list = []

    with open(file_name, "r") as csvfile:
        csv_reader = csv.reader(csvfile,delimiter=',', quotechar='"')
        images = [row for row in csv_reader]

    return images
