USE [Sistema_Banco]
GO

/****** Object:  StoredProcedure [dbo].[CASP_GetBeneficiariosXNumCuenta]    Script Date: 11/5/2019 6:18:43 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE OR ALTER PROCEDURE [dbo].[CASP_GetBeneficiariosXNumCuenta]
	@NumeroCuenta nvarchar(50)
AS
BEGIN

	SET NOCOUNT ON;

	SELECT P.Nombre, PA.Detalle as Parentesco, B.Porcentaje, P.Tipo_Documento_Identificacion,
			P.Documento_Identificacion, P.Email, P.Telefono1, P.Telefono2,
			P.Fecha_Nacimiento
	FROM Parentesco PA, Beneficiario B
	INNER JOIN Persona P ON P.id = B.idPersona
	WHERE B.Numero_Cuenta = @NumeroCuenta and B.idParentesco = PA.id and B.Activo = 1
END
GO

