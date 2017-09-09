{
  Unit dtpResource

  TdtpResource is a generic resource that can hold any kind of binary data.

  It implements reading from external files, or from embedded XML data, or from
  files inside the archive. Temporary storage is created as virtual memory. When
  real physical memory would run out, this is swapped to the page file.

  Project: DTP-Engine

  Creation Date: 22-08-2003 (NH)
  Version: See "changes.txt"

  Modifications:
  03jun2011: placed global resource thread in DtpDocument.pas

  Copyright (c) 2002-2011 By Nils Haeck M.Sc. - SimDesign
  More information: www.simdesign.nl or n.haeck@simdesign.nl

  This source code may NOT be used or replicated without prior permission
  from the abovementioned author.

}
unit dtpResource;

{$i simdesign.inc}

interface

uses
  Classes, Contnrs, Windows, SysUtils, SyncObjs, NativeXmlOld,
  Math, sdStorage, dtpDefaults,

  // we add dtpRasterHck here because it is used as intermediate storage format
  dtpRasterHck;

type

  TdtpResourceMode = (
    rmStored,    // The resource is stored (either embedded, archive, or external)
    rmIdle,      // The resource is loaded, resides in mapfile FStream
    rmActive     // The resource is active. As long as LockCount > 0 it won't be deactivated
                 // Deactivation may occor automatically if LockCount = 0
  );

const
   // Names of each storage mechanism
   cStorageDescription: array[TdtpResourceStorage] of string =
   ( 'None',
     'External',
     'Archive',
     'Embedded' );

type

  // TMapStream implements a virtual memory stream. Create it simply like this:
  // AMap := TMapStream.Create. It will map to the Windows page file automatically
  // if the physical memory of the machine runs low.
  TMapStream = class(TStream)
  private
    FPageIndex: integer;  // Index of current page
    FPageOffset: integer; // Position (offset) into the current page
    FPageSize: Integer;   // Memory size of each page
    FPages: array of pointer;
    FSize: Integer;       // The stream's total size
    function GetPosition: integer;
    procedure PageAlloc(Index: integer);
    procedure PageFree(Index: integer);
  protected
    procedure SetSize(NewSize: integer); override;
  public
    constructor Create; virtual;
    destructor Destroy; override;
    function Read(var Buffer; Count: Longint): Longint; override;
    function Write(const Buffer; Count: Longint): Longint; override;
    function Seek(Offset: integer; Origin: Word): integer; override;
  end;

  TdtpFileEvent = procedure(Sender: TObject; const AFileName: string) of object;


  TdtpObjectStreamEvent = procedure(Sender: TObject; var AObjectRef: TObject) of object;

  // TdtpResource is an object that can hold any kind of resource neccesary for
  // the document, for example a bitmap, metafile, etc. Resources are managed
  // by a global resource thread that scans them and decides which resources should
  // stay in memory and which resources will be written to disk. Resources which
  // have Storage = rsArchive will be written to the archive if they are not used
  // for a while, other resources will use up a map file. For intensive applications
  // use Storage = rsArchive to preserve memory.
  TdtpResource = class(TPersistent)
  private
    FAccessCount: integer;
    FAllowExternalOverwrite: boolean;
    FArchiveName: string;         // Name of the file in the archive (if stored with rsArchive)
    FFileName: string;            // The fully qualified name of external file (if storage with rsExternal)
    FObjectModified: boolean;     // The resource's object was modified
    FStream: TMapStream;          // A mapstream that stores the decompressed object
    FStreamModified: boolean;     // The resource's stream was modified
    FStreamLoaded: boolean;       // Set to true after the stream is loaded from archive or external
    FStorage: TdtpResourceStorage;// The storage method (external, document archive, or embedded)
    FDocument: TObject;
    FOnObjectFromStream: TdtpObjectStreamEvent;
    FOnObjectToStream: TdtpObjectStreamEvent;
    FOnAfterLoadFromFile: TNotifyEvent;
    FOnObjectChanged: TNotifyEvent;
    procedure SetObjectRef(const Value: TObject);
    function GetExtension: string;
    function GetObjectRef: TObject;
    function GetArchive: TsdStorage;
    function GetMode: TdtpResourceMode;
    procedure SetMode(const Value: TdtpResourceMode);
    function ArchiveFileExists: boolean;
    // Load an object from the stream if it has data
    procedure LoadObject;
    procedure StoreObject;
    procedure LoadStream;
    procedure SaveStream;
    procedure StoreStream;
    procedure LoadFromArchive;
    procedure LoadFromEmbedded(ANode: TXmlNodeOld);
    procedure SaveToArchive;
    procedure SaveToEmbedded(ANode: TXmlNodeOld);
    procedure LoadFromExternal;
    procedure SaveToExternal;
    function GetApproximateSize: integer;
    procedure SetStorage(const Value: TdtpResourceStorage);
    procedure SetExtension(const Value: string);
  protected
    FObjectRef: TObject;  // The object associated with the resource
    procedure DefaultObjectToStream; virtual;
    procedure DefaultObjectFromStream; virtual;
    procedure DefaultLoadFromExternal; virtual;
    procedure DoAfterLoadFromFile;
    procedure DoObjectChanged;
    function GetObjectApproximateSize: integer; virtual;
    procedure SaveObject;
    property StreamModified: boolean read FStreamModified write FStreamModified;
    property ObjectModified: boolean read FObjectModified write FObjectModified;
  public
    constructor Create; virtual;
    destructor Destroy; override;
    // Add the name of our archive file to the Names list if it is in use
    procedure AddArchiveResourceNames(Names: TStrings); virtual;
    // Assign another resource to this resource. This means that the current
    // content is dropped and a copy is created of Source.
    procedure Assign(Source: TPersistent); override;
    // When working for a longer time with a resource, wrap the sequence in a
    // call to BeginAccess and EndAccess in order to avoid the resource to be
    // dropped in the meantime.
    procedure BeginAccess;
    // Clear clears the current content of the resource.
    procedure Clear; virtual;
    // Drop gets called by the document or resource maintenance thread whenever
    // virtual memory runs low and the resource is relatively long unused. It will
    // cause the resource to drop its current object until referenced again. However,
    // the resource is still present, but in saved (compact) form.
    procedure Drop; virtual;
    // When working for a longer time with a resource, wrap the sequence in a
    // call to BeginAccess and EndAccess in order to avoid the resource to be
    // dropped in the meantime.
    procedure EndAccess;
    // Call IsEmpty to find out if the resource is empty.
    function IsEmpty: boolean;
    procedure LoadFromXML(ANode: TXmlNodeOld); virtual;
    procedure SaveToXml(ANode: TXmlNodeOld); virtual;
    // Call LoadFromFile to load a resource from the file with full name AFileName.
    // Prior to a call to this function you can set Storage to any other storage
    // type: Storage := rsExternal will cause the file to be stored externally
    // instead of embedded (default). Storage := rsArchive will cause the file to
    //  be stored with method rsArchive.
    procedure LoadFromFile(const AFileName: string);
    // Call LoadFromStream to load a resource from a stream in S. Count = 0 (default)
    // will cause the total stream S to be read from start to end. If Count is bigger
    // than 0, stream S will be read from for Count bytes. Set AExtension to indicate
    // what kind of stream is in S. The extension must match the type in order to
    // make sure the correct load and save methods are used. So when passing a jpeg
    // stream, call LoadFromStream(S, '.jpg');
    procedure LoadFromStream(S: TStream; const AExtension: string; Count: integer = 0);
    // Call SaveToFile to save the resource to a file with name AFileName.
    procedure SaveToFile(const AFileName: string; AllowOverwrite: boolean = False);
    // Set AllowExternalOverwrite to True if you want to let the resource write itself
    // to the external file with FileName once the resource changes. Use this option
    // with care! It is only recommended when using temporary files. Default is False.
    property AllowExternalOverwrite: boolean read FAllowExternalOverwrite write FAllowExternalOverwrite;
    // Specify an archive name if you want to use Storage = rsArchive manually. When using
    // LoadFromFile the ArchiveName is set to the filename.
    property ArchiveName: string read FArchiveName write FArchiveName;
    // Document is a pointer to the document which contains the archive in which
    // the resoure saves itself. You only have to provide this pointer if the
    // resource uses archive storage (Storage = rsArchive).
    property Document: TObject read FDocument write FDocument;
    // Extension returns the extension of the file that is currently loaded in
    // the resource. Extension is used internally by TdtpResource and TdtpBitmapResource
    // to determine how to load the data. Set Extension to a certain format to
    // force internal saving to that file format, e.g. Extension := '.jpg'. Make
    // sure to include the dot and use lowercase.
    property Extension: string read GetExtension write SetExtension;
    // FileName returns the name of the file that was loaded into the resource.
    // If the resource has Storage = rsEmbedded, this filename will be just the
    // filename without the path. If the resource has Storage = rsExternal, this
    // filename will contain the complete path to the actual file.
    property FileName: string read FFileName write FFileName;
    // ObjectRef points to the object that is held by the resource. Reading ObjectRef
    // will cause the resource to try to load and activate the object. If this succeeds,
    // ObjectRef will contain a valid pointer to the generic TObject type object, which
    // can be cast to the required class. If this fails, ObjectRef will be nil.
    property ObjectRef: TObject read GetObjectRef write SetObjectRef;
    // Storage determines the storage mechanism for the resource. If it is
    // rsEmbedded, the resource is stored in the XML in the archive (see LoadFromXml).
    // If it is rsExternal, the resource is stored in an external file outside of
    // the document and not copied into the archive. If it is rsArchive, the file
    // is stored as a shared resource in the archive.
    property Storage: TdtpResourceStorage read FStorage write SetStorage;
    // Stream holds the resource when it is not in Mode rmStored. Since Stream is a
    // TMapStream, its memory is mappable (virtual) and can be mapped to a page
    // file by Windows if not in use for some time. This ensures that memory
    // used by the resources stays within reasonable limits.
    // Use Stream when you implement events OnObjectFromStream / OnObjectToStream
    // in order to load / save the object from the stream.
    property Stream: TMapStream read FStream;
    // Use this event to do any initialisation of the owner after the resource is loaded
    // from a file (and mode is rmIdle)
    property OnAfterLoadFromFile: TNotifyEvent read FOnAfterLoadFromFile write FOnAfterLoadFromFile;
    // OnObjectChanged is called whenever the object got assigned or cleared, and can
    // be used to update or invalidate the setting control
    property OnObjectChanged: TNotifyEvent read FOnObjectChanged write FOnObjectChanged;
    // OnObjectFromStream can be used to provide specific code for loading the object
    // allocated to Obj from the Stream
    property OnObjectFromStream: TdtpObjectStreamEvent read FOnObjectFromStream write FOnObjectFromStream;
    // OnObjectToStream can be used to provide specific code for saving the object
    // in Obj to the Stream
    property OnObjectToStream: TdtpObjectStreamEvent read FOnObjectToStream write FOnObjectToStream;
  end;

  TdtpResourceClass = class of TdtpResource;

  TdtpResourceThread = class(TThread)
  private
    FResources: TList;
    FLastCheck: dword;
    FUpdateCount: integer;
    FLock: TCriticalSection;
    procedure DoResourceCheck;
    function GetResourceCount: integer;
    function GetResources(Index: integer): TdtpResource;
  protected
    procedure Execute; override;
  public
    constructor Create; virtual;
    destructor Destroy; override;
    procedure ResourceAdd(AResource: TdtpResource);
    procedure ResourceRemove(AResource: TdtpResource);
    procedure ResourceUpdate(AResource: TdtpResource);
    property Lock: TCriticalSection read FLock;
    property ResourceCount: integer read GetResourceCount;
    property Resources[Index: integer]: TdtpResource read GetResources;
  end;

// Retrieve the resource class from the class name AClassName
function RetrieveResourceClass(const AClassName: string): TdtpResourceClass;

// Register currently unknown resource classes
procedure RegisterResourceClass(AClass: TdtpResourceClass);

// Enter the global resource lock. Use this to prevent the resource thread from
// dropping resources while doing critical related work (like saving archive files)
procedure glResourceLockEnter;

// Leave the global resource lock. This call must precede each call to glResourceLockEnter.
procedure glResourceLockLeave;

// Do a check and drop the resources, can be called globally
procedure glCheckAndDropResources;

resourcestring

  sresNoMethodForObjectStoring   = 'No method for object storing defined';
  sresNoMethodForObjectLoading   = 'No method for object loading defined';
  sresFileDoesNotExist           = 'File does not exist: %s';
  sresNoSaveToFileMethod         = 'No OnSaveToFile event implemented.';
  sresFileAlreadyExists          = 'File already exists';
  sresResourceIsEmpty            = 'Resource is empty';
  sresCannotAllocateVirtualMem   = 'Cannot allocate virtual memory (%s).';
  sresCannotFreeVirtualMem       = 'Cannot free virtual memory (%s).';
  sresPageSizeIsZero             = 'Memory map page size is zero';
  sresAccessMismatch             = 'Access count mismatch';
  sreUnsupportedBinaryEncoding   = 'Unsupported binary encoding';

implementation

uses
  dtpShape, dtpDocument;

type
  TResourceClassHolder = class
  public
    FClass: TdtpResourceClass;
    FClassName: string;
  end;

const

  // Interval in msec to check the resource pool
  cResourceCheckInterval  = 2000;
  // Number of resource updates before doing a check
  cMaxResourceUpdateCount = 20;
  cAllowedResourceCount   = 10;

function RetrieveResourceClass(const AClassName: string): TdtpResourceClass;
var
  i: integer;
begin
  Result := TdtpResource;
  if assigned(FResourceClassList) then with FResourceClassList do
  begin
    for i := 0 to Count - 1 do
      if TResourceClassHolder(Items[i]).FClassName = AClassName then
      begin
        Result := TResourceClassHolder(Items[i]).FClass;
        exit;
      end;
  end;
end;

procedure RegisterResourceClass(AClass: TdtpResourceClass);
// Register currently unknown resource classes
var
  i: integer;
  ANewClass: TResourceClassHolder;
begin
  if not assigned(FResourceClassList) then
    FResourceClassList := TObjectList.Create;
  // Unique?
  with FResourceClassList do
  begin
    for i := 0 to Count - 1 do
      if AClass = TResourceClassHolder(Items[i]).FClass then
        exit;
    // Add new class
    ANewClass := TResourceClassHolder.Create;
    ANewClass.FClass := AClass;
    ANewClass.FClassName := AClass.ClassName;
    Add(ANewClass);
  end;
end;

// Add a resource to the global resource list
procedure glResourceAdd(AResource: TdtpResource);
begin
  if FResourceThread is TdtpResourceThread then
    TdtpResourceThread(FResourceThread).ResourceAdd(AResource);
end;

// Remove a resource from the global resource list
procedure glResourceRemove(AResource: TdtpResource);
begin
  if FResourceThread is TdtpResourceThread then
    TdtpResourceThread(FResourceThread).ResourceRemove(AResource);
end;

// Update a resource in the global resource list so that it is #1 again
procedure glResourceUpdate(AResource: TdtpResource);
begin
  if FResourceThread is TdtpResourceThread then
    TdtpResourceThread(FResourceThread).ResourceUpdate(AResource);
end;

procedure glResourceLockEnter;
begin
  if FResourceThread is TdtpResourceThread then
    TdtpResourceThread(FResourceThread).Lock.Enter;
end;

procedure glResourceLockLeave;
begin
  if FResourceThread is TdtpResourceThread then
    TdtpResourceThread(FResourceThread).Lock.Leave;
end;

// Do a check and drop the resources, can be called globally
procedure glCheckAndDropResources;
begin
  if FResourceThread is TdtpResourceThread then
    TdtpResourceThread(FResourceThread).DoResourceCheck;
end;

{ TdtpResource }

function TdtpResource.ArchiveFileExists: boolean;
var
  Archive: TsdStorage;
begin
  BeginAccess;
  try
    Result := False;
    if length(FArchiveName) = 0 then exit;
    Archive := GetArchive;
    if assigned(Archive) then
      Result := Archive.StreamExists(UTF8String(FArchiveName));
  finally
    EndAccess;
  end;
end;

procedure TdtpResource.Assign(Source: TPersistent);
var
  ADoc: TNativeXmlOld;
begin
  BeginAccess;
  try
    if Source is TdtpResource then
    begin
      ADoc := CreateXmlForDtp('');
      try
        TdtpResource(Source).SaveToXml(ADoc.Root);
        LoadFromXml(ADoc.Root);
        // Clear the archive name to avoid duplicate copies
        FArchiveName := '';
        // Check for archive
        if (Storage in [rsExternal, rsArchive]) and (Document <> TdtpResource(Source).Document) then
        begin
           // Copy to our stream
           FStream.Size := 0;
           FStream.CopyFrom(TdtpResource(Source).FStream, 0);
           FStreamModified := True;
        end;
      finally
        ADoc.Free;
      end;
    end else
      inherited;
  finally
    EndAccess;
  end;
end;

procedure TdtpResource.BeginAccess;
begin
  inc(FAccessCount);
  glResourceLockEnter;
end;

procedure TdtpResource.Clear;
begin
  BeginAccess;
  try
    FStream.Size := 0;
    FArchiveName := '';
    FFileName := '';
    FObjectModified := False;
    FStreamModified := False;
    FStreamLoaded := False;
    if assigned(FObjectRef) then
    begin
      FreeAndNil(FObjectRef);
      DoObjectChanged;
    end;
  finally
    EndAccess;
  end;
end;

constructor TdtpResource.Create;
begin
  inherited Create;
  FStream := TMapStream.Create;
  // Defaults
  FStorage := rsEmbedded;
  // Register ourself in the global resource list
  glResourceAdd(Self);
end;

procedure TdtpResource.DefaultLoadFromExternal;
var
  S: TFileStream;
begin
  // just copy the stream
  S := TFileStream.Create(FFileName, fmOpenRead or fmShareDenyNone);
  try
    FStream.Size := 0;
    FStream.CopyFrom(S, S.Size);
  finally
    S.Free;
  end;
end;

procedure TdtpResource.DefaultObjectFromStream;
begin
  // Default is exception
  raise Exception.Create(sresNoMethodForObjectLoading);
end;

procedure TdtpResource.DefaultObjectToStream;
begin
  // Default is exception
  raise Exception.Create(sresNoMethodForObjectStoring);
end;

destructor TdtpResource.Destroy;
begin
  // Remove ourself from the global resource list
  glResourceRemove(Self);
  FreeAndNil(FObjectRef);
  FreeAndNil(FStream);
  inherited;
end;

procedure TdtpResource.DoAfterLoadFromFile;
begin
  if assigned(FOnAfterLoadFromFile) then FOnAfterLoadFromFile(Self);
end;

procedure TdtpResource.DoObjectChanged;
begin
  if assigned(FOnObjectChanged) then FOnObjectChanged(Self);
  // The modified object must be saved to the stream, the stream must be
  // saved to the archive (if any)
  SaveStream;
end;

procedure TdtpResource.Drop;
begin
  // Make sure to respect access
  if FAccessCount > 0 then exit;

  case Storage of
  rsEmbedded, rsNone:
    SetMode(rmIdle);
  rsArchive, rsExternal:
    SetMode(rmStored);
  end;
end;

procedure TdtpResource.EndAccess;
begin
  glResourceLockLeave;
  dec(FAccessCount);
  if FAccessCount < 0 then
    raise Exception.Create(sresAccessMismatch);
end;

function TdtpResource.GetApproximateSize: integer;
begin
  Result := FStream.Size + GetObjectApproximateSize;
end;

function TdtpResource.GetArchive: TsdStorage;
begin
  Result := nil;
  if Document is TdtpDocument then
    Result := TdtpDocument(Document).Archive;
end;

function TdtpResource.GetExtension: string;
begin
  Result := LowerCase(ExtractFileExt(FileName));
end;

function TdtpResource.GetMode: TdtpResourceMode;
begin
  BeginAccess;
  try
    Result := rmActive;
    if assigned(FObjectRef) or FObjectModified then
      exit;
    Result := rmIdle;
    if (FStream.Size > 0) or FStreamModified then
      exit;
    Result := rmStored;
  finally
    EndAccess;
  end;
end;

function TdtpResource.GetObjectApproximateSize: integer;
begin
  // Default object size returns streamsize if object is allocated. This is not
  // correct for objects that are read from compressed streams! Must be overridden
  // in descendants in that case
  if assigned(FObjectRef) then
    Result := FStream.Size
  else
    Result := 0;
end;

function TdtpResource.GetObjectRef: TObject;
begin
  BeginAccess;
  try
    // We were referenced so make sure to be in the upper list
    glResourceUpdate(Self);
    // Ensure we load the object
    SetMode(rmActive);
    Result := FObjectRef;
  finally
    EndAccess;
  end;
end;

function TdtpResource.IsEmpty: boolean;
begin
  Result := True;
  if GetMode in [rmIdle, rmActive] then
  begin
    Result := False;
    exit;
  end;
  // Mode = rmStored
  case Storage of
  rsArchive: Result := not ArchiveFileExists;
  rsExternal: Result := not FileExists(FFileName);
  end;
end;

procedure TdtpResource.LoadFromArchive;
var
  Archive: TsdStorage;
begin
  FStream.Size := 0;
  FStreamModified := False;
  if length(FArchiveName) = 0 then
    exit;
  Archive := GetArchive;
  if not assigned(Archive) then
    exit;
  try
    Archive.StreamRead(UTF8String(FArchiveName), FStream);
  except
    // Stream not present..
    FStream.Size := 0;
  end;
  if FStream.Size = 0 then
    FArchiveName := '';
  FStreamLoaded := True;
end;

procedure TdtpResource.LoadFromEmbedded(ANode: TXmlNodeOld);
// Load the stream from the embedded XML format in FNode
var
  AData, ABuffer: TXmlNodeOld;
  BinaryEncoding: TBinaryEncodingType;
  ASize: integer;
  M: TMemoryStream;
  AFilter: Utf8String;
begin
  FStreamModified := False;
  FStream.Size := 0;
  AData := ANode.NodeByName('Data');
  if not assigned(AData) then
    exit;

  ASize := AData.ReadInteger('Size');
  if ASize = 0 then
    exit;

  // Create buffer to hold data to save
  M := TMemoryStream.Create;

  try
    // Determine filter that is used
    AFilter := AData.ReadString('Filter');
    if AFilter = 'BinHex' then
    begin
      // BinHex encoded (for compat with old versions)
      BinaryEncoding := xbeBinHex;
    end else
      if (AFilter = 'Base64') or (AFilter = '') then
      begin
        // Base64 encoded
        BinaryEncoding := xbeBase64;
      end else
        raise Exception.Create(sreUnsupportedBinaryEncoding);

    // Decompress and read in
    ABuffer := AData.NodeByName('Buffer');
    if not assigned(ABuffer) then
      exit;

    // Read data into memory stream
    M.Size := ASize;
    ABuffer.BinaryEncoding := xbeBase64;
    ABuffer.BufferRead(M.Memory^, ASize);

    // Load the memory stream into the mapstream
    FStream.Write(M.Memory^, ASize);
    FStream.Position := 0;

  finally
    M.Free;
  end;
end;

procedure TdtpResource.LoadFromExternal;
begin
  FStream.Size := 0;
  FStreamModified := False;
  if not FileExists(FFileName) then
    exit;
  DefaultLoadFromExternal;
  FStreamLoaded := True;
  case Storage of
  rsEmbedded, rsNone:
    FStreamModified := True;
  rsArchive:
    begin
      FArchiveName := FFileName;
      FStreamModified := True;
    end;
  end;//case
end;

procedure TdtpResource.LoadFromFile(const AFilename: string);
// Load the resource from an external file and set mode to idle
begin
  BeginAccess;
  try
    // Clear the resource first
    Clear;

    // check
    if not FileExists(AFileName) then
      raise Exception.CreateFmt(sresFileDoesNotExist, [AFileName]);

    // Store filename for future use
    FFileName := ExpandUNCFileName(AFileName);
    // Load the file now, it also sets the FArchiveName
    LoadFromExternal;

    // Do we have anything?
    if (FStream.Size > 0) and FStreamModified then
    begin

      // Save it if rsArchive
      if Storage = rsArchive then
        SaveToArchive;

    end;
    // Call OnAfterLoadFromFile
    DoAfterLoadFromFile;
    DoObjectChanged;
  finally
    EndAccess;
  end;
end;

procedure TdtpResource.LoadFromStream(S: TStream; const AExtension: string; Count: integer = 0);
begin
  BeginAccess;
  try
    // Clear the resource first
    Clear;
    Extension := AExtension;

    if not assigned(S) then
      exit;
    FStream.Size := 0;
    if Count = 0 then
    begin
      S.Position := 0;
      FStream.CopyFrom(S, S.Size);
    end else
      FStream.CopyFrom(S, Count);
    FStreamModified := True;

    if FStream.Size > 0 then
    begin

      // Save it if rsArchive
      if Storage = rsArchive then
        SaveToArchive;

    end;
    // Call OnAfterLoadFromFile
    DoAfterLoadFromFile;
    DoObjectChanged;
  finally
    EndAccess;
  end;
end;

procedure TdtpResource.LoadFromXML(ANode: TXmlNodeOld);
var
  i: TdtpResourceStorage;
  S: string;
begin
  BeginAccess;
  try
    // Clear first
    Clear;

    // Load props
    FArchiveName := string(ANode.ReadString('ArchiveName'));
    FFileName := string(ANode.ReadString('FileName'));
    S := string(ANode.ReadString('Storage'));
    for i := low(TdtpResourceStorage) to high(TdtpResourceStorage) do
      if cStorageDescription[i] = S then
        FStorage := i;

    // Load the stream (using any of external, archive or embedded)
    case FStorage of
    rsArchive: LoadFromArchive;
    rsEmbedded: LoadFromEmbedded(ANode);
    rsExternal: LoadFromExternal;
    end;// case
  finally
    EndAccess;
  end;
end;

procedure TdtpResource.LoadObject;
begin
  BeginAccess;
  try
    if FObjectModified then
      exit;
    FreeAndNil(FObjectRef);
    LoadStream;
    if FStream.Size > 0 then
    begin
      FStream.Position := 0;
      if assigned(FOnObjectFromStream) then
        FOnObjectFromStream(Self, FObjectRef)
      else
        DefaultObjectFromStream;
      // Set this back to false, since it is likely to be set to true
      // by assignment to ObjectRef.
      FObjectModified := False;
    end;
  finally
    EndAccess;
  end;
end;

procedure TdtpResource.LoadStream;
begin
  if FObjectModified then
  begin
    SaveObject;
    exit;
  end;
  if not FStreamModified and not FStreamLoaded then
  begin
    case Storage of
    rsArchive: LoadFromArchive;
    rsExternal: LoadFromExternal;
    end;
  end;
end;

procedure TdtpResource.SaveObject;
begin
  if FObjectModified then
  begin
    FStream.Size := 0;
    if assigned(FObjectRef) then
      if assigned(FOnObjectToStream) then
        FOnObjectToStream(Self, FObjectRef)
      else
        DefaultObjectToStream;
    FStreamModified := True;
    FObjectModified := False;
  end;
end;

procedure TdtpResource.SaveStream;
begin
  // Save stream and clear stream if successful
  SaveObject;
  if FStreamModified then
  begin
    case Storage of
    rsArchive: SaveToArchive;
    rsExternal: SaveToExternal;
    end;
  end;
end;

procedure TdtpResource.SaveToArchive;
var
  Archive: TsdStorage;
begin
  if not FStreamModified then
    exit;
  // Try to get archive
  Archive := GetArchive;
  if not assigned(Archive) then
    exit;
  // Check stream size
  if FStream.Size = 0 then
  begin
    // No content -> Remove old archive and clear archive name
    if length(FArchiveName) > 0 then
      Archive.StreamDelete(UTF8String(FArchiveName));
    FArchiveName := '';
  end else
  begin
    // Content -> Create name if neccesary, and save to archive
    if length(FArchiveName) = 0 then
      FArchiveName := string(Archive.GetUniqueStreamName(UTF8String(Extension)));
    Archive.StreamWrite(UTF8String(FArchiveName), FStream);
  end;
  FStreamModified := False;
end;

procedure TdtpResource.SaveToEmbedded(ANode: TXmlNodeOld);
// Save the stream to the embedded XML format in FNode
var
  ABuf: Pointer;
  DataNode: TXmlNodeOld;
begin
  FStreamModified := False;
  if FStream.Size = 0 then exit;
  // Create buffer to hold data to save
  GetMem(ABuf, FStream.Size);
  try
    // Load the stream into the buffer
    FStream.Position := 0;
    FStream.Read(ABuf^, FStream.Size);

    DataNode := ANode.NodeNew('Data');
    DataNode.WriteInteger('Size', FStream.Size);
    //BinaryEncoding := xbeBase64;
    DataNode.WriteString('Filter', 'Base64');
    // In this case: no compression.. just write it away 1:1
    DataNode.NodeNew('Buffer').BufferWrite(ABuf^, FStream.Size);
  finally
    FreeMem(ABuf);
  end;
end;

procedure TdtpResource.SaveToExternal;
var
  S: TFileStream;
begin
  if not FStreamModified then exit;
  if (length(FFileName) > 0) and (FFileName[1] <> '.') then
  begin
    if FileExists(FFileName) and not FAllowExternalOverwrite then
      exit;//raise Exception.Create(sresNoSaveToFileMethod);
    if FStream.Size > 0 then
    begin
      S := TFileStream.Create(FFileName, fmCreate);
      try
        FStream.Position := 0;
        S.CopyFrom(FStream, FStream.Size);
      finally
        S.Free;
      end;
    end;
    FStreamModified := False;
  end;
end;

procedure TdtpResource.SaveToFile(const AFileName: string; AllowOverwrite: boolean);
var
  S: TFileStream;
begin
  BeginAccess;
  try
    // Check
    if not AllowOverwrite and FileExists(AFileName) then
      raise Exception.Create(sresFileAlreadyExists);

    // In case it wasn't saved
    SaveObject;

    // If we do not have data try to load
    LoadStream;

    // Do we have data now?
    if FStream.Size = 0 then
      raise Exception.Create(sresResourceIsEmpty);

    // Save to file
    S := TFileStream.Create(AFileName, fmCreate);
    try
      FStream.Position := 0;
      S.CopyFrom(FStream, FStream.Size);
    finally
      S.Free;
    end;
  finally
    EndAccess;
  end;
end;

procedure TdtpResource.SaveToXml(ANode: TXmlNodeOld);
begin
  BeginAccess;
  try
    ANode.WriteString('ClassName', UTF8String(ClassName));
    // Save the object if required
    SaveObject;
    case Storage of
    rsEmbedded:
      SaveToEmbedded(ANode);
    rsArchive:
      SaveToArchive;
    rsExternal:
      SaveToExternal;
    end;//case
    // Save props
    ANode.WriteString('ArchiveName', UTF8String(FArchiveName));
    ANode.WriteString('FileName', UTF8String(FFileName));
    ANode.WriteString('Storage',  UTF8String(cStorageDescription[FStorage]));
  finally
    EndAccess;
  end;
end;

procedure TdtpResource.SetExtension(const Value: string);
begin
  if length(FFilename) > 0 then
    FFileName := ChangeFileExt(FFileName, Value)
  else
    FFileName := Value;
end;

procedure TdtpResource.SetMode(const Value: TdtpResourceMode);
// Set the mode of the resource, by stepping through the states
var
  AMode: TdtpResourceMode;
begin
  BeginAccess;
  try
    AMode := GetMode;
    if AMode <> Value then
    begin
      case Value of
      rmStored:
        begin
          if AMode = rmActive then
            StoreObject;
          if GetMode = rmIdle then
            StoreStream;
        end;
      rmIdle:
        begin
          if AMode = rmStored then
          begin
            LoadStream;
            exit;
          end;
          if AMode = rmActive then
            StoreObject;
        end;
      rmActive:
        begin
          // First of all, load if not yet done
          if AMode = rmStored then
            LoadStream;
          // If idle, create the object
          if GetMode = rmIdle then
            LoadObject;
        end;
      end;//case
    end;
  finally
    EndAccess;
  end;
end;

procedure TdtpResource.SetObjectRef(const Value: TObject);
begin
  BeginAccess;
  try
    if FObjectRef <> Value then
    begin
      if assigned(FObjectRef) then
        FreeAndNil(FObjectRef);
      FObjectRef := Value;
      FObjectModified := True;
      glResourceUpdate(Self);
      DoObjectChanged;
    end;
  finally
    EndAccess;
  end;
end;

procedure TdtpResource.SetStorage(const Value: TdtpResourceStorage);
begin
  BeginAccess;
  try
    if FStorage <> Value then
    begin
      // Make sure to have the object
      LoadStream;
      // Set new storage method, and set FStreamModified to true to indicate
      // that the streem needs a save to new storage device
      FStorage := Value;
      FStreamModified := True;
      // Make sure to have an archive name if there's a filename
      if (length(FArchiveName )= 0) and (length(FFileName) >= 5) then
        FArchiveName := FFileName;
      // If the new storage is not embedded we will save
      SaveStream;
    end;
  finally
    EndAccess;
  end;
end;

procedure TdtpResource.StoreObject;
begin
  // Save object and remove object
  SaveObject;
  FreeAndNil(FObjectRef);
end;

procedure TdtpResource.StoreStream;
begin
  // Save stream and clear stream if successful
  SaveStream;
  if not FStreamModified then
  begin
    FStream.Size := 0;
    FStreamLoaded := False;
  end;
end;

procedure TdtpResource.AddArchiveResourceNames(Names: TStrings);
// Add our archive name to the list, if in use
begin
  if (Storage = rsArchive) and (length(FArchiveName) > 0) then
    Names.Add(FArchiveName);
end;

{ TMapStream }

constructor TMapStream.Create;
var
  AInfo: TSystemInfo;
begin
  inherited Create;
  // Get system information with page size
  GetSystemInfo(AInfo);
  // We use a the size of the allocation granularity. This will scale nicely
  // with system specs and also automatically be future compatible.
  // Currently it comes down to Granularity = 64Kb
  FPageSize := AInfo.dwAllocationGranularity;
  if FPageSize <= 0 then
    raise Exception.Create(sresPageSizeIsZero);
end;

destructor TMapStream.Destroy;
var
  i: integer;
begin
  for i := 0 to length(FPages) - 1 do
    PageFree(i);
  inherited;
end;

function TMapStream.GetPosition: integer;
begin
  Result := FPageIndex * FPageSize + FPageOffset;
end;

procedure TMapStream.PageAlloc(Index: integer);
begin
  // Virtual allocate
  FPages[Index] := VirtualAlloc(
    nil,           // contains nil so we will get a location allocated
    FPageSize,     // We will open one page
    MEM_COMMIT,    // Directly "commit" the memory. aka make it ready to write/read to/from
    PAGE_READWRITE // We want to read and write to the memory
  );
  if not assigned(FPages[Index]) then
    raise Exception.Create(SysErrorMessage(GetLastError));
end;

procedure TMapStream.PageFree(Index: integer);
var
  Res: bool;
begin
  Res := VirtualFree(FPages[Index], 0, MEM_RELEASE);
  if Res = False then
    raise Exception.Create(SysErrorMessage(GetLastError));
end;

function TMapStream.Read(var Buffer; Count: Integer): Longint;
var
  NewPosition: integer;
  S, D: PByte;
  PacketCount: integer;
begin
  NewPosition := GetPosition + Count;
  if NewPosition > FSize then
    Count := FSize - GetPosition;
  Result := Count;
  D := @Buffer;
  while Count > 0 do
  begin
    if FPageOffset = FPageSize then
    begin
      inc(FPageIndex);
      FPageOffset := 0;
    end;
    PacketCount := Min(Count, FPageSize - FPageOffset);
    S := @PByteArray(FPages[FPageIndex])[FPageOffset];
    Move(S^, D^, PacketCount);
    dec(Count, PacketCount);
    inc(D, PacketCount);
    inc(FPageOffset, PacketCount);
  end;
end;

function TMapStream.Seek(Offset: integer; Origin: Word): integer;
begin
  case Origin of
  soFromBeginning: Result := Offset;
  soFromCurrent:   Result := GetPosition + Offset;
  soFromEnd:       Result := FSize + Offset;
  else
    Result := 0; // avoid compiler warning
  end;//case
  if Result > FSize then
    SetSize(Result);
  // New page index and offset
  FPageIndex  := Result div FPageSize;
  FPageOffset := Result mod FPageSize;
end;

procedure TMapStream.SetSize(NewSize: integer);
var
  i, PageCount, OldCount: integer;
begin
  if NewSize = FSize then exit;
  PageCount := (NewSize + FPageSize - 1) div FPageSize;
  OldCount := length(FPages);
  if PageCount > OldCount then
  begin
    SetLength(FPages, PageCount);
    for i := OldCount to PageCount - 1 do
      PageAlloc(i);
  end;
  if PageCount < OldCount then
  begin
    for i := OldCount - 1 downto PageCount do
      PageFree(i);
    SetLength(FPages, PageCount);
  end;
  FSize := NewSize;
  if FSize < GetPosition then
  begin
    FPageIndex  := FSize div FPageSize;
    FPageOffset := FSize mod FPageSize;
  end;
end;

function TMapStream.Write(const Buffer; Count: Integer): Longint;
var
  NewPosition: integer;
  S, D: PByte;
  PacketCount: integer;
begin
  NewPosition := GetPosition + Count;
  if NewPosition > FSize then
    SetSize(NewPosition);
  Result := Count;
  S := @Buffer;
  while Count > 0 do
  begin
    if FPageOffset = FPageSize then
    begin
      inc(FPageIndex);
      FPageOffset := 0;
    end;
    PacketCount := Min(Count, FPageSize - FPageOffset);
    D := @PByteArray(FPages[FPageIndex])[FPageOffset];
    Move(S^, D^, PacketCount);
    dec(Count, PacketCount);
    inc(S, PacketCount);
    inc(FPageOffset, PacketCount);
  end;
end;

{ TdtpResourceThread }

constructor TdtpResourceThread.Create;
begin
  inherited Create(True);
  FResources := TList.Create;
  FLock := TCriticalSection.Create;
  Priority := tpLower;
{$warnings off}
  Resume;
{$warnings on}
end;

destructor TdtpResourceThread.Destroy;
begin
  FreeAndNil(FLock);
  FreeAndNil(FResources);
  inherited;
end;

procedure TdtpResourceThread.DoResourceCheck;
var
  i: integer;
  TotalSize: int64;
begin
  FLock.Enter;
  try
    if ResourceCount <= cAllowedResourceCount then
      exit;
    // Loop through all resources and drop the ones that were not updated recently
    // and above the allowed maximum size for all resources
    TotalSize := 0;
    for i := 0 to ResourceCount - 1 do
    begin
      if (TotalSize <= cDefaultMaximumResourceSize) and (i < cAllowedResourceCount) then
        // Add up to total
        inc(TotalSize, Resources[i].GetApproximateSize)
      else
        // We're above total, so we will drop this resource
        Resources[i].Drop;
    end;
  finally
    FLock.Leave;
  end;
end;

procedure TdtpResourceThread.Execute;
begin
  repeat
    if ((GetTickCount - FLastCheck) > cResourceCheckInterval)
      and (FUpdateCount > cMaxResourceUpdateCount) then
    begin
      DoResourceCheck;
      FLastCheck := GetTickCount;
      FUpdateCount := 0;
    end;
    sleep(10);
  until Terminated;
end;

function TdtpResourceThread.GetResourceCount: integer;
begin
  if assigned(FResources) then
    Result := FResources.Count
  else
    Result := 0;
end;

function TdtpResourceThread.GetResources(Index: integer): TdtpResource;
begin
  if (Index >= 0) and (Index < ResourceCount) then
    Result := TdtpResource(FResources[Index])
  else
    Result := nil;
end;

procedure TdtpResourceThread.ResourceAdd(AResource: TdtpResource);
begin
  FLock.Enter;
  try
    if assigned(FResources) and assigned(AResource)
      and not (FResources.IndexOf(AResource) >= 0) then
    FResources.Insert(0, AResource);
  finally
    FLock.Leave;
  end;
end;

procedure TdtpResourceThread.ResourceRemove(AResource: TdtpResource);
begin
  FLock.Enter;
  try
    if assigned(FResources) and assigned(AResource) then
      FResources.Remove(AResource);
  finally
    FLock.Leave;
  end;
end;

procedure TdtpResourceThread.ResourceUpdate(AResource: TdtpResource);
begin
  // Put the resource AResource back at #1 position
  FLock.Enter;
  try
    if assigned(FResources) and assigned(AResource)
      and (ResourceCount > 0) and (AResource <> Resources[0]) then
    begin
      AResource := FResources.Extract(AResource);
      if assigned(AResource) then
        FResources.Insert(0, AResource);
      inc(FUpdateCount);
    end;
  finally
    FLock.Leave;
  end;
end;

end.
