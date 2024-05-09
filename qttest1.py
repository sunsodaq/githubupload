from PyQt5.QtWidgets import (QApplication, QMainWindow,
                             QPushButton, QLabel, QVBoxLayout, QWidget,QLineEdit)
import sys
from random import randint
class AnotherWindow(QWidget):
    def __init__(self):
        super().__init__()
        layout = QVBoxLayout()
        self.label = QLabel()
        layout.addWidget(self.label)
        self.setLayout(layout)

    def update_label(self):
        self.label.setText("another  window %d " % randint(0,100))
class TheOtherWindow(QWidget):
    def __init__(self):
        super().__init__()
        layout = QVBoxLayout()# 레이아웃을 수직(Vertical) 으로 정렬함
        self.label = QLabel()
        layout.addWidget(self.label) #레이아웃에 위젯(label) 추가
        self.setLayout(layout)#TheOtherWindow 에 layout 추가
    def update_label(self):
        self.label.setText("The other window %d " %randint(70,800))

class MainWindow(QMainWindow):
    def __init__(self):
        super().__init__()
        self.cnt=0
        self.list2=[]
        self.w1 = AnotherWindow()  # No external window yet.
        self.w2 = TheOtherWindow()  # No external window yet.
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
        self.cnt+=1 # 클래스의 멤버변수 값이 1씩 증가
        self.total=0
        for i in self.list2: # list2에는 문자열로 저장되어 있고
            self.total += int(i) # 더하기를 하기 위해서 정수로 변환하여 총합을 구하고
        print(self.cnt)
        self.list2.append(str(self.cnt)) # cnt 값이 문자열로 변환되어
        # 멤버변수인 list2에 추가됨
        if self.cnt%3==0: # 구해진 총합을 문자열로 변환하여 lineEdit에 추가함
            self.lineEdit.setText(str(self.total)) #리스트의 총합을 추가하는 코드로 변경
            self.w1.close()
            self.w2.update_label()#초기 라벨은 기본값이고 호출될때 라벨의 값을 변경함
            self.w2.show()
        if len(self.list2) >=20:
            self.list2=[]
        else:
            self.w2.close()
            self.w1.update_label()
            self.w1.show()
app = QApplication(sys.argv)
w = MainWindow() #MainWindow객체 생성시 생성자에서 2개의 window 객체 생성
#멤버변수 cnt의 값이 3의 배수일 경우와 그렇지 않은 경우의 서로 다른 윈도우를 표시하고 다른
#윈도우는 종료함
w.show()
app.exec()