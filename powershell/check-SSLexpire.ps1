
#############
#### Checks the cert store for expiring certs on a computer
#### Pass days to expire to the script as an argument
#### check-SSLexpire.ps1 [days]
#### 
#### Sends email of expiring certs to burlingamedevop@moneygram.com
#### Can run script on remote computer if uncomment invoke-command
#### Can pass multiple computers with comma delimited server names
#### check-SSLexpire.ps1 [days] [serverlist]
#### Need to run as a service account in task scheduler if running on remote computers
#### Invoke command will not work on the local computer
#############

param(
[string]$Days
#[array]$serverlist
)

<#
$servers = $serverlist.Split(",")

foreach($server in $servers)
{

# removing remote invoke
#Invoke-command -ComputerName $server -ArgumentList $days -ScriptBlock {

Param (
$days
)
#>

$DaysToExpiration = $Days
$expirationDate = (Get-Date).AddDays($DaysToExpiration)

$certs = Get-ChildItem CERT:localmachine/My |  ? {$_.NotAfter -lt $expirationDate} | select friendlyname, subject, @{Name="Expiration"; Expression= {$_.Notafter}} | fl | out-string


if ($certs.Length -gt 1)
{

$emailbody = "These certs are expiring within $DaysToExpiration days:`r"  + $certs

 Send-MailMessage -to "burlingamedevops@moneygram.com" -from "SSLalert@moneygram.com" -subject "[ALERT] Certs expiring on $env:computername" -body $emailbody  -SmtpServer "10.200.200.136" 
}

<#

} # Removing remote invoke

} # remove foreach

#>