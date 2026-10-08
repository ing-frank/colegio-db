# colegio_db — Sistema de Gestión Escolar con pase de lista

Ejercicio práctico del taller **Creación de una Base de Datos en PostgreSQL**.

## Tablas

| Tabla | Descripción |
|---|---|
| `estudiantes` | `estudiante_id` (PK, SERIAL), `nombre` (NOT NULL), `email` (UNIQUE, NOT NULL), `edad` (CHECK >= 15) |
| `cursos` | `curso_id` (PK, SERIAL), `nombre_curso` (NOT NULL), `estudiante_id` (FK a `estudiantes`) |
| `asistencias` | Pase de lista: `curso_id` (FK a `cursos`), `fecha`, `estado` (presente, ausente, tardanza, excusa), `observacion` |

## Cómo ejecutarlo

```bash
psql -U postgres -f colegio_db.sql
```

En pgAdmin 4: ejecutar primero `CREATE DATABASE colegio_db;`, abrir el Query Tool
sobre `colegio_db` y ejecutar el resto del script (sin la línea `\c colegio_db;`).

## Contenido del script

1. **Fase 1:** crea `colegio_db` y se conecta.
2. **Fase 2 (DDL):** crea las tres tablas con llaves primarias, foráneas y restricciones.
3. **Fase 3 (DML):** inserta 4 estudiantes, 6 cursos y 12 registros de asistencia.
4. **Fase 4 (DQL):** todos los estudiantes, cursos de un estudiante por ID, JOIN estudiante-curso, pase de lista de un día y resumen de asistencia.

## Datos del estudiante

- **Estudiante:** Frank Alberto Sherivé
- **Matrícula:** LR-2025-03023
- **Carrera:** Ingeniería en Software
- **Universidad:** Universidad Federico Henríquez y Carvajal (UFHEC), La Romana
- **Profesora:** Miladys Rosario
