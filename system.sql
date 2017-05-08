-- Las sentencias ejecutadas por SYSTEM

create tablespace TS_CAMPUS datafile 'tscampus.dbf' size 10M autoextend on;

create user CAMPUS identified by campus default tablespace TS_CAMPUS quota 100M on TS_CAMPUS;

grant connect to CAMPUS with admin option;
grant create table, create view, create procedure to CAMPUS;

grant create role to CAMPUS;

CREATE OR REPLACE TRIGGER CAMPUS.TR_CONEXIONES
AFTER LOGON ON DATABASE 
BEGIN
  INSERT INTO CAMPUS.CONEXIONES (SESIONID, USUARIO, IP, MAQUINA, INICIO)  
  SELECT SYS_CONTEXT('USERENV','SESSIONID'), SYS_CONTEXT('USERENV','SESSION_USER'), SYS_CONTEXT('USERENV','IP_ADDRESS'), SYS_CONTEXT('USERENV','HOST'), SYSDATE FROM DUAL;
END;

grant create, drop, update user to CAMPUS;