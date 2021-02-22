@echo off
setlocal enabledelayedexpansion

set SCRIPT=housekeep.bat
set TEST_REPORT_FILE=test_housekeep_report.txt
set TEST_PATH=testing
set TEST_FILE=testing.txt
set TEST_SUBDIR_PATH=%TEST_PATH%\subdir
set TEST_SUBDIR_FILE=testing_subdir.txt
set REPORT_PATH=housekeep_list_report.txt
set TEMP_PATH=test_temp
set TEMP_REPORT_NAME=housekeep_list_report_
REM COUNT is the test number
set COUNT=0
REM CHECKPOINT_COUNT is the checkpoint number
set CHECKPOINT_COUNT=0

echo TESTING START AT %DATE% %TIME%
REM Set up
if not exist %TEMP_PATH% mkdir %TEMP_PATH%
del /F /Q %TEMP_PATH%
if not exist %TEST_PATH% mkdir %TEST_PATH%
echo Test report of script %SCRIPT% performed at %DATE% %TIME% > %TEST_REPORT_FILE%

REM Invalid path test
:test1
call :start_test
REM Test 1 - Test invalid path, error message should appear
set INVALID_PATH=testing\invalid_folder
REM Ensure path is not available
if exist %INVALID_PATH% rmdir /S /Q %INVALID_PATH%

REM Test call script in separate window, redirect all stdout output to temp file
start cmd /c "call %SCRIPT% %INVALID_PATH%"^> %TEMP_FILE%
REM Program running time
call :program_run_pause 7
REM Checkpoint 1 - Error message pop up
call :findstr_in_console "%INVALID_PATH% does not exist, please retry"
REM Checkpoint 2 - Redirect to input screen
call :findstr_in_console "Please input folder path for housekeeping: "
call :end_test

REM Invalid housekeep time
:test2
call :start_test
REM Test 2 - Test invalid housekeep time - no 'y' in string
set INVALID_TIME=22

REM Test call script in separate window, redirect all stdout output to temp file
start cmd /c "echo Y0y0|call %SCRIPT% %TEST_PATH% %INVALID_TIME%"^> %TEMP_FILE%
REM Program running time
call :program_run_pause 7
REM Checkpoint 1 - Error message pop up
call :findstr_in_console "Time must contain exactly 1 'y'"
REM Checkpoints 2-4 - Redirect to input screen (with 3 lines to check)
call :findstr_in_console "Please enter time (year + month) on or before which we perform housekeep"
call :findstr_in_console "Use y to separate between year and month, e.g. 4y6, 0y2, 10y0 are acceptable"
call :findstr_in_console "Please input here: "
call :end_test

:test3
call :start_test
REM Test 3 - Test invalid housekeep time - 2 'y's in string
set INVALID_TIME=2y2y

REM Test call script in separate window, redirect all stdout output to temp file
start cmd /c "echo Y0y0|call %SCRIPT% %TEST_PATH% %INVALID_TIME%"^> %TEMP_FILE%
REM Program running time
call :program_run_pause 7
REM Checkpoint 1 - Error message pop up
call :findstr_in_console "Time must contain exactly 1 'y'"
REM Checkpoints 2-4 - Redirect to input screen (with 3 lines to check)
call :findstr_in_console "Please enter time (year + month) on or before which we perform housekeep"
call :findstr_in_console "Use y to separate between year and month, e.g. 4y6, 0y2, 10y0 are acceptable"
call :findstr_in_console "Please input here: "
call :end_test

:test4
call :start_test
REM Test 4 - Test invalid housekeep time - only year is input
set INVALID_TIME=2y

REM Test call script in separate window, redirect all stdout output to temp file
start cmd /c "echo Y0y0|call %SCRIPT% %TEST_PATH% %INVALID_TIME%"^> %TEMP_FILE%
REM Program running time
call :program_run_pause 7
REM Checkpoint 1 - Error message pop up
call :findstr_in_console "Please input number before and after 'y'"
REM Checkpoints 2-4 - Redirect to input screen (with 3 lines to check)
call :findstr_in_console "Please enter time (year + month) on or before which we perform housekeep"
call :findstr_in_console "Use y to separate between year and month, e.g. 4y6, 0y2, 10y0 are acceptable"
call :findstr_in_console "Please input here: "
call :end_test

:test5
call :start_test
REM Test 5 - Test invalid housekeep time - only month is input
set INVALID_TIME=y2

REM Test call script in separate window, redirect all stdout output to temp file
start cmd /c "echo Y0y0|call %SCRIPT% %TEST_PATH% %INVALID_TIME%"^> %TEMP_FILE%
REM Program running time
call :program_run_pause 7
REM Checkpoint 1 - Error message pop up
call :findstr_in_console "Please input number before and after 'y'"
REM Checkpoints 2-4 - Redirect to input screen (with 3 lines to check)
call :findstr_in_console "Please enter time (year + month) on or before which we perform housekeep"
call :findstr_in_console "Use y to separate between year and month, e.g. 4y6, 0y2, 10y0 are acceptable"
call :findstr_in_console "Please input here: "
call :end_test

:test6
call :start_test
REM Test 6 - With non-numeric character in year
set INVALID_TIME=2#y2

REM Test call script in separate window, redirect all stdout output to temp file
start cmd /c "echo Y0y0|call %SCRIPT% %TEST_PATH% %INVALID_TIME%"^> %TEMP_FILE%
REM Program running time
call :program_run_pause 7
REM Checkpoint 1 - Error message pop up
call :findstr_in_console "Incorrect format"
REM Checkpoints 2-4 - Redirect to input screen (with 3 lines to check)
call :findstr_in_console "Please enter time (year + month) on or before which we perform housekeep"
call :findstr_in_console "Use y to separate between year and month, e.g. 4y6, 0y2, 10y0 are acceptable"
call :findstr_in_console "Please input here: "
call :end_test

:test7
call :start_test
REM Test 7 - With non-numeric character in month
set INVALID_TIME=2y2@

REM Test call script in separate window, redirect all stdout output to temp file
start cmd /c "echo Y0y0|call %SCRIPT% %TEST_PATH% %INVALID_TIME%"^> %TEMP_FILE%
REM Program running time
call :program_run_pause 7
REM Checkpoint 1 - Error message pop up
call :findstr_in_console "Incorrect format"
REM Checkpoints 2-4 - Redirect to input screen (with 3 lines to check)
call :findstr_in_console "Please enter time (year + month) on or before which we perform housekeep"
call :findstr_in_console "Use y to separate between year and month, e.g. 4y6, 0y2, 10y0 are acceptable"
call :findstr_in_console "Please input here: "
call :end_test

:test8
call :start_test
REM Test 8 - With housekeep year before 1900
set /A MAX_VALID_YEAR=%DATE:~6,4%-1900
set /A INVALID_YEAR=%DATE:~6,4%-1900+1
set INVALID_TIME=%INVALID_YEAR%y0

REM Test call script in separate window, redirect all stdout output to temp file
start cmd /c "echo Y0y0|call %SCRIPT% %TEST_PATH% %INVALID_TIME%"^> %TEMP_FILE%
REM Program running time
call :program_run_pause 7
REM Checkpoint 1 - Error message pop up
call :findstr_in_console "Invalid year, max number of years before is %MAX_VALID_YEAR%"
REM Checkpoints 2-4 - Redirect to input screen (with 3 lines to check)
call :findstr_in_console "Please enter time (year + month) on or before which we perform housekeep"
call :findstr_in_console "Use y to separate between year and month, e.g. 4y6, 0y2, 10y0 are acceptable"
call :findstr_in_console "Please input here: "
call :end_test

:test9
call :start_test
REM Test 9 - With housekeep month greater than 11
set INVALID_TIME=1y12

REM Test call script in separate window, redirect all stdout output to temp file
start cmd /c "echo Y0y0|call %SCRIPT% %TEST_PATH% %INVALID_TIME%"^> %TEMP_FILE%
REM Program running time
call :program_run_pause 7
REM Checkpoint 1 - Error message pop up
call :findstr_in_console "Invalid month, max number of months before is 11"
REM Checkpoints 2-4 - Redirect to input screen (with 3 lines to check)
call :findstr_in_console "Please enter time (year + month) on or before which we perform housekeep"
call :findstr_in_console "Use y to separate between year and month, e.g. 4y6, 0y2, 10y0 are acceptable"
call :findstr_in_console "Please input here: "
call :end_test

REM Simple file deletion
:test10
call :start_test
REM Test 10 - Test not delete / recycle file
set VALID_TIME=0y0
set MONTH=%DATE:~3,2%
REM Set up testing folder and file
call :set_test_file

REM Test call script in separate window, redirect all stdout output to temp file
start cmd /c "echo YYNNN|call %SCRIPT% %TEST_PATH% %VALID_TIME%"^> %TEMP_FILE%
REM Program running time
call :program_run_pause 7
REM Checkpoint 1 - Title in report file
call :findstr_in_report "Housekeep report for path %TEST_PATH% with files dated on or before %MONTH:0=%/%DATE:~6,4%"
REM Checkpoints 2-5 - File name and modified time shown properly, not showing deleted
call :findstr_in_report "%TEST_FILE%"
call :findstr_in_report "Last modified date: %MODIFIED_DATE: =0% %MODIFIED_TIME: =0%"
call :findstr_in_report "%TEST_FILE% deleted" V
call :findstr_in_report "%TEST_FILE% recycled" V
REM Checkpoint 6 - File is found
if exist %TEST_PATH%\%TEST_FILE% (call :write_report_console passed) else (call :write_report_console FAILED)
call :end_test

:test11
call :start_test
REM Test 11 - Test delete file
set VALID_TIME=0y0
set MONTH=%DATE:~3,2%
REM Set up testing folder and file
call :set_test_file

REM Test call script in separate window, redirect all stdout output to temp file
start cmd /c "echo YYYNN|call %SCRIPT% %TEST_PATH% %VALID_TIME%"^> %TEMP_FILE%
REM Program running time
call :program_run_pause 7
REM Checkpoint 1 - Title in report file
call :findstr_in_report "Housekeep report for path %TEST_PATH% with files dated on or before %MONTH:0=%/%DATE:~6,4%"
REM Checkpoints 2-4 - File name and modified time shown properly, not showing deleted
call :findstr_in_report "%TEST_FILE%"
call :findstr_in_report "Last modified date: %MODIFIED_DATE: =0% %MODIFIED_TIME: =0%"
call :findstr_in_report "%TEST_FILE% deleted"
REM Checkpoint 5 - File is not found
if not exist %TEST_PATH%\%TEST_FILE% (call :write_report_console passed) else (call :write_report_console FAILED)
call :end_test

:test12
call :start_test
REM Test 12 - Test no file to delete / recycle, all files are after housekeep time
set VALID_TIME=0y1
set /A CHECK_MONTH=%DATE:~3,2%-1
if %CHECK_MONTH% LEQ 0 (
	set /A CHECK_MONTH=%CHECK_MONTH%+12
	set /A CHECK_YEAR=%DATE:~6,4%-1
) else (set CHECK_YEAR=%DATE:~6,4%)
REM Set up testing folder and file
call :set_test_file

REM Test call script in separate window, redirect all stdout output to temp file
start cmd /c "echo YYNN|call %SCRIPT% %TEST_PATH% %VALID_TIME%"^> %TEMP_FILE%
REM Program running time
call :program_run_pause 7
REM Checkpoint 1 - Title in report file
call :findstr_in_report "Housekeep report for path %TEST_PATH% with files dated on or before %CHECK_MONTH%/%CHECK_YEAR%"
REM Checkpoints 2-5 - File name and modified time shown properly, not showing deleted
call :findstr_in_report "%TEST_FILE%" V
call :findstr_in_report "Last modified date: %MODIFIED_DATE: =0% %MODIFIED_TIME: =0%" V
call :findstr_in_report "%TEST_FILE% deleted" V
call :findstr_in_report "%TEST_FILE% recycled" V
REM Checkpoint 6 - File is found
if exist %TEST_PATH%\%TEST_FILE% (call :write_report_console passed) else (call :write_report_console FAILED)
call :end_test

REM Injection test
:test13
call :start_test
REM Test 13 - Test injection path, error message should appear
set INJECTION_PATH=testing\&injection

mkdir %INJECTION_PATH%
REM Test call script in separate window, redirect all stdout output to temp file
start cmd /c call %SCRIPT% "%INJECTION_PATH%"^> %TEMP_FILE%
REM Program running time
call :program_run_pause 7
REM Checkpoint 1 - Error message pop up
call :findstr_in_console "which affect command line running"
REM Checkpoint 2 - Redirect to input screen
call :findstr_in_console "Please input folder path for housekeeping: "
call :end_test

:test14
call :start_test
REM Test 14 - Test injection in housekeep time
set INJECTION_TIME=2y\&2
REM Set up temp script for testing (this is required since echo Y cannot work for below)
powershell -Command "(gc %SCRIPT%) -replace 'choice /M:Confirm ', 'choice /M:Confirm  /D:Y /T:1' | Out-File -encoding ASCII test14_%SCRIPT%"

REM Test call script in separate window, redirect all stdout output to temp file
start cmd /c call test14_%SCRIPT% %TEST_PATH% "%INJECTION_TIME%"^> %TEMP_FILE%
REM Program running time
call :program_run_pause 10
REM Checkpoint 1 - Error message pop up
call :findstr_in_console "which affect command line running"
REM Checkpoints 2-4 - Redirect to input screen (with 3 lines to check)
call :findstr_in_console "Please enter time (year + month) on or before which we perform housekeep"
call :findstr_in_console "Use y to separate between year and month, e.g. 4y6, 0y2, 10y0 are acceptable"
call :findstr_in_console "Please input here: "
call :end_test
REM Delete temp script
del /F /Q test14_%SCRIPT%

:test15
call :start_test
REM Test 15 - Test no file in directory
set VALID_TIME=0y0
set MONTH=%DATE:~3,2%
REM Ensure no file in test directory
if not exist %TEST_PATH% mkdir %TEST_PATH%
del /F /Q %TEST_PATH%\*.*

REM Test call script in separate window, redirect all stdout output to temp file
start cmd /c "echo YYNN|call %SCRIPT% %TEST_PATH% %VALID_TIME%"^> %TEMP_FILE%
REM Program running time
call :program_run_pause 7
REM Checkpoint 1 - Title in report file
call :findstr_in_report "Housekeep report for path %TEST_PATH% with files dated on or before %MONTH:0=%/%DATE:~6,4%"
REM Checkpoints 2-5 - File name and modified time shown properly, not showing deleted
call :findstr_in_report "%TEST_FILE%" V
call :findstr_in_report "Last modified date: %MODIFIED_DATE: =0% %MODIFIED_TIME: =0%" V
call :findstr_in_report "%TEST_FILE% deleted" V
call :findstr_in_report "%TEST_FILE% recycled" V
call :end_test

REM Subdirectory file removal
:test16
call :start_test
REM Test 16 - Test with subfolder, not delete / recycle file in subdirectory
set VALID_TIME=0y0
set MONTH=%DATE:~3,2%
REM Set up testing folder and file
call :set_test_file
call :set_subdir_test_file

REM Test call script in separate window, redirect all stdout output to temp file
start cmd /c "echo YYYYNN|call %SCRIPT% %TEST_PATH% %VALID_TIME%"^> %TEMP_FILE%
REM Program running time
call :program_run_pause 7
REM Checkpoint 1 - Title in report file
call :findstr_in_report "Housekeep report for path %TEST_PATH% with files dated on or before %MONTH:0=%/%DATE:~6,4%"
REM Checkpoints 2-4 - For file in dir, file name and modified time shown properly, showing deleted
call :findstr_in_report "%TEST_FILE%"
call :findstr_in_report "Last modified date: %MODIFIED_DATE: =0% %MODIFIED_TIME: =0%"
call :findstr_in_report "%TEST_FILE% deleted"
REM Checkpoints 5-8 - For file in subdir, file name and modified time shown properly, not showing deleted
call :findstr_in_report "%TEST_SUBDIR_FILE%"
call :findstr_in_report "Last modified date: %SUBDIR_MODIFIED_DATE: =0% %SUBDIR_MODIFIED_TIME: =0%"
call :findstr_in_report "%TEST_SUBDIR_FILE% deleted" V
call :findstr_in_report "%TEST_SUBDIR_FILE% recycled" V
REM Checkpoint 9 - File in dir is not found
if exist %TEST_PATH%\%TEST_FILE% (call :write_report_console FAILED) else (call :write_report_console passed)
REM Checkpoint 10 - File in subdir is found
if exist %TEST_SUBDIR_PATH%\%TEST_SUBDIR_FILE% (call :write_report_console passed) else (call :write_report_console FAILED)
call :end_test

:test17
call :start_test
REM Test 17 - Test with subfolder, delete file in subdirectory
set VALID_TIME=0y0
set MONTH=%DATE:~3,2%
REM Set up testing folder and file
call :set_test_file
call :set_subdir_test_file

REM Test call script in separate window, redirect all stdout output to temp file
start cmd /c "echo YYYYYN|call %SCRIPT% %TEST_PATH% %VALID_TIME%"^> %TEMP_FILE%
REM Program running time
call :program_run_pause 7
REM Checkpoint 1 - Title in report file
call :findstr_in_report "Housekeep report for path %TEST_PATH% with files dated on or before %MONTH:0=%/%DATE:~6,4%"
REM Checkpoints 2-4 - For file in dir, file name and modified time shown properly, showing deleted
call :findstr_in_report "%TEST_FILE%"
call :findstr_in_report "Last modified date: %MODIFIED_DATE: =0% %MODIFIED_TIME: =0%"
call :findstr_in_report "%TEST_FILE% deleted"
REM Checkpoints 5-7 - For file in subdir, file name and modified time shown properly, showing deleted
call :findstr_in_report "%TEST_SUBDIR_FILE%"
call :findstr_in_report "Last modified date: %SUBDIR_MODIFIED_DATE: =0% %SUBDIR_MODIFIED_TIME: =0%"
call :findstr_in_report "%TEST_SUBDIR_FILE% deleted"
REM Checkpoint 8 - File in dir is not found
if exist %TEST_PATH%\%TEST_FILE% (call :write_report_console FAILED) else (call :write_report_console passed)
REM Checkpoint 9 - File in subdir is not found
if exist %TEST_SUBDIR_PATH%\%TEST_SUBDIR_FILE% (call :write_report_console FAILED) else (call :write_report_console passed)
call :end_test

:test18
call :start_test
REM Test 18 - Test with subfolder with no file
set VALID_TIME=0y0
set MONTH=%DATE:~3,2%
REM Set up testing folder and file
call :set_test_file
if not exist %TEST_SUBDIR_PATH% mkdir %TEST_SUBDIR_PATH%
del /F /Q %TEST_SUBDIR_PATH%\*.*

REM Test call script in separate window, redirect all stdout output to temp file
start cmd /c "echo YYYYN|call %SCRIPT% %TEST_PATH% %VALID_TIME%"^> %TEMP_FILE%
REM Program running time
call :program_run_pause 7
REM Checkpoint 1 - Title in report file
call :findstr_in_report "Housekeep report for path %TEST_PATH% with files dated on or before %MONTH:0=%/%DATE:~6,4%"
REM Checkpoints 2-3 - For file in dir, file name and modified time shown properly, showing deleted
call :findstr_in_report "%TEST_FILE%"
call :findstr_in_report "%TEST_FILE% deleted"
REM Checkpoints 4-6 - For file in subdir, file name and modified time not shown
call :findstr_in_report "%TEST_SUBDIR_FILE%" V
call :findstr_in_report "%TEST_SUBDIR_FILE% deleted" V
call :findstr_in_report "%TEST_SUBDIR_FILE% recycled" V
REM Checkpoint 7 - File in subdir is not found
if exist %TEST_PATH%\%TEST_FILE% (call :write_report_console FAILED) else (call :write_report_console passed)
call :end_test

:test19
call :start_test
REM Test 19 - Test with subfolder, not go through subfolder, file not deleted
set VALID_TIME=0y0
set MONTH=%DATE:~3,2%
REM Set up testing folder and file
call :set_test_file
call :set_subdir_test_file

REM Test call script in separate window, redirect all stdout output to temp file
start cmd /c "echo YYYNN|call %SCRIPT% %TEST_PATH% %VALID_TIME%"^> %TEMP_FILE%
REM Program running time
call :program_run_pause 7
REM Checkpoint 1 - Title in report file
call :findstr_in_report "Housekeep report for path %TEST_PATH% with files dated on or before %MONTH:0=%/%DATE:~6,4%"
REM Checkpoints 2-3 - For file in dir, file name and modified time shown properly, showing deleted
call :findstr_in_report "%TEST_FILE%"
call :findstr_in_report "%TEST_FILE% deleted"
REM Checkpoints 4-6 - For file in subdir, file name and modified time not shown
call :findstr_in_report "%TEST_SUBDIR_FILE%" V
call :findstr_in_report "%TEST_SUBDIR_FILE% deleted" V
call :findstr_in_report "%TEST_SUBDIR_FILE% recycled" V
REM Checkpoint 7 - File in dir is not found
if exist %TEST_PATH%\%TEST_FILE% (call :write_report_console FAILED) else (call :write_report_console passed)
REM Checkpoint 8 - File in subdir is found
if exist %TEST_SUBDIR_PATH%\%TEST_SUBDIR_FILE% (call :write_report_console passed) else (call :write_report_console FAILED)
call :end_test

REM Subdirectory folder removal
:test20
call :start_test
REM Test 20 - Test with empty subfolder, deleted
set VALID_TIME=0y0
set MONTH=%DATE:~3,2%
REM Set up testing folder and file
call :set_test_file
call :set_subdir_test_file

REM Test call script in separate window, redirect all stdout output to temp file
start cmd /c "echo YYYYYY|call %SCRIPT% %TEST_PATH% %VALID_TIME%"^> %TEMP_FILE%
REM Program running time
call :program_run_pause 7
REM Checkpoint 1 - Title in report file
call :findstr_in_report "Housekeep report for path %TEST_PATH% with files dated on or before %MONTH:0=%/%DATE:~6,4%"
REM Checkpoints 2-3 - For file in dir, file name and modified time shown properly, showing deleted
call :findstr_in_report "%TEST_FILE%"
call :findstr_in_report "%TEST_FILE% deleted"
REM Checkpoints 4-5 - For file in subdir, file name and modified time shown properly, showing deleted
call :findstr_in_report "%TEST_SUBDIR_FILE%"
call :findstr_in_report "%TEST_SUBDIR_FILE% deleted"
REM Checkpoint 6 - File in dir is not found
if exist %TEST_PATH%\%TEST_FILE% (call :write_report_console FAILED) else (call :write_report_console passed)
REM Checkpoint 7 - File in subdir is not found
if exist %TEST_SUBDIR_PATH%\%TEST_SUBDIR_FILE% (call :write_report_console FAILED) else (call :write_report_console passed)
REM Checkpoint 8 - Subdirectory subdir is removed
if exist %TEST_SUBDIR_PATH% (call :write_report_console FAILED) else (call :write_report_console passed)
call :end_test

:test21
call :start_test
REM Test 21 - Test with empty subfolder, not deleted
set VALID_TIME=0y0
set MONTH=%DATE:~3,2%
REM Set up testing folder and file
call :set_test_file
call :set_subdir_test_file

REM Test call script in separate window, redirect all stdout output to temp file
start cmd /c "echo YYYYYN|call %SCRIPT% %TEST_PATH% %VALID_TIME%"^> %TEMP_FILE%
REM Program running time
call :program_run_pause 7
REM Checkpoint 1 - Title in report file
call :findstr_in_report "Housekeep report for path %TEST_PATH% with files dated on or before %MONTH:0=%/%DATE:~6,4%"
REM Checkpoints 2-3 - For file in dir, file name and modified time shown properly, showing deleted
call :findstr_in_report "%TEST_FILE%"
call :findstr_in_report "%TEST_FILE% deleted"
REM Checkpoints 4-5 - For file in subdir, file name and modified time shown properly, showing deleted
call :findstr_in_report "%TEST_SUBDIR_FILE%"
call :findstr_in_report "%TEST_SUBDIR_FILE% deleted"
REM Checkpoint 6 - File in dir is not found
if exist %TEST_PATH%\%TEST_FILE% (call :write_report_console FAILED) else (call :write_report_console passed)
REM Checkpoint 7 - File in subdir is not found
if exist %TEST_SUBDIR_PATH%\%TEST_SUBDIR_FILE% (call :write_report_console FAILED) else (call :write_report_console passed)
REM Checkpoint 8 - Subdirectory subdir is not removed
if exist %TEST_SUBDIR_PATH% (call :write_report_console passed) else (call :write_report_console FAILED)
call :end_test

:test22
call :start_test
REM Test 22 - Test with not empty subfolder, not removed
set VALID_TIME=0y0
set MONTH=%DATE:~3,2%
REM Set up testing folder and file
call :set_test_file
call :set_subdir_test_file

REM Test call script in separate window, redirect all stdout output to temp file
start cmd /c "echo YYYYNY|call %SCRIPT% %TEST_PATH% %VALID_TIME%"^> %TEMP_FILE%
REM Program running time
call :program_run_pause 7
REM Checkpoint 1 - Title in report file
call :findstr_in_report "Housekeep report for path %TEST_PATH% with files dated on or before %MONTH:0=%/%DATE:~6,4%"
REM Checkpoints 2-3 - For file in dir, file name and modified time shown properly, showing deleted
call :findstr_in_report "%TEST_FILE%"
call :findstr_in_report "%TEST_FILE% deleted"
REM Checkpoints 4-6 - For file in subdir, file name and modified time shown properly, showing not deleted
call :findstr_in_report "%TEST_SUBDIR_FILE%"
call :findstr_in_report "%TEST_SUBDIR_FILE% deleted" V
call :findstr_in_report "%TEST_SUBDIR_FILE% recycled" V
REM Checkpoint 7 - File in dir is not found
if exist %TEST_PATH%\%TEST_FILE% (call :write_report_console FAILED) else (call :write_report_console passed)
REM Checkpoint 8 - File in subdir is found
if exist %TEST_SUBDIR_PATH%\%TEST_SUBDIR_FILE% (call :write_report_console passed) else (call :write_report_console FAILED)
REM Checkpoint 9 - Subdirectory subdir is not removed
if exist %TEST_SUBDIR_PATH% (call :write_report_console passed) else (call :write_report_console FAILED)
call :end_test

REM Simple file recycling
:test23
call :start_test
REM Test 23 - Test recycle file
set VALID_TIME=0y0
set MONTH=%DATE:~3,2%
REM Set up testing folder and file
call :set_test_file

REM Test call script in separate window, redirect all stdout output to temp file
start cmd /c "echo YYRNN|call %SCRIPT% %TEST_PATH% %VALID_TIME%"^> %TEMP_FILE%
REM Program running time
call :program_run_pause 7
REM Checkpoint 1 - Title in report file
call :findstr_in_report "Housekeep report for path %TEST_PATH% with files dated on or before %MONTH:0=%/%DATE:~6,4%"
REM Checkpoints 2-4 - File name and modified time shown properly, not showing deleted
call :findstr_in_report "%TEST_FILE%"
call :findstr_in_report "Last modified date: %MODIFIED_DATE: =0% %MODIFIED_TIME: =0%"
call :findstr_in_report "%TEST_FILE% recycled"
REM Checkpoint 5 - File is not found
if not exist %TEST_PATH%\%TEST_FILE% (call :write_report_console passed) else (call :write_report_console FAILED)
call :end_test

REM Subdirectory file recycling
:test24
call :start_test
REM Test 24 - Test with subfolder, recycle file in subdirectory
set VALID_TIME=0y0
set MONTH=%DATE:~3,2%
REM Set up testing folder and file
call :set_test_file
call :set_subdir_test_file

REM Test call script in separate window, redirect all stdout output to temp file
start cmd /c "echo YYYYRN|call %SCRIPT% %TEST_PATH% %VALID_TIME%"^> %TEMP_FILE%
REM Program running time
call :program_run_pause 7
REM Checkpoint 1 - Title in report file
call :findstr_in_report "Housekeep report for path %TEST_PATH% with files dated on or before %MONTH:0=%/%DATE:~6,4%"
REM Checkpoints 2-4 - For file in dir, file name and modified time shown properly, showing deleted
call :findstr_in_report "%TEST_FILE%"
call :findstr_in_report "Last modified date: %MODIFIED_DATE: =0% %MODIFIED_TIME: =0%"
call :findstr_in_report "%TEST_FILE% deleted"
REM Checkpoints 5-7 - For file in subdir, file name and modified time shown properly, showing deleted
call :findstr_in_report "%TEST_SUBDIR_FILE%"
call :findstr_in_report "Last modified date: %SUBDIR_MODIFIED_DATE: =0% %SUBDIR_MODIFIED_TIME: =0%"
call :findstr_in_report "%TEST_SUBDIR_FILE% recycled"
REM Checkpoint 8 - File in dir is not found
if exist %TEST_PATH%\%TEST_FILE% (call :write_report_console FAILED) else (call :write_report_console passed)
REM Checkpoint 9 - File in subdir is not found
if exist %TEST_SUBDIR_PATH%\%TEST_SUBDIR_FILE% (call :write_report_console FAILED) else (call :write_report_console passed)
call :end_test

REM Subdirectory folder removal
:test25
call :start_test
REM Test 25 - Test with empty subfolder, deleted
set VALID_TIME=0y0
set MONTH=%DATE:~3,2%
REM Set up testing folder and file
call :set_test_file
call :set_subdir_test_file

REM Test call script in separate window, redirect all stdout output to temp file
start cmd /c "echo YYYYRY|call %SCRIPT% %TEST_PATH% %VALID_TIME%"^> %TEMP_FILE%
REM Program running time
call :program_run_pause 7
REM Checkpoint 1 - Title in report file
call :findstr_in_report "Housekeep report for path %TEST_PATH% with files dated on or before %MONTH:0=%/%DATE:~6,4%"
REM Checkpoints 2-3 - For file in dir, file name and modified time shown properly, showing deleted
call :findstr_in_report "%TEST_FILE%"
call :findstr_in_report "%TEST_FILE% deleted"
REM Checkpoints 4-5 - For file in subdir, file name and modified time shown properly, showing deleted
call :findstr_in_report "%TEST_SUBDIR_FILE%"
call :findstr_in_report "%TEST_SUBDIR_FILE% recycled"
REM Checkpoint 6 - File in dir is not found
if exist %TEST_PATH%\%TEST_FILE% (call :write_report_console FAILED) else (call :write_report_console passed)
REM Checkpoint 7 - File in subdir is not found
if exist %TEST_SUBDIR_PATH%\%TEST_SUBDIR_FILE% (call :write_report_console FAILED) else (call :write_report_console passed)
REM Checkpoint 8 - Subdirectory subdir is removed
if exist %TEST_SUBDIR_PATH% (call :write_report_console FAILED) else (call :write_report_console passed)
call :end_test

:test26
call :start_test
REM Test 26 - Test with empty subfolder, not deleted
set VALID_TIME=0y0
set MONTH=%DATE:~3,2%
REM Set up testing folder and file
call :set_test_file
call :set_subdir_test_file

REM Test call script in separate window, redirect all stdout output to temp file
start cmd /c "echo YYYYRN|call %SCRIPT% %TEST_PATH% %VALID_TIME%"^> %TEMP_FILE%
REM Program running time
call :program_run_pause 7
REM Checkpoint 1 - Title in report file
call :findstr_in_report "Housekeep report for path %TEST_PATH% with files dated on or before %MONTH:0=%/%DATE:~6,4%"
REM Checkpoints 2-3 - For file in dir, file name and modified time shown properly, showing deleted
call :findstr_in_report "%TEST_FILE%"
call :findstr_in_report "%TEST_FILE% deleted"
REM Checkpoints 4-5 - For file in subdir, file name and modified time shown properly, showing deleted
call :findstr_in_report "%TEST_SUBDIR_FILE%"
call :findstr_in_report "%TEST_SUBDIR_FILE% recycled"
REM Checkpoint 6 - File in dir is not found
if exist %TEST_PATH%\%TEST_FILE% (call :write_report_console FAILED) else (call :write_report_console passed)
REM Checkpoint 7 - File in subdir is not found
if exist %TEST_SUBDIR_PATH%\%TEST_SUBDIR_FILE% (call :write_report_console FAILED) else (call :write_report_console passed)
REM Checkpoint 8 - Subdirectory subdir is not removed
if exist %TEST_SUBDIR_PATH% (call :write_report_console passed) else (call :write_report_console FAILED)
call :end_test

:end
echo ===========================
echo TESTING END AT %DATE% %TIME%, report at %cd%\%TEST_REPORT_FILE%
pause
endlocal
goto :eof

REM Subroutines run by above code
REM Commands which need to be run before starting each test
:start_test
set /A COUNT+=1
REM At start of each test, reset checkpoint number to 0
set CHECKPOINT_COUNT=0
set TEMP_FILE=%TEMP_PATH%\test_temp_%COUNT%.txt
echo. > %TEMP_FILE%
echo ============================
echo ============================>> %TEST_REPORT_FILE%
echo Test %COUNT% start
goto :eof

:set_test_file
if exist %TEST_PATH% rmdir /S /Q %TEST_PATH%
mkdir %TEST_PATH%
echo.> %TEST_PATH%\%TEST_FILE% & set MODIFIED_DATE=%DATE:~0,10%& set MODIFIED_TIME=%TIME:~0,5%
goto :eof

:set_subdir_test_file
if exist %TEST_SUBDIR_PATH% rmdir /S /Q %TEST_SUBDIR_PATH%
mkdir %TEST_SUBDIR_PATH%
echo.> %TEST_SUBDIR_PATH%\%TEST_SUBDIR_FILE% & set SUBDIR_MODIFIED_DATE=%DATE:~0,10%& set SUBDIR_MODIFIED_TIME=%TIME:~0,5%
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

:end_test
REM Backup report file for further investigation
if exist %REPORT_PATH% move /y %REPORT_PATH% %TEMP_PATH%\%TEMP_REPORT_NAME%%COUNT%.txt
if exist %TEST_PATH%\%TEST_FILE% del /F /Q %TEST_PATH%\%TEST_FILE%
goto :eof
