from PyQt5.QtWidgets import (QApplication, QMainWindow,
                             QPushButton, QLabel, QVBoxLayout, QWidget,QLineEdit)
import sys
from random import randint
class MainWindow(QMainWindow):
    def __init__(self):
        super().__init__()
        self.cnt=0
        self.list2=[]
        self.mainWidget= QWidget()
        self.mainLayout =QVBoxLayout(self.mainWidget)
        self.button = QPushButton("Push for Window")
        self.lineEdit = QLineEdit()
        self.mainLayout.addWidget(self.mainWidget)
        self.mainLayout.addWidget(self.button)
        self.mainLayout.addWidget(self.lineEdit)
        self.button.clicked.connect(self.show_new_window)
        self.setCentralWidget(self.mainWidget)
    def show_new_window(self, checked): # 버튼을 누를 때마다 여기 들어와요
        self.cnt+=1
        self.total = 0 # 지역변수이고 , __init__에 있게 되면 멤버변수에 계속 누적이 되는 것
        self.list2.append(self.cnt)
        for i in self.list2:
            self.total += i
        print('list2: ',self.list2,', cnt: ', self.cnt, ', total: ', self.total)
        self.lineEdit.setText(str(self.total))
app = QApplication(sys.argv)
w = MainWindow() #MainWindow객체 생성시 생성자에서 2개의 window 객체 생성
#멤버변수 cnt의 값이 3의 배수일 경우와 그렇지 않은 경우의 서로 다른 윈도우를 표시하고 다른
#윈도우는 종료함
w.show()
app.exec()