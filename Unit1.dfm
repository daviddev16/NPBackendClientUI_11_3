object Form1: TForm1
  Left = 0
  Top = 0
  BorderStyle = bsSingle
  Caption = 'Alterdata NPS Client'
  ClientHeight = 499
  ClientWidth = 458
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -12
  Font.Name = 'Segoe UI'
  Font.Style = []
  Scaled = False
  Visible = True
  OnCreate = FormCreate
  TextHeight = 15
  object Button1: TButton
    Left = 0
    Top = 8
    Width = 161
    Height = 25
    Caption = 'Localizar Servi'#231'o na Rede'
    TabOrder = 0
    OnClick = Button1Click
  end
  object MmLog: TMemo
    Left = 0
    Top = 39
    Width = 457
    Height = 89
    ReadOnly = True
    ScrollBars = ssVertical
    TabOrder = 1
  end
  object cmdPanel: TPanel
    Left = 0
    Top = 134
    Width = 457
    Height = 363
    Caption = 'cmdPanel'
    Enabled = False
    TabOrder = 2
    object EdtJsonCmd: TLabeledEdit
      Left = 8
      Top = 34
      Width = 441
      Height = 23
      EditLabel.Width = 154
      EditLabel.Height = 15
      EditLabel.Caption = '(Backend) -> Comando Json:'
      TabOrder = 0
      Text = '{"cmd": "ALTERDATA_WSHOP"}'
    end
    object Button2: TButton
      Left = 8
      Top = 63
      Width = 268
      Height = 25
      Caption = 'Enviar comando para endere'#231'o encontrado'
      TabOrder = 1
      OnClick = Button2Click
    end
    object Memo1: TMemo
      Left = 8
      Top = 94
      Width = 441
      Height = 259
      ReadOnly = True
      ScrollBars = ssVertical
      TabOrder = 2
    end
  end
end
