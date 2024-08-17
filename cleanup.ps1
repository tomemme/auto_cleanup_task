# Initialize variables
$logFile = "$env:UserProfile\Documents\system_cleanup_log.txt"
$totalSpaceFreedOverall = 0.0
$DryRun = $true  # Set this to $false for actual cleanup

# Define the Remove-TempFiles function
function Remove-TempFiles {
    param (
        [string]$logFile,
        [switch]$DryRun
    )

    $totalSpaceFreed = 0
    $logEntries = ""

    # Define paths to temp directories
    $tempPaths = @(
        "$env:Temp\*",
        "$env:LocalAppData\Temp\*"
    )

    # Iterate over each path and delete files
    foreach ($path in $tempPaths) {
        $items = Get-ChildItem -Path $path -Recurse
        foreach ($item in $items) {
            $itemSize = $item.Length
            if ($DryRun) {
                $logEntries += "Would delete: $($item.FullName) at $(Get-Date)`r`n"
            } else {
                Remove-Item -Path $item.FullName -Recurse -Force -ErrorAction SilentlyContinue
                $logEntries += "Deleted: $($item.FullName) at $(Get-Date)`r`n"
            }
            $totalSpaceFreed += $itemSize
        }
    }

    # Log the total space freed
    $spaceFreedMB = [math]::Round($totalSpaceFreed / 1MB, 2)

    if ($DryRun) {
        $logEntries += "Total space that would be freed from Temp Files: $spaceFreedMB MB at $(Get-Date)`r`n"
    } else {
        $logEntries += "Total space freed from Temp Files: $spaceFreedMB MB at $(Get-Date)`r`n"
    }

    # Write log entries to log file
    Add-Content -Path $logFile -Value $logEntries
    return $spaceFreedMB
}

# Define the Clear-BraveCache function
function Clear-BraveCache {
    param (
        [string]$logFile,
        [switch]$DryRun
    )

    $totalSpaceFreed = 0
    $logEntries = ""

    $cachePaths = @(
        "$env:LocalAppData\BraveSoftware\Brave-Browser\User Data\Default\Cache\*",
        "$env:LocalAppData\BraveSoftware\Brave-Browser\User Data\Default\Code Cache\*"
    )

    foreach ($path in $cachePaths) {
        $items = Get-ChildItem -Path $path -Recurse
        foreach ($item in $items) {
            $itemSize = $item.Length
            if ($DryRun) {
                $logEntries += "Would delete: $($item.FullName) at $(Get-Date)`r`n"
            } else {
                Remove-Item -Path $item.FullName -Recurse -Force -ErrorAction SilentlyContinue
                $logEntries += "Deleted: $($item.FullName) at $(Get-Date)`r`n"
            }
            $totalSpaceFreed += $itemSize
        }
    }

    $spaceFreedMB = [math]::Round($totalSpaceFreed / 1MB, 2)

    if ($DryRun) {
        $logEntries += "Total space that would be freed from Brave Cache: $spaceFreedMB MB at $(Get-Date)`r`n"
    } else {
        $logEntries += "Total space freed from Brave Cache: $spaceFreedMB MB at $(Get-Date)`r`n"
    }

    Add-Content -Path $logFile -Value $logEntries
    return $spaceFreedMB
}

# Function to clean up old log files
function Remove-LogFiles {
    param (
        [string]$logFile,
        [switch]$DryRun
    )

    $totalSpaceFreed = 0
    $logEntries = ""

    # Define the path to the log files you want to clean up
    $logPaths = @(
        "C:\ProgramData\Microsoft\Windows\WER\ReportArchive\*",
        "C:\Windows\Panther\*",
        "C:\Windows\INF\*"
    )

    foreach ($path in $logPaths) {
        $items = Get-ChildItem -Path $path -Recurse | Where-Object { $_.LastWriteTime -lt (Get-Date).AddDays(-30) }
        foreach ($item in $items) {
            if ($DryRun) {
                $logEntries = "Would delete: $($item.FullName) at $(Get-Date)`r`n"
            } else {
                Remove-Item -Path $item.FullName -Force -ErrorAction SilentlyContinue
                $logEntries = "Deleted: $($item.FullName) at $(Get-Date)`r`n"
            }
            $totalSpaceFreed += $item.Length
        }
    }

    $spaceFreedMB = [math]::Round($totalSpaceFreed / 1MB, 2)

    if ($DryRun) {
        $logEntries += "Total space that would be freed from log files: $spaceFreedMB MB at $(Get-Date)`r`n"
    } else {
        $logEntries += "Total space freed from log files: $spaceFreedMB MB at $(Get-Date)`r`n"
    }

    Add-Content -Path $logFile -Value $logEntries
    return $spaceFreedMB
}

# Function to empty the Recycle Bin
function Clear-RecycleBin {
    param (
        [string]$logFile,
        [switch]$DryRun
    )

    $totalSpaceFreed = 0
    $logEntries = ""

    # Initialize shell object to access the Recycle Bin
    $shell = New-Object -ComObject Shell.Application
    $recycleBin = $shell.Namespace(0xA)  # 0xA is the Recycle Bin

    # Enumerate items in the Recycle Bin
    for ($i = 0; $i -lt $recycleBin.Items().Count; $i++) {
        $item = $recycleBin.Items().Item($i)
        $itemPath = $item.Path
        $itemSize = $item.Size

        if ($DryRun) {
            $logEntries += "Would delete: $itemPath at $(Get-Date)`r`n"
        } else {
            $logEntries += "Deleted: $itemPath at $(Get-Date)`r`n"
        }
        $totalSpaceFreed += $itemSize
    }

    if (-not $DryRun) {
        # Actually clear the Recycle Bin
        Clear-RecycleBin -Force -ErrorAction SilentlyContinue
    }

    $spaceFreedMB = [math]::Round($totalSpaceFreed / 1MB, 2)
    if ($DryRun) {
        $logEntries += "Total space that would be freed from Recycle Bin: $spaceFreedMB MB at $(Get-Date)`r`n"
    } else {
        $logEntries += "Total space freed from Recycle Bin: $spaceFreedMB MB at $(Get-Date)`r`n"
    }

    Add-Content -Path $logFile -Value $logEntries
    return $spaceFreedMB
}

# Main script execution
$result1 = Remove-TempFiles -LogFile $logFile -DryRun:$DryRun
$totalSpaceFreedOverall += $result1

$result2 = Clear-BraveCache -LogFile $logFile -DryRun:$DryRun
$totalSpaceFreedOverall += $result2

$result3 = Remove-LogFiles -LogFile $logFile -DryRun:$DryRun
$totalSpaceFreedOverall += $result3

$result4 = Clear-RecycleBin -LogFile $logFile -DryRun:$DryRun
$totalSpaceFreedOverall += $result4

# Create info block for footer and header
$logfooter = "Cleaning TempFiles returned: $result1 MB`n"
$logfooter += "Clearing BraveCache returned: $result2 MB`n"
$logfooter += "Removing LogFiles returned: $result3 MB`n"
$logfooter += "Cleaning RecycleBin returned: $result4 MB`n"
$logfooter += "Total space that would be freed by cleanup operations: $totalSpaceFreedOverall MB at $(Get-Date)"

# Add the footer at the top of the log
$logContent = Get-Content -Path $logFile -Raw  # Use -Raw to get the entire content as a single string
$logCombined = $logfooter + "`n" + $logContent
$logCombined | Out-File -FilePath $logFile -Encoding utf8  # Use Out-File to write the combined content back

# Add the footer at the end of the log
Add-Content -Path $logFile -Value "$logfooter"
