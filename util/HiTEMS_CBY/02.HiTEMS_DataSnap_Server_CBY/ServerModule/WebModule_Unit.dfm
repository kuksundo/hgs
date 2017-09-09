object WM1: TWM1
  OldCreateOrder = False
  OnCreate = WebModuleCreate
  Actions = <
    item
      Name = 'ReverseStringAction'
      PathInfo = '/ReverseString'
      Producer = ReverseString
    end
    item
      Name = 'ServerFunctionInvokerAction'
      PathInfo = '/ServerFunctionInvoker'
      Producer = ServerFunctionInvoker
    end
    item
      Default = True
      Name = 'DefaultAction'
      PathInfo = '/'
      OnAction = WebModuleDefaultAction
    end>
  BeforeDispatch = WebModuleBeforeDispatch
  Height = 463
  Width = 665
  object DSHTTPWebDispatcher1: TDSHTTPWebDispatcher
    DSContext = 'datasnap/'
    RESTContext = 'rest/'
    CacheContext = 'cache/'
    Server = ServerContainer1.DSServer1
    DSHostname = 'localhost'
    DSPort = 211
    Filters = <>
    CredentialsPassThrough = False
    SessionTimeout = 1200000
    WebDispatch.MethodType = mtAny
    WebDispatch.PathInfo = 'datasnap*'
    Left = 112
    Top = 91
  end
  object ServerFunctionInvoker: TPageProducer
    HTMLFile = 'Templates\ServerFunctionInvoker.html'
    OnHTMLTag = ServerFunctionInvokerHTMLTag
    Left = 112
    Top = 280
  end
  object ReverseString: TPageProducer
    HTMLFile = 'templates\ReverseString.html'
    OnHTMLTag = ServerFunctionInvokerHTMLTag
    Left = 112
    Top = 328
  end
  object WebFileDispatcher1: TWebFileDispatcher
    WebFileExtensions = <
      item
        MimeType = 'text/css'
        Extensions = 'css'
      end
      item
        MimeType = 'text/javascript'
        Extensions = 'js'
      end
      item
        MimeType = 'image/x-png'
        Extensions = 'png'
      end
      item
        MimeType = 'text/html'
        Extensions = 'htm;html'
      end
      item
        MimeType = 'image/jpeg'
        Extensions = 'jpg;jpeg;jpe'
      end
      item
        MimeType = 'image/gif'
        Extensions = 'gif'
      end>
    BeforeDispatch = WebFileDispatcher1BeforeDispatch
    WebDirectories = <
      item
        DirectoryAction = dirInclude
        DirectoryMask = '*'
      end
      item
        DirectoryAction = dirExclude
        DirectoryMask = '\templates\*'
      end>
    RootDirectory = '.'
    Left = 88
    Top = 216
  end
  object DSProxyGenerator1: TDSProxyGenerator
    ExcludeClasses = 'DSMetadata'
    MetaDataProvider = DSServerMetaDataProvider1
    Writer = 'Java Script REST'
    Left = 288
    Top = 96
  end
  object DSServerMetaDataProvider1: TDSServerMetaDataProvider
    Server = ServerContainer1.DSServer1
    Left = 288
    Top = 40
  end
  object DSProxyDispatcher1: TDSProxyDispatcher
    RequiredProxyFilesPath = 'proxy'
    DSProxyGenerator = DSProxyGenerator1
    Left = 280
    Top = 144
  end
  object DSAuthenticationManager1: TDSAuthenticationManager
    Roles = <>
    Left = 64
    Top = 24
  end
  object DSHTTPServiceProxyDispatcher1: TDSHTTPServiceProxyDispatcher
    WebFileExtensions = <
      item
        MimeType = 'application/x-zip-compressed'
        Extensions = 'zip'
      end>
    WebDirectories = <
      item
        DirectoryAction = dirInclude
        DirectoryMask = '\proxy\*'
      end
      item
        DirectoryAction = dirExclude
        DirectoryMask = '\proxy\*\*'
      end>
    RootDirectory = '.'
    RequiredProxyFilesPath = 'proxy'
    Left = 112
    Top = 152
  end
  object DSHTTPServiceFileDispatcher1: TDSHTTPServiceFileDispatcher
    WebFileExtensions = <
      item
        MimeType = 'text/css'
        Extensions = 'css'
      end
      item
        MimeType = 'text/html'
        Extensions = 'html;htm'
      end
      item
        MimeType = 'text/javascript'
        Extensions = 'js'
      end
      item
        MimeType = 'image/jpeg'
        Extensions = 'jpeg;jpg'
      end
      item
        MimeType = 'image/x-png'
        Extensions = 'png'
      end>
    WebDirectories = <
      item
        DirectoryAction = dirInclude
        DirectoryMask = '*'
      end
      item
        DirectoryAction = dirExclude
        DirectoryMask = '\templates\*'
      end>
    RootDirectory = '.'
    Left = 112
    Top = 216
  end
end
