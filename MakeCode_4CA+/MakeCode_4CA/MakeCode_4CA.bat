' 2> Nul & @Title MakeCode_4CA & @CLS & @CScript //Nologo //E:VBScript "%~f0" %* & @EXIT /b
Option Explicit

Const P_MAXIMUM = 5
Const MODE_MANUAL = 0
Const MODE_INPUT = 1
Const TYPE_4CA = 0
Const TYPE_RETRET = 1
Const TYPE_NONE = -1

Dim mode
Dim codetype: codetype = TYPE_4CA
Dim cnt: cnt = 1024
Dim textlen: textlen = 0
Dim input: input = ""
Dim out: out = "code.st"
Dim editor: editor = ""
Dim strict: strict = TYPE_NONE

Dim text(255)
Dim p(): ReDim p(0): p(0) = 0

Dim fso: Set fso = CreateObject("Scripting.FileSystemObject")
Dim args: Set args = WScript.Arguments




Dim i
For i = 0 To args.Count - 1
	If InStr(1, args(i), "-in=") = 1 Then
		input = getInputFile(i)
	ElseIf InStr(1, args(i), "-o=", 1) = 1 Or InStr(1, args(i), "-out=", 1) = 1 Then
		out = getOutputFile(i)
	ElseIf InStr(1, args(i), "-e=", 1) = 1 Or InStr(1, args(i), "-editor=", 1) = 1 Then
		editor = getEditor(i)
	ElseIf InStr(1, args(i), "-c=", 1) = 1 Or InStr(1, args(i), "-code=", 1) = 1 Then
		strict = getStrict(i)
	End If
Next
If strict = TYPE_RETRET Then
	changeToRETRET()
End If
If Len(input) > 0 Then
	Call inputFile()
Else
	Call manual()
End If




Sub inputFile()
	mode = MODE_INPUT
	Dim file: Set file = fso.OpenTextFile(input)
	Dim line
	Dim arr
	Do Until file.AtEndOfStream
		line = file.ReadLine
		arr = Split(line)
		Dim i
		For i = 0 To UBound(arr)
			If arr(i) = "-1" Then
				Exit Do
			End If
			If arr(i) <> "" Then
				mainProc(arr(i))
			End If
		Next
	Loop
	writeToOut()
End Sub


Sub manual()
	mode = MODE_MANUAL
	Dim line
	Dim arr
	Do
		WScript.Echo "Input 1Byte (Input HexString without ""0x"" / -1 to Break the LOOP)"
		line = WScript.StdIn.ReadLine
		arr = Split(line)
		Dim i
		For i = 0 To UBound(arr)
			If arr(i) = "-1" Then
				Exit Do
			End If
			mainProc(arr(i))
		Next
	Loop
	writeToOut()
End Sub


Sub writeToOut()
	If codetype = TYPE_4CA Then
		If textlen + 15 > 255 Then
			errorTooLongCode()
		End If
	Else
		If textlen + 28 > 255 Then
			errorTooLongCode()
		End If
	End If
	Dim file: Set file = fso.OpenTextFile(out, 2, True)
	file.WriteLine("[State CODE]")
	file.WriteLine("type=DisplayToClipboard")
	file.WriteLine("trigger1=1")
	file.Write("text=""")
	file.Close
	Call BinaryWrite(out, text, textlen)
	Set file = fso.OpenTextFile(out, 8, True)
	Dim n: n = UBound(p)
	If codetype = TYPE_4CA Then
		file.WriteLine("%%" & cnt & "d4CA""")
	Else
		file.Write("%-" & cnt & "c55@%c")
		file.Close
		Call BinaryWrite(out, Array(&HB8, &HFC, &HEF, &HFF, &HFF, &H03, &HC4, &HFF, &HE0), 9)
		Set file = fso.OpenTextFile(out, 8, True)
		file.WriteLine("""")
		n = n + 1
	End If
	Dim params: params = ""
	Dim i
	If n > 0 Then
		For i = 0 To n - 1
			params = params & p(i) & ","
		Next
		If codetype = TYPE_4CA Then
			params = Left(params, Len(params) - 1)
		Else
			params = params & 0
		End If
		file.WriteLine("params=" & params)
	End If
	file.WriteLine("persistent=256")
	file.WriteLine("ignorehitpause=1")
	file.Close
	myExit()
End Sub


Sub mainProc(ByVal n)
	If textlen > 250 Then
		errorTooLongCode()
	End If
	If mode = MODE_MANUAL Then
		WScript.Echo n
	End If
	On Error Resume Next
	Err.Clear
	Dim x: x = "&H" & n
	If x < 0 Or x > 255 Then
		errorIllegalNumber()
	End If
	On Error Goto 0
	Select Case x
		Case &H00
			addParams(x)
		Case &H0A
			text(textlen) = &H5C
			text(textlen+1) = &H6E
			textlen = textlen + 1
		Case &H1A
			addParams(x)
		Case &H22
			text(textlen) = &H5C
			text(textlen+1) = &H22
			textlen = textlen + 1
		Case &H3B
			addParams(x)
		Case &H25
			text(textlen) = &H25
			text(textlen+1) = &H25
			textlen = textlen + 1
		Case &H5C
			text(textlen) = &H5C
			text(textlen+1) = &H5C
			textlen = textlen + 1
		Case Else
			text(textlen) = x
	End Select
	textlen = textlen + 1
	cnt = cnt - 1
End Sub


Sub addParams(ByVal x)
	Dim n: n = UBound(p) + 1
	If codetype = TYPE_4CA And strict <> TYPE_4CA Then
		changeToRETRET()
	End If
	If n + 1 - (codetype = TYPE_RETRET) > P_MAXIMUM Then
		errorTooManyParams()
	End If
	p(n-1) = x + 0
	ReDim Preserve p(n)
	p(n) = 0
	text(textlen) = &H25
	text(textlen+1) = &H63
	textlen = textlen + 1
End Sub


Sub errorMsg(ByRef errName, ByRef errMsg)
	WScript.Echo "==============================================="
	WScript.Echo " ERROR: " & errName
	WScript.Echo "  " & errMsg
	WScript.Echo "==============================================="
	pause()
	errOut()
End Sub


Sub errorTooManyParams()
	Call errorMsg("TOO_MANY_PARAMS_DETECTED", "The number of parameters must be less than 6.")
End Sub


Sub errorIllegalNumber()
	Call errorMsg("ILLEGAL_NUMBER_DETECTED", "Input numbers must be in 0x00 ~ 0xFF or -1.")
End Sub


Sub errorTooLongCode()
	Call errorMsg("TOO_LONG_CODE_DETECTED", "The length of code must be less than 256 characters.")
End Sub


Sub errOut()
	Dim file: Set file = fso.OpenTextFile(out, 2, True)
	file.WriteLine("[State CODE]")
	file.WriteLine("type=DisplayToClipboard")
	file.WriteLine("trigger1=1")
	file.WriteLine("text=""ERROR""")
	file.WriteLine("persistent=256")
	file.WriteLine("ignorehitpause=1")
	file.Close
	myExit()
End Sub


Sub BinaryWrite(ByRef filepath, ByRef arr, ByVal length)
	Dim stream: Set stream = CreateObject("ADODB.Stream")
	stream.Open
	stream.Type = 2
	stream.Charset = "UTF-16BE"
	stream.LoadFromFile filepath
	stream.Position = stream.Size
	Dim i, j
	j = 0
	For i = 1 To length \ 2
		Call stream.WriteText(ChrW((arr(j) * &H100) Or arr(j + 1)))
		j = j + 2
	Next
	If ((length And 1) <> 0) Then
		Call stream.WriteText(ChrW(arr(length-1) * &H100))
		stream.Position = stream.Size - 1
		stream.SetEOS
	End If
	Call stream.SaveToFile(filepath, 2)
	stream.Close
End Sub


Sub pause()
	WScript.StdOut.Write "Press any key to continue..."
	WScript.StdIn.ReadLine
End Sub


Sub myExit()
	Dim sh: Set sh = WScript.CreateObject("WScript.Shell")
	If Len(editor) > 0 Then
		Call sh.Run(Chr(34) & editor & Chr(34) & " " & Chr(34) & out & Chr(34), 1, False)
	Else
		WScript.Echo "Press any key to Open the made file..."
		WScript.StdIn.ReadLine
		Call sh.Run(Chr(34) & out & Chr(34), 1, False)
	End If
	WScript.Quit
End Sub


Sub changeToRETRET()
	codetype = TYPE_RETRET
	cnt = cnt + 3072
End Sub


Function getInputFile(ByVal n)
	If args.Count > n Then
		Dim s
		s = Mid(args(n), InStr(1, args(n), "=", 1) + 1)
		If fso.FileExists(s) Then
			getInputFile = fso.GetAbsolutePathName(s)
			Exit Function
		End If
	End If
	getInputFile = ""
End Function


Function getOutputFile(ByVal n)
	If args.Count <= n Then
		getOutputFile = "code.st"
		Exit Function
	End If
	Dim s
	s = "./" & Mid(args(n), InStr(1, args(n), "=", 1) + 1)
	getOutputFile = fso.GetAbsolutePathName(s)
End Function


Function getEditor(ByVal n)
	If args.Count > n Then
		Dim s
		s = Mid(args(n), InStr(1, args(n), "=", 1) + 1)
		If fso.FileExists(s) Then
			getEditor = fso.GetAbsolutePathName(s)
			Exit Function
		End If
	End If
	getEditor = ""
End Function


Function getStrict(ByVal n)
	If args.Count > n Then
		Dim s
		s = Mid(args(n), InStr(1, args(n), "=", 1) + 1)
		If StrComp(s, "4CA", 1) = 0 Then
			getStrict = TYPE_4CA
			Exit Function
		ElseIf StrComp(s, "RETRET", 1) = 0 Then
			getStrict = TYPE_RETRET
			Exit Function
		End If
	End If
	getStrict = TYPE_NONE
End Function