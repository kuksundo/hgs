{******************************************************************

                       JEDI-VCL Demo

 Copyright (C) 2002 Project JEDI

 Original author:

 Contributor(s):

 You may retrieve the latest version of this file at the JEDI-JVCL
 home page, located at http://jvcl.delphi-jedi.org

 The contents of this file are used with permission, subject to
 the Mozilla Public License Version 1.1 (the "License"); you may
 not use this file except in compliance with the License. You may
 obtain a copy of the License at
 http://www.mozilla.org/MPL/MPL-1_1Final.html

 Software distributed under the License is distributed on an
 "AS IS" basis, WITHOUT WARRANTY OF ANY KIND, either express or
 implied. See the License for the specific language governing
 rights and limitations under the License.

******************************************************************}

unit ConfigForm;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms,
  Dialogs, ImgList, ComCtrls, JvPageListTreeView, ExtCtrls, StdCtrls, ActnList,
  JvButton, JvFooter, JvComponent, JvGroupHeader, JvCombobox, JvColorCombo,
  Buttons, JvBitBtn, JvExStdCtrls, JvExControls, JvExButtons, JvExExtCtrls,
  JvExComCtrls, JvPageList, JvCtrls, JvExtComponent, JvComCtrls, Options,
  JvComponentBase, JvgXMLSerializer, Mask, JvExMask, JvToolEdit;

type
  TConfigFormF = class(TForm)
    ImageList1: TImageList;
    StatusBar1: TStatusBar;
    Panel1: TPanel;
    Splitter1: TSplitter;
    JvPagedTreeView1: TJvSettingsTreeView;
    ActionList1: TActionList;
    JvStandardPage2: TJvStandardPage;
    JvStandardPage4: TJvStandardPage;
    JvStandardPage1: TJvStandardPage;
    JvStandardPage5: TJvStandardPage;
    JvFooter1: TJvFooter;
    JvFooterBtn2: TJvFooterBtn;
    JvFooterBtn3: TJvFooterBtn;
    JvPageList1: TJvPageList;
    pgNtwork: TJvStandardPage;
    JvGroupHeader3: TJvGroupHeader;
    TCPPortEdit: TEdit;
    pgXML: TJvStandardPage;
    JvGroupHeader1: TJvGroupHeader;
    JvGroupHeader2: TJvGroupHeader;
    ImageList2: TImageList;
    Label7: TLabel;
    Label8: TLabel;
    Label2: TLabel;
    UDPPortEdit: TEdit;
    JvgXMLSerializer: TJvgXMLSerializer;
    XMLFilenameEdit: TJvFilenameEdit;
    Label3: TLabel;
    IPAddress1: TEdit;
    Label1: TLabel;
    SendIntervalEdit: TEdit;
    Label4: TLabel;
    UseUDPCB: TCheckBox;
    procedure FormCreate(Sender: TObject);
    procedure JvFooterBtn2Click(Sender: TObject);
    procedure JvFooterBtn3Click(Sender: TObject);
    procedure JvGroupHeader2Click(Sender: TObject);
  private
  public
    FOptions: TOptionComponent;
    FConfigFileName: string;

    procedure SaveConfigVar2File(AFileName: string);
    procedure LoadConfigFile2Var(AFileName: string);
    procedure LoadConfigVar2Form;
    procedure LoadConfigForm2Var;
  end;

var
  ConfigFormF: TConfigFormF;

implementation

{$R *.dfm}

procedure TConfigFormF.FormCreate(Sender: TObject);
begin
  //FOptions := TOptionComponent.Create(Self);
end;

procedure TConfigFormF.JvFooterBtn2Click(Sender: TObject);
begin
  if Assigned(FOptions) then
  begin
    if FConfigFileName = '' then
      ShowMessage('Not assigned file name!')
    else
    begin
      if MessageDlg('Are you save?', mtConfirmation,[mbYes, mbNo],0) = mrYes then
      begin
        LoadConfigForm2Var;
        SaveConfigVar2File(FConfigFileName);
      end;
    end;
  end;
end;

procedure TConfigFormF.JvFooterBtn3Click(Sender: TObject);
begin
  Close;
end;

procedure TConfigFormF.JvGroupHeader2Click(Sender: TObject);
begin

end;

//FOptions Data를 XML 파일에 저장함.
procedure TConfigFormF.SaveConfigVar2File(AFileName: string);
var
  Fs: TFileStream;
begin
  FOptions.SaveToFile(AFileName);
  //Fs := TFileStream.Create(AFileName, fmCreate);
  //try
  //  JvgXMLSerializer.Serialize(FOptions, Fs);
  //finally
  //  Fs.Free;
  //end;

  ShowMessage('Object has been saved to the file '#13#10 + AFileName);
end;

procedure TConfigFormF.LoadConfigFile2Var(AFileName: string);
begin
  //file이 없으면 생성하고
  if not FileExists(AFileName) then
  begin
    FOptions.ParamFileName := AFileName;
    FOptions.SaveToFile(AFileName);
  end
  else
  begin
    FOptions.Option.Clear;
    FOptions.LoadFromFile(AFileName);
  end;
end;

//Config Form의 설정값을 FOptions에 저장함.
procedure TConfigFormF.LoadConfigForm2Var;
begin
  FOptions.ParamFileName := XMLFilenameEdit.Text;
  FOptions.Option.Clear;
  FOptions.IPAddress := IPAddress1.Text;
  FOptions.TCPPort := StrToIntDef(TCPPortEdit.Text,1000);
  FOptions.UDPPort := StrToIntDef(UDPPortEdit.Text,1001);
  FOptions.SendInterval := StrToIntDef(SendIntervalEdit.Text, 1000);
  FOptions.UseUDP := UseUDPCB.Checked;
end;

procedure TConfigFormF.LoadConfigVar2Form;
begin
  //if FOptions.Option.Count = 0 then
  //  FOptions.AddDefautProperties;
    
  XMLFilenameEdit.Text := FOptions.ParamFileName;
  IPAddress1.Text := FOptions.IPAddress;
  TCPPortEdit.Text := IntToStr(FOptions.TCPPort);
  UDPPortEdit.Text := IntToStr(FOptions.UDPPort);
  SendIntervalEdit.Text := IntToStr(FOptions.SendInterval);
  UseUDPCB.Checked := FOptions.UseUDP;
end;

end.
