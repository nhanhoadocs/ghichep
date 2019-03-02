icacls "%plesk_dir%\admin\plib\functions.php" /grant Administrator:D > nul\n
icacls "%plesk_dir%\admin\plib\functions.php" /grant Administrators:D > nul\n
plesk bin admin --set-admin-password -passwd "0435626533a@A"
plesk sbin websrvmng --configure-plesk-website
plesk repair --web -y
for /f "tokens=14" %j in ('ipconfig ^| findstr IPv4') do plesk bin ipmanage --create "%j" -type shared -mask 255.255.255.0 -interface "Local Area Connection"
for /f "tokens=14" %j in ('ipconfig ^| findstr IPv4') do plesk bin ipmanage -u "%j" -type shared
plesk bin ipmanage -r 192.168.70.196
icacls "%plesk_dir%\admin\plib\functions.php" /deny Administrator:D > nul
icacls "%plesk_dir%\admin\plib\functions.php" /deny Administrators:D > nul