# -*- coding: utf-8 -*
import MySQLdb
import datetime

product_param = {
    "mysql_host": "192.168.33.171",
    "mysql_port": 3306,
    "mysql_user": "root",
    "mysql_pwd": "ZTOzto123!@#",
    "mysql_db": "pgroup",
    "mysql_table_name": "cluster_system_info"
}

test_param = {
    "mysql_host": "localhost",
    "mysql_port": 3306,
    "mysql_user": "root",
    "mysql_pwd": "xiaoxiao",
    "mysql_db": "pgroup",
    "mysql_table_name": "cluster_system_info"
}

env = "dev"
params = product_param if env == "pro" else test_param


# def insert_product(vendorId, productUID, product_sku, status):
#     fields_str = ",".join(table_fields)
#     dt = datetime.datetime.now().strftime("%Y-%m-%d %H:%M:%S")
#     sql = "insert into %s (%s)values('%s','%s','%s','%s','%s', '%s')" % \
#         (params['mysql_table_name'], fields_str, vendorId, productUID, product_sku, status, dt, dt)
#     res = mysql_insert(sql)
#     return res


# def update_product_status(id, status):
#     table_name = params['mysql_table_name']
#     dt = datetime.datetime.now().strftime("%Y-%m-%d %H:%M:%S")
#     sql = "UPDATE %s SET status=%s, updated_at=%s where id=%s" % (table_name, status, dt, id)
#     res = mysql_update(sql)
#     return res


# def fin_product_by_sku(sku):
#     table_name = params['mysql_table_name']
#     sql = "select * from  %s  where product_sku=%s limit 1" % (table_name, sku)
#     p = mysql_find(sql)
#     return p


def mysql_select_all(sql):
    db = get_mysql_connector()
    cursor = db.cursor()
    cursor.execute(sql)
    results = cursor.fetchall()
    for row in results:
        print row
    return results


def get_mysql_connector():
    db = MySQLdb.connect(
        host=params['mysql_host'],
        port=params['mysql_port'],
        user=params['mysql_user'],
        passwd=params['mysql_pwd'],
        db=params['mysql_db']
    )
    return db


def mysql_find(sql):
    db = get_mysql_connector()
    cursor = db.cursor()
    data = None
    try:
        cursor.execute(sql)
        data = cursor.fetchone()
    except Exception, e:
        print e
        data = None
    db.close()
    return data


def mysql_insert(sql):
    db = get_mysql_connector()
    cursor = db.cursor()
    res = False
    try:
        cursor.execute(sql)
        db.commit()
        res = True
    except Exception, e:
        print e
        db.rollback()
        res = False
    db.close()
    return res


def mysql_update(sql):
    res = mysql_insert(sql)
    return res
