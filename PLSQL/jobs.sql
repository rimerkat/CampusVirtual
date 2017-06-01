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
	dni VARCHAR2(10) NOT NULL,
	nombre VARCHAR2(20) NOT NULL, apellidos VARCHAR2(40) NOT NULL, 
	expediente VARCHAR2(20) NOT NULL, usuarioOracle varchar2(20), 
	codigoAsignatura VARCHAR(20) NOT NULL, nombreAsignatura VARCHAR2(30) NOT NULL, 
	curso VARCHAR2(10) NOT NULL, nota NUMBER NOT NULL, calificacion VARCHAR2(10),
        CONSTRAINT alumno_asig UNIQUE (dni, nombreAsignatura) );
  
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
set serveroutput on

CREATE OR REPLACE PROCEDURE PR_RELLENAR_HISTORICO AS 
  
	CURSOR C_ASIGNATURAS IS
	SELECT us.id, us.dni dni, us.nombre nombre, us.apellidos apellidos, us.expediente expediente, ORACLE.miuser usuario, 
        asig.id codigo, asig.nombre asignatura, asig.curso curso, nf.nota nota, nf.calificacion calificacion, nf.fecha
	FROM ASIGNATURAS asig
	JOIN NOTAS_FINALES nf on nf.asignaturas_id = asig.id
	JOIN USUARIOS us on us.id = nf.usuarios_id
	JOIN ORACLE on ORACLE.usuarios_id = us.id
        WHERE EXTRACT(month from nf.fecha) = '9'
	ORDER BY asig.id;
  
BEGIN   -- Introducimos los datos correspondientes las notas finales de todos los alumnos para todas las asignaturas
	FOR VAR_ALUMNO IN C_ASIGNATURAS LOOP
-- (3.1) Ejecutamos las tuplas en bloques independientes para poder capturar los errores y no afectar al resto de tuplas
        BEGIN
  		INSERT INTO HISTORICO VALUES(VAR_ALUMNO.dni, VAR_ALUMNO.nombre, VAR_ALUMNO.apellidos, VAR_ALUMNO.expediente, 
					     VAR_ALUMNO.usuario, to_char(VAR_ALUMNO.codigo), VAR_ALUMNO.asignatura, 
					     VAR_ALUMNO.curso, VAR_ALUMNO.nota, VAR_ALUMNO.calificacion);   
 -- (3.2) Si se llega aquí, es porque no se ha producido ningún error y entonces borramos los datos de la tabla correspondiente
 		DELETE FROM NOTAS_FINALES WHERE usuarios_id = VAR_ALUMNO.id AND asignaturas_id = VAR_ALUMNO.codigo;
	EXCEPTION 
      		WHEN OTHERS THEN
--		INSERT INTO errores VALUES(VAR_ALUMNO.expediente, VAR_ALUMNO.codigo, SQLERRM);
          	DBMS_OUTPUT.PUT_LINE('Expediente '||VAR_ALUMNO.expediente||', Asignatura '||VAR_ALUMNO.codigo||' => '|| SQLERRM);
    	END;
    	END LOOP;

END PR_RELLENAR_HISTORICO;

-- (2.2) Creamos el job:
-- Desde SYSTEM damos los permisos necesarios para hacerlo:
grant create job to campus;

BEGIN
    DBMS_SCHEDULER.CREATE_JOB (
      job_name => 'septiembre_job',
      job_type => 'STORED_PROCEDURE', -- usaremos el procedimiento anteriormente creado
      repeat_interval => 'FREQ=YEARLY; BYMONTH=OCT; BYMONTHDAY=15', --cada 15 octubre, de cada año
      job_action => 'PR_RELLENAR_HISTORICO',
      -- start_date => SYSDATE, -- no es necesario, se ejecuta cuando 'repeat_interval'
      enabled => TRUE,
      comments => 'Se ejecuta todos los años el día 15 de octubre y almacena todos los datos en la tabla HISTORICO');
    -- DBMS_SCHEDULER.SET_ATTRIBUTE ('septiembre_job', 'max_runs', 100); -- ejecuta el JOB hasta 100 veces
END;




-- AUDITORIA

--(4)
-- Es muy importante controlar quién modifica las notas finales de las asignaturas. Establecer los mecanismos para poder obtener 
-- el usuario y la IP de cada modificación que se haga de las notas. 
-- Esto se puede hacer mediante la auditoría de Oracle o mediante Triggers.

--(4.1) Para eso, creamos la tabla siguiente

CREATE TABLE CONTROLAR_NOTAS (alumno number, asignatura number, nota_antes number, 
			      nota_despues number, usuario varchar2(20), ip varchar2(50) );

-- (4.2) Se crea desde SYS un disparador para almacenar los datos modificados y del usuario en la tabla anterior :

CREATE OR REPLACE TRIGGER TR_CONTROL_CAMBIOS
BEFORE UPDATE OF nota ON CAMPUS.NOTAS_FINALES FOR EACH ROW
DECLARE
	ip varchar2(50);
	usuario varchar2(20);
BEGIN
	SELECT SYS_CONTEXT('USERENV', 'IP_ADDRESS', 15) INTO ip FROM DUAL;
	SELECT USER INTO usuario FROM DUAL;
	INSERT INTO CAMPUS.CONTROLAR_NOTAS VALUES (:old.usuarios_id, :old.asignaturas_id, :old.nota, :new.nota, usuario, ip);
	
END TR_CONTROL_CAMBIOS;



------ testing
update notas_finales set fecha='20/09/16';
update notas_finales set fecha='18/06/16' where USUARIOS_id = 37 and ASIGNATURAS_id = 421;
update usuarios set expediente = substr(concat(109, ORA_HASH(substr(dni,2,6))),1,12);

EXECUTE PR_RELLENAR_HISTORICO;
select * from historico;
--select * from errores;

update NOTAS_FINALES set nota = 7 where calificacion = 'Notable';
select * from controlar_notas;

