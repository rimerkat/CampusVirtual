-- JOBS

-- (1)
-- Una vez que terminan los exámenes de septiembre se almacenan las notas finales en una tabla histórica, eliminándose los datos 
-- de las pruebas parciales. 
-- Para ello se debe crear una tabla llamada HISTORICO con el nombre y apellidos del usuario, su dni, expediente, usuario de oracle, 
-- código de asignatura, nombre de asignatura, curso académico, nota y calificación final. 

-- (1.1) Debemos añadir el atributo fecha en la tabla NOTAS_FINALES para poder poner la fecha de la convocatoria:
alter table NOTAS_FINALES add Fecha DATE NOT NULL;
-- (1.2) Y añadir el atributo expediente del alumno para el apartado 2.1:
alter table USUARIOS add expediente varchar2(20);

-- (1.3) Creamos la tabla HISTORICO como indicado:
CREATE TABLE HISTORICO (
	dni VARCHAR2(10) NOT NULL PRIMARY KEY,
	nombre VARCHAR2(20) NOT NULL, apellidos VARCHAR2(40) NOT NULL, 
	expediente VARCHAR2(20) NOT NULL, usuarioOracle varchar2(20), 
	codigoAsignatura VARCHAR(20) NOT NULL, nombreAsignatura VARCHAR2(30) NOT NULL, 
	curso VARCHAR2(10) NOT NULL, nota NUMBER NOT NULL, calificacion VARCHAR2(10) NOT NULL  );
  
-- (2)
-- Realizar un JOB que se ejecute todos los años el día 15 de octubre y que almacene todos los datos en la tabla HISTORICO.

-- (3)
-- (3.1) Si se produjera algún error, debe capturarse, para asegurarnos de que la copia se realiza con los demás alumnos y asignaturas. 
-- Para ello se debe crear una tabla ERRORES donde aparezca el expediente del alumno, el código de la asignatura y el error
-- que se ha producido.
CREATE TABLE ERRORES (expediente VARCHAR2(20), codigoAsignatura VARCHAR2(20), errorC VARCHAR2(50));

-- (3.2) Si la copia en el HISTORICO tuvo éxito para todos los alumnos de una asignatura, se deben borrar de la información 
-- de las tablas correspondientes.
-- NOTA: Para probarlo se puede disparar el JOB cada minuto y luego cambiar su frecuencia.

--- (2.1) creamos el procedimiento que almacena los datos en la tabla HISTORICO:
CREATE OR REPLACE PROCEDURE PR_UPLOAD_JOB AS 

	Expediente varchar2(20) default "";
	CodigoAsignatura varchar2(20) default "";
	CURSOR C_ASIGNATURAS IS
	SELECT asi.id asigID, asi.nombre asig, asi.curso, us.nombre usNombre, us.apellidos usApellidos, us.dni, nf.nota,
	nf.calificacion, us.expediente, orc.miuser usuarioOracle
	FROM ASIGNATURAS asi
	JOIN NOTAS_FINALES nf on nf.asignaturas_id = asi.id 
	JOIN USUARIOS us on nf.usuarios_id = us.id
	JOIN ORACLE orc on orc.usuarios_id = us.id
	WHERE extract(month from nf.fecha) = '9'
	ORDER BY asi.id;
BEGIN
        -- Introducimos los datos correspondientes las notas finales de todos los alumnos para todas las asignaturas
	FOR VAR_ALUMNO IN C_ASIGNATURAS LOOP
		Expediente := VAR_ALUMNO.expediente;
		CodigoAsignatura := asigID;
  		INSERT INTO HISTORICO VALUES(VAR_ALUMNO.usNombre, VAR_ALUMNO.usApellidos, VAR_ALUMNO.dni, VAR_ALUMNO.expediente, 
					     VAR_ALUMNO.usuarioOracle, VAR_ALUMNO.asigID, VAR_ALUMNO.asig, 
					     VAR_ALUMNO.curso, VAR_ALUMNO.nota, VAR_ALUMNO.calificacion);
	END LOOP;

-- (3.1) Si se produjera algún error, debe capturarse, para asegurarnos de que la copia se realiza con los demás alumnos y asignaturas. 
EXCEPTION 
  WHEN OTHERS THEN -- captura todo tipo de error
      INSERT INTO errores VALUES (Expediente, CodigoAsignatura, 'Error number ' || SQLCODE || ' : ' || SQLERRM);
      
END PR_UPLOAD_JOB;

-- (2.2) Creamos el job:
BEGIN
    DBMS_SCHEDULER.CREATE_JOB (
      job_name => 'septiembre_job',
      job_type => 'STORED_PROCEDURE', -- usaremos el procedimiento anteriormente creado
      repeat_interval => 'FREQ=YEARLY; BYMONTH=OCT; BYMONTHDAY=15', --cada 15 octubre, de cada año
      job_action => 'PR_UPLOAD_JOB',
      -- start_date => SYSDATE, -- no es necesario, se ejecuta cuando 'repeat_interval'
      enabled => TRUE,
      comments => 'Se ejecuta todos los años el día 15 de octubre y almacena todos los datos en la tabla HISTORICO');
    -- DBMS_SCHEDULER.SET_ATTRIBUTE ('septiembre_job', 'max_runs', 100); -- ejecuta el JOB hasta 100 veces
END;




-- AUDITORIA

-- Es muy importante controlar quién modifica las notas finales de las asignaturas. Establecer los mecanismos para poder obtener 
-- el usuario y la IP de cada modificación que se haga de las notas. 
-- Esto se puede hacer mediante la auditoría de Oracle o mediante Triggers.





------ testing
  update notas_finales set fecha='20/09/16';


