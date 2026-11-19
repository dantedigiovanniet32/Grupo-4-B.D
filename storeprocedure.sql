delimiter //

create procedure evasion(
in id_type int,
in tamanio varchar(50),
in velocidad_base float,
in sprite varchar(100),
in puntos_evasion int
)
begin
    insert into asteroidstypes (id_type, tamanio, velocidad_base, sprite, puntos_evasion) 
    values (id_type, tamanio, velocidad_base, sprite, puntos_evasion);
end //

delimiter ;
   
call evasion(1,"soygrande", 150.89, "spr_aster_big", 18000);
