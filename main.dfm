object Form1: TForm1
  Left = 0
  Top = 0
  Caption = #1054#1087#1090#1080#1084#1080#1079#1072#1090#1086#1088' CadworkOptimizer'
  ClientHeight = 619
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
    Top = 540
    Width = 212
    Height = 15
    Caption = #1053#1086#1074#1072#1103' '#1089#1090#1088#1086#1082#1072' - Insert '#1080#1083#1080' '#1089#1090#1088#1077#1083#1082#1072' '#1074#1085#1080#1079
  end
  object Label2: TLabel
    Left = 627
    Top = 233
    Width = 102
    Height = 15
    Caption = #1044#1083#1080#1085#1085#1099' '#1079#1072#1075#1086#1090#1086#1074#1086#1082
  end
  object Label3: TLabel
    Left = 8
    Top = 160
    Width = 34
    Height = 15
    Caption = 'Label3'
  end
  object Label4: TLabel
    Left = 8
    Top = 233
    Width = 119
    Height = 15
    Caption = #1054#1082#1085#1086' '#1074#1099#1074#1086#1076#1072' '#1076#1072#1085#1085#1099#1093':'
  end
  object Label5: TLabel
    Left = 112
    Top = 192
    Width = 65
    Height = 15
    Caption = #1048#1079#1076#1077#1083#1080#1077' '#8470' '
  end
  object Label6: TLabel
    Left = 192
    Top = 192
    Width = 54
    Height = 15
    Caption = '                  '
  end
  object Label7: TLabel
    Left = 323
    Top = 192
    Width = 39
    Height = 15
    Caption = '             '
  end
  object Label8: TLabel
    Left = 264
    Top = 192
    Width = 45
    Height = 15
    Caption = #1044#1083#1080#1085#1085#1072':'
  end
  object Label9: TLabel
    Left = 382
    Top = 192
    Width = 71
    Height = 15
    Caption = #1050#1086#1083#1080#1095#1077#1089#1090#1074#1086': '
  end
  object Label10: TLabel
    Left = 472
    Top = 192
    Width = 42
    Height = 15
    Caption = '              '
  end
  object Label11: TLabel
    Left = 552
    Top = 192
    Width = 83
    Height = 15
    Caption = #1050#1086#1084#1084#1077#1085#1090#1072#1088#1080#1081': '
  end
  object Label12: TLabel
    Left = 653
    Top = 192
    Width = 33
    Height = 15
    Caption = '           '
  end
  object Label13: TLabel
    Left = 448
    Top = 581
    Width = 59
    Height = 15
    Caption = #1054#1090#1087#1080#1083', '#1084#1084
  end
  object Label14: TLabel
    Left = 8
    Top = 540
    Width = 562
    Height = 15
    Caption = 
      'F - '#1087#1077#1088#1074#1086#1077' '#1080#1079#1076#1077#1083#1080#1077' '#1074' '#1088#1072#1089#1082#1088#1086#1077', M - '#1076#1086#1073#1072#1074#1083#1077#1085#1085#1099#1077' '#1080#1079#1076#1077#1083#1080#1103' ('#1084#1086#1076#1080#1092'. '#1072#1083 +
      #1075'), '#1054' - '#1086#1087#1090#1080#1084#1080#1079#1080#1088#1086#1074#1072#1085#1085#1086#1077' '#1080#1079#1076#1077#1083#1080#1077
  end
  object Button1: TButton
    Left = 8
    Top = 577
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
    Height = 43
    TabOrder = 3
  end
  object Button3: TButton
    Left = 104
    Top = 577
    Width = 113
    Height = 25
    Caption = #1054#1087#1090#1080#1084#1080#1079#1072#1094#1080#1103
    TabOrder = 4
    OnClick = Button3Click
  end
  object Memo4: TMemo
    Left = 8
    Top = 254
    Width = 593
    Height = 280
    ScrollBars = ssBoth
    TabOrder = 5
  end
  object Button4: TButton
    Left = 714
    Top = 151
    Width = 75
    Height = 25
    Caption = 'Button4'
    TabOrder = 6
    OnClick = Button4Click
  end
  object Edit6: TEdit
    Left = 795
    Top = 153
    Width = 57
    Height = 23
    TabOrder = 7
    Text = 'Edit1'
  end
  object Button5: TButton
    Left = 858
    Top = 151
    Width = 75
    Height = 25
    Caption = 'Button5'
    TabOrder = 8
    OnClick = Button5Click
  end
  object Button6: TButton
    Left = 858
    Top = 577
    Width = 75
    Height = 25
    Caption = #1057#1086#1093#1088#1072#1085#1080#1090#1100
    TabOrder = 9
    OnClick = Button6Click
  end
  object CheckBox1: TCheckBox
    Left = 240
    Top = 581
    Width = 194
    Height = 17
    Caption = #1052#1086#1076#1080#1092#1080#1094#1080#1088#1086#1074#1072#1085#1085#1099#1081' '#1072#1083#1075#1086#1088#1080#1090#1084
    Checked = True
    State = cbChecked
    TabOrder = 10
  end
  object ValueListEditor1: TValueListEditor
    Left = 627
    Top = 254
    Width = 306
    Height = 156
    KeyOptions = [keyEdit, keyAdd]
    TabOrder = 11
    TitleCaptions.Strings = (
      #1044#1083#1080#1085#1085#1072
      #1050#1086#1083#1080#1095#1077#1089#1090#1074#1086)
  end
  object Button7: TButton
    Left = 724
    Top = 577
    Width = 115
    Height = 25
    Caption = #1055#1077#1095#1072#1090#1100' '#1090#1072#1073#1083#1080#1095#1077#1082
    TabOrder = 12
    OnClick = Button7Click
  end
  object BitBtn1: TBitBtn
    Left = 8
    Top = 188
    Width = 33
    Height = 25
    Glyph.Data = {
      36030000424D3603000000000000360000002800000010000000100000000100
      18000000000000030000C40E0000C40E00000000000000000000FFFFFFFFFFFF
      FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
      FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
      FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
      FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
      FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
      FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
      FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFCFCFCFCFCFCFFFFFFFFFFFFFFFF
      FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
      FFFF707070D4D4D4FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
      FFFFFFFFFFFFFFFFFFF4F4F4AFAFAF0B0B0B000000C3C3C3FFFFFFFFFFFFFFFF
      FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFE3E3E35050501C1C1C00
      0000000000C3C3C3FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
      FFFFFFFFFFFF0B0B0B010101000000000000000000C3C3C3FFFFFFFFFFFFFFFF
      FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFB6B6B683838300000000
      0000000000C3C3C3FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
      FFFFFFFFFFFFFFFFFFFFFFFF9E9E9E191919000000C3C3C3FFFFFFFFFFFFFFFF
      FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFD4
      D4D4636363CACACAFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
      FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
      FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
      FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
      FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
      FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
      FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF}
    TabOrder = 13
    OnClick = BitBtn1Click
  end
  object BitBtn2: TBitBtn
    Left = 58
    Top = 188
    Width = 32
    Height = 25
    Glyph.Data = {
      36030000424D3603000000000000360000002800000010000000100000000100
      18000000000000030000C40E0000C40E00000000000000000000FFFFFFFFFFFF
      FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
      FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
      FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
      FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
      FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFCFCFCFF
      FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
      FFFFFFFFFFFFFFFFFFFEFEFE969696C6C6C6FAFAFAFFFFFFFFFFFFFFFFFFFFFF
      FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFEFEFE7070700B
      0B0B7B7B7BD5D5D5FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
      FFFFFFFFFFFFFFFFFFFEFEFE707070000000000000161616AEAEAEF7F7F7FFFF
      FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFEFEFE70707000
      0000000000000000080808424242FAFAFAFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
      FFFFFFFFFFFFFFFFFFFEFEFE7070700000000000000303034F4F4FCDCDCDFEFE
      FEFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFEFEFE70707000
      00000E0E0EB3B3B3F3F3F3FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
      FFFFFFFFFFFFFFFFFFFEFEFE7D7D7D646464E7E7E7FEFEFEFFFFFFFFFFFFFFFF
      FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFE8E8E8FE
      FEFEFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
      FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
      FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
      FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
      FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
      FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
      FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF}
    TabOrder = 14
    OnClick = BitBtn2Click
  end
  object Edit1: TEdit
    Left = 671
    Top = 153
    Width = 37
    Height = 23
    TabOrder = 15
    Text = 'Edit1'
  end
  object Edit2: TEdit
    Left = 529
    Top = 578
    Width = 72
    Height = 23
    TabOrder = 16
    Text = '6'
  end
  object ValueListEditor2: TValueListEditor
    Left = 627
    Top = 416
    Width = 306
    Height = 118
    KeyOptions = [keyEdit, keyAdd]
    TabOrder = 17
    TitleCaptions.Strings = (
      #1044#1083#1080#1085#1085#1072
      #1050#1086#1083#1080#1095#1077#1089#1090#1074#1086)
  end
  object CheckBox2: TCheckBox
    Left = 739
    Top = 213
    Width = 126
    Height = 17
    Caption = #1042#1090#1086#1088#1086#1081' '#1089#1087#1080#1089#1086#1082' '#1089' '
    TabOrder = 18
  end
  object Edit3: TEdit
    Left = 865
    Top = 210
    Width = 68
    Height = 23
    TabOrder = 19
    Text = '5'
  end
  object OpenDialog1: TOpenDialog
    Filter = 'BVN '#1092#1072#1081#1083' Hundegger|*.bvn'
    Left = 864
  end
  object SaveDialog1: TSaveDialog
    DefaultExt = #39'bvn'#39
    Filter = 'BVN|*.bvn'
    Left = 904
  end
end
