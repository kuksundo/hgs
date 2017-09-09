{+--------------------------------------------------------------------------+
 | Class:       mwPascalParser
 | Created:     04.99
 | Author:      Martin Waldenburg
 | Description: A very fast Pascal parser.
 | Version:     0.05
 | Copyright (c) 1999 Martin Waldenburg
 | All rights reserved.
 |
 | June 15th 1999.
 | I'd like to invite the Delphi community to develop
 | it further and to create a full featured Object Pascal parser.
 | The lizence to this software has been moved to the
 | MOZILLA PUBLIC LICENSE Version 1.1
 | http://www.mozilla.org/NPL/NPL-1_1Final.html
 | Martin.Waldenburg@T-Online.de
 +--------------------------------------------------------------------------+}

unit mwPascalParser;

interface

uses
  SysUtils, Windows, Messages, Classes, Controls, mwPasLexTypes, mwPasLex, mwPasParTypes;

type
  TmwPascalParser = class(TObject)
  private
    fCurUnit: TmwPasUnitInfo;
    fLexer: TmwPasLex;
    fStream: TMemoryStream;
    fTokenTable: array[ptAbsolute..ptXor] of procedure of object;
    fUnitList: TStringList;
    fUnitStack: TList;
    fSearchPaths: TStringList;
    fGoIntoUnits: Boolean;
    fUseSearchPaths: Boolean;
    fExcludedUnits: TStringList;
    fFinished: Boolean;
    fCurInfo: TmwPasCodeInfo;
    procedure AddUnitToList(aUnit: TmwPasUnitInfo);
    procedure AddUnitToStack(aUnit: TmwPasUnitInfo);
    procedure AlternativeProc;
    procedure CreateNewInfo(Belongs: TmwPasCodeInfo);
    procedure CreateNewUnit(UnitName: string; SourceStream: TMemoryStream; OwnS: Boolean);
    procedure DestroyParseUnits;
    procedure GotoNextNoJunk;
    procedure LookForFile(FileName: string);
    procedure MakeTokenProcTable;
    procedure ParseArrayConstantDeclaration;
    procedure ParseArrayDeclaration;
    procedure ParseBlock;
    procedure ParseCaseSection;
    procedure ParseClassDeclaration;
    procedure ParseClassFieldDeclaration;
    procedure ParseClassForwardDeclaration;
    procedure ParseClassFunctionDeclaration;
    procedure ParseClassFunctionImplementation;
    procedure ParseClassProcedureDeclaration;
    procedure ParseClassProcedureImplementation;
    procedure ParseClassReferenceDeclaration;
    procedure ParseConstSection;
    procedure ParseConstructorDeclaration;
    procedure ParseConstructorImplementation;
    procedure ParseDestructorDeclaration;
    procedure ParseDestructorImplementation;
    procedure ParseDispInterfaceDeclaration;
    procedure ParseForLoop;
    procedure ParseFormalParameters;
    procedure ParseFunctionDeclaration;
    procedure ParseFunctionImplementation;
    procedure ParseFunctionMethodDeclaration;
    procedure ParseFunctionMethodImplementation;
    procedure ParseFunctionalTypeDeclaration;
    procedure ParseIfStatement;
    procedure ParseInterfaceDeclaration;
    procedure ParseLabelDeclarationSection;
    procedure ParsePackedArrayDeclaration;
    procedure ParsePackedSetDeclaration;
    procedure ParseProceduralTypeDeclaration;
    procedure ParseProcedureDeclaration;
    procedure ParseProcedureImplementation;
    procedure ParseProcedureMethodDeclaration;
    procedure ParseProcedureMethodImplementation;
    procedure ParseRecordCaseSection;
    procedure ParseRecordConstantDeclaration;
    procedure ParseRecordDeclaration;
    procedure ParseRecordFieldConstantDeclaration;
    procedure ParseRepeatLoop;
    procedure ParseSetDeclaration;
    procedure ParseTypeSection;
    procedure ParseVarSection;
    procedure ParseWhileLoop;
    procedure ptAnsiCommentProc;
    procedure ptBorCommentProc;
    procedure ptCompDirectProc;
    procedure ptConstProc;
    procedure ptConstructorProc;
    procedure ptCRLFProc;
    procedure ptCRLFCoProc;
    procedure ptDefineDirectProc;
    procedure ptDestructorProc;
    procedure ptElseDirectProc;
    procedure ptEndIfDirectProc;
    procedure ptErrorProc;
    procedure ptExportsProc;
    procedure ptFinalizationProc;
    procedure ptFunctionProc;
    procedure ptIdentifierProc;
    procedure ptIfDefDirectProc;
    procedure ptIfNDefDirectProc;
    procedure ptIfOptDirectProc;
    procedure ptImplementationProc;
    procedure ptIncludeDirectProc;
    procedure ptInitializationProc;
    procedure ptInterfaceStartProc;
    procedure ptLibraryProc;
    procedure ptNullProc;
    procedure ptObjectProc;
    procedure ptProcedureProc;
    procedure ptProgramProc;
    procedure ptResourceDirectProc;
    procedure ptResourcestringProc;
    procedure ptSemiColonProc;
    procedure ptSlashesCommentProc;
    procedure ptStringresourceProc;
    procedure ptTheEndProc;
    procedure ptThreadvarProc;
    procedure ptTypeProc;
    procedure ptUndefDirectProc;
    procedure ptUnitProc;
    procedure ptUsesProc;
    procedure ptVarProc;
    procedure RestoreInfoFromStack(LastPos: Integer);
    procedure RestoreUnitFromStack;
    procedure TerminateStream(aStream: TMemoryStream);
    procedure SetSearchPaths(const Value: TStringList);
    procedure SetExcludedUnits(const Value: TStringList);
    procedure ExpliciteLookForFile(FileName: string);
  public
    constructor Create(UnitName: string; SourceStream: TMemoryStream);
    destructor Destroy; override;
    property Finished: Boolean read fFinished write fFinished;
    procedure Parse;
    property CurInfo: TmwPasCodeInfo read fCurInfo;
    property CurUnit: TmwPasUnitInfo read fCurUnit;
    property ExcludedUnits: TStringList read fExcludedUnits write SetExcludedUnits;
    property GoIntoUnits: Boolean read fGoIntoUnits write fGoIntoUnits;
    property Lexer: TmwPasLex read fLexer;
    property SearchPaths: TStringList read fSearchPaths write SetSearchPaths;
    property UnitList: TStringList read fUnitList;
    property UseSearchPaths: Boolean read fUseSearchPaths write fUseSearchPaths;
  end;

implementation

{ TmwPascalParser }

procedure TmwPascalParser.AddUnitToList(aUnit: TmwPasUnitInfo);
begin
  aUnit.LexStatus := fLexer.Status;
  fUnitList.AddObject(aUnit.Name, aUnit);
end;

procedure TmwPascalParser.AddUnitToStack(aUnit: TmwPasUnitInfo);
begin
  aUnit.LexStatus := fLexer.Status;
  fUnitStack.Add(aUnit);
end;

procedure TmwPascalParser.AlternativeProc;
begin

  fLexer.Next;
end;

constructor TmwPascalParser.Create(UnitName: string; SourceStream: TMemoryStream);
begin
  inherited Create;
  fStream := nil;
  fFinished := False;
  fCurUnit := nil;
  fExcludedUnits := TStringList.Create;
  fSearchPaths := TStringList.Create;
  fUnitList := TStringList.Create;
  fUnitStack := TList.Create;
  MakeTokenProcTable;
  fLexer := TmwPasLex.Create;
  if SourceStream <> nil then CreateNewUnit(UnitName, SourceStream, False) else
  begin
    LookForFile(UnitName);
  end;
end;

procedure TmwPascalParser.CreateNewInfo(Belongs: TmwPasCodeInfo);
begin
  fCurInfo := TmwPasCodeInfo.Create;
  fCurInfo.BelongsTo := Belongs;
  fCurInfo.LineNumber := fLexer.LineNumber;
  fCurInfo.StartPos := fLexer.TokenPos;
  fCurUnit.InfoStack.Add(fCurInfo);
end;

procedure TmwPascalParser.CreateNewUnit(UnitName: string;
  SourceStream: TMemoryStream; OwnS: Boolean);
var
  Temp: TmwPasCodeInfo;
begin
  TerminateStream(SourceStream);
  if fCurUnit = nil then
  begin
    fLexer.Origin := SourceStream.Memory;
    fCurUnit := TmwPasUnitInfo.Create(UnitName, SourceStream, OwnS);
    AddUnitToList(fCurUnit);
  end
  else
  begin
    AddUnitToStack(fCurUnit);
    fLexer.Origin := SourceStream.Memory;
    fCurUnit := TmwPasUnitInfo.Create(UnitName, SourceStream, OwnS);
    AddUnitToList(fCurUnit);
  end;
  fCurInfo := fCurUnit.InfoStack.Last;
  Case fLexer.TokenID in [ptAnsiComment, ptBorComment, ptCRLF, ptCRLFCo,
    ptSlashesComment, ptSpace] of
    True:
      begin
        fLexer.NextNoJunk;
        Temp := TmwPasCodeInfo.Create;
        with Temp do
        begin
          BelongsTo := fCurUnit;
          EndPos := fLexer.TokenPos;
          InfoType := ciPreHeader;
          Name := '';
          StartPos := 0;
        end;
        fCurUnit.Infos.Add(Temp);
      end;
  end;
end;

destructor TmwPascalParser.Destroy;
begin
  fExcludedUnits.Free;
  fSearchPaths.Free;
  DestroyParseUnits;
  fUnitList.Free;
  fUnitStack.Free;
  fLexer.Free;
  inherited Destroy;
end;

procedure TmwPascalParser.DestroyParseUnits;
var
  I: Integer;
begin
  for I := 0 to fUnitList.Count - 1 do TmwPasUnitInfo(fUnitList.Objects[I]).Free;
end;

procedure TmwPascalParser.ExpliciteLookForFile(FileName: string);
var
  PathPlusFileName: string;
begin
  fLexer.NextNoJunk;
  fLexer.NextNoJunk;
  if fLexer.TokenID = ptStringConst then
  begin
    PathPlusFileName := fLexer.StringContent;
    if FileExists(PathPlusFileName) then
    begin
      fStream := TMemoryStream.Create;
      fStream.LoadFromFile(PathPlusFileName);
      CreateNewUnit(FileName, fStream, True);
    end else fLexer.Next { error handling };
  end else { error handling };
end;

procedure TmwPascalParser.GotoNextNoJunk;
begin
  repeat
    fLexer.Next;
  until not (fLexer.TokenID in [ptAnsiComment, ptBorComment, ptCRLF, ptCRLFCo, ptSlashesComment, ptSpace]);
end;

procedure TmwPascalParser.LookForFile(FileName: string);
var
  I: Integer;
  PathPlusFileName: string;
  ID, IDEX: TptTokenKind;
begin
  ID := ptUnKnown;
  if fStream <> nil then
    if fLexer.TokenID = ptIdentifier then fLexer.OneAhead(ID, IDEX);
  if ID = ptIn then ExpliciteLookForFile(FileName) else
    if fExcludedUnits.IndexOf(FileName) < 0 then
      if fUnitList.IndexOf(FileName) < 0 then
        if FileExists(FileName) then
        begin
          fStream := TMemoryStream.Create;
          fStream.LoadFromFile(FileName);
          CreateNewUnit(FileName, fStream, True);
        end
        else
          if FileExists(FileName + '.Pas') then
          begin
            fStream := TMemoryStream.Create;
            fStream.LoadFromFile(FileName + '.Pas');
            CreateNewUnit(FileName, fStream, True);
          end
          else
            if UseSearchPaths then
              for I := 0 to fSearchPaths.Count - 1 do
              begin
                PathPlusFileName := fSearchPaths[I] + FileName;
                if FileExists(PathPlusFileName) then
                begin
                  fStream := TMemoryStream.Create;
                  fStream.LoadFromFile(PathPlusFileName);
                  CreateNewUnit(FileName, fStream, True);
                  break;
                end
                else
                  if FileExists(PathPlusFileName + '.Pas') then
                  begin
                    fStream := TMemoryStream.Create;
                    fStream.LoadFromFile(PathPlusFileName + '.Pas');
                    CreateNewUnit(FileName, fStream, True);
                    break;
                  end;
              end;
end;

procedure TmwPascalParser.MakeTokenProcTable;
var
  I: TptTokenKind;
begin
  for I := ptAbsolute to ptXor do
    Case I of
      ptAnsiComment: fTokenTable[I] := ptAnsiCommentProc;
      ptBorComment: fTokenTable[I] := ptBorCommentProc;
      ptCompDirect: fTokenTable[I] := ptCompDirectProc;
      ptConst: fTokenTable[I] := ptConstProc;
      ptConstructor: fTokenTable[I] := ptConstructorProc;
      ptCRLF: fTokenTable[I] := ptCRLFProc;
      ptCRLFCo: fTokenTable[I] := ptCRLFCoProc;
      ptDefineDirect: fTokenTable[I] := ptDefineDirectProc;
      ptDestructor: fTokenTable[I] := ptDestructorProc;
      ptElseDirect: fTokenTable[I] := ptElseDirectProc;
      ptEndIfDirect: fTokenTable[I] := ptEndIfDirectProc;
      ptError: fTokenTable[I] := ptErrorProc;
      ptExports: fTokenTable[I] := ptExportsProc;
      ptFinalization: fTokenTable[I] := ptFinalizationProc;
      ptFunction: fTokenTable[I] := ptFunctionProc;
      ptIdentifier: fTokenTable[I] := ptIdentifierProc;
      ptIfDefDirect: fTokenTable[I] := ptIfDefDirectProc;
      ptIfNDefDirect: fTokenTable[I] := ptIfNDefDirectProc;
      ptIfOptDirect: fTokenTable[I] := ptIfOptDirectProc;
      ptImplementation: fTokenTable[I] := ptImplementationProc;
      ptIncludeDirect: fTokenTable[I] := ptIncludeDirectProc;
      ptInitialization: fTokenTable[I] := ptInitializationProc;
      ptInterfaceStart: fTokenTable[I] := ptInterfaceStartProc;
      ptLibrary: fTokenTable[I] := ptLibraryProc;
      ptNull: fTokenTable[I] := ptNullProc;
      ptObject: fTokenTable[I] := ptObjectProc;
      ptProcedure: fTokenTable[I] := ptProcedureProc;
      ptProgram: fTokenTable[I] := ptProgramProc;
      ptResourceDirect: fTokenTable[I] := ptResourceDirectProc;
      ptResourcestring: fTokenTable[I] := ptResourcestringProc;
      ptSemiColon: fTokenTable[I] := ptSemiColonProc;
      ptSlashesComment: fTokenTable[I] := ptSlashesCommentProc;
      ptStringresource: fTokenTable[I] := ptStringresourceProc;
      ptTheEnd: fTokenTable[I] := ptTheEndProc;
      ptThreadvar: fTokenTable[I] := ptThreadvarProc;
      ptType: fTokenTable[I] := ptTypeProc;
      ptUndefDirect: fTokenTable[I] := ptUndefDirectProc;
      ptUnit: fTokenTable[I] := ptUnitProc;
      ptUses: fTokenTable[I] := ptUsesProc;
      ptVar: fTokenTable[I] := ptVarProc;
    else fTokenTable[I] := AlternativeProc;
    end;
end;

procedure TmwPascalParser.Parse;
begin
  while not Finished do fTokenTable[fLexer.TokenID];
end;

procedure TmwPascalParser.ParseArrayConstantDeclaration;
begin
  { ToDo }
end;

procedure TmwPascalParser.ParseArrayDeclaration;
begin
  { ToDo }
  fLexer.Next;
end;

procedure TmwPascalParser.ParseBlock;
begin
  { ToDo }
end;

procedure TmwPascalParser.ParseCaseSection;
begin
  { ToDo }
end;

procedure TmwPascalParser.ParseClassDeclaration;
begin
  { ToDo }
  fLexer.Next;
end;

procedure TmwPascalParser.ParseClassFieldDeclaration;
begin
  { ToDo }
end;

procedure TmwPascalParser.ParseClassForwardDeclaration;
begin
  { ToDo }
  fLexer.Next;
end;

procedure TmwPascalParser.ParseClassFunctionDeclaration;
begin
  { ToDo }
end;

procedure TmwPascalParser.ParseClassFunctionImplementation;
begin
  { ToDo }
end;

procedure TmwPascalParser.ParseClassProcedureDeclaration;
begin
  { ToDo }
end;

procedure TmwPascalParser.ParseClassProcedureImplementation;
begin
  { ToDo }
end;

procedure TmwPascalParser.ParseClassReferenceDeclaration;
begin
  { ToDo }
  fLexer.Next;
end;

procedure TmwPascalParser.ParseConstSection;
begin
  { ToDo }
end;

procedure TmwPascalParser.ParseConstructorDeclaration;
begin
  { ToDo }
end;

procedure TmwPascalParser.ParseConstructorImplementation;
begin
  { ToDo }
end;

procedure TmwPascalParser.ParseDestructorDeclaration;
begin
  { ToDo }
end;

procedure TmwPascalParser.ParseDestructorImplementation;
begin
  { ToDo }
end;

procedure TmwPascalParser.ParseDispInterfaceDeclaration;
begin
  { ToDo }
  fLexer.Next;
end;

procedure TmwPascalParser.ParseForLoop;
begin
  { ToDo }
end;

procedure TmwPascalParser.ParseFormalParameters;
begin
  { ToDo }
end;

procedure TmwPascalParser.ParseFunctionalTypeDeclaration;
begin
  { ToDo }
  fLexer.Next;
end;

procedure TmwPascalParser.ParseFunctionDeclaration;
begin
  { ToDo }
end;

procedure TmwPascalParser.ParseFunctionImplementation;
begin
  { ToDo }
end;

procedure TmwPascalParser.ParseFunctionMethodDeclaration;
begin
  { ToDo }
end;

procedure TmwPascalParser.ParseFunctionMethodImplementation;
begin
  { ToDo }
end;

procedure TmwPascalParser.ParseIfStatement;
begin
  { ToDo }
end;

procedure TmwPascalParser.ParseInterfaceDeclaration;
begin
  { ToDo }
  fLexer.Next;
end;

procedure TmwPascalParser.ParseLabelDeclarationSection;
begin
  { ToDo }
end;

procedure TmwPascalParser.ParsePackedArrayDeclaration;
begin
  { ToDo }
  fLexer.Next;
end;

procedure TmwPascalParser.ParsePackedSetDeclaration;
begin
  { ToDo }
  fLexer.Next;
end;

procedure TmwPascalParser.ParseProceduralTypeDeclaration;
begin
  { ToDo }
  fLexer.Next;
end;

procedure TmwPascalParser.ParseProcedureDeclaration;
begin
  { ToDo }
end;

procedure TmwPascalParser.ParseProcedureImplementation;
begin
  { ToDo }
end;

procedure TmwPascalParser.ParseProcedureMethodDeclaration;
begin
  { ToDo }
end;

procedure TmwPascalParser.ParseProcedureMethodImplementation;
begin
  { ToDo }
end;

procedure TmwPascalParser.ParseRecordCaseSection;
begin
  { ToDo }
end;

procedure TmwPascalParser.ParseRecordConstantDeclaration;
begin
  { ToDo }
end;

procedure TmwPascalParser.ParseRecordDeclaration;
begin
  { ToDo }
end;

procedure TmwPascalParser.ParseRecordFieldConstantDeclaration;
begin
  { ToDo }
end;

procedure TmwPascalParser.ParseRepeatLoop;
begin
  { ToDo }
end;

procedure TmwPascalParser.ParseSetDeclaration;
begin
  { ToDo }
end;

procedure TmwPascalParser.ParseTypeSection;
var
  ID1, ID2, ID3, ExID1, ExID2, ExID3: TptTokenKind;
begin
  CreateNewInfo(fCurInfo);
  fCurInfo.InfoType := ciTypeSection;
  GotoNextNoJunk;
  Repeat
    Case fLexer.TokenID of
      ptIdentifier:
        begin
          fLexer.Ahead(ID1, ID2, ID3, ExID1, ExID2, ExID3);
          if ID1 = ptEqual then
          begin
            Case ID2 of
              ptArray: ParseArrayDeclaration;
              ptClass:
                Case ID3 of
                  ptOf: ParseClassReferenceDeclaration;
                  ptSemiColon: ParseClassForwardDeclaration;
                else ParseClassDeclaration;
                end;
              ptDispInterface: ParseDispInterfaceDeclaration;
              ptFunction: ParseFunctionalTypeDeclaration;
              ptInterface: ParseInterfaceDeclaration;
              ptPacked:
                Case ID3 of
                  ptArray: ParsePackedArrayDeclaration;
                  ptSet: ParsePackedSetDeclaration;
                else fLexer.Next { ToDo };
                end;
              ptProcedure: ParseProceduralTypeDeclaration;
            else fLexer.Next {ToDo};
            end;
          end else fLexer.Next{ error handling };
        end;
      ptIfDefDirect: ptIfDefDirectProc;
      ptIfNDefDirect: ptIfNDefDirectProc;
      ptIfOptDirect: ptIfOptDirectProc;
      ptAnsiComment, ptBorComment, ptCRLF, ptCRLFCo,
        ptSlashesComment, ptSpace: GotoNextNoJunk;
    else fLexer.Next {ToDo};
    end
  until fLexer.TokenID in [ptConst, ptEnd, ptFinalization, ptFunction,
    ptInterfaceStart, ptProcedure, ptType, ptVar];

  RestoreInfoFromStack(fLexer.TokenPos);
end;

procedure TmwPascalParser.ParseVarSection;
begin
  { ToDo }
  fLexer.Next;
end;

procedure TmwPascalParser.ParseWhileLoop;
begin
  { ToDo }
end;

procedure TmwPascalParser.ptAnsiCommentProc;
begin

  fLexer.Next;
end;

procedure TmwPascalParser.ptBorCommentProc;
begin

  fLexer.Next;
end;

procedure TmwPascalParser.ptCompDirectProc;
begin

  fLexer.Next;
end;

procedure TmwPascalParser.ptConstProc;
begin
  case fCurInfo.InfoType of
    ciUsesClause: RestoreInfoFromStack(fLexer.RunPos);
    { This should not happen: add error handling }
  end;
  fLexer.Next;
end;

procedure TmwPascalParser.ptConstructorProc;
begin
  case fCurInfo.InfoType of
    ciUsesClause: RestoreInfoFromStack(fLexer.RunPos);
    { This should not happen: add error handling }
  end;
  fLexer.Next;
end;

procedure TmwPascalParser.ptCRLFCoProc;
begin

  fLexer.Next;
end;

procedure TmwPascalParser.ptCRLFProc;
begin

  fLexer.Next;
end;

procedure TmwPascalParser.ptDefineDirectProc;
begin

  fLexer.Next;
end;

procedure TmwPascalParser.ptDestructorProc;
begin
  case fCurInfo.InfoType of
    ciUsesClause: RestoreInfoFromStack(fLexer.RunPos);
    { This should not happen: add error handling }
  end;
  fLexer.Next;
end;

procedure TmwPascalParser.ptElseDirectProc;
begin

  fLexer.Next;
end;

procedure TmwPascalParser.ptEndIfDirectProc;
begin

  fLexer.Next;
end;

procedure TmwPascalParser.ptErrorProc;
begin

  fLexer.Next;
end;

procedure TmwPascalParser.ptExportsProc;
begin
  case fCurInfo.InfoType of
    ciUsesClause: RestoreInfoFromStack(fLexer.RunPos);
    { This should not happen: add error handling }
  end;
  fLexer.Next;
end;

procedure TmwPascalParser.ptFinalizationProc;
begin
  RestoreInfoFromStack(fLexer.TokenPos);
  CreateNewInfo(fCurInfo);
  fCurInfo.InfoType := ciFinalizationsSection;
  fLexer.Next;
end;

procedure TmwPascalParser.ptFunctionProc;
begin
  case fCurInfo.InfoType of
    ciUsesClause: RestoreInfoFromStack(fLexer.RunPos);
    { This should not happen: add error handling }
  end;
  fLexer.Next;
end;

procedure TmwPascalParser.ptIdentifierProc;
var
  OldCount: Integer;
begin
  case fCurInfo.InfoType of
    ciUsesClause:
      begin
        case fCurUnit.ImplementationsLine < 0 of
          True: fCurUnit.UsesList.Add(fLexer.Token);
          False: fCurUnit.SecondUsesList.Add(fLexer.Token);
        end;
        if GoIntoUnits then
        begin
          OldCount := fUnitStack.Count;
          LookForFile(fLexer.Token);
          if OldCount = fUnitStack.Count then fLexer.Next;
        end else fLexer.Next;
      end;
  else
    Case fLexer.ExID of
      ptContains: fLexer.Next { ToDo };
      ptPackage: fLexer.Next { ToDo };
      ptRequires: fLexer.Next { ToDo };
    else fLexer.Next;
    end;
  end;
end;

procedure TmwPascalParser.ptIfDefDirectProc;
begin

  fLexer.Next;
end;

procedure TmwPascalParser.ptIfNDefDirectProc;
begin

  fLexer.Next;
end;

procedure TmwPascalParser.ptIfOptDirectProc;
begin

  fLexer.Next;
end;

procedure TmwPascalParser.ptImplementationProc;
begin
  fCurUnit.ImplementationsLine := fLexer.LineNumber;
  while fCurUnit.InfoStack.Count > 1 do RestoreInfoFromStack(fLexer.TokenPos);
  CreateNewInfo(fCurInfo);
  fCurInfo.InfoType := ciImplementationsSection;
  fLexer.Next;
end;

procedure TmwPascalParser.ptIncludeDirectProc;
var
  OldCount: Integer;
begin
  if GoIntoUnits then
  begin
    OldCount := fUnitStack.Count;
    LookForFile(fLexer.DirectiveParam);
    if OldCount = fUnitStack.Count then fLexer.Next;
  end else fLexer.Next;
end;

procedure TmwPascalParser.ptInitializationProc;
begin
  CreateNewInfo(fCurInfo);
  fCurInfo.InfoType := ciInitializationsSection;
  fLexer.Next;
end;

procedure TmwPascalParser.ptInterfaceStartProc;
begin
  fCurUnit.InterfaceLine := fLexer.LineNumber;
  CreateNewInfo(fCurInfo);
  fCurInfo.InfoType := ciInterfaceSection;
  fLexer.Next;
end;

procedure TmwPascalParser.ptLibraryProc;
begin
  fCurUnit.InfoType := ciLibrary;
  fLexer.Next;
end;

procedure TmwPascalParser.ptNullProc;
begin
  fCurUnit.Parsed := True;
  if fUnitStack.Count > 0 then
  begin
    while fCurUnit.InfoStack.Count > 1 do RestoreInfoFromStack(fLexer.TokenPos);
    fCurInfo.EndPos := fLexer.RunPos;
    RestoreUnitFromStack;
    fLexer.Next;
  end else
  begin
    while fCurUnit.InfoStack.Count > 1 do RestoreInfoFromStack(fLexer.TokenPos);
    fCurInfo.EndPos := fLexer.RunPos;
    fFinished := True;
  end
end;

procedure TmwPascalParser.ptObjectProc;
begin
  case fCurInfo.InfoType of
    ciUsesClause: RestoreInfoFromStack(fLexer.RunPos);
    { This should not happen: add error handling }
  end;

  fLexer.Next;
end;

procedure TmwPascalParser.ptProcedureProc;
begin
  case fCurInfo.InfoType of
    ciUsesClause: RestoreInfoFromStack(fLexer.RunPos);
    { This should not happen: add error handling }
  end;

  fLexer.Next;
end;

procedure TmwPascalParser.ptProgramProc;
begin
  fCurUnit.InfoType := ciProgram;
  fLexer.Next;
end;

procedure TmwPascalParser.ptResourceDirectProc;
begin

  fLexer.Next;
end;

procedure TmwPascalParser.ptResourcestringProc;
begin
  case fCurInfo.InfoType of
    ciUsesClause: RestoreInfoFromStack(fLexer.RunPos);
    { This should not happen: add error handling }
  end;
  fLexer.Next;
end;

procedure TmwPascalParser.ptSemiColonProc;
begin
  case fCurInfo.InfoType of
    ciUsesClause: RestoreInfoFromStack(fLexer.RunPos);
  end;
  fLexer.Next;
end;

procedure TmwPascalParser.ptSlashesCommentProc;
begin

  fLexer.Next;
end;

procedure TmwPascalParser.ptStringresourceProc;
begin
  case fCurInfo.InfoType of
    ciUsesClause: RestoreInfoFromStack(fLexer.RunPos);
    { This should not happen: add error handling }
  end;
  fLexer.Next;
end;

procedure TmwPascalParser.ptTheEndProc;
begin
  fCurUnit.Parsed := True;
  if fUnitStack.Count > 0 then
  begin
    while fCurUnit.InfoStack.Count > 1 do RestoreInfoFromStack(fLexer.TokenPos);
    fCurInfo.EndPos := fLexer.RunPos;
    RestoreUnitFromStack;
    fLexer.Next;
  end else
  begin
    while fCurUnit.InfoStack.Count > 1 do RestoreInfoFromStack(fLexer.TokenPos);
    fCurInfo.EndPos := fLexer.RunPos;
    fFinished := True;
  end
end;

procedure TmwPascalParser.ptThreadvarProc;
begin
  case fCurInfo.InfoType of
    ciUsesClause: RestoreInfoFromStack(fLexer.RunPos);
    { This should not happen: add error handling }
  end;
  fLexer.Next;
end;

procedure TmwPascalParser.ptTypeProc;
begin
  case fCurInfo.InfoType of
    ciUsesClause: RestoreInfoFromStack(fLexer.RunPos);
    { This should not happen: add error handling }
  end;
  ParseTypeSection;
end;

procedure TmwPascalParser.ptUndefDirectProc;
begin
  case fCurInfo.InfoType of
    ciUsesClause: RestoreInfoFromStack(fLexer.RunPos);
    { This should not happen: add error handling }
  end;
  fLexer.Next;
end;

procedure TmwPascalParser.ptUnitProc;
begin
  fCurUnit.InfoType := ciUnit;
  fLexer.Next;
end;

procedure TmwPascalParser.ptUsesProc;
begin
  CreateNewInfo(fCurInfo);
  fCurInfo.InfoType := ciUsesClause;
  case fCurUnit.ImplementationsLine < 0 of
    True: fCurUnit.UsesLine := fLexer.LineNumber;
    False: fCurUnit.SecondUsesLine := fLexer.LineNumber;
  end;
  fLexer.Next;
end;

procedure TmwPascalParser.ptVarProc;
begin
  case fCurInfo.InfoType of
    ciUsesClause: RestoreInfoFromStack(fLexer.RunPos);
    { This should not happen: add error handling }
  end;
  ParseVarSection;
end;

procedure TmwPascalParser.RestoreInfoFromStack(LastPos: Integer);
begin
  if fCurUnit.InfoStack.Count < 1 then Exit;
  fCurInfo.EndPos := LastPos;
  fCurUnit.InfoStack.RemoveLast;
  fCurInfo := fCurUnit.InfoStack.Last;
end;

procedure TmwPascalParser.RestoreUnitFromStack;
begin
  if fUnitStack.Count < 1 then Exit;
  fCurUnit := TmwPasUnitInfo(fUnitStack.Last);
  fCurInfo := fCurUnit.InfoStack.Last;
  fLexer.Status := fCurUnit.LexStatus;
  fUnitStack.Delete(fUnitStack.Count - 1);
end;

procedure TmwPascalParser.SetExcludedUnits(const Value: TStringList);
begin
  fExcludedUnits.Assign(Value);
end;

procedure TmwPascalParser.SetSearchPaths(const Value: TStringList);
begin
  fSearchPaths.Assign(Value);
end;

procedure TmwPascalParser.TerminateStream(aStream: TMemoryStream);
var
  aChar: char;
begin
  aStream.Position := aStream.Size;
  aChar := #0;
  aStream.Write(aChar, 1);
end;

end.

