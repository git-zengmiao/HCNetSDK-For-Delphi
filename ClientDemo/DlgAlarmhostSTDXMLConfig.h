#pragma once
#include "afxwin.h"
#include "./xml/XmlBase.h"

// CDlgAlarmhostSTDXMLConfig 对话框

class CDlgAlarmhostSTDXMLConfig : public CDialog
{
	DECLARE_DYNAMIC(CDlgAlarmhostSTDXMLConfig)

public:
	CDlgAlarmhostSTDXMLConfig(CWnd* pParent = NULL);   // 标准构造函数
	virtual ~CDlgAlarmhostSTDXMLConfig();

// 对话框数据
	enum { IDD = IDD_DLG_ALARMHOST_STD_XML_CONFIG };
    CComboBox m_cmbCommand;
    CString m_csInputXml;
    CString m_csOutputXml;

    char* m_pXmlOutput;

protected:
	virtual void DoDataExchange(CDataExchange* pDX);    // DDX/DDV 支持
    virtual BOOL OnInitDialog();
    afx_msg void OnCbnSelchangeCmbCommand();
    afx_msg void OnBnClickedBtnConfig();
	DECLARE_MESSAGE_MAP()

public:
    LONG m_lUserID;
    int m_iDevIndex;
    int m_iStartChan;
    int m_iChanNum;
    char m_sCommand[256];
    int m_InPutXmlLen;
};
