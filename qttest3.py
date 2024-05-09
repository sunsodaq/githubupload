from PyQt5.QtWidgets import (QApplication, QMainWindow,
                             QPushButton, QLabel, QVBoxLayout, QWidget,QLineEdit,QPlainTextEdit)
import sys
from random import randint

class MainWindow(QMainWindow): # QMainWindow 상속
    def __init__(self):
        super().__init__()
        self.mainWidget = QWidget() # 위젯 객체를 생성 후 member 변수(mainWidget)에 저장
        self.listMul=[] # 더하기를 위한 리스트를 멤버변수로 선언
        self.listAdd=[] # 곱하기를 위한 리스트를 멤버변수로 선언
        self.mainLayout =QVBoxLayout(self.mainWidget) #vertical로 layout을 하겠다
        self.buttonMul = QPushButton("누적 곱하기") # 누르기 버튼 객체 생성 (곱하기)
        self.buttonSum = QPushButton("누적 합") # 누르기 버튼 객체 생성 (더하기)
        self.guguBtn = QPushButton("구구단") # 누르기 버튼 객체 생성 (구구단)
        self.textbox = QPlainTextEdit("2*1"+str(2*1)+"="+"2\n2*2"+str(2*2)+"="+"4\n ")
        self.lineEditMul = QLineEdit()
        self.lineEditSum = QLineEdit()
        self.guguEdit = QLineEdit()
        self.mainLayout.addWidget(self.mainWidget) # 레이아웃에 위젯(아이콘)을 추가
        self.mainLayout.addWidget(self.buttonMul) # 레이아웃에 위젯(아이콘)을 추가
        self.mainLayout.addWidget(self.buttonSum) # 레이아웃에 위젯(아이콘)을 추가
        self.mainLayout.addWidget(self.guguBtn) # 레이아웃에 위젯(아이콘)을 추가
        self.mainLayout.addWidget(self.lineEditMul)
        self.mainLayout.addWidget(self.lineEditSum)
        self.mainLayout.addWidget(self.textbox)
        self.buttonMul.clicked.connect(self.mul) # self.buttonMul 버튼을 함수 mul 과 연결 (jquery의 on과 동일)
        self.buttonSum.clicked.connect(self.add) # 버튼 위젯이 눌리면 add 함수 호출 되도록 연결
        self.guguBtn.clicked.connect(self.gugu)
        self.setCentralWidget(self.mainWidget)# 위젯이 쌓여있는 레이아웃을 중앙에 배치하겠다
        self.textbox.setPlainText("asdf\nasdfe")
    def mul(self, checked): # 버튼을 누를 때마다 여기 들어와요
        print('mul버튼이 눌렸어요', self.lineEditMul.text()) # lineEditMul의 내용을 읽어오는 것은 jquery의 text()메서드와 동일
        self.listMul.append(self.lineEditMul.text())
        self.total = 0
        if len(self.listMul)>=5: # 리스트에 5개가 들어가면 아래의 코드를 실행하고
            for i in self.listMul:
                self.total *= int(i)
            self.listMul=[] # 여기서 list를 초기화함
            self.lineEditMul.setText("리스트의 누적 곱 : "+str(self.total))

    def add(self, checked):
        print('add버튼이 눌렸어요', self.lineEditSum.text())
        self.listAdd.append(self.lineEditSum.text())
        self.total = 0
        if len(self.listAdd)>=5: # 리스트에 5개가 들어가면 아래의 코드를 실행하고
            for i in self.listAdd:
                self.total *= int(i)
            self.listAdd=[] # 여기서 list를 초기화함
            self.lineEditSum.setText("리스트의 누적 합 : "+str(self.total))
    def gugu(self):
        print("구구단이 눌렸습니다")
        str=""
        str_1=self.listAdd.pop()
        print(str_1, type(str_1))
        str+="\n".join([f"{str_1} x {i} = {int(str_1)*i}" for i in range(1,10)])
        print(str)
        self.textbox.setPlainText(str)



app = QApplication(sys.argv)
w = MainWindow() #MainWindow객체 생성시 생성자에서 2개의 window 객체 생성
#멤버변수 cnt의 값이 3의 배수일 경우와 그렇지 않은 경우의 서로 다른 윈도우를 표시하고 다른
#윈도우는 종료함
w.show()
app.exec()