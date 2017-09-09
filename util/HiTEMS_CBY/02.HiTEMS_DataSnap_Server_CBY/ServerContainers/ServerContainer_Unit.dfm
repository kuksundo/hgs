object ServerContainer1: TServerContainer1
  OldCreateOrder = False
  Height = 516
  Width = 781
  object DSServer1: TDSServer
    AutoStart = True
    HideDSAdmin = False
    Left = 96
    Top = 11
  end
  object DSTCPServerTransport1: TDSTCPServerTransport
    Server = DSServer1
    BufferKBSize = 32
    Filters = <
      item
        FilterId = 'PC1'
        Properties.Strings = (
          'Key=uDkhh6xRLKEEubWQ')
      end
      item
        FilterId = 'RSA'
        Properties.Strings = (
          'UseGlobalKey=true'
          'KeyLength=1024'
          'KeyExponent=3')
      end
      item
        FilterId = 'ZLibCompression'
        Properties.Strings = (
          'CompressMoreThan=1024')
      end>
    OnConnect = DSTCPServerTransport1Connect
    OnDisconnect = DSTCPServerTransport1Disconnect
    KeepAliveEnablement = kaDefault
    Left = 96
    Top = 73
  end
  object Get_Photorum_Session_Class: TDSServerClass
    OnGetClass = Get_Photorum_Session_ClassGetClass
    OnCreateInstance = Get_Photorum_Session_ClassCreateInstance
    OnDestroyInstance = Get_Photorum_Session_ClassDestroyInstance
    Server = DSServer1
    LifeCycle = 'Session'
    Left = 240
    Top = 195
  end
  object Get_Monitoring_Session_Class: TDSServerClass
    OnGetClass = Get_Monitoring_Session_ClassGetClass
    OnCreateInstance = Get_Monitoring_Session_ClassCreateInstance
    OnDestroyInstance = Get_Monitoring_Session_ClassDestroyInstance
    Server = DSServer1
    LifeCycle = 'Session'
    Left = 240
    Top = 139
  end
  object Get_LDS_Session_Class: TDSServerClass
    OnGetClass = Get_LDS_Session_ClassGetClass
    OnCreateInstance = Get_LDS_Session_ClassCreateInstance
    OnDestroyInstance = Get_LDS_Session_ClassDestroyInstance
    Server = DSServer1
    LifeCycle = 'Session'
    Left = 240
    Top = 251
  end
  object Get_TRC_Session_Class: TDSServerClass
    OnGetClass = Get_TRC_Session_ClassGetClass
    OnCreateInstance = Get_TRC_Session_ClassCreateInstance
    OnDestroyInstance = Get_TRC_Session_ClassDestroyInstance
    Server = DSServer1
    LifeCycle = 'Session'
    Left = 240
    Top = 307
  end
  object Get_HiTEMS_Session_Class: TDSServerClass
    OnGetClass = Get_HiTEMS_Session_ClassGetClass
    OnCreateInstance = Get_HiTEMS_Session_ClassCreateInstance
    OnDestroyInstance = Get_HiTEMS_Session_ClassDestroyInstance
    Server = DSServer1
    LifeCycle = 'Session'
    Left = 240
    Top = 363
  end
end
