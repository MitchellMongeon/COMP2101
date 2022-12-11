"_____________________________________________________________________________________________________________"
"SYSTEM HARDWARE"
$hardinfo=get-wmiobject win32_computersystem
$Hardtable=$hardinfo |
foreach {$hardinfo=$_;
                               new-object -typename psobject -property @{Domain=$hardinfo.domain
                                                                         Manufacturer=$hardinfo.manufacturer
                                                                         Model=$hardinfo.model
                                                                         Name=$hardinfo.name
                                                                         OwnerName=$hardinfo.primaryownername
                                                                         "PhysicalMemory(GB)"=$hardinfo.totalphysicalmemory / 1gb -as [int]
                                                                         }
 }
$hardtable | ft -auto
"_____________________________________________________________________________________________________________"

"OS"
$OS=get-wmiobject win32_operatingsystem
$OStable=$OS |
foreach {$OS=$_;
			new-object -typename psobject -property @{Name=$os.name
                                                                  Version=$os.version
                                                                 }
}
$OStable | ft -auto
"_____________________________________________________________________________________________________________"
                      

"CPU"
$CPU=get-wmiobject win32_processor
$cputable = $cpu |
foreach {$CPU =$_;
	 $cache=$cpu.GetRelated("Win32_cachememory");
	 new-object psobject -property @{Description=$cpu.description
					 Cores=$CPU.numberofcores
					 L2Cache=$cache.l2cachesize / 1gb -as [int]
					 L3Cache=$cache.L3cachesize / 1gb -as [int]
					}
}
$cputable | ft Description, cores, L2Cache, L3Cache
"_____________________________________________________________________________________________________________"
"Ram"
$totalcapacity=0
$RAM=get-wmiobject win32_physicalmemory
$RAMtable= $RAM |
foreach {$RAM =$_;
	 new-object psobject -propety @{Vendor=$ram.manufacturer
					Description=$ram.description
					Size=$ram.capacity / 1gb -as [int]
					DIMM=$ram.banklabel
					}
					$totalcapacity+=$RAM/1mb
}
$RAMtable | ft -auto
"Total RAM: ${totalcapacity}MB"
"_____________________________________________________________________________________________________________"
"Physical Disk Drive(s)"

$diskdrives = Get-wmiobject win32_diskdrive 
$Disktable = foreach ($disk in $diskdrives) {
      $partitions = $diskdrives.getrelated("win32_diskpartition")
      foreach ($partition in $partitions) {
            $logicaldisks = $partition.getrelated("win32_logicaldisk")
            foreach ($logicaldisk in $logicaldisks) {
                     new-object psobject -property @{Manufacturer=$disk.Manufacturer
						     Model=$disk.model
                                                     Location=$partition.deviceid
                                                     Drive=$logicaldisk.deviceid
                                                     "Size(GB)"=$logicaldisk.size / 1gb -as [int]
						     FreeSpace=$logicaldisk.freespace / 1gb -as [int]
						     PercentFree= [Math]::round((($logicaldisk.freespace/$logicaldisk.size) * 100))
                                                    }
         				 	    }
     				 	  }

				  } 

$Disktable | ft Drive, Manufacturer, Model, "Size(GB)", Freespace, PercentFree 

"_____________________________________________________________________________________________________________"

"Network"

get-ciminstance win32_networkadapterconfiguration | where ipenabled | 
select  description, index, ipaddress, ipsubnet, DNSDomain, DNSServerSearchOrder | 
ft -AutoSize

"_____________________________________________________________________________________________________________"

"Video Card"

$vid=Get-wmiobject win32_videocontroller
$vidtable=$vid |
foreach {$vid = $_;
	 new-object psobject -property @{Vender=$vid.AdapterCompatibility
					 Description=$vid.name
					 Resolution=$vid.VideoModeDescription
					}
	}
$vidtable | ft -auto

"_____________________________________________________________________________________________________________"
					 




