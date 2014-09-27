Uses CRTASM, UTILS;
{ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ}
Function FindLine(fn:string; find:string; casesen:boolean):Longint;
var f:text;
    x:LongInt;
    s:string;
    found:boolean;
Begin
     x:=0; found:=false;
     assign(f, fn);
     reset(f);
     case casesen of
          True :Repeat
                    ReadLn(f, s);
                    Inc(x);
                    if (pos(find, s)>0) then found:=true;
                Until found or eof(f);
          False:Repeat
                   ReadLn(f, s);
                   Inc(x);
                   if (pos(upper(find), upper(s))>0) then found:=true;
                Until found or eof(f);
          End;
     if not found then begin x:=0; exit; end;
     Close(f);
     FindLine:=X;
End;
{ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ}
Function RandomList(fn:string; _begin,_end:string; delimiter:string):String;
Var f            :text;
    s            :string;
    c,
    startoflist,
    numberofitems,
    endoflist    :longint;
Begin
  Assign(f, fn);
  Reset(f);
    StartOfList  :=FindLine(fn, _begin, false)+1;
    EndOfList    :=FindLine(fn, _end,   false)-1;
    NumberOfItems:=EndOfList-StartOfList;
    If NumberOfItems=-1 then begin randomlist:='NO ITEMS'; exit; end;
    RandomList   :=ReadLine(fn, random(NumberOfItems+1)+StartOfList);
  Close(f);
End;
{ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ}
{ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ}
Begin
     Randomize;
     WriteLn(RandomList('TEMP.DOC','[START]','[END]',''));
End.