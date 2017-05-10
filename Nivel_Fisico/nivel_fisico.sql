-- CAMPUS VIRTUAL. NIVEL FISICO. 
-- Grupo MATRIX: 
--  María , 
--  Nadia Carrera Chahir, 
--  Joaquín, 
--  Rime Raissouni.

--1. Crear un espacio de tablas denominado TS_CAMPUS
create tablespace TS_CAMPUS datafile 'tscampus.dbf' size 10M autoextend on;

--2. Crear un usuario denominado CAMPUS con el esquema correspondiente. Darle cuota en TS_CAMPUS y permiso para conectarse, crear tablas, crear vistas, crear procedimientos. Asignarle TS_CAMPUS como TABLESPACE por defecto.
create user CAMPUS identified by campus default tablespace TS_CAMPUS quota 100M on TS_CAMPUS;
--hacemos connect con admin option para poder crear usuarios dentro de CAMPUS
grant connect with admin option, create table, create view, create procedure to CAMPUS;

--3. Conectarse como CAMPUS y ejecutar el script para crear las tablas.
-- Ver script modelo_relacional.sql y ejecutarlo

--4. Crear Roles R_PROFESOR, R_ALUMNO, R_ADMINISTRATIVO
create role R_PROFESOR;
create role R_ALUMNO;
create role R_ADMINISTRATIVO;

--5. Dar permisos al R_ADMINISTRATIVO para:
--5.1. Seleccionar, insertar, modificar o borrar en la tabla de usuarios
grant connect to R_ADMINISTRATIVO;
grant select, insert, alter, delete on USUARIOS to R_ADMINISTRATIVO;
--5.2. Seleccionar, insertar, modificar o borrar de la tabla de asignaturas
grant select, insert, alter, delete on ASIGNATURAS to R_ADMINISTRATIVO;
--5.3. Matricular a un alumno en una asignatura. Borrar o modificar la matrícula.
grant select, insert, alter, delete on Rol_Us_As to R_ADMINISTRATIVO;
--5.4. Leer la calificación final de los alumnos. Realmente se debe poder leer la nota, la calificación, el nombre de la asignatura, el curso y todos los datos del alumno, por lo que habrá que crear una vista.

-- Creamos la vista
create view V_CALIFICACIONES as
select asig.NOMBRE as ASIG_NOMBRE, asig.curso, us.nombre as ALU_NOMBRE, us.apellidos as ALU_APELLIDOS, us.dni, us.pais, us. correo, nf.CALIFICACION, nf.NOTA
from NOTAS_FINALES nf
join USUARIOS us on nf.USUARIOS_ID = us.id
join ASIGNATURAS asig on nf.ASIGNATURAS_ID = asig.id
join ROL_US_AS r on r.USUARIOS_ID = us.id and r.ASIGNATURAS_ID = asig.id
join ROLES on rol = r.ROLES_ROL
where  nombre = 'estudiante';
-- Damos los permisos
grant select on V_CALIFICACIONES to R_ADMINISTRATIVO;

--6. Dar permisos al R_PROFESOR para:
--6.1. Crear todo tipo de actividades (leer, insertar, modificar o borrar)
grant connect to R_PROFESOR;
grant select, insert, alter, delete on ACTIVIDADES to R_PROFESOR;
--6.2. Crear Preguntas (leer, insertar, modificar o borrar)
grant select, insert, alter, delete on PREGUNTAS to R_PROFESOR;
--6.3. Asignar Usuarios a grupos
grant select, insert, alter, delete on US_GRUPS to R_PROFESOR;
--6.4. Poner nota y calificación final a un alumno en una asignatura
grant select, insert, alter, delete on NOTAS_FINALES to R_PROFESOR;
--6.5. Modificar el esquema para que el profesor pueda poner nota a una respuesta de un alumno a una pregunta. Dar los permisos necesarios
-- Damos los permisos--
grant select, insert, alter, delete on RESPUESTAS to R_PROFESOR;

--7. Dar permisos a R_ALUMNO para:
--7.1 Conectarse. Hay que modificar el esquema para que cada usuario tenga un USUARIO de Oracle con el que se conecte. Crear un procedimiento almacenado que a cada usuario de la tabla USUARIOS le asigne un usuario de Oracle y una palabra de paso. El procedimiento también asignará los permisos necesarios al usuario.
-- Conectado desde CAMPUS
grant connect to R_ALUMNO;
-- Creamos el procedimiento
create or replace procedure PR_ASIGNA_USUARIO(USUARIO IN VARCHAR2) AS
BEGIN
  EXECUTE IMMEDIATE 'create user '|| USUARIO || ' identified by '|| USUARIO ||' default tablespace TS_CAMPUS quota 10M on TS_CAMPUS';
  EXECUTE IMMEDIATE ‘grant R_ALUMNO TO ’||USUARIO;
END PR_ASIGNA_USUARIO;
--- Modificamos el script de tablas creando la tabla ORACLE. ORACLE es la tabla de usuarios ORACLE. ---
create table ORACLE (id number not null primary key, miuser varchar2(30) not null, pass varchar2(30) not null) ;
alter table ORACLE add USUARIOS_id Number;
ALTER TABLE ORACLE ADD CONSTRAINT ORACLE_USUARIOS_FK FOREIGN KEY ( USUARIOS_id ) REFERENCES USUARIOS ( id ) ;

--7.2 Crear los mecanismos necesarios (evalúe las diferentes posibilidades) para que cada alumno sólo pueda ver sus propios datos.
create or replace view V_DATOS_USUARIO AS
select us.dni, us.nombre, us.apellidos, us.correo, us.pais from USUARIOS us
join ORACLE ora on ora.USUARIOS_id = us.id
where USER = ora.miuser;
-- damos permiso de ver esos datos
grant select on V_DATOS_USUARIO to R_ALUMNO;

--7.3 Dar permiso para Insertar en la vista V_RESULTADO (hay que crearla). Es la vista en la que el alumno guarda la respuesta a una pregunta. Deberá contener datos del alumno, la pregunta y la respuesta. Obviamente un alumno no puede contestar por otro, por lo que habrá que validar el usuario.
create or replace view V_RESULTADO as
select us.nombre as ALU_NOMBRE, us.apellidos as ALU_APELLIDOS, us.dni, us.pais, us.correo, asig.nombre as ASIG_NOMBRE, act.nombre as ACT_NOMBRE, pre.pregunta, res.respuesta
from USUARIOS us 
join ROL_US_AS r on r.USUARIOS_ID = us.id 
join ASIGNATURAS asig on r.ASIGNATURAS_ID = asig.id
join ROLES on roles.rol = r.ROLES_ROL
join ACTIVIDADES act on act.asignaturas_id = asig.id
join PREGUNTAS pre on pre.cuestionarios_id = act.id
left outer join RESPUESTAS res on res.Preguntas_id = pre.id and res.USUARIOS_ID = us.id
join ORACLE ora on ora.USUARIOS_id = us.id
where USER = ora.miuser and roles.nombre='estudiante';
-- damos permisos
grant select on V_RESULTADO to R_ALUMNO;


--8. Crear una tabla CONEXIONES con los campos SESIONID, USUARIO, IP, MAQUINA, INICIO, FIN. Crear un trigger de manera que cada vez que un usuario de la base de datos se conecte se almacene en la tabla CONEXIONES su número de sesión, usuario, ip desde donde se conecta, máquina y fecha del sistema. Utilizar la funicón SYS_CONTEXT:
-- Conectado desde CAMPUS
create table CONEXIONES(
    sesionid     NUMBER NOT NULL PRIMARY KEY,
    usuario      VARCHAR2(50) NOT NULL ,
    ip           VARCHAR2(20),
    maquina      VARCHAR2(20),
    inicio       DATE,
    fin          DATE
  ) ;

-- Conectado desde desde SYS as SYSDBA
CREATE OR REPLACE TRIGGER TR_CONEXIONES
AFTER LOGON ON DATABASE 
BEGIN
  INSERT INTO CAMPUS.CONEXIONES (SESIONID, USUARIO, IP, MAQUINA, INICIO)  
  SELECT SYS_CONTEXT('USERENV','SESSIONID'), SYS_CONTEXT('USERENV','SESSION_USER'), SYS_CONTEXT('USERENV','IP_ADDRESS'), SYS_CONTEXT('USERENV','HOST'), SYSDATE FROM DUAL;
END;

--9. Crear al menos un usuario de cada role y probar que todo funciona según lo diseñado
-- Conectado desde SYSTEM
grant create, drop, update user to CAMPUS;
-- desde CAMPUS
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

--- SENTENCIAS PARA TESTING


