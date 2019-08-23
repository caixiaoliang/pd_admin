# -*- coding: utf-8 -*
import login
import products
import image_uploader
import time
import random
import json
import product_mod


def upload_products(create_product_url, post_data_list, g_session):
    payloadHeader = {
        'User-Agent': login.AGENT,
        'Content-Type': 'application/json'
    }
    for p in post_data_list:
        r = g_session.post(create_product_url, data=p, headers=payloadHeader, verify=False)
        print r.status_code
        print "requests response content is   %s" % r.text
        print "---------------split------------------"
        if r.status_code == 201:
            product_info = r.json()
            product_sku = product_info['product']['items'][0]['vendorSku']
            vendorId = product_info['product']['vendorId']
            productUID = product_info['product']['id']
            status = 0
            res = product_mod.insert_product(vendorId, productUID, product_sku, status)
            print "insert product to db %s" % res
        else:
            print "upload product failed"

        time.sleep(random.uniform(5, 10))
    print "all products upload finished"


def u_img(g_session):
    # groupon 图可以重复传，会自动过滤
    # product_id = '0ae3a1be-e2aa-442a-a479-701d5abacad8'
    # img_url = "https://goods-supply.s3.amazonaws.com/production/8c083c28-e61c-491e-a7ec-20b30185d68a/external-files/da1af215-d578-449e-9701-4b3ae876e0af/282f80dd-7c97-42e5-a6da-f84d1df2b8e9.jpg?response-content-disposition=attachment&X-Amz-Expires=600&X-Amz-Date=20190327T094747Z&X-Amz-Algorithm=AWS4-HMAC-SHA256&X-Amz-Credential=AKIAJOORUDLZTXMA2VRQ/20190327/us-east-1/s3/aws4_request&X-Amz-SignedHeaders=host&X-Amz-Signature=056e7495bf2d91cff7da300ceec6596586c385de675b5d51fe05a813d6c70718"
    # img_url1 = "https://goods-supply.s3.amazonaws.com/production/8c083c28-e61c-491e-a7ec-20b30185d68a/external-files/f4829d9c-d2ec-4743-aa0a-729cba8be5ae/560e2844-8f27-46e8-8532-4832a5891261.jpg?response-content-disposition=attachment&X-Amz-Expires=600&X-Amz-Date=20190702T033652Z&X-Amz-Algorithm=AWS4-HMAC-SHA256&X-Amz-Credential=AKIAJOORUDLZTXMA2VRQ/20190702/us-east-1/s3/aws4_request&X-Amz-SignedHeaders=host&X-Amz-Signature=cc5c83c0685119db68836391d85035fc9ad1aeb06e427d1e3f93da9c566f7fb2"
    # product_info = products.get_product_info(g_session, product_id)

    # 读取csv,去数据库中找到对应SKU的记录，然后
    img_list = image_uploader.laodimages_from_csv("testimgs.csv")
    for row in img_list:
        sku = row[0]
        product_imgs = row[1:]
        print sku
        print product_imgs
        upload_images_by_sku(sku, g_session, product_imgs)


def upload_images_by_sku(sku, g_session, product_imgs):
    product = product_mod.fin_product_by_sku(sku)
    if product:
        print product
        product_id = product[0]
        images = product_imgs
        product_uid = product[2]
        product_info = products.get_product_info(g_session, product_uid)

        for img_url in images:
            is_img_upload_success = image_uploader.upload_image(g_session, img_url, product_info)
            if is_img_upload_success:
                incre_res = product_mod.increament_product_imgcount(product_id, 1)
                print "图片上传成功"
                if not incre_res:
                    print "increament 更新失败"
            else:
                print "产品Sku：%s ,图片上传失败" % sku
            time.sleep(random.uniform(5, 10))
    else:
        print "sku: %s 的商品不存在，图片上传失败" % sku


def test():
    res1 = product_mod.create_table()
    print res1
    sku = "2x140BKUSGP1"
    product_mod.insert_product("vendorId", "productUID", sku, 0)
    product = product_mod.fin_product_by_sku(sku)
    product_id = product[0]
    incre_res = product_mod.increament_product_imgcount(product_id, 1)
    print incre_res


if __name__ == '__main__':
    # g_session = login.get_session()
    g_session = login.get_fast_session()
    p_json_list = products.fullfil_products(g_session)
    tmp = []
    tmp.append(p_json_list[0])
    print "tmps is %s" % tmp
    upload_products(products.CREATE_PRODUCT_URL, tmp, g_session)
    u_img(g_session)
    # test()


