from app import app
import os
from flask import render_template, request
from selenium import webdriver
from selenium.webdriver import ActionChains
from webdriver_manager.chrome import ChromeDriverManager
from selenium.webdriver.common.actions.action_builder import ActionBuilder
from selenium.webdriver import Keys, ActionChains
from selenium.webdriver.chrome.service import Service
from selenium.webdriver.common.by import By
import time

@app.route("/")
def hello_world():
    return render_template('1.html', h="홍길동")

@app.route("/h")
def h():
    args= request.args['area']
    print(args)
    url = "https://topis.seoul.go.kr/"
    driver = webdriver.Chrome(service=Service(ChromeDriverManager().install()))
    driver.get(url)
    driver.implicitly_wait(0.5)

    search_input = driver.find_element(By.ID, "searchTxt")
    ActionChains(driver).send_keys_to_element(search_input, args).perform()
    time.sleep(1)
    return render_template("2.html", hh=args+"잘됐어요")

if __name__ == "__main__":
    app.run("0.0.0.0", port=os.getenv('PORT', 6969))