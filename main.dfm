object Form1: TForm1
  Left = 0
  Top = 0
  Caption = 'Form1'
  ClientHeight = 609
  ClientWidth = 954
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -12
  Font.Name = 'Segoe UI'
  Font.Style = []
  OnCreate = FormCreate
  OnDestroy = FormDestroy
  TextHeight = 15
  object Label1: TLabel
    Left = 627
    Top = 519
    Width = 145
    Height = 15
    Caption = #1053#1086#1074#1072#1103' '#1089#1090#1088#1086#1082#1072' - Insert'
  end
  object Label2: TLabel
    Left = 627
    Top = 254
    Width = 102
    Height = 15
    Caption = #1044#1083#1080#1085#1085#1099' '#1079#1072#1075#1086#1090#1086#1074#1086#1082
  end
  object Button1: TButton
    Left = 208
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
    Width = 193
    Height = 23
    TabOrder = 6
    Text = 'Edit1'
  end
  object Edit3: TEdit
    Left = 399
    Top = 225
    Width = 162
    Height = 23
    TabOrder = 7
    Text = 'Edit1'
  end
  object Edit4: TEdit
    Left = 567
    Top = 225
    Width = 113
    Height = 23
    TabOrder = 8
    Text = 'Edit1'
  end
  object Edit5: TEdit
    Left = 686
    Top = 225
    Width = 113
    Height = 23
    TabOrder = 9
    Text = 'Edit1'
  end
  object Button3: TButton
    Left = 304
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
    Width = 593
    Height = 259
    TabOrder = 11
  end
  object Button4: TButton
    Left = 605
    Top = 561
    Width = 75
    Height = 25
    Caption = 'Button4'
    TabOrder = 12
    OnClick = Button4Click
  end
  object Edit6: TEdit
    Left = 697
    Top = 562
    Width = 57
    Height = 23
    TabOrder = 13
    Text = 'Edit1'
  end
  object Button5: TButton
    Left = 760
    Top = 561
    Width = 75
    Height = 25
    Caption = 'Button5'
    TabOrder = 14
    OnClick = Button5Click
  end
  object Button6: TButton
    Left = 438
    Top = 561
    Width = 75
    Height = 25
    Caption = #1057#1086#1093#1088#1072#1085#1080#1090#1100
    TabOrder = 15
    OnClick = Button6Click
  end
  object CheckBox1: TCheckBox
    Left = 304
    Top = 528
    Width = 209
    Height = 17
    Caption = #1052#1086#1076#1080#1092#1080#1094#1080#1088#1086#1074#1072#1085#1085#1099#1081' '#1072#1083#1075#1086#1088#1080#1090#1084
    TabOrder = 16
  end
  object ValueListEditor1: TValueListEditor
    Left = 627
    Top = 275
    Width = 306
    Height = 238
    KeyOptions = [keyEdit, keyAdd]
    TabOrder = 17
  end
  object OpenDialog1: TOpenDialog
    Filter = 'BVN '#1092#1072#1081#1083' Hundegger|*.bvn'
    Left = 24
    Top = 552
  end
  object SaveDialog1: TSaveDialog
    DefaultExt = #39'bvn'#39
    Filter = 'BVN|*.bvn'
    Left = 112
    Top = 552
  end
end
