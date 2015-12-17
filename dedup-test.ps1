cls  
#clearing variables
Clear-Variable XX  -erroraction 'silentlycontinue'
Clear-Variable RENAME -erroraction 'silentlycontinue'
Clear-Variable PATH -erroraction 'silentlycontinue'
Clear-Variable NAME  -erroraction 'silentlycontinue'
Clear-Variable I -erroraction 'silentlycontinue'
Clear-Variable SIZE -erroraction 'silentlycontinue'
Clear-Variable NEWNAME -erroraction 'silentlycontinue'
Clear-Variable X -erroraction 'silentlycontinue'
Clear-Variable RANDTXTARRAY -erroraction 'silentlycontinue'
Clear-Variable NAMEARRAY -erroraction 'silentlycontinue'
Clear-Variable RANDTXT -erroraction 'silentlycontinue'
Clear-Variable EXTARRAY -erroraction 'silentlycontinue'
Clear-Variable M -erroraction 'silentlycontinue'
Clear-Variable Z -erroraction 'silentlycontinue'
#Clear-Variable B
Clear-Variable E -erroraction 'silentlycontinue'
Clear-Variable EXTENTION -erroraction 'silentlycontinue'
#Clear-Variable PCNAME
#Clear-Variable DATE
Clear-Variable LOGDIR -erroraction 'silentlycontinue'
#Clear-Variable LOGNAME
Clear-Variable LOGPATH -erroraction 'silentlycontinue'
#Clear-Variable LOGFILENAME
#Clear-Variable TEXT
Clear-Variable COPYCOUNT -erroraction 'silentlycontinue'


#update
try{
    $workpath = $pwd
    $updatepath = "\\files\tickets\velislav\files\dedup-tools\"
    Write-Host "Checking for update..." -ForegroundColor Yellow 
        if ($(Get-Item $workpath\dedup-test.ps1).CreationTimeUtc -lt $(Get-Item $updatepath\dedup-test.ps1).CreationTimeUtc) 
        {
          Copy-Item $updatepath\dedup-test.ps1 $workpath\dedup-test.ps1 -ErrorAction Stop
          Start-Sleep 3
          Write-Host "Script updated. Please start it again." 
          exit
         }
    }

catch
    {

    }
Write-Host "Script is up to date." -ForegroundColor Yellow

Start-Sleep -Seconds 3
cls    		
#user controls
$path = Read-Host "Choose path"
if(!(Test-Path $path))
 {
    Write-Host "(!)Destination not reachable" -foreground "red"
    Start-Sleep -s 4
    exit
 }

$size = Read-Host "Choose file size"
#if($size.GetType().FullName -ne "System.int64")
$pat = "^[A-Z0-9]+$"
if(!($size -match $pat))
    {
       Write-Host "Specified file size is not recognized. Please set the file size such as: 1MB, 1GB " -ForegroundColor Red
	   Start-Sleep -Seconds 5
		exit
    }
	$size.ToCharArray()
#initialize logs
$LogPath = ((Get-Item env:LOGS).Value)+"\dedup-test\"
$LogDir = ((Get-Item env:LOGS).Value)
#Creating logs directory 
 if(!(Test-Path $LogPath))
	{
		New-Item -ItemType directory -Name "dedup-test" -Path $LogDir
	}

#function LOGS
function Log
    { 
$pcname = $Env:COMPUTERNAME
$date = Get-Date -UFormat "%Y-%m-%d-%H"
$LogDir = ((Get-Item env:LOGS).Value)
$LogName = ($pcname+"-"+"dedup-test-log"+"-"+$date)
$LogPath = ((Get-Item env:LOGS).Value)
$LogFileName = $LogPath+"\dedup-test\"+$LogName+".txt"
$text =("["+$date+"]"+" Script started on "+$pcname+"."+" "+"File "+$name+" created  successfully in "+$path+" ."+" "+$CopyCount+" files copied" )
$text | Out-File $LogFileName -Append
   }

#Generating random file name
$e=(Get-Random -Minimum 5 -Maximum 20) 
$nameArray=@("a", "b", "c", "d", "e", "f", "g", "h", "i", "j", "k", "l", "m", "n", "o", "p" ,"q" ,"r" ,"s", "t", "u", "v", "w", "x", "y", "z", "0", "1", "2", "3", "4", "5", "6", "7", "8", "9")
for($i = 0; $i -le $e; $i++)
	{		     	
		$x = (Get-Random -InputObject $nameArray)
		$name += $x
		$rename = $name
				    
	}
$extArray = @(".TXT")
#$extArray = @(".BIN", ".DAT", ".TXT")
$extention = (Get-Random $extArray)
$name += $extention
switch ($extention)
	{
		<#case 1
			.VHD{
					#Creating dummy vhd and filling it with data
					$MountedDisk = Mount-VHD -Path $path\$name -Passthru
					[String]$DriveLetter = ($MountedDisk | Get-Disk | Get-Partition | ? {$_.Type -eq "Basic"} | Select-Object -ExpandProperty DriveLetter) + ":"
					$DriveLetter = $DriveLetter.Replace(' ','')
					Start-Sleep -Seconds 2 
					Get-PSDrive | Out-Null 
					New-Item -Path "$DriveLetter\Sources" -ItemType Directory | Out-Null
					Copy-Item -Path "MyScript.cmd" -Destination "$DriveLetter\sources\run.cmd" -Force
					Start-Sleep -Seconds 2 
					Dismount-VHD $MountedDisk.Path		
			
				}
		
		#case 4
		<#	.DAT{
		      $f = new-object System.IO.FileStream $path\$name, Create, ReadWrite
			  $f.SetLength(42MB)
			  $f.Close()
			}
		
		#>	
		#case 6
			.TXT{
					$f = new-object System.IO.FileStream $path\$name, Create, ReadWrite
			  		$f.Close()
			  		while ($(Get-ChildItem $path\$name).length -le $size)
			  			{
			  				$randtxtArray=@("a", "b", "c", "d", "e", "f", "g", "h", "i", "j", "k", "l", "m", "n", "o", "p" ,"q" ,"r" ,"s", "t", "u", "v", "w", "x", "y", "z", "0", "1", "2", "3", "4", "5", "6", "7", "8", "9")	
							for($m = 0; $m -le 2; $m++)  
								{
			     		
									$z = (Get-Random -InputObject $randtxtArray)
				 					
                                    $randtxt += $z
				    	
						Write-Progress -Activity "Creating random file" -status "Progress:" -PercentComplete (($(Get-ChildItem $path\$name).length/$size)*100)
                        		}
					
			  				$randtxt | Add-Content "$path\$name"  
                            
					       
			 			 }
			   #Clear-Variable RANDTXT
				}
			
			
		#case 7
	<#		.BIN{
			  $f = new-object System.IO.FileStream $path\$name, Create, ReadWrite
			  $f.SetLength(42MB)
			  $f.Close()
			}
		#>
		} 
#creating directory "dedup"		
if(!(Test-Path $path\dedup))
	{
		New-Item -ItemType directory -Name dedup -Path $path
	}
		
		
$xx=1
#Copy the random file		
try{
    while(1)
	    {
		    xcopy.exe $path\$name $path\dedup\ 
		    $newname=($rename+"_"+$xx+$extention)
		    Rename-Item -Path $path\dedup\$name -NewName $newname
		    $xx++
		    $CopyCount++
		    Log
	    }
	}

catch [System.OutOfMemoryException]
    {
    
       $mem = (Get-Process | sort vm | select name, vm -Last 5)
       $mem | Out-File $LogFileName -Append 
    
    }	
catch{

        $ErrorMessage = $_.Exception.Message
        $FailedItem = $_.Exception.ItemName
        $error = $FailedItem+" "+$ErrorMessage
        $error| Out-File $LogFileName -Append
     }

		
		
