USE [Sistema_Banco]
GO

/****** Object:  StoredProcedure [dbo].[CASP_EliminarBeneficiario]    Script Date: 11/5/2019 6:17:36 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author:		<Austin Hakanson>
-- Create date: <14-10-2019>
-- Description:	<SP para actualizar los datos de 1 usuario>
-- =============================================

CREATE OR ALTER PROCEDURE [dbo].[CASP_EliminarBeneficiario]

	-- Parametros del potencial NUEVO Beneficiario
	@Numero_Cuenta nvarchar(50),
	@Documento_Identificacion nvarchar(50)
AS
BEGIN

-- Se verifica que los parametros no vengan en NULL

	IF @Documento_Identificacion IS NULL
	BEGIN
		return -100001
	END

	IF @Numero_Cuenta IS NULL
	BEGIN
		return -100002
	END
	
	 -- Se valida que exista el estado de cuenta
	IF EXISTS (SELECT CA.id, P.id
			   FROM CuentaAhorro CA, Persona P
			   WHERE CA.Numero_Cuenta = @Numero_Cuenta and P.Documento_Identificacion = @Documento_Identificacion)
	BEGIN
		DECLARE @idPersona int = (SELECT P.id FROM Persona P WHERE P.Documento_Identificacion = @Documento_Identificacion)

		DELETE FROM Beneficiario
		WHERE idPersona = @idPersona

		DELETE FROM Persona
		WHERE Documento_Identificacion = @Documento_Identificacion

		
	END
	ELSE
	BEGIN
		return -100003 -- No se encontro una cuenta con el numero de cuenta suministrado o el Documento de identificacion es incorrecto
	END
END
GO

