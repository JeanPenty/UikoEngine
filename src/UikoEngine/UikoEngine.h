#ifndef __NSUIKOSKINENGINE_H__
#define __NSUIKOSKINENGINE_H__
#pragma once

#include "UIlib.h"
#include "stdafx.h"
#include "Uiko/pluginapi.h"
#include "Uiko/MsgDef.h"
#include <windows.h>

/* ������ 1. skin��·�������setup.exe���ɵ�·����
 *        2. skin�����ļ���
 *        3. ��װҳ��tab������
 * ���ܣ� ��ʼ������
*/
DLLEXPORT void InitDuiEngine(HWND hwndParent, int string_size, TCHAR *variables, stack_t **stacktop, extra_parameters *extra);

/* ������ 1. skin��·�������setup.exe���ɵ�·����
 *        2. skin�����ļ���
 * ���ܣ� ����
*/
DLLEXPORT void ReloadSkin(HWND hwndParent, int string_size, TCHAR *variables, stack_t **stacktop, extra_parameters *extra);

/* ������ 1. control������
 * ���ܣ� Ѱ���ض���control�Ƿ����
*/
DLLEXPORT void FindControl(HWND hwndParent, int string_size, char *variables, stack_t **stacktop, extra_parameters *extra);

/* ������ 1. ��click�¼���control������
 *        2. ���Э���ļ�����
 * ���ܣ� Ϊ�ؼ��󶨶�Ӧ���¼�����click��Ϣʱִ�ж�Ӧ����
*/
DLLEXPORT void BindControl(HWND hwndParent, int string_size, char *variables, stack_t **stacktop, extra_parameters *extra);


/* ������ 1. control������
 *        2. ����control������
 *        3. ���ݵ����� (�����ṩ�����������ͣ� 1. text; 2. bkimage; 3. link; 4. enable; 5.visible; 6.tooltip;)
 * ���ܣ� Ϊ�ؼ��󶨶�Ӧ���¼�����click��Ϣʱִ�ж�Ӧ����
*/
DLLEXPORT void SetControlData(HWND hwndParent, int string_size, char *variables, stack_t **stacktop, extra_parameters *extra);

/* ������ 1. control������
 *        2. ���ݵ����� (�����ṩһ���������ͣ� 1. text; 2.tooltip; 3.value )
 * ���ܣ� Ϊ�ؼ��󶨶�Ӧ���¼�����click��Ϣʱִ�ж�Ӧ����
*/
DLLEXPORT void GetControlData(HWND hwndParent, int string_size, char *variables, stack_t **stacktop, extra_parameters *extra);

/* ������ 1. Progress������
 *        2. ����Progress������
 *        3. ���ݵ����� (�����ṩ�����������ͣ� value )
 * ���ܣ� Ϊ�ؼ��󶨶�Ӧ���¼�����click��Ϣʱִ�ж�Ӧ����
*/
DLLEXPORT void SetProgressData(HWND hwndParent, int string_size, char *variables, stack_t **stacktop, extra_parameters *extra);

/* ������ 1. Progress������
 *        2. ���ݵ����� (�����ṩһ���������ͣ� value )
 * ���ܣ� Ϊ�ؼ��󶨶�Ӧ���¼�����click��Ϣʱִ�ж�Ӧ����
*/
DLLEXPORT void GetProgressData(HWND hwndParent, int string_size, char *variables, stack_t **stacktop, extra_parameters *extra);


DLLEXPORT void SetListData(HWND hwndParent, int string_size, char *variables, stack_t **stacktop, extra_parameters *extra);
DLLEXPORT void GetListData(HWND hwndParent, int string_size, char *variables, stack_t **stacktop, extra_parameters *extra);
DLLEXPORT void SetComboData(HWND hwndParent, int string_size, char *variables, stack_t **stacktop, extra_parameters *extra);
DLLEXPORT void GetComboData(HWND hwndParent, int string_size, char *variables, stack_t **stacktop, extra_parameters *extra);


/* ������ 1. ��ϢHWND
 *        2. ��ϢID
 *		  3. WPARAM
 *	      4. LPARAM
 * ���ܣ� ����Ϣ
*/
DLLEXPORT void DuiSendMessage(HWND hwndParent, int string_size, char *variables, stack_t **stacktop, extra_parameters *extra);

/* ������ 1. richedit control������
 *        2. ���Э���ļ�����
 * ���ܣ� ��ʾ���֤�ļ�
*/
DLLEXPORT void ShowLicense(HWND hwndParent, int string_size, char *variables, stack_t **stacktop, extra_parameters *extra);

/* ������ 1. ��ҳ�ؼ�������
 *        2. ��ҳ����
 * ���ܣ� ��ʾ��ҳ
*/
DLLEXPORT void ShowWebBrowser(HWND hwndParent, int string_size, char *variables, stack_t **stacktop, extra_parameters *extra);


/* ������ 1. TimerID(һ���ǻص�������ID)
 *        2. interval
 * ���ܣ� ������ʱ��
*/
DLLEXPORT void DuiCreatTimer(HWND hwndParent, int string_size, char *variables, stack_t **stacktop, extra_parameters *extra);

/* ������ 1. TimerID(һ���ǻص�������ID)
 * ���ܣ� ɱ����ʱ��
*/
DLLEXPORT void DuiKillTimer(HWND hwndParent, int string_size, char *variables, stack_t **stacktop, extra_parameters *extra);

/* ������ 1. ���⣨���磺 ��ѡ���ļ��У�
 * ���ܣ� ����Ϣ
*/
DLLEXPORT void SelectFolderDialog(HWND hwndParent, int string_size, char *variables, stack_t **stacktop, extra_parameters *extra);

/* ������ 1. ��Ӧ��ʼ��װ���ȵĽ���������
 * ���ܣ� ��ʼ��װ��Ӧ
*/
DLLEXPORT void StartInstall(HWND hwndParent, int string_size, char *variables, stack_t **stacktop, extra_parameters *extra);

/* ������ 1. ��Ӧ��ʼж�ؽ��ȵĽ���������
 * ���ܣ� ��ʼ��װ��Ӧ
*/
DLLEXPORT void StartUninstall(HWND hwndParent, int string_size, char *variables, stack_t **stacktop, extra_parameters *extra);

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
/*
 * ��������ʾ/���� ����ͼ��
 * ���ܣ�
*/
DLLEXPORT void ShowTrayIcon( HWND hwndParent, int string_size, char *variables, stack_t **stacktop, extra_parameters *extra );

/* ������ 1. ����
 * ���ܣ� ��ʼ������Ӧ
*/
DLLEXPORT void StartDownload(HWND hwndParent, int string_size, char *variables, stack_t **stacktop, extra_parameters *extra);

/* ������ 1. �����ļ���
 * ���ܣ� �����ļ���
*/
DLLEXPORT void CreateDir( HWND hwndParent, int string_size, char *variables, stack_t **stacktop, extra_parameters *extra );

/* ������ 1. ɾ���ļ���
 * ���ܣ� ɾ���ļ���
*/
DLLEXPORT void DeleteDir( HWND hwndParent, int string_size, char *variables, stack_t **stacktop, extra_parameters *extra );
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

/* ������ ��
 * ���ܣ� ���ô��ڴ�С
*/
DLLEXPORT void SetWndSize( HWND hwndParent, int string_size, char *variables, stack_t **stacktop, extra_parameters *extra );

/* ������ ��
 * ���ܣ� ���Debug��Ϣ
*/
DLLEXPORT void ShowDebugString( HWND hwndParent, int string_size, char *variables, stack_t **stacktop, extra_parameters *extra );

/* ������ ��
 * ���ܣ� ��ʾ���棨ע�⣺һ��������Show������
*/
DLLEXPORT void ShowPage(HWND hwndParent, int string_size, char *variables, stack_t **stacktop, extra_parameters *extra);

/* ������ ��
 * ���ܣ� ���ش���
*/
DLLEXPORT void DestroyDuiEngine(HWND hwndParent, int string_size, char *variables, stack_t **stacktop, extra_parameters *extra);

/* ������ ��
 * ���ܣ� �˳���װ
*/
DLLEXPORT void ExitDuiEngine(HWND hwndParent, int string_size, char *variables, stack_t **stacktop, extra_parameters *extra);


////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

/* ������ 1. �����ļ�������
 *        2. ����ؼ�����
 *		  3. ��ʾ���ݿؼ�����
 *		  4. �رհ�ť�ؼ�����
 *		  5. ȷ����ť�ؼ�����
 *		  6. ȡ����ť�ؼ�����
 * ���ܣ� ��ʼ��MessageBox
*/
DLLEXPORT void InitDuiEngineMsgBox(HWND hwndParent, int string_size, char *variables, stack_t **stacktop, extra_parameters *extra);

/* ������ 1. MessageBox(ѡ��yes no)
 * ���ܣ� 
*/
DLLEXPORT void DuiEngineMsgBox(HWND hwndParent, int string_size, char *variables, stack_t **stacktop, extra_parameters *extra);

#endif



