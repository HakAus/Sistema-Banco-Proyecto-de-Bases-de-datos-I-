USE [Sistema_Banco]
GO
/****** Object:  Trigger [dbo].[COInsertados]    Script Date: 02/11/2019 15:19:15 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Antony Artavia Palma>
-- Create date: <12/10/2019>
-- Description:	<Trigger para crear un evento>
-- =============================================
CREATE TRIGGER  [dbo].[COInsertados] ON [dbo].[CuentaObjetivo]
   AFTER INSERT
AS 
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

		--Variables para buscar id de otros elementos
    declare @TipoEvento nvarchar(100) = N'Insertar CO';
	declare @Numero_de_Cuenta nvarchar(50);				--Numero cuenta para buscar el idUsuario
		
		--Elementos para el nuevo elemento
	declare @idUsuario int;    --El id del usuario
	declare @Fecha date = GETDATE();
	declare @idTipoEvento int;   --El id del tipo evento
	declare @IP int = 0;
	declare @XMLAntes xml;
	declare @XMLDespues xml;

	Select @Numero_de_Cuenta = NewCO.Numero_Cuenta,		--Determina NumeroCuenta y idTipoEvento
			@idTipoEvento = TE.id		
	from inserted NewCO, TipoEvento TE
	where TE.nombre = @TipoEvento;

	Select @idUsuario = CA.idCliente		--Id del usuario
	from Cuenta_Ahorro CA 
	where CA.Numero_Cuenta = @Numero_de_Cuenta;  

	
	declare @TablaXml TABLE (  --Tabla variable para sacar XML del evento
		id int NOT NULL,
		idCuenta int NOT NULL,
		Saldo money NOT NULL,
		Fecha_Inicio date NOT NULL,
		Fecha_Final date NOT NULL,
		Monto_Ahorro money NOT NULL,
		Numero_Cuenta nvarchar(50) NOT NULL
	)

	insert into @TablaXml  --Insercion del Evento en tabla variable
	select newCo.id, newCo.idCuenta, newCo.Saldo, newCo.Fecha_Inicio,
			newCo.Fecha_Final, newCo.Monto_Ahorro, newCo.Numero_Cuenta
	from inserted newCo

	set @XMLDespues = (Select * from @TablaXml as TablaXml for xml Auto, ELEMENTS XSINIL);  --XML del Evento

	insert into Evento (idTipoEvento, idUser, _IP, Fecha, XMLAntes, XMLDespues)  --Insercion final al evento
	values(@idTipoEvento, @idUsuario, @IP, @Fecha, @XMLAntes, @XMLDespues);

END
