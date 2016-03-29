unit viewsource;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, FileUtil, Forms, Controls, Graphics, Dialogs, StdCtrls;

type

  { Tview_source }

  Tview_source = class(TForm)
    button_close: TButton;
    memo_src: TMemo;
    procedure button_closeClick(Sender: TObject);
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

procedure Tview_source.button_closeClick(Sender: TObject);
begin
  Close;
end;

end.

