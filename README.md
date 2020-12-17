# windows-file-housekeep
Windows batch script to housekeep files (generate list + prompt for deletion) modified before a time specified by the user.

How to use
----------
The script ```housekeep.bat``` can be downloaded to any directory and used.
It will prompt for 2 inputs:
1. Folder path to housekeep, simply copy from Windows Explorer window. (Unfortunately, it does not support checking for subdirectories too, this will be added as a feature later.)
2. Housekeep time, where the housekeep process will operate each file with 'Last Modified Time' before this time.

A report file ```housekeep_list_temp.txt``` will be generated, which lists all files modified on or before the user's input time, and whether they are deleted.

Future developments
-------------------
1. Housekeeping of subdirectories of the specified folder.
