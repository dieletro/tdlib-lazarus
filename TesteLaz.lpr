program TesteLaz;

{$mode objfpc}{$H+}

uses
  //ShareMem,
  {$IFDEF UNIX}{$IFDEF UseCThreads}
  cthreads,
  {$ENDIF}{$ENDIF}
  Interfaces, // this includes the LCL widgetset
  Forms,
  LazTeste;

{$R *.res}

begin
  RequireDerivedFormResource:=True;
  Application.Scaled:=True;
  Application.Initialize;
  Application.CreateForm(TfrmLazteste, frmLazteste);
  Application.Run;
end.

