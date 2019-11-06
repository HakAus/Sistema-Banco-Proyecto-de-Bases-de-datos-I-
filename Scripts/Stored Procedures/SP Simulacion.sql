USE [Sistema_Banco]
GO

/****** Object:  StoredProcedure [dbo].[SP_Simulacion]    Script Date: 11/5/2019 6:30:02 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author:		<Austin Hakanson>
-- Create date: <10/11/2019>
-- Description:	<SP para hacer la simulacion de actividades>
-- =============================================
CREATE OR ALTER PROCEDURE [dbo].[SP_Simulacion]

AS
BEGIN
	
	SET NOCOUNT ON

	-- Se declara una tabla variable para cargar las fechas de operacion
	DECLARE @Fechas TABLE
	(
	id int primary key identity(1,1),
	fecha date
	)

	DECLARE @DocHandle int, @XmlDocument xml 

	-- Se cargan los datos del XML a la variable XML
	SELECT @XmlDocument = F
	FROM OPENROWSET (Bulk '\\Mac\Home\Documents\Ing. Computación\IV Semestre\Bases de datos I\IIITP\Simulacion.xml',Single_BLOB) AS Fechas(F)
	-- Create an internal representation of the XML document.  
	EXEC sp_xml_preparedocument @DocHandle OUTPUT, @XmlDocument  
	-- Execute a SELECT statement using OPENXML rowset provider.  
	INSERT INTO @Fechas
	SELECT fecha 
	FROM OPENXML (@DocHandle, '/xml/Simulacion/FechaOperacion',1) -- El uno al final indica que la lectura es <atribute-centric> 
      WITH (fecha date)
	EXEC sp_xml_removedocument @DocHandle

	DECLARE @fechaIteracion date
	DECLARE @fechaFin date

	SELECT @fechaIteracion = min (F.fecha),
		   @fechaFin = max(F.fecha)
	FROM @Fechas F


	-- Se declaran tablas variable para almacenar temporalmente los datos
	DECLARE @Cliente TABLE
	(
	id int identity(1,1),
	Fecha_Nacimiento date,
	Tipo_Documento_Identificacion nvarchar(100),
	Documento_Identificacion nvarchar(100),
	Email nvarchar(100),
	Telefono1 int,
	Telefono2 int,
	Nombre nvarchar(100),
	Usuario nvarchar(100),
	Contrasenia nvarchar(100)
	)
	DECLARE @Cuentas TABLE
	(
	id int identity(1,1),
	Numero_Cuenta nvarchar(50),
	Saldo money,
	Cliente nvarchar(100),
	Tipo_Cuenta_Ahorro nvarchar(100),
	Fecha_Creacion date
	)
	DECLARE @BeneficiariosNuevos TABLE
	(
	id int identity(1,1),
	Nombre nvarchar(100),
	Parentesco nvarchar(3),
	Porcentaje int,
	Activo int,
	Fecha_Desactivacion date,
	Tipo_Documento_Identificacion nvarchar(100),
	Documento_Identificacion nvarchar(100),
	Email nvarchar(100),
	Telefono1 int,
	Telefono2 int,
	Numero_Cuenta nvarchar(100),
	Fecha_Nacimiento date
	)
	DECLARE @BeneficiariosExistentes TABLE
	(
	id int identity(1,1),
	Parentesco nvarchar(3),
	Porcentaje int,
	Activo int,
	Fecha_Desactivacion date,
	Documento_Identificacion nvarchar(100),
	NumeroCuenta nvarchar(100)
	)
	DECLARE @Movimientos TABLE
	(
	id int identity(1,1),
	NumeroCuenta nvarchar(100),
	Tipo_Movimiento nvarchar(100),
	Fecha date,
	Monto money,
	Descripcion nvarchar(100)
	)
	DECLARE @CuentasObjetivo TABLE
	(
	id int identity(1,1),
	NumeroDeCuenta nvarchar(50),
	FechaInicial date,
	FechaFinal date,
	DescripcionObjetivo nvarchar(100),
	MontoAhorrar money
	)

	-- Variables para los ciclos internos
	DECLARE @lo int
	DECLARE @hi int
	DECLARE @temp xml

	--Variable para llevar control de las transacciones 
	DECLARE @InicioTran int = 0

	-- Variables para el procesamiento de beneficiarios existentes
	DECLARE @idPersona_BeneficiarioExistente int

	--Inicio de cambios en tablas correspondientes para los movimientos
	declare @tipo nvarchar(1)
	declare @tipoNombre nvarchar(50)
	declare @saldoNuevo int

	-- Actualizacion del saldo minimo en el estado de cuenta (Variables)
	DECLARE @idCuenta_Movimiento int
	DECLARE @idUltimoEC int
	DECLARE @saldoMinimoEC int

	-- Creacion de un nuevo estado de cuenta (Variables)
	-- Se crea una tabla para guardar las cuentas que necesitan cerrar estado de cuenta
	DECLARE @CuentasCerrarEC TABLE
	(sec INT IDENTITY(1,1),
		idCuenta INT
	)

	-- Declaracion de variables
		DECLARE @idCuentaCerrarEC int
		DECLARE @idUltimoEC_CuentaCerrar int
		DECLARE @saldoMinimoEC_Cerrar money
		DECLARE @QRCH_EC_Cerrar int
		DECLARE @idTCA_Cuenta_Cerrar int
		DECLARE @SaldoActual_CuentaCerrar money
		DECLARE @MaxRCH_Cuenta_Cerrar int
		DECLARE @SaldoMinimo_Segun_Tipo_Cuenta_Cerrar money
		DECLARE @Multa_MaxRCH_Cuenta_Cerrar money
		DECLARE @Multa_Saldo_Minimo_Cuenta_Cerrar money
		DECLARE @Cargos_Servicio_Cuenta_Cerrar money
		DECLARE @MontoIntereses money
		DECLARE @fechaInicioEC date
		DECLARE @fechaFinalEC date
		DECLARE @fechaUltimoEstadoCuenta date
		DECLARE @NumCuenta_NuevoEC nvarchar(100)

	-- Variables para la acreditacion de las cuentas objetivo 
		DECLARE @Monto_Ahorro money
		DECLARE @Numero_Cuenta_CO nvarchar(50)
		DECLARE @SaldoCuenta_Debitar money
		DECLARE @Fecha_Ultimo_Credito date
		DECLARE @Fecha_Final_CO date

	WHILE @fechaIteracion <= @fechaFin
	BEGIN
	
		-- Se cargan todos los datos del XML en @XmlDocument
		SELECT @XmlDocument = C
		FROM OPENROWSET (Bulk '\\Mac\Home\Documents\Ing. Computación\IV Semestre\Bases de datos I\IIITP\Simulacion.xml',Single_BLOB) AS Clientes(C)

		-- Se cargan en @temp los datos XML de la fecha @fechaIteracion
		SET @temp = (select @XmlDocument.query('/xml/Simulacion/FechaOperacion[@fecha= sql:variable("@fechaIteracion")]'))
		
		-- Insercion de los clientes

		-- Se inicializa el contador de @Cliente en el id del ultimo registro
		SET @lo = (SELECT COUNT(C.id) FROM @Cliente C) + 1

		-- Se cargan en @Cliente los valores de los clientes dentro de la @fechaIteracion actual
		INSERT INTO @Cliente
		SELECT Tab.Col.value('(fechaNacimiento)[1]','date'),
			   Tab.Col.value('(tipoDocId)[1]','nvarchar(100)'),
			   Tab.Col.value('(docId)[1]','nvarchar(100)'),
			   Tab.Col.value('(email)[1]','nvarchar(100)'),
			   Tab.Col.value('(telefono1)[1]','int'),
			   Tab.Col.value('(telefono2)[1]','int'),
			   Tab.Col.value('(nombre)[1]','nvarchar(100)'),
			   Tab.Col.value('(usuario)[1]','nvarchar(100)'),
			   Tab.Col.value('(contrasenia)[1]','nvarchar(100)')
		FROM @temp.nodes('FechaOperacion/Cliente') Tab(Col)
		
		-- Se actualiza el fin del contador al ultimo registro agregado en @Cliente
		SET @hi = (SELECT COUNT(C.id) FROM @Cliente C)

		-- Ciclo para agregar cada cliente en las tablas Persona y Cliente
		BEGIN TRY
			IF @@TRANCOUNT = 0
			BEGIN
				SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
				BEGIN TRANSACTION AgregarCliente
				SET @InicioTran = 1
			END
		
			WHILE @lo <= @hi 
			BEGIN
				-- Se agregan primero los datos correspondientes a la tabla Persona
				INSERT INTO dbo.Persona
				SELECT TID.id, C.Nombre, C.Tipo_Documento_Identificacion,  C.Documento_Identificacion,
					   C.Telefono1, C.Telefono2, C.Email, C.Fecha_Nacimiento
				FROM TipoID TID, @Cliente C
				WHERE TID.Nombre = C.Tipo_Documento_Identificacion and C.id = @lo
					 and NOT EXISTS (SELECT * FROM Persona WHERE Documento_Identificacion = C.Documento_Identificacion) -- Se valida que no se ingresen repetidos
			
				-- Se agregan luego los datos correspondientes a la tabla Cliente
				INSERT INTO Cliente (idPersona, Usuario, Contrasenia)
				SELECT P.id, C.Usuario, C.Contrasenia
				FROM @Cliente C
				INNER JOIN Persona P ON C.Documento_Identificacion = P.Documento_Identificacion
				WHERE C.id = @lo  and NOT EXISTS (SELECT * FROM Cliente WHERE idPersona = P.id) -- Se valida que no se ingresen repetidos

				-- Se aumenta 1 en el contador
				SET @lo = @lo + 1
			END
		
			IF @InicioTran = 1
			BEGIN
				COMMIT TRANSACTION AgregarCliente
				SET @InicioTran = 0
			END
		END TRY
		BEGIN CATCH
			IF (@InicioTran = 1)
			BEGIN
				ROLLBACK TRANSACTION AgregarCliente
				SELECT 'Hubo un error al agregar los clientes'
				return -100001
			END
		END CATCH
	
		 -- Insercion de Cuentas

		-- Se inicializa el contador de @Cuentas en el id del ultimo registro
		SET @lo = (SELECT COUNT(C.Numero_Cuenta) FROM @Cuentas C) + 1

		-- Se cargan en @Cuentas los valores de los clientes dentro de la @fechaIteracion actual
		INSERT INTO @Cuentas
		SELECT Tab.Col.value('(numCuenta)[1]','nvarchar(100)'),
			   Tab.Col.value('(saldo)[1]','int'),
			   Tab.Col.value('(cliente)[1]','nvarchar(100)'),
			   Tab.Col.value('(tipoCuentaAhorro)[1]','nvarchar(100)'),
			   Tab.Col.value('(fechaCreacion)[1]','date')
		FROM @temp.nodes('FechaOperacion/Cuenta') Tab(Col)

		-- Se actualiza el fin del contador al ultimo registro agregado en @Cuentas
		SET @hi = (SELECT COUNT(C.Numero_Cuenta) FROM @Cuentas C)

		-- Ciclo para agregar cada cuenta en la tabla CuentaAhorro
		BEGIN TRY
			IF @@TRANCOUNT = 0
			BEGIN
				SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
				BEGIN TRANSACTION AgregarCuenta
				SET @InicioTran = 1
			END
			WHILE @lo <= @hi
			BEGIN 
				
				IF NOT EXISTS (SELECT CA.id FROM @Cuentas C, Cuenta_Ahorro CA WHERE C.id = @lo and CA.Numero_Cuenta = C.Numero_Cuenta)
				BEGIN
					INSERT INTO dbo.Cuenta_Ahorro (idTipoCuentaAhorro, idCliente, Numero_Cuenta, Saldo, Fecha_Creacion)
					SELECT TCA.id, CL.id, C.Numero_Cuenta, C.Saldo, C.Fecha_Creacion 
					FROM @Cuentas C
					INNER JOIN TipoCuentaAhorro TCA ON TCA.Nombre = C.Tipo_Cuenta_Ahorro
					INNER JOIN Cliente CL ON CL.idPersona = (SELECT P.id FROM Persona P WHERE P.Documento_Identificacion = C.Cliente) 
					WHERE C.id = @lo and NOT EXISTS (SELECT CA.id FROM Cuenta_Ahorro CA WHERE CA.Numero_Cuenta = C.Numero_Cuenta)
				END
				ELSE
				BEGIN
					SELECT 'Esta repetido' as Descripcion, CA.id, CA.Numero_Cuenta FROM @Cuentas C,Cuenta_Ahorro CA WHERE C.id = @lo and CA.Numero_Cuenta = C.Numero_Cuenta
				END
				SET @lo = @lo + 1
			END

			IF @InicioTran = 1
			BEGIN
				COMMIT TRANSACTION AgregarCuenta
				SET @InicioTran = 0
			END

		END TRY
		BEGIN CATCH
			IF @InicioTran = 1
			BEGIN
				ROLLBACK TRANSACTION AgregarCuenta
				SELECT 'Hubo un error al agregar las cuentas'
				Return -100002
			END
		END CATCH
		

		 -- Insercion de Beneficiaros Nuevos

		SET @lo = (SELECT COUNT(B.Documento_Identificacion) FROM @BeneficiariosNuevos B) + 1

		INSERT INTO @BeneficiariosNuevos
		SELECT Tab.Col.value('(nombre)[1]','nvarchar(100)'),
			   Tab.Col.value('(parentesco)[1]','nvarchar(3)'),
			   Tab.Col.value('(porcentaje)[1]','int'),
			   Tab.Col.value('(activo)[1]','int'),
			   Tab.Col.value('(fechaDesactivo)[1]','date'),
			   Tab.Col.value('(tipoDocId)[1]','nvarchar(100)'),
			   Tab.Col.value('(docId)[1]','nvarchar(100)'),
			   Tab.Col.value('(email)[1]','nvarchar(100)'),
			   Tab.Col.value('(telefono1)[1]','int'),
			   Tab.Col.value('(telefono2)[1]','int'),
			   Tab.Col.value('(numCuenta)[1]','nvarchar(100)'),
			   Tab.Col.value('(fechaNacimiento)[1]','date')
		FROM @temp.nodes('FechaOperacion/BeneficiarioNuevo') Tab(Col)

		SET @hi = (SELECT COUNT(B.Documento_Identificacion) FROM @BeneficiariosNuevos B)

		BEGIN TRY
			IF @@TRANCOUNT = 0
			BEGIN
				SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
				BEGIN TRANSACTION AgregarBeneficiarioNuevo
				SET @InicioTran = 1
			END

			WHILE @lo <= @hi
			BEGIN 
				-- Se debe verificar que no entren cedulas repetidas

				IF (SELECT COUNT(BE.Documento_Identificacion) 
					FROM @BeneficiariosNuevos BE 
					WHERE BE.Documento_Identificacion = (SELECT B.Documento_Identificacion FROM @BeneficiariosNuevos B WHERE B.id = @lo)) <=1
				BEGIN

					INSERT INTO dbo.Persona
					SELECT TID.id, B.Nombre, B.Tipo_Documento_Identificacion,  B.Documento_Identificacion,
						   B.Telefono1, B.Telefono2, B.Email, B.Fecha_Nacimiento
					FROM TipoID TID, @BeneficiariosNuevos B
					WHERE TID.Nombre = B.Tipo_Documento_Identificacion and B.id = @lo
						 and NOT EXISTS (SELECT * FROM Persona WHERE Documento_Identificacion = B.Documento_Identificacion)

					INSERT INTO Beneficiario
					SELECT P.id, PA.id, B.Parentesco, B.Porcentaje, B.Activo, B.Fecha_Desactivacion, B.Numero_Cuenta
					FROM @BeneficiariosNuevos B
					INNER JOIN Persona P ON B.Documento_Identificacion = P.Documento_Identificacion
					INNER JOIN Parentesco PA ON PA.Nombre = B.Parentesco 
					WHERE B.id = @lo and NOT EXISTS (SELECT * FROM Beneficiario WHERE idPersona = P.id)
				END
				--ELSE
				--BEGIN
				--	SELECT 'Caso de beneficiario nuevo repetido'
				--END

				SET @lo = @lo + 1
			END

			IF @InicioTran = 1
			BEGIN
				COMMIT TRANSACTION AgregarBeneficiarioNuevo
				SET @InicioTran = 0
			END

		END TRY
		BEGIN CATCH
			IF @InicioTran = 1
			BEGIN
				ROLLBACK TRANSACTION AgregarBeneficiarioNuevo
				SELECT 'Hubo un error al agregar los beneficiarios nuevos'
				Return -100003
			END
		END CATCH

		 --Actualizacion de beneficiarios existentes
		SET @lo = (SELECT COUNT(B.Documento_Identificacion) FROM @BeneficiariosExistentes B) + 1

		INSERT INTO @BeneficiariosExistentes
		SELECT Tab.Col.value('(parentesco)[1]','nvarchar(3)'),
			   Tab.Col.value('(porcentaje)[1]','int'),
			   Tab.Col.value('(activo)[1]','int'),
			   Tab.Col.value('(fechaDesactivo)[1]','date'),
			   Tab.Col.value('(docId)[1]','nvarchar(100)'),
			   Tab.Col.value('(numCuenta)[1]','nvarchar(100)')
		FROM @temp.nodes('FechaOperacion/BeneficiarioExistente') Tab(Col)

		SET @hi = (SELECT COUNT(B.Documento_Identificacion) FROM @BeneficiariosExistentes B)

		BEGIN TRY
			IF @@TRANCOUNT = 0
			BEGIN
				SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
				BEGIN TRANSACTION AgregarBeneficiarioExistente
				SET @InicioTran = 1
			END

			WHILE @lo <= @hi
			BEGIN 
				-- Primero se verifica si existe el beneficiario antes de actualizarlo

				-- Se selecciona el idPersona correspondiente al Documento de Identidad de la fila @lo en @BeneficiariosExistentes
				SELECT @idPersona_BeneficiarioExistente = P.id
				FROM Persona P
				WHERE P.Documento_Identificacion = (SELECT B.Documento_Identificacion FROM @BeneficiariosExistentes B WHERE B.id = @lo)

				SELECT B.Documento_Identificacion as DocIdParaActualizar FROM @BeneficiariosExistentes B WHERE B.id = @lo
				SELECT B.idPersona as IdPersonasEnBeneficiario FROM Beneficiario B 

				IF EXISTS(SELECT B.id FROM Beneficiario B WHERE B.idPersona = @idPersona_BeneficiarioExistente and B.Numero_Cuenta = (SELECT B.NumeroCuenta FROM @BeneficiariosExistentes B WHERE B.id = @lo))
				BEGIN
					select 'va a actualizar el caso de luis'
					-- Se selecciona el id de la persona con el documento de identificacion de la tabla BeneficiariosExistentes en la fila @lo

					UPDATE dbo.Beneficiario
					SET idParentesco = (SELECT PA.id FROM Parentesco PA WHERE PA.Nombre = BE.Parentesco),
						Parentesco = BE.Parentesco,
						Porcentaje = BE.Porcentaje
					FROM @BeneficiariosExistentes BE
					WHERE idPersona = @idPersona_BeneficiarioExistente and Numero_Cuenta = BE.NumeroCuenta

				END
				
				SET @lo = @lo + 1
			END

			IF @InicioTran = 1
			BEGIN
				COMMIT TRANSACTION AgregarBeneficiarioExistente
				SET @InicioTran = 0
			END
		END TRY
		BEGIN CATCH
			IF @InicioTran = 1
			BEGIN
				ROLLBACK TRANSACTION AgregarBeneficiarioExistente
				SELECT 'Hubo un error al modificar los beneficiarios existentes'
				Return -100004
			END
		END CATCH

		 -- Insercion de movimientos

		SET @lo = (SELECT COUNT(M.id) FROM @Movimientos M) + 1

		INSERT INTO @Movimientos
		SELECT Tab.Col.value('(numCuenta)[1]','nvarchar(100)'),
			   Tab.Col.value('(tipoMovimiento)[1]','nvarchar(100)'),
			   Tab.Col.value('(fecha)[1]','date'),
			   Tab.Col.value('(monto)[1]','int'),
			   Tab.Col.value('(descripcion)[1]','nvarchar(100)')
		FROM @temp.nodes('FechaOperacion/Movimiento') Tab(Col)

		SET @hi = (SELECT COUNT(M.id) FROM @Movimientos M)
		
		BEGIN TRY
			IF @@TRANCOUNT = 0
			BEGIN
				SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
				BEGIN TRANSACTION AgregarMovimientos
				SET @InicioTran = 1
			END

			WHILE @lo <= @hi
			BEGIN 
				set @tipo = (select TM.TipoDC from TipoMovimiento TM, @Movimientos M where TM.Nombre = M.Tipo_Movimiento 
									and M.id = @lo)
				set @tipoNombre = (select M.Tipo_Movimiento from @Movimientos M where M.id = @lo)

				IF (@tipo = 'C')
					BEGIN
						Update Cuenta_Ahorro
						Set Saldo = Saldo + M.Monto
						From @Movimientos M
						Where Numero_Cuenta = M.NumeroCuenta and M.id = @lo
					END
				ELSE
					BEGIN
			
						if(
							(select CA.Saldo 
							from Cuenta_Ahorro CA, @Movimientos M
							where CA.Numero_Cuenta = M.NumeroCuenta and M.id = @lo)
							< 
							(select abs(M.Monto)
							 from @Movimientos M
							 where M.id = @lo)
							 )
					   
							BEGIN
								Update Cuenta_Ahorro set Saldo = 0
								From @Movimientos M
								Where Numero_Cuenta = M.NumeroCuenta and M.id = @lo

							END
						ELSE
							BEGIN
								Update Cuenta_Ahorro 
								set Saldo = Saldo + M.Monto
								From @Movimientos M
								Where Numero_Cuenta = M.NumeroCuenta and M.id = @lo


							END
					END
		
					SET @saldoNuevo = (SELECT CA.Saldo 
									  FROM Cuenta_Ahorro CA 
									  INNER JOIN @Movimientos M ON CA.Numero_Cuenta = M.NumeroCuenta 
									  WHERE M.id = @lo) 

					--Insercion del nuevo movimiento
					INSERT dbo.Movimiento
					SELECT CA.id, TM.id, M.Tipo_Movimiento,
							M.Fecha, M.Monto, @saldoNuevo, M.Descripcion
					FROM @Movimientos M
					INNER JOIN Cuenta_Ahorro CA ON CA.Numero_Cuenta = M.NumeroCuenta 
					INNER JOIN TipoMovimiento TM ON TM.Nombre = M.Tipo_Movimiento
					WHERE M.id = @lo

					-- Actualizacion del saldo minimo en Estado de cuenta

					-- Se obtiene el id de la cuenta donde se hizo el movimiento
					SELECT @idCuenta_Movimiento = CA.id
					FROM Cuenta_Ahorro CA
					INNER JOIN @Movimientos M ON CA.Numero_Cuenta = M.NumeroCuenta
					WHERE M.id = @lo

					-- Se obtiene el id del ultimo estado de cuenta de la cuenta seleccionada
					SELECT @idUltimoEC = max(EC.id)
					FROM EstadoCuenta EC
					INNER JOIN @Movimientos M ON EC.Numero_Cuenta = M.NumeroCuenta
					WHERE M.id = @lo

					-- Se obtiene el saldo minimo del estado de cuenta con el id obtenido
					SELECT @saldoMinimoEC = EC.Saldo_Minimo
					FROM EstadoCuenta EC
					WHERE EC.id = @idUltimoEC
				
					-- Se verifica si el nuevo saldo es menor al saldo minimo en el estado de cuenta
					IF (@saldoNuevo < @saldoMinimoEC)
					BEGIN
						UPDATE EstadoCuenta
						SET Saldo_Minimo = @saldoNuevo,
							Saldo_Final = @saldoNuevo
						WHERE id = @idUltimoEC
					END
					ELSE
					BEGIN
						UPDATE EstadoCuenta
						SET Saldo_Final = @saldoNuevo
						WHERE id = @idUltimoEC
					END

					-- Se actualizan los contadores QRCH y QRCA
					IF (@tipoNombre = 'retiroCH')
					BEGIN
						UPDATE EstadoCuenta
						SET QRCH = QRCH + 1
						WHERE id = @idUltimoEC
					END
					IF (@tipoNombre = 'retiroCA')
					BEGIN
						UPDATE EstadoCuenta
						SET QRCA = QRCA + 1
						WHERE id = @idUltimoEC
					END

				SET @lo = @lo + 1
			END
			
			IF @InicioTran = 1
			BEGIN
				COMMIT TRANSACTION AgregarMovimientos
				SET @InicioTran = 0
			END

		END TRY
		BEGIN CATCH
			IF @InicioTran = 1
			BEGIN
				ROLLBACK TRANSACTION AgregarMovimientos
				SELECT 'Hubo un error al agregar los movimientos'
				Return -100005
			END
		END CATCH

		-- Procesamiento de cuentas objetivo

		-- Insercion de nuevas cuentas objetivo

		SET @lo = (SELECT COUNT(CO.id) FROM @CuentasObjetivo CO) + 1

		INSERT INTO @CuentasObjetivo
		SELECT Tab.Col.value('@NumeroDeCuenta','nvarchar(50)'),
			   @fechaIteracion,
			   Tab.Col.value('@FechaFinal','date'),
			   Tab.Col.value('@DescripcionObjetivo','nvarchar(100)'),
			   Tab.Col.value('@MontoAhorrar','money')
		FROM @temp.nodes('FechaOperacion/CO') Tab(Col)

		SET @hi = (SELECT COUNT(CO.id) FROM @CuentasObjetivo CO)

		BEGIN TRY
			IF @@TRANCOUNT = 0
			BEGIN
				SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
				BEGIN TRANSACTION AgregarCuentasObjetivo
				SET @InicioTran = 1
			END

			WHILE @lo <= @hi
			BEGIN 
				
				-- Se inserta cada cuenta objetivo leida desde el archivo xml para la fecha de operacion actual
				INSERT INTO CuentaObjetivo (idCuenta, Saldo, Fecha_Inicio, Fecha_Final, Fecha_Ultimo_Credito, Monto_Ahorro, Numero_Cuenta, Descripcion, Activo)
				SELECT CA.id, 0, CO.FechaInicial, CO.FechaFinal, DATEADD(MONTH,1,CO.FechaInicial), CO.MontoAhorrar, CO.NumeroDeCuenta, CO.DescripcionObjetivo, 1
				FROM @CuentasObjetivo CO
				INNER JOIN Cuenta_Ahorro CA ON CA.Numero_Cuenta = CO.NumeroDeCuenta
				WHERE CO.id = @lo

				SET @lo = @lo + 1

			END
			
			IF @InicioTran = 1
			BEGIN
				COMMIT TRANSACTION AgregarCuentasObjetivo
				SET @InicioTran = 0
			END

		END TRY
		BEGIN CATCH
			IF @InicioTran = 1
			BEGIN
				ROLLBACK TRANSACTION AgregarCuentasObjetivo
				SELECT 'Hubo un error al agregar las cuentas objetivo'
				Return -100006
			END
		END CATCH

		-- Procesar depositos en cuentas objetivo

		DECLARE @CuentasObjetivoPorAcreditar TABLE
		(
		sec int identity(1,1),
		idCuentaObjetivo int
		)

		IF EXISTS(SELECT CO.id FROM CuentaObjetivo CO WHERE CO.Fecha_Ultimo_Credito = @fechaIteracion and CO.Activo = 1)
		BEGIN

			SET @lo = (SELECT COUNT(CO.sec) FROM @CuentasObjetivoPorAcreditar CO ) + 1
			INSERT INTO @CuentasObjetivoPorAcreditar
			SELECT CO.id 
			FROM CuentaObjetivo CO 
			WHERE CO.Fecha_Ultimo_Credito = @fechaIteracion
			SET @hi = (SELECT COUNT(CO.sec) FROM @CuentasObjetivoPorAcreditar CO )

			BEGIN TRY 
			IF @@TRANCOUNT = 0
				BEGIN
					SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
					BEGIN TRANSACTION ProcesarCuentasObjetivo
					SET @InicioTran = 1
				END
				WHILE @lo <= @hi
				BEGIN
					-- Se acredita el monto a ahorrar a la cuenta objetivo correspondiente

					-- Se selecciona la fecha del ultimo credito y la fecha final

					SELECT @Fecha_Ultimo_Credito = CO.Fecha_Ultimo_Credito,
						   @Fecha_Final_CO = CO.Fecha_Final
					FROM CuentaObjetivo CO
					WHERE CO.id = (SELECT C.idCuentaObjetivo FROM @CuentasObjetivoPorAcreditar C WHERE C.sec = @lo)

					-- Se actualiza la fecha del ultimo credito mientras que sea menor a la fecha final de la cuenta objetivo
					IF (@Fecha_Ultimo_Credito < @Fecha_Final_CO)
					BEGIN 

						UPDATE CuentaObjetivo
						SET Saldo = (Saldo + Monto_Ahorro),
							Fecha_Ultimo_Credito = DATEADD(MONTH,1,Fecha_Ultimo_Credito)
						WHERE id = (SELECT C.idCuentaObjetivo FROM @CuentasObjetivoPorAcreditar C WHERE C.sec = @lo)
					END
					ELSE
					BEGIN
						UPDATE CuentaObjetivo
						SET Saldo = (Saldo + Monto_Ahorro)
						WHERE id = (SELECT C.idCuentaObjetivo FROM @CuentasObjetivoPorAcreditar C WHERE C.sec = @lo)

						-- Procesar redencion en cuentas objetivo

						IF (@Fecha_Ultimo_Credito = @Fecha_Final_CO)
						BEGIN	
							-- Se acredita la cuenta de ahorro 

							UPDATE Cuenta_Ahorro
							SET Saldo = Saldo + (SELECT CO.Saldo
										 FROM CuentaObjetivo CO
										 INNER JOIN @CuentasObjetivoPorAcreditar C ON CO.id = C.idCuentaObjetivo and C.sec = @lo)
							WHERE id = (SELECT CO.idCuenta
										FROM CuentaObjetivo CO
										INNER JOIN @CuentasObjetivoPorAcreditar C ON CO.id = C.idCuentaObjetivo and C.sec = @lo)

							-- Se debita la cuenta objetivo y se desactiva
							UPDATE CuentaObjetivo
							SET Saldo = 0,
								Activo = 0
							WHERE id = (SELECT C.idCuentaObjetivo FROM @CuentasObjetivoPorAcreditar C WHERE C.sec = @lo)
						END

					END

					-- Se debita el monto a ahorrar de la cuenta de ahorro

					-- Se seleccionan algunas variables que se necesitan para el proceso
					SELECT @Monto_Ahorro = CO.Monto_Ahorro,
						   @Numero_Cuenta_CO = CO.Numero_Cuenta
					FROM CuentaObjetivo CO
					INNER JOIN @CuentasObjetivoPorAcreditar C ON CO.id = C.idCuentaObjetivo and C.sec = @lo

					SELECT @SaldoCuenta_Debitar = CA.Saldo
					FROM Cuenta_Ahorro CA
					WHERE CA.Numero_Cuenta = @Numero_Cuenta_CO

					-- Se verifica primero si el saldo de la cuenta queda negativo al restar el monto de ahorro
					-- Si el saldo de la cuenta de ahorro no queda negativo se realiza la transaccion a la cuenta objetivo
					IF ((@SaldoCuenta_Debitar - @Monto_Ahorro) > 0)
					BEGIN
						UPDATE Cuenta_Ahorro 
						SET Saldo = Saldo - @Monto_Ahorro
						WHERE Numero_Cuenta = @Numero_Cuenta_CO

						-- Se registra en la tabla de movimientos de CO la transaccion
						INSERT INTO MovimientoCO
						SELECT CO.id, TCO.id, @fechaIteracion, CO.Monto_Ahorro, CO.Descripcion
						FROM @CuentasObjetivoPorAcreditar C 
						INNER JOIN CuentaObjetivo CO ON CO.id = C.idCuentaObjetivo
						INNER JOIN TipoMovimientoCO TCO ON TCO.Nombre = 'Depósito'
						WHERE C.sec = @lo
					END

					SET @lo = @lo + 1
				END

				IF (@InicioTran = 1)
					BEGIN
						COMMIT TRANSACTION ProcesarCuentasObjetivo
						SET @InicioTran = 0
					END
			END TRY
			BEGIN CATCH
				IF @InicioTran = 1
				BEGIN
					ROLLBACK TRANSACTION ProcesarCuentasObjetivo
					SELECT 'Hubo un error al procesar las cuentas objetivo'
					Return -100007
				END
			END CATCH
			
		END
	
		-- Proceso de cierre de estados de cuenta

		-- Se insertan en la tabla CuentasCerrarEC las cuentas donde la fecha final de su ultimo estado de cuenta es igual a la fecha de iteracion
		INSERT INTO @CuentasCerrarEC
		SELECT CA.id
		FROM Cuenta_Ahorro CA
		INNER JOIN EstadoCuenta EC ON CA.Numero_Cuenta = EC.Numero_Cuenta
		WHERE EC.Fecha_Final = @fechaIteracion
		
		SET @lo = (SELECT min(C.sec) from @CuentasCerrarEC C)
		SET @hi = (SELECT max(C.sec) from @CuentasCerrarEC C)

		BEGIN TRY 
			IF @@TRANCOUNT = 0
			BEGIN
				SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
				BEGIN TRANSACTION CrearNuevoEstadoDeCuenta
				SET @InicioTran = 1
			END

			WHILE @lo <= @hi
			BEGIN
				-- Se selecciona el id de la cuenta que debe ser procesada
				SELECT @idCuentaCerrarEC = C.idCuenta
				FROM @CuentasCerrarEC C
				WHERE C.sec = @lo 

				-- Se obtiene el id del ultimo estado de cuenta de la cuenta que esta siendo procesada
				SELECT @idUltimoEC_CuentaCerrar = max(EC.id)
				FROM EstadoCuenta EC
				WHERE EC.idCuenta = @idCuentaCerrarEC and EC.Fecha_Final = @fechaIteracion

				-- Se obtiene el saldo minimo mantenido durante la vigencia del ultimo estado de cuenta
				-- Se obtiene la cantidad de retiros en cajero humano hechos durante la vigencia del ultimo estado de cuenta
				SELECT @saldoMinimoEC_Cerrar = EC.Saldo_Minimo, 
					   @QRCH_EC_Cerrar = EC.QRCH
				FROM EstadoCuenta EC
				WHERE EC.idCuenta = @idCuentaCerrarEC and EC.Fecha_Final = @fechaIteracion

				-- Se obtiene el id del tipo de cuenta de la cuenta en iteracion
				-- Se obtiene el saldo actual de la cuenta en iteracion
				SELECT @idTCA_Cuenta_Cerrar = CA.idTipoCuentaAhorro,
					   @SaldoActual_CuentaCerrar = CA.Saldo
				FROM Cuenta_Ahorro CA
				WHERE CA.id = @idCuentaCerrarEC

				-- Se obtiene el maximo de retiros en cajero humano para el tipo de cuenta de la cuenta en iteracion
				-- Se obtiene el saldo minimo para el tipo de cuenta de la cuenta en iteracion
				-- Se obtiene la multa por exceder el maximo de retiros en cajero humano, segun el tipo de cuenta de la cuenta en iteracion
				-- Se obtiene la multa por incumplir el saldo minimo, segun el tipo de cuenta de la cuenta en iteracion
				-- Se obtiene los cargos de servicio segun el tipo de cuenta de la cuenta en iteracion
				-- Se calculan los intereses
				SELECT @MaxRCH_Cuenta_Cerrar = TCA.Maximo_Retiros_Cajero_Humano, 
					   @Multa_MaxRCH_Cuenta_Cerrar = TCA.Multa_Exceso_Retiros_Cajero,
					   @SaldoMinimo_Segun_Tipo_Cuenta_Cerrar = TCA.Saldo_Minimo,
					   @Multa_Saldo_Minimo_Cuenta_Cerrar = TCA.Multa_Saldo_Minimo,
					   @Cargos_Servicio_Cuenta_Cerrar = TCA.Monto_Mensual_Cargos_Servicio,
					   @MontoIntereses = (TCA.Tasa_Interes_Mensual * 0.01 * @saldoMinimoEC_Cerrar)/12
				FROM TipoCuentaAhorro TCA
				WHERE TCA.id = @idTCA_Cuenta_Cerrar

				-- Se acreditan los intereses al estado de cuenta que esta por cerrarse
				SET @SaldoActual_CuentaCerrar = @SaldoActual_CuentaCerrar + @MontoIntereses

				-- Si se excedio el maximo de retiros en cajero humano se aplica la multa correspondiente
				IF (@QRCH_EC_Cerrar > @MaxRCH_Cuenta_Cerrar)
				BEGIN
					SET @SaldoActual_CuentaCerrar = @SaldoActual_CuentaCerrar - @Multa_MaxRCH_Cuenta_Cerrar
				END

				-- Si se incumplio con el saldo minimo se aplica la multa correspondiente
				IF (@saldoMinimoEC_Cerrar < @SaldoMinimo_Segun_Tipo_Cuenta_Cerrar)
				BEGIN
					SET @SaldoActual_CuentaCerrar = @SaldoActual_CuentaCerrar - @Multa_MaxRCH_Cuenta_Cerrar
				END

				-- Si el saldo despues de aplicar los intereses y multas queda negativo, se deja en cero
				IF (@SaldoActual_CuentaCerrar < 0)
				BEGIN 
					SET @SaldoActual_CuentaCerrar = 0
				END

				UPDATE EstadoCuenta 
				SET Saldo_Final = @SaldoActual_CuentaCerrar,
					Intereses = @MontoIntereses
				WHERE id = @idUltimoEC_CuentaCerrar

				-- CREACION DEL NUEVO ESTADO DE CUENTA

				-- Se define la fecha inicial del nuevo estado de cuenta
				--SET @fechaInicioEC = @fechaIteracion

				-- Se define la fecha final del nuevo estado de cuenta
				SET @fechaFinalEC = DATEADD(MONTH,1,@fechaIteracion)

				-- Se define la fecha final del ultimo estado de cuenta para validar el ingreso de estados de cuenta
				SET @fechaUltimoEstadoCuenta = (SELECT EC.Fecha_Final FROM EstadoCuenta EC WHERE EC.id = @idUltimoEC_CuentaCerrar)

				-- Se obtiene el numero de cuenta de la cuenta en iteracion para la que se esta creando un nuevo estado de cuenta
				SELECT @NumCuenta_NuevoEC = CA.Numero_Cuenta
				FROM Cuenta_Ahorro CA
		 		WHERE CA.id = @idCuentaCerrarEC

				-- Insercion del nuevo estado de cuenta
				IF (@fechaUltimoEstadoCuenta = @fechaIteracion)
				BEGIN
					INSERT INTO EstadoCuenta 
					VALUES(@idCuentaCerrarEC, @fechaIteracion, @fechaFinalEC, @SaldoActual_CuentaCerrar, @SaldoActual_CuentaCerrar,
					   @SaldoActual_CuentaCerrar, 0, @NumCuenta_NuevoEC, 0 ,0)
				END
			
			-- Se aumenta el contador interno
				SET @lo = @lo + 1
			END

			IF @InicioTran = 1
			BEGIN
				COMMIT TRANSACTION CrearNuevoEstadoDeCuenta
				SET @InicioTran = 0
			END
		END TRY
		BEGIN CATCH

			IF @InicioTran = 1
				BEGIN
					ROLLBACK TRANSACTION CrearNuevoEstadoDeCuenta
					SELECT 'Hubo un error al crear los nuevos estados de cuenta'
					Return -100008
				END
		
		END CATCH

		DELETE @CuentasCerrarEC

		SET @fechaIteracion = (SELECT DATEADD(day, 1, @fechaIteracion))
	END

END
GO

