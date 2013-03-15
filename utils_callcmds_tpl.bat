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

rem set other values to included both MinGW and Cygwin Env.
set /a INSIDE_UTILS_ENV_MINGW=0
set /a INSIDE_UTILS_ENV_CYGWIN=1
set /a INSIDE_UTILS_ENV_FLAG=0

rem set other values to do some user cmds
set /a EOF_ENV_CMD=0
set /a EOF_ENV_BASH=1
set /a EOF_ENV_EOF=3
set /a EOF_ENV_FLAG=0

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
set PATH=%PATH%
rem echo %PATH%

echo Init HOME directory to here call batfile.
set HOME=%cd%

REM ******************************
REM Start ...
REM ##############################


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
  PAUSE
  EXIT
