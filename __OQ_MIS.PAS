Unit OQ_MISC;

Interface
Uses HSD, STRINGS, CRTASM, GFX, CRT, UTILS;
Const
      {Errors컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴�}
      errNone                   = 100;
      errNoTagFileName          = 101;
      errTaglineFileNotFound    = 102;
      errConfigNotFound         = 103;
      errNoSigFileName          = 104;
      errSigFileNotFound        = 105;
      errSigTooBig              = 106;
      errAllBlankRandom         = 107;
      errNoFindRandSigFile      = 108;
      {Other횮ontants컴컴컴컴컴컴컴컴컴컴컴�}
      DefaultConfig             ='OQ.CFG';
      DefaultCom                ='COM1';  {Or reroute to a file!}
      CON                       :Boolean=False;
{컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴}
Type
    tConfig     =Record
                       RenPipes,
                       ShowBanner,
                       ANSI,
                       Picker,
                       ShowTagline,
                       ShowSig,
                       RandomSig,
                       ShowTime,
                       ShowDate,
                       ForceLowASCII :Boolean;
                       TaglineFile   :String;
                       SignatureFile :String;
                       ComPort       :String;
                       RandSig       :Array[0..9] of String;
                       rTime,rDate,
                       oqBanners     :Array[0..9] of String;
                       Seperator     :String;
                    End;
{컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴}
Var
   com                  :Text;
   cfg                  :tConfig;
   ConfigFilename       :String;
   MaxBanners,
   MaxRTime, MaxRDate   :Byte;
{컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴}
Procedure LineFeed;
Function  ANSIColor(i,col:word):string;
Function  ANSIBG(col:word):string;
function  LZ(w : Word) : String;
Procedure SetColor(color:byte);
Procedure ErrBeep;                                  {Think: MARIO}
Procedure Err(errorno:byte; s,ss:string);
procedure output(s:string);
procedure OutPipe(s:string);
{컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴}
{컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴}
Implementation
Procedure LineFeed;
Begin
  if con then writeln else output(^M);
End;
{컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴}
function LZ(w : Word) : String;
var
  s : String;
begin
  Str(w:0,s);
  if Length(s) = 1 then s:='0'+s;
  LZ:=s;
end;
{컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴}
Procedure SetColor(color:byte);
begin
  if con then TextColor(color) else
   If cfg.RenPipes then Write(com,'|'+lz(color))
      else if cfg.ANSI then
                    begin
                      if color=00 then write(com,AnsiColor(0,0));
                      if color=01 then write(com,AnsiColor(0,4));
                      if color=02 then write(com,AnsiColor(0,2));
                      if color=03 then write(com,AnsiColor(0,6));
                      if color=04 then write(com,AnsiColor(0,1));
                      if color=05 then write(com,AnsiColor(0,5));
                      if color=06 then write(com,AnsiColor(0,3));
                      if color=07 then write(com,AnsiColor(0,7));
                      if color=08 then write(com,AnsiColor(1,0));
                      if color=09 then write(com,AnsiColor(1,4));
                      if color=10 then write(com,AnsiColor(1,2));
                      if color=11 then write(com,AnsiColor(1,10));
                      if color=12 then write(com,AnsiColor(1,4));
                      if color=13 then write(com,AnsiColor(1,1));
                      if color=14 then write(com,AnsiColor(1,3));
                      if color=15 then write(com,AnsiColor(1,7));
                    End;
end;
{컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴�}
Function ANSIColor(i,col:word):string;
Var
   foo:string;
   bs :string;
begin
 foo:='';
 if cfg.ANSI then
                begin
                  str(i,bs);
                   foo:=#27+'['+bs;
                  str(col, bs);
                   foo:=foo+';3'+bs+'m';
                end;
 ansicolor:=foo;
end;
{컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴�}
Function AnsiBG(col:word):string;
Var
   foo:string;
   bs :string;
begin
 foo:='';
 if cfg.ANSI  then
                begin
                   foo:=#27+'[';
                     str(col, bs);
                   foo:=foo+'4'+bs+'m';
                end;
 AnsiBG:=foo;
end;
{컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴}
Procedure ErrBeep;                                  {Think: MARIO}
Begin
     Sound(30); delay(50); nosound;
     delay(150);
     sound(19);
End;
{컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴}
Procedure Err(errorno:byte; s,ss:string);
Begin
  ClrScr;
  TextColor(Yellow);
  if not (errorno=errConfigNotFound) then writeln('Read from ',configfilename,' for the current config.');
  TextColor(white);
  WriteLn('Whoops...');
  ErrBeep;
  TextColor(yellow);
  case errorno of
       errNone                  :begin end;
       errNoTagFileName         :begin
                                   TextColor(blue+8);
                                   WriteLn('Nothing has been specified for your tagline file.  Please supply');
                                   WriteLn('a filename, or turn "ShowTagline" in your configuration off.');
                                 end;
       errTaglineFileNotFound   :begin
                                   TextColor(Red);
                                   WriteLn('The tagline file "',s,'" specified in your configuration file');
                                   WriteLn('could not be found.');
                                 end;
       errConfigNotFound        :begin
                                   TextColor(Red);
                                   WriteLn('The configuration specified, "',s,'" could not be found.');
                                   WriteLn;
                                   WriteLn('OmniQuote, when not supplied with a configuration file on the');
                                   WriteLn('command line, will try to load in ''OQ.CFG'' from the current');
                                   WriteLn('directory.  If your method of accessing OQ calls');
                                   WriteLn('it doing something similar to "C:\TERM\OMNI\OQ.EXE", then keep');
                                   WriteLn('in mind that the current directory will be C:\TERM, and NOT');
                                   WriteLn('C:\TERM\OMNI where OQ.CFG would be found.  For safety, you should');
                                   WriteLn('always specify a file on the comand line.');
                                 end;
      errNoSigFileName          :Begin
                                   TextColor(blue+8);
                                   WriteLn('Nothing has been specified for your tagline file.  Please supply');
                                   WriteLn('a filename, or turn "ShowTagline" in your configuration off.');
                                 End;
      errSigFileNotFound        :Begin
                                   TextColor(Red);
                                   WriteLn('The signature file "',s,'" specified in your configuration file');
                                   WriteLn('could not be found.');
                                 End;
      errSigTooBig              :Begin
                                   TextColor(Red);
                                   WriteLn('The signture file "',s,'" is over 65534 bytes ins size.');
                                   WriteLn('(That must be one BIG sig!)');
                                 End;
      errAllBlankRandom         :begin
                                  TextColor(Red);
                                  WriteLn('You have selected random signatures, but all the SIG entries');
                                  WriteLn('are blank.  Please either turn off RandomSignatures and supply');
                                  WriteLn('a filename for the SignaturePath option, or supply at least ONE');
                                  WriteLn('filename for any one of the SIG entries.');
                                 end;
      errNoFindRandSigFile      :begin
                                  TextColor(red);
                                  WriteLn('The file "',s,'" in the entry ''',ss,'''');
                                  WriteLn('in your config could not be found.  Please supply a correct filename, or');
                                  WriteLn('leave the entry blank.');
                                 end;
       else
           begin
             TextColor(green+blink);
             writeln('Undefined error.  (*Something weird going on!*)');
           end;
       end;
       textcolor(red+8);
       writeln;
       writeln('Press A Key When Finished Reading');
       delay(300); NoSound;
       repeat until keypressed; readkey;
       halt(errorno);
End;
{컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴}
procedure output(s:string);
Begin
     case con of
          true:  write(s);
          false: write(com, s);
          end;
End;
{컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴}
procedure OutPipe(s:string);
var x,y :byte;
    c   :char;
begin
 x:=1;                                       {Beginning of string}
 while x<length(s)+1 do
          case s[x] of
               '|'  :if s[x+1] in ['0'..'9'] then
                      begin
                         setcolor(stow(s[x+1]+s[x+2]));
                         inc(x, 3);
                      end
                       begin
                       end
                         else
                      begin write('|'); inc(x); end;
               '^'  :begin
                         if upcase(s[x+1])='M' then begin
                                                       linefeed;
                                                       inc(x,2)
                                                    end
                                               else begin
                                                       output('^');
                                                       inc(x);
                                                    end;
                     end;
                else begin output(s[x]); inc(x); end;
              end;
end; {OutPipe}

End. {unit}