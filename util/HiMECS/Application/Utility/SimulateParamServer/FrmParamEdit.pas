unit FrmParamEdit;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.ImgList, FrameGSFileList,
  Vcl.StdCtrls, NxEdit, Vcl.ComCtrls, JvExControls, JvLabel, AdvOfficePager,
  AeroButtons, Vcl.ExtCtrls;

type
  TParamEditF = class(TForm)
    Panel1: TPanel;
    AeroButton1: TAeroButton;
    btn_Close: TAeroButton;
    Panel3: TPanel;
    AdvOfficePage1: TAdvOfficePager;
    CertInfoPage: TAdvOfficePage;
    JvLabel3: TJvLabel;
    JvLabel4: TJvLabel;
    JvLabel31: TJvLabel;
    JvLabel49: TJvLabel;
    JvLabel2: TJvLabel;
    JvLabel6: TJvLabel;
    JvLabel7: TJvLabel;
    JvLabel1: TJvLabel;
    JvLabel5: TJvLabel;
    ProductTypeCB: TComboBox;
    UpdateDatePicker: TDateTimePicker;
    TrainedSubjectEdit: TNxButtonEdit;
    TrainedCourseEdit: TNxButtonEdit;
    CourseFileDBPathEdit: TNxButtonEdit;
    CourseFileDBNameEdit: TNxButtonEdit;
    CourseLevelCB: TComboBox;
    TrainDaysEdit: TEdit;
    TargetGroupEdit: TEdit;
    AttachmentPage: TAdvOfficePage;
    GSFileFrame: TGSFileListFrame;
    ImageList16x16: TImageList;
    Imglist16x16: TImageList;
  private
  public
    { Public declarations }
  end;

var
  ParamEditF: TParamEditF;

implementation

{$R *.dfm}

end.
