-- JOBS

-- (1)
-- Una vez que terminan los exámenes de septiembre se almacenan las notas finales en una tabla histórica, eliminándose los datos 
-- de las pruebas parciales. 
-- Para ello se debe crear una tabla llamada HISTORICO con el nombre y apellidos del usuario, su dni, expediente, usuario de oracle, 
-- código de asignatura, nombre de asignatura, curso académico, nota y calificación final. 

-- (1.1) Debemos añadir el atributo fecha en la tabla NOTAS_FINALES para poder poner la fecha de la convocatoria:
alter table NOTAS_FINALES add Fecha DATE;

-- (1.2) Creamos la tabla HISTORICO como indicado:
CREATE TABLE HISTORICO
	(
	Nombre VARCHAR2(20), Apellidos VARCHAR2(40), Dni VARCHAR2(10),
	Expediente VARCHAR2(20), UsuarioOracle varchar2(20), CodigoAsignatura VARCHAR(20),
	NombreAsignatura VARCHAR2(30), Curso VARCHAR2(10), Nota NUMBER, Calificacion VARCHAR2(10),
	CONSTRAINT dni_pk PRIMARY KEY (Dni));
  
-- (2)
-- Realizar un JOB que se ejecute todos los años el día 15 de octubre y que almacene todos los datos en la tabla HISTORICO.
--- (2.1) creamos el procedimiento que almacena los datos en la tabla HISTORICO:
CREATE OR REPLACE PROCEDURE upload_job AS  
BEGIN
  SELECT ... INTO ... FROM ...;
 delete from (select * from MENSAJES_BORRADOS); END;

EXCEPTION 
  WHEN OTHERS THEN -- captura todo tipo de error
      INSERT INTO errores VALUES (Expediente, CodigoAsignatura, 'Error number ' || SQLCODE || ' : ' || SQLERRM);
END;
END upload_job;

-- (2.2) Creamos el job:
BEGIN
    DBMS_SCHEDULER.CREATE_JOB (
      job_name => 'septiembre_job',
      job_type => 'STORED_PROCEDURE', -- usaremos el procedimiento anteriormente creado
      repeat_interval => 'FREQ=YEARLY; BYMONTH=OCT; BYMONTHDAY=15', --cada 15 octubre, de cada año
      job_action => 'upload_job',
      -- start_date => SYSDATE, -- no es necesario, se ejecuta cuando 'repeat_interval'
      enabled => TRUE,
      comments => 'Se ejecuta todos los años el día 15 de octubre y almacena todos los datos en la tabla HISTORICO');
    -- DBMS_SCHEDULER.SET_ATTRIBUTE ('septiembre_job', 'max_runs', 100); -- ejecuta el JOB hasta 100 veces
END;

-- (3)
-- (3.1) Si se produjera algún error, debe capturarse, para asegurarnos de que la copia se realiza con los demás alumnos y asignaturas. 
-- Para ello se debe crear una tabla ERRORES donde aparezca el expediente del alumno, el código de la asignatura y el error
-- que se ha producido.
CREATE TABLE ERRORES (Expediente VARCHAR2(20), CodigoAsignatura VARCHAR2(20), ErrorC VARCHAR2(50));

-- (3.2) Si la copia en el HISTORICO tuvo éxito para todos los alumnos de una asignatura, se deben borrar de la información 
-- de las tablas correspondientes.
-- NOTA: Para probarlo se puede disparar el JOB cada minuto y luego cambiar su frecuencia.


-- AUDITORIA

-- Es muy importante controlar quién modifica las notas finales de las asignaturas. Establecer los mecanismos para poder obtener 
-- el usuario y la IP de cada modificación que se haga de las notas. 
-- Esto se puede hacer mediante la auditoría de Oracle o mediante Triggers.




