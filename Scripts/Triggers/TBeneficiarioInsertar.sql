USE [Sistema_Banco]
GO
/****** Object:  Trigger [dbo].[BeneficiariosActualizados]    Script Date: 11/4/2019 9:44:27 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Antony Artavia Palma>
-- Create date: <12/10/2019>
-- Description:	<Trigger para crear un evento>
-- =============================================
ALTER TRIGGER  [dbo].[BeneficiariosActualizados] ON [dbo].[Beneficiario]
   AFTER UPDATE
AS 
BEGIN

	SET NOCOUNT ON;

	declare @Numero_de_Cuenta nvarchar(50);  --Numero cuenta para buscar el idUsuario
	declare @TipoEvento nvarchar(100);
	declare @ActivoDespues int;
	declare @ActivoAntes int;

    declare @idUsuario int;    --El id del usuario
	declare @Fecha date = GETDATE();
	declare @idTipoEvento int;   --El id del tipo evento
	declare @IP int = 0;			--valor dummy
	declare @XMLAntes xml;
	declare @XMLDespues xml;

	Select @Numero_de_Cuenta = ActBen.Numero_Cuenta		--Determina NumeroCuenta y idTipoEvento				--Viejo Activo
	from inserted ActBen

	Select @idUsuario = CA.idCliente from Cuenta_Ahorro CA where CA.Numero_Cuenta = @Numero_de_Cuenta;  --Id del usuario

	declare @TablaXml TABLE (  --Tabla variable para sacar XML del evento
		id int NOT NULL,
		idPersona int NOT NULL,

		idTipoID int NOT NULL,			--De la tabla persona
		Nombre nvarchar(100) NOT NULL,
		Tipo_Documento_Identificacion nvarchar(100) NOT NULL,
		Documento_Identificacion nvarchar(100) NOT NULL,
		Telefono1 int NOT NULL,
		Telefono2 int NOT NULL,
		Email nvarchar(100) NOT NULL,
		Fecha_Nacimiento date NOT NULL,

		idParentesco int NOT NULL,
		Parentesco nvarchar(3) NOT NULL,
		Porcentaje int NOT NULL,
		Activo int NOT NULL,
		Fecha_Desactivacion date NULL,
		Numero_Cuenta nvarchar(100) NOT NULL
	)
	
	select @ActivoAntes = ActBen.Activo from deleted ActBen			--Nuevo Activo
	select @ActivoDespues = ActBen.Activo from inserted ActBen			--Nuevo Activo

	--Actua dependiendo si fue una desactivacion o solo una modificacion
	if(@ActivoDespues = 0 and @ActivoAntes != @ActivoDespues)		
		BEGIN			--Para la modificacion de un evento
		
			insert into @TablaXml  --Insercion del Evento en tabla variable
			select  newBen.id, newBen.idPersona, P.idTipoID, P.Nombre,
					P.Tipo_Documento_Identificacion, P.Documento_Identificacion,
					P.Telefono1, P.Telefono2, P.Email, P.Fecha_Nacimiento,
					newBen.idParentesco, newBen.Parentesco,
					newBen.Porcentaje, newBen.Activo, newBen.Fecha_Desactivacion,
					newBen.Numero_Cuenta
			from inserted newBen, Persona P
			Where P.id = newBen.idPersona

			set @XMLAntes = NULL;
			set @XMLAntes = (Select * from @TablaXml as TablaXml for xml Auto, ELEMENTS XSINIL);  --XML del Evento

			set @TipoEvento = N'Eliminar Beneficiario';
			Select @idTipoEvento = TE.id from  TipoEvento TE where TE.nombre = @TipoEvento;		--idTipoEvento

			insert into Evento (idTipoEvento, idUser, _IP, Fecha, XMLAntes, XMLDespues)  --Insercion final al evento
			values(@idTipoEvento, @idUsuario, @IP, @Fecha, @XMLAntes, @XMLDespues);
		
		END
	ELSE
		BEGIN		--Para la modificacion de un evento
			
			insert into @TablaXml  --Insercion del Evento en tabla variable  ANTES
			select  newBen.id, newBen.idPersona, P.idTipoID, P.Nombre,
					P.Tipo_Documento_Identificacion, P.Documento_Identificacion,
					P.Telefono1, P.Telefono2, P.Email, P.Fecha_Nacimiento,
					newBen.idParentesco, newBen.Parentesco,
					newBen.Porcentaje, newBen.Activo, newBen.Fecha_Desactivacion,
					newBen.Numero_Cuenta
			from deleted newBen, Persona P
			Where P.id = newBen.idPersona

			set @XMLAntes = (Select * from @TablaXml as TablaXml for xml Auto, ELEMENTS XSINIL);  --XML del Evento ANTES
			
			delete from @TablaXml;  --Limpia la tabla variable

			insert into @TablaXml  --Insercion del Evento en tabla variable  DESPUES
			select  newBen.id, newBen.idPersona, P.idTipoID, P.Nombre,
					P.Tipo_Documento_Identificacion, P.Documento_Identificacion,
					P.Telefono1, P.Telefono2, P.Email, P.Fecha_Nacimiento,
					newBen.idParentesco, newBen.Parentesco,
					newBen.Porcentaje, newBen.Activo, newBen.Fecha_Desactivacion,
					newBen.Numero_Cuenta
			from inserted newBen, Persona P
			Where P.id = newBen.idPersona

			set @XMLDespues = (Select * from @TablaXml as TablaXml for xml Auto, ELEMENTS);  --XML del Evento DESPUES

			set @TipoEvento = N'Modificar Beneficiario';
			Select @idTipoEvento = TE.id from  TipoEvento TE where TE.nombre = @TipoEvento;		--idTipoEvento

			insert into Evento (idTipoEvento, idUser, _IP, Fecha, XMLAntes, XMLDespues)  --Insercion final al evento
			values(@idTipoEvento, @idUsuario, @IP, @Fecha, @XMLAntes, @XMLDespues);
		
		END

END
