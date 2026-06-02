{
  HikFMX Demo 5 - RTSP via PasLibVlc

  前置条件
  =========
  1. 安装 VLC（与 Delphi 编译目标匹配的位数）
     - 32位编译 → 安装 32位 VLC
     - 64位编译 → 安装 64位 VLC
     - 下载地址: https://www.videolan.org/vlc/
  2. Delphi 搜索路径需要包含：
     - ..\..\PasLibVlc_3.0.8\source      (PasLibVlcUnit.pas, PasLibVlcClassUnit.pas)
     - ..\..\PasLibVlc_3.0.8\source.fmx  (FmxPasLibVlcPlayerUnit.pas)

  海康 RTSP 地址格式
  ==================
  rtsp://admin:password@IP:554/Streaming/Channels/101  (主码流)
  rtsp://admin:password@IP:554/Streaming/Channels/102  (子码流)
  rtsp://admin:password@IP:554/Streaming/Channels/103  (第三码流)

  部分老型号海康：
  rtsp://admin:password@IP:554/h264/ch1/main/av_stream
  rtsp://admin:password@IP:554/h264/ch1/sub/av_stream

  集成说明
  ========
  - TFmxPasLibVlcPlayer 继承自 TImage，视频帧通过 VLC 回调渲染到 Bitmap
  - 不需要 HWND，纯 FMX 软件渲染，可跨平台（Windows/macOS）
  - 播放只需一行: vlcPlayer.Play('rtsp://...');
  - RTL 优化: --rtsp-tcp（TCP传输更稳定）+ --network-caching=200（降低延迟）

  DLL 加载机制
  ============
  - PasLibVlc 使用 LoadLibrary + GetProcAddress 动态加载 libvlc.dll
  - 不在 PE 导入表中，不存在海康 SDK 那种 DLL 找不到的问题
  - 默认自动搜索 VLC 安装路径，也可通过 VLC.Path 属性或 VLC 安装目录指定
}
