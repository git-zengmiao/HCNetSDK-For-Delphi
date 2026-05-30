unit Unit1;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, Vcl.XPMan, HCNetSDK, plaympeg4,
  Vcl.ExtCtrls, Vcl.DBCtrls;

type
  TForm1 = class(TForm)
    Button2: TButton;
    Button3: TButton;
    Btn_Play_Wnd: TDBImage;
    Button1: TButton;
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    Label4: TLabel;
    Label5: TLabel;
    Edit1: TEdit;
    Edit2: TEdit;
    Edit3: TEdit;
    Edit4: TEdit;
    Edit5: TEdit;
    procedure Button2Click(Sender: TObject);
    procedure Button3Click(Sender: TObject);
    procedure Button1Click(Sender: TObject);
  private
    hWndC : THandle;
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Form1: TForm1;

  g_nPort: longint;

   //登录相关参数
   lUserID: Longint;  //登录返回值，具有唯一性，后续对设备的操作都需要通过此ID实现
   deviceIP: PAnsiChar;  //设备IP地址
   devicePort: Word;     //设备端口号
   userName: PAnsiChar;   //登录用户名
   passWord: PAnsiChar;   //登录密码
   struDeviceInfo: NET_DVR_DEVICEINFO_V30; //设备参数信息结构

   //预览相关参数
   lRealHandle: Longint;                //预览句柄
   struPlayInfo: NET_DVR_CLIENTINFO;    //预览参数
   zhuatuInfo: NET_DVR_JPEGPARA;     //抓图参数
   pUser: Pointer;                      //用户数据

   //错误号
   dwRet : integer;

   const WM_CAP_START = WM_USER;
const WM_CAP_STOP = WM_CAP_START + 68;
const WM_CAP_DRIVER_CONNECT = WM_CAP_START + 10;
const WM_CAP_DRIVER_DISCONNECT = WM_CAP_START + 11;
const WM_CAP_SAVEDIB = WM_CAP_START + 25;
const WM_CAP_GRAB_FRAME = WM_CAP_START + 60;
const WM_CAP_SEQUENCE = WM_CAP_START + 62;
const WM_CAP_FILE_SET_CAPTURE_FILEA = WM_CAP_START + 20;
const WM_CAP_SEQUENCE_NOFILE =WM_CAP_START+ 63 ;
const WM_CAP_SET_OVERLAY =WM_CAP_START+ 51 ;
const WM_CAP_SET_PREVIEW =WM_CAP_START+ 50 ;
const WM_CAP_SET_CALLBACK_VIDEOSTREAM = WM_CAP_START +6;
const WM_CAP_SET_CALLBACK_ERROR=WM_CAP_START +2;
const WM_CAP_SET_CALLBACK_STATUSA= WM_CAP_START +3;
const WM_CAP_SET_CALLBACK_FRAME= WM_CAP_START +5;
const WM_CAP_SET_SCALE=WM_CAP_START+ 53 ;
const WM_CAP_SET_PREVIEWRATE=WM_CAP_START+ 52 ;

function capCreateCaptureWindowA(lpszWindowName : PCHAR; dwStyle : longint;x : integer;y : integer;nWidth : integer; nHeight : integer;ParentWin : HWND;nId : integer): HWND; STDCALL EXTERNAL 'AVICAP32.DLL';


implementation

{$R *.dfm}

procedure TForm1.Button1Click(Sender: TObject);
begin
 //初始化SDK;
    if NET_DVR_Init() then
      showmessage('SDK初始化成功')
    else
      showmessage('SDK初始化失败');
    lUserID := -1;
    lRealHandle :=-1;
    dwRet := 0;


    //对参数赋初值
    deviceIP := PAnsiChar(AnsiString(Edit1.Text));
    devicePort := StrtoInt(Edit2.Text);
    userName := PAnsiChar(AnsiString(Edit3.Text));
    passWord := PAnsiChar(AnsiString(Edit4.Text));
//      deviceIP := PAnsiChar('192.168.0.70');
//      devicePort := StrtoInt('8000');
//      userName := PAnsiChar('admin');
//      passWord := PAnsiChar('qq123456789');


    //登录设备
    lUserID := NET_DVR_Login_V30(deviceIP, devicePort, userName, passWord, @struDeviceInfo);
    if lUserID < 0 then
    begin
        dwRet := NET_DVR_GetLastError();
        Showmessage('登录设备失败，错误号为'+ IntToStr(dwRet));
        Exit;
    end;
end;

procedure TForm1.Button2Click(Sender: TObject);
begin


if lUserID < 0 then
    begin
        Showmessage('请先登录设备！');
        Exit;
    end;

    struPlayInfo.lChannel := StrtoInt(Edit5.Text);  //通道号
    struPlayInfo.lLinkMode := 0; //最高位为1表示子码流，其他位值：0-TCP方式，1-UDP方式，2-多播方式
    struPlayInfo.sMultiCastIP := NIL; //多播组地址
    struPlayInfo.hPlayWnd := Btn_Play_Wnd.Handle; //预览窗口
    //struPlayInfo.hPlayWnd := 0;//不解码只取流
//  struPlayInfo.hPlayWnd:= Panel1.Handle;
    //开始预览
    lRealHandle := NET_DVR_RealPlay_V30(lUserID, @struPlayInfo, nil, pUser, TRUE);
//  lRealHandle := NET_DVR_RealPlay(lUserID, @struPlayInfo);

    //设置回调函数，在回调里面解码
    //lRealHandle := NET_DVR_RealPlay_V30(lUserID, @struPlayInfo, @testRealDataCallBack_V30,  pUser, TRUE);

    if lRealHandle>=0 then
    begin
        showmessage('播放成功....');
    end
    else
    begin
        dwRet := NET_DVR_GetLastError();
        Showmessage('预览失败，错误号为'+ IntToStr(dwRet));
    end;
//    Btn_Play_Wnd.Caption := 'Play!';
end;

procedure TForm1.Button3Click(Sender: TObject);
begin
//if NET_DVR_CaptureJPEGPicture(lRealHandle, 1, zhuatuInfo, PChar('C:\12332222.jpg')) then
//showmessage(ExtractFilePath(Paramstr(0))+'time.bmp');
if NET_DVR_CapturePicture(lRealHandle, PAnsiChar('D:\time.bmp')) then
   showmessage('抓图成功,路径：D:\time.bmp')
else
   showmessage('抓图失败');
//  Btn_Play_Wnd.Picture.SaveToFile('C:\\1111.bmp');
end;

end.
