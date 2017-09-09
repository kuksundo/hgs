unit uAccountsFormTests;

interface

uses
  TestFrameWork, uRCUtils, uAccounts, Classes;

type
  TTest_uAccountsForm = class(TTestCase)
  published
    procedure Test_AddRemoveReorderAccounts;
  private
    procedure CheckAccountList(Accounts : TAccounts; testName : String; accountNamesCommaText: string);
end;

{
Additional Recommended Manual Test Cases:

1. Start with no accounts
2. Add an account, edit, save
3. Delete the one account, back to no accounts
  3a. select no on the delete new account confirmation -> one account remains
  3b. repeat but select yes -> now no accounts, all fields disabled, applicable buttons disabled
4. Add several accounts, fill in random details on some.
  -> prompted to save changes when account any time add account pressed
  -> not prompted if account saved first
5. Click on a new account tab while editing. -> prompted to save
  5b. repeat with no unsaved edits, no prompt
6. click on a different screen tab (like mail) while editing -> prompted to save
  6b. repeat with no unsaved edits, no prompt.
7. Add new account, delete without saving, test each dialog option
8. Delete account from middle
9. Delete first account.
10. Reorder accounts
  -> verify account order "sticks"
  -> verify account order persists between shutting down the app
  -> verify rules are modified to continue to point to the correct higher numbered accounts
11. Delete account with rules
  -> rules changed to inactive, set to "all accounts"
  -> rules for higher number accounts shifted



}


implementation
uses SysUtils, Dialogs, System.UITypes;


procedure TTest_uAccountsForm.CheckAccountList(Accounts : TAccounts; testName : String; accountNamesCommaText: string);
var
  i : integer;
  accountNames: TStringList;
begin
  accountNames := TStringList.Create;
  try
    accountNames.CommaText := accountNamesCommaText;

    Status('-----Begin '+testName +' -----');
    Check(Accounts.Count = AccountNames.Count, testname + ': Accounts.Count Expected='+IntToStr(AccountNames.Count)+' Actual='+IntToStr(Accounts.Count));
    Status(testname + ': Accounts.Count Expected='+IntToStr(AccountNames.Count)+' Actual='+IntToStr(Accounts.Count));

    for i := 0 to accountNames.Count - 1 do begin
      Check(Accounts.Items[i].Name = accountNames[i], testname + ': Items['+IntToStr(i)+']='+Accounts.Items[i].Name);
      Status( testname + ': Items['+IntToStr(i)+']='+Accounts.Items[i].Name);
    end;
    for i := 0 to accountNames.Count - 1 do begin
      Check(Accounts.Items[i].AccountIndex = i,  testname + ': Items['+IntToStr(i)+'].AccountIndex: '+ IntToStr(Accounts.Items[i].AccountIndex));
      Status( testname + ': Items['+IntToStr(i)+'].AccountIndex: '+ IntToStr(Accounts.Items[i].AccountIndex));
    end;
    for i := 0 to accountNames.Count - 1 do begin
      Check(Accounts.Items[i].AccountNum = i + 1, testname + ': Items['+IntToStr(i)+'].AccountNum: '+ IntToStr(Accounts.Items[i].AccountNum));
      Status( testname + ': Items['+IntToStr(i)+'].AccountNum: '+ IntToStr(Accounts.Items[i].AccountNum));
    end;
    Status('');
  finally
    accountNames.Free;
  end;
end;

procedure TTest_uAccountsForm.Test_AddRemoveReorderAccounts;
var
  Accounts : TAccounts;
  account : TAccount;
  i : integer;
  accountNames : TStringList;
  testName : String;
begin
  Accounts := TAccounts.Create();

  account := Accounts.Add();
  account.name := 'a';

  Check(Accounts.Items[0].name = 'a', 'Add a item [0]: '+ Accounts.Items[0].name);

  account := Accounts.Add();
  account.name := 'b';

  Check(Accounts.Items[0].name = 'a', 'Add b item [0]: '+ Accounts.Items[0].name);
  Check(Accounts.Items[1].name = 'b', 'Add b item [1]: '+ Accounts.Items[1].name);

  //----------------------------------------------------------------------------

  account := Accounts.Add();
  account.name := 'c';

  account := Accounts.Add();
  account.name := 'd';

  account := Accounts.Add();
  account.name := 'e';

  account := Accounts.Add();
  account.name := 'f';

  CheckAccountList(Accounts, 'Add 6 Items', 'a,b,c,d,e,f');

  Accounts.Move(0,5);
  CheckAccountList(Accounts, 'Move(0,5)', 'b,c,d,e,f,a');

  Accounts.Move(2,3);
  CheckAccountList(Accounts, 'Move(2,3)', 'b,c,e,d,f,a');

  Accounts.Move(4,0);
  CheckAccountList(Accounts, 'Move(2,3)', 'f,b,c,e,d,a');

  Accounts.Move(3,1);
  CheckAccountList(Accounts, 'Move(2,3)', 'f,e,b,c,d,a');

  Accounts.Delete(3);
  CheckAccountList(Accounts, 'Delete(3)', 'f,e,b,d,a');

  Accounts.Delete(0);
  CheckAccountList(Accounts, 'Delete(0)', 'e,b,d,a');

  Accounts.Delete(3);
  CheckAccountList(Accounts, 'Delete(3)', 'e,b,d');

  Accounts.Delete(1);
  CheckAccountList(Accounts, 'Delete(1)', 'e,d');

  Accounts.Delete(0);
  CheckAccountList(Accounts, 'Delete(0)', 'd');

  Accounts.Delete(0);
  CheckAccountList(Accounts, 'Delete(0)', '');

  account := Accounts.Add();
  account.name := 'g';
  account := Accounts.Add();
  account.name := 'h';
  account := Accounts.Add();
  account.name := 'i';
  account := Accounts.Add();
  account.name := 'j';
  CheckAccountList(Accounts, 'add g,h,i,j', 'g,h,i,j');

  Accounts.Move(3,0);
  CheckAccountList(Accounts,'Move(3,0) x1','j,g,h,i');

  Accounts.Move(3,0);
  CheckAccountList(Accounts,'Move(3,0) x2','i,j,g,h');

  Accounts.Move(2,0);
  CheckAccountList(Accounts,'Move(2,0)','g,i,j,h');

  Accounts.Move(2,2);
  CheckAccountList(Accounts,'Move(2,2)','g,i,j,h');

  Accounts.Move(2,1);
  CheckAccountList(Accounts,'Move(2,2)','g,j,i,h');


  account := Accounts.Add();
  account.name := 'k';
  account := Accounts.Add();
  account.name := 'l';
  account := Accounts.Add();
  account.name := 'm';
  account := Accounts.Add();
  account.name := 'n';
  CheckAccountList(Accounts,'Add k,l,m,n','g,j,i,h,k,l,m,n');

  Accounts.Move(1,6);
  CheckAccountList(Accounts,'Move(1,6)','g,i,h,k,l,m,j,n');

  Accounts.Move(6,1);
  CheckAccountList(Accounts,'Move(1,6)','g,j,i,h,k,l,m,n');

  Accounts.Delete(7);
  CheckAccountList(Accounts,'Delete(7)','g,j,i,h,k,l,m');

  Accounts.Delete(5);
  CheckAccountList(Accounts,'Delete(5)','g,j,i,h,k,m');

  Accounts.Delete(3);
  CheckAccountList(Accounts,'Delete(3)','g,j,i,k,m');

  Accounts.Delete(1);
  CheckAccountList(Accounts,'Delete(1)','g,i,k,m');

  Accounts.Delete(0);
  CheckAccountList(Accounts,'Delete(0)','i,k,m');
end;


initialization
   TestFramework.RegisterTest(TTest_uAccountsForm.Suite);
end.
