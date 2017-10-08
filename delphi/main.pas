unit main;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, cdbfapiPlus, Grids, ExtCtrls;

type
  TForm1 = class(TForm)
    OpenDialog1: TOpenDialog;
    DrawGrid1: TDrawGrid;
    Panel1: TPanel;
    Button1: TButton;
    Label1: TLabel;
    procedure Button1Click(Sender: TObject);
    procedure DrawGrid1DrawCell(Sender: TObject; ACol, ARow: Integer;
      Rect: TRect; State: TGridDrawState);
  private
    { Private declarations }
    dbf: TcdbfapiPlus;

    procedure RefreshData;
  public
    { Public declarations }
  end;

var
  Form1: TForm1;

implementation

{$R *.dfm}

procedure TForm1.Button1Click(Sender: TObject);
begin
    if OpenDialog1.Execute then
    begin
        if (dbf <> nil) then
        begin
            dbf.closeDBFfile;
            dbf := nil;
            RefreshData;
        end;

        dbf := TcdbfapiPlus.Create;
        if dbf.openDBFfile(OpenDialog1.FileName) then
        begin
            Label1.Caption := OpenDialog1.FileName;
            RefreshData;
        end
        else
        begin
            Label1.Caption := 'No file';
            dbf := nil;
            RefreshData;
        end;
    end;
end;

procedure TForm1.RefreshData;
begin
    if (dbf = nil) then
    begin
        DrawGrid1.colCount := 2;
        DrawGrid1.RowCount := 2;
    end
    else
    begin
        DrawGrid1.colCount := dbf.fieldCount + 1;
        DrawGrid1.RowCount := dbf.recCount + 1;
    end;

    DrawGrid1.Refresh;
end;

procedure TForm1.DrawGrid1DrawCell(Sender: TObject; ACol, ARow: Integer;
  Rect: TRect; State: TGridDrawState);
var
   text :String;
begin
   if dbf = nil then exit;

   DrawGrid1.Canvas.FillRect(rect);

   if ACol = 0 then
   begin
      if ARow = 0 then exit;

      text := inttostr(ARow);

      DrawText( DrawGrid1.Canvas.Handle,
        PChar(text),
        length(text),
        rect,
        DT_VCENTER or DT_NOPREFIX or DT_SINGLELINE or DT_CENTER	 );

       exit;
   end;

   if ARow = 0 then
   begin
      text := dbf.fieldName(ACol-1);

      DrawText( DrawGrid1.Canvas.Handle,
        PChar(text),
        length(text),
        rect,
        DT_VCENTER or DT_NOPREFIX or DT_SINGLELINE or DT_CENTER	 );

        exit;
   end;

      dbf.getRecord(ARow-1);

      text := dbf.getString(ACol-1);

      DrawText( DrawGrid1.Canvas.Handle,
        PChar(text),
        length(text),
        rect,
        DT_VCENTER or DT_NOPREFIX or DT_SINGLELINE	 );


end;

end.
