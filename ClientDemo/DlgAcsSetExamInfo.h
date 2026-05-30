#pragma once


// CDlgAcsSetExamInfo 对话框

class CDlgAcsSetExamInfo : public CDialog
{
	DECLARE_DYNAMIC(CDlgAcsSetExamInfo)

public:
	CDlgAcsSetExamInfo(CWnd* pParent = NULL);   // 标准构造函数
	virtual ~CDlgAcsSetExamInfo();

// 对话框数据
	enum { IDD = IDD_DLG_ACS_SET_EXAM_INFO };

protected:
	virtual void DoDataExchange(CDataExchange* pDX);    // DDX/DDV 支持

	DECLARE_MESSAGE_MAP()
public:
    afx_msg void OnBnClickedBtnAdd();
    afx_msg void OnBnClickedBtnDelete();
    afx_msg void OnBnClickedBtnClear();
    afx_msg void OnBnClickedBtnSetList();
    afx_msg void OnBnClickedBtnDeleteByno();
    afx_msg void OnBnClickedBtnExit();
    virtual BOOL OnInitDialog();
    int GetExistItem(const NET_DVR_EXAM_INFO_CFG *lpExamInfoCfg);
    void Clear();
    BOOL SendFirst();
    BOOL SendNext();
    void ProcessExamInfoCallbackData(DWORD dwType, void* lpBuffer, DWORD dwBufLen);

public:
    LONG m_lUserID;
    int m_iDeviceIndex;
    CListCtrl m_listSetExamInfo;
    CString m_csExamRoundNo;
    CString m_csExamNo;
    CString m_csExamSubject;
    CString m_csTeacherNo;
    CString m_csTeacherName;
    COleDateTime m_startDate;
    COleDateTime m_startTime;
    COleDateTime m_endDate;
    COleDateTime m_endTime;
    BOOL m_bExamInfoValid;
    LONG m_lSetExamInfoHandle;
    DWORD m_dwSendIndex;       //下发序号
protected:
    afx_msg LRESULT OnMsgSetExamInfoFinish(WPARAM wParam, LPARAM lParam);
};
