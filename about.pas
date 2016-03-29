unit about;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, FileUtil, Forms, Controls, Graphics, Dialogs, StdCtrls,
  ExtCtrls;

type

  { TFabout }

  TFabout = class(TForm)
    Button_close: TButton;
    ProgIcon: TImage;
    ProgTitle: TLabel;
    ProgDescription: TLabel;
    ProgVersion: TLabel;
    procedure Button_closeClick(Sender: TObject);

  private
    { private declarations }
  public
    { public declarations }
  end;

var
  Fabout: TFabout;

implementation

{$R *.lfm}

{ TFabout }

procedure TFabout.Button_closeClick(Sender: TObject);
begin
  Close;
end;




end.

