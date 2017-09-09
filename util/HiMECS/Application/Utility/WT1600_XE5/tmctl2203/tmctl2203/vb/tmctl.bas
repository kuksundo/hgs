Attribute VB_Name = "tmctl"
' Visual Basic USB Control Function
' Yokogawa T&M

Public Const MaxStationNum = 128  ' 最大ステーション個数

Type DeviceList
        adr As String * 64        ' 名前
End Type

Type DeviceListArray
    list(MaxStationNum - 1) As DeviceList        ' ステーションリスト
End Type

Declare Function TmInitialize Lib "tmctl.dll" (ByVal wire As Long, ByVal adr As String, ByRef id As Long) As Long
Declare Function TmInitializeA Lib "tmctl.dll" Alias "TmInitialize" (ByVal wire As Long, ByVal adr As String, ByRef id As Long) As Long
Declare Function TmSetIFC Lib "tmctl.dll" (ByVal id As Long, ByVal tm As Long) As Long
Declare Function TmDeviceClear Lib "tmctl.dll" (ByVal id As Long) As Long
Declare Function TmSend Lib "tmctl.dll" (ByVal id As Long, ByVal msg As String) As Long
Declare Function TmSendByLen Lib "tmctl.dll" Alias "TmSendByLength" (ByVal id As Long, ByRef msg As Any, ByVal blen As Long) As Long
Declare Function TmSendSetup Lib "tmctl.dll" (ByVal id As Long) As Long
Declare Function TmSendOnlyBin Lib "tmctl.dll" Alias "TmSendOnly" (ByVal id As Long, ByRef msg As Any, ByVal blen As Long, ByVal ed As Long) As Long
Declare Function TmReceiveBin Lib "tmctl.dll" Alias "TmReceive" (ByVal id As Long, ByRef buf As Any, ByVal blen As Long, ByRef rlen As Long) As Long
Declare Function TmReceiveSetup Lib "tmctl.dll" (ByVal id As Long) As Long
Declare Function TmReceiveOnlyBin Lib "tmctl.dll" Alias "TmReceiveOnly" (ByVal id As Long, ByRef buf As Any, ByVal blen As Long, ByRef rlen As Long) As Long
Declare Function TmReceiveBlockHeader Lib "tmctl.dll" (ByVal id As Long, ByRef rlen As Long) As Long
Declare Function TmReceiveBlockData Lib "tmctl.dll" (ByVal id As Long, ByRef buf As Any, ByVal blen As Long, ByRef rlen As Long, ByRef ed As Long) As Long
Declare Function TmCheckEnd Lib "tmctl.dll" (ByVal id As Long) As Long
Declare Function TmSetCmd Lib "tmctl.dll" (ByVal id As Long, ByVal cmd As String) As Long
Declare Function TmSetRen Lib "tmctl.dll" (ByVal id As Long, ByVal flg As Long) As Long
Declare Function TmGetLastError Lib "tmctl.dll" (ByVal id As Long) As Long
Declare Function TmGetDetailLastError Lib "tmctl.dll" (ByVal id As Long) As Long
Declare Function TmCheckError Lib "tmctl.dll" (ByVal id As Long, ByVal sts As Long, ByVal msg As String, ByVal err As String) As Long
Declare Function TmSetTerm Lib "tmctl.dll" (ByVal id As Long, ByVal eos As Long, ByVal eot As Long) As Long
Declare Function TmSetEos Lib "tmctl.dll" (ByVal id As Long, ByVal eos As Long) As Long
Declare Function TmSetTimeout Lib "tmctl.dll" (ByVal id As Long, ByVal tmp As Long) As Long
Declare Function TmSetDma Lib "tmctl.dll" (ByVal id As Long, ByVal flg As Long) As Long
Declare Function TmGetStatusByte Lib "tmctl.dll" (ByVal id As Long, ByRef sts As Byte) As Long
Declare Function TmFinish Lib "tmctl.dll" (ByVal id As Long) As Long
Declare Function TmSearchDevices Lib "tmctl.dll" (ByVal wire As Long, list As DeviceListArray, ByVal max As Long, ByRef num As Long, ByVal option1 As String) As Long
Declare Function TmEncodeSerialNumber Lib "tmctl.dll" (ByVal encode As String, ByVal encodelen As Long, ByVal src As String) As Long
Declare Function TmDecodeSerialNumber Lib "tmctl.dll" (ByVal decode As String, ByVal decodelen As Long, ByVal src As String) As Long

Function TmReceive(ByVal id As Long, ByRef buf As String, ByVal blen As Long, ByRef rlen As Long)
    TmReceive = TmReceiveBin(id, ByVal buf, blen, rlen)
End Function

Function TmReceiveOnly(ByVal id As Long, ByRef buf As String, ByVal blen As Long, ByRef rlen As Long)
    TmReceiveOnly = TmReceiveOnlyBin(id, ByVal buf, blen, rlen)
End Function

Function TmReceiveBlock(ByVal id As Long, ByRef buf() As Integer, ByVal blen As Long, ByRef rlen As Long, ByRef ed As Long)
    TmReceiveBlock = TmReceiveBlockData(id, buf(0), blen, rlen, ed)
End Function

Function TmReceiveBlockB(ByVal id As Long, ByRef buf() As Byte, ByVal blen As Long, ByRef rlen As Long, ByRef ed As Long)
    TmReceiveBlockB = TmReceiveBlockData(id, buf(0), blen, rlen, ed)
End Function
Function TmSendByLength(ByVal id As Long, ByVal msg As String, ByVal blen As Long) As Long
    TmSendByLength = TmSendByLen(id, ByVal msg, blen)
End Function
Function TmSendByLengthB(ByVal id As Long, ByRef buf() As Byte, ByVal blen As Long) As Long
    TmSendByLengthB = TmSendByLen(id, buf(0), blen)
End Function
Function TmSendOnly(ByVal id As Long, ByVal msg As String, ByVal blen As Long, ByVal ed As Long) As Long
        TmSendOnly = TmSendOnlyBin(id, ByVal msg, blen, ed)
End Function
Function TmSendOnlyB(ByVal id As Long, ByRef buf() As Byte, ByVal blen As Long, ByVal ed As Long) As Long
        TmSendOnlyB = TmSendOnlyBin(id, buf(0), blen, ed)
End Function

