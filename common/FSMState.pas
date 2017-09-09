unit FSMState;

interface

type
  TIntegerArray = array of integer;

  TFSMState = class
	  m_wNumberOfTransistions: word;	    // maximum number of states supported by this state
	  m_piInputs: array of integer;	      // input array for tranistions
	  m_piOutputState: array of integer;	// output state array
	  m_iStateID: integer;						    // the unique ID of this state

  public
	  // constructor accepts an ID for this state and the number of transitions to support
	  Constructor Create( iStateID: integer; wTransitions: word );
	  // destructor cleans up allocated arrays
	  Destructor Destroy;

  	// access the state ID
	  function GetID: integer; { return m_iStateID; }
	  // add a state transition to the array
	  procedure AddTransition( iInput: integer; iOutputID: integer );
	  // remove a state transation from the array
	  procedure DeleteTransition( iOutputID: integer );
	  // get the output state and effect a transistion
	  function GetOutput( iInput: integer ): integer;
    function GetOutputs: TIntegerArray;
  end;

implementation

//////////////////////////////////////////////////////////////////////
// AddTransition() - accept an input transition threshhold and the
// output state ID to associate with it
//////////////////////////////////////////////////////////////////////
procedure TFSMState.AddTransition( iInput: integer; iOutputID: integer );
var i: integer;
begin
	// the m_piInputs[] and m_piOutputState[] are not sorted
	// so find the first non-zero offset in m_piOutputState[]
	// and use that offset to store the input and OutputID
	// within the m_piInputs[] and m_piOutputState[]
	for i := 0 to m_wNumberOfTransistions - 1 do
	begin
		if( m_piOutputState[i] = 0) then
			break;
	end;

	// only a valid offset is used
	if( i < m_wNumberOfTransistions ) then
	begin
		m_piOutputState[i] := iOutputID;
		m_piInputs[i] := iInput;
	end;
end;

//////////////////////////////////////////////////////////////////////
// GetOutput() - accepts an input transition value and finds the
// input transition value stored in m_piInputs[] that is associated
// with an output state ID and returns that output state ID
//
// NOTE: this function acts as a state transition function and could
// be replaced with a different transition approach depending on the
// needs of your FSM
//////////////////////////////////////////////////////////////////////
function TFSMState.GetOutput( iInput: integer ): integer;
var iOutputID, i: integer;
begin
	iOutputID := m_iStateID;	// output state to be returned

	// for each possible transistion
	for i := 0 to m_wNumberOfTransistions - 1 do
  begin
    // zeroed output state IDs indicate the end of the array
		if( m_piOutputState[i] = 0 ) then
			break;

		// state transition function: look for a match with the input value
		if( iInput = m_piInputs[i] ) then
		begin
			iOutputID := m_piOutputState[i];	// output state id
			break;
		end;
	end;//for

	// returning either this m_iStateID to indicate no output
	// state was matched by the input (ie. no state transition
	// can occur) or the transitioned output state ID
	Result := iOutputID;
end;

function TFSMState.GetOutputs: TIntegerArray;
var
  i: integer;
begin
  SetLength(Result, High(m_piOutputState)+1);

  for i := Low(m_piOutputState) to High(m_piOutputState) do
    Result[i] := m_piOutputState[i];
end;

//////////////////////////////////////////////////////////////////////
// DeleteTransition() - remove an output state ID and its associated
// input transition value from the arrays and zero out the slot used
//////////////////////////////////////////////////////////////////////
procedure TFSMState.DeleteTransition( iOutputID: integer );
var i,j: integer;
begin
	// the m_piInputs[] and m_piOutputState[] are not sorted
	// so find the offset of the output state ID to remove
	for i := 0 to m_wNumberOfTransistions - 1 do
	begin
		if( m_piOutputState[i] = iOutputID ) then
			break;
	end;//for

	// test to be sure the offset is valid
	if( i >= m_wNumberOfTransistions ) then
		exit;

	// remove this output ID and its input transition value
	m_piInputs[i] := 0;
	m_piOutputState[i] := 0;

	// since the m_piInputs[] and m_piOutputState[] are not
	// sorted, then we need to shift the remaining contents
	for j := i to m_wNumberOfTransistions - 1 do
  begin
		if( m_piOutputState[i] = 0 ) then
			break;

		m_piInputs[i] := m_piInputs[i+1];
		m_piOutputState[i] := m_piOutputState[i+1];
	end;//for

	// and make sure the last used offset is cleared
	m_piInputs[i] := 0;
	m_piOutputState[i] := 0;
end;

//////////////////////////////////////////////////////////////////////
// Create() - create a new instance and allocate arrays
//////////////////////////////////////////////////////////////////////
Constructor TFSMState.Create( iStateID: integer; wTransitions: word );
var i: integer;
begin
	// don't allow 0 transitions
	if( wTransitions = 0 ) then
		m_wNumberOfTransistions := 1
	else
		m_wNumberOfTransistions := wTransitions;

	// save off id and number of transitions
	m_iStateID := iStateID;

	// now allocate each array
	try
		SetLength(m_piInputs, m_wNumberOfTransistions);
		for i := 0 to m_wNumberOfTransistions - 1 do
			m_piInputs[i] := 0;
  except
  end;

	try
		SetLength(m_piOutputState, m_wNumberOfTransistions);
		for i := 0 to m_wNumberOfTransistions-1 do
			m_piOutputState[i] := 0;
  except
		m_piInputs := nil;
	end;//try
end;

//////////////////////////////////////////////////////////////////////
// Destroy() - clean up by returning memory used for arrays
//////////////////////////////////////////////////////////////////////
Destructor TFSMState.Destroy;
begin
	m_piInputs := nil;
	m_piOutputState := nil;
end;

function TFSMState.GetID: integer;
begin
  Result := m_iStateID;
end;

end.
