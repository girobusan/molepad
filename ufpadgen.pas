unit ufpadgen;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, FileUtil, Forms, Controls, Graphics, Dialogs, StdCtrls,
  Spin, ExtCtrls,
  padgenlib;

type

  { Tpad_gen }

  Tpad_gen = class(TForm)
    padgen_second_label: TLabel;
    padgenClose: TButton;
    padgen_generate: TButton;
    label_pages: TLabel;
    lines_label: TLabel;
    pad_save: TSaveDialog;
    num_pages: TSpinEdit;
    num_lines: TSpinEdit;
    padgen_lines_panel: TPanel;
    panel_pages: TPanel;

    procedure padgenCloseClick(Sender: TObject);
    procedure padgen_generateClick(Sender: TObject);
    procedure padgen_second_labelClick(Sender: TObject);
  private
    { private declarations }
  public
    { public declarations }
  end;

var
  pad_gen: Tpad_gen;

resourcestring
  ssReady = 'OTP saved.';
  ssFileOops = 'Cant'' write to file.';
  ssCantMakePad = 'Can not generate the pad.';

implementation

{$R *.lfm}

{ Tpad_gen }



procedure Tpad_gen.padgenCloseClick(Sender: TObject);
begin
  Close;
end;

procedure Tpad_gen.padgen_generateClick(Sender: TObject);
var
  fname: string;
  fout: TextFile;
  pad: string;
begin
  if pad_save.Execute then
  begin
    fname := pad_save.Filename;
    AssignFile(fout, fname);
    Rewrite(fout);
    pad := CreatePad(num_pages.Value, num_lines.Value);
    if pad <> '' then
      Write(fout, pad) //FIX NEEDED
    else
      begin
      ShowMessage(ssCantMakePad);
      CloseFile(fout);
      Exit
      end;
    CloseFile(fout);
    ShowMessage(ssReady);
    Close
  end
  else
    ShowMessage(ssFileOops);
end;

procedure Tpad_gen.padgen_second_labelClick(Sender: TObject);
begin

end;


end.
