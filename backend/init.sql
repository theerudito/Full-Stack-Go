
-- Crear base de datos
CREATE DATABASE Ejemplo;

-- Conectarse a la base de datos
\c Ejemplo;

-- Crear tabla de personajes
CREATE TABLE
  personajes (
    id SERIAL PRIMARY KEY,
    nombre VARCHAR(100),
    clan VARCHAR(100),
    edad INT
  );

-- Insertar algunos personajes de ejemplo
INSERT INTO
  personajes (nombre, clan, edad)
VALUES
  ('Naruto Uzumaki', 'Uzumaki', 17),
  ('Sasuke Uchiha', 'Uchiha', 17),
  ('Sakura Haruno', 'Haruno', 17),
  ('Kakashi Hatake', 'Hatake', 29),
  ('Itachi Uchiha', 'Uchiha', 21),
  ('Gaara', 'Kazekage', 17);