@echo off
tskill wgatray
ren %SystemRoot%\system32\WgaLogon.dll backup_WgaLogon.dll
ren %SystemRoot%\system32\WgaTray.exe backup_WgaTray.exe
ren %SystemRoot%\system32\DllCache\WgaLogon.dll backup_WgaLogon.dll
ren %SystemRoot%\system32\DllCache\WgaTray.exe backup_gaTray.exe

echo All Done!

pause
