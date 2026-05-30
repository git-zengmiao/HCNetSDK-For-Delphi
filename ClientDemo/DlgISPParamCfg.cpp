// DlgISPParamCfg.cpp : implementation file
//

#include "stdafx.h"
#include "clientdemo.h"
#include "DlgISPParamCfg.h"

#ifdef _DEBUG
#define new DEBUG_NEW
#undef THIS_FILE
static char THIS_FILE[] = __FILE__;
#endif

/////////////////////////////////////////////////////////////////////////////
// CDlgISPParamCfg dialog


CDlgISPParamCfg::CDlgISPParamCfg(CWnd* pParent/* =NULL*/)
	: CDialog(CDlgISPParamCfg::IDD, pParent)
{
	//{{AFX_DATA_INIT(CDlgISPParamCfg)
	m_bChkLightInhibitEn = FALSE;
	m_byBGain = 0;
	m_iBrightness = 0;
	m_iContrast = 0;
	m_byDehazeLevel = 0;
	m_byRGain = 0;
	m_iGain = 0;
	m_byNormalLevel = 0;
	m_iSharpness = 0;
	m_byElectLevel = 0;
	m_iBackLightModeLevel = 0;
	m_bySpectralLevel = 0;
	m_byTemporalLevel = 0;
	m_iVedioExposure = 0;
	m_iWDRContrastLevel = 0;
	m_iWDRLevel1 = 0;
	m_iWDRLevel2 = 0;
	m_bChkLightInhibitEnN = FALSE;
	m_byBGainN = 0;
	m_iBackLightModeLevelN = 0;
	m_iBrightnessN = 0;
	m_iContrastN = 0;
	m_byDehazeLevelN = 0;
	m_byElectLevelN = 0;
	m_iGainN = 0;
	m_byNormalLevelN = 0;
	m_byRGainN = 0;
	m_iSharpnessN = 0;
	m_bySpectralLevelN = 0;
	m_byTemporalLevelN = 0;
	m_iVedioExposureN = 0;
	m_iWDRContrastLevelN = 0;
	m_iWDRLevel1N = 0;
	m_iWDRLevel2N = 0;
	m_iDBackLightX1 = 0;
	m_iNBackLightX1 = 0;
	m_iDBackLightX2 = 0;
	m_iNBackLightX2 = 0;
	m_iNBackLightY1 = 0;
	m_iDBackLightY2 = 0;
	m_iNBackLightY2 = 0;
	m_iDBackLightY1 = 0;
	m_iExposureUserSetD = 0;
	m_iExposureUserSetN = 0;
	//}}AFX_DATA_INIT
	memset(&m_struISPCameraParamCfg, 0, sizeof(m_struISPCameraParamCfg));
}


void CDlgISPParamCfg::DoDataExchange(CDataExchange* pDX)
{
	CDialog::DoDataExchange(pDX);
	//{{AFX_DATA_MAP(CDlgISPParamCfg)
	DDX_Control(pDX, IDC_COMBO_WHITEBALANCE_MODE2, m_comboWhiteBalanceModeN);
	DDX_Control(pDX, IDC_COMBO_WDR_WORKTYPE2, m_comboWDRWorkTypeN);
	DDX_Control(pDX, IDC_COMBO_NOISEMOVEMODE2, m_comboNoiseMoveModeN);
	DDX_Control(pDX, IDC_COMBO_LIGHT_INHIBIT_LEVEL2, m_comboLightInhibitLevelN);
	DDX_Control(pDX, IDC_COMBO_GRAY_LEVEL2, m_comboGrayLevelN);
	DDX_Control(pDX, IDC_COMBO_DEHAZE_MODE2, m_comboDehazeModeN);
	DDX_Control(pDX, IDC_COMBO_BACKLIGHT_MODE2, m_comboBackLightModeN);
	DDX_Control(pDX, IDC_COM_ELECTE2, m_comElecteSwitchN);
	DDX_Control(pDX, IDC_COMBO_WDR_WORKTYPE, m_comboWDRWorkType);
	DDX_Control(pDX, IDC_COMBO_NOISEMOVEMODE, m_comboNoiseMoveMode);
	DDX_Control(pDX, IDC_COMBO_LIGHT_INHIBIT_LEVEL, m_comboLightInhibitLevel);
	DDX_Control(pDX, IDC_COMBO_GRAY_LEVEL, m_comboGrayLevel);
	DDX_Control(pDX, IDC_COMBO_DEHAZE_MODE, m_comboDehazeMode);
	DDX_Control(pDX, IDC_COMBO_BACKLIGHT_MODE, m_comboBackLightMode);
	DDX_Control(pDX, IDC_COM_ELECTE, m_comElecteSwitch);
	DDX_Control(pDX, IDC_COMBO_WHITEBALANCE_MODE, m_comboWhiteBalanceMode);
	DDX_Control(pDX, IDC_COMBO_WORKTYPE, m_comboWorkType);
	DDX_DateTimeCtrl(pDX, IDC_DATETIME_START, m_TimeStart);
	DDX_DateTimeCtrl(pDX, IDC_DATETIME_STOP, m_TimeStop);
	DDX_Check(pDX, IDC_CHK_LIGHT_INHIBIT_EN, m_bChkLightInhibitEn);
	DDX_Text(pDX, IDC_EDIT_B_GAIN, m_byBGain);
	DDX_Text(pDX, IDC_EDIT_BRIGHTNESS, m_iBrightness);
	DDX_Text(pDX, IDC_EDIT_CONTRAST, m_iContrast);
	DDX_Text(pDX, IDC_EDIT_DEHAZE_LEVEL, m_byDehazeLevel);
	DDX_Text(pDX, IDC_EDIT_R_GAIN, m_byRGain);
	DDX_Text(pDX, IDC_EDIT_GAIN, m_iGain);
	DDX_Text(pDX, IDC_EDIT_NORMAILEVEL, m_byNormalLevel);
	DDX_Text(pDX, IDC_EDIT_SHARPNESS, m_iSharpness);
	DDX_Text(pDX, IDC_EDIT_ELECT_LEVEL, m_byElectLevel);
	DDX_Text(pDX, IDC_EDIT_BACKLIGHT_MODE_LEVEL, m_iBackLightModeLevel);
	DDX_Text(pDX, IDC_EDIT_SPECTRALLEVEL, m_bySpectralLevel);
	DDX_Text(pDX, IDC_EDIT_TEMPORALLEVEL, m_byTemporalLevel);
	DDX_Text(pDX, IDC_EDIT_VEDIOEXPOSURE, m_iVedioExposure);
	DDX_Text(pDX, IDC_EDIT_WDR_CONTRAST_LEVEL, m_iWDRContrastLevel);
	DDX_Text(pDX, IDC_EDIT_WDR_LEVEL1, m_iWDRLevel1);
	DDX_Text(pDX, IDC_EDIT_WDR_LEVEL2, m_iWDRLevel2);
	DDX_Check(pDX, IDC_CHK_LIGHT_INHIBIT_EN2, m_bChkLightInhibitEnN);
	DDX_Text(pDX, IDC_EDIT_B_GAIN2, m_byBGainN);
	DDX_Text(pDX, IDC_EDIT_BACKLIGHT_MODE_LEVEL2, m_iBackLightModeLevelN);
	DDX_Text(pDX, IDC_EDIT_BRIGHTNESS2, m_iBrightnessN);
	DDX_Text(pDX, IDC_EDIT_CONTRAST2, m_iContrastN);
	DDX_Text(pDX, IDC_EDIT_DEHAZE_LEVEL2, m_byDehazeLevelN);
	DDX_Text(pDX, IDC_EDIT_ELECT_LEVEL2, m_byElectLevelN);
	DDX_Text(pDX, IDC_EDIT_GAIN2, m_iGainN);
	DDX_Text(pDX, IDC_EDIT_NORMAILEVEL2, m_byNormalLevelN);
	DDX_Text(pDX, IDC_EDIT_R_GAIN2, m_byRGainN);
	DDX_Text(pDX, IDC_EDIT_SHARPNESS2, m_iSharpnessN);
	DDX_Text(pDX, IDC_EDIT_SPECTRALLEVEL2, m_bySpectralLevelN);
	DDX_Text(pDX, IDC_EDIT_TEMPORALLEVEL2, m_byTemporalLevelN);
	DDX_Text(pDX, IDC_EDIT_VEDIOEXPOSURE2, m_iVedioExposureN);
	DDX_Text(pDX, IDC_EDIT_WDR_CONTRAST_LEVEL2, m_iWDRContrastLevelN);
	DDX_Text(pDX, IDC_EDIT_WDR_LEVEL3, m_iWDRLevel1N);
	DDX_Text(pDX, IDC_EDIT_WDR_LEVEL4, m_iWDRLevel2N);
	DDX_Text(pDX, IDC_EDIT_BACKLIGHT_X1_D, m_iDBackLightX1);
	DDX_Text(pDX, IDC_EDIT_BACKLIGHT_X1_N, m_iNBackLightX1);
	DDX_Text(pDX, IDC_EDIT_BACKLIGHT_X2_D, m_iDBackLightX2);
	DDX_Text(pDX, IDC_EDIT_BACKLIGHT_X2_N, m_iNBackLightX2);
	DDX_Text(pDX, IDC_EDIT_BACKLIGHT_Y1_N, m_iNBackLightY1);
	DDX_Text(pDX, IDC_EDIT_BACKLIGHT_Y2_D, m_iDBackLightY2);
	DDX_Text(pDX, IDC_EDIT_BACKLIGHT_Y2_N, m_iNBackLightY2);
	DDX_Text(pDX, IDC_EDIT_BACKLIGHT_Y1_D, m_iDBackLightY1);
	DDX_Text(pDX, IDC_EDIT_EXPOSURE_USERSET_D, m_iExposureUserSetD);
	DDX_Text(pDX, IDC_EDIT_EXPOSURE_USERSET_N, m_iExposureUserSetN);
	//}}AFX_DATA_MAP
}


BEGIN_MESSAGE_MAP(CDlgISPParamCfg, CDialog)
	//{{AFX_MSG_MAP(CDlgISPParamCfg)
	ON_BN_CLICKED(IDC_BTN_SAVE, OnBtnSave)
	ON_WM_CANCELMODE()
	//}}AFX_MSG_MAP
END_MESSAGE_MAP()

/////////////////////////////////////////////////////////////////////////////
// CDlgISPParamCfg message handlers

void CDlgISPParamCfg::OnBtnSave() 
{
	// TODO: Add your control notification handler code here
	OnGetParamFormWnd();
	memcpy(m_pstruISPCameraParamcfg, &m_struISPCameraParamCfg, sizeof(m_struISPCameraParamCfg));
}

void CDlgISPParamCfg::OnGetParamFormWnd()
{
	UpdateData(TRUE);	
	m_struISPCameraParamCfg.dwSize = sizeof(m_struISPCameraParamCfg);
	m_struISPCameraParamCfg.byWorkType = m_comboWorkType.GetCurSel();
	//开始时间
	m_struISPCameraParamCfg.struDayNightScheduleTime.struStartTime.byHour = m_TimeStart.GetHour();
	m_struISPCameraParamCfg.struDayNightScheduleTime.struStartTime.byMinute = m_TimeStart.GetMinute();
	m_struISPCameraParamCfg.struDayNightScheduleTime.struStartTime.bySecond = m_TimeStart.GetSecond();
	//结束时间
	m_struISPCameraParamCfg.struDayNightScheduleTime.struStopTime.byHour = m_TimeStop.GetHour();
	m_struISPCameraParamCfg.struDayNightScheduleTime.struStopTime.byMinute = m_TimeStop.GetMinute();
	m_struISPCameraParamCfg.struDayNightScheduleTime.struStopTime.bySecond = m_TimeStop.GetSecond();

	//白天参数
	m_struISPCameraParamCfg.struDayIspAdvanceParam.struVideoEffect.byBrightnessLevel = m_iBrightness;
	m_struISPCameraParamCfg.struDayIspAdvanceParam.struVideoEffect.byContrastLevel = m_iContrast;
    m_struISPCameraParamCfg.struDayIspAdvanceParam.struVideoEffect.bySharpnessLevel = m_iSharpness;
	m_struISPCameraParamCfg.struDayIspAdvanceParam.struVideoEffect.byEnableFunc = 0;
	m_struISPCameraParamCfg.struDayIspAdvanceParam.struVideoEffect.byEnableFunc |= (m_bChkLightInhibitEn<<2);

	m_struISPCameraParamCfg.struDayIspAdvanceParam.struVideoEffect.byLightInhibitLevel = m_comboLightInhibitLevel.GetCurSel()+1;
	m_struISPCameraParamCfg.struDayIspAdvanceParam.struVideoEffect.byGrayLevel = m_comboGrayLevel.GetCurSel();

	m_struISPCameraParamCfg.struDayIspAdvanceParam.struExposure.dwVideoExposureSet = m_iVedioExposure;
	m_struISPCameraParamCfg.struDayIspAdvanceParam.struExposure.dwExposureUserSet = m_iExposureUserSetD;

	m_struISPCameraParamCfg.struDayIspAdvanceParam.struWhiteBalance.byWhiteBalanceMode = m_comboWhiteBalanceMode.GetCurSel();
	m_struISPCameraParamCfg.struDayIspAdvanceParam.struWhiteBalance.byWhiteBalanceModeBGain = m_byBGain;
	m_struISPCameraParamCfg.struDayIspAdvanceParam.struWhiteBalance.byWhiteBalanceModeRGain = m_byRGain;
	
	m_struISPCameraParamCfg.struDayIspAdvanceParam.struNoiseRemove.byDigitalNoiseRemoveEnable = m_comboNoiseMoveMode.GetCurSel();
	m_struISPCameraParamCfg.struDayIspAdvanceParam.struNoiseRemove.byDigitalNoiseRemoveLevel = m_byNormalLevel;
	m_struISPCameraParamCfg.struDayIspAdvanceParam.struNoiseRemove.bySpectralLevel = m_bySpectralLevel;
	m_struISPCameraParamCfg.struDayIspAdvanceParam.struNoiseRemove.byTemporalLevel = m_byTemporalLevel;

	m_struISPCameraParamCfg.struDayIspAdvanceParam.struGain.byGainLevel = m_iGain;
	m_struISPCameraParamCfg.struDayIspAdvanceParam.struBackLight.byBacklightMode = m_comboBackLightMode.GetCurSel();
	m_struISPCameraParamCfg.struDayIspAdvanceParam.struBackLight.byBacklightLevel = m_iBackLightModeLevel;
	m_struISPCameraParamCfg.struDayIspAdvanceParam.struBackLight.dwPositionX1 = m_iDBackLightX1;
	m_struISPCameraParamCfg.struDayIspAdvanceParam.struBackLight.dwPositionX2 = m_iDBackLightX2;
	m_struISPCameraParamCfg.struDayIspAdvanceParam.struBackLight.dwPositionY1 = m_iDBackLightY1;
	m_struISPCameraParamCfg.struDayIspAdvanceParam.struBackLight.dwPositionY2 = m_iDBackLightY2;

	m_struISPCameraParamCfg.struDayIspAdvanceParam.struDefogCfg.byMode = m_comboDehazeMode.GetCurSel();
	m_struISPCameraParamCfg.struDayIspAdvanceParam.struDefogCfg.byLevel = m_byDehazeLevel;
	
	m_struISPCameraParamCfg.struDayIspAdvanceParam.struElectronicStabilization.byEnable = m_comElecteSwitch.GetCurSel();
	m_struISPCameraParamCfg.struDayIspAdvanceParam.struElectronicStabilization.byLevel = m_byElectLevel;
	
	//宽动态
	m_struISPCameraParamCfg.struDayIspAdvanceParam.struWdr.byWDREnabled = m_comboWDRWorkType.GetCurSel();
	m_struISPCameraParamCfg.struDayIspAdvanceParam.struWdr.byWDRContrastLevel = m_iWDRContrastLevel;
	m_struISPCameraParamCfg.struDayIspAdvanceParam.struWdr.byWDRLevel1 = m_iWDRLevel1;
	m_struISPCameraParamCfg.struDayIspAdvanceParam.struWdr.byWDRLevel2 = m_iWDRLevel2;

	//夜晚参数
	m_struISPCameraParamCfg.struNightIspAdvanceParam.struVideoEffect.byBrightnessLevel = m_iBrightnessN;
	m_struISPCameraParamCfg.struNightIspAdvanceParam.struVideoEffect.byContrastLevel = m_iContrastN;
    m_struISPCameraParamCfg.struNightIspAdvanceParam.struVideoEffect.bySharpnessLevel = m_iSharpnessN;
	m_struISPCameraParamCfg.struNightIspAdvanceParam.struVideoEffect.byEnableFunc = 0;
	m_struISPCameraParamCfg.struNightIspAdvanceParam.struVideoEffect.byEnableFunc |= (m_bChkLightInhibitEnN<<2);
	
	m_struISPCameraParamCfg.struNightIspAdvanceParam.struVideoEffect.byLightInhibitLevel = m_comboLightInhibitLevelN.GetCurSel()+1;
	m_struISPCameraParamCfg.struNightIspAdvanceParam.struVideoEffect.byGrayLevel = m_comboGrayLevelN.GetCurSel();
	
	m_struISPCameraParamCfg.struNightIspAdvanceParam.struExposure.dwVideoExposureSet = m_iVedioExposureN;
	m_struISPCameraParamCfg.struNightIspAdvanceParam.struExposure.dwExposureUserSet = m_iExposureUserSetN;

	m_struISPCameraParamCfg.struNightIspAdvanceParam.struWhiteBalance.byWhiteBalanceMode = m_comboWhiteBalanceModeN.GetCurSel();
	m_struISPCameraParamCfg.struNightIspAdvanceParam.struWhiteBalance.byWhiteBalanceModeBGain = m_byBGainN;
	m_struISPCameraParamCfg.struNightIspAdvanceParam.struWhiteBalance.byWhiteBalanceModeRGain = m_byRGainN;
	
	m_struISPCameraParamCfg.struNightIspAdvanceParam.struNoiseRemove.byDigitalNoiseRemoveEnable = m_comboNoiseMoveModeN.GetCurSel();
	m_struISPCameraParamCfg.struNightIspAdvanceParam.struNoiseRemove.byDigitalNoiseRemoveLevel = m_byNormalLevelN;
	m_struISPCameraParamCfg.struNightIspAdvanceParam.struNoiseRemove.bySpectralLevel = m_bySpectralLevelN;
	m_struISPCameraParamCfg.struNightIspAdvanceParam.struNoiseRemove.byTemporalLevel = m_byTemporalLevelN;
	
	m_struISPCameraParamCfg.struNightIspAdvanceParam.struGain.byGainLevel = m_iGain;
	m_struISPCameraParamCfg.struNightIspAdvanceParam.struBackLight.byBacklightMode = m_comboBackLightModeN.GetCurSel();
	m_struISPCameraParamCfg.struNightIspAdvanceParam.struBackLight.byBacklightLevel = m_iBackLightModeLevelN;
	m_struISPCameraParamCfg.struNightIspAdvanceParam.struBackLight.dwPositionX1 = m_iNBackLightX1;
	m_struISPCameraParamCfg.struNightIspAdvanceParam.struBackLight.dwPositionX2 = m_iNBackLightX2;
	m_struISPCameraParamCfg.struNightIspAdvanceParam.struBackLight.dwPositionY1 = m_iNBackLightY1;
	m_struISPCameraParamCfg.struNightIspAdvanceParam.struBackLight.dwPositionY2 = m_iNBackLightY2;
	
	m_struISPCameraParamCfg.struNightIspAdvanceParam.struDefogCfg.byMode = m_comboDehazeModeN.GetCurSel();
	m_struISPCameraParamCfg.struNightIspAdvanceParam.struDefogCfg.byLevel = m_byDehazeLevelN;
	
	m_struISPCameraParamCfg.struNightIspAdvanceParam.struElectronicStabilization.byEnable = m_comElecteSwitchN.GetCurSel();
	m_struISPCameraParamCfg.struNightIspAdvanceParam.struElectronicStabilization.byLevel = m_byElectLevelN;
	
	//宽动态
	m_struISPCameraParamCfg.struNightIspAdvanceParam.struWdr.byWDREnabled = m_comboWDRWorkTypeN.GetCurSel();
	m_struISPCameraParamCfg.struNightIspAdvanceParam.struWdr.byWDRContrastLevel = m_iWDRContrastLevelN;
	m_struISPCameraParamCfg.struNightIspAdvanceParam.struWdr.byWDRLevel1 = m_iWDRLevel1N;
	m_struISPCameraParamCfg.struNightIspAdvanceParam.struWdr.byWDRLevel2 = m_iWDRLevel2N;

}

void CDlgISPParamCfg::OnSetParamToWnd()
{
	m_comboWorkType.SetCurSel(m_struISPCameraParamCfg.byWorkType);
	//开始时间
	m_TimeStart.SetTime(m_struISPCameraParamCfg.struDayNightScheduleTime.struStartTime.byHour, \
		m_struISPCameraParamCfg.struDayNightScheduleTime.struStartTime.byMinute, \
		m_struISPCameraParamCfg.struDayNightScheduleTime.struStartTime.bySecond
		);

	//结束时间	
	m_TimeStop.SetTime(m_struISPCameraParamCfg.struDayNightScheduleTime.struStopTime.byHour, \
		m_struISPCameraParamCfg.struDayNightScheduleTime.struStopTime.byMinute, \
		m_struISPCameraParamCfg.struDayNightScheduleTime.struStopTime.bySecond
		);

	//白天参数
	m_iBrightness = m_struISPCameraParamCfg.struDayIspAdvanceParam.struVideoEffect.byBrightnessLevel;
	m_iContrast = m_struISPCameraParamCfg.struDayIspAdvanceParam.struVideoEffect.byContrastLevel;
    m_iSharpness = m_struISPCameraParamCfg.struDayIspAdvanceParam.struVideoEffect.bySharpnessLevel;
	m_bChkLightInhibitEn = (m_struISPCameraParamCfg.struDayIspAdvanceParam.struVideoEffect.byEnableFunc>>2)&0x01;
	
	m_comboLightInhibitLevel.SetCurSel(m_struISPCameraParamCfg.struDayIspAdvanceParam.struVideoEffect.byLightInhibitLevel - 1);
	m_comboGrayLevel.SetCurSel(m_struISPCameraParamCfg.struDayIspAdvanceParam.struVideoEffect.byGrayLevel);
	
	m_iVedioExposure = m_struISPCameraParamCfg.struDayIspAdvanceParam.struExposure.dwVideoExposureSet;
	m_iExposureUserSetD = m_struISPCameraParamCfg.struDayIspAdvanceParam.struExposure.dwExposureUserSet;

	m_comboWhiteBalanceMode.SetCurSel(m_struISPCameraParamCfg.struDayIspAdvanceParam.struWhiteBalance.byWhiteBalanceMode);
	m_byBGain = m_struISPCameraParamCfg.struDayIspAdvanceParam.struWhiteBalance.byWhiteBalanceModeBGain;
	m_byRGain = m_struISPCameraParamCfg.struDayIspAdvanceParam.struWhiteBalance.byWhiteBalanceModeRGain;
	
	m_comboNoiseMoveMode.SetCurSel(m_struISPCameraParamCfg.struDayIspAdvanceParam.struNoiseRemove.byDigitalNoiseRemoveEnable);
	m_byNormalLevel = m_struISPCameraParamCfg.struDayIspAdvanceParam.struNoiseRemove.byDigitalNoiseRemoveLevel;
	m_bySpectralLevel = m_struISPCameraParamCfg.struDayIspAdvanceParam.struNoiseRemove.bySpectralLevel;
	m_byTemporalLevel = m_struISPCameraParamCfg.struDayIspAdvanceParam.struNoiseRemove.byTemporalLevel;
	
	m_iGain = m_struISPCameraParamCfg.struDayIspAdvanceParam.struGain.byGainLevel;
	m_comboBackLightMode.SetCurSel(m_struISPCameraParamCfg.struDayIspAdvanceParam.struBackLight.byBacklightMode);
	m_iBackLightModeLevel = m_struISPCameraParamCfg.struDayIspAdvanceParam.struBackLight.byBacklightLevel;
	m_iDBackLightX1 = m_struISPCameraParamCfg.struDayIspAdvanceParam.struBackLight.dwPositionX1;
	m_iDBackLightX2 = m_struISPCameraParamCfg.struDayIspAdvanceParam.struBackLight.dwPositionX2;
	m_iDBackLightY1 = m_struISPCameraParamCfg.struDayIspAdvanceParam.struBackLight.dwPositionY1;
	m_iDBackLightY2 = m_struISPCameraParamCfg.struDayIspAdvanceParam.struBackLight.dwPositionY2;
	
	m_comboDehazeMode.SetCurSel(m_struISPCameraParamCfg.struDayIspAdvanceParam.struDefogCfg.byMode);
	m_byDehazeLevel = m_struISPCameraParamCfg.struDayIspAdvanceParam.struDefogCfg.byLevel;
	
	m_comElecteSwitch.SetCurSel(m_struISPCameraParamCfg.struDayIspAdvanceParam.struElectronicStabilization.byEnable);
	m_byElectLevel = m_struISPCameraParamCfg.struDayIspAdvanceParam.struElectronicStabilization.byLevel;
	
	//宽动态
	m_comboWDRWorkType.SetCurSel(m_struISPCameraParamCfg.struDayIspAdvanceParam.struWdr.byWDREnabled);
	m_iWDRContrastLevel = m_struISPCameraParamCfg.struDayIspAdvanceParam.struWdr.byWDRContrastLevel;
	m_iWDRLevel1 = m_struISPCameraParamCfg.struDayIspAdvanceParam.struWdr.byWDRLevel1;
	m_iWDRLevel2 = m_struISPCameraParamCfg.struDayIspAdvanceParam.struWdr.byWDRLevel2;

	//夜晚参数
	m_iBrightnessN = m_struISPCameraParamCfg.struNightIspAdvanceParam.struVideoEffect.byBrightnessLevel;
	m_iContrastN = m_struISPCameraParamCfg.struNightIspAdvanceParam.struVideoEffect.byContrastLevel;
    m_iSharpnessN = m_struISPCameraParamCfg.struNightIspAdvanceParam.struVideoEffect.bySharpnessLevel;
	m_bChkLightInhibitEnN = (m_struISPCameraParamCfg.struNightIspAdvanceParam.struVideoEffect.byEnableFunc>>2)&0x01;
	
	m_comboLightInhibitLevelN.SetCurSel(m_struISPCameraParamCfg.struNightIspAdvanceParam.struVideoEffect.byLightInhibitLevel - 1);
	m_comboGrayLevelN.SetCurSel(m_struISPCameraParamCfg.struNightIspAdvanceParam.struVideoEffect.byGrayLevel);
	
	m_iVedioExposureN = m_struISPCameraParamCfg.struNightIspAdvanceParam.struExposure.dwVideoExposureSet;
	m_iExposureUserSetN = m_struISPCameraParamCfg.struNightIspAdvanceParam.struExposure.dwExposureUserSet;

	m_comboWhiteBalanceModeN.SetCurSel(m_struISPCameraParamCfg.struNightIspAdvanceParam.struWhiteBalance.byWhiteBalanceMode);
	m_byBGainN = m_struISPCameraParamCfg.struNightIspAdvanceParam.struWhiteBalance.byWhiteBalanceModeBGain;
	m_byRGainN = m_struISPCameraParamCfg.struNightIspAdvanceParam.struWhiteBalance.byWhiteBalanceModeRGain;
	
	m_comboNoiseMoveModeN.SetCurSel(m_struISPCameraParamCfg.struNightIspAdvanceParam.struNoiseRemove.byDigitalNoiseRemoveEnable);
	m_byNormalLevelN = m_struISPCameraParamCfg.struNightIspAdvanceParam.struNoiseRemove.byDigitalNoiseRemoveLevel;
	m_bySpectralLevelN = m_struISPCameraParamCfg.struNightIspAdvanceParam.struNoiseRemove.bySpectralLevel;
	m_byTemporalLevelN = m_struISPCameraParamCfg.struNightIspAdvanceParam.struNoiseRemove.byTemporalLevel;
	
	m_iGainN = m_struISPCameraParamCfg.struNightIspAdvanceParam.struGain.byGainLevel;
	m_comboBackLightModeN.SetCurSel(m_struISPCameraParamCfg.struNightIspAdvanceParam.struBackLight.byBacklightMode);
	m_iBackLightModeLevelN = m_struISPCameraParamCfg.struNightIspAdvanceParam.struBackLight.byBacklightLevel;
	m_iNBackLightX1 = m_struISPCameraParamCfg.struNightIspAdvanceParam.struBackLight.dwPositionX1;
	m_iNBackLightX2 = m_struISPCameraParamCfg.struNightIspAdvanceParam.struBackLight.dwPositionX2;
	m_iNBackLightY1 = m_struISPCameraParamCfg.struNightIspAdvanceParam.struBackLight.dwPositionY1;
	m_iNBackLightY2 = m_struISPCameraParamCfg.struNightIspAdvanceParam.struBackLight.dwPositionY2;
	
	m_comboDehazeModeN.SetCurSel(m_struISPCameraParamCfg.struNightIspAdvanceParam.struDefogCfg.byMode);
	m_byDehazeLevelN = m_struISPCameraParamCfg.struNightIspAdvanceParam.struDefogCfg.byLevel;
	
	m_comElecteSwitchN.SetCurSel(m_struISPCameraParamCfg.struNightIspAdvanceParam.struElectronicStabilization.byEnable);
	m_byElectLevelN = m_struISPCameraParamCfg.struNightIspAdvanceParam.struElectronicStabilization.byLevel;
	
	//宽动态
	m_comboWDRWorkTypeN.SetCurSel(m_struISPCameraParamCfg.struNightIspAdvanceParam.struWdr.byWDREnabled);
	m_iWDRContrastLevelN = m_struISPCameraParamCfg.struNightIspAdvanceParam.struWdr.byWDRContrastLevel;
	m_iWDRLevel1N = m_struISPCameraParamCfg.struNightIspAdvanceParam.struWdr.byWDRLevel1;
	m_iWDRLevel2N = m_struISPCameraParamCfg.struNightIspAdvanceParam.struWdr.byWDRLevel2;

	UpdateData(FALSE);
}

BOOL CDlgISPParamCfg::OnInitDialog() 
{
	CDialog::OnInitDialog();
	
	// TODO: Add extra initialization here
	InitWnd();

	memcpy(&m_struISPCameraParamCfg, m_pstruISPCameraParamcfg, sizeof(m_struISPCameraParamCfg));
	OnSetParamToWnd();

	return TRUE;  // return TRUE unless you set the focus to a control
	              // EXCEPTION: OCX Property Pages should return FALSE
}

void CDlgISPParamCfg::InitWnd()
{
	char szLan[128] = {0};

	m_comboWhiteBalanceMode.ResetContent();
	g_StringLanType(szLan, "手动白平衡","MWB");
	m_comboWhiteBalanceMode.InsertString(0, szLan);
	m_comboWhiteBalanceMode.SetItemData(0, 0);
	
	g_StringLanType(szLan, "自动白平衡1", "AWB1");
	m_comboWhiteBalanceMode.InsertString(1, szLan);
	m_comboWhiteBalanceMode.SetItemData(1, 1);
	
	g_StringLanType(szLan, "自动白平衡2", "AWB2");
	m_comboWhiteBalanceMode.InsertString(2, szLan);
	m_comboWhiteBalanceMode.SetItemData(2, 2);
	
	g_StringLanType(szLan, "锁定白平衡", "Locked WB");
	m_comboWhiteBalanceMode.InsertString(3, szLan);
	m_comboWhiteBalanceMode.SetItemData(3, 3);
	
	g_StringLanType(szLan, "室外", "Outdoor");
	m_comboWhiteBalanceMode.InsertString(4, szLan);
	m_comboWhiteBalanceMode.SetItemData(4, 4);
	
	g_StringLanType(szLan, "室内", "Indoor");
	m_comboWhiteBalanceMode.InsertString(5, szLan);
	m_comboWhiteBalanceMode.SetItemData(5, 5);
	
	g_StringLanType(szLan, "日光灯", "Fluorescent Lamp");
	m_comboWhiteBalanceMode.InsertString(6, szLan);
	m_comboWhiteBalanceMode.SetItemData(6, 6);
	
	g_StringLanType(szLan, "钠灯", "Sodium Lamp");
	m_comboWhiteBalanceMode.InsertString(7, szLan);
	m_comboWhiteBalanceMode.SetItemData(7, 7);
	
	g_StringLanType(szLan, "自动跟随", "Auto-Track");
	m_comboWhiteBalanceMode.InsertString(8, szLan);
	m_comboWhiteBalanceMode.SetItemData(8, 8);
	
	g_StringLanType(szLan, "一次白平衡", "One Push");
	m_comboWhiteBalanceMode.InsertString(9, szLan);
	m_comboWhiteBalanceMode.SetItemData(9, 9);
	
	g_StringLanType(szLan, "室外自动", "Auto-Outdoor");
	m_comboWhiteBalanceMode.InsertString(10, szLan);
	m_comboWhiteBalanceMode.SetItemData(10, 10);
	
	g_StringLanType(szLan, "钠灯自动", "Auto-Sodiumlight");
	m_comboWhiteBalanceMode.InsertString(11, szLan);
	m_comboWhiteBalanceMode.SetItemData(11, 11);
	
	g_StringLanType(szLan, "水银灯", "Mercury Lamp");
	m_comboWhiteBalanceMode.InsertString(12, szLan);
	m_comboWhiteBalanceMode.SetItemData(12, 12);
	
	g_StringLanType(szLan, "自动白平衡", "Auto-WB");
	m_comboWhiteBalanceMode.InsertString(13, szLan);
	m_comboWhiteBalanceMode.SetItemData(13, 13);
	
	g_StringLanType(szLan, "白炽灯", "IncandescentLamp");
	m_comboWhiteBalanceMode.InsertString(14, szLan);
	m_comboWhiteBalanceMode.SetItemData(14, 14);
	
	g_StringLanType(szLan, "暖光灯", "Warm Light Lamp");
	m_comboWhiteBalanceMode.InsertString(15, szLan);
	m_comboWhiteBalanceMode.SetItemData(15, 15);
	
	g_StringLanType(szLan, "自然光", "Natural Light");
	m_comboWhiteBalanceMode.InsertString(16, szLan);
	m_comboWhiteBalanceMode.SetItemData(16, 16);

	//
	m_comboWhiteBalanceModeN.ResetContent();
	g_StringLanType(szLan, "手动白平衡","MWB");
	m_comboWhiteBalanceModeN.InsertString(0, szLan);
	m_comboWhiteBalanceModeN.SetItemData(0, 0);
	
	g_StringLanType(szLan, "自动白平衡1", "AWB1");
	m_comboWhiteBalanceModeN.InsertString(1, szLan);
	m_comboWhiteBalanceModeN.SetItemData(1, 1);
	
	g_StringLanType(szLan, "自动白平衡2", "AWB2");
	m_comboWhiteBalanceModeN.InsertString(2, szLan);
	m_comboWhiteBalanceModeN.SetItemData(2, 2);
	
	g_StringLanType(szLan, "锁定白平衡", "Locked WB");
	m_comboWhiteBalanceModeN.InsertString(3, szLan);
	m_comboWhiteBalanceModeN.SetItemData(3, 3);
	
	g_StringLanType(szLan, "室外", "Outdoor");
	m_comboWhiteBalanceModeN.InsertString(4, szLan);
	m_comboWhiteBalanceModeN.SetItemData(4, 4);
	
	g_StringLanType(szLan, "室内", "Indoor");
	m_comboWhiteBalanceModeN.InsertString(5, szLan);
	m_comboWhiteBalanceModeN.SetItemData(5, 5);
	
	g_StringLanType(szLan, "日光灯", "Fluorescent Lamp");
	m_comboWhiteBalanceModeN.InsertString(6, szLan);
	m_comboWhiteBalanceModeN.SetItemData(6, 6);
	
	g_StringLanType(szLan, "钠灯", "Sodium Lamp");
	m_comboWhiteBalanceModeN.InsertString(7, szLan);
	m_comboWhiteBalanceModeN.SetItemData(7, 7);
	
	g_StringLanType(szLan, "自动跟随", "Auto-Track");
	m_comboWhiteBalanceModeN.InsertString(8, szLan);
	m_comboWhiteBalanceModeN.SetItemData(8, 8);
	
	g_StringLanType(szLan, "一次白平衡", "One Push");
	m_comboWhiteBalanceModeN.InsertString(9, szLan);
	m_comboWhiteBalanceModeN.SetItemData(9, 9);
	
	g_StringLanType(szLan, "室外自动", "Auto-Outdoor");
	m_comboWhiteBalanceModeN.InsertString(10, szLan);
	m_comboWhiteBalanceModeN.SetItemData(10, 10);
	
	g_StringLanType(szLan, "钠灯自动", "Auto-Sodiumlight");
	m_comboWhiteBalanceModeN.InsertString(11, szLan);
	m_comboWhiteBalanceModeN.SetItemData(11, 11);
	
	g_StringLanType(szLan, "水银灯", "Mercury Lamp");
	m_comboWhiteBalanceModeN.InsertString(12, szLan);
	m_comboWhiteBalanceModeN.SetItemData(12, 12);
	
	g_StringLanType(szLan, "自动白平衡", "Auto-WB");
	m_comboWhiteBalanceModeN.InsertString(13, szLan);
	m_comboWhiteBalanceModeN.SetItemData(13, 13);
	
	g_StringLanType(szLan, "白炽灯", "IncandescentLamp");
	m_comboWhiteBalanceModeN.InsertString(14, szLan);
	m_comboWhiteBalanceModeN.SetItemData(14, 14);
	
	g_StringLanType(szLan, "暖光灯", "Warm Light Lamp");
	m_comboWhiteBalanceModeN.InsertString(15, szLan);
	m_comboWhiteBalanceModeN.SetItemData(15, 15);
	
	g_StringLanType(szLan, "自然光", "Natural Light");
	m_comboWhiteBalanceModeN.InsertString(16, szLan);
	m_comboWhiteBalanceModeN.SetItemData(16, 16);

	UpdateData(FALSE);
}
void CDlgISPParamCfg::OnCancelMode() 
{
	CDialog::OnCancelMode();
	
	// TODO: Add your message handler code here
	
}
