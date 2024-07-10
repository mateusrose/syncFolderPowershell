param (
    [Parameter(Mandatory)]
    [string]$SourceFolder,

    [Parameter(Mandatory)]
    [string]$ReplicaFolder,

    [Parameter(Mandatory)]
    [string]$LogFilePath
)


#function that logs changes into a file and console, takes 2 parameters


#function that holds the sync folder logic
function Sync-Folder {
    param (
        [Parameter(Mandatory)]
        [string]$SourceFolder,

        [Parameter(Mandatory)]
        [string]$ReplicaFolder
    )

    function Log-Write {
        param (
            [Parameter(Mandatory)]
            [string]$Message 
        )

        #to dont repeat date every time when calling
        $formattedMessage = "[{0}] {1}" -f (Get-Date), $Message
        Write-Host $formattedMessage
        Add-Content -Path $Script:logFile -Value $formattedMessage
}




    #possible errors
    try {
        #check if the source folder exists
        if (-not (Test-Path -Path $SourceFolder -PathType Container)) {
            throw [System.IO.DirectoryNotFoundException]
        }

        #check if Replica Folder exists, create if not
        if (-not (Test-Path -Path $ReplicaFolder -PathType Container)) {
            New-Item -ItemType Directory -Path $ReplicaFolder | Out-Null
            Log-Write -Message "Created replica folder: $ReplicaFolder" 
        }

        #sync new files from source to replica
        Get-ChildItem -Path $SourceFolder -Recurse | ForEach-Object {
            $sourcePath = $_.FullName
            $replicaPath = $sourcePath.Replace($SourceFolder, $ReplicaFolder)

            #checking if its a folder and doesnt exist in replica folder
            if ($_.PsIsContainer -and -not (Test-Path -Path $replicaPath -PathType Container)) {
                New-Item -ItemType Directory -Path $replicaPath | Out-Null
                Log-Write -Message "Created directory: $replicaPath" 

            #other file types if not present in replica folder or last write time of source file is newer than replica file
            } elseif (-not (Test-Path -Path $replicaPath) -or $_.LastWriteTime -gt (Get-Item -Path $replicaPath).LastWriteTime) {
                Copy-Item -Path $sourcePath -Destination $replicaPath -Force
                Log-Write -Message "Copied file: $sourcePath to $replicaPath" 
            }
        }

    
        #remove what is in replica that is not in source
        Get-ChildItem -Path $ReplicaFolder -Recurse | Where-Object {
            $replicaPath = $_.FullName
            $sourcePath = $replicaPath.Replace($ReplicaFolder, $SourceFolder)

            #if not in source folder
            if (-not (Test-Path -Path $sourcePath)) {
                #check if folder
                if ($_.PsIsContainer) {
                    Remove-Item -Path $_.FullName -Recurse -Force
                    Log-Write -Message "Removed directory: $($_.FullName)" 
                #other files
                } else {
                    Remove-Item -Path $_.FullName -Force
                    Log-Write -Message "Removed file: $($_.FullName)"
                }
            }
        }
    } catch {
        Write-Host "Error during operation: $($_.Exception.Message)"
    }
}



#create/update the log file and set its path with name
$logFile = Join-Path -Path $logFilePath -ChildPath "syncLog.log"

try {
    #passing arguments from script to Sync-Folder function, passing logFile that is the combination of all add-content operations of the log file
    Sync-Folder -SourceFolder $SourceFolder -ReplicaFolder $ReplicaFolder
} catch {
    Write-Host "Error: $_" 
}


