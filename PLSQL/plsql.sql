-- CAMPUS VIRTUAL. PL/SQL. 
-- Grupo MATRIX: 
--  Nadia Carrera Chahir,  
--  María Castro Martínez, 
--  Rime Raissouni,
--  Joaquín Terrasa Moya.


-- Se desea crear un mecanismo para conceder permiso explícito sobre los objetos que posee el usuario CAMPUS 
-- a algunos usuarios en concreto. Para ello se deberán realizar los siguientes pasos:

-- 1. Crear una tabla T_PERMISOS en el usuario CAMPUS:

create table T_PERMISOS (USUARIO VARCHAR2(50), OBJETO VARCHAR2(50),	FECHA	DATE, PERMISO VARCHAR2(20),	ACTIVO NUMBER(1));

-- ALICIA, ALBERTO, DAVID y RAM son usuarios ya existentes en nuestro esquema CAMPUS:

INSERT INTO T_PERMISOS VALUES ('ALICIA',	'V_DATOS_USUARIO',	'20/05/2017',	'SELECT',	1);
INSERT INTO T_PERMISOS VALUES ('ALBERTO',	'V_DATOS_USUARIO',	'22/05/2017',	'SELECT',	1);
INSERT INTO T_PERMISOS VALUES ('RAM',	'RESPUESTAS',	'23/05/2017',	'INSERT',	1);
INSERT INTO T_PERMISOS VALUES ('DAVID',	'V_CALIFICACIONES',	'23/05/2017',	'SELECT',	0);

-- 2. Conceder permiso al usuario CAMPUS para que este usuario pueda consultar los permisos concedidos en el sistema. 
-- Para ello, conéctate como SYS AS SYSDBA y haz GRANT SELECT en la vista correspondiente.

-- En sysdba: 
grant select on dba_tab_privs to CAMPUS;

-- 3. Realizar un procedimiento dentro del usuario CAMPUS que lea los datos de la tabla T_PERMISOS de más antiguo a más reciente 
-- y vaya concediendo o revocando permisos a cada uno de los usuarios de la tabla según el valor de la columna ACTIVO, siempre 
-- y cuando sea necesario, lo cual se comprobará en la vista DBA_TAB_PRIVS. Así, en el ejemplo, suponiendo que USU1 tiene 
-- permiso para ver la vista V_PERMISOS, las instrucciones a ejecutar deberían ser:
-- GRANT INSERT ON CAMPUS.V_RESULTADO TO USU2;
-- REVOKE SELECT ON CAMPUS.V_PERMISOS FROM USU1;

CREATE OR REPLACE PROCEDURE PR_DAR_PERMISOS AS
--leer los datos de la tabla T_PERMISOS de más antiguo a más reciente
CURSOR c_permisos IS SELECT * FROM T_PERMISOS ORDER BY fecha ASC;
counter NUMBER;

BEGIN
  FOR var_permisos IN c_permisos LOOP
  -- vaya concediendo o revocando permisos a cada uno de los usuarios de la tabla según el valor de la columna ACTIVO
  -- ..siempre y cuando sea necesario, lo cual se comprobará en la vista DBA_TAB_PRIVS.
  SELECT count(*) INTO counter FROM DBA_TAB_PRIVS
  WHERE GRANTEE = var_permisos.usuario AND TABLE_NAME = var_permisos.objeto AND PRIVILEGE = var_permisos.permiso;
  
  IF counter = 0 AND var_permisos.activo = 1 THEN
  -- vaya concediendo o revocando permisos a cada uno de los usuarios de la tabla según el valor de la columna ACTIVO
      EXECUTE IMMEDIATE 'GRANT '||var_permisos.permiso||' ON '||var_permisos.objeto||' TO '||var_permisos.usuario ;
  ELSIF counter != 0 AND var_permisos.activo = 0 THEN
      EXECUTE IMMEDIATE 'REVOKE '||var_permisos.permiso||' ON '||var_permisos.objeto||' FROM '||var_permisos.usuario ;
  END IF;
  -- Si el campo Activo está a 0 para un permiso que no está otorgado tampoco se ejecuta nada. De hecho, si ejecutamos 2 veces 
  -- seguidas el procedimiento, la segunda ejecución no cambiará los permisos, porque están como indica la tabla.
  END LOOP;

END PR_DAR_PERMISOS;


-- Ejecutamos el procedimiento y comprobamos el resultado:

EXECUTE PR_DAR_PERMISOS;

select * from dba_tab_privs where grantee = 'ALICIA';
select * from dba_tab_privs where grantee = 'ALBERTO';
select * from dba_tab_privs where grantee = 'RAM';
select * from dba_tab_privs where grantee = 'DAVID';








