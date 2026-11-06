@echo off
REM Обертка для IDEA: пересобирает отредактированные спрайты (bbrusher) и упаковывает мод
"C:\Program Files\Git\bin\bash.exe" "%~dp0..\build_brushes.sh" "zmod_davkul_rising-russian.zip" "%~dp0."
