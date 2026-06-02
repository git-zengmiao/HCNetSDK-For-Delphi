@echo off
:: HikFMX Demo 5 启动脚本
:: 用途：确保 VLC DLL 在搜索路径中
:: 如果 VLC 已安装到默认路径（C:\Program Files\VideoLAN\VLC），
:: VLC DLL 应该已经可以找到，不需要此脚本

:: 如需自定义 VLC 路径，取消下面的注释并修改：
:: set PATH=C:\Program Files\VideoLAN\VLC;%PATH%

start "" "%~dp0HikFmxDemo5.exe"
