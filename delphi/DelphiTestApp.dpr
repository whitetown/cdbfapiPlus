program DelphiTestApp;

uses
  Forms,
  main in 'main.pas' {Form1},
  cdbfapiPlus in 'cdbfapiPlus.pas';

{$R *.res}

begin
  Application.Initialize;
  Application.Title := 'Delphi Test App';
  Application.CreateForm(TForm1, Form1);
  Application.Run;
end.
