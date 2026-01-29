@echo off
setlocal

REM =========================
REM Paths
REM =========================
set SRC_DIR=C:\R\padd_reports
set DEST_DIR=C:\R\phl

REM =========================
REM Ensure destination exists
REM =========================
if not exist "%DEST_DIR%" (
    echo Destination repo does not exist
    exit /b 1
)

REM =========================
REM Copy files
REM =========================
copy /Y "%SRC_DIR%\eia_padd_1_mogas_snd.html" "%DEST_DIR%\"
copy /Y "%SRC_DIR%\eia_report.html" "%DEST_DIR%\"

REM Copy entire assets directory
xcopy "%SRC_DIR%\eia_report_files\*" "%DEST_DIR%\eia_report_files\" /E /I /Y >nul

REM =========================
REM Git: one combined commit
REM =========================
cd /d "%DEST_DIR%" || exit /b 1

REM Stage *all* changes (new, modified, deleted)
git add -A

REM Commit only if there are changes
git diff --cached --quiet
if %errorlevel%==0 (
    echo No changes to commit
    exit /b 0
)

git commit -m "Update EIA reports and assets"
git push

endlocal
