############
### Script to zip and move IIS logs to log1
### Zips files older than 7 days
############

$date = (get-date).AddDays(-7) 
$year = $date.Year


$source = "C:\inetpub\logs\LogFiles\W3SVC1\"
$destinationfolder = "\\log1\logs\$year\iis\"

# Check if destination folder exists, create if not
If(!(Test-Path $destinationfolder))
{
  New-Item $destinationfolder -type directory
}


# Generate list of files to zip

$filelist = Get-ChildItem -Path $source | where-object {$_.Lastwritetime -lt (get-date).AddDays(-7)}
$filelist



# Go through file list and zip and copy
foreach($file in $filelist)
{

$destinationzipfolder = $destinationfolder + $file + ".zip"

set-content $destinationzipfolder ("PK" + [char]5 + [char]6 + ("$([char]0)" * 18))
(dir $destinationzipfolder).IsReadOnly = $False

$shellApplication = new-object -ComObject shell.application
$zipPackage = $shellApplication.NameSpace($destinationzipfolder)

$zipPackage.CopyHere($file.fullname)

Start-Sleep -Milliseconds 10000

}


# Remove files after zipping
foreach($file in $filelist)
{
  # Test if zip folder created before removing file
  $destinationzipfolder = $destinationfolder + $file + ".zip"
  If(Test-Path $destinationzipfolder)
   {
     remove-item $file.fullname
   }
   Start-Sleep -Milliseconds 500
}



