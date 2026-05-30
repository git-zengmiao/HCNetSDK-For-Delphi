unit DecodeCardSdk;

//============================================================================
// Hikvision DS-40xxHC/HF BOARD SYSTEM SDK
// Delphi VCL/FMX compatible translation
// Based on: incEn/DecodeCardSdk.h
// DS-40xxHC/HF系列解码卡SDK接口函数声明，解码卡SDK (DsSdk.dll)，含HW_播放器API
//============================================================================

interface

{$IFDEF MSWINDOWS}
  {$IF CompilerVersion >= 23.0}
  uses Winapi.Windows, Winapi.Messages;
  {$ELSE}
  uses Windows, Messages;
  {$ENDIF}
{$ELSE}
  uses Types;
{$ENDIF}

uses
  DataType;

type
  PHANDLE = ^HANDLE;
  PUSHORT = ^USHORT;
  PPUSHORT = ^PUSHORT;

const
  DLL_DECODECARD = 'DsSdk.dll';   // Decode card SDK DLL name

const
  // Error codes
  ERR_WAIT_TIMEOUT                = $c0000001;
  ERR_INVALID_HANDLE              = $c0000002;
  ERR_INVALID_ARGUMENT            = $c0000003;
  ERR_DDRAW_CREATE_FAILED         = $c0000004;
  ERR_DDRAW_CAPS_FAULT            = $c0000005;
  ERR_SET_COOPERATIVELEVEL_FAILED = $c0000006;
  ERR_PRIMARY_SURFACE_CREATE_FAILED = $c0000007;
  ERR_GET_OVERLAY_ADDRESS_FAILED  = $c0000008;
  ERR_OVERLAY_SURFACE_CREATE_FAILED = $c0000009;
  ERR_OVERLAY_UPDATE_FAILED       = $c000000a;
  ERR_TMMAN_FAILURE               = $c000000b;
  ERR_CHANNELMAGIC_MISMATCH       = $c000000c;
  ERR_CALLBACK_REGISTERED         = $c000000d;
  ERR_QUEUE_OVERFLOW              = $c000000e;
  ERR_STREAM_THREAD_FAILURE       = $c000000f;
  ERR_THREAD_STOP_ERROR           = $c0000010;
  ERR_NOT_SUPPORT                 = $c0000011;
  ERR_OUTOF_MEMORY                = $c0000012;
  ERR_DSP_BUSY                    = $c0000013;
  ERR_DATA_ERROR                  = $c0000014;
  ERR_KERNEL                      = $c0000016;
  ERR_OFFSCREEN_CREATE_FAILED     = $c0000017;
  ERR_MULTICLOCK_FAILURE          = $c0000018;
  ERR_INVALID_DEVICE              = $c0000019;
  ERR_INVALID_DRIVER              = $c000001a;

  // Error codes for MD card
  HWERR_SUCCESS                      = 0;
  HWERR_ALLOCATE_MEMORY              = $c1000001;
  HWERR_INVALID_HANDLE               = $c1000002;
  HWERR_DDRAW_CREATE_FAILED          = $c1000003;
  HWERR_DDRAW_CAPS_FAULT             = $c1000004;
  HWERR_SET_COOPERATIVELEVEL_FAILED  = $c1000005;
  HWERR_PRIMARY_SURFACE_CREATE_FAILED = $c1000006;
  HWERR_OVERLAY_CREATE_FAILED        = $c1000007;
  HWERR_GET_OVERLAY_ADDRESS_FAILED   = $c1000008;
  HWERR_OVERLAY_UPDATE_FAILED        = $c1000009;
  HWERR_SURFACE_NULL                 = $c100000a;
  HWERR_FILEHEADER_UNKNOWN           = $c100000b;
  HWERR_CREATE_FILE_FAILED           = $c100000c;
  HWERR_FILE_SIZE_ZERO               = $c100000d;
  HWERR_FILE_SIZE_INVALID            = $c100000d;
  HWERR_CREATE_OBJ_FAILED            = $c100000e;
  HWERR_CHANNELMAGIC_MISMATCH        = $c100000f;
  HWERR_PARA_OVER                    = $c1000010;
  HWERR_ORDER                        = $c1000011;
  HWERR_COMMAND                      = $c1000012;
  HWERR_UNSUPPORTED                  = $c1000013;
  HWERR_DSPOPEN                      = $c1000014;
  HWERR_DSPLOAD                      = $c1000015;
  HWERR_ALLOCATE_DSPMEMORY           = $c1000016;
  HWERR_DSPCHECHER                   = $c1000017;
  HWERR_IMGFILE_UNKNOWN              = $c1000018;
  HWERR_INVALID_FILE                 = $c1000019;

  // Video standards
  HW_PAL  = 2;
  HW_NTSC = 1;

  // Jump direction
  HW_JUMP_FORWARD   = 309;
  HW_JUMP_BACKWARD  = 310;

  // Stream types
  STREAM_TYPE_VIDEO  = 1;
  STREAM_TYPE_AUDIO  = 2;
  STREAM_TYPE_AVSYNC = 3;

  // Maximum display regions
  MAX_DISPLAY_REGION = 16;

  // Serial number length
  SERIAL_NUMBER_LENGTH = 12;

type
  // Video format type
  TypeVideoFormat = (
    vdfRGB8A_233              = $00000001,
    vdfRGB8R_332              = $00000002,
    vdfRGB15Alpha             = $00000004,
    vdfRGB16                  = $00000008,
    vdfRGB24                  = $00000010,
    vdfRGB24Alpha             = $00000020,
    vdfYUV420Planar           = $00000040,
    vdfYUV422Planar           = $00000080,
    vdfYUV411Planar           = $00000100,
    vdfYUV420Interspersed     = $00000200,
    vdfYUV422Interspersed     = $00000400,
    vdfYUV411Interspersed     = $00000800,
    vdfYUV422Sequence         = $00001000,
    vdfYUV422SequenceAlpha    = $00002000,
    vdfMono                   = $00004000,
    vdfYUV444Planar           = $00008000
  );

  // Bitrate control type
  BitrateControlType_t = (
    brCBR = 0,
    brVBR = 1
  );

  // Board type
  BOARD_TYPE_DS = (
    DS400XM         = 0,
    DS400XH         = 1,
    DS4004HC        = 2,
    DS4008HC        = 3,
    DS4016HC        = 4,
    DS4001HF        = 5,
    DS4004HF        = 6,
    DS4002MD        = 7,
    DS4004MD        = 8,
    DS4016HCS       = 9,
    DS4002HT        = 10,
    DS4004HT        = 11,
    DS4008HT        = 12,
    DS4004HC_PLUS   = 13,
    DS4008HC_PLUS   = 14,
    DS4016HC_PLUS   = 15,
    INVALID_BOARD_TYPE = Integer($ffffffff)
  );

// Callback types
  TDrawFun = procedure(nPort: Integer; hDc: HDC; nUser: Integer); stdcall;

  TLogRecordCallback = procedure(str: PAnsiChar; context: Pointer); stdcall;
  TStreamReadCallback = function(channelNumber: ULONG; context: Pointer): Integer; stdcall;
  TStreamDirectReadCallback = function(channelNumber: ULONG; DataBuf: Pointer; Length: DWORD; FrameType: Integer; context: Pointer): Integer; stdcall;

  // Channel capability
  PCHANNEL_CAPABILITY = ^CHANNEL_CAPABILITY;
  CHANNEL_CAPABILITY = packed record
    bAudioPreview: UCHAR;
    bAlarmIO:      UCHAR;
    bWatchDog:     UCHAR;
  end;

  // Frame statistics
  PFRAMES_STATISTICS = ^FRAMES_STATISTICS;
  FRAMES_STATISTICS = packed record
    VideoFrames:   ULONG;
    AudioFrames:   ULONG;
    FramesLost:    ULONG;
    QueueOverflow: ULONG;
    CurBps:        ULONG;
  end;

  // Board detail (v3.0)
  PDS_BOARD_DETAIL = ^DS_BOARD_DETAIL;
  DS_BOARD_DETAIL = packed record
    boardType:                BOARD_TYPE_DS;
    sn:                       array[0..15] of Byte;
    dspCount:                 UINT;
    firstDspIndex:            UINT;
    encodeChannelCount:       UINT;
    firstEncodeChannelIndex:  UINT;
    decodeChannelCount:       UINT;
    firstDecodeChannelIndex:  UINT;
    displayChannelCount:      UINT;
    firstDisplayChannelIndex: UINT;
    reserved1: UINT;
    reserved2: UINT;
    reserved3: UINT;
    reserved4: UINT;
  end;

  // DSP detail (v3.0)
  PDSP_DETAIL = ^DSP_DETAIL;
  DSP_DETAIL = packed record
    encodeChannelCount:       UINT;
    firstEncodeChannelIndex:  UINT;
    decodeChannelCount:       UINT;
    firstDecodeChannelIndex:  UINT;
    displayChannelCount:      UINT;
    firstDisplayChannelIndex: UINT;
    reserved1: UINT;
    reserved2: UINT;
    reserved3: UINT;
    reserved4: UINT;
  end;

  // Region parameter
  PREGION_PARAM = ^REGION_PARAM;
  REGION_PARAM = packed record
    left:   UINT;
    top:    UINT;
    width:  UINT;
    height: UINT;
    color:  COLORREF;
    param:  UINT;
  end;

  // Display parameters (for MD card)
  PDISPLAY_PARA = ^DISPLAY_PARA;
  DISPLAY_PARA = packed record
    bToScreen:   Integer;
    bToVideoOut: Integer;
    nLeft:       Integer;
    nTop:        Integer;
    nWidth:      Integer;
    nHeight:     Integer;
    nReserved:   Integer;
  end;

  // Hardware version info
  PHW_VERSION = ^HW_VERSION;
  HW_VERSION = packed record
    DspVersion:    ULONG;
    DspBuildNum:   ULONG;
    DriverVersion: ULONG;
    DriverBuildNum: ULONG;
    SDKVersion:    ULONG;
    SDKBuildNum:   ULONG;
  end;

// Motion detection callback
  TMotionDetectionCallback = procedure(channelNumber: ULONG; bMotionDetected: BOOL; context: Pointer); stdcall;

// File reference done callback
  TFileRefDoneCallback = procedure(nChannel: UINT; nSize: UINT); stdcall;

// Image stream callback
  TImageStreamCallback = procedure(channelNumber: UINT; context: Pointer); stdcall;

//============================================================================
// Decode card SDK API functions (DS400xHC/HF)
// Export: InitDSPs, DeInitDSPs, ChannelOpen, ChannelClose, etc.
// DLL: DsSdk.dll
//============================================================================

function InitDSPs(): Integer; stdcall; external DLL_DECODECARD;
function DeInitDSPs(): Integer; stdcall; external DLL_DECODECARD;
function ChannelOpen(ChannelNum: Integer): HANDLE; stdcall; external DLL_DECODECARD;
function ChannelClose(hChannelHandle: HANDLE): Integer; stdcall; external DLL_DECODECARD;
function GetTotalChannels(): Integer; stdcall; external DLL_DECODECARD;
function GetTotalDSPs(): Integer; stdcall; external DLL_DECODECARD;

function StartVideoPreview(
  hChannelHandle: HANDLE; WndHandle: HWND; rect: PRect;
  bOverlay: BOOL; VideoFormat: Integer; FrameRate: Integer
): Integer; stdcall; external DLL_DECODECARD;

function StopVideoPreview(hChannelHandle: HANDLE): Integer; stdcall; external DLL_DECODECARD;

function SetVideoPara(
  hChannelHandle: HANDLE; Brightness: Integer; Contrast: Integer;
  Saturation: Integer; Hue: Integer
): Integer; stdcall; external DLL_DECODECARD;

function GetVideoPara(
  hChannelHandle: HANDLE; VideoStandard: PVideoStandard_t;
  Brightness, Contrast, Saturation, Hue: PInteger
): Integer; stdcall; external DLL_DECODECARD;

function GetVideoSignal(hChannelHandle: HANDLE): Integer; stdcall; external DLL_DECODECARD;
function GetSDKVersion(VersionInfo: PVERSION_INFO): Integer; stdcall; external DLL_DECODECARD;
function GetCapability(hChannelHandle: HANDLE; Capability: PCHANNEL_CAPABILITY): Integer; stdcall; external DLL_DECODECARD;

function GetLastErrorNum(
  hChannelHandle: HANDLE; DspError: PULONG; SdkError: PULONG
): Integer; stdcall; external DLL_DECODECARD;

function SetStreamType(hChannelHandle: HANDLE; StreamType: USHORT): Integer; stdcall; external DLL_DECODECARD;
function GetStreamType(hChannelHandle: HANDLE; StreamType: PUSHORT): Integer; stdcall; external DLL_DECODECARD;
function GetFramesStatistics(hChannelHandle: HANDLE; framesStatistics: PFRAMES_STATISTICS): Integer; stdcall; external DLL_DECODECARD;
function StartMotionDetection(hChannelHandle: HANDLE): Integer; stdcall; external DLL_DECODECARD;

function GetBoardInfo(
  hChannelHandle: HANDLE; BoardType: PULONG; SerialNo: PUCHAR
): Integer; stdcall; external DLL_DECODECARD;

function StopMotionDetection(hChannelHandle: HANDLE): Integer; stdcall; external DLL_DECODECARD;

function GetOriginalImage(
  hChannelHandle: HANDLE; ImageBuf: PUCHAR; Size: PULONG
): Integer; stdcall; external DLL_DECODECARD;

function RegisterLogRecordCallback(
  LogRecordFunc: TLogRecordCallback; Context: Pointer
): Integer; stdcall; external DLL_DECODECARD;

function SetAudioPreview(hChannelHandle: HANDLE; bEnable: BOOL): Integer; stdcall; external DLL_DECODECARD;

function ReadStreamData(
  hChannelHandle: HANDLE; DataBuf: Pointer; Length: PDWORD; FrameType: PInteger
): Integer; stdcall; external DLL_DECODECARD;

function RegisterMessageNotifyHandle(hWnd: HWND; MessageId: UINT): Integer; stdcall; external DLL_DECODECARD;
function StartVideoCapture(hChannelHandle: HANDLE): Integer; stdcall; external DLL_DECODECARD;
function StopVideoCapture(hChannelHandle: HANDLE): Integer; stdcall; external DLL_DECODECARD;

function SetIBPMode(
  hChannelHandle: HANDLE; KeyFrameIntervals: Integer; BFrames: Integer;
  PFrames: Integer; FrameRate: Integer
): Integer; stdcall; external DLL_DECODECARD;

function SetDefaultQuant(
  hChannelHandle: HANDLE; IQuantVal: Integer; PQuantVal: Integer; BQuantVal: Integer
): Integer; stdcall; external DLL_DECODECARD;

function SetOsd(hChannelHandle: HANDLE; Enable: BOOL): Integer; stdcall; external DLL_DECODECARD;

function SetLogo(
  hChannelHandle: HANDLE; x, y, w, h: Integer; yuv: PByte
): Integer; stdcall; external DLL_DECODECARD;

function StopLogo(hChannelHandle: HANDLE): Integer; stdcall; external DLL_DECODECARD;

function SetupMotionDetection(
  hChannelHandle: HANDLE; RectList: PRect; iAreas: Integer
): Integer; stdcall; external DLL_DECODECARD;

function MotionAnalyzer(
  hChannelHandle: HANDLE; MotionData: PAnsiChar; iThreshold: Integer; iResult: PInteger
): Integer; stdcall; external DLL_DECODECARD;

function LoadYUVFromBmpFile(
  FileName: PAnsiChar; yuv: PByte; BufLen: Integer; Width, Height: PInteger
): Integer; stdcall; external DLL_DECODECARD;

function SaveYUVToBmpFile(
  FileName: PAnsiChar; yuv: PByte; Width, Height: Integer
): Integer; stdcall; external DLL_DECODECARD;

function CaptureIFrame(hChannelHandle: HANDLE): Integer; stdcall; external DLL_DECODECARD;

function RegisterStreamReadCallback(
  StreamReadCallback: TStreamReadCallback; Context: Pointer
): Integer; stdcall; external DLL_DECODECARD;

function AdjustMotionDetectPrecision(
  hChannelHandle: HANDLE; iGrade: Integer; iFastMotionDetectFps: Integer;
  iSlowMotionDetectFps: Integer
): Integer; stdcall; external DLL_DECODECARD;

function SetupBitrateControl(
  hChannelHandle: HANDLE; MaxBps: ULONG
): Integer; stdcall; external DLL_DECODECARD;

function SetOverlayColorKey(DestColorKey: COLORREF): Integer; stdcall; external DLL_DECODECARD;

function SetOsdDisplayMode(
  hChannelHandle: HANDLE; Brightness: Integer; Translucent: BOOL;
  parameter: Integer; Format1: PUSHORT; Format2: PUSHORT
): Integer; stdcall; external DLL_DECODECARD;

function SetLogoDisplayMode(
  hChannelHandle: HANDLE; ColorKey: COLORREF; Translucent: BOOL;
  TwinkleInterval: Integer
): Integer; stdcall; external DLL_DECODECARD;

function SetEncoderPictureFormat(
  hChannelHandle: HANDLE; PictureFormat: PictureFormat_t
): Integer; stdcall; external DLL_DECODECARD;

function SetVideoStandard(
  hChannelHandle: HANDLE; VideoStandard: VideoStandard_t
): Integer; stdcall; external DLL_DECODECARD;

function RestoreOverlay(): Integer; stdcall; external DLL_DECODECARD;
function ResetDSP(DspNumber: Integer): Integer; stdcall; external DLL_DECODECARD;
function GetSoundLevel(hChannelHandle: HANDLE): Integer; stdcall; external DLL_DECODECARD;

function SetBitrateControlMode(
  hChannelHandle: HANDLE; brc: BitrateControlType_t
): Integer; stdcall; external DLL_DECODECARD;

function SetupNotifyThreshold(
  hChannelHandle: HANDLE; iFramesThreshold: Integer
): Integer; stdcall; external DLL_DECODECARD;

function SetupSubChannel(
  hChannelHandle: HANDLE; iSubChannel: Integer
): Integer; stdcall; external DLL_DECODECARD;

function GetSubChannelStreamType(
  DataBuf: Pointer; FrameType: Integer
): Integer; stdcall; external DLL_DECODECARD;

function RegisterStreamDirectReadCallback(
  StreamDirectReadCallback: TStreamDirectReadCallback; Context: Pointer
): Integer; stdcall; external DLL_DECODECARD;

function RegisterDrawFun(
  nport: DWORD; DrawFun: TDrawFun; nUser: Integer
): Integer; stdcall; external DLL_DECODECARD;

function SetupMask(
  hChannelHandle: HANDLE; rectList: PRect; iAreas: Integer
): Integer; stdcall; external DLL_DECODECARD;

function StopMask(hChannelHandle: HANDLE): Integer; stdcall; external DLL_DECODECARD;

function SetSubEncoderPictureFormat(
  hChannelHandle: HANDLE; PictureFormat: PictureFormat_t
): Integer; stdcall; external DLL_DECODECARD;

function StartSubVideoCapture(hChannelHandle: HANDLE): Integer; stdcall; external DLL_DECODECARD;
function StopSubVideoCapture(hChannelHandle: HANDLE): Integer; stdcall; external DLL_DECODECARD;

function SetupDateTime(
  hChannelHandle: HANDLE; now: PSYSTEMTIME
): Integer; stdcall; external DLL_DECODECARD;

function SetImageStream(
  hChannel: HANDLE; bStart: BOOL; fps, width, height: UINT; imageBuffer: PByte
): Integer; stdcall; external DLL_DECODECARD;

function RegisterImageStreamCallback(
  callback: TImageStreamCallback; context: Pointer
): Integer; stdcall; external DLL_DECODECARD;

function SetInputVideoPosition(
  hChannel: HANDLE; x, y: UINT
): Integer; stdcall; external DLL_DECODECARD;

function StopRegisterDrawFun(nport: DWORD): Integer; stdcall; external DLL_DECODECARD;

// v3.0
function GetBoardCount(): UINT; stdcall; external DLL_DECODECARD;
function GetBoardDetail(boardNum: UINT; pBoardDetail: PDS_BOARD_DETAIL): Integer; stdcall; external DLL_DECODECARD;
function GetDspCount(): UINT; stdcall; external DLL_DECODECARD;
function GetDspDetail(dspNum: UINT; pDspDetail: PDSP_DETAIL): Integer; stdcall; external DLL_DECODECARD;
function GetEncodeChannelCount(): UINT; stdcall; external DLL_DECODECARD;
function GetDecodeChannelCount(): UINT; stdcall; external DLL_DECODECARD;
function GetDisplayChannelCount(): UINT; stdcall; external DLL_DECODECARD;
function SetDefaultVideoStandard(VideoStandard: VideoStandard_t): Integer; stdcall; external DLL_DECODECARD;
function SetVideoDetectPrecision(hChannel: HANDLE; value: UINT): Integer; stdcall; external DLL_DECODECARD;
function SetSubStreamType(hChannelHandle: HANDLE; StreamType: USHORT): Integer; stdcall; external DLL_DECODECARD;
function GetSubStreamType(hChannelHandle: HANDLE; StreamType: PUSHORT): Integer; stdcall; external DLL_DECODECARD;
function SetDisplayStandard(nDisplayChannel: UINT; VideoStandard: VideoStandard_t): Integer; stdcall; external DLL_DECODECARD;

function SetDisplayRegion(
  nDisplayChannel: UINT; nRegionCount: UINT; pParam: PREGION_PARAM; nReserved: UINT
): Integer; stdcall; external DLL_DECODECARD;

function ClearDisplayRegion(
  nDisplayChannel: UINT; nRegionFlag: UINT
): Integer; stdcall; external DLL_DECODECARD;

function SetDisplayRegionPosition(
  nDisplayChannel: UINT; nRegion: UINT; nLeft: UINT; nTop: UINT
): Integer; stdcall; external DLL_DECODECARD;

function FillDisplayRegion(
  nDisplayChannel: UINT; nRegion: UINT; pImage: PByte
): Integer; stdcall; external DLL_DECODECARD;

function SetEncoderVideoExtOutput(
  nEncodeChannel: UINT; nPort: UINT; bOpen: BOOL;
  nDisplayChannel: UINT; nDisplayRegion: UINT; nReserved: UINT
): Integer; stdcall; external DLL_DECODECARD;

function SetDecoderVideoExtOutput(
  nDecodeChannel: UINT; nPort: UINT; bOpen: BOOL;
  nDisplayChannel: UINT; nDisplayRegion: UINT; nReserved: UINT
): Integer; stdcall; external DLL_DECODECARD;

function SetDecoderVideoOutput(
  nDecodeChannel: UINT; nPort: UINT; bOpen: BOOL;
  nDisplayChannel: UINT; nDisplayRegion: UINT; nReserved: UINT
): Integer; stdcall; external DLL_DECODECARD;

function SetDecoderAudioOutput(
  nDecodeChannel: UINT; bOpen: BOOL; nOutputChannel: UINT
): Integer; stdcall; external DLL_DECODECARD;

// v3.1
function SetDeInterlace(
  hChannelHandle: HANDLE; mode: UINT; level: UINT
): Integer; stdcall; external DLL_DECODECARD;

function SetPreviewOverlayMode(bTrue: BOOL): Integer; stdcall; external DLL_DECODECARD;

//============================================================================
// Decode card PLAYER API functions (DS4002MD)
// These functions are exported from DsSdk.dll with "PLAYER_API" prefix
// In Delphi, they use the same DLL
//============================================================================

function HW_InitDirectDraw(hParent: HWND; colorKey: COLORREF): Integer; stdcall; external DLL_DECODECARD;
function HW_ReleaseDirectDraw(): Integer; stdcall; external DLL_DECODECARD;
function HW_InitDecDevice(pDeviceTotal: PInteger): Integer; stdcall; external DLL_DECODECARD;
function HW_ReleaseDecDevice(): Integer; stdcall; external DLL_DECODECARD;
function HW_ChannelOpen(nChannelNum: Integer; phChannel: PHANDLE): Integer; stdcall; external DLL_DECODECARD;
function HW_ChannelClose(hChannel: HANDLE): Integer; stdcall; external DLL_DECODECARD;

// Stream operations
function HW_OpenStream(hChannel: HANDLE; pFileHeadBuf: PBYTE; nSize: DWORD): Integer; stdcall; external DLL_DECODECARD;
function HW_CloseStream(hChannel: HANDLE): Integer; stdcall; external DLL_DECODECARD;
function HW_InputData(hChannel: HANDLE; pBuf: PBYTE; nSize: DWORD): Integer; stdcall; external DLL_DECODECARD;
function HW_OpenFile(hChannel: HANDLE; sFileName: LPTSTR): Integer; stdcall; external DLL_DECODECARD;
function HW_CloseFile(hChannel: HANDLE): Integer; stdcall; external DLL_DECODECARD;

// Play control
function HW_SetDisplayPara(hChannel: HANDLE; pPara: PDISPLAY_PARA): Integer; stdcall; external DLL_DECODECARD;
function HW_Play(hChannel: HANDLE): Integer; stdcall; external DLL_DECODECARD;
function HW_Stop(hChannel: HANDLE): Integer; stdcall; external DLL_DECODECARD;
function HW_Pause(hChannel: HANDLE; bPause: ULONG): Integer; stdcall; external DLL_DECODECARD;

// Sound
function HW_PlaySound(hChannel: HANDLE): Integer; stdcall; external DLL_DECODECARD;
function HW_StopSound(hChannel: HANDLE): Integer; stdcall; external DLL_DECODECARD;
function HW_SetVolume(hChannel: HANDLE; nVolume: ULONG): Integer; stdcall; external DLL_DECODECARD;

// Overlay
function HW_RefreshSurface(): Integer; stdcall; external DLL_DECODECARD;
function HW_RestoreSurface(): Integer; stdcall; external DLL_DECODECARD;
function HW_ClearSurface(): Integer; stdcall; external DLL_DECODECARD;
function HW_ZoomOverlay(pSrcClientRect: PRect; pDecScreenRect: PRect): Integer; stdcall; external DLL_DECODECARD;

// File capture
function HW_StartCapFile(hChannel: HANDLE; sFileName: LPTSTR): Integer; stdcall; external DLL_DECODECARD;
function HW_StopCapFile(hChannel: HANDLE): Integer; stdcall; external DLL_DECODECARD;

// Picture capture
function HW_GetYV12Image(hChannel: HANDLE; pBuffer: PBYTE; nSize: ULONG): Integer; stdcall; external DLL_DECODECARD;
function HW_GetPictureSize(hChannel: HANDLE; pWidth: PULONG; pHeight: PULONG): Integer; stdcall; external DLL_DECODECARD;

function HW_ConvertToBmpFile(
  pBuf: PByte; nSize: ULONG; nWidth: ULONG; nHeight: ULONG;
  sFileName: PAnsiChar; nReserved: ULONG
): Integer; stdcall; external DLL_DECODECARD;

// Navigation
function HW_Jump(hChannel: HANDLE; nDirection: ULONG): Integer; stdcall; external DLL_DECODECARD;
function HW_SetJumpInterval(hChannel: HANDLE; nSecond: ULONG): Integer; stdcall; external DLL_DECODECARD;
function HW_GetSpeed(hChannel: HANDLE; pSpeed: PInteger): Integer; stdcall; external DLL_DECODECARD;
function HW_SetSpeed(hChannel: HANDLE; nSpeed: Integer): Integer; stdcall; external DLL_DECODECARD;
function HW_SetPlayPos(hChannel: HANDLE; nPos: ULONG): Integer; stdcall; external DLL_DECODECARD;
function HW_GetPlayPos(hChannel: HANDLE; pPos: PULONG): Integer; stdcall; external DLL_DECODECARD;
function HW_GetVersion(pVersion: PHW_VERSION): Integer; stdcall; external DLL_DECODECARD;
function HW_GetCurrentFrameRate(hChannel: HANDLE; pFrameRate: PULONG): Integer; stdcall; external DLL_DECODECARD;
function HW_GetCurrentFrameNum(hChannel: HANDLE; pFrameNum: PULONG): Integer; stdcall; external DLL_DECODECARD;
function HW_GetFileTotalFrames(hChannel: HANDLE; pTotalFrames: PULONG): Integer; stdcall; external DLL_DECODECARD;
function HW_GetFileTime(hChannel: HANDLE; pFileTime: PULONG): Integer; stdcall; external DLL_DECODECARD;
function HW_GetCurrentFrameTime(hChannel: HANDLE; pFrameTime: PULONG): Integer; stdcall; external DLL_DECODECARD;
function HW_GetPlayedFrames(hChannel: HANDLE; pDecVFrames: PULONG): Integer; stdcall; external DLL_DECODECARD;
function HW_GetDeviceSerialNo(hChannel: HANDLE; pDeviceSerialNo: PULONG): Integer; stdcall; external DLL_DECODECARD;
function HW_SetFileEndMsg(hChannel: HANDLE; hWnd: HWND; nMsg: UINT): Integer; stdcall; external DLL_DECODECARD;
function HW_SetStreamOpenMode(hChannel: HANDLE; nMode: ULONG): Integer; stdcall; external DLL_DECODECARD;
function HW_GetStreamOpenMode(hChannel: HANDLE; pMode: PULONG): Integer; stdcall; external DLL_DECODECARD;
function HW_SetVideoOutStandard(hChannel: HANDLE; nStandard: ULONG): Integer; stdcall; external DLL_DECODECARD;
function HW_SetDspDeadlockMsg(hWnd: HWND; nMsg: UINT): Integer; stdcall; external DLL_DECODECARD;

function HW_GetChannelNum(
  nDspNum: Integer; pChannelNum: PInteger; nNumsToGet: ULONG; pNumsGotten: PULONG
): Integer; stdcall; external DLL_DECODECARD;

function HW_ResetDsp(nDspNum: Integer): Integer; stdcall; external DLL_DECODECARD;
function HW_SetAudioPreview(hChannel: HANDLE; bEnable: BOOL): Integer; stdcall; external DLL_DECODECARD;

// Ex stream operations
function HW_OpenStreamEx(hChannel: HANDLE; pFileHeadBuf: PBYTE; nSize: DWORD): Integer; stdcall; external DLL_DECODECARD;
function HW_CloseStreamEx(hChannel: HANDLE): Integer; stdcall; external DLL_DECODECARD;
function HW_InputVideoData(hChannel: HANDLE; pBuf: PBYTE; nSize: DWORD): Integer; stdcall; external DLL_DECODECARD;
function HW_InputAudioData(hChannel: HANDLE; pBuf: PBYTE; nSize: DWORD): Integer; stdcall; external DLL_DECODECARD;

// v4.0
function SetOsdDisplayModeEx(
  hChannelHandle: HANDLE; color: Integer; Translucent: BOOL; param: Integer;
  nLineCount: Integer; Format: PPUSHORT
): Integer; stdcall; external DLL_DECODECARD;

function SetupMotionDetectionEx(
  hChannelHandle: HANDLE; iGrade: Integer; iFastMotionDetectFps: Integer;
  iSlowMotionDetectFps: Integer; delay: UINT; RectList: PRect; iAreas: Integer;
  MotionDetectionCallback: TMotionDetectionCallback; reserved: Integer
): Integer; stdcall; external DLL_DECODECARD;

function GetJpegImage(
  hChannelHandle: HANDLE; ImageBuf: PUCHAR; Size: PULONG; nQuality: UINT
): Integer; stdcall; external DLL_DECODECARD;

// WatchDog
function SetWatchDog(boardNumber: UINT; bEnable: BOOL): Integer; stdcall; external DLL_DECODECARD;

// v4.1
function HW_SetFileRef(
  hChannel: HANDLE; bEnable: BOOL; FileRefDoneCallback: TFileRefDoneCallback
): Integer; stdcall; external DLL_DECODECARD;

function HW_LocateByAbsoluteTime(hChannel: HANDLE; time: SYSTEMTIME): Integer; stdcall; external DLL_DECODECARD;
function HW_LocateByFrameNumber(hChannel: HANDLE; frmNum: UINT): Integer; stdcall; external DLL_DECODECARD;
function HW_GetCurrentAbsoluteTime(hChannel: HANDLE; pTime: PSYSTEMTIME): Integer; stdcall; external DLL_DECODECARD;

function HW_GetFileAbsoluteTime(
  hChannel: HANDLE; pStartTime: PSYSTEMTIME; pEndTime: PSYSTEMTIME
): Integer; stdcall; external DLL_DECODECARD;

implementation

end.
