#pragma once
#include "afxwin.h"


// CDlgAcsWorkModeCfg 对话框

class CDlgAcsWorkModeCfg : public CDialogEx
{
	DECLARE_DYNAMIC(CDlgAcsWorkModeCfg)

public:
	CDlgAcsWorkModeCfg(CWnd* pParent = NULL);   // 标准构造函数
	virtual ~CDlgAcsWorkModeCfg();

// 对话框数据
	enum { IDD = IDD_DLG_ACS_WORKMODE_CFG };

protected:
	virtual void DoDataExchange(CDataExchange* pDX);    // DDX/DDV 支持

	DECLARE_MESSAGE_MAP()
public:
    afx_msg void OnBnClickedButtonGet();
    afx_msg void OnBnClickedButtonSet();
    CComboBox m_cmbWorkMode;
    virtual BOOL OnInitDialog();

    LONG m_lUserID;
    int m_iDeviceIndex;
    char *m_pOutBuf;
    BOOL CreateWorkModeCfg(char* pBuf, DWORD dwBufLen, int &dwRet);
};
