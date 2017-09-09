unit Test;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, ItemLists, Items, Filters;

type
  TfrmTest = class(TForm)
    btnCreate: TButton;
    lbxRoot: TListBox;
    lbxFilter: TListBox;
    lblRoot: TLabel;
    lblFilter: TLabel;
    btnDestroy: TButton;
    lblProgress: TLabel;
    btnRemove: TButton;
    btnAddFilter: TButton;
    btnAdd: TButton;
    btnRestart: TButton;
    btnUpdate: TButton;
    cbThreaded: TCheckBox;
    btnClear: TButton;
    lblInter: TLabel;
    lbxInter: TListBox;
    cbPaused: TCheckBox;
    procedure btnCreateClick(Sender: TObject);
    procedure btnDestroyClick(Sender: TObject);
    procedure btnRemoveClick(Sender: TObject);
    procedure lbxRootClick(Sender: TObject);
    procedure btnAddClick(Sender: TObject);
    procedure btnAddFilterClick(Sender: TObject);
    procedure btnRestartClick(Sender: TObject);
    procedure btnUpdateClick(Sender: TObject);
    procedure btnClearClick(Sender: TObject);
    procedure cbPausedClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
    procedure UpdateUnfiltered(Sender: TObject);
    procedure UpdateInter(Sender: TObject);
    procedure UpdateFiltered(Sender: TObject);
    procedure FilterProgress(Sender: TObject; APercent: double);
  end;

  TMyFilter = class(TFilter)
    function AcceptItem(AItem: TItem): boolean; override;
  end;

  TIdentFilter = class(TDuplexFilter)
    constructor Create;
    function AcceptItem(AItem: TItem): boolean; override;
  end;


var

  frmTest: TfrmTest;

  Root, Filter, Duplex, Extra: TItemList;

  Ident: TIdentFilter;

function MyListCompare(Item1, Item2: TItem; Info: pointer): integer;

implementation

{$R *.DFM}

function MyListCompare(Item1, Item2: TItem; Info: pointer): integer;
begin
  if TItem(Item1).FTest < TItem(Item2).FTest then Result := -1
    else if TItem(Item1).FTest > TItem(Item2).FTest then Result := 1
      else Result := 0;
end;

function TMyFilter.AcceptItem(AItem: TItem): boolean;
begin
  Result := AItem.FTest < 200
end;

constructor TIdentFilter.Create;
begin
  if frmTest.cbThreaded.Checked then
    inherited Create(True)   // Create threaded
  else
    inherited Create(False); // Create unthreaded

  // Define a sorting mech for Duplex
  OnCompare := MyListCompare;
  Duplex.OnCompare := MyListCompare;

end;

function TIdentFilter.AcceptItem(AItem: TItem): boolean;
var
  Index: integer;
begin
  // Artificial delay
  sleep(1);
  // Now here we can access the FDuplex itemlist as well
  Result := false;
  // Find ourselves
  Index := Duplex.IndexOf(AItem);
  if Index < 0 then ShowMessage('Problemos');
  // Accept if we find an identical pre or post item
  if ((Index > 0)              and (Duplex.Items[Index-1].FTest = AItem.FTest)) or
     ((Index < Duplex.Count-1) and (Duplex.Items[Index+1].FTest = AItem.FTest)) then
    Result := True;
end;

procedure TfrmTest.UpdateUnfiltered(Sender: TObject);
var
  i: integer;
begin
  with lbxRoot do begin
    Items.Clear;
    for i := 0 to Root.Count -1 do
      Items.Add(IntToStr(Root.Items[i].FTest));
  end;
  lblRoot.Caption := Format('Unfiltered (%d)', [Root.Count]);

end;

procedure TfrmTest.UpdateInter(Sender: TObject);
var
  i: integer;
begin
  with lbxInter do begin
    Items.Clear;
    for i := 0 to Extra.Count -1 do
      Items.Add(IntToStr(Extra.Items[i].FTest));
  end;
  lblInter.Caption := Format('Interm (%d)', [Extra.Count]);

end;

procedure TfrmTest.UpdateFiltered(Sender: TObject);
var
  i: integer;
  prev: string;
  FoundErr: boolean;
begin
  with lbxFilter do begin
    Items.Clear;
    prev := '';
    FoundErr := false;
    for i := 0 to Filter.Count -1 do
      Items.Add(IntToStr(Filter.Items[i].FTest));
    // Watchdog
    for i := 0 to Filter.Count -2 do begin
      if Items[i] <> prev then
        if Items[i+1] <> Items[i] then FoundErr := true;
      prev := Items[i];
    end;
  end;

  with lblFilter do begin
    Caption := Format('Filtered (%d)', [Filter.Count]);
    if FoundErr then
      Caption := Caption + ' Error!';
  end;
end;

procedure TfrmTest.FilterProgress(Sender: TObject; APercent: double);
begin
  lblProgress.Caption := Format('Progress: %3.1f%%', [APercent]);
  Application.ProcessMessages;
end;

procedure TfrmTest.btnCreateClick(Sender: TObject);
var
  i: integer;
  Item: TItem;
  List: TList;
begin
  Randomize;
  cbThreaded.Enabled := false;
  btnDestroy.Enabled := true;
  btnCreate.Enabled := false;
  btnAddFilter.Enabled := true;

  // Create Root
  Root := TItemList.Create(True);
  Root.Name := 'root';
  Root.AddUpdate(UpdateUnfiltered);

  Filter := TIdentFilter.Create;
  Filter.Name := 'Ident';

  Duplex := TDuplexFilter(Filter).Duplex;
  Duplex.Name := 'Duplex';

  Filter.Parent := Root;
  Filter.AddUpdate(UpdateFiltered);
  Filter.OnProgress := FilterProgress;

  Extra := TMyFilter.Create;
  Extra.Name := 'Extra';
  Extra.OnCompare := MyListCompare;
  Extra.AddUpdate(UpdateInter);

  // Create items
  List := TList.Create;
  for i:=0 to 199 do begin
    Item := TItem.Create;
    with Item do begin
      ItemID := i;
      FTest := random(500);
    end;
    List.Add(Item);
  end;
  Root.InsertItems(Self, List);
  List.Free;
end;

procedure TfrmTest.btnDestroyClick(Sender: TObject);
begin
  cbThreaded.Enabled := true;
  btnDestroy.Enabled := false;
  btnCreate.Enabled := true;
  Root.Free;
  Filter.Free;
  Extra.Free;
  lbxRoot.Clear;
  lbxFilter.Clear;
end;

procedure TfrmTest.btnAddClick(Sender: TObject);
var
  i: integer;
  Item: TItem;
  List: TList;
begin
  // Create items
  List := TList.Create;
  try
    for i:=0 to 199 do begin
      Item := TItem.Create;
      with Item do begin
        ItemID := Root.Count + i;
        FTest := random(500);
      end;
      List.Add(Item);
    end;
    Root.InsertItems(Self, List);
  finally
    List.Free;
  end;
end;

procedure TfrmTest.btnRemoveClick(Sender: TObject);
var
  i: integer;
  DelList: TList;
begin
  // Delete selected entries
  DelList := TList.Create;
  try
    for i:= 0 to lbxRoot.Items.Count - 1 do with lbxRoot do
      if Selected[i] then
        DelList.Add(Root.Items[i]);
    // Now remove
    Root.RemoveItems(Self, DelList);
  finally
    DelList.Free;
  end;
end;

procedure TfrmTest.btnClearClick(Sender: TObject);
begin
  Root.ClearItems(Self);
end;

procedure TfrmTest.btnAddFilterClick(Sender: TObject);
begin
  //
  if assigned(Extra.Parent) then begin
    // remove
    Filter.Parent := Extra.Parent;
    Extra.Parent := nil;
    btnAddFilter.Caption := 'Add';
  end else begin
    // Add
    Extra.Parent := Filter.Parent;
    Filter.Parent := Extra;
    btnAddFilter.Caption := 'Remove';
  end;
end;

procedure TfrmTest.lbxRootClick(Sender: TObject);
begin
  btnRemove.Enabled := (lbxRoot.SelCount > 0);
end;

procedure TfrmTest.btnRestartClick(Sender: TObject);
begin
  TDuplexFilter(Filter).Execute;
end;

procedure TfrmTest.btnUpdateClick(Sender: TObject);
var
  i: integer;
  List: TList;
begin
  List := TList.Create;
  for i:=0 to 9 do with Root do begin
    Items[i].FTest := random(500);
    List.Add(Items[i]);
  end;

  Root.UpdateItems(Self, List);
  List.Free;
end;

procedure TfrmTest.cbPausedClick(Sender: TObject);
begin
  TDuplexFilter(Filter).ThreadActive := not cbPaused.Checked;
end;

end.
