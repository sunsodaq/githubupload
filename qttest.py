import sys
from PyQt5.QtWidgets import  QApplication, QWidget

class MyApp(QWidget):
    def __init__(self, width, height, m_w, m_h):
        super().__init__()
        self.initUI(width, height,m_w, m_h)
    def initUI(self, w, h, m_w, m_h):
        self.setWindowTitle("나의 첫번째 어플리케이션")
        self.move(m_w, m_h)
        self.resize(w,h)
        self.show()

if __name__=='__main__':
    app=QApplication(sys.argv)
    for i in range(5):
        ex=MyApp(50*i,30*i, 200,300)
    sys.exit(app.exec_())