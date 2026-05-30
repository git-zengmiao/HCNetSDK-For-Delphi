// TimeSegment.cpp : implementation file
//

#include "stdafx.h"
#include "clientdemo.h"
#include "TimeSegment.h"

#ifdef _DEBUG
#define new DEBUG_NEW
#undef THIS_FILE
static char THIS_FILE[] = __FILE__;
#endif

/////////////////////////////////////////////////////////////////////////////
// CTimeSegment dialog


CTimeSegment::CTimeSegment(CWnd* pParent /*=NULL*/)
	: CDialog(CTimeSegment::IDD, pParent)
    ,m_iCurSel(-1)
{
	//{{AFX_DATA_INIT(CTimeSegment)
	m_BEnable = FALSE;
	m_dtEndTime = COleDateTime::GetCurrentTime();
	m_dtStartTime = COleDateTime::GetCurrentTime();
	//}}AFX_DATA_INIT
}


void CTimeSegment::DoDataExchange(CDataExchange* pDX)
{
	CDialog::DoDataExchange(pDX);
	//{{AFX_DATA_MAP(CTimeSegment)
	DDX_Control(pDX, IDC_COM_ACHP_TIMESEGMENT_VERIFY, m_cmbVerify);
	DDX_Control(pDX, IDC_COM_ACHP_TIMESEGMENT_DOORSTATUS, m_cmbDoorStatus);
	DDX_Control(pDX, IDC_LST_TIMESEGMENT, m_lstTimeSegment);
	DDX_Check(pDX, IDC_CHK_ACHP_TIMESEGMENT_ENABLE, m_BEnable);
	DDX_DateTimeCtrl(pDX, IDC_DATETIME_ACHP_TIMESEGMENT_ENDTIME, m_dtEndTime);
	DDX_DateTimeCtrl(pDX, IDC_DATETIME_ACHP_TIMESEGMENT_STARTTIME, m_dtStartTime);
	//}}AFX_DATA_MAP
}


BEGIN_MESSAGE_MAP(CTimeSegment, CDialog)
	//{{AFX_MSG_MAP(CTimeSegment)
	ON_BN_CLICKED(IDC_OK, OnOk)
	ON_NOTIFY(NM_CLICK, IDC_LST_TIMESEGMENT, OnClickLstTimesegment)
	ON_NOTIFY(NM_SETFOCUS, IDC_LST_TIMESEGMENT, OnSetfocusLstTimesegment)
	//}}AFX_MSG_MAP
END_MESSAGE_MAP()

/////////////////////////////////////////////////////////////////////////////
// CTimeSegment message handlers

BOOL CTimeSegment::OnInitDialog() 
{
	CDialog::OnInitDialog();
	
	// TODO: Add extra initialization here
    int i=0; 
	char szLan[128];
    m_lstTimeSegment.SetExtendedStyle(LVS_EX_GRIDLINES |LVS_EX_FULLROWSELECT);
    g_StringLanType(szLan, "时间段", "Time Segment");
    m_lstTimeSegment.InsertColumn(i++, szLan, LVCFMT_LEFT,60, -1);
    g_StringLanType(szLan, "使能", "Enable");
    m_lstTimeSegment.InsertColumn(i++, szLan, LVCFMT_LEFT,50, -1); 
    g_StringLanType(szLan, "门状态模式", "Door status mode");
    m_lstTimeSegment.InsertColumn(i++, szLan, LVCFMT_LEFT,80, -1);  //3
    g_StringLanType(szLan, "验证模式", "Verify mode");
    m_lstTimeSegment.InsertColumn(i++, szLan, LVCFMT_LEFT,80, -1); 
    g_StringLanType(szLan, "开放时间", "Open time");  
    m_lstTimeSegment.InsertColumn(i++, szLan, LVCFMT_LEFT,80, -1); //5
    g_StringLanType(szLan, "结束时间", "Stop time");
    m_lstTimeSegment.InsertColumn(i++, szLan, LVCFMT_LEFT,80, -1); 

    UpdateList(); 
	return TRUE;  // return TRUE unless you set the focus to a control
	              // EXCEPTION: OCX Property Pages should return FALSE
}

void CTimeSegment::OnOk() 
{
	// TODO: Add your control notification handler code here
    for (int i = 0; i<MAX_TIMESEGMENT_V30;i++)
    {
        if (m_struTimeSegment[i].struTimeSegment.struBeginTime.byHour == 23
            && m_struTimeSegment[i].struTimeSegment.struBeginTime.byMinute==59
            && m_struTimeSegment[i].struTimeSegment.struBeginTime.bySecond==59)
        {
            m_struTimeSegment[i].struTimeSegment.struBeginTime.byHour = 24;
            m_struTimeSegment[i].struTimeSegment.struBeginTime.byMinute = 0;
            m_struTimeSegment[i].struTimeSegment.struBeginTime.bySecond = 0;
        }

        if (m_struTimeSegment[i].struTimeSegment.struEndTime.byHour == 23
            && m_struTimeSegment[i].struTimeSegment.struEndTime.byMinute==59
            && m_struTimeSegment[i].struTimeSegment.struEndTime.bySecond==59)
        {
            m_struTimeSegment[i].struTimeSegment.struEndTime.byHour = 24;
            m_struTimeSegment[i].struTimeSegment.struEndTime.byMinute = 0;
            m_struTimeSegment[i].struTimeSegment.struEndTime.bySecond = 0;
        }
    }
    
	CDialog::OnOK();
}

void CTimeSegment::SetTimeSegment(const NET_DVR_SINGLE_PLAN_SEGMENT*  lpItem)
{
    memcpy(m_struTimeSegment, lpItem, sizeof(m_struTimeSegment)); 
}

void CTimeSegment::GetTimeSegment(NET_DVR_SINGLE_PLAN_SEGMENT *lpItem)
{
    void *pDst = (void *)lpItem;
    memcpy(pDst, m_struTimeSegment, sizeof(m_struTimeSegment));
}

void CTimeSegment::UpdateList()
{
    m_lstTimeSegment.DeleteAllItems();
    CString tmp;
    int iIndex;
#ifdef DEMO_LAN_CN
    const char* pDoorStatus[] = { "无效", "休眠", "常开(自由)", "常闭(禁用)", "普通状态" };
    const char *pVerify[] = { "无效", "休眠", "刷卡+密码", "刷卡", "刷卡或密码", "指纹", "指纹+密码", "指纹或刷卡", "指纹+刷卡", "指纹+刷卡+密码", "人脸或指纹或刷卡或密码", "人脸+指纹", \
        "人脸+密码", "人脸+刷卡", "人脸", "工号+密码", "指纹或密码", "工号+指纹", "工号+指纹+密码", "人脸+指纹+刷卡", "人脸+密码+指纹", "工号+人脸", "人脸或人脸+刷卡", "指纹或人脸",  "刷卡或人脸或密码", 
        "刷卡或人脸","刷卡或人脸或指纹","刷卡或指纹或密码"};
#else
    const char* pDoorStatus[] = {"invalid", "sleep", "Normally open", "Normally close","Normal"};
    const char *pVerify[] = {"invalid", "sleep", "card and password", "card", "card or password", "fingerprint", "fingerprint and password", "fingerprint or card", "fingerprint and card", "fingerprint and card and password" "face or fingerprint or card or password",
        "face and fingerprint", "face and password", "face and card", "face", "work number and password", "fingerprint or password", "work number and fingerprint", "work number and fingerprint and password", "face and fingerprint and card", "face and password and fingerprint", "work number and face", "face or face and swipe card",
        "fingerprint or face",  "card or face or password", "card or face", "card or face or fingerprint", "card or fingerprint or password"};

#endif
    int iHour, iMinute,  iSecond;
    iHour = iMinute= iSecond = 0;
    for (int i=0; i<MAX_TIMESEGMENT_V30; i++)
    {
        tmp.Format("%d", i+1); 
        iIndex = m_lstTimeSegment.InsertItem(i, tmp);    
        m_lstTimeSegment.SetItemData(i, i); 
        if (m_struTimeSegment[i].byEnable)
        {
            tmp.Format("yes"); 
        }
        else
        {
            tmp.Format("no"); 
        }
        m_lstTimeSegment.SetItemText(i, 1, tmp); 
        if ( m_struTimeSegment[i].byDoorStatus > 4)
        {
            tmp.Format("%d", m_struTimeSegment[i].byDoorStatus);
        }
        else
        {
            int iDoorIndex = m_struTimeSegment[i].byDoorStatus;
            tmp.Format("%s", pDoorStatus[iDoorIndex ]); 
        }
        m_lstTimeSegment.SetItemText(i, 2, tmp);
        if (m_struTimeSegment[i].byVerifyMode > (sizeof(pVerify) / sizeof(pVerify[0])))
        {
            tmp.Format("%d", m_struTimeSegment[i].byVerifyMode);
        } 
        else
        {
            int iDoorIndex = m_struTimeSegment[i].byVerifyMode;
            tmp.Format("%s", pVerify[iDoorIndex ]); 
        }
        m_lstTimeSegment.SetItemText(i, 3, tmp);
        LPNET_DVR_SIMPLE_DAYTIME lpTime = &m_struTimeSegment[i].struTimeSegment.struBeginTime;  
        tmp.Format("%2d:%2d:%2d", lpTime->byHour, lpTime->byMinute, lpTime->bySecond); 
        m_lstTimeSegment.SetItemText(i, 4, tmp); 
        lpTime = &m_struTimeSegment[i].struTimeSegment.struEndTime; 
        tmp.Format("%2d:%2d:%2d", lpTime->byHour, lpTime->byMinute, lpTime->bySecond); 
        m_lstTimeSegment.SetItemText(i, 5, tmp);
    }
    UpdateData(FALSE); 
} 

void CTimeSegment::OnClickLstTimesegment(NMHDR* pNMHDR, LRESULT* pResult) 
{
	// TODO: Add your control notification handler code here
    POSITION  iPos = m_lstTimeSegment.GetFirstSelectedItemPosition();
    if (iPos == NULL)
    {
        return;
    }
    m_iCurSel  = m_lstTimeSegment.GetNextSelectedItem(iPos);
    DWORD i = m_lstTimeSegment.GetItemData(m_iCurSel); 
    m_BEnable    = m_struTimeSegment[i].byEnable; 
    m_cmbDoorStatus.SetCurSel(m_struTimeSegment[i].byDoorStatus); 
    m_cmbVerify.SetCurSel(m_struTimeSegment[i].byVerifyMode); 
    LPNET_DVR_SIMPLE_DAYTIME lpTime = NULL; 
    if ( CheckDate(m_struTimeSegment[i].struTimeSegment.struBeginTime) )
    {
        lpTime = &m_struTimeSegment[i].struTimeSegment.struBeginTime;
        if (lpTime->byHour == 24
            && lpTime->byMinute==0
            && lpTime->bySecond==0)
        {
            lpTime->byHour = 23;
            lpTime->byMinute = 59;
            lpTime->bySecond = 59;
        }
        m_dtStartTime.SetTime(lpTime->byHour, lpTime->byMinute, lpTime->bySecond);
    }
    if (CheckDate(m_struTimeSegment[i].struTimeSegment.struEndTime))
    {
        lpTime = &m_struTimeSegment[i].struTimeSegment.struEndTime;
        if (lpTime->byHour == 24
            && lpTime->byMinute==0
            && lpTime->bySecond==0)
        {
            lpTime->byHour = 23;
            lpTime->byMinute = 59;
            lpTime->bySecond = 59;
        }
        m_dtEndTime.SetTime(lpTime->byHour, lpTime->byMinute, lpTime->bySecond);
    }
    UpdateData(FALSE); 
	*pResult = 0;
}

void CTimeSegment::OnSetfocusLstTimesegment(NMHDR* pNMHDR, LRESULT* pResult) 
{
	// TODO: Add your control notification handler code here
	UpdateData(TRUE); 
    if (m_iCurSel != -1)
    {
        m_struTimeSegment[m_iCurSel].byEnable = m_BEnable;
        m_struTimeSegment[m_iCurSel].byVerifyMode = m_cmbVerify.GetCurSel(); 
        m_struTimeSegment[m_iCurSel].byDoorStatus = m_cmbDoorStatus.GetCurSel(); 
        LPNET_DVR_SIMPLE_DAYTIME lpTime = &m_struTimeSegment[m_iCurSel].struTimeSegment.struBeginTime;  
        lpTime->byHour = m_dtStartTime.GetHour(); 
        lpTime->byMinute = m_dtStartTime.GetMinute(); 
        lpTime->bySecond = m_dtStartTime.GetSecond();
        if (lpTime->byHour == 23
            && lpTime->byMinute==59
            && lpTime->bySecond==59)
        {
            lpTime->byHour = 24;
            lpTime->byMinute = 0;
            lpTime->bySecond = 0;
        }
        lpTime = &m_struTimeSegment[m_iCurSel].struTimeSegment.struEndTime;
        lpTime->byHour = m_dtEndTime.GetHour(); 
        lpTime->byMinute = m_dtEndTime.GetMinute(); 
        lpTime->bySecond = m_dtEndTime.GetSecond();
        if (lpTime->byHour == 23
            && lpTime->byMinute==59
            && lpTime->bySecond==59)
        {
            lpTime->byHour = 24;
            lpTime->byMinute = 0;
            lpTime->bySecond = 0;
        }
    }
    UpdateList(); 
	*pResult = 0;
}


BOOL CTimeSegment::CheckDate(const NET_DVR_SIMPLE_DAYTIME& struItem)
{
    if (struItem.byHour >24 ||  struItem.byMinute > 59 || struItem.bySecond > 59 )
    {
        return FALSE; 
    }
    return TRUE; 
}   
