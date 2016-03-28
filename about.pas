unit about;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, FileUtil, Forms, Controls, Graphics, Dialogs, StdCtrls,
  ExtCtrls;

type

  { TFabout }

  TFabout = class(TForm)
    Button1: TButton;
    Image1: TImage;
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    procedure Button1Click(Sender: TObject);

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

procedure TFabout.Button1Click(Sender: TObject);
begin
  Close;
end;




end.

