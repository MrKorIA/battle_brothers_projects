@echo off
REM Обертка для IDEA: упаковывает мод через общий build.sh монорепозитория
"C:\Program Files\Git\bin\bash.exe" "%~dp0..\build.sh" "mod_legendary_kriegsgeist_location_legends-russian.zip" "%~dp0."
