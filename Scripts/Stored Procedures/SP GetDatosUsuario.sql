USE [Sistema_Banco]
GO

/****** Object:  StoredProcedure [dbo].[CASP_GetDatosUsuario]    Script Date: 11/5/2019 6:19:01 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author:		<Austin Hakanson>
-- Create date: <09-09-2019>
-- Description:	<Obtencion de datos de usuario>
-- =============================================
CREATE OR ALTER PROCEDURE [dbo].[CASP_GetDatosUsuario] 
	-- Add the parameters for the stored procedure here
	@Usuario nvarchar(100),
	@Clave nvarchar(100)
AS
BEGIN
	
	SET NOCOUNT ON

	BEGIN TRY

		IF @Usuario = ''
		BEGIN
			return -100001
		END

		IF @Clave = ''
		BEGIN
			return -100002
		END

		DECLARE @resultado INT
		-- SET NOCOUNT ON added to prevent extra result sets from
		-- interfering with SELECT statements.
		SET NOCOUNT ON;

		-- Insert statements for procedure here
	
		SELECT CA.Numero_Cuenta, P.Nombre
		FROM dbo.CuentaAhorro CA, dbo.Persona P
		INNER JOIN Cliente C ON C.idPersona = P.id
		WHERE (C.Usuario = @Usuario and C.Contrasenia = @Clave) and (CA.idCliente = C.id)
		
	END TRY

	BEGIN CATCH
		return @@ERROR * -1
	END CATCH
END
GO

