-- ============================================================
-- Sistema de Gestión Escolar (colegio) - Pase de lista
-- Estudiante: Frank Alberto Sherivé
-- Matrícula:  LR-2025-03023
-- Carrera:    Ingeniería en Software
-- Universidad Federico Henríquez y Carvajal (UFHEC), La Romana
-- Profesora:  Miladys Rosario
-- Motor:      PostgreSQL
-- Ejecutar con:  psql -U postgres -f colegio_db.sql
-- ============================================================

-- ------------------------------------------------------------
-- FASE 1: Crear la base de datos y conectarse
-- ------------------------------------------------------------
CREATE DATABASE colegio_db;

\c colegio_db;

-- ------------------------------------------------------------
-- FASE 2: Crear las tablas (DDL)
-- ------------------------------------------------------------
CREATE TABLE estudiantes (
    estudiante_id SERIAL PRIMARY KEY,
    nombre        VARCHAR(100) NOT NULL,
    email         VARCHAR(120) NOT NULL UNIQUE,
    edad          INT CHECK (edad >= 15)
);

CREATE TABLE cursos (
    curso_id      SERIAL PRIMARY KEY,
    nombre_curso  VARCHAR(100) NOT NULL,
    estudiante_id INT REFERENCES estudiantes(estudiante_id) ON DELETE CASCADE
);

-- Pase de lista: una fila por estudiante-curso y por día
CREATE TABLE asistencias (
    asistencia_id SERIAL PRIMARY KEY,
    curso_id      INT NOT NULL REFERENCES cursos(curso_id) ON DELETE CASCADE,
    fecha         DATE NOT NULL DEFAULT CURRENT_DATE,
    estado        VARCHAR(10) NOT NULL
                  CHECK (estado IN ('presente', 'ausente', 'tardanza', 'excusa')),
    observacion   VARCHAR(200),
    UNIQUE (curso_id, fecha)
);

-- ------------------------------------------------------------
-- FASE 3: Insertar datos (DML)
-- ------------------------------------------------------------
INSERT INTO estudiantes (nombre, email, edad) VALUES
    ('Ana María Pérez',    'ana.perez@colegio.edu.do',    16),
    ('Luis Miguel Santos', 'luis.santos@colegio.edu.do',  17),
    ('Carla Rodríguez',    'carla.rodriguez@colegio.edu.do', 15),
    ('José Manuel Guzmán', 'jose.guzman@colegio.edu.do',  18);

INSERT INTO cursos (nombre_curso, estudiante_id) VALUES
    ('Matemáticas',     1),
    ('Lengua Española', 1),
    ('Matemáticas',     2),
    ('Informática',     2),
    ('Informática',     3),
    ('Ciencias Naturales', 4);

INSERT INTO asistencias (curso_id, fecha, estado, observacion) VALUES
    (1, '2026-10-05', 'presente', NULL),
    (2, '2026-10-05', 'presente', NULL),
    (3, '2026-10-05', 'tardanza', 'Llegó 10 minutos tarde'),
    (4, '2026-10-05', 'presente', NULL),
    (5, '2026-10-05', 'ausente',  NULL),
    (6, '2026-10-05', 'presente', NULL),
    (1, '2026-10-06', 'ausente',  NULL),
    (2, '2026-10-06', 'presente', NULL),
    (3, '2026-10-06', 'presente', NULL),
    (4, '2026-10-06', 'presente', NULL),
    (5, '2026-10-06', 'excusa',   'Cita médica'),
    (6, '2026-10-06', 'presente', NULL);

-- ------------------------------------------------------------
-- FASE 4: Consultas de verificación (DQL)
-- ------------------------------------------------------------

-- 1. Mostrar todos los estudiantes registrados
SELECT * FROM estudiantes;

-- 2. Cursos que pertenecen a un estudiante específico (por su ID)
SELECT curso_id, nombre_curso
FROM cursos
WHERE estudiante_id = 1;

-- 3. JOIN: nombre del estudiante junto al curso que cursa
SELECT e.nombre AS estudiante, c.nombre_curso AS curso
FROM estudiantes e
JOIN cursos c ON c.estudiante_id = e.estudiante_id
ORDER BY e.nombre, c.nombre_curso;

-- 4. Pase de lista de un día
SELECT a.fecha, e.nombre AS estudiante, c.nombre_curso AS curso, a.estado, a.observacion
FROM asistencias a
JOIN cursos c      ON c.curso_id = a.curso_id
JOIN estudiantes e ON e.estudiante_id = c.estudiante_id
WHERE a.fecha = '2026-10-05'
ORDER BY c.nombre_curso, e.nombre;

-- 5. Resumen de asistencia por estudiante
SELECT e.nombre AS estudiante,
       COUNT(*) FILTER (WHERE a.estado = 'presente') AS presentes,
       COUNT(*) FILTER (WHERE a.estado = 'ausente')  AS ausencias,
       COUNT(*) FILTER (WHERE a.estado = 'tardanza') AS tardanzas,
       COUNT(*) FILTER (WHERE a.estado = 'excusa')   AS excusas
FROM estudiantes e
JOIN cursos c      ON c.estudiante_id = e.estudiante_id
JOIN asistencias a ON a.curso_id = c.curso_id
GROUP BY e.nombre
ORDER BY e.nombre;
