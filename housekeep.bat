@echo off
setlocal enabledelayedexpansion
REM ***Please note that the date format used is DD/MM/YYYY and the time format used is HH:MM***
REM ***Please modify the script as neccessary for different settings***
REM Optional call command line arguments (if not provided, will be prompted)
REM %1 = Folder path to housekeep
REM %2 = time (year + month) on or before which we perform housekeep
REM (Use y to separate between year and month, e.g. 4y6, 0y2, 10y0 are acceptable)
set REPORT_PATH=housekeep_list_report.txt

:set_path
cls
if "%1"=="" (
	set /P HOUSEKEEP_PATH="Please input folder path for housekeeping: "
) else (
	set HOUSEKEEP_PATH=%1
)
if not exist %HOUSEKEEP_PATH% (
	echo %HOUSEKEEP_PATH% does not exist, please retry
	timeout 5
	REM Clear invalid inputs
	shift & shift
	goto :set_path
)

cls
echo ================================================================================
echo Path to housekeep is %HOUSEKEEP_PATH%
echo ================================================================================
choice /M:"Confirm " /D:Y /T:10
if errorlevel 2 goto :set_path

:set_time
cls
echo ================================================================================
echo Path to housekeep is %HOUSEKEEP_PATH%
echo ================================================================================

if "%2"=="" (
	echo Please enter time ^(year + month^) on or before which we perform housekeep
	echo Use y to separate between year and month, e.g. 4y6, 0y2, 10y0 are acceptable
	set /P HOUSEKEEP_TIME_BEFORE="Please input here: "
) else (
	set HOUSEKEEP_TIME_BEFORE=%2
)

echo %HOUSEKEEP_TIME_BEFORE% | findstr /C:"y" | findstr /V "y.*y" > nul || set ERRORMESSAGE=Time must contain exactly 1 'y' && goto :error

REM ***Date format DD/MM/YYYY
set /A MAX_HOUSEKEEP_YEAR_BEFORE=%DATE:~6,4%-1900

for /f "delims=y tokens=1,2,*" %%a in ("%HOUSEKEEP_TIME_BEFORE%") do (
	REM Validate both tokens are not empty
	if "%%a%%b"=="%%a" (set ERRORMESSAGE=Please input number before and after 'y' && goto :error)
	if "%%a%%b"=="%%b" (set ERRORMESSAGE=Please input number before and after 'y' && goto :error)
	
	REM Format the tokens, remove leading zeroes
	call :format_number %%a
	set HOUSEKEEP_YEAR_BEFORE=!Var!
	call :format_number %%b
	set HOUSEKEEP_MONTH_BEFORE=!Var!
		
	REM Validate both tokens are numbers
	echo !HOUSEKEEP_YEAR_BEFORE!| findstr "^[0-9]*$" > nul || set ERRORMESSAGE=Incorrect format && goto :error
	echo !HOUSEKEEP_MONTH_BEFORE!| findstr "^[0-9]*$" > nul || set ERRORMESSAGE=Incorrect format && goto :error
	
	REM Validate year is not before 1900
	if %MAX_HOUSEKEEP_YEAR_BEFORE% LSS !HOUSEKEEP_YEAR_BEFORE! (
		set ERRORMESSAGE=Invalid year, max number of years before is %MAX_HOUSEKEEP_YEAR_BEFORE%
		goto :error
	)
	set /A HOUSEKEEP_YEAR=%DATE:~6,4%-!HOUSEKEEP_YEAR_BEFORE!
	REM Validate month before is not more than 12
	if !HOUSEKEEP_MONTH_BEFORE! GEQ 12 (
		set ERRORMESSAGE=Invalid month, max number of months before is 11
		goto :error
	)
	set /A HOUSEKEEP_MONTH=%DATE:~3,2%-!HOUSEKEEP_MONTH_BEFORE!
)
goto :confirm

:error
echo ================================================================================
echo Error: %ERRORMESSAGE%
echo ================================================================================
echo Please retry
REM Clear invalid inputs
shift
timeout 5
goto :set_time

:confirm
cls
echo ================================================================================
echo Path to housekeep is %HOUSEKEEP_PATH%
echo Housekeep files on or before %HOUSEKEEP_MONTH%/%HOUSEKEEP_YEAR%
echo ================================================================================
choice /M:"Confirm " /D:Y /T:10
if errorlevel 2 goto :set_time
goto :start

:start
if exist %REPORT_PATH% del /F /Q %REPORT_PATH%
echo Housekeep report for path %HOUSEKEEP_PATH% with files dated on or before %HOUSEKEEP_MONTH%/%HOUSEKEEP_YEAR%> %REPORT_PATH%
echo ====================================================================================================>> %REPORT_PATH%

REM Check if number of months before > month, then need to subtract 1 year
if %HOUSEKEEP_MONTH% LEQ 0 (
	set /A HOUSEKEEP_YEAR=%HOUSEKEEP_YEAR%-1
	set /A HOUSEKEEP_MONTH=%HOUSEKEEP_MONTH%+12
)

REM Filter out only files in output from dir command
for /f "tokens=1,2,3,4,*" %%a in ('dir /o:d /a-d %HOUSEKEEP_PATH% ^| findstr /V ^^^<DIR^^^>.*\.\.* ^| findstr /C:/') do (
	REM ***Set last modified date (DD/MM/YYYY) and time (HH:MM) of file
	set LAST_MODIFIED_DATE=%%a
	set LAST_MODIFIED_YEAR=!LAST_MODIFIED_DATE:~6,4!
	set LAST_MODIFIED_MONTH=!LAST_MODIFIED_DATE:~3,2!
	
	ver > nul
	if !LAST_MODIFIED_YEAR! LSS %HOUSEKEEP_YEAR% (
		echo %%d>> %REPORT_PATH%
		echo Last modified date: !LAST_MODIFIED_DATE! %%b>> %REPORT_PATH%
		choice /M:"File %%d with last modified date !LAST_MODIFIED_DATE! %%b, delete "
	) else if "!LAST_MODIFIED_YEAR!"=="%HOUSEKEEP_YEAR%" (
		if !LAST_MODIFIED_MONTH! LEQ %HOUSEKEEP_MONTH% (
			echo %%d>> %REPORT_PATH%
			echo Last modified date: !LAST_MODIFIED_DATE! %%b>> %REPORT_PATH%
			choice /M:"File %%d with last modified date !LAST_MODIFIED_DATE! %%b, delete " /D:N /T:20
		)
	)
	
	if "!errorlevel!"=="1" (
		del /F /Q %HOUSEKEEP_PATH%\%%d && echo %%d deleted && echo %%d deleted>> %REPORT_PATH%
	)
)

goto :fin

:fin
echo ==========================
echo Quit housekeep.bat program
echo ==========================
pause
endlocal
goto :eof

REM Subroutines called above
:format_number
for /f "tokens=* delims=0" %%i in ("%1") do set Var=%%i
if "%Var%"=="" set Var=0