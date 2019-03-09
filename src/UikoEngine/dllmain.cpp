//************************************************************
//  UikoEngine - NSIS UI Library
//
//  File: dllmain.cpp
//  Version: 2.0.0.2001
//  CreateDate: 2013-01-04
//  LastDate: 2015-09-03
//
//  Author: Garfield 
//
//  Copyright (c) 2012-2015, Uiko Develop Team (www.uiko.cn).
//  All Rights Reserved.
//************************************************************

#include "stdafx.h"
#include "UIlib.h"
#include <atlstr.h>

HINSTANCE g_hInstance;

//��Ȩ����
BOOL ProvidesRight()
{
	HANDLE hToken;
	BOOL fOK = FALSE;
	if(OpenProcessToken(GetCurrentProcess(), TOKEN_ADJUST_PRIVILEGES, &hToken))
	{
		TOKEN_PRIVILEGES tp;
		tp.PrivilegeCount = 1;
		if(!LookupPrivilegeValue(NULL, SE_DEBUG_NAME, &tp.Privileges[0].Luid))
		{
			printf("Can't lookup privilege value.\n");
			OutputDebugString(_T("Can't lookup privilege value.\n"));
		}
		tp.Privileges[0].Attributes=SE_PRIVILEGE_ENABLED;
		if( !AdjustTokenPrivileges(hToken, FALSE, &tp, sizeof(tp), NULL, NULL))
		{
			printf("Can't adjust privilege value.\n");
			OutputDebugString(_T("Can't adjust privilege value.\n"));
		}
		fOK = ( GetLastError() == ERROR_SUCCESS );
		CloseHandle(hToken);
	}
	return fOK;
}

BOOL WINAPI DllMain(HANDLE hInst, ULONG ul_reason_for_call, LPVOID lpReserved)
{
	g_hInstance = (HINSTANCE) hInst;

#ifdef _DEBUG
 	if (ul_reason_for_call == DLL_PROCESS_ATTACH)
 		MessageBox( 0, _T("DEBUG"), _T("dui-DllMain"), 0 );
#endif

	//��Ȩ����
    if (ProvidesRight() == FALSE)
    {
	    //AfxMessageBox(_T("��Ȩʧ�ܣ��������ϵͳ����ԱȨ�����д˳��򣬿��ܸ��»�ʧ�ܣ�"));
	    int err = GetLastError();
	    
	    CString csLastError;
	    csLastError.Format(_T("��Ȩʧ�ܣ�����ϵͳ����ԱȨ�ޣ���װ���ܻ�ʧ�ܣ� Error=%d"), err);
	    OutputDebugString(csLastError);
    }

    return TRUE;
}

