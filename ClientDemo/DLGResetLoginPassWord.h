#pragma once
#include "afxwin.h"


// CDLGResetLoginPassWord 对话框

class CDLGResetLoginPassWord : public CDialogEx
{
	DECLARE_DYNAMIC(CDLGResetLoginPassWord)

public:
	CDLGResetLoginPassWord(CWnd* pParent = NULL);   // 标准构造函数
	virtual ~CDLGResetLoginPassWord();

// 对话框数据
	enum { IDD = IDD_DLG_RESET_LOGIN_PASSWORD };

protected:
	virtual void DoDataExchange(CDataExchange* pDX);    // DDX/DDV 支持

	DECLARE_MESSAGE_MAP()
public:
    CString m_LoginPassWordCheck;
    LONG  m_lChannel;
    LONG m_lUserID;
    int m_iDeviceIndex;
    char m_szStatusBuf[ISAPI_STATUS_LEN];
    const int XML_ABILITY_OUT_LEN = 3 * 1024 * 1024;
    NET_DVR_LOGIN_PASSWORDCFG m_struLoginPassWord;
    afx_msg void OnBnClickedBtnLoginpwCheck();
    CComboBox m_dwIndex;
    CString m_sAnswer;
    BOOL m_bMark;
    afx_msg void OnBnClickedBtnGet();
    afx_msg void OnBnClickedBtnSet();
    CComboBox m_dwIndex2;
    CString m_sAnswer2;
    BOOL m_bMark2;
    BOOL m_bMark3;
    CString m_sAnswer3;
    CComboBox m_dwIndex3;
    CString m_csFilePath;
    afx_msg void OnBnClickedBtnFilePath();
    afx_msg void OnBnClickedBtnFileDownload();
    LONG    m_lDownloadHandle;
    BOOL    m_bDownLoading;
    HANDLE	m_hDownloadThread;
    afx_msg void OnBnClickedBtnManualCheck();
};
