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

set /a INSIDE_UTILS_ENV_JAVA=1
set /a INSIDE_UTILS_ENV_VISUAL_STUDIO=0
set /a INSIDE_UTILS_ENV_QT=0

set /a INSIDE_UTILS_ENV_SAYCV_MXE=0
set /a INSIDE_UTILS_ENV_HG=1
set /a INSIDE_UTILS_ENV_RTEMS=1
set /a INSIDE_UTILS_ENV_APACHE_ANT=1
set /a INSIDE_UTILS_ENV_GOOGLE_GO=1
set /a INSIDE_UTILS_ENV_AUTOBAHNTESTSUITE=1

set /a SETTINGS_HTTP_PROXY=0

rem set other values to do some user cmds
set /a EOF_ENV_CMD=0
set /a EOF_ENV_BASH=1
set /a EOF_ENV_EOF=3
set /a EOF_ENV_FLAG=3

rem set JAVA SDK values will be used
set /a USED_JAVA_VER_1D6=0
set /a USED_JAVA_VER_1D7=1
set /a USED_JAVA_VER_NONE=3
set /a USED_JAVA_VER_FLAG=1

set INSTALL_ENV_DIR_MINGW=D:/MinGW
set INSTALL_ENV_DIR_CYGWIN=D:/cygwin

set ORIGIN_PATH=%PATH%

SetLocal EnableDelayedExpansion
if %INSIDE_UTILS_ENV_FLAG% EQU %INSIDE_UTILS_ENV_MINGW% (
    echo Init Included MinGW env.
    set "PATH=%INSTALL_ENV_DIR_MINGW%/bin;!PATH!"
    set "PATH=%INSTALL_ENV_DIR_MINGW%/msys/1.0/bin;%INSTALL_ENV_DIR_MINGW%/msys/1.0/local/bin;!PATH!"
) else (
  if %INSIDE_UTILS_ENV_FLAG% EQU %INSIDE_UTILS_ENV_CYGWIN% (
    echo Init Included Cygwin env.
    set "PATH=%INSTALL_ENV_DIR_CYGWIN%/bin;!PATH!"
  ) else (
    if %INSIDE_UTILS_ENV_FLAG% EQU %INSIDE_UTILS_ENV_BOTHALL% (
      echo Init Included MinGW and Cygwin env.
      set "PATH=%INSTALL_ENV_DIR_CYGWIN%/bin;!PATH!"
      set "PATH=%INSTALL_ENV_DIR_MINGW%/bin;!PATH!"
      set "PATH=%INSTALL_ENV_DIR_MINGW%/msys/1.0/bin;%INSTALL_ENV_DIR_MINGW%/msys/1.0/local/bin;!PATH!"
    ) else (
      echo Init Excluded MinGW and Cygwin env.
    )
  )
)
SetLocal DisableDelayedExpansion
echo SayCV_MXE: Add git bin dir to PATH.
set PATH=%PATH%;D:/Program Files (x86)/Git/bin
set PATH=%PATH%;D:/Program Files/Git/bin
echo SayCV_MXE: Add Python bin dir to PATH.
set PATH=D:/Python27;D:/Python27/Scripts;%PATH%
rem echo %PATH%

echo SayCV_MXE: Init HOME directory to here call batfile.
set HOME=%cd%
set ORIGIN_HOME=%cd%

if '%INSIDE_UTILS_ENV_JAVA%' == '1' (
SetLocal EnableDelayedExpansion
echo SayCV_MXE: Set JAVA_HOME Env.
set JAVA_INSTALL_DIR=D:/cygwin/opt/Java
if '%USED_JAVA_VER_FLAG%'=='%USED_JAVA_VER_1D6%' (
	set "JAVA_HOME=!JAVA_INSTALL_DIR!/jdk6"
	rem set  "JRE_HOME=!JAVA_INSTALL_DIR!/jre6
	set  "CLASSPATH=!JAVA_HOME!/lib:!JRE_HOME!/lib
	echo SayCV_MXE: Set JAVA_HOME Env to 1.6.
) else (
	if '%USED_JAVA_VER_FLAG%'=='%USED_JAVA_VER_1D7%' (
		set "JAVA_HOME=!JAVA_INSTALL_DIR!/jdk7"
		rem set  "JRE_HOME=!JAVA_INSTALL_DIR!/jre7
		set  "CLASSPATH=!JAVA_HOME!/lib:!JRE_HOME!/lib
		echo SayCV_MXE: Set JAVA_HOME Env to 1.7.
	) else (
		echo SayCV_MXE: Do NOT Needed Set JAVA_HOME Env.
	)
)
if not exist "!JAVA_HOME!" (
	echo SayCV_MXE: But directory of JAVA_HOME NOT Exist.
)
SetLocal DisableDelayedExpansion
)

if '%INSIDE_UTILS_ENV_QT%'=='1' (
SetLocal EnableDelayedExpansion
echo SayCV_MXE: Add QT bin dir to PATH.
set QMAKESPEC=win32-g++
set "QT_SDK_DIR=D:/MinGW/opt/Qt/4.8.4"
set "QT_SDK_DIR=D:/work_coding/bitbucket-SayCV-Hosting/repo_SayCV_UTILS/SayCV_MXE/tmp/qt/qt-everywhere-opensource-src-4.8.4"
set QT64_502_ROOT=!SayCV_MXE_HOME!/usr/opt/Qt64-5.0.2
set Qt32_484_ROOT=!SayCV_MXE_HOME!/usr/opt/Qt32-4.8.4
if '1'=='0' (
	set "PATH=!QT64_502_ROOT!/bin;!PATH!"
	set "PATH=!QT64_502_ROOT!/pre_bin;!PATH!"
	set "QTDIR=!QT64_502_ROOT!"
) else (
	if '1'=='0' (
		set "PATH=!Qt32_484_ROOT!/bin;!PATH!"
		set "PATH=!Qt32_484_ROOT!/ported32/bin;!PATH!"
		set "QTDIR=!Qt32_484_ROOT!"
	) else (
		set "PATH=!QT_SDK_DIR!/bin;!PATH!"
		set "QTDIR=!QT_SDK_DIR!"
	)
)
SetLocal DisableDelayedExpansion
)

if '%INSIDE_UTILS_ENV_VISUAL_STUDIO%'=='1' (
setlocal enabledelayedexpansion
echo SayCV_MXE: Set VCPath and SDKPath.
set      "VCROOT=D:/Program Files (x86)/Microsoft Visual Studio 11.0"
set "VC_IDE_PATH=!VCROOT!/Common7/IDE"
set      "VCPath=!VCROOT!/VC"
set     "SDKPath=D:/Program Files (x86)/Microsoft SDKs/Windows/v7.1"

echo SayCV_MXE: Add Microsoft Visual Studio IDE dir to PATH.
set "PATH=!PATH!;!VC_IDE_PATH!"

echo SayCV_MXE: Call vcvars32.bat.
call "!VCPath!/bin/vcvars32.bat"
setlocal disabledelayedexpansion
)

if '%INSIDE_UTILS_ENV_RTEMS%'=='1' (
setlocal enabledelayedexpansion
echo SayCV_MXE: Config RTEMS TOOLs and BSP SDK.
set      "RTEMSROOT=D:/cygwin/opt"
set "RTEMS_TOOLS_PATH=!RTEMSROOT!/rtems-4.11-tools-VO1/bin;!RTEMSROOT!/rtems-4.11-tools/bin"

set			"RTEMS_BSPSDK_PATH=!RTEMSROOT!/rtems-4.11/arm-rtemseabi4.11"
set     "MKIMAGE=%HOME%/barebox-at91/scripts/mkimage.exe"

echo SayCV_MXE: Add RTEMS TOOLs to PATH.
set "PATH=!PATH!;!RTEMS_TOOLS_PATH!"

setlocal disabledelayedexpansion
)

if %SETTINGS_HTTP_PROXY% ==1 (
	echo SayCV_MXE: Setting http_proxy on.
	set http_proxy=http://127.0.0.1:8087/
	set https_proxy=http://127.0.0.1:8087/
)

echo SayCV_MXE: Setting SayCV_MXE_HOME and SayCV_MXE_TARGET_PATH.
set SayCV_MXE_HOME=%ORIGIN_HOME%/../repo_SayCV_UTILS/SayCV_MXE
set SayCV_MXE_TARGET_PATH=%ORIGIN_HOME%/../work_root/target
echo SayCV_MXE: Setting SayCV_MXE_HOME_ABS and SayCV_MXE_TARGET_PATH_ABS.
cd ..
set SayCV_MXE_HOME_ABS=%cd%/repo_SayCV_UTILS/SayCV_MXE
set SayCV_MXE_TARGET_PATH_ABS=%cd%/work_root/target
cd %ORIGIN_HOME%

if '%INSIDE_UTILS_ENV_SAYCV_MXE%'=='1' (
setlocal enabledelayedexpansion
	echo SayCV_MXE: Add SAYCV_MXE TOOLs to PATH.
	set "PATH=!SayCV_MXE_HOME!/bin;!PATH!"
	set "CROSS_COMPILE=i686-pc-mingw32-"
setlocal disabledelayedexpansion
)

if '%INSIDE_UTILS_ENV_APACHE_ANT%'=='1' (
setlocal enabledelayedexpansion
	echo SayCV_MXE: Add Apache ant TOOLs to PATH.
	set      "APACHE_ANT_ROOT=!SayCV_MXE_HOME!/usr/opt/ant"

	set "PATH=!PATH!;!APACHE_ANT_ROOT!/bin"
setlocal disabledelayedexpansion
)

if '%INSIDE_UTILS_ENV_HG%'=='1' (
setlocal enabledelayedexpansion
echo SayCV_MXE: Set Mercurial HG Path.
set      "HGROOT=C:/Program Files/Mercurial"
echo SayCV_MXE: Add Mercurial HG dir to PATH.
set "PATH=!PATH!;!HGROOT!"
setlocal disabledelayedexpansion
)

if '%INSIDE_UTILS_ENV_GOOGLE_GO%'=='1' (
setlocal enabledelayedexpansion
	echo SayCV_MXE: Config Google Go TOOLs.
	rem set "GOOS=windows"
	rem set "GOARCH=386"
	rem Because of PATH NOT Include such as ..
	set "GOROOT=!SayCV_MXE_HOME_ABS!/usr/opt/go"

	echo SayCV_MXE: Add Google Go TOOLs to PATH.
	set "PATH=!GOROOT!/bin;!PATH!"
	set "GOPATH=!HOME!/SayCV_Go"
	set "PATH=!GOROOT!/pkg/tool/windows_386;!PATH!"
setlocal disabledelayedexpansion
)

if '%INSIDE_UTILS_ENV_AUTOBAHNTESTSUITE%'=='0' (
setlocal enabledelayedexpansion
	if not exist get-pip.py (
		wget -c --no-check-certificate https://bootstrap.pypa.io/get-pip.py
		python get-pip.py
	)
	python get-pip.py
	rem python -m pip install -U pip
	pip install --upgrade setuptools
	rem pip install --upgrade setuptools DONE.
	pip install autobahntestsuite
	if '0'=='1' (
		echo SayCV_MXE: Alternatively, install from sources.
		cd %ORIGIN_HOME%
		git clone git://github.com/tavendo/AutobahnTestSuite.git
		cd %ORIGIN_HOME%/AutobahnTestSuite
		rem git checkout v0.6.1
		cd %ORIGIN_HOME%/AutobahnTestSuite/autobahntestsuite
		python setup.py install
		cd %ORIGIN_HOME%
	)
	
	if '0'=='1' (
		if not exist autobahntestsuite-0.6.1 (
			wget -c --no-check-certificate https://pypi.python.org/packages/source/a/autobahntestsuite/autobahntestsuite-0.6.1.zip
		)
		cd %ORIGIN_HOME%/autobahntestsuite-0.6.1
		rem cd %ORIGIN_HOME%/AutobahnTestSuite/autobahntestsuite
		python setup.py install
		cd %ORIGIN_HOME%
	)
	
	echo SayCV_MXE: Add AutobahnTestSuite TOOLs to PATH.
	set "AutobahnTestSuite_ROOT=!HOME!/SayCV_Go"
	set "PATH=!AutobahnTestSuite_ROOT!/bin;!PATH!"
setlocal disabledelayedexpansion
)

REM ******************************
REM Start ...
REM ##############################

if '1'=='1' (
	go get github.com/SayCV/shutdowntimer
	cd %ORIGIN_HOME%/SayCV_Go/src/github.com/SayCV/shutdowntimer
	go build
	rem -ldflags "-H windowsgui"
	cmd
)

if '1'=='1' (
	echo "godiff file1 file2 > results.html"
	echo "godiff directory1 directory > results.html"
	go get github.com/spcau/godiff
	cd %ORIGIN_HOME%/SayCV_Go/src/github.com/spcau/godiff
	go build -o godiff.exe  godiff.go godiff_windows.go
	cmd
)

::: ##############################
::: Install Go: An image conversion command line tool written in the Go language
::: Install Go: Require a runtime or specific tools: ImageMagick
rem call :__subCall_Build_SAYCV_GO_goconvert_INSTALL__
::: ##############################
::: Install Go mandelbrot
rem call :__subCall_Build_SAYCV_GO_mandelbrot_INSTALL__
::: ##############################
::: Install Go Language Library for SVG generation
rem call :__subCall_Build_SAYCV_GO_SVGO_INSTALL__ barchart
rem No Para Means all
rem barchart bubtrail bulletgraph
rem pmap
::: ##############################
::: Install geo: Geographical calculations in Go
rem call :__subCall_Build_SAYCV_GO_GEO_INSTALL__
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
	cd %ORIGIN_HOME%
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

rem ./goconvert -f imagefolderpath -c mycollectionname
:__subCall_Build_SAYCV_GO_goconvert_INSTALL__
	go get code.google.com/p/exif4go
	go get code.google.com/p/goconvert
	cd %GOROOT%/src/pkg/code.google.com/p/goconvert
	cd HOME=%cd%
	goconvert -f test -c firsttest
	goto :__subCall_Status_Code__

:__subCall_Build_SAYCV_GO_mandelbrot_INSTALL__
	go get github.com/Nightgunner5/mandelbrot
	goto :__subCall_Status_Code__

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
	cd %GOROOT%/src/pkg/github.com/kellydunn/golang-geo
	GO_ENV=test go test
	rem helpers
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


