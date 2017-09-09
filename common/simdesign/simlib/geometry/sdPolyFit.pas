{
  Polynomial fits to a data set of points.

  The polynomial is defined as
        N
  Y = Sig Ak X^k
      k=0

  The coefficients A0..AN are estimated from the dataset using a least-squares
  solver

  N is the degree of the polynomial
  
  TODO!

}
unit sdPolyFit;

interface

uses
  Classes;

type

  TsdPolyFit = class(TPersistent)
  end;

implementation

end.
