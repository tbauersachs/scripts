################################################################################
## Server Health Report (CPU,memory,space)
## Creates html document and sends alert if certain criteria are met
################################################################################  
 
#$ServerListFile = "C:\ServerList.txt"   
#$ServerList = Get-Content $ServerListFile -ErrorAction SilentlyContinue  
#$Result = @()  
$ServerList="ws4"
$sendalert = "no"

ForEach($computername in $ServerList)  
{ 
 
$AVGProc = Get-WmiObject -computername $computername win32_processor |  Measure-Object -property LoadPercentage -Average | Select Average 
$Mem = gwmi -Class win32_operatingsystem -computername $computername | Select-Object @{Name = "MemoryUsage"; Expression = {“{0:N2}” -f ((($_.TotalVisibleMemorySize - $_.FreePhysicalMemory)*100)/ $_.TotalVisibleMemorySize) }} 
$vol = Get-WmiObject -Class win32_Volume -ComputerName $computername -Filter "DriveLetter = 'C:'" | Select-object @{Name = "C PercentFree"; Expression = {“{0:N2}” -f  (($_.FreeSpace / $_.Capacity)*100) } } 


          $cpuBgcolor = "lawngreen"
          $memBgcolor = "lawngreen"
          $driveBgcolor = "lawngreen"

          if(($($AVGProc.Average)) -ge "90")  
          {  
            $cpuBgcolor = "red" 
            $sendalert = "yes" 
          } 

          if(($($Mem.MemoryUsage)) -ge "90")  
          {  
            $memBgcolor = "red" 
            $sendalert = "yes"  
          } 

          if(($($vol.'C PercentFree')) -lt "10")  
          {  
            $driveBgcolor = "red" 
            $sendalert = "yes"  
          } 
 
    $Outputreport = "<HTML><TITLE> Server Health Report </TITLE> 
                     <BODY background-color:peachpuff> 
                     <font color =""#99000"" face=""Microsoft Tai le""> 
                     <H2> Server Health Report </H2></font> 
                     <Table border=1 cellpadding=0 cellspacing=0> 
                     <TR bgcolor=lightgrey align=center> 
                       <TD><B>Server Name</B></TD> 
                       <TD><B>Avrg.CPU Utilization</B></TD> 
                       <TD><B>Memory Utilization</B></TD> 
                       <TD><B>C Drive (available)</B></TD></TR>
                       <TR><TD>$computername</TD><TD align=center bgcolor=$cpubgcolor >$($AVGProc.Average)%</TD><TD align=center  bgcolor=$memBgcolor>$($Mem.MemoryUsage)%</TD><TD align=center  bgcolor=$driveBgcolor>$($vol.'C PercentFree')%</TD></TR>
                       </Table></BODY></HTML>
                       " 
                         
    
        }  
  
$Outputreport | out-file C:\Scripts\Test.htm  
#Invoke-Expression C:\Scripts\Test.htm 

if( $sendalert -eq "yes") {
##Send email functionality from below line, use it if you want    
$smtpServer = "10.200.200.136" 
$smtpFrom = "ws4Alert@moneygram.com" 
$smtpTo = "burlingamedevops@moneygram.com" 
$messageSubject = "WS4 Servers Health report" 
$message = New-Object System.Net.Mail.MailMessage $smtpfrom, $smtpto 
$message.Subject = $messageSubject 
$message.IsBodyHTML = $true 
$message.Body = "<head><pre>$style</pre></head>" 
$message.Body += Get-Content C:\scripts\test.htm 
$smtp = New-Object Net.Mail.SmtpClient($smtpServer) 
$smtp.Send($message)
}

