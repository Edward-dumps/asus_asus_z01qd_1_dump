@ECHO OFF

REM Version:	V01
REM Date:	20190312

REM ============== setting ==============

CLS

call:erase

pause
EXIT 0
rem goto END

REM ============== erase() ==============
:erase

ECHO "fastboot format asdf "
fastboot format asdf
echo errorlevel="%ERRORLEVEL%"
IF "%ERRORLEVEL%" == "1" (
	ECHO "FAILED: fastboot format asdf failure, EXIT!"
	GOTO:EOF
)
ECHO "Success: fastboot format asdf!"
ECHO "fastboot erase asuskey3"
fastboot erase asuskey3
echo errorlevel="%ERRORLEVEL%"
IF "%ERRORLEVEL%" == "0" (
	ECHO "Success: fastboot erase asuskey3 , EXIT!"
	ECHO "Device reboot!"
	fastboot reboot
	GOTO:EOF
)
ECHO "FAILED: fastboot erase asuskey3 failure, EXIT!"
GOTO:EOF

:END
