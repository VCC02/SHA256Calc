object frmSHA256CalcMain: TfrmSHA256CalcMain
  Left = 350
  Height = 185
  Top = 268
  Width = 782
  Caption = 'SHA256 Calculator'
  ClientHeight = 185
  ClientWidth = 782
  Constraints.MaxHeight = 200
  Constraints.MinHeight = 185
  Constraints.MinWidth = 782
  Font.Quality = fqAntialiased
  OnCreate = FormCreate
  LCLVersion = '6.1'
  object btnLoadFile: TButton
    Left = 8
    Height = 25
    Top = 16
    Width = 107
    Caption = 'Load File...'
    Font.Quality = fqCleartypeNatural
    OnClick = btnLoadFileClick
    ParentFont = False
    TabOrder = 0
  end
  object prbShaProcessing: TProgressBar
    Left = 8
    Height = 20
    Top = 48
    Width = 770
    Anchors = [akTop, akLeft, akRight]
    TabOrder = 1
    Visible = False
  end
  object lbeHash: TLabeledEdit
    Left = 8
    Height = 24
    Top = 96
    Width = 770
    Anchors = [akTop, akLeft, akRight]
    EditLabel.AnchorSideLeft.Control = lbeHash
    EditLabel.AnchorSideRight.Control = lbeHash
    EditLabel.AnchorSideRight.Side = asrBottom
    EditLabel.AnchorSideBottom.Control = lbeHash
    EditLabel.Left = 8
    EditLabel.Height = 18
    EditLabel.Top = 75
    EditLabel.Width = 770
    EditLabel.Caption = 'Hash'
    EditLabel.ParentColor = False
    Font.Quality = fqCleartypeNatural
    ParentFont = False
    ReadOnly = True
    TabOrder = 2
  end
  object chkDisplayAsLowerCase: TCheckBox
    Left = 623
    Height = 21
    Top = 72
    Width = 155
    Anchors = [akTop, akRight]
    Caption = 'Display As Lower Case'
    Font.Quality = fqCleartypeNatural
    OnChange = chkDisplayAsLowerCaseChange
    ParentFont = False
    TabOrder = 3
  end
  object lbeFile: TLabeledEdit
    Left = 8
    Height = 24
    Top = 152
    Width = 770
    Anchors = [akTop, akLeft, akRight]
    EditLabel.AnchorSideLeft.Control = lbeFile
    EditLabel.AnchorSideRight.Control = lbeFile
    EditLabel.AnchorSideRight.Side = asrBottom
    EditLabel.AnchorSideBottom.Control = lbeFile
    EditLabel.Left = 8
    EditLabel.Height = 18
    EditLabel.Top = 131
    EditLabel.Width = 770
    EditLabel.Caption = 'File'
    EditLabel.ParentColor = False
    Font.Quality = fqCleartypeNatural
    ParentFont = False
    ReadOnly = True
    TabOrder = 4
  end
  object btnStop: TButton
    Left = 144
    Height = 25
    Top = 16
    Width = 104
    Caption = 'Stop'
    Font.Quality = fqCleartypeNatural
    OnClick = btnStopClick
    ParentFont = False
    TabOrder = 5
    Visible = False
  end
  object edtCredits: TEdit
    Left = 264
    Height = 24
    Hint = 'Credits'
    Top = 13
    Width = 512
    Anchors = [akTop, akLeft, akRight]
    Color = clBtnFace
    Font.Quality = fqCleartypeNatural
    ParentFont = False
    ParentShowHint = False
    ReadOnly = True
    ShowHint = True
    TabOrder = 6
    Text = 'Uses DCPcrypt from http://www.cityinthesky.co.uk/opensource/dcpcrypt/'
  end
  object OpenDialog1: TOpenDialog
    Left = 312
    Top = 40
  end
  object tmrUpdateProgressBar: TTimer
    Enabled = False
    Interval = 10
    OnTimer = tmrUpdateProgressBarTimer
    Left = 176
    Top = 40
  end
  object tmrStartup: TTimer
    Enabled = False
    Interval = 10
    OnTimer = tmrStartupTimer
    Left = 416
    Top = 40
  end
end
