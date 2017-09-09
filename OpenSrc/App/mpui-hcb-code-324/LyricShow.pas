{*******************************************************}
{   单 元 名：ULyricShow.pas                            }
{                                                       }
{   作者：ying32                                        }
{   QQ：396506155                                       }
{   E-mail：yuanfen3287@vip.qq.com                      }
{   http://www.ying32.tk                                }
{   版权所有 (C) 2011-2012 ying32                       }
{*******************************************************}
unit LyricShow;

interface

uses
  Windows, Classes, ExtCtrls, Forms, GDILyrics;
type
  TLyricShowForm = class(TForm)
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
  private
    { Private declarations }
  public

  protected

  end;

var
  LyricShowForm: TLyricShowForm; GDILyric: TGDIDrawLyric;

implementation

uses core;

{$R *.dfm}

procedure TLyricShowForm.FormCreate(Sender: TObject);
begin
  ParentWindow := GetDesktopWindow;
  GDILyric := TGDIDrawLyric.Create(Handle);
  Width := CurMonitor.Width;
  Height := (CurMonitor.WorkareaRect.Bottom - CurMonitor.WorkareaRect.Top)*140 div 770;
  Left := CurMonitor.Left;
  Top := CurMonitor.Top + CurMonitor.WorkareaRect.Bottom
    - CurMonitor.WorkareaRect.Top - Height;
  GDILyric.SetWidthAndHeight(Width, Height);
  if dlod then Show else Hide;
end;

procedure TLyricShowForm.FormDestroy(Sender: TObject);
begin
  GDILyric.Free;
end;

end.

