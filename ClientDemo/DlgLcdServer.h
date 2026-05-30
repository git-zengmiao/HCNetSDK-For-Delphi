#if !defined(AFX_DLGLCDSERVER_H__07A9A4A3_36B3_4952_B717_847ADF3E3724__INCLUDED_)
#define AFX_DLGLCDSERVER_H__07A9A4A3_36B3_4952_B717_847ADF3E3724__INCLUDED_

#if _MSC_VER > 1000
#pragma once
#endif // _MSC_VER > 1000
// DlgLcdServer.h : header file
//

/////////////////////////////////////////////////////////////////////////////
// CDlgLcdServer dialog
#define SCREEN_NUM  100 //屏幕个数

class CDlgLcdServer : public CDialog
{
// Construction
public:
	CDlgLcdServer(CWnd* pParent = NULL);   // standard constructor

// Dialog Data
	//{{AFX_DATA(CDlgLcdServer)
	enum { IDD = IDD_DLG_LCD_SERVER };
	CComboBox	m_comboLcdOperateType;
	CComboBox	m_comboY;
	CComboBox	m_comboX;
	CComboBox	m_comboAddType;
	CComboBox	m_comboScreenIndex;
	BOOL	m_bEable;
	CString	m_csCode;
	CString	m_csIP;
	CString	m_csPassWord;
	DWORD	m_dwPort;
	CString	m_csUserName;
	DWORD	m_dwWallNo;
	BOOL	m_bEnablePos;
	//}}AFX_DATA


// Overrides
	// ClassWizard generated virtual function overrides
	//{{AFX_VIRTUAL(CDlgLcdServer)
	protected:
	virtual void DoDataExchange(CDataExchange* pDX);    // DDX/DDV support
	//}}AFX_VIRTUAL

// Implementation
protected:

	// Generated message map functions
	//{{AFX_MSG(CDlgLcdServer)
	virtual BOOL OnInitDialog();
	afx_msg void OnBtnGetAll();
	afx_msg void OnBtnExit();
	afx_msg void OnSelchangeComboScreenIndex();
	afx_msg void OnSelchangeComboAddType();
	afx_msg void OnBtnSetAll();
	afx_msg void OnBtnSetSingle();
	afx_msg void OnBtnGetSingle();
	afx_msg void OnBtnLcdOperate();
	//}}AFX_MSG
	DECLARE_MESSAGE_MAP()

public:
    LONG m_lUserID;
    int m_iDeviceIndex;
    NET_DVR_SCREEN_INDEX_CFG m_struScreenIndex[SCREEN_NUM]; //屏幕索引参数
    NET_DVR_VIDEOWALLDISPLAYPOSITION m_struPosition[SCREEN_NUM];  //屏幕位置参数
    DWORD m_dwStatusListIndex[SCREEN_NUM]; //索引配置状态列表
    DWORD m_dwStatusListPos[SCREEN_NUM]; //位置配置状态列表
    DWORD m_dwIndex[SCREEN_NUM]; //屏幕索引号

private:
    void SaveCurrentData();
    int m_iLastSel;
};

//{{AFX_INSERT_LOCATION}}
// Microsoft Visual C++ will insert additional declarations immediately before the previous line.

#endif // !defined(AFX_DLGLCDSERVER_H__07A9A4A3_36B3_4952_B717_847ADF3E3724__INCLUDED_)
