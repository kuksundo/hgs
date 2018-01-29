unit UnitHiMAPData;

interface

uses System.Classes, Vcl.StdCtrls, System.SysUtils, System.StrUtils;

type
  THiMAP_Device_Type = (hdtNone, hdtSymap, hdtHimap, hdtFinal);
  THiMAP_Device_Variant = (hdvNone, hdvXG, hdvX, hdvBCG, hdvBC, hdvFinal);
  THiMAP_Device_Variant2 = (hdv2None, hdv2FI, hdv2M, hdv2T, hdv2BCSF, hdv2BCST,
    hdv2BCSL, hdv2BCSG, hdv2F, hdv2II, hdv2S, hdv2SDC, hdv2HiMix, hdv2HICMPC,
    hdv2HICMPCII, hdv2Final);
  THiMAP_FI_Type = (hfitNone, hfitC16XT, hfitS16XT, hfitC56MX, hfitC16MT, hfitS16MT, hfitFinal);
  THiMAP_M_Type = (hmtNone, hmtC16XT, hmtS16XT, hmtC56MX, hmtC16MT, hmtS16MT, hmtFinal);
  THiMAP_T_Type = (httNone, httC16XT, httS16XT, httC56MT, httS16MT, httFinal);
  THiMAP_BCSF_Type = (hbcsftNone, hbcsft56MX, hbcsft56MR, hbcsftFinal);
  THiMAP_BCST_Type = (hbcsttNone, hbcstt56MX, hbcstt56DX, hbcstt16MX,
    hbcstt56IX_IEC61850, hbcstt56IX_ISC, hbcsttFinal);
  THiMAP_BCSL_Type = (hbcsltNone, hbcslt56MX, hbcslt16MX, hbcsltFinal);
  THiMAP_BCSG_Type = (hbcsgtNone, hbcsgt16MX, hbcsgtFinal);
  THiMAP_F_Type = (hmftNone, hmftCC, hmftCM, hmftSC, hmftSM, hmftFinal);
  THiCAM_II_Type = (hiitNone, hiit56M, hiit56C, hiit55M, hiitFinal);
  THiCAM_S_Type = (hstNone, hstS56X, hstS56M, hstR56M, hstFinal);
  THiCAM_SDC_Type = (hsdctNone, hsdctM, hsdctFinal);

  //Symap에만 적용됨
  THiMAP_Power_Supply = (hpsNone, hpsA, hpsB, hpsC, hpsFinal);
  THiMAP_Phase_CT = (hpctNone, hpct0, hpct1, hpct2, hpct3, hpctFinal);
  THiMAP_Phase_PT = (hpptNone, hpptA, hpptB, hpptC, hpptD, hpptE, hpptF, hpptG, hpptH, hpptI, hpptJ, hpptFinal);
  THiMAP_Phase_CT_Diff = (hpctdNone, hpctd0, hpctd1, hpctd2, hpctd3, hpctd4, hpctd5, hpctd6, hpctdFinal);
  THiMAP_CT_Ground = (hcgNone, hcgA, hcgB, hcgC, hcgD, hcgE, hcgF, hcgG, hcgH, hcgFinal);
  THiMAP_PT_Ground = (hpgNone, hpg0, hpg1, hpg2, hpg3, hpg4, hpg5, hpg6, hpg7, hpg8, hpgFinal);
  THiMAP_CANBUS = (hcbNone, hcbA, hcbB, hcbC, hcbFinal);
  THiMAP_PROFIBUS = (hpbNone, hpb0, hpb1, hpb2, hpbFinal);
  THiMAP_SERIAL_INTERFACE = (hsiNone, hsiA, hsiB, hsiC, hsiFinal);
  THiMAP_IEC_61850 = (hi6None, hi60, hi61, hi6Final);
  THiMAP_Analog_Output = (haoNone, haoA, haoB, haoFinal);
  THiMAP_Shunt1 = (hs1None, hs10, hs11, hs1Final);
  THiMAP_Front_Design = (hpdNone, hpdA, hpdB, hpdFinal);
  THiMAP_Recording_Unit = (hruNone, hru0, hru1, hruFinal);

  //HiMAP에만 적용됨
  THiMAP_COMMUNICATION = (hcNone, hcC0, hcC1, hcC2, hcC3, hcC3F, hcC4F, hcC5,
    hcC6, hcC7, hcC8, hcC8F, hcC12, hcC13, hcC137, hcRC, hcRS, hcFinal);
  THiMAP_EXTENDED_BOARD = (hebNone, heb0, heb1, heb2, heb3, heb4, heb5, heb6, hebFinal);
  THiMAP_SPECIAL_CONFIG = (hscNone, hsc0, hsc1, hsc2, hsc3, hsc4, hscFinal);
  THiMAP_SPECIAL_CONFIGs = set of THiMAP_SPECIAL_CONFIG;
  THiMAP_NORMAL_FREQUENCY = (hnfNone, hnf1, hnf2, hnfFinal);
  THiMAP_FRONTPANEL_TYPE = (hftNone, hft1, hft2, hft3, hft4, hft5, hft6, hft7, hft8, hftX, hftFinal);

  THiMAP_Extension_Device = (hedNone, hedCMA211, hedCMA212, hedCMA216, hedCMA216_217, hedCMA238, hedCMA198, hedFinal);
  THiMAP_Extension_Device_CMA216_217 = (hed216_217None, hed216_217A, hed216_217B, hed216_217C, hed216_217Final);
  THiMAP_Extension_Device_CMA238 = (hed238None, hed238A, hed238B, hed238Final);
  THiMAP_Extension_Device_CMA198 = (hed198None, hed198A, hed198B, hed198C, hed198Final);

const
  R_HiMAP_Device_Type : array[hdtNone..hdtFinal] of record
    Description, VCode, H_VCode : string; //VCode = Symap VCode임, H_VCode = Himap VCode임
    Value       : THiMAP_Device_Type;
  end = ((Description : ''; VCode : ''; H_VCode : ''; Value : hdtNone),
         (Description : 'Symap';
                  VCode : 'Symap';   H_VCode : 'Symap'; Value : hdtSymap),
         (Description : 'HiMAP';
                  VCode : 'HiMAP';   H_VCode : 'HiMAP'; Value : hdtHimap),
         (Description : ''; VCode : ''; H_VCode : ''; Value : hdtFinal)
  );

  R_HiMAP_Device_Variant : array[hdvNone..hdvFinal] of record
    Description, VCode, H_VCode : string; //VCode = Symap VCode임, H_VCode = Himap VCode임
    Value       : THiMAP_Device_Variant;
  end = ((Description : ''; VCode : ''; H_VCode : ''; Value : hdvNone),
         (Description : 'Multifunctional controller and protection (without Diff.-prot.) & Power Management System (PMS)';
                  VCode : 'XG';   H_VCode : ''; Value : hdvXG),
         (Description : 'Multifunctional controller and protection (without Diff.-prot.)';
                  VCode : 'X';   H_VCode : 'X'; Value : hdvX),
         (Description : 'Multifunctional controller and protection (optional Diff.-prot.) & Power Management System (PMS)';
                  VCode : 'BCG';   H_VCode : ''; Value : hdvBCG),
         (Description : 'Multifunctional controller and protection (optional Diff.-prot.)';
                  VCode : 'BC';   H_VCode : 'BC'; Value : hdvBC),
         (Description : ''; VCode : ''; H_VCode : ''; Value : hdvFinal)
  );

  R_HiMAP_Device_Variant2 : array[hdv2None..hdv2Final] of record
    Description, VCode, H_VCode : string;
    Value       : THiMAP_Device_Variant2;
  end = ((Description : ''; VCode : ''; H_VCode : ''; Value : hdv2None),
         (Description : 'HIMAP-FI';
                  VCode : '';   H_VCode : 'HIMAP-FI'; Value : hdv2FI),
         (Description : 'HIMAP-M';
                  VCode : '';   H_VCode : 'HIMAP-M'; Value : hdv2M),
         (Description : 'HIMAP-T';
                  VCode : '';   H_VCode : 'HIMAP-T'; Value : hdv2T),
         (Description : 'HIMAP-BCS-F';
                  VCode : '';   H_VCode : 'HIMAP-BCS-F'; Value : hdv2BCSF),
         (Description : 'HIMAP-BCS-T';
                  VCode : '';   H_VCode : 'HIMAP-BCS-T'; Value : hdv2BCST),
         (Description : 'HIMAP-BCS-L';
                  VCode : '';   H_VCode : 'HIMAP-BCS-L'; Value : hdv2BCSL),
         (Description : 'HIMAP-BCS-G';
                  VCode : '';   H_VCode : 'HIMAP-BCS-G'; Value : hdv2BCSG),
         (Description : 'HIMAP-F';
                  VCode : '';   H_VCode : 'HIMAP-F'; Value : hdv2F),
         (Description : 'HICAM-II';
                  VCode : '';   H_VCode : 'HICAM-II'; Value : hdv2II),
         (Description : 'HICAM-S';
                  VCode : '';   H_VCode : 'HICAM-S'; Value : hdv2S),
         (Description : 'HICAM-S-DC';
                  VCode : '';   H_VCode : 'HICAM-S-DC'; Value : hdv2SDC),
         (Description : 'HIMIX';
                  VCode : '';   H_VCode : 'HIMIX'; Value : hdv2HiMix),
         (Description : 'HICM-PC';
                  VCode : '';   H_VCode : 'HICM-PC'; Value : hdv2HICMPC),
         (Description : 'HICM-PCII';
                  VCode : '';   H_VCode : 'HICM-PCII'; Value : hdv2HICMPCII),
         (Description : ''; VCode : ''; H_VCode : ''; Value : hdv2Final)
  );

  R_HiMAP_FI_Type : array[hfitNone..hfitFinal] of record
    Description, VCode, H_VCode : string;
    Value       : THiMAP_FI_Type;
  end = ((Description : ''; VCode : ''; H_VCode : ''; Value : hfitNone),
         (Description : 'HIMAP-FI-C16XT';
                  VCode : '';   H_VCode : 'C16XT'; Value : hfitC16XT),
         (Description : 'HIMAP-FI-S16XT';
                  VCode : '';   H_VCode : 'S16XT'; Value : hfitS16XT),
         (Description : 'HIMAP-FI-C56MX';
                  VCode : '';   H_VCode : 'C56MX'; Value : hfitC56MX),
         (Description : 'HIMAP-FI-C16MT';
                  VCode : '';   H_VCode : 'C16MT'; Value : hfitC16MT),
         (Description : 'HIMAP-FI-S16MT';
                  VCode : '';   H_VCode : 'S16MT'; Value : hfitS16MT),
         (Description : ''; VCode : ''; H_VCode : ''; Value : hfitFinal)
  );

  R_HiMAP_M_Type : array[hmtNone..hmtFinal] of record
    Description, VCode, H_VCode : string;
    Value       : THiMAP_M_Type;
  end = ((Description : ''; VCode : ''; H_VCode : ''; Value : hmtNone),
         (Description : 'HIMAP-M-C16XT';
                  VCode : '';   H_VCode : 'C16XT'; Value : hmtC16XT),
         (Description : 'HIMAP-M-S16XT';
                  VCode : '';   H_VCode : 'S16XT'; Value : hmtS16XT),
         (Description : 'HIMAP-M-C56MX';
                  VCode : '';   H_VCode : 'C56MX'; Value : hmtC56MX),
         (Description : 'HIMAP-M-C16MT';
                  VCode : '';   H_VCode : 'C16MT'; Value : hmtC16MT),
         (Description : 'HIMAP-M-S16MT';
                  VCode : '';   H_VCode : 'S16MT'; Value : hmtS16MT),
         (Description : ''; VCode : ''; H_VCode : ''; Value : hmtFinal)
  );

  R_HiMAP_T_Type : array[httNone..httFinal] of record
    Description, VCode, H_VCode : string;
    Value       : THiMAP_T_Type;
  end = ((Description : ''; VCode : ''; H_VCode : ''; Value : httNone),
         (Description : 'HIMAP-T-C16XT';
                  VCode : '';   H_VCode : 'C16XT'; Value : httC16XT),
         (Description : 'HIMAP-T-S16XT';
                  VCode : '';   H_VCode : 'S16XT'; Value : httS16XT),
         (Description : 'HIMAP-T-C56MT';
                  VCode : '';   H_VCode : 'C56MT'; Value : httC56MT),
         (Description : 'HIMAP-T-S16MT';
                  VCode : '';   H_VCode : 'S16MT'; Value : httS16MT),
         (Description : ''; VCode : ''; H_VCode : ''; Value : httFinal)
  );

  R_HiMAP_BCSF_Type : array[hbcsftNone..hbcsftFinal] of record
    Description, VCode, H_VCode : string;
    Value       : THiMAP_BCSF_Type;
  end = ((Description : ''; VCode : ''; H_VCode : ''; Value : hbcsftNone),
         (Description : 'HIMAP-BCS-F-56MX';
                  VCode : '';   H_VCode : '56MX'; Value : hbcsft56MX),
         (Description : 'HIMAP-BCS-F-56MR';
                  VCode : '';   H_VCode : '56MR'; Value : hbcsft56MR),
         (Description : ''; VCode : ''; H_VCode : ''; Value : hbcsftFinal)
  );

  R_HiMAP_BCST_Type : array[hbcsttNone..hbcsttFinal] of record
    Description, VCode, H_VCode : string;
    Value       : THiMAP_BCST_Type;
  end = ((Description : ''; VCode : ''; H_VCode : ''; Value : hbcsttNone),
         (Description : 'HIMAP-BCS-T-56MX';
                  VCode : '';   H_VCode : '56MX'; Value : hbcstt56MX),
         (Description : 'HIMAP-BCS-T-56DX';
                  VCode : '';   H_VCode : '56DX'; Value : hbcstt56DX),
         (Description : 'HIMAP-BCS-T-16MX';
                  VCode : '';   H_VCode : '16MX'; Value : hbcstt16MX),
         (Description : 'HIMAP-BCS-T-56IX-IEC61850';
                  VCode : '';   H_VCode : '56IX-IEC61850'; Value : hbcstt56IX_IEC61850),
         (Description : 'HIMAP-BCS-T-56IX_ISC';
                  VCode : '';   H_VCode : '56IX_ISC'; Value : hbcstt56IX_ISC),
         (Description : ''; VCode : ''; H_VCode : ''; Value : hbcsttFinal)
  );

  R_HiMAP_BCSL_Type : array[hbcsltNone..hbcsltFinal] of record
    Description, VCode, H_VCode : string;
    Value       : THiMAP_BCSL_Type;
  end = ((Description : ''; VCode : ''; H_VCode : ''; Value : hbcsltNone),
         (Description : 'HIMAP-BCS-L-56MX';
                  VCode : '';   H_VCode : '56MX'; Value : hbcslt56MX),
         (Description : 'HIMAP-BCS-L-16MX';
                  VCode : '';   H_VCode : '16DX'; Value : hbcslt16MX),
         (Description : ''; VCode : ''; H_VCode : ''; Value : hbcsltFinal)
  );

  R_HiMAP_BCSG_Type : array[hbcsgtNone..hbcsgtFinal] of record
    Description, VCode, H_VCode : string;
    Value       : THiMAP_BCSG_Type;
  end = ((Description : ''; VCode : ''; H_VCode : ''; Value : hbcsgtNone),
         (Description : 'HIMAP-BCS-G-16MX';
                  VCode : '';   H_VCode : '16MX'; Value : hbcsgt16MX),
         (Description : ''; VCode : ''; H_VCode : ''; Value : hbcsgtFinal)
  );

  R_HiMAP_F_Type : array[hmftNone..hmftFinal] of record
    Description, VCode, H_VCode : string;
    Value       : THiMAP_F_Type;
  end = ((Description : ''; VCode : ''; H_VCode : ''; Value : hmftNone),
         (Description : 'HIMAP-F-CC';
                  VCode : '';   H_VCode : 'CC'; Value : hmftCC),
         (Description : 'HIMAP-F-CM';
                  VCode : '';   H_VCode : 'CM'; Value : hmftCM),
         (Description : 'HIMAP-F-SC';
                  VCode : '';   H_VCode : 'SC'; Value : hmftSC),
         (Description : 'HIMAP-F-SM';
                  VCode : '';   H_VCode : 'SM'; Value : hmftSM),
         (Description : ''; VCode : ''; H_VCode : ''; Value : hmftFinal)
  );

  R_HiCAM_II_Type : array[hiitNone..hiitFinal] of record
    Description, VCode, H_VCode : string;
    Value       : THiCAM_II_Type;
  end = ((Description : ''; VCode : ''; H_VCode : ''; Value : hiitNone),
         (Description : 'HICAM-II-56M';
                  VCode : '';   H_VCode : '56M'; Value : hiit56M),
         (Description : 'HIMAP-II-56C';
                  VCode : '';   H_VCode : '56C'; Value : hiit56C),
         (Description : 'HIMAP-II-55M';
                  VCode : '';   H_VCode : '55M'; Value : hiit55M),
         (Description : ''; VCode : ''; H_VCode : ''; Value : hiitFinal)
  );

  R_HiCAM_S_Type : array[hstNone..hstFinal] of record
    Description, VCode, H_VCode : string;
    Value       : THiCAM_S_Type;
  end = ((Description : ''; VCode : ''; H_VCode : ''; Value : hstNone),
         (Description : 'HICAM-S-S56X';
                  VCode : '';   H_VCode : 'S56X'; Value : hstS56X),
         (Description : 'HIMAP-S-S56M';
                  VCode : '';   H_VCode : 'S56M'; Value : hstS56M),
         (Description : 'HIMAP-S-R56M';
                  VCode : '';   H_VCode : 'R56M'; Value : hstR56M),
         (Description : ''; VCode : ''; H_VCode : ''; Value : hstFinal)
  );

  R_HiCAM_SDC_Type : array[hsdctNone..hsdctFinal] of record
    Description, VCode, H_VCode : string;
    Value       : THiCAM_SDC_Type;
  end = ((Description : ''; VCode : ''; H_VCode : ''; Value : hsdctNone),
         (Description : 'HIMAP-S-DC-M';
                  VCode : '';   H_VCode : 'M'; Value : hsdctM),
         (Description : ''; VCode : ''; H_VCode : ''; Value : hsdctFinal)
  );

  R_HiMAP_Power_Supply : array[hpsNone..hpsFinal] of record
    Description, VCode, H_VCode : string;
    Value       : THiMAP_Power_Supply;
  end = ((Description : ''; VCode : ''; H_VCode : ''; Value : hpsNone),
         (Description : '12-36V DC';              VCode : 'A'; H_VCode : '24'; Value : hpsA),
         (Description : '36-72V DC';              VCode : 'B'; H_VCode : '60'; Value : hpsB),
         (Description : '60-230V AC; 80-300V DC'; VCode : 'C'; H_VCode : '110'; Value : hpsC),
         (Description : ''; VCode : ''; H_VCode : ''; Value : hpsFinal)
  );

  R_HiMAP_Phase_CT : array[hpctNone..hpctFinal] of record
    Description, VCode, H_VCode : string;
    Value       : THiMAP_Phase_CT;
  end = ((Description : ''; VCode : ''; H_VCode : ''; Value : hpctNone),
         (Description : '1A secondary rated current; 3-phase (0-20×In)';
              VCode : '0'; H_VCode : '1A'; Value : hpct0),
         (Description : '5A secondary rated current; 3-phase (0-20×In)';
              VCode : '1'; H_VCode : '5A'; Value : hpct1),
         (Description : '1A secondary rated current; 3-phase, seperated measuring inputs: M: 0-2×In, P: 0-20×In';
              VCode : '2'; H_VCode : '1AM'; Value : hpct2),
         (Description : '5A secondary rated current; 3-phase, seperated measuring inputs: M: 0-2×In, P: 0-20×In';
              VCode : '3'; H_VCode : '5AM'; Value : hpct3),
         (Description : ''; VCode : ''; H_VCode : ''; Value : hpctFinal)
  );

  R_HiMAP_Phase_PT : array[hpptNone..hpptFinal] of record
    Description, VCode, H_VCode : string;
    Value       : THiMAP_Phase_PT;
  end = ((Description : ''; VCode : ''; H_VCode : ''; Value : hpptNone),
         (Description : 'FEEDER and BUS1: 100V/√3 PT, 2 x 3-phase, (resistor)';
              VCode : 'A'; H_VCode : 'R100V'; Value : hpptA),
         (Description : 'FEEDER and BUS1: 200V/√3 PT, 2 x 3-phase, (resistor)';
              VCode : 'B'; H_VCode : 'R200v'; Value : hpptB),
         (Description : 'FEEDER and BUS1: 400V/√3 PT, 2 x 3-phase, (resistor)';
              VCode : 'C'; H_VCode : 'R400V'; Value : hpptC),
         (Description : 'FEEDER and BUS1: 800V/√3 PT, 2 x 3-phase, (resistor)';
              VCode : 'D'; H_VCode : 'R800V'; Value : hpptD),
         (Description : 'FEEDER, BUS1 and BUS2: 100V/√3 PT, 3 x 3-phase, (resistor)';
              VCode : 'E'; H_VCode : 'R100VB2'; Value : hpptE),
         (Description : 'FEEDER, BUS1 and BUS2: 200V/√3 PT, 3 x 3-phase, (resistor)';
              VCode : 'F'; H_VCode : ''; Value : hpptF),
         (Description : 'FEEDER, BUS1 and BUS2: 400V/√3 PT, 3 x 3-phase, (resistor)';
              VCode : 'G'; H_VCode : 'R400VB2'; Value : hpptG),
         (Description : 'FEEDER, BUS1 and BUS2: 800V/√3 PT, 3 x 3-phase, (resistor)';
              VCode : 'H'; H_VCode : ''; Value : hpptH),
         (Description : 'FEEDER and BUS1: 100V/√3 PT, 2 x 3-phase, (galvanic isolated)';
              VCode : 'I'; H_VCode : 'PT100V'; Value : hpptI),
         (Description : 'FEEDER and BUS1: 400V/√3 PT, 2 x 3-phase, (galvanic isolated)';
              VCode : 'J'; H_VCode : 'PT400V'; Value : hpptJ),
         (Description : ''; VCode : ''; H_VCode : ''; Value : hpptFinal)
  );

  R_HiMAP_Phase_CT_Diff : array[hpctdNone..hpctdFinal] of record
    Description, VCode, H_VCode : string;
    Value       : THiMAP_Phase_CT_Diff;
  end = ((Description : ''; VCode : ''; H_VCode : ''; Value : hpctdNone),
         (Description : 'Standard (without)';
              VCode : '0'; H_VCode : 'D0'; Value : hpctd0),
         (Description : 'Generator/Motor (compensation), 1 x 3-phase (0-20×In); secondary rated current depends on selected ordering option of ordering identifier “3. Phase current translormer (CT)”';
              VCode : '1'; H_VCode : 'D1'; Value : hpctd1),
         (Description : '2-winding transformer (vector groups): 1A secondary rated current, 1 x 3-phase (0-20×In)';
              VCode : '2'; H_VCode : 'D2'; Value : hpctd2),
         (Description : '2-winding transformer (vector groups): 5A secondary rated current, 1 x 3-phase (0-20×In)';
              VCode : '3'; H_VCode : ''; Value : hpctd3),
         (Description : '3-winding transformer (vector groups): 1A, 1A secondary rated current, 2 x 3-phase (0-20×In)';
              VCode : '4'; H_VCode : 'D3'; Value : hpctd4),
         (Description : '3-winding transformer (vector groups): 5A, 5A secondary rated current, 2 x 3-phase (0-20×In)';
              VCode : '5'; H_VCode : ''; Value : hpctd5),
         (Description : '3-winding transformer (vector groups): 1A, 5A secondary rated current, 2 x 3-phase (0-20×In)';
              VCode : '6'; H_VCode : ''; Value : hpctd6),
         (Description : ''; VCode : ''; H_VCode : ''; Value : hpctdFinal)
  );

  R_HiMAP_CT_Ground : array[hcgNone..hcgFinal] of record
    Description, VCode, H_VCode : string;
    Value       : THiMAP_CT_Ground;
  end = ((Description : ''; VCode : ''; H_VCode : ''; Value : hcgNone),
         (Description : 'without';
              VCode : 'A'; H_VCode : 'GC0'; Value : hcgA),
         (Description : '1 x ground current input 1A, (0-20×In)';
              VCode : 'B'; H_VCode : 'GCS1'; Value : hcgB),
         (Description : '2 x ground current inputs 1A, (0-20×In); (only available without BUS2 or without PT ground!)';
              VCode : 'C'; H_VCode : 'GCS2'; Value : hcgC),
         (Description : '1 x sensitive ground current input, (0-20mA)';
              VCode : 'D'; H_VCode : 'GCS20'; Value : hcgD),
         (Description : '1 x sensitive ground current input, (0-100mA)';
              VCode : 'E'; H_VCode : 'GCS100'; Value : hcgE),
         (Description : '1 x ground current input 5A, (0-20×In)';
              VCode : 'F'; H_VCode : ''; Value : hcgF),
         (Description : '2 x ground current inputs 5A, (0-20×In); (only available without BUS2 or without PT ground!)';
              VCode : 'G'; H_VCode : ''; Value : hcgG),
         (Description : '1 x ground current input 1A, (0-20×In), and 1 x ground current input 5A, (0-20×In); (only available without BUS2 or without PT ground!)';              VCode : 'H'; H_VCode : ''; Value : hcgH),
         (Description : ''; VCode : ''; H_VCode : ''; Value : hcgFinal)
  );

  R_HiMAP_PT_Ground : array[hpgNone..hpgFinal] of record
    Description, VCode, H_VCode : string;
    Value       : THiMAP_PT_Ground;
  end = ((Description : ''; VCode : ''; H_VCode : ''; Value : hpgNone),
         (Description : 'without';
              VCode : '0'; H_VCode : 'GV0'; Value : hpg0),
         (Description : '1 x 100V/√3 PT, 1-phase, (resistor)';
              VCode : '1'; H_VCode : 'G1V100'; Value : hpg1),
         (Description : '1 x 200V/√3 PT, 1-phase, (resistor)';
              VCode : '2'; H_VCode : 'G1V200'; Value : hpg2),
         (Description : '1 x 400V/√3 PT, 1-phase, (resistor)';
              VCode : '3'; H_VCode : 'G1V400'; Value : hpg3),
         (Description : '1 x 800V/√3 PT, 1-phase, (resistor)';
              VCode : '4'; H_VCode : 'G1V800'; Value : hpg4),
         (Description : '2 x 100V/√3 PT, 1-phase, (resistor); (only available without BUS2 or without CT ground!)';
              VCode : '5'; H_VCode : 'G2V100'; Value : hpg5),
         (Description : '2 x 200V/√3 PT, 1-phase, (resistor); (only available without BUS2 or without CT ground!)';
              VCode : '6'; H_VCode : 'G2V200'; Value : hpg6),
         (Description : '2 x 400V/√3 PT, 1-phase, (resistor); (only available without BUS2 or without CT ground!)';
              VCode : '7'; H_VCode : 'G2V400'; Value : hpg7),
         (Description : '2 x 800V/√3 PT, 1-phase, (resistor); (only available without BUS2 or without CT ground!)';
              VCode : '8'; H_VCode : 'G2V800'; Value : hpg8),
         (Description : ''; VCode : ''; H_VCode : ''; Value : hpgFinal)
  );

  R_HiMAP_CANBUS : array[hcbNone..hcbFinal] of record
    Description, VCode, H_VCode : string;
    Value       : THiMAP_CANBUS;
  end = ((Description : ''; VCode : ''; H_VCode : ''; Value : hcbNone),
         (Description : 'CANBUS 1 (standard), connection terminals, up to 100m';
              VCode : 'A'; H_VCode : ''; Value : hcbA),
         (Description : 'CANBUS 1 and CANBUS 2 (engine control protocol or CANopen (SCADA)), connection terminals, up to 100m; (only available with “Recording unit”!)';
              VCode : 'B'; H_VCode : ''; Value : hcbB),
         (Description : 'CANBUS 1 and CANBUS 2 (redundance to CANBUS 1), connection terminals, up to 100m';
              VCode : 'C'; H_VCode : ''; Value : hcbC),
         (Description : ''; VCode : ''; H_VCode : ''; Value : hcbFinal)
  );

  R_HiMAP_PROFIBUS : array[hpbNone..hpbFinal] of record
    Description, VCode, H_VCode : string;
    Value       : THiMAP_PROFIBUS;
  end = ((Description : ''; VCode : ''; H_VCode : ''; Value : hpbNone),
         (Description : 'without';
              VCode : '0'; H_VCode : ''; Value : hpb0),
         (Description : 'PROFIBUS DP: RS485, DSUB-9';
              VCode : '1'; H_VCode : ''; Value : hpb1),
         (Description : 'PROFIBUS DP: fiber optic (plastic fibre), wavelength 660nm, ST® connector (BFOC), 400m';
              VCode : '2'; H_VCode : ''; Value : hpb2),
         (Description : ''; VCode : ''; H_VCode : ''; Value : hpbFinal)
  );

  R_HiMAP_SERIAL_INTERFACE : array[hsiNone..hsiFinal] of record
    Description, VCode, H_VCode : string;
    Value       : THiMAP_SERIAL_INTERFACE;
  end = ((Description : ''; VCode : ''; H_VCode : ''; Value : hsiNone),
         (Description : 'without';
              VCode : 'A'; H_VCode : ''; Value : hsiA),
         (Description : 'RS485';
              VCode : 'B'; H_VCode : ''; Value : hsiB),
         (Description : 'RS422/RS485';
              VCode : 'C'; H_VCode : ''; Value : hsiC),
         (Description : ''; VCode : ''; H_VCode : ''; Value : hsiFinal)
  );

  R_HiMAP_IEC_61850 : array[hi6None..hi6Final] of record
    Description, VCode, H_VCode : string;
    Value       : THiMAP_IEC_61850;
  end = ((Description : ''; VCode : ''; H_VCode : ''; Value : hi6None),
         (Description : 'without';
              VCode : '0'; H_VCode : ''; Value : hi60),
         (Description : 'IEC 61850: fiber optic (glass fibre); star connection (single); wavelength 1300nm, ST® connector (BFOC), 2km; only available without serial interface RS422/485!';
              VCode : '1'; H_VCode : ''; Value : hi61),
         (Description : ''; VCode : ''; H_VCode : ''; Value : hi6Final)
  );

  R_HiMAP_Analog_Output : array[haoNone..haoFinal] of record
    Description, VCode, H_VCode : string;
    Value       : THiMAP_Analog_Output;
  end = ((Description : ''; VCode : ''; H_VCode : ''; Value : haoNone),
         (Description : 'Common terminal: negative potential';
              VCode : 'A'; H_VCode : ''; Value : haoA),
         (Description : 'Common terminal: positive potential';
              VCode : 'B'; H_VCode : ''; Value : haoB),
         (Description : ''; VCode : ''; H_VCode : ''; Value : haoFinal)
  );

  R_HiMAP_Shunt1 : array[hs1None..hs1Final] of record
    Description, VCode, H_VCode : string;
    Value       : THiMAP_Shunt1;
  end = ((Description : ''; VCode : ''; H_VCode : ''; Value : hs1None),
         (Description : '”SHUNT1”-output: normally open (NO) (standard)';
              VCode : '0'; H_VCode : ''; Value : hs10),
         (Description : '”SHUNT1”-output: normally closed (NC)';
              VCode : '1'; H_VCode : ''; Value : hs11),
         (Description : ''; VCode : ''; H_VCode : ''; Value : hs1Final)
  );

  R_HiMAP_Front_Design : array[hpdNone..hpdFinal] of record
    Description, VCode, H_VCode : string;
    Value       : THiMAP_Front_Design;
  end = ((Description : ''; VCode : ''; H_VCode : ''; Value : hpdNone),
         (Description : 'Standard (“Stucke” design)';
              VCode : 'A'; H_VCode : ''; Value : hpdA),
         (Description : 'OEM design (on request)';
              VCode : 'B'; H_VCode : ''; Value : hpdB),
         (Description : ''; VCode : ''; H_VCode : ''; Value : hpdFinal)
  );

  R_HiMAP_Recording_Unit : array[hruNone..hruFinal] of record
    Description, VCode, H_VCode : string;
    Value       : THiMAP_Recording_Unit;
  end = ((Description : ''; VCode : ''; H_VCode : ''; Value : hruNone),
         (Description : 'without';
              VCode : '0'; H_VCode : 'RU0'; Value : hru0),
         (Description : 'Recording unit';
              VCode : '1'; H_VCode : 'RU1'; Value : hru1),
         (Description : ''; VCode : ''; H_VCode : ''; Value : hruFinal)
  );

  R_HiMAP_Communication : array[hcNone..hcFinal] of record
    Description, VCode, H_VCode : string;
    Value       : THiMAP_COMMUNICATION;
  end = ((Description : ''; VCode : ''; H_VCode : ''; Value : hcNone),
         (Description : 'standard (1 x CANBUS [P.M.]); 1 x RS232 [PC])';
              VCode : ''; H_VCode : 'C0'; Value : hcC0),
         (Description : 'additional CANBUS Port (direct engine control)';
              VCode : ''; H_VCode : 'C1'; Value : hcC1),
         (Description : 'additional RS422 or RS485 (MODBUS)';
              VCode : ''; H_VCode : 'C2'; Value : hcC2),
         (Description : 'additional PROFIBUS DP (RS485)';
              VCode : ''; H_VCode : 'C3'; Value : hcC3),
         (Description : 'additional PROFIBUS DP (fibre optic)';
              VCode : ''; H_VCode : 'C3F'; Value : hcC3F),
         (Description : 'additional RS232 port (fibre optic)';
              VCode : ''; H_VCode : 'C4F'; Value : hcC4F),
         (Description : 'addidional RS485 port (IEC60870-5-103)';
              VCode : ''; H_VCode : 'C5'; Value : hcC5),
         (Description : 'ISDN-Modem';
              VCode : ''; H_VCode : 'C6'; Value : hcC6),
         (Description : 'analog-Modem';
              VCode : ''; H_VCode : 'C7'; Value : hcC7),
         (Description : 'IEC61850 RJ45';
              VCode : ''; H_VCode : 'C8'; Value : hcC8),
         (Description : 'IEC61850 (fibre optic ST)';
              VCode : ''; H_VCode : 'C8F'; Value : hcC8F),
         (Description : 'additional CANBUS and RS422 or RS485 port';
              VCode : ''; H_VCode : 'C12'; Value : hcC12),
         (Description : 'additional CANBUS and PROFIBUS DP port (RS485)';
              VCode : ''; H_VCode : 'C13'; Value : hcC13),
         (Description : 'additional CANBUS and PROFIBUS DP port (RS485) and analog Modem';
              VCode : ''; H_VCode : 'C137'; Value : hcC137),
         (Description : 'Ring connection';
              VCode : ''; H_VCode : 'RC'; Value : hcRC),
         (Description : 'Star connection';
              VCode : ''; H_VCode : 'RS'; Value : hcRS),
         (Description : ''; VCode : ''; H_VCode : ''; Value : hcFinal)
  );

  R_HiMAP_Extended_Board : array[hebNone..hebFinal] of record
    Description, VCode, H_VCode : string;
    Value       : THiMAP_EXTENDED_BOARD;
  end = ((Description : ''; VCode : ''; H_VCode : ''; Value : hebNone),
         (Description : 'no connection';
              VCode : ''; H_VCode : '0'; Value : heb0),
         (Description : 'CMA 210 (16 x PT100)';
              VCode : ''; H_VCode : '1'; Value : heb1),
         (Description : 'CMA 211 (24 x binary inputs; 5 x PT100; 24 x binary outputs)';
              VCode : ''; H_VCode : '2'; Value : heb2),
         (Description : 'CMA 212 (16 x binary inputs; 18 x binary outputs)';
              VCode : ''; H_VCode : '3'; Value : heb3),
         (Description : 'CMA 216 (24 x binary inputs; 24 x binary outputs)';
              VCode : ''; H_VCode : '4'; Value : heb4),
         (Description : 'CMA 216 and CMA217 (24 x binary inputs; 6 x PT100; 24 x binary outputs)';
              VCode : ''; H_VCode : '5'; Value : heb5),
         (Description : 'CMA 218 (6 x PT100)';
              VCode : ''; H_VCode : '6'; Value : heb6),
         (Description : ''; VCode : ''; H_VCode : ''; Value : hebFinal)
  );

  R_HiMAP_Special_Config : array[hscNone..hscFinal] of record
    Description, VCode, H_VCode : string;
    Value       : THiMAP_SPECIAL_CONFIG;
  end = ((Description : ''; VCode : ''; H_VCode : ''; Value : hscNone),
         (Description : 'none';
              VCode : ''; H_VCode : '0'; Value : hsc0),
         (Description : 'ground insulation fault (for generator or motor rotor)';
              VCode : ''; H_VCode : '1'; Value : hsc1),
         (Description : 'with GPS module';
              VCode : ''; H_VCode : '2'; Value : hsc2),
         (Description : 'with additional Transponder access';
              VCode : ''; H_VCode : '3'; Value : hsc3),
         (Description : 'Shunt1 output normally closed (standard: n. o.)';
              VCode : ''; H_VCode : '4'; Value : hsc4),
         (Description : ''; VCode : ''; H_VCode : ''; Value : hscFinal)
  );

  R_HiMAP_Normal_Frequency : array[hnfNone..hnfFinal] of record
    Description, VCode, H_VCode : string;
    Value       : THiMAP_NORMAL_FREQUENCY;
  end = ((Description : ''; VCode : ''; H_VCode : ''; Value : hnfNone),
         (Description : '50Hz';
              VCode : ''; H_VCode : '1'; Value : hnf1),
         (Description : '60Hz';
              VCode : ''; H_VCode : '2'; Value : hnf2),
         (Description : ''; VCode : ''; H_VCode : ''; Value : hnfFinal)
  );

  R_HiMAP_FrontPanel_Type : array[hftNone..hftFinal] of record
    Description, VCode, H_VCode : string;
    Value       : THiMAP_FRONTPANEL_TYPE;
  end = ((Description : ''; VCode : ''; H_VCode : ''; Value : hftNone),
         (Description : 'SYMAP-BC Stucke';
              VCode : ''; H_VCode : '1'; Value : hft1),
         (Description : 'SYMAP-BCG Stucke';
              VCode : ''; H_VCode : '2'; Value : hft2),
         (Description : 'SYMAP-BCG Stucke without prog-connector';
              VCode : ''; H_VCode : '3'; Value : hft3),
         (Description : '';
              VCode : ''; H_VCode : '4'; Value : hft4),
         (Description : '';
              VCode : ''; H_VCode : '5'; Value : hft5),
         (Description : 'SYMAP-X Stucke';
              VCode : ''; H_VCode : '6'; Value : hft6),
         (Description : 'SYMAP-XG Stucke';
              VCode : ''; H_VCode : '7'; Value : hft7),
         (Description : 'Customer-specific constructions are of spezial request available(with notation)';
              VCode : ''; H_VCode : '8'; Value : hft8),
         (Description : '';
              VCode : ''; H_VCode : 'X'; Value : hftX),
         (Description : ''; VCode : ''; H_VCode : ''; Value : hftFinal)
  );

function HDT2Desc(AHDT:THiMAP_Device_Type) : string;
function Desc2HDT(AHDT:string): THiMAP_Device_Type;
function HDT2VCode(AHDT:THiMAP_Device_Type) : string;
function VCode2HDT(AHDT:string): THiMAP_Device_Type;
function HDT2HVCode(AHDT:THiMAP_Device_Type) : string;
function HVCode2HDT(AHDT:string): THiMAP_Device_Type;

function HDV2Desc(AHDV:THiMAP_Device_Variant) : string;
function Desc2HDV(AHDV:string): THiMAP_Device_Variant;
function HDV2VCode(AHDV:THiMAP_Device_Variant) : string;
function VCode2HDV(AHDV:string): THiMAP_Device_Variant;
function HDV2HVCode(AHDV:THiMAP_Device_Variant) : string;
function HVCode2HDV(AHDV:string): THiMAP_Device_Variant;
procedure HDV2Combo(AComboBox:TComboBox);
procedure HDV2Combo2(AComboBox:TComboBox);

function HDV2ToDesc(AHDV2:THiMAP_Device_Variant2) : string;
function DescToHDV2(AHDV2:string): THiMAP_Device_Variant2;
function HDV2ToHVCode(AHDV2:THiMAP_Device_Variant2) : string;
function HVCodeToHDV2(AHDV2:string): THiMAP_Device_Variant2;
procedure HDV2ToCombo2(AComboBox:TComboBox);

function HFIT2Desc(AHFIT:THiMAP_FI_Type) : string;
function Desc2HFIT(AHFIT:string): THiMAP_FI_Type;
function HFIT2HVCode(AHFIT:THiMAP_FI_Type) : string;
function HVCode2HFIT(AHFIT:string): THiMAP_FI_Type;
procedure HFIT2Combo2(AComboBox:TComboBox);

function HMT2Desc(AHMT:THiMAP_M_Type) : string;
function Desc2HMT(AHMT:string): THiMAP_M_Type;
function HMT2HVCode(AHMT:THiMAP_M_Type) : string;
function HVCode2HMT(AHMT:string): THiMAP_M_Type;
procedure HMT2Combo2(AComboBox:TComboBox);

function HTT2Desc(AHTT:THiMAP_T_Type) : string;
function Desc2HTT(AHTT:string): THiMAP_T_Type;
function HTT2HVCode(AHTT:THiMAP_T_Type) : string;
function HVCode2HTT(AHTT:string): THiMAP_T_Type;
procedure HTT2Combo2(AComboBox:TComboBox);

function HBCSFT2Desc(AHBCSFT:THiMAP_BCSF_Type) : string;
function Desc2HBCSFT(AHBCSFT:string): THiMAP_BCSF_Type;
function HBCSFT2HVCode(AHBCSFT:THiMAP_BCSF_Type) : string;
function HVCode2HBCSFT(AHBCSFT:string): THiMAP_BCSF_Type;
procedure HBCSFT2Combo2(AComboBox:TComboBox);

function HBCSTT2Desc(AHBCSTT:THiMAP_BCST_Type) : string;
function Desc2HBCSTT(AHBCSTT:string): THiMAP_BCST_Type;
function HBCSTT2HVCode(AHBCSTT:THiMAP_BCST_Type) : string;
function HVCode2HBCSTT(AHBCSTT:string): THiMAP_BCST_Type;
procedure HBCSTT2Combo2(AComboBox:TComboBox);

function HBCSLT2Desc(AHBCSLT:THiMAP_BCSL_Type) : string;
function Desc2HBCSLT(AHBCSLT:string): THiMAP_BCSL_Type;
function HBCSLT2HVCode(AHBCSLT:THiMAP_BCSL_Type) : string;
function HVCode2HBCSLT(AHBCSLT:string): THiMAP_BCSL_Type;
procedure HBCSLT2Combo2(AComboBox:TComboBox);

function HBCSGT2Desc(AHBCSGT:THiMAP_BCSG_Type) : string;
function Desc2HBCSGT(AHBCSGT:string): THiMAP_BCSG_Type;
function HBCSGT2HVCode(AHBCSGT:THiMAP_BCSG_Type) : string;
function HVCode2HBCSGT(AHBCSGT:string): THiMAP_BCSG_Type;
procedure HBCSGT2Combo2(AComboBox:TComboBox);

function HFT2Desc(AHFT:THiMAP_F_Type) : string;
function Desc2HFT(AHFT:string): THiMAP_F_Type;
function HFT2HVCode(AHFT:THiMAP_F_Type) : string;
function HVCode2HFT(AHFT:string): THiMAP_F_Type;
procedure HFT2Combo2(AComboBox:TComboBox);

function HIIT2Desc(AHIIT:THiCAM_II_Type) : string;
function Desc2HIIT(AHIIT:string): THiCAM_II_Type;
function HIIT2HVCode(AHIIT:THiCAM_II_Type) : string;
function HVCode2HIIT(AHIIT:string): THiCAM_II_Type;
procedure HIIT2Combo2(AComboBox:TComboBox);

function HST2Desc(AHST:THiCAM_S_Type) : string;
function Desc2HST(AHST:string): THiCAM_S_Type;
function HST2HVCode(AHST:THiCAM_S_Type) : string;
function HVCode2HST(AHST:string): THiCAM_S_Type;
procedure HST2Combo2(AComboBox:TComboBox);

function HSDCT2Desc(AHSDCT:THiCAM_SDC_Type) : string;
function Desc2HSDCT(AHSDCT:string): THiCAM_SDC_Type;
function HSDCT2HVCode(AHSDCT:THiCAM_SDC_Type) : string;
function HVCode2HSDCT(AHSDCT:string): THiCAM_SDC_Type;
procedure HSDCT2Combo2(AComboBox:TComboBox);

function HPS2Desc(AHPS:THiMAP_Power_Supply) : string;
function Desc2HPS(AHPS:string): THiMAP_Power_Supply;
function HPS2VCode(AHPS:THiMAP_Power_Supply) : string;
function VCode2HPS(AHPS:string): THiMAP_Power_Supply;
function HPS2HVCode(AHPS:THiMAP_Power_Supply) : string;
function HVCode2HPS(AHPS:string): THiMAP_Power_Supply;
procedure HPS2Combo(AComboBox:TComboBox);
procedure HPS2Combo2(AComboBox:TComboBox);

function HPCT2Desc(AHPCT:THiMAP_Phase_CT) : string;
function Desc2HPCT(AHPCT:string): THiMAP_Phase_CT;
function HPCT2VCode(AHPCT:THiMAP_Phase_CT) : string;
function VCode2HPCT(AHPCT:string): THiMAP_Phase_CT;
function HPCT2HVCode(AHPCT:THiMAP_Phase_CT) : string;
function HVCode2HPCT(AHPCT:string): THiMAP_Phase_CT;
procedure HPCT2Combo(AComboBox:TComboBox);
procedure HPCT2Combo2(AComboBox:TComboBox);

function HPPT2Desc(AHPPT:THiMAP_Phase_PT) : string;
function Desc2HPPT(AHPPT:string): THiMAP_Phase_PT;
function HPPT2VCode(AHPPT:THiMAP_Phase_PT) : string;
function VCode2HPPT(AHPPT:string): THiMAP_Phase_PT;
function HPPT2HVCode(AHPPT:THiMAP_Phase_PT) : string;
function HVCode2HPPT(AHPPT:string): THiMAP_Phase_PT;
procedure HPPT2Combo(AComboBox:TComboBox);
procedure HPPT2Combo2(AComboBox:TComboBox);

function HPCTD2Desc(AHPCTD:THiMAP_Phase_CT_Diff) : string;
function Desc2HPCTD(AHPCTD:string): THiMAP_Phase_CT_Diff;
function HPCTD2VCode(AHPCTD:THiMAP_Phase_CT_Diff) : string;
function VCode2HPCTD(AHPCTD:string): THiMAP_Phase_CT_Diff;
function HPCTD2HVCode(AHPCTD:THiMAP_Phase_CT_Diff) : string;
function HVCode2HPCTD(AHPCTD:string): THiMAP_Phase_CT_Diff;
procedure HPCTD2Combo(AComboBox:TComboBox);
procedure HPCTD2Combo2(AComboBox:TComboBox);

function HCTG2Desc(AHCTG:THiMAP_CT_Ground) : string;
function Desc2HCTG(AHCTG:string): THiMAP_CT_Ground;
function HCTG2VCode(AHCTG:THiMAP_CT_Ground) : string;
function VCode2HCTG(AHCTG:string): THiMAP_CT_Ground;
function HCTG2HVCode(AHCTG:THiMAP_CT_Ground) : string;
function HVCode2HCTG(AHCTG:string): THiMAP_CT_Ground;
procedure HCTG2Combo(AComboBox:TComboBox);
procedure HCTG2Combo2(AComboBox:TComboBox);

function HPTG2Desc(AHPTG:THiMAP_PT_Ground) : string;
function Desc2HPTG(AHPTG:string): THiMAP_PT_Ground;
function HPTG2VCode(AHPTG:THiMAP_PT_Ground) : string;
function VCode2HPTG(AHPTG:string): THiMAP_PT_Ground;
function HPTG2HVCode(AHPTG:THiMAP_PT_Ground) : string;
function HVCode2HPTG(AHPTG:string): THiMAP_PT_Ground;
procedure HPTG2Combo(AComboBox:TComboBox);
procedure HPTG2Combo2(AComboBox:TComboBox);

function HCB2Desc(AHCB:THiMAP_CANBUS) : string;
function Desc2HCB(AHCB:string): THiMAP_CANBUS;
function HCB2VCode(AHCB:THiMAP_CANBUS) : string;
function VCode2HCB(AHCB:string): THiMAP_CANBUS;
function HCB2HVCode(AHCB:THiMAP_CANBUS) : string;
function HVCode2HCB(AHCB:string): THiMAP_CANBUS;
procedure HCB2Combo(AComboBox:TComboBox);
procedure HCB2Combo2(AComboBox:TComboBox);

function HPB2Desc(AHPB:THiMAP_PROFIBUS) : string;
function Desc2HPB(AHPB:string): THiMAP_PROFIBUS;
function HPB2VCode(AHPB:THiMAP_PROFIBUS) : string;
function VCode2HPB(AHPB:string): THiMAP_PROFIBUS;
function HPB2HVCode(AHPB:THiMAP_PROFIBUS) : string;
function HVCode2HPB(AHPB:string): THiMAP_PROFIBUS;
procedure HPB2Combo(AComboBox:TComboBox);
procedure HPB2Combo2(AComboBox:TComboBox);

function HSI2Desc(AHSI:THiMAP_SERIAL_INTERFACE) : string;
function Desc2HSI(AHSI:string): THiMAP_SERIAL_INTERFACE;
function HSI2VCode(AHSI:THiMAP_SERIAL_INTERFACE) : string;
function VCode2HSI(AHSI:string): THiMAP_SERIAL_INTERFACE;
function HSI2HVCode(AHSI:THiMAP_SERIAL_INTERFACE) : string;
function HVCode2HSI(AHSI:string): THiMAP_SERIAL_INTERFACE;
procedure HSI2Combo(AComboBox:TComboBox);
procedure HSI2Combo2(AComboBox:TComboBox);

function HIEC618502Desc(AHI6:THiMAP_IEC_61850) : string;
function Desc2HIEC61850(AHI6:string): THiMAP_IEC_61850;
function HIEC618502VCode(AHI6:THiMAP_IEC_61850) : string;
function VCode2HIEC61850(AHI6:string): THiMAP_IEC_61850;
function HIEC618502HVCode(AHI6:THiMAP_IEC_61850) : string;
function HVCode2HIEC61850(AHI6:string): THiMAP_IEC_61850;
procedure HIEC618502Combo(AComboBox:TComboBox);
procedure HIEC618502Combo2(AComboBox:TComboBox);

function HAO2Desc(AHAO:THiMAP_Analog_Output) : string;
function Desc2HAO(AHAO:string): THiMAP_Analog_Output;
function HAO2VCode(AHAO:THiMAP_Analog_Output) : string;
function VCode2HAO(AHAO:string): THiMAP_Analog_Output;
function HAO2HVCode(AHAO:THiMAP_Analog_Output) : string;
function HVCode2HAO(AHAO:string): THiMAP_Analog_Output;
procedure HAO2Combo(AComboBox:TComboBox);
procedure HAO2Combo2(AComboBox:TComboBox);

function HS12Desc(AS1:THiMAP_Shunt1) : string;
function Desc2HS1(AS1:string): THiMAP_Shunt1;
function HS12VCode(AS1:THiMAP_Shunt1) : string;
function VCode2HS1(AS1:string): THiMAP_Shunt1;
function HS12HVCode(AS1:THiMAP_Shunt1) : string;
function HVCode2HS1(AS1:string): THiMAP_Shunt1;
procedure HS12Combo(AComboBox:TComboBox);
procedure HS12Combo2(AComboBox:TComboBox);

function HFrontDesign2Desc(AFD:THiMAP_Front_Design) : string;
function Desc2HFrontDesign(AFD:string): THiMAP_Front_Design;
function HFrontDesign2VCode(AFD:THiMAP_Front_Design) : string;
function VCode2HFrontDesign(AFD:string): THiMAP_Front_Design;
function HFrontDesign2HVCode(AFD:THiMAP_Front_Design) : string;
function HVCode2HFrontDesign(AFD:string): THiMAP_Front_Design;
procedure HFrontDesign2Combo(AComboBox:TComboBox);
procedure HFrontDesign2Combo2(AComboBox:TComboBox);

function HRecordingUnit2Desc(ARU:THiMAP_Recording_Unit) : string;
function Desc2HRecordingUnit(ARU:string): THiMAP_Recording_Unit;
function HRecordingUnit2VCode(ARU:THiMAP_Recording_Unit) : string;
function VCode2HRecordingUnit(ARU:string): THiMAP_Recording_Unit;
function HRecordingUnit2HVCode(ARU:THiMAP_Recording_Unit) : string;
function HVCode2HRecordingUnit(ARU:string): THiMAP_Recording_Unit;
procedure HRecordingUnit2Combo(AComboBox:TComboBox);
procedure HRecordingUnit2Combo2(AComboBox:TComboBox);

function HCommunication2Desc(AComm:THiMAP_COMMUNICATION) : string;
function Desc2HCommunication(AComm:string): THiMAP_COMMUNICATION;
function HCommunication2HVCode(AComm:THiMAP_COMMUNICATION) : string;
function HVCode2HCommunication(AComm:string): THiMAP_COMMUNICATION;
procedure HCommunication2Combo2(AComboBox:TComboBox);

function HExtBoard2Desc(AExtBrd:THiMAP_EXTENDED_BOARD) : string;
function Desc2HExtBoard(AExtBrd:string): THiMAP_EXTENDED_BOARD;
function HExtBoard2HVCode(AExtBrd:THiMAP_EXTENDED_BOARD) : string;
function HVCode2HExtBoard(AExtBrd:string): THiMAP_EXTENDED_BOARD;
procedure HExtBoard2Combo2(AComboBox:TComboBox);

function HSpecialConfig2Desc(ASepecialConfig:THiMAP_SPECIAL_CONFIG) : string;
function HSpecialConfigs2Desc(ASepecialConfigs:string) : string;
function Desc2HSpecialConfig(ASepecialConfig:string): THiMAP_SPECIAL_CONFIG;
function HSpecialConfig2HVCode(ASepecialConfig:THiMAP_SPECIAL_CONFIG) : string;
function HVCode2HSpecialConfig(ASepecialConfig:string): THiMAP_SPECIAL_CONFIG;
procedure HSpecialConfig2Combo2(AComboBox:TComboBox);
procedure HSpecialConfig2List(AList:TStrings);
function HiMAP_SPECIAL_CONFIG_SetToInt(ss : THiMAP_SPECIAL_CONFIGs) : integer;
function IntToHiMAP_SPECIAL_CONFIG_Set(mask : integer) : THiMAP_SPECIAL_CONFIGs;
function HVCodes2HiMAP_SPECIAL_CONFIG_Set(ASepecialConfig:string): THiMAP_SPECIAL_CONFIGs;

function HNormalFreq2Desc(ANormalFreq:THiMAP_NORMAL_FREQUENCY) : string;
function Desc2HNormalFreq(ANormalFreq:string): THiMAP_NORMAL_FREQUENCY;
function HNormalFreq2HVCode(ANormalFreq:THiMAP_NORMAL_FREQUENCY) : string;
function HVCode2HNormalFreq(ANormalFreq:string): THiMAP_NORMAL_FREQUENCY;
procedure HNormalFreq2Combo2(AComboBox:TComboBox);

function HFrontType2Desc(AFrontType:THiMAP_FRONTPANEL_TYPE) : string;
function Desc2HFrontType(AFrontType:string): THiMAP_FRONTPANEL_TYPE;
function HFrontType2HVCode(AFrontType:THiMAP_FRONTPANEL_TYPE) : string;
function HVCode2HFrontType(AFrontType:string): THiMAP_FRONTPANEL_TYPE;
procedure HFrontType2Combo2(AComboBox:TComboBox);

implementation

function HDT2Desc(AHDT:THiMAP_Device_Type) : string;
begin
  if AHDT <= High(THiMAP_Device_Type) then
    Result := R_HiMAP_Device_Type[AHDT].Description;
end;

function Desc2HDT(AHDT:string): THiMAP_Device_Type;
var Li: THiMAP_Device_Type;
begin
  for Li := Low(THiMAP_Device_Type) to High(THiMAP_Device_Type) do
  begin
    if R_HiMAP_Device_Type[Li].Description = AHDT then
    begin
      Result := R_HiMAP_Device_Type[Li].Value;
      exit;
    end;
  end;
end;

function HDT2VCode(AHDT:THiMAP_Device_Type) : string;
begin
  if AHDT <= High(THiMAP_Device_Type) then
    Result := R_HiMAP_Device_Type[AHDT].VCode;
end;

function VCode2HDT(AHDT:string): THiMAP_Device_Type;
var Li: THiMAP_Device_Type;
begin
  for Li := Low(THiMAP_Device_Type) to High(THiMAP_Device_Type) do
  begin
    if R_HiMAP_Device_Type[Li].VCode = AHDT then
    begin
      Result := R_HiMAP_Device_Type[Li].Value;
      exit;
    end;
  end;
end;

function HDT2HVCode(AHDT:THiMAP_Device_Type) : string;
begin
  if AHDT <= High(THiMAP_Device_Type) then
    Result := R_HiMAP_Device_Type[AHDT].H_VCode;
end;

function HVCode2HDT(AHDT:string): THiMAP_Device_Type;
var Li: THiMAP_Device_Type;
begin
  for Li := Low(THiMAP_Device_Type) to High(THiMAP_Device_Type) do
  begin
    if R_HiMAP_Device_Type[Li].H_VCode = AHDT then
    begin
      Result := R_HiMAP_Device_Type[Li].Value;
      exit;
    end;
  end;
end;

function HDV2Desc(AHDV:THiMAP_Device_Variant) : string;
begin
  if AHDV <= High(THiMAP_Device_Variant) then
    Result := R_HiMAP_Device_Variant[AHDV].Description;
end;

function Desc2HDV(AHDV:string): THiMAP_Device_Variant;
var Li: THiMAP_Device_Variant;
begin
  for Li := Low(THiMAP_Device_Variant) to High(THiMAP_Device_Variant) do
  begin
    if R_HiMAP_Device_Variant[Li].Description = AHDV then
    begin
      Result := R_HiMAP_Device_Variant[Li].Value;
      exit;
    end;
  end;
end;

function HDV2VCode(AHDV:THiMAP_Device_Variant) : string;
begin
  if AHDV <= High(THiMAP_Device_Variant) then
    Result := R_HiMAP_Device_Variant[AHDV].VCode;
end;

function VCode2HDV(AHDV:string): THiMAP_Device_Variant;
var Li: THiMAP_Device_Variant;
begin
  for Li := Low(THiMAP_Device_Variant) to High(THiMAP_Device_Variant) do
  begin
    if R_HiMAP_Device_Variant[Li].VCode = AHDV then
    begin
      Result := R_HiMAP_Device_Variant[Li].Value;
      exit;
    end;
  end;
end;

function HDV2HVCode(AHDV:THiMAP_Device_Variant) : string;
begin
  if AHDV <= High(THiMAP_Device_Variant) then
    Result := R_HiMAP_Device_Variant[AHDV].H_VCode;
end;

function HVCode2HDV(AHDV:string): THiMAP_Device_Variant;
var Li: THiMAP_Device_Variant;
begin
  for Li := Low(THiMAP_Device_Variant) to High(THiMAP_Device_Variant) do
  begin
    if R_HiMAP_Device_Variant[Li].H_VCode = AHDV then
    begin
      Result := R_HiMAP_Device_Variant[Li].Value;
      exit;
    end;
  end;
end;

procedure HDV2Combo(AComboBox:TComboBox);
var Li: THiMAP_Device_Variant;
begin
  AComboBox.Clear;

  for Li := Low(THiMAP_Device_Variant) to Pred(High(THiMAP_Device_Variant)) do
  begin
    if Li = Low(THiMAP_Device_Variant) then
      AComboBox.Items.Add(R_HiMAP_Device_Variant[Li].Description)
    else
      AComboBox.Items.Add(R_HiMAP_Device_Variant[Li].VCode + ' : ' + R_HiMAP_Device_Variant[Li].Description);
  end;
end;

procedure HDV2Combo2(AComboBox:TComboBox);
var
  Li: THiMAP_Device_Variant;
begin
  AComboBox.Clear;

  for Li := Low(THiMAP_Device_Variant) to Pred(High(THiMAP_Device_Variant)) do
  begin
    if Li = Low(THiMAP_Device_Variant) then
      AComboBox.Items.Add(R_HiMAP_Device_Variant[Li].Description)
    else
    if R_HiMAP_Device_Variant[Li].H_VCode <> '' then
      AComboBox.Items.Add(R_HiMAP_Device_Variant[Li].H_VCode + ' : ' + R_HiMAP_Device_Variant[Li].Description);
  end;
end;

function HDV2ToDesc(AHDV2:THiMAP_Device_Variant2) : string;
begin
  if AHDV2 <= High(THiMAP_Device_Variant2) then
    Result := R_HiMAP_Device_Variant2[AHDV2].Description;
end;

function DescToHDV2(AHDV2:string): THiMAP_Device_Variant2;
var Li: THiMAP_Device_Variant2;
begin
  for Li := Low(THiMAP_Device_Variant2) to High(THiMAP_Device_Variant2) do
  begin
    if R_HiMAP_Device_Variant2[Li].Description = AHDV2 then
    begin
      Result := R_HiMAP_Device_Variant2[Li].Value;
      exit;
    end;
  end;
end;

function HDV2ToHVCode(AHDV2:THiMAP_Device_Variant2) : string;
begin
  if AHDV2 <= High(THiMAP_Device_Variant2) then
    Result := R_HiMAP_Device_Variant2[AHDV2].H_VCode;
end;

function HVCodeToHDV2(AHDV2:string): THiMAP_Device_Variant2;
var Li: THiMAP_Device_Variant2;
begin
  for Li := Low(THiMAP_Device_Variant2) to High(THiMAP_Device_Variant2) do
  begin
    if R_HiMAP_Device_Variant2[Li].H_VCode = AHDV2 then
    begin
      Result := R_HiMAP_Device_Variant2[Li].Value;
      exit;
    end;
  end;
end;

procedure HDV2ToCombo2(AComboBox:TComboBox);
var
  Li: THiMAP_Device_Variant2;
begin
  AComboBox.Clear;

  for Li := Low(THiMAP_Device_Variant2) to Pred(High(THiMAP_Device_Variant2)) do
  begin
    if Li = Low(THiMAP_Device_Variant2) then
      AComboBox.Items.Add(R_HiMAP_Device_Variant2[Li].Description)
    else
    if R_HiMAP_Device_Variant2[Li].H_VCode <> '' then
      AComboBox.Items.Add(R_HiMAP_Device_Variant2[Li].H_VCode + ' : ' + R_HiMAP_Device_Variant2[Li].Description);
  end;
end;

function HFIT2Desc(AHFIT:THiMAP_FI_Type) : string;
begin
  if AHFIT <= High(THiMAP_FI_Type) then
    Result := R_HiMAP_FI_Type[AHFIT].Description;
end;

function Desc2HFIT(AHFIT:string): THiMAP_FI_Type;
var Li: THiMAP_FI_Type;
begin
  for Li := Low(THiMAP_FI_Type) to High(THiMAP_FI_Type) do
  begin
    if R_HiMAP_FI_Type[Li].Description = AHFIT then
    begin
      Result := R_HiMAP_FI_Type[Li].Value;
      exit;
    end;
  end;
end;

function HFIT2HVCode(AHFIT:THiMAP_FI_Type) : string;
begin
  if AHFIT <= High(THiMAP_FI_Type) then
    Result := R_HiMAP_FI_Type[AHFIT].H_VCode;
end;

function HVCode2HFIT(AHFIT:string): THiMAP_FI_Type;
var Li: THiMAP_FI_Type;
begin
  for Li := Low(THiMAP_FI_Type) to High(THiMAP_FI_Type) do
  begin
    if R_HiMAP_FI_Type[Li].H_VCode = AHFIT then
    begin
      Result := R_HiMAP_FI_Type[Li].Value;
      exit;
    end;
  end;
end;

procedure HFIT2Combo2(AComboBox:TComboBox);
var
  Li: THiMAP_FI_Type;
begin
  AComboBox.Clear;

  for Li := Low(THiMAP_FI_Type) to Pred(High(THiMAP_FI_Type)) do
  begin
    if Li = Low(THiMAP_FI_Type) then
      AComboBox.Items.Add(R_HiMAP_FI_Type[Li].Description)
    else
    if R_HiMAP_FI_Type[Li].H_VCode <> '' then
      AComboBox.Items.Add(R_HiMAP_FI_Type[Li].H_VCode + ' : ' + R_HiMAP_FI_Type[Li].Description);
  end;
end;

function HMT2Desc(AHMT:THiMAP_M_Type) : string;
begin
  if AHMT <= High(THiMAP_M_Type) then
    Result := R_HiMAP_M_Type[AHMT].Description;
end;

function Desc2HMT(AHMT:string): THiMAP_M_Type;
var Li: THiMAP_M_Type;
begin
  for Li := Low(THiMAP_M_Type) to High(THiMAP_M_Type) do
  begin
    if R_HiMAP_M_Type[Li].Description = AHMT then
    begin
      Result := R_HiMAP_M_Type[Li].Value;
      exit;
    end;
  end;
end;

function HMT2HVCode(AHMT:THiMAP_M_Type) : string;
begin
  if AHMT <= High(THiMAP_M_Type) then
    Result := R_HiMAP_M_Type[AHMT].H_VCode;
end;

function HVCode2HMT(AHMT:string): THiMAP_M_Type;
var Li: THiMAP_M_Type;
begin
  for Li := Low(THiMAP_M_Type) to High(THiMAP_M_Type) do
  begin
    if R_HiMAP_M_Type[Li].H_VCode = AHMT then
    begin
      Result := R_HiMAP_M_Type[Li].Value;
      exit;
    end;
  end;
end;

procedure HMT2Combo2(AComboBox:TComboBox);
var
  Li: THiMAP_M_Type;
begin
  AComboBox.Clear;

  for Li := Low(THiMAP_M_Type) to Pred(High(THiMAP_M_Type)) do
  begin
    if Li = Low(THiMAP_M_Type) then
      AComboBox.Items.Add(R_HiMAP_M_Type[Li].Description)
    else
    if R_HiMAP_M_Type[Li].H_VCode <> '' then
      AComboBox.Items.Add(R_HiMAP_M_Type[Li].H_VCode + ' : ' + R_HiMAP_M_Type[Li].Description);
  end;
end;

function HTT2Desc(AHTT:THiMAP_T_Type) : string;
begin
  if AHTT <= High(THiMAP_T_Type) then
    Result := R_HiMAP_T_Type[AHTT].Description;
end;

function Desc2HTT(AHTT:string): THiMAP_T_Type;
var Li: THiMAP_T_Type;
begin
  for Li := Low(THiMAP_T_Type) to High(THiMAP_T_Type) do
  begin
    if R_HiMAP_T_Type[Li].Description = AHTT then
    begin
      Result := R_HiMAP_T_Type[Li].Value;
      exit;
    end;
  end;
end;

function HTT2HVCode(AHTT:THiMAP_T_Type) : string;
begin
  if AHTT <= High(THiMAP_T_Type) then
    Result := R_HiMAP_T_Type[AHTT].H_VCode;
end;

function HVCode2HTT(AHTT:string): THiMAP_T_Type;
var Li: THiMAP_T_Type;
begin
  for Li := Low(THiMAP_T_Type) to High(THiMAP_T_Type) do
  begin
    if R_HiMAP_T_Type[Li].H_VCode = AHTT then
    begin
      Result := R_HiMAP_T_Type[Li].Value;
      exit;
    end;
  end;
end;

procedure HTT2Combo2(AComboBox:TComboBox);
var
  Li: THiMAP_T_Type;
begin
  AComboBox.Clear;

  for Li := Low(THiMAP_T_Type) to Pred(High(THiMAP_T_Type)) do
  begin
    if Li = Low(THiMAP_T_Type) then
      AComboBox.Items.Add(R_HiMAP_T_Type[Li].Description)
    else
    if R_HiMAP_T_Type[Li].H_VCode <> '' then
      AComboBox.Items.Add(R_HiMAP_T_Type[Li].H_VCode + ' : ' + R_HiMAP_T_Type[Li].Description);
  end;
end;

function HBCSFT2Desc(AHBCSFT:THiMAP_BCSF_Type) : string;
begin
  if AHBCSFT <= High(THiMAP_BCSF_Type) then
    Result := R_HiMAP_BCSF_Type[AHBCSFT].Description;
end;

function Desc2HBCSFT(AHBCSFT:string): THiMAP_BCSF_Type;
var Li: THiMAP_BCSF_Type;
begin
  for Li := Low(THiMAP_BCSF_Type) to High(THiMAP_BCSF_Type) do
  begin
    if R_HiMAP_BCSF_Type[Li].Description = AHBCSFT then
    begin
      Result := R_HiMAP_BCSF_Type[Li].Value;
      exit;
    end;
  end;
end;

function HBCSFT2HVCode(AHBCSFT:THiMAP_BCSF_Type) : string;
begin
  if AHBCSFT <= High(THiMAP_BCSF_Type) then
    Result := R_HiMAP_BCSF_Type[AHBCSFT].H_VCode;
end;

function HVCode2HBCSFT(AHBCSFT:string): THiMAP_BCSF_Type;
var Li: THiMAP_BCSF_Type;
begin
  for Li := Low(THiMAP_BCSF_Type) to High(THiMAP_BCSF_Type) do
  begin
    if R_HiMAP_BCSF_Type[Li].H_VCode = AHBCSFT then
    begin
      Result := R_HiMAP_BCSF_Type[Li].Value;
      exit;
    end;
  end;
end;

procedure HBCSFT2Combo2(AComboBox:TComboBox);
var
  Li: THiMAP_BCSF_Type;
begin
  AComboBox.Clear;

  for Li := Low(THiMAP_BCSF_Type) to Pred(High(THiMAP_BCSF_Type)) do
  begin
    if Li = Low(THiMAP_BCSF_Type) then
      AComboBox.Items.Add(R_HiMAP_BCSF_Type[Li].Description)
    else
    if R_HiMAP_BCSF_Type[Li].H_VCode <> '' then
      AComboBox.Items.Add(R_HiMAP_BCSF_Type[Li].H_VCode + ' : ' + R_HiMAP_BCSF_Type[Li].Description);
  end;
end;

function HBCSTT2Desc(AHBCSTT:THiMAP_BCST_Type) : string;
begin
  if AHBCSTT <= High(THiMAP_BCST_Type) then
    Result := R_HiMAP_BCST_Type[AHBCSTT].Description;
end;

function Desc2HBCSTT(AHBCSTT:string): THiMAP_BCST_Type;
var Li: THiMAP_BCST_Type;
begin
  for Li := Low(THiMAP_BCST_Type) to High(THiMAP_BCST_Type) do
  begin
    if R_HiMAP_BCST_Type[Li].Description = AHBCSTT then
    begin
      Result := R_HiMAP_BCST_Type[Li].Value;
      exit;
    end;
  end;
end;

function HBCSTT2HVCode(AHBCSTT:THiMAP_BCST_Type) : string;
begin
  if AHBCSTT <= High(THiMAP_BCST_Type) then
    Result := R_HiMAP_BCST_Type[AHBCSTT].H_VCode;
end;

function HVCode2HBCSTT(AHBCSTT:string): THiMAP_BCST_Type;
var Li: THiMAP_BCST_Type;
begin
  for Li := Low(THiMAP_BCST_Type) to High(THiMAP_BCST_Type) do
  begin
    if R_HiMAP_BCST_Type[Li].H_VCode = AHBCSTT then
    begin
      Result := R_HiMAP_BCST_Type[Li].Value;
      exit;
    end;
  end;
end;

procedure HBCSTT2Combo2(AComboBox:TComboBox);
var
  Li: THiMAP_BCST_Type;
begin
  AComboBox.Clear;

  for Li := Low(THiMAP_BCST_Type) to Pred(High(THiMAP_BCST_Type)) do
  begin
    if Li = Low(THiMAP_BCST_Type) then
      AComboBox.Items.Add(R_HiMAP_BCST_Type[Li].Description)
    else
    if R_HiMAP_BCST_Type[Li].H_VCode <> '' then
      AComboBox.Items.Add(R_HiMAP_BCST_Type[Li].H_VCode + ' : ' + R_HiMAP_BCST_Type[Li].Description);
  end;
end;

function HBCSLT2Desc(AHBCSLT:THiMAP_BCSL_Type) : string;
begin
  if AHBCSLT <= High(THiMAP_BCSL_Type) then
    Result := R_HiMAP_BCSL_Type[AHBCSLT].Description;
end;

function Desc2HBCSLT(AHBCSLT:string): THiMAP_BCSL_Type;
var Li: THiMAP_BCSL_Type;
begin
  for Li := Low(THiMAP_BCSL_Type) to High(THiMAP_BCSL_Type) do
  begin
    if R_HiMAP_BCSL_Type[Li].Description = AHBCSLT then
    begin
      Result := R_HiMAP_BCSL_Type[Li].Value;
      exit;
    end;
  end;
end;

function HBCSLT2HVCode(AHBCSLT:THiMAP_BCSL_Type) : string;
begin
  if AHBCSLT <= High(THiMAP_BCSL_Type) then
    Result := R_HiMAP_BCSL_Type[AHBCSLT].H_VCode;
end;

function HVCode2HBCSLT(AHBCSLT:string): THiMAP_BCSL_Type;
var Li: THiMAP_BCSL_Type;
begin
  for Li := Low(THiMAP_BCSL_Type) to High(THiMAP_BCSL_Type) do
  begin
    if R_HiMAP_BCSL_Type[Li].H_VCode = AHBCSLT then
    begin
      Result := R_HiMAP_BCSL_Type[Li].Value;
      exit;
    end;
  end;
end;

procedure HBCSLT2Combo2(AComboBox:TComboBox);
var
  Li: THiMAP_BCSL_Type;
begin
  AComboBox.Clear;

  for Li := Low(THiMAP_BCSL_Type) to Pred(High(THiMAP_BCSL_Type)) do
  begin
    if Li = Low(THiMAP_BCSL_Type) then
      AComboBox.Items.Add(R_HiMAP_BCSL_Type[Li].Description)
    else
    if R_HiMAP_BCSL_Type[Li].H_VCode <> '' then
      AComboBox.Items.Add(R_HiMAP_BCSL_Type[Li].H_VCode + ' : ' + R_HiMAP_BCSL_Type[Li].Description);
  end;
end;

function HBCSGT2Desc(AHBCSGT:THiMAP_BCSG_Type) : string;
begin
  if AHBCSGT <= High(THiMAP_BCSG_Type) then
    Result := R_HiMAP_BCSG_Type[AHBCSGT].Description;
end;

function Desc2HBCSGT(AHBCSGT:string): THiMAP_BCSG_Type;
var Li: THiMAP_BCSG_Type;
begin
  for Li := Low(THiMAP_BCSG_Type) to High(THiMAP_BCSG_Type) do
  begin
    if R_HiMAP_BCSG_Type[Li].Description = AHBCSGT then
    begin
      Result := R_HiMAP_BCSG_Type[Li].Value;
      exit;
    end;
  end;
end;

function HBCSGT2HVCode(AHBCSGT:THiMAP_BCSG_Type) : string;
begin
  if AHBCSGT <= High(THiMAP_BCSG_Type) then
    Result := R_HiMAP_BCSG_Type[AHBCSGT].H_VCode;
end;

function HVCode2HBCSGT(AHBCSGT:string): THiMAP_BCSG_Type;
var Li: THiMAP_BCSG_Type;
begin
  for Li := Low(THiMAP_BCSG_Type) to High(THiMAP_BCSG_Type) do
  begin
    if R_HiMAP_BCSG_Type[Li].H_VCode = AHBCSGT then
    begin
      Result := R_HiMAP_BCSG_Type[Li].Value;
      exit;
    end;
  end;
end;

procedure HBCSGT2Combo2(AComboBox:TComboBox);
var
  Li: THiMAP_BCSG_Type;
begin
  AComboBox.Clear;

  for Li := Low(THiMAP_BCSG_Type) to Pred(High(THiMAP_BCSG_Type)) do
  begin
    if Li = Low(THiMAP_BCSG_Type) then
      AComboBox.Items.Add(R_HiMAP_BCSG_Type[Li].Description)
    else
    if R_HiMAP_BCSG_Type[Li].H_VCode <> '' then
      AComboBox.Items.Add(R_HiMAP_BCSG_Type[Li].H_VCode + ' : ' + R_HiMAP_BCSG_Type[Li].Description);
  end;
end;

function HFT2Desc(AHFT:THiMAP_F_Type) : string;
begin
  if AHFT <= High(THiMAP_F_Type) then
    Result := R_HiMAP_F_Type[AHFT].Description;
end;

function Desc2HFT(AHFT:string): THiMAP_F_Type;
var Li: THiMAP_F_Type;
begin
  for Li := Low(THiMAP_F_Type) to High(THiMAP_F_Type) do
  begin
    if R_HiMAP_F_Type[Li].Description = AHFT then
    begin
      Result := R_HiMAP_F_Type[Li].Value;
      exit;
    end;
  end;
end;

function HFT2HVCode(AHFT:THiMAP_F_Type) : string;
begin
  if AHFT <= High(THiMAP_F_Type) then
    Result := R_HiMAP_F_Type[AHFT].H_VCode;
end;

function HVCode2HFT(AHFT:string): THiMAP_F_Type;
var Li: THiMAP_F_Type;
begin
  for Li := Low(THiMAP_F_Type) to High(THiMAP_F_Type) do
  begin
    if R_HiMAP_F_Type[Li].H_VCode = AHFT then
    begin
      Result := R_HiMAP_F_Type[Li].Value;
      exit;
    end;
  end;
end;

procedure HFT2Combo2(AComboBox:TComboBox);
var
  Li: THiMAP_F_Type;
begin
  AComboBox.Clear;

  for Li := Low(THiMAP_F_Type) to Pred(High(THiMAP_F_Type)) do
  begin
    if Li = Low(THiMAP_F_Type) then
      AComboBox.Items.Add(R_HiMAP_F_Type[Li].Description)
    else
    if R_HiMAP_F_Type[Li].H_VCode <> '' then
      AComboBox.Items.Add(R_HiMAP_F_Type[Li].H_VCode + ' : ' + R_HiMAP_F_Type[Li].Description);
  end;
end;

function HIIT2Desc(AHIIT:THiCAM_II_Type) : string;
begin
  if AHIIT <= High(THiCAM_II_Type) then
    Result := R_HiCAM_II_Type[AHIIT].Description;
end;

function Desc2HIIT(AHIIT:string): THiCAM_II_Type;
var Li: THiCAM_II_Type;
begin
  for Li := Low(THiCAM_II_Type) to High(THiCAM_II_Type) do
  begin
    if R_HiCAM_II_Type[Li].Description = AHIIT then
    begin
      Result := R_HiCAM_II_Type[Li].Value;
      exit;
    end;
  end;
end;

function HIIT2HVCode(AHIIT:THiCAM_II_Type) : string;
begin
  if AHIIT <= High(THiCAM_II_Type) then
    Result := R_HiCAM_II_Type[AHIIT].H_VCode;
end;

function HVCode2HIIT(AHIIT:string): THiCAM_II_Type;
var Li: THiCAM_II_Type;
begin
  for Li := Low(THiCAM_II_Type) to High(THiCAM_II_Type) do
  begin
    if R_HiCAM_II_Type[Li].H_VCode = AHIIT then
    begin
      Result := R_HiCAM_II_Type[Li].Value;
      exit;
    end;
  end;
end;

procedure HIIT2Combo2(AComboBox:TComboBox);
var
  Li: THiCAM_II_Type;
begin
  AComboBox.Clear;

  for Li := Low(THiCAM_II_Type) to Pred(High(THiCAM_II_Type)) do
  begin
    if Li = Low(THiCAM_II_Type) then
      AComboBox.Items.Add(R_HiCAM_II_Type[Li].Description)
    else
    if R_HiCAM_II_Type[Li].H_VCode <> '' then
      AComboBox.Items.Add(R_HiCAM_II_Type[Li].H_VCode + ' : ' + R_HiCAM_II_Type[Li].Description);
  end;
end;

function HST2Desc(AHST:THiCAM_S_Type) : string;
begin
  if AHST <= High(THiCAM_S_Type) then
    Result := R_HiCAM_S_Type[AHST].Description;
end;

function Desc2HST(AHST:string): THiCAM_S_Type;
var Li: THiCAM_S_Type;
begin
  for Li := Low(THiCAM_S_Type) to High(THiCAM_S_Type) do
  begin
    if R_HiCAM_S_Type[Li].Description = AHST then
    begin
      Result := R_HiCAM_S_Type[Li].Value;
      exit;
    end;
  end;
end;

function HST2HVCode(AHST:THiCAM_S_Type) : string;
begin
  if AHST <= High(THiCAM_S_Type) then
    Result := R_HiCAM_S_Type[AHST].H_VCode;
end;

function HVCode2HST(AHST:string): THiCAM_S_Type;
var Li: THiCAM_S_Type;
begin
  for Li := Low(THiCAM_S_Type) to High(THiCAM_S_Type) do
  begin
    if R_HiCAM_S_Type[Li].H_VCode = AHST then
    begin
      Result := R_HiCAM_S_Type[Li].Value;
      exit;
    end;
  end;
end;

procedure HST2Combo2(AComboBox:TComboBox);
var
  Li: THiCAM_S_Type;
begin
  AComboBox.Clear;

  for Li := Low(THiCAM_S_Type) to Pred(High(THiCAM_S_Type)) do
  begin
    if Li = Low(THiCAM_S_Type) then
      AComboBox.Items.Add(R_HiCAM_S_Type[Li].Description)
    else
    if R_HiCAM_S_Type[Li].H_VCode <> '' then
      AComboBox.Items.Add(R_HiCAM_S_Type[Li].H_VCode + ' : ' + R_HiCAM_S_Type[Li].Description);
  end;
end;

function HSDCT2Desc(AHSDCT:THiCAM_SDC_Type) : string;
begin
  if AHSDCT <= High(THiCAM_SDC_Type) then
    Result := R_HiCAM_SDC_Type[AHSDCT].Description;
end;

function Desc2HSDCT(AHSDCT:string): THiCAM_SDC_Type;
var Li: THiCAM_SDC_Type;
begin
  for Li := Low(THiCAM_SDC_Type) to High(THiCAM_SDC_Type) do
  begin
    if R_HiCAM_SDC_Type[Li].Description = AHSDCT then
    begin
      Result := R_HiCAM_SDC_Type[Li].Value;
      exit;
    end;
  end;
end;

function HSDCT2HVCode(AHSDCT:THiCAM_SDC_Type) : string;
begin
  if AHSDCT <= High(THiCAM_SDC_Type) then
    Result := R_HiCAM_SDC_Type[AHSDCT].H_VCode;
end;

function HVCode2HSDCT(AHSDCT:string): THiCAM_SDC_Type;
var Li: THiCAM_SDC_Type;
begin
  for Li := Low(THiCAM_SDC_Type) to High(THiCAM_SDC_Type) do
  begin
    if R_HiCAM_SDC_Type[Li].H_VCode = AHSDCT then
    begin
      Result := R_HiCAM_SDC_Type[Li].Value;
      exit;
    end;
  end;
end;

procedure HSDCT2Combo2(AComboBox:TComboBox);
var
  Li: THiCAM_SDC_Type;
begin
  AComboBox.Clear;

  for Li := Low(THiCAM_SDC_Type) to Pred(High(THiCAM_SDC_Type)) do
  begin
    if Li = Low(THiCAM_SDC_Type) then
      AComboBox.Items.Add(R_HiCAM_SDC_Type[Li].Description)
    else
    if R_HiCAM_SDC_Type[Li].H_VCode <> '' then
      AComboBox.Items.Add(R_HiCAM_SDC_Type[Li].H_VCode + ' : ' + R_HiCAM_SDC_Type[Li].Description);
  end;
end;

function HPS2Desc(AHPS:THiMAP_Power_Supply) : string;
begin
  if AHPS <= High(THiMAP_Power_Supply) then
    Result := R_HiMAP_Power_Supply[AHPS].Description;
end;

function Desc2HPS(AHPS:string): THiMAP_Power_Supply;
var Li: THiMAP_Power_Supply;
begin
  for Li := Low(THiMAP_Power_Supply) to High(THiMAP_Power_Supply) do
  begin
    if R_HiMAP_Power_Supply[Li].Description = AHPS then
    begin
      Result := R_HiMAP_Power_Supply[Li].Value;
      exit;
    end;
  end;
end;

function HPS2VCode(AHPS:THiMAP_Power_Supply) : string;
begin
  if AHPS <= High(THiMAP_Power_Supply) then
    Result := R_HiMAP_Power_Supply[AHPS].VCode;
end;

function VCode2HPS(AHPS:string): THiMAP_Power_Supply;
var Li: THiMAP_Power_Supply;
begin
  for Li := Low(THiMAP_Power_Supply) to High(THiMAP_Power_Supply) do
  begin
    if R_HiMAP_Power_Supply[Li].VCode = AHPS then
    begin
      Result := R_HiMAP_Power_Supply[Li].Value;
      exit;
    end;
  end;
end;

function HPS2HVCode(AHPS:THiMAP_Power_Supply) : string;
begin
  if AHPS <= High(THiMAP_Power_Supply) then
    Result := R_HiMAP_Power_Supply[AHPS].H_VCode;
end;

function HVCode2HPS(AHPS:string): THiMAP_Power_Supply;
var Li: THiMAP_Power_Supply;
begin
  for Li := Low(THiMAP_Power_Supply) to High(THiMAP_Power_Supply) do
  begin
    if R_HiMAP_Power_Supply[Li].H_VCode = AHPS then
    begin
      Result := R_HiMAP_Power_Supply[Li].Value;
      exit;
    end;
  end;
end;

procedure HPS2Combo(AComboBox:TComboBox);
var Li: THiMAP_Power_Supply;
begin
  AComboBox.Clear;

  for Li := Low(THiMAP_Power_Supply) to Pred(High(THiMAP_Power_Supply)) do
  begin
    if Li = Low(THiMAP_Power_Supply) then
      AComboBox.Items.Add(R_HiMAP_Power_Supply[Li].Description)
    else
      AComboBox.Items.Add(R_HiMAP_Power_Supply[Li].VCode + ' : ' + R_HiMAP_Power_Supply[Li].Description);
  end;
end;

procedure HPS2Combo2(AComboBox:TComboBox);
var Li: THiMAP_Power_Supply;
begin
  AComboBox.Clear;

  for Li := Low(THiMAP_Power_Supply) to Pred(High(THiMAP_Power_Supply)) do
  begin
    if Li = Low(THiMAP_Power_Supply) then
      AComboBox.Items.Add(R_HiMAP_Power_Supply[Li].Description)
    else
    if R_HiMAP_Power_Supply[Li].H_VCode <> '' then
      AComboBox.Items.Add(R_HiMAP_Power_Supply[Li].H_VCode + ' : ' + R_HiMAP_Power_Supply[Li].Description);
  end;
end;

function HPCT2Desc(AHPCT:THiMAP_Phase_CT) : string;
begin
  if AHPCT <= High(THiMAP_Phase_CT) then
    Result := R_HiMAP_Phase_CT[AHPCT].Description;
end;

function Desc2HPCT(AHPCT:string): THiMAP_Phase_CT;
var Li: THiMAP_Phase_CT;
begin
  for Li := Low(THiMAP_Phase_CT) to High(THiMAP_Phase_CT) do
  begin
    if R_HiMAP_Phase_CT[Li].Description = AHPCT then
    begin
      Result := R_HiMAP_Phase_CT[Li].Value;
      exit;
    end;
  end;
end;

function HPCT2VCode(AHPCT:THiMAP_Phase_CT) : string;
begin
  if AHPCT <= High(THiMAP_Phase_CT) then
    Result := R_HiMAP_Phase_CT[AHPCT].VCode;
end;

function VCode2HPCT(AHPCT:string): THiMAP_Phase_CT;
var Li: THiMAP_Phase_CT;
begin
  for Li := Low(THiMAP_Phase_CT) to High(THiMAP_Phase_CT) do
  begin
    if R_HiMAP_Phase_CT[Li].VCode = AHPCT then
    begin
      Result := R_HiMAP_Phase_CT[Li].Value;
      exit;
    end;
  end;
end;

function HPCT2HVCode(AHPCT:THiMAP_Phase_CT) : string;
begin
  if AHPCT <= High(THiMAP_Phase_CT) then
    Result := R_HiMAP_Phase_CT[AHPCT].H_VCode;
end;

function HVCode2HPCT(AHPCT:string): THiMAP_Phase_CT;
var Li: THiMAP_Phase_CT;
begin
  for Li := Low(THiMAP_Phase_CT) to High(THiMAP_Phase_CT) do
  begin
    if R_HiMAP_Phase_CT[Li].H_VCode = AHPCT then
    begin
      Result := R_HiMAP_Phase_CT[Li].Value;
      exit;
    end;
  end;
end;

procedure HPCT2Combo(AComboBox:TComboBox);
var Li: THiMAP_Phase_CT;
begin
  AComboBox.Clear;

  for Li := Low(THiMAP_Phase_CT) to Pred(High(THiMAP_Phase_CT)) do
  begin
    if Li = Low(THiMAP_Phase_CT) then
      AComboBox.Items.Add(R_HiMAP_Phase_CT[Li].Description)
    else
      AComboBox.Items.Add(R_HiMAP_Phase_CT[Li].VCode + ' : ' + R_HiMAP_Phase_CT[Li].Description);
  end;
end;

procedure HPCT2Combo2(AComboBox:TComboBox);
var Li: THiMAP_Phase_CT;
begin
  AComboBox.Clear;

  for Li := Low(THiMAP_Phase_CT) to Pred(High(THiMAP_Phase_CT)) do
  begin
    if Li = Low(THiMAP_Phase_CT) then
      AComboBox.Items.Add(R_HiMAP_Phase_CT[Li].Description)
    else
    if R_HiMAP_Phase_CT[Li].H_VCode <> '' then
      AComboBox.Items.Add(R_HiMAP_Phase_CT[Li].H_VCode + ' : ' + R_HiMAP_Phase_CT[Li].Description);
  end;
end;

function HPPT2Desc(AHPPT:THiMAP_Phase_PT) : string;
begin
  if AHPPT <= High(THiMAP_Phase_PT) then
    Result := R_HiMAP_Phase_PT[AHPPT].Description;
end;

function Desc2HPPT(AHPPT:string): THiMAP_Phase_PT;
var Li: THiMAP_Phase_PT;
begin
  for Li := Low(THiMAP_Phase_PT) to High(THiMAP_Phase_PT) do
  begin
    if R_HiMAP_Phase_PT[Li].Description = AHPPT then
    begin
      Result := R_HiMAP_Phase_PT[Li].Value;
      exit;
    end;
  end;
end;

function HPPT2VCode(AHPPT:THiMAP_Phase_PT) : string;
begin
  if AHPPT <= High(THiMAP_Phase_PT) then
    Result := R_HiMAP_Phase_PT[AHPPT].VCode;
end;

function VCode2HPPT(AHPPT:string): THiMAP_Phase_PT;
var Li: THiMAP_Phase_PT;
begin
  for Li := Low(THiMAP_Phase_PT) to High(THiMAP_Phase_PT) do
  begin
    if R_HiMAP_Phase_PT[Li].VCode = AHPPT then
    begin
      Result := R_HiMAP_Phase_PT[Li].Value;
      exit;
    end;
  end;
end;

function HPPT2HVCode(AHPPT:THiMAP_Phase_PT) : string;
begin
  if AHPPT <= High(THiMAP_Phase_PT) then
    Result := R_HiMAP_Phase_PT[AHPPT].H_VCode;
end;

function HVCode2HPPT(AHPPT:string): THiMAP_Phase_PT;
var Li: THiMAP_Phase_PT;
begin
  for Li := Low(THiMAP_Phase_PT) to High(THiMAP_Phase_PT) do
  begin
    if R_HiMAP_Phase_PT[Li].H_VCode = AHPPT then
    begin
      Result := R_HiMAP_Phase_PT[Li].Value;
      exit;
    end;
  end;
end;

procedure HPPT2Combo(AComboBox:TComboBox);
var Li: THiMAP_Phase_PT;
begin
  AComboBox.Clear;

  for Li := Low(THiMAP_Phase_PT) to Pred(High(THiMAP_Phase_PT)) do
  begin
    if Li = Low(THiMAP_Phase_PT) then
      AComboBox.Items.Add(R_HiMAP_Phase_PT[Li].Description)
    else
      AComboBox.Items.Add(R_HiMAP_Phase_PT[Li].VCode + ' : ' + R_HiMAP_Phase_PT[Li].Description);
  end;
end;

procedure HPPT2Combo2(AComboBox:TComboBox);
var Li: THiMAP_Phase_PT;
begin
  AComboBox.Clear;

  for Li := Low(THiMAP_Phase_PT) to Pred(High(THiMAP_Phase_PT)) do
  begin
    if Li = Low(THiMAP_Phase_PT) then
      AComboBox.Items.Add(R_HiMAP_Phase_PT[Li].Description)
    else
    if R_HiMAP_Phase_PT[Li].H_VCode <> '' then
      AComboBox.Items.Add(R_HiMAP_Phase_PT[Li].H_VCode + ' : ' + R_HiMAP_Phase_PT[Li].Description);
  end;
end;

function HPCTD2Desc(AHPCTD:THiMAP_Phase_CT_Diff) : string;
begin
  if AHPCTD <= High(THiMAP_Phase_CT_Diff) then
    Result := R_HiMAP_Phase_CT_Diff[AHPCTD].Description;
end;

function Desc2HPCTD(AHPCTD:string): THiMAP_Phase_CT_Diff;
var Li: THiMAP_Phase_CT_Diff;
begin
  for Li := Low(THiMAP_Phase_CT_Diff) to High(THiMAP_Phase_CT_Diff) do
  begin
    if R_HiMAP_Phase_CT_Diff[Li].Description = AHPCTD then
    begin
      Result := R_HiMAP_Phase_CT_Diff[Li].Value;
      exit;
    end;
  end;
end;

function HPCTD2VCode(AHPCTD:THiMAP_Phase_CT_Diff) : string;
begin
  if AHPCTD <= High(THiMAP_Phase_CT_Diff) then
    Result := R_HiMAP_Phase_CT_Diff[AHPCTD].VCode;
end;

function VCode2HPCTD(AHPCTD:string): THiMAP_Phase_CT_Diff;
var Li: THiMAP_Phase_CT_Diff;
begin
  for Li := Low(THiMAP_Phase_CT_Diff) to High(THiMAP_Phase_CT_Diff) do
  begin
    if R_HiMAP_Phase_CT_Diff[Li].VCode = AHPCTD then
    begin
      Result := R_HiMAP_Phase_CT_Diff[Li].Value;
      exit;
    end;
  end;
end;

function HPCTD2HVCode(AHPCTD:THiMAP_Phase_CT_Diff) : string;
begin
  if AHPCTD <= High(THiMAP_Phase_CT_Diff) then
    Result := R_HiMAP_Phase_CT_Diff[AHPCTD].H_VCode;
end;

function HVCode2HPCTD(AHPCTD:string): THiMAP_Phase_CT_Diff;
var Li: THiMAP_Phase_CT_Diff;
begin
  for Li := Low(THiMAP_Phase_CT_Diff) to High(THiMAP_Phase_CT_Diff) do
  begin
    if R_HiMAP_Phase_CT_Diff[Li].H_VCode = AHPCTD then
    begin
      Result := R_HiMAP_Phase_CT_Diff[Li].Value;
      exit;
    end;
  end;
end;

procedure HPCTD2Combo(AComboBox:TComboBox);
var Li: THiMAP_Phase_CT_Diff;
begin
  AComboBox.Clear;

  for Li := Low(THiMAP_Phase_CT_Diff) to Pred(High(THiMAP_Phase_CT_Diff)) do
  begin
    if Li = Low(THiMAP_Phase_CT_Diff) then
      AComboBox.Items.Add(R_HiMAP_Phase_CT_Diff[Li].Description)
    else
      AComboBox.Items.Add(R_HiMAP_Phase_CT_Diff[Li].VCode + ' : ' + R_HiMAP_Phase_CT_Diff[Li].Description);
  end;
end;

procedure HPCTD2Combo2(AComboBox:TComboBox);
var Li: THiMAP_Phase_CT_Diff;
begin
  AComboBox.Clear;

  for Li := Low(THiMAP_Phase_CT_Diff) to Pred(High(THiMAP_Phase_CT_Diff)) do
  begin
    if Li = Low(THiMAP_Phase_CT_Diff) then
      AComboBox.Items.Add(R_HiMAP_Phase_CT_Diff[Li].Description)
    else
    if R_HiMAP_Phase_CT_Diff[Li].H_VCode <> '' then
      AComboBox.Items.Add(R_HiMAP_Phase_CT_Diff[Li].H_VCode + ' : ' + R_HiMAP_Phase_CT_Diff[Li].Description);
  end;
end;

function HCTG2Desc(AHCTG:THiMAP_CT_Ground) : string;
begin
  if AHCTG <= High(THiMAP_CT_Ground) then
    Result := R_HiMAP_CT_Ground[AHCTG].Description;
end;

function Desc2HCTG(AHCTG:string): THiMAP_CT_Ground;
var Li: THiMAP_CT_Ground;
begin
  for Li := Low(THiMAP_CT_Ground) to High(THiMAP_CT_Ground) do
  begin
    if R_HiMAP_CT_Ground[Li].Description = AHCTG then
    begin
      Result := R_HiMAP_CT_Ground[Li].Value;
      exit;
    end;
  end;
end;

function HCTG2VCode(AHCTG:THiMAP_CT_Ground) : string;
begin
  if AHCTG <= High(THiMAP_CT_Ground) then
    Result := R_HiMAP_CT_Ground[AHCTG].VCode;
end;

function VCode2HCTG(AHCTG:string): THiMAP_CT_Ground;
var Li: THiMAP_CT_Ground;
begin
  for Li := Low(THiMAP_CT_Ground) to High(THiMAP_CT_Ground) do
  begin
    if R_HiMAP_CT_Ground[Li].VCode = AHCTG then
    begin
      Result := R_HiMAP_CT_Ground[Li].Value;
      exit;
    end;
  end;
end;

function HCTG2HVCode(AHCTG:THiMAP_CT_Ground) : string;
begin
  if AHCTG <= High(THiMAP_CT_Ground) then
    Result := R_HiMAP_CT_Ground[AHCTG].H_VCode;
end;

function HVCode2HCTG(AHCTG:string): THiMAP_CT_Ground;
var Li: THiMAP_CT_Ground;
begin
  for Li := Low(THiMAP_CT_Ground) to High(THiMAP_CT_Ground) do
  begin
    if R_HiMAP_CT_Ground[Li].H_VCode = AHCTG then
    begin
      Result := R_HiMAP_CT_Ground[Li].Value;
      exit;
    end;
  end;
end;

procedure HCTG2Combo(AComboBox:TComboBox);
var Li: THiMAP_CT_Ground;
begin
  AComboBox.Clear;

  for Li := Low(THiMAP_CT_Ground) to Pred(High(THiMAP_CT_Ground)) do
  begin
    if Li = Low(THiMAP_CT_Ground) then
      AComboBox.Items.Add(R_HiMAP_CT_Ground[Li].Description)
    else
      AComboBox.Items.Add(R_HiMAP_CT_Ground[Li].VCode + ' : ' + R_HiMAP_CT_Ground[Li].Description);
  end;
end;

procedure HCTG2Combo2(AComboBox:TComboBox);
var Li: THiMAP_CT_Ground;
begin
  AComboBox.Clear;

  for Li := Low(THiMAP_CT_Ground) to Pred(High(THiMAP_CT_Ground)) do
  begin
    if Li = Low(THiMAP_CT_Ground) then
      AComboBox.Items.Add(R_HiMAP_CT_Ground[Li].Description)
    else
    if R_HiMAP_CT_Ground[Li].H_VCode <> '' then
      AComboBox.Items.Add(R_HiMAP_CT_Ground[Li].H_VCode + ' : ' + R_HiMAP_CT_Ground[Li].Description);
  end;
end;

function HPTG2Desc(AHPTG:THiMAP_PT_Ground) : string;
begin
  if AHPTG <= High(THiMAP_PT_Ground) then
    Result := R_HiMAP_PT_Ground[AHPTG].Description;
end;

function Desc2HPTG(AHPTG:string): THiMAP_PT_Ground;
var Li: THiMAP_PT_Ground;
begin
  for Li := Low(THiMAP_PT_Ground) to High(THiMAP_PT_Ground) do
  begin
    if R_HiMAP_PT_Ground[Li].Description = AHPTG then
    begin
      Result := R_HiMAP_PT_Ground[Li].Value;
      exit;
    end;
  end;
end;

function HPTG2VCode(AHPTG:THiMAP_PT_Ground) : string;
begin
  if AHPTG <= High(THiMAP_PT_Ground) then
    Result := R_HiMAP_PT_Ground[AHPTG].VCode;
end;

function VCode2HPTG(AHPTG:string): THiMAP_PT_Ground;
var Li: THiMAP_PT_Ground;
begin
  for Li := Low(THiMAP_PT_Ground) to High(THiMAP_PT_Ground) do
  begin
    if R_HiMAP_PT_Ground[Li].VCode = AHPTG then
    begin
      Result := R_HiMAP_PT_Ground[Li].Value;
      exit;
    end;
  end;
end;

function HPTG2HVCode(AHPTG:THiMAP_PT_Ground) : string;
begin
  if AHPTG <= High(THiMAP_PT_Ground) then
    Result := R_HiMAP_PT_Ground[AHPTG].H_VCode;
end;

function HVCode2HPTG(AHPTG:string): THiMAP_PT_Ground;
var Li: THiMAP_PT_Ground;
begin
  for Li := Low(THiMAP_PT_Ground) to High(THiMAP_PT_Ground) do
  begin
    if R_HiMAP_PT_Ground[Li].H_VCode = AHPTG then
    begin
      Result := R_HiMAP_PT_Ground[Li].Value;
      exit;
    end;
  end;
end;

procedure HPTG2Combo(AComboBox:TComboBox);
var Li: THiMAP_PT_Ground;
begin
  AComboBox.Clear;

  for Li := Low(THiMAP_PT_Ground) to Pred(High(THiMAP_PT_Ground)) do
  begin
    if Li = Low(THiMAP_PT_Ground) then
      AComboBox.Items.Add(R_HiMAP_PT_Ground[Li].Description)
    else
     AComboBox.Items.Add(R_HiMAP_PT_Ground[Li].VCode + ' : ' + R_HiMAP_PT_Ground[Li].Description);
  end;
end;

procedure HPTG2Combo2(AComboBox:TComboBox);
var Li: THiMAP_PT_Ground;
begin
  AComboBox.Clear;

  for Li := Low(THiMAP_PT_Ground) to Pred(High(THiMAP_PT_Ground)) do
  begin
    if Li = Low(THiMAP_PT_Ground) then
      AComboBox.Items.Add(R_HiMAP_PT_Ground[Li].Description)
    else
    if R_HiMAP_PT_Ground[Li].H_VCode <> '' then
      AComboBox.Items.Add(R_HiMAP_PT_Ground[Li].H_VCode + ' : ' + R_HiMAP_PT_Ground[Li].Description);
  end;
end;

function HCB2Desc(AHCB:THiMAP_CANBUS) : string;
begin
  if AHCB <= High(THiMAP_CANBUS) then
    Result := R_HiMAP_CANBUS[AHCB].Description;
end;

function Desc2HCB(AHCB:string): THiMAP_CANBUS;
var Li: THiMAP_CANBUS;
begin
  for Li := Low(THiMAP_CANBUS) to High(THiMAP_CANBUS) do
  begin
    if R_HiMAP_CANBUS[Li].Description = AHCB then
    begin
      Result := R_HiMAP_CANBUS[Li].Value;
      exit;
    end;
  end;
end;

function HCB2VCode(AHCB:THiMAP_CANBUS) : string;
begin
  if AHCB <= High(THiMAP_CANBUS) then
    Result := R_HiMAP_CANBUS[AHCB].VCode;
end;

function VCode2HCB(AHCB:string): THiMAP_CANBUS;
var Li: THiMAP_CANBUS;
begin
  for Li := Low(THiMAP_CANBUS) to High(THiMAP_CANBUS) do
  begin
    if R_HiMAP_CANBUS[Li].VCode = AHCB then
    begin
      Result := R_HiMAP_CANBUS[Li].Value;
      exit;
    end;
  end;
end;

function HCB2HVCode(AHCB:THiMAP_CANBUS) : string;
begin
  if AHCB <= High(THiMAP_CANBUS) then
    Result := R_HiMAP_CANBUS[AHCB].H_VCode;
end;

function HVCode2HCB(AHCB:string): THiMAP_CANBUS;
var Li: THiMAP_CANBUS;
begin
  for Li := Low(THiMAP_CANBUS) to High(THiMAP_CANBUS) do
  begin
    if R_HiMAP_CANBUS[Li].H_VCode = AHCB then
    begin
      Result := R_HiMAP_CANBUS[Li].Value;
      exit;
    end;
  end;
end;

procedure HCB2Combo(AComboBox:TComboBox);
var Li: THiMAP_CANBUS;
begin
  AComboBox.Clear;

  for Li := Low(THiMAP_CANBUS) to Pred(High(THiMAP_CANBUS)) do
  begin
    if Li = Low(THiMAP_CANBUS) then
      AComboBox.Items.Add(R_HiMAP_CANBUS[Li].Description)
    else
      AComboBox.Items.Add(R_HiMAP_CANBUS[Li].VCode + ' : ' + R_HiMAP_CANBUS[Li].Description);
  end;
end;

procedure HCB2Combo2(AComboBox:TComboBox);
var Li: THiMAP_CANBUS;
begin
  AComboBox.Clear;

  for Li := Low(THiMAP_CANBUS) to Pred(High(THiMAP_CANBUS)) do
  begin
    if Li = Low(THiMAP_CANBUS) then
      AComboBox.Items.Add(R_HiMAP_CANBUS[Li].Description)
    else
    if R_HiMAP_CANBUS[Li].H_VCode <> '' then
      AComboBox.Items.Add(R_HiMAP_CANBUS[Li].H_VCode + ' : ' + R_HiMAP_CANBUS[Li].Description);
  end;
end;

function HPB2Desc(AHPB:THiMAP_PROFIBUS) : string;
begin
  if AHPB <= High(THiMAP_PROFIBUS) then
    Result := R_HiMAP_PROFIBUS[AHPB].Description;
end;

function Desc2HPB(AHPB:string): THiMAP_PROFIBUS;
var Li: THiMAP_PROFIBUS;
begin
  for Li := Low(THiMAP_PROFIBUS) to High(THiMAP_PROFIBUS) do
  begin
    if R_HiMAP_PROFIBUS[Li].Description = AHPB then
    begin
      Result := R_HiMAP_PROFIBUS[Li].Value;
      exit;
    end;
  end;
end;

function HPB2VCode(AHPB:THiMAP_PROFIBUS) : string;
begin
  if AHPB <= High(THiMAP_PROFIBUS) then
    Result := R_HiMAP_PROFIBUS[AHPB].VCode;
end;

function VCode2HPB(AHPB:string): THiMAP_PROFIBUS;
var Li: THiMAP_PROFIBUS;
begin
  for Li := Low(THiMAP_PROFIBUS) to High(THiMAP_PROFIBUS) do
  begin
    if R_HiMAP_PROFIBUS[Li].VCode = AHPB then
    begin
      Result := R_HiMAP_PROFIBUS[Li].Value;
      exit;
    end;
  end;
end;

function HPB2HVCode(AHPB:THiMAP_PROFIBUS) : string;
begin
  if AHPB <= High(THiMAP_PROFIBUS) then
    Result := R_HiMAP_PROFIBUS[AHPB].H_VCode;
end;

function HVCode2HPB(AHPB:string): THiMAP_PROFIBUS;
var Li: THiMAP_PROFIBUS;
begin
  for Li := Low(THiMAP_PROFIBUS) to High(THiMAP_PROFIBUS) do
  begin
    if R_HiMAP_PROFIBUS[Li].H_VCode = AHPB then
    begin
      Result := R_HiMAP_PROFIBUS[Li].Value;
      exit;
    end;
  end;
end;

procedure HPB2Combo(AComboBox:TComboBox);
var Li: THiMAP_PROFIBUS;
begin
  AComboBox.Clear;

  for Li := Low(THiMAP_PROFIBUS) to Pred(High(THiMAP_PROFIBUS)) do
  begin
    if Li = Low(THiMAP_PROFIBUS) then
      AComboBox.Items.Add(R_HiMAP_PROFIBUS[Li].Description)
    else
      AComboBox.Items.Add(R_HiMAP_PROFIBUS[Li].VCode + ' : ' + R_HiMAP_PROFIBUS[Li].Description);
  end;
end;

procedure HPB2Combo2(AComboBox:TComboBox);
var Li: THiMAP_PROFIBUS;
begin
  AComboBox.Clear;

  for Li := Low(THiMAP_PROFIBUS) to Pred(High(THiMAP_PROFIBUS)) do
  begin
    if Li = Low(THiMAP_PROFIBUS) then
      AComboBox.Items.Add(R_HiMAP_PROFIBUS[Li].Description)
    else
    if R_HiMAP_PROFIBUS[Li].H_VCode <> '' then
      AComboBox.Items.Add(R_HiMAP_PROFIBUS[Li].H_VCode + ' : ' + R_HiMAP_PROFIBUS[Li].Description);
  end;
end;

function HSI2Desc(AHSI:THiMAP_SERIAL_INTERFACE) : string;
begin
  if AHSI <= High(THiMAP_SERIAL_INTERFACE) then
    Result := R_HiMAP_SERIAL_INTERFACE[AHSI].Description;
end;

function Desc2HSI(AHSI:string): THiMAP_SERIAL_INTERFACE;
var Li: THiMAP_SERIAL_INTERFACE;
begin
  for Li := Low(THiMAP_SERIAL_INTERFACE) to High(THiMAP_SERIAL_INTERFACE) do
  begin
    if R_HiMAP_SERIAL_INTERFACE[Li].Description = AHSI then
    begin
      Result := R_HiMAP_SERIAL_INTERFACE[Li].Value;
      exit;
    end;
  end;
end;

function HSI2VCode(AHSI:THiMAP_SERIAL_INTERFACE) : string;
begin
  if AHSI <= High(THiMAP_SERIAL_INTERFACE) then
    Result := R_HiMAP_SERIAL_INTERFACE[AHSI].VCode;
end;

function VCode2HSI(AHSI:string): THiMAP_SERIAL_INTERFACE;
var Li: THiMAP_SERIAL_INTERFACE;
begin
  for Li := Low(THiMAP_SERIAL_INTERFACE) to High(THiMAP_SERIAL_INTERFACE) do
  begin
    if R_HiMAP_SERIAL_INTERFACE[Li].VCode = AHSI then
    begin
      Result := R_HiMAP_SERIAL_INTERFACE[Li].Value;
      exit;
    end;
  end;
end;

function HSI2HVCode(AHSI:THiMAP_SERIAL_INTERFACE) : string;
begin
  if AHSI <= High(THiMAP_SERIAL_INTERFACE) then
    Result := R_HiMAP_SERIAL_INTERFACE[AHSI].H_VCode;
end;

function HVCode2HSI(AHSI:string): THiMAP_SERIAL_INTERFACE;
var Li: THiMAP_SERIAL_INTERFACE;
begin
  for Li := Low(THiMAP_SERIAL_INTERFACE) to High(THiMAP_SERIAL_INTERFACE) do
  begin
    if R_HiMAP_SERIAL_INTERFACE[Li].H_VCode = AHSI then
    begin
      Result := R_HiMAP_SERIAL_INTERFACE[Li].Value;
      exit;
    end;
  end;
end;

procedure HSI2Combo(AComboBox:TComboBox);
var Li: THiMAP_SERIAL_INTERFACE;
begin
  AComboBox.Clear;

  for Li := Low(THiMAP_SERIAL_INTERFACE) to Pred(High(THiMAP_SERIAL_INTERFACE)) do
  begin
    if Li = Low(THiMAP_SERIAL_INTERFACE) then
      AComboBox.Items.Add(R_HiMAP_SERIAL_INTERFACE[Li].Description)
    else
      AComboBox.Items.Add(R_HiMAP_SERIAL_INTERFACE[Li].VCode + ' : ' + R_HiMAP_SERIAL_INTERFACE[Li].Description);
  end;
end;

procedure HSI2Combo2(AComboBox:TComboBox);
var Li: THiMAP_SERIAL_INTERFACE;
begin
  AComboBox.Clear;

  for Li := Low(THiMAP_SERIAL_INTERFACE) to Pred(High(THiMAP_SERIAL_INTERFACE)) do
  begin
    if Li = Low(THiMAP_SERIAL_INTERFACE) then
      AComboBox.Items.Add(R_HiMAP_SERIAL_INTERFACE[Li].Description)
    else
    if R_HiMAP_SERIAL_INTERFACE[Li].H_VCode <> '' then
      AComboBox.Items.Add(R_HiMAP_SERIAL_INTERFACE[Li].H_VCode + ' : ' + R_HiMAP_SERIAL_INTERFACE[Li].Description);
  end;
end;

function HIEC618502Desc(AHI6:THiMAP_IEC_61850) : string;
begin
  if AHI6 <= High(THiMAP_IEC_61850) then
    Result := R_HiMAP_IEC_61850[AHI6].Description;
end;

function Desc2HIEC61850(AHI6:string): THiMAP_IEC_61850;
var Li: THiMAP_IEC_61850;
begin
  for Li := Low(THiMAP_IEC_61850) to High(THiMAP_IEC_61850) do
  begin
    if R_HiMAP_IEC_61850[Li].Description = AHI6 then
    begin
      Result := R_HiMAP_IEC_61850[Li].Value;
      exit;
    end;
  end;
end;

function HIEC618502VCode(AHI6:THiMAP_IEC_61850) : string;
begin
  if AHI6 <= High(THiMAP_IEC_61850) then
    Result := R_HiMAP_IEC_61850[AHI6].VCode;
end;

function VCode2HIEC61850(AHI6:string): THiMAP_IEC_61850;
var Li: THiMAP_IEC_61850;
begin
  for Li := Low(THiMAP_IEC_61850) to High(THiMAP_IEC_61850) do
  begin
    if R_HiMAP_IEC_61850[Li].VCode = AHI6 then
    begin
      Result := R_HiMAP_IEC_61850[Li].Value;
      exit;
    end;
  end;
end;

function HIEC618502HVCode(AHI6:THiMAP_IEC_61850) : string;
begin
  if AHI6 <= High(THiMAP_IEC_61850) then
    Result := R_HiMAP_IEC_61850[AHI6].H_VCode;
end;

function HVCode2HIEC61850(AHI6:string): THiMAP_IEC_61850;
var Li: THiMAP_IEC_61850;
begin
  for Li := Low(THiMAP_IEC_61850) to High(THiMAP_IEC_61850) do
  begin
    if R_HiMAP_IEC_61850[Li].H_VCode = AHI6 then
    begin
      Result := R_HiMAP_IEC_61850[Li].Value;
      exit;
    end;
  end;
end;

procedure HIEC618502Combo(AComboBox:TComboBox);
var Li: THiMAP_IEC_61850;
begin
  AComboBox.Clear;

  for Li := Low(THiMAP_IEC_61850) to Pred(High(THiMAP_IEC_61850)) do
  begin
    if Li = Low(THiMAP_IEC_61850) then
      AComboBox.Items.Add(R_HiMAP_IEC_61850[Li].Description)
    else
      AComboBox.Items.Add(R_HiMAP_IEC_61850[Li].VCode + ' : ' + R_HiMAP_IEC_61850[Li].Description);
  end;
end;

procedure HIEC618502Combo2(AComboBox:TComboBox);
var Li: THiMAP_IEC_61850;
begin
  AComboBox.Clear;

  for Li := Low(THiMAP_IEC_61850) to Pred(High(THiMAP_IEC_61850)) do
  begin
    if Li = Low(THiMAP_IEC_61850) then
      AComboBox.Items.Add(R_HiMAP_IEC_61850[Li].Description)
    else
    if R_HiMAP_IEC_61850[Li].H_VCode <> '' then
      AComboBox.Items.Add(R_HiMAP_IEC_61850[Li].H_VCode + ' : ' + R_HiMAP_IEC_61850[Li].Description);
  end;
end;

function HAO2Desc(AHAO:THiMAP_Analog_Output) : string;
begin
  if AHAO <= High(THiMAP_Analog_Output) then
    Result := R_HiMAP_Analog_Output[AHAO].Description;
end;

function Desc2HAO(AHAO:string): THiMAP_Analog_Output;
var Li: THiMAP_Analog_Output;
begin
  for Li := Low(THiMAP_Analog_Output) to High(THiMAP_Analog_Output) do
  begin
    if R_HiMAP_Analog_Output[Li].Description = AHAO then
    begin
      Result := R_HiMAP_Analog_Output[Li].Value;
      exit;
    end;
  end;
end;

function HAO2VCode(AHAO:THiMAP_Analog_Output) : string;
begin
  if AHAO <= High(THiMAP_Analog_Output) then
    Result := R_HiMAP_Analog_Output[AHAO].VCode;
end;

function VCode2HAO(AHAO:string): THiMAP_Analog_Output;
var Li: THiMAP_Analog_Output;
begin
  for Li := Low(THiMAP_Analog_Output) to High(THiMAP_Analog_Output) do
  begin
    if R_HiMAP_Analog_Output[Li].VCode = AHAO then
    begin
      Result := R_HiMAP_Analog_Output[Li].Value;
      exit;
    end;
  end;
end;

function HAO2HVCode(AHAO:THiMAP_Analog_Output) : string;
begin
  if AHAO <= High(THiMAP_Analog_Output) then
    Result := R_HiMAP_Analog_Output[AHAO].H_VCode;
end;

function HVCode2HAO(AHAO:string): THiMAP_Analog_Output;
var Li: THiMAP_Analog_Output;
begin
  for Li := Low(THiMAP_Analog_Output) to High(THiMAP_Analog_Output) do
  begin
    if R_HiMAP_Analog_Output[Li].H_VCode = AHAO then
    begin
      Result := R_HiMAP_Analog_Output[Li].Value;
      exit;
    end;
  end;
end;

procedure HAO2Combo(AComboBox:TComboBox);
var Li: THiMAP_Analog_Output;
begin
  AComboBox.Clear;

  for Li := Low(THiMAP_Analog_Output) to Pred(High(THiMAP_Analog_Output)) do
  begin
    if Li = Low(THiMAP_Analog_Output) then
      AComboBox.Items.Add(R_HiMAP_Analog_Output[Li].Description)
    else
      AComboBox.Items.Add(R_HiMAP_Analog_Output[Li].VCode + ' : ' + R_HiMAP_Analog_Output[Li].Description);
  end;
end;

procedure HAO2Combo2(AComboBox:TComboBox);
var Li: THiMAP_Analog_Output;
begin
  AComboBox.Clear;

  for Li := Low(THiMAP_Analog_Output) to Pred(High(THiMAP_Analog_Output)) do
  begin
    if Li = Low(THiMAP_Analog_Output) then
      AComboBox.Items.Add(R_HiMAP_Analog_Output[Li].Description)
    else
    if R_HiMAP_Analog_Output[Li].H_VCode <> '' then
      AComboBox.Items.Add(R_HiMAP_Analog_Output[Li].H_VCode + ' : ' + R_HiMAP_Analog_Output[Li].Description);
  end;
end;

function HS12Desc(AS1:THiMAP_Shunt1) : string;
begin
  if AS1 <= High(THiMAP_Shunt1) then
    Result := R_HiMAP_Shunt1[AS1].Description;
end;

function Desc2HS1(AS1:string): THiMAP_Shunt1;
var Li: THiMAP_Shunt1;
begin
  for Li := Low(THiMAP_Shunt1) to High(THiMAP_Shunt1) do
  begin
    if R_HiMAP_Shunt1[Li].Description = AS1 then
    begin
      Result := R_HiMAP_Shunt1[Li].Value;
      exit;
    end;
  end;
end;

function HS12VCode(AS1:THiMAP_Shunt1) : string;
begin
  if AS1 <= High(THiMAP_Shunt1) then
    Result := R_HiMAP_Shunt1[AS1].VCode;
end;

function VCode2HS1(AS1:string): THiMAP_Shunt1;
var Li: THiMAP_Shunt1;
begin
  for Li := Low(THiMAP_Shunt1) to High(THiMAP_Shunt1) do
  begin
    if R_HiMAP_Shunt1[Li].VCode = AS1 then
    begin
      Result := R_HiMAP_Shunt1[Li].Value;
      exit;
    end;
  end;
end;

function HS12HVCode(AS1:THiMAP_Shunt1) : string;
begin
  if AS1 <= High(THiMAP_Shunt1) then
    Result := R_HiMAP_Shunt1[AS1].H_VCode;
end;

function HVCode2HS1(AS1:string): THiMAP_Shunt1;
var Li: THiMAP_Shunt1;
begin
  for Li := Low(THiMAP_Shunt1) to High(THiMAP_Shunt1) do
  begin
    if R_HiMAP_Shunt1[Li].H_VCode = AS1 then
    begin
      Result := R_HiMAP_Shunt1[Li].Value;
      exit;
    end;
  end;
end;

procedure HS12Combo(AComboBox:TComboBox);
var Li: THiMAP_Shunt1;
begin
  AComboBox.Clear;

  for Li := Low(THiMAP_Shunt1) to Pred(High(THiMAP_Shunt1)) do
  begin
    if Li = Low(THiMAP_Shunt1) then
      AComboBox.Items.Add(R_HiMAP_Shunt1[Li].Description)
    else
      AComboBox.Items.Add(R_HiMAP_Shunt1[Li].VCode + ' : ' + R_HiMAP_Shunt1[Li].Description);
  end;
end;

procedure HS12Combo2(AComboBox:TComboBox);
var Li: THiMAP_Shunt1;
begin
  AComboBox.Clear;

  for Li := Low(THiMAP_Shunt1) to Pred(High(THiMAP_Shunt1)) do
  begin
    if Li = Low(THiMAP_Shunt1) then
      AComboBox.Items.Add(R_HiMAP_Shunt1[Li].Description)
    else
    if R_HiMAP_Shunt1[Li].H_VCode <> '' then
      AComboBox.Items.Add(R_HiMAP_Shunt1[Li].H_VCode + ' : ' + R_HiMAP_Shunt1[Li].Description);
  end;
end;

function HFrontDesign2Desc(AFD:THiMAP_Front_Design) : string;
begin
  if AFD <= High(THiMAP_Front_Design) then
    Result := R_HiMAP_Front_Design[AFD].Description;
end;

function Desc2HFrontDesign(AFD:string): THiMAP_Front_Design;
var Li: THiMAP_Front_Design;
begin
  for Li := Low(THiMAP_Front_Design) to High(THiMAP_Front_Design) do
  begin
    if R_HiMAP_Front_Design[Li].Description = AFD then
    begin
      Result := R_HiMAP_Front_Design[Li].Value;
      exit;
    end;
  end;
end;

function HFrontDesign2VCode(AFD:THiMAP_Front_Design) : string;
begin
  if AFD <= High(THiMAP_Front_Design) then
    Result := R_HiMAP_Front_Design[AFD].VCode;
end;

function VCode2HFrontDesign(AFD:string): THiMAP_Front_Design;
var Li: THiMAP_Front_Design;
begin
  for Li := Low(THiMAP_Front_Design) to High(THiMAP_Front_Design) do
  begin
    if R_HiMAP_Front_Design[Li].VCode = AFD then
    begin
      Result := R_HiMAP_Front_Design[Li].Value;
      exit;
    end;
  end;
end;

function HFrontDesign2HVCode(AFD:THiMAP_Front_Design) : string;
begin
  if AFD <= High(THiMAP_Front_Design) then
    Result := R_HiMAP_Front_Design[AFD].H_VCode;
end;

function HVCode2HFrontDesign(AFD:string): THiMAP_Front_Design;
var Li: THiMAP_Front_Design;
begin
  for Li := Low(THiMAP_Front_Design) to High(THiMAP_Front_Design) do
  begin
    if R_HiMAP_Front_Design[Li].H_VCode = AFD then
    begin
      Result := R_HiMAP_Front_Design[Li].Value;
      exit;
    end;
  end;
end;

procedure HFrontDesign2Combo(AComboBox:TComboBox);
var Li: THiMAP_Front_Design;
begin
  AComboBox.Clear;

  for Li := Low(THiMAP_Front_Design) to Pred(High(THiMAP_Front_Design)) do
  begin
    if Li = Low(THiMAP_Front_Design) then
      AComboBox.Items.Add(R_HiMAP_Front_Design[Li].Description)
    else
      AComboBox.Items.Add(R_HiMAP_Front_Design[Li].VCode + ' : ' + R_HiMAP_Front_Design[Li].Description);
  end;
end;

procedure HFrontDesign2Combo2(AComboBox:TComboBox);
var Li: THiMAP_Front_Design;
begin
  AComboBox.Clear;

  for Li := Low(THiMAP_Front_Design) to Pred(High(THiMAP_Front_Design)) do
  begin
    if Li = Low(THiMAP_Front_Design) then
      AComboBox.Items.Add(R_HiMAP_Front_Design[Li].Description)
    else
    if R_HiMAP_Front_Design[Li].H_VCode <> '' then
      AComboBox.Items.Add(R_HiMAP_Front_Design[Li].H_VCode + ' : ' + R_HiMAP_Front_Design[Li].Description);
  end;
end;

function HRecordingUnit2Desc(ARU:THiMAP_Recording_Unit) : string;
begin
  if ARU <= High(THiMAP_Recording_Unit) then
    Result := R_HiMAP_Recording_Unit[ARU].Description;
end;

function Desc2HRecordingUnit(ARU:string): THiMAP_Recording_Unit;
var Li: THiMAP_Recording_Unit;
begin
  for Li := Low(THiMAP_Recording_Unit) to High(THiMAP_Recording_Unit) do
  begin
    if R_HiMAP_Recording_Unit[Li].Description = ARU then
    begin
      Result := R_HiMAP_Recording_Unit[Li].Value;
      exit;
    end;
  end;
end;

function HRecordingUnit2VCode(ARU:THiMAP_Recording_Unit) : string;
begin
  if ARU <= High(THiMAP_Recording_Unit) then
    Result := R_HiMAP_Recording_Unit[ARU].VCode;
end;

function VCode2HRecordingUnit(ARU:string): THiMAP_Recording_Unit;
var Li: THiMAP_Recording_Unit;
begin
  for Li := Low(THiMAP_Recording_Unit) to High(THiMAP_Recording_Unit) do
  begin
    if R_HiMAP_Recording_Unit[Li].VCode = ARU then
    begin
      Result := R_HiMAP_Recording_Unit[Li].Value;
      exit;
    end;
  end;
end;

function HRecordingUnit2HVCode(ARU:THiMAP_Recording_Unit) : string;
begin
  if ARU <= High(THiMAP_Recording_Unit) then
    Result := R_HiMAP_Recording_Unit[ARU].H_VCode;
end;

function HVCode2HRecordingUnit(ARU:string): THiMAP_Recording_Unit;
var Li: THiMAP_Recording_Unit;
begin
  for Li := Low(THiMAP_Recording_Unit) to High(THiMAP_Recording_Unit) do
  begin
    if R_HiMAP_Recording_Unit[Li].H_VCode = ARU then
    begin
      Result := R_HiMAP_Recording_Unit[Li].Value;
      exit;
    end;
  end;
end;

procedure HRecordingUnit2Combo(AComboBox:TComboBox);
var Li: THiMAP_Recording_Unit;
begin
  AComboBox.Clear;

  for Li := Low(THiMAP_Recording_Unit) to Pred(High(THiMAP_Recording_Unit)) do
  begin
    if Li = Low(THiMAP_Recording_Unit) then
      AComboBox.Items.Add(R_HiMAP_Recording_Unit[Li].Description)
    else
      AComboBox.Items.Add(R_HiMAP_Recording_Unit[Li].VCode + ' : ' + R_HiMAP_Recording_Unit[Li].Description);
  end;
end;

procedure HRecordingUnit2Combo2(AComboBox:TComboBox);
var Li: THiMAP_Recording_Unit;
begin
  AComboBox.Clear;

  for Li := Low(THiMAP_Recording_Unit) to Pred(High(THiMAP_Recording_Unit)) do
  begin
    if Li = Low(THiMAP_Recording_Unit) then
      AComboBox.Items.Add(R_HiMAP_Recording_Unit[Li].Description)
    else
    if R_HiMAP_Recording_Unit[Li].H_VCode <> '' then
      AComboBox.Items.Add(R_HiMAP_Recording_Unit[Li].H_VCode + ' : ' + R_HiMAP_Recording_Unit[Li].Description);
  end;
end;

function HCommunication2Desc(AComm:THiMAP_COMMUNICATION) : string;
begin
  if AComm <= High(THiMAP_COMMUNICATION) then
    Result := R_HiMAP_Communication[AComm].Description;
end;

function Desc2HCommunication(AComm:string): THiMAP_COMMUNICATION;
var Li: THiMAP_COMMUNICATION;
begin
  for Li := Low(THiMAP_COMMUNICATION) to High(THiMAP_COMMUNICATION) do
  begin
    if R_HiMAP_Communication[Li].Description = AComm then
    begin
      Result := R_HiMAP_Communication[Li].Value;
      exit;
    end;
  end;
end;

function HCommunication2HVCode(AComm:THiMAP_COMMUNICATION) : string;
begin
  if AComm <= High(THiMAP_COMMUNICATION) then
    Result := R_HiMAP_Communication[AComm].H_VCode;
end;

function HVCode2HCommunication(AComm:string): THiMAP_COMMUNICATION;
var Li: THiMAP_COMMUNICATION;
begin
  for Li := Low(THiMAP_COMMUNICATION) to High(THiMAP_COMMUNICATION) do
  begin
    if R_HiMAP_Communication[Li].H_VCode = AComm then
    begin
      Result := R_HiMAP_Communication[Li].Value;
      exit;
    end;
  end;
end;

procedure HCommunication2Combo2(AComboBox:TComboBox);
var Li: THiMAP_COMMUNICATION;
begin
  AComboBox.Clear;

  for Li := Low(THiMAP_COMMUNICATION) to Pred(High(THiMAP_COMMUNICATION)) do
  begin
    if Li = Low(THiMAP_COMMUNICATION) then
      AComboBox.Items.Add(R_HiMAP_Communication[Li].Description)
    else
    if R_HiMAP_Communication[Li].H_VCode <> '' then
      AComboBox.Items.Add(R_HiMAP_Communication[Li].H_VCode + ' : ' + R_HiMAP_Communication[Li].Description);
  end;
end;

function HExtBoard2Desc(AExtBrd:THiMAP_EXTENDED_BOARD) : string;
begin
  if AExtBrd <= High(THiMAP_EXTENDED_BOARD) then
    Result := R_HiMAP_Extended_Board[AExtBrd].Description;
end;

function Desc2HExtBoard(AExtBrd:string): THiMAP_EXTENDED_BOARD;
var Li: THiMAP_EXTENDED_BOARD;
begin
  for Li := Low(THiMAP_EXTENDED_BOARD) to High(THiMAP_EXTENDED_BOARD) do
  begin
    if R_HiMAP_Extended_Board[Li].Description = AExtBrd then
    begin
      Result := R_HiMAP_Extended_Board[Li].Value;
      exit;
    end;
  end;
end;

function HExtBoard2HVCode(AExtBrd:THiMAP_EXTENDED_BOARD) : string;
begin
  if AExtBrd <= High(THiMAP_EXTENDED_BOARD) then
    Result := R_HiMAP_Extended_Board[AExtBrd].H_VCode;
end;

function HVCode2HExtBoard(AExtBrd:string): THiMAP_EXTENDED_BOARD;
var Li: THiMAP_EXTENDED_BOARD;
begin
  for Li := Low(THiMAP_EXTENDED_BOARD) to High(THiMAP_EXTENDED_BOARD) do
  begin
    if R_HiMAP_Extended_Board[Li].H_VCode = AExtBrd then
    begin
      Result := R_HiMAP_Extended_Board[Li].Value;
      exit;
    end;
  end;
end;

procedure HExtBoard2Combo2(AComboBox:TComboBox);
var Li: THiMAP_EXTENDED_BOARD;
begin
  AComboBox.Clear;

  for Li := Low(THiMAP_EXTENDED_BOARD) to Pred(High(THiMAP_EXTENDED_BOARD)) do
  begin
    if Li = Low(THiMAP_EXTENDED_BOARD) then
      AComboBox.Items.Add(R_HiMAP_Extended_Board[Li].Description)
    else
    if R_HiMAP_Extended_Board[Li].H_VCode <> '' then
      AComboBox.Items.Add(R_HiMAP_Extended_Board[Li].H_VCode + ' : ' + R_HiMAP_Extended_Board[Li].Description);
  end;
end;

function HSpecialConfig2Desc(ASepecialConfig:THiMAP_SPECIAL_CONFIG) : string;
begin
  if ASepecialConfig <= High(THiMAP_SPECIAL_CONFIG) then
    Result := R_HiMAP_Special_Config[ASepecialConfig].Description;
end;

function HSpecialConfigs2Desc(ASepecialConfigs:string) : string;
var
  LStr: string;
  i: integer;
begin
  for i := 1 to Length(ASepecialConfigs) do
  begin
    LStr := LeftStr(ASepecialConfigs, i);
    Result := Result + HSpecialConfig2Desc(HVCode2HSpecialConfig(LStr)) + ';';
  end;
end;

function Desc2HSpecialConfig(ASepecialConfig:string): THiMAP_SPECIAL_CONFIG;
var Li: THiMAP_SPECIAL_CONFIG;
begin
  for Li := Low(THiMAP_SPECIAL_CONFIG) to High(THiMAP_SPECIAL_CONFIG) do
  begin
    if R_HiMAP_Special_Config[Li].Description = ASepecialConfig then
    begin
      Result := R_HiMAP_Special_Config[Li].Value;
      exit;
    end;
  end;
end;

function HSpecialConfig2HVCode(ASepecialConfig:THiMAP_SPECIAL_CONFIG) : string;
begin
  if ASepecialConfig <= High(THiMAP_SPECIAL_CONFIG) then
    Result := R_HiMAP_Special_Config[ASepecialConfig].H_VCode;
end;

function HVCode2HSpecialConfig(ASepecialConfig:string): THiMAP_SPECIAL_CONFIG;
var Li: THiMAP_SPECIAL_CONFIG;
begin
  for Li := Low(THiMAP_SPECIAL_CONFIG) to High(THiMAP_SPECIAL_CONFIG) do
  begin
    if R_HiMAP_Special_Config[Li].H_VCode = ASepecialConfig then
    begin
      Result := R_HiMAP_Special_Config[Li].Value;
      exit;
    end;
  end;
end;

procedure HSpecialConfig2Combo2(AComboBox:TComboBox);
var Li: THiMAP_SPECIAL_CONFIG;
begin
  AComboBox.Clear;

  for Li := Low(THiMAP_SPECIAL_CONFIG) to Pred(High(THiMAP_SPECIAL_CONFIG)) do
  begin
    if Li = Low(THiMAP_SPECIAL_CONFIG) then
      AComboBox.Items.Add(R_HiMAP_Special_Config[Li].Description)
    else
    if R_HiMAP_Special_Config[Li].H_VCode <> '' then
      AComboBox.Items.Add(R_HiMAP_Special_Config[Li].H_VCode + ' : ' + R_HiMAP_Special_Config[Li].Description);
  end;
end;

procedure HSpecialConfig2List(AList:TStrings);
var Li: THiMAP_SPECIAL_CONFIG;
begin
  AList.Clear;

  for Li := Succ(Low(THiMAP_SPECIAL_CONFIG)) to Pred(High(THiMAP_SPECIAL_CONFIG)) do
  begin
    if R_HiMAP_Special_Config[Li].H_VCode <> '' then
      AList.Add(R_HiMAP_Special_Config[Li].H_VCode + ' : ' + R_HiMAP_Special_Config[Li].Description);
  end;
end;

function HiMAP_SPECIAL_CONFIG_SetToInt(ss : THiMAP_SPECIAL_CONFIGs) : integer;
var intset : TIntegerSet;
    s : THiMAP_SPECIAL_CONFIG;
begin
  intSet := [];
  for s in ss do
    include(intSet, ord(s));
  result := integer(intSet);
end;

function IntToHiMAP_SPECIAL_CONFIG_Set(mask : integer) : THiMAP_SPECIAL_CONFIGs;
var intSet : TIntegerSet;
    b : byte;
begin
  intSet := TIntegerSet(mask);
  result := [];
  for b in intSet do
    include(result, THiMAP_SPECIAL_CONFIG(b));
end;

function HVCodes2HiMAP_SPECIAL_CONFIG_Set(ASepecialConfig:string): THiMAP_SPECIAL_CONFIGs;
var
  LStr: string;
  i: integer;
begin
  Result := [];

  for i := 1 to Length(ASepecialConfig) do
  begin
    LStr := LeftStr(ASepecialConfig, i);
    if LStr <> '' then
    begin
      System.Delete(ASepecialConfig, 1, 1);
      Result := Result + [HVCode2HSpecialConfig(LStr)];
    end;
  end;
end;

function HNormalFreq2Desc(ANormalFreq:THiMAP_NORMAL_FREQUENCY) : string;
begin
  if ANormalFreq <= High(THiMAP_NORMAL_FREQUENCY) then
    Result := R_HiMAP_Normal_Frequency[ANormalFreq].Description;
end;

function Desc2HNormalFreq(ANormalFreq:string): THiMAP_NORMAL_FREQUENCY;
var Li: THiMAP_NORMAL_FREQUENCY;
begin
  for Li := Low(THiMAP_NORMAL_FREQUENCY) to High(THiMAP_NORMAL_FREQUENCY) do
  begin
    if R_HiMAP_Normal_Frequency[Li].Description = ANormalFreq then
    begin
      Result := R_HiMAP_Normal_Frequency[Li].Value;
      exit;
    end;
  end;
end;

function HNormalFreq2HVCode(ANormalFreq:THiMAP_NORMAL_FREQUENCY) : string;
begin
  if ANormalFreq <= High(THiMAP_NORMAL_FREQUENCY) then
    Result := R_HiMAP_Normal_Frequency[ANormalFreq].H_VCode;
end;

function HVCode2HNormalFreq(ANormalFreq:string): THiMAP_NORMAL_FREQUENCY;
var Li: THiMAP_NORMAL_FREQUENCY;
begin
  for Li := Low(THiMAP_NORMAL_FREQUENCY) to High(THiMAP_NORMAL_FREQUENCY) do
  begin
    if R_HiMAP_Normal_Frequency[Li].H_VCode = ANormalFreq then
    begin
      Result := R_HiMAP_Normal_Frequency[Li].Value;
      exit;
    end;
  end;
end;

procedure HNormalFreq2Combo2(AComboBox:TComboBox);
var Li: THiMAP_NORMAL_FREQUENCY;
begin
  AComboBox.Clear;

  for Li := Low(THiMAP_NORMAL_FREQUENCY) to Pred(High(THiMAP_NORMAL_FREQUENCY)) do
  begin
    if Li = Low(THiMAP_NORMAL_FREQUENCY) then
      AComboBox.Items.Add(R_HiMAP_Normal_Frequency[Li].Description)
    else
    if R_HiMAP_Normal_Frequency[Li].H_VCode <> '' then
      AComboBox.Items.Add(R_HiMAP_Normal_Frequency[Li].H_VCode + ' : ' + R_HiMAP_Normal_Frequency[Li].Description);
  end;
end;

function HFrontType2Desc(AFrontType:THiMAP_FRONTPANEL_TYPE) : string;
begin
  if AFrontType <= High(THiMAP_FRONTPANEL_TYPE) then
    Result := R_HiMAP_FrontPanel_Type[AFrontType].Description;
end;

function Desc2HFrontType(AFrontType:string): THiMAP_FRONTPANEL_TYPE;
var Li: THiMAP_FRONTPANEL_TYPE;
begin
  for Li := Low(THiMAP_FRONTPANEL_TYPE) to High(THiMAP_FRONTPANEL_TYPE) do
  begin
    if R_HiMAP_FrontPanel_Type[Li].Description = AFrontType then
    begin
      Result := R_HiMAP_FrontPanel_Type[Li].Value;
      exit;
    end;
  end;
end;

function HFrontType2HVCode(AFrontType:THiMAP_FRONTPANEL_TYPE) : string;
begin
  if AFrontType <= High(THiMAP_FRONTPANEL_TYPE) then
    Result := R_HiMAP_FrontPanel_Type[AFrontType].H_VCode;
end;

function HVCode2HFrontType(AFrontType:string): THiMAP_FRONTPANEL_TYPE;
var Li: THiMAP_FRONTPANEL_TYPE;
begin
  for Li := Low(THiMAP_FRONTPANEL_TYPE) to High(THiMAP_FRONTPANEL_TYPE) do
  begin
    if R_HiMAP_FrontPanel_Type[Li].H_VCode = AFrontType then
    begin
      Result := R_HiMAP_FrontPanel_Type[Li].Value;
      exit;
    end;
  end;
end;

procedure HFrontType2Combo2(AComboBox:TComboBox);
var Li: THiMAP_FRONTPANEL_TYPE;
begin
  AComboBox.Clear;

  for Li := Low(THiMAP_FRONTPANEL_TYPE) to Pred(High(THiMAP_FRONTPANEL_TYPE)) do
  begin
    if Li = Low(THiMAP_FRONTPANEL_TYPE) then
      AComboBox.Items.Add(R_HiMAP_FrontPanel_Type[Li].Description)
    else
    if R_HiMAP_FrontPanel_Type[Li].H_VCode <> '' then
      AComboBox.Items.Add(R_HiMAP_FrontPanel_Type[Li].H_VCode + ' : ' + R_HiMAP_FrontPanel_Type[Li].Description);
  end;
end;

end.
