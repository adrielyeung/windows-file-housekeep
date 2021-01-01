$LOG_DATETIME = Get-Date -Format "yyyyMMdd_HHmmss"
$BACKUP_DATE = Get-Date -Format "yyyyMMdd"

function Get-FolderHash ($backup_from, $back_subfolder) {
    switch ($back_subfolder) {
        Y {$folder_contents = Get-ChildItem $backup_from\* -Recurse -Force}
        N {$folder_contents = Get-ChildItem $backup_from\*.* -Force}
    }
    $folder_contents | ?{!$_.psiscontainer} | %{[Byte[]]$contents += [System.IO.File]::ReadAllBytes($_.fullname)}
    $hasher = [System.Security.Cryptography.SHA1]::Create()
    [string]::Join("",$($hasher.ComputeHash($contents) | %{"{0:x2}" -f $_}))
}

function Copy-Backup ($backup_from, $back_subfolder) {
    $backup_to = $backup_from+"_bk_"+$BACKUP_DATE
    New-Item -Path $backup_to\.. -Name (Split-Path $backup_to -Leaf) -ItemType "directory" -Force | Out-Null
    Remove-Item -Path $backup_to\* -Recurse -Force
    switch ($back_subfolder) {
        Y {Copy-Item -Path "$backup_from\*" -Destination "$backup_to" -Recurse -Force}
        N {Copy-Item -Path "$backup_from\*.*" -Destination "$backup_to" -Force}
    }
}

function Compare-FolderHash ($backup_from, $back_subfolder) {
    $LOG_PATH = "$backup_from\..\log"
    $Today = (Get-Date).DateTime
    $LOG_NAME = "log_"+$LOG_DATETIME+".txt"
    if (-Not (Test-Path $LOG_PATH)) {New-Item -Path $backup_from\.. -Name log -ItemType "directory" -Force | Out-Null}
    "Backup of "+$backup_from+" at "+$TODAY > $LOG_PATH\$LOG_NAME
    $backup_to = $backup_from+"_bk_"+$BACKUP_DATE
    $FROM_HASH = Get-FolderHash $backup_from $back_subfolder
    $TO_HASH = Get-FolderHash $backup_to $back_subfolder
    "Hash of "+$backup_from+" is: "+$FROM_HASH >> $LOG_PATH\$LOG_NAME
    "Hash of "+$backup_to+" is: "+$TO_HASH >> $LOG_PATH\$LOG_NAME
    if (($FROM_HASH -eq $TO_HASH) -and ($FROM_HASH -ne $NULL)) {
        "Hashes of original folder and backup matches"
        "Hashes of original folder and backup matches" >> $LOG_PATH\$LOG_NAME
    } else {
        "Hashes of original folder and backup do not match" >> $LOG_PATH\$LOG_NAME
        Write-Error "Hashes of original folder and backup do not match"
    }
}

if ([string]::IsNullOrWhiteSpace($args[0])) {
    $BACKUP_PATH=Read-Host "Please enter path of folder to backup"
} else {
    $BACKUP_PATH=$args[0]
}

if (-not (Test-Path $BACKUP_PATH)) {throw "Path "+$BACKUP_PATH+" not found."}

# Check if subdirectories exist, if yes, ask if backup them too
if (Get-ChildItem -Path "$BACKUP_PATH" -Directory) {
    Get-ChildItem -Path "$BACKUP_PATH" -Directory
    if ([string]::IsNullOrWhiteSpace($args[1])) {
        $BACKUP_SUBFOLDER=Read-Host "Found above subfolders, backup all contents within too? (Y/N)"
    } else {
        $BACKUP_SUBFOLDER=$args[1]
    }
    
    Copy-Backup $BACKUP_PATH $BACKUP_SUBFOLDER
    Compare-FolderHash $BACKUP_PATH $BACKUP_SUBFOLDER
} else {
    Copy-Backup $BACKUP_PATH N
    Compare-FolderHash $BACKUP_PATH N
}

# Check if hashes of original folder and backup matches
if ($?) {"Backup completed"} else {"Error occurred during backup, please check"}
