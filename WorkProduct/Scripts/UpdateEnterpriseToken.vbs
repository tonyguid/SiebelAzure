Dim sInputFile, sNewPwd
Dim oFSO, oInFile, oOutFile
Dim bChangeNext
Dim sLine, sFirstWord, dNow, sDatetimestamp
Dim stdout

sInputFile = WScript.Arguments.Item(0)
sNewPwd = WScript.Arguments.Item(1)

Set oFSO = CreateObject("Scripting.FileSystemObject")
Set oInFile = oFSO.OpenTextFile(sInputFile) 
On Error Resume Next
oFSO.DeleteFile sInputFile + ".tmp"
Set oOutFile = oFSO.CreateTextFile(sInputFile + ".tmp", True)

bChangeNext = False
Do Until oInFile.AtEndOfStream	
  sLine = oInFile.ReadLine
  sFirstWord = Trim(StringPart(sLine, "=", 1))
  If (sFirstWord = "SiebEntSecToken") Then
 	sLine = "SiebEntSecToken = " & sNewPwd
  End If
  oOutFile.WriteLine sLine
Loop

oInFile.Close
oOutFile.Close

dNow = Now
sDatetimestamp = CStr(Year(dNow)) + "-" + CStr(Month(dNow)) + "-" + CStr(Day(dNow)) + "-" + CStr(Hour(dNow)) + "-" + CStr(Minute(dNow)) + "-" + CStr(Second(dNow))
oFSO.MoveFile sInputFile, StringPart(sInputFile, ".", 1) + sDatetimestamp + ".bak"
oFSO.MoveFile sInputFile + ".tmp", sInputFile
Set oFSO = Nothing

Function StringPart(sString, sDelim, nPart)
    Dim nPos
    Dim nCurPart
    Dim nLen
    Dim sRetVal
    
    'Seed the values
    nCurPart = 1
    nPos = 1
    nLen = Len(sString)
    
    'First, find the indicator stating that we have the beginning of the part
    While (nCurPart < nPart) And (nPos <= nLen)
        If (Mid(sString, nPos, Len(sDelim)) = sDelim) Then
            nCurPart = nCurPart + 1
            nPos = nPos + Len(sDelim)
        Else
            nPos = nPos + 1
        End If
    Wend
    
    'Add characters until we get to another delimiter or the end of the string
    sRetVal = ""
    If (nCurPart = nPart) Then      'We may not have had enough pieces; if so, we will return ""
        While (nPos <= nLen) And (Mid(sString, nPos, Len(sDelim)) <> sDelim)
            sRetVal = sRetVal & Mid(sString, nPos, 1)
            nPos = nPos + 1
        Wend
    End If
    
    'Set the return value
    StringPart = sRetVal
End Function
