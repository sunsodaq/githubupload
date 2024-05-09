import os
import sys
import urllib.request
import datetime
import time
import json
import pandas as pd
from dotenv import load_dotenv
load_dotenv()
ServiceKey = os.getenv('ServiceKey')
serviceKey = ServiceKey

def getRequestUrl(url):
    req = urllib.request.Request(url)
    try:
        response = urllib.request.urlopen(req)
        if response.getCode()==200:
            print("[%s] url Request 성공 " %datetime.datetime.now())
            return response.read().decode('utf-8')
    except Exception as e:
        print(e)
        print("[%s] Error for Url :%s " % (datetime.datetime.now(), url))
        return None
def getTourismStatsItem(yyyymm, national_code, ed_cd):
    service_url = "http://openapi.tour.go.kr/openapi/service/EdrcntTourismStatsServicee/getEdrcntTourismStatsList"
    parameters = "?_type=json&serviceKey="+serviceKey
    parameters += "&YM="+yyyymm
    parameters += "&NAT_CD=" + national_code
    parameters += "&ED_CD="+ed_cd
    url = service_url + parameters
    retDate = getRequestUrl(url)
    if (retDate == None) : return None
    else : return json.loads(retDate)

def getTourismStatsService(nat_cd, ed_cd, nStartYear, nEndYear):
    jsonResult = {}
    result = []
    natName=''
    dateEnd = "{0}{1:0>2}".format(str(nEndYear), str(12)) # 데이터 끝 초기화
    isDataEnd = 0 # 데이터 끝 확인용 flag 초기화
    for year in range(nStartYear, nEndYear+1):
        for month in range(1,13):
            if (isDataEnd==1):break # 데이터 끝 flag 설정되어있으면 작업 중지
            yyyymm="{0} {1:0>2}".format(str(year),str(month))
            jsonData = getTourismStatsItem(yyyymm, nat_cd, ed_cd)
            if(jsonData['response']['header']['resultMsg']=='OK'):
                # 입력된 범위까지 수집하지 않았지만 더이상 제공되는 데이터가 없는 마지막 항목인 경우
                if jsonData['response']['body']['items'] =='':
                    isDataEnd =1 # 데이터 끝 flag 설정
                    dateEnd = "{0} {1:0>2}".format(str(year),str(month-1))
                    print("데이터 없음 ...\n 제공되는 통계데이터는 %s년 %s월 까지 입니다"%(str(year), str(month-1)))
                    break
            #jsonData를 출력하여 확인 .........................
            print(json.dumps(jsonData, indent=4, sort_keys=True, ensure_ascii=False))
            natName = jsonData['response']['body']['items']['item']['natKorNm']
            natName = natName.replace(' ','')
            num = jsonData['response']['body']['items']['item']['num']
            ed = jsonData['response']['body']['items']['item']['ed']
            print('[%s %s : %s]' %(natName, nat_cd, yyyymm, num))
    return (jsonResult, result, natName, ed, dateEnd)

def main():
    jsonResult = {}
    result = []
    natName=''
    print("<< 국내 입국한 외국인의 통계 데이터를 수집합니다 >>")
    nat_cd = input('국가 코드를 입력하세요 (중국:112/일본:130/미국:275)')
    nStartYear = int(input('데이터를 몇 년부터 수집할까요?'))
    nEndYear = int(input('데이터를 몇 년까지 수집할까요?'))
    ed_cd = "E"  # 방한 외래 관광객, D : 해외 출국
    jsonResult, result, natName, ed, dateEnd = getTourismStatsService(nat_cd, ed_cd, nStartYear, nEndYear)
    if(natName==''): #url 요청은 성공하였지만 데이터 제공이 안 된 경우
        print('데이터가 전달되지 않았습니다. 공공 데이터 포털 서비스의 상태를 확인하시기 바랍니다.')
    else:
        #파일 저장 1: JSON 파일
        with open('./%s_%s_%d_%s.json' %(natName, ed, nStartYear, dateEnd),'w', encoding='utf-8') as outfile:
            jsonFile = json.dumps(jsonResult, indent=4, sort_keys=True, ensure_ascii=False)
            outfile.write(jsonFile)
        #파일 저장 2: csv 파일
        columns = ['입국자국가', '국가코드', '입국연월', '입국자 수']
        result_df = pd.DataFrame(result, columns=columns)
        result_df.to_csv('./%s_%s_%d_%s.csv' %(natName, ed, nStartYear, dateEnd),index=False,encoding='cp949')

if __name__=='__main__':
    main()





