Option Explicit

Const adTypeBinary = 1, adSaveCreateOverWrite = 2
Dim fso, adostream, xmldom, node
Dim Key, FileIn, FileOut, Buffer
Dim ByteTable(256)

On Error Resume Next
Set fso = CreateObject("Scripting.FileSystemObject")
If err.number <> 0 Then
	WScript.Echo("Failed to create Scripting.FileSystemObject object. " & err.Description & ".")
	WScript.Quit
End If

If WScript.Arguments.Count < 3 Then
	WScript.Echo("Too few arguments.")
	WScript.Echo("Usage: XorCrypt.vbs <Key> <FileIn> <FileOut>")
	WScript.Echo("Note: <Key> is a byte.")
	WScript.Quit
Else
	Key = CByte(WScript.Arguments(0))
	If err.number <> 0 Then
		WScript.Echo("Invalid key.")
		WScript.Quit
	End If
	FileIn = WScript.Arguments(1)
	FileOut = WScript.Arguments(2)
End If

Set xmldom = CreateObject("Msxml2.DOMDocument")
If err.number <>0 Then
	WScript.Echo("Failed to create Msxml2.DOMDocument object. " & err.Description & ".")
	WScript.Quit
End If
Set adostream = CreateObject("ADODB.Stream")
If err.number <>0 Then
	WScript.Echo("Failed to create ADODB.Stream object. " & err.Description & ".")
	WScript.Quit
End If

Set node = xmldom.CreateElement("binary")
node.DataType = "bin.hex"
Dim i, char
For i = 0 To UBound(ByteTable)
	char = Hex(i)
	If Len(char) = 1 Then char = "0" & char
	node.text = char
	ByteTable(i) = node.nodeTypedValue
Next

adostream.Type = adTypeBinary
adostream.Open
adostream.LoadFromFile FileIn
If err.number <> 0 Then
	WScript.Echo("Failed to open " & FileIn & " " & err.Description & ".")
	WScript.Quit
End If
Buffer = adostream.Read
adostream.Close
adostream.Type = adTypeBinary
adostream.Open
Dim bByte, bByteXored
For i = 1 To LenB(Buffer)
	bByte = AscB(MidB(Buffer, i, 1))
	bByteXored = bByte Xor CByte(Key)
	adostream.Write ByteTable(bByteXored)
Next
adostream.SaveToFile FileOut, adSaveCreateOverWrite
If err.number <> 0 Then
	WScript.Echo("Failed to open " & FileOut & " " & err.Description & ".")
	WScript.Quit
End If
adostream.Close
Set xmldom = Nothing
Set adostream = Nothing
Set node = Nothing
Set fso = Nothing
WScript.Echo(FileIn & " is xored with key " & Key & " and saved as " & FileOut)
