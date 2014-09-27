{G+,A+,X+}
Program OmniQuote2000;
Uses HSD, DOS, CRTASM, UTILS, CRT, INI, OQ_MISC;
Const
     DOW              :Array[0..6] of string[3]=
                               ('Sun','Mon','Tue','Wed','Thu','Fri','Sat');
     DefBanner    ='OmniQuote2k';
     DefTime      ='Time:';
     DefDate      ='Date:';
     SeperatorDefault ='-';
{컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴}
Procedure ReadConfig(s:string);
Var x        :byte;
    allblank :boolean;
Begin
 ConfigFilename:=S;
 AllBlank:=True;
 if not exist(s) then err(errConfigNotFound,s,'');
 with cfg do
      begin
         getINIToggle(s,'PipesEnabled',    RenPipes);
         getINIToggle(s,'ShowBanner',      ShowBanner);
         getINIToggle(s,'ANSI',            ANSI);
         getINIToggle(s,'TaglinePicker',   Picker);
         getINIToggle(s,'ShowTagline',     ShowTagline);
         getINIToggle(s,'ShowSig',         ShowSig);
         getINIToggle(s,'ShowTime',        ShowTime);
         getINIToggle(s,'ShowDate',        ShowDate);
         getINIToggle(s,'ForceLowASCII',   ForceLowASCII);
         getINIToggle(s,'RandomSignature', RandomSig);
         GetINIString(s,'SendTo','CON',    cfg.ComPort);
         GetINIString(s,'Seperator','|08-',cfg.Seperator);
         if cfg.Comport='CON' then CON:=True;
         if showtagline then begin
                               GetINIString(s,'TaglinePath','',TaglineFile);
                               if taglinefile='' then err(errNoTagFileName,'','');
                               if not exist(taglinefile) then err(errTaglineFileNotFound, taglinefile,'');
                             end;
         if showsig and (not randomsig) then begin
                               GetINIString(s,'SignaturePath','',SignatureFile);
                               if signaturefile='' then err(errNoSigFileName,'','');
                               if not exist(signaturefile) then err(errSigFileNotFound,signaturefile,'');
                         end;
         if randomsig then begin
                             GetINIString(s,'SignaturePath','',SignatureFile);
                             For x:=0 to 9 do
                              begin
                                GetINIString(s,'SIG'+b2dec(x),'',randsig[x]);
                                if randsig[x]<>'' then
                                        begin
                                          allblank:=false;
                                          if not exist(randsig[x]) then err(errNoFindRandSigFile,randsig[x],'SIG'+b2dec(x));
                                        end;
                                end;

                             if allblank then err(errAllBlankRandom,'','');
                           end;
         For x:=0 to 9 do
                     begin
                       GetINIString(s,'BANNER'+b2dec(x),'',oqbanners[x]);
                       if oqbanners[x]='' then
                                   begin
                                     maxbanners:=x;
                                     break;
                                   end;
                     end;
        For x:=0 to 9 do
                    begin
                         GetINIString(s,'TIME'+b2dec(x),'',rTime[x]);
                         if length(rTime[x])=0 then
                                   begin
                                     MaxRTime:=x;
                                     break;
                                   end;
                         inc(maxrtime);
                    end;

         For x:=0 to 9 do
                    begin
                         GetINIString(s,'DATE'+b2dec(x),'',rDate[x]);
                         if rDate[x]='' then
                                   begin
                                     MaxRDate:=x;
                                     break;
                                   end;
                         inc(MaxRDate);
                    end;
      end; {WITH}
     if cfg.oqbanners[0]='' then begin cfg.oqbanners[0]:=DefBanner; maxbanners:=0; end;
     if cfg.rDate[0]    ='' then begin cfg.rDate[0]    :=DefTime;   maxrtime  :=0; end;
     if cfg.rTime[0]    ='' then begin cfg.rTime[0]    :=DefTime;   maxrdate  :=0; end;

End; {READ CONFIG}
{컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴}
{컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴}
Procedure DisplaySignature;
var f  :file;
    p  :pointer;
    fs :longint;
    x  :word;
Begin
   assign(f, cfg.SignatureFile);
   reset(f,1);
   fs:=filesize(f);
   if fs>65534 then err(errSigTooBig,cfg.SignatureFile,'');
   getmem(p, fs);
   BlockRead(f, p^, fs);
   close(f);
   x:=0;
   while x<fs do
       if (mem[seg(p^):ofs(p^)+x]=byte(#$D)) and (mem[seg(p^):ofs(p^)+x+1]=byte(#$A))
                   then begin
                           linefeed;
                           inc(x,2);
                        end else begin
                                  output(chr(mem[seg(p^):ofs(p^)+x]));
                                  inc(x);
                                 end;
   freemem(p, fs);
   LineFeed;
End;
{컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴}
Procedure RandomSignature;    {Pick that random siggy!}
var f  :file;
    p  :pointer;
    fs :longint;
    x  :word;
Begin
   repeat x:=random(9); until cfg.randsig[x]<>'';
   assign(f, cfg.randsig[x]);
   reset(f,1);
   fs:=filesize(f);
   if fs>65534 then err(errSigTooBig,cfg.SignatureFile,'');
   getmem(p, fs);
   BlockRead(f, p^, fs);
   close(f);
   x:=0;
   while x<fs do
       if (mem[seg(p^):ofs(p^)+x]=byte(#$D)) and (mem[seg(p^):ofs(p^)+x+1]=byte(#$A))
                   then begin
                           linefeed;
                           inc(x,2);
                        end else begin
                                  output(chr(mem[seg(p^):ofs(p^)+x]));
                                  inc(x);
                                 end;
   freemem(p, fs);
   LineFeed;
End;
{컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴}
{컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴}
Procedure ShowBanner;
Var h,m,s,x:word;
Begin
   outpipe(cfg.oqbanners[random(maxbanners)]);
End;
{컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴}
Procedure ShowTime;
var h,m,s,x:word;
begin
   outpipe(cfg.seperator);
   gettime(h,m,s,x);
   outpipe(cfg.rTime[random(maxrtime)] + b2dec(h)+':'+b2dec(m)+'.'+b2dec(s));
   if not cfg.showdate then outpipe(cfg.seperator);
end;
{컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴}
Procedure ShowDate;
var h,m,s,x:word;
    z      :word;
begin
   getdate(h,m,s,x);
   outpipe(cfg.seperator);
   outpipe(cfg.rDate[random(maxrtime)] + dow[x]+','+w2dec(m)+'/'+w2dec(s)+'/'+w2dec(h));
   outpipe(cfg.seperator);
end;
{컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴}
{컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴}
Procedure ShowTagline;
var f         :text;
    x,
    line,
    nTaglines :longint;
    tag       :string;
    found     :boolean;
Begin
     nTaglines:=Lines(cfg.taglinefile);
     assign(f, cfg.taglinefile);
     reset(f);
     found:=false;
     x:=0;
     repeat
       line:=random(nTaglines);
       while not (x=line) do
             begin readln(f, tag); inc(x); end;
       readln(f, tag);
       if not (tag[1]=';') then found:=true;
     until found;
     setcolor(random(14)+1);
     outpipe(tag);
     LineFeed;
End;
{컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴}
{컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴}
{컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴}
Procedure PerformOmniQuoteDuties;
Begin
  if con             then clrscr;
  If cfg.showsig     then if cfg.randomsig then RandomSignature
                                           else DisplaySignature;
  if cfg.showbanner  then ShowBanner;
  if cfg.showtime    then ShowTime;
  if cfg.showdate    then ShowDate;
  if cfg.showbanner or (cfg.showtime or cfg.showdate)
                     then LineFeed;
  if cfg.showtagline then ShowTagline;
End;
{컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴}
{컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴}
{컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴}
Procedure Init;
Begin
   randomize;
   cfg.comport:=DefaultCom;
   CheckBreak:=False;
   if (paramcount >= 1) then ReadConfig(paramstr(1))
                        else ReadConfig(defaultconfig);
   If not CON then
                begin
                  assign(com, cfg.comport);
                  rewrite(com);
                end;
End;
{컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴}
Procedure DeInit;
Begin
     if not CON then Close(com);
End;
{컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴}
Begin
     Init;
     PerformOmniQuoteDuties;
     DeInit;
End.
(* FEARLESS WRETCH...INSANITY...HE WATCHES...LURKING...*)