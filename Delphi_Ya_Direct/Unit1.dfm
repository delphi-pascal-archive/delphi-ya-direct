object Form1: TForm1
  Left = 227
  Top = 125
  Width = 1080
  Height = 630
  Caption = 'WebBrowser'
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -14
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  Visible = True
  WindowState = wsMaximized
  OnActivate = FormActivate
  PixelsPerInch = 120
  TextHeight = 16
  object Panel2: TPanel
    Left = 0
    Top = 50
    Width = 1072
    Height = 533
    Align = alClient
    TabOrder = 0
    object WebBrowser1: TWebBrowser
      Left = 1
      Top = 1
      Width = 1070
      Height = 531
      Align = alClient
      TabOrder = 0
      OnDocumentComplete = WebBrowser1DocumentComplete
      ControlData = {
        4C00000078580000E82B00000000000000000000000000000000000000000000
        000000004C000000000000000000000001000000E0D057007335CF11AE690800
        2B2E126208000000000000004C0000000114020000000000C000000000000046
        8000000000000000000000000000000000000000000000000000000000000000
        00000000000000000100000000000000000000000000000000000000}
    end
    object Memo1: TMemo
      Left = 1
      Top = 1
      Width = 1070
      Height = 531
      Align = alClient
      Lines.Strings = (
        'results')
      TabOrder = 1
      Visible = False
    end
  end
  object StatusBar1: TStatusBar
    Left = 0
    Top = 583
    Width = 1072
    Height = 19
    Panels = <>
    SimpleText = '...'
    OnClick = StatusBar1Click
    OnDblClick = StatusBar1DblClick
  end
  object Panel1: TPanel
    Left = 0
    Top = 0
    Width = 1072
    Height = 50
    Align = alTop
    Ctl3D = False
    ParentCtl3D = False
    TabOrder = 2
    OnClick = StatusBar1Click
    OnDblClick = StatusBar1DblClick
    object Label1: TLabel
      Left = 10
      Top = 12
      Width = 61
      Height = 20
      Caption = 'Yandex'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -17
      Font.Name = 'MS Sans Serif'
      Font.Style = [fsBold]
      ParentFont = False
    end
    object Label2: TLabel
      Left = 284
      Top = 14
      Width = 53
      Height = 20
      Caption = 'Begun'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -17
      Font.Name = 'MS Sans Serif'
      Font.Style = [fsBold]
      ParentFont = False
    end
    object Button6: TButton
      Left = 89
      Top = 10
      Width = 60
      Height = 27
      Caption = #1042#1086#1081#1090#1080
      TabOrder = 0
      OnClick = Button6Click
    end
    object Button1: TButton
      Left = 158
      Top = 10
      Width = 92
      Height = 27
      Caption = #1054#1073#1088#1072#1073#1086#1090#1072#1090#1100
      TabOrder = 1
      OnClick = Button1Click
    end
    object Button3: TButton
      Left = 348
      Top = 10
      Width = 61
      Height = 27
      Caption = #1042#1086#1081#1090#1080
      TabOrder = 2
      OnClick = Button3Click
    end
    object Button4: TButton
      Left = 417
      Top = 10
      Width = 93
      Height = 27
      Caption = #1054#1073#1088#1072#1073#1086#1090#1072#1090#1100
      TabOrder = 3
      OnClick = Button7Click
    end
    object ProgressBar1: TProgressBar
      Left = 522
      Top = 16
      Width = 346
      Height = 12
      Max = 10
      Smooth = True
      Step = 1
      TabOrder = 4
      Visible = False
    end
  end
  object IdHTTP1: TIdHTTP
    MaxLineAction = maException
    ReadTimeout = 0
    AllowCookies = True
    ProxyParams.BasicAuthentication = False
    ProxyParams.ProxyPort = 0
    Request.ContentLength = -1
    Request.ContentRangeEnd = 0
    Request.ContentRangeStart = 0
    Request.ContentType = 'text/html'
    Request.Accept = 'text/html, */*'
    Request.BasicAuthentication = False
    Request.UserAgent = 'Mozilla/3.0 (compatible; Indy Library)'
    HTTPOptions = [hoForceEncodeParams]
    Left = 1024
    Top = 9
  end
end
