$limit = (Get-Date).AddDays(-30)
$path = "\\nxi-16\c$\Program Files\NXiTraspo\Log"

# Delete files older than the $limit.
Get-ChildItem -Path $path -Recurse -Force | Where-Object { !$_.PSIsContainer -and $_.CreationTime -lt $limit } | Remove-Item # -Force

# Delete any empty directories left behind after deleting the old files.
#Get-ChildItem -Path $path -Recurse -Force | Where-Object { $_.PSIsContainer -and (Get-ChildItem -Path $_.FullName -Recurse -Force | Where-Object { !$_.PSIsContainer }) -eq $null } | Remove-Item -Force -Recurse -Verbose