unit PlugIn;
{+-----------------------------------------------------------------------------+
 | Class:       TPlugInLibrary
 | Created:     01/04/2000
 | Author:      Eli Yukelzon a.k.a Fulgore
 |              Ported from Plugger by Tobin Schwaiger-Hastanan
 | Description: Class for Plugin collecting and managing
 | Version:     0.0.1
 | Copyright (c) 2000 Eli Yukelzon a.k.a Fulgore
 | All rights reserved.
 |
 | Thanks to: Tobin Schwaiger-Hastanan
 +----------------------------------------------------------------------------+}
{ Modified 25/04/00 18:54:47 by the CDK, Version 4.02 Rev. M }

Interface

Uses sharemem,                          // for dll connection
  PlugInBase,                           // our plugin header
  classes,                              // tstringlist
  windows,                              // LoadLibrary
  sysutils,                             // Strutils, findfirst
  dialogs,                              // Showmessage
  Controls;
  
Type
  TNewLibraryEvent = Procedure(Sender: TObject; LibraryFile: String;
    LibraryHandle: THandle) Of Object;
  TNewPluginEvent = Procedure(Sender: TObject; APlugin: TBasePlugIn) Of Object;

  TPluggerError = class(Exception)
  end;

  TPlugInLibrary = Class(TComponent)
  private
    FOnNewLibrary: TNewLibraryEvent;
    FOnNewPlugin: TNewPluginEvent;
    m_pPlugInTree: TBasePlugIn;
    // i amtired of fiddling with TList... Any correct working code
    // appritiated though... fix it if you want...
    m_hInstance: TStringList;
    // add plugin to binary tree.
    Function AddPlugIn(pPlugIn: TBasePlugIn): boolean;
  protected
    Procedure TriggerNewLibraryEvent(LibraryFile: String; LibraryHandle:
      THandle); virtual;
    Procedure TriggerNewPluginEvent(APlugin: TBasePlugIn); virtual;
  public
    Constructor Create(AOwner: TComponent);
    Destructor Destroy;
    // Load a specific plugin
    Function LoadPlugIn(Const szFile: String): boolean;
    // Load a directory of plugins based on extension
    Function LoadPlugins(sDir, sExt: String): boolean;
    // Return a plugin from tree by it's name
    Function FindPlugIn(Const szPlugIn: String): TBasePlugIn;
  published
    Property OnNewLibrary: TNewLibraryEvent read FOnNewLibrary write FOnNewLibrary;
    Property OnNewPlugin: TNewPluginEvent read FOnNewPlugin write FOnNewPlugin;
  End;

  // templates for plugin's functions
  fFUNC1 = Function: integer;
  fFUNC2 = Function(idx: integer): TBasePlugIn; stdcall;

Implementation

{ TPlugInLibrary }

// Add Plugin into library tree

Function TPlugInLibrary.AddPlugIn(pPlugIn: TBasePlugIn): boolean;
Var
  pNode             : TBasePlugIn;
  cmp               : integer;
Begin
  pNode := m_pPlugInTree;
  result := false;

  If Not assigned(pNode) Then
  Begin
    // plugin Plugin tree doesn't exist yet, so set the root node to the
    // current Plugin
    m_pPlugInTree := pPlugIn;
    result := true;
    exit;
  End;

  // insert plugin  into the binary tree (sorted by name)
  While (assigned(pNode)) Do
  Begin
    cmp := strcomp(pchar(pPlugIn.GetPlugInName), pchar(pNode.GetPlugInName));

    If (cmp = 0) Then
    Begin
      result := false;
      exit;
    End;

    If (cmp < 0) Then
    Begin
      If Not assigned(pNode.Left) Then
      Begin
        pNode.Left := pPlugIn;
        result := true;
        Break;
      End;

      pNode := pNode.Left;
    End
    Else
    Begin
      If Not (assigned(pNode.Right)) Then
      Begin
        pNode.Right := pPlugIn;
        result := true;
        Break;
      End;

      pNode := pNode.Right;
    End;
  End;//while

  m_pPlugInTree := pNode;

End;

// init
Constructor TPlugInLibrary.Create(AOwner: TComponent);
Begin
  Inherited Create(AOwner);
  m_pPlugInTree := Nil;
  m_hInstance := TStringList.create;
End;

//free
Destructor TPlugInLibrary.Destroy;
Var
  j    : integer;
  hMod : hModule;
Begin
  // release all handles
  For j := 0 To m_hInstance.count - 1 Do // Iterate
  Begin
    Hmod := strtoint64(m_hInstance[j]);
    FreeLibrary(hMod);
  End;// for

  m_hInstance.free;
End;

// get plugin by name...
Function TPlugInLibrary.FindPlugIn(Const szPlugIn: String): TBasePlugIn;
Var
  pNode             : TBasePlugIn;
  cmp               : integer;
Begin
  pNode := m_pPlugInTree;

  // search plugin tree for szPlugIn name
  While assigned(pNode) Do
  Begin
    cmp := strcomp(pchar(szPlugIn), pchar(pNode.GetPlugInName));
    If cmp = 0 Then break;            // found it
    If (cmp < 0) Then
      pNode := pNode.Left
    Else
      pNode := pNode.Right;
  End;

  // return pointer to user... if node did not exist, then pointer will be NIL
  result := pNode;
End;

Function TPlugInLibrary.LoadPlugIn(Const szFile: String): boolean;
Var
  GetPlugInCount    : fFUNC1;
  GetPlugIn         : fFUNC2;
  hInst             : hModule;
  i, count          : integer;
  retval            : boolean;
  pPlugIn           : TBasePlugIn;
Label
  exit_function;
Begin
  retval := false;
  // load library
  hInst := LoadLibrary(pchar(szFile));
  If (hInst = 0) Then
    Goto exit_function; // doesn't exist/couldn't be loaded.. buh bye
  TriggerNewLibraryEvent(szFile,hInst);
  // add instace to stl vector
  if not Assigned(m_hInstance) then m_hInstance:=TStringList.Create;
  m_hInstance.add(inttostr(hInst));

  // get plug in interface function addresses
  GetPlugInCount := fFUNC1(GetProcAddress(hInst, 'GetPlugInCount'));
  GetPlugIn := fFUNC2(GetProcAddress(hInst, 'GetPlugIn'));

  // if they couldn't be found...
  If Not (Assigned(GetPlugInCount) And Assigned(GetPlugIn)) Then
    Goto exit_function;                 // go buh bye...

  count := GetPlugInCount;              // get plugin PlugIn count
  For i := 0 To count - 1 Do
  Begin
    // get plugin PlugIn by index
    pPlugIn := GetPlugIn(i);

    // if it was accessable...
    If assigned(pPlugIn) Then
      // add plugin to tree...
      If Not AddPlugIn(pPlugIn) Then
        raise TPluggerError.CreateFmt('Couldn''t load plugin command named %s because such name'#13#10'already exists. Command''s Name should be unique.', [pPlugin.getpluginname])
      else
        TriggerNewPluginEvent(pPlugIn);
  End;

  retval := true;

  exit_function:

  If Not retval Then
    If (hInst) <> 0 Then
      FreeLibrary(hInst);

  result := retval;

End;

Function TPlugInLibrary.LoadPlugins(sDir, sExt: String): boolean;
Var
  sr                : tsearchrec;
  i                 : integer;
Begin
  i := findfirst(Extractfilepath(sDir) + '*.' + sExt, faAnyFile, sr);
  While i = 0 Do
  Begin
    loadplugin(Extractfilepath(sDir) + sr.name);
    i := findnext(sr);
  End;// while
  findclose(sr);
  Result := True;                       //got to work on that...
End;

Procedure TPlugInLibrary.TriggerNewLibraryEvent(LibraryFile: String;
  LibraryHandle: THandle);
Begin
  If assigned(FOnNewLibrary) Then
    FOnNewLibrary(Self, LibraryFile, LibraryHandle);
End;{ TriggerNewLibraryEvent }

Procedure TPlugInLibrary.TriggerNewPluginEvent(APlugin: TBasePlugIn);
Begin
  If assigned(FOnNewPlugin) Then
    FOnNewPlugin(Self, APlugin);
End;{ TriggerNewPluginEvent }

End.

