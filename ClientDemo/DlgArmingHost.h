#pragma once
#include "afxwin.h"


// CDlgArmingHost 对话框

class CDlgArmingHost : public CDialog
{
    DECLARE_DYNAMIC(CDlgArmingHost)

public:
    CDlgArmingHost(CWnd* pParent = NULL);   // 标准构造函数
    virtual ~CDlgArmingHost();

    // 对话框数据
    enum { IDD = IDD_DLG_IPC_ANR_ARMING_HOST };

protected:
    virtual void DoDataExchange(CDataExchange* pDX);    // DDX/DDV 支持
    afx_msg void OnClickedBtnGet();
    afx_msg BOOL OnInitDialog();
    DECLARE_MESSAGE_MAP()

public:
    LONG    m_lServerID;
    int     m_iDevIndex;
    LONG    m_lChannel;

    DWORD m_dwPort;
    CString m_strIpv4;
    CString m_strIpv6;
    CComboBox m_cmbANRType;
    afx_msg void OnBnClickedCancel();
    CComboBox m_cmbConfirmMechanismEnabled;
};
