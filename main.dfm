object Form1: TForm1
  Left = 0
  Top = 0
  Caption = 'Form1'
  ClientHeight = 442
  ClientWidth = 628
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -12
  Font.Name = 'Segoe UI'
  Font.Style = []
  OnCreate = FormCreate
  OnDestroy = FormDestroy
  TextHeight = 15
  object Button1: TButton
    Left = 264
    Top = 409
    Width = 75
    Height = 25
    Caption = #1054#1090#1082#1088#1099#1090#1100
    TabOrder = 0
    OnClick = Button1Click
  end
  object Memo1: TMemo
    Left = 32
    Top = 40
    Width = 577
    Height = 49
    TabOrder = 1
  end
  object Memo2: TMemo
    Left = 32
    Top = 112
    Width = 577
    Height = 49
    TabOrder = 2
  end
  object Memo3: TMemo
    Left = 32
    Top = 192
    Width = 577
    Height = 97
    TabOrder = 3
  end
  object Edit1: TEdit
    Left = 32
    Top = 312
    Width = 57
    Height = 23
    TabOrder = 4
    Text = 'Edit1'
  end
  object Button2: TButton
    Left = 104
    Top = 311
    Width = 75
    Height = 25
    Caption = 'Button2'
    TabOrder = 5
    OnClick = Button2Click
  end
  object Edit2: TEdit
    Left = 240
    Top = 312
    Width = 369
    Height = 23
    TabOrder = 6
    Text = 'Edit1'
  end
  object Edit3: TEdit
    Left = 240
    Top = 341
    Width = 369
    Height = 23
    TabOrder = 7
    Text = 'Edit1'
  end
  object OpenDialog1: TOpenDialog
    Filter = 'BVN '#1092#1072#1081#1083' Hundegger|*.bvn'
    Left = 24
    Top = 392
  end
end
