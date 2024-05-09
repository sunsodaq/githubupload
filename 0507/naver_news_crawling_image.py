import urllib
from flask import Flask, render_template, request
app=Flask(__name__)
import requests
from bs4 import BeautifulSoup
import time

@app.route('/')
def hello_world():
    return render_template("index.html")
@app.route('/naver')
def hello_naver():
    cnt=0
    print("여기는 이미지 가져오는중.............")
    result=[]
    url = "https://news.naver.com/"
    html = requests.get(url)
    soup = BeautifulSoup(html.content, "html.parser")
    # 모든 img 태그를 검색해 링크를 구한다
    for element in soup.find_all("img"):
        src = element.get('src')
        # print(src)
        # 절대 url을 만들어 이미지 데이터를 구한다
        image_url = urllib.parse.urljoin(url, src)
        print(cnt, image_url)
        if image_url in ['https://news.naver.com/']:
            cnt+=1
            if cnt>20: break
        result.append(image_url)
        # 리스트에 추가하여 전달하고 html에서 반복문으로 출력
        time.sleep(1)
    print(result)
    res = list(filter (lambda x: x not in ['https://news.naver.com/'], result))
    return render_template("naverimg.html", data=res)

# 모든 img 태그를 검색해 링크를 구한다
if __name__ == "__main__":
    app.run()