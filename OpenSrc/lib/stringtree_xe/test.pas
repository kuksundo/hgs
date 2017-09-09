
program test;

 uses cmem,system.classes,system.sysutils,stringtree,HashStringList,FastList;



var 
 StringTree1 : TStringTree;
i,j,k:integer;
str:string;
a:TFastList;
stringTreeError: TStringTreeError;



begin

 StringTree1 := TStringTree.Create;

for i:=0 to 10
do
begin
str:=inttostr(i);
stringTreeError:=stringtree1.CreateDir( str) ;
if stringTreeError <> strOK then
begin
writeln(StringTree1.ErrorToStr( stringTreeError));
halt;
end;

str:='';
end;
k:=0;
for i:=0 to 1000
do
for j:=0 to 10
do 
begin
k:=i;
str:=inttostr(k);

stringTreeError:=stringtree1.CreateFile(inttostr(j), 'am'+str) ;
if stringTreeError <> strOK then
begin
writeln(StringTree1.ErrorToStr( stringTreeError));
halt;
end;
stringTreeError:=stringtree1.CreateFile(inttostr(j), 'bm'+str) ;
if stringTreeError <> strOK then
begin
writeln(StringTree1.ErrorToStr( stringTreeError));
halt;
end;

str:='';
end;

stringTreeError:=stringtree1.deletefile('9','am1000');

writeln('Number of files in the directory 0 is: ', stringtree1.GetFileCount('0')); 
// if GetFileCount() fails, it will return -1
// if it succeeds, it will return the number of files

if stringTreeError <> strOK then
begin
writeln(StringTree1.ErrorToStr( stringTreeError));
halt;
end;

stringTreeError:=stringtree1.deletefiles('10');
if stringTreeError <> strOK then
begin
writeln(StringTree1.ErrorToStr( stringTreeError));
halt;
end;



{for i:=0 to 10000
do 
begin
str:=inttostr(i);
stringtree1.DeleteDir(str);
end;}

stringTreeError:=stringtree1.SaveToFile( 'Data10.ini');
if stringTreeError <> strOK then
begin
writeln(StringTree1.ErrorToStr( stringTreeError));
halt;
end;


stringtree1.clear;

stringTreeError:=stringtree1.loadfromfile('data10.ini');
if stringTreeError <> strOK then
begin
writeln(StringTree1.ErrorToStr( stringTreeError));
halt;
end;


a := TFastList.Create;

writeln;

for i:=0 to 10
do 
begin
write('Please press a key to list the directory number '+inttostr(i)+' : ') ;
readln;
 stringTreeError:=stringtree1.GetFileList(inttostr(i),a);
if stringTreeError <> strOK then
begin
writeln(StringTree1.ErrorToStr( stringTreeError));
halt;
end;

//writeln(a.count);
for j:=0 to a.count-1
do writeln(a[j]);
a.clear;
end;

a.free;

stringtree1.free;

end.
