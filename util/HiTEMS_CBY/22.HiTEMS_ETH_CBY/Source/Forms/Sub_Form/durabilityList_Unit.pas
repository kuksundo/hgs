unit durabilityList_Unit;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, JvBackgrounds, Vcl.Imaging.pngimage,
  Vcl.ExtCtrls, Vcl.ComCtrls, TreeList, Vcl.StdCtrls, NxCollection,
  AdvSmoothPanel, Ora, NxEdit, Vcl.ImgList;

type
  TdurabilityList_Frm = class(TForm)
    AdvSmoothPanel1: TAdvSmoothPanel;
    NxHeaderPanel1: TNxHeaderPanel;
    Panel2: TPanel;
    Button6: TButton;
    Button1: TButton;
    partTree: TTreeList;
    Image2: TImage;
    JvBackground1: TJvBackground;
    Panel1: TPanel;
    Label1: TLabel;
    recordno: TNxEdit;
    Label2: TLabel;
    maker: TNxEdit;
    Label3: TLabel;
    ptype: TNxEdit;
    Label4: TLabel;
    serial: TNxEdit;
    treeImg: TImageList;
    procedure partTreeMouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure partTreeDblClick(Sender: TObject);
    procedure partTreeChange(Sender: TObject; Node: TTreeNode);
    procedure Button6Click(Sender: TObject);
  private
    { Private declarations }
    FProjNo : String;
    FCurrentNode : TTreeNode;
  public
    { Public declarations }
    function Set_the_partTree_Root : Boolean;
    procedure Add_PARTCODE_to_partTree;
  end;

var
  durabilityList_Frm: TdurabilityList_Frm;
  function Create_new_durability_Item(aProjNo:String) : Boolean;

implementation
uses
  DataModule_Unit;

{$R *.dfm}

function Create_new_durability_Item(aProjNo:String) : Boolean;
var
  li : integer;
  lNode : TTreeNode;
begin
  with TdurabilityList_Frm.Create(Application) do
  begin
    FProjNo := aProjNo;
    partTree.Items.BeginUpdate;
    try
      if Set_the_partTree_Root = True then
      begin
        Add_PARTCODE_to_partTree;

        for li := 0 to partTree.Items.Count-1 do
        begin
          lNode := partTree.Items.Item[li];
          lNode.Expanded := True;
        end;
        partTree.Items.EndUpdate;
      end;

      if ShowModal = mrOk then
      begin
        Result := True;
      end;
    finally
      Free;
    end;
  end;

end;

procedure TdurabilityList_Frm.Add_PARTCODE_to_partTree;
var
  lp,
  li: Integer;
  lnew, lNode : TTreeNode;
  lstr,
  litem,
  lroot : String;
begin
  with partTree.Items do
  begin
    BeginUpdate;
    try
      with DM1.OraQuery1 do
      begin
        Close;
        SQL.Clear;
        SQL.Add('select A.ROOTNO, A.PCODE, A.PROJNO,A.QTY, B.PCODENM '+
                'from HIMSEN_ENGINE_PART_SET A, HIMSEN_PART_CODE B '+
                'WHERE A.PROJNO = :param1 and A.PCODE = B.PCODE '+
                'group by A.rootno, A.PCODE, A.PROJNO, A.QTY, B.PCODENM '+
                'order by A.ROOTNO, A.PCODE');
        ParamByName('param1').AsString := FProjNo;
        Open;

        while not eof do
        begin
          lroot := FieldByName('ROOTNO').AsString;
          litem := FieldByName('PCODENM').AsString+';'+FieldByName('PCODE').AsString;

          for li := 0 to Count-1 do
          begin
            lNode := Item[li];
            lp := pos(';',lNode.Text);

            if lp > 0 then
            begin
              lstr := Copy(lNode.Text,lp+1,Length(lNode.Text));

              if lstr = lroot  then
              begin
                lnew := AddChild(lNode,litem);
                lnew.ImageIndex := 1;
                lnew.Expanded := True;
                Break;
              end;
            end;
          end;
          Next;
        end;
      end;
    finally
      EndUpdate;
    end;
  end;
end;

procedure TdurabilityList_Frm.Button6Click(Sender: TObject);
begin
  Close;
end;

procedure TdurabilityList_Frm.partTreeChange(Sender: TObject; Node: TTreeNode);
begin
  with partTree.Items do
  begin
    BeginUpdate;
    try
      if Node.Selected = True then
        Node.SelectedIndex := 2;

    finally
      EndUpdate;
    end;
  end;
end;

procedure TdurabilityList_Frm.partTreeDblClick(Sender: TObject);
var
  li : integer;
  lStr,
  lRootNo : String;
  lPCODE : String;
  lprtNode,
  lNode : TTreeNode;
begin
  if (FCurrentNode <> nil) and not(FProjNo = '') then
  begin
    lNode := FCurrentNode;
    if lNode.ImageIndex = 1 then
    begin
      lStr := lNode.Parent.Text;
      li := Pos(';',lStr);
      if li > 0 then
        lRootno := Copy(lStr,li+1,Length(lStr)-li);

      lStr := lNode.Text;
      li := Pos(';',lStr);
      if li > 0 then
        lPCODE                     := Copy(lStr,li+1,Length(lStr)-li);
    end;

    with DM1.OraQuery1 do
    begin
      Close;
      SQL.Clear;
      SQL.Add('select * from HIMSEN_PART_SPEC_V ' +
              'where PROJNO = '''+FProjNo+''' '+
              'and ROOTNO = '+lRootNo+
              ' and PCODE = '+lPCODE +
              ' order by RECNO DESC');
      Open;

      if not(RecordCount = 0) then
      begin
        recordno.Text := FieldByName('RECNO').AsString;
        maker.Text    := FieldByName('MAKER').AsString;
        pType.Text    := FieldByName('TYPE').AsString;
        serial.Text   := FieldByName('SERIALNO').AsString;
      end;
    end;
  end;
end;

procedure TdurabilityList_Frm.partTreeMouseDown(Sender: TObject;
  Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
var
  lNode : TTreeNode;
begin
  lNode := partTree.GetNodeAt(X,Y);
  if lNode <> nil then
    FCurrentNode := lNode
  else
    FCurrentNode := nil;

end;

function TdurabilityList_Frm.Set_the_partTree_Root: Boolean;
var
  nNode,
  lNode: TTreeNode;
  lstr,lstr1: String;
  li,le: integer;
  lQuery : TOraQuery;
  lPrtNo : String;
begin
  Result := False;
  with DM1.OraQuery1 do
  begin
    Close;
    SQL.Clear;
    SQL.Add('select * from HIMSEN_PART_ROOT START WITH LV = 0 '+
            'connect by prior ROOTNO = PRTROOT order siblings by rootno');
    Open;

    if not(RecordCount = 0) then
    begin
      with partTree.Items do
      begin
        BeginUpdate;
        Clear;
        lQuery := TOraQuery.Create(nil);
        lQuery.Session := DM1.OraSession1;
        try
          try
            for li := 0 to RecordCount-1 do
            begin
              lstr := FieldByName('ROOTNAME').AsString+';'+FieldByName('ROOTNO').AsString;
              if li = 0 then
              begin
                lNode := Add(nil,lstr);
              end
              else
              begin
                lprtNo := FieldByName('PRTROOT').AsString;
                with lQuery do
                begin
                  Close;
                  SQL.Clear;
                  SQL.Add('select * from HIMSEN_PART_ROOT where ROOTNO = '+lprtNo);
                  Open;

                  if not(RecordCount = 0) then
                  begin
                    lstr1 := FieldByName('ROOTNAME').AsString+';'+FieldByName('ROOTNO').AsString;
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
            partTree.Columns[1].Font.Color := clWhite;
            Result := True;
          except
            Result := False;
          end;
        finally
          EndUpdate;
          FreeAndNil(lQuery);
        end;
      end;
    end;
  end;
end;

end.
