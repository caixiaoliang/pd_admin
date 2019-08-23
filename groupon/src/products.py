# -*- coding: utf-8 -*
import csv
import json
import time
import login
import MySQLdb
import datetime

CREATE_PRODUCT_URL = "https://www.groupon.com/goods-gateway/proxy/gpapi/v2/products"
PRPDUCT_URL = "https://www.groupon.com/goods-gateway/proxy/gpapi/v1/products/"


def find_category_id_by_name(name):
    with open('category.json') as json_file:
        data = json.load(json_file)
        res_list = filter(lambda p: p['localizedContents'][0]['description']== name,data['categories'])
    return res_list


def get_product_images():
    images = []
    return images


def get_attribute_by_id(category_id, data, g_session):
    # "https://www.groupon.com/goods-gateway/proxy/gpapi/v1/categories/5187a247-a892-4f2e-bc0b-b0e756b368ed?include=variantCategories"
    attribute_url = "https://www.groupon.com/goods-gateway/proxy/gpapi/v1/categories/%s?include=variantCategories" % category_id
    payloadHeader = {
        'User-Agent': login.AGENT,
        'Content-Type': 'application/json'
    }
    r = g_session.get(attribute_url, headers=payloadHeader, verify=False)

    # remote_category_attributes = json.load(r_json)
    remote_category_attributes = r.json()
    product_attr_list = get_original_attributes(data)

    # print remote_category_attributes
    # print product_attr_list
    # print len(product_attr_list)
    # print len(remote_category_attributes)
    p_attr = build_attributes(remote_category_attributes, product_attr_list)
    return p_attr


def get_product_info(g_session, product_uid):
    # get product info
    header = login.group_header()
    url = PRPDUCT_URL + product_uid +"?upgrade=true"
    print url
    r = g_session.get(url, headers=header, verify=False)
    print r.text
    if r.status_code == 200:
        product_info = r.json()

        return product_info
    else:
        return None


def get_original_attributes(data):
    attr_keys = data[65:115:2]
    attr_values = data[66:115:2]
    list_attr = [{'k': attr_keys[idx], 'v': attr_values[idx]} for idx in range(len(attr_keys)) if attr_keys[idx]!='' ]
    return list_attr


def build_attributes(remote_category_attributes, product_attr_list):

    p_attributes = []
    print "product arrs is. %s" % product_attr_list
    for attr in product_attr_list:
        print "attr is %s" % attr

        attr_name = attr['k']
        attr_value = attr['v']
        for x in remote_category_attributes['category']['variantCategories']:
            if x['localizedContents'][0]['name'] == attr_name or x['localizedContents'][0]['description'] == attr_name:
                #可以自定义值的属性
                a_name_id = x['id']
                if x['isFreeText'] == True and len(x['values']) == 1:
                    print '自定义'
                    a_v_id = x['values'][0]['id']
                    tmp = {
                        "attrValueId": a_v_id,
                        "attrNameId": a_name_id,
                        "localizedContents": [
                            {
                                "attrValue": attr_value,
                                "locale": "en_US"
                            }
                        ],
                        "attachments": []
                    }
                    p_attributes.append(tmp)
                    print 'find it'
                    print p_attributes
                    break
                else:
                    res=filter(lambda v:  v['localizedContents'][0]['name']==attr_value, x['values'])
                    # print len(res)
                    if len(res)>0:
                        a_v_id = res[0]['id']
                        tmp={
                            "attrValueId": a_v_id,
                            "attrNameId": a_name_id,
                            "localizedContents": [],
                            "attachments": []
                        }
                        p_attributes.append(tmp)
                        print 'find it'
                        print p_attributes
                        break
    return p_attributes


def find_proper_attrs(attr_list, actual_attr):
    # 判断是否在CSV的属性列表中
    print ''


def build_products_json(products_info,g_session):
    # data[65],data[66] 是属性1的开始
    # data[65:50]
    product_category_id = find_category_id_by_name(products_info[0])[0]['id']
    p_attr = get_attribute_by_id(product_category_id, products_info ,g_session)

    category_id = product_category_id
    vendorSku = products_info[1]
    localizedContentsTitle = products_info[2]
    localizedContentsdescription = products_info[3]
    manufacturer = products_info[4]
    manufacturerModeNumber =  None  if products_info[5]=="" else products_info[5]
    brandName = products_info[6]
    isBundle = False if products_info[7]=="No" else True
    ProductIdentifierType = products_info[8]
    ProductIdentifier = products_info[9]
    sellPrice = products_info[11]
    CustomerShipFee = products_info[12]
    shippingReturnPolicy = products_info[13]
    referencePrice = products_info[14]
    msrpSiteLink = products_info[15]
    ProductWeight = products_info[22]
    ProductWeightUnit = products_info[23]
    ProductHeight = products_info[24]
    ProductLength = products_info[25]
    ProductWidth = products_info[26]
    ProductDimensionsUnit = products_info[27]
    isLtl = False if products_info[28] == "No" else True
    packageWeight = products_info[29]
    packageWeightUnit = products_info[30]
    packageHeight = products_info[31]
    packageLength = products_info[32]
    packageWidth = products_info[33]
    packageDimensionsUnit = products_info[34]
    CountryofOrigin = products_info[35]
    isHazmat = False if products_info[36] == "No" else True
    boxContents = products_info[37]
    WarrantyDescription = products_info[38]
    WarrantyType = None if products_info[39] == "" else products_info[39]
    WarrantyProvider = None if products_info[40] == ""  else products_info[40]
    ConcealWarrantyProvider = products_info[41]
    WarrantyLength = None if products_info[42] =="" else  float(products_info[42])
    WarrantyLengthUnit = None if products_info[43] == ""  else products_info[43]
    quantityOnHand = products_info[45]

    postData={
        "product": {
            "id": None,
            "brandApprovedAt": None,
            "buyUrl": None,
            "hideWarranty": False,
            "images": [],
            "localizedContents": [
                {
                    "boxContents": "boxContents",
                    "bulletPoints": [],
                    "description": localizedContentsdescription,
                    "locale": "en_US",
                    "title": localizedContentsTitle
                }
            ],
            "msrpSiteLink": msrpSiteLink,
            "retailSiteLink": "",
            "sourceName": "gateway",
            "vendorGroupId": None,
            "shippingReturn": shippingReturnPolicy,
            "isReturnEligible": False,
            "featureCountry": "US",
            "parentProductUuid": None,
            "hasProp65Disclosure": False,
            "prop65Disclosure": None,
            "attachments": [],
            "feature": None,

            "items": [
                {
                    "id": None,
                    "approvalStatus": "pending",
                    "attributes": p_attr,
                    # "attributes": [
                    #     {
                    #         "attrValueId": "dfeef6e2-5b6d-4ec8-8803-8244d2e72bce",
                    #         "attrNameId": "c6daa42b-cf73-489d-98ad-e9a891a3e900",
                    #         "localizedContents": [],
                    #         "attachments": []
                    #     },
                    #     {
                    #         "attrValueId": "948bf688-e629-414d-b36c-cb6dc1d96f27",
                    #         "attrNameId": "bc80b602-8b32-4337-8f38-e75d3968606c",
                    #         "localizedContents": [],
                    #         "attachments": []
                    #     },
                    #     {
                    #         "attrValueId": "85b95204-9a7b-4c0a-8bfe-320073f101a5",
                    #         "attrNameId": "1a6a3fda-505e-4226-985d-f9a13fa9d68c",
                    #         "localizedContents": [
                    #             {
                    #                 "attrValue": "c",
                    #                 "locale": "en_US"
                    #             }
                    #         ],
                    #         "attachments": []
                    #     }
                    # ],

                    "autoApprovalStatus": "pending",
                    "autoRejectionReasons": [],

                    "brand": {
                        "name": brandName
                    },

                    "buyUrl": None,

                    "height": {
                        "unit": "feet",
                        "value": float(ProductHeight)
                    },

                    "images": [],
                    "isBundle": isBundle,
                    "isExchangeRtvEligible": None,
                    "isExchangeRtvOverride": None,
                    "isHazmat": isHazmat,
                    "isLtl": isLtl,
                    "isRtvOverride": False,
                    "isRtvEligible": False,
                    "isRiskBlocked": False,

                    "length": {
                        "unit": "feet",
                        "value": float(ProductLength)
                    },

                    "localizedContents": [
                        {
                            "locale": "en_US",
                            "title": localizedContentsTitle
                        }
                    ],

                    "ltlService": None,
                    "manualApprovalStatus": "pending",
                    "manualRejectionReason": None,
                    "manufacturer": manufacturer,
                    "modelNumber": manufacturerModeNumber,

                    "packageHeight": {
                        "unit": "feet",
                        "value": float(packageHeight)
                    },

                    "packageLength": {
                        "unit": "feet",
                        "value": float(packageLength)
                    },

                    "packageWeight": {
                        "unit": packageWeightUnit,
                        "value": float(packageWeight)
                    },

                    "packageWidth": {
                        "unit": "feet",
                        "value": float(packageWidth)
                    },

                    "productId": None,

                    "regionalizedContents": [
                        {
                            "countryCode": "US",
                            "map": {
                                "amount": None,
                                "currencyCode": "USD"
                            },
                            "msrp": {
                                "amount": float(referencePrice),
                                "currencyCode": "USD"
                            },
                            "referencePriceType": "msrp"
                        }
                    ],

                    "riskBlockedReason": None,
                    "state": "active",
                    "universalId": {
                        "type": ProductIdentifierType,
                        "value": ProductIdentifier
                    },

                    "vendorSku": vendorSku,

                    "warranties": [
                        {
                            "description": WarrantyDescription,
                            "locale": None,
                            "provider": WarrantyProvider,
                            "warrantyType": WarrantyType,
                            "length": {
                                "amount": WarrantyLength,
                                "unit": WarrantyLengthUnit
                            }
                        }
                    ],

                    "weight": {
                        "unit": ProductWeightUnit,
                        "value": float(ProductWeight) 
                    },
                    "width": {
                        "unit": "feet",
                        "value": float(ProductWidth)
                    },

                    "htsCode": None,

                    "htsAttributeKeyValue": {},

                    "attachments": [],

                    "categoryId": category_id,

                    "offers": [
                        {
                            "id": "fc58b91a-73ce-43ba-95ae-727432437a88",
                            "contractType": None,
                            "discountAllowance": None,
                            "featureCountry": None,
                            "isActive": True,
                            "isStickyPrice": False,

                            "itemCost": {
                                "amount": None,
                                "currencyCode": "USD"
                            },
                            "fulfillmentOptions": [
                                {
                                    "freightAllowance": None,
                                    "shippingCost": {
                                        "amount": None,
                                        "currencyCode": "USD"
                                    },
                                    "estimatedShippingCost": {
                                        "amount": None,
                                        "currencyCode": "USD"
                                    },
                                    "shippingCostToCustomer": {
                                        "amount": float(CustomerShipFee),
                                        "currencyCode": "USD"
                                    },
                                    "fulfillmentMethod": None,
                                    "isStickyEstimatedShipping": False
                                }
                            ],
                            "originCountry": CountryofOrigin,
                            "quantityOnHand": int(quantityOnHand),
                            "sellPrice": {
                                "amount": float(sellPrice),
                                "currencyCode": "USD"
                            },
                            "state": None
                        }
                    ]

                }
            ],
            "vendorId": "b539ecac-7f18-49cd-ba6d-bf8aae6840e5",
            "htsAttributeTree": None
        }
    }
    return postData


def fullfil_products(g_session):
    birth_data = []
    products_json_list = []

    with open("products_test.csv", "r") as csvfile:
        csv_reader = csv.reader(csvfile,delimiter=',', quotechar='"')
        birth_data = [row for row in csv_reader]

    for data in birth_data:
        # 检查CSV 长度，验证有效性
        if len(data) == 115:
            print "parsed product sku is:  %s" % data[1]
            json_product = json.dumps(build_products_json(data, g_session))
            products_json_list.append(json_product)

    return products_json_list


def test():
    print "this is products"


if __name__ == '__main__':
    birth_data = []
    products_json_list = []

    with open("products_test.csv","r") as csvfile:
        csv_reader = csv.reader(csvfile,delimiter=',', quotechar='"')
        birth_data = [ row for row in csv_reader]

    products_attr_arr=[]
    for data in birth_data:
        if  len(data)==115 :
            # print  "parsed product sku is:  %s-----%s" % (data[65],data[66])
            #从65开始取50个元素
            #python 切片操作 start:end:step 从索引start开始取到索引end，不包含end, step是取的间隔，默认为1，就是挨个取
            attr_keys = data[65:115:2]
            attr_values = data[66:115:2]
            list_attr =  [ {'k':attr_keys[idx],'v': attr_values[idx]} for idx in range(len(attr_keys)) if attr_keys[idx]!='' ]
            # print list_attr
            products_attr_arr.append(list_attr)

    d = {}
    with open('category_attr.json') as json_file:
        d = json.load(json_file)

    # print d
    product_list_attrs=[]
    test_arr = []
    test_arr.append(products_attr_arr[0])

    for product_attr_list in  products_attr_arr:
    # for product_attr_list in  products_attr_arr:
        p_attr = []
        print "product arrs is. %s" % product_attr_list
        for attr in product_attr_list:
            print "attr is %s" % attr

            attr_name = attr['k']
            attr_value = attr['v']
            for x in d['category']['variantCategories']:
                # print "---------"
                # print " localizedContents is %s" % len(x['localizedContents'])

                if x['localizedContents'][0]['name'] == attr_name or x['localizedContents'][0]['description'] == attr_name:
                    #可以自定义值的属性
                    a_name_id=x['id']

                    if x['isFreeText']==True and len(x['values'])==1:
                        print '自定义'
                        a_v_id = x['values'][0]['id']
                        p_attr.append({"attrValueId":a_v_id,"attrNameId":a_name_id})
                        print 'find it'
                        print p_attr
                        print attr_value
                        break
                    else:
                        res=filter(lambda v:  v['localizedContents'][0]['name']==attr_value, x['values'])
                        # print len(res)
                        if len(res)>0:
                            a_v_id = res[0]['id']
                            p_attr.append({"attrValueId":a_v_id,"attrNameId":a_name_id})
                            print 'find it'
                            print p_attr
                            break

        product_list_attrs.append(p_attr)
    print len(product_list_attrs[0])
    for x in product_list_attrs:
        print x

# "localizedContents": [
#     {
#         "attrValue": "Max. 8.31PS",
#         "locale": "en_US"
#     }
# ],  
