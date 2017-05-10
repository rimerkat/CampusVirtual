-- Las sentencias ejecutadas por CAMPUS

-- Ejecutar modelo_relacional.sql desde CAMPUS
-- Introducir los siguientes datos

INSERT INTO USUARIOS VALUES (12, ‘U454655’, 'Alberto','Jimenez Alvarez','ajalvarez@gmail.com','españa',''); 
INSERT INTO USUARIOS VALUES (21, 'H789565', 'Juan','Fraud Mango','jfmango@gmail.com','españa',''); 
INSERT INTO USUARIOS VALUES (89, 'Y896453E', 'Ram','Faharadi Kariji','ramfk@gmail.com',’india’,''); 
INSERT INTO USUARIOS VALUES (37, 'A852696', 'Alicia','Llaves Negras','allavesn@gmail.com','españa',''); 
INSERT INTO CENTROS VALUES (01, 'www.uma.es/etsi-informatica/', 'ETSII');
INSERT INTO TITULACIONES VALUES (1, 'Ingenieria Informatica', '',01);
INSERT INTO ASIGNATURAS VALUES (411, '2015/16', 'Base de datos','A','1'); 
INSERT INTO ASIGNATURAS VALUES (412, '2015/16', 'Sistemas de Internet','A','1');
INSERT INTO ASIGNATURAS VALUES (413, '2015/16', 'Procesadores de Lenguaje','A','1');
INSERT INTO ASIGNATURAS VALUES (421, '2015/16', 'Logica Computacional','A','1');
INSERT INTO ROLES VALUES ('0', 'estudiante');
INSERT INTO ROLES VALUES ('1', 'profesor');
INSERT INTO NOTAS_FINALES VALUES ('Aprobado', 6, 411, 12);
INSERT INTO NOTAS_FINALES VALUES ('Notable', 8, 412, 12);
INSERT INTO NOTAS_FINALES VALUES ('Notable', 7, 421, 12);
INSERT INTO NOTAS_FINALES VALUES ('Sobresaliente', 9, 411, 37);
INSERT INTO NOTAS_FINALES VALUES ('Matricula', 10, 421, 37);
INSERT INTO NOTAS_FINALES VALUES ('Notable', 8, 413, 37);
INSERT INTO ROL_US_AS VALUES ('0', 421, 37);
INSERT INTO ROL_US_AS VALUES ('0', 413, 37);
INSERT INTO ROL_US_AS VALUES ('0', 411, 37);
INSERT INTO ROL_US_AS VALUES ('0', 411, 12);
INSERT INTO ROL_US_AS VALUES ('0', 412, 12);
INSERT INTO ROL_US_AS VALUES ('0', 421, 12);
INSERT INTO ROL_US_AS VALUES ('1', 413, 89);
INSERT INTO ROL_US_AS VALUES ('1', 421, 89);
INSERT INTO ROL_US_AS VALUES ('1', 411, 21);
INSERT INTO ROL_US_AS VALUES ('1', 412, 21);

-- Las sentencias de la tarea

create role R_PROFESOR;

create role R_ALUMNO;

create role R_ADMINISTRATIVO;

grant connect to R_ADMINISTRATIVO;

grant select, insert, alter, delete on USUARIOS to R_ADMINISTRATIVO;

grant select, insert, alter, delete on ASIGNATURAS to R_ADMINISTRATIVO;

grant select, insert, alter, delete on Rol_Us_As to R_ADMINISTRATIVO;

create view V_CALIFICACIONES as
select asig.NOMBRE as ASIG_NOMBRE, asig.curso, us.nombre as ALU_NOMBRE, us.apellidos as ALU_APELLIDOS, us.dni, us.pais, us. correo, nf.CALIFICACION, nf.NOTA
from NOTAS_FINALES nf
join USUARIOS us on nf.USUARIOS_ID = us.id
join ASIGNATURAS asig on nf.ASIGNATURAS_ID = asig.id
join ROL_US_AS r on r.USUARIOS_ID = us.id and r.ASIGNATURAS_ID = asig.id
join ROLES on rol = r.ROLES_ROL
where  nombre = 'estudiante';

grant select on V_CALIFICACIONES to R_ADMINISTRATIVO;

grant select, insert, alter, delete on PREGUNTAS to R_PROFESOR;

grant select, insert, alter, delete on ACTIVIDADES to R_PROFESOR;

grant select, insert, alter, delete on NOTAS_FINALES to R_PROFESOR;

grant select, insert, alter, delete on US_GRUPS to R_PROFESOR;

grant select on V_CALIFICACIONES to R_ADMINISTRATIVO;

grant connect to R_PROFESOR;

grant select, insert, alter, delete on PREGUNTAS to R_PROFESOR;

grant select, insert, alter, delete on ACTIVIDADES to R_PROFESOR;

grant select, insert, alter, delete on US_GRUPS to R_PROFESOR;

grant select, insert, alter, delete on NOTAS_FINALES to R_PROFESOR;

grant select, insert, alter, delete on RESPUESTAS to R_PROFESOR;

grant connect to R_ALUMNO;

create or replace procedure PR_ASIGNA_USUARIO(USUARIO IN VARCHAR2) AS
BEGIN
  EXECUTE IMMEDIATE 'create user '|| USUARIO || ' identified by '|| USUARIO ||' default tablespace TS_CAMPUS quota 10M on TS_CAMPUS';
  EXECUTE IMMEDIATE ‘grant R_ALUMNO TO ’||USUARIO;
END PR_ASIGNA_USUARIO;

-- SENTENCIAS PENDIENTES DE 8.2 Y 8.3

create user ALUMNO identified by almatrix
  default tablespace TS_CAMPUS
  quota 10M on TS_CAMPUS;
grant R_ALUMNO to ALUMNO;

create user PROFESOR identified by pmatrix
  default tablespace TS_CAMPUS
  quota 10M on TS_CAMPUS;
grant R_PROFESOR to PROFESOR;

create user ADMINISTRATIVO identified by admatrix
  default tablespace TS_CAMPUS
  quota 10M on TS_CAMPUS;
grant R_ADMINISTRATIVO to ADMINISTRATIVO;
