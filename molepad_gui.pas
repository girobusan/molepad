unit molepad_gui;

{$mode objfpc}{$H+}

interface




uses
  Classes, SysUtils, FileUtil, Forms, Controls, Graphics, Dialogs, Menus,
  OTPcipher, ucheckerboard,
  ComCtrls, StdCtrls, ExtCtrls;
var
  curtable:TCodeTable;
  tables : array[1..2] of TCodeTable;
  trs    : TResourceStream;
  tsl    : TStringList;
  i:integer;

type

  { Tmp_main }

  Tmp_main = class(TForm)
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
    menu_file: TMenuItem;
    menuitem_exit: TMenuItem;
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
    procedure cb_encrypt_by_substractionChange(Sender: TObject);
    procedure codetable_chooserChange(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure memo_input_textChange(Sender: TObject);
    procedure menuitem_exitClick(Sender: TObject);
  private
    { private declarations }
  public
    { public declarations }
  end;

var
  mp_main: Tmp_main;

resourcestring

ssLoadCodetable='Load table from file';

implementation

{$R *.lfm}

{ Tmp_main }

procedure Tmp_main.codetable_chooserChange(Sender: TObject);
begin
  if codetable_chooser.ItemIndex=length(tables) then
  begin
    //codetable_description.caption:='No description';
    ShowMessage('Not implemented');
    //exit;
  end
  else
  begin
  curTable:=tables[codetable_chooser.ItemIndex + 1];
  codetable_description.caption:=curTable.description;
  end;
  codetable_chooser.text:= curTable.Title //FIX
end;

procedure Tmp_main.cb_encrypt_by_substractionChange(Sender: TObject);
begin
  if cb_encrypt_by_substraction.checked then setEncByAdditionTo(False)
  else setEncByAdditionTo(True)
end;

procedure Tmp_main.FormCreate(Sender: TObject);
begin
  //Set the checkbox at KEY tab
  if not isEncByAddition then cb_encrypt_by_substraction.checked:=False
  else cb_encrypt_by_substraction.checked:=True;
  //populate drop-down with encoding tables
  //SONET-C
   trs := TResourceStream.Create(HInstance, 'SONET-C', RT_RCDATA);
   tsl:= TStringList.Create;
   tsl.LoadFromStream(trs);
   tables[1].CreateFromStrings(tsl);
   tsl.free;
   //SONET-L (FIX)
   trs := TResourceStream.Create(HInstance, 'SONET-L', RT_RCDATA);
   tsl:= TStringList.Create;
   tsl.LoadFromStream(trs);
   tables[2].CreateFromStrings(tsl);
   tsl.free;

   codetable_chooser.Items.Clear;
   for i:=1 to length(tables) do
   begin
     codetable_chooser.Items.Add(tables[i].title);
   end;
     codetable_chooser.Items.Add(ssLoadCodetable);


end;

procedure Tmp_main.memo_input_textChange(Sender: TObject);
begin

end;

procedure Tmp_main.menuitem_exitClick(Sender: TObject);
begin
  Halt(0);
end;

end.

