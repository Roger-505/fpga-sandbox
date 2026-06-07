@echo off
REM ************************************************************************************************
REM ** Call syntax: cleanup.cmd
REM ** This script deletes all the directories and files, except *.cmd next to the
REM ** cleanup script. Use it to remove previous build results.
REM ************************************************************************************************

rem delete all files from subfolders
for /d /r %%i in (%~dp0*) do del /f /q %%i\*
rem delete all subfolders
for /d %%i in (%~dp0*) do rd /S /Q %%i

rem unmark read only from all files
attrib -R %~dp0* /S

rem mark read only those we wish to keep
attrib +R %~dp0*.cmd

rem delete all non read-only
del /Q /A:-R %~dp0*

rem unmark read-only
attrib -R %~dp0*

