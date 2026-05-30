#pragma once

// CDlgAttendanceHolidayGroup 对话框

class CDlgAttendanceHolidayGroup : public CDialog
{
	DECLARE_DYNAMIC(CDlgAttendanceHolidayGroup)

public:
	CDlgAttendanceHolidayGroup(CWnd* pParent = NULL);   // 标准构造函数
	virtual ~CDlgAttendanceHolidayGroup();
    BOOL OnInitDialog();

// 对话框数据
	enum { IDD = IDD_DLG_ATTENDANCE_HOLIDAY_GROUP };

protected:
	virtual void DoDataExchange(CDataExchange* pDX);    // DDX/DDV 支持

	DECLARE_MESSAGE_MAP()
public:
    int m_iDevIndex;
    long m_lServerID;
    afx_msg void OnBnClickedBtnGetAttendanceHolidayGroup();
    afx_msg void OnBnClickedBtnSetAttendanceHolidayGroup();
    CComboBox m_cmbEnable;
    CComboBox m_cmbHolidayPlanEnable[32];
    int m_iHolidayGroupID;
    CString m_csHolidayGroupName;
    DWORD m_dwHolidayPlanID[32];
    BOOL CreateAttendanceHolidayGroupXml(char* pBuf, DWORD dwBufLen, int &dwRet);
};
