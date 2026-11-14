@echo off
cd /d "%~dp0.."
call mvnw.cmd compile exec:java "-Dexec.mainClass=vn.iotstar.config.JpaSmokeTest"
pause
