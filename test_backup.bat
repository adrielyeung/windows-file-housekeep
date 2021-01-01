@echo off
setlocal enabledelayedexpansion

set SCRIPT=backup_compare_hash.ps1
set TEST_REPORT_FILE=test_backup_report.txt
set TEST_PATH=testing
set TEST_FILE=testing.txt
set TEST_SUB1=sub1
set TEST_SUB1_FILE=sub1.txt
set TEST_SUB2=sub1\sub2
set TEST_SUB2_FILE=sub2.txt
set REPORT_PATH=backup_list_report.txt
REM COUNT is the test number
set COUNT=0
REM CHECKPOINT_COUNT is the checkpoint number
set CHECKPOINT_COUNT=0

echo TESTING START AT %DATE% %TIME%
REM Set up
if not exist temp\ mkdir temp\
if exist %TEST_PATH% rmdir /s /q %TEST_PATH%
mkdir %TEST_PATH%
echo Test report of script %SCRIPT% performed at %DATE% %TIME% > %TEST_REPORT_FILE%

:test1
call :start_test
REM Test 1 - Backup folder with 1 file, no subdirectories
REM Set up testing folder and file
call :set_test_file 0

REM Test call script in separate window, redirect all stdout output to temp file
start cmd /c powershell -File %SCRIPT% %TEST_PATH% ^> %TEMP_FILE%
REM Program running time
call :program_run_pause 3
REM Checkpoint 1 - Hash match after backup
call :findstr_in_console "Hashes of original folder and backup matches"
REM Checkpoint 2 - Redirect to input screen
call :findstr_in_console "Backup completed"
REM Checkpoint 3 - File is in backup folder
if exist %TEST_PATH%_bk_%date:~6,4%%date:~3,2%%date:~0,2%\%TEST_FILE% (call :write_report_console passed) else (call :write_report_console FAILED)

:test2
call :start_test
REM Test 2 - Backup folder with 1 file + 1 subdirectory with 1 file + NOT backup subdirectories
REM Set up testing folder and file
call :set_test_file 1

REM Test call script in separate window, redirect all stdout output to temp file
start cmd /c powershell -File %SCRIPT% %TEST_PATH% N ^> %TEMP_FILE%
REM Program running time
call :program_run_pause 3
REM Checkpoint 1 - Hash match after backup
call :findstr_in_console "Hashes of original folder and backup matches"
REM Checkpoint 2 - Redirect to input screen
call :findstr_in_console "Backup completed"
REM Checkpoint 3 - File is in backup folder
if exist %TEST_PATH%_bk_%date:~6,4%%date:~3,2%%date:~0,2%\%TEST_FILE% (call :write_report_console passed) else (call :write_report_console FAILED)
REM Checkpoint 4 - Subdir file is not in backup folder
if not exist %TEST_PATH%_bk_%date:~6,4%%date:~3,2%%date:~0,2%\%TEST_SUB1%\%TEST_SUB1_FILE% (call :write_report_console passed) else (call :write_report_console FAILED)

:test3
call :start_test
REM Test 3 - Backup folder with 1 file + 1 subdirectory with 1 file + backup subdirectories
REM Set up testing folder and file
call :set_test_file 1

REM Test call script in separate window, redirect all stdout output to temp file
start cmd /c powershell -File %SCRIPT% %TEST_PATH% Y ^> %TEMP_FILE%
REM Program running time
call :program_run_pause 3
REM Checkpoint 1 - Hash match after backup
call :findstr_in_console "Hashes of original folder and backup matches"
REM Checkpoint 2 - Redirect to input screen
call :findstr_in_console "Backup completed"
REM Checkpoint 3 - File is in backup folder
if exist %TEST_PATH%_bk_%date:~6,4%%date:~3,2%%date:~0,2%\%TEST_FILE% (call :write_report_console passed) else (call :write_report_console FAILED)
REM Checkpoint 4 - Subdir file is not in backup folder
if exist %TEST_PATH%_bk_%date:~6,4%%date:~3,2%%date:~0,2%\%TEST_SUB1%\%TEST_SUB1_FILE% (call :write_report_console passed) else (call :write_report_console FAILED)

:test4
call :start_test
REM Test 4 - Backup folder with 1 file + 1 subdirectory with 1 file + 1 subsubdirectory with 1 file + NOT backup subdirectories
REM Set up testing folder and file
call :set_test_file 2

REM Test call script in separate window, redirect all stdout output to temp file
start cmd /c powershell -File %SCRIPT% %TEST_PATH% N ^> %TEMP_FILE%
REM Program running time
call :program_run_pause 3
REM Checkpoint 1 - Hash match after backup
call :findstr_in_console "Hashes of original folder and backup matches"
REM Checkpoint 2 - Redirect to input screen
call :findstr_in_console "Backup completed"
REM Checkpoint 3 - File is in backup folder
if exist %TEST_PATH%_bk_%date:~6,4%%date:~3,2%%date:~0,2%\%TEST_FILE% (call :write_report_console passed) else (call :write_report_console FAILED)
REM Checkpoint 4 - Subdir file is not in backup folder
if not exist %TEST_PATH%_bk_%date:~6,4%%date:~3,2%%date:~0,2%\%TEST_SUB1%\%TEST_SUB1_FILE% (call :write_report_console passed) else (call :write_report_console FAILED)
REM Checkpoint 5 - Subsubdir file is not in backup folder
if not exist %TEST_PATH%_bk_%date:~6,4%%date:~3,2%%date:~0,2%\%TEST_SUB2%\%TEST_SUB2_FILE% (call :write_report_console passed) else (call :write_report_console FAILED)

:test5
call :start_test
REM Test 5 - Backup folder with 1 file + 1 subdirectory with 1 file + 1 subsubdirectory with 1 file + backup subdirectories
REM Set up testing folder and file
call :set_test_file 2

REM Test call script in separate window, redirect all stdout output to temp file
start cmd /c powershell -File %SCRIPT% %TEST_PATH% Y ^> %TEMP_FILE%
REM Program running time
call :program_run_pause 3
REM Checkpoint 1 - Hash match after backup
call :findstr_in_console "Hashes of original folder and backup matches"
REM Checkpoint 2 - Redirect to input screen
call :findstr_in_console "Backup completed"
REM Checkpoint 3 - File is in backup folder
if exist %TEST_PATH%_bk_%date:~6,4%%date:~3,2%%date:~0,2%\%TEST_FILE% (call :write_report_console passed) else (call :write_report_console FAILED)
REM Checkpoint 4 - Subdir file is not in backup folder
if exist %TEST_PATH%_bk_%date:~6,4%%date:~3,2%%date:~0,2%\%TEST_SUB1%\%TEST_SUB1_FILE% (call :write_report_console passed) else (call :write_report_console FAILED)
REM Checkpoint 5 - Subsubdir file is not in backup folder
if exist %TEST_PATH%_bk_%date:~6,4%%date:~3,2%%date:~0,2%\%TEST_SUB2%\%TEST_SUB2_FILE% (call :write_report_console passed) else (call :write_report_console FAILED)

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
echo. > %TEST_PATH%\%TEST_FILE%
REM Set up subdirectories
if "%1"=="1" (
	if not exist %TEST_PATH%\%TEST_SUB1% mkdir %TEST_PATH%\%TEST_SUB1%
	echo .> %TEST_PATH%\%TEST_SUB1%\%TEST_SUB1_FILE%
)
if "%1"=="2" (
	if not exist %TEST_PATH%\%TEST_SUB1% mkdir %TEST_PATH%\%TEST_SUB1%
	echo .> %TEST_PATH%\%TEST_SUB1%\%TEST_SUB1_FILE%
	if not exist %TEST_PATH%\%TEST_SUB2% mkdir %TEST_PATH%\%TEST_SUB2%
	echo .> %TEST_PATH%\%TEST_SUB2%\%TEST_SUB2_FILE%
)
REM Delete backup subdirectories from previous tests
for /f %%a in ('dir /a:d /b .\testing_bk_*') do rmdir /q /s .\%%a
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
