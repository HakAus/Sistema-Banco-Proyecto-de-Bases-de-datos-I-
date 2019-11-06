USE [Sistema_Banco]
GO
/****** Object:  Trigger [dbo].[BeneficiariosInsertados]    Script Date: 02/11/2019 14:31:29 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Antony Artavia Palma>
-- Create date: <12/10/2019>
-- Description:	<Trigger para crear un evento>
-- =============================================
CREATE TRIGGER  [dbo].[BeneficiarioModificado] ON [dbo].[Persona]
   AFTER UPDATE
AS 
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

	declare @Numero_de_Cuenta nvarchar(50);  --Numero cuenta para buscar el idUsuario
	declare @TipoEvento nvarchar(100) = N'Modificar Beneficiario';
	declare @idBeneficario int;
	
    declare @idUsuario int;    --El id del usuario
	declare @Fecha date = GETDATE();
	declare @idTipoEvento int;   --El id del tipo evento
	declare @IP int = 0;
	declare @XMLAntes xml;
	declare @XMLDespues xml;

	Select @Numero_de_Cuenta = Ben.Numero_Cuenta, @idTipoEvento = TP.id		--Asigna el numero de cuenta
	from Beneficiario Ben, inserted	P, TipoEvento TP
	Where Ben.idPersona = P.id
	AND TP.nombre = @TipoEvento

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

	if EXISTS(Select * from Beneficiario Ben, inserted P where Ben.idPersona = P.id)
		BEGIN
			insert into @TablaXml  --Insercion del Evento en tabla variable  ANTES
			select  Ben.id, Ben.idPersona, P.idTipoID, P.Nombre,
					P.Tipo_Documento_Identificacion, P.Documento_Identificacion,
					P.Telefono1, P.Telefono2, P.Email, P.Fecha_Nacimiento,
					Ben.idParentesco, Ben.Parentesco,
					Ben.Porcentaje, Ben.Activo, Ben.Fecha_Desactivacion,
					Ben.Numero_Cuenta
			from deleted P, Beneficiario Ben
			Where Ben.idPersona = P.id

			set @XMLAntes = (Select * from @TablaXml as TablaXml for xml Auto, ELEMENTS XSINIL);  --XML del Evento

			delete from @TablaXml;  --Limpia la tabla variable

			insert into @TablaXml  --Insercion del Evento en tabla variable  DESPUES
			select  Ben.id, Ben.idPersona, P.idTipoID, P.Nombre,
					P.Tipo_Documento_Identificacion, P.Documento_Identificacion,
					P.Telefono1, P.Telefono2, P.Email, P.Fecha_Nacimiento,
					Ben.idParentesco, Ben.Parentesco,
					Ben.Porcentaje, Ben.Activo, Ben.Fecha_Desactivacion,
					Ben.Numero_Cuenta
			from inserted P, Beneficiario Ben
			Where Ben.idPersona = P.id

			set @XMLDespues = (Select * from @TablaXml as TablaXml for xml Auto, ELEMENTS XSINIL);  --XML del Evento

			insert into Evento (idTipoEvento, idUser, _IP, Fecha, XMLAntes, XMLDespues)  --Insercion final al evento
			values(@idTipoEvento, @idUsuario, @IP, @Fecha, @XMLAntes, @XMLDespues);
		END

END
