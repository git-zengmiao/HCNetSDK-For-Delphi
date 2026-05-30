#pragma once
#include "afxwin.h"
#include "afxdtctl.h"
#include "atltime.h"
#include "ATLComTime.h"


// CDlgUHFBasicInfo 对话框

class CDlgUHFBasicInfo : public CDialogEx
{
	DECLARE_DYNAMIC(CDlgUHFBasicInfo)

public:
	CDlgUHFBasicInfo(CWnd* pParent = NULL);   // 标准构造函数
	virtual ~CDlgUHFBasicInfo();

// 对话框数据
	enum { IDD = IDD_DLG_UHF_BASIC_INFO };

protected:
	virtual void DoDataExchange(CDataExchange* pDX);    // DDX/DDV 支持

	DECLARE_MESSAGE_MAP()
public:
    afx_msg void OnBnClickedButtonGet();
    afx_msg void OnBnClickedButtonSet();

    LONG m_lUserID;
    int m_iDeviceIndex;
    BOOL CreateUHFBasicInfo(char* pBuf, DWORD dwBufLen, int &dwRet);
    CComboBox m_comboReadWriteMode;
    CComboBox m_comboWorkFrequencyType;
    CComboBox m_comboWorkMode;
    int m_iOutputPower;
    int m_iRepeatLabelFilterTime;
    int m_iStartHour1;
    int m_iStartHour2;
    int m_iStartHour3;
    int m_iStartMinute1;
    int m_iStartMinute2;
    int m_iStartMinute3;
    int m_iStopHour1;
    int m_iStopHour2;
    int m_iStopHour3;
    int m_iStopMinute1;
    int m_iStopMinute2;
    int m_iStopMinute3;
    afx_msg void OnBnClickedButtonGetTime();
    afx_msg void OnBnClickedButtonSetTime();
    COleDateTime m_ctDate;
    COleDateTime m_ctTime;
    COleDateTime m_ctDateMS;
    COleDateTime m_ctTimeMS;
    afx_msg void OnBnClickedButtonGetTimems();
    afx_msg void OnBnClickedButtonSetTimems();
    int m_iMS;
};
