#pragma once
#include "afxwin.h"


// CDlgRecordHostVedioSwitchConfig 对话框

class CDlgRecordHostVedioSwitchConfig : public CDialogEx
{
	DECLARE_DYNAMIC(CDlgRecordHostVedioSwitchConfig)

public:
	CDlgRecordHostVedioSwitchConfig(CWnd* pParent = NULL);   // 标准构造函数
	virtual ~CDlgRecordHostVedioSwitchConfig();

// 对话框数据
	enum { IDD = IDD_DLG_RECORD_HOST_VIDEO_SWITCH_CONFIG };

protected:
	virtual void DoDataExchange(CDataExchange* pDX);    // DDX/DDV 支持

	DECLARE_MESSAGE_MAP()
public:
    virtual BOOL OnInitDialog();
    afx_msg void OnBnClickedBtnGet();
    afx_msg void OnBnClickedBtnSet();
    BOOL m_enable;
    LONG m_lUserID;
    int m_iDeviceIndex;
    CComboBox m_EffectModeCtrl;
    BOOL CreateVideoSwitchConfiguration(char* pBuf, DWORD dwBufLen, int &dwRet);
};
