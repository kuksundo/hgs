unit LogConst;

{$mode objfpc}{$H+}

interface

resourcestring
  rsDebug       = 'Debug';
  rsInfo        = 'Info';
  rsWarning     = 'Warning';
  rsError       = 'Error';
  rsUnknownHost = 'unknown_host'; //< Имя компьютера извлечь не удалось.
  rsUnknownApp  = 'unknown_app';  //< Имя приложения извлечь не удалось.

const
  logExtension = 'csv';  //< Расширение файла журнала.
  msgDelimiter = ';';    //< Разделитель параметров в сообщении журнала.
  msgEOL       = #13#10; //< Признак конца строки.

implementation

end.
