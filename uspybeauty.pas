unit uspybeauty;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils;

function SpyGrouping(s:ansistring; pad:boolean=true):ansistring;
function extractNums(s:ansistring):ansistring;
function PadTo(s:string;p:integer):string;

implementation

function SpyGrouping(s:ansistring; pad:boolean=true):ansistring; //Group them like a REAL spy!
  var
     r:ansistring='';
     i:integer;
     p:integer=0;
     ws:ansistring;
  const
    FiveBullets='00000';
  begin
    ws:=Trim(s);
    p:= length(ws) mod 5;


       for i:=1 to (length(ws)) do
           begin
           r:=r+s[i];
           if ((i mod 5) = 0) then r:=r+' ';  //ALL spies ALL the time group them by 5.
           end;
       if pad and (p<>0) then r:= r+copy(fiveBullets, 1, 5-p);

        SpyGrouping:=r
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

function PadTo(s:string;p:integer):string;
var
   r:string;

  begin
    r:=s;
    while (length(r) mod p)<>0 do r+='0';
    PadTo:=r
  end;

end.

