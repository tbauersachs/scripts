$strComputer = "."

$colItems = get-wmiobject -class "Win32_Service" -namespace "root\cimv2" -computername $strComputer

foreach ($objItem in $colItems) {
      write-host $objItem.Name, $objItem.State
}
