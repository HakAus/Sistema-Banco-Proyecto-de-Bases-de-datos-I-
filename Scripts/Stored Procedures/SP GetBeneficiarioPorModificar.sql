USE [Sistema_Banco]
GO

/****** Object:  StoredProcedure [dbo].[CASP_GetBeneficiarioPorModificar]    Script Date: 11/5/2019 6:18:13 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author:		<Austin Hakanson>
-- Create date: <07-10-2019>
-- Description:	<SP para obtener datos de beneficiario a modificar>
-- =============================================
CREATE OR ALTER PROCEDURE [dbo].[CASP_GetBeneficiarioPorModificar]
	-- Parametros
	@Numero_Cuenta nvarchar(50),
	@Documento_Identificacion nvarchar(50)
AS
BEGIN

	SET NOCOUNT ON;
    -- Insert statements for procedure here
	SELECT P.Nombre, PA.Detalle, B.Porcentaje, P.Tipo_Documento_Identificacion,
			P.Documento_Identificacion, P.Email, P.Telefono1, P.Telefono2, P.Fecha_Nacimiento
	FROM Parentesco PA, Beneficiario B
	INNER JOIN Persona P ON B.idPersona = P.id
	WHERE B.Numero_Cuenta = @Numero_Cuenta and P.Documento_Identificacion = @Documento_Identificacion
			and PA.Nombre = B.Parentesco
END
GO

