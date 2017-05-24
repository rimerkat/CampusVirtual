--  Una vez que terminan los exámenes de septiembre se almacenan las notas finales en una tabla histórica, 
--  eliminándose los datos de las pruebas parciales. Para ello se debe crear una tabla llamada HISTORICO con 
--  el nombre y apellidos del usuario, su dni, expediente, usuario de oracle, código de asignatura, nombre de 
--  asignatura, curso académico, nota y calificación final. 
--  Realizar un JOB que se ejecute todos los años el día 15 de octubre y que almacene todos los datos en la tabla 
--  HISTORICO. Si se produjera algún error, debe capturarse, para asegurarnos de que la copia se realiza con los 
--  demás alumnos y asignaturas. Para ello se debe crear una tabla ERRORES donde aparezca el expediente del alumno,
--  el código de la asignatura y el error que se ha producido.
--  Si la copia en el HISTORICO tuvo éxito para todos los alumnos de una asignatura, se deben borrar de la información
--  de las tablas correspondientes. (subir NOTA)
--  NOTA: Para probarlo se puede disparar el JOB cada minuto y luego cambiar su frecuencia.

create table HISTORICO(Nombre VARCHAR2(20), Apellidos VARCHAR2(40), Dni VARCHAR2(10), Expediente VARCHAR2(20), CodigoAsignatura VARCHAR(20),
      NombreAsignatura VARCHAR2(30), Curso VARCHAR2(10), Nota NUMBER, Calificacion VARCHAR2(10));
  
create table ERRORES(Expediente VARCHAR2(20), CodigoAsignatura VARCHAR2(20), ErrorC VARCHAR2(50));

-- Alterar tabla NOTAS_FINALES para poder poner la fecha de la convocatoria
alter table NOTAS_FINALES add Fecha DATE;

BEGIN
    DBMS_SCHEDULER.CREATE_JOB (
      job_name => 'septiembre_job',
      job_type => 'PLSQL_BLOCK', -- stored_procedure
      repeat_interval => 'FREQ=YEARLY; BYMONTH=OCT; BYMONTHDAY=15', --cada 15 octubre, cada año
      --job_action => 'BEGIN delete from (select * from MENSAJES_BORRADOS); END;', --procedimiento
      start_date => SYSDATE,
      end_date => '30/MAY/2015 20.00.00',       -- ¿hasta cuándo?
      enabled => TRUE,
      comments => 'Job MATRIX');
END;

-- 1. Realizar un JOB que almacene todos los datos en la tabla HISTORICO.
-- Crear un procedimiento con ASIGNATURA, ALUMNO, NOTAS_FINALES, ROL_US_AS (join)



-- 2. Si se produjera algún error, debe capturarse, para asegurarnos de que la copia se realiza con los 
--  demás alumnos y asignaturas. Para ello se debe crear una tabla ERRORES donde aparezca el expediente del alumno,
--  el código de la asignatura y el error que se ha producido.
