USE [Sistema_Banco]
GO

/****** Object:  StoredProcedure [dbo].[CASP_EstadosCuentaXNumCuenta]    Script Date: 11/5/2019 6:17:52 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author:		<Austin Hakanson>
-- Create date: <07-09-19>
-- Description:	<Se obtiene los estados de cuenta pasando un numero de cuenta como parametro>
-- =============================================
CREATE OR ALTER PROCEDURE [dbo].[CASP_EstadosCuentaXNumCuenta]  
	-- Add the parameters for the stored procedure here
	@NumeroCuenta nvarchar(50)
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;
    -- Insert statements for procedure here
	BEGIN TRY
		if @NumeroCuenta is null
			BEGIN
				return -100001
			END
		else
			BEGIN
			SELECT TOP (8) 
				EC.Fecha_Inicio, 
				EC.Fecha_Final,
			    EC.Saldo_Inicial,
		        EC.Saldo_Final,
				EC.Intereses
			FROM dbo.EstadoCuenta EC
			WHERE EC.Numero_Cuenta = @NumeroCuenta
			ORDER BY
				EC.Fecha_Inicio
			END
	END TRY
	BEGIN CATCH
		RETURN @@ERROR*-1
	END CATCH	   
END
GO

