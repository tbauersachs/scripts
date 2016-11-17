


$DaysToExpiration = 45
$expirationDate = (Get-Date).AddDays($DaysToExpiration)



$certs = Get-ChildItem CERT:localmachine/My |  ? {$_.NotAfter -lt $expirationDate} | select friendlyname, subject, @{Name="Expiration"; Expression= {$_.Notafter}} | fl | out-string


if ($certs.Length -gt 1)
{


 Send-MailMessage -to "tbowersox@moneygram.com" -from "SSLalert@moneygram.com" -subject "[ALERT] Certs expiring within $DaysToExpiration days on $env:computername" -body $certs -SmtpServer "10.200.200.136" 
}