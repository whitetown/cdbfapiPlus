object Form1: TForm1
  Left = 266
  Top = 124
  Width = 928
  Height = 480
  Caption = 'cdbfapiPlus demo'
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  Position = poDefault
  PixelsPerInch = 96
  TextHeight = 13
  object DrawGrid1: TDrawGrid
    Left = 0
    Top = 41
    Width = 912
    Height = 401
    Align = alClient
    ColCount = 2
    RowCount = 2
    Options = [goFixedVertLine, goFixedHorzLine, goVertLine, goHorzLine, goRangeSelect, goColSizing, goThumbTracking]
    TabOrder = 0
    OnDrawCell = DrawGrid1DrawCell
  end
  object Panel1: TPanel
    Left = 0
    Top = 0
    Width = 912
    Height = 41
    Align = alTop
    TabOrder = 1
    object Label1: TLabel
      Left = 96
      Top = 16
      Width = 30
      Height = 13
      Caption = 'No file'
    end
    object Button1: TButton
      Left = 8
      Top = 8
      Width = 75
      Height = 25
      Caption = 'Open'
      TabOrder = 0
      OnClick = Button1Click
    end
  end
  object OpenDialog1: TOpenDialog
    DefaultExt = 'dbf'
    Filter = 'DBF files|*.dbf'
    Left = 144
    Top = 8
  end
end
