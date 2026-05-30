#pragma once


// CDlgDepartmentParam 对话框

class CDlgDepartmentParam : public CDialog
{
	DECLARE_DYNAMIC(CDlgDepartmentParam)

public:
	CDlgDepartmentParam(CWnd* pParent = NULL);   // 标准构造函数
	virtual ~CDlgDepartmentParam();
    BOOL OnInitDialog();

// 对话框数据
	enum { IDD = IDD_DLG_DEPARTMENT_PARAM };

protected:
	virtual void DoDataExchange(CDataExchange* pDX);    // DDX/DDV 支持

	DECLARE_MESSAGE_MAP()
public:
    int m_iDevIndex;
    long m_lServerID;
    afx_msg void OnBnClickedBtnGetDepartmentParam();
    afx_msg void OnBnClickedBtnSetDepartmentParam();
    int m_iDepartmentID;
    CString m_csDepartmentName;
    BOOL CreateDepartmentParamXml(char* pBuf, DWORD dwBufLen, int &dwRet);
    CComboBox m_cmbEnable;
};
