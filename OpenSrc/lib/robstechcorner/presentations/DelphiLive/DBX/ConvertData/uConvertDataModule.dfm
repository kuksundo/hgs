object dmConvert: TdmConvert
  OldCreateOrder = False
  Height = 258
  Width = 330
  object BDEdb: TDatabase
    AliasName = 'DBDEMOS'
    DatabaseName = 'BDEdb'
    SessionName = 'Default'
    Left = 40
    Top = 16
  end
  object dbxConn: TSQLConnection
    LoadParamsOnConnect = True
    Left = 136
    Top = 24
  end
  object bdeTable: TTable
    DatabaseName = 'BDEdb'
    ReadOnly = True
    TableName = 'animals.dbf'
    Left = 40
    Top = 80
  end
  object qryImport: TSQLQuery
    MaxBlobSize = -1
    Params = <>
    SQL.Strings = (
      'select * from '
      'clients'
      'where'
      ' 0 = 1')
    Left = 136
    Top = 80
  end
  object CDS: TClientDataSet
    Aggregates = <>
    Params = <>
    ProviderName = 'dsProvider'
    Left = 136
    Top = 184
  end
  object dsProvider: TDataSetProvider
    DataSet = qryImport
    Left = 136
    Top = 128
  end
end
