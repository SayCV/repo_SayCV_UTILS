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
echo SayCV_MXE: Add Python bin dir to PATH.
set PATH=D:\Python27;%PATH%

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
set PATH=%GOROOT%/pkg/tool/windows_386;%PATH%

echo SayCV_MXE: Add SayCV_MXE bin dir to PATH.
set PATH=%PATH%;%SayCV_MXE_HOME%/usr/bin

::: ##############################
::: Install Go mandelbrot
call :__subCall_Build_SAYCV_GO_mandelbrot_INSTALL__
::: ##############################
::: Install Go Language Library for SVG generation
call :__subCall_Build_SAYCV_GO_SVGO_INSTALL__ barchart
rem No Para Means all
rem barchart bubtrail bulletgraph
rem pmap
::: ##############################
::: Install geo: Geographical calculations in Go
call :__subCall_Build_SAYCV_GO_GEO_INSTALL__
cd %GOROOT%/src/pkg/github.com/kellydunn/golang-geo
GO_ENV=test go test
rem helpers
::: ##############################
::: Install gocode and MarGo
rem call :__subCall_Build_SAYCV_GO_IDE_INSTALL__
::: ##############################
::: Example: So Simple, So Ugly
rem call :__subCall_Build_SAYCV_GO_UIK_TEST__ uiktest
rem uikradio uiktest 
::: ##############################
::: Example: So Useful, So Good
rem call :__subCall_Build_SAYCV_GO_WALK_TEST__ notifyicon
rem declarative dialog drawing externalwidgets filebrowser imageicon imageviewer img
rem listbox logview notifyicon progressindicator tableview webview

::: ##############################
cd %HOME%
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
  goto :EOF

:__subCall_Build_SAYCV_GO_mandelbrot_INSTALL__
rem	go get github.com/Nightgunner5/mandelbrot
rem	goto :__subCall_Status_Code__

:__subCall_Build_SAYCV_GO_SVGO_INSTALL__
	go get github.com/ajstarks/svgo
	go install github.com/ajstarks/svgo/...
	cd %GOROOT%/src/pkg/github.com/ajstarks/svgo
	rem quag svgdef svgopher
	rem call :__subCall_Build_SAYCV_GO_COMMON_TEST__ %1
  goto :__subCall_Status_Code__

:__subCall_Build_SAYCV_GO_GEO_INSTALL__
	go get -u github.com/kellydunn/golang-geo
	cd %GOROOT%/src/pkg/github.com/kellydunn/golang-geo/test
	call :__subCall_Build_SAYCV_GO_COMMON_TEST__ %1

:__subCall_Build_SAYCV_GO_IDE_INSTALL__
	go get -u github.com/nsf/gocode
	go get -u github.com/DisposaBoy/MarGo
	go install github.com/nsf/gocode
	go install github.com/DisposaBoy/MarGo
  goto :__subCall_Status_Code__

:__subCall_Build_SAYCV_GO_UIK_TEST__
	rem go get github.com/AllenDang/w32
	rem go get github.com/skelterjohn/go.uik
	cd %GOROOT%/src/pkg/github.com/skelterjohn/go.uik/examples
	call :__subCall_Build_SAYCV_GO_COMMON_TEST__ %1

:__subCall_Build_SAYCV_GO_WALK_TEST__
	rem go get github.com/lxn/walk
	cd %GOROOT%/src/pkg/github.com/lxn/walk/examples
	call :__subCall_Build_SAYCV_GO_COMMON_TEST__ %1
	
:__subCall_Build_SAYCV_GO_COMMON_TEST__
	if "%1"=="" goto :__subCall_Status_Code__
	cd %1
	if exist build.bat (
		call build.bat
	) else (
		go build
	)
	echo Run Programes...
	%1.exe
  goto :__subCall_Status_Code__


