# Folder Sync Script
This script synchronizes the contents of a source folder with a replica folder, ensuring that both folders contain the same files and subdirectories. It also logs all operations to a specified log file.

## Prerequisites
To run this script, you need to set the execution policy to allow running remote scripts.

Open PowerShell as Administrator.
Set the execution policy:
Set-ExecutionPolicy RemoteSigned

## Step-by-Step Guide
### 1. Clone the repository
### 2. Prepare the Parameters
Before running the script, make sure you have the following parameters ready:

<ins>SourceFolder</ins>: The path of the folder you want to sync from.

<ins>ReplicaFolder</ins>: The path of the folder you want to sync to.

<ins>LogFilePath</ins>: The path where you want to save the log file.


### 3. (Optional) Demo Setup
For demonstration purposes, you can use the provided demo and demoReplica folders for the source and replica folder. Ensure that, after cloning, you have a structure similar to this one:

C:\pathToDownloadedFolder\syncFolderPowershell\ (LogFilePath)
│
├── SyncFolders.ps1
├── demo\ (SourceFolder)
│   ├── somefiles
│   ├── someFolders
│       └── somefiles
│
└── demoReplica (ReplicaFolder)
│   ├── somefilesbeingdelete
│   ├── someFoldersbeingdeleted
│       └── somefiles

### 4. Run the script with powershell and after provide SourceFolder, ReplicaFolder and LogFilePath where a syncLog.log will be created/updated.
