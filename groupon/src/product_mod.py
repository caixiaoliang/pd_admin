# -*- coding: utf-8 -*
import mysql_wrap
import datetime


product_param = {
    "mysql_host": "192.168.33.171",
    "mysql_port": 3306,
    "mysql_user": "root",
    "mysql_pwd": "ZTOzto123!@#",
    "mysql_db": "pgroup",
    "mysql_table_name": "products"
}

test_param = {
    "mysql_host": "localhost",
    "mysql_port": 3306,
    "mysql_user": "root",
    "mysql_pwd": "xiaoxiao",
    "mysql_db": "pgroup",
    "mysql_table_name": "products"
}

env = "dev"
params = product_param if env == "pro" else test_param

# 产品状态 0 失败，1 产品上传成功，2图上传成功
# 加一个已经上传成功的图片的数量
# 传图策略，失败重传所有图
table_fields = ["vendorId", "productUID", "product_sku", "status", 'img_count', "created_at", "updated_at"]
fields1 = ["id", "productId", "url", "status"]


def create_table():
    sql = (
      "CREATE TABLE if not exists pgroup.products ("
      "id bigint(20) NOT NULL AUTO_INCREMENT,"
      "vendorId varchar(255) DEFAULT NULL,"
      "productUID varchar(255) DEFAULT NULL,"
      "product_sku varchar(255) DEFAULT NULL,"
      "status  bigint(20) DEFAULT '0',"
      "img_count  bigint(20) DEFAULT '0',"
      "created_at datetime DEFAULT NULL,"
      "updated_at datetime DEFAULT NULL,"
      "PRIMARY KEY (id),"
      "UNIQUE KEY puid (productUID)"
      ")"
    )
    print sql
    res = mysql_wrap.mysql_update(sql)
    return res


def insert_product(vendorId, productUID, product_sku, status):
    img_count = 0
    fields_str = ",".join(table_fields)
    dt = datetime.datetime.now().strftime("%Y-%m-%d %H:%M:%S")
    sql = "insert into %s (%s)values('%s','%s','%s','%s','%s', '%s', '%s')" % \
        (params['mysql_table_name'], fields_str, vendorId, productUID, product_sku, status, img_count, dt, dt)
    print sql
    res = mysql_wrap.mysql_insert(sql)
    return res


def update_product_imgcount(id, img_count):
    table_name = params['mysql_table_name']
    dt = datetime.datetime.now().strftime("%Y-%m-%d %H:%M:%S")
    sql = "UPDATE %s SET img_count=%s , updated_at='%s' where id=%s" % (table_name, img_count, dt, id)
    print sql
    res = mysql_wrap.mysql_update(sql)
    return res


def increament_product_imgcount(id, num):
    p = fin_product_by('id', id)
    if p:
        old_val = p[5]
        new_val = old_val + num
        res = update_product_imgcount(id, new_val)
        return res
    else:
        return False


def update_product_status(id, status):
    table_name = params['mysql_table_name']
    dt = datetime.datetime.now().strftime("%Y-%m-%d %H:%M:%S")
    sql = "UPDATE %s SET status=%s , updated_at='%s' where id=%s" % (table_name, status, dt, id)
    print sql
    res = mysql_wrap.mysql_update(sql)
    return res


def fin_product_by_sku(sku):
    table_name = params['mysql_table_name']
    sql = "select * from  %s  where product_sku='%s' limit 1" % (table_name, sku)
    print sql
    p = mysql_wrap.mysql_find(sql)
    return p


def fin_product_by(k, v):
    table_name = params['mysql_table_name']
    sql = "select * from  %s  where %s='%s' limit 1" % (table_name, k, v)
    print sql
    p = mysql_wrap.mysql_find(sql)
    return p


if __name__ == '__main__':
    print "product mod\n"
    # print create_table()
    # res = insert_product("1", "2", "x3", 0)
    # print res
    product = fin_product_by_sku("x3")
    print product[0]
    res1 = update_product_status(product[0], 1)
    print res1
    product1 = fin_product_by_sku("x3")
    print(product1)


