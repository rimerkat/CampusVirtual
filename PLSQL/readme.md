---
title: "Trabajos en PLSQL"
subtitle: "Administracion de Base de Datos"
author: "Grupo MATRIX: Joaquin Terrasa Moya, María Castro Martínez, Nadia Carrera Chahir, Rime Raissouni"
date: 24/05/2017
---

## 1. Procedimientos PL/SQL

blablabla

***

## 2. JOBS 
Una vez que terminan los exámenes de septiembre se almacenan las notas finales en una tabla histórica, eliminándose los datos de las pruebas parciales. Para ello se debe crear una tabla llamada `HISTORICO` con el **nombre y apellidos del usuario, su dni, expediente, usuario de oracle, código de asignatura, nombre de asignatura, curso académico, nota y calificación final**.

Realizar un [`JOB`][1] que se ejecute <u>todos los años el día 15 de octubre</u> y que almacene todos los datos en la tabla `HISTORICO`. <u>[Si se produjera algún error, debe capturarse][2]</u>, para asegurarnos de que la copia se realiza con los demás alumnos y asignaturas. Para ello <u>se debe crear una tabla ERRORES</u> donde aparezca el **expediente del alumno, el código de la asignatura y el error que se ha producido**.
Si la copia en el HISTORICO tuvo éxito para todos los alumnos de una asignatura, se deben borrar de la información
de las tablas correspondientes. (subir NOTA)

  1. ***NOTA**: Para probarlo se puede disparar el JOB cada minuto y luego cambiar su frecuencia.*
  2. ***AUDITORIA**: Es muy importante controlar quién modifica las notas finales de las asignaturas. Establecer los mecanismos para poder obtener el usuario y la IP de cada modificación que se haga de las notas. Esto se puede hacer mediante la auditoría de Oracle o mediante Triggers.*

[1]: https://docs.oracle.com/cd/B28359_01/appdev.111/b28419/d_sched.htm#i1000363
[2]: http://www.oracle.com/technetwork/issue-archive/2012/12-mar/o22plsql-1518275.html
