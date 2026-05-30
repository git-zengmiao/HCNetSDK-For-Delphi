// DlgInquestEvent.cpp : implementation file
//

#include "stdafx.h"
#include "clientdemo.h"
#include "DlgInquestEvent.h"

#ifdef _DEBUG
#define new DEBUG_NEW
#undef THIS_FILE
static char THIS_FILE[] = __FILE__;
#endif


CDlgInquestEvent *g_InquestEvent;

/////////////////////////////////////////////////////////////////////////////
// CDlgInquestEvent dialog


CDlgInquestEvent::CDlgInquestEvent(CWnd* pParent /*=NULL*/)
	: CDialog(CDlgInquestEvent::IDD, pParent)
	, m_bSearching(FALSE)
	, m_hFileThread(NULL)
	, m_lFileHandle(-1)
	, m_lLoginID(-1)
	, m_iDeviceIndex(-1)
	, m_byRoomIndex(-1)
	, m_bResuming(FALSE)
	, m_lResumeHandle(-1)
	, m_hResumeThread(NULL)
    , m_bContinueResuming(FALSE)
    , m_bChkCDPrintEnbled(FALSE)
{
	//{{AFX_DATA_INIT(CDlgInquestEvent)
	m_DateStart = 0;
	m_DateStop = 0;
	m_TimeStart = 0;
	m_TimeStop = 0;
	m_bChkResume = FALSE;
	m_csInqInfo = _T("");
	//}}AFX_DATA_INIT
	memset(&m_struEventParam, 0, sizeof(m_struEventParam));
}


void CDlgInquestEvent::DoDataExchange(CDataExchange* pDX)
{
	CDialog::DoDataExchange(pDX);
	//{{AFX_DATA_MAP(CDlgInquestEvent)
	DDX_Control(pDX, IDC_LIST_TRIAL_EVENT, m_listTrialEvent);
	DDX_Control(pDX, IDC_LIST_EVENT_FILE, m_listInqEvent);
	DDX_Control(pDX, IDC_COMBO_MINOR_EVENT, m_comboMinorEvent);
	DDX_Control(pDX, IDC_COMBO_MAJOR_EVENT, m_comboMajorEvent);
	DDX_DateTimeCtrl(pDX, IDC_COMBO_EVENT_DATE_START, m_DateStart);
	DDX_DateTimeCtrl(pDX, IDC_COMBO_EVENT_DATE_STOP, m_DateStop);
	DDX_DateTimeCtrl(pDX, IDC_COMBO_EVENT_TIME_START, m_TimeStart);
	DDX_DateTimeCtrl(pDX, IDC_COMBO_EVENT_TIME_STOP, m_TimeStop);
	DDX_Check(pDX, IDC_CHK_RESUME_MODE, m_bChkResume);
	DDX_Text(pDX, IDC_EDIT_INQ_INFO, m_csInqInfo);
    DDX_Check(pDX, IDC_CHK_CD_PRINT_ENBLED, m_bChkCDPrintEnbled);
	//}}AFX_DATA_MAP
}


BEGIN_MESSAGE_MAP(CDlgInquestEvent, CDialog)
	//{{AFX_MSG_MAP(CDlgInquestEvent)
	ON_WM_CANCELMODE()
	ON_BN_CLICKED(IDC_BTN_SEARCH, OnBtnSearch)
	ON_BN_CLICKED(IDC_BUTTON_EXIT, OnButtonExit)
	ON_BN_CLICKED(IDC_BUTTON_RESUME, OnButtonResume)
	ON_BN_CLICKED(IDC_BTN_TRIAL_INFO, OnBtnTrialInfo)
	ON_CBN_SELCHANGE(IDC_COMBO_MAJOR_EVENT, OnSelchangeComboMajorEvent)
    ON_WM_TIMER()
	//}}AFX_MSG_MAP
END_MESSAGE_MAP()

/////////////////////////////////////////////////////////////////////////////
// CDlgInquestEvent message handlers

BOOL CDlgInquestEvent::OnInitDialog() 
{
	CDialog::OnInitDialog();

	g_InquestEvent = this;

	char szLan[128] = {0};

	m_comboMinorEvent.ResetContent();
	g_StringLanType(szLan, "讯问开始信息", "Inquest Start Info");
	m_comboMinorEvent.AddString(szLan);
	g_StringLanType(szLan, "讯问停止信息", "Inquest Stop Info");
	m_comboMinorEvent.AddString(szLan);
	g_StringLanType(szLan, "重点标记信息", "Important Remark Info");
	m_comboMinorEvent.AddString(szLan);
	g_StringLanType(szLan, "审讯片断状态信息", "Inquest Fragment Status");
	m_comboMinorEvent.AddString(szLan);
	g_StringLanType(szLan, "审讯案件信息", "Inquest Case Info");
	m_comboMinorEvent.AddString(szLan);

	m_comboMajorEvent.SetCurSel(0);
	m_comboMinorEvent.SetCurSel(0);
	//GetDlgItem(IDC_LIST_EVENT_FILE)->ShowWindow(SW_SHOW);
	GetDlgItem(IDC_LIST_TRIAL_EVENT)->ShowWindow(SW_HIDE);

	m_listInqEvent.SetExtendedStyle(LVS_EX_GRIDLINES | LVS_EX_FULLROWSELECT);	
	g_StringLanType(szLan, "主类型", "Major Type");
	m_listInqEvent.InsertColumn(0, szLan,LVCFMT_LEFT,80,-1);
	g_StringLanType(szLan, "次类型", "Minor Type");
	m_listInqEvent.InsertColumn(1, szLan,LVCFMT_LEFT,80,-1);
	g_StringLanType(szLan, "开始时间", "Start Time");
	m_listInqEvent.InsertColumn(2, szLan, LVCFMT_LEFT, 120, -1);	
	g_StringLanType(szLan, "结束时间", "Stop Time");
	m_listInqEvent.InsertColumn(3, szLan, LVCFMT_LEFT, 120, -1);
	g_StringLanType(szLan, "审讯室", "Room No");
	m_listInqEvent.InsertColumn(4, szLan, LVCFMT_LEFT, 60, -1);
	g_StringLanType(szLan, "刻录机", "Drive No");
	m_listInqEvent.InsertColumn(5, szLan, LVCFMT_LEFT, 60, -1);
	g_StringLanType(szLan, "片段编号", "Segment No");
	m_listInqEvent.InsertColumn(6, szLan, LVCFMT_LEFT, 60, -1);
	g_StringLanType(szLan, "片段大小", "Segment Size");
	m_listInqEvent.InsertColumn(7, szLan, LVCFMT_LEFT, 80, -1);
	g_StringLanType(szLan, "片段状态", "Segment State");
	m_listInqEvent.InsertColumn(8, szLan, LVCFMT_LEFT, 60, -1);
	
	g_StringLanType(szLan, "案件编号", "case no");
	m_listInqEvent.InsertColumn(9, szLan, LVCFMT_LEFT, 80, -1);
	g_StringLanType(szLan, "案件名称", "case name");
	m_listInqEvent.InsertColumn(10, szLan, LVCFMT_LEFT, 80, -1);
	g_StringLanType(szLan, "自定义1", "custom1");
	m_listInqEvent.InsertColumn(11, szLan, LVCFMT_LEFT, 80, -1);
	g_StringLanType(szLan, "自定义2", "custom2");
	m_listInqEvent.InsertColumn(12, szLan, LVCFMT_LEFT, 80, -1);
	g_StringLanType(szLan, "自定义3", "custom3");
	m_listInqEvent.InsertColumn(13, szLan, LVCFMT_LEFT, 80, -1);

	m_listTrialEvent.SetExtendedStyle(LVS_EX_GRIDLINES | LVS_EX_FULLROWSELECT);
	g_StringLanType(szLan, "主类型", "Major Type");
	m_listTrialEvent.InsertColumn(0, szLan,LVCFMT_LEFT,80,-1);
	g_StringLanType(szLan, "次类型", "Minor Type");
	m_listTrialEvent.InsertColumn(1, szLan,LVCFMT_LEFT,80,-1);
	g_StringLanType(szLan, "开始时间", "Start Time");
	m_listTrialEvent.InsertColumn(2, szLan, LVCFMT_LEFT, 120, -1);	
	g_StringLanType(szLan, "结束时间", "Stop Time");
	m_listTrialEvent.InsertColumn(3, szLan, LVCFMT_LEFT, 120, -1);
	g_StringLanType(szLan, "审讯室", "Room No");
	m_listTrialEvent.InsertColumn(4, szLan, LVCFMT_LEFT, 60, -1);
	g_StringLanType(szLan, "刻录机", "Drive No");
	m_listTrialEvent.InsertColumn(5, szLan, LVCFMT_LEFT, 60, -1);
	g_StringLanType(szLan, "片段编号", "Segment No");
	m_listTrialEvent.InsertColumn(6, szLan, LVCFMT_LEFT, 60, -1);
	g_StringLanType(szLan, "片段大小", "Segment Size");
	m_listTrialEvent.InsertColumn(7, szLan, LVCFMT_LEFT, 80, -1);
	g_StringLanType(szLan, "片段状态", "Segment State");
	m_listTrialEvent.InsertColumn(8, szLan, LVCFMT_LEFT, 60, -1);
	
	g_StringLanType(szLan, "案件编号", "case no");
	m_listTrialEvent.InsertColumn(9, szLan, LVCFMT_LEFT, 80, -1);
	g_StringLanType(szLan, "案件名称", "case name");
	m_listTrialEvent.InsertColumn(10, szLan, LVCFMT_LEFT, 80, -1);
	g_StringLanType(szLan, "案件类型", "case type");
	m_listTrialEvent.InsertColumn(11, szLan, LVCFMT_LEFT, 80, -1);
	g_StringLanType(szLan, "当事人1", "litigant1");
	m_listTrialEvent.InsertColumn(12, szLan, LVCFMT_LEFT, 80, -1);
	g_StringLanType(szLan, "当事人2", "litigant2");
	m_listTrialEvent.InsertColumn(13, szLan, LVCFMT_LEFT, 80, -1);
	g_StringLanType(szLan, "审判长", "judge");
	m_listTrialEvent.InsertColumn(14, szLan, LVCFMT_LEFT, 80, -1);

	CTime timeCur = CTime::GetCurrentTime();
	CTime timeStart(timeCur.GetYear(),timeCur.GetMonth(),timeCur.GetDay(),0,0,0);
	CTime timeStop(timeCur.GetYear(),timeCur.GetMonth(),timeCur.GetDay(),23,59,59);
	m_DateStart = timeStart;
	m_TimeStart = timeStart;
	m_DateStop = timeStop;
	m_TimeStop = timeStop;
	
	CString csTemp;
	csTemp.Format("%d", m_byRoomIndex);
	GetDlgItem(IDC_STATIC_ROOM_INDEX)->SetWindowText(csTemp);

	UpdateData(FALSE);

	return TRUE;
}

void CDlgInquestEvent::OnCancelMode() 
{
	CDialog::OnCancelMode();	
}

/*********************************************************
Function:	GetEventThread
Desc:		
Input:		pParam, point to event dialog
Output:	
Return:	
**********************************************************/
UINT GetInquestEventThread(LPVOID pParam)
{
	LONG lRet = -1;
	NET_DVR_SEARCH_EVENT_RET struEventInfo = {0};
	char szLan[1024] = {0};
	int iFileNum = 0;

	while (1)
	{
		memset(&struEventInfo, 0, sizeof(NET_DVR_SEARCH_EVENT_RET));
		lRet = NET_DVR_FindNextEvent(g_InquestEvent->m_lFileHandle, &struEventInfo);
		if (lRet == NET_DVR_FILE_SUCCESS)
		{

			g_InquestEvent->m_listInqEvent.InsertItem(iFileNum, "", 0);	
			g_InquestEvent->m_listTrialEvent.InsertItem(iFileNum, "", 0);
			//major type
			if(struEventInfo.wMajorType == EVENT_INQUEST)
			{
				g_StringLanType(szLan, "审讯", "Inquest");
				g_InquestEvent->m_listInqEvent.SetItemText(iFileNum, 0, szLan);
				
				//minor type
				switch (struEventInfo.wMinorType)
				{
				case INQUEST_START_INFO:
					g_StringLanType(szLan, "审讯开始", "Inquest Start");
					break;
				case INQUEST_STOP_INFO:
					g_StringLanType(szLan, "审讯停止", "Inquest Stop");
					break;
				case INQUEST_TAG_INFO:
					g_StringLanType(szLan, "重点标记", "Tag Info");
					break;
				case INQUEST_SEGMENT_INFO:
					g_StringLanType(szLan, "审讯片段", "Inquest Segment");
					break;
				case INQUEST_CASE_INFO:
					g_StringLanType(szLan, "案件信息", "Inquest Case Info");
					break;
				default:
					g_StringLanType(szLan, "未知", "UnKnow");
					break;
				}
				g_InquestEvent->m_listInqEvent.SetItemText(iFileNum, 1, szLan);
				
				//Start time
				sprintf(szLan, "%04d%02d%02d%02d%02d%02d",struEventInfo.struStartTime.dwYear, \
					struEventInfo.struStartTime.dwMonth, struEventInfo.struStartTime.dwDay, \
					struEventInfo.struStartTime.dwHour, struEventInfo.struStartTime.dwMinute,\
					struEventInfo.struStartTime.dwSecond);
				g_InquestEvent->m_listInqEvent.SetItemText(iFileNum, 2, szLan);
				
				//Stop time
				sprintf(szLan, "%04d%02d%02d%02d%02d%02d", struEventInfo.struEndTime.dwYear, struEventInfo.struEndTime.dwMonth,\
					struEventInfo.struEndTime.dwDay, struEventInfo.struEndTime.dwHour, \
					struEventInfo.struEndTime.dwMinute, struEventInfo.struEndTime.dwSecond);
				g_InquestEvent->m_listInqEvent.SetItemText(iFileNum, 3, szLan);			
				
				//Inquest room number
				sprintf(szLan, "%d", struEventInfo.uSeniorRet.struInquestRet.byRoomIndex);
				g_InquestEvent->m_listInqEvent.SetItemText(iFileNum, 4, szLan);
				
				//Drive number
				sprintf(szLan, "%d", struEventInfo.uSeniorRet.struInquestRet.byDriveIndex);
				g_InquestEvent->m_listInqEvent.SetItemText(iFileNum, 5, szLan);
				
				//Segment No
				sprintf(szLan, "%d", struEventInfo.uSeniorRet.struInquestRet.dwSegmentNo);
				g_InquestEvent->m_listInqEvent.SetItemText(iFileNum, 6, szLan);	
				
				//Segment Size
				sprintf(szLan, "%d", struEventInfo.uSeniorRet.struInquestRet.wSegmetSize);
				g_InquestEvent->m_listInqEvent.SetItemText(iFileNum, 7, szLan);
				
				//Segment State
				switch (struEventInfo.uSeniorRet.struInquestRet.wSegmentState)
				{
				case 0:
					g_StringLanType(szLan, "刻录正常", "normal，1");
					break;
				case 1:
					g_StringLanType(szLan, "刻录异常", "exception，2");
					break;
				case 2:
					g_StringLanType(szLan, "不刻录审讯", "inquest w/o write");
					break;
				default:
					g_StringLanType(szLan, "未知", "UnKnow");
					break;
				}
				g_InquestEvent->m_listInqEvent.SetItemText(iFileNum, 8, szLan);
				
				//number ++
				iFileNum ++;
			}
			else if (EVENT_TRIAL_CASE == struEventInfo.wMajorType)
			{
				g_StringLanType(szLan, "庭审", "trial");
				g_InquestEvent->m_listTrialEvent.SetItemText(iFileNum, 0, szLan);
				
				//minor type
				switch (struEventInfo.wMinorType)
				{
				case INQUEST_START_INFO:
					g_StringLanType(szLan, "庭审开始", "Inquest Start");
					break;
				case INQUEST_STOP_INFO:
					g_StringLanType(szLan, "庭审停止", "Inquest Stop");
					break;
				case INQUEST_TAG_INFO:
					g_StringLanType(szLan, "重点标记", "Tag Info");
					break;
				case INQUEST_SEGMENT_INFO:
					g_StringLanType(szLan, "庭审片段", "Inquest Segment");
					break;
				case TRIAL_JUDGE_CASE_INFO:
					g_StringLanType(szLan, "庭审案件", "Inquest case");
					break;
				default:
					g_StringLanType(szLan, "未知", "UnKnow");
					break;
				}
				g_InquestEvent->m_listTrialEvent.SetItemText(iFileNum, 1, szLan);
				
				//Start time
				sprintf(szLan, "%04d%02d%02d%02d%02d%02d",struEventInfo.struStartTime.dwYear, \
					struEventInfo.struStartTime.dwMonth, struEventInfo.struStartTime.dwDay, \
					struEventInfo.struStartTime.dwHour, struEventInfo.struStartTime.dwMinute,\
					struEventInfo.struStartTime.dwSecond);
				g_InquestEvent->m_listTrialEvent.SetItemText(iFileNum, 2, szLan);
				
				//Stop time
				sprintf(szLan, "%04d%02d%02d%02d%02d%02d", struEventInfo.struEndTime.dwYear, struEventInfo.struEndTime.dwMonth,\
					struEventInfo.struEndTime.dwDay, struEventInfo.struEndTime.dwHour, \
					struEventInfo.struEndTime.dwMinute, struEventInfo.struEndTime.dwSecond);
				g_InquestEvent->m_listTrialEvent.SetItemText(iFileNum, 3, szLan);			
				
				//Inquest room number
				sprintf(szLan, "%d", struEventInfo.uSeniorRet.struTrialRet.byRoomIndex);
				g_InquestEvent->m_listTrialEvent.SetItemText(iFileNum, 4, szLan);
				
				//Drive number
				sprintf(szLan, "%d", struEventInfo.uSeniorRet.struTrialRet.byDriveIndex);
				g_InquestEvent->m_listTrialEvent.SetItemText(iFileNum, 5, szLan);
				
				//Segment No
				sprintf(szLan, "%d", struEventInfo.uSeniorRet.struTrialRet.dwSegmentNo);
				g_InquestEvent->m_listTrialEvent.SetItemText(iFileNum, 6, szLan);	
				
				//Segment Size
				sprintf(szLan, "%d", struEventInfo.uSeniorRet.struTrialRet.wSegmetSize);
				g_InquestEvent->m_listTrialEvent.SetItemText(iFileNum, 7, szLan);
				
				//Segment State
				switch (struEventInfo.uSeniorRet.struTrialRet.bySegmentState)
				{
				case 0:
					g_StringLanType(szLan, "刻录正常", "normal，1");
					break;
				case 1:
					g_StringLanType(szLan, "刻录异常", "exception，2");
					break;
				case 2:
					g_StringLanType(szLan, "不刻录", "inquest w/o write");
					break;
				default:
					g_StringLanType(szLan, "未知", "UnKnow");
					break;
				}
				g_InquestEvent->m_listTrialEvent.SetItemText(iFileNum, 8, szLan);
				
				sprintf(szLan, "%s", struEventInfo.uSeniorRet.struTrialRet.byCaseNo);
				g_InquestEvent->m_listTrialEvent.SetItemText(iFileNum, 9, szLan);

				sprintf(szLan, "%s", struEventInfo.uSeniorRet.struTrialRet.byCaseName);
				g_InquestEvent->m_listTrialEvent.SetItemText(iFileNum, 10, szLan);

				switch (struEventInfo.uSeniorRet.struTrialRet.byCaseType)
				{
				case 1:
					g_StringLanType(szLan, "刑事案件", "crimiinal");
					break;
				case 2:
					g_StringLanType(szLan, "民事案件", "civil");
					break;
				}
				g_InquestEvent->m_listTrialEvent.SetItemText(iFileNum, 11, szLan);

				sprintf(szLan, "%s", struEventInfo.uSeniorRet.struTrialRet.byLitigant1);
				g_InquestEvent->m_listTrialEvent.SetItemText(iFileNum, 12, szLan);

				sprintf(szLan, "%s", struEventInfo.uSeniorRet.struTrialRet.byLitigant2);
				g_InquestEvent->m_listTrialEvent.SetItemText(iFileNum, 13, szLan);

				sprintf(szLan, "%s", struEventInfo.uSeniorRet.struTrialRet.byChiefJudge);
				g_InquestEvent->m_listTrialEvent.SetItemText(iFileNum, 14, szLan);
				//number ++
				iFileNum ++;
			}
			else
			{
				g_StringLanType(szLan, "未知", "UnKnow");
			}
		}
		else
		{
			if (lRet == NET_DVR_ISFINDING)
			{
				Sleep(5);
				continue;
			}
			if ((lRet == NET_DVR_NOMOREFILE) || (lRet == NET_DVR_FILE_NOFIND))
			{
				g_StringLanType(szLan, "查找", "Search");
				g_InquestEvent->GetDlgItem(IDC_BTN_SEARCH)->SetWindowText(szLan);
				g_InquestEvent->m_bSearching = FALSE;
				(g_InquestEvent->GetDlgItem(IDC_STATIC_EVENT_SEARCH_STATE))->ShowWindow(SW_HIDE);
				if (iFileNum > 0)
				{
					g_pMainDlg->AddLog(g_InquestEvent->m_iDeviceIndex, OPERATION_SUCC_T, "NET_DVR_FindNextEvent file num[%d]", iFileNum);
					g_StringLanType(szLan, "获取事件列表成功, 所有事件已列出", "Finish to get event list, and event have all been listed");
					AfxMessageBox(szLan);
				}
				else
				{
					g_StringLanType(szLan, "搜索结束, 没有搜到事件", "Finish to get file list, and There is no event file");
					AfxMessageBox(szLan);
				}
				
				break;
			}
			else
			{
				g_InquestEvent->GetDlgItem(IDC_BTN_SEARCH)->SetWindowText("Search");
				g_InquestEvent->m_bSearching = FALSE;
				(g_InquestEvent->GetDlgItem(IDC_STATIC_EVENT_SEARCH_STATE))->ShowWindow(SW_HIDE);
				g_StringLanType(szLan, "由于服务器忙或网络故障, 搜索异常结束", "Since the server is busy, or network failure, abnormal termination of access file list");
				AfxMessageBox(szLan);

				break;
			}
		}
	}
	NET_DVR_FindClose(g_InquestEvent->m_lFileHandle);
 	CloseHandle(g_InquestEvent->m_hFileThread);
 	g_InquestEvent->m_hFileThread = NULL;	
	return 0;
}

void CDlgInquestEvent::OnBtnSearch()
{ 
	UpdateData(TRUE);
	char szLan[128] = {0};

	if (!m_bSearching)
	{
		m_listInqEvent.DeleteAllItems();
		m_listTrialEvent.DeleteAllItems();

		if (m_comboMajorEvent.GetCurSel() == 0)
		{
			m_struEventParam.wMajorType = EVENT_INQUEST;
			m_struEventParam.uSeniorParam.struInquestParam.byRoomIndex = m_byRoomIndex;
		}
		else if (m_comboMajorEvent.GetCurSel() == 1)
		{
			m_struEventParam.wMajorType = EVENT_TRIAL_CASE;
		}
		m_struEventParam.wMinorType = m_comboMinorEvent.GetCurSel() + INQUEST_START_INFO;
	
		if (m_comboMajorEvent.GetCurSel() == 0 && m_comboMinorEvent.GetCurSel() == 4)
		{
			strncpy((char*)m_struEventParam.uSeniorParam.struInquestParam.sInquestInfo, m_csInqInfo, INQUEST_CASE_LEN);
		}
		
		m_struEventParam.struStartTime.dwYear = m_DateStart.GetYear();
		m_struEventParam.struStartTime.dwMonth = m_DateStart.GetMonth();
		m_struEventParam.struStartTime.dwDay = m_DateStart.GetDay();
		m_struEventParam.struStartTime.dwHour = m_TimeStart.GetHour();
		m_struEventParam.struStartTime.dwMinute = m_TimeStart.GetMinute();
		m_struEventParam.struStartTime.dwSecond = m_TimeStart.GetSecond();
		m_struEventParam.struEndTime.dwYear = m_DateStop.GetYear();
		m_struEventParam.struEndTime.dwMonth = m_DateStop.GetMonth();
		m_struEventParam.struEndTime.dwDay = m_DateStop.GetDay();
		m_struEventParam.struEndTime.dwHour = m_TimeStop.GetHour();
		m_struEventParam.struEndTime.dwMinute = m_TimeStop.GetMinute();
		m_struEventParam.struEndTime.dwSecond = m_TimeStop.GetSecond();
		
		m_lFileHandle = NET_DVR_FindFileByEvent(m_lLoginID, &m_struEventParam);
		
		if (m_lFileHandle < 0)
		{
			g_pMainDlg->AddLog(m_iDeviceIndex, OPERATION_FAIL_T, "NET_DVR_FindFileByEvent");
			g_StringLanType(szLan, "获取文件列表失败!", "Fail to get file list");
			AfxMessageBox(szLan);
			return;
		}

		m_listInqEvent.DeleteAllItems();
		DWORD dwThreadId;
		if (m_hFileThread == NULL)
		{
			m_hFileThread = CreateThread(NULL,0,LPTHREAD_START_ROUTINE(GetInquestEventThread),this,0,&dwThreadId);	
		}
		if (m_hFileThread == NULL)
		{
			g_StringLanType(szLan, "打开查找线程失败!", "Fail to open searching thread!");
			AfxMessageBox(szLan);
			return;
		}
		g_StringLanType(szLan, "停止", "Stop");
		GetDlgItem(IDC_BTN_SEARCH)->SetWindowText(szLan);
		m_bSearching = TRUE;
		GetDlgItem(IDC_STATIC_EVENT_SEARCH_STATE)->ShowWindow(SW_SHOW);
	}
	else
	{
		if (m_hFileThread)
		{
			TerminateThread(m_hFileThread, 0);
		}
		CloseHandle(m_hFileThread);
		m_hFileThread = NULL;
		NET_DVR_FindClose(m_lFileHandle);
		g_StringLanType(szLan, "查找", "Search");
		GetDlgItem(IDC_BTN_SEARCH)->SetWindowText(szLan);
		m_bSearching = FALSE;
		GetDlgItem(IDC_STATIC_EVENT_SEARCH_STATE)->ShowWindow(SW_HIDE);
	}
}

void CDlgInquestEvent::OnButtonExit() 
{
	if (m_hFileThread)
	{
		TerminateThread(m_hFileThread, 0);
		CloseHandle(m_hFileThread);
		m_hFileThread = NULL;
		NET_DVR_FindClose(m_lFileHandle);
	}

	CDialog::OnCancel();
}

DWORD  ResumeEventThread(LPVOID pParam)
{
    DWORD dwState = 0;
    char szLan[256] = {0};
    while (1)
    {
        NET_DVR_InquestGetResumeProgress(g_InquestEvent->m_lResumeHandle, &dwState);
		if (dwState == 100)
        {
            g_StringLanType(szLan, "恢复事件成功", "Resume event succeed"); 
            g_InquestEvent->GetDlgItem(IDC_STATIC_EVENT_RESUME)->SetWindowText(szLan);
            NET_DVR_InquestStopResume(g_InquestEvent->m_lResumeHandle);
            g_StringLanType(szLan, "恢复事件", "Resume Event");
            g_InquestEvent->GetDlgItem(IDC_BUTTON_RESUME)->SetWindowText(szLan);
            g_InquestEvent->m_bResuming = FALSE;
			Sleep(1000);
            g_InquestEvent->GetDlgItem(IDC_STATIC_EVENT_RESUME)->ShowWindow(SW_HIDE);
            break;
        }
        else if (dwState == 400)
        {
            g_StringLanType(szLan, "恢复事件过程出现异常", "Resume event exception");
            g_InquestEvent->GetDlgItem(IDC_STATIC_EVENT_RESUME)->SetWindowText(szLan);
            NET_DVR_InquestStopResume(g_InquestEvent->m_lResumeHandle);
            g_StringLanType(szLan, "恢复事件", "Resume Event");
            g_InquestEvent->GetDlgItem(IDC_BUTTON_RESUME)->SetWindowText(szLan);
            g_InquestEvent->m_bResuming = FALSE;
			Sleep(1000);
            g_InquestEvent->GetDlgItem(IDC_STATIC_EVENT_RESUME)->ShowWindow(SW_HIDE);
            break;
        }
        else if (dwState == 500)
        {
            g_StringLanType(szLan, "恢复事件失败", "Failed to resume event");
            g_InquestEvent->GetDlgItem(IDC_STATIC_EVENT_RESUME)->SetWindowText(szLan);
            NET_DVR_InquestStopResume(g_InquestEvent->m_lResumeHandle);
            g_StringLanType(szLan, "恢复事件", "Resume Event");
            g_InquestEvent->GetDlgItem(IDC_BUTTON_RESUME)->SetWindowText(szLan);
            g_InquestEvent->m_bResuming = FALSE;
			Sleep(1000);
            g_InquestEvent->GetDlgItem(IDC_STATIC_EVENT_RESUME)->ShowWindow(SW_HIDE);
            break;
        }
		//进度值
        else if (dwState >= 0 && dwState < 100)
        { 
			char sTemp[24] = {0};
			g_StringLanType(szLan, "正在恢复事件", "Resuming");
            sprintf(sTemp, "%s[%d]", szLan, dwState);

            g_InquestEvent->GetDlgItem(IDC_STATIC_EVENT_RESUME)->SetWindowText(sTemp);
        }
		else if(dwState ==  BACKUP_CHANGE_DEVICE)
		{
			g_StringLanType(szLan, "设备已满, 请更换设备继续恢复", "Device of resume is full, change another device and continue resuming");
			g_InquestEvent->GetDlgItem(IDC_STATIC_EVENT_RESUME)->SetWindowText(szLan);
			NET_DVR_StopBackup(g_InquestEvent->m_lResumeHandle);
            g_StringLanType(szLan, "恢复事件", "Resume Event");
			g_InquestEvent->GetDlgItem(IDC_BUTTON_RESUME)->SetWindowText(szLan);
			g_InquestEvent->m_bResuming = FALSE;
			Sleep(1000);
			g_InquestEvent->GetDlgItem(IDC_STATIC_EVENT_RESUME)->ShowWindow(SW_HIDE);
			break;
		}
		//中间过程
		else if(dwState == BACKUP_SEARCH_DEVICE)
		{
            g_StringLanType(szLan, "正在搜索备份设备", "searching backup device");
            g_InquestEvent->GetDlgItem(IDC_STATIC_EVENT_RESUME)->SetWindowText(szLan);
		}
		else if(dwState == BACKUP_SEARCH_FILE)
		{
            g_StringLanType(szLan, "正在搜索录像文件", "searching record files");
            g_InquestEvent->GetDlgItem(IDC_STATIC_EVENT_RESUME)->SetWindowText(szLan);
		}
        else if (dwState == BACKUP_CHANGE_DISK)
        {
            g_StringLanType(szLan, "正在更换光盘", "replacing disks");
            g_InquestEvent->GetDlgItem(IDC_STATIC_EVENT_RESUME)->SetWindowText(szLan);
        }
		//错误值
		else if(dwState >= BACKUP_TIME_SEG_NO_FILE)
		{
            char szLanCn[128] = {0};
            char szLanEn[128] = {0};
            sprintf(szLanCn, "恢复事件失败, 错误值[%d]", dwState);
            sprintf(szLanEn, "Backup failed, ErrorCode[%d]", dwState);
			g_StringLanType(szLan, szLanCn, szLanEn);
            g_InquestEvent->GetDlgItem(IDC_STATIC_EVENT_RESUME)->SetWindowText(szLan);

            NET_DVR_InquestStopResume(g_InquestEvent->m_lResumeHandle);
            g_StringLanType(szLan, "恢复事件", "Resume Event");
            g_InquestEvent->GetDlgItem(IDC_BUTTON_RESUME)->SetWindowText(szLan);
            g_InquestEvent->m_bResuming = FALSE;
			Sleep(2000);
            g_InquestEvent->GetDlgItem(IDC_STATIC_EVENT_RESUME)->ShowWindow(SW_HIDE);
            break;
		}
		
        Sleep(1000);
    }
    CloseHandle(g_InquestEvent->m_hResumeThread);
    g_InquestEvent->m_hResumeThread = NULL;

    return 0;
}

void CDlgInquestEvent::OnButtonResume()
{
    UpdateData(TRUE);
    char szLan[128] = { 0 };
    NET_DVR_INQUEST_RESUME_EVENT strResumeEvent = { 0 };

    if (!m_bContinueResuming)
    {
        if (m_comboMajorEvent.GetCurSel() == 0)
        {
            m_pos = m_listInqEvent.GetFirstSelectedItemPosition();
        }
        else if (m_comboMajorEvent.GetCurSel() == 1)
        {
            m_pos = m_listTrialEvent.GetFirstSelectedItemPosition();
        }

        if (m_pos == NULL)
        {
            g_StringLanType(szLan, "请选择要恢复的事件", "Please select the event for resume");
            AfxMessageBox(szLan);
            return;
        }
        m_bContinueResuming = TRUE;
        SetTimer(8, 1000, NULL);
    }
    else
    {
        if (m_hResumeThread)
        {
            TerminateThread(m_hResumeThread, 0);
        }

        CloseHandle(m_hResumeThread);
        m_hResumeThread = NULL;
        NET_DVR_InquestStopResume(m_lResumeHandle);
        g_StringLanType(szLan, "恢复事件", "Resume Event");
        GetDlgItem(IDC_BUTTON_RESUME)->SetWindowText(szLan);
        m_bResuming = FALSE;
        GetDlgItem(IDC_STATIC_EVENT_RESUME)->ShowWindow(SW_HIDE);
        KillTimer(8);
        m_bContinueResuming = FALSE;
    }
}


#include "DlgTrialCaseParam.h"
void CDlgInquestEvent::OnBtnTrialInfo() 
{
	// TODO: Add your control notification handler code here
	CDlgTrialCaseParam dlg;
	if(dlg.DoModal() == IDOK)
	{
		memcpy(&(m_struEventParam.uSeniorParam.struTrialParam),&g_caseInfo,sizeof(CASE_INFO));
	}
}


void CDlgInquestEvent::OnSelchangeComboMajorEvent() 
{
	// TODO: Add your control notification handler code here
	
// 	m_listInqEvent.DeleteAllItems();
 	char szLan[128] = {0};
// 
// 	int iColumnNum = m_listInqEvent.GetHeaderCtrl()->GetItemCount();
// 
// 	int i = -1;
// 	for (i = 0; i < iColumnNum; i++)
// 	{
// 		BOOL bRet =  FALSE;
// 		bRet = m_listInqEvent.DeleteColumn(i);
// 		int j = 0;
// 	}

// 	g_StringLanType(szLan, "主类型", "Major Type");
// 	m_listInqEvent.InsertColumn(0, szLan,LVCFMT_LEFT,80,-1);
// 	g_StringLanType(szLan, "次类型", "Minor Type");
// 	m_listInqEvent.InsertColumn(1, szLan,LVCFMT_LEFT,80,-1);
// 	g_StringLanType(szLan, "开始时间", "Start Time");
// 	m_listInqEvent.InsertColumn(2, szLan, LVCFMT_LEFT, 120, -1);	
// 	g_StringLanType(szLan, "结束时间", "Stop Time");
// 	m_listInqEvent.InsertColumn(3, szLan, LVCFMT_LEFT, 120, -1);
// 	g_StringLanType(szLan, "审讯室", "Room No");
// 	m_listInqEvent.InsertColumn(4, szLan, LVCFMT_LEFT, 60, -1);
// 	g_StringLanType(szLan, "刻录机", "Drive No");
// 	m_listInqEvent.InsertColumn(5, szLan, LVCFMT_LEFT, 60, -1);
// 	g_StringLanType(szLan, "片段编号", "Segment No");
// 	m_listInqEvent.InsertColumn(6, szLan, LVCFMT_LEFT, 60, -1);
// 	g_StringLanType(szLan, "片段大小", "Segment Size");
// 	m_listInqEvent.InsertColumn(7, szLan, LVCFMT_LEFT, 80, -1);
// 	g_StringLanType(szLan, "片段状态", "Segment State");
// 	m_listInqEvent.InsertColumn(8, szLan, LVCFMT_LEFT, 60, -1);
// 	
// 	g_StringLanType(szLan, "案件编号", "case no");
// 	m_listInqEvent.InsertColumn(9, szLan, LVCFMT_LEFT, 80, -1);
// 	g_StringLanType(szLan, "案件名称", "case name");
// 	m_listInqEvent.InsertColumn(10, szLan, LVCFMT_LEFT, 80, -1);

	if (m_comboMajorEvent.GetCurSel() == 0)
	{
		GetDlgItem(IDC_LIST_EVENT_FILE)->ShowWindow(SW_SHOW);
		GetDlgItem(IDC_LIST_TRIAL_EVENT)->ShowWindow(SW_HIDE);

		GetDlgItem(IDC_BTN_TRIAL_INFO)->EnableWindow(FALSE);
		GetDlgItem(IDC_EDIT_INQ_INFO)->EnableWindow(TRUE);

		m_comboMinorEvent.ResetContent();
		g_StringLanType(szLan, "讯问开始信息", "Inquest Start Info");
		m_comboMinorEvent.AddString(szLan);
		g_StringLanType(szLan, "讯问停止信息", "Inquest Stop Info");
		m_comboMinorEvent.AddString(szLan);
		g_StringLanType(szLan, "重点标记信息", "Important Remark Info");
		m_comboMinorEvent.AddString(szLan);
		g_StringLanType(szLan, "审讯片断状态信息", "Inquest Fragment Status");
		m_comboMinorEvent.AddString(szLan);
		g_StringLanType(szLan, "审讯案件信息", "Inquest Case Info");
		m_comboMinorEvent.AddString(szLan);

		m_comboMinorEvent.SetCurSel(0);
 
// 		g_StringLanType(szLan, "自定义1", "custom1");
// 		m_listInqEvent.InsertColumn(11, szLan, LVCFMT_LEFT, 80, -1);
// 		g_StringLanType(szLan, "自定义2", "custom2");
// 		m_listInqEvent.InsertColumn(12, szLan, LVCFMT_LEFT, 80, -1);
// 		g_StringLanType(szLan, "自定义3", "custom3");
// 		m_listInqEvent.InsertColumn(13, szLan, LVCFMT_LEFT, 80, -1);
	}
	else if (m_comboMajorEvent.GetCurSel() == 1)
	{
		GetDlgItem(IDC_LIST_EVENT_FILE)->ShowWindow(SW_HIDE);
		GetDlgItem(IDC_LIST_TRIAL_EVENT)->ShowWindow(SW_SHOW);

		GetDlgItem(IDC_BTN_TRIAL_INFO)->EnableWindow(TRUE);
		GetDlgItem(IDC_EDIT_INQ_INFO)->EnableWindow(FALSE);

		m_comboMinorEvent.ResetContent();
		g_StringLanType(szLan, "庭审开始事件", "Start Event");
		m_comboMinorEvent.AddString(szLan);
		g_StringLanType(szLan, "庭审结束事件", "End Event");
		m_comboMinorEvent.AddString(szLan);
		g_StringLanType(szLan, "重点标注事件", "Important Event");
		m_comboMinorEvent.AddString(szLan);
		g_StringLanType(szLan, "片段信息", "Segment Event");
		m_comboMinorEvent.AddString(szLan);
		g_StringLanType(szLan, "案件信息", "Case Info");
		m_comboMinorEvent.AddString(szLan);

		m_comboMinorEvent.SetCurSel(0);

// 		g_StringLanType(szLan, "案件类型", "case type");
// 		m_listInqEvent.InsertColumn(11, szLan, LVCFMT_LEFT, 80, -1);
// 		g_StringLanType(szLan, "当事人1", "litigant1");
// 		m_listInqEvent.InsertColumn(12, szLan, LVCFMT_LEFT, 80, -1);
// 		g_StringLanType(szLan, "当事人2", "litigant2");
// 		m_listInqEvent.InsertColumn(13, szLan, LVCFMT_LEFT, 80, -1);
// 		g_StringLanType(szLan, "审判长", "judge");
// 		m_listInqEvent.InsertColumn(14, szLan, LVCFMT_LEFT, 80, -1);
	}
}


#if (_MSC_VER >= 1500)	//vs2008
void CDlgInquestEvent::OnTimer(UINT_PTR nIDEvent)
#else
void CDlgInquestEvent::OnTimer(UINT nIDEvent)
#endif
{
    // TODO: Add your message handler code here and/or call default
    switch (nIDEvent)
    {
    case 8:
        if (!m_bResuming && m_pos != NULL && m_hResumeThread == NULL)
        {
            UpdateData(TRUE);
            char szLan[128] = { 0 };
            NET_DVR_INQUEST_RESUME_EVENT strResumeEvent = { 0 };

            int iItemCount = 0;
            int iIndex = 0;
            CString csTemp = _T("");
            DWORD dwTemp = 0;

            while (m_pos != NULL && iItemCount < MAX_RESUME_SEGMENT)
            {
                if (m_comboMajorEvent.GetCurSel() == 0)
                {
                    iIndex = m_listInqEvent.GetNextSelectedItem(m_pos);

                    csTemp = m_listInqEvent.GetItemText(iIndex, 2);
                    sscanf(csTemp, "%04d%02d%02d%02d%02d%02d", &(strResumeEvent.struResumeSegment[iItemCount].struStartTime.dwYear), \
                        &(strResumeEvent.struResumeSegment[iItemCount].struStartTime.dwMonth), \
                        &(strResumeEvent.struResumeSegment[iItemCount].struStartTime.dwDay), \
                        &(strResumeEvent.struResumeSegment[iItemCount].struStartTime.dwHour), \
                        &(strResumeEvent.struResumeSegment[iItemCount].struStartTime.dwMinute), \
                        &(strResumeEvent.struResumeSegment[iItemCount].struStartTime.dwSecond));

                    csTemp = m_listInqEvent.GetItemText(iIndex, 3);
                    sscanf(csTemp, "%04d%02d%02d%02d%02d%02d", &(strResumeEvent.struResumeSegment[iItemCount].struStopTime.dwYear), \
                        &(strResumeEvent.struResumeSegment[iItemCount].struStopTime.dwMonth), \
                        &(strResumeEvent.struResumeSegment[iItemCount].struStopTime.dwDay), \
                        &(strResumeEvent.struResumeSegment[iItemCount].struStopTime.dwHour), \
                        &(strResumeEvent.struResumeSegment[iItemCount].struStopTime.dwMinute), \
                        &(strResumeEvent.struResumeSegment[iItemCount].struStopTime.dwSecond));

                    csTemp = m_listInqEvent.GetItemText(iIndex, 4);
                    sscanf(csTemp, "%d", &dwTemp);
                    strResumeEvent.struResumeSegment[iItemCount].byRoomIndex = (BYTE)dwTemp;

                    csTemp = m_listInqEvent.GetItemText(iIndex, 5);
                    sscanf(csTemp, "%d", &dwTemp);
                    strResumeEvent.struResumeSegment[iItemCount].byDriveIndex = (BYTE)dwTemp;

                    csTemp = m_listInqEvent.GetItemText(iIndex, 6);
                    sscanf(csTemp, "%d", &(strResumeEvent.struResumeSegment[iItemCount].dwSegmentNo));

                    csTemp = m_listInqEvent.GetItemText(iIndex, 7);
                    sscanf(csTemp, "%d", &dwTemp);
                    strResumeEvent.struResumeSegment[iItemCount].wSegmetSize = (WORD)dwTemp;

                    ++iItemCount;
                }
                else if (m_comboMajorEvent.GetCurSel() == 1)
                {
                    iIndex = m_listTrialEvent.GetNextSelectedItem(m_pos);

                    csTemp = m_listTrialEvent.GetItemText(iIndex, 2);
                    sscanf(csTemp, "%04d%02d%02d%02d%02d%02d", &(strResumeEvent.struResumeSegment[iItemCount].struStartTime.dwYear), \
                        &(strResumeEvent.struResumeSegment[iItemCount].struStartTime.dwMonth), \
                        &(strResumeEvent.struResumeSegment[iItemCount].struStartTime.dwDay), \
                        &(strResumeEvent.struResumeSegment[iItemCount].struStartTime.dwHour), \
                        &(strResumeEvent.struResumeSegment[iItemCount].struStartTime.dwMinute), \
                        &(strResumeEvent.struResumeSegment[iItemCount].struStartTime.dwSecond));

                    csTemp = m_listTrialEvent.GetItemText(iIndex, 3);
                    sscanf(csTemp, "%04d%02d%02d%02d%02d%02d", &(strResumeEvent.struResumeSegment[iItemCount].struStopTime.dwYear), \
                        &(strResumeEvent.struResumeSegment[iItemCount].struStopTime.dwMonth), \
                        &(strResumeEvent.struResumeSegment[iItemCount].struStopTime.dwDay), \
                        &(strResumeEvent.struResumeSegment[iItemCount].struStopTime.dwHour), \
                        &(strResumeEvent.struResumeSegment[iItemCount].struStopTime.dwMinute), \
                        &(strResumeEvent.struResumeSegment[iItemCount].struStopTime.dwSecond));

                    csTemp = m_listTrialEvent.GetItemText(iIndex, 4);
                    sscanf(csTemp, "%d", &dwTemp);
                    strResumeEvent.struResumeSegment[iItemCount].byRoomIndex = (BYTE)dwTemp;

                    csTemp = m_listTrialEvent.GetItemText(iIndex, 5);
                    sscanf(csTemp, "%d", &dwTemp);
                    strResumeEvent.struResumeSegment[iItemCount].byDriveIndex = (BYTE)dwTemp;

                    csTemp = m_listTrialEvent.GetItemText(iIndex, 6);
                    sscanf(csTemp, "%d", &(strResumeEvent.struResumeSegment[iItemCount].dwSegmentNo));

                    csTemp = m_listTrialEvent.GetItemText(iIndex, 7);
                    sscanf(csTemp, "%d", &dwTemp);
                    strResumeEvent.struResumeSegment[iItemCount].wSegmetSize = (WORD)dwTemp;

                    ++iItemCount;
                }
            }

            strResumeEvent.dwResumeNum = iItemCount;
            strResumeEvent.byResumeMode = m_bChkResume;
            strResumeEvent.byCDPrintEnbled = m_bChkCDPrintEnbled;

            m_lResumeHandle = NET_DVR_InquestResumeEvent(m_lLoginID, &strResumeEvent);
            if (m_lResumeHandle == -1)
            {
                g_pMainDlg->AddLog(m_iDeviceIndex, OPERATION_FAIL_T, "NET_DVR_InquestResumeEvent");
                return;
            }
            else
            {
                g_pMainDlg->AddLog(m_iDeviceIndex, OPERATION_SUCC_T, "NET_DVR_InquestResumeEvent");
            }

            DWORD dwThreadId = 0;
            if (m_hResumeThread == NULL)
            {
                m_hResumeThread = CreateThread(NULL, 0, LPTHREAD_START_ROUTINE(ResumeEventThread), this, 0, &dwThreadId);
            }
            if (m_hResumeThread == NULL)
            {
                char szLan[256] = { 0 };
                g_StringLanType(szLan, "打开恢复事件线程失败!", "Fail to open resume event thread!");
                AfxMessageBox(szLan);
                return;
            }
            g_StringLanType(szLan, "停止", "Stop");
            GetDlgItem(IDC_BUTTON_RESUME)->SetWindowText(szLan);
            m_bResuming = TRUE;
            GetDlgItem(IDC_STATIC_EVENT_RESUME)->ShowWindow(SW_SHOW);

        }
        if (m_pos == NULL && !m_bResuming)
        {
            if (m_hResumeThread)
            {
                TerminateThread(m_hResumeThread, 0);
            }
            char szLan[256] = { 0 };
            CloseHandle(m_hResumeThread);
            m_hResumeThread = NULL;
            NET_DVR_InquestStopResume(m_lResumeHandle);
            g_StringLanType(szLan, "恢复事件", "Resume Event");
            GetDlgItem(IDC_BUTTON_RESUME)->SetWindowText(szLan);
            m_bResuming = FALSE;
            GetDlgItem(IDC_STATIC_EVENT_RESUME)->ShowWindow(SW_HIDE);
            m_bContinueResuming = FALSE;
            KillTimer(8);
        }
        break;
    default:
        break;
    }
    CDialog::OnTimer(nIDEvent);
}
