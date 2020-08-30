Option Explicit

Const adTypeBinary = 1, adSaveCreateOverWrite = 2
Dim adostream, xmldom, node
Dim Key, FileIn, FileOut, Buffer
Dim ByteTable(256)

Set adostream = CreateObject("ADODB.Stream")
Set xmldom = CreateObject("MSXML2.DOMDocument")

Select Case WScript.Arguments.Count
Case 1
	If WScript.Arguments.Item(0) = "/?" Then
		WScript.Echo("Usage: XorCrypt Key FileIn FileOut")
		WScript.Echo("Note: Key is a byte.")
		WScript.Quit
	Else
		WScript.Echo("Too few arguments.")
		WScript.Quit 1
	End If
Case Else
	If WScript.Arguments.Count < 3 Then
		WScript.Echo("Too few arguments.")
		WScript.Quit 1
	End if
End Select

On Error Resume Next
Key = CByte(WScript.Arguments(0))
If err.number <> 0 Then
	WScript.Echo("Invalid key.")
	WScript.Quit 1
End If
On Error Goto 0
FileIn = WScript.Arguments(1)
FileOut = WScript.Arguments(2)

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
adostream.Close
Set xmldom = Nothing
Set adostream = Nothing
Set node = Nothing

WScript.Echo(FileIn & " is xor-ed with key " & Key & " and saved as " & FileOut)
