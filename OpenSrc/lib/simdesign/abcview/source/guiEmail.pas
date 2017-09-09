{ Unit Emails

  Email possibly downscaled image files using Mapi.

  Project: ABC-View Manager

  Author: Nils Haeck M.Sc.
  Copyright (c) 2000 - 2005 by SimDesign B.V.

  It is NOT allowed to publish or copy this software without express permission
  of the author!

}
unit guiEmail;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, ComCtrls, RXSlider, Buttons, MapiControl, sdProperties,
  sdItems, guiFeedback, NativeJpg, ExtCtrls, sdProcessThread, sdAbcVars,
  sdAbcFunctions;

type

  TsdMailer = class(TComponent)
  private
    FDisplayFileName: TStrings;
    FAttachedFileName: TStrings;
    FMailText: string;
    FSubject: string;
    FShowDialog: Boolean;
    FUseMAPI: boolean;
    FMapiControl: TMapiControl;
    procedure SetAttachedFileName(const Value: TStrings);
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    procedure Reset;
    procedure Sendmail;
  published
    property Body: string read FMailText write FMailText;
    property Subject: string read FSubject write FSubject;
    property AttachedFiles: TStrings read FAttachedFileName write SetAttachedFileName;
    property DisplayFileName: TStrings read FDisplayFileName;
    property ShowDialog: Boolean read FShowDialog write FShowDialog;
    // set UseMAPI := True to use MAPI instead of homegrown
    property UseMAPI: boolean read FUseMAPI write FUseMAPI;
  end;

  TfrmEmail = class(TForm)
    GroupBox1: TGroupBox;
    rbMAPI: TRadioButton;
    rbStandard: TRadioButton;
    gbAttach: TGroupBox;
    lvFiles: TListView;
    GroupBox3: TGroupBox;
    chbSizeLimit: TCheckBox;
    cbbSizeLimit: TComboBox;
    chbReduceSize: TCheckBox;
    chbReduceQual: TCheckBox;
    Label1: TLabel;
    Label2: TLabel;
    cbbMaxResolution: TComboBox;
    edWidth: TEdit;
    Label3: TLabel;
    edHeight: TEdit;
    Label4: TLabel;
    Label5: TLabel;
    Label7: TLabel;
    DelaySlider: TRxSlider;
    Label8: TLabel;
    Label9: TLabel;
    Label10: TLabel;
    BitBtn1: TBitBtn;
    btnNext: TBitBtn;
    BitBtn3: TBitBtn;
    Button1: TButton;
    lbReduced: TLabel;
    GroupBox2: TGroupBox;
    edSubject: TEdit;
    procedure FormCreate(Sender: TObject);
    procedure lvFilesData(Sender: TObject; Item: TListItem);
    procedure chbReduceSizeClick(Sender: TObject);
    procedure Button1Click(Sender: TObject);
    procedure edHeightExit(Sender: TObject);
    procedure cbbMaxResolutionChange(Sender: TObject);
  private
    FFiles: TList;
    FMaxWidth: integer;
    FMaxHeight: integer;
    FMailer: TsdMailer;
    procedure SetFiles(Value: TList);
    procedure FileAddAttachProp(AFile: TsdFile);
  public
    FNumFiles,                // Number of files in Filelist
    FNumBytes: int64;         // Number of bytes
    property Files: TList read FFiles write SetFiles;
    procedure SendEmail;
    procedure SetNotification;
    procedure SetDimensionsFromEdit;
  end;

  // TPropAttachm holds information about the file when it will be used
  // as an attachment in e.g. mail messages. This property is not stored,
  // and will only be valid during a single session
  TprAttachment = class(TsdProperty)
  protected
    function GetName: string; override;
    function GetPropID: word; override;
    function GetValue: string; override;
  public
    OrigX,
    OrigY: integer;
    PixelFormat: TPixelFormat;
    NotAnImage: boolean;
    SizeIsReduced: boolean;
    ReducedX,
    ReducedY: integer;
    TempFile: string; // Tempfile holds the name of the temporary file that holds
                      // the attachment or is empty if file is attached directly
    TempX,
    TempY: integer;
  end;

  TEmailThread = class(TProcess)
  public
    Parent: TObject;
    procedure Run; override;
  end;

var
  frmEmail: TfrmEmail;

implementation

uses
  guiMain, {Utils,} ImageProcessors, sdGraphicLoader;

{$R *.DFM}

procedure TFrmEmail.SetFiles(Value: TList);
begin
  FFiles := Value;
  SetNotification;
end;

procedure TFrmEmail.SendEmail;
var
  i: integer;
  Attach: TprAttachment;
  AttachFiles,
  DisplayFiles: TStrings;
  TotalSize,
  SizeLimit: int64;
  Part: integer;
  MultiPart: boolean;
  UserSubject: string;
  Resizer: TImageProcessor;
begin
  // Initialize
  chbReduceSize.Checked := False;
  chbReduceQual.Checked := False;
  lbReduced.Visible := False;
  Files := frmMain.SelectedItems;
  if Files.Count = 0 then
  begin
    MessageDlg(
      'You must first select some images that you want to send by email.',
      mtInformation, [mbOK, mbHelp], 0);
    exit;
  end;
  if ShowModal = mrOK then
  begin

    // Setup feedback dialog
    Feedback.Start;
    AttachFiles := TStringList.Create;
    DisplayFiles := TStringList.create;
    Resizer := TImageProcessor.Create;
    with Resizer do
    begin
      FeedbackDialog := Feedback;
      Commands.Add(CreateDownSampleCommand(FMaxWidth, FMaxHeight));
    end;
    try

      // Add tasks
      with Files do
        for i := 0 to Count - 1 do if TsdItem(Items[i]).ItemType = itFile then
        begin
          Attach := TprAttachment(TsdItem(Items[i]).GetProperty(prAttachment));
          if assigned(Attach) and Attach.SizeIsReduced then
            with Attach do
              Feedback.Add(Format('Resize %s to %dx%d',
                [TsdFile(Items[i]).Name, Attach.ReducedX, Attach.ReducedY]));
        end;

      Feedback.Add('Create mail message(s)');

      // Loop through the list and process each file
      with Files do
        for i := 0 to Count - 1 do
          if TsdItem(Items[i]).ItemType = itFile then
          begin

            Attach := TprAttachment(TsdItem(Items[i]).GetProperty(prAttachment));
            if assigned(Attach) and Attach.SizeIsReduced then
            with Attach do
            begin

              // Check existing temporary files
              if length(TempFile) > 0 then
              begin
                if FileExists(TempFile) then
                begin
                  if (TempX <> ReducedX) or (TempY <> ReducedY) then
                  begin
                    DeleteFile(TempFile);
                    TempFile := '';
                  end;
                end else
                begin
                  TempFile := '';
                end;
              end;

              if length(TempFile) = 0 then
              begin
                with Resizer do
                begin
                  InputFile := TsdFile(Items[i]).FileName;
                  OutputFile := frmMain.GetNewTempFile;
                  Execute;
                  if OutputResult = gsGraphicsOK then
                  begin
                    AttachFiles.Add(OutputFile);
                    Attach.TempX := OutputBitmap.Width;
                    Attach.TempY := OutputBitmap.Height;
                    Feedback.Status := tsCompleted;
                  end else
                  begin
                    Feedback.AddError('Unable to rescale image');
                    Feedback.Status := tsError;
                  end;
                end;

              end else
              begin

                // Re-use temp file
                AttachFiles.Add(TempFile);
              end;

              // And add the display filename
              DisplayFiles.Add(
                ChangeFileExt(
                  TsdFile(Items[i]).Name,                    // Original name
                  cOutputFormatExt[Resizer.OutputFormat]   // Rename extension
                  ));


            end else
            begin

              // No reduceing
              AttachFiles.Add(TsdFile(Items[i]).FileName);
              DisplayFiles.Add(TsdFile(Items[i]).FileName);

            end;

          end;

      UserSubject := edSubject.Text;
      if UserSubject = '' then
        UserSubject := '<Type subject here>';

      i := 0;
      Part := 0;
      SizeLimit := round(0.7 * SizeStrToInt(cbbSizeLimit.Text));
      MultiPart := False;
      while i < AttachFiles.Count do
        with FMailer do
        begin

          Reset;
          TotalSize := 0;

          repeat
            inc(TotalSize, sdGetFileSize(AttachFiles[i]));
            AttachedFiles.Add(AttachFiles[i]);
            DisplayFileName.Add(DisplayFiles[i]);
            inc(i);
          until ((TotalSize > SizeLimit) and chbSizeLimit.Checked) or
                (i = AttachFiles.Count);

          if i < AttachFiles.Count then
            MultiPart := True;

          inc(Part);
          Feedback.Info := Format('Creating email (part %d)', [Part]);

          Body :=
            #13#10'_____________________________________________'#13#10+
                  'This email was created with ABC-View Manager'#13#10+
                  'Download your copy at http://www.abc-view.com/';
          if MultiPart then
            Subject := Format('%s (part %d)', [UserSubject, Part])
          else
            Subject := UserSubject;

          ShowDialog := True;

          if MultiPart then

            // Send this part
            FMailer.SendMail

          else

            // Use a thread if just one part
            with TEmailThread.Create(True, glProcessList) do
            begin
              Parent := Self;
              Resume;
            end;

        end;

      Feedback.Status := tsCompleted;

    finally
      Feedback.Finish;
      AttachFiles.Free;
      DisplayFiles.Free;
      Resizer.Free;
    end;
  end;
  Files := nil;
end;

procedure TfrmEmail.SetDimensionsFromEdit;
var
  i: integer;
  NewEntry: string;
begin
  FMaxWidth  := StrToInt(edWidth.Text);
  FMaxHeight := StrToInt(edHeight.Text);
  NewEntry := Format('%dx%d pixels',[FMaxWidth, FMaxHeight]);

  with cbbMaxResolution do
  begin
    // Add this one to the combo box
    i := 0;
    while i < Items.Count do
      if Items[i] = NewEntry then
        Items.Delete(i)
      else
        inc(i);
    Items.Insert(0, NewEntry);
    // Maximum lines
    while Items.Count > FItemHistoryCount do
      Items.Delete(Items.Count - 1);
    // Text box
    ItemIndex:=0;
  end;

end;

procedure TfrmEmail.SetNotification;
var
  i: integer;
  ASize: int64;
  Attach: TprAttachment;
begin
  if not assigned(FFiles) then
    exit;

  // MAPI?
  if rbMAPI.Checked then
    FMailer.UseMAPI := True
  else
    FMailer.UseMAPI := False;

  // Calculate attachment sizes
  FNumFiles := 0;
  FNumBytes := 0;
  lbReduced.Visible := False;
  SetDimensionsFromEdit;

  for i := 0 to FFiles.Count - 1 do
    with TsdFile(FFiles[i]) do
    begin
      inc(FNumFiles);
      // Reductions?
      ASize := Size;
      if chbReduceSize.Checked then
      begin

        FMaxWidth  := StrToInt(edWidth.Text);
        FMaxHeight := StrToInt(edHeight.Text);

        FileAddAttachProp(TsdFile(FFiles[i]));
        Attach := TprAttachment(GetProperty(prAttachment));

        if assigned(Attach) then
          with Attach do
          begin

            if not NotAnImage then
            begin

              // Determine reduced size
              SizeIsReduced := False;
              ReducedX := OrigX;
              ReducedY := OrigY;
              if OrigX > FMaxWidth then
              begin
                lbReduced.Visible := True;
                SizeIsReduced := True;
                ReducedX := FMaxWidth;
                ReducedY := MulDiv(OrigY, FMaxWidth, OrigX);
              end;
              if ReducedY > FMaxHeight then
              begin
                lbReduced.Visible := True;
                SizeIsReduced := True;
                ReducedX := MulDiv(OrigX, FMaxHeight, OrigY);
                ReducedY := FMaxHeight;
              end;

              // determine factor
              if (OrigX > 0) and (OrigY > 0) then
                ASize := MulDiv(ASize, ReducedX * ReducedY, OrigX * OrigY);

            end;
          end;

      end else
      begin

        Attach := TprAttachment(GetProperty(prAttachment));
        if assigned(Attach) then
          with Attach do
          begin
            SizeIsReduced := False;
            ReducedX := OrigX;
            ReducedY := OrigY;
          end;

      end;
      inc(FNumBytes, ASize);

    end;

  lvFiles.Items.Count := FFiles.Count;
  lvFiles.Invalidate;

  gbAttach.Caption := Format(
    'Attachments that will be added to the email (%d files, approx. %dKB)',
    [FNumFiles, round(FNumBytes/1024)]);


end;

procedure TfrmEmail.FileAddAttachProp(AFile: TsdFile);
var
  Attach: TprAttachment;
begin
  if not assigned(AFile) then
    exit;

  // Dimensions, look for the special TPropAttachm
  Attach := TprAttachment(AFile.GetProperty(prAttachment));
  if not assigned(Attach) then
  begin
    // Create it!
    Attach := TprAttachment.Create;
    with Attach do
    begin
      if not AFile.GetImageDimensions(OrigX, OrigY, PixelFormat) then
        NotAnImage := True;
    end;
    AFile.AddProperty(Attach);
  end;
end;

procedure TfrmEmail.FormCreate(Sender: TObject);
begin
  lvFiles.SmallImages := FSmallIcons;
  cbbMaxResolution.ItemIndex := 0;
  FMailer := TsdMailer.Create(Self);
end;

procedure TfrmEmail.lvFilesData(Sender: TObject; Item: TListItem);
var
  AItem: TsdItem;
  Attach: TprAttachment;
begin

  if assigned(FFiles) and (Item.Index < FFiles.Count) then
  begin
    AItem := TsdItem(FFiles[Item.Index]);
    // Files
    if AItem.ItemType = itFile then
      with TsdFile(AItem) do
      begin

        Item.Caption := Name;
        Item.ImageIndex := Icon;
        Item.SubItems.Add(FolderName);

        // Dimensions, look for the special TPropAttachm
        FileAddAttachProp(TsdFile(AItem));

        Attach := TprAttachment(GetProperty(prAttachment));
        if assigned(Attach) then
          Item.SubItems.Add(Attach.Value);

      end;
  end else
    Item.Caption := '*error*';
end;

function TprAttachment.GetName: string;
begin
  Result:='As attachment';
end;

function TprAttachment.GetPropID: word;
begin
  Result := prAttachment;
end;

function TprAttachment.GetValue: string;
begin
  if NotAnImage then
    Result := 'Not an image'
  else
  begin
    if SizeIsReduced then
      Result := Format('%dx%d pixels*',[ReducedX, ReducedY])
    else
      Result := Format('%dx%d pixels',[OrigX, OrigY]);
  end;
end;

procedure TfrmEmail.chbReduceSizeClick(Sender: TObject);
begin
  Screen.Cursor := crHourGlass;
  try
    SetNotification;
  finally
    Screen.Cursor := crDefault;
  end;
end;

procedure TEmailThread.Run;
begin
  // this is all we do!
  TfrmEmail(Parent).FMailer.SendMail;
end;

procedure TfrmEmail.Button1Click(Sender: TObject);
begin
  SetNotification;
end;

procedure TfrmEmail.edHeightExit(Sender: TObject);
begin
  SetNotification;
end;

procedure TfrmEmail.cbbMaxResolutionChange(Sender: TObject);
var
  APos: integer;
  AText: string;
begin
  // copy the values to the edit boxes
  AText := cbbMaxResolution.Text;

  // first value
  APos := Pos('x', AText);
  if APos > 0 then
  begin
    edWidth.Text := Copy(AText, 1, APos - 1);
    Delete(AText, 1, APos);
  end;

  // second value
  APos := Pos(' ', AText);
  if APos > 0 then
  begin
    edHeight.Text := Copy(AText, 1, APos - 1);
  end;

  // Notify
  SetNotification;
end;

{ TsdMailer }

constructor TsdMailer.Create(AOwner: TComponent);
begin
  inherited;
  FDisplayFileName := TStringList.Create;
  FAttachedFileName := TStringList.Create;
  FMapiControl := TMapiControl.Create(Self);
//  Reset;
end;

destructor TsdMailer.Destroy;
begin
  FDisplayFileName.Free ;
  FAttachedFileName.Free;
  FMapiControl.Free;
  inherited;
end;

procedure TsdMailer.Reset;
begin
  if FUseMAPI then
    FMapiControl.Reset
  else
  begin
    // reset our own
    FDisplayFileName.Clear;
    FAttachedFileName.Clear;
    FMailText := '';
    FSubject := '';
    FShowDialog := False;
  end;
end;

procedure TsdMailer.Sendmail;
var
  F: TFileStream;
begin
  if FUseMAPI then
    FMapiControl.SendMail
  else
  begin
    F := TFileStream.Create('email.eml', fmCreate, fmShareExclusive);
    try
      F.Write('dit is een emailtje', 10);
    finally
      F.Free;
    end;
  end;
end;

procedure TsdMailer.SetAttachedFileName(const Value: TStrings);
begin
  FAttachedFileName := Value;
end;

end.
