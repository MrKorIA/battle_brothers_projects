@echo off
REM Обертка для IDEA: упаковывает мод через общий build.sh монорепозитория
"C:\Program Files\Git\bin\bash.exe" "%~dp0..\build.sh" "zmod_davkul_rising-russian.zip" "%~dp0."
