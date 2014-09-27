Uses HSD, CRTASM, GFX, CRT;
Procedure Bin; External; {$L BIN.OBJ}
{ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ}
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
  offs:=0;                                         {Set buffer offset to 0}
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
                 if not ((x-offs)> mx) then begin {If we dont' go past end of taglines then write tagline}
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
                              #80:if offs<mx-11 then inc(offs);        {DN}
                              #73:if offs-12<-6 then offs:=-6
                                                else dec(offs,12);     {PGUp}
                              #81:if offs+12>(mx-11) then offs:=(mx-11)
                                                     else inc(offs,12);{PGDn}
                              #71:offs:=-6;                            {HOME}
                              #79:offs:=mx-11;                         {END}
                     end;
         #13        :begin quit:=true; picker:=buf^[offs+7]; end;     {Pick 7th tagline after offset (For middle)}
         #27        :quit:=true;                                      {Quits}
         end;
  until quit;
  ClrScr;                                                             {ClrScreen}
  close(f);                                                           {CLOSE THAT FILE! IT'S COLD IN HERE!!}
  dispose(buf);                                                       {Bye bye BUF^}
End;

Begin
{     writeln(Picker('C:\TERM\OMNI\TAGLINES.TAG'));
{      writeln(picker('C:\dev\oq\30\taglines.tag'));}
      writeln(picker('taglines.old'));
End.