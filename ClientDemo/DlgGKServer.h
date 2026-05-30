#pragma once


// CDlgGKServer 对话框

class CDlgGKServer : public CDialogEx
{
	DECLARE_DYNAMIC(CDlgGKServer)

public:
	CDlgGKServer(CWnd* pParent = NULL);   // 标准构造函数
	virtual ~CDlgGKServer();

// 对话框数据
	enum { IDD = IDD_DLG_GK_SERVER };

protected:
	virtual void DoDataExchange(CDataExchange* pDX);    // DDX/DDV 支持

	DECLARE_MESSAGE_MAP()
public:
    BOOL m_bEnable;
    UINT m_wPort;
    afx_msg void OnBnClickedBtnGet();

private:
    LONG m_lUserID;
    LONG m_iDeviceIndex;
public:
    afx_msg void OnBnClickedBtnSet();
    virtual BOOL OnInitDialog();
};
