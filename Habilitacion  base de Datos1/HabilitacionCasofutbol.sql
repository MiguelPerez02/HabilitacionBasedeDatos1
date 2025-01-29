SELECT * FROM Presidente;

CREATE TABLE Presidente (
    tipo_documento VARCHAR(20),
    numero_documento BIGINT PRIMARY KEY,
    nombre VARCHAR(255) NOT NULL,
    apellidos VARCHAR(255) NOT NULL,
    fecha_nacimiento DATE NOT NULL,
    equipo_id INT,
    año_eleccion YEAR,
    UNIQUE (tipo_documento, numero_documento)
);

SELECT * FROM Equipo;

CREATE TABLE Equipo (
    codigo INT PRIMARY KEY,
    nombre VARCHAR(255) NOT NULL,
    estadio VARCHAR(255) NOT NULL,
    aforo INT,
    año_fundacion YEAR,
    ciudad VARCHAR(255),
    presidente_id BIGINT,
    FOREIGN KEY (presidente_id) REFERENCES Presidente(numero_documento)
);

SELECT * FROM Jugador;

CREATE TABLE Jugador (
    codigo INT PRIMARY KEY,
    nombre VARCHAR(255) NOT NULL,
    fecha_nacimiento DATE NOT NULL,
    posicion VARCHAR(255) NOT NULL,
    equipo_id INT,
    FOREIGN KEY (equipo_id) REFERENCES Equipo(codigo)
);

SELECT * FROM Partido;

CREATE TABLE Partido (
    codigo INT PRIMARY KEY,
    fecha DATE NOT NULL,
    equipo_casa_id INT,
    goles_casa INT,
    equipo_fuera_id INT,
    goles_fuera INT,
    FOREIGN KEY (equipo_casa_id) REFERENCES Equipo(codigo),
    FOREIGN KEY (equipo_fuera_id) REFERENCES Equipo(codigo)
);

SELECT * FROM Gol;

CREATE TABLE Gol (
    codigo INT PRIMARY KEY,
    partido_id INT,
    jugador_id INT,
    minuto INT,
    descripcion VARCHAR(255),
    FOREIGN KEY (partido_id) REFERENCES Partido(codigo),
    FOREIGN KEY (jugador_id) REFERENCES Jugador(codigo)
);


INSERT INTO Presidente (tipo_documento, numero_documento, nombre, apellidos, fecha_nacimiento, equipo_id, año_eleccion)
VALUES
('CC', 2345678901, 'Carlos', 'Mendoza', '1965-02-15', 1, 2018),
('CC', 3456789012, 'Lucas', 'Herrera', '1980-11-30', 2, 2022),
('CC', 4567890123, 'Roberto', 'Diaz', '1955-06-20', 3, 2019),
('CC', 5678901234, 'Rafael', 'Perez', '1978-08-10', 4, 2021),
('CC', 6789012345, 'Fernando', 'Gonzalez', '1975-09-12', 5, 2020);


-- Insertar registros en la tabla Equipo
INSERT INTO Equipo (codigo, nombre, estadio, aforo, año_fundacion, ciudad)
VALUES (1, 'America', 'Estadio Pascual', 20000, 1990, 'Cali'),
       (2, 'Deportivo Cali', 'Estadio Palmaseca', 30000, 1995, 'Palmira'),
       (3, 'Millonarios', 'Estadio Campin', 22000, 1985, 'Bogota'),
       (4, 'Junior', 'Estadio Metropolitano', 20000, 1992, 'Barranquilla'),
       (5, 'Deportivo Pasto', 'Estadio Libertad', 18000, 2000, 'Pasto');

-- Insertar registros en la tabla Jugador
INSERT INTO Jugador (codigo, nombre, fecha_nacimiento, posicion, equipo_id)
VALUES (1, 'Luis', '1995-04-25', 'Delantero', 1),
       (2, 'Carlos', '1993-08-15', 'Defensa', 2),
       (3, 'Gabriel', '1991-09-10', 'Portero', 3),
       (4, 'Mauro', '1992-03-22', 'Centrocampista', 4),
       (5, 'Juan', '1994-05-18', 'Delantero', 5);

-- Insertar registros en la tabla Partido
INSERT INTO Partido (codigo, fecha, equipo_casa_id, goles_casa, equipo_fuera_id, goles_fuera)
VALUES (1, '2025-01-01', 1, 2, 2, 1),
       (2, '2025-02-01', 2, 1, 3, 2),
       (3, '2025-03-15', 3, 3, 4, 1),
       (4, '2025-04-20', 4, 2, 5, 4),
       (5, '2025-05-25', 5, 0, 1, 3);

-- Insertar registros en la tabla Gol
INSERT INTO Gol (codigo, partido_id, jugador_id, minuto, descripcion)
VALUES (1, 1, 1, 23, 'Golazo desde fuera del área'),
       (2, 2, 2, 15, 'Gol de cabeza'),
       (3, 3, 3, 30, 'Tiro libre'),
       (4, 4, 4, 45, 'Gol de penalti'),
       (5, 5, 5, 60, 'Gol en contra');


DELIMITER //

CREATE PROCEDURE ConsultarGolesJugador(IN codigo INT)
BEGIN
    SELECT j.codigo, j.nombre, e.nombre AS equipo, p.nombre AS presidente, SUM(g.minuto) AS total_goles
    FROM Jugador j
    JOIN Equipo e ON j.equipo_id = e.codigo
    JOIN Presidente p ON e.codigo = p.equipo_id
    LEFT JOIN Gol g ON j.codigo = g.jugador_id
    WHERE j.codigo = codigo
    GROUP BY j.codigo, j.nombre, e.nombre, p.nombre;
END //

DELIMITER ;

CALL ConsultarGolesJugador(1);
CALL ConsultarGolesJugador(2);
CALL ConsultarGolesJugador(3);

CREATE USER 'usuario_nuevo'@'localhost' IDENTIFIED BY 'contraseña';
GRANT ALL PRIVILEGES ON casofutbol.* TO 'usuario_nuevo'@'localhost';
FLUSH PRIVILEGES;

USE casofutbol;
SHOW TABLES;
SELECT * FROM Presidente;
SELECT * FROM Equipo;
SELECT * FROM Jugador;
SELECT * FROM Partido;
SELECT * FROM Gol;


