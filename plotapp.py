from flask import Flask, render_template
import pandas as pd
import json
import plotly
import plotly.express as px
import MySQLdb

db=MySQLdb.connect(host='localhost', user='root', password='1234', db='izen')
cur = db.cursor()

app = Flask(__name__)

@app.route('/')
def bar_with_ploty():
    # Students data available in a list of list
    sql = "select * from graph_tbl";
    cur.execute(sql)
    datas = cur.fetchall();
    for i in datas:
        print(i);
    df = pd.DataFrame(datas, columns=['no','Name','Age','City','Country'], index=['a','b','c','d','e','f','g'])
    #Bar chart 생성
    fig = px.bar(df, x='Name', y='Age', color='City', barmode='group')

    #graphJson 생성
    graphJson = json.dumps(fig, cls=plotly.utils.PlotlyJSONEncoder)

    return render_template('bar.html', graphJson=graphJson)
if __name__ =='__main__':
    app.run(debug=True)