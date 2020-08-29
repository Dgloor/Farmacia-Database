use g1;
-- datos necesarios solicitante bodeguero juestificativo medicina n_seri fecha_caducidad cantidad
DROP PROCEDURE IF EXISTS RegistrarIngreso;
DELIMITER ||

CREATE PROCEDURE RegistrarIngreso ( in solicitante varchar(12) , in bodeguero varchar(12), in Justificativo varchar(100), in medicina int, in nSerie int , in caducidad date, in cantidad int )
begin
	start transaction;
		INSERT INTO Registro(id_bodeguero,fecha_solicitud,justificativo) values (bodeguero, date(now()),Justificativo);
        INSERT INTO Ingreso(id_ingreso,id_admin_bodega) values ((select max(id_registro) from Registro),solicitante);
        INSERT INTO Unidad_Medicamento(id_medicamento,numero_serie,fecha_caducidad) values (medicina,nSerie,caducidad);
        INSERT INTO Ingreso_Bodega_Unidad(id_ingreso,numero_serie,cantidad ) values ((select max(id_ingreso) from Ingreso),nSerie,cantidad);
        FLUSH TABLES;
	commit;
end ||
DELIMITER ;
