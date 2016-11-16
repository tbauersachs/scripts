###########################
# Script for creating dump files
# for the Prod-svc and Prod-web Alloy processes
###########################

$timestamp = "_" + (get-date).ToString("MMM") + (get-date).day + "_" + (get-date).hour  + (get-date).Minute + ".dmp"
$dmppath = "\\log1\logs\dumps\"


######## PROD-SVC Dump ##############

# Get the PROD-SVC process
$Prodsvc = gwmi win32_process | where {$_.getowner().user -eq "PROD-SVC"}

$filenamesvc = "alloyProd-SVC" + $timestamp  

#Create the PROD-SVC dump
C:\scripts\procdump.exe -ma $Prodsvc.ProcessId $dmppath$filenamesvc




######## PROD-WEB Dump ##############

$filenameweb = "alloyProd-WEB" +  $timestamp  

# Get the PROD-WEB process
$Prodweb = gwmi win32_process | where {$_.getowner().user -eq "PROD-WEB"}

# Create PROD-WEB dump
C:\scripts\procdump.exe -ma $Prodweb.ProcessId $dmppath$filenameweb