{ unit Encrypt

  This unit provides an encryption algorithm for strings

  Project: ABC-View Manager

  Author: Nils Haeck M.Sc.
  Copyright (c) 2000 - 2005 by SimDesign B.V.

  It is NOT allowed to publish or copy this software without express permission
  of the author!

}
unit Encrypt;

interface

uses

  Dialogs, Classes, Sysutils;

// Encryption / Decryption of strings
function EncryptStr(S: string): string;
function DecryptStr(S: string): string;

// Random key
function MakeRandomKey: string;


implementation

const

  // Constants used for string encryption
  LowAcc = $28;
  HigAcc = $7E;
  OfsAcc =  12;
  ModAcc =$100;
  MulAcc =   2;

  // Constants used for stream encryption
  cEncryptSeed = $58;

//
// Encryption/Decryption
//
function EncryptStr(S: string): string;
var
  i,b: integer;
begin
  //Use simple +13, +15 etc right now
  Result:=S;
  for i:=1 to Length(Result) do
    if ord(Result[i]) in [LowAcc..HigAcc] then
    begin
      b:=Ord(Result[i])-LowAcc;
      b:=b+OfsAcc+(i mod ModAcc)*MulAcc; // Encrypt
      while b>(HigAcc-LowAcc) do b:=b-(HigAcc-LowAcc+1);
      Result[i]:=Chr(b+LowAcc);
    end else
end;

function DecryptStr(S: string): string;
var
  i,b: integer;
begin
  //Use simple -13, -15 etc right now
  Result:=S;
  for i:=1 to Length(Result) do
    if ord(Result[i]) in [LowAcc..HigAcc] then
    begin
      b:=Ord(Result[i])-LowAcc;            // Result in range LowAcc..HigAcc
      b:=b-OfsAcc-(i mod ModAcc)*MulAcc;   // Decrypt
      while b<0 do b:=b+(HigAcc-LowAcc+1); // result back in range $00-$5F
      Result[i]:=Chr(b+LowAcc);            // Result back in range $20-$7F
    end;
end;

function MakeRandomKey: string;
var
  i: integer;
begin
  Randomize;
  Result:='123456';
  for i:=1 to 6 do
    Result[i]:=chr(Random($72-$61)+$61); // in range [a..z]
end;

end.
