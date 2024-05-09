
import requests
#웹페이지를 취득한다
url = "http://python.cyber.co.kr/pds/books/python2nd/test1.html"
response = requests.get(url)

#글자가 깨지지 않도록 한다
response.encoding = response.apparent_encoding

#취득한 문자열 데이터를 표시한다
print(response.text)