:: Author: debiedowner

@echo off

REM make current directory work when run as administrator
cd "%~dp0"

set installPath="%LOCALAPPDATA%\Vivaldi\Application"
echo Searching at: %installPath%
for /f "tokens=*" %%a in ('dir /a:-d /b /s %installPath%') do (
	if "%%~nxa"=="browser.html" set latestVersionFolder=%%~dpa
)

if "%latestVersionFolder%"=="" (
	pause & exit
) else (
	echo Found latest version folder: "%latestVersionFolder%"
)

if not exist "%latestVersionFolder%\browser.bak.html" (
	echo Creating a backup of your original browser.html file.
	copy "%latestVersionFolder%\browser.html" "%latestVersionFolder%\browser.bak.html"
)

echo copying js files to custom.js
type *.js > "%latestVersionFolder%\custom.js"

echo patching browser.html file
type "%latestVersionFolder%\browser.bak.html" | findstr /v "</body>" | findstr /v "</html>" > "%latestVersionFolder%\browser.html"
echo     ^<script src="custom.js"^>^</script^> >> "%latestVersionFolder%\browser.html"
echo   ^</body^> >> "%latestVersionFolder%\browser.html"
echo ^</html^> >> "%latestVersionFolder%\browser.html"

pause
