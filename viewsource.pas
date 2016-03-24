unit viewsource;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, FileUtil, Forms, Controls, Graphics, Dialogs, StdCtrls;

type

  { Tview_source }

  Tview_source = class(TForm)
    close_vs: TButton;
    memo_src: TMemo;
    procedure close_vsClick(Sender: TObject);
  private
    { private declarations }
  public
    { public declarations }
  end;

var
  view_source: Tview_source;

implementation

{$R *.lfm}

{ Tview_source }

procedure Tview_source.close_vsClick(Sender: TObject);
begin
  Close;
end;

end.

