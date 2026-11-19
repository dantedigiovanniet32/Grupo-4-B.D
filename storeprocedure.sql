DELIMITER //

CREATE PROCEDURE crear_jugador(
    IN nuevo_id INT,
    IN nuevo_nombre VARCHAR(3)
)
BEGIN
    INSERT INTO players (id_player, nombre)
    VALUES (nuevo_id, nuevo_nombre);
END //

DELIMITER ;
CALL crear_jugador(1, 'Vgt');
