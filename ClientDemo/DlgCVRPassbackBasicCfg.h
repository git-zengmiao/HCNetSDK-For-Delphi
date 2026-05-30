#pragma once
#include "atltime.h"
#include "afxwin.h"


// CDlgCVRPassbackBasicCfg 对话框

class CDlgCVRPassbackBasicCfg : public CDialogEx
{
    DECLARE_DYNAMIC(CDlgCVRPassbackBasicCfg)

public:
    CDlgCVRPassbackBasicCfg(CWnd* pParent = NULL);   // 标准构造函数
    virtual ~CDlgCVRPassbackBasicCfg();

    // 对话框数据
    enum { IDD = IDD_DLG_CVR_PASSBACK_BASIC_CFG };

protected:
    virtual void DoDataExchange(CDataExchange* pDX);    // DDX/DDV 支持

    DECLARE_MESSAGE_MAP()
public:
    int m_iMaxTotalConcurrenceNum;
    int m_iMaxDvrConcurrenceNum;
    afx_msg void OnBnClickedButtonGet();
    afx_msg void OnBnClickedButtonSet();
    virtual BOOL OnInitDialog();
    char    m_szStatusBuf[ISAPI_STATUS_LEN];

    LONG  m_lServerID;
    LONG  m_iDevIndex;
    DWORD m_dwStartTime;
    DWORD m_dwStopTime;
    DWORD m_dwSyncSpeed;
    CComboBox m_comRecordType;
};
