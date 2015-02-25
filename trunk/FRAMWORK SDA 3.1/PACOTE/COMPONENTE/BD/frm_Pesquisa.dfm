object frmPesquisa: TfrmPesquisa
  Left = 404
  Top = 151
  BorderStyle = bsSizeToolWin
  Caption = 'frmPesquisa'
  ClientHeight = 401
  ClientWidth = 635
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  OnActivate = FormActivate
  OnClose = FormClose
  PixelsPerInch = 96
  TextHeight = 13
  object pnlPesquisa: TPanel
    Left = 0
    Top = 0
    Width = 635
    Height = 81
    Align = alTop
    BevelInner = bvLowered
    BevelOuter = bvLowered
    TabOrder = 0
    object pnlData: TPanel
      Left = 2
      Top = 25
      Width = 631
      Height = 54
      Align = alClient
      BevelOuter = bvNone
      TabOrder = 2
      object lblPeriodoInicial: TLabel
        Left = 11
        Top = 7
        Width = 69
        Height = 13
        Caption = 'Periodo &Inicial:'
      end
      object lblPeriodoFinal: TLabel
        Left = 129
        Top = 7
        Width = 64
        Height = 13
        Caption = 'Periodo &Final:'
      end
      object lblDe: TLabel
        Left = 112
        Top = 26
        Width = 6
        Height = 13
        Caption = 'a'
      end
      object mskInicial: TMaskEdit
        Left = 11
        Top = 24
        Width = 86
        Height = 21
        EditMask = '99\/99\/9999;1;_'
        MaxLength = 10
        TabOrder = 0
        Text = '  /  /    '
      end
      object mskFinal: TMaskEdit
        Left = 130
        Top = 22
        Width = 86
        Height = 21
        EditMask = '99\/99\/9999;1;_'
        MaxLength = 10
        TabOrder = 1
        Text = '  /  /    '
      end
    end
    object pnlVariant: TPanel
      Left = 2
      Top = 25
      Width = 631
      Height = 54
      Align = alClient
      BevelInner = bvLowered
      TabOrder = 1
      DesignSize = (
        631
        54)
      object lblProcurando: TLabel
        Left = 118
        Top = 10
        Width = 76
        Height = 13
        Caption = 'Procurando por:'
      end
      object mskProcurando: TMaskEdit
        Left = 118
        Top = 28
        Width = 504
        Height = 21
        Anchors = [akLeft, akRight, akBottom]
        CharCase = ecUpperCase
        TabOrder = 1
        Text = ''
        OnChange = mskProcurandoChange
        OnKeyDown = mskProcurandoKeyDown
        OnKeyPress = mskProcurandoKeyPress
      end
      object rgpCriterio: TRadioGroup
        Left = 2
        Top = 2
        Width = 114
        Height = 50
        Align = alLeft
        Ctl3D = True
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clNavy
        Font.Height = -11
        Font.Name = 'MS Sans Serif'
        Font.Style = [fsBold]
        ItemIndex = 0
        Items.Strings = (
          'Iniciado com'
          'Contendo')
        ParentCtl3D = False
        ParentFont = False
        TabOrder = 0
        OnClick = rgpCriterioClick
      end
    end
    object pnlDisplay: TPanel
      Left = 2
      Top = 2
      Width = 631
      Height = 23
      Align = alTop
      BevelInner = bvLowered
      TabOrder = 0
      object Procurando: TStaticText
        Left = 2
        Top = 2
        Width = 627
        Height = 20
        Align = alTop
        Alignment = taCenter
        Caption = 'Pesquisando em : '
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clNavy
        Font.Height = -13
        Font.Name = 'MS Sans Serif'
        Font.Style = [fsBold]
        ParentFont = False
        TabOrder = 0
      end
    end
  end
  object pnlGrid: TPanel
    Left = 0
    Top = 81
    Width = 635
    Height = 280
    Align = alClient
    BevelOuter = bvLowered
    TabOrder = 1
    object GridPesquisa: TDBGrid
      Left = 1
      Top = 1
      Width = 633
      Height = 278
      Align = alClient
      BorderStyle = bsNone
      Ctl3D = True
      DataSource = dtsFind
      Options = [dgTitles, dgIndicator, dgColumnResize, dgColLines, dgRowLines, dgTabs, dgAlwaysShowSelection, dgMultiSelect]
      ParentCtl3D = False
      TabOrder = 0
      TitleFont.Charset = DEFAULT_CHARSET
      TitleFont.Color = clWindowText
      TitleFont.Height = -11
      TitleFont.Name = 'MS Sans Serif'
      TitleFont.Style = []
      OnDblClick = GridPesquisaDblClick
      OnKeyDown = GridPesquisaKeyDown
      OnKeyPress = GridPesquisaKeyPress
      OnTitleClick = GridPesquisaTitleClick
    end
    object pnlInfo: TPanel
      Left = 449
      Top = 255
      Width = 185
      Height = 25
      BevelOuter = bvNone
      Caption = 'Buscando dados...'
      Color = clWindow
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clNavy
      Font.Height = -11
      Font.Name = 'MS Sans Serif'
      Font.Style = [fsItalic]
      ParentFont = False
      TabOrder = 1
    end
  end
  object pnlOperacao: TPanel
    Left = 0
    Top = 361
    Width = 635
    Height = 40
    Align = alBottom
    BevelOuter = bvLowered
    TabOrder = 2
    DesignSize = (
      635
      40)
    object spbtConfirmar: TSpeedButton
      Left = 552
      Top = 5
      Width = 39
      Height = 31
      Hint = 'Confirmar'
      Anchors = [akRight, akBottom]
      Flat = True
      Glyph.Data = {
        F6000000424DF600000000000000760000002800000010000000100000000100
        0400000000008000000000000000000000001000000000000000000000000000
        8000008000000080800080000000800080008080000080808000C0C0C0000000
        FF0000FF000000FFFF00FF000000FF00FF00FFFF0000FFFFFF00111111111111
        1111111110111111111111110A01111111111110AAA0111111111110AAA01111
        1111110AAAAA0111111110AAAAAA0111111117AA11AAA01111117A11111AA011
        11111111111AAA01111111111111AA011111111111111AA0111111111111117A
        0111111111111117A0111111111111111AA11111111111111111}
      ParentShowHint = False
      ShowHint = True
      OnClick = spbtConfirmarClick
    end
    object SpeedButton4: TSpeedButton
      Left = 591
      Top = 5
      Width = 40
      Height = 31
      Hint = 'Fechar'
      Anchors = [akRight, akBottom]
      Flat = True
      Glyph.Data = {
        36030000424D3603000000000000360000002800000010000000100000000100
        18000000000000030000232E0000232E00000000000000000001FFFFFFFFFFFF
        FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF1D639B196098145D95105A
        920D5890135C920C578F9999997171715454545151514F4F4F4C4C4C4A4A4A47
        474745454525679D3274A83D7CAF4784B54E8ABA3E7EAD0C578FFFFFFFFFFFFF
        585858A2A2A2A2A2A2A3A3A3A4A4A4A4A4A4A5A5A52F6FA578ABD278ABD373A7
        D169A0CD407FAE0F5991FFFFFFFFFFFF5C5C5CA1A1A1A1A1A1A2A2A2A3A3A3A3
        A3A3A4A4A43674AA7DAFD45B9AC95495C75896C84180AE135C94FFFFFFFFFFFF
        606060A0A0A0A0A0A0A1A1A1A2A2A2A2A2A2A3A3A33D79B082B3D7629FCC5A9A
        C95E9BCA4381AF196098FFFFFFFFFFFF6464649F9F9F9F9F9FA0A0A0A1A1A1A1
        A1A1A2A2A2457EB488B7D967A3CF619ECC639FCC4583B11F649CFFFFFFFFFFFF
        6868689E9E9E9F9F9F9F9F9FA0A0A0A0A0A0A1A1A14C84BA8DBBDB6EA8D166A6
        D15FB4DF4785B12569A1FFFFFFFFFFFF6C6C6C9D9D9D9E9E9E9E9E9E9F9F9F9F
        9F9FA0A0A05489BF94BFDD75ADD463B8E14BD4FF428BB82C6EA6FFFFFFFFFFFF
        7070709C9C9C9D9D9D9D9D9D9E9E9E9F9F9F9F9F9F5A8EC498C3E07CB3D774AF
        D65EC4ED4B88B33473ABFFFFFFFFFFFF7373739B9B9B9C9C9C9C9C9C9D9D9D9E
        9E9E9E9E9E6092C99EC7E283B8DA7DB4D77EB3D74F89B43B79B1FFFFFFFFFFFF
        7777779A9A9A9B9B9B9B9B9B9C9C9C9D9D9D9D9D9D6696CCA2CBE389BDDC83B9
        DA84B9DA518BB5437EB6FFFFFFFFFFFF7A7A7A9999999A9A9A9A9A9A9B9B9B9C
        9C9C9C9C9C6C9AD0A7CEE58FC1DF89BDDC8BBDDC538DB64B84BCFFFFFFFFFFFF
        7D7D7D9999999999999A9A9A9A9A9A9B9B9B9B9B9B6F9DD3AAD1E7ABD1E798C7
        E191C2DE568FB75289C1FFFFFFFFFFFF8080807E7E7E7C7C7C7A7A7A77777775
        7575727272719ED46F9ED687B2DCABD3E8A9D0E65890B8598EC6FFFFFFFFFFFF
        FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF709ED66D9C
        D485B1DA5A91B96093CBFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
        FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF6D9CD46A9AD26697CF}
      ParentShowHint = False
      ShowHint = True
      OnClick = SpeedButton4Click
    end
  end
  object dtsFind: TDataSource
    DataSet = cdsPesquisa
    Left = 40
    Top = 323
  end
  object cdsPesquisa: TClientDataSet
    Aggregates = <>
    Params = <>
    Left = 80
    Top = 324
  end
end
