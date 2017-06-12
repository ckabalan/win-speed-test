#speedtest for disks

$outputpath = "e:\speedtest.csv"
$tempfile = "C:\temp\testfile.dat"

while ($true){
	$now = Get-Date -format "dd-MMM-yyyy HH:mm:ss.fff"
	$epoch = get-date -UFormat %s

	#write 
	$write_ms = measure-command {FSUTIL.EXE file createnew $tempfile (1GB)}

	#read
	$read_ms = measure-command {$bytes = [System.IO.File]::ReadAllBytes("C:\temp\testfile.dat")  }

	#create object and append to table
	$object = New-Object psobject -Property $props
	#Create properties for custom object
	$props = @{
		"PrettyDate" = $now
		"epoch" = $epoch
		"write_ms" = $write_ms.TotalMilliseconds
		"read_ms" = $read_ms.TotalMilliseconds
	}

	Remove-Item $tempfile

	$bytes = ""
	[gc]::collect()

	IF ($object.PrettyDate -ne ""){$object.PrettyDate+", "+$object.epoch+", "+$object.write_ms+", "+$object.read_ms | out-file $outputpath -append}
	start-sleep 1
}
