unit sdBasicTypes;

interface

type

  PWord = ^word;

  TsdPoint = packed record
    X: integer;
    Y: integer;
  end;

  TsdFloatPoint = packed record
    X: double;
    Y: double;
  end;
  TsdFloatPointArray = array of TsdFloatPoint;


implementation

end.
