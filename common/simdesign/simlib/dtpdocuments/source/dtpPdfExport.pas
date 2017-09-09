unit dtpPdfExport;

{$i simdesign.inc}

interface

uses
  Classes, sdStorage, dtpDocument, sdPdfDocument;

type

  // Export a page or complete DTP document to PDF format
  TdtpPdfExport = class(TComponent)
  private
    FPdf: TpdfDocument;
  public
    constructor Create(AOwner: TComponent); override;
    // Add a page to the PDF, from ADocument, using page number APageNumber. Note
    // that APageNumber starts at 0. To add all pages, simply use a construct like:
    // <code>
    // AExport := TdtpPdfExport.Create;
    // try
    //   for i := 0 to ADoc.PageCount - 1 do
    //     AExport.AddPage(ADoc, i);
    //   AExport.SaveToFile('mydoc.pdf');
    // finally
    //   AExport.Free;
    // end;
    // </code>
    procedure AddPage(ADocument: TdtpDocument; APageNumber: integer);
    // Save the resulting export to a PDF file with name AFileName. If AFileName
    // already exists, it will be overwritten. If AFileName cannot be created,
    // an exception is raised.
    procedure SaveToFile(const AFileName: string);
    // Save the resulting export as PDF to a stream S.
    procedure SaveToStream(S: TStream);
  end;

implementation

uses
  sdPdfObjects;

{ TdtpPdfExport }

procedure TdtpPdfExport.AddPage(ADocument: TdtpDocument;
  APageNumber: integer);
var
  APage: TPdfPage;
begin
  // Start by creating a new page in the PDF
  APage := TPdfPage(FPdf.ObjectAdd(TpdfDictionary));
  // Add to the page tree
  FPdf.PageTree.PageAdd(APage);
end;

constructor TdtpPdfExport.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  FPdf := TPdfDocument.Create(Self);
end;

procedure TdtpPdfExport.SaveToFile(const AFileName: string);
var
  S: TFileStream;
begin
  S := TFileStream.Create(AFileName, fmCreate);
  try
    SaveToStream(S);
  finally
    S.Free;
  end;
end;

procedure TdtpPdfExport.SaveToStream(S: TStream);
begin
  FPdf.SaveToStream(S);
end;

end.
