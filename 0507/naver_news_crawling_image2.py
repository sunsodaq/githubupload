import requests
from bs4 import BeautifulSoup
from pathlib import Path
import urllib
import time


url = "http://www.bestpen.kr/index.html"

html = requests.get(url)
soup = BeautifulSoup(html.content, "html.parser")

# 저장용 폴더 생성
out_folder = Path("download2")
out_folder.mkdir(exist_ok=True)
cnt = 0

# 모든 img 태그를 검색해 링크를 구한다
for element in soup.find_all("img"):

    src=element.get('src')
    # print(src)

    # 절대 url을 만들어 이미지 데이터를 구한다
    image_url = urllib.parse.urljoin(url,src)
    imgdata = requests.get(image_url)
    # print(imgdata)

    # URL에서 마지막에 있는 파일명을 추출하고 저장 폴더명과 연결
    filename = image_url.split("/")[-1]
    # outpath = out_folder.joinpath(filename)
    # print(filename)

    str1="download2//"+str(cnt)+".jpg"
    print(str1)
    cnt+=1

    # 이미지 데이터를 파일에 저장
    with open(str1, mode="wb") as f:
        f.write(imgdata.content)
    # 한번 access 했으므로 1초 기다림
    time.sleep(1)