unit SFTConst;

interface

uses Messages, Graphics;

Const
  INIFILENAME = '.\SerialFileTransfer.ini';
  OPTIONFILENAME = '.\SerialFileTransfer.xml';
  SAVEINIFILENAME = 'SaveData.ini';
  IPCCLIENTNAME = 'SerialFileTransfer';
  WM_RECEIVESTRING = WM_USER + 100;
  WM_RECEIVEBYTE = WM_USER + 101;
  WM_RECEIVEWORD = WM_USER + 102;
  WM_SAVEDATA = WM_USER + 103;
  WM_FILESEND_COMPLETE = WM_USER + 104;
  WM_FILERECV_COMPLETE = WM_USER + 105;
  WM_FILERECV_PROGRESS = WM_USER + 106;
  WM_FILESEND_PROGRESS = WM_USER + 107;
  WM_IMAGESEND_COMPLETE = WM_USER + 108;
  WM_IMAGERECV_COMPLETE = WM_USER + 109;
  WM_RTFSEND_COMPLETE = WM_USER + 110;
  WM_RTFRECV_COMPLETE = WM_USER + 111;

  FILE_SEPERATOR = ',';
  COLOR_ON = clRed;
  COLOR_OFF = clLime;
  MAX_SEND_SIZE = 3000;

  CLIPBOARDCAPACITY = 3;
  KLIPBOARDHKEYID01 = $0400 + 84; //  clipboard identifier (onst
  AUTOKILLTIME = 3000;  //  three seconds
  IMAGEFILE = '$CLIPBOARD_IMAGE$';
  RTFFILE = '$CLIPBOARD_RTF$';

  MSG_FILE_SEND_REQ = '$_FILE_SEND_REQ_$';
  MSG_FILE_SEND_ACK = '$_FILE_SEND_ACK_$';
  MSG_FILE_SEND_NOACK = '$_FILE_SEND_NOACK_$';
  MSG_FILE_SEND_COMPLETE = '$_FILE_SEND_COMPLETE_$';
  MSG_FILE_RECV_OK = '$_FILE_RECV_OK_$';
  MSG_FILE_RE_SEND_REQ = '$_FILE_RE_SEND_REQ_$';

  MSG_IMAGE_SEND_REQ = '$_IMAGE_SEND_REQ_$';
  MSG_IMAGE_SEND_ACK = '$_IMAGE_SEND_ACK_$';
  MSG_IMAGE_SEND_NOACK = '$_IMAGE_SEND_NOACK_$';
  MSG_IMAGE_SEND_COMPLETE = '$_IMAGE_SEND_COMPLETE_$';
  MSG_IMAGE_RECV_OK = '$_IMAGE_RECV_OK_$';
  MSG_IMAGE_RE_SEND_REQ = '$_IMAGE_RE_SEND_REQ_$';

  MSG_RTF_SEND_REQ = '$_RTF_SEND_REQ_$';
  MSG_RTF_SEND_ACK = '$_RTF_SEND_ACK_$';
  MSG_RTF_SEND_NOACK = '$_RTF_SEND_NOACK_$';
  MSG_RTF_SEND_COMPLETE = '$_RTF_SEND_COMPLETE_$';
  MSG_RTF_RECV_OK = '$_RTF_RECV_OK_$';
  MSG_RTF_RE_SEND_REQ = '$_RTF_RE_SEND_REQ_$';

type
  COMM_STATE = (csNull, csIdle, csRTFSend, csImageSend, csFileSend, csCommandSend, csFileRecv,
                  csRTFRecv, csImageRecv, csCommandRecv);
  STATE_INPUT = (csFile_Send_Req_Recv, csFile_Send_Req_Send, csFile_Send_Ack,
                  csFile_Send_deny, csFile_Send_Complete, csFile_Recv_OK,
                csImage_Send_Req_Recv, csImage_Send_Req_Send, csImage_Send_Ack,
                  csImage_Send_deny, csImage_Send_Complete, csImage_Recv_OK,
                csRTF_Send_Req_Recv, csRTF_Send_Req_Send, csRTF_Send_Ack,
                  csRTF_Send_deny, csRTF_Send_Complete, csRTF_Recv_OK);

function GetStateName(Key: COMM_STATE): String;

resourcestring
  SGLYPHIMAGELISTANIM = 'GLYPHIMAGELISTANIM';
  SGLYPHIMAGELIST     = 'GLYPHIMAGELIST';
  SGLYPHABOUT         = 'GLYPHABOUT';
  SGLYPHSETTINGS      = 'GLYPHSETTINGS';
  SGLYPHTRASH         = 'GLYPHTRASH';
  SGLYPHEXIT          = 'GLYPHEXIT';

implementation

function GetStateName(Key: COMM_STATE): String;
begin
  case Key of
    csIdle:         Result := 'Idle_State';
    csCommandSend:  Result := 'CommandSend_State';
    csFileSend:     Result := 'FileSend_State';
    csFileRecv:     Result := 'FileRecv_State';
    csCommandRecv:  Result := 'CommandRecv_State';
    csImageSend:     Result := 'ImageSend_State';
    csImageRecv:     Result := 'ImageRecv_State';
    csRTFSend:     Result := 'RTFSend_State';
    csRTFRecv:     Result := 'RTFRecv_State';
  else
    Result := '';
  end;
end;

end.
