object Form3: TForm3
  Left = 0
  Top = 0
  BorderIcons = [biSystemMenu]
  BorderStyle = bsSingle
  Caption = 'File'#26908#32034
  ClientHeight = 404
  ClientWidth = 421
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  KeyPreview = True
  Menu = MainMenu1
  OldCreateOrder = False
  OnClose = FormClose
  OnCreate = FormCreate
  OnKeyDown = FormKeyDown
  PixelsPerInch = 96
  TextHeight = 13
  object Button1: TButton
    Left = 290
    Top = 327
    Width = 121
    Height = 25
    Caption = #12469#12540#12481
    TabOrder = 4
    OnClick = Button1Click
  end
  object GroupBox1: TGroupBox
    Left = 7
    Top = 8
    Width = 411
    Height = 281
    Caption = #25313#24373#23376#12398#25351#23450
    TabOrder = 0
    object edtKakuchosiAdd: TEdit
      Left = 8
      Top = 251
      Width = 121
      Height = 21
      ImeMode = imDisable
      TabOrder = 0
      OnKeyPress = edtKakuchosiAddKeyPress
    end
    object Button3: TButton
      Left = 135
      Top = 251
      Width = 75
      Height = 25
      Caption = #36861#21152
      TabOrder = 1
      OnClick = Button3Click
    end
    object CheckListBox1: TCheckListBox
      Left = 6
      Top = 16
      Width = 291
      Height = 229
      ItemHeight = 13
      TabOrder = 4
    end
    object Button4: TButton
      Left = 229
      Top = 251
      Width = 75
      Height = 25
      Caption = #20840#37096'ON'
      TabOrder = 2
      OnClick = CheckListCheckChange
    end
    object Button5: TButton
      Left = 310
      Top = 251
      Width = 75
      Height = 25
      Caption = #20840#37096'OFF'
      TabOrder = 3
      OnClick = CheckListCheckChange
    end
    object CheckListBox2: TCheckListBox
      Left = 304
      Top = 16
      Width = 97
      Height = 229
      OnClickCheck = CheckListBox2ClickCheck
      ItemHeight = 13
      TabOrder = 5
    end
  end
  object GroupBox2: TGroupBox
    Left = 8
    Top = 295
    Width = 273
    Height = 98
    Caption = #22793#26356#26085#20184#12398#25351#23450
    TabOrder = 1
    object Label1: TLabel
      Left = 29
      Top = 65
      Width = 12
      Height = 13
      Caption = #65374
    end
    object CheckBox1: TCheckBox
      Left = 14
      Top = 21
      Width = 223
      Height = 17
      Caption = #22793#26356#26085#20184#12399#25351#23450#12375#12394#12356
      TabOrder = 0
      OnClick = CheckBox1Click
    end
    object fromDateTimePicker1: TDateTimePicker
      Left = 9
      Top = 44
      Width = 120
      Height = 21
      Date = 0.717518564822967200
      Time = 0.717518564822967200
      DateFormat = dfLong
      ImeMode = imDisable
      TabOrder = 1
      OnChange = DateTimePickersClick
    end
    object toDateTimePicker1: TDateTimePicker
      Left = 46
      Top = 68
      Width = 120
      Height = 21
      Date = 40199.717518564820000000
      Time = 40199.717518564820000000
      DateFormat = dfLong
      ImeMode = imDisable
      TabOrder = 3
      OnChange = DateTimePickersClick
    end
    object fromDateTimePicker2: TDateTimePicker
      Left = 137
      Top = 44
      Width = 86
      Height = 21
      Date = 0.717518564822967200
      Time = 0.717518564822967200
      ImeMode = imDisable
      Kind = dtkTime
      TabOrder = 2
      OnChange = DateTimePickersClick
    end
    object toDateTimePicker2: TDateTimePicker
      Left = 167
      Top = 68
      Width = 86
      Height = 21
      Date = 40199.717518564820000000
      Time = 40199.717518564820000000
      ImeMode = imDisable
      Kind = dtkTime
      TabOrder = 4
      OnChange = DateTimePickersClick
    end
  end
  object Button2: TButton
    Left = 290
    Top = 353
    Width = 121
    Height = 25
    Caption = #32066#20102
    TabOrder = 5
    OnClick = Button2Click
  end
  object CheckBox6: TCheckBox
    Left = 288
    Top = 308
    Width = 121
    Height = 17
    Caption = '\'#12376#12419#12394#12367#12390'/'#12364#12356#12356
    Checked = True
    State = cbChecked
    TabOrder = 3
  end
  object CheckBox2: TCheckBox
    Left = 288
    Top = 291
    Width = 129
    Height = 17
    Caption = 'java'#12434'class'#12395#32622#12365#25563#12360
    Checked = True
    State = cbChecked
    TabOrder = 2
  end
  object MainMenu1: TMainMenu
    Left = 200
    Top = 200
    object mnuFile: TMenuItem
      Caption = #12501#12449#12452#12523
      ShortCut = 49222
      object mnuSave: TMenuItem
        Caption = #20445#23384
        OnClick = mnuSaveClick
      end
      object mnuLoad: TMenuItem
        Caption = #35501#36796
        OnClick = mnuLoadClick
      end
      object mnuClose: TMenuItem
        Caption = #38281#12376#12427
        OnClick = mnuCloseClick
      end
    end
  end
end
