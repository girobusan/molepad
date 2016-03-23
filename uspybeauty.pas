unit uspybeauty;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils;

function SpyGrouping(s:ansistring; pad:boolean=true):ansistring;
function extractNums(s:ansistring):ansistring;

implementation

function SpyGrouping(s:ansistring; pad:boolean=true):ansistring; //Group them like a REAL spy!
  var
     r:ansistring='';
     i:integer;
     p:integer=0;
  const
    FiveBullets='00000';
  begin
       for i:=1 to (length(s)) do
           begin
           r:=r+s[i];
           if ((i mod 5) = 0) then r:=r+' ';  //ALL spies ALL the time group them by 5.
           end;
        if pad then p:= length(r) mod 5;
        SpyGrouping:=r + copy(FiveBullets, 1, p)
  end;

function extractNums(s:ansistring):ansistring;
  var
     r:ansistring='';
     i:integer;
  const
     DIGITS=['0'..'9'];
  begin
    for i:=1 to length(s) do
        begin
        if s[i] in DIGITS then r:=r+s[i]
        end;
    extractNums:=r
  end;

end.

