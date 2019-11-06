USE [Sistema_Banco]
GO

/****** Object:  StoredProcedure [dbo].[CASP_InicioSesion]    Script Date: 11/5/2019 6:29:03 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author:		<Austin Hakanson>
-- Create date: <7-09-2019>
-- Description:	<Validacion de inicio de sesion>
-- =============================================
CREATE OR ALTER PROCEDURE [dbo].[CASP_InicioSesion] 
	-- Add the parameters for the stored procedure here
	@Usuario nvarchar(100),
	@Clave nvarchar(100)
AS
BEGIN
	DECLARE @id int
	SET NOCOUNT ON

	BEGIN TRY

		IF @Usuario = ''
		BEGIN
			SET @Usuario = ' '
			return -100001
		END

		IF @Clave = ''
		BEGIN
			SET @Clave = ' '
			return -100002
		END
		

		IF EXISTS(
		SELECT C.id
		FROM Cliente C, CuentaAhorro CA
		WHERE C.Usuario = @Usuario and C.Contrasenia = @Clave and (CA.idCliente = C.id)
		)
		BEGIN
			return 1
		END
		ELSE
			BEGIN
				return 2
			END
	END TRY

	BEGIN CATCH
		return @@ERROR * -1
	END CATCH
END
GO

