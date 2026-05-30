// DlgGetAllRs485Slot.cpp : implementation file
//

#include "stdafx.h"
#include "clientdemo.h"
#include "DlgGetAllRs485Slot.h"

#ifdef _DEBUG
#define new DEBUG_NEW
#undef THIS_FILE
static char THIS_FILE[] = __FILE__;
#endif

/////////////////////////////////////////////////////////////////////////////
// DlgGetAllRs485Slot dialog
DWORD WINAPI DlgGetAllRs485Slot::GetConfigThread(LPVOID lpArg)
{
	DlgGetAllRs485Slot* pThis = reinterpret_cast<DlgGetAllRs485Slot*>(lpArg);
	int bRet = 0;
	char szLan[128] = {0};
	memset(&(pThis->m_struAlarmHostRs485SlotCfg),0,sizeof(pThis->m_struAlarmHostRs485SlotCfg));
	while(pThis->m_bGetNext)
	{
		bRet = NET_DVR_GetNextRemoteConfig(pThis->m_lHandle, &pThis->m_struAlarmHostRs485SlotCfg, sizeof(pThis->m_struAlarmHostRs485SlotCfg));
		if (bRet == NET_SDK_GET_NEXT_STATUS_SUCCESS)
		{
			pThis->AddInfoToDlg();
		}
		else
		{
			if (bRet == NET_SDK_GET_NETX_STATUS_NEED_WAIT)
			{
				Sleep(5);
				continue;
			}
			if (bRet == NET_SDK_GET_NEXT_STATUS_FINISH)
			{
				g_StringLanType(szLan, "获取配置结束!", "Get route info Ending");
				g_pMainDlg->AddLog(pThis->m_iDeviceIndex, OPERATION_SUCC_T, szLan);
				//AfxMessageBox(szLan);
				break;
			}
			else if(bRet == NET_SDK_GET_NEXT_STATUS_FAILED)
			{
				g_StringLanType(szLan, "获取配置失败!", "Get route info failed");
				AfxMessageBox(szLan);
				break;
			}
			else
			{
				g_StringLanType(szLan, "未知状态", "Unknown status");
				AfxMessageBox(szLan);
				break;
			}
		}
	}
	if (-1 != pThis->m_lHandle)
	{
		if (!NET_DVR_StopRemoteConfig(pThis->m_lHandle))
		{
			g_pMainDlg->AddLog(pThis->m_iDeviceIndex, OPERATION_FAIL_T, "Stop Remote Config Failed");
			pThis->m_bGetNext = FALSE;
		}
		else
		{
			g_pMainDlg->AddLog(pThis->m_iDeviceIndex, OPERATION_SUCC_T, "Stop Remote Config Successful");
			pThis->m_bGetNext = FALSE;
			pThis->m_lHandle = -1;
		}
	}
	return 0 ;
}

void DlgGetAllRs485Slot::AddInfoToDlg() 
{
	//点号
	if(0xff == m_struAlarmHostRs485SlotCfg.byChannel)
	{
		sprintf(m_sTemp, "%s", "--");
	}
	else
	{
		sprintf(m_sTemp, "%d", m_struAlarmHostRs485SlotCfg.byChannel);
	}
	m_listRs485Slot.InsertItem(m_iRowCount,m_sTemp);

	if(0xff == m_struAlarmHostRs485SlotCfg.bySlotChan)
	{
		sprintf(m_sTemp, "%s", "--");
	}
	else
	{
		sprintf(m_sTemp, "%d", m_struAlarmHostRs485SlotCfg.bySlotChan);
	}
	m_listRs485Slot.SetItemText(m_iRowCount, 1, m_sTemp);
	
	//前端设备名称
	sprintf(m_sTemp, "%s", (char*)m_struAlarmHostRs485SlotCfg.sDeviceName, NAME_LEN);
	m_listRs485Slot.SetItemText(m_iRowCount, 2, m_sTemp);
	
	sprintf(m_sTemp, "%d", m_struAlarmHostRs485SlotCfg.wDeviceType);
	m_listRs485Slot.SetItemText(m_iRowCount, 3, m_sTemp);
	
	sprintf(m_sTemp, "%d", m_struAlarmHostRs485SlotCfg.wDeviceProtocol);
	m_listRs485Slot.SetItemText(m_iRowCount, 4, m_sTemp);

	sprintf(m_sTemp, "%d", m_struAlarmHostRs485SlotCfg.wAddress);
	m_listRs485Slot.SetItemText(m_iRowCount, 5, m_sTemp);
	
	m_iRowCount++;
}

DlgGetAllRs485Slot::DlgGetAllRs485Slot(CWnd* pParent /*=NULL*/)
	: CDialog(DlgGetAllRs485Slot::IDD, pParent)
{
	//{{AFX_DATA_INIT(DlgGetAllRs485Slot)
		// NOTE: the ClassWizard will add member initialization here
	//}}AFX_DATA_INIT
	m_lHandle = -1;
}


void DlgGetAllRs485Slot::DoDataExchange(CDataExchange* pDX)
{
	CDialog::DoDataExchange(pDX);
	//{{AFX_DATA_MAP(DlgGetAllRs485Slot)
	DDX_Control(pDX, IDC_LIST_RS485_SLOT, m_listRs485Slot);
	//}}AFX_DATA_MAP
}


BEGIN_MESSAGE_MAP(DlgGetAllRs485Slot, CDialog)
	//{{AFX_MSG_MAP(DlgGetAllRs485Slot)
	ON_BN_CLICKED(IDC_BTN_GET, OnBtnGet)
	//}}AFX_MSG_MAP
END_MESSAGE_MAP()

/////////////////////////////////////////////////////////////////////////////
// DlgGetAllRs485Slot message handlers
BOOL DlgGetAllRs485Slot::OnInitDialog() 
{
	CDialog::OnInitDialog();
	m_iDeviceIndex = g_pMainDlg->GetCurDeviceIndex();
	m_lUserID = g_struDeviceInfo[m_iDeviceIndex].lLoginID;
	m_listRs485Slot.SetExtendedStyle(LVS_EX_GRIDLINES | LVS_EX_FULLROWSELECT);
	m_listRs485Slot.InsertColumn(0, "485通道号", LVCFMT_LEFT, 80, -1);
	m_listRs485Slot.InsertColumn(1,"槽位号", LVCFMT_LEFT, 80, -1);
	m_listRs485Slot.InsertColumn(2,"前端设备名称", LVCFMT_LEFT, 150, -1);
	m_listRs485Slot.InsertColumn(3,"前端设备类型", LVCFMT_LEFT, 80, -1);
	m_listRs485Slot.InsertColumn(4,"前端设备协议", LVCFMT_LEFT, 80, -1);
	m_listRs485Slot.InsertColumn(5,"设备地址", LVCFMT_LEFT, 150, -1);

	GetDeviceTypeList(m_struDevTypeList);
	return TRUE;
}

BOOL DlgGetAllRs485Slot::GetDeviceTypeList(NET_DVR_DEVICE_TYPE_LIST& struDevTypeList)
{
    if (NET_DVR_GetDeviceTypeList(m_lUserID, &struDevTypeList))
    {
        g_pMainDlg->AddLog(m_iDeviceIndex, OPERATION_SUCC_T, "NET_DVR_GetDeviceTypeList");
        return TRUE;
    }
    else
    {
        g_pMainDlg->AddLog(m_iDeviceIndex, OPERATION_FAIL_T, "NET_DVR_GetDeviceTypeList");
        return FALSE;
    }
}

void DlgGetAllRs485Slot::OnBtnGet() 
{
	// TODO: Add your control notification handler code here
	NET_DVR_485_SLOT_LIST_INFO stru485SlotListInfo;
	memset(&stru485SlotListInfo,0,sizeof(NET_DVR_485_SLOT_LIST_INFO));
	stru485SlotListInfo.dwSize = sizeof(NET_DVR_485_SLOT_LIST_INFO);
	stru485SlotListInfo.byAll = 1;
	m_listRs485Slot.DeleteAllItems();
	m_iRowCount = 0;
	if (m_lHandle>=0)
	{
		g_pMainDlg->AddLog(m_iDeviceIndex, OPERATION_FAIL_T, "It is getting data, wait for a moment");
	}
	else
	{
		m_lHandle = NET_DVR_StartRemoteConfig(m_lUserID, NET_DVR_GET_ALL_ALARMHOST_RS485_SLOT_CFG, &stru485SlotListInfo, sizeof(NET_DVR_485_SLOT_LIST_INFO), NULL, this);
		if (m_lHandle>=0)
		{
			m_bGetNext = TRUE;
			g_pMainDlg->AddLog(m_iDeviceIndex, OPERATION_SUCC_T, "Start Remote Config successfully");
			DWORD dwThreadId;
			m_hGetInfoThread = CreateThread(NULL,0,LPTHREAD_START_ROUTINE(GetConfigThread), this, 0, &dwThreadId);
		}
		else
		{
			g_pMainDlg->AddLog(m_iDeviceIndex, OPERATION_FAIL_T, "Start Remote Config failed");
			return;
		}
	}
}
