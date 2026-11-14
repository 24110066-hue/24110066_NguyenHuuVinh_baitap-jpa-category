@echo off
cd /d "%~dp0.."
call mvnw.cmd test-compile exec:java "-Dexec.mainClass=vn.iotstar.dev.DevServer" "-Dexec.classpathScope=test" "-Dapp.db=h2"
pause
