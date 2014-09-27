function ran1pt: real;
{adapted from ran1 in NRPAS13.ZIP (code for the book
Numerical Recipes in Pascal); modified 94-03-25 by Pierre 
Tourigny, pierre.tourigny@bbs.synapse.net; Ran1pt calls 
Randomize if RANDSEED has not already been set}
const
  m1: longint = 259200; i1: longint = 7141; c1: longint = 54773;
  m2: longint = 134456; i2: longint = 8121; c2: longint = 28411;
  m3: longint = 243000; i3: longint = 4561; c3: longint = 51349;
  {static variables}
  x1: longint = 0; x2: longint = 0; x3: longint = 0;
  r: array [1..97] of real = (0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,
    0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,
    0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,
    0,0,0,0,0,0,0,0);
  initialized: boolean = false;
var
  j: integer;
begin
if not initialized then begin
  if randseed = 0 then randomize
  else randseed := abs(randseed);
  x1 := (randseed+c1) mod m1;
  x1 := (x1*i1+c1) mod m1;
  x2 := x1 mod m2;
  x1 := (x1*i1+c1) mod m1;
  x3 := x1 mod m3;
  for j := 1 to 97 do begin
    x1 := (x1*i1+c1) mod m1;
    x2 := (x2*i2+c2) mod m2;
    r[j] := (x1+x2/m2)/m1;
    end;
  initialized := true;
  end;
x1 := (x1*i1+c1) mod m1;
x2 := (x2*i2+c2) mod m2;
x3 := (x3*i3+c3) mod m3;
j := 1 + (97*x3) div m3;
ran1pt := r[j];
r[j] := (x1+x2/m2)/m1;
end;

function ranlong(max: longint): longint;
begin ranlong := trunc(max * ran1pt) end;

function ran(n:longint):longint;
begin
     randomize;
     if n>65535 then ran:=ranlong(n)
                  else ran:=random(n);
end;

begin
     repeat
           writeln(ran(maxlongint));
     until port[$60]=1
end.