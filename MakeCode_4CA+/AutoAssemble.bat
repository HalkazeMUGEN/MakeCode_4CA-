@echo off
setlocal enabledelayedexpansion

set in=input.txt
set out=output.txt
set code=code.st
set list=NASM\list.txt

if not exist NASM\nasm.exe (
	echo ERROR:NO_NASM
	goto EXIT
)

echo BITS 32>in
echo section .text>>in
echo 	global _start>>in
echo _start:>>in
type %in%>>in

NASM\nasm in -o bin -l %list%
del in
if not exist bin (
	echo If you need more detailed information, please check "%list%".
	goto EXIT
)

certutil -f -encodehex bin hex 4 >nul
del bin

if not exist hex goto EXIT

:MAIN
	if exist %out% del %out%
	for /f "delims=" %%i in (hex) do (
		set text=
		for %%a in (%%i) do (
			set text=!text!%%a 
		)
		echo !text!>>%out%
	)
	del hex
	if exist MakeCode_4CA MakeCode_4CA\MakeCode_4CA.bat %out% %code%
	pause
	exit /B

:EXIT
	pause
	exit /B