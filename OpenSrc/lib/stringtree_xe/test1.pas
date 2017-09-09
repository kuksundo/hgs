
program test;

 uses 
cmem,
{$IFDEF Unix}cthreads,{$ENDIF}
system.classes,system.sysutils,stringtree,HashStringList,FastList;



var 
 StringTree1 : TStringTree;
i,j,k:integer;
str:string;
a:TFastList;
stringTreeError: TStringTreeError;



begin

 StringTree1 := TStringTree.Create;
stringTreeError:=stringtree1.CreateDir( 'amine') ;
if stringTreeError <> strOK then
begin
writeln(StringTree1.ErrorToStr( stringTreeError));
halt;
end;

stringTreeError:=stringtree1.CreateDir( 'amine\amine1\amine4') ;
if stringTreeError <> strOK then
begin
writeln(StringTree1.ErrorToStr( stringTreeError));
halt;
end;

stringTreeError:=stringtree1.CreateDir( 'amine\amine1\amine5') ;
if stringTreeError <> strOK then
begin
writeln(StringTree1.ErrorToStr( stringTreeError));
halt;
end;


stringTreeError:=stringtree1.CreateDir( 'amine\amine2') ;
if stringTreeError <> strOK then
begin
writeln(StringTree1.ErrorToStr( stringTreeError));
halt;
end;

stringTreeError:=stringtree1.CreateDir( 'amine\amine3') ;
if stringTreeError <> strOK then
begin
writeln(StringTree1.ErrorToStr( stringTreeError));
halt;
end;

a := TFastList.Create;

writeln;
stringtree1.DeleteDir('amine\amine1');
 stringTreeError:=stringtree1.GetDirTree('amine',a);
if stringTreeError <> strOK then
begin
writeln(StringTree1.ErrorToStr( stringTreeError));
halt;
end;

//writeln(a.count);
for j:=0 to a.count-1
do writeln(a[j]);
a.clear;

a.free;

stringtree1.free;

end.
