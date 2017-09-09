unit UnitAlarmConfig;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, Buttons, ExtCtrls, JvExControls, JvComCtrls, JvToolEdit,
  Mask, JvExMask, ComCtrls, IniPersist, Vcl.Samples.Spin, UnitConfigIniClass,
  EditBtn, UnitSelectTagName, AdvGroupBox, NxColumns, NxColumnClasses,
  NxScrollControl, NxCustomGridControl, NxCustomGrid, NxGrid, NxEdit, UnitAlarmConst;

type
  TConfigSettings = class (TINIConfigBase)
  private
    FSharedName: String;
    FServerIP: string;
    FServerPort: string;
    FUserId: string;
    FUserPasswd: string;
    FMQServerIP: string;
    FMQServerPort: string;
    FMQUserId: string;
    FMQUserPasswd: string;
    FMQServerTopic: string;
    FConfigSource: string;
    FItemsFileName: string;
    FRunConditionFileName: string;
    FItemValueSelectInterval: string;
    FMyPortNo: string;
  public
    // Use the IniValue attribute on any property or field
    // you want to show up in the INI File.
    //Section Name, Key Name, Default Key Value
    [IniValue('Comm Server','Shared Name','')]
    property SharedName : String read FSharedName write FSharedName;
    [IniValue('Comm Server','Server IP','')]
    property ServerIP : String read FServerIP write FServerIP;
    [IniValue('Comm Server','Server Port','')]
    property ServerPort : String read FServerPort write FServerPort;
    [IniValue('Comm Server','User ID','')]
    property UserId : String read FUserId write FUserId;
    [IniValue('Comm Server','PassWord','')]
    property UserPasswd : String read FUserPasswd write FUserPasswd;
    [IniValue('MQ Server','MQ Server IP','')]
    property MQServerIP : String read FMQServerIP write FMQServerIP;
    [IniValue('MQ Server','MQ Server Port','')]
    property MQServerPort : String read FMQServerPort write FMQServerPort;
    [IniValue('MQ Server','MQ Server UserId','')]
    property MQServerUserId : String read FMQUserId write FMQUserId;
    [IniValue('MQ Server','MQ Server Passwd','')]
    property MQServerPasswd : String read FMQUserPasswd write FMQUserPasswd;
    [IniValue('MQ Server','MQ Server Topic','')]
    property MQServerTopic : string read FMQServerTopic write FMQServerTopic;
    [IniValue('Etc','Config Source','0')]
    property ConfigSource : string read FConfigSource write FConfigSource;
    [IniValue('Etc','Item Value Select Interval From DB','1000')]
    property ItemValueSelectInterval : string read FItemValueSelectInterval write FItemValueSelectInterval;
    [IniValue('Etc','My Port No','706')]
    property MyPortNo : string read FMyPortNo write FMyPortNo;
    [IniValue('File','Items File Name','')]
    property ItemsFileName : string read FItemsFileName write FItemsFileName;
    [IniValue('File','Run Condition File Name','')]
    property RunConditionFileName : string read FRunConditionFileName write FRunConditionFileName;
  end;

  TAlarmConfigF = class(TForm)
    PageControl1: TPageControl;
    Tabsheet2: TTabSheet;
    Label1: TLabel;
    Label3: TLabel;
    AlarmDBFilenameEdit: TJvFilenameEdit;
    Panel1: TPanel;
    BitBtn1: TBitBtn;
    BitBtn2: TBitBtn;
    RunCondFileEdit: TJvFilenameEdit;
    GroupBox1: TGroupBox;
    RB_bydate: TRadioButton;
    RB_byfilename: TRadioButton;
    RadioButton1: TRadioButton;
    ED_csv: TEdit;
    Label2: TLabel;
    AlarmItemFileEdit: TJvFilenameEdit;
    RelPathCB: TCheckBox;
    TabSheet1: TTabSheet;
    Label20: TLabel;
    Label21: TLabel;
    Label22: TLabel;
    Label25: TLabel;
    Label26: TLabel;
    Label9: TLabel;
    Label23: TLabel;
    ServerIPEdit: TEdit;
    UserEdit: TEdit;
    PasswdEdit: TEdit;
    ReConnectIntervalEdit: TSpinEdit;
    ServerPortEdit: TEdit;
    SharedNameEdit: TEdit;
    TabSheet3: TTabSheet;
    Label6: TLabel;
    Label7: TLabel;
    Label8: TLabel;
    Label10: TLabel;
    Label12: TLabel;
    Label13: TLabel;
    ServerEdit: TEdit;
    Edit1: TEdit;
    Edit2: TEdit;
    TableNameCombo: TComboBox;
    SpinEdit1: TSpinEdit;
    TabSheet4: TTabSheet;
    ConfigSourceRG: TRadioGroup;
    ConfigSourceEdit: TEdit;
    AlarmConditionSheet: TTabSheet;
    AdvGroupBox1: TAdvGroupBox;
    RunConditionGrid: TNextGrid;
    ProjNo: TNxTextColumn;
    EngNo: TNxTextColumn;
    ParamIndex: TNxTextColumn;
    TagName: TNxTextColumn;
    BtnCol: TNxImageColumn;
    Label4: TLabel;
    Label5: TLabel;
    ItemValueSelectInterval: TEdit;
    TagDesc: TNxTextColumn;
    Label11: TLabel;
    MyPortNoEdit: TEdit;
    TabSheet5: TTabSheet;
    Label14: TLabel;
    Label15: TLabel;
    Label16: TLabel;
    Label24: TLabel;
    Label17: TLabel;
    Label18: TLabel;
    MQIPAddress: TJvIPAddress;
    MQPortEdit: TEdit;
    MQUserEdit: TEdit;
    MQPasswdEdit: TEdit;
    MQTopicLB: TListBox;
    Button1: TButton;
    Button2: TButton;
    Edit3: TEdit;
    MQTopicEdit: TEdit;
    procedure ConfigSourceRGClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure NxButtonColumn1ButtonClick(Sender: TObject);
    procedure RunConditionGridSelectCell(Sender: TObject; ACol, ARow: Integer);
    procedure Button1Click(Sender: TObject);
    procedure Button2Click(Sender: TObject);
  private
    { Private declarations }
  public
    procedure LoadRunConditionFromFile(AFileName: string);
    procedure SaveRunCondition2File(AFileName: string);
    procedure LoadRunConditionFromList(AList: TMonEngInfoDict);
  end;

var
  AlarmConfigF: TAlarmConfigF;

implementation

uses UnitReporterMain, CommonUtil, HiMECSConst;

{$R *.dfm}

procedure TAlarmConfigF.Button1Click(Sender: TObject);
begin
  if Edit1.Text <> '' then
  begin
    if MQTopicLB.Items.IndexOf(Edit1.Text) = -1 then
      MQTopicLB.Items.Add(Edit1.Text)
    else
      ShowMessage('Topic is duplicated.');
  end;

end;

procedure TAlarmConfigF.Button2Click(Sender: TObject);
var
  i: integer;
begin
  if MQTopicLB.SelCount > 0 then
  begin
    for i := MQTopicLB.Count - 1 downto 0 do
    begin
      if MQTopicLB.Selected[i] then
        MQTopicLB.Items.Delete(i);
    end;
  end;
end;

procedure TAlarmConfigF.ConfigSourceRGClick(Sender: TObject);
begin
  ConfigSourceEdit.Text := IntToStr(ConfigSourceRG.ItemIndex);
end;

procedure TAlarmConfigF.FormCreate(Sender: TObject);
begin
  ConfigSourceEdit.Text := '';
  RunConditionGrid.DoubleBuffered := False;
end;

procedure TAlarmConfigF.LoadRunConditionFromFile(AFileName: string);
begin
//  RunConditionGrid.LoadFromTextFile(AFileName);
end;

procedure TAlarmConfigF.LoadRunConditionFromList(AList: TMonEngInfoDict);
var
  i, LRow: integer;
  LKey: string;
begin
  //기존 설정값이 없을때 실행 됨
  for LKey in AList.Keys do //ProjNo;EngNo;
  begin
    LRow := RunConditionGrid.AddRow;
    RunConditionGrid.CellByName['ProjNo',LRow].AsString := AList[Lkey].ProjNo;
    RunConditionGrid.CellByName['EngNo',LRow].AsString := AList[Lkey].EngNo;
    RunConditionGrid.CellByName['TagName',LRow].AsString := AList[Lkey].RunCondTagName;
    RunConditionGrid.CellByName['TagDesc',LRow].AsString := AList[Lkey].RunCondTagDesc;
    RunConditionGrid.CellByName['ParamIndex',LRow].AsString := AList[Lkey].RunCondParamIndex;
    RunConditionGrid.CellByName['BtnCol',LRow].AsInteger := 6;
  end;
end;

procedure TAlarmConfigF.NxButtonColumn1ButtonClick(Sender: TObject);
var
  LStr: string;
begin
  LStr := GetUniqueEngName(RunConditionGrid.CellByName['ProjNo',RunConditionGrid.SelectedRow].AsString,
    RunConditionGrid.CellByName['EngNo',RunConditionGrid.SelectedRow].AsString);
  FormAlarmList.FWG.SelectTagName4RunCondition(LStr,RunConditionGrid);
end;

procedure TAlarmConfigF.RunConditionGridSelectCell(Sender: TObject; ACol,
  ARow: Integer);
var
  LStr: string;
begin
  if (ACol = 2) or (ACol = 3) then
  begin
    LStr := GetUniqueEngName(RunConditionGrid.CellByName['ProjNo',RunConditionGrid.SelectedRow].AsString,
      RunConditionGrid.CellByName['EngNo',RunConditionGrid.SelectedRow].AsString);
    FormAlarmList.FWG.SelectTagName4RunCondition(LStr,RunConditionGrid);
  end;
end;

procedure TAlarmConfigF.SaveRunCondition2File(AFileName: string);
begin
//  RunConditionGrid.SaveToTextFile(AFileName);
end;

end.
