unit HitemsCode_Unit;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, AdvOfficeStatusBar, ComCtrls, StdCtrls, ExtCtrls, NxCollection, Ora,
  Grids, AdvObj, BaseGrid, AdvGrid, Vcl.Imaging.pngimage, AdvSmoothPanel,
  JvBackgrounds, Vcl.ImgList, Data.DB, MemDS, DBAccess, DBAdvGrid;

type
  THitemsCode_Frm = class(TForm)
    AdvSmoothPanel1: TAdvSmoothPanel;
    Panel1: TPanel;
    Button1: TButton;
    NxHeaderPanel1: TNxHeaderPanel;
    Panel3: TPanel;
    adgrp_btn: TButton;
    rootTree: TTreeView;
    NxSplitter1: TNxSplitter;
    NxHeaderPanel2: TNxHeaderPanel;
    Panel4: TPanel;
    Button3: TButton;
    Button4: TButton;
    Panel5: TPanel;
    Panel6: TPanel;
    Panel7: TPanel;
    cdGrp: TEdit;
    cdGrpNm: TEdit;
    Panel8: TPanel;
    Panel9: TPanel;
    Image2: TImage;
    JvBackground1: TJvBackground;
    Timer1: TTimer;
    ImageList1: TImageList;
    codeGrid: TDBAdvGrid;
    OraQuery1: TOraQuery;
    DataSource1: TDataSource;
    Panel2: TPanel;
    Panel10: TPanel;
    code: TEdit;
    codeNm: TEdit;
    cdDesc: TEdit;
    procedure adgrp_btnClick(Sender: TObject);
    procedure Button1Click(Sender: TObject);
    procedure Button4Click(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure Timer1Timer(Sender: TObject);
    procedure rootTreeChange(Sender: TObject; Node: TTreeNode);
    procedure rootTreeMouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure codeClick(Sender: TObject);
    procedure Button3Click(Sender: TObject);
  private
    { Private declarations }
    FFirst : Boolean;
    FStartRoot : String;
  public
    { Public declarations }
    procedure Set_the_Tree_of_Root(aStartRoot:String);
    procedure Show_Code_2_Grid(aCdGrp:String);

    function Check_for_Avaliability_of_the_Code(var aMsg:String) : Boolean;
    function Check_for_Group_Level(aCdGrp:String) : Integer;
  end;

var
  HitemsCode_Frm: THitemsCode_Frm;

implementation
uses
  CommonUtil_Unit,
  HiTEMS_ETH_COMMON,
  HiTEMS_ETH_CONST,
  DataModule_Unit,
  HitemsAddCode_Unit,
  HitemsAddGroup_Unit;

{$R *.dfm}

procedure THitemsCode_Frm.adgrp_btnClick(Sender: TObject);
var
  LForm : THitemsAddGroup_Frm;
  lNode : TTreeNode;
  lkey : int64;
  li : integer;
begin
  LForm := THitemsAddGroup_Frm.Create(nil);
  try
    with LForm do
    begin
      if not(rootTree.Selected = nil) then
      begin
        lNode := rootTree.Selected;
        pCdGrpNm.Text := lNode.Text;
        FCdGrpLv := lNode.Level+1;
        lkey := DateTimeToMilliseconds(Now);
        cdGrp.Text := IntToStr(lkey);
        FUserID := CurrentUsers;
        with DM1.OraQuery1 do
        begin
          Close;
          SQL.Clear;
          SQL.Add('select CDGRP from HITEMS_CODE_ROOT ' +
                  'where CDGRPNAME = '''+lNode.Text+''' ');
          Open;

          if not(RecordCount = 0) then
            pCdGrpCd.Text := FieldByName('CDGRP').AsString;
        end;
        ShowModal;

        rootTree.Items.BeginUpdate;
        try
          Set_the_Tree_of_Root(FStartRoot);
        finally
          for li := 0 to rootTree.Items.Count-1 do
            rootTree.Items[li].Expanded := True;
          rootTree.Items.EndUpdate;
        end;
      end
    end;
  finally
    FreeAndNil(LForm);
  end;
end;

procedure THitemsCode_Frm.Button1Click(Sender: TObject);
begin
  Close;
end;

procedure THitemsCode_Frm.Button3Click(Sender: TObject);
var
  lMsg : String;
  lSort : Integer;
  lKey : String;
begin
  if not(cdGrp.Text = '') and not(cdGrpNm.Text = '') and
     not(code.Text = '') and not(codeNm.Text = '') then

  begin
    if Check_for_Avaliability_of_the_Code(lMsg) = True then
    begin
      lSort := Check_for_Group_Level(cdGrp.Text);
      try
        with DM1.OraQuery1 do
        begin
          Close;
          SQL.Clear;
          SQL.Add('Insert Into HITEMS_CODE_GROUP ' +
                  'Values(:CDGRP, :CODE, :DESCRIPTION, :SORTNO, ' +
                  ':REGID, :REGDATE, :MODID, :MODDATE)');

          ParamByName('CDGRP').AsFloat := StrToFloat(CDGRP.Text);
          ParamByName('CODE').AsString := CODE.Text;
          ParamByName('DESCRIPTION').AsString := CDDESC.Text;
          ParamByName('SORTNO').AsInteger := lSort;
          ParamByName('REGID').AsString := CurrentUsers;
          ParamByName('REGDATE').AsDateTime := NOW;
          ExecSQL;
          showMessage('등록성공!');

        end;
      finally
        Show_Code_2_Grid(cdGrp.Text);
      end;
    end
    else
      ShowMessage(lMsg);
  end
  else
    ShowMessage('그룹 또는 코드란이 비었습니다.');

end;

procedure THitemsCode_Frm.Button4Click(Sender: TObject);
begin
  ShowMessage('준비중 입니다.');
end;

function THitemsCode_Frm.Check_for_Avaliability_of_the_Code(
  var aMsg: String): Boolean;
begin
  Result := False;
  with DM1.OraQuery1 do
  begin
    Close;
    SQL.Clear;
    SQl.Add('select * from HITEMS_CODE_GROUP ' +
            'where CDGRP = '+CDGRP.Text+
            ' and CODE = '''+CODE.Text + ''' ');
    Open;

    if RecordCount = 0 then
    begin
      Result := True;
    end
    else
      aMsg := '이미 등록된 코드 입니다.';
  end;
end;

function THitemsCode_Frm.Check_for_Group_Level(aCdGrp: String): Integer;
begin
  with DM1.OraQuery1 do
  begin
    Close;
    SQl.Clear;
    SQL.Add('select * from HITEMS_CODE_GROUP '+
            'where CDGRP = '+aCdGrp);
    Open;

    if not(RecordCount = 0) then
      Result := RecordCount +1
    else
      Result := 1;
  end;
end;

procedure THitemsCode_Frm.codeClick(Sender: TObject);
var
  lResult : String;
  lpos : integer;
begin
  lResult := add_new_HiTEMS_CODE;

  lpos := pos(';',lResult);

  if lpos > 0 then
  begin
    Code.Text := Copy(lResult,0,lpos-1);
    codeNm.Text := Copy(lResult,lpos+1,(length(lResult)-lpos));
  end;
end;

procedure THitemsCode_Frm.FormCreate(Sender: TObject);
begin
  Timer1.Enabled := True;
  Show_Code_2_Grid('90792462');
end;

procedure THitemsCode_Frm.rootTreeChange(Sender: TObject; Node: TTreeNode);
begin
  with rootTree.Items do
  begin
    BeginUpdate;
    try
      if Node.Selected = True then
        Node.SelectedIndex := 1;

    finally
      EndUpdate;
    end;
  end;
end;

procedure THitemsCode_Frm.rootTreeMouseDown(Sender: TObject;
  Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
var
  lNode : TTreeNode;
  lCDGRP : String;
begin
  if Button = mbLeft then
  begin
    with rootTree.Items do
    begin
      BeginUpdate;
      try
        lNode := rootTree.GetNodeAt(X,Y);

        if lNode <> nil then
        begin
          if not(lNode.Level = 0) then
          begin
            with DM1.OraQuery1 do
            begin
              Close;
              SQL.Clear;
              SQL.Add('select * from HiTEMS_CODE_ROOT ' +
                      'where CDGRPNAME = '''+lNode.Text+''' ');
              Open;
              if not(RecordCount = 0) then
              begin
                lCDGRP := FieldByName('CDGRP').AsString;
                cdGrp.Text := lCDGRP;
                cdGrpNm.Text := lNode.Text;

                Show_Code_2_Grid(lCDGRP);
              end;
            end;
          end
          else
          begin
            cdGrp.Clear;
            cdGrpNm.Clear;
            code.Clear;
            codenm.Clear;
            cdDesc.Clear;
          end;
        end;
      finally
        EndUpdate;
      end;
    end;
  end;
end;

procedure THitemsCode_Frm.Set_the_Tree_of_Root(aStartRoot: String);
var
  nNode,
  lNode: TTreeNode;
  lstr,lstr1: String;
  li,le: integer;
  lQuery : TOraQuery;
  lPrtNo : String;
begin
  with DM1.OraQuery1 do
  begin
    Close;
    SQL.Clear;
    SQL.Add('select * from HITEMS_CODE_ROOT START WITH CDGRP = '+aStartRoot+' ' +
            'and CDGRPLV = 0 connect by prior CDGRP = PCDGRP order siblings by CDGRP');
    Open;

    if not(RecordCount = 0) then
    begin
      with rootTree.Items do
      begin
        BeginUpdate;
        Clear;
        lQuery := TOraQuery.Create(nil);
        lQuery.Session := DM1.OraSession1;
        try
          for li := 0 to RecordCount-1 do
          begin
            lstr := FieldByName('CDGRPNAME').AsString;
            if li = 0 then
            begin
              lNode := Add(nil,lstr);
            end
            else
            begin
              lprtNo := FieldByName('PCDGRP').AsString;
              with lQuery do
              begin
                Close;
                SQL.Clear;
                SQL.Add('select * from HITEMS_CODE_ROOT where CDGRP = '+lprtNo);
                Open;

                if not(RecordCount = 0) then
                begin
                  lstr1 := FieldByName('CDGRPNAME').AsString;
                  for le := 0 to Count-1 do
                  begin
                    if Item[le].Text = lstr1 then
                    begin
                      lNode := Item[le];
                      Break;
                    end;
                  end;
                  addChild(lNode,lstr);
                end;
              end;
            end;
            Next;
          end;
        finally
          EndUpdate;
          FreeAndNil(lQuery);
        end;
      end;
    end;
  end;
end;

procedure THitemsCode_Frm.Show_Code_2_Grid(aCdGrp: String);
begin
  with codeGrid do
  begin
    BeginUpdate;
    AutoSize := False;
    try
      with OraQuery1 do
      begin
        Close;
        SQL.Clear;
        SQL.Add('select * from HITEMS_CODE_GROUP_V ' +
                'where CDGRP = '+aCdGrp+
                ' order by SORTNO');
        Open;
      end;
    finally
      DataSource1.DataSet.Refresh;
      AutoSize := True;
      EndUpdate;
    end;
  end;
end;

procedure THitemsCode_Frm.Timer1Timer(Sender: TObject);
var
  li : integer;
begin
  li := 0;
  if Caption = '힘센시험이력관리시스템-[시험코드관리]' then
    li := 1;

  if li > 0 then
  begin
    Timer1.Enabled := False;
    case li of
      1 : FStartRoot := '1209271726';
    end;

    Set_the_Tree_of_Root(FStartRoot);
    with rootTree.Items do
    begin
      BeginUpdate;
      try
        for li := 0 to Count-1 do
          rootTree.Items[li].Expanded := True;
      finally
        EndUpdate;
      end;
    end;
  end;
end;

end.

