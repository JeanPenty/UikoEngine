/***********************************************************
*                     ����NSIS ANSI
*   file:   dui.nsi
*   author: Garfield
*   taobao: http://shop64088102.taobao.com 
*   version:4.0.1.1001
*   lastdate:2015-09-24
************************************************************/

# ��װ�����ʼ���峣��
!define PRODUCT_PACKTYPE              "Setup"                          # �������( Setup ��װ��/ Update ������)
!define PRODUCT_NAME                  "UikoEngine"                     # ��Ʒ����
!define PRODUCT_NAME_EN               "UikoEngine"                     # ��ƷӢ������
!define PRODUCT_NAME_MUTEX            "UikoEngine"                     # ��������
!define PRODUCT_VERSION               "1.0.0.1"                        # ����汾
!define PRODUCT_DISK                  "C:\"                            # Ĭ�ϰ�װ�̷�(C:\��D:\)
!define PRODUCT_DISKPATH              "Program Files"                  # Ĭ�ϰ�װĿ¼(game �� Program Files)
!define PRODUCT_PATH                  "UikoEngine"                     # ����װ·��(��װĿ¼)
!define PRODUCT_FILEPATH              "bin"                            # ������·��(��ǰĿ¼)
!define PRODUCT_SKINPATH              "skin"                           # Ƥ�����·��(��ǰĿ¼)
!define PRODUCT_SKINZIP               "skin.rdn"
!define PRODUCT_MAIN_EXE              "Browser.exe"                    # ��������
!define PRODUCT_MAIN_UNEXE            "uninst.exe"                     # ж��exe�ļ�
!define PRODUCT_MAIN_SHORTCUT_TOOLTIP "${PRODUCT_NAME}"                # ��ݷ�ʽ ��ʾ��Ϣ
!define PRODUCT_MAIN_SHORTCUT_ICO     "inst.ico"                       # ��ݷ�ʽ ico�ļ�(��װĿ¼��***.ico)
!define PRODUCT_MAIN_SHORTCUT_RUN     ""                               # ��ݷ�ʽ ���������в��� 
!define PRODUCT_MAIN_ICO              "${PRODUCT_SKINPATH}\inst.ico"          # ��װ��ico�ļ�
!define PRODUCT_MAIN_UNICO            "${PRODUCT_SKINPATH}\uninst.ico"        # ж�س���ico�ļ�

!include "dui.nsh"

/****** ��װ����02 ******/
Section "Install" Sec02
  
SectionEnd

/****** ж������02 ******/
Section "Uninstall" un.Sec02

	# ɾĿ¼
	dui::DeleteDirectory "$INSTDIR"
	
SectionEnd
