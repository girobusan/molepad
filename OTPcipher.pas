unit OTPcipher;

{$mode objfpc}{$H+}

interface

uses
  Dialogs,Classes, SysUtils,uspybeauty;


procedure changeEncryptionType();
function isEncByAddition():boolean;
procedure setEncByAdditionTo(val:boolean);
function Cipher(src:ansistring; key:ansistring; encypher:boolean):ansistring;

implementation

var
   encypherByAddition:boolean=True;

procedure changeEncryptionType();
begin
       encypherByAddition:=not encypherByAddition
   end;
procedure setEncByAdditionTo(val:boolean);
begin
   encypherByAddition:=val;
end;

function isEncByAddition():boolean;
begin
   isEncByAddition:= encypherByAddition
end;


function mod10minus(a:integer;b:integer):integer; //a-b: it was harder, than expected
begin
     if b>a then a:=10+a;  //very problem specific
     mod10minus:=(a-b) mod 10;
end;

function Cipher(src:ansistring; key:ansistring; encypher:boolean):ansistring;
var
   i:integer;       //loop counter
   sn:integer;      //current source text digit
   kn:integer;      //current key digit
   r:ansistring=''; //result
begin
     encypher:=encypher and encypherByAddition;
     src:=extractNums(src);
     key:=extractNums(key);
   if length(src)> length(key) then
      begin
      Cipher:='(⊙︿⊙)'; // :_(
      ShowMessage('Insufficient key length');
      exit;
      end;
   for i:=1 to (length(src)) do
       begin
         try
         sn:=strToInt(src[i]);
         kn:=strToInt(key[i]);
         Except
           On E:EConvertError do
             begin
             ShowMessage('Non-digit symbol in input. Please check.'); //Newer shown,
             Cipher:='(''o'')';                              //but funny.
             exit;
             end;

         end;
         if encypher then
            begin
            r:=r+intToStr( (sn+kn) mod 10 )
            end
         else
             begin
             r:=r+intToStr( mod10minus(sn,kn))
             end;
       end;
   //if encypher then  ShowMessage('Encrypted');

   Cipher:=SpyGrouping(r);
end;

end.
