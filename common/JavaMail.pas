unit JavaMail;

interface

implementation

uses Androidapi.JNI.GraphicsContentViewText, Androidapi.JNIBridge,
  Androidapi.JNI.JavaTypes, FMX.Helpers.Android, Androidapi.JNI.Net,
  Androidapi.JNI.Os, Androidapi.IOUtils;

{$R *.fmx}

procedure TForm1.CreateEmail(const Recipient, Subject, Content,
   Attachment: string);
var
  Intent: JIntent;
  Uri: Jnet_Uri;
  AttachmentFile: JFile;
begin
  Intent := TJIntent.Create;
  Intent.setAction(TJIntent.JavaClass.ACTION_Send);
  Intent.setFlags(TJIntent.JavaClass.FLAG_ACTIVITY_NEW_TASK);
  Intent.putExtra(TJIntent.JavaClass.EXTRA_EMAIL, StringToJString(Recipient));
  Intent.putExtra(TJIntent.JavaClass.EXTRA_SUBJECT, StringToJString(Subject));
  Intent.putExtra(TJIntent.JavaClass.EXTRA_TEXT, StringToJString(Content));
  AttachmentFile := SharedActivity.getExternalFilesDir(StringToJString(Attachment));
  Uri := TJnet_Uri.JavaClass.fromFile(AttachmentFile);
  Intent.putExtra(TJIntent.JavaClass.EXTRA_STREAM,
  TJParcelable.Wrap((Uri as ILocalObject).GetObjectID));
  Intent.setType(StringToJString('vnd.android.cursor.dir/email'));
  SharedActivity.startActivity(Intent);
end;

procedure TForm1.Button1Click(Sender: TObject);
var
  sl: TStringList;
  sFileName: string;
begin
  sFileName := Androidapi.IOUtils.getExternalFilesDir + PathDelim + 'Test.txt';
  sl := TStringList.Create;

  try
    sl.Add('TestContent');
    sl.SaveToFile(sFileName);
  finally
    FreeAndNil(sl);
  end;

  CreateEmail('aaaaa@bbbbb.com', 'TestFromDelphi', 'test','Test.txt');
end;

end.
