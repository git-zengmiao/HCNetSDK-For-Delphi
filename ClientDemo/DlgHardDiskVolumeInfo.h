#pragma once
#include "afxcmn.h"
#include "afxwin.h"


// CDlgHardDiskVolumeInfo 对话框

class CDlgHardDiskVolumeInfo : public CDialogEx
{
	DECLARE_DYNAMIC(CDlgHardDiskVolumeInfo)

public:
	CDlgHardDiskVolumeInfo(CWnd* pParent = NULL);   // 标准构造函数
	virtual ~CDlgHardDiskVolumeInfo();

// 对话框数据
	enum { IDD = IDD_DLG_HARD_DISK_VOLUME_INFO };

protected:
	virtual void DoDataExchange(CDataExchange* pDX);    // DDX/DDV 支持

	DECLARE_MESSAGE_MAP()
public:
    virtual BOOL OnInitDialog();
    CListCtrl m_listHardDiskVolume;
    afx_msg void OnBnClickedButtonGet();
    afx_msg void OnBnClickedButtonSet();
    CComboBox m_comboBox;

    int m_iDevIndex;
    long m_lServerID;
    NET_DVR_HARD_DISK_VOLUME_INFO m_struHardDiskVolumeInfo;
    BOOL m_bSelectItem;
    int m_iRowCount;
    int m_iItem;
    int m_iSubItem;
    int m_iLastItem;
    void SaveParam();
    void AddHardDiskVolumeInfoToList();
    afx_msg void OnCbnKillfocusComboBox();
    afx_msg void OnNMClickListHardDiskVolume(NMHDR *pNMHDR, LRESULT *pResult);
    afx_msg void OnNMDblclkListHardDiskVolume(NMHDR *pNMHDR, LRESULT *pResult);
};
