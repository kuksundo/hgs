program ppworker;
//
//  Paranoid Pirate worker
//  @author Varga Bal?s <bb.varga@gmail.com>
//
{$APPTYPE CONSOLE}

uses
    SysUtils
  , zmqapi
  , zhelpers
  , zmq
  ;

const
  HEARTBEAT_LIVENESS = 3;    //  3-5 is reasonable
  HEARTBEAT_INTERVAL = 1000; //  msecs
  INTERVAL_INIT = 1000;      //  Initial reconnect
  INTERVAL_MAX = 32000;      //  After exponential backoff

//  Paranoid Pirate Protocol constants
  PPP_READY = '\001';        //  Signals worker is ready
  PPP_HEARTBEAT = '\002';    //  Signals worker heartbeat

//  Helper function that returns a new configured socket
//  connected to the Paranoid Pirate queue

function s_worker_socket( ctx: TZMQContext ): TZMQSocket;
var
  worker: TZMQSocket;
begin
  worker := ctx.Socket( stDealer );
  worker.connect( 'tcp://localhost:5556 ' );

  //  Tell queue we're ready for work
  Writeln( 'I: worker ready' );
  worker.send( PPP_READY );

  result := worker;
end;

//  We have a single task, which implements the worker side of the
//  Paranoid Pirate Protocol (PPP). The interesting parts here are
//  the heartbeating, which lets the worker detect if the queue has
//  died, and vice-versa:
var
  ctx: TZMQContext;
  worker: TZMQSocket;
  liveness,
  interval: size_t;
  heartbeat_at: Int64;
  cycles: Integer;
  poller: TZMQPoller;
  msg: TZMQMsg;
begin
  ctx := TZMQContext.create;
  worker := s_worker_socket( ctx );

  //  If liveness hits zero, queue is considered disconnected
  liveness := HEARTBEAT_LIVENESS;
  interval := INTERVAL_INIT;

  //  Send out heartbeats at regular intervals
  heartbeat_at := zIncTimeMs( zTimeStamp, HEARTBEAT_INTERVAL );

  Randomize;
  cycles := 0;

  poller := TZMQPoller.Create( true );
  poller.Register( worker, [pePollIn] );
  while not ctx.Terminated do
  try
    poller.poll( HEARTBEAT_INTERVAL );

    if pePollIn in poller.PollItem[0].revents then
    begin
      //  Get message
      //  - 3-part envelope + content -> request
      //  - 1-part HEARTBEAT -> heartbeat
      msg := nil;
      worker.recv( msg );

      //  To test the robustness of the queue implementation we //
      //  simulate various typical problems, such as the worker
      //  crashing, or running very slowly. We do this after a few
      //  cycles so that the architecture can get up and running
      //  first:
      if msg.size = 3 then
      begin
        Inc( cycles );
        if ( cycles > 3 ) and ( random( 5 ) = 0 ) then
        begin
          Writeln( 'I: simulating a crash' );
          FreeAndNil( msg );
          break;
        end else

        if ( cycles > 3 ) and ( random( 5 ) = 0 ) then
        begin
          Writeln( 'I: simulating CPU overload' );
          sleep( 3000 );
          if ctx.Terminated then
            break;
        end;
        Writeln( 'I: normal reply' );
        worker.send( msg );
        liveness := HEARTBEAT_LIVENESS;
        sleep( 1000 );              //  Do some heavy work
        if ctx.Terminated then
          break;
      end else

      //  When we get a heartbeat message from the queue, it means the
      //  queue was (recently) alive, so reset our liveness indicator:
      if msg.size = 1 then
      begin
        if msg.first.asUtf8String = PPP_HEARTBEAT then
          liveness := HEARTBEAT_LIVENESS
        else begin
          Writeln( 'E: invalid message' );
          Writeln( msg.first.dump );
        end;
        FreeAndNil( msg );
      end else
      begin
        Writeln( 'E: invalid message' );
        //Writeln( msg.dump );
      end;
      interval := INTERVAL_INIT;
    end else

    //  If the queue hasn't sent us heartbeats in a while, destroy the
    //  socket and reconnect. This is the simplest most brutal way of
    //  discarding any messages we might have sent in the meantime://
    begin
      Dec( liveness );
      if liveness = 0 then
      begin
        Writeln( 'W: heartbeat failure, can''t reach queue' );
        Writeln( Format( 'W: reconnecting in %d msec...', [interval] ) );
        sleep( interval );

        if interval < INTERVAL_MAX then
          interval := interval * 2;

        poller.Deregister( worker, [pePollIn] );
        worker.Free;
        worker := s_worker_socket( ctx );
        poller.Register( worker, [pePollIn] );
        liveness := HEARTBEAT_LIVENESS;
      end;
    end;

    //  Send heartbeat to queue if it's time
    if zTimeStamp > heartbeat_at then
    begin
      heartbeat_at := zIncTimeMs( zTimeStamp, HEARTBEAT_INTERVAL );
      Writeln( 'I: worker heartbeat' );
      worker.send( PPP_HeartBeat );
    end;
  except
  end;
  ctx.Free;
end.
