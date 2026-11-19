@echo off
REM Обертка для IDEA: пересобирает отредактированные спрайты (bbrusher) и упаковывает мод
"C:\Program Files\Git\bin\bash.exe" "%~dp0..\build_brushes.sh" "mod_nggh_magic_concept-russian.zip" "%~dp0."
