#pragma once


// CDlgAttendanceHolidayPlan 对话框

class CDlgAttendanceHolidayPlan : public CDialog
{
	DECLARE_DYNAMIC(CDlgAttendanceHolidayPlan)

public:
	CDlgAttendanceHolidayPlan(CWnd* pParent = NULL);   // 标准构造函数
	virtual ~CDlgAttendanceHolidayPlan();
    BOOL OnInitDialog();

// 对话框数据
	enum { IDD = IDD_DLG_ATTENDANCE_HOLIDAY_PLAN };

protected:
	virtual void DoDataExchange(CDataExchange* pDX);    // DDX/DDV 支持

	DECLARE_MESSAGE_MAP()
public:
    int m_iDevIndex;
    long m_lServerID;
    afx_msg void OnBnClickedBtnGetAttendanceHolidayPlan();
    afx_msg void OnBnClickedBtnSetAttendanceHolidayPlan();
    int m_iHolidayPlanID;
    CString m_csHolidayPlanName;
    CString m_csStartTime;
    CString m_csEndTime;
    CComboBox m_cmbEnable;
    BOOL CreateAttendanceHolidayPlanXml(char* pBuf, DWORD dwBufLen, int &dwRet);
};
