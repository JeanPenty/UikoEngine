/***********************************************************
*                     ���NSISԴ��V4.0
*   file:   dui.nsh
*   author: Garfield
*   taobao: http://shop64088102.taobao.com 
*   version:4.0.0.1001
*   lastdate:2015-06-21
************************************************************/

;��װ�� ��ѹ�հ�
!system '>blank set/p=MSCF<nul'
!packhdr temp.dat 'cmd /c Copy /b temp.dat /b +blank&&del blank'
/*# UPX
!define HAVE_UPX 1
!ifdef HAVE_UPX
!packhdr tmp.dat "E:UPX\upx --best tmp.dat"
!endif
*/

;!define PRODUCT_WEB_AD                "http://.*/ad.html"                        # ��ҳ���
!define PRODUCT_WEB_SITE              "http://www.cdcdx.com/"                    # ��ɴ���ҳ
!define PRODUCT_WEB_LICENCE           "http://.*/license.html"                   # ����Э������ ��ʽ:"http://..."

!define PRODUCT_LANGUAGE              "2052"                                     # 2052-SimpChinese  1033-English
!define PRODUCT_COMMENTS              "UikoEngine"                               # ��עע��˵��
!define PRODUCT_PUBLISHER             "www.cdcdx.com"
!define PRODUCT_PUBLISHER_EN          "CDCDX.COM"
!define PRODUCT_PUBLISHER_SITE        "http://www.cdcdx.com"                     # ���й�˾����
!define PRODUCT_HELP_LINK             "http://www.cdcdx.com"                     # ��������
# ---------------------------------------------------------------------
!define PRODUCT_BRANDINGTEXT          "--��ɫ�޶���ľ��--��������ֹ��ѡ������"   # BrandingText
!define PRODUCT_ROOT_KEY              "HKLM"
!define PRODUCT_SUB_KEY               "Software\Microsoft\Windows\CurrentVersion\Uninstall\${PRODUCT_NAME_EN}"    # ע���·��

!define MUI_ICON                      "${PRODUCT_MAIN_ICO}"                      # ��װico
!define MUI_UNICON                    "${PRODUCT_MAIN_UNICO}"                    # ж��ico

# ѡ��ѹ����ʽ
SetCompressor /SOLID lzma             ;zlib\bzip2\lzma

# �����ͷ�ļ�
!include "MUI.nsh"
;!include "MUI2.nsh"
!include "LogicLib.nsh"
!include "WinMessages.nsh"
!include "FileFunc.nsh"
!include "WordFunc.nsh"
!include "Library.nsh"
!include "StrFunc.nsh"
!include "x64.nsh"
!include "UAC.nsh"

!AddPluginDir "."

Var Dialog               # �Զ������Ĵ��ھ��
Var MessageBoxHandle     # �Զ�����Ϣ������
Var DesktopIconState     # ��ӵ������ݷ�ʽ
Var QuickLaunchBarState  # ��ӵ����������
Var StartMenuState       # ��ӵ���ʼ�˵�
Var BootRunState         # ������������
Var RunNowState          # ������������
Var FreeSpaceSize
Var installPath
;Var timerID
;Var timerIDUninstall
;Var InstallValue
Var InstallState         # �ظ���װ״̬
Var LocalPath
Var PCOnline             # ����״̬
Var SystemTime           # ϵͳʱ��
Var WindowsVersion       # ϵͳ�汾

# �����dll
ReserveFile "${NSISDIR}\Plugins\inetc.dll"
ReserveFile "${NSISDIR}\Plugins\system.dll"
ReserveFile "${NSISDIR}\Plugins\TCP.dll"
ReserveFile "${NSISDIR}\Plugins\dui.dll"                               # ����NSISƤ�����

# ��װ�����������������
!insertmacro MUI_LANGUAGE "SimpChinese"
# ��װԤ�ͷ��ļ�
!insertmacro MUI_RESERVEFILE_INSTALLOPTIONS

VIProductVersion "${PRODUCT_VERSION}"                                  # �汾(�Ϸ���ʾ)
VIAddVersionKey /LANG=${PRODUCT_LANGUAGE}  "ProductName"       "${PRODUCT_NAME_EN}"         # ��Ʒ����
VIAddVersionKey /LANG=${PRODUCT_LANGUAGE}  "Contact"           "${PRODUCT_PUBLISHER}"       # ��˾(ͼ����ʾ)
VIAddVersionKey /LANG=${PRODUCT_LANGUAGE}  "Comments"          "${PRODUCT_COMMENTS}"        # ��עע��    VIAddVersionKey /LANG=${LANG_ID}
VIAddVersionKey /LANG=${PRODUCT_LANGUAGE}  "CompanyName"       "${PRODUCT_PUBLISHER}"       # ��˾(ͼ����ʾ)
VIAddVersionKey /LANG=${PRODUCT_LANGUAGE}  "LegalTrademarks"   "${PRODUCT_NAME}"            # �Ϸ��̱�
VIAddVersionKey /LANG=${PRODUCT_LANGUAGE}  "LegalCopyright"    "Copyright (C) ${PRODUCT_PUBLISHER_EN}. All Rights Reserved."    # ��Ȩ
VIAddVersionKey /LANG=${PRODUCT_LANGUAGE}  "FileDescription"   "${PRODUCT_NAME} ��װ����"   # �ļ�˵������(�Ϸ���ʾ)(ͼ����ʾ)
VIAddVersionKey /LANG=${PRODUCT_LANGUAGE}  "FileVersion"       "${PRODUCT_VERSION}"         # �ļ��汾
VIAddVersionKey /LANG=${PRODUCT_LANGUAGE}  "ProductVersion"    "${PRODUCT_VERSION}"         # ��Ʒ�汾
VIAddVersionKey /LANG=${PRODUCT_LANGUAGE}  "OriginalFilename"  "${PRODUCT_MAIN_EXE}"        # ԭ�ļ���


Name       "${PRODUCT_NAME}"                                           # ��ʾ�Ի���ı���
OutFile    "${PRODUCT_NAME}_${PRODUCT_PACKTYPE}.exe"                   # ����ļ��� _V${PRODUCT_VERSION}
#InstallDir "$PROGRAMFILES\${PRODUCT_PATH}"                             # Ĭ�ϰ�װ·�� C��
InstallDir "$LOCALAPPDATA\${PRODUCT_PATH}"                             # Ĭ�ϰ�װ·�� LOCALAPPDATA
InstallDirRegKey "${PRODUCT_ROOT_KEY}" "${PRODUCT_SUB_KEY}" "InstallPath"                   # �ϴΰ�װ·�� ע���
BrandingText "${PRODUCT_NAME}${PRODUCT_BRANDINGTEXT}"                  # ��Ȩ����

ShowInstDetails   show                                                 # ��ʾ��װ�����ϸ��      hide|show|nevershow
ShowUninstDetails show                                                 # ��ʾж�س����ϸ��      hide|show|nevershow
RequestExecutionLevel admin                                            # ����ԱȨ�� Vista/7/8 UAC
CRCCheck off

# -----------------------------�Զ���ҳ��------------------------------------
Page         custom     inst_UI
Page         instfiles  "" inst_Progress
UninstPage   custom     un.uninst_UI
UninstPage   instfiles  "" un.uninst_Progress

# -----------------------------��װ����------------------------------------

# ��װSection
Section "Install" Sec01
    ${If} $InstallState == "Cover"
        SetOutPath "$TEMP"
        Delete "$INSTDIR\*.*"
        RMDir /r "$INSTDIR"
    ${EndIf}
    
    # ���ư�װ�ļ�
    SetOutPath "$INSTDIR"
    SetOverwrite ifnewer
    
    File /r "${PRODUCT_FILEPATH}\*"
    
    SetOverwrite on
    SetRebootFlag false
    
SectionEnd

# ��ݷ�ʽ / ע���
Section -AdditionalIcons
    
    # ��ʼ�˵�
    SetShellVarContext current
    StrCmp $StartMenuState "1" "" +5
        CreateDirectory "$SMPROGRAMS\${PRODUCT_NAME}"
        CreateShortCut  "$SMPROGRAMS\${PRODUCT_NAME}.lnk" "$INSTDIR\${PRODUCT_MAIN_EXE}" "${PRODUCT_MAIN_SHORTCUT_RUN}" "" 0 SW_SHOWNORMAL "" "${PRODUCT_MAIN_SHORTCUT_TOOLTIP}"
        CreateShortCut  "$SMPROGRAMS\${PRODUCT_NAME}\${PRODUCT_NAME}.lnk"       "$INSTDIR\${PRODUCT_MAIN_EXE}" "${PRODUCT_MAIN_SHORTCUT_RUN}" "" 0 SW_SHOWNORMAL "" "${PRODUCT_MAIN_SHORTCUT_TOOLTIP}"
        CreateShortCut  "$SMPROGRAMS\${PRODUCT_NAME}\ж��${PRODUCT_NAME}.lnk"   "$INSTDIR\${PRODUCT_MAIN_UNEXE}" "" "" 0 SW_SHOWNORMAL "" "�����ʼж��"
    
    # �����ݷ�ʽ
    StrCmp $DesktopIconState "1" +1 +2
        CreateShortCut  "$DESKTOP\${PRODUCT_NAME}.lnk" "$INSTDIR\${PRODUCT_MAIN_EXE}" "${PRODUCT_MAIN_SHORTCUT_RUN}" "" 0 SW_SHOWNORMAL "" "${PRODUCT_MAIN_SHORTCUT_TOOLTIP}"
    
    # ��������ݷ�ʽ
    StrCmp $QuickLaunchBarState "1" +1 taskbar
        ReadRegStr $R0 HKLM "SOFTWARE\Microsoft\Windows NT\CurrentVersion" "CurrentVersion"
        ${if} $R0 >= 6.0  # Vista����  ����������
            CreateShortCut "$DESKTOP\${PRODUCT_NAME}.lnk" "$INSTDIR\${PRODUCT_MAIN_EXE}"
            ExecShell taskbarpin "$DESKTOP\${PRODUCT_NAME}.lnk"
            ExecShell startpin "$DESKTOP\${PRODUCT_NAME}.lnk"
        ${else}           # XP����  ����������
            IfFileExists "$QUICKLAUNCH\${PRODUCT_NAME}.lnk" 0 +2
                Delete "$QUICKLAUNCH\${PRODUCT_NAME}.lnk";
            CreateShortCut "$QUICKLAUNCH\${PRODUCT_NAME}.lnk" "$INSTDIR\${PRODUCT_MAIN_EXE}"
        ${Endif}
    taskbar:
    
    SetShellVarContext all
    
    Call GetSystemTime
    # ע�����Ϣ
    WriteUninstaller "$INSTDIR\${PRODUCT_MAIN_UNEXE}"
    WriteRegStr ${PRODUCT_ROOT_KEY} "${PRODUCT_SUB_KEY}" "BuildTime"       "$SystemTime"                    # ��װʱ��
    WriteRegStr ${PRODUCT_ROOT_KEY} "${PRODUCT_SUB_KEY}" "Contact"         "${PRODUCT_PUBLISHER}"           # ������
    WriteRegStr ${PRODUCT_ROOT_KEY} "${PRODUCT_SUB_KEY}" "Copyright"       "Copyright (C) ${PRODUCT_PUBLISHER_EN}. All Rights Reserved."   # ��Ȩ˵��
    WriteRegStr ${PRODUCT_ROOT_KEY} "${PRODUCT_SUB_KEY}" "DisplayIcon"     "$INSTDIR\${PRODUCT_MAIN_EXE}"   # ��������·��
    WriteRegStr ${PRODUCT_ROOT_KEY} "${PRODUCT_SUB_KEY}" "DisplayName"     "${PRODUCT_NAME}"                # ������
    WriteRegStr ${PRODUCT_ROOT_KEY} "${PRODUCT_SUB_KEY}" "DisplayNameEn"   "${PRODUCT_NAME_EN}"             # ����Ӣ����
    WriteRegStr ${PRODUCT_ROOT_KEY} "${PRODUCT_SUB_KEY}" "DisplayVersion"  "${PRODUCT_VERSION}"             # ����汾
    WriteRegStr ${PRODUCT_ROOT_KEY} "${PRODUCT_SUB_KEY}" "HelpLink"        "${PRODUCT_HELP_LINK}"           # ��������
    WriteRegStr ${PRODUCT_ROOT_KEY} "${PRODUCT_SUB_KEY}" "InstallDate"     "$SystemTime"                    # ��װʱ��
    WriteRegStr ${PRODUCT_ROOT_KEY} "${PRODUCT_SUB_KEY}" "InstallLocation" "$INSTDIR"                       # ��װĿ¼
    WriteRegStr ${PRODUCT_ROOT_KEY} "${PRODUCT_SUB_KEY}" "ProgramPath"     "$INSTDIR"                       # ��װĿ¼
    WriteRegStr ${PRODUCT_ROOT_KEY} "${PRODUCT_SUB_KEY}" "Publisher"       "${PRODUCT_PUBLISHER}"           # ������
    WriteRegStr ${PRODUCT_ROOT_KEY} "${PRODUCT_SUB_KEY}" "URLInfoAbout"    "${PRODUCT_PUBLISHER_SITE}"      # ��վ��Ϣ
    WriteRegStr ${PRODUCT_ROOT_KEY} "${PRODUCT_SUB_KEY}" "URLUpdateInfo"   "${PRODUCT_PUBLISHER_SITE}"      # ��վ��Ϣ
    WriteRegStr ${PRODUCT_ROOT_KEY} "${PRODUCT_SUB_KEY}" "UninstallString" "$INSTDIR\${PRODUCT_MAIN_UNEXE}" # ж�س�������·��
    
    # ��������
    WriteRegStr ${PRODUCT_ROOT_KEY} "${PRODUCT_SUB_KEY}" "SupportLink"     "http://shop64088102.taobao.com"            # ��������
    WriteRegStr ${PRODUCT_ROOT_KEY} "${PRODUCT_SUB_KEY}" "Support"         "Powered by UikoEngine"                     # ����֧��

SectionEnd

# ��װ�Զ������
Function inst_UI
    
    # ��ʼ������
    dui::InitDuiEngine /NOUNLOAD "$TEMP\${PRODUCT_NAME_EN}Setup" "${PRODUCT_SKINZIP}" "invalid_string_position" "inst.xml" "inst.ico" "inst_UITab" "${PRODUCT_NAME}" "false" "true"
    ;dui::InitDuiEngine /NOUNLOAD "$TEMP\${PRODUCT_NAME_EN}Setup" "inst.xml" "inst.ico" "inst_UITab" "${PRODUCT_NAME}" "false" "false"
    Pop $Dialog

    # ��ʼ��MessageBox����
    dui::InitDuiEngineMsgBox "msgbox.xml" "msgbox_lblTitle" "msgbox_edtText" "msgbox_btnClose" "msgbox_btnYes" "msgbox_btnNo" "true"
    Pop $MessageBoxHandle

    # ----------------------------��һ��ҳ��-----------------------------------------------
    
    # ȡ����ť�󶨺���
    dui::FindControl "inst_Welcome_btnClose"
    Pop $0
    ${If} $0 == "-1"
        MessageBox MB_OK "Do not have inst_Welcome_btnClose button"
    ${Else}
        GetFunctionAddress $0 onGlobalCancelFunc
        dui::BindControl "inst_Welcome_btnClose"  $0
    ${EndIf}
    
    # ���������ʾ�趨
    dui::FindControl "inst_Welcome_lblSoftName"
    Pop $0
    ${If} $0 == "-1"
        MessageBox MB_OK "Do not have inst_Welcome_lblSoftName button"
    ${Else}
        ;dui::SetControlData "inst_Welcome_lblSoftName"  ${PRODUCT_NAME} "text"
        dui::BindControl "inst_Welcome_lblSoftName" $0
    ${EndIf}
    
    # �鿴Э�����鰴ť�󶨺���
    dui::FindControl "inst_Welcome_btnLicence"
    Pop $0
    ${If} $0 == "-1"
        MessageBox MB_OK "Do not have inst_Welcome_btnLicence button"
    ${Else}
        GetFunctionAddress $0 onLicenseLinkBtnFunc
        dui::BindControl "inst_Welcome_btnLicence"  $0 
    ${EndIf}
    
    # �Ѿ��Ķ�Э�鰴ť�󶨺���
    dui::FindControl "inst_Welcome_btnAccept"
    Pop $0
    ${If} $0 == "-1"
        MessageBox MB_OK "Do not have inst_Welcome_btnAccept button"
    ${Else}
        GetFunctionAddress $0 onAcceptLicenceFunc    ;��װ�ؼ����ÿ���
        dui::BindControl "inst_Welcome_btnAccept"  $0 
    ${EndIf}
    
    # ���ٰ�װ��ť�󶨺���
    dui::FindControl "inst_Welcome_btnQuickInst"
    Pop $0
    ${If} $0 == "-1"
        MessageBox MB_OK "Do not have inst_Welcome_btnQuickInst button"
    ${Else}
        GetFunctionAddress $0 onQuickInstBtnFunc
        dui::BindControl "inst_Welcome_btnQuickInst"  $0
    ${EndIf}
    
    # ��һ����ť�󶨺���
    dui::FindControl "inst_Welcome_btnNext"
    Pop $0
    ${If} $0 == "-1"
        MessageBox MB_OK "Do not have inst_Welcome_btnNext button"
    ${Else}
        GetFunctionAddress $0 onNextBtnFunc
        dui::BindControl "inst_Welcome_btnNext"  $0
    ${EndIf}
    
    # ��һ����ť�󶨺���
    dui::FindControl "inst_Welcome_btnCover"
    Pop $0
    ${If} $0 == "-1"
        MessageBox MB_OK "Do not have inst_Welcome_btnCover button"
    ${Else}
        GetFunctionAddress $0 onNextBtnFunc
        dui::BindControl "inst_Welcome_btnCover"  $0
    ${EndIf}
    
    # ----------------------------�ڶ���ҳ��-----------------------------------------------
    
    # ȡ����ť�󶨺���
    dui::FindControl "inst_Option_btnClose"
    Pop $0
    ${If} $0 == "-1"
        MessageBox MB_OK "Do not have inst_Option_btnClose button"
    ${Else}
        GetFunctionAddress $0 onGlobalCancelFunc
        dui::BindControl "inst_Option_btnClose"  $0
    ${EndIf}
    
    # ���������ʾ�趨
    dui::FindControl "inst_Option_lblSoftName"
    Pop $0
    ${If} $0 == "-1"
        MessageBox MB_OK "Do not have inst_Option_lblSoftName button"
    ${Else}
        ;dui::SetControlData "inst_Option_lblSoftName"  ${PRODUCT_NAME} "text"
        dui::BindControl "inst_Option_lblSoftName" $0
    ${EndIf}
    
    # ���ô��̿ռ��趨����
    dui::FindControl "inst_Option_lblLastSpace"
    Pop $0
    ${If} $0 == "-1"
        MessageBox MB_OK "Do not have inst_Option_lblLastSpace button"
    ${Else}
        dui::SetControlData "inst_Option_lblLastSpace"  $FreeSpaceSize  "text"
    ${EndIf}
    
    # ��װ·���༭���趨����
    dui::FindControl "inst_Option_edtPath"
    Pop $0
    ${If} $0 == "-1"
        MessageBox MB_OK "Do not have inst_Option_btnOpenPath button"
    ${Else}
        dui::SetControlData "inst_Option_edtPath"  $installPath "text"
        GetFunctionAddress $0 onTextChangeFunc
        dui::BindControl "inst_Option_edtPath" $0
    ${EndIf}

    # ��װ·�������ť�󶨺���
    dui::FindControl "inst_Option_btnOpenPath"
    Pop $0
    ${If} $0 == "-1"
        MessageBox MB_OK "Do not have inst_Option_btnOpenPath button"
    ${Else}
        GetFunctionAddress $0 onInstallPathBrownBtnFunc
        dui::BindControl "inst_Option_btnOpenPath"  $0
    ${EndIf}

    # ������ʼ�˵��󶨺���
    dui::FindControl "inst_Option_btnStartMenu"
    Pop $0
    ${If} $0 == "-1"
        MessageBox MB_OK "Do not have inst_Option_btnStartMenu button"
    ${Else}
        StrCpy $StartMenuState "1"
        GetFunctionAddress $0 onStartMenuStateFunc
        dui::BindControl "inst_Option_btnStartMenu"  $0
    ${EndIf}

    # ���������ݷ�ʽ�󶨺���
    dui::FindControl "inst_Option_btnShortCut"
    Pop $0
    ${If} $0 == "-1"
        MessageBox MB_OK "Do not have inst_Option_btnShortCut button"
    ${Else}
        StrCpy $DesktopIconState "1"
        GetFunctionAddress $0 onDesktopIconStateFunc
        dui::BindControl "inst_Option_btnShortCut"  $0
    ${EndIf}

    # ������������ݷ�ʽ�󶨺���
    dui::FindControl "inst_Option_btnQuickLaunchBar"
    Pop $0
    ${If} $0 == "-1"
        MessageBox MB_OK "Do not have inst_Option_btnQuickLaunchBar button"
    ${Else}
        GetFunctionAddress $0 onQuickLaunchBarStateFunc
        dui::BindControl "inst_Option_btnQuickLaunchBar"  $0
    ${EndIf}
    
    # ������������󶨺���
    dui::FindControl "inst_Complete_btnBootRun"
    Pop $0
    ${If} $0 == "-1"
        MessageBox MB_OK "Do not have inst_Complete_btnBootRun button"
    ${Else}
        GetFunctionAddress $0 onBootRunStateFunc
        dui::BindControl "inst_Complete_btnBootRun"  $0
    ${EndIf}
    
    # ��ʼ��װ��ť�󶨺���
    dui::FindControl "inst_Option_btnStartInst"
    Pop $0
    ${If} $0 == "-1"
        MessageBox MB_OK "Do not have inst_Option_btnStartInst button"
    ${Else}
        GetFunctionAddress $0 onStartInstBtnFunc
        dui::BindControl "inst_Option_btnStartInst"  $0
    ${EndIf}
    
    # ��һ����ť�󶨺���
    dui::FindControl "inst_Option_btnBack"
    Pop $0
    ${If} $0 == "-1"
        MessageBox MB_OK "Do not have inst_Option_btnBack button"
    ${Else}
        GetFunctionAddress $0 onBackBtnFunc
        dui::BindControl "inst_Option_btnBack"  $0
    ${EndIf}
    
    # ----------------------------������ҳ��-----------------------------------------------
    
    # ���������ʾ�趨
    dui::FindControl "inst_Inst_lblSoftName"
    Pop $0
    ${If} $0 == "-1"
        MessageBox MB_OK "Do not have inst_Inst_lblSoftName button"
    ${Else}
        ;dui::SetControlData "inst_Inst_lblSoftName"  ${PRODUCT_NAME} "text"
        dui::BindControl "inst_Inst_lblSoftName" $0
    ${EndIf}
    
    # ȡ����ť�󶨺���
    dui::FindControl "inst_Inst_btnClose"
    Pop $0
    ${If} $0 == "-1"
        MessageBox MB_OK "Do not have inst_Inst_btnClose button"
    ${Else}
        GetFunctionAddress $0 onGlobalCancelFunc
        dui::BindControl "inst_Inst_btnClose"  $0
    ${EndIf}
    
    /*# ������������ʾ�󶨺���
    dui::FindControl "inst_Inst_lblPercent"
    Pop $0
    ${If} $0 == "-1"
        MessageBox MB_OK "Do not have inst_Inst_lblPercent button"
    ${Else}
        StrCpy $InstallValue  "0"
        GetFunctionAddress $timerID instProgressValue
        dui::DuiCreatTimer $timerID 1000  # callback interval
    ${EndIf}
    */
    # ----------------------------���ĸ�ҳ��-----------------------------------------------
    
    # ���������ʾ�趨
    dui::FindControl "inst_Complete_lblSoftName"
    Pop $0
    ${If} $0 == "-1"
        MessageBox MB_OK "Do not have inst_Complete_lblSoftName button"
    ${Else}
        ;dui::SetControlData "inst_Complete_lblSoftName"  ${PRODUCT_NAME} "text"
        dui::BindControl "inst_Complete_lblSoftName" $0
    ${EndIf}
    
    # ȡ����ť�󶨺���
    dui::FindControl "inst_Complete_btnClose"
    Pop $0
    ${If} $0 == "-1"
        MessageBox MB_OK "Do not have inst_Complete_btnClose button"
    ${Else}
        GetFunctionAddress $0 onFinishedBtnFunc
        dui::BindControl "inst_Complete_btnClose"  $0
    ${EndIf}
    
    # �鿴�ٷ���վ��ť�󶨺���
    dui::FindControl "inst_Complete_btnWebsite"
    Pop $0
    ${If} $0 == "-1"
        MessageBox MB_OK "Do not have inst_Complete_btnWebsite button"
    ${Else}
        GetFunctionAddress $0 onWebSiteLinkBtnFunc
        dui::BindControl "inst_Complete_btnWebsite"  $0 
    ${EndIf}
    
    # �������鰴ť�󶨺���
    dui::FindControl "inst_Complete_btnRun"
    Pop $0
    ${If} $0 == "-1"
        MessageBox MB_OK "Do not have inst_Complete_btnRun button"
    ${Else}
        GetFunctionAddress $0 onFinishedRunBtnFunc
        dui::BindControl "inst_Complete_btnRun"  $0
    ${EndIf}
    
    # ��װ��ɰ�ť�󶨺���
    dui::FindControl "inst_Complete_btnOK"
    Pop $0
    ${If} $0 == "-1"
        MessageBox MB_OK "Do not have inst_Complete_btnOK button"
    ${Else}
        GetFunctionAddress $0 onFinishedBtnFunc
        dui::BindControl "inst_Complete_btnOK"  $0
    ${EndIf}
    
    # ---------------------------------��ʾ------------------------------------------------
    
    ${If} $InstallState == "Cover"
        ReadRegStr $LocalPath ${PRODUCT_ROOT_KEY} ${PRODUCT_SUB_KEY} "InstallLocation"
        StrCmp $LocalPath "" +4 0
        dui::SetControlData "inst_Option_edtPath" $LocalPath "text"
        
        dui::SetControlData "inst_Option_edtPath" "false" "enable"
        dui::SetControlData "inst_Option_btnOpenPath" "false" "enable"
        ;dui::DuiSendMessage $Dialog WM_DUI_ENABLED "inst_Option_edtPath"
        ;dui::DuiSendMessage $Dialog WM_DUI_ENABLED "inst_Option_btnOpenPath"
    
        dui::SetControlData "inst_Option_btnStartInst" "��ʼ����" "text"
        dui::SetControlData "inst_Welcome_btnQuickInst" "���ٸ���" "text"
        dui::SetControlData "inst_Welcome_btnNext" "false" "visible"
        dui::SetControlData "inst_Welcome_btnCover" "true" "visible"
        ;dui::DuiSendMessage $Dialog WM_DUI_VISIBLE "inst_Welcome_btnNext"
    ${EndIf}
    ;-----------------------------------------------------------------------------------------
    
    dui::ShowPage
    
FunctionEnd

# ��װ��ʼ��
Function .onInit
    
    # 360��֤Ҫ����ʹ�þ�Ĭ����
    IfSilent 0 +2
    SetSilent normal
    
    # ������ʱĿ¼  $PLUGINSDIR
    InitPluginsDir
    ;MessageBox MB_OK "$PLUGINSDIR"
    
    # ��ⰲװ�����Ƿ����� ��������
    System::Call 'kernel32::CreateMutexA(i 0, i 0, t "${PRODUCT_NAME_MUTEX}Mutex") i .r1 ?e'
    Pop $R0
    StrCmp $R0 0 +3
        MessageBox MB_ICONINFORMATION "${PRODUCT_NAME} ��װ�����Ѿ����У�"
        Abort
    ;MessageBox::show MB_ICONINFORMATION "��ܰ��ʾ" "" "${PRODUCT_NAME} ��װ�����Ѿ����У�" "�ر�"
    
    # �������
    Call InternetOnline
    
    StrCpy $StartMenuState 1
    StrCpy $DesktopIconState 1
    StrCpy $QuickLaunchBarState 0
    StrCpy $BootRunState 0
    
    # Ĭ�ϰ�װ�̷� C��D��
    ;Push $R0
    ;${DriveSpace} ${PRODUCT_DISK} "/D=F /S=M" $R0
    ;${If} $R0 = null
    ;    StrCpy $INSTDIR "C:\${PRODUCT_DISKPATH}\${PRODUCT_PATH}"
    ;${Else}
    ;    StrCpy $INSTDIR "${PRODUCT_DISK}${PRODUCT_DISKPATH}\${PRODUCT_PATH}"
    ;${EndIf}
    ;Pop $R0
  
    # �ϴΰ�װ·�� ע���
    Push $R2
    ReadRegStr $R2 "${PRODUCT_ROOT_KEY}" "${PRODUCT_SUB_KEY}" "InstallPath"
    StrCmp $R2 "" +2 +1
        StrCpy $INSTDIR $R2
    Pop $R2
    
    # �ϴΰ�װ·�� ʣ��ռ����
    StrCpy $installPath $INSTDIR
    Call UpdateFreeSpace
    
    # �жϲ���ϵͳ
    Call GetWindowsVersion
    Pop $R0
    StrCmp $R0 "98"   done
    StrCmp $R0 "2000" done
    Goto End
    done:
        MessageBox MB_OK "�Բ���${PRODUCT_NAME}Ŀǰ��֧�ִ�ϵͳ��"
        Abort
    End:

    # ���汾
    ReadRegStr $0 ${PRODUCT_ROOT_KEY} "${PRODUCT_SUB_KEY}" "DisplayVersion"
    Var /Global local_check_version
    ${VersionCompare} "${PRODUCT_VERSION}" "$0" $local_check_version
    
    # ���ǰ�װ
    ${If} $0 != ""
        # ��ͬ�汾
        ${If} $local_check_version == "0"
            StrCmp $local_check_version "0" 0 +2
                StrCpy $InstallState "Cover"
                Goto CHECK_RUN
            StrCmp $local_check_version "0" 0 +4
            MessageBox MB_YESNO "���Ѿ���װ��ǰ�汾��${PRODUCT_NAME},�Ƿ񸲸ǰ�װ��" IDYES true IDNO false
            true:
                StrCpy $InstallState "Cover"
                Goto CHECK_RUN
            false:
                Quit
        # ��װ���汾�ϵ�
        ${ElseIf} $local_check_version == "2"
            MessageBox MB_OK|MB_ICONINFORMATION "���Ѿ���װ���°汾��${PRODUCT_NAME}���˾ɰ汾�޷���ɰ�װ��$\r$\n������װ����ж�����а汾��"
            Quit
        # ��װ���汾�ϸ�
        ${Else}
            Goto CHECK_RUN
        ${EndIf}
    ${EndIf}

CHECK_RUN:
    # �������Ƿ�������
    TCP::FindProc "${PRODUCT_MAIN_EXE}"
    IntCmp $R0 1 check uninst
    exit:
        Quit
    check:
        MessageBox MB_ICONQUESTION|MB_OKCANCEL|MB_DEFBUTTON2 "${PRODUCT_NAME}�������У���װ�޷����У����˳���������ԡ�$\r$\n�����ȷ���������������̣������ȡ�����˳���" IDCANCEL exit
        Push "${PRODUCT_MAIN_EXE}"
        Processwork::KillProcess
    uninst:
        ;MessageBox MB_ICONQUESTION|MB_YESNO|MB_DEFBUTTON2 "��ȷʵҪ��ȫ�Ƴ� $(^Name) ���������е������" IDYES +2  
        ;Abort
    
    # �����ö�
    FindWindow $0 "#32770" ""
    System::Call "user32::SetWindowPos(i r0, i -1,i 0,i 0,i 0,i 0,i 3)"
    BringToFront
    
    # �ͷ�Ƥ����Դ�ļ�
    SetOutPath $TEMP\${PRODUCT_NAME_EN}Setup
    File "${PRODUCT_SKINPATH}\${PRODUCT_SKINZIP}"
    ;File "${PRODUCT_SKINPATH}\*.png"
    ;File "${PRODUCT_SKINPATH}\*.ico"
    ;File "${PRODUCT_SKINPATH}\*.xml"
    ;File ".\${PRODUCT_SKINPATH}\*.txt"
    
FunctionEnd

# ��װ�ɹ�
Function .onInstSuccess
    
    # ���ش���
    HideWindow
    
    # ǿ���������� no
    StrCpy $RunNowState "0"
    
    # ������������
    StrCmp $BootRunState "1" +1 bootrun
        ReadRegStr $R0 HKLM "SOFTWARE\Microsoft\Windows NT\CurrentVersion" "CurrentVersion"
        ${if} $R0 >= 6.0  # Vista����
            ;CreateShortCut "$SMSTARTUP\${PRODUCT_NAME}.lnk" "$INSTDIR\${PRODUCT_MAIN_EXE}" "" "$INSTDIR\${PRODUCT_MAIN_EXE}" 0
            WriteRegStr HKLM  "Software\Microsoft\Windows\CurrentVersion\Run" "${PRODUCT_NAME_EN}"  "$INSTDIR\${PRODUCT_MAIN_EXE} hide"
        ${else}           # XP����
            ;CreateShortCut "$SMSTARTUP\${PRODUCT_NAME}.lnk" "$INSTDIR\${PRODUCT_MAIN_EXE}" "" "$INSTDIR\${PRODUCT_MAIN_EXE}" 0
            WriteRegStr HKLM  "Software\Microsoft\Windows\CurrentVersion\Run" "${PRODUCT_NAME_EN}"  "$INSTDIR\${PRODUCT_MAIN_EXE} hide"
        ${Endif}
    bootrun:
    
    # ���г���
    Call RunAfterInstall
    
FunctionEnd

# ȫ��ȡ��
Function onGlobalCancelFunc
    
    dui::DuiSendMessage $Dialog WM_DUI_CANCEL "${PRODUCT_NAME}" "ȷ��Ҫ�˳���װ��" "ȷ��" "ȡ��"
    Pop $0
    ;MessageBox MB_OK "$0"
    ${If} $0 == "0"
        # ���ش���
        dui::DestroyDuiEngine
        
        # ɾĿ¼
        dui::DeleteDirectory "$PLUGINSDIR"
        
        # �˳�����
        dui::ExitDuiEngine
        Abort
    ${EndIf}
    
FunctionEnd

# ��һ�� / ����
Function onBackBtnFunc
    dui::DuiSendMessage $Dialog WM_DUI_BACK
FunctionEnd

# ��һ��
Function onNextBtnFunc
    dui::DuiSendMessage $Dialog WM_DUI_NEXT
FunctionEnd
        
# ͬ�����Э��
Function onAcceptLicenceFunc
    dui::DuiSendMessage $Dialog WM_DUI_ENABLED "inst_Welcome_btnQuickInst"
    dui::DuiSendMessage $Dialog WM_DUI_ENABLED "inst_Welcome_btnNext"
    dui::DuiSendMessage $Dialog WM_DUI_ENABLED "inst_Welcome_btnCover"
FunctionEnd

# �����Э����ַ
Function onLicenseLinkBtnFunc
    dui::DuiSendMessage $Dialog WM_DUI_OPENURL ${PRODUCT_WEB_LICENCE}
    Pop $0
    ${If} $0 == "urlerror"
        MessageBox MB_OK "urlerror"
    ${EndIf}
FunctionEnd

# �򿪹ٷ���վ
Function onWebSiteLinkBtnFunc
    dui::DuiSendMessage $Dialog WM_DUI_OPENURL ${PRODUCT_PUBLISHER_SITE}
    Pop $0
    ${If} $0 == "url error"
        MessageBox MB_OK "url error"
    ${EndIf}
FunctionEnd

# -------------��ݷ�ʽ�������--------------------------------------

# ��ʼ�˵�
Function onStartMenuStateFunc
    dui::DuiSendMessage $Dialog WM_DUI_OPTIONSTATE "inst_Custom_btnStartMenu" ""
    Pop $0
    ${If} $0 == "1"
        StrCpy $StartMenuState "1"
    ${Else}
        StrCpy $StartMenuState "0"
    ${EndIf}
FunctionEnd

# �����ݷ�ʽ
Function onDesktopIconStateFunc
    dui::DuiSendMessage $Dialog WM_DUI_OPTIONSTATE "inst_Custom_btnShortCut" ""
    Pop $0
    ${If} $0 == "1"
        StrCpy $DesktopIconState "1"
    ${Else}
        StrCpy $DesktopIconState "0"
    ${EndIf}
FunctionEnd

# ��������ݷ�ʽ
Function onQuickLaunchBarStateFunc
    dui::DuiSendMessage $Dialog WM_DUI_OPTIONSTATE "inst_Option_btnQuickLaunchBar" ""
    Pop $1
    ${If} $1 == "1"
        StrCpy $QuickLaunchBarState "1"
    ${Else}
        StrCpy $QuickLaunchBarState "0"
    ${EndIf}
FunctionEnd

# ������������
Function onBootRunStateFunc

    dui::DuiSendMessage $Dialog WM_DUI_OPTIONSTATE "inst_Complete_btnBootRun" ""
    Pop $1
    ${If} $1 == "1"
        StrCpy $BootRunState "1"
    ${Else}
        StrCpy $BootRunState "0"
    ${EndIf}
    
FunctionEnd

# -------------��װ·��ѡ�����---------------------------------------
# ��װ·���䶯
Function onTextChangeFunc

    # �ı���ô��̿ռ��С
    dui::GetControlData inst_Option_edtPath "text"
    Pop $0
    ;MessageBox MB_OK $0
    StrCpy $INSTDIR $0

    # ���»�ȡ���̿ռ�
    Call UpdateFreeSpace

    # ���´��̿ռ��ı���ʾ
    dui::FindControl "inst_Option_lblLastSpace"
    Pop $0
    ${If} $0 == "-1"
        MessageBox MB_OK "Do not have inst_Option_lblLastSpace button"
    ${Else}
        ;dui::SetText2Control "inst_Option_lblLastSpace"  $FreeSpaceSize
        dui::SetControlData "inst_Option_lblLastSpace"  $FreeSpaceSize  "text"
    ${EndIf}
    
    # ·���Ƿ�Ϸ����Ϸ���Ϊ0Bytes��
    ${If} $FreeSpaceSize == "0Bytes"
        dui::SetControlData "inst_Option_btnStartInst" "false" "enable"
    ${Else}
        dui::SetControlData "inst_Option_btnStartInst" "true" "enable"
    ${EndIf}
FunctionEnd

# ѡ���ļ���
Function onInstallPathBrownBtnFunc

    dui::GetControlData "inst_Option_edtPath" "text"
    Pop $1
    dui::SelectFolderDialog "ѡ���ļ���" $1
    Pop $installPath
    ;MessageBox MB_OK $installPath
    ${If} $installPath == "-1"
        StrCpy $installPath $INSTDIR
    ${Else}
        StrCpy $installPath "$installPath\${PRODUCT_PATH}"
    ${EndIf}
    
    StrCpy $0 $installPath 
    
    ${If} $0 == "-1"
    ${Else}
        StrCpy $INSTDIR "$installPath"  ;\${PRODUCT_NAME_EN}"
        # ���ð�װ·���༭���ı�
        dui::FindControl "inst_Option_edtPath"
        Pop $0
        ${If} $0 == "-1"
            MessageBox MB_OK "Do not have inst_Option_btnOpenPath button"
        ${Else}
            StrCpy $installPath $INSTDIR
            dui::SetControlData "inst_Option_edtPath"  $installPath  "text"
        ${EndIf}
    ${EndIf}

    # ���»�ȡ���̿ռ�
    Call UpdateFreeSpace

    # ·���Ƿ�Ϸ����Ϸ���Ϊ0Bytes��
    ${If} $FreeSpaceSize == "0Bytes"
        dui::SetControlData "inst_Option_btnStartInst" "false" "enable"
    ${Else}
        dui::SetControlData "inst_Option_btnStartInst" "true" "enable"
    ${EndIf}

    # ���´��̿ռ��ı���ʾ
    dui::FindControl "inst_Option_lblLastSpace"
    Pop $0
    ${If} $0 == "-1"
        MessageBox MB_OK "Do not have inst_Option_lblLastSpace button"
    ${Else}
        ;dui::SetText2Control "inst_Option_lblLastSpace"  $FreeSpaceSize
        dui::SetControlData "inst_Option_lblLastSpace"  $FreeSpaceSize  "text"
    ${EndIf}
FunctionEnd

# ���»�ȡ���̿ռ�
Function UpdateFreeSpace
    ${GetRoot} $INSTDIR $0
    StrCpy $1 "Bytes"

    System::Call kernel32::GetDiskFreeSpaceEx(tr0,*l,*l,*l.r0)
    ${If} $0 > 1024
    ${OrIf} $0 < 0
        System::Int64Op $0 / 1024
        Pop $0
        StrCpy $1 "KB"
        ${If} $0 > 1024
        ${OrIf} $0 < 0
            System::Int64Op $0 / 1024
            Pop $0
            StrCpy $1 "MB"
            ${If} $0 > 1024
            ${OrIf} $0 < 0
                System::Int64Op $0 / 1024
                Pop $0
                StrCpy $1 "GB"
            ${EndIf}
        ${EndIf}
    ${EndIf}
    StrCpy $FreeSpaceSize  "$0$1 )"
FunctionEnd

# --------------��װ���----------------------------------------------
# ���ٰ�װ
Function onQuickInstBtnFunc
    
    # ��һ��
    Call onNextBtnFunc
    
    # �ж��Ƿ�����
    ;${if} $PCOnline == 200  # ����
    ;    ;dui::SetControlData "inst_Inst_Center" "false" "visible"
    ;    dui::SetControlData "inst_Inst_Center2" "true" "visible"
    ;    dui::ShowWebBrowser "ieWebBrowser" "${PRODUCT_WEB_AD}"     # "��ҳ�ؼ�����" "��ַ"
    ;${Endif}
    
    # ��ʼ��װ����
    dui::DuiSendMessage $Dialog WM_DUI_STARTINSTALL
    
    ;Call inst_Progress
    
FunctionEnd

# ��ʼ��װ
Function onStartInstBtnFunc
    
    # �ж��Ƿ�����
    ;${if} $PCOnline == 200  # ����
    ;    ;dui::SetControlData "inst_Inst_Center" "false" "visible"
    ;    dui::SetControlData "inst_Inst_Center2" "true" "visible"
    ;    dui::ShowWebBrowser "ieWebBrowser" "${PRODUCT_WEB_AD}"     # "��ҳ�ؼ�����" "��ַ"
    ;${Endif}
    
    # ���ٰ�װ����
    dui::DuiSendMessage $Dialog WM_DUI_STARTINSTALL
    
    ;Call inst_Progress
    
FunctionEnd

# ��װ������ʾ
Function inst_Progress
    
    # �������󶨺���
    dui::FindControl "inst_Inst_Progress"
    Pop $0
    ;MessageBox MB_OK "inst_Progress $0" 
    ${If} $0 == "-1"
        MessageBox MB_OK "Do not have inst_Inst_Progress button"
    ${Else}
        dui::StartInstall  "inst_Inst_Progress" "inst_Inst_lblPercent"
    ${EndIf}
    
    # ��һ��
    ;Call onNextBtnFunc
    
FunctionEnd

/*# ��װ����������ʾ
Function instProgressValue

    dui::GetProgressData inst_Inst_Progress "value"
    Pop $0
    StrCpy $R0 $0
    System::Int64Op $R0 / 300
    Pop $0
    StrCpy $R1 $0
    System::Int64Op $R0 % 300
    Pop $0
    StrCpy $R0 $0
    System::Int64Op $R0 / 30
    Pop $0
    StrCpy $InstallValue $R1.$0%
    
    # ��������ʾ����
    dui::FindControl "inst_Inst_lblPercent"
    Pop $0
    ${If} $0 == "-1"
        MessageBox MB_OK "Do not have inst_Inst_lblPercent button"
    ${Else}
        dui::SetControlData "inst_Inst_lblPercent"  $InstallValue  "text"
    ${EndIf}
    
FunctionEnd
*/

# ------------��װ������--------------------------------------------
# ��������
Function onFinishedRunBtnFunc
    
    # ǿ���������� yes
    StrCpy $RunNowState "1"
    
    # ������������
    dui::DuiSendMessage $Dialog WM_DUI_OPTIONSTATE "inst_Complete_btnBootRun" ""
    Pop $0
    ${If} $0 == "0"
        ReadRegStr $R0 HKLM "SOFTWARE\Microsoft\Windows NT\CurrentVersion" "CurrentVersion"
        ${if} $R0 >= 6.0  # Vista����
            ;MessageBox MB_OK "������������ - $R0 - ${PRODUCT_NAME_EN} - $INSTDIR\${PRODUCT_MAIN_EXE}"
            ;CreateShortCut "$SMSTARTUP\${PRODUCT_NAME}.lnk" "$INSTDIR\${PRODUCT_MAIN_EXE}" "" "$INSTDIR\${PRODUCT_MAIN_EXE}" 0
            WriteRegStr HKLM  "Software\Microsoft\Windows\CurrentVersion\Run" "${PRODUCT_NAME_EN}"  "$INSTDIR\${PRODUCT_MAIN_EXE} -autorun"
        ${else}           # XP����
            ;CreateShortCut "$SMSTARTUP\${PRODUCT_NAME}.lnk" "$INSTDIR\${PRODUCT_MAIN_EXE}" "" "$INSTDIR\${PRODUCT_MAIN_EXE}" 0
            WriteRegStr HKLM  "Software\Microsoft\Windows\CurrentVersion\Run" "${PRODUCT_NAME_EN}"  "$INSTDIR\${PRODUCT_MAIN_EXE} -autorun"
        ${Endif}
    ${Endif}
    
    # ���ش���
    dui::DestroyDuiEngine
    
    # ���г���
    Call RunAfterInstall
    
    # ����ҳ
    ;dui::DuiSendMessage $Dialog WM_DUI_OPENURL ${PRODUCT_WEB_SITE}
    
    # ������ʱ��
    ;dui::DuiKillTimer $timerID
    
    # ������װ
    dui::DuiSendMessage $Dialog WM_DUI_FINISHEDINSTALL
    
FunctionEnd

# ��װ���
Function onFinishedBtnFunc
    
    # ǿ���������� no
    StrCpy $RunNowState "0"
    
    # ������������
    dui::DuiSendMessage $Dialog WM_DUI_OPTIONSTATE "inst_Complete_btnBootRun" ""
    Pop $0
    ${If} $0 == "0"
        ReadRegStr $R0 HKLM "SOFTWARE\Microsoft\Windows NT\CurrentVersion" "CurrentVersion"
        ${if} $R0 >= 6.0  # Vista����
            ;MessageBox MB_OK "������������ - $R0 - ${PRODUCT_NAME_EN} - $INSTDIR\${PRODUCT_MAIN_EXE}"
            ;CreateShortCut "$SMSTARTUP\${PRODUCT_NAME}.lnk" "$INSTDIR\${PRODUCT_MAIN_EXE}" "" "$INSTDIR\${PRODUCT_MAIN_EXE}" 0
            WriteRegStr HKLM  "Software\Microsoft\Windows\CurrentVersion\Run" "${PRODUCT_NAME_EN}"  "$INSTDIR\${PRODUCT_MAIN_EXE} -autorun"
        ${else}           # XP����
            ;CreateShortCut "$SMSTARTUP\${PRODUCT_NAME}.lnk" "$INSTDIR\${PRODUCT_MAIN_EXE}" "" "$INSTDIR\${PRODUCT_MAIN_EXE}" 0
            WriteRegStr HKLM  "Software\Microsoft\Windows\CurrentVersion\Run" "${PRODUCT_NAME_EN}"  "$INSTDIR\${PRODUCT_MAIN_EXE} -autorun"
        ${Endif}
    ${Endif}
    
    # ���ش���
    dui::DestroyDuiEngine
    
    # ���г���
    Call RunAfterInstall
    
    # ����ҳ
    ;dui::DuiSendMessage $Dialog WM_DUI_OPENURL ${PRODUCT_WEB_SITE}
    
    # ������ʱ��
    ;dui::DuiKillTimer $timerID
    
    # ������װ
    dui::DuiSendMessage $Dialog WM_DUI_FINISHEDINSTALL
    
FunctionEnd

# ------------�������--------------------------------------------
# ���г���
Function RunAfterInstall
    StrCmp $RunNowState "1" "" +2
    Exec '"$INSTDIR\${PRODUCT_MAIN_EXE}"'
FunctionEnd

# �������
Function InternetOnline

    TCP::CheckURL "www.baidu.com"
    Pop $0
    ${if} $0 == 200         # �ٶ�����
        StrCpy $PCOnline 200
    ${else}                 # ������
        StrCpy $PCOnline 0
    ${Endif}
    ;MessageBox MB_OK "The URL returns: $0 $PCOnline"
    
FunctionEnd

# ϵͳʱ��
Function GetSystemTime
    # ��ȡϵͳʱ��
    System::Alloc 16
    System::Call "kernel32::GetLocalTime(isR0)"
    System::Call "*$R0(&i2.R1,&i2.R2,&i2.R3,&i2.R4,&i2.R5,&i2.R6,&i2.R7,&i2.R8)"
    System::Free $R0
    StrCpy $SystemTime "$R1-$R2-$R4,$R5:$R6:$R7";.$R8,����$R3"
    ;MessageBox MB_OK "$R1��$R2��$R4��,����$R3,$R5:$R6:$R7.$R8"
FunctionEnd

# ϵͳ�汾 ֧��Win10
Function GetWindowsVersion

    Push $R0
    Push $R1
    Push $R2
    
    ClearErrors
    ReadRegStr $R0 HKLM "SOFTWARE\Microsoft\Windows NT\CurrentVersion" "CurrentVersion" ;ProductName
    IfErrors 0 lbl_winnt
    # we are not NT
    ReadRegStr $R0 HKLM "SOFTWARE\Microsoft\Windows\CurrentVersion" "VersionNumber"
    StrCpy $R1 $R0 1
    StrCmp $R1 '4' 0 lbl_error
    StrCpy $R1 $R0 3
    StrCmp $R1 '4.0' lbl_win32_95
    StrCmp $R1 '4.9' lbl_win32_ME lbl_win32_98
lbl_win32_95:
    StrCpy $R0 '95'
    Goto lbl_done
lbl_win32_98:
    StrCpy $R0 '98'
    Goto lbl_done
lbl_win32_ME:
    StrCpy $R0 'ME'
    Goto lbl_done
lbl_winnt:
    # check if Windows is Client or Server.
    ReadRegStr $R2 HKLM "SOFTWARE\Microsoft\Windows NT\CurrentVersion" "InstallationType"
  
    StrCpy $R1 $R0 1
    StrCmp $R1 '3' lbl_winnt_x
    StrCmp $R1 '4' lbl_winnt_x
    StrCpy $R1 $R0 3
    StrCmp $R1 '5.0' lbl_winnt_2000
    StrCmp $R1 '5.1' lbl_winnt_XP
    StrCmp $R1 '5.2' lbl_winnt_2003
    StrCmp $R1 '6.0' lbl_winnt_vista_2008
    StrCmp $R1 '6.1' lbl_winnt_7_2008R2
    StrCmp $R1 '6.2' lbl_winnt_8_2012
    StrCmp $R1 '6.3' lbl_winnt_81_2012R2
    StrCmp $R1 '6.4' lbl_winnt_10_2016 ; the early Windows 10 tech previews used version 6.4
    StrCpy $R1 $R0 4
    StrCmp $R1 '10.0' lbl_winnt_10_2016
    Goto lbl_error

  lbl_winnt_x:
    StrCpy $R0 "NT $R0" 6
    Goto lbl_done
  lbl_winnt_2000:
    Strcpy $R0 '2000'
    Goto lbl_done
  lbl_winnt_XP:
    Strcpy $R0 'XP'
    Goto lbl_done
  lbl_winnt_2003:
    Strcpy $R0 '2003'
    Goto lbl_done
  ;----------------- Family - Vista / 2008 -------------
  lbl_winnt_vista_2008:
    StrCmp $R2 'Client' go_vista
    StrCmp $R2 'Server' go_2008
    go_vista:
      Strcpy $R0 'Vista'
      Goto lbl_done
    go_2008:
      Strcpy $R0 'Server2008'
      Goto lbl_done
  ;----------------- Family - 7 / 2008R2 -------------
  lbl_winnt_7_2008R2:
    StrCmp $R2 'Client' go_7
    StrCmp $R2 'Server' go_2008R2
    go_7:
      Strcpy $R0 'Win7'
      Goto lbl_done
    go_2008R2:
      Strcpy $R0 'Server2008R2'
      Goto lbl_done
  ;----------------- Family - 8 / 2012 -------------
  lbl_winnt_8_2012:
    StrCmp $R2 'Client' go_8
    StrCmp $R2 'Server' go_2012
    go_8:
      Strcpy $R0 'Win8'
      Goto lbl_done
    go_2012:
      Strcpy $R0 'Server2012'
      Goto lbl_done
  ;----------------- Family - 8.1 / 2012R2 -------------
  lbl_winnt_81_2012R2:
    StrCmp $R2 'Client' go_81
    StrCmp $R2 'Server' go_2012R2
    go_81:
      Strcpy $R0 'Win8.1'
      Goto lbl_done
    go_2012R2:
      Strcpy $R0 'Server2012R2'
      Goto lbl_done
  ;----------------- Family - 10 / 2016 -------------
  lbl_winnt_10_2016:
    StrCmp $R2 'Client' go_10
    StrCmp $R2 'Server' go_2016
    go_10:
      Strcpy $R0 'Win10.0'
      Goto lbl_done
    go_2016:
      Strcpy $R0 'Server2016'
      Goto lbl_done
  ;-----------------------------------------------------
lbl_error:
    StrCpy $R0 ''
lbl_done:
    Pop $R2
    Pop $R1
    StrCpy $WindowsVersion $R0
    
    GetVersion::WindowsPlatformArchitecture
    Pop $R2
    StrCpy $WindowsVersion "$WindowsVersion-$R2"
    Exch $R0
    
FunctionEnd

# --------------------------------------------------------------------------------------------------------------------

# -----------------------------ж�ز���------------------------------------

# ж��Section
Section "Uninstall" un.Sec01
    
    ;ReadRegStr $LocalPath ${PRODUCT_ROOT_KEY} ${PRODUCT_SUB_KEY} "InstallLocation"
    ;MessageBox MB_OK "$LocalPath"
    
    # ɾ��ע���
    DeleteRegKey ${PRODUCT_ROOT_KEY} "${PRODUCT_SUB_KEY}"
    DeleteRegKey /ifempty ${PRODUCT_ROOT_KEY} "${PRODUCT_SUB_KEY}"
    SetRebootFlag false

    # ɾ��������
    SetShellVarContext current
    ReadRegStr $R0 HKLM "SOFTWARE\Microsoft\Windows NT\CurrentVersion" "CurrentVersion"
    ${if} $R0 >= 6.0   # ɾ������������
        IfFileExists "$APPDATA\Microsoft\Internet Explorer\Quick Launch\User Pinned\TaskBar\${PRODUCT_NAME}.lnk" 0 +3
            ExecShell taskbarunpin "$APPDATA\Microsoft\Internet Explorer\Quick Launch\User Pinned\TaskBar\${PRODUCT_NAME}.lnk"
            ;ExecShell taskbarunpin "$DESKTOP\${PRODUCT_NAME}.lnk"
            ExecShell startunpin "$DESKTOP\${PRODUCT_NAME}.lnk"
            Delete "$APPDATA\Microsoft\Internet Explorer\Quick Launch\User Pinned\TaskBar\${PRODUCT_NAME}.lnk"
            Delete "$DESKTOP\${PRODUCT_NAME}.lnk"
    ${else}            # ɾ������������
        IfFileExists "$QUICKLAUNCH\${PRODUCT_NAME}.lnk" 0 +2
            Delete "$QUICKLAUNCH\${PRODUCT_NAME}.lnk";
    ${Endif}

    # �����ݷ�ʽ
    Delete "$DESKTOP\${PRODUCT_NAME}.lnk"
    Delete "$APPDATA\Microsoft\Internet Explorer\Quick Launch\User Pinned\TaskBar\${PRODUCT_NAME}.lnk"

    # ��ʼ�˵�
    Delete "$SMPROGRAMS\${PRODUCT_NAME}.lnk"
    Delete "$SMPROGRAMS\${PRODUCT_NAME}\${PRODUCT_NAME}.lnk"
    Delete "$SMPROGRAMS\${PRODUCT_NAME}\ж��${PRODUCT_NAME}.lnk"
    RMDir /r "$SMPROGRAMS\${PRODUCT_NAME}"
    SetShellVarContext all
    
    ;MessageBox MB_OK "$INSTDIR"
    # ɾ��װĿ¼
    SetOutPath "$TEMP"
    Delete "$INSTDIR\*.*"
    Delete "$INSTDIR\*"
    RMDir /r "$INSTDIR\*"
    RMDir /r "$INSTDIR"

    SetRebootFlag false
    SetAutoClose false
    
SectionEnd

# ж���Զ������
Function un.uninst_UI
    
    # �������uninst.xml
    IfFileExists "$TEMP\${PRODUCT_NAME_EN}Setup\${PRODUCT_SKINZIP}" +3 +1
        MessageBox MB_ICONQUESTION|MB_YESNO|MB_DEFBUTTON2 "��ȷʵҪ��ȫ�Ƴ� $(^Name)�����������" IDYES unshowpage IDNO +1
        Quit
    
    # ��ʼ������
    dui::InitDuiEngine /NOUNLOAD "$TEMP\${PRODUCT_NAME_EN}Setup" "${PRODUCT_SKINZIP}" "invalid_string_position" "uninst.xml" "uninst.ico" "uninst_UITab" "${PRODUCT_NAME}" "false" "true"
    ;dui::InitDuiEngine /NOUNLOAD "$TEMP\${PRODUCT_NAME_EN}Setup" "uninst.xml" "uninst.ico" "uninst_UITab" "${PRODUCT_NAME}" "false" "false"
    Pop $Dialog

    # ��ʼ��MessageBox����
    dui::InitDuiEngineMsgBox "msgbox.xml" "msgbox_lblTitle" "msgbox_edtText" "msgbox_btnClose" "msgbox_btnYes" "msgbox_btnNo" "false"
    Pop $MessageBoxHandle
    
    # -------------------------------------��ʼж��ҳ��------------------------------------
    
    # ȡ����ť�󶨺���
    dui::FindControl "uninst_Welcome_btnClose"
    Pop $0
    ${If} $0 == "-1"
        MessageBox MB_OK "Do not have uninst_Welcome_btnClose button"
    ${Else}
        GetFunctionAddress $0 un.onGlobalCancelFunc
        dui::BindControl "uninst_Welcome_btnClose"  $0
    ${EndIf}
    
    # ���������ʾ�趨
    dui::FindControl "uninst_Welcome_lblSoftName"
    Pop $0
    ${If} $0 == "-1"
        MessageBox MB_OK "Do not have uninst_Welcome_lblSoftName button"
    ${Else}
        ;dui::SetControlData "uninst_Welcome_lblSoftName"  ${PRODUCT_NAME} "text"
        dui::BindControl "uninst_Welcome_lblSoftName" $0
    ${EndIf}
    
    # ��ʼж�ذ�ť�󶨺���
    dui::FindControl "uninst_Welcome_btnStartUninst"
    Pop $0
    ${If} $0 == "-1"
        MessageBox MB_OK "Do not have uninst_Welcome_btnStartUninst button"
    ${Else}
        GetFunctionAddress $0 un.onStartUninstallBtnFunc
        dui::BindControl "uninst_Welcome_btnStartUninst"  $0
    ${EndIf}

    # ȡ����ť�󶨺���
    dui::FindControl "uninst_Welcome_btnCancel"
    Pop $0
    ${If} $0 == "-1"
        MessageBox MB_OK "Do not have uninst_Welcome_btnCancel button"
    ${Else}
        GetFunctionAddress $0 un.onGlobalCancelFunc
        dui::BindControl "uninst_Welcome_btnCancel"  $0
    ${EndIf}

    # --------------------------------�ڶ���ҳ��-------------------------------------------

    # ���������ʾ�趨
    dui::FindControl "uninst_Uninst_lblSoftName"
    Pop $0
    ${If} $0 == "-1"
        MessageBox MB_OK "Do not have uninst_Uninst_lblSoftName button"
    ${Else}
        ;dui::SetControlData "uninst_Uninst_lblSoftName"  ${PRODUCT_NAME} "text"
        dui::BindControl "uninst_Uninst_lblSoftName" $0
    ${EndIf}
    
    # ȡ����ť�󶨺���
    dui::FindControl "uninst_Uninst_btnClose"
    Pop $0
    ${If} $0 == "-1"
        MessageBox MB_OK "Do not have uninst_Uninst_btnClose button"
    ${Else}
        GetFunctionAddress $0 un.onGlobalCancelFunc
        dui::BindControl "uninst_Uninst_btnClose"  $0
    ${EndIf}
    
    
    /*# ������������ʾ�󶨺���
    dui::FindControl "uninst_Uninst_lblPercent"
    Pop $0
    ${If} $0 == "-1"
        MessageBox MB_OK "Do not have uninst_Uninst_lblPercent button"
    ${Else}
        StrCpy $InstallValue  "0"
        GetFunctionAddress $timerIDUninstall un.uninstProgressValue
        dui::DuiCreatTimer $timerIDUninstall 500  # callback interval
    ${EndIf}
    */
    
    # --------------------------------ж�����ҳ��----------------------------------------
    
    # ���������ʾ�趨
    dui::FindControl "uninst_Complete_lblSoftName"
    Pop $0
    ${If} $0 == "-1"
        MessageBox MB_OK "Do not have uninst_Complete_lblSoftName button"
    ${Else}
        ;dui::SetControlData "uninst_Complete_lblSoftName"  ${PRODUCT_NAME} "text"
        dui::BindControl "uninst_Complete_lblSoftName" $0
    ${EndIf}
    
    # ȡ����ť�󶨺���
    dui::FindControl "uninst_Complete_btnClose"
    Pop $0
    ${If} $0 == "-1"
        MessageBox MB_OK "Do not have uninst_Complete_btnClose button"
    ${Else}
        GetFunctionAddress $0 un.onUninstallFinishedBtnFunc
        dui::BindControl "uninst_Complete_btnClose"  $0
    ${EndIf}
    
    # ��ɰ�װ ��ť�󶨺���
    dui::FindControl "uninst_Complete_btnOK"
    Pop $0
    ${If} $0 == "-1"
        MessageBox MB_OK "Do not have uninst_Complete_btnOK button"
    ${Else}
        GetFunctionAddress $0 un.onUninstallFinishedBtnFunc
        dui::BindControl "uninst_Complete_btnOK"  $0
    ${EndIf}
    
    # ---------------------------------��ʾ------------------------------------------------
    
    dui::ShowPage
    
unshowpage:

FunctionEnd

# ж�س�ʼ��
Function un.onInit
    
    # 360��֤Ҫ����ʹ�þ�Ĭ����
    IfSilent 0 +2
    SetSilent normal
    
    # ������ʱĿ¼  $PLUGINSDIR
    InitPluginsDir
    ;MessageBox MB_OK "$PLUGINSDIR"
    
    # ���ж�س����Ƿ����� ��������
    System::Call 'kernel32::CreateMutexA(i 0, i 0, t "${PRODUCT_NAME_MUTEX}Mutex") i .r3 ?e'
    Pop $R0
    StrCmp $R0 0 +3
        MessageBox MB_ICONINFORMATION "${PRODUCT_NAME} ж�س����Ѿ����У�"
        Abort
    ;MessageBox::show MB_ICONINFORMATION "��ܰ��ʾ" "" "${PRODUCT_NAME} ж�س����Ѿ����У�" "�ر�"
    
    # �������
    Call un.unInternetOnline
    
    # ж�ؼ������Ƿ�������
    TCP::FindProc "${PRODUCT_MAIN_EXE}"
    IntCmp $R0 1 check uninst
    exit:
        Quit
    check:
        MessageBox MB_ICONQUESTION|MB_OKCANCEL|MB_DEFBUTTON2 "ж�س����⵽ ${PRODUCT_NAME} �������У����˳���������ԡ�$\r$\n�����ȷ���������������̣������ȡ�����˳���" IDCANCEL exit
        Push "${PRODUCT_MAIN_EXE}"
        Processwork::KillProcess
    uninst:
        ;MessageBox MB_ICONQUESTION|MB_YESNO|MB_DEFBUTTON2 "��ȷʵҪ��ȫ�Ƴ� $(^Name) ���������е������" IDYES +2  
        ;Abort
    
    # �����ö�
    FindWindow $0 "#32770" ""
    System::Call "user32::SetWindowPos(i r0, i -1,i 0,i 0,i 0,i 0,i 3)"
    BringToFront
    
    # �ͷ�Ƥ����Դ�ļ�
    SetOutPath $TEMP\${PRODUCT_NAME_EN}Setup
    File "${PRODUCT_SKINPATH}\${PRODUCT_SKINZIP}"
    ;File "${PRODUCT_SKINPATH}\*.png"
    ;File "${PRODUCT_SKINPATH}\*.ico"
    ;File "${PRODUCT_SKINPATH}\*.xml"
    ;File ".\${PRODUCT_SKINPATH}\*.txt"
    
FunctionEnd

# ж�سɹ�
Function un.onUninstSuccess
    
    # ���ش���
    HideWindow

    # ɾע���
    DeleteRegKey ${PRODUCT_ROOT_KEY} "${PRODUCT_SUB_KEY}"
    
    # ����ҳ
    dui::DuiSendMessage $Dialog WM_DUI_OPENURL ${PRODUCT_WEB_SITE}
    
FunctionEnd

# ж��ȫ��ȡ��
Function un.onGlobalCancelFunc

    # ���ش���
    dui::DestroyDuiEngine

    # ɾĿ¼
    dui::DeleteDirectory "$PLUGINSDIR"
    
    # �˳�����
    dui::ExitDuiEngine
    Abort
    
    /*# ȡ��ж��ʱ������ȷ��
    dui::DuiSendMessage $Dialog WM_DUI_CANCEL "${PRODUCT_NAME}" "ȷ��Ҫ�˳�ж�أ�" "ȷ��" "ȡ��"
    Pop $0
    ${If} $0 == "0
        Abort
        # �˳�����
        dui::ExitDuiEngine
    ${EndIf}
    */
    
FunctionEnd

# ��ʼж��
Function un.onStartUninstallBtnFunc
    
    # �ж��Ƿ�����
    ;${if} $PCOnline == 200  # ����
    ;    ;dui::SetControlData "uninst_Uninst_Center" "false" "visible"
    ;    dui::SetControlData "uninst_Uninst_Center2" "true" "visible"
    ;    dui::ShowWebBrowser "ieWebBrowser" "${PRODUCT_WEB_AD}"     # "��ҳ�ؼ�����" "��ַ"
    ;${Endif}
    
    # ��ʼж��
    dui::DuiSendMessage $Dialog WM_DUI_STARTUNINSTALL
    
    # ��һ��
    ;Call un.onNextBtnFunc
    
FunctionEnd

# ж�ؽ�����ʾ
Function un.uninst_Progress
    
    # �������uninst.xml
    IfFileExists "$TEMP\${PRODUCT_NAME_EN}Setup\${PRODUCT_SKINZIP}" +1 unshowpage2
    
    # �������󶨺���
    dui::FindControl "uninst_Uninst_Progress"
    Pop $0
    ${If} $0 == "-1"
            MessageBox MB_OK "Do not have uninst_Uninst_Progress button"
    ${Else}
            dui::StartUninstall  "uninst_Uninst_Progress" "uninst_Uninst_lblPercent"
    ${EndIf}
    
unshowpage2:

FunctionEnd

/*# ��װ����������ʾ
Function un.uninstProgressValue

    dui::GetProgressData uninst_Uninst_Progress "value"
    Pop $0
    StrCpy $R0 $0
    System::Int64Op $R0 / 300
    Pop $0
    StrCpy $R1 $0
    System::Int64Op $R0 % 300
    Pop $0
    StrCpy $R0 $0
    System::Int64Op $R0 / 30
    Pop $0
    StrCpy $InstallValue $R1.$0%
    
    
    # ��������ʾ����
    dui::FindControl "uninst_Uninst_lblPercent"
    Pop $0
    ${If} $0 == "-1"
        MessageBox MB_OK "Do not have uninst_Uninst_lblPercent button"
    ${Else}
        dui::SetControlData "uninst_Uninst_lblPercent"  $InstallValue  "text"
    ${EndIf}
    
FunctionEnd
*/

# �޸����/ж�����
Function un.onUninstallFinishedBtnFunc

    # ���ش���
    dui::DestroyDuiEngine
    
    # ɾƤ��Ŀ¼
    IfFileExists "$TEMP\${PRODUCT_NAME_EN}Setup\${PRODUCT_SKINZIP}" +1 +6
        Delete "$TEMP\${PRODUCT_NAME_EN}Setup\*.*"
        Delete "$TEMP\${PRODUCT_NAME_EN}Setup\*"
        Delete "$TEMP\${PRODUCT_NAME_EN}Setup\"
        RMDir "$TEMP\${PRODUCT_NAME_EN}Setup\"
        RMDir /r "$TEMP\${PRODUCT_NAME_EN}Setup\"
    
    # ����ҳ
    ;dui::DuiSendMessage $Dialog WM_DUI_OPENURL ${PRODUCT_WEB_SITE}
    
    # ������ʱ��
    ;dui::DuiKillTimer $timerIDUninstall
    
    # ������װ
    dui::DuiSendMessage $Dialog WM_DUI_FINISHEDUNINSTALL

    # �˳�����
    dui::ExitDuiEngine
    Abort
    
FunctionEnd

# �������
Function un.unInternetOnline

    TCP::CheckURL "www.baidu.com"
    Pop $0
    ${if} $0 == 200         # �ٶ�����
        StrCpy $PCOnline 200
    ${else}                 # ������
        StrCpy $PCOnline 0
    ${Endif}
    ;MessageBox MB_OK "The URL returns: $0 $PCOnline"
    
FunctionEnd
