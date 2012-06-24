object frmPregress: TfrmPregress
  Left = 0
  Top = 0
  BorderIcons = []
  BorderStyle = bsNone
  ClientHeight = 117
  ClientWidth = 340
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  Position = poDesktopCenter
  OnShow = FormShow
  PixelsPerInch = 96
  TextHeight = 13
  object Panel1: TPanel
    Left = 0
    Top = 0
    Width = 337
    Height = 201
    TabOrder = 0
    object lblTitle: TLabel
      Left = 0
      Top = 0
      Width = 337
      Height = 57
      Alignment = taCenter
      AutoSize = False
      Color = clSkyBlue
      Font.Charset = SHIFTJIS_CHARSET
      Font.Color = clWindowText
      Font.Height = -27
      Font.Name = #65325#65331' '#12468#12471#12483#12463
      Font.Style = []
      ParentColor = False
      ParentFont = False
    end
    object lblFooter: TLabel
      Left = 0
      Top = 96
      Width = 337
      Height = 21
      Alignment = taRightJustify
      AutoSize = False
      Color = clSkyBlue
      Font.Charset = ANSI_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = #65325#65331' '#12468#12471#12483#12463
      Font.Style = []
      ParentColor = False
      ParentFont = False
    end
    object ProgressBar1: TProgressBar
      Left = 0
      Top = 56
      Width = 337
      Height = 41
      Smooth = True
      Step = 0
      TabOrder = 0
    end
  end
  object Timer1: TTimer
    Interval = 50
    OnTimer = Timer1Timer
    Left = 256
    Top = 72
  end
end
