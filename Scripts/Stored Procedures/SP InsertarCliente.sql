USE [Sistema_Banco]
GO

/****** Object:  StoredProcedure [dbo].[CASP_InsertarCliente]    Script Date: 11/5/2019 6:29:34 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author:		<Antony Artavia Palma>
-- Create date: <10/10/2019>
-- Last Modificataion date: <11/10/2019> (Austin)
-- Description:	<SP para ingresar un nuevo usario (Cliente) en la BD>
-- =============================================
CREATE OR ALTER PROCEDURE [dbo].[CASP_InsertarCliente]
	-- Add the parameters for the stored procedure here
	@Fecha_Nacimiento date,
	@Usuario nvarchar(100),
	@Contrasenia nvarchar(100),
	@Tipo_Documento_Identificacion nvarchar(100),
	@Documento_Identificacion nvarchar(50),
	@Email nvarchar(100),
	@Telefono1 int,
	@Telefono2 int,
	@Nombre nvarchar(100)
	
AS
BEGIN
	SET NOCOUNT ON;

	BEGIN TRY
	
		-- Se verifica que los parametros no vengan nulos

		IF @Usuario = NULL
		BEGIN
			return -100001
		END
		
		IF @Contrasenia = NULL
		BEGIN
			return -100002
		END
		
		IF @Tipo_Documento_Identificacion = NULL
		BEGIN
			return -100003
		END

		IF @Documento_Identificacion = NULL
		BEGIN
			return -100004
		END

		IF @Email = NULL
		BEGIN
			return -100005
		END

		IF @Telefono1 = NULL
		BEGIN
			return -100006
		END

		IF @Telefono2 = NULL
		BEGIN
			return -100007
		END

		IF @Nombre = NULL
		BEGIN
			return -100008
		END

		-- Se verifica si ya existia el cliente en la base de datos
		IF EXISTS(SELECT *
					FROM Persona P
					WHERE P.Documento_Identificacion = @Documento_Identificacion)
			BEGIN
				return -100009 -- El Cliente ingresado ya existe
			END
		ELSE
			BEGIN
				INSERT INTO dbo.Persona
				SELECT TID.id, @Nombre, @Tipo_Documento_Identificacion,  @Documento_Identificacion,
					   @Telefono1, @Telefono2, @Email, @Fecha_Nacimiento
				FROM TipoID TID
				WHERE TID.Nombre = @Tipo_Documento_Identificacion

				-- Se guarda el id de la ultima persona agregada
				DECLARE @idAgregado int
				SELECT @idAgregado = max(P.id)
				FROM Persona P

				INSERT INTO dbo.Cliente
				SELECT @idAgregado, @Usuario, @Contrasenia
			END
	END TRY

	BEGIN CATCH
		return @@ERROR * -1
	END CATCH
END
GO

