{G+,A+,X+}
Program OmniQuote2000;
{ PUT IN PREVIEW MODE!!}
{ ???? NUMBER OF BANNERS INCONSISTANT WITH ACTUAL NUMBER }
{   ÚÄÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÄ¿
    ³  ÜÛßÛÜ    .        .        ÛÛ   ÜÛßÛÜ ú       .       Ü          ³
    À ŞÛİ ŞÛİ Ü ÜÜ ÜÜÜ   Ü ÜÜÜ   ÜÜÜ úŞÛİ ŞÛİ ÜÜ  ÜÜ  ÜÜÜ   ÛÛ   ú ÜÜÜ  Ù
      ÛÛ  .ÛÛ .ÛÛ ÛÛ ÛÛ   ÛÛ ÛÛ   ÛÛ  ÛÛ   ÛÛ  ÛÛ Û  ÛÛ ÛÛ ßÛÛß  ÜÛÛ ÛÛ
      ŞÛİ ŞÛİ. ÛÛ ÛÛ ÛÛ . ÛÛ ÛÛ . ÛÛ  ŞÛİÜŞÛİ  ÛÛ Û  ÛÛ ÛÛ  ÛÛ  ÜÛÛßßßß
       ßÛÜÛß  ÜÛß ÛÛ ßÛÜÜÜÛß ßÛÜÜÜÛÛÜ  ßÛÛÛß   ßÛÜßÜ ßÛÜÛß  ßÛÜß  ßÛÜÜß
          ³                              ßÛÜ Ü     .
     ú -ÄÄÅÄ-- ú        .           ú      ßß    ú                .   .
          ³ ßÛÛÛÛÛÛÜ       ÜÛÛÛÛÛÛÜ.     ÜÛÛÛÛÛÛÜ   .  ÜÛÛÛÛÛÛÜ
       ú  |       ÛÛİú    ŞÛÛß  ßÛÛİ   .ŞÛÛß. ßÛÛİ    ŞÛÛß  ßÛÛİ    .
          .   ÜÛÛÛÛß      ÛÛİ ú  ŞÛÛ    ÛÛİ    ŞÛÛ    ÛÛİ  . ŞÛÛ    |
     .       ÛÛß          ŞÛÛÜ  ÜÛÛİ    ŞÛÛÜ .ÜÛÛİ.   ŞÛÛÜ  ÜÛÛİ    ³ .
            ÛÛÛÛÛÛÛÛÜ  .   ßÛÛÛÛÛÛß  .   ßÛÛÛÛÛÛß      ßÛÛÛÛÛÛß ú-ÄÄÅÄÄÄ--ú
       ú                                            ú               ³
    Ú      .    An entire rewrite of the original OmniQuote!   ú    |   ¿
    ³                   (c)1996 Hacsoft Developments!               .   ³
    ÀÄÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÄÙ
}
Uses HSD, CRTASM, UTILS, CRT, INI, OQ_MISC;
Const
     DefLine1    ='OmniQuote2k |VE - Time:|TI - Date:|DA';
     DefLine2    ='|TA^M';
     MaxLines    =9;
{ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ}
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
         getINIString(s,'UseSetNumber','Random', Rnd);
         getINIToggle(s,'ANSI',            ANSI);
         getINIToggle(s,'ForceLowASCII',   ForceLowASCII);
         GetINIString(s,'SendTo','CON',    cfg.ComPort);
{         showtagline:=true;}
{         showsig:=true;}
         if cfg.Comport='CON' then CON:=True;
         {GET TAGLINE FILENAME}
         GetINIString(s,'TaglinePath','',TaglineFile);
         if taglinefile<>'' then
                         if not exist(taglinefile) then
                                       err(errTaglineFileNotFound, taglinefile,'');
               begin
                  for x:=0 to 9 do
                         begin
                           GetINIString(s,'SIG'+b2dec(x),'',randsig[x]);
                           if randsig[x]<>'' then
                                            begin
{                                              allblank:=false;}
                                              if not exist(randsig[x]) then
                                                               err(errNoFindRandSigFile,randsig[x],'SIG'+b2dec(x));
                                            end;
                         end;
{                        if allblank then err(errAllBlankRandom,'','');}
                       end;

         For x:=0 to 9 do               {GET FIRST LINE BANNER DEFINITIONS}
                     begin
                       GetINIString(s,'LINE1_'+b2dec(x),'',oqLine1[x]);
                       if oqLine1[x]='' then
                                   begin
                                     maxLine1:=x;
                                     break;
                                   end;
                     end;

         For x:=0 to 9 do               {GET SECOND LINE BANNER DEFINITIONS}
                     begin
                       GetINIString(s,'LINE2_'+b2dec(x),'',oqLine2[x]);
                       if oqLine2[x]='' then
                                   begin
                                     maxLine2:=x;
                                     break;
                                   end;
                     end;

      end; {WITH}
End; {READ CONFIG}
{ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ}
Procedure ShowLine1;
Begin
   if maxLine1>0 then
      if upcase(cfg.rnd[1])='R' then outpipe(cfg.oqLine1[random(maxLine1)])
                                else
                                    begin
                                      if stow(cfg.rnd) in [0..MaxLines] then
                                           outpipe(cfg.oqLine1[stow(cfg.rnd)]);
                                    end;
End;
{ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ}
Procedure ShowLine2;
Begin
   if maxLine2>0 then
      if upcase(cfg.rnd[1])='R' then outpipe(cfg.oqLine2[random(maxLine2)])
                                else
                                    begin
                                      if stow(cfg.rnd) in [0..MaxLines] then
                                           outpipe(cfg.oqLine2[stow(cfg.rnd)]);
                                    end;

End;
{ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ}
{ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ}
{ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ}
{ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ}
{ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ}
{ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ}
Procedure PerformOmniQuoteDuties;
Begin
  if con             then clrscr;
{  if maxLine1>0 then outpipe(cfg.oqLine1[random(maxLine1)]);
  if maxLine2>0 then outpipe(cfg.oqLine2[random(maxline2)]);}
  ShowLine1;
  ShowLine2;
End;
{ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ}
{ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ}
{ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ}
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
{ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ}
Procedure DeInit;
Begin
     if not CON then begin flush(com); Close(com); end;
End;
{ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ}
Begin
     Init;
     PerformOmniQuoteDuties;
     DeInit;
End.
(* FEARLESS WRETCH...INSANITY...HE WATCHES...LURKING...*)