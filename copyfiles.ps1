Get-Content -path "C:\scripts\tas278results.txt" | foreach-object{ 

if ($_ -like "*Web*") {
write-host $_
Copy-Item $_ C:\scripts\TAS-278\web\
}
write-host $_
if ($_ -like "*Svc*") {
Copy-Item $_ C:\scripts\TAS-278
}

}
