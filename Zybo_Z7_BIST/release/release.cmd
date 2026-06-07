@echo off
REM ************************************************************************************************
REM ** Call syntax: release.cmd
REM ** Return code: 0 on success, non-zero on failure.
REM ** This script is used to create release binaries for all the Vivado projects in the repo.
REM ** Release binaries are copied to the "packet" directory created next to the script.
REM ** It also creates a build<i> directory where temporary build files are stored.
REM ** It calls build scripts specific to each project in the repo.
REM ************************************************************************************************

setlocal EnableDelayedExpansion

if not exist %~dp0packet mkdir %~dp0packet

rem Specify multiple projects like this: ("%~dp0..\bist" "%~dp0..\demo")
set PROJECTS=("%~dp0..\z20\bist", "%~dp0..\z10\bist", "%~dp0..\z20\demo", "%~dp0..\z10\demo", "%~dp0..\z20\cetest")
rem set PROJECTS=("%~dp0..\z20\bist", "%~dp0..\z10\bist")

echo *** release: started ***

set I=0
for %%x in %PROJECTS% do (
	FOR /f "tokens=1,2 delims=.." %%a IN ("%%x") do set var1=%%a&set var2=%%b&set var3="\sdk"
	
	set folder=!var1!!var2!!var3!
	echo !folder! 
	mkdir !folder!	 
	pushd !folder! 
	rem Project-specific hardware image build script
	call %%x\src\others\build_image.cmd %~dp0packet
	popd
	if %ERRORLEVEL% NEQ 0 goto fail
	set /a I=!I!+1
)

goto end
goto end
:fail
echo Could not copy all the release files to packet.
exit /b %ERRORLEVEL%

:end
echo *** release: done ***
exit /b 0