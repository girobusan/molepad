unit ucheckerboard;

{$mode objfpc}{$H+}
(*
Implementation of "staggered checkerboard" (нерегулярная таблица) encoding.

*)

interface

uses
  {$ifdef unix}
  cwstring, //for right Unicode handling on *nix
  {$endif}
  Classes, SysUtils, contnrs;
type
  TCodeTable = Object
    title:string;
    description:string;
    letters: string;  //all characters, which belongs to different codepages
    rawsource:ansistring;


    procedure CreateFromStrings(strs:tstringlist);
    procedure CreateFromFile(filename:string);
    function Encode(itxt:ansistring):ansistring; virtual;
    function Decode(txt:ansistring):ansistring; virtual;
    constructor Init();
    destructor Destroy();

    private
    cp1enc : TFPStringHashTable;  //all "main" characters to codes
    cp2enc : TFPStringHashTable;   //all "alt" characters to codes
    cp1dec : TFPStringHashTable;   //all "main" codes to characters
    cp2dec : TFPStringHashTable;   //all "alt" codes to  characters


  end;

   TNullCode = Object(TCodeTable)
     function Encode(itxt:ansistring):ansistring; virtual;
     function Decode(txt:ansistring):ansistring; virtual;
     end;



implementation

constructor TCodeTable.Init();
  begin
  Title:='Untitled';
  Description:='No description provided'
  end;

destructor TCodeTable.Destroy();
begin
 cp1enc.free;
 cp2enc.free;
 cp1dec.free;
 cp2dec.free;

end;

procedure TCodeTable.CreateFromStrings(strs:tStringList);
 const
    SNONE=0;
    STITLE=1;
    SDESCRIPT=2;
    SCODE1=3;
    SCODE2=4;
    SLETTERS=5;
 var

   i:integer;
   buffer:ansistring;
   upperbuffer:ansistring;
   readerState:integer=SNONE;
   currentCode:ansistring;
   currentSymbol:ansistring;
 begin
   rawsource:=strs.text;
   cp1enc:= TFPStringHashTable.Create(); //encode...
   cp2enc:=TFPStringHashTable.Create();

   cp1dec:= TFPStringHashTable.Create(); //decode...
   cp2dec:=TFPStringHashTable.Create();

   //reading
   for i:=0 to (strs.Count-1) do
   begin
     buffer:= Trim(strs[i]);
     upperbuffer:=utf8encode( WideUpperCase( Utf8decode(buffer ) ) );
     if buffer = '' then Continue;
     if buffer[1] ='#' then Continue;
     //check if state must be changed
     case upperbuffer of
      'TITLE'        : readerState:=STITLE;
      'DESCRIPTION'  : readerState:=SDESCRIPT;
      'CODETABLE'    : readerState:=SCODE1;
      'ALTCODES'     : readerState:=SCODE2;
      'LETTERS'      : readerState:=SLETTERS;
     else
       if readerState = SNONE then Continue;
     //reading info fields
       case readerState of
         STITLE:
           begin
           title:= title + buffer;
           Continue
           end;
         SDESCRIPT:
           begin
           description:= description + buffer;
           Continue
           end;
         SLETTERS:
           begin
           letters:= letters+upperbuffer;
           Continue
           end;
       end;
       //reading code tables
       if (readerState = SCODE1) or (readerState = SCODE2) then
         begin
         //extract code and symbol from buffer
          currentCode:= copy(buffer, 1, pos(' ', buffer)-1 );
          currentSymbol := copy(upperbuffer, pos(' ', buffer)+1, 6  );
          //writeln('Code '+ currentCode + ' means ' + currentSymbol + '.');
          //filling codetables
          try
          if readerState = SCODE1 then
            begin
            cp1dec.Add(currentCode, currentSymbol);
            cp1enc.Add(currentSymbol,currentCode)
            end;
          if readerState = SCODE2 then
            begin
            cp2dec.Add(currentCode, currentSymbol);
            cp2enc.Add(currentSymbol,currentCode);
            end;
          except
            on EDuplicate do writeln('Warning, duplicate symbol or code in code table');
          end;
          //filled
         end;

     end;//end BIG CASE
   end;//end reading loop
   //test
   writeln('It is codetable, named "'+ title+'", descripted as "' + description +'"');
   //writeln('Hashtables filled');
   //writeln ('cp1-' + IntToStr(cp1enc.Count));
   //writeln ('cp2-' + IntToStr(cp2enc.Count));
   ///test

 end;

procedure TCodeTable.CreateFromFile(filename:string);
    var
      tmps:tstringlist;
    begin
      tmps:= TStringlist.Create;  //NOTE
      tmps.LoadFromFile(filename);
      createFromStrings(tmps);
      tmps.Free
    end;

function TCodeTable.Encode(itxt:ansistring):ansistring;
  const
     digits='0123456789';
  var

    i:integer;
    txt:string;
    b:string;  //buffer
    cpage1:boolean=True; //cp of current text
    fig:boolean=False; //do we do digits
    r:string=''; //result
  begin
    //encoding loop
    txt:=utf8encode(WideUpperCase( utf8decode(itxt) ));
    for  i:=1 to length(utf8decode( utf8encode(txt) )) do
    begin
       b:= utf8encode( Copy(utf8decode(txt), i,1 ));             //txt[i];


       //if symnol is unknown?
       if (pos(b, digits)=0) and ( cp1enc[b]='' ) and  (cp2enc[b]='') and not(b=' ') then
         begin
         writeln('Unknown symbol '+b);
         r:=r+'';
         Continue
         end;
      //do we need to change mode - digits?
      if (pos(b, digits)>0) and (not fig) then
        begin
        fig:=True;
        r+=cp1enc['!FIG']   //????!
        end;
      if (pos(b, digits)=0) and fig then
        begin
        fig:=False;
        r:= r+ cp1enc['!FIG']
        end;
      //is there a space?
       if b=' ' then
         begin
         r+=cp1enc['!SPACE'];
         Continue
         end;

      //do we need to change mode - codepages?
      if pos(b,letters)<>0 then
      begin
        //if symbol is in cp1, and current is cp2, switch to cp1
          if (cp1enc[b]<>'') and (not cpage1) then
            begin
            cpage1:=True;
            r+=cp1enc['!CP1']
            end;
        //if symbol in cp2, and current is cp1. switch to cp2
          if (cp2enc[b]<>'') and cpage1 then
            begin
            cpage1:=False;
            r+=cp1enc['!CP2']
            end;

        end;//all about codepages
       //here goes dumb substitution
       if fig then
         begin
         r:= r+b+b;
         Continue
         end;
       if cpage1 then r+=cp1enc[b];
       if (not cpage1) then
         begin
         if(cp2enc[b]='') then r+=cp1enc[b] else  r+=cp2enc[b];  //not so dumb
         end
      end;//end main loop
    Encode:=r
    end;





function TCodeTable.Decode(txt:ansistring):ansistring;
  var
    position:integer=1;
    blength:integer=1;
    iscp1:boolean=True;
    isDigits:boolean=False;
    wst:widestring;
    buff:string;
    rz:string='';
  begin
    wst:=utf8decode(txt);
    repeat
      buff:=utf8encode( copy(wst,position,blength));

      //DIGITS
      //check, if we're already in the digits block
      if isDigits then
       begin
       if blength<2 then
        begin
        Inc(blength);
        continue;  //not enough data
        end;
       if (blength=2) and (buff[1]=buff[2]) then
        begin
        //we know the digit
        rz+=buff[1];
        position:=position + blength;
        blength:=1;
        continue
        end
       else
        isDigits:=False; //certainly, it's not a digit.
        blength:=1;      //we have to start new round
        if buff[1] = cp1enc['!FIG'] then  //if fig. designator encoded with one digit
         begin
         position :=position +1;
         Continue;
         end;
        if buff = cp1enc['!FIG'] then    //if designator encoded with two digits
         begin
         position :=position +2;
         Continue;
         end;

        (*something goes wrong with the digits, if we've reached this line:
          digits block ended, but designator not found. Digits designator must
          consist either of one digit, or two different ones*)
           // position:=position + 0
          (*We'll try to decrypt as letter (GIVE A WARNING)
          Actually, it means, that in some cases it's possible not to terminate
          digits blocks. But only if the next code can not be misdecoded
          as digits.*)

       end;//digits block ended here

      //SPECIAL SYMBOLS
      if (cp1dec[buff]<>'') and (cp1dec[buff][1]='!') and (length(cp1dec[buff])>1) then
       begin
        //writeln('it''s special "' + cp1dec[buff] +'"');
        case cp1dec[buff] of
          '!FIG'  : isDigits:=true;
          '!SPACE': rz+=' ';
          '!CP1' : iscp1:=true;
          '!CP2' : iscp1:=false;
          '!CODE' : rz+='code';
        end;
        position:=position + blength;
        blength:=1;
        Continue
       end; //that's all with special symbols

      //LETTERS
      if (cp1dec[buff]<> '') and iscp1 then   //symbol from main codetable...
       begin                                 //       __.-.__
        rz+= cp1dec[buff];                  //        '-o_o-'
        position:=position + blength;      //          / ~ \
        blength:=1;
        Continue //...it was.
       end;
      if (cp2dec[buff]<> '') and not iscp1 then  //symbol from alt codetable...
       begin
        rz+= cp2dec[buff];
        position:=position + blength;
        blength:=1;
        Continue  //...it was.
       end;
      if (cp2dec[buff]= '') and (cp1dec[buff]<> '') then //let me guess...
       begin
        //writeln('punctuation?' + buff);
        rz+= cp1dec[buff];
        position:=position + blength;
        blength:=1;
        Continue  //...punctuation?
       end;


       //we're messed up if...
       if blength>2 then
        begin
         writeln('We''re messed up, sir!'); //I was not able to
         Decode:= rz+'...(unciphered)';
         exit
        end;

       //not decoded, enlarge buffer length
       blength+=1;
    until position>length(wst);
  Decode:= rz
  end;

function TNullCode.Encode(itxt:ansistring):ansistring;
  begin
  Encode:=itxt;
  end;


  function TNullCode.Decode(txt:ansistring):ansistring;
  begin
  Decode:=txt;
  end;

end.

