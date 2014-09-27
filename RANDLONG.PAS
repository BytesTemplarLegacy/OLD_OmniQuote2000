{$Q-}
uses hsd;
var b:longint;

function RandomLongInt(range:longint):longint;
var a,b,
    c:longint;
begin
  repeat
     a:=random($FFFF);
     b:=random($FFFF);
     c:=a+(b shl 15);
  until c <range;
end;

begin
     randomize;
     repeat
     b:=randomlongint(200);
     writeln(longint(b));
     until port[$60]=1;
end.