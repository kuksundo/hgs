unit bmpcache;
//mm 031099-1

interface
uses SysUtils,Windows,Classes,Graphics,globals,bildklassen;

type
	TBmpCache=class(TPersistent)
		// richtet ein bitmap-cache im windows-temp-verzeichnis ein
	private
		FCache:TStrings;
		procedure Convert(const Bild:TBildobjekt; const Bitmap: TBitmap);
		function CreateCachedFileName(const Bild:TBildobjekt): string;
		function BitmapInCache(const Bild:TBildobjekt; var cachefile:string):boolean;
		procedure ClearCache;
	public
		constructor Create;
		destructor Destroy; override;

		function ConvertToBitmap(Bild:TBildobjekt; bitmapfile:string):boolean;
		 // wandelt bild in bitmapfile um.
		 // das file wird gecachet oder aus dem cache gelesen (falls vorhanden)
	end;

var
	GlobalBmpCache:TBmpCache;

implementation

{ TBmpCache }

constructor TBmpCache.Create;
begin
	inherited;
	FCache:=TStringList.Create;
end;

destructor TBmpCache.Destroy;
begin
	ClearCache;
	FCache.Free;
	inherited;
end;

function TBmpCache.ConvertToBitmap;
var
	tempFile:string;
	Bitmap:TBitmap;
begin
	if (Bild.MediaType.Grafikformat in [gf_Bitmap,gf_Icon,gf_Metafile,gf_JPEG,gf_GIF])
		and not BitmapInCache(Bild,tempfile) then begin
			SetLength(tempfile,0);
			Bitmap:=TBitmap.Create;
			try
				Convert(Bild,Bitmap);
				tempfile:=CreateCachedFileName(Bild);
				if Length(tempfile)>0 then Bitmap.SaveToFile(tempfile);
			finally
				Bitmap.Free;
			end;
		end;
	result:=(Length(tempFile)>0)
		and CopyFile(pChar(tempfile),pChar(bitmapfile),false);
end;

procedure TBmpCache.Convert;
var
	flaeche:tRect;
	groesse:tPoint;
begin
	try
		Bild.AusgabeCanvas:=Bitmap.Canvas;
		SystemParametersInfo(spi_GetWorkArea,0,@flaeche,0);
		groesse:=Bild.BildGroesse(flaeche);
		Bitmap.Width:=groesse.x;
		Bitmap.Height:=groesse.y;
		Bild.BildZeichnen(Bitmap.Canvas.ClipRect);
	finally
		Bild.AusgabeCanvas:=nil;
	end;
end;

function TBmpCache.CreateCachedFileName;
var
	tempDir:string;
	l:cardinal;
	sdrive:string;
	drive:byte;
begin
	SetLength(tempDir,max_Path);
	l:=GetTempPath(Length(tempDir),pChar(tempDir));
	if (l>0) and (l<=max_Path) then begin
		SetLength(tempDir,l);
		SetLength(result,max_Path);
		l:=GetTempFileName(pChar(tempDir),'bmp',0,pChar(result));
		if l>0 then	begin
			SetLength(result,StrLen(pChar(result)));
			sdrive:=LowerCase(ExtractFileDrive(result));
			drive:=Ord(sdrive[1]);
			if (drive>=Ord('a')) and (drive<=Ord('z')) then
				while (DiskFree(drive-Ord('a')+1)<10000000) and (FCache.count>0) do begin
					SysUtils.DeleteFile(FCache.Values[FCache.Names[0]]);
					FCache.Delete(0);
				end;
			FCache.Add(Bild.Pfad+'='+result);
		end	else SetLength(result,0);
	end else SetLength(result,0);
end;

function TBmpCache.BitmapInCache;
begin
	cachefile:=FCache.Values[Bild.Pfad];
	result:=Length(cachefile)>0;
	if result then with FCache do
		Move(IndexOfName(Bild.Pfad),count-1);
end;

procedure TBmpCache.ClearCache;
var
	idx:integer;
begin
	with FCache do begin
		if count>0 then
			for idx:=0 to count-1 do
				SysUtils.DeleteFile(Values[Names[idx]]);
		Clear;
	end;
end;

initialization
	GlobalBmpCache:=TBmpCache.Create;
finalization
	GlobalBmpCache.Free;
	GlobalBmpCache:=nil;
end.
