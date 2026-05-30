#pragma once
#include "afxwin.h"


// CDlgRecordHostEducationServerCfg 对话框

class CDlgRecordHostEducationServerCfg : public CDialogEx
{
	DECLARE_DYNAMIC(CDlgRecordHostEducationServerCfg)

public:
	CDlgRecordHostEducationServerCfg(CWnd* pParent = NULL);   // 标准构造函数
	virtual ~CDlgRecordHostEducationServerCfg();

// 对话框数据
	enum { IDD = IDD_DLG_RECORD_HOST_EDUCATION_SERVER_CFG };

protected:
	virtual void DoDataExchange(CDataExchange* pDX);    // DDX/DDV 支持

	DECLARE_MESSAGE_MAP()
public:
	BOOL m_bConnetServer;
	CComboBox m_cmbConnetStatus;
	CComboBox m_cmbType;
	CString m_strDomain;
	int m_iHeartBeatTime;
	CString m_strIPAddress;
	int m_iPort;
	afx_msg void OnBnClickedButtonGet();
	afx_msg void OnBnClickedButtonSet();

	LONG m_lUserID;
	int m_iDeviceIndex;
	BOOL CreateEducationServerCfgXML(char* pBuf, DWORD dwBufLen, int &dwRet);
	virtual BOOL OnInitDialog();
};
