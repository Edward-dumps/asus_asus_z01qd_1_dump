@ECHO OFF

REM Version:	V01
REM Date:	20190312

REM ============== setting ==============

CLS

IF [%1] EQU [] (
    ECHO "FAILED: NO FLASH FILE"
    pause
    EXIT 0
)
IF NOT [%1] EQU [] (
    SET FILE=%1
)

call:flash

pause
EXIT 0
rem goto END

REM ============== flash() ==============
:flash

ECHO "fastboot flash asuskey3 %FILE% "
fastboot flash asuskey3 %FILE%
echo errorlevel="%ERRORLEVEL%"
IF "%ERRORLEVEL%" == "0" (
	ECHO "Success: fastboot flash asuskey3 %FILE% , EXIT!"
	ECHO "Device reboot!"
	fastboot reboot
	GOTO:EOF
)
ECHO "FAILED: fastboot flash asuskey3 %FILE% failure, EXIT!"
GOTO:EOF

:END
