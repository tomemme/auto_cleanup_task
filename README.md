# System Cleanup Script

This PowerShell script automates the cleanup of temporary files, browser cache, log files, and the Recycle Bin on a Windows system. It includes a dry-run mode for testing and generates a log file to track the cleanup operations.

## Features

- **Remove Temporary Files**: Cleans up files from the system's temp directories.
- **Clear Brave Browser Cache**: Removes cache files from the Brave browser.
- **Remove Log Files**: Deletes log files from the Windows logs directory.
- **Clear Recycle Bin**: Empties the Recycle Bin using a COM object for reliable operation.
- **Logging**: Logs all operations, including the amount of space freed, and allows for a dry-run mode.

## Usage

1. **Dry Run Mode**: Test the script without actually deleting any files.
- Scripts comes in Dry run mode

2. **Actual Cleanup**: Perform the cleanup operations.
- To perform the cleanup after running in dry mode. You must update the $DryRun variable to be false, and call the script.

3. **Log File**: The script generates a log file at `C:\Users\<YourUsername>\Documents\system_cleanup_log.txt` detailing the operations performed and space freed.

## Requirements

- **PowerShell**: This script is designed to run in a PowerShell environment on Windows.
- **Brave Browser**: If you use the `Clear-BraveCache` function, make sure Brave is installed.

## Contributing

Feel free to fork this repository and submit pull requests with improvements or additional features.

## License

This project is licensed under the MIT License. See the `LICENSE` file for more details.
