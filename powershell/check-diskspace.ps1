####
# Script for checking free space on C: drive
# Less than 2 GB Alert email is sent
####


$disk = Get-WmiObject Win32_LogicalDisk -Filter "DeviceID='C:'" | Select-Object Size, Freespace

# $disk.Size/1GB
$freespace = [Math]::Round($disk.FreeSpace/1GB,1)

# If less than 2 GB send email

if ($freespace -lt 2)
{

Send-MailMessage -to "burlingamedevops@moneygram.com" -from "ws4Alert@moneygram.com" -subject "[ALERT]- Low Disk Space (WS4): $freespace GB Remaining" -SmtpServer "10.200.200.136" 
}