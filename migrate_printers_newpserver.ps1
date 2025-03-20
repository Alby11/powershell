# Define old and new print server names
$oldServer = "\\PRINT-old"
$newServer = "\\PRINT-new"

# Retrieve all network printers from the old server
$printers = Get-WmiObject -Query "SELECT * FROM Win32_Printer WHERE Network = TRUE"

# Loop through each printer
foreach ($printer in $printers)
{
    # Check if the printer is mapped from the old server
    if ($printer.SystemName -like $oldServer)
    {
        # Extract printer name
        $printerName = $printer.Name.Split('\')[-1]

        # Remove the old printer connection
        $printer.Delete()
        Write-Host "Removed old printer: $printer.Name"

        # Add the new printer connection
        $newPrinterPath = "$newServer\$printerName"
        Add-Printer -ConnectionName $newPrinterPath
        Write-Host "Added new printer: $newPrinterPath"
    }
}

Write-Host "Printer migration completed."