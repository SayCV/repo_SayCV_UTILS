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
echo SayCV_MXE: Add git bin dir to PATH.
set PATH=%PATH%;D:\Program Files (x86)\Git\bin
set PATH=%PATH%;D:\Program Files\Git\bin
echo SayCV_MXE: Add Python bin dir to PATH.
set PATH=D:\Python27;%PATH%
rem echo %PATH%

echo SayCV_MXE: echo Init HOME directory to here call batfile.
set HOME=%cd%

REM ******************************
REM Start ...
REM ##############################

echo SayCV_MXE: Set JAVA_HOME Env.
set JAVA_HOME=D:\cygwin\opt\java\jdk1.6.0_20
set JAVA_HOME=D:\cygwin\opt\java\jdk1.7.0_07

set HOME_TMP=%cd%
set SayCV_MXE_HOME=%HOME_TMP%/SayCV_MXE
echo SayCV_MXE: Add Apache ant bin dir to PATH.
set PATH=%SayCV_MXE_HOME%/usr/opt/ant/bin;%PATH%;

echo SayCV_MXE: Add Google Go bin dir to PATH.
set GOOS=windows
set GOARCH=386
set GOROOT=%SayCV_MXE_HOME%/usr/opt/go
set PATH=%GOROOT%/bin;%PATH%

echo Goplay is a web interface for experimenting with Go code.
echo It is similar to the Go Playground: http://golang.org/doc/play/
echo To use goplay:
cd %GOROOT%/misc/goplay
go install
mv goplay.exe %GOROOT%/bin/goplay.exe
echo Done goplay

rem cd SayCV_Go
rem go get github.com/SayCV/go-walk
go get github.com/lxn/walk
go get github.com/lxn/polyglot
go get github.com/lxn/polyglot/polyglot
go get github.com/lxn/walk/tools/ui2walk

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
  call :__subCall_ShutDown_EOF__
:EOF
  PAUSE
  EXIT

:__subCall_ShutDown_EOF__
  if "END_WITH_SHUTDOWN_FLAG" == "END_WITH_SHUTDOWN_YES_TIME" (
    at 22:50 every:M,T,W,Th,F,S,Su shutdown -s -t 60 -c "������,��˯�����ˣ�"
    at 13:50 every:M,T,W,Th,F,S,Su shutdown -s -t 60 -c "Ҫͣ���ˣ�����̰ɣ�"
    at 15:50 every:M,T,W,Th,F,S,Su shutdown -s -t 60 -c "Ҫͣ���ˣ�����̰ɣ�"
    at 9:50 every:M,T,W,Th,F,S,Su shutdown -s -t 60 -c "Ҫͣ���ˣ�����̰ɣ�"
    at 5:50 every:M,T,W,Th,F,S,Su shutdown -s -t 60 -c "Ҫͣ���ˣ�����̰ɣ�"
    echo ��ʼ��ʱ�رջ�����
  ) else (
    if "END_WITH_SHUTDOWN_FLAG" == "END_WITH_SHUTDOWN_YES" (
      shutdown -s -t 00
      echo ��ʼ�رջ�����
    ) else (
      echo Do Nothing for shutdown computer!!!
    )
  )
  goto :EOF
