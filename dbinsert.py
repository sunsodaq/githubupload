import MySQLdb
from flask import render_template, request
from app import app
import os


db=MySQLdb.connect(host='localhost', user='root', password='1234', db='izen')
cur = db.cursor()

sql = "insert into score_tbl( math, eng, korea, total, avg, grade) values (%s, %s, %s, %s, %s, %s)"

@app.route("/")
def hello_world():
    return render_template('3.html')

def getTotalAndAvg(i):
    return (sum(i), sum(i)/len(i))

def calcGrade(i):
    if i>=90:return '수'
    elif i>=80: return '우'
    elif i>=70: return '미'
    elif i>=60: return '양'
    else: return '가'

@app.route("/dbinput", methods=['POST','GET'])
def hello_db():
    if request.method == 'POST':
        result = request.form;
        print('result: ', result)
        dict_score = result.to_dict()
        # print('result_0: ', dict_score)
        t=tuple()
        for i in dict_score.keys():
            # print('inner for ', dict_score[i])
            t += (int(dict_score[i]),)
        total, avg = getTotalAndAvg(t)
        t += (total, avg, calcGrade(avg))
        print('t:',t)
        cur.execute(sql, t)
    db.commit()
    return render_template('2.html')

if __name__ == "__main__":
    app.run("0.0.0.0", port=os.getenv('PORT', 6969))