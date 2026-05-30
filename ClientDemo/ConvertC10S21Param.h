
#ifndef _CONVERT_C10S21_PARAM_H_
#define _CONVERT_C10S21_PARAM_H_

#include "XMLParamsConvert.h"

/************************************************************************/
/* 结构体及宏定义                                                   
/************************************************************************/
#define MAX_LEN_USERNAME      32
#define MAX_LEN_PASSWORD      64
#define MAX_NUM_SCREEN_SERVER 32

typedef struct tagNET_DVR_IPADDR_ //IP地址
{		
    char	sIpV4[16];	 //IPv4地址
    char 	sIpV6[128];  //保留
}NET_DVR_IPADDR_, *LPNET_DVR_IPADDR_;

typedef struct tagNET_DVR_SCREEN_SERVER_LOGIN_CFG
{
	DWORD dwSize;
	DWORD dwServerNo;
	NET_DVR_IPADDR_ struIPAddr;
	DWORD dwPortNo;
	char  sUserName[MAX_LEN_USERNAME];
	char  sPassword[MAX_LEN_PASSWORD];
	DWORD dwInputNo;
}NET_DVR_SCREEN_SERVER_LOGIN_CFG, *LPNET_DVR_SCREEN_SERVER_LOGIN_CFG;

typedef struct tagNET_DVR_SCREEN_SERVER_LOGIN_CFG_LIST
{
	DWORD dwSize;
	NET_DVR_SCREEN_SERVER_LOGIN_CFG struList[MAX_NUM_SCREEN_SERVER];
}NET_DVR_SCREEN_SERVER_LOGIN_CFG_LIST, *LPNET_DVR_SCREEN_SERVER_LOGIN_CFG_LIST;

/************************************************************************/
/* 转换函数定义
/************************************************************************/
BOOL ConvertScreenServerLoginParamXmlToStru(CXmlBase& struXml, void* pStruct);
BOOL ConvertScreenServerLoginParamXmlToStru(const char* pXmlBuf, void* pStruct);
BOOL ConvertScreenServerLoginParamXmlToStruList(const char* pXmlBuf, void* pStruct);
BOOL ConvertScreenServerLoginParamStruToXml(void* pStruct, char* *pXmlBuf, DWORD &dwXmlLen);
DWORD GetIDFromResponseStatus(const char* pXmlBuf);
















#endif
