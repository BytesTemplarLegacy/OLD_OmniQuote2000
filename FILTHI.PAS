
Function HiAsciiFilter(s:string):String;
Const
     Connectors:string='Ú¿ÀÙÃ´ÅÉ»¼ÈÌ¹ÎÆµÕ¸Ô¾ØÖ·Ó½Ç¶×';
     hLines    :string='ÄÍÜß¯®©ª÷';
     vLines    :string='³ºôõïâ³Şİ';
     Blocks    :string='Û²±°şğùú';
var x:byte;
    z:string;
Begin
    z:=s;
    for x:=1 to length(s) do
        begin
         if pos(z[x],connectors)>0  then z[x]:='+';
         if pos(z[x],hLines)>0      then z[x]:='-';
         if pos(z[x],vLines)>0      then z[x]:='|';
         if pos(z[x],Blocks)>0      then z[x]:='x';
         if (z[x]<#32) or (z[x]>#127) then z[x]:='.';
        end;
    hiasciifilter:=z;
End;
Begin
        writeln(HiAsciiFilter('ÉÍÍÍÍÍÍÍÍÍÍ»'));
        writeln(HiAsciiFilter('ÓÄÄÄÄÄÄÄÄÄÄ½'));
End.