@echo off
echo No Copyright @ SayCV.
echo Use of this source code is governed by a BSD-style
echo license that can be found in the LICENSE file.
echo.
echo 2013 @ SayCV.Xiao.
echo.

cd /d %~dp0

rem echo set dos windows size : cols=113, lines=150, color=black
rem mode con cols=113 lines=15 & color 0f

rem set whether shutdown computer or not when call end with the batch.
set /a END_WITH_SHUTDOWN_NO=0
set /a END_WITH_SHUTDOWN_YES=1
set /a END_WITH_SHUTDOWN_YES_TIME=2
set /a END_WITH_SHUTDOWN_FLAG=0

rem set other values to included both MinGW and Cygwin Env.
set /a INSIDE_UTILS_ENV_MINGW=0
set /a INSIDE_UTILS_ENV_CYGWIN=1
set /a INSIDE_UTILS_ENV_BOTHALL=2
set /a INSIDE_UTILS_ENV_FLAG=0

rem set other values to do some user cmds
set /a EOF_ENV_CMD=0
set /a EOF_ENV_BASH=1
set /a EOF_ENV_EOF=3
set /a EOF_ENV_FLAG=3

rem set JAVA SDK values will be used
set /a USED_JAVA_VER_1D6=0
set /a USED_JAVA_VER_1D7=1
set /a USED_JAVA_VER_NONE=3
set /a USED_JAVA_VER_FLAG=0

set INSTALL_ENV_DIR_MINGW=D:\MinGW
set INSTALL_ENV_DIR_CYGWIN=D:\cygwin

SetLocal EnableDelayedExpansion
if %INSIDE_UTILS_ENV_FLAG% EQU %INSIDE_UTILS_ENV_MINGW% (
    echo Init Included MinGW env.
    set "PATH=%INSTALL_ENV_DIR_MINGW%\bin;!PATH!"
    set "PATH=%INSTALL_ENV_DIR_MINGW%\msys\1.0\bin;%INSTALL_ENV_DIR_MINGW%\msys\1.0\local\bin;!PATH!"
) else (
  if %INSIDE_UTILS_ENV_FLAG% EQU %INSIDE_UTILS_ENV_CYGWIN% (
    echo Init Included Cygwin env.
    set "PATH=%INSTALL_ENV_DIR_CYGWIN%\bin;!PATH!"
  ) else (
    if %INSIDE_UTILS_ENV_FLAG% EQU %INSIDE_UTILS_ENV_BOTHALL% (
      echo Init Included MinGW and Cygwin env.
      set "PATH=%INSTALL_ENV_DIR_CYGWIN%\bin;!PATH!"
      set "PATH=%INSTALL_ENV_DIR_MINGW%\bin;!PATH!"
      set "PATH=%INSTALL_ENV_DIR_MINGW%\msys\1.0\bin;%INSTALL_ENV_DIR_MINGW%\msys\1.0\local\bin;!PATH!"
    ) else (
      echo Init Excluded MinGW and Cygwin env.
    )
  )
)
SetLocal DisableDelayedExpansion
echo SayCV_MXE: Add 7z bin dir to PATH.
set PATH=%PATH%;D:\Program Files\7-Zip
echo SayCV_MXE: Add git bin dir to PATH.
set PATH=%PATH%;D:\Program Files (x86)\Git\bin
set PATH=%PATH%;D:\Program Files\Git\bin
echo SayCV_MXE: Add Python bin dir to PATH.
set PATH=D:\Python27;%PATH%
rem echo %PATH%

echo SayCV_MXE: echo Init HOME directory to here call batfile.
set HOME=%cd%
set ORIGIN_HOME=%cd%

REM ******************************
REM Start ...
REM ##############################
echo SayCV_MXE: Set JAVA_HOME Env.
set JAVA_INSTALL_DIR=D:/cygwin/opt/Java
if '%USED_JAVA_VER_FLAG%'=='%USED_JAVA_VER_1D6%' (
	set "JAVA_HOME=%JAVA_INSTALL_DIR%/jdk6"
	rem set  "JRE_HOME=%JAVA_INSTALL_DIR%/jre6
	set  "CLASSPATH=%JAVA_HOME%/lib:%JRE_HOME%/lib
	echo SayCV_MXE: Set JAVA_HOME Env to 1.6.
) else (
	if '%USED_JAVA_VER_FLAG%'=='%USED_JAVA_VER_1D7%' (
		set "JAVA_HOME=%JAVA_INSTALL_DIR%/jdk7"
		rem set  "JRE_HOME=%JAVA_INSTALL_DIR%/jre7
		set  "CLASSPATH=%JAVA_HOME%/lib:%JRE_HOME%/lib
		echo SayCV_MXE:Set JAVA_HOME Env to 1.7.
	) else (
		echo SayCV_MXE: Do NOT Needed Set JAVA_HOME Env.
	)
)
if not exist %JAVA_HOME% (
	echo SayCV_MXE: But directory of JAVA_HOME NOT Exist.
)
echo SayCV_MXE: Add JAVA_HOME bin to PATH.
set "PATH=%JAVA_HOME%/bin;%PATH%"

echo SayCV_MXE: Set PKG_CONFIG_PATH to MXE Builds.
set "SayCV_MXE_HOME=%HOME%/SayCV_MXE"
set "PKG_CONFIG=i686-pc-mingw32-pkg-config"
set "PKG_CONFIG_PATH=%HOME%/SayCV_MXE/usr/i686-pc-mingw32/lib/pkgconfig"
set "PKG_CONFIG_PATH_i686_pc_mingw32=%HOME%/SayCV_MXE/usr/i686-pc-mingw32/lib/pkgconfig"


echo SayCV_MXE: Ignore Add MXE Builds bin to PATH.
rem set "PATH=%SayCV_MXE_HOME%/usr/bin;%PATH%"

echo SayCV_MXE: D:\MinGW\msys\1.0\bin\make.exe: 
echo SayCV_MXE: *** couldn't commit memory for cygwin heap, Win32 error 0
echo SayCV_MXE: Please try rebasing the DLL.
echo SayCV_MXE: You'll need to copy it to a temporary location, rebase the copy, 
echo SayCV_MXE: exit all MSYS processes and copy the rebased DLL to the bin directory.
bash --login -i -c "cp /bin/msys-1.0.dll origin-msys-1.0.dll"
bash --login -i -c "cp -f origin-msys-1.0.dll rebase-msys-1.0.dll"
bash --login -i -c "rebase -b 0x64000000 rebase-msys-1.0.dll"
echo SayCV_MXE: Set Cygwin ENV to Replace MinGW DLL.
set "PATH=%INSTALL_ENV_DIR_CYGWIN%/bin;%PATH%"
bash --login -i -c "cp -f rebase-msys-1.0.dll /bin/msys-1.0.dll"
rem bash --login -i- c "rebase -b 0x30000000 /bin/msys-1.0.dll"
rem bash --login -i- c "rebase -b 0x70000000 /bin/msys-1.0.dll"

REM ##############################
REM End ...
REM ******************************

:__subCall_Status_Code__
if "%errorlevel%"=="0" ( 
	echo Done Sucessful.
	goto :__subCall_Call_Branch__
) else (
  if "%errorlevel%"=="1" (
  	echo Done Failed.
  	goto :__subCall_Call_Branch__
  ) else (
    echo Not Found Error.
    echo "errorlevel=%errorlevel%"
  	goto :__subCall_Call_Branch__
  )
)

:__subCall_Call_Branch__
if %EOF_ENV_FLAG% EQU %EOF_ENV_CMD% (
  call :__subCall_CMD__
) else (
  if %EOF_ENV_FLAG% EQU %EOF_ENV_BASH% (
  	call :__subCall_BASH__
  ) else (
  	call :__subCall_EOF__
  )
)

:__subCall_BASH__
  bash --login -i
  goto :__subCall_EOF__

:__subCall_CMD__
  cmd
  goto :__subCall_EOF__

:__subCall_EOF__
:EOF
  rem call :__subCall_ShutDown_EOF__
  PAUSE
  EXIT

:__subCall_ShutDown_EOF__
  if "END_WITH_SHUTDOWN_FLAG" == "END_WITH_SHUTDOWN_YES_TIME" (
    at 22:50 every:M,T,W,Th,F,S,Su shutdown -s -t 60 -c "很晚了,该睡觉了了！"
    at 13:50 every:M,T,W,Th,F,S,Su shutdown -s -t 60 -c "要停电了，快存盘吧！"
    at 15:50 every:M,T,W,Th,F,S,Su shutdown -s -t 60 -c "要停电了，快存盘吧！"
    at 9:50 every:M,T,W,Th,F,S,Su shutdown -s -t 60 -c "要停电了，快存盘吧！"
    at 5:50 every:M,T,W,Th,F,S,Su shutdown -s -t 60 -c "要停电了，快存盘吧！"
    echo 开始定时关闭机器！
  ) else (
    if "END_WITH_SHUTDOWN_FLAG" == "END_WITH_SHUTDOWN_YES" (
      shutdown -s -t 00
      echo 开始关闭机器！
    ) else (
      echo Do Nothing for shutdown computer!!!
    )
  )
  goto :__subCall_EOF__

:__subCall_Build_PKGs__
	bash --login -i -c "make update-checksum-%1"
	bash --login -i -c "make %1"
  goto :__subCall_Status_Code__
