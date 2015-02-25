object frmLogon: TfrmLogon
  Left = 587
  Top = 268
  Width = 431
  Height = 266
  Caption = 'frmLogon'
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  PixelsPerInch = 96
  TextHeight = 13
  object pnlDados: TPanel
    Left = 0
    Top = 0
    Width = 423
    Height = 198
    Align = alClient
    BevelInner = bvLowered
    TabOrder = 0
    object Label1: TLabel
      Left = 16
      Top = 8
      Width = 39
      Height = 13
      Caption = 'Servidor'
    end
    object Label2: TLabel
      Left = 16
      Top = 52
      Width = 25
      Height = 13
      Caption = 'Alias:'
    end
    object Label3: TLabel
      Left = 16
      Top = 72
      Width = 71
      Height = 13
      Caption = 'Banco Dados :'
    end
    object edServidor: TEdit
      Left = 12
      Top = 24
      Width = 205
      Height = 21
      TabOrder = 0
    end
    object edAlias: TEdit
      Left = 92
      Top = 48
      Width = 317
      Height = 21
      TabOrder = 1
    end
    object edBd: TEdit
      Left = 92
      Top = 72
      Width = 317
      Height = 21
      TabOrder = 2
    end
    object GroupBox1: TGroupBox
      Left = 2
      Top = 112
      Width = 419
      Height = 84
      Align = alBottom
      TabOrder = 3
      object Label4: TLabel
        Left = 16
        Top = 32
        Width = 42
        Height = 13
        Caption = 'Usuario :'
      end
      object Label5: TLabel
        Left = 16
        Top = 56
        Width = 31
        Height = 13
        Caption = 'Senha'
      end
      object edUsuario: TEdit
        Left = 80
        Top = 24
        Width = 121
        Height = 21
        TabOrder = 0
      end
      object edSenha: TEdit
        Left = 80
        Top = 48
        Width = 121
        Height = 21
        TabOrder = 1
      end
    end
    object StaticText1: TStaticText
      Left = 12
      Top = 108
      Width = 146
      Height = 17
      BevelInner = bvNone
      BevelKind = bkFlat
      BevelOuter = bvRaised
      Caption = ' Parametros de Conex'#227'o '
      Color = 8404992
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWhite
      Font.Height = -11
      Font.Name = 'MS Sans Serif'
      Font.Style = [fsBold]
      ParentColor = False
      ParentFont = False
      TabOrder = 4
    end
  end
  object pnlBotoes: TPanel
    Left = 0
    Top = 198
    Width = 423
    Height = 41
    Align = alBottom
    BevelOuter = bvLowered
    TabOrder = 1
    object btOk: TSpeedButton
      Left = 200
      Top = 4
      Width = 73
      Height = 29
      Caption = 'Ok'
      OnClick = btOkClick
    end
    object btCancelar: TSpeedButton
      Left = 284
      Top = 4
      Width = 73
      Height = 29
      Caption = 'Cancelar'
      OnClick = btCancelarClick
    end
  end
end
