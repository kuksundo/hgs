{** This unit is a nice demonstration of how DeCAL's generic programming works.
Note that there are only two IO procedures in this unit, and they will
successfully do IO for ALL the DeCAL data structures.  Everything in DeCAL boils
down to either a sequence or a map, so we provide those two and let the
DeCAL structures handle the rest. <P>

Copyright (c) 2000 Ross Judson.  <P>

  The contents of this file are subject to the Mozilla Public License
  Version 1.0 (the "License"); you may not use this file except in
  compliance with the License. You may obtain a copy of the
  License at http://www.mozilla.org/MPL/ <P>

}

unit DeCALIO;

interface

implementation

uses DeCAL, SuperStream;

procedure IODContainer(obj : TObject; stream : TObjStream; direction : TObjIODirection; version : Integer; var callSuper : Boolean);
var
	len : Integer;
	i: integer;
  seq : DSequence;
  iter : DIterator;
  empty : DObject;
begin
	seq := obj as DSequence;
  case version of		{  }
    1 :
    begin
      if direction = ioDirWrite then
      	begin
		      len := seq.Size;
          stream.write(len, sizeof(len));
          if len > 0 then
          	begin
            	iter := seq.start;
              while not atEnd(iter) do
              	begin
                	stream.TransferVarRec(getRef(iter)^, direction);
                  advance(iter);
                end;		{ while }
            end;

        end
      else
      	begin
					stream.read(len, sizeof(len));
          if len > 0 then
          	begin
              i := 0;
              while i < len do
              	begin
                  stream.TransferVarRec(empty, direction);
                  seq.add(empty);
                  ClearDObject(empty);
                  Inc(i);
                end;		{ while }
            end;

        end;

    end;
  end;		{ case }
end;


procedure IODSequence(obj : TObject; stream : TObjStream; direction : TObjIODirection; version : Integer; var callSuper : Boolean);
var
	len : Integer;
	i: integer;
  seq : DSequence;
  iter : DIterator;
  empty : DObject;
begin
	seq := obj as DSequence;
  case version of		{  }
    1 :
    begin
      if direction = ioDirWrite then
      	begin
		      len := seq.Size;
          stream.write(len, sizeof(len));
          if len > 0 then
          	begin
            	iter := seq.start;
              while not atEnd(iter) do
              	begin
                	stream.TransferVarRec(getRef(iter)^, direction);
                  advance(iter);
                end;		{ while }
            end;

        end
      else
      	begin
        	seq.create;
					stream.read(len, sizeof(len));
          if len > 0 then
          	begin
              i := 0;
              while i < len do
              	begin
                  stream.TransferVarRec(empty, direction);
                  seq.add(empty);
                  ClearDObject(empty);
                  Inc(i);
                end;		{ while }
            end;

        end;

    end;
  end;		{ case }
end;

procedure IODInternalMap(obj : TObject; stream : TObjStream; direction : TObjIODirection; version : Integer; var callSuper : Boolean);
var map : DInternalMap;
		len : Integer;
    iter : DIterator;
    key, value : DObject;
begin
	map := obj as DInternalMap;
  case version of
  	1:
    	begin
        if direction = iodirWrite then
          begin
            len := map.size;
            stream.write(len, sizeof(len));
            iter := map.start;
            while not atEnd(iter) do
            	begin
              	SetToKey(iter);
              	stream.TransferVarRec(getRef(iter)^, direction);
              	SetToValue(iter);
              	stream.TransferVarRec(getRef(iter)^, direction);
              	advance(iter);
              end;
          end
        else
          begin
          	map.create; // this is virtual, so MultiMap will get called correctly
          	stream.read(len, sizeof(len));
            if len > 0 then
            	begin
              	while len > 0 do
                	begin
                    stream.transferVarRec(key, direction);
                    stream.transferVarRec(value, direction);
                    map.putAt(key, value);
                    ClearDObject(key);
                    ClearDObject(value);
                  	Dec(len);
                  end;
              end;
          end;
      end;
  end;
end;

procedure Init;
begin
	TObjStream.RegisterClass(DSequence, IODSequence, 1);
	TObjStream.RegisterClass(DInternalMap, IODInternalMap, 1);

  // simple registration with no IO procedure.
	TObjStream.RegisterClass(DMap, nil, 1);
	TObjStream.RegisterClass(DMultiMap, nil, 1);
	TObjStream.RegisterClass(DList, nil, 1);
	TObjStream.RegisterClass(DArray, nil, 1);
	TObjStream.RegisterClass(DSet, nil, 1);
	TObjStream.RegisterClass(DMultiSet, nil, 1);
end;

procedure Term;
begin
end;

initialization
	Init;
finalization
	Term;
end.
