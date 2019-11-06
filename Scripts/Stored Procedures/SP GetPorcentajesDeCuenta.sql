USE [Sistema_Banco]
GO

/****** Object:  StoredProcedure [dbo].[CASP_GetPorcentajesDeCuenta]    Script Date: 11/5/2019 6:28:43 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author:		<Austin Hakanson>
-- Create date: <27/09/2019>
-- Description:	<SP para obtener la suma de porcentajes de beneficio de los beneficiarios de una cuenta>
-- =============================================
CREATE OR ALTER PROCEDURE [dbo].[CASP_GetPorcentajesDeCuenta] 
	-- Parametros
	@NumeroCuenta nvarchar(50)

AS
BEGIN

	SET NOCOUNT ON;

	SELECT SUM(B.Porcentaje)
	FROM dbo.Beneficiario B
	WHERE B.Numero_Cuenta = @NumeroCuenta
   
END
GO

