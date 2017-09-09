unit CommonData;

interface

type
  TData = record
    HasInput: boolean;
    Value1, Value2: integer;
  end;

const
  SHARED_DATA_NAME = 'SharedData_{AD8721E6-16F6-40E8-9881-2F6641DD53BB}';
  CONSUME_EVENT_NAME = SHARED_DATA_NAME + '_ConsumeEvent';
  PRODUCE_EVENT_NAME = SHARED_DATA_NAME + '_ProduceEvent';

implementation

end.
