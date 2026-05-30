#pragma once


// CDlgSchedulePlan 对话框

class CDlgSchedulePlan : public CDialog
{
	DECLARE_DYNAMIC(CDlgSchedulePlan)

public:
	CDlgSchedulePlan(CWnd* pParent = NULL);   // 标准构造函数
	virtual ~CDlgSchedulePlan();
    BOOL OnInitDialog();

// 对话框数据
	enum { IDD = IDD_DLG_SCHEDULE_PLAN };

protected:
	virtual void DoDataExchange(CDataExchange* pDX);    // DDX/DDV 支持

	DECLARE_MESSAGE_MAP()
public:
    int m_iDevIndex;
    long m_lServerID;
    afx_msg void OnBnClickedBtnGetSchedulePlan();
    afx_msg void OnBnClickedBtnSetSchedulePlan();
    int m_iSchedulePlanID;
    CComboBox m_cmbSchedulePlanType;
    CComboBox m_cmbEnable;
    CString m_csScheduleStartTime;
    CString m_csScheduleEndTime;
    int m_iHolidayGroupNo;
    CString m_csDayOfWeek[7];
    CComboBox m_cmbClassType[7];
    DWORD m_dwClassNo[7];
    BOOL CreateSchedulePlanXml(char* pBuf, DWORD dwBufLen, int &dwRet);
};
