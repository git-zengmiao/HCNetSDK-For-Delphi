unit PlayMpeg4;

//============================================================================
// Hikvision PlayCtrl SDK - PlayM4 API
// Delphi VCL/FMX compatible translation
// Based on: incEn/plaympeg4.h
// PlayM4 API函数声明，播放SDK (PlayCtrl.dll)，含文件播放、流播放、回放控制、回放信息查询等接口
//============================================================================

interface

{$IFDEF MSWINDOWS}
  {$IF CompilerVersion >= 23.0}
  uses Winapi.Windows;
  {$ELSE}
  uses Windows;
  {$ENDIF}
{$ENDIF}

const
  DLL_PLAYCTRL = 'PlayCtrl.dll';

const
  // Max channel numbers
  PLAYM4_MAX_SUPPORTS = 500;

  // Wave coefficient range
  MIN_WAVE_COEF = -100;
  MAX_WAVE_COEF = 100;

  // Timer type
  TIMER_1 = 1;
  TIMER_2 = 2;

  // Buffer and data type
  BUF_VIDEO_SRC    = 1;
  BUF_AUDIO_SRC    = 2;
  BUF_VIDEO_RENDER = 3;
  BUF_AUDIO_RENDER = 4;
  BUF_VIDEO_DECODED = 5;
  BUF_AUDIO_DECODED = 6;

  // Error codes
  PLAYM4_NOERROR                  = 0;
  PLAYM4_PARA_OVER                = 1;
  PLAYM4_ORDER_ERROR              = 2;
  PLAYM4_TIMER_ERROR              = 3;
  PLAYM4_DEC_VIDEO_ERROR          = 4;
  PLAYM4_DEC_AUDIO_ERROR          = 5;
  PLAYM4_ALLOC_MEMORY_ERROR       = 6;
  PLAYM4_OPEN_FILE_ERROR          = 7;
  PLAYM4_CREATE_OBJ_ERROR         = 8;
  PLAYM4_CREATE_DDRAW_ERROR       = 9;
  PLAYM4_CREATE_OFFSCREEN_ERROR   = 10;
  PLAYM4_BUF_OVER                 = 11;
  PLAYM4_CREATE_SOUND_ERROR       = 12;
  PLAYM4_SET_VOLUME_ERROR         = 13;
  PLAYM4_SUPPORT_FILE_ONLY        = 14;
  PLAYM4_SUPPORT_STREAM_ONLY      = 15;
  PLAYM4_SYS_NOT_SUPPORT          = 16;
  PLAYM4_FILEHEADER_UNKNOWN       = 17;
  PLAYM4_VERSION_INCORRECT        = 18;
  PLAYM4_INIT_DECODER_ERROR       = 19;
  PLAYM4_CHECK_FILE_ERROR         = 20;
  PLAYM4_INIT_TIMER_ERROR         = 21;
  PLAYM4_BLT_ERROR                = 22;
  PLAYM4_UPDATE_ERROR             = 23;
  PLAYM4_OPEN_FILE_ERROR_MULTI    = 24;
  PLAYM4_OPEN_FILE_ERROR_VIDEO    = 25;
  PLAYM4_JPEG_COMPRESS_ERROR      = 26;
  PLAYM4_EXTRACT_NOT_SUPPORT      = 27;
  PLAYM4_EXTRACT_DATA_ERROR       = 28;
  PLAYM4_SECRET_KEY_ERROR         = 29;
  PLAYM4_DECODE_KEYFRAME_ERROR    = 30;
  PLAYM4_NEED_MORE_DATA           = 31;
  PLAYM4_INVALID_PORT             = 32;
  PLAYM4_NOT_FIND                 = 33;
  PLAYM4_NEED_LARGER_BUFFER       = 34;
  PLAYM4_FAIL_UNKNOWN             = 99;

  // Fisheye error codes
  PLAYM4_FEC_ERR_ENABLEFAIL        = 100;
  PLAYM4_FEC_ERR_NOTENABLE         = 101;
  PLAYM4_FEC_ERR_NOSUBPORT         = 102;
  PLAYM4_FEC_ERR_PARAMNOTINIT      = 103;
  PLAYM4_FEC_ERR_SUBPORTOVER       = 104;
  PLAYM4_FEC_ERR_EFFECTNOTSUPPORT  = 105;
  PLAYM4_FEC_ERR_INVALIDWND        = 106;
  PLAYM4_FEC_ERR_PTZOVERFLOW       = 107;
  PLAYM4_FEC_ERR_RADIUSINVALID     = 108;
  PLAYM4_FEC_ERR_UPDATENOTSUPPORT  = 109;
  PLAYM4_FEC_ERR_NOPLAYPORT        = 110;
  PLAYM4_FEC_ERR_PARAMVALID        = 111;
  PLAYM4_FEC_ERR_INVALIDPORT       = 112;
  PLAYM4_FEC_ERR_PTZZOOMOVER       = 113;
  PLAYM4_FEC_ERR_OVERMAXPORT       = 114;
  PLAYM4_FEC_ERR_ENABLED           = 115;
  PLAYM4_FEC_ERR_D3DACCENOOTENABLE = 116;

  // Max display regions
  MAX_DISPLAY_WND = 4;

  // Display type
  DISPLAY_NORMAL    = $00000001;
  DISPLAY_QUARTER   = $00000002;
  DISPLAY_YC_SCALE  = $00000004;
  DISPLAY_NOTEARING = $00000008;

  // Display buffers
  MAX_DIS_FRAMES = 50;
  MIN_DIS_FRAMES = 1;

  // Locate by
  BY_FRAMENUM  = 1;
  BY_FRAMETIME = 2;

  // Source buffer
  SOURCE_BUF_MAX = 1024 * 100000;
  SOURCE_BUF_MIN = 1024 * 50;

  // Stream type
  STREAME_REALTIME = 0;
  STREAME_FILE     = 1;

  // Frame type
  T_AUDIO16 = 101;
  T_AUDIO8  = 100;
  T_UYVY    = 1;
  T_YV12    = 3;
  T_RGB32   = 7;

  // Capability
  SUPPORT_DDRAW        = 1;
  SUPPORT_BLT          = 2;
  SUPPORT_BLTFOURCC    = 4;
  SUPPORT_BLTSHRINKX   = 8;
  SUPPORT_BLTSHRINKY   = 16;
  SUPPORT_BLTSTRETCHX  = 32;
  SUPPORT_BLTSTRETCHY  = 64;
  SUPPORT_SSE          = 128;
  SUPPORT_MMX          = 256;

  // System pack type
  SYSTEM_NULL     = $0;
  SYSTEM_HIK      = $1;
  SYSTEM_MPEG2_PS = $2;
  SYSTEM_MPEG2_TS = $3;
  SYSTEM_RTP      = $4;
  SYSTEM_RTPHIK   = $401;

  // Video encode type
  VIDEO_NULL  = $0;
  VIDEO_H264  = $1;
  VIDEO_MPEG4 = $3;
  VIDEO_MJPEG = $4;
  VIDEO_AVC264 = $0100;

  // Audio encode type
  AUDIO_NULL       = $0000;
  AUDIO_ADPCM      = $1000;
  AUDIO_MPEG       = $2000;
  AUDIO_AAC        = $2001;
  AUDIO_RAW_DATA8  = $7000;
  AUDIO_RAW_UDATA16 = $7001;
  AUDIO_G711_U     = $7110;
  AUDIO_G711_A     = $7111;
  AUDIO_G722_1     = $7221;
  AUDIO_G723_1     = $7231;
  AUDIO_G726_U     = $7260;
  AUDIO_G726_A     = $7261;
  AUDIO_G726_16    = $7262;
  AUDIO_G729       = $7290;
  AUDIO_AMR_NB     = $3000;

  // Sync data type
  SYNCDATA_VEH = 1;
  SYNCDATA_IVS = 2;

  // Motion flow type
  MOTION_FLOW_NONE = 0;
  MOTION_FLOW_CPU  = 1;
  MOTION_FLOW_GPU  = 2;

  // Encrypt type
  ENCRYPT_AES_3R_VIDEO  = 1;
  ENCRYPT_AES_10R_VIDEO = 2;
  ENCRYPT_AES_3R_AUDIO  = 1;
  ENCRYPT_AES_10R_AUDIO = 2;

  // FourCC for HIK_MEDIAINFO
  FOURCC_HKMI = $484B4D49;

  // Protocol type
  PLAYM4_PROTOCOL_RTSP = 1;

  // Session info type
  PLAYM4_SESSION_INFO_SDP = 1;

  // Rotate angle
  R_ANGLE_0   = -1;
  R_ANGLE_L90 = 0;
  R_ANGLE_R90 = 1;
  R_ANGLE_180 = 2;

type
  // Frame position
  PFRAME_POS = ^FRAME_POS;
  FRAME_POS = packed record
    nFilePos:        Integer;
    nFrameNum:       Integer;
    nFrameTime:      Integer;
    nErrorFrameNum:  Integer;
    pErrorTime:      PSYSTEMTIME;
    nErrorLostFrameNum: Integer;
    nErrorFrameSize: Integer;
  end;

  // Frame info
  PFRAME_INFO = ^FRAME_INFO;
  FRAME_INFO = packed record
    nWidth:      Integer;
    nHeight:     Integer;
    nStamp:      Integer;
    nType:       Integer;
    nFrameRate:  Integer;
    dwFrameNum:  DWORD;
  end;

  // Display info YUV
  PDISPLAY_INFO_YUV = ^DISPLAY_INFO_YUV;
  DISPLAY_INFO_YUV = packed record
    nPort:      Integer;      // channel
    pBuf:       PAnsiChar;    // pointer to channel 1 image data
    nBufLen:    UINT;         // size of channel 1 image data
    pBuf1:      PAnsiChar;    // pointer to channel 2 image data
    nBufLen1:   UINT;         // size of channel 2 image data
    pBuf2:      PAnsiChar;    // pointer to channel 3 image data
    nBufLen2:   UINT;         // size of channel 3 image data
    nWidth:     UINT;         // width
    nHeight:    UINT;         // height
    nStamp:     UINT;         // timestamp in ms
    nType:      UINT;         // data type
    pUser:      Pointer;      // user data
    reserved:   array[0..3] of UINT;
  end;

  // Frame type
  PFRAME_TYPE = ^FRAME_TYPE;
  FRAME_TYPE = packed record
    pDataBuf:  PAnsiChar;
    nSize:     Integer;
    nFrameNum: Integer;
    bIsAudio:  BOOL;
    nReserved: Integer;
  end;

  // Watermark info
  PWATERMARK_INFO = ^WATERMARK_INFO;
  WATERMARK_INFO = packed record
    pDataBuf:  PAnsiChar;
    nSize:     Integer;
    nFrameNum: Integer;
    bRsaRight: BOOL;
    nReserved: Integer;
  end;

  // Sync data info
  PSYNCDATA_INFO = ^SYNCDATA_INFO;
  SYNCDATA_INFO = packed record
    dwDataType: DWORD;      // ancillary information type
    dwDataLen:  DWORD;      // ancillary information data length
    pData:      PByte;      // pointer to ancillary information data
  end;

  // Hikvision Media Information
  PHIK_MEDIAINFO = ^HIK_MEDIAINFO;
  HIK_MEDIAINFO = packed record
    media_fourcc:          UINT;     // "HKMI": $484B4D49
    media_version:         USHORT;   // version of the info structure
    device_id:             USHORT;   // device ID
    system_format:         USHORT;   // system format type
    video_format:          USHORT;   // video encode type
    audio_format:          USHORT;   // audio encode type
    audio_channels:        UCHAR;    // channels
    audio_bits_per_sample: UCHAR;    // sample rate (bits per sample)
    audio_samplesrate:     UINT;     // sampling rate
    audio_bitrate:         UINT;     // compressed audio bitrate (bit)
    reserved:              array[0..3] of UINT;
  end;

  // Display info
  PDISPLAY_INFO = ^DISPLAY_INFO;
  DISPLAY_INFO = packed record
    nPort:    Integer;
    pBuf:     PAnsiChar;
    nBufLen:  Integer;
    nWidth:   Integer;
    nHeight:  Integer;
    nStamp:   Integer;
    nType:    Integer;
    nUser:    Integer;
  end;

  // Display info extended
  PDISPLAY_INFOEX = ^DISPLAY_INFOEX;
  DISPLAY_INFOEX = packed record
    nPort:       Integer;
    pVideoBuf:   PAnsiChar;
    nVideoBufLen: Integer;
    pPriBuf:     PAnsiChar;
    nPriBufLen:  Integer;
    nWidth:      Integer;
    nHeight:     Integer;
    nStamp:      Integer;
    nType:       Integer;
    nUser:       Integer;
  end;

  // System time
  PPLAYM4_SYSTEM_TIME = ^PLAYM4_SYSTEM_TIME;
  PLAYM4_SYSTEM_TIME = packed record
    dwYear:   DWORD;
    dwMon:    DWORD;
    dwDay:    DWORD;
    dwHour:   DWORD;
    dwMin:    DWORD;
    dwSec:    DWORD;
    dwMs:     DWORD;
  end;

  // Encrypt info
  PENCRYPT_INFO = ^ENCRYPT_INFO;
  ENCRYPT_INFO = packed record
    nAudioEncryptType: Integer;
    nSetSecretKey:     Integer;
  end;

  // Session info (for RTSP)
  PPLAYM4_SESSION_INFO = ^PLAYM4_SESSION_INFO;
  PLAYM4_SESSION_INFO = packed record
    nSessionInfoType: Integer;     // session info type, e.g. SDP
    nSessionInfoLen:  Integer;     // data length of session info
    pSessionInfoData: PByte;       // session info data
  end;

  // Addition info
  PPLAYM4_ADDITION_INFO = ^PLAYM4_ADDITION_INFO;
  PLAYM4_ADDITION_INFO = packed record
    pData:       PByte;       // the attachment data
    dwDatalen:   DWORD;       // the length of the attachment data
    dwDataType:  DWORD;       // the data type
    dwTimeStamp: DWORD;       // the relative time stamp
  end;

  // Fish-eye place type
  FECPLACETYPE = (
    FEC_PLACE_WALL    = $1,
    FEC_PLACE_FLOOR   = $2,
    FEC_PLACE_CEILING = $3
  );

  // Fish-eye correct type
  FECCORRECTTYPE = (
    FEC_CORRECT_PTZ = $100,
    FEC_CORRECT_180 = $200,
    FEC_CORRECT_360 = $300
  );

  // Fish-eye cycle param
  PCYCLEPARAM = ^CYCLEPARAM;
  CYCLEPARAM = packed record
    fRadiusLeft:   Single;
    fRadiusRight:  Single;
    fRadiusTop:    Single;
    fRadiusBottom: Single;
  end;

  // Fish-eye PTZ param
  PPTZPARAM = ^PTZPARAM;
  PTZPARAM = packed record
    fPTZPositionX: Single;
    fPTZPositionY: Single;
  end;

const
  // Fisheye update flag
  FEC_UPDATE_RADIUS        = $1;
  FEC_UPDATE_PTZZOOM       = $2;
  FEC_UPDATE_WIDESCANOFFSET = $4;
  FEC_UPDATE_PTZPARAM      = $8;

type
  // Fisheye param
  PFISHEYEPARAM = ^FISHEYEPARAM;
  FISHEYEPARAM = packed record
    nUpDateType:        UINT;
    nPlaceAndCorrect:   UINT;
    stPTZParam:         PTZPARAM;
    stCycleParam:       CYCLEPARAM;
    fZoom:              Single;
    fWideScanOffset:    Single;
    nResver:            array[0..15] of Integer;
  end;

  // Fisheye callback
  TFISHEYE_CallBack = procedure(pUser: Pointer; nSubPort: UINT; nCBType: UINT;
    hDC: Pointer; nWidth: UINT; nHeight: UINT); stdcall;

  // Video enhancement modules
  PLAYM4_VIE_MODULES = (
    PLAYM4_VIE_MODU_ADJ     = $00000001,
    PLAYM4_VIE_MODU_EHAN    = $00000002,
    PLAYM4_VIE_MODU_DEHAZE  = $00000004,
    PLAYM4_VIE_MODU_DENOISE = $00000008,
    PLAYM4_VIE_MODU_SHARPEN = $00000010,
    PLAYM4_VIE_MODU_DEBLOCK = $00000020,
    PLAYM4_VIE_MODU_CRB     = $00000040,
    PLAYM4_VIE_MODU_LENS    = $00000080
  );

  // Video enhancement parameters
  PPLAYM4_VIE_PARACONFIG = ^PLAYM4_VIE_PARACONFIG;
  PLAYM4_VIE_PARACONFIG = packed record
    moduFlag: Integer;   // enable module flags

    // PLAYM4_VIE_MODU_ADJ
    brightVal:   Integer;  // [-255, 255]
    contrastVal: Integer;  // [-256, 255]
    colorVal:    Integer;  // [-256, 255]

    // PLAYM4_VIE_MODU_EHAN
    toneScale:   Integer;  // [0, 100]
    toneGain:    Integer;  // [-256, 255]
    toneOffset:  Integer;  // [-255, 255]
    toneColor:   Integer;  // [-256, 255]

    // PLAYM4_VIE_MODU_DEHAZE
    dehazeLevel:  Integer; // [0, 255]
    dehazeTrans:  Integer; // [0, 255]
    dehazeBright: Integer; // [0, 255]

    // PLAYM4_VIE_MODU_DENOISE
    denoiseLevel: Integer; // [0, 255]

    // PLAYM4_VIE_MODU_SHARPEN
    usmAmount:    Integer; // [0, 255]
    usmRadius:    Integer; // [1, 15]
    usmThreshold: Integer; // [0, 255]

    // PLAYM4_VIE_MODU_DEBLOCK
    deblockLevel: Integer; // [0, 100]

    // PLAYM4_VIE_MODU_LENS
    lensWarp: Integer;     // [-256, 255]
    lensZoom: Integer;     // [-256, 255]
  end;

  // Private data render type
  PLAYM4_PRIDATA_RENDER = (
    PLAYM4_RENDER_ANA_INTEL_DATA = $00000001,
    PLAYM4_RENDER_MD             = $00000002,
    PLAYM4_RENDER_ADD_POS        = $00000004,
    PLAYM4_RENDER_ADD_PIC        = $00000008,
    PLAYM4_RENDER_FIRE_DETCET    = $00000010,
    PLAYM4_RENDER_TEM            = $00000020,
    PLAYM4_RENDER_TRACK_TEM      = $00000040,
    PLAYM4_RENDER_THERMAL        = $00000080
  );

  // Thermal flag
  PLAYM4_THERMAL_FLAG = (
    PLAYM4_THERMAL_FIREMASK  = $00000001,
    PLAYM4_THERMAL_RULEGAS   = $00000002,
    PLAYM4_THERMAL_TARGETGAS = $00000004
  );

  // Fire alarm
  PLAYM4_FIRE_ALARM = (
    PLAYM4_FIRE_FRAME_DIS     = $00000001,
    PLAYM4_FIRE_MAX_TEMP      = $00000002,
    PLAYM4_FIRE_MAX_TEMP_POSITION = $00000004,
    PLAYM4_FIRE_DISTANCE      = $00000008
  );

  // Temperature flag
  PLAYM4_TEM_FLAG = (
    PLAYM4_TEM_REGION_BOX  = $00000001,
    PLAYM4_TEM_REGION_LINE = $00000002,
    PLAYM4_TEM_REGION_POINT = $00000004
  );

  // Track flag
  PLAYM4_TRACK_FLAG = (
    PLAYM4_TRACK_PEOPLE  = $00000001,
    PLAYM4_TRACK_VEHICLE = $00000002
  );

  // PTZ info (thermal)
  PPTZ_INFO = ^PTZ_INFO;
  PTZ_INFO = packed record
    dwDefVer:  USHORT;
    dwLength:  USHORT;
    dwP:       DWORD;    // P(0~3600)
    dwT:       DWORD;    // T(0~3600)
    dwZ:       DWORD;    // Z(0~3600)
    chFSMState: Byte;
    bClearFocusState: Byte;
    reserved:  array[0..5] of Byte;
  end;

//============================================================================
// Callback type definitions
//============================================================================

  // Decode callback
  TDecCBFun = procedure(nPort: Integer; pBuf: PAnsiChar; nSize: Integer;
    pFrameInfo: PFRAME_INFO; nReserved1, nReserved2: Integer); stdcall;

  // Display callback YUV
  TDisplayCBFunYUV = procedure(pstDisplayInfo: PDISPLAY_INFO_YUV); stdcall;

  // Display callback
  TDisplayCBFun = procedure(nPort: Integer; pBuf: PAnsiChar;
    nSize, nWidth, nHeight, nStamp, nType, nReserved: Integer); stdcall;

  // Display callback Ex (receives DISPLAY_INFO struct pointer)
  TDisplayCBFunEx = procedure(pstDisplayInfo: PDISPLAY_INFO); stdcall;

  // Draw function callback
  TDrawFunPlay = procedure(nPort: Integer; hDc: HDC; nUser: Integer); stdcall;

  // Source buffer callback
  TSourceBufCallBack = procedure(nPort: Integer; nBufSize: DWORD;
    dwUser: DWORD; pReserved: Pointer); stdcall;

  // File reference done callback
  TFileRefDone = procedure(nPort: DWORD; nUser: DWORD); stdcall;

  // Verify callback
  TVerifyCallBack = procedure(nPort: Integer; pFilePos: PFRAME_POS;
    bIsVideo: DWORD; nUser: DWORD); stdcall;

  // Audio callback
  TAudioCallBack = procedure(nPort: Integer; pAudioBuf: PAnsiChar;
    nSize, nStamp, nType, nUser: Integer); stdcall;

  // Enc type change callback
  TEncChangeCallBack = procedure(nPort: Integer; nUser: Integer); stdcall;

  // Original frame callback
  TGetOrignalFrameCallBack = procedure(nPort: Integer;
    frameType: PFRAME_TYPE; nUser: Integer); stdcall;

  // Watermark check callback
  TCheckWatermarkCallBack = procedure(nPort: Integer;
    pWatermarkInfo: PWATERMARK_INFO; nUser: DWORD); stdcall;

  // Decode callback mend
  TDecCBFunMend = procedure(nPort: Integer; pBuf: PAnsiChar; nSize: Integer;
    pFrameInfo: PFRAME_INFO; nUser: Integer; nReserved2: Integer); stdcall;

  // File end callback
  TFileEndCallback = procedure(nPort: Integer; pUser: Pointer); stdcall;

  // Encrypt type change callback
  TEncryptTypeCBFun = procedure(nPort: Integer;
    pEncryptInfo: PENCRYPT_INFO; nReserved: Integer); stdcall;

//============================================================================
// API Functions
//============================================================================

// ver 1.0
function PlayM4_InitDDraw(hWnd: HWND): BOOL; stdcall; external DLL_PLAYCTRL;
function PlayM4_RealeseDDraw(): BOOL; stdcall; external DLL_PLAYCTRL;
function PlayM4_OpenFile(nPort: Integer; sFileName: PAnsiChar): BOOL; stdcall; external DLL_PLAYCTRL;
function PlayM4_CloseFile(nPort: Integer): BOOL; stdcall; external DLL_PLAYCTRL;
function PlayM4_Play(nPort: Integer; hWnd: HWND): BOOL; stdcall; external DLL_PLAYCTRL;
function PlayM4_Stop(nPort: Integer): BOOL; stdcall; external DLL_PLAYCTRL;
function PlayM4_Pause(nPort: Integer; nPause: DWORD): BOOL; stdcall; external DLL_PLAYCTRL;
function PlayM4_Fast(nPort: Integer): BOOL; stdcall; external DLL_PLAYCTRL;
function PlayM4_Slow(nPort: Integer): BOOL; stdcall; external DLL_PLAYCTRL;
function PlayM4_OneByOne(nPort: Integer): BOOL; stdcall; external DLL_PLAYCTRL;
function PlayM4_SetPlayPos(nPort: Integer; fRelativePos: Single): BOOL; stdcall; external DLL_PLAYCTRL;
function PlayM4_GetPlayPos(nPort: Integer): Single; stdcall; external DLL_PLAYCTRL;
function PlayM4_SetFileEndMsg(nPort: Integer; hWnd: HWND; nMsg: UINT): BOOL; stdcall; external DLL_PLAYCTRL;
function PlayM4_SetVolume(nPort: Integer; nVolume: WORD): BOOL; stdcall; external DLL_PLAYCTRL;
function PlayM4_StopSound(): BOOL; stdcall; external DLL_PLAYCTRL;
function PlayM4_PlaySound(nPort: Integer): BOOL; stdcall; external DLL_PLAYCTRL;
function PlayM4_OpenStream(nPort: Integer; pFileHeadBuf: PBYTE; nSize: DWORD; nBufPoolSize: DWORD): BOOL; stdcall; external DLL_PLAYCTRL;
function PlayM4_InputData(nPort: Integer; pBuf: PBYTE; nSize: DWORD): BOOL; stdcall; external DLL_PLAYCTRL;
function PlayM4_CloseStream(nPort: Integer): BOOL; stdcall; external DLL_PLAYCTRL;
function PlayM4_GetCaps(): Integer; stdcall; external DLL_PLAYCTRL;
function PlayM4_GetFileTime(nPort: Integer): DWORD; stdcall; external DLL_PLAYCTRL;
function PlayM4_GetPlayedTime(nPort: Integer): DWORD; stdcall; external DLL_PLAYCTRL;
function PlayM4_GetPlayedFrames(nPort: Integer): DWORD; stdcall; external DLL_PLAYCTRL;

// ver 2.0
function PlayM4_SetDecCallBack(nPort: Integer; DecCBFun: TDecCBFun): BOOL; stdcall; external DLL_PLAYCTRL;
function PlayM4_SetDisplayCallBackYUV(nPort: Integer; DisplayCBFun: TDisplayCBFunYUV; bTrue: BOOL; pUser: Pointer): BOOL; stdcall; external DLL_PLAYCTRL;
function PlayM4_SetDisplayCallBack(nPort: Integer; DisplayCBFun: TDisplayCBFun): BOOL; stdcall; external DLL_PLAYCTRL;
function PlayM4_ConvertToBmpFile(pBuf: PAnsiChar; nSize, nWidth, nHeight, nType: Integer; sFileName: PAnsiChar): DWORD; stdcall; external DLL_PLAYCTRL;
function PlayM4_GetFileTotalFrames(nPort: Integer): DWORD; stdcall; external DLL_PLAYCTRL;
function PlayM4_GetCurrentFrameRate(nPort: Integer): DWORD; stdcall; external DLL_PLAYCTRL;
function PlayM4_GetPlayedTimeEx(nPort: Integer): DWORD; stdcall; external DLL_PLAYCTRL;
function PlayM4_SetPlayedTimeEx(nPort: Integer; nTime: DWORD): BOOL; stdcall; external DLL_PLAYCTRL;
function PlayM4_GetCurrentFrameNum(nPort: Integer): DWORD; stdcall; external DLL_PLAYCTRL;
function PlayM4_SetStreamOpenMode(nPort: Integer; nMode: DWORD): BOOL; stdcall; external DLL_PLAYCTRL;
function PlayM4_GetFileHeadLength(): DWORD; stdcall; external DLL_PLAYCTRL;
function PlayM4_GetSdkVersion(): DWORD; stdcall; external DLL_PLAYCTRL;

// ver 2.2
function PlayM4_GetLastError(nPort: Integer): DWORD; stdcall; external DLL_PLAYCTRL;
function PlayM4_RefreshPlay(nPort: Integer): BOOL; stdcall; external DLL_PLAYCTRL;
function PlayM4_SetOverlayMode(nPort: Integer; bOverlay: BOOL; colorKey: COLORREF): BOOL; stdcall; external DLL_PLAYCTRL;
function PlayM4_GetPictureSize(nPort: Integer; pWidth: PInteger; pHeight: PInteger): BOOL; stdcall; external DLL_PLAYCTRL;
function PlayM4_SetPicQuality(nPort: Integer; bHighQuality: BOOL): BOOL; stdcall; external DLL_PLAYCTRL;
function PlayM4_PlaySoundShare(nPort: Integer): BOOL; stdcall; external DLL_PLAYCTRL;
function PlayM4_StopSoundShare(nPort: Integer): BOOL; stdcall; external DLL_PLAYCTRL;

// ver 2.4
function PlayM4_GetStreamOpenMode(nPort: Integer): Integer; stdcall; external DLL_PLAYCTRL;
function PlayM4_GetOverlayMode(nPort: Integer): Integer; stdcall; external DLL_PLAYCTRL;
function PlayM4_GetColorKey(nPort: Integer): COLORREF; stdcall; external DLL_PLAYCTRL;
function PlayM4_GetVolume(nPort: Integer): WORD; stdcall; external DLL_PLAYCTRL;
function PlayM4_GetPictureQuality(nPort: Integer; bHighQuality: PBOOL): BOOL; stdcall; external DLL_PLAYCTRL;
function PlayM4_GetSourceBufferRemain(nPort: Integer): DWORD; stdcall; external DLL_PLAYCTRL;
function PlayM4_ResetSourceBuffer(nPort: Integer): BOOL; stdcall; external DLL_PLAYCTRL;
function PlayM4_SetSourceBufCallBack(nPort: Integer; nThreShold: DWORD; SourceBufCallBack: TSourceBufCallBack; dwUser: DWORD; pReserved: Pointer): BOOL; stdcall; external DLL_PLAYCTRL;
function PlayM4_ResetSourceBufFlag(nPort: Integer): BOOL; stdcall; external DLL_PLAYCTRL;
function PlayM4_SetDisplayBuf(nPort: Integer; nNum: DWORD): BOOL; stdcall; external DLL_PLAYCTRL;
function PlayM4_GetDisplayBuf(nPort: Integer): DWORD; stdcall; external DLL_PLAYCTRL;
function PlayM4_OneByOneBack(nPort: Integer): BOOL; stdcall; external DLL_PLAYCTRL;
function PlayM4_SetFileRefCallBack(nPort: Integer; pFileRefDone: TFileRefDone; nUser: DWORD): BOOL; stdcall; external DLL_PLAYCTRL;
function PlayM4_SetCurrentFrameNum(nPort: Integer; nFrameNum: DWORD): BOOL; stdcall; external DLL_PLAYCTRL;
function PlayM4_GetKeyFramePos(nPort: Integer; nValue, nType: DWORD; pFramePos: PFRAME_POS): BOOL; stdcall; external DLL_PLAYCTRL;
function PlayM4_GetNextKeyFramePos(nPort: Integer; nValue, nType: DWORD; pFramePos: PFRAME_POS): BOOL; stdcall; external DLL_PLAYCTRL;

// ver 2.4 (Win2000+)
function PlayM4_InitDDrawDevice(): BOOL; stdcall; external DLL_PLAYCTRL;
procedure PlayM4_ReleaseDDrawDevice(); stdcall; external DLL_PLAYCTRL;
function PlayM4_GetDDrawDeviceTotalNums(): DWORD; stdcall; external DLL_PLAYCTRL;
function PlayM4_SetDDrawDevice(nPort: Integer; nDeviceNum: DWORD): BOOL; stdcall; external DLL_PLAYCTRL;
function PlayM4_GetCapsEx(nDDrawDeviceNum: DWORD): Integer; stdcall; external DLL_PLAYCTRL;

function PlayM4_ThrowBFrameNum(nPort: Integer; nNum: DWORD): BOOL; stdcall; external DLL_PLAYCTRL;

// ver 2.5
function PlayM4_SetDisplayType(nPort: Integer; nType: Integer): BOOL; stdcall; external DLL_PLAYCTRL;
function PlayM4_GetDisplayType(nPort: Integer): Integer; stdcall; external DLL_PLAYCTRL;

// ver 3.0
function PlayM4_SetDecCBStream(nPort: Integer; nStream: DWORD): BOOL; stdcall; external DLL_PLAYCTRL;
function PlayM4_SetDisplayRegion(nPort: Integer; nRegionNum: DWORD; pSrcRect: PRect; hDestWnd: HWND; bEnable: BOOL): BOOL; stdcall; external DLL_PLAYCTRL;
function PlayM4_RefreshPlayEx(nPort: Integer; nRegionNum: DWORD): BOOL; stdcall; external DLL_PLAYCTRL;
function PlayM4_SetDDrawDeviceEx(nPort: Integer; nRegionNum, nDeviceNum: DWORD): BOOL; stdcall; external DLL_PLAYCTRL;

// v3.2
function PlayM4_GetRefValue(nPort: Integer; pBuffer: PByte; pSize: PDWORD): BOOL; stdcall; external DLL_PLAYCTRL;
function PlayM4_SetRefValue(nPort: Integer; pBuffer: PByte; nSize: DWORD): BOOL; stdcall; external DLL_PLAYCTRL;
function PlayM4_OpenStreamEx(nPort: Integer; pFileHeadBuf: PBYTE; nSize: DWORD; nBufPoolSize: DWORD): BOOL; stdcall; external DLL_PLAYCTRL;
function PlayM4_CloseStreamEx(nPort: Integer): BOOL; stdcall; external DLL_PLAYCTRL;
function PlayM4_InputVideoData(nPort: Integer; pBuf: PBYTE; nSize: DWORD): BOOL; stdcall; external DLL_PLAYCTRL;
function PlayM4_InputAudioData(nPort: Integer; pBuf: PBYTE; nSize: DWORD): BOOL; stdcall; external DLL_PLAYCTRL;
function PlayM4_RegisterDrawFun(nPort: Integer; DrawFun: TDrawFunPlay; nUser: Integer): BOOL; stdcall; external DLL_PLAYCTRL;
function PlayM4_RigisterDrawFun(nPort: Integer; DrawFun: TDrawFunPlay; nUser: Integer): BOOL; stdcall; external DLL_PLAYCTRL;

// v3.4
function PlayM4_SetTimerType(nPort: Integer; nTimerType: DWORD; nReserved: DWORD): BOOL; stdcall; external DLL_PLAYCTRL;
function PlayM4_GetTimerType(nPort: Integer; pTimerType: PDWORD; pReserved: PDWORD): BOOL; stdcall; external DLL_PLAYCTRL;
function PlayM4_ResetBuffer(nPort: Integer; nBufType: DWORD): BOOL; stdcall; external DLL_PLAYCTRL;
function PlayM4_GetBufferValue(nPort: Integer; nBufType: DWORD): DWORD; stdcall; external DLL_PLAYCTRL;

// V3.6
function PlayM4_AdjustWaveAudio(nPort: Integer; nCoefficient: Integer): BOOL; stdcall; external DLL_PLAYCTRL;
function PlayM4_SetVerifyCallBack(nPort: Integer; nBeginTime, nEndTime: DWORD; funVerify: TVerifyCallBack; nUser: DWORD): BOOL; stdcall; external DLL_PLAYCTRL;
function PlayM4_SetAudioCallBack(nPort: Integer; funAudio: TAudioCallBack; nUser: Integer): BOOL; stdcall; external DLL_PLAYCTRL;
function PlayM4_SetEncTypeChangeCallBack(nPort: Integer; funEncChange: TEncChangeCallBack; nUser: Integer): BOOL; stdcall; external DLL_PLAYCTRL;
function PlayM4_SetColor(nPort: Integer; nRegionNum: DWORD; nBrightness, nContrast, nSaturation, nHue: Integer): BOOL; stdcall; external DLL_PLAYCTRL;
function PlayM4_GetColor(nPort: Integer; nRegionNum: DWORD; pBrightness, pContrast, pSaturation, pHue: PInteger): BOOL; stdcall; external DLL_PLAYCTRL;
function PlayM4_SetEncChangeMsg(nPort: Integer; hWnd: HWND; nMsg: UINT): BOOL; stdcall; external DLL_PLAYCTRL;
function PlayM4_GetOriginalFrameCallBack(nPort: Integer; bIsChange, bNormalSpeed: BOOL; nStartFrameNum, nStartStamp, nFileHeader: Integer; funGetOrignalFrame: TGetOrignalFrameCallBack; nUser: Integer): BOOL; stdcall; external DLL_PLAYCTRL;
function PlayM4_GetFileSpecialAttr(nPort: Integer; pTimeStamp, pFileNum, pReserved: PDWORD): BOOL; stdcall; external DLL_PLAYCTRL;
function PlayM4_GetSpecialData(nPort: Integer): DWORD; stdcall; external DLL_PLAYCTRL;
function PlayM4_SetCheckWatermarkCallBack(nPort: Integer; funCheckWatermark: TCheckWatermarkCallBack; nUser: DWORD): BOOL; stdcall; external DLL_PLAYCTRL;
function PlayM4_SetImageSharpen(nPort: Integer; nLevel: DWORD): BOOL; stdcall; external DLL_PLAYCTRL;
function PlayM4_SetDecodeFrameType(nPort: Integer; nFrameType: DWORD): BOOL; stdcall; external DLL_PLAYCTRL;
function PlayM4_SetPlayMode(nPort: Integer; bNormal: BOOL): BOOL; stdcall; external DLL_PLAYCTRL;
function PlayM4_SetOverlayFlipMode(nPort: Integer; bTrue: BOOL): BOOL; stdcall; external DLL_PLAYCTRL;

// V4.7.0.0
function PlayM4_ConvertToJpegFile(pBuf: PAnsiChar; nSize, nWidth, nHeight, nType: Integer; sFileName: PAnsiChar): BOOL; stdcall; external DLL_PLAYCTRL;
function PlayM4_SetJpegQuality(nQuality: Integer): BOOL; stdcall; external DLL_PLAYCTRL;
function PlayM4_SetDeflash(nPort: Integer; bDefalsh: BOOL): BOOL; stdcall; external DLL_PLAYCTRL;

// V4.8.0.0
function PlayM4_CheckDiscontinuousFrameNum(nPort: Integer; bCheck: BOOL): BOOL; stdcall; external DLL_PLAYCTRL;
function PlayM4_GetBMP(nPort: Integer; pBitmap: PBYTE; nBufSize: DWORD; pBmpSize: PDWORD): BOOL; stdcall; external DLL_PLAYCTRL;
function PlayM4_GetJPEG(nPort: Integer; pJpeg: PBYTE; nBufSize: DWORD; pJpegSize: PDWORD): BOOL; stdcall; external DLL_PLAYCTRL;
function PlayM4_SetDecCallBackMend(nPort: Integer; DecCBFun: TDecCBFunMend; nUser: Integer): BOOL; stdcall; external DLL_PLAYCTRL;
function PlayM4_SetSecretKey(nPort: Integer; lKeyType: Integer; pSecretKey: PAnsiChar; lKeyLen: Integer): BOOL; stdcall; external DLL_PLAYCTRL;

// V4.9.0.1
function PlayM4_SetFileEndCallback(nPort: Integer; FileEndCallback: TFileEndCallback; pUser: Pointer): BOOL; stdcall; external DLL_PLAYCTRL;
function PlayM4_GetPort(nPort: PInteger): BOOL; stdcall; external DLL_PLAYCTRL;
function PlayM4_FreePort(nPort: Integer): BOOL; stdcall; external DLL_PLAYCTRL;
function PlayM4_SetDisplayCallBackEx(nPort: Integer; DisplayCBFun: TDisplayCBFunEx; nUser: Integer): BOOL; stdcall; external DLL_PLAYCTRL;
function PlayM4_SkipErrorData(nPort: Integer; bSkip: BOOL): BOOL; stdcall; external DLL_PLAYCTRL;

function PlayM4_SetDecCallBackExMend(
  nPort: Integer; DecCBFun: TDecCBFunMend; pDest: PAnsiChar;
  nDestSize: Integer; nUser: Integer
): BOOL; stdcall; external DLL_PLAYCTRL;

function PlayM4_ReversePlay(nPort: Integer): BOOL; stdcall; external DLL_PLAYCTRL;
function PlayM4_GetSystemTime(nPort: Integer; pstSystemTime: PPLAYM4_SYSTEM_TIME): BOOL; stdcall; external DLL_PLAYCTRL;

function PlayM4_OpenStreamAdvanced(
  nPort: Integer; nProtocolType: Integer;
  pstSessionInfo: PPLAYM4_SESSION_INFO; nBufPoolSize: DWORD
): BOOL; stdcall; external DLL_PLAYCTRL;

function PlayM4_SetRotateAngle(
  nPort: Integer; nRegionNum: DWORD; dwType: DWORD
): BOOL; stdcall; external DLL_PLAYCTRL;

function PlayM4_SetSycGroup(nPort: Integer; dwGroupIndex: DWORD): BOOL; stdcall; external DLL_PLAYCTRL;
function PlayM4_SetSycStartTime(nPort: Integer; pstSystemTime: PPLAYM4_SYSTEM_TIME): BOOL; stdcall; external DLL_PLAYCTRL;

// Fisheye APIs (v6.121+)
function PlayM4_FEC_Enable(nPort: Integer): BOOL; stdcall; external DLL_PLAYCTRL;
function PlayM4_FEC_Disable(nPort: Integer): BOOL; stdcall; external DLL_PLAYCTRL;

function PlayM4_FEC_GetPort(
  nPort: Integer; nSubPort: PUINT;
  emPlaceType: FECPLACETYPE; emCorrectType: FECCORRECTTYPE
): BOOL; stdcall; external DLL_PLAYCTRL;

function PlayM4_FEC_DelPort(nPort: Integer; nSubPort: UINT): BOOL; stdcall; external DLL_PLAYCTRL;

function PlayM4_FEC_SetParam(
  nPort: Integer; nSubPort: UINT; pPara: PFISHEYEPARAM
): BOOL; stdcall; external DLL_PLAYCTRL;

function PlayM4_FEC_GetParam(
  nPort: Integer; nSubPort: UINT; pPara: PFISHEYEPARAM
): BOOL; stdcall; external DLL_PLAYCTRL;

function PlayM4_FEC_SetWnd(
  nPort: Integer; nSubPort: UINT; hWnd: Pointer
): BOOL; stdcall; external DLL_PLAYCTRL;

function PlayM4_FEC_SetCallBack(
  nPort: Integer; nSubPort: UINT;
  cbFunc: TFISHEYE_CallBack; pUser: Pointer
): BOOL; stdcall; external DLL_PLAYCTRL;

function PlayM4_MotionFlow(nPort: Integer; dwAdjustType: DWORD): BOOL; stdcall; external DLL_PLAYCTRL;

// Video Enhancement APIs
function PlayM4_VIE_SetModuConfig(
  lPort: Integer; nModuFlag: Integer; bEnable: BOOL
): BOOL; stdcall; external DLL_PLAYCTRL;

function PlayM4_VIE_SetRegion(
  lPort: Integer; lRegNum: Integer; pRect: PRect
): BOOL; stdcall; external DLL_PLAYCTRL;

function PlayM4_VIE_GetModuConfig(
  lPort: Integer; pdwModuFlag: PInteger
): BOOL; stdcall; external DLL_PLAYCTRL;

function PlayM4_VIE_SetParaConfig(
  lPort: Integer; pParaConfig: PPLAYM4_VIE_PARACONFIG
): BOOL; stdcall; external DLL_PLAYCTRL;

function PlayM4_VIE_GetParaConfig(
  lPort: Integer; pParaConfig: PPLAYM4_VIE_PARACONFIG
): BOOL; stdcall; external DLL_PLAYCTRL;

function PlayM4_SyncToAudio(nPort: Integer; bSyncToAudio: BOOL): BOOL; stdcall; external DLL_PLAYCTRL;

function PlayM4_RenderPrivateData(
  nPort: Integer; nIntelType: Integer; bTrue: BOOL
): BOOL; stdcall; external DLL_PLAYCTRL;

function PlayM4_RenderPrivateDataEx(
  nPort: Integer; nIntelType, nSubType: Integer; bTrue: BOOL
): BOOL; stdcall; external DLL_PLAYCTRL;

function PlayM4_SetEncryptTypeCallBack(
  nPort: Integer; EncryptTypeCBFun: TEncryptTypeCBFun
): BOOL; stdcall; external DLL_PLAYCTRL;

function PlayM4_GetStreamAdditionalInfo(
  nPort: Integer; lType: Integer; pInfo: PByte; plLen: PInteger
): BOOL; stdcall; external DLL_PLAYCTRL;

implementation

end.
