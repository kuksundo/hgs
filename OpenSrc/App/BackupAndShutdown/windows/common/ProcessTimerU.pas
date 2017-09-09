{-----------------------------------------------------------------------------
 Unit Name: ProcessTimerU
 Author: Tristan Marlow
 Purpose: Calculated Elapsed and Estimated time of an activity.

 ----------------------------------------------------------------------------
 License
 This program is free software; you can redistribute it and/or modify
 it under the terms of the GNU Library General Public License as
 published by the Free Software Foundation; either version 2 of
 the License, or (at your option) any later version.

 This program is distributed in the hope that it will be useful,
 but WITHOUT ANY WARRANTY; without even the implied warranty of
 MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 GNU Library General Public License for more details.
 ----------------------------------------------------------------------------

 History: 04/05/2007 - First Release.

-----------------------------------------------------------------------------}
unit ProcessTimerU;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  ExtCtrls;

type
  TProcessTimer =  class(TObject)
  private
     // Private declarations
     FStartTime: TDateTime;
     FTotal: LongWord;
     FCurrent: LongWord;
     FRunning: Boolean;
     FEstTime : TDateTime;
     FElapsedTime: TDateTime;
  protected
    function GetElapsedTime : TDateTime;
    function GetEstimatedTime : TDateTime;
  public
    // Public declarations
     constructor Create;
     procedure Start(ATotalAmount: LongWord);
     procedure Stop;
     procedure UpdateProgress(ACurrent: LongWord);
     property Running: Boolean read FRunning;
     property EstimatedTime : TDateTime read GetEstimatedTime;
     property ElapsedTime : TDateTime read GetElapsedTime;
     property Total : LongWord read FTotal;
     property Current : LongWord read FCurrent;
  end;


implementation



function TProcessTimer.GetElapsedTime : TDateTime;
begin
  if FRunning then
    begin
      FElapsedTime:= Now - FStartTime;
    end else
    begin
      FElapsedTime := 0;
    end;
  Result := FElapsedTime;
end;

function TProcessTimer.GetEstimatedTime : TDateTime;
begin
  if (FCurrent<>0) and (FRunning) then
    begin
      FEstTime := ((GetElapsedTime / FCurrent) * FTotal) - GetElapsedTime;
    end else
    begin
      FEstTime := 0;
    end;
  Result := FEstTime;
{    if (FCurrent<>0) and (FRunning) then
    begin
      FEstTime := ((GetElapsedTime / FCurrent) * FTotal);
    end else
    begin
      FEstTime := 0;
    end;
  Result := FEstTime;}
end;


procedure TProcessTimer.UpdateProgress(ACurrent: LongWord);
begin
  FCurrent := ACurrent;
end;

procedure TProcessTimer.Stop;
begin
  FTotal := 0;
  FCurrent := 0;
  FStartTime := Now;
  FEstTime := 0;
  FElapsedTime := 0;
  FRunning := False;
end;

procedure TProcessTimer.Start(ATotalAmount: LongWord);
begin
  FTotal := ATotalAmount;
  FCurrent := 0;
  FStartTime := Now;
  FEstTime := 0;
  FElapsedTime := 0;
  FRunning := True;
end;

constructor TProcessTimer.Create;
begin
  inherited Create;
  FTotal := 0;
  FCurrent := 0;
  FStartTime := Now;
  FEstTime := 0;
  FElapsedTime := 0;
  FRunning := False;
end;


end.
