{   MPUI-hcb, an MPlayer frontend for Windows
    Copyright (C) 2006-2013 Huang Chen Bin <hcb428@foxmail.com>

    This program is free software; you can redistribute it and/or modify
    it under the terms of the GNU General Public License as published by
    the Free Software Foundation; either version 2 of the License, or
    (at your option) any later version.

    This program is distributed in the hope that it will be useful,
    but WITHOUT ANY WARRANTY; without even the implied warranty of
    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
    GNU General Public License for more details.

    You should have received a copy of the GNU General Public License
    along with this program; if not, write to the Free Software
    Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA  02111-1307  USA
}

unit DLyric;

interface

uses
    Windows, SysUtils, TntSysUtils, Variants, Classes, Controls, TntControls,
    Dialogs, TntDialogs, StdCtrls, TntStdCtrls, ComCtrls, TntComCtrls, IdHTTP,
    Forms, TntForms, XMLDoc, XMLIntf, ActiveX;

const LangList:array[0..56] of string=('all','alb','ara','arm','ben','bos','pob',
          'bul','cat','chi','hrv','cze','dan','dut','eng','epo','est','fin','fre',
          'glg','geo','ger','ell','heb','hin','hun','ice','ind','ita','jpn','kaz',
          'kor','lav','lit','ltz','mac','may','nor','oci','per','pol','por','rum',
          'rus','scc','sin','slo','slv','spa','swe','syr','tgl','tha','tur','ukr',
          'urd','vie');
          
type
    Tbytes = array of Byte;
    TLyricEntry = record
      id: widestring;
      artist: widestring;
      title: widestring;
      searchID: Integer;
    end;
    TLyricEntryList = array of TLyricEntry;

    TSubEntry = record
       IDSubtitle,LanguageName,SubFormat,SubSumCD,MovieName,
       SubAddDate,SubDownloadsCnt:WideString;
    end;
    TSubEntryList = array of TSubEntry;

    TDownLoadLyric = class(TThread)
    private
      Len:Integer; LyricList:TLyricEntryList;
      SubList:TSubEntryList;
    protected
      procedure Execute; override;
      procedure GetLyricList;
      procedure GetLyric(FN,URL:WideString);
      procedure UpdateListView;
    public
      artist, title, FN, id, URL:WideString;
      mode,Lang: Integer;
    end;

    TDLyricForm = class(TTntForm)
    LArtist: TTntLabel;
    EArtist: TTntEdit;
    ETitle: TTntEdit;
    LTitle: TTntLabel;
    BSearch: TTntButton;
    LyricListView: TTntListView;
    PLS: TTntPageControl;
    LSTitle: TTntLabel;
    ESTitle: TTntEdit;
    BSSearch: TTntButton;
    SubListView: TTntListView;
    CLang: TTntComboBox;
    slyric:TTntTabSheet;
    ssubtitle:TTntTabSheet;
    LSLang: TTntLabel;
    BLSave: TTntButton;
    BLApply: TTntButton;
    BLClose: TTntButton;
    BSave: TTntButton;
    BApply: TTntButton;
    BClose: TTntButton;
    procedure BSearchClick(Sender: TObject);
    procedure BApplyClick(Sender: TObject);
    procedure BCloseClick(Sender: TObject);
    procedure BSaveClick(Sender: TObject);
    procedure TntFormShow(Sender: TObject);
    procedure TntFormHide(Sender: TObject);
    procedure PLSChange(Sender: TObject);
    procedure CLangClick(Sender: TObject);
    private
    { Private declarations }
    public
    { Public declarations }
    end;

var DLyricForm: TDLyricForm; stList:TSubEntryList;

const
SearchPath: array[0..2] of string = (
    'http://ttlrcct.qianqian.com/dll/lyricsvr.dll?sh?Artist=%s&Title=%s&Flags=0',
    'http://ttlrccnc.qianqian.com/dll/lyricsvr.dll?sh?Artist=%s&Title=%s&Flags=0',
  //'<?xml version="1.0" encoding=''utf-8''?><search filetype="lyrics" artist="%s" title="%s"/>'
    '<?xml version=''1.0'' encoding=''utf-8'' standalone=''yes'' ?><searchV1 filetype="lyrics" artist="%s" title="%s" client="MiniLyrics" />'
    );

DownloadPath : array[0..2] of string = (
    'http://ttlrcct.qianqian.com/dll/lyricsvr.dll?dl?Id=%s&Code=%s',
    'http://ttlrccnc.qianqian.com/dll/lyricsvr.dll?dl?Id=%s&Code=%s',
    ''
    );

function ToHexString(s, encode: WideString): string;
function CreateLyricCode(singer, title: WideString; lrcId: integer): string;
function Conv(i: Integer): int64;
function findID(id:WideString; list:TLyricEntryList):Boolean;
procedure vl_enc(data, md5_extra:string; out ms:TMemoryStream);
function vl_dec(data:string):string;

implementation
uses Plist, Core, Locale, Main, md5;

{$R *.dfm}
procedure TDownLoadLyric.Execute;
begin
{ mode value:
      1,2 --> Seearch
    -1,-2 --> Save
      3,4 --> Auto Search and Load
    -3,-4 --> Apply
}

  Len:=0;
  if mode>0 then begin
    GetLyricList;
    if mode mod 2=1 then Len:= Length(LyricList)
    else Len:=Length(SubList);
    if Len=0 then begin
      case mode of
        1: DLyricForm.BSearch.Enabled:=True;
        2: DLyricForm.BSSearch.Enabled:=True;
      end;
      Exit;
    end
    else if (Len=1) and (mode>2) then begin
      if mode=3 then begin
        if LyricList[0].searchID<2 then begin
          Url := DownloadPath[LyricList[0].searchID];
          Url := Format(Url, [LyricList[0].id, CreateLyricCode(LyricList[0].artist, LyricList[0].title, StrToInt(LyricList[0].id))]);
        end
        else Url:= LyricList[0].id;
        GetLyric(FN,Url);
      end
      else GetLyric(FN, SubList[0].IDSubtitle);
    end;
  end
  else GetLyric(FN, URL);
  Application.ProcessMessages;
  if (mode>2) and (not ADls) then exit;
  Synchronize(UpdateListView);
  Application.ProcessMessages;
end;

procedure TDownLoadLyric.GetLyric(FN,URL:WideString);
var IdHTTP1: TIdhttp; fs:TFileStream;
begin
  IdHTTP1:=TIdhttp.Create(nil);
  IdHTTP1.HTTPOptions:=[hoKeepOrigProtocol];
  if Abs(mode mod 2)=0 then begin
    IdHTTP1.Host:='www.opensubtitles.org';
    URL:='/en/download/sub/' + URL;
  end;
  fs:=TFileStream.Create(FN,fmCreate or fmShareDenyNone);
  try
    IdHTTP1.Get(URL,fs);
  except
    IdHTTP1.Free;
    fs.Free;
    Exit;
  end;
  IdHTTP1.Free;
  fs.Free;
end;

procedure TDownLoadLyric.GetLyricList;
var XMLString, MyUrl: string; artistV, titleV,idV,linkV,s:OleVariant;
    XDOC: IXMLDocument; XmlNd,nd,nd1: IXMLNode; i,j,Len,searchID:Integer;
    IdHTTP1: TIdhttp; Mem:TMemoryStream; SList:TStringList;
    IDSubtitle,LanguageName,SubFormat,SubSumCD,MovieName,
    SubAddDate,SubEnabled,SubDownloadsCnt,SubBad,a,t:WideString;
begin
  if Abs(mode mod 2)=1 then begin
    artist := Tnt_WideLowerCase(Tnt_WideStringReplace(artist, '''', '', [rfReplaceAll]));
    artist := Tnt_WideLowerCase(Tnt_WideStringReplace(artist, '"', '', [rfReplaceAll]));
    title := Tnt_WideLowerCase(Tnt_WideStringReplace(title, '''', '', [rfReplaceAll]));
    title := Tnt_WideLowerCase(Tnt_WideStringReplace(title, '"', '', [rfReplaceAll]));

    for searchID:=High(SearchPath) downto Low(SearchPath) do begin
      IdHTTP1:=TIdhttp.Create(nil); XMLString:='';
      IdHTTP1.HTTPOptions:=[hoKeepOrigProtocol];

      if searchID<2 then begin   //IdHTTP1.Free;  Exit;
        a:= Tnt_WideStringReplace(artist, ' ', '', [rfReplaceAll]);
        t:= Tnt_WideStringReplace(title, ' ', '', [rfReplaceAll]);
        a:= ToHexString(a, 'Unicode'); t:= ToHexString(t, 'Unicode');
        MyUrl:= Format(SearchPath[searchID], [a,t]);
        try
          XMLString := IdHTTP1.Get(MyUrl);
        except
          IdHTTP1.Free;
          Continue;
        end;
      end
      else begin  // IdHTTP1.Free;  Exit;
        MyUrl:= Format(SearchPath[searchID], [UTF8Encode(artist), UTF8Encode(title)]);
        vl_enc(MyUrl,'Mlv1clt4.0',Mem);
        //http://www.viewlyrics.com:1212/searchlyrics.htm
        IdHTTP1.Request.UserAgent:='MiniLyrics';
        {IdHTTP1.ProtocolVersion:=pv1_1;
        IdHttp1.Request.CustomHeaders.Values['Connection']:='Keep-Alive';
        IdHttp1.Request.CustomHeaders.Values['Expect']:='100-continue';}
        idhttp1.Request.ContentType:='';
        idhttp1.Request.Accept:='';
        // IdHTTP1.Port:='1212';
        //idhttp1.Request.ContentLength:=length(tb);
        try
          XMLString:=IdHTTP1.post('http://search.crintsoft.com/searchlyrics.htm',Mem);
          XMLString:=vl_dec(XMLString);
        except
          IdHTTP1.Free;
          Mem.free;
          Continue;
        end;
        Mem.free;
      end;
      IdHTTP1.Free;
      if XMLString='' then Continue;

      try
        OleInitialize(nil);
        XDOC:= LoadXMLData(XMLString);
      except
          XDOC:=nil;
          OleUninitialize;
          Continue;
      end;
      OleUninitialize;
      XDOC.Options:= XDOC.Options - [doAttrNull];
      XmlNd := xdoc.DocumentElement;

      for i := 0 to XmlNd.ChildNodes.Count - 1 do begin
          idV:=XmlNd.ChildNodes[i].Attributes['id'];
          artistV:=XmlNd.ChildNodes[i].Attributes['artist'];
          titleV:=XmlNd.ChildNodes[i].Attributes['title'];
          linkV:=XmlNd.ChildNodes[i].Attributes['link'];
          if (artistV<>Null) and (artistV<>'') and
             (titleV<>Null) and (titleV<>'') then begin
            if (idV<>Null) and (StrToIntDef(idV,-1)>-1) and (not findID(idV,LyricList)) then begin
                Len:=Length(LyricList);
                SetLength(LyricList,Len + 1);
                LyricList[Len].id := idV;
                LyricList[Len].artist:=artistV;
                LyricList[Len].title:=titleV;
                LyricList[Len].searchID:=searchID;
            end
            else if (linkV<>Null) and (Tnt_WideLowerCase(WideExtractFileExt(linkV))='.lrc') and
              (not findID(linkV,LyricList)) then begin
                Len:=Length(LyricList);
                SetLength(LyricList,Len + 1);
                LyricList[Len].id := linkV;
                LyricList[Len].artist:=artistV;
                LyricList[Len].title:=titleV;
                LyricList[Len].searchID:=searchID;
            end;
          end;
      end;
      XDOC := nil;
    end;
  end
  else begin
    IdHTTP1:=TIdhttp.Create(nil); XMLString:='';
    IdHTTP1.HTTPOptions:=[hoKeepOrigProtocol];
    IdHTTP1.Host:='www.opensubtitles.org';
    MyUrl:= Format('/en/search/sublanguageid-%s/moviename-%s/xml', [LangList[Lang],UTF8Encode(title)]);
    try
      XMLString:=IdHTTP1.Get(MyUrl);
    except
      IdHTTP1.Free;
      Exit;
    end;

    IdHTTP1.Free;
    if XMLString='' then Exit;

    try
      OleInitialize(nil);
      XDOC := XMLDoc.LoadXMLData(UTF8Decode(XMLString));
    except
      XDOC:=nil;
      OleUninitialize;
      Exit;
    end;
    OleUninitialize;
    XDOC.Options:= XDOC.Options - [doAttrNull];
    XmlNd := XDOC.DocumentElement;

    SList:= TStringList.Create;
    SetLength(SubList,0);
    nd:= XmlNd.ChildNodes.FindNode('search');
    if nd<>nil then begin
      nd:=nd.ChildNodes.FindNode('results');
      if nd<>nil then begin
        for i := 0 to nd.ChildNodes.Count - 1 do begin
          nd1:=nd.ChildNodes[i];
          if nd1.NodeName='subtitle' then begin
             s:=nd1.ChildValues['MovieID'];
             if (s<>Null) and (StrToIntDef(s,-1)>-1) then SList.Add(s);
             break;
          end;
        end;
      end;
    end;

    XDOC:=nil;

    for i := 0 to SList.Count - 1 do begin
      MyUrl:= Format('/en/search/sublanguageid-%s/xml/idmovie-%s', [LangList[Lang],SList[i]]);
      repeat
        IdHTTP1:=TIdhttp.Create(nil);
        IdHTTP1.Host:='www.opensubtitles.org';
        XMLString:='';
        try
          XMLString := IdHTTP1.Get(MyUrl);
        except
          IdHTTP1.Free;
          Break;
        end;

        IdHTTP1.Free;
        if XMLString='' then Break;

        try
          OleInitialize(nil);
          XDOC := XMLDoc.LoadXMLData(UTF8Decode(XMLString));
        except
          XDOC:=nil;
          OleUninitialize;
          Break;
        end;
        OleUninitialize;
        MyUrl:='';
        XDOC.Options:= XDOC.Options - [doAttrNull];
        XmlNd := XDOC.DocumentElement;
        nd:= XmlNd.ChildNodes.FindNode('search');
        if nd<>nil then begin
          nd:=nd.ChildNodes.FindNode('results');
          if nd<>nil then begin
            for j := 0 to nd.ChildNodes.Count - 1 do begin
              nd1:=nd.ChildNodes[j];
              if nd1.NodeName='subtitle' then begin
                SubBad:=''; SubEnabled:='';
                s:=nd1.ChildValues['SubBad'];
                if (s<>Null) and (StrToIntDef(s,-1)=0) then SubBad:=s;
                s:=nd1.ChildValues['SubEnabled'];
                if (s<>Null) and (StrToIntDef(s,-1)>0) then SubEnabled:=s;
                if (SubEnabled<>'') and (SubBad<>'') then begin
                  IDSubtitle:=''; LanguageName:=''; SubFormat:='';
                  SubSumCD:=''; SubAddDate:='';
                  SubDownloadsCnt:=''; MovieName:='';
                  s:=nd1.ChildValues['SubDownloadsCnt'];
                  if (s<>Null) and (StrToIntDef(s,-1)>-1) then SubDownloadsCnt := s;
                  s:=nd1.ChildValues['IDSubtitle'];
                  if (s<>Null) and (StrToIntDef(s,-1)>-1) then IDSubtitle := s;
                  s:=nd1.ChildValues['LanguageName'];
                  if (s<>Null) and (s<>'') then LanguageName := s;
                  s:=nd1.ChildValues['SubSumCD'];
                  if (s<>Null) and (StrToIntDef(s,-1)>-1) then SubSumCD := s;
                  s:=nd1.ChildValues['SubFormat'];
                  if (s<>Null) and (s<>'') then  SubFormat := s;
                  s:=nd1.ChildValues['SubAddDate'];
                  if (s<>Null) and (s<>'') then SubAddDate := s;
                  s:=nd1.ChildValues['MovieName'];
                  if (s<>Null) and (s<>'') then MovieName := s;
                  if (IDSubtitle<>'') and (LanguageName<>'') and (SubSumCD<>'') and (MovieName<>'')
                    and (SubFormat<>'') and (SubAddDate<>'') and (SubDownloadsCnt<>'') then begin
                    Len:=Length(SubList);
                    SetLength(SubList,Len + 1);
                    SubList[Len].IDSubtitle:=IDSubtitle; SubList[Len].LanguageName:=LanguageName;
                    SubList[Len].SubFormat:=SubFormat; SubList[Len].SubSumCD:=SubSumCD;
                    SubList[Len].SubAddDate:=SubAddDate; SubList[Len].SubDownloadsCnt:=SubDownloadsCnt;
                    SubList[Len].MovieName:=MovieName;
                  end;
                end;
              end;
            end;
            nd:=nd.ChildNodes.FindNode('rel_links');
            if nd<>nil then begin
              nd:=nd.ChildNodes.FindNode('next');
              if nd<>nil then begin
                s:=nd.Attributes['LinkRel'];
                if s<>Null then MyUrl := s;
              end;
            end;
          end;
        end;
      until MyUrl='';
    end;
    SList.Free;
  end;
  XDOC := nil;
end;

procedure TDownLoadLyric.UpdateListView;
var i:Integer;
begin
  if WideFileExists(FN) then begin
    case mode of
      3,-3: begin
              DLyricForm.BLSave.Enabled:=True; DLyricForm.BLApply.Enabled:=True;
              Lyric.ParseLyric(FN); if Len=1 then Exit;
            end;
      4,-4: begin
              DLyricForm.BSave.Enabled:=True; DLyricForm.BApply.Enabled:=True;
              DownSubtitle_CallBackW(PWChar(FN),1,0); if Len=1 then Exit;
            end;
    end;
  end;

  if abs(mode mod 2)=1 then begin
    DLyricForm.BSearch.Enabled := true;
    DLyricForm.BLSave.Enabled:=True; DLyricForm.BLApply.Enabled:=True;
    if Len=0 then Exit;
    DLyricForm.EArtist.Text:= artist; DLyricForm.ETitle.Text:= title;

    DLyricForm.PLS.ActivePageIndex:=0;
    DLyricForm.LyricListView.Clear;
    for i:=0 to Len-1 do begin
      with DLyricForm.LyricListView.Items.Add do begin
        Caption:=LyricList[i].id;
        SubItems.Add(LyricList[i].artist);
        SubItems.Add(LyricList[i].title);
        Data:= Pointer(LyricList[i].searchID);
      end;
    end;
  end
  else begin
    DLyricForm.BSSearch.Enabled := true;
    DLyricForm.BSave.Enabled:=True; DLyricForm.BApply.Enabled:=True;
    if Len=0 then Exit;
    DLyricForm.ESTitle.Text:= title;

    DLyricForm.CLang.ItemIndex:=Lang; stList:=SubList;
    DLyricForm.PLS.ActivePageIndex:=1;
    DLyricForm.SubListView.Clear;
    for i:=0 to Len-1 do begin
      with DLyricForm.SubListView.Items.Add do begin
        Caption:=SubList[i].IDSubtitle;
        SubItems.Add(SubList[i].MovieName);
        SubItems.Add(SubList[i].LanguageName);
        SubItems.Add(SubList[i].SubFormat);
        SubItems.Add(SubList[i].SubSumCD);
        SubItems.Add(SubList[i].SubDownloadsCnt);
        SubItems.Add(SubList[i].SubAddDate);
      end;
    end;
  end;
  DLyricForm.Show;
  DLyricForm.PLSChange(nil);
end;

procedure TDLyricForm.BSearchClick(Sender: TObject);
var t:TDownLoadLyric;
begin
  Application.ProcessMessages;
  if PLS.ActivePageIndex=0 then begin
    if (EArtist.Text='') and (ETitle.Text='') then Exit;
    BSearch.Enabled := False;
    t:=TDownLoadLyric.Create(True);
    t.FreeOnTerminate:=True;
    t.artist:=EArtist.Text; t.title:=ETitle.Text;
    t.mode:=1; t.Resume;
  end
  else begin
    if not dsEnd then begin
      LoadSLibrary;
      if IsSLoaded <> 0 then
        DownloaderSubtitleW(PWChar(MediaURL), True, DownSubtitle_CallBackW, DownSubtitle_CallBackFinish);
    end;
    if ESTitle.Text='' then Exit;
    BSSearch.Enabled := False;
    t:=TDownLoadLyric.Create(True);
    t.FreeOnTerminate:=True;
    t.title:=ESTitle.Text; t.Lang:=CLang.ItemIndex;
    t.mode:=2; t.Resume;
  end;
end;

procedure TDLyricForm.BApplyClick(Sender: TObject);
var t:TDownLoadLyric; i:Integer;
begin
  Application.ProcessMessages;
  if PLS.ActivePageIndex=0 then begin
    if LyricListView.Items.Count=0 then Exit;
    if LyricListView.ItemIndex=-1 then LyricListView.ItemIndex:=0;
    BLSave.Enabled:=False; BLApply.Enabled:=False;
    t:=TDownLoadLyric.Create(True);
    t.FreeOnTerminate:=True;
    t.FN:=WideIncludeTrailingPathDelimiter(LyricDir) + GetFileName(WideExtractFileName(MediaURL)) + '.lrc';
    i:=Integer(LyricListView.Selected.Data);
    if i<2 then begin
      t.URL := DownloadPath[i];
      t.URL := Format(t.URL, [LyricListView.Selected.Caption, CreateLyricCode(LyricListView.Selected.SubItems[0], LyricListView.Selected.SubItems[1], StrToInt(LyricListView.Selected.Caption))]);
    end
    else t.URL:= LyricListView.Selected.Caption;
    t.mode:=-3; t.Resume;
  end
  else begin
    if SubListView.Items.Count=0 then Exit;
    if SubListView.ItemIndex=-1 then SubListView.ItemIndex:=0;
    BSave.Enabled:=False; BApply.Enabled:=False;
    t:=TDownLoadLyric.Create(True);
    t.FreeOnTerminate:=True;
    t.FN:=WideIncludeTrailingPathDelimiter(LyricDir) + GetFileName(WideExtractFileName(MediaURL)) + '.zip';
    t.URL:= SubListView.Selected.Caption;
    t.mode:=-4;
    t.Resume;
  end;
end;

procedure TDLyricForm.BCloseClick(Sender: TObject);
begin
  Close;
end;

procedure TDLyricForm.BSaveClick(Sender: TObject);
var t:TDownLoadLyric; i:integer;
begin
  Application.ProcessMessages;
  with PlaylistForm.SaveDialog do begin
    if PLS.ActivePageIndex=0 then begin
      Title := BLSave.Hint;
      Filter:= LyricFilter + ' (*.lrc)|*.lrc|' + AnyFilter + ' (*.*)|*.*';
      if LyricListView.Items.Count=0 then Exit;
      if LyricListView.ItemIndex=-1 then LyricListView.ItemIndex:=0;
      FileName:=GetFileName(WideExtractFileName(MediaURL));
      if Execute then begin
        BLSave.Enabled:=False; BLApply.Enabled:=False;
        t:=TDownLoadLyric.Create(True);
        t.FN:=FileName;
        i:=Integer(LyricListView.Selected.Data);
        if i<2 then begin
          t.URL := DownloadPath[i];
          t.URL := Format(t.URL, [LyricListView.Selected.Caption, CreateLyricCode(LyricListView.Selected.SubItems[0], LyricListView.Selected.SubItems[1], StrToInt(LyricListView.Selected.Caption))]);
        end
        else t.URL:= LyricListView.Selected.Caption;
        t.mode:=-1;
        t.Resume;
      end;
    end
    else begin
      Title := BSave.Hint;
      Filter:= SubFilter + ' (*.zip)|*.zip|' + AnyFilter + ' (*.*)|*.*';
      if SubListView.Items.Count=0 then Exit;
      if SubListView.ItemIndex=-1 then SubListView.ItemIndex:=0;
      FileName:=GetFileName(WideExtractFileName(MediaURL));
      if Execute then begin
        BSave.Enabled:=False; BApply.Enabled:=False;
        t:=TDownLoadLyric.Create(True);
        t.FN:=FileName; t.URL:=LyricListView.Selected.Caption;
        t.mode:=-2;
        t.Resume;
      end;
    end;
  end;
end;

procedure TDLyricForm.TntFormShow(Sender: TObject);
begin
  if (MainForm.Width >= CurMonitor.Width) or (MainForm.Height >= CurMonitor.WorkareaRect.Bottom - CurMonitor.WorkareaRect.Top) then MainForm.Enabled := false;
  if (OnTop > 0) or MainForm.MFullScreen.Checked then SetWindowPos(Handle, HWND_TOPMOST, 0, 0, 0, 0, SWP_NOMOVE or SWP_NOSIZE);
end;

procedure TDLyricForm.TntFormHide(Sender: TObject);
begin
  if PlayListForm.Visible then exit;
  MainForm.Enabled := true;
  if (OnTop = 1) or ((OnTop = 2) and (Status = sPlaying)) or MainForm.MFullScreen.Checked then
    SetWindowPos(MainForm.Handle, HWND_TOPMOST, 0, 0, 0, 0, SWP_NOMOVE or SWP_NOSIZE);
end;

procedure TDLyricForm.PLSChange(Sender: TObject);
begin
  if PLS.TabIndex=0 then Caption:= MainForm.MDownloadLyric.Caption
  else Caption:=MainForm.Mdownloadsubtitle.Caption;
end;

procedure TDLyricForm.CLangClick(Sender: TObject);
var Len,i:Integer;
begin
  Len:=Length(stList);
  if (CLang.ItemIndex=-1) or (Len=0) then Exit;
  SubListView.Clear;
  for i:=0 to Len-1 do begin
    if (CLang.ItemIndex=0) or (stList[i].LanguageName=CLang.Items[CLang.ItemIndex]) then begin
      with SubListView.Items.Add do begin
        Caption:=stList[i].IDSubtitle;
        SubItems.Add(stList[i].MovieName);
        SubItems.Add(stList[i].LanguageName);
        SubItems.Add(stList[i].SubFormat);
        SubItems.Add(stList[i].SubSumCD);
        SubItems.Add(stList[i].SubDownloadsCnt);
        SubItems.Add(stList[i].SubAddDate);
      end;
    end;
  end;
end;

function GetBytes(const S,mode: WideString): TBytes;
var
  Len: Integer; a:UTF8String;
begin

  if mode='UTF8' then begin
 // len := WideCharToMultiByte(CP_UTF8, 0, PwChar(S), Length(S), nil, 0, nil, nil);
  // SetLength(Result, Len);
   //  WideCharToMultiByte(CP_UTF8, 0,pwchar(s), Length(S), PChar(Result), len, nil, nil);
    a:=UTF8Encode(s);
    Len := Length(a);
    SetLength(Result, Len);
    CopyMemory(PChar(Result),PChar(a),Len);
  end
  else begin
    Len := Length(S)* SizeOf(WideChar);
    SetLength(Result, Len);
    CopyMemory(PChar(Result),PWChar(S),Len);
  end;
end;

function ToHexString(s,encode: WideString): string;
var ByteAy: Tbytes; i:Integer;
begin
    ByteAy := GetBytes(s,encode);
    Result := '';
    for i:=Low(ByteAy) to High(ByteAy) do
        Result := Format('%s%.2x', [Result, ByteAy[i]]);
end;

function Conv(i: Integer): int64;
var
    r: int64;
begin
    r := i mod $100000000;
    if (i >= 0) and (r > $80000000) then
        r := r - $100000000;
    if (i < 0) and (r < $80000000) then
        r := r + $100000000;
    Result := r;
end;

function CreateLyricCode(singer, title: WideString; lrcId: integer): string;
var
    qqHexStr: string;
    MyLen,  j, t1, t2, t3, t4, c, t, i, t5:Integer;
    t6: Int64;
    song: array of Integer;
begin
//GET /dll/lyricsvr.dll?dl?Id=228350&Code=1424073039 HTTP/1.1
    qqHexStr := ToHexString(singer + title, 'UTF8');
    MyLen := Length(qqHexStr) div 2;
    SetLength(song, mylen);
    for I := 0 to MyLen - 1 do
        song[i] := StrToInt64('$' + copy(qqHexStr, i * 2 + 1, 2));
    t2 := 0;
    t1 := (lrcId and $0000FF00) shr 8;
    t:= lrcId and $00FF0000;
    if t = 0 then
        t3 := $000000FF and (not t1)
    else
        t3 := $000000FF and (t shr 16);
    t3 := t3 or (($000000FF and lrcId) shl 8);
    t3 := t3 shl 8;
    t3 := t3 or ($000000FF and t1);
    t3 := t3 shl 8;
    if ((lrcId and $FF000000) = 0) then
        t3 := t3 or ($000000FF and (not lrcId))
    else
        t3 := t3 or ($000000FF and (lrcId shr 24));
    j := MyLen - 1;
    while (j >= 0) do
    begin
        c := song[j];
        if (c >= 128) then
            c := c - 256;
        t1 := (c + t2) and $00000000FFFFFFFF;
        t2 := (t2 shl (j mod 2 + 4)) and $00000000FFFFFFFF;
        t2 := (t1 + t2) and $00000000FFFFFFFF;
        Dec(j);
    end;
    j := 0;
    t1 := 0;
    while j <= (mylen - 1) do
    begin
        c := song[j];
        if (c >= 128) then
            c := c - 256;
        t4 := (c + t1) and $00000000FFFFFFFF;
        t1 := (t1 shl (j mod 2 + 3)) and $00000000FFFFFFFF;
        t1 := (t1 + t4) and $00000000FFFFFFFF;
        Inc(j);
    end;
    t5 := Conv(t2 xor t3);
    t5 := Conv(t5 + (t1 or lrcId));
    t5 := Conv(t5 * (t1 or t3));
    t5 := Conv(t5 * (t2 xor lrcId));
    t6 := t5;
    if (t6 > $80000000) then
        t5 := t6 - $100000000;
    Result := IntToStr(t5);
end;

function findID(id:WideString; list:TLyricEntryList):Boolean;
var i:Integer;
begin
  Result:= false;
  for i:=Low(list) to High(list) do
     if list[i].id = id then begin
       Result:= true;
       Break;
     end;
end;

function hexToStr(hex:string):string;
var i:integer;
begin
    result:='';
    i:=1;
    while i<length(hex) do begin
       result:= result + char(StrToInt('$'+hex[i]+hex[i+1]));
       i:=i+2;
    end;
end;

procedure vl_enc(data, md5_extra:string; out ms:TMemoryStream);
var datalen,j,i,magickey:integer; hasheddata:string; t:Tbytes;
begin
  hasheddata:= StrToMD5(data + md5_extra);
  hasheddata:=hexToStr(hasheddata);
  j:= 0; datalen:= length(data);
  for i:= 1 to datalen do
    j:= j + ord(data[i]);

  magickey:= round(j / datalen);
  for i:= 1 to datalen do
    data[i]:= char(ord(data[i]) xor magickey);
 hasheddata:= hasheddata + data;
 datalen := Length(hasheddata);
 SetLength(t, datalen + 6);
 t[0]:=$02; t[1]:=magickey; t[2]:=$04; t[3]:=$00; t[4]:=$00; t[5]:=$00;
 for i:= 1 to datalen do
   t[5 + i]:=byte(hasheddata[i]);
 ms:= TMemoryStream.Create;
 ms.Write(t[0],datalen + 6);
end;

function vl_dec(data:string):string;
var magickey,i:integer;
begin
  result:= ''; magickey:= ord(data[2]);
  for i:= 23 to length(data) do
    result:= result + char(ord(data[i]) xor magickey);
end;

end.
