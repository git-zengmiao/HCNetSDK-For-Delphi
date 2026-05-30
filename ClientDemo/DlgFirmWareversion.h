#pragma once


// CDlgFirmWareversion 对话框

class CDlgFirmWareversion : public CDialogEx
{
	DECLARE_DYNAMIC(CDlgFirmWareversion)

public:
	CDlgFirmWareversion(CWnd* pParent = NULL);   // 标准构造函数
	virtual ~CDlgFirmWareversion();

// 对话框数据
	enum { IDD = IDD_DLG_FIRMWARE_VERSION };

protected:
	virtual void DoDataExchange(CDataExchange* pDX);    // DDX/DDV 支持

	DECLARE_MESSAGE_MAP()
public:
    afx_msg void OnBnClickedButton1();
    LONG  m_lServerID;
    LONG  m_lChannel;
    LONG  m_iDevIndex;
    char    m_szStatusBuf[ISAPI_STATUS_LEN];
    afx_msg void OnBnClickedBtnGet();
    CString m_FirmwareVersion;
};
