{MAKEDISK.EXE}
Uses Dos,Objects,Drivers,Views,Menus,Dialogs,App,Protect,MsgBox;

const SourcePath: pathstr='C:\DISTRIB\DAM-PC21\REGIS\DATA\';
      DestinPath: pathstr='A:\';
      MainProg='INSTALL.EXE';

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

type TMakeDisk=object(TApplication)
       CopyDial: PCopyDial;
       constructor Init;
       function CopyFile(Source,Dest: PathStr): boolean;
       function RegDialog(var RegNum: word): boolean;
       procedure InitStatusLine; virtual;
     end;

var Command: word;
    RegNum: word;

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
    Insert(New(PStaticText,init(R,'MAKEDISK kopi‰ert bestand')));
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

function TMakeDisk.RegDialog(var RegNum: word): boolean;
  var Dial: TDialog;
      InputName: PInputLine;
      R: TRect;
      x: integer;
      Name: string;
  label StartOver;
  begin
    R.Assign(0,0,46,11);
    Dial.Init(R,'Registratienummer opgeven');
    Dial.Options:=Dial.Options or ofCentered;
    R.Assign(2,2,44,3);
    Dial.Insert(New(PStaticText,init(R,'Registratienummer: ')));
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
          ('U kunt het Registratie-vak niet leeg laten.',
            nil,mfOKButton+mfWarning);
        Goto StartOver;
      end;
      RegNum:=Hex2Word(Name);
    end;
    Dial.Done;
    RegDialog:=(Command=cmOK);
  end;

constructor TMakeDisk.Init;
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
    OK:=true;
    InstError:=0;
    Title:=' MAKEDISK Utility ';
    GetExtent(R);
    R.B.Y:=R.A.Y+1;
    R.A.X:=0;
    R.B.X:=length(Title);
    New(T,init(R,Title));
    T^.Options:=T^.Options+ofCenterX;
    insert(T);
    {1. welcome}
    Command:=MessageBox
      ('Welkom in de MAKEDISK utility. Stop een nieuwe, geformatteerde '+
       'floppy in '+DestinPath+' (denk aan volume-naam!).',
        nil,mfOKCancel+mfInformation);
    if Command=cmCancel then
      OK:=false;
    if OK then
    begin
      {2. create sourcepath}
      FindFirst(SourcePath+Mainprog,AnyFile,SR);
      if DosError<>0 then
      begin
        Command:=MessageBox
          ('INSTALL.EXE niet aanwezig in '+SourcePath,
        nil,mfCancelButton+mfError);
        OK:=false;
        InstError:=1;
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
          if ((SR.Attr and (Directory+VolumeID))=0) then
            OK:=CopyFile(SourcePath+SR.Name,DestinPath+SR.Name);
          FindNext(SR);
        end else
          LastFile:=true;
      until LastFile or (OK=false);
      if OK then Delete(CopyDial);
    end;
    if OK then
    begin
      {5. Get regnum}
      OK:=RegDialog(RegNum);
    end;
    if OK then
    begin
      {6. search regpos}
      SearchFile(DestinPath+MainProg,'instinfo',SearchPos,SearchCount);
      if SearchCount<>1 then
      begin
        OK:=false;
        InstError:=4;
      end;
      if OK then
      begin
        {7. Change regnr}
        DrvNr:=ord(UpCase(DestinPath[1]))-ord('A')+1;
        CreateDiskCode(DrvNr,DskCd,OK);
        if OK then
        begin
          DskNr:=RegNum xor DskCd;
          InsertDiskCode(DestinPath+MainProg,SearchPos+8,DskNr,RegNum xor $FEFE,OK);
        end;
      end;
      if not OK then
      begin
        Command:=MessageBox
          ('MAKEDISK kan registratienummer niet aan '+MainProg+' toevoegen. ',
          nil,mfOKButton+mfError);
        if InstError=0 then
          InstError:=2;
      end;
    end;
    if OK then
    begin
      {? Goodbye OK}
      Command:=MessageBox
        ('MAKEDISK van '+MainProg+' is geslaagd (Reg.nr: '+Word2Hex(RegNum)+
         ').',
        nil,mfOKButton+mfInformation);
    end else
    begin
      {Goodbye: Failed install}
      Command:=MessageBox
        ('MAKEDISK is NIET geslaagd. ',
        nil,mfOKButton+mfError);
    end;
  end;

function TMakeDisk.CopyFile(Source,Dest: PathStr): boolean;
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

procedure TMakeDisk.InitStatusLine;
  begin
  end;


var MakeDisk: TMakeDisk;
begin
  MakeDisk.Init;
  MakeDisk.Done;
end.