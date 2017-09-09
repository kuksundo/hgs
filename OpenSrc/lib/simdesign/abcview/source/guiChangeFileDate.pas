{ Unit ChangeFileDates

  This unit implements batch-changing of file's "modified" date

  Modifications:
  21May2004:
    Added feature to add/substract years/months/days from the date

  Project: ABC-View Manager

  Author: Nils Haeck M.Sc.
  Copyright (c) 2000 - 2005 by SimDesign B.V.

  It is NOT allowed to publish or copy this software without express permission
  of the author!

}
unit guiChangeFiledate;


interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, Buttons, Grids, Mask, rxToolEdit, ExtCtrls, {$warnings off}FileCtrl, {$warnings on}
  ComCtrls, ActnList, ImgList, Contnrs, RXSpin, sdItems, NativeXml, sdAbcVars;

type

  TBatchChangeDateItem = class
  public
    Icon: integer;      // Icon index in system image list
    Ref: TsdItem;       // Pointer to the TItem
    Name: string;
    OldDate: TDateTime;
    NewDate: TDateTime;
    Error: boolean;
    Exif: TXmlNode;
    destructor Destroy; override;
  end;

  TfrmChangeFiledate = class(TForm)
    Label2: TLabel;
    BitBtn1: TBitBtn;
    BitBtn2: TBitBtn;
    BitBtn3: TBitBtn;
    GroupBox1: TGroupBox;
    Label3: TLabel;
    GroupBox2: TGroupBox;
    GroupBox3: TGroupBox;
    lvFiles: TListView;
    BitBtn4: TBitBtn;
    alRename: TActionList;
    ilRename: TImageList;
    RemoveFromList: TAction;
    BitBtn5: TBitBtn;
    rbDateNow: TRadioButton;
    rbDateFixed: TRadioButton;
    rbDateDelta: TRadioButton;
    rbDateEXIF: TRadioButton;
    rbDateSelected: TRadioButton;
    rbDateDatabase: TRadioButton;
    tmDate: TTimer;
    deFixedDate: TDateEdit;
    edFixedTime: TEdit;
    sbFixedHour: TRxSpinButton;
    sbFixedMin: TRxSpinButton;
    Label1: TLabel;
    Label4: TLabel;
    edDeltaTime: TEdit;
    Label5: TLabel;
    sbDeltaHour: TRxSpinButton;
    Label6: TLabel;
    sbDeltaMin: TRxSpinButton;
    cbbDelta: TComboBox;
    lbWarning: TLabel;
    rbYearDelta: TRadioButton;
    edDeltaYear: TEdit;
    Label7: TLabel;
    udDeltaYear: TUpDown;
    edDeltaMonth: TEdit;
    udDeltaMonth: TUpDown;
    Label8: TLabel;
    edDeltaDay: TEdit;
    udDeltaDay: TUpDown;
    Label9: TLabel;
    procedure FormCreate(Sender: TObject);
    procedure lvFilesData(Sender: TObject; Item: TListItem);
    procedure RemoveFromListExecute(Sender: TObject);
    procedure alRenameUpdate(Action: TBasicAction; var Handled: Boolean);
    procedure FormDestroy(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure ValidateControls(Sender: TObject);
    procedure tmDateTimer(Sender: TObject);
    procedure lvFilesChange(Sender: TObject; Item: TListItem;
      Change: TItemChange);
    procedure sbFixedHourTopClick(Sender: TObject);
    procedure sbFixedHourBottomClick(Sender: TObject);
    procedure sbFixedMinTopClick(Sender: TObject);
    procedure sbFixedMinBottomClick(Sender: TObject);
    procedure sbDeltaHourTopClick(Sender: TObject);
    procedure sbDeltaHourBottomClick(Sender: TObject);
    procedure sbDeltaMinTopClick(Sender: TObject);
    procedure sbDeltaMinBottomClick(Sender: TObject);
  protected
    procedure DoPreview;
  public
    FItems: TObjectList;
    procedure SetFilesFromSelection(Value: TList);
    procedure SetNotification;
  end;

var
  frmChangeFiledate: TfrmChangeFiledate;

implementation

uses
  Links, sdMetadataExif;

const

  cDateFormat = 'YYYY:MM:DD HH:NN:SS';
  cTimeFormat = 'HH:MM:SS';

{$R *.DFM}

destructor TBatchChangeDateItem.Destroy;
begin
  if assigned(Exif) then
    FreeAndNil(Exif);
end;

procedure TfrmChangeFiledate.FormCreate(Sender: TObject);
begin
  // Initialization
  lvFiles.SmallImages := FSmallIcons;
  FItems := TObjectList.Create;
  cbbDelta.ItemIndex := 0;
  lbWarning.Visible := False;
end;

procedure TfrmChangeFiledate.SetNotification;
begin
  if not assigned(FItems) then exit;
  Label3.Caption:=Format('You''re about to change the "modified" date of these %d files.',
    [FItems.Count]);
end;

procedure TfrmChangeFiledate.DoPreview;
var
  i: integer;
  AText: string;
  Xml: TNativeXml;
  AChild, ATag: TXmlNode;
  AYear, AMonth, ADay: word;
  NewMonth, NewYear: integer;
  BCD: TBatchChangeDateItem;
begin
  // find new date
  for i := 0 to FItems.Count - 1 do
  begin
    BCD := TBatchChangeDateItem(FItems[i]);
    try
      BCD.Error := False;
      // Current date
      if rbDateNow.Checked then
        BCD.NewDate := Now;

      // Fixed Date
      if rbDateFixed.Checked then
      begin
        AText := edFixedTime.Text;
        if AText = '' then
          AText := '00:00';
        BCD.NewDate := deFixedDate.Date + StrToTime(AText);
      end;

      // To date of selected
      if rbDateSelected.Checked then
      begin
        if assigned(lvFiles.Selected) then
          BCD.NewDate := TBatchChangeDateItem(FItems[lvFiles.Selected.Index]).OldDate;
      end;

      // Add/Substract hours/minutes
      if rbDateDelta.Checked then
      begin
        AText := edDeltaTime.Text;
        if cbbDelta.ItemIndex = 0 then
          // Add
          BCD.NewDate := BCD.OldDate + StrToTime(AText)
        else
          // Substract
          BCD.NewDate := BCD.OldDate - StrToTime(AText);
      end;

      // Add/Substract years, months, days
      if rbYearDelta.Checked then
      begin
        // decode old date
        DecodeDate(trunc(BCD.OldDate), AYear, AMonth, ADay);
        // Add year and month
        NewMonth := AMonth + udDeltaMonth.Position;
        NewYear  := AYear  + udDeltaYear.Position;
        while NewMonth > 12 do
        begin
          dec(NewMonth, 12);
          inc(NewYear);
        end;
        while NewMonth < 1 do
        begin
          inc(NewMonth, 12);
          dec(NewYear);
        end;
        BCD.NewDate := EncodeDate(NewYear, NewMonth, ADay) + Frac(BCD.OldDate);
        // Days we simply add by adding
        BCD.NewDate := BCD.NewDate + udDeltaDay.Position;
      end;

      // Change to EXIF date
      if rbDateExif.Checked then
      begin
        BCD.NewDate := BCD.OldDate;
        if not assigned(BCD.Exif) then
        begin
          // Try to load the exif info
          Xml := TNativeXml.CreateName('exif', Self);
          BCD.Exif := Xml.Root;
          BCD.Ref.GetTags(BCD.Exif);
        end;
        if assigned(BCD.Exif) then
        begin
          // Try to find the 'Exif' tags
          AChild := BCD.Exif.NodebyName('EXIF');
          if assigned(AChild) then
          begin
            // DateTime field
            ATag := AChild.NodeByName('DateTime');
            if assigned(ATag) then
            begin
              sdExifDateToDateTime(ATag.Value, BCD.NewDate);
              continue;
            end;
            // DateTime original field
            ATag := AChild.NodeByName('DateTimeOriginal');
            if assigned(ATag) then
            begin
              {Res := }sdExifDateToDateTime(ATag.Value, BCD.NewDate);
              continue;
            end;
            // DateTime digitized field
            ATag := AChild.NodeByName('DateTimeDigitized');
            if assigned(ATag) then
            begin
              {Res := }sdExifDateToDateTime(ATag.Value, BCD.NewDate);
              continue;
            end;
            // Arriving here means not found
            BCD.Error := True;
          end else
          begin
            // No Exif found
            BCD.Error := True;
          end;
        end;
      end;

    except
      BCD.NewDate := BCD.OldDate;
      BCD.Error := True;
    end;
  end;

  // Update the listview
  if lvFiles.Items.Count <> FItems.Count then
    lvFiles.Items.Count := FItems.Count;
  lvFiles.Invalidate;

  // Update the notification
  SetNotification;
end;

procedure TfrmChangeFiledate.SetFilesFromSelection(Value: TList);
var
  i: integer;
  Item: TBatchChangeDateItem;
begin
  if not assigned(Value) then
    exit;
  // Create the object list
  for  i := 0 to Value.Count - 1 do
    if TsdItem(Value[i]).ItemType in [itFile] then
    begin
      Item := TBatchChangeDateItem.Create;
      Item.Ref := Value[i];
      case TsdItem(Value[i]).ItemType of
      itFile:
        begin
          Item.Name := TsdFile(Value[i]).Name;
          Item.OldDate := TsdFile(Value[i]).Modified;
          Item.NewDate := Item.OldDate;
        end;
      end;
      Item.Icon := TsdItem(Value[i]).Icon;
      FItems.Add(Item);
    end;
  if Value.Count <= 100 then
    lvFiles.DoubleBuffered := True;
  SetNotification;
end;

procedure TfrmChangeFiledate.lvFilesData(Sender: TObject; Item: TListItem);
var
  AFile: TBatchChangeDateItem;
begin
  if Item.Index < FItems.Count then
  begin
    AFile := TBatchChangeDateItem(FItems[Item.Index]);
    with AFile do
    begin
      Item.Caption := Name;
      Item.ImageIndex := Icon;
      Item.SubItems.Add(FormatDateTime(cDateFormat, OldDate));
      if NewDate = 0 then
      begin
        Item.SubItems.Add('Error')
      end else
      begin
        if Error then
        begin
          Item.SubItems.Add('Use Old Date*');
          lbWarning.Visible := True;
        end else
          Item.SubItems.Add(FormatDateTime(cDateFormat, NewDate));
      end;    
    end;
  end else
    Item.Caption := '*error*';
  SetNotification;
end;

procedure TfrmChangeFiledate.RemoveFromListExecute(Sender: TObject);
var
  i: integer;
  Item: TListItem;
  Remove: TList;
begin

  Remove := TList.Create;
  try

    // Create temp remove list
    with lvFiles do
      if (SelCount > 0) then
      begin
        Item := Selected;
        repeat
          if Item.Selected then
            Remove.Add(FItems[Item.Index]);
          Item := GetNextItem(Item, sdAll, [isSelected]);
        until Item = nil;
      end;

    // Remove the selected entries from the files list
    for i := 0 to Remove.Count - 1 do
      FItems.Remove(Remove[i]);

  finally
    Remove.Free;
  end;
  ValidateControls(Self);
end;

procedure TfrmChangeFiledate.alRenameUpdate(Action: TBasicAction;
  var Handled: Boolean);
begin
  // Determine the state of the controls (actions)
  RemoveFromList.Enabled := lvFiles.SelCount > 0;
  Handled := True;
end;

procedure TfrmChangeFiledate.FormDestroy(Sender: TObject);
begin
  if assigned(FItems) then
    FreeAndNil(FItems);
end;

procedure TfrmChangeFiledate.FormShow(Sender: TObject);
begin
  ValidateControls(Self);
end;

procedure TfrmChangeFiledate.ValidateControls(Sender: TObject);
begin
  // Validate the controls
  DoPreview;

  // The enabled and visible states
  rbDateSelected.Enabled := lvFiles.SelCount = 1;
  rbDateDatabase.Enabled := False;

  deFixedDate.Visible := rbDateFixed.Checked;
  edFixedTime.Visible := rbDateFixed.Checked;
  label1.Visible := rbDateFixed.Checked;
  label4.Visible := rbDateFixed.Checked;
  sbFixedHour.Visible := rbDateFixed.Checked;
  sbFixedMin.Visible := rbDateFixed.Checked;

  cbbDelta.Visible := rbDateDelta.Checked;
  label5.Visible := rbDateDelta.Checked;
  label6.Visible := rbDateDelta.Checked;
  edDeltaTime.Visible := rbDateDelta.Checked;
  sbDeltaHour.Visible := rbDateDelta.Checked;
  sbDeltaMin.Visible := rbDateDelta.Checked;

  edDeltaYear.Visible := rbYearDelta.Checked;
  udDeltaYear.Visible := rbYearDelta.Checked;
  edDeltaMonth.Visible := rbYearDelta.Checked;
  udDeltaMonth.Visible := rbYearDelta.Checked;
  edDeltaDay.Visible := rbYearDelta.Checked;
  udDeltaDay.Visible := rbYearDelta.Checked;
  label7.Visible := rbYearDelta.Checked;
  label8.Visible := rbYearDelta.Checked;
  label9.Visible := rbYearDelta.Checked;

end;

procedure TfrmChangeFiledate.tmDateTimer(Sender: TObject);
begin
  tmDate.Enabled := False;
  // Do a preview each time
  DoPreview;
  tmDate.Enabled := True;
end;

procedure TfrmChangeFiledate.lvFilesChange(Sender: TObject;
  Item: TListItem; Change: TItemChange);
begin
  rbDateSelected.Enabled := lvFiles.SelCount = 1;
end;

procedure TfrmChangeFiledate.sbFixedHourTopClick(Sender: TObject);
begin
  try
    edFixedTime.Text := FormatDateTime(cTimeFormat, StrToTime(edFixedTime.Text) + 1/24);
  except
    edFixedTime.Text := '00:00:00';
  end;
end;

procedure TfrmChangeFiledate.sbFixedHourBottomClick(Sender: TObject);
begin
  try
    edFixedTime.Text := FormatDateTime(cTimeFormat, StrToTime(edFixedTime.Text) - 1/24);
  except
    edFixedTime.Text := '00:00:00';
  end;
end;

procedure TfrmChangeFiledate.sbFixedMinTopClick(Sender: TObject);
begin
  try
    edFixedTime.Text := FormatDateTime(cTimeFormat, StrToTime(edFixedTime.Text) + 1/(24*60));
  except
    edFixedTime.Text := '00:00:00';
  end;
end;

procedure TfrmChangeFiledate.sbFixedMinBottomClick(Sender: TObject);
begin
  try
    edFixedTime.Text := FormatDateTime(cTimeFormat, StrToTime(edFixedTime.Text) - 1/(24*60));
  except
    edFixedTime.Text := '00:00:00';
  end;
end;

procedure TfrmChangeFiledate.sbDeltaHourTopClick(Sender: TObject);
begin
  try
    edDeltaTime.Text := FormatDateTime(cTimeFormat, StrToTime(edDeltaTime.Text) + 1/24);
  except
    edDeltaTime.Text := '00:00:00';
  end;
end;

procedure TfrmChangeFiledate.sbDeltaHourBottomClick(Sender: TObject);
begin
  try
    edDeltaTime.Text := FormatDateTime(cTimeFormat, StrToTime(edDeltaTime.Text) - 1/24);
  except
    edDeltaTime.Text := '00:00:00';
  end;
end;

procedure TfrmChangeFiledate.sbDeltaMinTopClick(Sender: TObject);
begin
  try
    edDeltaTime.Text := FormatDateTime(cTimeFormat, StrToTime(edDeltaTime.Text) + 1/(24*60));
  except
    edDeltaTime.Text := '00:00:00';
  end;
end;

procedure TfrmChangeFiledate.sbDeltaMinBottomClick(Sender: TObject);
begin
  try
    edDeltaTime.Text := FormatDateTime(cTimeFormat, StrToTime(edDeltaTime.Text) - 1/(24*60));
  except
    edDeltaTime.Text := '00:00:00';
  end;
end;

end.
