object frmResult: TfrmResult
  Left = 0
  Top = 0
  AutoScroll = False
  BorderIcons = [biSystemMenu, biMaximize]
  Caption = #26908#32034#32080#26524
  ClientHeight = 428
  ClientWidth = 651
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  KeyPreview = True
  OldCreateOrder = False
  OnKeyDown = FormKeyDown
  OnShow = FormShow
  DesignSize = (
    651
    428)
  PixelsPerInch = 96
  TextHeight = 13
  object pnl: TPanel
    Left = -1
    Top = 388
    Width = 652
    Height = 41
    Anchors = [akLeft, akRight, akBottom]
    TabOrder = 1
    DesignSize = (
      652
      41)
    object Button1: TButton
      Left = 175
      Top = 8
      Width = 100
      Height = 25
      Anchors = [akLeft, akBottom]
      Caption = #12463#12522#12483#12503#12508#12540#12489#12395#12467#12500#12540
      TabOrder = 2
      OnClick = Button1Click
    end
    object Button2: TButton
      Left = 504
      Top = 8
      Width = 111
      Height = 25
      Anchors = [akLeft, akBottom]
      Caption = #38281#12376#12427
      TabOrder = 5
      OnClick = Button2Click
    end
    object Button3: TButton
      Left = 10
      Top = 8
      Width = 70
      Height = 25
      Anchors = [akLeft, akBottom]
      Caption = #20840#37096'ON'
      TabOrder = 0
      OnClick = CheckListCheckChange
    end
    object Button4: TButton
      Left = 87
      Top = 8
      Width = 70
      Height = 25
      Anchors = [akLeft, akBottom]
      Caption = #20840#37096'OFF'
      TabOrder = 1
      OnClick = CheckListCheckChange
    end
    object Button5: TButton
      Left = 280
      Top = 8
      Width = 100
      Height = 25
      Anchors = [akLeft, akBottom]
      Caption = #12501#12449#12452#12523#12395#20445#23384
      TabOrder = 3
      OnClick = Button5Click
    end
    object Button6: TButton
      Left = 384
      Top = 8
      Width = 100
      Height = 25
      Anchors = [akLeft, akBottom]
      Caption = #12467#12500#12540
      TabOrder = 4
      OnClick = Button6Click
    end
  end
  object CheckListBox1: TCheckListBox
    Left = 0
    Top = 0
    Width = 649
    Height = 385
    Anchors = [akLeft, akTop, akRight, akBottom]
    Font.Charset = ANSI_CHARSET
    Font.Color = clWindowText
    Font.Height = -15
    Font.Name = #65325#65331' '#12468#12471#12483#12463
    Font.Style = []
    ItemHeight = 15
    ParentFont = False
    TabOrder = 0
  end
end
