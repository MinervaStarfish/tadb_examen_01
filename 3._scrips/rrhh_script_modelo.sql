-- Correo: mariana.osorioro@upb.edu.co
-- Estudiante: Mariana Osorio Rojas
-- ID: 464679


-- Universidad Pontificia Bolivariana
-- Facultad de Ingenierías - Ingeniería de Sistemas e Informática
-- Tópicos Avanzados en Bases de Datos


-- ==============================================================

-- Examen No 1: Análisis de Recursos Humanos 
--              Lógica Almacenada en Base de Datos

-- Motor de Base de datos: PostgreSQL 17.x

-- ==============================================================


-- ***************************
-- Abastecimiento en nube AWS
-- ***************************

-- crear y configurar intancia EC2 en AWS

-- Usar SSH para conectarse a la instancia desde nuestro terminal local:
ssh -i \Users\User\Downloads\rrhh_key.pem ubuntu@18.189.193.27


-- *************************************
-- Creación de base de datos y usuarios
-- *************************************

-- Instalar paquetes en terminal local
sudo apt update && sudo apt upgrade -y

-- Instalar PostgreSQL
sudo apt install postgresql postgresql-contrib -y

-- Iniciar y habilitar PostgreSQ
sudo systemctl start postgresql
sudo systemctl enable postgresql

-- Permitir conexiones remotas 

-- Editar pg_hba.conf
-- sudo nano /etc/postgresql/*/main/pg_hba.conf 
-- Agregar al final: 
host rrhh_db rrhh_admin TU_IP_PRIVADA/32 md5

-- Editar postgresql.conf
-- sudo nano /etc/postgresql/*/main/postgresql.conf
-- Buscar y editar: 
listen_addresses = '*'

-- Reiniciar PostgreSQL
sudo systemctl restart postgresql


-- Entra a PostgreSQL
sudo -u postgres psql

-- Para salir de Postgre una vez terminada la creacion
\q

-- Crear la base de datos
CREATE DATABASE rrhh_db;

-- Crear el usuario admin con contraseña 
--(diferente del default, para mejorar la seguridad de nuestro usuario con más privilegios):
CREATE USER rrhh_admin WITH PASSWORD 'rrhh_pass';

-- ==============================================================


-- ASIGNACIÓN DE PRIVILEGIOS PARA EL USUARIO ADMIN
GRANT ALL PRIVILEGES ON DATABASE rrhh_db TO rrhh_admin; -- Otorgar acceso total a la base de datos
GRANT ALL PRIVILEGES ON SCHEMA public TO rrhh_admin; -- Dar acceso total al esquema (para que pueda crear tablas y otros objetos)

-- ==============================================================
-- Recordar que es una pésima práctica de seguridad asignarle 
-- TODOS los privilegios

-- Esto será solo para el usuario admin
-- Se crearán otros usuarios para manejar la seguridad
-- ==============================================================


-- Dar acceso total a todas las tablas existentes en el esquema
GRANT ALL PRIVILEGES ON ALL TABLES IN SCHEMA public TO rrhh_admin;

-- Asegurar que cualquier tabla nueva en el futuro también tenga permisos
ALTER DEFAULT PRIVILEGES IN SCHEMA public GRANT ALL ON TABLES TO rrhh_admin;

-- Dar permisos sobre secuencias (para manejar IDs autoincrementales)
GRANT ALL PRIVILEGES ON ALL SEQUENCES IN SCHEMA public TO rrhh_admin;
ALTER DEFAULT PRIVILEGES IN SCHEMA public GRANT ALL ON SEQUENCES TO rrhh_admin;

-- Si usarás funciones almacenadas, otorga permisos sobre ellas
GRANT ALL PRIVILEGES ON ALL FUNCTIONS IN SCHEMA public TO rrhh_admin;
ALTER DEFAULT PRIVILEGES IN SCHEMA public GRANT ALL ON FUNCTIONS TO rrhh_admin;


-- ==============================================================

-- Privilegios de uso en el esquema
grant usage on schema public to rrhh_admin;

-- privilegios para crear objetos
grant create on schema public to rrhh_admin;

-- Privilegios sobre tablas existentes
grant select, insert, update, delete, trigger on all tables in schema public to rrhh_admin;

-- privilegios sobre secuencias existentes
grant usage, select on all sequences in schema public to rrhh_admin;

-- privilegios sobre funciones existentes
grant execute on all functions in schema public to rrhh_admin;

-- privilegios sobre procedimientos existentes
grant execute on all procedures in schema public to rrhh_admin;

-- privilegios sobre futuras tablas y secuencias
alter default privileges in schema public grant select, insert, update, delete, trigger on tables to rrhh_admin;

alter default privileges in schema public grant select, usage on sequences to rrhh_admin;

-- privilegios sobre futuras funciones y procedimientos
alter default privileges in schema public grant execute on routines to rrhh_admin;

--Privilegios de consulta sobre el esquema information_schema
grant usage on schema information_schema to rrhh_admin;

-- ==============================================================

-- Crear usuario con menos privilegios
CREATE USER rrhh_user WITH PASSWORD 'securepass';
GRANT SELECT, INSERT, UPDATE ON ALL TABLES IN SCHEMA public TO rrhh_user;

-- ==============================================================


-- =========================================
-- Para validar los privilegios sobre tablas
-- =========================================

-- Cambiar "rrhh_admin" por el usuario que se quiere verificar

SELECT grantee, table_schema, table_name, privilege_type
FROM information_schema.table_privileges
WHERE grantee = 'rrhh_admin';

-- Para validar los privilegios sobre los esquemas
SELECT 
    n.nspname AS schema_name,
    CASE WHEN has_schema_privilege('rrhh_admin', n.oid, 'CREATE') THEN 'CREATE' ELSE NULL END AS create_privilege,
    CASE WHEN has_schema_privilege('rrhh_admin', n.oid, 'USAGE') THEN 'USAGE' ELSE NULL END AS usage_privilege
FROM 
    pg_catalog.pg_namespace n
WHERE 
    n.nspname NOT LIKE 'pg_%'
    AND n.nspname != 'information_schema';


-- Para validar los atributos del usuario
SELECT rolname, rolsuper, rolinherit, rolcreaterole, rolcreatedb, rolcanlogin
FROM pg_roles
WHERE rolname = 'rrhh_admin';

-- Para validar privilegios a nivel de base de datos
SELECT grantee, privilege_type
FROM information_schema.usage_privileges
WHERE object_type = 'DATABASE' AND object_name = 'rrhh_admin';

-- Para validar privilegios sobre rutinas
SELECT grantee, routine_schema, routine_name, privilege_type
FROM information_schema.routine_privileges
WHERE grantee = 'rrhh_admin';

-- Para validar privilegios sobre secuencias
select grantee, object_schema, object_name, 
object_type, privilege_type 
FROM information_schema.usage_privileges
WHERE grantee = 'rrhh_admin'
AND object_type = 'SEQUENCE';


-- ==============================================================

-- Con el usuario: rrhh_db / rrhh_admin

-- *******************
-- Creacion de tablas
-- *******************

-- Seguir el orden

-- Tabla: Departamentos
create table departamentos
(
    id_departamento      int not null constraint departamentos_pk primary key,
    nombre              varchar(50) not null
);

comment on table departamentos is 'Lista de departamentos dentro del proyecto';
comment on column departamentos.id_departamento is 'Identificador único del departamento';
comment on column departamentos.nombre is 'Nombre del departamento';


-- Tabla: Fases del proyecto (PIs)
create table pis
(
    id_pi          int not null constraint pis_pk primary key,
    nombre         varchar(50) not null
);

comment on table pis is 'Lista de fases del proyecto (PIs)';
comment on column pis.id_pi is 'Identificador único de la fase del proyecto';
comment on column pis.nombre is 'Nombre de la fase del proyecto';


-- Tabla: Cargos
create table cargos
(
    id_cargo              int not null constraint cargos_pk primary key,
    nombre                varchar(50) not null,
    id_departamento       int not null constraint cargos_departamento_fk references departamentos,
    remuneracion_quincenal float not null
);

comment on table cargos is 'Lista de cargos con su respectiva remuneración y departamento';
comment on column cargos.id_cargo is 'Identificador único del cargo';
comment on column cargos.nombre is 'Nombre del cargo';
comment on column cargos.id_departamento is 'Departamento al que pertenece el cargo';
comment on column cargos.remuneracion_quincenal is 'Salario quincenal del cargo en dólares';


-- Tabla: Equipos
create table equipos
(
    id_equipo        int not null constraint equipos_pk primary key,
    nombre          varchar(50) not null,
    id_departamento int not null constraint equipos_departamento_fk references departamentos
);

comment on table equipos is 'Lista de equipos de trabajo dentro del proyecto';
comment on column equipos.id_equipo is 'Identificador único del equipo';
comment on column equipos.nombre is 'Nombre del equipo de trabajo';
comment on column equipos.id_departamento is 'Departamento al que pertenece el equipo';


-- Tabla: Empleados
create table empleados
(
    id_empleado   int not null constraint empleados_pk primary key,
    nombre        varchar(100) not null,
    id_cargo      int not null constraint empleados_cargo_fk references cargos
);

comment on table empleados is 'Lista de empleados del proyecto';
comment on column empleados.id_empleado is 'Identificador único del empleado';
comment on column empleados.nombre is 'Nombre completo del empleado';
comment on column empleados.id_cargo is 'Cargo que ocupa el empleado en la organización';


-- Tabla: Relación entre empleados y equipos
create table empleados_equipos
(
    id_empleado int not null constraint empleados_equipos_empleado_fk references empleados,
    id_equipo   int not null constraint empleados_equipos_equipo_fk references equipos,
    constraint empleados_equipos_pk primary key (id_empleado, id_equipo)
);

comment on table empleados_equipos is 'Relación entre empleados y los equipos a los que pertenecen';
comment on column empleados_equipos.id_empleado is 'Identificador del empleado asignado a un equipo';
comment on column empleados_equipos.id_equipo is 'Identificador del equipo al que pertenece el empleado';


-- Tabla: Relación entre equipos y proyectos de inversión (PIs)
create table equipos_pi
(
    id_equipo int not null constraint equipos_pi_equipo_fk references equipos,
    id_pi     int not null constraint equipos_pi_pi_fk references pis,
    constraint equipos_pi_pk primary key (id_equipo, id_pi)
);

comment on table equipos_pi is 'Relación entre equipos y las fases del proyecto (PIs) en las que han trabajado';
comment on column equipos_pi.id_equipo is 'Identificador del equipo que participó en la fase del proyecto';
comment on column equipos_pi.id_pi is 'Identificador de la fase del proyecto en la que participó el equipo';

-- Tabla: Nómina
CREATE TABLE NOMINA (
    id_quincena INT NOT NULL,
    id_departamento INT NOT NULL,
    total_empleados_departamento INT NOT NULL,
    valor FLOAT NOT NULL,
    PRIMARY KEY (id_quincena, id_departamento)
);


-- ==============================================================

-- Orden de Eliminación
drop table equipos_pi cascade
drop table empleados_equipos cascade
drop table empleados cascade
drop table equipos cascade
drop table pis cascade
drop table cargos cascade
drop table departamentos cascade

-- ==============================================================


-- **********
-- funciones
-- **********

CREATE OR REPLACE FUNCTION f_calcula_costo_departamento_quincena(
    p_quincena INT,                -- Número de la quincena (1 a 25)
    p_id_departamento INT          -- Código del departamento
)
RETURNS FLOAT AS $$
DECLARE
    v_pi INT;                      -- PI correspondiente a la quincena
    v_total_salario FLOAT := 0;    -- Total del salario pagado
BEGIN
    -- Determinar el PI correspondiente a la quincena
    v_pi := CEIL(p_quincena / 5.0);

    -- Calcular el salario total pagado en la quincena para el departamento
    SELECT COALESCE(SUM(c.remuneracion_quincenal), 0)
    INTO v_total_salario
    FROM empleados e
    JOIN cargos c ON e.id_cargo = c.id_cargo
    JOIN departamentos d ON c.id_departamento = d.id_departamento
    JOIN empleados_equipos ee ON e.id_empleado = ee.id_empleado
    JOIN equipos_pi ep ON ee.id_equipo = ep.id_equipo
    WHERE d.id_departamento = p_id_departamento
      AND ep.id_pi = v_pi;

    -- Retornar el total del salario
    RETURN v_total_salario;
END;
$$ LANGUAGE plpgsql;


-- Ejemplo de uso (el retorno se muestra en la carpeta "archivos_salidas")
SELECT f_calcula_costo_departamento_quincena(6, 1);


-- ==============================================================


-- ***************
-- Procedimientos
-- ***************

CREATE OR REPLACE PROCEDURE p_calcula_nomina_quincena(p_id_quincena INT)
LANGUAGE plpgsql
AS $$
BEGIN
    -- Eliminar registros previos de la quincena en la tabla NOMINA
    DELETE FROM NOMINA WHERE id_quincena = p_id_quincena;

    -- Insertar los nuevos cálculos de nómina
    INSERT INTO NOMINA (id_quincena, id_departamento, total_empleados_departamento, valor)
    SELECT
        p_id_quincena AS id_quincena,
        d.id_departamento,
        COUNT(DISTINCT e.id_empleado) AS total_empleados_departamento,
        COALESCE(SUM(c.remuneracion_quincenal), 0)::FLOAT AS valor
    FROM departamentos d
    LEFT JOIN cargos c ON d.id_departamento = c.id_departamento
    LEFT JOIN empleados e ON c.id_cargo = e.id_cargo
    LEFT JOIN empleados_equipos ee ON e.id_empleado = ee.id_empleado
    LEFT JOIN equipos eq ON ee.id_equipo = eq.id_equipo
    GROUP BY d.id_departamento;
END;
$$;


-- Ejemplo de uso (el retorno se muestra en la carpeta "archivos_salidas")
CALL p_calcula_nomina_quincena(1);

