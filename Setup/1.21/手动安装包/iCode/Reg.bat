@echo off
for /f "delims=" %%i in ('dir *.dll /b /s') do regsvr32 /s "%%i"&&echo.�ɹ�ע�� %%i
for /f "delims=" %%i in ('dir *.ocx /b /s') do regsvr32 /s "%%i"&&echo.�ɹ�ע�� %%i