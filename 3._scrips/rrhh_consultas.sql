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




-- CTE (Common Table Expression) --



-- 1.1 ¿Cuántas personas fueron contratadas por cargo?

WITH empleados_por_cargo AS (
    SELECT 
        e.id_cargo,
        COUNT(e.id_empleado) AS cantidad_empleados
    FROM 
        empleados e
    GROUP BY 
        e.id_cargo
)
SELECT 
    c.id_cargo,
    c.nombre AS cargo,
    COALESCE(epc.cantidad_empleados, 0) AS cantidad_empleados
FROM 
    cargos c
LEFT JOIN 
    empleados_por_cargo epc ON c.id_cargo = epc.id_cargo
ORDER BY 
    c.id_cargo;


-- 1.2 ¿Cuántas personas fueron contratadas por crago 
--y cuánto se les pagó durante todo el proyecto?

WITH pagos_por_empleado AS (
    SELECT 
        e.id_empleado,
        e.id_cargo,
        COUNT(DISTINCT ep.id_pi) * 5 AS total_quincenas -- Cada PI equivale a 5 pagos quincenales
    FROM empleados e
    JOIN empleados_equipos ee ON e.id_empleado = ee.id_empleado
    JOIN equipos_pi ep ON ee.id_equipo = ep.id_equipo
    GROUP BY e.id_empleado, e.id_cargo
),
total_por_cargo AS (
    SELECT 
        c.id_cargo,
        c.nombre AS cargo,
        COUNT(p.id_empleado) AS cantidad_empleados,
        SUM(p.total_quincenas * c.remuneracion_quincenal) AS total_pagado
    FROM pagos_por_empleado p
    JOIN cargos c ON p.id_cargo = c.id_cargo
    GROUP BY c.id_cargo, c.nombre
)
SELECT * FROM total_por_cargo ORDER BY id_cargo;


-- //////////////////////////////////////////////////////////////////////////////////////////////////////////////////////// --

-- Funciones Ventana (Window Functions) --


-- 1.1 ¿Para cada quincena, cuánto se pagó en todos los cargos contratados para ese periodo?

WITH quincenas AS (
    SELECT generate_series(1, 25) AS quincena
),
equipos_quincena AS (
    SELECT
        q.quincena,
        ep.id_equipo,
        ep.id_pi
    FROM
        quincenas q
    LEFT JOIN
        equipos_pi ep ON (q.quincena - 1) / 5 + 1 = ep.id_pi
),
total_pagado AS (
    SELECT
        eq.quincena,
        SUM(c.remuneracion_quincenal) AS total_pagado_quincena
    FROM
        equipos_quincena eq
    JOIN
        empleados_equipos eeq ON eq.id_equipo = eeq.id_equipo
    JOIN
        empleados e ON eeq.id_empleado = e.id_empleado
    JOIN
        cargos c ON e.id_cargo = c.id_cargo
    GROUP BY
        eq.quincena
)
SELECT
    q.quincena,
    COALESCE(tp.total_pagado_quincena, 0) AS total_pagado_quincena
FROM
    quincenas q
LEFT JOIN
    total_pagado tp ON q.quincena = tp.quincena
ORDER BY
    q.quincena;


-- 1.2 ¿Para cada quincena, cuánto se pagó en todos los cargos contratados para ese periodo 
-- y cuánto fue la variación porcentual con respecto a la quincena inmediatamente previa?

WITH quincenas AS (
    SELECT generate_series(1, 25) AS quincena
),
equipos_quincena AS (
    SELECT
        q.quincena,
        ep.id_equipo,
        ep.id_pi
    FROM
        quincenas q
    LEFT JOIN
        equipos_pi ep ON (q.quincena - 1) / 5 + 1 = ep.id_pi
),
total_pagado AS (
    SELECT
        eq.quincena,
        SUM(c.remuneracion_quincenal) AS total_pagado_quincena
    FROM
        equipos_quincena eq
    JOIN
        empleados_equipos eeq ON eq.id_equipo = eeq.id_equipo
    JOIN
        empleados e ON eeq.id_empleado = e.id_empleado
    JOIN
        cargos c ON e.id_cargo = c.id_cargo
    GROUP BY
        eq.quincena
),
variacion_porcentual AS (
    SELECT
        q.quincena,
        COALESCE(tp.total_pagado_quincena, 0) AS total_pagado_quincena,
        LAG(COALESCE(tp.total_pagado_quincena, 0)) OVER (ORDER BY q.quincena) AS total_anterior
    FROM
        quincenas q
    LEFT JOIN
        total_pagado tp ON q.quincena = tp.quincena
)
SELECT
    quincena,
    total_pagado_quincena,
    CASE
        WHEN total_anterior = 0 THEN 0  -- Si no hay total anterior, la variación es 0
        ELSE ROUND(((total_pagado_quincena - total_anterior) / total_anterior * 100)::numeric, 2)  -- Redondeo a 2 decimales
    END AS variacion_porcentual
FROM
    variacion_porcentual
ORDER BY
    quincena;



-- //////////////////////////////////////////////////////////////////////////////////////////////////////////////////////// --

-- f_calcula_costo_departamento_quincena
-- calcula el salario total pagado a todos los empleados de un departamento en una quincena específica

SELECT f_calcula_costo_departamento_quincena(6, 1);


-- //////////////////////////////////////////////////////////////////////////////////////////////////////////////////////// --

-- p_calcula_nomina_quincena
-- calcula la nómina de una quincena específica, eliminando datos previos y registrando el número de empleados y el total de remuneraciones por departamento

CALL p_calcula_nomina_quincena(1);

SELECT * FROM NOMINA; -- para ver lo que se insertó en la tabla



