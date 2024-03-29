USE [Sistema_Banco]
GO
/****** Object:  Trigger [dbo].[CrearPrimerEstadoCuenta]    Script Date: 11/2/2019 7:39:02 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Antony Artavia Palma>
-- Create date: <12/10/2019>
-- Description:	<Trigger para crear un estado cuenta>
-- =============================================
ALTER TRIGGER  [dbo].[CrearPrimerEstadoCuenta] ON [dbo].[Cuenta_Ahorro]
   AFTER INSERT
AS 
BEGIN

	SET NOCOUNT ON;

    declare @idCuenta int;
	declare @FechaInicio date;
	declare @FechaFin date;
	declare @SaldoInicial money;
	declare @NumCuenta nvarchar(50);

	Select @idCuenta = NewCA.id from inserted NewCA;
	Select @FechaInicio = NewCA.Fecha_Creacion from inserted NewCA;
	Set @FechaFin = DATEADD(MONTH, 1, @FechaInicio);
	Select @SaldoInicial = NewCA.Saldo from inserted NewCA;
	Select @NumCuenta = NewCA.Numero_Cuenta from inserted NewCA;

	------------------------------INSERCION---------------------------------------

	INSERT INTO dbo.EstadoCuenta(idCuenta, Fecha_Inicio, Fecha_Final, Saldo_Inicial, 
								Saldo_Final, Saldo_Minimo, Intereses, Numero_Cuenta, QRCH, QRCA)
	VALUES (@idCuenta, @FechaInicio, @FechaFin, @SaldoInicial, @SaldoInicial, @SaldoInicial, 0, @NumCuenta, 0,0)

END
