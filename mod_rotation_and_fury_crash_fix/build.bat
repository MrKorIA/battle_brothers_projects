@echo off
REM Обертка для IDEA: упаковывает мод через общий build.sh монорепозитория
"C:\Program Files\Git\bin\bash.exe" "%~dp0..\build.sh" "mod_rotation_and_fury_crash_fix.zip" "%~dp0."
