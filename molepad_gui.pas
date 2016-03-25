unit molepad_gui;

{$mode objfpc}{$H+}

interface




uses
  Classes, SysUtils, FileUtil, Forms, Controls, Graphics, Dialogs, Menus,
  OTPcipher, ucheckerboard,uspybeauty,viewsource,

  ComCtrls, StdCtrls, ExtCtrls, ActnList;
var
  curtable   : ^TCodeTable;
  customTable: TCodeTable;
  tables     : array of TCodeTable;
  trs        : TResourceStream;
  tsl        : TStringList;
  i          : integer;
  x          : integer;

const

  rTables: array[0..3] of string =('SONET-C','SONET-L','CT55','CT-1-ENGLISH') ; //FIX


type

  { Tmp_main }

  Tmp_main = class(TForm)
    viewSrc: TAction;
    DecipherAndDecode: TAction;
    EncodeAndEncipher: TAction;
    loadTable: TAction;
    ActionList1: TActionList;
    button_encipher: TButton;
    button_decipher: TButton;
    cb_encrypt_by_substraction: TCheckBox;
    codetable_chooser: TComboBox;
    codetable_description: TLabel;
    label_key: TLabel;
    label_codetable: TLabel;
    MainMenu1: TMainMenu;
    memo_input_text: TMemo;
    memo_final_result: TMemo;
    memo_encoded_text: TMemo;
    memo_key: TMemo;
    MenuItem1: TMenuItem;
    MenuItem2: TMenuItem;
    MenuItem3: TMenuItem;
    MenuItem4: TMenuItem;
    menu_tools: TMenuItem;
    menu_file: TMenuItem;
    menuitem_exit: TMenuItem;
    loadCodetabeFile: TOpenDialog;
    tabs_main: TPageControl;
    tabs_result: TPageControl;
    panel_key_top: TPanel;
    cipher_main_container: TPanel;
    cipher_buttons_container: TPanel;
    panel_key_bottom: TPanel;
    StatusBar: TStatusBar;
    tab_result_final: TTabSheet;
    tab_result_encoded: TTabSheet;
    tab_key: TTabSheet;
    tab_cipher: TTabSheet;
    procedure viewSrcExecute(Sender: TObject);
    procedure DecipherAndDecodeExecute(Sender: TObject);
    procedure EncodeAndEncipherExecute(Sender: TObject);
    procedure loadTableExecute(Sender: TObject);
    procedure cb_encrypt_by_substractionChange(Sender: TObject);
    procedure codetable_chooserChange(Sender: TObject);
    procedure FormCreate(Sender: TObject);

    procedure memo_input_textChange(Sender: TObject);
    procedure MenuItem1Click(Sender: TObject);
    procedure menuitem_exitClick(Sender: TObject);

  private
    { private declarations }
  public
    { public declarations }
  end;

var
  mp_main: Tmp_main;

resourcestring

ssLoadCodetable='Load custom table from file...';
ssUseCodetable='Use the ';
ssUseCodetableFin=' table.';
ssCodeWarning='Warning! This text is NOT enciphered';

procedure performEncipher();
procedure performDecipher();

implementation

{$R *.lfm}

{ Tmp_main }

procedure Tmp_main.codetable_chooserChange(Sender: TObject);

  begin
    if codetable_chooser.ItemIndex=length(tables) then
    begin
     loadTableExecute(codetable_chooser);
    end
    else
    begin
      curTable:=@tables[codetable_chooser.ItemIndex];
    end;
    codetable_description.caption:=curTable^.description;
    codetable_chooser.text:= curTable^.Title //FIX
  end;

procedure Tmp_main.cb_encrypt_by_substractionChange(Sender: TObject);
begin
  if cb_encrypt_by_substraction.checked then setEncByAdditionTo(False)
  else setEncByAdditionTo(True)
end;

procedure Tmp_main.loadTableExecute(Sender: TObject);
var
  filename:string;
begin
     if loadCodetabeFile.Execute then
      begin
        customTable.Init;
        filename := loadCodetabeFile.Filename;
        customTable.createFromFile(filename);
        curTable:=@customTable;
      end;
     codetable_description.caption:=curTable^.description;
    codetable_chooser.text:= curTable^.Title //FIX
end;

procedure Tmp_main.EncodeAndEncipherExecute(Sender: TObject);
begin
  performEncipher;
end;

procedure Tmp_main.DecipherAndDecodeExecute(Sender: TObject);
begin
  performDecipher;
end;

procedure Tmp_main.viewSrcExecute(Sender: TObject);
begin
  if assigned(curTable) then
   begin
   view_source.memo_src.Lines.text:=curTable^.rawsource;
   view_source.Show();
   end
  else showMessage('No table selected.');
end;

procedure Tmp_main.FormCreate(Sender: TObject);
begin
  //Set the checkbox at KEY tab
  if isEncByAddition then cb_encrypt_by_substraction.checked:=False
  else cb_encrypt_by_substraction.checked:=True;
  //load tables from resources
  SetLength(Tables , length(rTables) );
  for x:=0 to Length(rTables)-1 do
  begin
   trs := TResourceStream.Create(HInstance, rTables[x], RT_RCDATA);
   tsl:= TStringList.Create;
   tsl.LoadFromStream(trs);
   tables[x].CreateFromStrings(tsl);
  end;
   tsl.free;
   trs.free;
  //populate drop-down menu
   codetable_chooser.Items.Clear;
   for i:=0 to length(tables)-1 do
   begin
     codetable_chooser.Items.Add(ssUseCodetable + tables[i].title + ssUseCodetableFin);
   end;
   codetable_chooser.Items.Add(ssLoadCodetable);


end;



//encrypt
procedure performEncipher();
var
  input:string;
  otkey:string;
  encoded:string;
  indicator:string;
  //output:string;
begin
  //prepare key

  otkey:= extractNums( mp_main.memo_key.lines.text);;
  if otkey='' then
   begin
     ShowMessage('No valid key found');
     exit;
   end;
   indicator:=copy(otkey,1,5);
   otkey:=copy(otkey,6,length(otkey)-5);
  //check table
  if not assigned(curTable) then
   begin
     ShowMessage('No code table selected');
     exit;
   end;
  //check source
  input:= trim( mp_main.memo_input_text.lines.text) ;
  if input='' then
   begin
      ShowMessage('No source text entered');
     exit;
   end;
  //encode
  //ShowMessage(curTable^.Title);
  encoded:= curTable^.Encode(input);
  ShowMessage(encoded);
  mp_main.memo_encoded_text.lines.text:= SpyGrouping(encoded);
  //encrypt
  mp_main.memo_final_result.lines.text:=indicator + ' ' + SpyGrouping(Cipher(encoded, otkey, True));
end;

//decrypt
procedure performDecipher();
var
  input:string;
  otkey:string;
  encoded:string;
  indicator:string;
  //output:string;
begin
  //prepare key
  otkey:= extractNums( mp_main.memo_key.lines.text);
  if otkey='' then
   begin
     ShowMessage('No valid key found');
     exit;
   end;
   indicator:=copy(otkey,1,5);
   otkey:=copy(otkey,6,length(otkey)-5);
  //check table
  if not assigned(curTable) then
   begin
     ShowMessage('No code table selected');
     exit;
   end;
  //check source
  input:= trim( mp_main.memo_input_text.lines.text) ;
  if input='' then
   begin
      ShowMessage('No source text entered');
     exit;
   end;
  //decrypt
  //check indicator
  if (leftstr(input, 5)<>indicator) then
   begin
     ShowMessage('Indicator group do not match the key.');
   end;
  encoded:= Cipher(copy(input, 6, length(input)-5 ), otkey, False) ;
  mp_main.memo_encoded_text.lines.text:= SpyGrouping(encoded);
  //decode
  mp_main.memo_final_result.lines.text:=curTable^.Decode(encoded) // Cipher(encoded, otkey, True);

end;

procedure Tmp_main.memo_input_textChange(Sender: TObject);
begin

end;

procedure Tmp_main.MenuItem1Click(Sender: TObject);
begin

end;

procedure Tmp_main.menuitem_exitClick(Sender: TObject);
begin
  Halt(0);
end;

end.

