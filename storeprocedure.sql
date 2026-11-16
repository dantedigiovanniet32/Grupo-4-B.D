DELIMITER //

create procedure sp_registrar_sesion(
    IN p_nombre_jugador VARCHAR(100),
    IN p_puntos_iniciales INT,
    IN p_inicio DATETIME,
    IN p_fin DATETIME,
    IN p_tiempo_supervivencia INT,
    IN p_dificultad VARCHAR(50)
)
begin
    declare v_id_player INT;

    SELECT id_player INTO v_id_player 
    FROM players 
    WHERE nombre = p_nombre_jugador;

    IF v_id_player IS NULL THEN
        INSERT INTO players(nombre, puntos) VALUES (p_nombre_jugador, p_puntos_iniciales);
        SET v_id_player = LAST_INSERT_ID();
    ELSE
        UPDATE players 
        SET puntos = GREATEST(puntos, p_puntos_iniciales) 
        WHERE id_player = v_id_player;
    END IF;

    INSERT INTO sessions(id_player, inicio, fin, tiempo_supervivencia, dificultad_inicial) 
    VALUES (v_id_player, p_inicio, p_fin, p_tiempo_supervivencia, p_dificultad);
    
    SELECT 'Sesión registrada correctamente' AS mensaje, v_id_player AS id_jugador, LAST_INSERT_ID() AS id_sesion;
END //

DELIMITER ;
