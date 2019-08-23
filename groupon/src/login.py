# -*- coding: utf-8 -*
from selenium import webdriver
from selenium.webdriver.support import expected_conditions as EC
from selenium.webdriver.common.by import By
from selenium.webdriver.support.ui import WebDriverWait
from fake_useragent import UserAgent
import requests
import time
import json
import sys
import os
import products
import pickle
import random
reload(sys)
# sys.setdefaultencoding('utf-8')

user_name = "cyjj2233@aliyun.com"
password = "cyjj2234"
LOGIN_URL = 'https://www.groupon.com/goods-gateway/auth/login'
CREATE_PRODUCT_URL = "https://www.groupon.com/goods-gateway/proxy/gpapi/v2/products"
# ua = UserAgent()
# userAgent=ua.chrome
AGENT = 'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_10_1) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/41.0.2227.1 Safari/537.36'

header = {
    "origin": "https://www.groupon.com",
    "User-Agent": AGENT
}


def group_header():
    return {
        'User-Agent': AGENT,
        'Content-Type': 'application/json'
    }


# 对方缓存了页面，用了JS异步加载，不用重定向，没法根据状态码判断登录与否
def isLoginStatus(driver):
    print "自动登录检测中...."
    page_url = 'https://www.groupon.com/goods-gateway/inventory'
    driver.get(page_url)
    try:
        WebDriverWait(driver, 10).until(
            EC.presence_of_element_located((By.XPATH, '//*[@id="logout"]')))
    except:
        print "未登录"
        return False
    print "已登录"
    return True


def set_chrome_option():
    option = webdriver.ChromeOptions()
    # 在运行的时候不弹出浏览器窗口
    option.add_argument("-headless")
    chrome_prefs = {}
    option.experimental_options["prefs"] = chrome_prefs
    # 的第二个参数“2”代表，禁止加载全部图片。可以替换为“1”：允许加载全部图片，“3”：禁止加载第三方图片。
    chrome_prefs["profile.default_content_settings"] = {"images": 2}
    chrome_prefs["profile.managed_default_content_settings"] = {"images": 2}
    return option


def login(driver):
    driver.get(LOGIN_URL)
    print 'opened login page...'
    driver.find_element_by_id('email').send_keys(user_name)
    driver.find_element_by_id('password').send_keys(password)
    driver.find_element_by_id('login-button').submit()
    print 'submited...'
    try:
        WebDriverWait(driver, 200).until(
            EC.presence_of_element_located((By.XPATH, '//*[@id="logout"]')))
    except:
        print "login failed"
        return False, driver

    print("login success")
    return True, driver


def save_cookies_in_pickle(driver):
    my_ck = {}
    with open('cookies.pickle', 'wb') as f:
        pickle.dump(driver.get_cookies(), f)
    print 'cookie saved success'


def get_cookie_dict():
    cookiejar = load_cookies_from_lwp()
    my_cookies = requests.utils.dict_from_cookiejar(cookiejar)
    return my_cookies


def load_cookies(session, filename):
    if not os.path.isfile(filename):
        return False

    with open(filename) as f:
        try:
            cookies = pickle.load(f)
            if cookies:
                for cookie in cookies:
                    session.cookies.set(cookie['name'], cookie['value'])
                print 'cookies 加载成功'
                return session
            else:
                return False
        except EOFError:
            return False


def load_pickle_cookie_to_driver(driver):
    driver.get(LOGIN_URL)
    for cookie in pickle.load(open("cookies.pickle", "rb")):
        if cookie.has_key('expiry'):
            cookie.update({'expiry': int(cookie['expiry'])})
        driver.add_cookie(cookie)
    return driver


def get_fast_session():
    groupon_session = requests.Session()
    groupon_session.headers.clear()
    gsession = load_cookies(groupon_session, 'cookies.pickle')
    return gsession


def get_session():
    option = set_chrome_option()
    driver = webdriver.Chrome(chrome_options = option)
    size = os.path.getsize('/Users/xiao/crawler_gro/src/cookies.pickle')
    if size != 0:
        driver = load_pickle_cookie_to_driver(driver)

    groupon_session = requests.Session()
    groupon_session.headers.clear()

    if not isLoginStatus(driver):
        login_status, chrome_driver = login(driver)
        driver = chrome_driver
        if login_status:
            save_cookies_in_pickle(driver)
        else:
            print "登录失败"
        driver.close()
    else:
        print "已登录"
    gsession = load_cookies(groupon_session, 'cookies.pickle')

    return gsession


def main():

    # webdriver add_cookie 后 判断登录
    # 未登录的话，登录，然后把cookie 给 request session
    # 然后把cookie存下来
    # 如果登录的话，request session直接去加载 cookie

    # option = set_chrome_option()
    # driver = webdriver.Chrome( chrome_options = option )
    # size = os.path.getsize('/Users/xiao/crawler_gro/src/cookies.pickle')

    # if size != 0:
    #     driver.get(login_url)
    #     for cookie in pickle.load(open("cookies.pickle", "rb")):
    #         if cookie.has_key('expiry'):
    #             cookie.update({'expiry': int(cookie['expiry'])})
    #         driver.add_cookie(cookie)

    # groupon_session = requests.Session()
    # groupon_session.headers.clear()

    # if not isLoginStatus(driver):
    #     login_status, chrome_driver = login(driver)
    #     driver = chrome_driver
    #     if login_status:
    #         save_cookies_in_pickle(driver)
    #     else:
    #         print "登录失败"
    #     driver.close()
    # else:
    #     print "已登录"
    #     gsession = load_cookies(groupon_session, 'cookies.pickle')
    #     p_json_list = products.fullfil_products()
    #     # print "cookies is % s" % gsession.cookies
    # p_json_list = products.fullfil_products()
    gsession = get_session()
    # upload_products(create_product_url, p_json_list, gsession)


if __name__ == '__main__':
    main()