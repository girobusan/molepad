unit OTPcipher;

{$mode objfpc}{$H+}

interface

uses
  Dialogs, SysUtils, uspybeauty;

procedure changeEncType();
function isEncByAddition(): boolean;
procedure setEncByAdditionTo(val: boolean);
function Cipher(src: ansistring; key: ansistring; encipher: boolean): ansistring;

implementation

var
  encipherByAddition: boolean = False;

procedure changeEncType();
begin
  encipherByAddition := not encipherByAddition;
end;

procedure setEncByAdditionTo(val: boolean);
begin
  encipherByAddition := val;
end;

function isEncByAddition(): boolean;
begin
  isEncByAddition := encipherByAddition;
end;


function mod10minus(a: integer; b: integer): integer; //a-b: it was harder, than expected
begin
  if b > a then
    a := 10 + a;  //very problem specific
  mod10minus := (a - b) mod 10;
end;

function Cipher(src: ansistring; key: ansistring; encipher: boolean): ansistring;
var
  i: integer;         //loop counter
  sn: integer;         //current source text digit
  kn: integer;         //current key digit
  r: ansistring = ''; //result
  eflag: boolean;         //substraction flag
begin

  eflag := encipher xor encipherByAddition;
  src := extractNums(src);
  key := extractNums(key);

  if length(utf8decode(src)) > length(key) then
  begin
    Cipher := '(⊙︿⊙)';
    ShowMessage('Insufficient key length');
    exit;
  end;
  for i := 1 to (length(src)) do
  begin
    try
      sn := StrToInt(src[i]);
      kn := StrToInt(key[i]);
    except
      On E: EConvertError do
      begin
        ShowMessage('Non-digit symbol in input. Please check.'); //Newer shown,
        Cipher := '(''o'')';                              //but funny.
        exit;
      end;

    end;
    if eflag then
    begin
      //ShowMessage('Minus');
      r := r + IntToStr(mod10minus(sn, kn));
    end
    else
    begin
      //ShowMessage('Plus');
      r := r + IntToStr((sn + kn) mod 10);
    end;
  end;
  Cipher := r;
end;

end.
