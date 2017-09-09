unit uWebBrowserTamed;

{ Modifies TWebBrowser to disable scripts, videos, sounds, images }


interface
uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes,
  Vcl.Graphics, Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.ExtCtrls, Vcl.OleCtrls
  , SHDocVw
  , Vcl.StdCtrls
  , MSHTML
  ;

type
  TWebBrowserTamed = class(TWebBrowser, IDispatch {+ others from ancestor })
  //--------------------------------------
    { IDispatch }
    function Invoke(DispID: Integer; const IID: TGUID; LocaleID: Integer;
      Flags: Word; var Params; VarResult, ExcepInfo, ArgErr: Pointer): HResult; stdcall;
    public
      ImagesOn : boolean;
  end;



implementation
uses
    Mshtmdid
  , Winapi.ActiveX;


{ TWebBrowserTamed }

  const
    AmbientControlFlagsNoImages : integer =
      // Items we want to block (these flags should be disabled)
      //DLCTL_DLIMAGES +
      //DLCTL_VIDEOS +
      //DLCTL_BGSOUNDS +

      // These flags enhance security by blocking undesirable content
      DLCTL_NO_SCRIPTS +
      DLCTL_NO_JAVA +
      DLCTL_NO_FRAMEDOWNLOAD +
      DLCTL_NO_DLACTIVEXCTLS +
      DLCTL_NO_RUNACTIVEXCTLS +
      DLCTL_NO_BEHAVIORS +

      // These flags prevent external content references from loading
      DLCTL_PRAGMA_NO_CACHE +
      DLCTL_FORCEOFFLINE +
      DLCTL_NO_CLIENTPULL +

      // This flag prevents dialog boxes (good for "html previewers")
      DLCTL_SILENT +
      0 ;

    AmbientControlFlagsWithImages : integer =
      // Allow Images & Videos (but not background sounds)
      DLCTL_DLIMAGES +
      DLCTL_VIDEOS +
      //DLCTL_BGSOUNDS +

      // Security options: (no javascript, active x, java, frames, etc)
      DLCTL_NO_SCRIPTS +
      DLCTL_NO_JAVA +
      DLCTL_NO_FRAMEDOWNLOAD +
      DLCTL_NO_DLACTIVEXCTLS +
      DLCTL_NO_RUNACTIVEXCTLS +
      DLCTL_NO_BEHAVIORS +

      // This flag prevents dialog boxes (good for "html previewers")
      DLCTL_SILENT +
      0 ;



function TWebBrowserTamed.Invoke(DispID: Integer; const IID: TGUID;
  LocaleID: Integer; Flags: Word; var Params; VarResult, ExcepInfo,
  ArgErr: Pointer): HResult;
var
  AmbientControlFlags: Integer;
begin
  Result := inherited Invoke(DispID, IID, LocaleID, Flags, Params, VarResult, ExcepInfo, ArgErr);
  if (Flags and DISPATCH_PROPERTYGET <> 0) and (VarResult <> nil) then
  begin
    Result := S_OK;
    case DispID of
      DISPID_AMBIENT_DLCONTROL:
      begin
        if ImagesOn then
          AmbientControlFlags := AmbientControlFlagsWithImages
        else
          AmbientControlFlags := AmbientControlFlagsNoImages;

        PVariant(VarResult)^ := AmbientControlFlags;
        Result := S_OK;
        PVariant(VarResult)^ := AmbientControlFlags;
      end;
      DISPID_AMBIENT_USERMODE:
        PVariant(VarResult)^ := WordBool(True);
    else
      Result := DISP_E_MEMBERNOTFOUND;
    end;
  end;
end;
end.
