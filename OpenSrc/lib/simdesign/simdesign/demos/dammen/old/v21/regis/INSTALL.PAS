{Installer}
(*{$DEFINE Regis}*) {Regis switch: registered version}

Uses Dos,Objects,Drivers,Views,Menus,Dialogs,App,Protect,MsgBox;

{$IFDEF Regis}
procedure InstallInfo; external;
{$L InstInfo.obj}
{$ENDIF}

type RegNameStr=string[40];

type PPercent=^TPercent;
     TPercent=object(TView)
       Perc: real;
       procedure Draw; virtual;
     end;

const udSandD=$01;
      udPerc =$02;

type PCopyDial=^TCopyDial;
     TCopyDial=object(TDialog)
       Stat1,Stat2: PStaticText;
       Percent: PPercent;
       constructor Init;
       procedure Update(Source,Dest: String; Perc: real; UpdFl: byte);
     end;

type TInstaller=object(TApplication)
       CopyDial: PCopyDial;
       constructor Init;
       function DestinDirDialog: boolean;
       {$IFDEF Regis}
       function NameDialog(var Name: RegNameStr): boolean;
       {$ENDIF}
       function CopyFile(Source,Dest: PathStr): boolean;
       procedure InitStatusLine; virtual;
     end;

var SourcePath,DestinPath: PathStr;
    ClientName: RegNameStr;
    Command: word;
    {$IFDEF Regis}
    RegNum,DskNum: word;
    {$ENDIF}

const InstallProg='DAM-PC 2.1';
      MainProg='DAM-PC21.EX_';
      MainRen ='DAM-PC21.EXE';
      MainExec='DAM-PC21';
      DestinDefault='C:\DAM-PC';

const ErrorString: array[0..6] of string=
      ('installatie is onderbroken door gebruiker', {0=default}
       'er ontbreken bestanden',                    {1}
       'DOS fout op doelstation',                   {2}
       'DOS fout op bronstation',                   {3}
       'segmentfout in hoofdprogramma',             {4}
       'doelstation bevat geen volumenaam',         {5}
       'INSTALL.EXE is verplaatst');                {6}

procedure TPercent.Draw;
  var B: TDrawBuffer;
      PercW: word;
      Color: word;
  begin
    Color:=GetColor($18);
    MoveChar(B,' ',Color,Size.X);
    PercW:=round(Perc*Size.X);
    Color:=GetColor($05);
    MoveChar(B,' ',Color,PercW);
    WriteLine(0, 0, Size.X, 1, B);
  end;

constructor TCopyDial.Init;
  var R: TRect;
  begin
    R.Assign(0,0,40,10);
    TDialog.Init(R,'Bestanden kopi‰ren');
    Options:=Options or ofCentered;
    R.Assign(2,2,38,3);
    Insert(New(PStaticText,init(R,'INSTALL kopi‰ert bestand')));
    R.Assign(2,4,38,5);
    Insert(New(PStaticText,init(R,'naar')));
    R.Assign(2,7,38,8);
    Insert(New(PStaticText,init(R,'Voortgang')));
    R.Assign(2,8,38,9);
    New(Percent,init(R));
    Insert(Percent);
  end;

procedure TCopyDial.Update(Source,Dest: String; Perc: real; UpdFl: byte);
  var R: TRect;
  begin
    if (UpdFl and udSandD)>0 then
    begin
      if Stat1<>nil then
        Delete(Stat1);
      R.Assign(4,3,38,4);
      Stat1:=New(PStaticText,init(R,Source));
      Insert(Stat1);
      if Stat2<>nil then
        Delete(Stat2);
      R.Assign(4,5,38,6);
      Stat2:=New(PStaticText,init(R,Dest));
      Insert(Stat2);
    end;
    if (UpdFl and udPerc)>0 then
    begin
      Percent^.Perc:=Perc;
      Percent^.DrawView;
    end;
  end;

constructor TInstaller.Init;
  var T: PStaticText;
      Title: string;
      R: TRect;
      OK,LastFile: boolean;
      SR: SearchRec;
      SearchPos: longint;
      SearchCount: word;
      DrvNr: byte;
      DskCd,DskNr: word;
      f: file;
  Label StartOver;
  begin
    TApplication.Init;
    {$IFDEF Regis}
    DskNum:=PWordArray(@InstallInfo)^[4];
    RegNum:=PWordArray(@InstallInfo)^[5] xor $FEFE;
    {$ENDIF}
    OK:=true;
    InstError:=0;
    Title:=' Installatieprogramma voor '+InstallProg;
    {$IFDEF Regis}
    Title:=Title+' (geregistreerde versie) ';
    {$ELSE}
    Title:=Title+' (shareware versie) ';
    {$ENDIF}
    GetExtent(R);
    R.B.Y:=R.A.Y+1;
    R.A.X:=0;
    R.B.X:=length(Title);
    New(T,init(R,Title));
    T^.Options:=T^.Options+ofCenterX;
    insert(T);
    {1. welcome}
    Command:=MessageBox
      ('Welkom in het installatieprogramma voor '+InstallProg+
       '. Als U '+InstallProg+' (opnieuw) wilt installeren, kies dan [OK].',
        nil,mfOKCancel+mfInformation);
    if Command=cmCancel then
      OK:=false;
    if OK then
    begin
      {2. create sourcepath}
      SourcePath:=GetCurDir;
      FindFirst(SourcePath+MainProg,AnyFile,SR);
      if DosError<>0 then
      begin
        Command:=MessageBox
          ('INSTALL.EXE kan de te kopi‰ren bestanden niet vinden. Start INSTALL a.u.b. vanuit '+
       'de directory waarin INSTALL.EXE zich bevindt.',
        nil,mfCancelButton+mfError);
        OK:=false;
        InstError:=1;
      end;
    end;
    {$IFDEF Regis}
    if OK then
    begin
      DrvNr:=ord(UpCase(SourcePath[1]))-ord('A')+1;
      CreateDiskCode(DrvNr,DskCd,OK);
      if OK then
      begin
        if DskNum<>(DskCd xor RegNum) then
          OK:=false;
      end;
      if not OK then
        InstError:=6;
    end;
    {$ENDIF}
    if OK then
    begin
      {3. create destinpath}
      StartOver:
      OK:=DestinDirDialog;
    end;
    if OK then
    begin
      {4. check source=dest}
      if SourcePath=DestinPath then
      begin
        Command:=MessageBox
          (InstallProg+' kan niet in de brondirectory ('+SourcePath+') ge‹nstalleerd worden. '+
          'Kies a.u.b. een andere doeldirectory.',
          nil,mfOKButton+mfWarning);
        Goto StartOver;
      end;
    end;
    if OK then
    begin
      {4. copy files}
      New(CopyDial,Init);
      Insert(CopyDial);
      LastFile:=false;
      FindFirst(SourcePath+'*.*',AnyFile,SR);
      repeat
        if DosError=0 then
        begin
          if ((SR.Attr and (Directory+VolumeID))=0) and
             (SR.Name<>'INSTALL.EXE') then
            OK:=CopyFile(SourcePath+SR.Name,DestinPath+SR.Name);
          FindNext(SR);
        end else
          LastFile:=true;
      until LastFile or (OK=false);
      if OK then Delete(CopyDial);
    end;
    {$IFDEF Regis}
    if OK then
    begin
      {5. Get client name}
      OK:=NameDialog(ClientName);
    end;
    {Registered}
    if OK then
    begin
      {6. Change client name}
      SearchFile(DestinPath+MainProg,'clientname',SearchPos,SearchCount);
      if SearchCount<>1 then
      begin
        OK:=false;
        InstError:=4;
      end else
      begin
        InsertDiskString(DestinPath+MainProg,@ClientName,SearchPos,OK);
      end;
      if OK then
      begin
        {7. Change regnr}
        DrvNr:=ord(UpCase(DestinPath[1]))-ord('A')+1;
        CreateDiskCode(DrvNr,DskCd,OK);
        if OK then
        begin
          DskNr:=RegNum xor DskCd;
          InsertDiskCode(DestinPath+MainProg,SearchPos+40,DskNr,RegNum xor $FFFF,OK);
        end;
      end;
      if not OK then
      begin
        Command:=MessageBox
          ('INSTALL kan Uw gegevens niet aan '+InstallProg+' toevoegen. ',
          nil,mfOKButton+mfError);
        if InstError=0 then
          InstError:=2;
      end;
    end;
    {$ENDIF}
    if OK then
    begin
      {8. rename main}
      FindFirst(DestinPath+MainRen,AnyFile,SR);
      if DosError=0 then
      begin
        Assign(f,DestinPath+MainRen);
        Erase(f);
      end;
      {$I-}
      Assign(f,DestinPath+MainProg);
      Rename(f,DestinPath+MainRen);
      {$I+}
      if IOResult<>0 then
        OK:=false;
      if not OK then
      begin
        Command:=MessageBox
          ('INSTALL kan '+InstallProg+' niet hernoemen. ',
          nil,mfOKButton+mfError);
        InstError:=2;
      end;
    end;
    if OK then
    begin
      {? Goodbye OK}
      Command:=MessageBox
        ('Installatie van '+InstallProg+' is geslaagd. U kunt '+InstallProg+' nu starten vanaf de DOS-prompt'+
        ' met het commando '+MainExec+'.',
        nil,mfOKButton+mfInformation);
      dec(DestinPath[0]);
      ChDir(DestinPath);
    end else
    begin
      {Goodbye: Failed install}
      Command:=MessageBox
        ('Installatie van '+InstallProg+' is NIET geslaagd ('+ErrorString[InstError]+'). '+
        'Zie de handleiding voor meer informatie.',
        nil,mfOKButton+mfError);
    end;
  end;

function TInstaller.DestinDirDialog: boolean;
  var Dial: TDialog;
      InputDir: PInputLine;
      R: TRect;
  label StartOver;
  begin
    DestinPath:=DestinDefault;
    R.Assign(0,0,50,9);
    Dial.Init(R,'Kies directory');
    Dial.Options:=Dial.Options or ofCentered;
    R.Assign(2,2,48,3);
    Dial.Insert(New(PStaticText,init(R,'In welke directory wilt u DAM-PC installeren?')));
    R.Assign(30,6,40,8);
    Dial.Insert(New(PButton,init(R,'Cancel',cmCancel,0)));
    R.Assign(10,6,20,8);
    Dial.Insert(New(PButton,init(R,'OK',cmOK,bfDefault)));
    R.Assign(2,4,48,5);
    New(InputDir,init(R,79));
    Dial.Insert(InputDir);
    StartOver:
    InputDir^.SetData(DestinPath);
    Command:=DeskTop^.ExecView(@Dial);
    if Command=cmOK then
    begin
      InputDir^.GetData(DestinPath);
      DestinPath:=FExpand(DestinPath);
      if DestinPath[Length(DestinPath)]='\' then
        dec(DestinPath[0]);
      if not PathValid(DestinPath) then
      begin
        Command:=MessageBox
          ('De directory '+DestinPath+' bestaat niet. Wilt u deze directory aanmaken?',
          nil,mfYesButton+mfNoButton+mfWarning);
        if Command=cmYes then
        begin
          Command:=cmOK;
          {$I-}
          MkDir(DestinPath);
          {$I+}
          if IOResult<>0 then
          begin
            Command:=MessageBox
              ('De directory '+DestinPath+' kan niet aangemaakt worden.',
               nil,mfOKButton+mfError);
            Goto StartOver;
          end;
        end else
          Goto StartOver;
      end;
      DestinPath:=DestinPath+'\';
    end;
    Dial.Done;
    DestinDirDialog:=(Command=cmOK);
  end;

{$IFDEF Regis}
function TInstaller.NameDialog(var Name: RegNameStr): boolean;
  var Dial: TDialog;
      InputName: PInputLine;
      R: TRect;
      x: integer;
  label StartOver;
  begin
    R.Assign(0,0,46,11);
    Dial.Init(R,'Uw gegevens');
    Dial.Options:=Dial.Options or ofCentered;
    R.Assign(2,2,44,3);
    Dial.Insert(New(PStaticText,init(R,'Registratienummer: '+Word2Hex(RegNum))));
    R.Assign(2,4,44,5);
    Dial.Insert(New(PStaticText,init(R,'Wat is Uw naam?')));
    R.Assign(30,8,40,10);
    Dial.Insert(New(PButton,init(R,'Cancel',cmCancel,0)));
    R.Assign(10,8,20,10);
    Dial.Insert(New(PButton,init(R,'OK',cmOK,bfDefault)));
    R.Assign(2,6,44,7);
    New(InputName,init(R,40));
    Dial.Insert(InputName);
    StartOver:
    Command:=DeskTop^.ExecView(@Dial);
    if Command=cmOK then
    begin
      InputName^.GetData(Name);
      if Name='' then
      begin
        Command:=MessageBox
          ('U kunt het naam-vak niet leeg laten.',
            nil,mfOKButton+mfWarning);
        Goto StartOver;
      end;
      for x:=length(Name)+1 to 40 do
        Name[x]:=' ';
      Name[0]:=chr(40);
      for x:=1 to 40 do
        Name[x]:=chr(ord(Name[x]) xor (x+$80));
    end;
    Dial.Done;
    NameDialog:=(Command=cmOK);
  end;
{$ENDIF}

function TInstaller.CopyFile(Source,Dest: PathStr): boolean;
  var S,D: TBufStream;
      Pos, FileSize: LongInt;
      b: byte;
  begin
    CopyDial^.Update(Source,Dest,0,udSandD+udPerc);
    Command:=cmOK;
    S.Init(Source,stOpenRead,1024);
    if S.Status<>stOK then
    begin
      Delete(CopyDial);
      Command:=MessageBox
      ('Bronbestand '+Source+' kan niet geopend worden.',
        nil,mfCancelButton+mfError);
      InstError:=3;
    end else
    begin
      D.Init(Dest,stCreate,1024);
      if D.Status<>stOK then
      begin
        Delete(CopyDial);
        Command:=MessageBox
        ('Doelbestand '+Dest+' kan niet aangemaakt worden.',
          nil,mfCancelButton+mfError);
        InstError:=2;
      end else
      begin
        FileSize:=S.GetSize;
        for Pos:=0 to FileSize-1 do
        begin
          S.Read(b,1);
          D.Write(b,1);
          if (Pos mod 512)=0 then
            CopyDial^.Update('','',Pos/(FileSize-1),udPerc);
        end;
        if (S.Status<>stOK) or (D.Status<>stOK) then
        begin
          Delete(CopyDial);
          Command:=MessageBox
          ('DOS Fout tijdens kopieren.',
            nil,mfCancelButton+mfError);
          if S.Status<>stOK then
            InstError:=3
          else
            InstError:=2;
        end;
      end;
      D.Done;
    end;
    S.Done;
    CopyFile:=(Command=cmOK);
  end;

procedure TInstaller.InitStatusLine;
  begin
  end;

var I: TInstaller;
begin
  I.Init;
  I.Done;
end.