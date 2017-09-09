{-----------------------------------------------------------------------------
 Unit Name: EmailU
 Author: Tristan Marlow
 Purpose: Send email messages

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
unit KeywordEmailU;

interface

uses
  
  Windows, Messages, SysUtils, Variants, Classes,
  IdBaseComponent, IdTCPConnection, 
  IdSMTP, IdMessage, IdAttachmentFile;

type
  TEmailKeywordItem = class(TCollectionItem)
  private
    FKeyword : String;
    FValue : String;
  published
    property Keyword : String read FKeyword write FKeyword;
    property Value : String read FValue write FValue;
end;

type
  TOnGetKeywords = procedure(ASender : TObject) of object;

type
  TKeywordEmail = class(TCollection)
  private
    FIdSMTP : TIdSMTP;
    FIdMessage : TIdMessage;
    FEnabled : Boolean;
    FRecipients : String;
    FSenderAddress : String;
    FSenderName : String;
    FSubject : String;
    FBody : TStrings;
    FAttachments : TStrings;
    FSMTPHostname : String;
    FSMTPPort : Integer;
    FSMTPAuthentication : Boolean;
    FSMTPSecure : Boolean;
    FSMTPUserName : String;
    FSMTPPassword : String;
    FOnGetKeywords : TOnGetKeywords;
  protected
    procedure SetBody(Value: TStrings);
    function GetKeyword(Index : Integer) : TEmailKeywordItem;
  public
    constructor Create; reintroduce;
    destructor Destroy; override;
    procedure Assign(Source : TPersistent); override;
    function Send : Boolean;
    function Add : TEmailKeywordItem;
    property Keywords[Index: Integer]: TEmailKeywordItem read GetKeyword;
  published
    property Enabled : Boolean read FEnabled write FEnabled;
    property Recipients : String read FRecipients write FRecipients;
    property SenderAddress : String read FSenderAddress write FSenderAddress;
    property SenderName : String read FSenderName write FSenderName;
    property Subject : String read FSubject write FSubject;
    property Body : TStrings read FBody write FBody;
    property Attachments : TStrings read FAttachments write FAttachments;
    property SMTPHostname : String read FSMTPHostname write FSMTPHostname;
    property SMTPPort : Integer read FSMTPPort write FSMTPPort;
    property SMTPAuthentication : Boolean read FSMTPAuthentication write FSMTPAuthentication;
    property SMTPSecure : Boolean read FSMTPSecure write FSMTPSecure;
    property SMTPUserName : String read FSMTPUserName write FSMTPUserName;
    property SMTPPassword : String read FSMTPPassword write FSMTPPassword;
    property OnGetKeywords : TOnGetKeywords read FOnGetKeywords write FOnGetKeywords;
end;

implementation

constructor TKeywordEmail.Create;
begin
  FIdSMTP := TIdSMTP.Create(nil);
  FIdMessage := TIdMessage.Create(nil);
  FBody := TStringList.Create;
  FAttachments := TStringList.Create;
  FSMTPPort := 25;
  FSMTPHostname := 'mail.x.y.z';
  inherited Create(TEmailKeywordItem);
end;

destructor TKeywordEmail.Destroy;
begin
  FreeAndNil(FAttachments);
  FreeAndNil(FBody);
  FreeAndNil(FIdMessage);
  FreeAndNil(FidSMTP);
  inherited Destroy;
end;

function TKeywordEmail.Add: TEmailKeywordItem;
begin
  Result := Inherited Add as TEmailKeywordItem;
end;

function TKeywordEmail.GetKeyword(Index : Integer) : TEmailKeywordItem;
begin
    Result := Inherited Items[Index] as TEmailKeywordItem;
end;

procedure TKeywordEmail.SetBody(Value : TStrings);
begin
  FBody.Assign(Value);
end;

procedure TKeywordEmail.Assign(Source : TPersistent);
var
  I : Integer;
begin
  if (Source is TKeywordEmail) then
    begin
      FRecipients := (Source as TKeywordEmail).Recipients;
      FSenderAddress := (Source as TKeywordEmail).SenderAddress;
      FSenderName := (Source as TKeywordEmail).SenderName;
      FEnabled := (Source as TKeywordEmail).Enabled;
      FSubject := (Source as TKeywordEmail).Subject;
      FBody.Assign((Source as TKeywordEmail).Body);
      FAttachments.Assign((Source as TKeywordEmail).Attachments);
      FSMTPHostname := (Source as TKeywordEmail).SMTPHostname;
      FSMTPPort := (Source as TKeywordEmail).SMTPPort;
      BeginUpdate;
      try
        Clear;
         for I := 0 to Pred(TKeywordEmail(Source).Count) do
          begin
            with Add do
              begin
                FKeyword := (TKeywordEmail(Source).Items[i] as TEmailKeywordItem).Keyword;
                FValue := (TKeywordEmail(Source).Items[i] as TEmailKeywordItem).Value;
              end;
          end;
      finally
        EndUpdate;
      end;
    end;
  //inherited Assign(Source);
end;

function TKeywordEmail.Send : Boolean;
var
  Idx : Integer;
begin
  if Assigned(FOnGetKeywords) then
    begin
      FOnGetKeywords(Self);
    end;
  with FIdMessage do
    begin
      From.Address := FSenderAddress;
      Recipients.EMailAddresses := FRecipients;
      Body.Assign(FBody);
      From.Name := FSenderName;
      Subject := FSubject;
      Attachments.Text := FAttachments.Text;
      For Idx := 0 to Pred(Self.Count) do
        begin
          Subject := StringReplace(Subject,Keywords[Idx].Keyword,Keywords[Idx].Value,[rfReplaceAll,rfIgnoreCase]);
          From.Name := StringReplace(From.Name,Keywords[Idx].Keyword,Keywords[Idx].Value,[rfReplaceAll,rfIgnoreCase]);
          Body.Text := StringReplace(Body.Text,Keywords[Idx].Keyword,Keywords[Idx].Value,[rfReplaceAll,rfIgnoreCase]);
          Attachments.Text := StringReplace(Attachments.Text,Keywords[Idx].Keyword,Keywords[Idx].Value,[rfReplaceAll,rfIgnoreCase]);
        end;
    end;
  FIdSMTP.Host := FSMTPHostName;
  FIdSMTP.Port := FSMTPPort;
  if FSMTPAuthentication then
    begin
      FIdSMTP.AuthType :=satDefault ;
      if FSMTPSecure then
        begin
          FIdSMTP.AuthType := satSASL;
        end;
    end else
    begin
      FIdSMTP.AuthType := satNone;
    end;
  FIdSMTP.Username := FSMTPUserName;
  FIdSMTP.Password := FSMTPPassword;
  For Idx := 0 to Pred(Self.Attachments.Count) do
    begin
      TIdAttachmentFile.Create(FIdMessage.MessageParts,Self.Attachments[Idx]);
    end;
  try
    FidSmTP.Connect;
  except
  end;
  if FIdSMTP.Connected then
    begin
      FIdSMTP.Send(FIdMessage);
      FIdSMTP.Disconnect;
      Result := True;
    end else
    begin
      Result := False;
    end;
end;

end.
