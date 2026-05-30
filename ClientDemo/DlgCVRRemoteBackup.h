#pragma once
#include "afxwin.h"
#include "afxcmn.h"
#include "XMLParamsConvert.h"

// CDlgCVRRemoteBackup 对话框

class CDlgCVRRemoteBackup : public CDialogEx
{
	DECLARE_DYNAMIC(CDlgCVRRemoteBackup)

public:
	CDlgCVRRemoteBackup(CWnd* pParent = NULL);   // 标准构造函数
	virtual ~CDlgCVRRemoteBackup();

// 对话框数据
	enum { IDD = IDD_DLG_CVR_REMOTE_BACKUP };

protected:
	virtual void DoDataExchange(CDataExchange* pDX);    // DDX/DDV 支持

	DECLARE_MESSAGE_MAP()
public:
    afx_msg void OnBnClickedButtonGet();
    afx_msg void OnBnClickedButtonSet();
    afx_msg void OnBnClickedButtonAddTask();
    afx_msg void OnBnClickedButtonDeleteTask();
    afx_msg void OnBnClickedButtonTaskSet();
    afx_msg void OnBnClickedButtonSearchTask();
    afx_msg void OnBnClickedButtonDelete();
    virtual BOOL OnInitDialog();

    LONG m_lUserID;
    int m_iDeviceIndex;
    CComboBox m_comboDeleteType;
    CComboBox m_comboIPVersion;
    CComboBox m_comboSearchType;
    CString m_strDeleteTaskID;
    CString m_strIPV4Address;
    CString m_strIPV6Address;
    CString m_strPassword;
    CString m_strTaskFileIndex;
    CString m_strTaskID;
    CString m_strTaskURL;
    CString m_strUserName;
    CListCtrl m_listAddTask;
    CListCtrl m_listSearchTask;

    int m_iRowCount;
    BOOL m_bSelectItem;
    int m_iSubItem;
    int m_iLastItem;

    BOOL CreateBackupMachineInfo(char* pBuf, DWORD dwBufLen, int &dwRet);
    BOOL CreateAddTaskCondition(char* pBuf, DWORD dwBufLen, int &dwRet);
    BOOL CreateSearchTaskCondition(char* pBuf, DWORD dwBufLen, int &dwRet);
    afx_msg void OnNMClickListAddTask(NMHDR *pNMHDR, LRESULT *pResult);
    CString m_strSearchID;
    int m_iMaxCountRet;
    int m_iCountStartRet;
    CString m_strSearchResult;
    CString m_strSearchStatus;
    int m_iCountResult;
    BOOL m_bRegerateID;
    int m_iStatusMaxCountRet;
    afx_msg void OnBnClickedButtonClearList();
};
