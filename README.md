# windows-file-housekeep
Some utility Windows batch / Powershell script to housekeep files:
1. Generate list of outdated files (files not modified for a period of time, as defined by user) with folder path as specified by user and prompt for deletion (```housekeep.bat```)
2. Backup a Windows directory with path as specified by user, with choice of backing up subdirectories or not (```backup_compare_hash.ps1```).

How to use housekeep.bat
------------------------
The script ```housekeep.bat``` can be downloaded to any directory and used.
It will prompt for 2 inputs:
1. Folder path to housekeep, simply copy from Windows Explorer window. (Unfortunately, it does not support checking for subdirectories too, this will be added as a feature later.)
2. Housekeep time, where the housekeep process will operate each file with 'Last Modified Time' before this time.

A report file ```housekeep_list_report.txt``` will be generated, which lists all files modified on or before the user's input time, and whether they are deleted.

The test script ```test_housekeep.bat``` is my attempt at developing a JUnit-styled unit test aimed to test the logic of the script ```housekeep.bat```.

How to use backup_compare_hash.ps1
----------------------------------
The script ```backup_compare_hash.ps1``` can be downloaded to any directory and used.
It will prompt for 1-2 inputs:
1. Folder path to backup, simply copy from Windows Explorer window. (The backup folder name will be same, but with ```_bk_<backup_date>``` appended to the end.)
2. If folder contains subdirectories, will prompt for whether backup all contents within subdirectories too.

Log will be in the ```log``` folder at the parent directory of the folder to backup (with filename ```log_<backup_date>_<backup_time>```. It will compare the contents using SHA1 hash methods of the bytes within the before and after copy folder. The compare result is logged and shown on the console.

Future developments
-------------------
1. Housekeeping of subdirectories of the specified folder.
2. Removal of empty directories after housekeeping.
3. Restoration of files and directories from Recycle Bin based on report file.
4. Validation of input in the free format ```set /P``` input to prevent injection.
