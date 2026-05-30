#pragma once
#include "explorer.h"
#include <string>

// CEzvizLogin 对话框

class CEzvizLogin : public CDialogEx
{
	DECLARE_DYNAMIC(CEzvizLogin)

public:
	CEzvizLogin(CWnd* pParent = NULL);   // 标准构造函数
	virtual ~CEzvizLogin();

// 对话框数据
	enum { IDD = IDD_DLG_EZVIZ_LOGIN };

protected:
	virtual void DoDataExchange(CDataExchange* pDX);    // DDX/DDV 支持

	DECLARE_MESSAGE_MAP()
public:
	CExplorer m_EzvizBrowser;
	std::string strAreaID;
	std::string accessToken;
	std::string areaDomain;
public:
	
	virtual BOOL OnInitDialog();
	void setArea(string area);
	DECLARE_EVENTSINK_MAP()
	void BeforeNavigate2Explorer(LPDISPATCH pDisp, VARIANT* URL, VARIANT* Flags, VARIANT* TargetFrameName, VARIANT* PostData, VARIANT* Headers, BOOL* Cancel);
};