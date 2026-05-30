#pragma once
#include "afxwin.h"


// CDlgUploadHdFile 对话框

class CDlgUploadHdFile : public CDialogEx
{
	DECLARE_DYNAMIC(CDlgUploadHdFile)

public:
	CDlgUploadHdFile(CWnd* pParent = NULL);   // 标准构造函数
	virtual ~CDlgUploadHdFile();

// 对话框数据
	enum { IDD = IDD_DLG_UPLOAD_HD_FILE };

protected:
	virtual void DoDataExchange(CDataExchange* pDX);    // DDX/DDV 支持

	DECLARE_MESSAGE_MAP()
public:
    LONG  m_lServerID;
    LONG  m_lChannel;
    LONG  m_iDevIndex;

    CComboBox m_comChannel;
    CString m_csUploadPath;
    CComboBox m_comUploadType;
    CComboBox m_comDownloadType;
    CString m_csDownloadPath;
    LONG m_lUploadHandle;
    LONG m_lDownloadHandle;
    DWORD m_dwFileSize;
    BYTE m_byChannel;
    CComboBox m_comFileType;
    afx_msg void OnBnClickedBtnFilePathUploadFile();
    afx_msg void OnBnClickedBtnFileUpload3200wFile();
    afx_msg void OnBnClickedBtnFilePathDownloadFile();
    afx_msg void OnBnClickedBtnFileDownload3200wFile();
    virtual BOOL OnInitDialog();
};
