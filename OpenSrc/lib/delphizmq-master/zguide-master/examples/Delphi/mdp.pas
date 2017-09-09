unit mdp;
//  Majordomo Protocol definitions
//  @author Varga Balázs <bb.varga@gmail.com>

interface

{$ifndef __MDP_H_INCLUDED__}
{$define __MDP_H_INCLUDED__}

const
  //  This is the version of MDP/Client we implement
  MDPC_CLIENT     = 'MDPC01';

  //  This is the version of MDP/Worker we implement
  MDPW_WORKER     = 'MDPW01';

//  MDP/Server commands, as strings
  MDPW_READY      = #001;
  MDPW_REQUEST    = #002;
  MDPW_REPLY      = #003;
  MDPW_HEARTBEAT  = #004;
  MDPW_DISCONNECT = #005;

const
  mdps_Commands: Array[0..5] of String = (
    '',
    'READY',
    'REQUEST',
    'REPLY',
    'HEARTBEAT',
    'DISCONNECT'
  );

{$endif}
implementation
end.

