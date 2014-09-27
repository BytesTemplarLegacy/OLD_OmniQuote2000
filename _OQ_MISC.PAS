Unit OQ_MISC;

Interface
Uses HSD, STRINGS, CRTASM, GFX, CRT;
{ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ}
Function Picker(s:string):String;
{ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ}
Const
     Ansi        =1;
     Ren         =2;
Type
    tShit        =array[0..1024] of Char;
Var
   ColorMode           :Byte;
   {ÚÍÍÍÍÍÍOPTIONSÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÄÄÄ}
   RenMode,
{   TagLine,}
   eLogo,
   HighASCII,
   ShowDate,
   ShowTime,
   ShowSig,
   ShowTagline,
   ANSIEnable,
   ASCIISig,
   sigFile,
   comport,
   tagpicker,
   tagfile     :string;

{ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ}
Procedure Bin;
Function  ANSIColor(i,col:word):string;
Function  AnsiBG(col:word):string;
Procedure ParseTagline(var foo:tShit);
Function  Col(var foo:String):String;
{ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ}
Implementation

Procedure Bin; External; {$L BIN.OBJ}

Function Picker(s:string):String;
Const
     Quit:Boolean=False;
Type
    tBuf        =array[-6..200] of string;
    tStr80      =String[80];
var
    f    :text;
    ch   :char;
    ss   :String[80];
    l    :longint;
    buf  :^tBuf;
    mx,x :integer;
    offs :integer;
Begin
  picker:='';
  if not exist(s) then begin picker:='FILE NOT FOUND! (This is NOT a tagline, but an ERROR!)'; exit; end;
  new(buf); CursorOff;
  assign(f, s);  reset(f);
  move(@Bin^, mem[$B800:0], 4000);                 {Draw Backdrop}
  l:=lines(s);                                     {Calculate Number of Lines}
  offs:=-6;                                         {Set buffer offset to 0}
  if l<200 then mx:=l else mx:=200;                {Create 200 line maximum}
  mx:=l;
  fillchar(buf^, sizeof(buf^), #0);                {Clean out all of buf^}
  for x:=1 to mx do readln(f, buf^[x]);            {Read In Taglines}
  textcolor(08);                                   {CurrentColor dGrey}
  repeat
   vSinc;                                          {Removes nasty flicker}
   ClrScr;                                         {ClearScr}
   move(@Bin^, mem[$B800:0], 4000);                {DrawBackdrop}
   for x:=5 to 17 do                               {Screen Y 5..17}
                 if not ((x-(offs+1))> mx) then begin {If we dont' go past end of taglines then write tagline}
                                               GotoXY(1,1); WriteLn('ofs:',offs,'³x:',x,'³mx:',mx);
                                               GotoXY(1,x);
                                               ss:=buf^[(x-4)+offs]; {Fits >255 tagline into [80] string}
                                               if x=5+6 then         {5 is really where 1st tagline goes, so 6 into it}
                                                  begin              {HIGHLIGHTING FOR MIDDLE LINE}
                                                    textcolor(White); textbackground(red); clreol;
                                                    WriteLn(ss);
                                                    textcolor(08); textbackground(0);
                                                  end
                                                    else WriteLn(ss);  {Else write it in the normal colors}
                                             end;
    repeat until keypressed; ch:=readkey;    {Wait for keypress and read it into ch}
    case ch of
         #0         :case readkey of
                              #72:if offs>-6 then dec(offs);           {UP}
                              #80:if offs<mx-7 then inc(offs);        {DN}
                              #73:if offs-12<-6 then offs:=-6
                                                else dec(offs,12);     {PGUp}
                              #81:if offs+12>(mx-7) then offs:=(mx-7)
                                                     else inc(offs,12);{PGDn}
                              #71:offs:=-6;                            {HOME}
                              #79:offs:=mx-7;                         {END}
                     end;
         #13        :begin quit:=true; picker:=buf^[offs+7]; end;     {Pick 7th tagline after offset (For middle)}
         #27        :quit:=true;                                      {Quits}
         end;
  until quit;
  ClrScr;                                                             {ClrScreen}
  close(f);                                                           {CLOSE THAT FILE! IT'S COLD IN HERE!!}
  dispose(buf);                                                       {Bye bye BUF^}
End;
{ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ}
Function ANSIColor(i,col:word):string;
Var
   foo:string;
   bs :string;
begin
 foo:='';
 if (ANSIEnable='1') then
                begin
                  str(i,bs);
                   foo:=#27+'['+bs;
                  str(col, bs);
                   foo:=foo+';3'+bs+'m';
                end;
 ansicolor:=foo;
end;
{ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ}
Function AnsiBG(col:word):string;
Var
   foo:string;
   bs :string;
begin
 foo:='';
 if (ANSIEnable='1')  then
                begin
                   foo:=#27+'[';
                     str(col, bs);
                   foo:=foo+'4'+bs+'m';
                end;
 AnsiBG:=foo;
end;
{ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ}
Procedure ParseTagline(var foo:tShit);
Var
   buf   :string;
   x     :word;
   code1 :string;
   s     :string;
Label Poop;
Begin
     buf:='';
     x  :=1;
     if ColorMode=0 then
        begin
          while x<(StrLen(foo)+1) do
           begin
             if s[x]='|' then inc(x,3);
             buf:=buf+s[x]; inc(x);
           end;
          goto poop;
        End;
     while x<(StrLen(Foo)+1) do
                  if (not (s[x]='|'))
                             then begin
                                    if (s[x]='^') and (s[x+1]='M') then
                                       begin
                                          buf:=buf+^M;
                                          inc(x,2);
                                       end else
                                    begin
                                      buf:=buf+s[x];
                                      inc(x);
                                    end;
                                   end
                        else
                           begin
                            code1:='';
                            inc(x);
                            if s[x]='|' then begin
                                               buf:=buf+'|';
                                               inc(x);
                                               goto poop;
                                             end;
                            code1:=s[x];
                            inc(x);
                            code1:=code1+s[x];
                            inc(x);
                           Case ColorMode of
                  ANSI    :Begin
                             if code1='00' then buf:=buf+AnsiColor(0,0);
                             if code1='01' then buf:=buf+AnsiColor(0,4);
                             if code1='02' then buf:=buf+AnsiColor(0,2);
                             if code1='03' then buf:=buf+AnsiColor(0,6);
                             if code1='04' then buf:=buf+AnsiColor(0,1);
                             if code1='05' then buf:=buf+AnsiColor(0,5);
                             if code1='06' then buf:=buf+AnsiColor(0,3);

                             if code1='07' then buf:=buf+AnsiColor(0,7);
                             if code1='08' then buf:=buf+AnsiColor(1,0);

                             if code1='09' then buf:=buf+AnsiColor(1,4);
                             if code1='10' then buf:=buf+AnsiColor(1,2);
                             if code1='11' then buf:=buf+AnsiColor(1,10);
                             if code1='12' then buf:=buf+AnsiColor(1,4);
                             if code1='13' then buf:=buf+AnsiColor(1,1);
                             if code1='14' then buf:=buf+AnsiColor(1,3);
                             if code1='15' then buf:=buf+AnsiColor(1,7);
                           End;
                  Ren:     buf:=buf+'|'+code1;
                 End;
 poop:
    end;
    s:=buf;
    StrPCopy(Foo,s);
{   Foo:=s;}
End;
{ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ}
Function Col(var foo:String):String;
Var
   buf   :string;
   x     :word;
   code1 :string;
   s     :string;
Label Poop;
Begin
     buf:='';
     x  :=1;
     if ColorMode=0 then
        begin
          while x<(length(foo)+1) do
           begin
             if s[x]='|' then inc(x,3);
             buf:=buf+s[x]; inc(x);
           end;
          goto poop;
        End;
     while x<(Length(Foo)+1) do
                  if (not (s[x]='|'))
                             then begin
                                    if (s[x]='^') and (s[x+1]='M') then
                                       begin
                                          buf:=buf+^M;
                                          inc(x,2);
                                       end else
                                    begin
                                      buf:=buf+s[x];
                                      inc(x);
                                    end;
                                   end
                        else
                           begin
                            code1:='';
                            inc(x);
                            if s[x]='|' then begin
                                               buf:=buf+'|';
                                               inc(x);
                                               goto poop;
                                             end;
                            code1:=s[x];
                            inc(x);
                            code1:=code1+s[x];
                            inc(x);
                           Case ColorMode of
                  ANSI    :Begin
                             if code1='00' then buf:=buf+AnsiColor(0,0);
                             if code1='01' then buf:=buf+AnsiColor(0,4);
                             if code1='02' then buf:=buf+AnsiColor(0,2);
                             if code1='03' then buf:=buf+AnsiColor(0,6);
                             if code1='04' then buf:=buf+AnsiColor(0,1);
                             if code1='05' then buf:=buf+AnsiColor(0,5);
                             if code1='06' then buf:=buf+AnsiColor(0,3);

                             if code1='07' then buf:=buf+AnsiColor(0,7);
                             if code1='08' then buf:=buf+AnsiColor(1,0);

                             if code1='09' then buf:=buf+AnsiColor(1,4);
                             if code1='10' then buf:=buf+AnsiColor(1,2);
                             if code1='11' then buf:=buf+AnsiColor(1,10);
                             if code1='12' then buf:=buf+AnsiColor(1,4);
                             if code1='13' then buf:=buf+AnsiColor(1,1);
                             if code1='14' then buf:=buf+AnsiColor(1,3);
                             if code1='15' then buf:=buf+AnsiColor(1,7);
                           End;
                  Ren:     buf:=buf+'|'+code1;
                 End;
 poop:
    end;
    col:=buf;
{    StrPCopy(Foo,s);}
{    Col:=Foo;}
End;

End.