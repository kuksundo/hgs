unit rcUtilsTester;

interface

uses
  TestFrameWork, uRCUtils;

type
 TTest_RCUtils = class(TTestCase)
 published
   procedure Test_SanitizeFileName;
   procedure Test_EncryptDecrypt_password;
   procedure Test_EncryptDecrypt_alpha;
   procedure Test_EncryptDecrypt_yoyo;
   procedure Test_EncryptDecrypt_greek;
   procedure Test_EncryptDecrypt_hebrew;
 end;



implementation
uses SysUtils;


procedure TTest_RCUtils.Test_SanitizeFileName;
var
  subject,expected,actual : string;
begin
  subject := 'Earth: The Final Frontier?' ;
  expected := 'Earth  The Final Frontier ';
  actual := SanitizeFileName(subject);
  Check(actual = expected, actual);

  subject := '"***SPAM***"' ;
  expected := '    SPAM    ';
  actual := SanitizeFileName(subject);
  Check(actual = expected, actual);

  subject := 'this is a valid subject.' ;
  expected := 'this is a valid subject.';
  actual := SanitizeFileName(subject);
  Check(actual = expected, actual);

  subject := 'left/right, front\back' ;
  expected := 'left right, front back';
  actual := SanitizeFileName(subject);
  Check(actual = expected, actual);

  subject := 'hi: who''s it gonna be? | not me! that''s who!' ;
  expected := 'hi  who''s it gonna be    not me! that''s who!';
  actual := SanitizeFileName(subject);
  Check(actual = expected, actual);
end;

procedure TTest_RCUtils.Test_EncryptDecrypt_password();
var
  password : string;
  encodedpw : string;
  decodedpw : string;
begin
  password := 'password';
  encodedpw := Encrypt(password);
  Check(encodedpw = '<NbhRO4qX6PE=>', 'Testing encoding "password": ' + encodedpw);
  decodedpw := Decrypt(encodedpw);
  Check(decodedpw = password, 'Testing decrypting "password": ' + decodedpw);
end;

procedure TTest_RCUtils.Test_EncryptDecrypt_alpha();
var
  password : string;
  encodedpw : string;
  decodedpw : string;
begin
  password := 'abcd1234!';
  encodedpw := Encrypt(password);
  Check(encodedpw = '<JBGoNXbKDpy7>','Testing encoding "abcd1234!": ' + encodedpw);
  decodedpw := Decrypt(encodedpw);
  Check(decodedpw = password, 'Testing decrypting "abcd1234!": ' + decodedpw);
end;

procedure TTest_RCUtils.Test_EncryptDecrypt_yoyo();
var
  password : string;
  encodedpw : string;
  decodedpw : string;
begin
  password := 'ÿóýõ'; // upper ANSI passes the old password algorithm
  encodedpw := Encrypt(password);
  Check(encodedpw = '<uvWS+w==>', 'Testing encoding "ÿóýõ": ' + encodedpw);
  decodedpw := Decrypt(encodedpw);
  Check(decodedpw = password, 'Testing decrypting "ÿóýõ": ' + decodedpw);
end;

procedure TTest_RCUtils.Test_EncryptDecrypt_greek();
var
  password : string;
  encodedpw : string;
  decodedpw : string;
begin
  password := 'στην αρχή';  // greek fails the old password algorithm
  encodedpw := Encrypt(password);
  Check(encodedpw = '>zobPk8yczZ7Cvs6Qz4XNoM6s<', 'Testing encoding "στην αρχή": ' + encodedpw);
  decodedpw := Decrypt(encodedpw);
  Check(decodedpw = password, 'Testing decrypting "στην αρχή": ' + decodedpw);
end;

procedure TTest_RCUtils.Test_EncryptDecrypt_hebrew();
var
  password : string;
  encodedpw : string;
  decodedpw : string;
begin
  password := 'בהתחלה';  // hebrew fails the old password algorithm
  encodedpw := Encrypt(password);
  Check(encodedpw = '>1pTUkNWX1I7UkdaQ<', 'Testing encoding hebrew: ' + encodedpw);
  decodedpw := Decrypt(encodedpw);
  Check(decodedpw = password, 'Testing decrypting hebrew: ' + encodedpw + ' ' + decodedpw);

end;

initialization
   TestFramework.RegisterTest(TTest_RCUtils.Suite);
end.
