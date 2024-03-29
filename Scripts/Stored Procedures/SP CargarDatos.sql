USE [Sistema_Banco]
GO
/****** Object:  StoredProcedure [dbo].[CASP_CargarDatos]    Script Date: 10/11/2019 4:22:32 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Austin Hakanson>
-- Create date: <Revisar>
-- Last Modification date: <11-10-2019>
-- Description:	<SP para cargar datos de tablas [TipoID], [Parentesco], [TipoCuentaAhorro], [TipoMovimiento],[Moneda]>
-- =============================================
ALTER PROCEDURE [dbo].[CASP_CargarDatos]

AS
BEGIN
	SET NOCOUNT ON;

	BEGIN TRY
	
	-- Insercion del tipo de ID
		DECLARE @TipoIDXML xml
		SELECT @TipoIDXML = TID
		FROM OPENROWSET (Bulk '\\Mac\Home\Documents\Ing. Computación\IV Semestre\Bases de datos I\IITP\XML Simulacion\TipoID.xml',Single_BLOB) AS TipoID(TID)

		DECLARE @hdoc int

		EXEC sp_xml_preparedocument @hdoc OUTPUT, @TipoIDXML


		INSERT TipoID
		SELECT Nombre
		FROM OPENXML (@hdoc,'SistemaBanc/TipoID')
		WITH (
			Nombre nvarchar(100)'nombre'
			)

		EXEC sp_xml_removedocument @hdoc

	-- Insercion de la moneda
		
		DECLARE @MonedaXML xml

		SELECT @MonedaXML = M
		FROM OPENROWSET (BULK '\\Mac\Home\Documents\Ing. Computación\IV Semestre\Bases de datos I\IITP\XML Simulacion\Moneda.xml', SINGLE_BLOB) AS Moneda(M)

		EXEC sp_xml_preparedocument @hdoc OUTPUT, @MonedaXML

		INSERT Moneda
		SELECT Nombre, Simbolo
		FROM OPENXML (@hdoc, '/SistemaBanc/Moneda')
		WITH (
			Nombre nvarchar(50) 'nombre',
			Simbolo nvarchar(3) 'simbolo'
		)

		EXEC sp_xml_removedocument @hdoc

	-- Insercion de parentesco

		DECLARE @ParentescoXML xml

		SELECT @ParentescoXML = P
		FROM OPENROWSET (Bulk '\\Mac\Home\Documents\Ing. Computación\IV Semestre\Bases de datos I\IITP\XML Simulacion\Parentesco.xml', Single_BLOB) AS Parentesco(P)

		EXEC sp_xml_preparedocument @hdoc OUTPUT, @ParentescoXML

		INSERT Parentesco
		SELECT Nombre, Detalle
		FROM OPENXML (@hdoc, '/SistemaBanc/Parentesco')
		WITH (
			Nombre nvarchar(3) 'nombre',
			Detalle nvarchar(50) 'detalle'
		)

		EXEC sp_xml_removedocument @hdoc

	-- Insercion de Tipo de Cuenta de Ahorro

		DECLARE @TipoCuentaAhorroXML xml

		SELECT @TipoCuentaAhorroXML = TCA
		FROM OPENROWSET (Bulk '\\Mac\Home\Documents\Ing. Computación\IV Semestre\Bases de datos I\IITP\XML Simulacion\TipoCuentaAhorro.xml', Single_BLOB) AS TipoCuentaAhorro(TCA)

		EXEC sp_xml_preparedocument @hdoc OUTPUT, @TipoCuentaAhorroXML

		DECLARE @TipoCuentaAhorro_Temporal TABLE
		(
		nombre nvarchar(100),
		saldoMinimo money,
		multaSaldoMinimo money,
		cargosPorServicioMensual money,
		retiros int,
		simMoneda nvarchar(3),
		maxRetirosCajeroHumano int,
		multaIncumpleMaxRetirosCajeroHumano money,
		tasaIntereses int
		)

		INSERT INTO @TipoCuentaAhorro_Temporal
		SELECT nombre, saldoMinimo, multaSaldoMinimo, cargosPorServicioMensual, 
			   retiros, simMoneda, maxRetirosCajeroHumano, multaIncumpleMaxRetirosCajeroHumano, 
			   tasaIntereses
		FROM OPENXML(@hdoc, 'SistemaBanc/TipoCuentaAhorro')
		WITH(
		nombre nvarchar(100) 'nombre',
		saldoMinimo money 'saldoMinimo',
		multaSaldoMinimo money 'multaSaldoMinimo',
		cargosPorServicioMensual money 'cargosPorServicioMensual',
		retiros int 'retiros',
		simMoneda nvarchar(3) 'simMoneda',
		maxRetirosCajeroHumano int 'maxRetirosCajeroHumano',
		multaIncumpleMaxRetirosCajeroHumano money 'multaIncumpleMaxRetirosCajeroHumano',
		tasaIntereses int 'tasaIntereses'
		)
		
		INSERT INTO TipoCuentaAhorro
		SELECT M.id, T.nombre, T.saldoMinimo, T.multaSaldoMinimo, T.cargosPorServicioMensual,
			   T.retiros, T.maxRetirosCajeroHumano, T.multaIncumpleMaxRetirosCajeroHumano, T.tasaIntereses
		FROM Moneda M, @TipoCuentaAhorro_Temporal T
		WHERE M.Simbolo = T.simMoneda

		EXEC sp_xml_removedocument @hdoc

	-- Insercion de Tipo de Movimiento
		
		DECLARE @TipoMovimientoXML xml

		SELECT @TipoMovimientoXML = TM
		FROM OPENROWSET (Bulk '\\Mac\Home\Documents\Ing. Computación\IV Semestre\Bases de datos I\IITP\XML Simulacion\TipoMovimiento.xml', Single_BLOB) AS TipoMovimientoXML(TM)

		EXEC sp_xml_preparedocument @hdoc OUTPUT, @TipoMovimientoXML

		INSERT INTO TipoMovimiento
		SELECT Nombre, TipoDC
		FROM OPENXML(@hdoc, 'SistemaBanc/TipoMov')
		WITH(
		Nombre nvarchar(100) 'nombre',
		TipoDC char(1) 'tipoDC'
		)

		EXEC sp_xml_removedocument @hdoc

	END TRY

	BEGIN CATCH
		return @@ERROR * -1
	END CATCH
END
