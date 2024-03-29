USE [Sistema_Banco]
GO
/****** Object:  Trigger [dbo].[COModificados]    Script Date: 11/4/2019 11:00:26 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Antony Artavia Palma>
-- Create date: <12/10/2019>
-- Description:	<Trigger para crear un evento>
-- =============================================
ALTER TRIGGER  [dbo].[COModificados] ON [dbo].[CuentaObjetivo]
   AFTER UPDATE
AS 
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

		--Variables para buscar id de otros elementos
    declare @TipoEvento nvarchar(100);
	declare @Numero_de_Cuenta nvarchar(50);				--Numero cuenta para buscar el idUsuario
	declare @ActivoAntes int;
	declare @ActivoDespues int;
		
		--Elementos para el nuevo elemento
	declare @idUsuario int;    --El id del usuario
	declare @Fecha date = GETDATE();
	declare @idTipoEvento int;   --El id del tipo evento
	declare @IP int = 0;
	declare @XMLAntes xml;
	declare @XMLDespues xml;

	Select @Numero_de_Cuenta = NewCO.Numero_Cuenta		--Determina NumeroCuenta y idTipoEvento
	from inserted NewCO

	Select @idUsuario = CA.idCliente		--Id del usuario
	from Cuenta_Ahorro CA 
	where CA.Numero_Cuenta = @Numero_de_Cuenta;  

	declare @TablaXml TABLE (  --Tabla variable para sacar XML del evento
		id int NOT NULL,
		idCuenta int NOT NULL,
		Saldo money NOT NULL,
		Fecha_Inicio date NOT NULL,
		Fecha_Final date NOT NULL,
		Monto_Ahorro money NOT NULL,
		Numero_Cuenta nvarchar(50) NOT NULL,
		Activo int
	)

	select @ActivoAntes = ActBen.Activo from deleted ActBen			--Nuevo Activo
	select @ActivoDespues = ActBen.Activo from inserted ActBen			--Nuevo Activo

	
	--Se valida la activacion o desacticavion
	if(@ActivoAntes != @ActivoDespues)
		BEGIN

			insert into @TablaXml  --Insercion del Evento en tabla variable
			select newCo.id, newCo.idCuenta, newCo.Saldo, newCo.Fecha_Inicio,
					newCo.Fecha_Final, newCo.Monto_Ahorro, newCo.Numero_Cuenta, newCo.Activo
			from deleted newCo

			set @XMLAntes = (Select * from @TablaXml as TablaXml for xml Auto, ELEMENTS XSINIL);  --XML del Evento

			set @TipoEvento = 'Eliminar CO';
			Select @idTipoEvento = TE.id from TipoEvento TE where TE.nombre = @TipoEvento

			insert into Evento (idTipoEvento, idUser, _IP, Fecha, XMLAntes, XMLDespues)  --Insercion final al evento
			values(@idTipoEvento, @idUsuario, @IP, @Fecha, @XMLAntes, @XMLDespues);
		END
	ELSE
		BEGIN
			insert into @TablaXml  --Insercion del Evento en tabla variable		ANTES
			select newCo.id, newCo.idCuenta, newCo.Saldo, newCo.Fecha_Inicio,
					newCo.Fecha_Final, newCo.Monto_Ahorro, newCo.Numero_Cuenta, newCo.Activo
			from deleted newCo

			set @XMLAntes = (Select * from @TablaXml as TablaXml for xml Auto, ELEMENTS XSINIL);  --XML del Evento

			delete from @TablaXml;   --Limpia la tabla variable

			insert into @TablaXml  --Insercion del Evento en tabla variable		DESPUES
			select newCo.id, newCo.idCuenta, newCo.Saldo, newCo.Fecha_Inicio,
					newCo.Fecha_Final, newCo.Monto_Ahorro, newCo.Numero_Cuenta, newCo.Activo
			from inserted newCo

			set @XMLDespues = (Select * from @TablaXml as TablaXml for xml Auto, ELEMENTS XSINIL);  --XML del Evento

			set @TipoEvento = N'Modificar CO';
			Select @idTipoEvento = TE.id from TipoEvento TE where TE.nombre = @TipoEvento

			insert into Evento (idTipoEvento, idUser, _IP, Fecha, XMLAntes, XMLDespues)  --Insercion final al evento
			values(@idTipoEvento, @idUsuario, @IP, @Fecha, @XMLAntes, @XMLDespues);
		END
END
