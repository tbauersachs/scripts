############
### Script to zip and move nlog  to log1
### 
############

$date = (get-date)
$year = $date.Year
$month = $date.Month
$day = $date.Day


$source = "C:\log.txt"
$destinationfolder = "\\log1\logs\$year\nlog"

# Check if destination folder exists, create if not
If(!(Test-Path $destinationfolder))
{
  New-Item $destinationfolder -type directory
}

$file = "nlog" + $year + $month + $day


$destinationzipfolder = $destinationfolder + "\" + $file + ".zip"

set-content $destinationzipfolder ("PK" + [char]5 + [char]6 + ("$([char]0)" * 18))
(dir $destinationzipfolder).IsReadOnly = $False

$shellApplication = new-object -ComObject shell.application
$zipPackage = $shellApplication.NameSpace($destinationzipfolder)

$zipPackage.CopyHere($source)

Start-Sleep -Milliseconds 20000


# Remove files after zipping

  # Test if zip folder created before removing file
  
  If(Test-Path $destinationzipfolder)
   {
     remove-item $source
   }
   



