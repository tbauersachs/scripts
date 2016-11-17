# check-network queries a web address to verify if it is accessible
# If the return is negative, send an alert

$emailbody = ""
$web = New-Object Net.WebClient

$chexarURL = $true
#$wuURL = $true


Try {
      $web.DownloadString("https://chexar.net/")
    }
Catch {
   $chexarURL = $false   
}

If(Test-Connection -ComputerName dbs1 -count 1 -Quiet) {
  $dbs1Ping = $true
} else {
  $dbs1Ping = $false
}

<# Could not get Western Union request to work with client cert
Try {

     # $certs = Get-ChildItem CERT:localmachine/My  |  ? {$_.Thumbprint -eq "FBC5165664DD485A20544EEA5FDB9BA6C435C116"} #| out-string #|  ? {$_.CN -eq "mgialloywuxy6149.wu-gwa.com"}
     # Write-Host $certs

     $cert = Get-Certificate
     write-host $cert

      #if ($certs.Length -gt 1) {
      write-host "test"
      #$web.clientcertificates.Add($cert)
      $web.AddCerts.($cert)
      $web.DownloadString("https://wugateway2.westernunion.net/")
     # } else {
     # write-host "no cert"
      #}
      
    }
Catch {
  $wuURL = $false
}
#>

if( $chexarURL -eq $false -or $dbs1Ping -eq $false) {

    if( $chexarURL -eq $false ) {

      $emailbody = "Chexar not accessible`r"

    }

    if( $dbs1Ping -eq $false ) {

      $emailbody =  $emailbody + "DBS1 not accessible`r"

    }


Send-MailMessage -to "tbowersox@moneygram.com" -from "NetworkAlert@moneygram.com" -subject "[ALERT] URL not accessible" -body $emailbody  -SmtpServer "10.200.200.136"
} 






#Gets a certificate from the certificate store
function Get-Certificate {
param()

$OpenFlags = [System.Security.Cryptography.X509Certificates.OpenFlags]
$X509FindType = [System.Security.Cryptography.X509Certificates.X509FindType]
$store = New-Object System.Security.Cryptography.X509Certificates.X509Store "My", "localmachine"

try {
  $store.Open($OpenFlags::OpenExistingOnly -bor $OpenFlags::ReadOnly)
  $certificates = @($store.Certificates.Find($X509FindType::FindByThumbprint, "FBC5165664DD485A20544EEA5FDB9BA6C435C116", $true))

  if ($certificates.Count -eq 0) { 
     Write-Warning "No certificate found." 
   } elseif ($certificates.Count -eq 1) { 
     $certificate = $certificates[0] 
     Write-Host "Got certificate with subject $($certificate.Subject)" 
   } else {
       Write-Host "Select the certificate to use for the web service call:"
       for($i=0;$i -lt $certificates.Count; $i++) {
          $c= $certificates[$i]
          Write-Host "[$i]:$($c.FriendlyName) $($c.Subject)"
        }

      $index = -1
      while($true ){
           $selected = Read-Host "Enter certificate number (0 - $($certificates.Count - 1))" 
            if ([int]::TryParse($selected, [ref]$index) -and $index -ge 0 -and $index -lt $certificates.Count) {
              Break
             }
       }
      $certificate = $certificates[$index]
      Write-Host "Got certificate with subject $($certificate.Subject)"
   }

    $certificate
  } finally {
   $store.Close() 
  }
}

