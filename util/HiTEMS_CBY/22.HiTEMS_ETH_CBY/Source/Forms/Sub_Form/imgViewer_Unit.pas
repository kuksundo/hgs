{********************************************************************}
{ TMS TAdvSmoothImageListBox Demo                                    }
{                                                                    }
{ written by TMS Software                                            }
{            copyright ?2012                                        }
{            Email : info@tmssoftware.com                            }
{            Website : http://www.tmssoftware.com                    }
{********************************************************************}

unit imgViewer_Unit;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  AdvSmoothImageListBox, AdvStyleIF, StdCtrls, FileCtrl, ShellAPI, ComCtrls,
  GDIPPictureContainer, AdvSmoothTileList, AdvSmoothTileListImageVisualizer,
  AdvSmoothTileListHTMLVisualizer;

type
  TimgViewer_Frm = class(TForm)
    TileList: TAdvSmoothTileList;
    GDIPPictureContainer1: TGDIPPictureContainer;
    AdvSmoothTileListHTMLVisualizer1: TAdvSmoothTileListHTMLVisualizer;
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure TileListPageChanged(Sender: TObject; PageIndex: Integer);
  private
    { Private declarations }
  public
    { Public declarations }
    folder: string;
  end;

var
  imgViewer_Frm: TimgViewer_Frm;
  procedure Create_Image_Browser(aImgContainer:TGDIPPictureContainer; aIdx:Integer);

implementation

{$R *.dfm}

procedure Create_Image_Browser(aImgContainer:TGDIPPictureContainer; aIdx:Integer);
var
  li : integer;
begin
  with TimgViewer_Frm.Create(Application) do
  begin
    GDIPPictureContainer1 := aImgContainer;

    if GDIPPictureContainer1.Items.Count > 0 then
    begin
      with TileList.Tiles do
      begin
        BeginUpdate;
        try
          for li := 0 to GDIPPictureContainer1.Items.Count-1 do
          begin
            Add;
//            Items[Count-1].Content.Image.Assign(GDIPPictureContainer1.Items[li].Picture);
          end;


          Items[aIdx].Content.Image.Assign(GDIPPictureContainer1.Items[aIdx].Picture);
          TileList.PageIndex := aIdx;
          ShowModal;
        finally
          EndUpdate;
        end;
      end;
    end;
  end;
end;
procedure TimgViewer_Frm.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  Action := caFree;
end;

procedure TimgViewer_Frm.TileListPageChanged(Sender: TObject;
  PageIndex: Integer);
var
  li : integer;
begin
  with TileList.Tiles do
  begin
    BeginUpdate;
    try
      for li := 0 to Count-1 do
        Items[li].Content.Image.Assign(nil);

      Items[PageIndex].Content.Image.Assign(GDIPPictureContainer1.Items[PageIndex].Picture);
    finally
      EndUpdate;
    end;
  end;
end;

end.
