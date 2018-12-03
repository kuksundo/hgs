unit UnitFGSSKMTagConst;

interface

uses System.Classes, UnitEnumHelper;

type
  TFGSSKMControlRoom = (fkcrNull, fkcrECR, fkcrCCR, fkcrECR_WH, fkcrCCR_WH,
    fkcrECR_CCR_WH, fkcrFinal);

  TFGSSKMTestMethod = (fktmNull, fktmMA, fktmAO, fktmCN, fktmAF,
    fktmUH, fktmUR, fktmRL, fktmMC, fktmMO, fktmUP, fktmAT, fktmUS, fktmPD,
    fktmOP, fktmCL, fktmAS, fktmER, fktmFinal);

const
  R_FGSSKMControlRoom : array[Low(TFGSSKMControlRoom)..High(TFGSSKMControlRoom)] of string =
    ('', 'ECR', 'CCR', 'ECR + W/H', 'CCR + W/H', 'ECR + CCR + W/H', '');

  R_FGSSKMTestMethod : array[Low(TFGSSKMTestMethod)..High(TFGSSKMTestMethod)] of string =
    ('', 'MA', 'AO', 'CN', 'AF', 'UH', 'UR', 'RL', 'MC', 'MO', 'UP', 'AT', 'US',
      'PD', 'OP', 'CL', 'AS', 'ER', '');
var
  g_FGSSKMControlRoom: TLabelledEnum<TFGSSKMControlRoom>;
  g_FGSSKMTestMethod: TLabelledEnum<TFGSSKMTestMethod>;

implementation

initialization
  g_FGSSKMControlRoom.InitArrayRecord(R_FGSSKMControlRoom);
  g_FGSSKMTestMethod.InitArrayRecord(R_FGSSKMTestMethod);

end.
