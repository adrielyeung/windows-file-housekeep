@echo off
setlocal enabledelayedexpansion

set SCRIPT=housekeep.bat
set TEST_REPORT_FILE=test_housekeep_report.txt
set TEST_PATH=testing
set TEST_FILE=testing.txt
set REPORT_PATH=housekeep_list_report.txt
REM COUNT is the test number
set COUNT=0
REM CHECKPOINT_COUNT is the checkpoint number
set CHECKPOINT_COUNT=0

echo TESTING START AT %DATE% %TIME%
REM Set up
if not exist temp\ mkdir temp\
if not exist %TEST_PATH% mkdir %TEST_PATH%
echo Test report of script %SCRIPT% performed at %DATE% %TIME% > %TEST_REPORT_FILE%

:test1
call :start_test
REM Test 1 - Test invalid path, error message should appear
set INVALID_PATH=testing\invalid_folder
REM Ensure path is not available
if exist %INVALID_PATH% rmdir /S /Q %INVALID_PATH%

REM Test call script in separate window, redirect all stdout output to temp file
start cmd /c call %SCRIPT% %INVALID_PATH% ^> %TEMP_FILE%
REM Program running time
call :program_run_pause 6
REM Checkpoint 1 - Error message pop up
call :findstr_in_console "%INVALID_PATH% does not exist, please retry"
REM Checkpoint 2 - Redirect to input screen
call :findstr_in_console "Please input folder path for housekeeping: "

:test2
call :start_test
REM Test 2 - Test invalid housekeep time - no 'y' in string
set INVALID_TIME=22

REM Test call script in separate window, redirect all stdout output to temp file
start cmd /c call %SCRIPT% %TEST_PATH% %INVALID_TIME% ^> %TEMP_FILE%
REM Program running time
call :program_run_pause 20
REM Checkpoint 1 - Error message pop up
call :findstr_in_console "Time must contain exactly 1 'y'"
REM Checkpoints 2-4 - Redirect to input screen (with 3 lines to check)
call :findstr_in_console "Please enter time (year + month) on or before which we perform housekeep"
call :findstr_in_console "Use y to separate between year and month, e.g. 4y6, 0y2, 10y0 are acceptable"
call :findstr_in_console "Please input here: "

:test3
call :start_test
REM Test 3 - Test invalid housekeep time - 2 'y's in string
set INVALID_TIME=2y2y

REM Test call script in separate window, redirect all stdout output to temp file
start cmd /c call %SCRIPT% %TEST_PATH% %INVALID_TIME% ^> %TEMP_FILE%
REM Program running time
call :program_run_pause 20
REM Checkpoint 1 - Error message pop up
call :findstr_in_console "Time must contain exactly 1 'y'"
REM Checkpoints 2-4 - Redirect to input screen (with 3 lines to check)
call :findstr_in_console "Please enter time (year + month) on or before which we perform housekeep"
call :findstr_in_console "Use y to separate between year and month, e.g. 4y6, 0y2, 10y0 are acceptable"
call :findstr_in_console "Please input here: "

:test4
call :start_test
REM Test 4 - Test invalid housekeep time - only year is input
set INVALID_TIME=2y

REM Test call script in separate window, redirect all stdout output to temp file
start cmd /c call %SCRIPT% %TEST_PATH% %INVALID_TIME% ^> %TEMP_FILE%
REM Program running time
call :program_run_pause 20
REM Checkpoint 1 - Error message pop up
call :findstr_in_console "Please input number before and after 'y'"
REM Checkpoints 2-4 - Redirect to input screen (with 3 lines to check)
call :findstr_in_console "Please enter time (year + month) on or before which we perform housekeep"
call :findstr_in_console "Use y to separate between year and month, e.g. 4y6, 0y2, 10y0 are acceptable"
call :findstr_in_console "Please input here: "

:test5
call :start_test
REM Test 5 - Test invalid housekeep time - only month is input
set INVALID_TIME=y2

REM Test call script in separate window, redirect all stdout output to temp file
start cmd /c call %SCRIPT% %TEST_PATH% %INVALID_TIME% ^> %TEMP_FILE%
REM Program running time
call :program_run_pause 20
REM Checkpoint 1 - Error message pop up
call :findstr_in_console "Please input number before and after 'y'"
REM Checkpoints 2-4 - Redirect to input screen (with 3 lines to check)
call :findstr_in_console "Please enter time (year + month) on or before which we perform housekeep"
call :findstr_in_console "Use y to separate between year and month, e.g. 4y6, 0y2, 10y0 are acceptable"
call :findstr_in_console "Please input here: "

:test6
call :start_test
REM Test 6 - With non-numeric character in year
set INVALID_TIME=2#y2

REM Test call script in separate window, redirect all stdout output to temp file
start cmd /c call %SCRIPT% %TEST_PATH% %INVALID_TIME% ^> %TEMP_FILE%
REM Program running time
call :program_run_pause 20
REM Checkpoint 1 - Error message pop up
call :findstr_in_console "Incorrect format"
REM Checkpoints 2-4 - Redirect to input screen (with 3 lines to check)
call :findstr_in_console "Please enter time (year + month) on or before which we perform housekeep"
call :findstr_in_console "Use y to separate between year and month, e.g. 4y6, 0y2, 10y0 are acceptable"
call :findstr_in_console "Please input here: "

:test7
call :start_test
REM Test 7 - With non-numeric character in month
set INVALID_TIME=2y2@

REM Test call script in separate window, redirect all stdout output to temp file
start cmd /c call %SCRIPT% %TEST_PATH% %INVALID_TIME% ^> %TEMP_FILE%
REM Program running time
call :program_run_pause 20
REM Checkpoint 1 - Error message pop up
call :findstr_in_console "Incorrect format"
REM Checkpoints 2-4 - Redirect to input screen (with 3 lines to check)
call :findstr_in_console "Please enter time (year + month) on or before which we perform housekeep"
call :findstr_in_console "Use y to separate between year and month, e.g. 4y6, 0y2, 10y0 are acceptable"
call :findstr_in_console "Please input here: "

:test8
call :start_test
REM Test 8 - With housekeep year before 1900
set /A MAX_VALID_YEAR=%DATE:~6,4%-1900
set /A INVALID_YEAR=%DATE:~6,4%-1900+1
set INVALID_TIME=%INVALID_YEAR%y0

REM Test call script in separate window, redirect all stdout output to temp file
start cmd /c call %SCRIPT% %TEST_PATH% %INVALID_TIME% ^> %TEMP_FILE%
REM Program running time
call :program_run_pause 20
REM Checkpoint 1 - Error message pop up
call :findstr_in_console "Invalid year, max number of years before is %MAX_VALID_YEAR%"
REM Checkpoints 2-4 - Redirect to input screen (with 3 lines to check)
call :findstr_in_console "Please enter time (year + month) on or before which we perform housekeep"
call :findstr_in_console "Use y to separate between year and month, e.g. 4y6, 0y2, 10y0 are acceptable"
call :findstr_in_console "Please input here: "

:test9
call :start_test
REM Test 9 - With housekeep month greater than 11
set INVALID_TIME=1y12

REM Test call script in separate window, redirect all stdout output to temp file
start cmd /c call %SCRIPT% %TEST_PATH% %INVALID_TIME% ^> %TEMP_FILE%
REM Program running time
call :program_run_pause 20
REM Checkpoint 1 - Error message pop up
call :findstr_in_console "Invalid month, max number of months before is 11"
REM Checkpoints 2-4 - Redirect to input screen (with 3 lines to check)
call :findstr_in_console "Please enter time (year + month) on or before which we perform housekeep"
call :findstr_in_console "Use y to separate between year and month, e.g. 4y6, 0y2, 10y0 are acceptable"
call :findstr_in_console "Please input here: "

:test10
call :start_test
REM Test 10 - Test not delete file
set VALID_TIME=0y0
REM Set up testing folder and file
call :set_test_file

REM Test call script in separate window, redirect all stdout output to temp file
start cmd /c call %SCRIPT% %TEST_PATH% %VALID_TIME% ^> %TEMP_FILE%
REM Program running time
call :program_run_pause 50
REM Checkpoint 1 - Title in report file
call :findstr_in_report "Housekeep report for path %TEST_PATH% with files dated on or before %DATE:~3,2%/%DATE:~6,4%"
REM Checkpoints 2-4 - File name and modified time shown properly, not showing deleted
call :findstr_in_report "%TEST_FILE%"
call :findstr_in_report "Last modified date: %MODIFIED_DATE: =0% %MODIFIED_TIME: =0%"
call :findstr_in_report "%TEST_FILE% deleted" V
REM Checkpoint 5 - File is found
if exist %TEST_PATH%\%TEST_FILE% (call :write_report_console passed) else (call :write_report_console FAILED)

:test11
call :start_test
REM Test 11 - Test delete file
set VALID_TIME=0y0
REM Set up testing folder and file
call :set_test_file
REM Set up temp script for testing
powershell -Command "(gc %SCRIPT%) -replace '/D:N /T:20', '/D:Y /T:20' | Out-File -encoding ASCII test11_%SCRIPT%"

REM Test call script in separate window, redirect all stdout output to temp file
start cmd /c call test11_%SCRIPT% %TEST_PATH% %VALID_TIME% ^> %TEMP_FILE%
REM Program running time
call :program_run_pause 50
REM Checkpoint 1 - Title in report file
call :findstr_in_report "Housekeep report for path %TEST_PATH% with files dated on or before %DATE:~3,2%/%DATE:~6,4%"
REM Checkpoints 2-4 - File name and modified time shown properly, not showing deleted
call :findstr_in_report "%TEST_FILE%"
call :findstr_in_report "Last modified date: %MODIFIED_DATE: =0% %MODIFIED_TIME: =0%"
call :findstr_in_report "%TEST_FILE% deleted"
REM Checkpoint 5 - File is not found
if not exist %TEST_PATH%\%TEST_FILE% (call :write_report_console passed) else (call :write_report_console FAILED)
REM Delete temp script
del /F /Q test11_%SCRIPT%

:test12
call :start_test
REM Test 12 - Test no file to delete, all files after housekeep time
set VALID_TIME=0y1
set /A CHECK_MONTH=%DATE:~3,2%-1
if %CHECK_MONTH% LSS 0 (
	set /A CHECK_MONTH=%CHECK_MONTH%+12
	set /A CHECK_YEAR=%DATE:~6,4%-1
) else (set CHECK_YEAR=%DATE:~6,4%)
REM Set up testing folder and file
call :set_test_file

REM Test call script in separate window, redirect all stdout output to temp file
start cmd /c call %SCRIPT% %TEST_PATH% %VALID_TIME% ^> %TEMP_FILE%
REM Program running time
call :program_run_pause 50
REM Checkpoint 1 - Title in report file
call :findstr_in_report "Housekeep report for path %TEST_PATH% with files dated on or before %CHECK_MONTH%/%CHECK_YEAR%"
REM Checkpoints 2-4 - File name and modified time shown properly, not showing deleted
call :findstr_in_report "%TEST_FILE%" V
call :findstr_in_report "Last modified date: %MODIFIED_DATE: =0% %MODIFIED_TIME: =0%" V
call :findstr_in_report "%TEST_FILE% deleted" V
REM Checkpoint 5 - File is found
if exist %TEST_PATH%\%TEST_FILE% (call :write_report_console passed) else (call :write_report_console FAILED)

:end
echo ===========================
echo TESTING END AT %DATE% %TIME%, report at %cd%\%TEST_REPORT_FILE%
pause
endlocal
goto :eof

REM Commands which need to be run before starting each test
:start_test
set /A COUNT+=1
REM At start of each test, reset checkpoint number to 0
set CHECKPOINT_COUNT=0
set TEMP_FILE=temp\test_temp_%COUNT%.txt
echo. > %TEMP_FILE%
echo ===========================
echo ===========================>> %TEST_REPORT_FILE%
echo Test %COUNT% start
goto :eof

:set_test_file
if not exist %TEST_PATH% mkdir %TEST_PATH%
echo .> %TEST_PATH%\%TEST_FILE% & set MODIFIED_DATE=%DATE:~0,10%& set MODIFIED_TIME=%TIME:~0,5%
goto :eof

:program_run_pause
echo Program running time for test %COUNT%
timeout /nobreak %1
goto :eof

:findstr_in_console
findstr /C:"%~1" %TEMP_FILE% > nul && call :write_report_console passed || call :write_report_console FAILED
goto :eof

:findstr_in_report
REM Call with %1 = string to search, %2 = V for fail on match
if "%2"=="V" (
	findstr /C:"%~1" %REPORT_PATH% > nul && call :write_report_console FAILED || call :write_report_console passed
) else (
	findstr /C:"%~1" %REPORT_PATH% > nul && call :write_report_console passed || call :write_report_console FAILED
)
goto :eof

:write_report_console
set /A CHECKPOINT_COUNT+=1
echo Test %COUNT% Checkpoint %CHECKPOINT_COUNT% %1 >> %TEST_REPORT_FILE% & echo Test %COUNT% Checkpoint %CHECKPOINT_COUNT% %1
goto :eof
