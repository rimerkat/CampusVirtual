CREATE TABLE historico
	(
	Nombre VARCHAR2(20), Apellidos VARCHAR2(40), Dni VARCHAR2(10),
	Expediente VARCHAR2(20), CodigoAsignatura VARCHAR(20),
	NombreAsignatura VARCHAR2(30), Curso VARCHAR2(10), Nota NUMBER, Calificacion VARCHAR2(10),
	CONSTRAINT dni_pk PRIMARY KEY (Dni));
  
CREATE TABLE errores (Expediente VARCHAR2(20), CodigoAsignatura VARCHAR2(20), ErrorC VARCHAR2(50));

-- Alterar tabla NOTAS_FINALES para poder poner la fecha de la convocatoria
alter table NOTAS_FINALES add Fecha DATE;


--  (1)
--  Realizar un JOB que almacene todos los datos en la tabla HISTORICO.
--  Crear un procedimiento con ASIGNATURA, ALUMNO, NOTAS_FINALES, ROL_US_AS (join)

--  (2)
--  Si se produjera algún error, debe capturarse, para asegurarnos de que la copia se realiza con los 
--  demás alumnos y asignaturas. Para ello se debe crear una tabla ERRORES donde aparezca el expediente del alumno,
--  el código de la asignatura y el error que se ha producido.

CREATE OR REPLACE PROCEDURE upload_job AS
  
  
BEGIN
  SELECT ... INTO ... FROM ...;
 delete from (select * from MENSAJES_BORRADOS); END;

EXCEPTION 
  WHEN OTHERS THEN -- captura todo tipo de error
    DECLARE
      err_num := SQLCODE;
      err_msg := SUBSTR(SQLERRM, 1, 200);
    BEGIN
      INSERT INTO errores VALUES (Expediente, CodigoAsignatura, 'Error number ' || err_num || ' : ' || err_msg);
    END;
END upload_job;



--Se crea el objeto con el rol CREATE JOB; luego, se ha de ejecutar en un usuario con permisos
BEGIN
    DBMS_SCHEDULER.CREATE_JOB (
      job_name => 'septiembre_job',
      job_type => 'STORED_PROCEDURE', -- antes: PLSQL_BLOCK
      repeat_interval => 'FREQ=YEARLY; BYMONTH=OCT; BYMONTHDAY=15', --cada 15 octubre, cada año
      job_action => 'upload_job',
      -- start_date => SYSDATE, -- no es necesario, se ejecuta cuando 'repeat_interval'
      enabled => TRUE,
      comments => 'Job MATRIX');

    -- DBMS_SCHEDULER.SET_ATTRIBUTE ('septiembre_job', 'max_runs', 100); -- ejecuta el JOB hasta 100 veces
END;
