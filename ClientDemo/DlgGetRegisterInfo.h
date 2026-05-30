#include "afxcmn.h"
#if !defined(AFX_DLGGETREGISTERINFO_H__5504F922_A4F4_4EB1_83C8_595AB10774E3__INCLUDED_)
#define AFX_DLGGETREGISTERINFO_H__5504F922_A4F4_4EB1_83C8_595AB10774E3__INCLUDED_

#if _MSC_VER > 1000
#pragma once
#endif // _MSC_VER > 1000

// CDlgGetRegisterInfo 对话框

class CDlgGetRegisterInfo : public CDialogEx
{
	DECLARE_DYNAMIC(CDlgGetRegisterInfo)

public:
	CDlgGetRegisterInfo(CWnd* pParent = NULL);   // 标准构造函数
	virtual ~CDlgGetRegisterInfo();

// 对话框数据
	enum { IDD = IDD_DLG_ACS_GET_REGISTOR_INFO };

protected:
	virtual void DoDataExchange(CDataExchange* pDX);    // DDX/DDV 支持

	DECLARE_MESSAGE_MAP()
public:
    afx_msg void OnBnClickedBtnGetRegisterInfo();
    afx_msg LRESULT OnMsgGetRegisterInfoFinish(WPARAM wParam, LPARAM lParam);
    //afx_msg LRESULT OnMsgGetRegisterInfoToList(WPARAM wParam, LPARAM lParam);

    LONG m_lServerID;
    int m_iDevIndex;
    LONG m_lRemoteHandle;
    LONG m_lLogNum;
    virtual BOOL OnInitDialog();
    CListCtrl m_listRegisterInfoLog;
    afx_msg void OnBnClickedBtnExit();
};
#endif //!define AFX_DLGGETREGISTERINFO_H__5504F922_A4F4_4EB1_83C8_595AB10774E3__INCLUDED_
