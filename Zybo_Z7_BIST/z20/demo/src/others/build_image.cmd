@echo off
REM ************************************************************************************************
REM ** Call syntax: build_image.cmd <target_dir>
REM ** Return code: 0 on success, non-zero on failure.
REM ** This script builds all the release binaries of the project creating temporary files in the
REM ** WORKING DIRECTORY. Final release binaries are copied to the path specified by <target_dir>.
REM ************************************************************************************************

setlocal EnableDelayedExpansion

if %1.==. (
   echo "Usage build_image <path to target dir>"
   goto fail
)

set TO_BIN=("%~dp0demo.bif")
set TO_COPY=()

set ERRORLEVEL=

WHERE xsct.bat >nul 2>nul
IF %ERRORLEVEL% NEQ 0 goto nosdk

echo *** building all projects ***
call xsct.bat %~dp0\sdk_build_all.tcl
rem I had to separate this tcl into two, because of Xilinx

rem Workaround for whoknowswhatbug
rem This will delete BSP sources from next to MSS files
FOR /R "."\ %%b IN (*.mss) DO (
   call :dirname_from_path result %%b
   FOR /D %%d IN (!result!*) DO (
      echo Deleting %%d
      rd /S /Q %%d
   )
)
call xsct.bat %~dp0\sdk_build_all_2.tcl
if %ERRORLEVEL% NEQ 0 goto fail

rem File for Audio demo used in both z10 and z20 
rem copied in common folder in z20 demo build batch
rem deleted from common folder in z10 demo build batch 
copy /Y %~dp0\morning_mood.raw %1\

echo *** building bin files ***
for %%x in %TO_BIN% do (
   echo ** %%x **
   if not exist %%x goto notfound
   
   rem Get file name portion of the path
   call :filename_from_path result %%x
   if %ERRORLEVEL% NEQ 0 goto bootgenerr
   call bootgen -image %%x -o "%1\img3_z20.bin" -w on
   if %ERRORLEVEL% NEQ 0 goto bootgenerr
)

echo *** copying files ***
for %%x in %TO_COPY% do (
   if not exist %%x (
      echo %%x was not found.
      goto notfound
   )
)

for %%x in %TO_COPY% do (
   copy /Y %%x %1\
   if %ERRORLEVEL% NEQ 0 goto fail
)
goto success

:nosdk
echo Did not find SDK xsct.bat command. Do you have it added to the PATH environment variable? Check below:
echo %PATH%
goto fail

:notfound
echo Some required files were not found during the build process.
goto fail

:bootgenerr
:fail
echo *** error building bin files ***
exit /b 1

:success
echo *** building successful ***
goto end

:filename_from_path <resultVar> <pathVar>
(
   set "%~1=%~n2"
   exit /b
)

:dirname_from_path <resultVar> <pathVar>
(
   set "%~1=%~dp2"
   exit /b
)

:end
exit /b 0
