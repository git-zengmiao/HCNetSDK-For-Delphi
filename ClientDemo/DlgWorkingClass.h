#pragma once


// CDlgWorkingClass 对话框

class CDlgWorkingClass : public CDialog
{
	DECLARE_DYNAMIC(CDlgWorkingClass)

public:
	CDlgWorkingClass(CWnd* pParent = NULL);   // 标准构造函数
	virtual ~CDlgWorkingClass();
    BOOL OnInitDialog();

// 对话框数据
	enum { IDD = IDD_DLG_WORKING_CLASS };

protected:
	virtual void DoDataExchange(CDataExchange* pDX);    // DDX/DDV 支持

	DECLARE_MESSAGE_MAP()
public:
    int m_iDevIndex;
    long m_lServerID;
    afx_msg void OnBnClickedBtnGetWorkingClass();
    afx_msg void OnBnClickedBtnSetWorkingClass();
    int m_iWorkingClassID;
    CComboBox m_cmbEnable;
    CString m_csClassName;
    int m_iWorkingTime;
    CComboBox m_cmbDelayEnable;
    CString m_csOnDutyDelay;
    DWORD m_dwTimeID[4];
    CString m_csStartRestTime[4];
    CString m_csEndRestTime[4];
    BOOL CreateWorkingClassXml(char* pBuf, DWORD dwBufLen, int &dwRet);
};
