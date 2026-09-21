@echo off
REM ==================================================================
REM  FlaechenKlar Start-Diagnose
REM  Macht sichtbar, warum FlaechenKlar.bat nichts oeffnet.
REM  Schreibt FK-Diagnose.txt in denselben Ordner.
REM ==================================================================
setlocal
set "LOG=%~dp0FK-Diagnose.txt"

echo FlaechenKlar Start-Diagnose
echo ========================================
echo.
echo Ordner: %~dp0
echo.

> "%LOG%" echo FlaechenKlar Start-Diagnose
>>"%LOG%" echo Datum: %DATE% %TIME%
>>"%LOG%" echo Ordner: %~dp0
>>"%LOG%" echo.

echo [1/6] Dateien im Ordner
>>"%LOG%" echo [1/6] Dateien im Ordner
for %%F in (launcher.ps1 update.ps1 update.bat start.html index.html version.txt) do (
  if exist "%~dp0%%F" (
    echo    OK      %%F
    >>"%LOG%" echo    OK      %%F
  ) else (
    echo    FEHLT   %%F
    >>"%LOG%" echo    FEHLT   %%F
  )
)
echo.
>>"%LOG%" echo.

echo [2/6] Ist powershell.exe startbar?
>>"%LOG%" echo [2/6] Ist powershell.exe startbar?
powershell.exe -NoProfile -Command "exit 7" >nul 2>&1
if "%ERRORLEVEL%"=="7" (
  echo    OK      powershell.exe laeuft
  >>"%LOG%" echo    OK      powershell.exe laeuft
) else (
  echo    PROBLEM powershell.exe startet nicht oder wird blockiert ^(Code %ERRORLEVEL%^)
  >>"%LOG%" echo    PROBLEM powershell.exe startet nicht oder wird blockiert, Code %ERRORLEVEL%
)
echo.
>>"%LOG%" echo.

echo [3/6] Ausfuehrungsrichtlinie ^(ExecutionPolicy^)
>>"%LOG%" echo [3/6] Ausfuehrungsrichtlinie (ExecutionPolicy)
powershell.exe -NoProfile -Command "Get-ExecutionPolicy -List | Format-Table -AutoSize | Out-String" > "%TEMP%\fkdiag_ep.txt" 2>&1
type "%TEMP%\fkdiag_ep.txt"
type "%TEMP%\fkdiag_ep.txt" >>"%LOG%"
echo.
>>"%LOG%" echo.

echo [4/6] Zonen-Markierung ^(Datei aus dem Internet / Netzlaufwerk^)
>>"%LOG%" echo [4/6] Zonen-Markierung
powershell.exe -NoProfile -Command "$d='%~dp0'; foreach($n in @('FlaechenKlar.bat','launcher.ps1','update.ps1')){ $p=Join-Path $d $n; if(Test-Path -LiteralPath $p){ $z=Get-Content -LiteralPath $p -Stream Zone.Identifier -ErrorAction SilentlyContinue; if($z){ $zid=($z | Select-String 'ZoneId').ToString(); Write-Output ('   MARKIERT ' + $n + '  (' + $zid.Trim() + ')') } else { Write-Output ('   frei     ' + $n) } } }; Write-Output ('   Laufwerkstyp: ' + (Split-Path $d -Qualifier))" > "%TEMP%\fkdiag_zone.txt" 2>&1
type "%TEMP%\fkdiag_zone.txt"
type "%TEMP%\fkdiag_zone.txt" >>"%LOG%"
echo.
>>"%LOG%" echo.

echo [5/6] Dateizuordnung fuer .html
>>"%LOG%" echo [5/6] Dateizuordnung fuer .html
powershell.exe -NoProfile -Command "try{ $k=(Get-ItemProperty 'HKCU:\SOFTWARE\Microsoft\Windows\Shell\Associations\UrlAssociations\http\UserChoice' -ErrorAction Stop).ProgId; Write-Output ('   Standardbrowser: ' + $k) }catch{ Write-Output '   Standardbrowser: NICHT ERMITTELBAR' }; cmd /c assoc .html 2>&1 | ForEach-Object { '   ' + $_ }" > "%TEMP%\fkdiag_assoc.txt" 2>&1
type "%TEMP%\fkdiag_assoc.txt"
type "%TEMP%\fkdiag_assoc.txt" >>"%LOG%"
echo.
>>"%LOG%" echo.

echo [6/6] launcher.ps1 SICHTBAR starten ^(hier kommt die echte Fehlermeldung^)
echo ----------------------------------------------------------------
>>"%LOG%" echo [6/6] launcher.ps1 sichtbar gestartet - Ausgabe:
powershell.exe -NoProfile -ExecutionPolicy Bypass -File "%~dp0launcher.ps1" > "%TEMP%\fkdiag_run.txt" 2>&1
set "RC=%ERRORLEVEL%"
type "%TEMP%\fkdiag_run.txt"
type "%TEMP%\fkdiag_run.txt" >>"%LOG%"
echo ----------------------------------------------------------------
echo Rueckgabewert: %RC%
>>"%LOG%" echo Rueckgabewert: %RC%
echo.
>>"%LOG%" echo.

del "%TEMP%\fkdiag_ep.txt" "%TEMP%\fkdiag_zone.txt" "%TEMP%\fkdiag_assoc.txt" "%TEMP%\fkdiag_run.txt" >nul 2>&1

echo ================================================================
echo Bericht gespeichert: %LOG%
echo Bitte diese Datei per Mail an info@flaechenklar.de senden.
echo ================================================================
echo.
pause
endlocal
