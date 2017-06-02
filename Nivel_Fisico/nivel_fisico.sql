-- CAMPUS VIRTUAL. NIVEL FISICO. 
-- Grupo MATRIX: 
--  Nadia Carrera Chahir,  
--  María Castro Martínez, 
--  Rime Raissouni,
--  Joaquín Terrasa Moya.

-- *** EJECUTAR LAS SENTENCIAS SIN COMENTARIOS. EN ALGUNAS MÁQUINAS CAUSA ERROR DE COMPILACIÓN. ***

-- *** SI NO SE INDICA LO CONTRARIO, EJECUTAR TODAS LAS SENTENCIAS DESDE EL USUARIO CAMPUS ***

--1. Crear un espacio de tablas denominado TS_CAMPUS
-- Conectado como SYSTEM
create tablespace TS_CAMPUS datafile 'tscampus.dbf' size 10M autoextend on;

--2. Crear un usuario denominado CAMPUS con el esquema correspondiente. Darle cuota en TS_CAMPUS y permiso para conectarse, 
-- crear tablas, crear vistas, crear procedimientos. Asignarle TS_CAMPUS como TABLESPACE por defecto.

-- Conectado como SYSTEM:
create user CAMPUS identified by campus default tablespace TS_CAMPUS quota 100M on TS_CAMPUS;
--Hacemos connect con admin option para poder crear usuarios dentro de CAMPUS (se necesita más adelante)
grant connect to CAMPUS with admin option;
grant create table, create view, create procedure to CAMPUS;
-- Tambien le damos permiso para crear y borrar usuarios (se necesita más adelante).
grant create user to CAMPUS;
grant alter user to CAMPUS;
grant update user to CAMPUS;
grant drop user to CAMPUS;

--3. Conectarse como CAMPUS y ejecutar el script para crear las tablas.

-- Conectado como CAMPUS:
-- Ejecutar script modelo_relacional.sql 

--4. Crear Roles R_PROFESOR, R_ALUMNO, R_ADMINISTRATIVO
create role R_PROFESOR;
create role R_ALUMNO;
create role R_ADMINISTRATIVO;

--5. Dar permisos al R_ADMINISTRATIVO para:
--5.1. Seleccionar, insertar, modificar o borrar en la tabla de usuarios
grant connect to R_ADMINISTRATIVO with admin option;
grant select, insert, alter, delete on USUARIOS to R_ADMINISTRATIVO;

--5.2. Seleccionar, insertar, modificar o borrar de la tabla de asignaturas
grant select, insert, alter, delete on ASIGNATURAS to R_ADMINISTRATIVO;

--5.3. Matricular a un alumno en una asignatura. Borrar o modificar la matrícula.
grant select, insert, alter, delete on Rol_Us_As to R_ADMINISTRATIVO;

--5.4. Leer la calificación final de los alumnos. Realmente se debe poder leer la nota, la calificación, 
-- el nombre de la asignatura, el curso y todos los datos del alumno, por lo que habrá que crear una vista.

-- Creamos la vista
create view V_CALIFICACIONES as
select asig.NOMBRE as ASIG_NOMBRE, asig.curso, us.nombre as ALU_NOMBRE, us.apellidos as ALU_APELLIDOS, 
us.dni, us.pais, us. correo, nf.CALIFICACION, nf.NOTA
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
grant select, insert, alter, delete on CUESTIONARIOS to R_PROFESOR;
grant select, insert, alter, delete on FOROS to R_PROFESOR;
grant select, insert, alter, delete on TAREAS to R_PROFESOR;
grant select, insert, alter, delete on DIARIO to R_PROFESOR;

--6.2. Crear Preguntas (leer, insertar, modificar o borrar)
grant select, insert, alter, delete on PREGUNTAS to R_PROFESOR;

--6.3. Asignar Usuarios a grupos
grant select, insert, alter, delete on US_GRUPS to R_PROFESOR;

--6.4. Poner nota y calificación final a un alumno en una asignatura
grant select, insert, alter, delete on NOTAS_FINALES to R_PROFESOR;

--6.5. Modificar el esquema para que el profesor pueda poner nota a una respuesta de un alumno a una pregunta. 
-- Dar los permisos necesarios
-- En nuestro caso no hace falta modificar el esquema pues el profesor modificará directamente la tabla RESPUESTAS.
grant select, insert, alter, delete on RESPUESTAS to R_PROFESOR;

--7. Dar permisos a R_ALUMNO para:
--7.1 Conectarse. Hay que modificar el esquema para que cada usuario tenga un USUARIO de Oracle con el que se conecte. 
-- Crear un procedimiento almacenado que a cada usuario de la tabla USUARIOS le asigne un usuario de Oracle y una palabra de paso. 
-- El procedimiento también asignará los permisos necesarios al usuario.
grant connect to R_ALUMNO;

--- Creamos la tabla ORACLE que representa los usuarios de ORACLE. (Ya incluida en el script modelo_relacional.sql)
CREATE TABLE ORACLE
  (
    id          NUMBER NOT NULL ,
    miuser      VARCHAR2 (30) NOT NULL ,
    pass        VARCHAR2 (30) NOT NULL ,
    USUARIOS_id NUMBER NOT NULL
  ) ;
CREATE UNIQUE INDEX ORACLE__IDX ON ORACLE ( USUARIOS_id ASC ) ;
ALTER TABLE ORACLE ADD CONSTRAINT ORACLE_PK PRIMARY KEY ( id ) ;

-- Creamos el procedimiento
create or replace procedure PR_ASIGNA_USUARIO(US_ID IN NUMBER, US_ORACLE IN VARCHAR2, US_ROL IN VARCHAR2) AS
-- Almacenamos el rol del usuario para darle los permisos correspondientes más tarde.
  ROL VARCHAR2(2);
BEGIN
  -- Si el usuario US_ID ya tiene asignado un usuario ORACLE, se lanza un error porque sólo puede haber un usuario Oracle 
  -- por usuario de CV.
-- Si el parámetro US_ROL no se especifica, se busca en los datos de la tabla USUARIOS.
  IF US_ROL != '' THEN ROL := US_ROL;
  ELSE  
  -- Por ahora suponemos que un usuario solo puede tener uno de los tres posibles roles.
    SELECT DISTINCT ROL_US_AS.ROLES_ROL INTO ROL FROM ROL_US_AS WHERE USUARIOS_ID = US_ID;
  END IF;
  -- Creamos su correspondiente usuario oracle y lo relacionamos con la tabla USUARIOS
  INSERT INTO ORACLE VALUES (US_ID||''||to_char(trunc(DBMS_RANDOM.value(10,999))), US_ORACLE, US_ORACLE, US_ID);
  EXECUTE IMMEDIATE 'create user '|| US_ORACLE || ' identified by '|| US_ORACLE 
  ||' default tablespace TS_CAMPUS quota 10M on TS_CAMPUS';
  -- Damos los permisos correspondientes
  IF ROL = '0' THEN --estudiante
    EXECUTE IMMEDIATE 'grant R_ALUMNO TO '||US_ORACLE;
  ELSIF ROL = '1' THEN --profesor
    EXECUTE IMMEDIATE 'grant R_PROFESOR TO '||US_ORACLE;
  ELSIF ROL = '2' THEN --administrativo
    EXECUTE IMMEDIATE 'grant R_ADMINISTRATIVO TO '||US_ORACLE;
  END IF; 

EXCEPTION
  WHEN OTHERS THEN 
    DBMS_OUTPUT.PUT_LINE(SQLCODE||' error: '||SQLERRM);

END PR_ASIGNA_USUARIO;

--7.2 Crear los mecanismos necesarios (evalúe las diferentes posibilidades) para que cada alumno sólo pueda ver sus propios datos.
create or replace view V_DATOS_USUARIO AS
select distinct us.dni, us.nombre, us.apellidos, us.correo, us.pais from USUARIOS us
join ORACLE ora on ora.USUARIOS_id = us.id
join ROL_US_AS r on r.USUARIOS_ID = us.id 
join ROLES on roles.rol = r.ROLES_ROL
where USER = ora.miuser and roles.nombre='estudiante';

-- damos permiso de ver esos datos
grant select on V_DATOS_USUARIO to R_ALUMNO;

--7.3 Dar permiso para Insertar en la vista V_RESULTADO (hay que crearla). Es la vista en la que el alumno guarda la respuesta 
-- a una pregunta. Deberá contener datos del alumno, la pregunta y la respuesta. Obviamente un alumno no puede contestar por otro, 
-- por lo que habrá que validar el usuario.
create or replace view V_RESULTADO as
select us.nombre as ALU_NOMBRE, us.apellidos as ALU_APELLIDOS, us.dni, us.pais, us.correo, asig.nombre as ASIG_NOMBRE,
act.id as ACT_ID, act.nombre as ACT_NOMBRE, pre.id as PREG_ID, pre.pregunta, res.respuesta
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
grant select, update on V_RESULTADO to R_ALUMNO;

-- Obviamente siendo V_RESULTADO una vista de varias tablas no se puede hacer un insert o update de forma directa en ella.
-- Entonces creamos un disparador instead of:
CREATE OR REPLACE TRIGGER TR_INSERTAR_EN_V_RESULTADO
INSTEAD OF UPDATE ON V_RESULTADO
FOR EACH ROW
DECLARE
  alumno_id number;
BEGIN
  SELECT id INTO alumno_id FROM USUARIOS WHERE dni = :old.dni;
  -- si se modifica una respuesta ya existente
  BEGIN
      UPDATE RESPUESTAS SET respuesta = :new.respuesta WHERE preguntas_id = :old.preg_id AND usuarios_id = alumno_id ;  
  EXCEPTION
    WHEN NO_DATA_FOUND THEN
  -- si se añade por primera vez una respuesta a una pregunta
      INSERT INTO RESPUESTAS (id, respuesta, preguntas_id, usuarios_id) 
      VALUES (concat(:old.preg_id,trunc(dbms_random.value(10,10000))), :new.respuesta, :old.preg_id, alumno_id);
  END;
END TR_INSERTAR_EN_V_RESULTADO;



--8. Crear una tabla CONEXIONES con los campos SESIONID, USUARIO, IP, MAQUINA, INICIO, FIN. Crear un trigger de manera 
-- que cada vez que un usuario de la base de datos se conecte se almacene en la tabla CONEXIONES su número de sesión, usuario, 
-- ip desde donde se conecta, máquina y fecha del sistema. Utilizar la funicón SYS_CONTEXT:

create table CONEXIONES( -- (Ya incluida en el script modelo_relacional.sql)
    sesionid     NUMBER NOT NULL PRIMARY KEY,
    usuario      VARCHAR2(50) NOT NULL ,
    ip           VARCHAR2(20),
    maquina      VARCHAR2(20),
    inicio       DATE,
    fin          DATE
  ) ;

-- Conectado desde SYS as SYSDBA:
CREATE OR REPLACE TRIGGER TR_CONEXIONES
AFTER LOGON ON DATABASE 
BEGIN
  INSERT INTO CAMPUS.CONEXIONES (SESIONID, USUARIO, IP, MAQUINA, INICIO)  
  SELECT SYS_CONTEXT('USERENV','SESSIONID'), SYS_CONTEXT('USERENV','SESSION_USER'), SYS_CONTEXT('USERENV','IP_ADDRESS'), 
  SYS_CONTEXT('USERENV','HOST'), SYSDATE FROM DUAL;
END;

--9. Crear al menos un usuario de cada rol y probar que todo funciona según lo diseñado
-- Conectado como CAMPUS:
-- *** EJECUTAR EL APARTADO DE INTRODUCCION DE DATOS DEL SCRIPT modelo_relacional.sql SI NO LO HA HECHO TODAVÍA. ***

-- Ya tenemos introducidos los siguientes usuarios del CV en la tabla USUARIOS:
EXECUTE PR_ASIGNA_USUARIO(90,'DAVID','2'); -- admnistrativo
EXECUTE PR_ASIGNA_USUARIO(37,'ALICIA','0'); -- alumna
EXECUTE PR_ASIGNA_USUARIO(12,'ALBERTO',''); -- alumno
EXECUTE PR_ASIGNA_USUARIO(89,'RAM',''); -- profesor

-- Ahora comprobamos que se han creado los usuarios ORACLE:
select * from ALL_USERS;
-- Podemos ver también que se han asignado a sus correspondientes usuarios del CV:
select * from ORACLE;

-- Comprobamos que no podemos asignar un segundo usuario Oracle a un usuario del CV :
EXECUTE PR_ASIGNA_USUARIO(12,'ALBERTO2','');

-- Ahora creamos una nueva conexión para un nuevo usuario p.e. RAM y nos conectamos de ese usuario :
-- ¡¡ CUIDADO LOS NOMBRES DE USUARIOS Y LAS CONTRASEÑAS ESTÁN EN MAYÚSCULAS !!   
--    CONTRASEÑA ES IGUAL QUE EL NOMBRE DE USUARIO (p.e. user = RAM, pass = RAM)

-- Nos conectamos como usuario RAM (es profesor) para comprobar que se conecta bien 
-- Comprobamos que puede crear actividades y preguntas..:
INSERT INTO CAMPUS.ACTIVIDADES(id,asignaturas_id,nombre) VALUES (1, 421, 'ACTIV1');
INSERT INTO CAMPUS.ACTIVIDADES(id,asignaturas_id,nombre) VALUES (2, 413, 'ACTIV1');
INSERT INTO CAMPUS.CUESTIONARIOS VALUES (1, sysdate, sysdate+3);
INSERT INTO CAMPUS.PREGUNTAS VALUES (1, 'PREGUNTA 1: blabla', 1);
INSERT INTO CAMPUS.PREGUNTAS VALUES (2, 'PREGUNTA 2: bla..', 1);
COMMIT; -- confirmamos los cambios para que sean visibles al resto de usuarios también

-- Nos conectamos como usuario ALICIA (es alumna) 
-- Comprobamos que sólo se puede ver sus propios datos 
select * from CAMPUS.V_DATOS_USUARIO;
select * from CAMPUS.V_RESULTADO;

-- Intentamos insertar una respuesta desde el usuario ALICIA:
 update CAMPUS.V_RESULTADO set RESPUESTA = 'respuesta Alicia' where ACT_ID = 1 and PREG_ID = 1;

-- Nos conectamos como usuario DAVID (es administrativo)
-- Comprobamos que puede crear, modificar ..etc usuarios, asignaturas y matriculas:
INSERT INTO CAMPUS.USUARIOS VALUES (02, 'C855510', 'Marta','Salva Gómez','martagz@gmail.com','españa',''); 
INSERT INTO CAMPUS.ASIGNATURAS VALUES (300, '2015/16', 'Legislaciones','A','1');
INSERT INTO CAMPUS.ROL_US_AS VALUES ('1', 300, 02);
COMMIT; -- confirmamos los cambios para que sean visibles al resto de usuarios también

-- Comprobamos que puede consultar las calificaciones de los alumnos:
select * from CAMPUS.V_CALIFICACIONES;

-- *** EXTRA SENTENCIAS ***
grant create index to campus; -- desde system

-- INDEXES
create index asig_idx on asignaturas(nombre,curso,grupoturno);
create index usuario_idx on usuarios (nombre, apellidos) compute statistics;
create index msj_idx on mensajes (usuarios_id,usuarios_id1);
create index msj_idx_1 on mensajes (usuarios_id1,usuarios_id);
create index resp_idx on respuestas(pregunta,respuesta,coreccion);

-- SYNONYMS
grant create synonym to campus; -- desde system

create synonym T_RESPUESTAS for campus.respuestas;
create synonym T_PREGUNTAS for campus.preguntas;
create synonym T_ACTIVIDADES for campus.actividades;
create synonym T_ASIGNATURAS for campus.asignaturas;
create synonym T_USUARIOS for campus.usuarios;
create synonym RESULTADOS for campus.V_RESULTADO;
create synonym PERMISOS for campus.V_DATOS_USUARIO;
create synonym ACTA for campus.V_CALIFICACIONES;

