#pragma once
#include "afxwin.h"


// CDlgHiddenInfo 对话框

class CDlgHiddenInfo : public CDialogEx
{
	DECLARE_DYNAMIC(CDlgHiddenInfo)

public:
	CDlgHiddenInfo(CWnd* pParent = NULL);   // 标准构造函数
	virtual ~CDlgHiddenInfo();

// 对话框数据
	enum { IDD = IDD_DLG_HIDDEN_INFO_CFG };

protected:
	virtual void DoDataExchange(CDataExchange* pDX);    // DDX/DDV 支持
    afx_msg void OnBnClickedBtnSet();
    afx_msg void OnBnClickedBtnGet();
	DECLARE_MESSAGE_MAP()
public:

    int m_iUserID;
    int m_iDevIndex;
    int m_iChanNO;
    char m_szStatusBuf[ISAPI_STATUS_LEN];
    CComboBox m_cmbFuncType;
    CComboBox m_cmbEnabled;
    CString m_scKeyWordOne;
    CString m_scKeyWordTwo;
    CString m_scKeyWordThree;
    CComboBox m_cmbPosID;
    afx_msg void OnBnClickedCancel();
};
#pragma once
