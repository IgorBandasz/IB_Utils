object frmInstalar: TfrmInstalar
  Left = 0
  Top = 0
  Caption = 'Instalador IB Utils'
  ClientHeight = 299
  ClientWidth = 333
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  PixelsPerInch = 96
  TextHeight = 13
  object btnInstalar: TButton
    Left = 136
    Top = 80
    Width = 75
    Height = 25
    Caption = 'Instalar'
    TabOrder = 0
    OnClick = btnInstalarClick
  end
  object btnDesinstalar: TButton
    Left = 136
    Top = 176
    Width = 75
    Height = 25
    Caption = 'Desinstalar'
    TabOrder = 1
    OnClick = btnDesinstalarClick
  end
end
