@echo off
setlocal enabledelayedexpansion

chcp 850 > nul

set out=code.st
set text=
set params=
set /a cnt=1024
set /a pCnt=1
set /a p1=0
set /a p2=0
set /a p3=0
set /a p4=0
set /a p5=0

if "%~1%"=="" goto MANUAL
set out=./%2%
if not "%~2%"=="" (
	set out=./%2%
)
if exist %1% goto INPUT_FILE
goto MANUAL


:WRITE_TO_OUT
	echo [State CODE]>%out%
	echo type=DisplayToClipboard>>%out%
	(echo trigger1=1)>>%out%
	echo %text%>temp
	certutil -f -decodehex temp temp.txt > nul
	set text=
	for /f "delims= eol=" %%i in (temp.txt) do (
		set text=!text!%%i
	)
	if %cnt% leq 1024 (
		echo text="%text%%%%cnt%d4CA">>%out%
	) else (
		set ret=66B803100FB7C0F7D0034424FCFFE0
		echo !ret!>temp
		certutil -f -decodehex temp temp.txt > nul
		set ret=
		for /f "delims= eol=" %%i in (temp.txt) do (
			set ret=!ret!%%i
		)
		echo text="!text!%%%cnt%d55@%%c!ret!">>%out%
	)
	if exist temp del temp
	if exist temp.txt del temp.txt
	for /l %%i in (1,1,%pCnt%) do (
		set params=!params!!p%%i!
		if %%i neq %pCnt% set params=!params!,
	)
	if %cnt% gtr 1024 set params=%params%,0
	(echo params=%params%)>>%out%
	echo persistent=256>>%out%
	(echo ignorehitpause=1)>>%out%
	if "%~3%"=="" (
		set /p nul="Press any key to Open the made file..."
		start %out%
		exit /b
	)
	set editor=%~3%
	start "" "%editor%" "%out%
	exit

:MANUAL
	:LOOP
		echo Input 1Byte (Input HexString without "0x" / -1 to Break the LOOP);
		set /p line=">"
		for %%n in (%line%) do (
			if %%n equ -1 goto LOOP_END
			call :MAIN %%n
		)
	goto LOOP
	:LOOP_END
	goto WRITE_TO_OUT

:INPUT_FILE
	for /f "delims=" %%i in (%1%) do (
		for %%n in (%%i) do (
			if %%n equ -1 goto EOF
			call :MAIN %%n
		)
	)
	:EOF
	goto WRITE_TO_OUT

:MAIN
	if "%out%" == "output.txt" (
		echo %1%
	)
	set /a x=0x%1%
	if !x! lss 0 goto ERROR_ILLEGAL_NUMBER
	if !x! gtr 255 goto ERROR_ILLEGAL_NUMBER
	if !x! equ 00 (
		call :ADD_PARAMS %1%
	) else if !x! equ 0x0A (
		call :ADD_PARAMS %1%
	) else if !x! equ 0x1A (
		call :ADD_PARAMS %1%
	) else if !x! equ 0x22 (
		call :ADD_PARAMS %1%
	) else if !x! equ 0x3B (
		call :ADD_PARAMS %1%
	) else if !x! equ 0x21 (
		call :ADD_PARAMS %1%
	) else if !x! equ 0x25 (
		set text=!text!2525
		set /a cnt=!cnt!-1
	) else if !x! equ 0x5E (
		set text=!text!5E5E
		set /a cnt=!cnt!-1
	) else (
		set text=!text!%1%
		set /a cnt=!cnt!-1
	)
	exit /b


:ADD_PARAMS
	if !pCnt! equ 5 goto ERROR_TOO_MANY_PARAMS
	if !pCnt! equ 1 set /a cnt=!cnt!+3072
	set /a p!pCnt!=0x%1%
	set /a pCnt=!pCnt!+1
	set text=!text!2563
	set /a cnt=!cnt!-1
	exit /b


:ERROR_TOO_MANY_PARAMS
	echo ERROR:TOO_MANY_PARAMS
	echo The number of parameters must be less than 6.
	pause
	goto WRITE_TO_OUT

:ERROR_ILLEGAL_NUMBER
	echo ERROR:ILLEGAL_NUMBER_DETECTED
	echo The input number must be in 0x00 ~ 0xFF or -1.
	pause
	goto WRITE_TO_OUT
