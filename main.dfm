object Form1: TForm1
  Left = 0
  Top = 0
  Caption = 'Form1'
  ClientHeight = 609
  ClientWidth = 941
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
    Left = 256
    Top = 561
    Width = 75
    Height = 25
    Caption = #1054#1090#1082#1088#1099#1090#1100
    TabOrder = 0
    OnClick = Button1Click
  end
  object Memo1: TMemo
    Left = 8
    Top = 8
    Width = 925
    Height = 33
    TabOrder = 1
  end
  object Memo2: TMemo
    Left = 8
    Top = 47
    Width = 925
    Height = 49
    TabOrder = 2
  end
  object Memo3: TMemo
    Left = 8
    Top = 102
    Width = 925
    Height = 97
    TabOrder = 3
  end
  object Edit1: TEdit
    Left = 8
    Top = 224
    Width = 57
    Height = 23
    TabOrder = 4
    Text = 'Edit1'
  end
  object Button2: TButton
    Left = 80
    Top = 223
    Width = 75
    Height = 25
    Caption = 'Button2'
    TabOrder = 5
    OnClick = Button2Click
  end
  object Edit2: TEdit
    Left = 200
    Top = 224
    Width = 233
    Height = 23
    TabOrder = 6
    Text = 'Edit1'
  end
  object Edit3: TEdit
    Left = 439
    Top = 224
    Width = 209
    Height = 23
    TabOrder = 7
    Text = 'Edit1'
  end
  object Edit4: TEdit
    Left = 654
    Top = 224
    Width = 113
    Height = 23
    TabOrder = 8
    Text = 'Edit1'
  end
  object Edit5: TEdit
    Left = 773
    Top = 224
    Width = 113
    Height = 23
    TabOrder = 9
    Text = 'Edit1'
  end
  object Button3: TButton
    Left = 456
    Top = 561
    Width = 113
    Height = 25
    Caption = #1054#1087#1090#1080#1084#1080#1079#1072#1094#1080#1103
    TabOrder = 10
    OnClick = Button3Click
  end
  object Memo4: TMemo
    Left = 8
    Top = 254
    Width = 925
    Height = 259
    TabOrder = 11
  end
  object OpenDialog1: TOpenDialog
    Filter = 'BVN '#1092#1072#1081#1083' Hundegger|*.bvn'
    Left = 16
    Top = 552
  end
end
