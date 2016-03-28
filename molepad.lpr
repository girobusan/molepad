program molepad;

{$mode objfpc}{$H+}

uses
  {$IFDEF UNIX}{$IFDEF UseCThreads}
  cthreads,
  {$ENDIF}{$ENDIF}
  Interfaces, // this includes the LCL widgetset
  Forms, molepad_gui, otherstrings, viewsource, about
  { you can add units after this };

{$R *.res}

begin
  RequireDerivedFormResource:=True;
  Application.Initialize;
  Application.CreateForm(Tmp_main, mp_main);
  Application.CreateForm(Tview_source, view_source);
  Application.CreateForm(TFabout, Fabout);
  Application.Run;
end.

