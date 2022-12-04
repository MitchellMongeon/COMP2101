get-ciminstance win32_networkadapterconfiguration | where ipenabled | 
select  description, index, ipaddress, ipsubnet, DNSDomain, DNSServerSearchOrder | 
ft -AutoSize