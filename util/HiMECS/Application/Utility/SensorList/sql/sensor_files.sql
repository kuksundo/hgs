CREATE TABLE SENSOR_FILES
(
  SENSORID    INTEGER          NOT NULL,
  SENSORCODE  NUMBER           NOT NULL,
  CGCODE      INTEGER,
  DRAWNO      VARCHAR2(30 CHAR),
  FILENAME    VARCHAR2(30 CHAR),
  FILESIZE    NUMBER,
  FILES       BLOB,
  REG_DATE    DATE,
  PRIMARY KEY(SENSORID, SENSORCODE)
)

CREATE SEQUENCE SEQ_SENSOR_FILES
  START WITH 1
  INCREMENT BY 1;

CREATE OR REPLACE TRIGGER TRG_SENSOR_FILES
  BEFORE INSERT ON SENSOR_FILES
  FOR EACH ROW
BEGIN
  SELECT SEQ_SENSOR_FILES.Nextval
  INTO :NEW.SENSORID
  FROM DUAL;
END;
  