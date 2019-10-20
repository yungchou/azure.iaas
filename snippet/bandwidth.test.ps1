# Enable Ping for testing and open File Sharing
New-NetFirewallRule –DisplayName “Allow ICMPv4-In” –Protocol ICMPv4
netsh advfirewall firewall set rule group=”File and Printer Sharing” new enable=Yes
 
#Create 4.8GB file
fsutil file createnew C:\large.file 5242880000  
 
#Copy file and meassure time
Measure-Command {Copy-Item -Path \\<source>\c$\large.file -Destination C:\}
