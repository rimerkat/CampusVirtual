-- TRABAJO CAMPUS VIRTUAL.  Grupo MATRIX: 
--  Nadia Carrera Chahir,  
--  María Castro Martínez, 
--  Rime Raissouni,
--  Joaquín Terrasa Moya.

------------------------------------------------------------
------------  PARTE 1 : NIVEL FISICO
------------------------------------------------------------

--1. Crear un espacio de tablas denominado TS_CAMPUS
-- Conectado como SYSTEM
create tablespace TS_CAMPUS datafile 'tscampus.dbf' size 10M autoextend on;

--2. Crear un usuario denominado CAMPUS con el esquema correspondiente. Darle cuota en TS_CAMPUS y permiso para conectarse, 
-- crear tablas, crear vistas, crear procedimientos. Asignarle TS_CAMPUS como TABLESPACE por defecto.

-- Conectado como SYSTEM:
create user CAMPUS identified by campus default tablespace TS_CAMPUS quota 100M on TS_CAMPUS;
--Hacemos connect con admin option para poder crear roles dentro de CAMPUS (se necesita más adelante)
grant connect to CAMPUS with admin option;
grant create table, create view, create procedure to CAMPUS;

-- Tambien le damos permiso para crear y borrar usuarios (se necesita más adelante).
grant create user to CAMPUS;
grant alter user to CAMPUS;
grant update user to CAMPUS;
grant drop user to CAMPUS;

----------------------------------------------------------------------------------------------------------
-- *** SI NO SE INDICA LO CONTRARIO, EJECUTAR TODAS LAS SENTENCIAS POSTERIORES DESDE EL USUARIO CAMPUS ***
----------------------------------------------------------------------------------------------------------

--3. Conectarse como CAMPUS y ejecutar el script para crear las tablas.

-------------------------------------
----- MODELO RELACIONAL DE LA BD ----
-------------------------------------

CREATE TABLE ACTIVIDADES
  (
    id             NUMBER NOT NULL ,
    ASIGNATURAS_id NUMBER NOT NULL ,
    nombre         VARCHAR2 (30) NOT NULL ,
    logo BFILE ,
    posicion_vertical   NUMBER ,
    posicion_horizontal NUMBER
  ) ;
ALTER TABLE ACTIVIDADES ADD CONSTRAINT ACTIVIDADES_PK PRIMARY KEY ( id ) ;


CREATE TABLE ASIGNATURAS
  (
    id              NUMBER NOT NULL ,
    curso           VARCHAR2 (30) NOT NULL ,
    nombre          VARCHAR2 (30) NOT NULL ,
    grupoTurno      VARCHAR2 (30) NOT NULL ,
    TITULACIONES_id NUMBER NOT NULL
  ) ;
ALTER TABLE ASIGNATURAS ADD CONSTRAINT ASIGNATURAS_PK PRIMARY KEY ( id ) ;


CREATE TABLE CENTROS
  (
    id     NUMBER NOT NULL ,
    url    VARCHAR2 (40) NOT NULL ,
    nombre VARCHAR2 (80) NOT NULL
  ) ;
ALTER TABLE CENTROS ADD CONSTRAINT CENTROS_PK PRIMARY KEY ( id ) ;


CREATE TABLE CONTENIDOS
  (
    id     NUMBER NOT NULL ,
    nombre VARCHAR2 (30) NOT NULL ,
    logo BFILE ,
    descripcion         VARCHAR2 (140) ,
    tipo_contenido      VARCHAR2 (30) ,
    posicion_vertical   NUMBER ,
    posicion_horizontal NUMBER ,
    ASIGNATURAS_id      NUMBER NOT NULL
  ) ;
ALTER TABLE CONTENIDOS ADD CONSTRAINT CONTENIDOS_PK PRIMARY KEY ( id ) ;


CREATE TABLE CORREO_INTERNO
  (
    fecha        DATE NOT NULL ,
    asunto       VARCHAR2 (30) ,
    descripcion  VARCHAR2 (100) ,
    USUARIOS_id  NUMBER NOT NULL ,
    USUARIOS_id1 NUMBER NOT NULL
  ) ;
ALTER TABLE CORREO_INTERNO ADD CONSTRAINT CORREO_INTERNO_PK PRIMARY KEY ( fecha, USUARIOS_id, USUARIOS_id1 ) ;


CREATE TABLE CUESTIONARIOS
  (
    id           NUMBER NOT NULL ,
    fecha_inicio DATE ,
    fecha_final  DATE
  ) ;
ALTER TABLE CUESTIONARIOS ADD CONSTRAINT CUESTIONARIOS_PK PRIMARY KEY ( id ) ;


CREATE TABLE DIARIO
  ( id NUMBER NOT NULL , descripción VARCHAR2 (500)
  ) ;
ALTER TABLE DIARIO ADD CONSTRAINT DIARIO_PK PRIMARY KEY ( id ) ;


CREATE TABLE ENTREGA
  (
    id          NUMBER NOT NULL ,
    comentarios VARCHAR2 (100) ,
    fichero BFILE ,
    nota        NUMBER ,
    fecha       DATE NOT NULL ,
    USUARIOS_id NUMBER NOT NULL ,
    TAREAS_id   NUMBER NOT NULL
  ) ;
ALTER TABLE ENTREGA ADD CONSTRAINT ENTREGA_PK PRIMARY KEY ( id ) ;


CREATE TABLE FOROS
  (
    id     NUMBER NOT NULL ,
    titulo VARCHAR2 (20) ,
    debate VARCHAR2 (600) ,
    fecha  DATE
  ) ;
ALTER TABLE FOROS ADD CONSTRAINT FOROS_PK PRIMARY KEY ( id ) ;


CREATE TABLE GRUPOS
  (
    id             NUMBER NOT NULL ,
    nombre         VARCHAR2 (30) NOT NULL ,
    ASIGNATURAS_id NUMBER NOT NULL
  ) ;
ALTER TABLE GRUPOS ADD CONSTRAINT GRUPOS_PK PRIMARY KEY ( id ) ;


CREATE TABLE MENSAJES
  (
    descripcion  VARCHAR2 (100) ,
    fecha        DATE NOT NULL ,
    USUARIOS_id1 NUMBER NOT NULL ,
    USUARIOS_id  NUMBER NOT NULL
  ) ;
ALTER TABLE MENSAJES ADD CONSTRAINT MENSAJES_PK PRIMARY KEY ( fecha, USUARIOS_id1, USUARIOS_id ) ;


CREATE TABLE NOTAS_FINALES
  (
    nota           NUMBER NOT NULL ,
    calificación   VARCHAR2 (30) ,
    ASIGNATURAS_id NUMBER NOT NULL ,
    USUARIOS_id    NUMBER NOT NULL ,
    fecha          DATE NOT NULL
  ) ;
ALTER TABLE NOTAS_FINALES ADD CONSTRAINT NOTAS_FINALES_PK PRIMARY KEY ( ASIGNATURAS_id, USUARIOS_id ) ;


CREATE TABLE ORACLE
  (
    id          NUMBER NOT NULL ,
    miuser      VARCHAR2 (30) NOT NULL ,
    pass        VARCHAR2 (30) NOT NULL ,
    USUARIOS_id NUMBER NOT NULL
  ) ;
CREATE UNIQUE INDEX ORACLE__IDX ON ORACLE
  (
    USUARIOS_id ASC
  )
  ;
ALTER TABLE ORACLE ADD CONSTRAINT ORACLE_PK PRIMARY KEY ( id ) ;


CREATE TABLE Preguntas
  (
    id               NUMBER NOT NULL ,
    pregunta         VARCHAR2 (200) NOT NULL ,
    CUESTIONARIOS_id NUMBER NOT NULL
  ) ;
ALTER TABLE Preguntas ADD CONSTRAINT Preguntas_PK PRIMARY KEY ( id ) ;


CREATE TABLE REGISTROS
  (
    fecha       DATE NOT NULL ,
    tipo        VARCHAR2 (30) ,
    descripcion VARCHAR2 (100) ,
    USUARIOS_id NUMBER NOT NULL
  ) ;
ALTER TABLE REGISTROS ADD CONSTRAINT REGISTROS_PK PRIMARY KEY ( fecha, USUARIOS_id ) ;


CREATE TABLE ROLES
  ( rol VARCHAR2 (2) NOT NULL , nombre VARCHAR2 (30)
  ) ;
ALTER TABLE ROLES ADD CONSTRAINT ROLES_PK PRIMARY KEY ( rol ) ;


CREATE TABLE Respuestas
  (
    id           NUMBER NOT NULL ,
    respuesta    VARCHAR2 (200) ,
    nota         NUMBER ,
    Preguntas_id NUMBER NOT NULL ,
    USUARIOS_id1 NUMBER NOT NULL ,
    USUARIOS_id  NUMBER NOT NULL ,
    correccion   VARCHAR2 (200)
  ) ;
ALTER TABLE Respuestas ADD CONSTRAINT Respuestas_PK PRIMARY KEY ( id ) ;


CREATE TABLE Rol_Us_As
  (
    ROLES_rol      VARCHAR2 (2) NOT NULL ,
    ASIGNATURAS_id NUMBER NOT NULL ,
    USUARIOS_id    NUMBER NOT NULL
  ) ;
ALTER TABLE Rol_Us_As ADD CONSTRAINT Rol_Us_As_PK PRIMARY KEY ( ROLES_rol, ASIGNATURAS_id, USUARIOS_id ) ;


CREATE TABLE TAREAS
  (
    id                 NUMBER NOT NULL ,
    descripcion        VARCHAR2 (500) ,
    fecha_entrega      DATE ,
    fecha_creacion     DATE ,
    fecha_modificacion DATE ,
    estado_entrega     VARCHAR2 (100) ,
    comentarios        VARCHAR2 (500)
  ) ;
ALTER TABLE TAREAS ADD CONSTRAINT TAREAS_PK PRIMARY KEY ( id ) ;


CREATE TABLE TITULACIONES
  (
    id         NUMBER NOT NULL ,
    nombre     VARCHAR2 (30) NOT NULL ,
    curso      VARCHAR2 (30) ,
    CENTROS_id NUMBER NOT NULL
  ) ;
ALTER TABLE TITULACIONES ADD CONSTRAINT TITULACIONES_PK PRIMARY KEY ( id ) ;


CREATE TABLE USUARIOS
  (
    id        NUMBER NOT NULL ,
    dni       VARCHAR2 (30) NOT NULL ,
    nombre    VARCHAR2 (30) NOT NULL ,
    apellidos VARCHAR2 (30) NOT NULL ,
    correo    VARCHAR2 (30) NOT NULL ,
    pais      VARCHAR2 (10) ,
    foto BFILE ,
    expediente VARCHAR2 (20)
  ) ;
ALTER TABLE USUARIOS ADD CONSTRAINT USUARIOS_PK PRIMARY KEY ( id ) ;


CREATE TABLE us_grups
  (
    GRUPOS_id   NUMBER NOT NULL ,
    USUARIOS_id NUMBER NOT NULL
  ) ;
ALTER TABLE us_grups ADD CONSTRAINT us_grups_PK PRIMARY KEY ( GRUPOS_id, USUARIOS_id ) ;


ALTER TABLE ACTIVIDADES ADD CONSTRAINT ACTIVIDADES_ASIGNATURAS_FK FOREIGN KEY ( ASIGNATURAS_id ) REFERENCES ASIGNATURAS ( id ) ;

ALTER TABLE ASIGNATURAS ADD CONSTRAINT ASIGNATURAS_TITULACIONES_FK FOREIGN KEY ( TITULACIONES_id ) REFERENCES TITULACIONES ( id ) ;

ALTER TABLE CONTENIDOS ADD CONSTRAINT CONTENIDOS_ASIGNATURAS_FK FOREIGN KEY ( ASIGNATURAS_id ) REFERENCES ASIGNATURAS ( id ) ;

ALTER TABLE CORREO_INTERNO ADD CONSTRAINT CORREO_INTERNO_USUARIOS_FK FOREIGN KEY ( USUARIOS_id ) REFERENCES USUARIOS ( id ) ;

ALTER TABLE CORREO_INTERNO ADD CONSTRAINT CORREO_INTERNO_USUARIOS_FKv1 FOREIGN KEY ( USUARIOS_id1 ) REFERENCES USUARIOS ( id ) ;

ALTER TABLE CUESTIONARIOS ADD CONSTRAINT CUESTIONARIOS_ACTIVIDADES_FK FOREIGN KEY ( id ) REFERENCES ACTIVIDADES ( id ) ;

ALTER TABLE DIARIO ADD CONSTRAINT DIARIO_ACTIVIDADES_FK FOREIGN KEY ( id ) REFERENCES ACTIVIDADES ( id ) ;

ALTER TABLE ENTREGA ADD CONSTRAINT ENTREGA_TAREAS_FK FOREIGN KEY ( TAREAS_id ) REFERENCES TAREAS ( id ) ;

ALTER TABLE ENTREGA ADD CONSTRAINT ENTREGA_USUARIOS_FK FOREIGN KEY ( USUARIOS_id ) REFERENCES USUARIOS ( id ) ;

ALTER TABLE us_grups ADD CONSTRAINT FK_ASS_27 FOREIGN KEY ( GRUPOS_id ) REFERENCES GRUPOS ( id ) ;

ALTER TABLE us_grups ADD CONSTRAINT FK_ASS_28 FOREIGN KEY ( USUARIOS_id ) REFERENCES USUARIOS ( id ) ;

ALTER TABLE FOROS ADD CONSTRAINT FOROS_ACTIVIDADES_FK FOREIGN KEY ( id ) REFERENCES ACTIVIDADES ( id ) ;

ALTER TABLE GRUPOS ADD CONSTRAINT GRUPOS_ASIGNATURAS_FK FOREIGN KEY ( ASIGNATURAS_id ) REFERENCES ASIGNATURAS ( id ) ;

ALTER TABLE MENSAJES ADD CONSTRAINT MENSAJES_USUARIOS_FK FOREIGN KEY ( USUARIOS_id ) REFERENCES USUARIOS ( id ) ;

ALTER TABLE MENSAJES ADD CONSTRAINT MENSAJES_USUARIOS_FKv1 FOREIGN KEY ( USUARIOS_id1 ) REFERENCES USUARIOS ( id ) ;

ALTER TABLE NOTAS_FINALES ADD CONSTRAINT NOTAS_FINALES_ASIGNATURAS_FK FOREIGN KEY ( ASIGNATURAS_id ) REFERENCES ASIGNATURAS ( id ) ;

ALTER TABLE NOTAS_FINALES ADD CONSTRAINT NOTAS_FINALES_USUARIOS_FK FOREIGN KEY ( USUARIOS_id ) REFERENCES USUARIOS ( id ) ;

ALTER TABLE ORACLE ADD CONSTRAINT ORACLE_USUARIOS_FK FOREIGN KEY ( USUARIOS_id ) REFERENCES USUARIOS ( id ) ;

ALTER TABLE Preguntas ADD CONSTRAINT Preguntas_CUESTIONARIOS_FK FOREIGN KEY ( CUESTIONARIOS_id ) REFERENCES CUESTIONARIOS ( id ) ;

ALTER TABLE REGISTROS ADD CONSTRAINT REGISTROS_USUARIOS_FK FOREIGN KEY ( USUARIOS_id ) REFERENCES USUARIOS ( id ) ;

ALTER TABLE Respuestas ADD CONSTRAINT Respuestas_Preguntas_FK FOREIGN KEY ( Preguntas_id ) REFERENCES Preguntas ( id ) ;

ALTER TABLE Respuestas ADD CONSTRAINT Respuestas_USUARIOS_FK FOREIGN KEY ( USUARIOS_id ) REFERENCES USUARIOS ( id ) ;

ALTER TABLE Respuestas ADD CONSTRAINT Respuestas_USUARIOS_FKv1 FOREIGN KEY ( USUARIOS_id1 ) REFERENCES USUARIOS ( id ) ;

ALTER TABLE Rol_Us_As ADD CONSTRAINT Rol_Us_As_ASIGNATURAS_FK FOREIGN KEY ( ASIGNATURAS_id ) REFERENCES ASIGNATURAS ( id ) ;

ALTER TABLE Rol_Us_As ADD CONSTRAINT Rol_Us_As_ROLES_FK FOREIGN KEY ( ROLES_rol ) REFERENCES ROLES ( rol ) ;

ALTER TABLE Rol_Us_As ADD CONSTRAINT Rol_Us_As_USUARIOS_FK FOREIGN KEY ( USUARIOS_id ) REFERENCES USUARIOS ( id ) ;

ALTER TABLE TAREAS ADD CONSTRAINT TAREAS_ACTIVIDADES_FK FOREIGN KEY ( id ) REFERENCES ACTIVIDADES ( id ) ;

ALTER TABLE TITULACIONES ADD CONSTRAINT TITULACIONES_CENTROS_FK FOREIGN KEY ( CENTROS_id ) REFERENCES CENTROS ( id ) ;

----------------------------------------------------------------
------------------ CREACION DE INDICES Y SINONIMOS -------------
----------------------------------------------------------------

grant create index to campus; -- desde system
grant create synonym to campus; -- desde system

create unique index asig_idx on asignaturas(nombre,curso,grupoturno);
create unique index usuario_idx on usuarios (nombre, apellidos) compute statistics;
create index msj_env_idx on mensajes (usuarios_id,usuarios_id1);
create index msj_rec_idx on mensajes (usuarios_id1,usuarios_id);
create unique index resp_idx on respuestas(preguntas_id,respuesta,correccion);

--create bitmap index roles_idx  on rol_us_as (roles_rol, usuarios_id);
-- Este último index no se ejecuta porque los indexes bitmap sólo se ejecutan en las versiones Entreprise de Oracle (según los foros):
--Error que empieza en la línea: 1 del comando :
--create bitmap index roles_idx  on rol_us_as (roles_rol, usuarios_id)
--Informe de error -
--Error SQL: ORA-00439: función no activada: Bit-mapped indexes
--00439. 00000 -  "feature not enabled: %s"
--*Cause:    The specified feature is not enabled.
--*Action:   Do not attempt to use this feature.

create synonym T_RESPUESTAS for campus.respuestas;
create synonym T_PREGUNTAS for campus.preguntas;
create synonym T_ACTIVIDADES for campus.actividades;
create synonym T_ASIGNATURAS for campus.asignaturas;
create synonym T_USUARIOS for campus.usuarios;
create synonym RESULTADOS for campus.V_RESULTADO;
create synonym PERMISOS for campus.V_DATOS_USUARIO;
create synonym ACTA for campus.V_CALIFICACIONES;

-----------------------------------------------------------
-------  INTRODUCCION DE DATOS EN LA BD
-----------------------------------------------------------

INSERT INTO USUARIOS VALUES (12, 'U454655', 'Alberto','Jimenez Alvarez','ajalvarez@gmail.com','españa',''); 
INSERT INTO USUARIOS VALUES (21, 'H789565', 'Juan','Fraud Mango','jfmango@gmail.com','españa',''); 
INSERT INTO USUARIOS VALUES (89, 'Y896453E', 'Ram','Faharadi Kariji','ramfk@gmail.com',’india’,''); 
INSERT INTO USUARIOS VALUES (37, 'A852696', 'Alicia','Llaves Negras','allavesn@gmail.com','españa',''); 
INSERT INTO USUARIOS VALUES (90, 'B454510', 'David','Moreno Calvo','dvc@gmail.com','españa',''); 
INSERT INTO CENTROS VALUES (01, 'www.uma.es/etsi-informatica/', 'ETSII');
INSERT INTO TITULACIONES VALUES (1, 'Ingenieria Informatica', '',01);
INSERT INTO ASIGNATURAS VALUES (411, '2015/16', 'Base de datos','A','1'); 
INSERT INTO ASIGNATURAS VALUES (412, '2015/16', 'Sistemas de Internet','A','1');
INSERT INTO ASIGNATURAS VALUES (413, '2015/16', 'Procesadores de Lenguaje','A','1');
INSERT INTO ASIGNATURAS VALUES (421, '2015/16', 'Logica Computacional','A','1');
INSERT INTO ROLES VALUES ('0', 'estudiante');
INSERT INTO ROLES VALUES ('1', 'profesor');
INSERT INTO ROLES VALUES ('2', 'administrativo');
INSERT INTO NOTAS_FINALES VALUES (6, 'Aprobado', 411, 12, '20/09/2016');
INSERT INTO NOTAS_FINALES VALUES (8, 'Notable', 412, 12, '20/09/2016');
INSERT INTO NOTAS_FINALES VALUES (7, 'Notable', 421, 12, '20/09/2016');
INSERT INTO NOTAS_FINALES VALUES (9, 'Sobresaliente', 411, 37, '20/09/2016');
INSERT INTO NOTAS_FINALES VALUES (10, 'Matricula', 421, 37, '18/06/2016');
INSERT INTO NOTAS_FINALES VALUES (8, 'Notable', 413, 37, '20/09/2016');  
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
INSERT INTO ROL_US_AS VALUES ('2', 411, 90);
INSERT INTO ROL_US_AS VALUES ('2', 412, 90);
INSERT INTO ROL_US_AS VALUES ('2', 413, 90);
INSERT INTO ROL_US_AS VALUES ('2', 421, 90);

-------------------------------------------------------------------------------------------
----- CREACION DE ROLES Y PERMISOS DEL ROL R_ADMINISTRATIVO, INCLUYENDO DE V_CALIFICACIONES 
-------------------------------------------------------------------------------------------

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

----------------------------------------------------------------------------------------
-------------------  PERMISOS DEL ROL R_PROFESOR, INCLUYENDO 
----------------------------------------------------------------------------------------

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

----------------------------------------------------------------------------------------
----- PERMISOS DEL ROL R_ALUMNO, INCLUYENDO DE V_RESULTADO Y V_DATOS_USUARIO.
----- CREACION DE PR_ASIGNA_USUARIO Y DEL TRIGGER TR_INSERTAR_EN_V_RESULTADO.
----------------------------------------------------------------------------------------

--7. Dar permisos a R_ALUMNO para:
--7.1 Conectarse. Hay que modificar el esquema para que cada usuario tenga un USUARIO de Oracle con el que se conecte. 
-- Crear un procedimiento almacenado que a cada usuario de la tabla USUARIOS le asigne un usuario de Oracle y una palabra de paso. 
-- El procedimiento también asignará los permisos necesarios al usuario.
grant connect to R_ALUMNO;

--- Creamos la tabla ORACLE que representa los usuarios de ORACLE. 
-- YA ESTA CREADA PREVIAMENTE (al ejecutar el script del modelo relacional de la BD)
--CREATE TABLE ORACLE
--  (
--    id          NUMBER NOT NULL ,
--    miuser      VARCHAR2 (30) NOT NULL ,
--    pass        VARCHAR2 (30) NOT NULL ,
--    USUARIOS_id NUMBER NOT NULL
--  ) ;
--CREATE UNIQUE INDEX ORACLE__IDX ON ORACLE ( USUARIOS_id ASC ) ;
--ALTER TABLE ORACLE ADD CONSTRAINT ORACLE_PK PRIMARY KEY ( id ) ;

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

----------------------------------------------------------------------------
------ AUDITAR LAS CONEXIONES CON CREACION DE TR_CONEXIONES
----------------------------------------------------------------------------

--8. Crear una tabla CONEXIONES con los campos SESIONID, USUARIO, IP, MAQUINA, INICIO, FIN. Crear un trigger de manera 
-- que cada vez que un usuario de la base de datos se conecte se almacene en la tabla CONEXIONES su número de sesión, usuario, 
-- ip desde donde se conecta, máquina y fecha del sistema. Utilizar la funicón SYS_CONTEXT:

-- desde CAMPUS:
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


----------------------------------------------------------
--------    TESTING: COMPROBAR QUE TODO FUNCIONA BIEN
----------------------------------------------------------

--9. Crear al menos un usuario de cada rol y probar que todo funciona según lo diseñado
-- Conectado como CAMPUS:

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
 COMMIT;

-- Nos conectamos como usuario DAVID (es administrativo)
-- Comprobamos que puede crear, modificar ..etc usuarios, asignaturas y matriculas:
INSERT INTO CAMPUS.USUARIOS VALUES (02, 'C855510', 'Marta','Salva Gómez','martagz@gmail.com','españa',''); 
INSERT INTO CAMPUS.ASIGNATURAS VALUES (300, '2015/16', 'Legislaciones','A','1');
INSERT INTO CAMPUS.ROL_US_AS VALUES ('1', 300, 02);
COMMIT; -- confirmamos los cambios para que sean visibles al resto de usuarios también

-- Comprobamos que puede consultar las calificaciones de los alumnos:
select * from CAMPUS.V_CALIFICACIONES;


--------------------------------------------------------------------------
--------------------   PARTE 2 : PL/SQL
--------------------------------------------------------------------------

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


------------------------------------------
------------  PARTE 3 : JOBS 
------------------------------------------

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
  		INSERT INTO errores VALUES(VAR_ALUMNO.expediente, VAR_ALUMNO.codigo, SQLERRM);
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


------------------------------------------
-------  PARTE 4 :  AUDITORIA  
------------------------------------------

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

--------------------------------------------------
------------- TESTING JOBS Y AUDITORIA
--------------------------------------------------

-- Rellenamos el expediente de los alumnos:
update usuarios set expediente = substr(concat(109, ORA_HASH(substr(dni,2,6))),1,12) where id = 12;
update usuarios set expediente = substr(concat(109, ORA_HASH(substr(dni,2,6))),1,12) where id = 37;

EXECUTE PR_RELLENAR_HISTORICO;
select * from historico;
select * from errores;

update NOTAS_FINALES set nota = 7 where calificacion = 'Notable';
select * from controlar_notas;

COMMIT;


