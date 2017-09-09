{**
	SuperStream is copyright (c) 2000 Ross Judson.<P>

  The contents of this file are subject to the Mozilla Public License
  Version 1.0 (the "License"); you may not use this file except in
  compliance with the License. You may obtain a copy of the
  License at http://www.mozilla.org/MPL/ <P>

  SuperStream documentation is in DelphiDoc format.  For information on
  DelphiDoc, please visit www.soletta.com.  Any updates to SuperStream can
  also be found there.  <P>

  Use tab size 2. <P>

	The SuperStream brings several important new capabilities to Delphi.   <P>

  First, the TStreamAdapter class permits the construction of streams
  that alter or buffer the data that passes through them, on the way to
  another stream.  An ownership concept is present, so that the streams
  are easy to build and free.  This enables, for example, easy buffering
  of TFileStreams.  The stock TFileStream is unbuffered and rather slow
  if many small io operations are made to it.  A TBufferedStream adapter
  can be placed on top of it to improve performance.  Stream adapters can
  be chained, so a TObjStream can be placed over a TBufferedStream, which
  is over a TFileStream, and so on.  <P>

  TBufferedStreams speed up io against the underlying stream if it is slow
  for many small reads and writes.   <P>

  TObjStream permits the easy storage and recovery of complex object graphs,
  complete with versioning.  It makes use of as much information as it
  can that is provided by the Delphi compiler.  Usage of the object streams
  is as simple as declaring an "object io procedure" for a class of
  object and registering it.  TObjStream differs from most object streaming
  code in that it makes heavy use of Delphi's open arrays to make coding
  as easy as possible.  <P>

  TObjStream understands class hierarchies, so any io procedures that are
  declared for superclasses are also called.  <P>

  TObjStream is suitable for many lightweight object storage tasks.  Couple
  TObjStream objects together with TBufferedStreams to improve performance.  <P>

  Here are the steps to use an object stream: <P>

  </UL>
  <LI> Decide which classes should be persistent.</LI>
	<LI> Write IO procedures for those classes.  Each IO procedure should have
  		the following signature:
  <CODE> TObjIO = procedure(obj : TObject; stream : TObjStream; direction : TObjIODirection; version : Integer; var callSuper : Boolean); </CODE> </LI>
	<LI> Register the IO procedures by calling TObjStream.RegisterClass. </LI>
  <LI> Create an object stream then read or write to it using WriteObject or
  ReadObject. </LI>
  </UL> <P>

  Your IO procedure should be prepared to receive a version number other than
  the tip revision.  If it receives an older version, it should correctly
  load the older version of the object.  The best way to do this is to use
  case statements, switching on the object version.  When you write objects,
  you should generally write the latest version.  By doing this, your
  application can read in old objects, but will automatically upgrade them
  to the latest version.  See the TestIO routine in the sample file for
  an example of this.<P>

  If you wish to register a class for IO but don't need to provide a procedure
  for it 'cause the superclass procedure will do, you still need to call
  RegisterClass.  Pass nil in place of an IO procedure pointer.

  See the StrTestFrm.pas file for example IO procedures.  You will primarily
  be using the TransferItems and TransferItemsEx calls.  If you need to
  handle TDateTime, Single, or Double, make sure you use the TransferItemsEx
  call, passing the ssvt constants appropriate to your data.<P>

  To transfer arrays of items, use the TransferArrays calls.  <P>

  Serializing sets can be a bit tricky.  Use the TransferBlocks call to
  handle sets -- pass the address of the set and do a SizeOf() call on the
  set to find out how much data to store.   <P>

  Note that you can freely mix calls to WriteObject and the various
  transfer calls during your IO procedures.  <P>

  Here is an example IO procedure:  <P>

  <PRE><CODE>
procedure TestIO(obj : TObject; stream : TObjStream; direction : TObjIODirection; version : Integer; var callSuper : Boolean);
begin
	with obj as TTest do
  	case version of
     1:
			begin
      	// old version didn't have a t value
		  	stream.TransferItems([s], [@s], direction, version);
        t := 'yipe';
      end;
     2:
	  	stream.TransferItems([s,t], [@s, @t], direction, version);
    end;

end;
  </CODE></PRE>

}

// We violate range checking in a few places here, deliberately.
{$RANGECHECKS OFF}

{$IFDEF VER100}
{$DEFINE DELPHI3}
{$ENDIF}

{$IFDEF VER110}
{$DEFINE DELPHI3}
{$ENDIF}

{$IFDEF VER120}
{$DEFINE DELPHI4}
{$ENDIF}


unit SuperStream;

interface

uses Classes, SysUtils;

const

	// These are straight from system.pas, except we've added ssvtSingle and ssvtDouble
	// so we can handle those kind of values.
	ssvtNone = -1;

	{** Indicates that the item is a single-precision (4 byte) floating point number. }
	ssvtSingle = -2;
	{** Indicates that the item is a double-precision (8 byte) floating point number. }
	ssvtDouble = -3;
	{** Indicates that the item is a TDateTime, which is really a double. }
	ssvtDateTime = ssvtDouble;

	{** Indicate that the item is an integer (32-bit). }
	ssvtInteger    = vtInteger   ;
	{** Indicate that the item is a boolean. }
	ssvtBoolean    = vtBoolean   ;
	{** Indicate that the item is a character. }
	ssvtChar       = vtChar      ;
	{** Indicate that the item is an extended floating point value. Unless your variable
	is specifically declared as extended, you will rarely want to use this.  Instead,
	use the ssvtSingle or ssvtDouble as appropriate. }
	ssvtExtended   = vtExtended  ;
	{** Indicate that the item is a short string. }
	ssvtString     = vtString    ;
	{** Indicate that the item is a pointer. }
	ssvtPointer    = vtPointer   ;
	{** Indicate that the item is a pointer to character. }
	ssvtPChar      = vtPChar     ;
	{** Indicate that the item is an object. }
	ssvtObject     = vtObject    ;
	{** Indicate that the item is a class object. }
	ssvtClass      = vtClass     ;
	{** Indicate that the item is a wide character. }
	ssvtWideChar   = vtWideChar  ;
	{** Indicate that the item is a pointer to wide characters. }
	ssvtPWideChar  = vtPWideChar ;
	{** Indicate that the item is an AnsiString (long string). }
	ssvtAnsiString = vtAnsiString;
	{** Indicate that the item is a currency value (like extended). }
	ssvtCurrency   = vtCurrency  ;
	{** Indicate that the item is a variant (not supported). }
	ssvtVariant    = vtVariant   ;
	{** Indicate that the item is an interface (not supported). }
  ssvtInterface  = vtInterface ;
  {** Indicate that the item is a wide string (not supported). }
	ssvtWideString = vtWideString;

{$IFDEF DELPHI4}
	ssvtInt64 = vtInt64;
{$ENDIF}

type

	TInitializer = procedure;

	{** TStreamAdapter defines a stream that wraps another stream. }
  TStreamAdapter = class(TStream)

  public
  	{** Construct a stream adapter.
    	@param 	targetStream		The stream being adapted.
      @param	owned						If true, the stream being adapted will be destroyed
      												when the adapter is destroyed. }
  	constructor Create(targetStream : TStream; owned : Boolean);

    {** Destroy a stream adapter.  Will also destroy the target stream if
    the owned flag is set true. }
    destructor Destroy; override;

    {** Read count bytes into buffer.  This is an override of the standard
    stream function.
    	@param 	buffer		Variable to read bytes into.
      @param	count			Number of bytes to read. }
		function Read(var Buffer; Count: Longint): Longint; override;

    {** write count bytes to the stream.  This is an override of the standard
    stream function.
    	@param buffer Variable to write to the stream.
      @param count Number of bytes to write. }
		function Write(const Buffer; Count: Longint): Longint; override;

    {** Move to a given position in the stream.
    @param 	offset 	The position to move to.
    @param	origin	Where to move:  Can be soFromBeginning, soFromCurrent, or soFromEnd. }
		function Seek(Offset: Longint; Origin: Word): Longint; override;

	protected
  	{** The stream being adapted. }
		FStream : TStream;
    {** Indicates Whether the target stream will be freed on destruction of
    the adapter. }
		FOwned : Boolean;

		procedure SetSize(NewSize: Longint); override;

  private
  	procedure _SetSize(NewSize : LongInt);

  end;

  {** Exceptions thrown by the object streaming system will be of this class
  or a descendent. }
	TObjStreamException = class(Exception)
  end;

	TObjStream = class;

  {** This determines the whether the io is read or write. }
  TObjIODirection = (iodirRead, iodirWrite);

  {** IO procedures must have this signature. obj is the object being read or
  written.  If being written, you will probably want to case the object to
  the correct type.  If being read, the object will already have been created,
  but will NOT have had a constructor called.  If your object requires that
  a constructor be called, invoke it directly, as in obj.Create.  This will
  not create a new object, but will initialize yours.  Note that many
  constructors just initialize variables -- if you're about to read in all
  those variables, you don't need to set them beforehand.  <P>

  Stream is the object stream. You may invoke any of its methods in your
  IO procedure, including WriteObject and the TransferXXX family.   <P>

  Direction indicates whether the call is for reading (iodirRead) or writing
  (iodirWrite).  Most of the time you won't have to worry about this --
  the TransferXXX calls read and write objects automatically depending on
  the direction flag passed to them.  <P>

  Version is the version of the object.  You will always be requested to
  write only the latest version of an object, unless you specifically
  try to write an earlier version yourself.  SuperStream won't do it.  You
  may be asked to read an earlier version of an object.  You should make
  sure you correctly read the earlier version, and fill in any extra
  information that isn't covered.  That way you'll have automatic upgrading
  of your objects.  <P>

	CallSuper is a boolean that's preset to true, indicating that the superClass'
  IO procedure will be called.  If you don't want the superClass' IO procedure
  to be called, set this to false before returning.  <P>
  }
	TObjIO = procedure(obj : TObject; stream : TObjStream; direction : TObjIODirection; version : Integer; var callSuper : Boolean);

  TObjCreation = procedure(obj : TObject; stream : TObjStream; version : Integer) of object;

  TStreamRegistration = class;

  {** Each object stream starts with one of these. }
  TObjStreamHeader = record
  	magic : Integer;
    dummy1, dummy2, dummy3, dummy4 : Integer;
  end;

  {** Options that can be applied to object streams.  Currently only the
  graph option is supported.  Supplying osoGraph as an option permits the
  reading and writing of arbitrary graphs of objects.  If this option is
  not supplied, objects will be written in full each time they are
  encountered.  It is highly recommended that the osoGraph option be supplied
  if there is any chance of an object appearing more than once.  Not supplying
  the option will result in a small speedup. }
  TObjStreamOption = (
  	osoGraph // support object graphs
  );
  {** A set of stream options. }
  TObjStreamOptions = set of TObjStreamOption;

  {** Object stream adapters read and write objects from other streams. It is
  often useful to couple this adapter with a buffering adapter, as object
  streams frequently read and write with thousands of small byte count io
  operations. }
	TObjStream = class(TStreamAdapter)
  protected

  	{** Indicates whether the header has already been transferred. }
		FHeaderTransferred : Boolean;

    {** Stores the options this stream has active. }
    FOptions : TObjStreamOptions;

    {** Stores the list of objects that have been written or read.  This
		is only used in graph mode. }
    FObjList : TList;

    {** Hook for programs to modify object construction. }
    FObjCreation : TObjCreation;

  public

  	{** If assigned, this event will be fired whenever a new object is created.
    This gives the program a chance to alter the construction of the new object. }
  	property OnObjCreation : TObjCreation read FObjCreation write FObjCreation;

  	{** Register class notifies the streaming system of a persistent capable class.
    @param 	cls				The class being registered.
    @param	_writer		An io procedure for the class.
    @param	latest		The current version number for the class (an integer).
    									The version number will usually be incremented each time
                      the structure of the object changes. }
  	class procedure RegisterClass(cls : TClass; _writer : TObjIO; latest : Integer);

  	{** Register class notifies the streaming system of a persistent capable class.
    @param 	cls				The class being registered.
    @param	_writer		An io procedure for the class.
    @param	latest		The current version number for the class (an integer).
    									The version number will usually be incremented each time
                      the structure of the object changes.
    @param init				Object initializer. }
  	class procedure RegisterClassEx(cls : TClass; _writer : TObjIO; latest : Integer; init : TInitializer);

    {** Assigns default io procedures for some of Delphi's classes. If this
    is not called, io procedures will have to be registered for all classes.
    IO procedures are registered for TStringList and TObjList.  TObjList is
    a list of objects, and is contained within this unit. }
		class procedure RegisterDefaultClasses;

    {** Reads a single object from a file, very conveniently.
    @param filename  The file to read the object from. }
    class function ReadObjectInFile(const fn : String; options : TObjStreamOptions) : TObject;

    {** Writes a single object to a file, conveniently.
    @param filename The file to write the object info.
    @param obj The object to write. The object must have its class registered. }
    class procedure WriteObjectToFile(const fn : String; options : TObjStreamOptions; obj : TObject);

    {** Construct an object stream.
    @param		stream		The stream to read or write objects to/from.
    @param		owned			If true, the target stream will be freed when the object stream
    										is freed.
  	@param 		options		Options from the TobjStreamOption type.}
    constructor Create(stream : TStream; owned : Boolean; options : TObjStreamOptions);

    {** Construct an object stream on a file.  The stream will be buffered
    internally.   You must also specify whether you intend to read or write
    from the stream.
    @param fn  				The file to use for streaming.
    @param options 		Options from the TObjStreamOption type.
    @param dir 				The IO direction (iodirRead, iodirWrite). }
    constructor CreateOnFile(const fn : String; options : TObjStreamOptions; dir : TObjIODirection);

    destructor Destroy; override;

    {** Use TransferItems to load and store atomic values.  Be careful with
     floating point -- it doesn't provide a way to do single and double, yet,
     because there's no way to distinguish those types.  If you want to do
     singles, doubles, or TDateTime, use the TransferItemsEx call instead,
     which lets you specify the types of your members.

     @param		items		An array of items to read or write.  The items should be
     									encased in square brackets:  [a,b,c].  This is Delphi's
                      open array syntax.
     @param		itemAddresses  Pointers to each of the variables passed in items,
     												also in open array format:  [@a, @b, @c].
     @param		direction		Either iodirRead or iodirWrite, depending on
     											whether objects are being read or written.
     @param		version		This will contain the version number of the object
     										read in. }
    procedure TransferItems(
    	items : array of const;
      itemAddresses : array of pointer;
      direction : TObjIODirection;
      var version : Integer); virtual;

    {** TransferVarRec does the io for a single TVarRec, where that TVarRec
    is the actual storage location for the value. }
		procedure TransferVarRec(var item : TVarRec; direction : TObjIODirection);

		{** TransferItem is used to read or write a single TVarRec-based object.
    This is very useful for writing the DeCAL classes, which store DObjects
    that are equivalent to TVarRec.
    @param item 		The item to transfer.
    @param itemAddress Where the item is.
    @param direction Whether to read or write.}
		procedure TransferItem(const item : TVarRec; itemAddress : Pointer; direction : TObjIODirection);

    {** TransferItemEx is used to read or write a single TVarRec-based object,
    supplying a specific type.
    @param item 		The item to transfer.
    @param itemAddress Where the item is.
    @param itemType The type of the variable (ssvt constant).
    @param direction Whether to read or write.}
		procedure TransferItemEx(const item : TVarRec; itemAddress : Pointer; itemType : Integer; direction : TObjIODirection);

    {** Transfer items to and from the stream, with type information. If you need to distinguish between different forms of floating point,
    use this routine instead.  itemTypes is an array of ssvt codes (see
    the top of this file) that correspond to the atomic data types.  You
    can use ssvtNone if you want the default mechanism to handle it.
    The best way to use this is to stream your singles and doubles first,
    then the rest of your items.  The list of itemtypes doesn't have to
    be the same length as the list of items to transfer -- ssvtNone will
    be assumed for the remaining items if the list is shorter. <P>

    The most common use of this routine is to transfer single or double
    floating point values, whose type is not handled accurately by the
    array of const system Delphi provides. <P>

     @param		items		An array of items to read or write.  The items should be
     									encased in square brackets:  [a,b,c].  This is Delphi's
                      open array syntax.

     @param		itemAddresses  Pointers to each of the variables passed in items,
     												also in open array format:  [@a, @b, @c].

     @param		itemTypes		The itemTypes open array exists so that atomic types
     											not handled by Delphi's open array system can be
                          used.  Each variable in the items parameter should
                          have, in itemTypes, a corresponding type indicator.
                          Note that this is usually only necessary of SINGLE
                          or DOUBLE values are going to be written.  <P>
                          Here are the possible values:
													<UL>
                          	<LI> ssvtNone   </LI>
                          	<LI> ssvtSingle   </LI>
                            <LI> ssvtDouble   </LI>
                            <LI> ssvtInteger   </LI>
                            <LI> ssvtBoolean   </LI>
                            <LI> ssvtChar   	</LI>
                            <LI> ssvtExtended   </LI>
                            <LI> ssvtString   </LI>
                            <LI> ssvtPointer   </LI>
                            <LI> ssvtPChar   </LI>
                            <LI> ssvtObject   </LI>
                            <LI> ssvtClass   </LI>
                            <LI> ssvtWideChar   </LI>
                            <LI> ssvtPWideChar   </LI>
                            <LI> ssvtAnsiString   </LI>
                            <LI> ssvtCurrency   </LI>
                            <LI> ssvtVariant   </LI>
                            <LI> ssvtInterface   </LI>
														<LI> ssvtWideString </LI>
														<LI> ssvtInt64 </LI>
													</UL>

     @param		direction		Either iodirRead or iodirWrite, depending on
     											whether objects are being read or written.

     @param		version		This will contain the version number of the object
     										read in. }

    procedure TransferItemsEx(
    	items : array of const;
      itemAddresses : array of pointer;
      itemTypes : array of Integer;
      direction : TObjIODirection;
      var version : Integer); virtual;

    {** Use TransferArrays to load and store multiple arrays of atomic values.
    @param 	firstItem		An open array of the first item of each array.
    @param	firstItemAddresses  An open array of the addresses of the first
    														item in each array.
    @param	counts		An open array containing a count for each array to be
    									written.
    @param	direction		iodirRead or iodirWrite, depending on whether read
												or write is desired.}
    procedure TransferArrays(
    	firstItem : array of const;
      firstItemAddresses : array of Pointer;
      counts : array of Integer;
      direction : TObjIODirection); virtual;

    {** Use TransferArrays to load and store multiple arrays of atomic values,
    		with additional type information.
    @param 	firstItem		An open array of the first item of each array.
    @param	firstItemAddresses  An open array of the addresses of the first
    														item in each array.
    @param	itemTypes	An open array of ssvt constants indicating the type
    									of each array.
    @param	counts		An open array containing a count for each array to be
    									written.
    @param	direction		iodirRead or iodirWrite, depending on whether read
    										or write is desired.}
    procedure TransferArraysEx(
    	firstItem : array of const;
      firstItemAddresses : array of Pointer;
      itemTypes : array of Integer;
      counts : array of Integer;
      direction : TObjIODirection); virtual;

    {** Use TransferBlocks to load and store blocks of memory in an object stream.
    	@param addresses An open array of pointers to the blocks.
      @param sizes An open array of the sizes of each block.
      @param direction	iodirRead or iodirWrite, depending on whether read
    										or write is desired.}
    procedure TransferBlocks(
    	addresses : array of pointer;
      sizes : array of integer;
      direction : TObjIODirection); virtual;

    {** Write an object to the stream.  The object's class must have been
    registered.  IO routines for subclasses will automatically be called.
    @param obj The object to write.}
    procedure WriteObject(obj : TObject); virtual;

    {** Read an object from the stream.  The object's class must have been
    registered.  IO routines for subclasses will automatically be called.}
    function ReadObject : TObject; virtual;

    {** Write an object to the stream using the given io procedure.
    @param obj The object to write.
    @param io The io procedure to use.
    @param version The version number that will be passed to the io procedure.
    @param callSuperClassIO Indicates whether the object's superclass io procedures
    												will be called after the specified io procedure is called. }
    procedure WriteObjectWith(obj : TObject; io : TObjIO; version : Integer); virtual;

    {** Read an object from the stream using the given io procedure.
    @param obj An already constructed empty object to read values into.
    @param io  The io procedure to use for this read or write only.
    @param version The version number to pass to the io procedure.
    @param callSuperClassIO If true, the object's superclass io procedure will be called
    												after the specified io procedure is called.}
    function ReadObjectWith(obj : TObject; io : TObjIO; var version : Integer) : TObject; virtual;

    {** Flush the list of objects written/read.  This is useful if you are
    resetting the stream to read it again. }
    procedure FlushObjectList; virtual;

  protected

  	class function GetRegistrationFor(cls : TClass) : TStreamRegistration;

		procedure DoHeaderTransfer; virtual;

    procedure ReadFixed(var buffer; count : LongInt);

  end;

  {** Stream registration objects keep information about each class that is
  streamable.  They store an IO procedure, class information, and version
  information. This is an internal class and should not be used by calling
  units.  *}
	TStreamRegistration = class

  	targetClass : TClass;
		io : TObjIO;
    latestVersion : Integer;
    init : TInitializer;

    constructor Create(tc : TClass; i : TObjIO; latest : Integer; _init : TInitializer);

  end;

  {** The buffered input stream adapter can accelerate the use of underlying
  streams.  Delphi's TFileStream performs no buffering, so its performance
  when reading and writing large numbers of small objects is not very good.
  Wrapping a TFileStream with a TBufferedStream results in much better
  performance. Note that you can only read from these streams.  Writing will
  throw an exception.  }
	TBufferedInputStream = class(TStreamAdapter)
  public

		constructor Create(targetStream : TStream; bufSize : Integer; Owned : Boolean);
		destructor Destroy; override;

		function Read(var Buffer; Count: Longint): Longint; override;
		function Write(const Buffer; Count: Longint): Longint; override;
		function Seek(Offset: Longint; Origin: Word): Longint; override;

	protected
		FStream : TStream;
		FWindow : TMemoryStream;
		FBufferSize : Integer;
		FWindowPosition : Integer;
		FOwned : Boolean;

		procedure SetSize(NewSize: Longint); override;

		procedure SetBufferSize(newSize : Integer); virtual;

  private
  	//procedure _SetSize(NewSize : LongInt);

  public
    property BufferSize : Integer read FBufferSize write SetBufferSize;
  end;

  {** The buffered output stream adapter can accelerate the use of underlying
  streams.   Note that you can only write sequentially to this stream; reading
  or seeking will throw an exception.  }
	TBufferedOutputStream = class(TStreamAdapter)
  public

		constructor Create(targetStream : TStream; bufSize : Integer; Owned : Boolean);
		destructor Destroy; override;

		function Read(var Buffer; Count: Longint): Longint; override;
		function Write(const Buffer; Count: Longint): Longint; override;
		function Seek(Offset: Longint; Origin: Word): Longint; override;

	protected
		FStream : TStream;
		FWindow : TMemoryStream;
		FBufferSize : Integer;
		FOwned : Boolean;

		procedure SetSize(NewSize: Longint); override;
		procedure SetBufferSize(newSize : Integer); virtual;

  private
  	//procedure _SetSize(NewSize : LongInt);
    procedure Flush;

  public
    property BufferSize : Integer read FBufferSize write SetBufferSize;
  end;

  {** TObjList is a subclass of TList that contains a list of objects.
  It provides an extra property, Objects, that gives access to the list. }
  TObjList = class(TList)
  protected
  	FOwns : Boolean;

  	function GetObject(idx : Integer) : TObject;
    procedure SetObject(idx : Integer; obj : Tobject);
  public

  	destructor Destroy; override;

    {** Clear the list, freeing all the objects. }
  	procedure FreeAll;

    {** Get at a list element, typecase to a TObject.   This property is also
    set up as the default property, so all you need to do is use objectList[x]
    to get at an object. }
  	property Objects[idx : Integer] : TObject read GetObject write SetObject; default;

		{** If the Owns property is true, the TObjList will free the objects it
		contains when it is destroyed. }
		property Owns : Boolean read FOwns write FOwns;

	end;

implementation

uses Windows;

const
	// How big should the buffered streams used by the TObjStream helpers be?
	FileBuffering = 4096;

var
	registry : TList = nil;
	defaultsRegistered : Boolean = false;

constructor TStreamRegistration.Create(tc : TClass; i : TObjIO; latest : Integer; _init : TInitializer);
begin
	targetClass := tc;
  io := i;
  latestVersion := latest;
  init := _init;
end;

class procedure TObjStream.RegisterClass(cls : TClass; _writer : TObjIO; latest : Integer);
begin
	RegisterClassEx(cls, _writer, latest, nil);
end;

class procedure TObjStream.RegisterClassEx(cls : TClass; _writer : TObjIO; latest : Integer; init : TInitializer);
begin
	if registry = nil then
  	registry := TList.Create;

  registry.Add(TStreamRegistration.Create(cls, _writer, latest, init));

end;

procedure IOStringList(obj : TObject; stream : TObjStream; direction : TObjIODirection; version : Integer; var callSuper : Boolean);
var len : Integer;
		s : String;
begin
	with obj as TStringList do
  	begin
    	case version of
      	1:begin
        		if direction = iodirWrite then
            	begin
              	s := Text;
                len := Length(s);
                stream.write(len, sizeof(len));
                if len > 0 then
                	stream.write(s[1], len);
              end
            else
            	begin
              	stream.read(len, sizeof(len));
                if len > 0 then
                	begin
                  	SetLength(s, len);
                    stream.read(s[1], len);
                  end
                else
                	s := '';
                Text := s;
              end;
          end;
      end;
    end;
end;

procedure IOObjList(obj : TObject; stream : TObjStream; direction : TObjIODirection; version : Integer; var callSuper : Boolean);
var len : Integer;
		ol : TObjList;
    i : Integer;
begin
	ol := obj as TObjList;
	case version of
  	1: 	begin
    			stream.transferItems([ol.FOwns], [@ol.fowns], direction, version);
          if direction = iodirWrite then
          	begin
            	len := ol.Count;
              stream.write(len, sizeof(len));
              if len > 0 then
              	begin
                	for i := 0 to len - 1 do
                  	begin
                    	stream.WriteObject(ol[i]);
                    end;
                end;
            end
          else
          	begin
            	// invoke constructor to set up default values
            	ol.Create;
            	stream.read(len, sizeof(len));
							if len > 0 then
              	begin
                	ol.Capacity := len;
                  for i := 0 to len - 1 do
                    ol.Add(stream.readObject);
                end;
     				end;
    		end;
  end;
end;

class procedure TObjStream.RegisterDefaultClasses;
begin
	if not defaultsRegistered then
		begin
			defaultsRegistered := true;
			RegisterClass(TStringList, IOStringList, 1);
			RegisterClass(TObjList, IOObjList, 1);
		end;
end;

class function TObjStream.GetRegistrationFor(cls : TClass) : TStreamRegistration;
var idx : Integer;
		reg : TStreamRegistration;
begin
	result := nil;
	for idx := 0 to registry.count - 1 do
  	begin
    	reg := TStreamRegistration(registry[idx]);
      if reg.targetClass = cls then
      	begin
	      	result := reg;
          break;
        end;
    end;
end;

procedure TObjStream.FlushObjectList;
begin
	FObjList.Clear;
end;

procedure TObjStream.WriteObjectWith(obj : TObject; io : TObjIO; version : Integer);
var cls : TClass;
		reg : TStreamRegistration;
    first : Boolean;
    nm : ShortString;
    callSuper : Boolean;
begin
	first := true;
	cls := obj.ClassType;
  repeat
  	if first then
    	begin
        // need to write out class identifier tag here.
        nm := ShortString(cls.ClassName());
        write(nm[0], 1);
        write(nm[1], Ord(nm[0]));

        callSuper := true;
        // invoke the passed-in io routine
        io(obj, self, ioDirWrite, version, callSuper);
      end
    else
    	begin
		    reg := GetRegistrationFor(cls);
        if reg <> nil then
          begin
            write(reg.latestVersion, sizeof(integer));

            callSuper := true;

            if assigned(reg.io) then
	            reg.io(obj, self, iodirWrite, reg.latestVersion, callSuper);
          end;
      end;

    first := false;

    // walk up class tree;
    cls := cls.ClassParent;

  until (not callSuper) or (cls = nil);
end;

function TObjStream.ReadObjectWith(obj : TObject; io : TObjIO; var version : Integer) : TObject;
var cls : TClass;
		reg : TStreamRegistration;
    callSuper : Boolean;
begin
	callSuper := true;
	io(obj, self, iodirRead, version, callSuper);
  if callSuper then
  	begin
    	cls := obj.ClassParent;
      while (cls <> nil) and (callSuper) do
      	begin
        	reg := GetRegistrationFor(cls);
          if reg <> nil then
          	begin
            	read(version, sizeof(version));

              if assigned(reg.io) then
	              reg.io(obj, self, iodirRead, version, callSuper);
            end;
          cls := cls.ClassParent;
        end;
    end;

	result := nil;
end;

procedure TObjStream.WriteObject(obj : TObject);
var cls : TClass;
		reg : TStreamRegistration;
    first : Boolean;
    nm : ShortString;
    position : Integer;
    max : Integer;
    zero : Char;
    callSuper : Boolean;
begin

	if obj = nil then
  	begin
    	if osoGraph in FOptions then
      	begin
          max := MaxInt;
          write(max, sizeof(max));
        end
      else
      	begin
        	zero := chr(0);
          write(zero, 1);
        end;
    	exit;
    end;

	if osoGraph in FOptions then
  	begin
    	// we may not be writing this object.
      position := FObjList.IndexOf(obj);
      write(position, sizeof(position));
      if position >= 0 then
      	exit // this object has already been written
      else
      	FObjList.Add(obj);
    end;

	first := true;
	cls := obj.ClassType;
  repeat
    reg := GetRegistrationFor(cls);
    if reg <> nil then
    	begin
      	if first then
        	begin
          	// need to write out class identifier tag here.
            nm := ShortString(cls.ClassName());
            write(nm[0], 1);
            write(nm[1], Ord(nm[0]));
          end;
        write(reg.latestVersion, sizeof(integer));
        callSuper := true;

        if assigned(reg.io) then
		      reg.io(obj, self, iodirWrite, reg.latestVersion, callSuper);
          
      end
    else if first then
    	raise TObjStreamException.Create(Format('Trying to write unregistered class (%s).', [obj.ClassName]));
    first := false;
    // walk up class tree;
    cls := cls.ClassParent;
  until (cls = nil) or (not callSuper);
end;

function TObjStream.ReadObject : TObject;
var nm : ShortString;
		i : Integer;
    reg : TStreamRegistration;
    version : Integer;
    cls : TClass;
    objid : Integer;
		found, callSuper : Boolean;
begin

	DoHeaderTransfer;

	if osoGraph in FOptions then
  	begin
			readFixed(objid, sizeof(Integer));

      // check for null pointer.
      if objid = MaxInt then
      	begin
        	result := nil;
          exit;
        end;

      if (objid >= 0) and (objid < FObjList.Count) then
      	begin
        	result := TObject(FObjList[objid]);
          exit;
        end;
    end;

	result := nil;
  readFixed(nm[0], 1);

  // check for null pointer case
  if nm[0] = chr(0) then
		exit;

	found := false;

	readFixed(nm[1], Ord(nm[0]));
	i := 0;
	while i < registry.Count do
		begin
			reg := TStreamRegistration(registry[i]);
			if reg.targetClass.ClassName = string(nm) then
				begin
					found := true;
					result := reg.targetClass.NewInstance;

					if osoGraph in FOptions then
						FObjList.Add(result);

					readFixed(version, sizeof(version));
					callSuper := true;

          if assigned(FObjCreation) then
          	FObjCreation(result, self, version);

          if assigned(reg.io) then
	          reg.io(result, self, iodirRead, version, callSuper);

          cls := reg.targetClass.ClassParent;
          while (cls <> nil) and (callSuper) do
          	begin
              reg := GetRegistrationFor(cls);
              if reg <> nil then
              	begin
                	readFixed(version, sizeof(version));

                  if assigned(reg.io) then
	                  reg.io(result, self, iodirRead, version, callSuper);
                end;
              cls := cls.ClassParent;
            end;

          break;
        end;
    	Inc(i);
		end;
	if not found then
		raise Exception.Create(Format('Cannot read - unregistered class (%s).', [nm]));
end;

procedure TObjStream.TransferBlocks(
  addresses : array of pointer;
  sizes : array of integer;
  direction : TObjIODirection);
var i : Integer;
begin
	DoHeaderTransfer;

	for i := Low(addresses) to High(addresses) do
  	begin
    	if direction = iodirWrite then
	      Write(PChar(addresses[i])^, sizes[i])
      else
      	ReadFixed(PChar(addresses[i])^, sizes[i]);
    end;
end;

// Use TransferArrays to load and store arrays of atomic values.
procedure TObjStream.TransferArrays(
  firstItem : array of const;
  firstItemAddresses : array of Pointer;
  counts : array of Integer;
  direction : TObjIODirection);
begin
	TransferArraysEx(firstItem, firstItemAddresses, [ssvtNone], counts, direction);
end;

procedure TObjStream.TransferArraysEx(
  firstItem : array of const;
  firstItemAddresses : array of Pointer;
  itemTypes : array of Integer; // optional!
  counts : array of Integer;
  direction : TObjIODirection);
type
	TAnsiStringArray = array[1..MaxInt div sizeof(String) - 1] of String;
  PAnsiStringArray = ^TAnsiStringArray;
  TStringArray = array[1..maxInt div sizeof(ShortString) - 1] of ShortString;
  PStringArray = ^TStringArray;
  PPChar = ^PChar;
  PObject = ^TObject;
var i : Integer;
		item : integer;
    ptr : PChar;
    pptr : PPChar;
    psa : PStringArray;
    pasa : PAnsiStringArray;
    len : Integer;
    objCount : Integer;
    itemType : Integer;
begin
	DoHeaderTransfer;

	for i := Low(firstItem) to High(firstItem) do
  	begin
      itemType := firstItem[i].VType;
      if (i <= High(itemTypes)) and (itemTypes[i] <> ssvtNone) then
        itemType := itemTypes[i];

    	if direction = iodirWrite then
      	begin

        	// write count
          write(counts[i], sizeof(Integer));

        	// write stuff
          ptr := PChar(firstItemAddresses[i]);

          case itemType of
            vtInteger:
              	write(ptr^, sizeof(Integer) * counts[i]);
						vtBoolean:
              	write(ptr^, sizeof(Boolean) * counts[i]);
            vtChar:
              	write(ptr^, sizeof(Char) * counts[i]);
            vtExtended:
              	write(ptr^, sizeof(Extended) * counts[i]);
            ssvtSingle:
            		write(ptr^, sizeof(Single) * counts[i]);
          	ssvtDouble:
            		write(ptr^, sizeof(Double) * counts[i]);
            vtString:
              begin
              	psa := PStringArray(ptr);
              	for item := 1 to counts[i] do
                	begin
		                write(psa^[item][0], sizeof(psa^[item][0]));
                    if Ord(psa^[item][0]) > 0 then
	    		            write(psa^[item][1], Ord(psa^[item][0]));
                  end;
              end;
            vtPointer:
              raise TObjStreamException.Create('Can''t stream raw pointers.');
            vtPChar:
            	begin
              	// We're going to assume this is a pointer to a null-terminated string.
                for item := 1 to counts[i] do
                	begin
		                len := StrLen(ptr);
    		            write(len, sizeof(len));
        		        write(ptr^, len);
                    ptr := ptr + sizeof(PChar);
                  end;
              end;
            vtObject:
            	begin
              	for item := 1 to counts[i] do
                	begin
										WriteObject(TObject(ptr));
                    ptr := ptr + sizeof(Pointer);
                  end;
              end;
            vtClass:
            	raise TObjStreamException.Create('Can''t write class objects.');
            vtWideChar:
              write(ptr^, sizeof(WideChar) * counts[i]);
            vtPWideChar:
              raise TObjStreamException.Create('Pointers to wide char not supported yet.');
            vtAnsiString:
              begin
              	pasa := PAnsiStringArray(ptr);
              	for item := 1 to counts[i] do
                	begin
                    len := Length(pasa^[item]);
                    write(len, sizeof(len));
                    if len > 0 then
	                    write(pasa^[item][1], len);
                  end;
              end;
            vtCurrency:
             	write(ptr^, sizeof(Currency) * counts[i]);
            vtVariant:
              raise TObjStreamException.Create('Variant not supported yet.');
            vtInterface:
              raise TObjStreamException.Create('Interface not supported yet.');
						vtWideString:
							begin
								raise TObjStreamException.Create('Wide string not supported yet.');
							end;
{$IFDEF DELPHI4}
						vtInt64:
							begin
								write(ptr^, sizeof(int64) * counts[i]);
							end;
{$ENDIF}

					end;

				end
			else
				begin
					// read stuff

					// read count
					readFixed(objCount, sizeof(Integer));

					if objCount <> counts[i] then
						raise TObjStreamException.Create('object count differs from expected.');

        	// read stuff
          ptr := PChar(firstItemAddresses[i]);

          case itemType of
            vtInteger:
              	readFixed(ptr^, sizeof(Integer) * counts[i]);
            vtBoolean:
              	readFixed(ptr^, sizeof(Boolean) * counts[i]);
            vtChar:
              	readFixed(ptr^, sizeof(Char) * counts[i]);
            vtExtended:
              	readFixed(ptr^, sizeof(Extended) * counts[i]);
          	ssvtSingle:
            		readFixed(ptr^, sizeof(Single) * counts[i]);
            ssvtDouble:
            		readFixed(ptr^, sizeof(Double) * counts[i]);
            vtString:
              begin
              	psa := PStringArray(ptr);
              	for item := 1 to counts[i] do
                	begin
		                readFixed(psa^[item][0], sizeof(psa^[item][0]));
                    if Ord(psa^[item][0]) > 0 then
	    		            readFixed(psa^[item][1], Ord(psa^[item][0]));
									end;
							end;
            vtPointer:
              raise TObjStreamException.Create('Can''t stream raw pointers.');
            vtPChar:
            	begin
              	// We're going to assume this is a pointer to a null-terminated string.
                for item := 1 to counts[i] do
                	begin
		                pptr := PPChar(ptr);
    		            readFixed(len, sizeof(len));
                    pptr^[0] := chr(len);
										readFixed(pptr^[1], len);
                    ptr := ptr + sizeof(ShortString);
                  end;
              end;
            vtObject:
            	begin
              	for item := 1 to counts[i] do
                	begin
		              	PObject(ptr)^ := ReadObject;
                    ptr := ptr + sizeof(Pointer);
                  end;
              end;
            vtClass:
            	raise TObjStreamException.Create('Can''t write class objects.');
            vtWideChar:
              readFixed(ptr^, sizeof(WideChar) * counts[i]);
            vtPWideChar:
              raise TObjStreamException.Create('Pointers to wide char not supported yet.');
            vtAnsiString:
              begin
              	pasa := PAnsiStringArray(ptr);
              	for item := 1 to counts[i] do
                	begin
                    readFixed(len, sizeof(len));
                    SetLength(pasa^[item], len);
                    UniqueString(pasa^[item]);
                    if len > 0 then
	                    readFixed(pasa^[item][1], len);
                  end;
              end;
            vtCurrency:
             	readFixed(ptr^, sizeof(Currency) * counts[i]);
            vtVariant:
              raise TObjStreamException.Create('Variant not supported yet.');
            vtInterface:
              raise TObjStreamException.Create('Interface not supported yet.');
						vtWideString:
							begin
								raise TObjStreamException.Create('Wide string not supported yet.');
							end;
{$IFDEF DELPHI4}
						vtInt64:
							begin
								readfixed(ptr^, sizeof(int64) * counts[i]);
							end;
{$ENDIF}

					end;

        end;

    end;
end;

procedure TObjStream.TransferItems(
  items : array of const;
  itemAddresses : array of pointer;
  direction : TObjIODirection;
  var version : Integer);
var
	i: integer;
begin
	DoHeaderTransfer;

  assert(High(itemAddresses) = High(items), 'The number of addresses must match the number of items');

	for i := Low(items) to High(items) do with items[i] do
		TransferItem(items[i], itemAddresses[i], direction);
end;

procedure TObjStream.TransferVarRec(var item : TVarRec; direction : TObjIODirection);
var _type : SmallInt;
begin

	if direction = iodirRead then
		begin

			item.vtype := 0;
			item.vinteger := 0;

			with item do
				begin

        	read(_type, Sizeof(_type));
					item.Vtype := _type;

					case _type of
						vtInteger:
								TransferItem(item, @VInteger, direction);
						vtBoolean:
								TransferItem(item, @VBoolean, direction);
						vtChar:
								TransferItem(item, @VChar, direction);
						vtExtended:
            	begin
                GetMem(VExtended, sizeof(extended));
                TransferItem(item, VExtended, direction);
              end;
						vtString:
							TransferItem(item, @VString, direction);
						vtPointer:
							raise TObjStreamException.Create('Can''t stream raw pointers.');
						vtPChar:
							TransferItem(item, @VPChar, direction);
						vtObject:
		        	TransferItem(item, @VObject, direction);
						vtClass:
							raise TObjStreamException.Create('Can''t write class objects.');
						vtWideChar:
							TransferItem(item, @VWideChar, direction);
						vtPWideChar:
							raise TObjStreamException.Create('Pointers to wide char not supported yet.');
						vtAnsiString:
             	TransferItem(item, @VAnsiString, direction);
						vtCurrency:
              begin
								GetMem(VCurrency, sizeof(currency));
								TransferItem(item, VCurrency, direction);
              end;
						vtVariant:
							raise TObjStreamException.Create('Variant not supported yet.');
						vtInterface:
							raise TObjStreamException.Create('Interface not supported yet.');
						vtWideString:
							begin
								TransferItem(item, @VWideString, direction);
							end;
						{$IFDEF DELPHI4}
						vtInt64:
							begin
								Getmem(VInt64, sizeof(int64));
								TransferItem(item, vint64, direction);
							end;
						{$ENDIF}
					end;
			end;
		end
  else
  	begin
    	_type := item.VType;
      write(_type, sizeof(_type));
			TransferItem(item, nil, direction);
    end;
end;

procedure TObjStream.TransferItem(const item : TVarRec; itemAddress : Pointer; direction : TObjIODirection);
begin
	TransferItemEx(item, itemAddress, item.VType, direction);
end;

procedure TObjStream.TransferItemEx(const item : TVarRec; itemAddress : Pointer; ItemType : Integer; direction : TObjIODirection);
type
	PShortString = ^ShortString;
  PString = ^String;
  PPChar = ^PChar;
  PObject = ^TObject;
  PCurrency = ^Currency;
  PInteger = ^Integer;
var len : Integer;
    ss : PShortString;
		pc : PPChar;
    po : PObject;
    ps : PString;
    ptr : PChar;
    pi : PInteger;
begin

	with item do
		if direction = iodirWrite then
	  	begin
				case itemType of
					vtInteger:
							write(VInteger, sizeof(VInteger));
					vtBoolean:
							write(VBoolean, sizeof(VBoolean));
					vtChar:
							write(VChar, sizeof(VChar));
					vtExtended:
							write(VExtended^, sizeof(VExtended^));
					ssvtSingle:
						begin
		        	ptr := PChar(itemAddress);
							write(ptr^, sizeof(Single));
						end;
					ssvtDouble:
						begin
		        	ptr := PChar(itemAddress);
							write(ptr^, sizeof(Double));
						end;
					vtString:
						begin
							write(VString^[0], sizeof(VString^[0]));
							if Length(VString^) > 0 then
								write(VString^[1], Ord(VString^[0]));
						end;
					vtPointer:
						raise TObjStreamException.Create('Can''t stream raw pointers.');
					vtPChar:
						begin
							// We're going to assume this is a pointer to a null-terminated string.
							len := StrLen(VPChar);
							write(len, sizeof(len));
							write(VPChar^, len);
						end;
					vtObject:
							WriteObject(VObject);
					vtClass:
						raise TObjStreamException.Create('Can''t write class objects.');
					vtWideChar:
						write(VWideChar, sizeof(VWideChar));
					vtPWideChar:
						raise TObjStreamException.Create('Pointers to wide char not supported yet.');
					vtAnsiString:
						begin
							if VAnsiString = nil then
								len := 0
							else
								len := Length(String(VAnsiString));
							write(len, sizeof(len));
							if len > 0 then
								write(String(VAnsiString)[1], len);
						end;
					vtCurrency:
						write(VCurrency, sizeof(VCurrency));
					vtVariant:
						raise TObjStreamException.Create('Variant not supported yet.');
					vtInterface:
						raise TObjStreamException.Create('Interface not supported yet.');
					vtWideString:
						begin
							len := Length(WideString(VWideString)) * 2;
							write(len, sizeof(len));
							if len > 0 then write(WideString(VWideString)[1], len);
						end;
{$IFDEF DELPHI4}
					vtInt64:
						write(VInt64, sizeof(int64));
{$ENDIF}

				end;
	    end
	  else
	   	begin
				case itemType of
					vtInteger:
							readFixed(PChar(itemAddress)^, sizeof(VInteger));
					vtBoolean:
							readFixed(PChar(itemAddress)^, sizeof(VBoolean));
					vtChar:
							readFixed(PChar(itemAddress)^, sizeof(VChar));
					vtExtended:
							readFixed(PChar(itemAddress)^, sizeof(VExtended^));
					ssvtSingle:
							readFixed(PChar(itemAddress)^, sizeof(Single));
					ssvtDouble:
							readFixed(PChar(itemAddress)^, sizeof(Double));
					vtString:
						begin
							ss := PShortString(itemAddress);
							readFixed(ss^[0], 1);
							readFixed(ss^[1], Ord(ss^[0]));
						end;
					vtPointer:
						raise TObjStreamException.Create('Can''t read in pointers.');
					vtPChar:
						begin
							// we'll allocate a pointer to a null terminated string.
							pc := PPChar(itemAddress);
							readFixed(len, sizeof(len));      // get length
							pc^ := StrAlloc(len + 1);    // allocate space
							readFixed(pc^^, len);             // read data
							(pc^ + len)^ := chr(0);      // add null terminator
						end;
					vtObject:
						begin
							po := PObject(itemAddress);
							po^ := readObject;
						end;
					vtClass:
						raise TObjStreamException.Create('Can''t read in class objects.');
					vtWideChar:
						readFixed(PWideChar(itemAddress)^, sizeof(WideChar));
					vtPWideChar:
						raise TObjStreamException.Create('Can''t read in pointers to wide char.');
					vtAnsiString:
						begin
							readFixed(len, sizeof(len));

							ps := PString(itemAddress);
              pi := PInteger(itemAddress);

              if len > 0 then
              	begin
                  UniqueString(ps^);
                  SetLength(ps^, len);
                  readFixed(ps^[1], len);
                end
              else
              	pi^ := 0;

						end;
					vtCurrency:
						readFixed(PCurrency(itemAddress)^, sizeof(Currency));
					vtVariant:
						raise TObjStreamException.Create('Can''t read in variants.');
					vtInterface:
						raise TObjStreamException.Create('Can''t read in interfaces.');
					vtWideString:
						raise TObjStreamException.Create('Can''t read in wide strings.');
					{$IFDEF DELPHI4}
					vtInt64:
						readFixed(PInt64(itemAddress)^, sizeof(int64));
					{$ENDIF}
				end;
			end;
end;

procedure TObjStream.TransferItemsEx(
	items : array of const;
	itemAddresses : array of pointer;
	itemTypes : array of Integer;
	direction : TObjIODirection;
	var version : Integer);
type
	PShortString = ^ShortString;
	PString = ^String;
	PPChar = ^PChar;
	PObject = ^TObject;
	PCurrency = ^Currency;
var i : Integer;
		itemType : Integer;
begin
	DoHeaderTransfer;

  assert(High(itemAddresses) = High(items), 'Number of addresses must match number of items');

	for i := Low(items) to High(items) do
		begin

			if (i <= High(itemTypes)) and (itemTypes[i] <> ssvtNone) then
				itemType := itemTypes[i]
      else
      	itemType := items[i].VType;

			TransferItemEx(items[i], itemAddresses[i], itemType, direction);

		end;
end;

constructor TObjStream.Create(stream : TStream; owned : Boolean; options : TObjStreamOptions);
begin
	inherited Create(stream, owned);
  FHeaderTransferred := false;
  FOptions := options;
  if osoGraph in options then
  	FObjList := TList.Create
  else
  	FObjList := nil;
end;

constructor TObjStream.CreateOnFile(const fn : String; options : TObjStreamOptions; dir : TObjIODirection);
var fs : TFileStream;
		bi : TBufferedInputStream;
    bo : TBufferedOutputStream;
begin
	if dir = iodirRead then
  	begin
    	fs := TFileStream.Create(fn, fmOpenRead);
      try
	      bi := TBufferedInputStream.Create(fs, FileBuffering, true);
	      Create(bi, true, options);
      except on e:Exception do
      	begin
        	fs.free;
          raise;
        end
      end;
    end
  else
  	begin
    	fs := TFileStream.Create(fn, fmCreate);
      try
	      bo := TBufferedOutputStream.Create(fs, FileBuffering, true);
	      Create(bo, true, options);
      except on e:Exception do
      	begin
        	fs.free;
          raise;
        end
      end;
    end;
end;

destructor TObjStream.destroy;
begin
	FObjList.Free;
	inherited;
end;

procedure TObjStream.DoHeaderTransfer;
begin
  if not FHeaderTransferred then
    begin
    end;
	FHeaderTransferred := true;
end;

procedure TObjStream.ReadFixed(var buffer; count : LongInt);
var bytes : LongInt;
begin
	bytes := Read(buffer, count);
  if bytes <> count then
  	raise TObjStreamException.Create('Fixed read failed -- incorrect number of bytes read.');
end;

class function TObjStream.ReadObjectInFile(const fn : String; options : TObjStreamOptions) : TObject;
var f : TFileStream;
		b : TBufferedInputStream;
		os : TObjStream;
begin
	f := TFileStream.Create(fn, fmOpenRead);
  try
  	b := TBufferedInputStream.Create(f, FileBuffering, false);
    try
      os := TObjStream.Create(b, false, options);
      try
        result := os.ReadObject;
      finally
        os.free;
      end;
    finally
    	b.free;
    end;
  finally
  	f.free;
  end;
end;

class procedure TObjStream.WriteObjectToFile(const fn : String; options : TObjStreamOptions; obj : TObject);
var f : TFileStream;
		b : TBufferedOutputStream;
		os : TObjStream;
begin
	f := TFileStream.Create(fn, fmCreate);
  try
  	b := TBufferedOutputStream.Create(f, FileBuffering, false);
    try
      os := TObjStream.Create(b, false, options);
      try
        os.WriteObject(obj);
      finally
        os.free;
      end;
    finally
    	b.free;
    end;
  finally
  	f.free;
  end;
end;

constructor TBufferedInputStream.Create(targetStream : TStream; bufSize : Integer; Owned : Boolean);
begin
	FStream := targetStream;
	FWindow := TMemoryStream.Create;
	FBufferSize := bufSize;
	FWindowPosition := 0;
	FOwned := Owned;
end;

destructor TBufferedInputStream.Destroy;
begin
	FWindow.Free;
	if FOwned then
		FStream.Free;
	inherited;
end;

function TBufferedInputStream.Read(var Buffer; Count: Longint): Longint;
var number, bytesRead : Integer;
    pos : PChar;
begin
	// default return is zero (to handle 0 byte requests)
	result := 0;

  pos := PChar(@buffer);
  while count > 0 do
  	begin
			number := count;
      if FWindow.Size - FWindow.Position < number then
      	number := FWindow.Size - FWindow.Position;
      if number > 0 then
      	begin
        	bytesRead := FWindow.Read(pos^, number);
          Inc(pos, bytesRead);
          Dec(count, bytesRead);
          Inc(result, bytesRead);
        end;
      if (count > 0) and (FWindow.Size - FWindow.Position = 0) then
      	begin
        	// Try to read more data into our buffer.
          FWindow.Clear;
          number := FBufferSize;
          if FStream.Size - FStream.Position < number then
          	number := FStream.Size - FStream.Position;
          if number > 0 then
          	begin
		          FWindow.CopyFrom(FStream, number);
  		        FWindow.Position := 0;
            end;

          // If we couldn't read any more data, we're done.
          if FWindow.Size = 0 then
          	break;
        end;
    end;

end;

function TBufferedInputStream.Write(const Buffer; Count: Longint): Longint;
begin
	raise Exception.Create('Can''t write to buffered input stream.');
end;

function TBufferedInputStream.Seek(Offset: Longint; Origin: Word): Longint;
begin
	case origin of
		soFromCurrent:
			begin
				result := FWindowPosition + FWindow.Position + offset;
				if offset <> 0 then
					begin
						result := FStream.Seek(result, origin);
					end;
			end;
		soFromBeginning:
			begin
				if (offset >= FWindowPosition) and (offset < (FWindowPosition + FWindow.Size)) then
					begin
						FWindow.Position := offset - FWindowPosition;
						result := offset;
					end
				else
					begin
						result := FStream.Seek(offset, origin);
					end;
			end;
		else
			begin
				result := FStream.Seek(offset, origin);
			end;
	end;
end;

procedure TBufferedInputStream.SetBufferSize(newSize : Integer);
begin
	if FBufferSize <> newSize then
  	begin
		  FBufferSize := newSize;
    end;
end;

procedure TBufferedInputStream.SetSize(NewSize: Longint);
begin
	raise Exception.Create('Can''t set size of buffered input stream.');
end;

{procedure TBufferedInputStream._SetSize(NewSize : LongInt);
begin
  SetSize(newSize);
end;}

constructor TBufferedOutputStream.Create(targetStream : TStream; bufSize : Integer; Owned : Boolean);
begin
	FStream := targetStream;
	FWindow := TMemoryStream.Create;
	FBufferSize := bufSize;
	FOwned := Owned;
end;

destructor TBufferedOutputStream.Destroy;
begin
	Flush;
	FWindow.Free;
	if FOwned then
		FStream.Free;
	inherited;
end;

function TBufferedOutputStream.Read(var Buffer; Count: Longint): Longint;
begin
	raise Exception.Create('Can''t read from buffered output stream.');
end;

function TBufferedOutputStream.Write(const Buffer; Count: Longint): Longint;
begin
	result := FWindow.Write(buffer, count);
  if FWindow.Size > FBufferSize then
  	Flush;
end;

procedure TBufferedOutputStream.Flush;
begin
	FStream.CopyFrom(FWindow, 0);
  FWindow.Clear;
end;

function TBufferedOutputStream.Seek(Offset: Longint; Origin: Word): Longint;
begin
	raise Exception.Create('Can''t seek on buffered output stream.');
end;

procedure TBufferedOutputStream.SetBufferSize(newSize : Integer);
begin
	if FBufferSize <> newSize then
  	begin
		  FBufferSize := newSize;
    end;
end;

procedure TBufferedOutputStream.SetSize(NewSize: Longint);
begin
	raise Exception.Create('Can''t set size of buffered output stream.');
end;

{procedure TBufferedOutputStream._SetSize(NewSize : LongInt);
begin
  SetSize(newSize);
end;}


constructor TStreamAdapter.Create(targetStream : TStream; owned : Boolean);
begin
	inherited Create;
  FStream := targetStream;
  FOwned := owned;
end;

destructor TStreamAdapter.Destroy;
begin
	if FOwned then
  	FStream.Free;
end;

function TStreamAdapter.Read(var Buffer; Count: Longint): Longint;
begin
	result := FStream.Read(buffer, count);
end;

function TStreamAdapter.Write(const Buffer; Count: Longint): Longint;
begin
	result := FStream.Write(buffer, count);
end;

function TStreamAdapter.Seek(Offset: Longint; Origin: Word): Longint;
begin
	result := FStream.Seek(offset, origin);
end;

procedure TStreamAdapter.SetSize(NewSize: Longint);
begin
	TStreamAdapter(FStream)._SetSize(NewSize);
end;

procedure TStreamAdapter._SetSize(NewSize : LongInt);
begin
	SetSize(NewSize);
end;

function TObjList.GetObject(idx : Integer) : TObject;
begin
	result := TObject(Items[idx]);
end;

procedure TObjList.SetObject(idx : Integer; obj : Tobject);
begin
	Items[idx] := obj;
end;

destructor TObjList.Destroy;
begin
	if FOwns then
  	FreeAll;
	inherited;
end;

procedure TObjList.FreeAll;
var i : Integer;
begin
	for i := 0 to count - 1 do
  	Objects[i].Free;
  Clear;
end;

var
	DelphiFound : Boolean = false;

procedure Init;
{$IFDEF TRIAL}
const
	msg = 'This program uses a trial version of SuperStream by Soletta, which cannot be distributed.  Halt.';
{$ENDIF}
{$IFDEF BETA}
const
	msg = 'This program uses a beta version of SuperStream by Soletta, which cannot be distributed.  Halt.';
  expiredMSG = 'The SuperStream version this program uses has expired.  Please check www.soletta.com for a new one.';
{$ENDIF}
begin
{$IFDEF TRIAL}

	DelphiFound := (FindWindow(nil, 'Delphi') <> 0) or (FindWindow(nil, 'Delphi 3') <> 0) or (FindWindow(nil, 'Delphi 4') <> 0);

	if not DelphiFound then
		begin
			if IsConsole then
				writeln(msg)
			else
				MessageBox(0, msg, 'Soletta - SuperStream', MB_APPLMODAL or MB_OK);
			Halt;
		end;

{$ENDIF}
{$IFDEF BETA}
	DelphiFound := (FindWindow(nil, 'Delphi') <> 0) or (FindWindow(nil, 'Delphi 3') <> 0) or (FindWindow(nil, 'Delphi 4') <> 0);
	if (now > encodeDate(1998, 8, 1)) then
  	begin
    	if IsConsole then
      	writeln(expiredMSG)
      else
	    	MessageBox(0, expiredMSG, 'Soletta - SuperStream Beta', MB_APPLMODAL or MB_OK);
    end;
	if (not DelphiFound) then
  	begin
    	if IsConsole then
				writeln(msg)
      else
	    	MessageBox(0, msg, 'Soletta - SuperStream Beta', MB_APPLMODAL or MB_OK);
      Halt;
    end;
{$ENDIF}

end;

procedure Term;
var i : Integer;
begin
	for i := 0 to registry.count - 1 do
  	TObject(registry[i]).Free;
  registry.free;
end;

initialization
	Init;
finalization
	Term;
end.
