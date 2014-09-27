Program TempKSPIFF;


Function GetKWord:String;
Const    nKList =10;
         kList  :Array[0..nKList-1] of String[7] =
                                    ('spiffy',
                                     'cool',
                                     'elite',
                                     'piano',
                                     'floyd',
                                     'pizza',
                                     'kumquat',
                                     'fudge',
                                     'monkey',
                                     'rubber');
Begin
     Randomize;
     GetKWord:='k-'+klist[random(nKList)];
End;


Begin
     writeln(GetKWord);
End.