unit DataType;

//============================================================================
// Hikvision HCNetSDK - Common Data Types
// Delphi VCL/FMX compatible translation
// Based on: incEn/DataType.h
// 基础类型映射、帧头、版本、OSD常量
//============================================================================

interface

{$IFDEF MSWINDOWS}
  // Delphi XE2+ uses Winapi.Windows (works for both VCL and FMX)
  {$IF CompilerVersion >= 23.0}
  uses Winapi.Windows;
  {$ELSE}
  uses Windows;
  {$ENDIF}
{$ENDIF}

type
  // Basic type mappings for cross-platform compatibility
  UCHAR  = Byte;
  PBYTE  = ^Byte;
  LPTSTR = PAnsiChar;
  USHORT = Word;
  ULONG  = Cardinal;
  HANDLE = Integer;
  DWORD  = LongWord;  // on non-Windows, defined as unsigned long
  LONG   = Integer;   // on non-Windows, defined as int

const
  FRAME_HEAD_MAGIC = $03211546;
  SYSTEM_SYNC_ID   = 2;

type
  PTMFRAME_HEADER = ^TMFRAME_HEADER;
  TMFRAME_HEADER = packed record
    SyncId:      ULONG;      // 00000000000000000000000000010b
    Magic:       ULONG;
    FrameType:   USHORT;     // I frames, P frames, BBP frames, Audio frames, dsp status, etc.
    Length:      ULONG;      // length includes this header
    FrameNumber: ULONG;      // serial number of this frame
    Breakable:   UCHAR;      // indicate if stream breakable
    PTS:         ULONG;      // system clock when this frame is processed
  end;

  // Video standard enumeration
  VideoStandard_t = (
    StandardNone  = Integer($80000000),
    StandardNTSC  = $00000001,
    StandardPAL   = $00000002,
    StandardSECAM = $00000004
  );

  // Frame type enumeration
  FrameType_t = (
    PktError          = 0,
    PktIFrames        = $0001,
    PktPFrames        = $0002,
    PktBBPFrames      = $0004,
    PktAudioFrames    = $0008,
    PktMotionDetection = $00010,
    PktDspStatus      = $00020,
    PktOrigImage      = $00040,
    PktSysHeader      = $00080,
    PktBPFrames       = $00100,
    PktSFrames        = $00200,
    PktSubIFrames     = $00400,
    PktSubPFrames     = $00800,
    PktSubBBPFrames   = $01000,
    PktSubSysHeader   = $02000
  );

  PVERSION_INFO = ^VERSION_INFO;
  VERSION_INFO = packed record
    DspVersion:   ULONG;
    DspBuildNum:  ULONG;
    DriverVersion: ULONG;
    DriverBuildNum: ULONG;
    SDKVersion:   ULONG;
    SDKBuildNum:  ULONG;
  end;

  PictureFormat_t = (
    ENC_CIF_FORMAT     = 0,
    ENC_QCIF_FORMAT    = 1,
    ENC_2CIF_FORMAT    = 2,
    ENC_4CIF_FORMAT    = 3,
    ENC_QQCIF_FORMAT   = 4,
    ENC_CIFQCIF_FORMAT = 5,
    ENC_CIFQQCIF_FORMAT = 6,
    ENC_DCIF_FORMAT    = 7,
    ENC_VGA_FORMAT     = 8
  );

  PMOTION_DATA_HEADER = ^MOTION_DATA_HEADER;
  MOTION_DATA_HEADER = packed record
    PicFormat:     PictureFormat_t;
    HorizeBlocks:  ULONG;
    VerticalBlocks: ULONG;
    BlockSize:     ULONG;
  end;

const
  // OSD base address
  _OSD_BASE        = $9000;
  _OSD_YEAR4       = _OSD_BASE + 0;
  _OSD_YEAR2       = _OSD_BASE + 1;
  _OSD_MONTH3      = _OSD_BASE + 2;
  _OSD_MONTH2      = _OSD_BASE + 3;
  _OSD_DAY         = _OSD_BASE + 4;
  _OSD_WEEK3       = _OSD_BASE + 5;
  _OSD_CWEEK1      = _OSD_BASE + 6;
  _OSD_HOUR24      = _OSD_BASE + 7;
  _OSD_HOUR12      = _OSD_BASE + 8;
  _OSD_MINUTE      = _OSD_BASE + 9;
  _OSD_SECOND      = _OSD_BASE + 10;
  _OSD_MILISECOND  = _OSD_BASE + 11;
  _OSD_APM         = _OSD_BASE + 14;

  // OSD base address EX (v6.0+)
  _OSD_BASE_EX        = $90000;
  _OSD_YEAR4_EX       = _OSD_BASE_EX + 0;
  _OSD_YEAR2_EX       = _OSD_BASE_EX + 1;
  _OSD_MONTH3_EX      = _OSD_BASE_EX + 2;
  _OSD_MONTH2_EX      = _OSD_BASE_EX + 3;
  _OSD_DAY_EX         = _OSD_BASE_EX + 4;
  _OSD_WEEK3_EX       = _OSD_BASE_EX + 5;
  _OSD_CWEEK1_EX      = _OSD_BASE_EX + 6;
  _OSD_HOUR24_EX      = _OSD_BASE_EX + 7;
  _OSD_HOUR12_EX      = _OSD_BASE_EX + 8;
  _OSD_MINUTE_EX      = _OSD_BASE_EX + 9;
  _OSD_SECOND_EX      = _OSD_BASE_EX + 10;
  _OSD_MILISECOND_EX  = _OSD_BASE_EX + 11;
  _OSD_APM_EX         = _OSD_BASE_EX + 14;

implementation

end.
