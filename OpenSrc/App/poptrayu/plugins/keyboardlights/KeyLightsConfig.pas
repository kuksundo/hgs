unit KeyLightsConfig;
{-------------------------------------------------------------------------------
POPTRAYU KEYBOARD LIGHTS PLUGIN 2.0
Copyright (C) 2001-2005  Renier Crause
Copyright (C) 2012 Jessica Brown
All Rights Reserved.

This is free software.

Permission to use, copy, modify, and distribute this software and
its documentation for any purpose, without fee, and without written
agreement is hereby granted, provided that the above copyright
notice appear in all copies of this software.

This program is distributed in the hope that it will be useful,
but WITHOUT ANY WARRANTY; without even the implied warranty of
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.
-------------------------------------------------------------------------------}

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, Buttons;

type
  TKeyboardLightsMode = (ScrollKeyBlinking = 1, ScrollKeySolid = 2);

type
  TKeyLightsConfigForm = class(TForm)
    radioFlash: TRadioButton;
    radioSolid: TRadioButton;
    Label1: TLabel;
    BtnSave: TBitBtn;
    btnCancel: TBitBtn;
    procedure BtnSaveClick(Sender: TObject);
    procedure btnCancelClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
    procedure Init(lightsMode : TKeyboardLightsMode);
  end;

var
  KeyLightsConfigForm: TKeyLightsConfigForm;

implementation

{$R *.dfm}

procedure TKeyLightsConfigForm.BtnSaveClick(Sender: TObject);
begin
  ModalResult := mrOk;
end;

procedure TKeyLightsConfigForm.btnCancelClick(Sender: TObject);
begin
  ModalResult := mrCancel;
end;

procedure TKeyLightsConfigForm.Init(lightsMode : TKeyboardLightsMode);
begin
  if lightsMode = ScrollKeyBlinking then
    radioFlash.Checked := true
  else if lightsMode = ScrollKeySolid then
    radioSolid.Checked := true;
end;


end.
