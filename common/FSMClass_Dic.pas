unit FSMClass_Dic;

interface

uses System.Generics.Collections, FSMState;

type
  TFSMClass = class
	  m_map: TDictionary<integer, TFSMstate>;	// map containing all states of this FSM
	  m_iCurrentState: integer;	// the m_iStateID of the current state

  public
	  constructor Create( iStateID: integer ); 	// set initial state of the FSM
	  destructor Destroy;		                		// clean up memory usage

  	// return the current state ID
	  function GetCurrentState(): integer; { return m_iCurrentState; }
  	// set current state
	  procedure SetCurrentState( iStateID: integer ); { m_iCurrentState = iStateID; }

	  function GetState( iStateID: integer ): TFSMstate;	// return the FSMstate object pointer
	  procedure AddState( pNewState: TFSMstate );	// add a FSMstate object pointer to the map
	  procedure DeleteState( iStateID: integer );	// delete a FSMstate object pointer from the map

	  function StateTransition( iInput: integer ): integer;	// perform a state transition based on input and current state
  end;

implementation

//////////////////////////////////////////////////////////////////////
// StateTransition() - perform a state transition based on input value
// passed and the current state, and return m_iCurrentState if there
// is no matching output state for the input value, or 0 if there is
// some type of problem (like the current state not found)
//////////////////////////////////////////////////////////////////////
function TFSMClass.StateTransition( iInput: integer ): integer;
var pState: TFSMState;
begin
	// the current state of the FSM must be set to have a transition
	if( m_iCurrentState = 0 ) then
  begin
		Result := m_iCurrentState;
    exit;
  end;

	// get the pointer to the FSMstate object that is the current state
	pState := GetState( m_iCurrentState );
	if( pState = nil ) then
	begin
		// signal that there is a problem
		m_iCurrentState := 0;
		Result := m_iCurrentState;
    exit;
	end;//if

	// now pass along the input transition value and let the FSMstate
	// do the really tough job of transitioning for the FSM, and save
	// off the output state returned as the new current state of the
	// FSM and return the output state to the calling process
	m_iCurrentState := pState.GetOutput( iInput );
	Result := m_iCurrentState;
end;

function TFSMClass.GetCurrentState(): integer;
begin
  Result := m_iCurrentState;
end;

procedure TFSMClass.SetCurrentState( iStateID: integer );
begin
  m_iCurrentState := iStateID;
end;

//////////////////////////////////////////////////////////////////////
// GetState() - return the FSMstate object pointer referred to by the
// state ID passed
//////////////////////////////////////////////////////////////////////
function TFSMClass.GetState( iStateID: integer ): TFSMstate;
var
  pState: TFSMstate;
  LKey: integer;
begin
	pState := nil;

	// try to find this FSMstate in the map
  if m_map.Count > 0 then
  begin
    if m_map.ContainsKey(iStateID) then
      pState := m_map.Items[iStateID];// as TFSMstate;
  end;

	Result := pState;
end;

//////////////////////////////////////////////////////////////////////
// AddState() - add a FSMstate object pointer to the map
//////////////////////////////////////////////////////////////////////
procedure TFSMClass.AddState( pNewState: TFSMstate );
var
  pState : TFSMState;
  LKey: integer;
begin
	// try to find this FSMstate in the map
  if m_map.Count > 0 then
    if m_map.ContainsKey(pNewState.GetID) then
      exit;

  // put the FSMstate object pointer into the map
  m_map.Add(pNewState.GetID, pNewState);
end;

//////////////////////////////////////////////////////////////////////
// DeleteState() - delete a FSMstate object pointer from the map
//////////////////////////////////////////////////////////////////////
procedure TFSMClass.DeleteState( iStateID: integer );
var
  pState: TFSMState;
  LKey: integer;
begin
	pState := nil;

  if m_map.Count > 0 then
  begin
    if m_map.ContainsKey(iStateID) then
      pState := m_map.Items[iStateID];// as TFSMstate;
	end;//if

	if( (pState <> nil) and (pState.GetID() = iStateID) ) then
	begin
		m_map.Remove( iStateID );	// remove it from the map
		//delete pState;		// delete the object itself
	end;//if
end;

//////////////////////////////////////////////////////////////////////
// Create() - Construction method
//////////////////////////////////////////////////////////////////////
constructor TFSMClass.Create( iStateID: integer );
begin
	m_iCurrentState := iStateID;
  m_map := TDictionary<integer, TFSMstate>.Create;
end;

//////////////////////////////////////////////////////////////////////
// ~FSMclass() - Destruction method
//////////////////////////////////////////////////////////////////////
destructor TFSMClass.Destroy;
var
  LKey: integer;
begin
  for LKey in m_map.Keys do
    m_map.Items[LKey].Free;

  m_map.Clear;
  m_map.Free;
end;

end.
