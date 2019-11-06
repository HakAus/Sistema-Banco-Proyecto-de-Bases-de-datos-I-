USE [Sistema_Banco]
GO

/****** Object:  StoredProcedure [dbo].[SP_GetMovimientosDeEstadoCuenta]    Script Date: 11/5/2019 6:29:52 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author:		<Austin Hakanson>
-- Create date: <03-11-2019>
-- Description:	<SP para obtener los movimientos de un estado de cuenta>
-- =============================================
CREATE OR ALTER PROCEDURE [dbo].[SP_GetMovimientosDeEstadoCuenta] 
	
	-- Parametros
	@FechaInicio date,
	@FechaFin date,
	@Numero_Cuenta nvarchar(50)

AS
BEGIN

	SET NOCOUNT ON;

    -- Insert statements for procedure here
	SELECT CA.Numero_Cuenta, M.Tipo_Movimiento, M.Monto, M.NuevoSaldo, M.Descripcion
	FROM Movimiento M
	INNER JOIN Cuenta_Ahorro CA ON CA.id = M.idCuenta
	WHERE M.Fecha >= @FechaInicio and M.Fecha < @FechaFin and CA.Numero_Cuenta = @Numero_Cuenta
END
GO

