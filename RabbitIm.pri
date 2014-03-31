SOURCES += main.cpp\
        MainWindow.cpp \
    Widgets/DlgLogin/DlgLogin.cpp \
    Widgets/DlgLogin/FrmLogin.cpp \
    XmppClient.cpp \
    Widgets/FrmUserList/FrmUserList.cpp \
    Widgets/FrmUserList/Roster.cpp \
    Widgets/FrmUserList/GroupItem.cpp \
    Widgets/FrmMessage/FrmMessage.cpp \
    Widgets/FrmMessage/Message.cpp \
    Global.cpp \
    Widgets/FrmRegister/FrmRegister.cpp \
    Widgets/FrmAbout/FrmAbout.cpp \
    Widgets/FrmVideo/FrmVideo.cpp

HEADERS  += MainWindow.h \
    Widgets/DlgLogin/DlgLogin.h \
    Widgets/DlgLogin/FrmLogin.h \
    XmppClient.h \
    Widgets/FrmUserList/FrmUserList.h \
    Widgets/FrmUserList/Roster.h \
    Widgets/FrmUserList/GroupItem.h \
    Widgets/FrmMessage/FrmMessage.h \
    Widgets/FrmMessage/Message.h \
    Global.h \
    Widgets/FrmRegister/FrmRegister.h \
    Widgets/FrmAbout/FrmAbout.h \
    Widgets/FrmVideo/FrmVideo.h

FORMS    += MainWindow.ui \
    Widgets/DlgLogin/DlgLogin.ui \
    Widgets/DlgLogin/FrmLogin.ui \
    Widgets/FrmUserList/FrmUserList.ui \
    Widgets/FrmMessage/FrmMessage.ui \
    Widgets/FrmRegister/FrmRegister.ui \
    Widgets/FrmAbout/FrmAbout.ui \
    Widgets/FrmVideo/FrmVideo.ui

RESOURCES += \
    Resource/Resource.qrc