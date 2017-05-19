-- Se desea crear un mecanismo para conceder permiso explícito sobre los objetos que posee el usuario CAMPUS 
-- a algunos usuarios en concreto. Para ello se deberán realizar los siguientes pasos:

-- 1. Crear una tabla T_PERMISOS en el usuario CAMPUS:

create table T_PERMISOS (USUARIO VARCHAR2(50), OBJETO VARCHAR2(50),	FECHA	DATE, PERMISO VARCHAR2(20),	ACTIVO NUMERIC);
INSERT INTO T_PERMISOS (USUARIO, OBJETO, FECHA, PERMISO, ACTIVO)
VALUES ('USU1',	'V_PERMISOS',	'20/05/2017',	'SELECT',	1);

INSERT INTO T_PERMISOS (USUARIO, OBJETO, FECHA, PERMISO, ACTIVO)
VALUES ('USU2',	'V_RESULTADO',	'22/05/2017',	'INSERT',	1);

INSERT INTO T_PERMISOS (USUARIO, OBJETO, FECHA, PERMISO, ACTIVO)
VALUES ('USU1',	'V_PERMISOS',	'23/05/2017',	'SELECT',	0);





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

create user usu1 identified by usu;
create user usu2 identified by usu;
--create or replace procedure 


-- Si el campo Activo está a 0 para un permiso que no está otorgado tampoco se ejecuta nada. De hecho, si ejecutamos 2 veces 
-- seguidas el procedimiento, la segunda ejecución no cambiará los permisos, porque están como indica la tabla.
