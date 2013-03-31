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
    echo Init Included MinGW and Cygwin env.
    set "PATH=%INSTALL_ENV_DIR_CYGWIN%\bin;!PATH!"
    set "PATH=%INSTALL_ENV_DIR_MINGW%\bin;!PATH!"
    set "PATH=%INSTALL_ENV_DIR_MINGW%\msys\1.0\bin;%INSTALL_ENV_DIR_MINGW%\msys\1.0\local\bin;!PATH!"
  )
)
SetLocal DisableDelayedExpansion
echo SayCV_MXE: Add git bin dir to PATH.
set PATH=%PATH%;D:\Program Files (x86)\Git\bin
echo SayCV_MXE: Add Python bin dir to PATH.
set PATH=D:\Python27;%PATH%;
rem echo %PATH%

echo SayCV_MXE: echo Init HOME directory to here call batfile.
set HOME=%cd%

REM ******************************
REM Start ...
REM ##############################
cd SayCV_MXE
set HOME=%cd%

rem END_WITH_SHUTDOWN_NO=0
rem END_WITH_SHUTDOWN_YES=1
rem END_WITH_SHUTDOWN_YES_TIME=2
set /a END_WITH_SHUTDOWN_FLAG=0

set MINGW_PKG_DIR=%INSTALL_ENV_DIR_MINGW%\var\cache\mingw-get\packages
if not exist stamp_call_mingw_get (
  mingw-get install msys-libtool msys-wget
  touch stamp_call_mingw_get
)

if "1" == "1" (
  echo SayCV_MXE: Hacked to Ignore check-requirements.
  bash --login -i -c "mkdir -p usr/installed"
  cd usr/installed && touch check-requirements
  cd ../../
)

if not exist stamp_getready_requirements_update_checksum (
  if "1" == "0" (
    call MXE_GetReady_Requirements.bat
  ) else (
    call MXE_GetReady_Requirements.bat
  )
)

echo SayCV_MXE: Start Make PKGS...
rem bash --login -i  -c "make update-checksum-mercurial"
cd SayCV_MXE
cd usr/installed
rm -f mercurial
cd ../tmp/mercurial/mercurial-2.5.2
rm -f stamp_cfg_mercurial-2.5.2
cd ../../../../../
bash --login -i -c "make mercurial"

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
  goto :__subCall_EOF__
