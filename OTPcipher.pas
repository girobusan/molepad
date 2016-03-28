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
   encypherByAddition:boolean=False;

procedure changeEncryptionType();
   begin
      //ShowMessage('Newer use it');
       encypherByAddition:=not encypherByAddition
   end;

procedure setEncByAdditionTo(val:boolean);
  begin
      //ShowMessage('Newer use it');
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
   eflag:boolean;
begin

     eflag:=not(encypher xor encypherByAddition);
     src:=extractNums(src);
     key:=extractNums(key);
     {*
     if encypherByAddition then ShowMessage('encypherByAddition true!');
     if encypher then ShowMessage('encypher tue!');
     if eflag then ShowMessage('eflag tue!');
     *}
   if length(utf8decode(src))> length(key) then
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
         if eflag then
            begin
            //ShowMessage('Plus');
            r:=r+intToStr( (sn+kn) mod 10 )
            end
         else
             begin
             //ShowMessage('Minus');
             r:=r+intToStr( mod10minus(sn,kn))
             end;
       end;
   //if encypher then  ShowMessage('Encrypted');

   Cipher:=r;
end;

end.
