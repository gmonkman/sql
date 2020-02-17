REM Open default ports for SQL Server
NETSH advFirewall firewall add rule name="Allow: Inbound: TCP: SQL Server Services" dir=in action=allow protocol=TCP localport=1433,1434,2382,135,2383,4022,16450,16451,16452,16453,16454,16455,16456,16457,16458,16459,16460
NETSH firewall set MulticastBroadcastResponse ENABL
pause