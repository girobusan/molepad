unit molepad_gui;

{$mode objfpc}{$H+}

interface




uses
  Classes, SysUtils, FileUtil, Forms, Controls, Graphics, Dialogs, Menus,
  OTPcipher, ucheckerboard, uspybeauty, viewsource, about,
  ComCtrls, StdCtrls, ExtCtrls, ActnList;

var
  curtable: ^TCodeTable;
  customTable: TCodeTable;
  tables: array of TCodeTable;
  trs: TResourceStream;
  tsl: TStringList;
  i: integer;
  x: integer;

const

  rTables: array[0..3] of string = ('SONET-C', 'SONET-L', 'CT55', 'CT-1-ENGLISH'); //FIX


type

  { Tmp_main }

  Tmp_main = class(TForm)
    generatePad: TAction;
    menu_help_about: TMenuItem;
    menu_help: TMenuItem;
    viewSrc: TAction;
    DecipherAndDecode: TAction;
    EncodeAndEncipher: TAction;
    loadTable: TAction;
    ActionList1: TActionList;
    button_encipher: TButton;
    button_decipher: TButton;
    cb_encipher_by_substraction: TCheckBox;
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
    procedure generatePadExecute(Sender: TObject);
    procedure menu_help_aboutClick(Sender: TObject);

    procedure viewSrcExecute(Sender: TObject);
    procedure DecipherAndDecodeExecute(Sender: TObject);
    procedure EncodeAndEncipherExecute(Sender: TObject);
    procedure loadTableExecute(Sender: TObject);
    procedure cb_encipher_by_substractionChange(Sender: TObject);
    procedure codetable_chooserChange(Sender: TObject);
    procedure FormCreate(Sender: TObject);



    procedure menuitem_exitClick(Sender: TObject);
    procedure ShowInStatus(s: string);

  private
    { private declarations }
  public
    { public declarations }
  end;

var
  mp_main: Tmp_main;

resourcestring

  ssLoadCodetable   = 'Load custom table from file...';
  ssUseCodetable    = 'Use the ';
  ssUseCodetableFin = ' table.';
  ssCodeWarning     = 'Warning! This text is NOT enciphered.';
  ssNoKey           = 'No valid key found.';
  ssNoTable         = 'No code table selected.';
  ssNoSource        = 'No source text entered.';
  ssNotImplemented  = 'Not implemented yet.';

procedure performEncipher();
procedure performDecipher();

implementation

{$R *.lfm}

{ Tmp_main }
procedure Tmp_main.ShowInStatus(s: string);
begin
  StatusBar.SimpleText := s;
end;


procedure Tmp_main.codetable_chooserChange(Sender: TObject);

begin
  if codetable_chooser.ItemIndex = length(tables) then
  begin
    loadTableExecute(codetable_chooser);
  end
  else
  begin
    curTable := @tables[codetable_chooser.ItemIndex];
  end;
  codetable_description.Caption := curTable^.description;
  codetable_chooser.Text := curTable^.Title; //FIX
end;

procedure Tmp_main.cb_encipher_by_substractionChange(Sender: TObject);
begin
  if cb_encipher_by_substraction.Checked then
    setEncByAdditionTo(False)
  else
    setEncByAdditionTo(True);
end;

procedure Tmp_main.loadTableExecute(Sender: TObject);
var
  filename: string;
begin
  if loadCodetabeFile.Execute then
  begin
    customTable.Init;
    filename := loadCodetabeFile.Filename;
    customTable.createFromFile(filename);
    curTable := @customTable;
  end;
  codetable_description.Caption := curTable^.description;
  codetable_chooser.Text := curTable^.Title; //FIX
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
    view_source.Caption := curTable^.title;
    view_source.memo_src.Lines.Text := curTable^.rawsource;
    view_source.Show();
  end
  else
    ShowMessage(ssNoTable);
end;



procedure Tmp_main.menu_help_aboutClick(Sender: TObject);
begin
  Fabout.ShowModal;
end;

procedure Tmp_main.generatePadExecute(Sender: TObject);
begin
  ShowMessage(ssNotImplemented)
end;

procedure Tmp_main.FormCreate(Sender: TObject);
var
  I: integer;
  MI:TMenuItem;
begin
  ///////////////////STARTUP CLEANUP//////////////////
  //for mac
  {$IFDEF DARWIN}
  begin
    for I := 0 to mp_main.ControlCount - 1 do
    begin
      if (mp_main.Controls[I].ClassType = TButton) then
        mp_main.Controls[I].Height := 22;
    end;
  end;
   {$ENDIF}
  //Add menu item for OTP generator
  {$IFDEF UNIX}
   MI:=TMenuItem.Create(MainMenu1);
   MI.Action:= generatePad;
   mainMenu1.Items[1].Add(MI);
   {$ENDIF}

  //Set the right tabs
  tabs_main.ActivePage := tab_key;
  tabs_result.ActivePage := tab_result_final;
  //Set the checkbox at KEY tab
  if isEncByAddition then
    cb_encipher_by_substraction.Checked := False
  else
    cb_encipher_by_substraction.Checked := True;
  //load tables from resources
  SetLength(Tables, length(rTables));
  for x := 0 to Length(rTables) - 1 do
  begin
    trs := TResourceStream.Create(HInstance, rTables[x], RT_RCDATA);
    tsl := TStringList.Create;
    tsl.LoadFromStream(trs);
    tables[x].CreateFromStrings(tsl);
  end;
  tsl.Free;
  trs.Free;
  //populate drop-down menu
  codetable_chooser.Items.Clear;
  for i := 0 to length(tables) - 1 do
  begin
    codetable_chooser.Items.Add(ssUseCodetable + tables[i].title + ssUseCodetableFin);
  end;
  codetable_chooser.Items.Add(ssLoadCodetable);

end;



//encrypt
procedure performEncipher();
var
  input: string;
  otkey: string;
  encoded: string;
  indicator: string;
  //output:string;
begin
  //prepare key

  otkey := extractNums(mp_main.memo_key.Lines.Text);
  ;
  if otkey = '' then
  begin
    ShowMessage(ssNoKey);
    exit;
  end;
  indicator := copy(otkey, 1, 5);
  otkey := copy(otkey, 6, length(otkey) - 5);
  //check table
  if not assigned(curTable) then
  begin
    ShowMessage(ssNoTable);
    exit;
  end;
  //check source
  input := trim(mp_main.memo_input_text.Lines.Text);
  if input = '' then
  begin
    ShowMessage(ssNoSource);
    exit;
  end;
  //encode
  //ShowMessage(curTable^.Title);
  encoded := curTable^.Encode(input);
  //ShowMessage(encoded);
  mp_main.memo_encoded_text.Lines.Text := SpyGrouping(encoded);
  //encrypt
  mp_main.memo_final_result.Lines.Text :=
    indicator + ' ' + SpyGrouping(Cipher(encoded, otkey, True));
end;

//decrypt
procedure performDecipher();    //TODO:remove repetitions
var
  input: string;
  otkey: string;
  encoded: string;
  indicator: string;
  //output:string;
begin
  //prepare key
  otkey := extractNums(mp_main.memo_key.Lines.Text);
  if otkey = '' then
  begin
    ShowMessage(ssNoKey);
    exit;
  end;
  indicator := copy(otkey, 1, 5);
  otkey := copy(otkey, 6, length(otkey) - 5);
  //check table
  if not assigned(curTable) then
  begin
    ShowMessage(ssNoTable);
    exit;
  end;
  //check source
  input := trim(mp_main.memo_input_text.Lines.Text);
  if input = '' then
  begin
    ShowMessage(ssNoSource);
    exit;
  end;
  //decrypt
  //check indicator
  if (leftstr(input, 5) <> indicator) then
  begin
    ShowMessage('Indicator group do not match the key.');
  end;
  encoded := Cipher(copy(input, 6, length(input) - 5), otkey, False);
  mp_main.memo_encoded_text.Lines.Text := SpyGrouping(encoded);
  //decode
  mp_main.memo_final_result.Lines.Text := curTable^.Decode(encoded);
  // Cipher(encoded, otkey, True);

end;



procedure Tmp_main.menuitem_exitClick(Sender: TObject);
begin
  Halt(0);
end;



end.
