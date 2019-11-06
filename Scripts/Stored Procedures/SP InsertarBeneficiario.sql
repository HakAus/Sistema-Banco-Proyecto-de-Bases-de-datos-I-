USE [Sistema_Banco]
GO

/****** Object:  StoredProcedure [dbo].[CASP_InsertarBeneficiario]    Script Date: 11/5/2019 6:29:14 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author:		<Austin Hakanson>
-- Create date: <9/15/2019>
-- Modification date: <8/10/2019>
-- Description:	<SP para ingresar un nuevo usario a la base de datos>
-- =============================================
CREATE OR ALTER PROCEDURE [dbo].[CASP_InsertarBeneficiario]
	-- Parametros
	@Numero_Cuenta nvarchar(50),

	@Nombre nvarchar(100),
	@Tipo_Documento_Identificacion nvarchar(100),
	@Documento_Identificacion nvarchar(50),
	@Parentesco nvarchar(50),
	@Porcentaje int,
	@Telefono1 int,
	@Telefono2 int,
	@Email nvarchar(100),
	@Fecha_Nacimiento date
	
AS
BEGIN

	BEGIN TRY
	
		-- Se verifica primero que los parametros no vengan nulos

		IF @Numero_Cuenta = NULL
		BEGIN
			return -100001
		END

		IF @Nombre = NULL
		BEGIN
			return -100002
		END

		IF @Parentesco = NULL
		BEGIN
			return -100003
		END

		IF @Porcentaje = NULL
		BEGIN
			return -100004
		END

		IF @Tipo_Documento_Identificacion = NULL
		BEGIN
			return -100005
		END

		IF @Documento_Identificacion = NULL
		BEGIN
			return -100006
		END

		IF @Email = NULL
		BEGIN
			return -100007
		END

		IF @Telefono1 = NULL
		BEGIN
			return -100008
		END

		IF @Telefono2 = NULL
		BEGIN
			return -100009
		END

		-- Se verifica que existan id en las tablas correspondientes para los parametros 
		-- de Numero_Cuenta, Parentesco y TipoID

		IF EXISTS (SELECT CA.id, P.id, TID.id 
				   FROM CuentaAhorro CA, Parentesco P, TipoID TID
				   WHERE CA.Numero_Cuenta = @Numero_Cuenta and P.Detalle = @Parentesco
				   and TID.Nombre = @Tipo_Documento_Identificacion)
			BEGIN
				-- Se calcula la suma de los porcentajes de los beneficiarios
				DECLARE @SumaPorcentaje int

				SELECT @SumaPorcentaje = SUM(B.Porcentaje)
				FROM dbo.Beneficiario B
				INNER JOIN Persona P ON B.id = P.id
				WHERE B.Numero_Cuenta = @Numero_Cuenta and B.Activo = 1

				-- Se verifica que el porcentaje ingresado no sea superior a 100
				IF (@Porcentaje > 100) 
					BEGIN
						return -100010 --  EL porcentaje ingresado es mayor a 100
					END
				
				-- Se verifica que la suma de porcentajes de todos los beneficiarios no sea superior a 100
				IF ((@SumaPorcentaje + @Porcentaje) > 100)
				BEGIN 
					return -100011	-- La suma de todos los porcentajes es mayor a 100
				END
				
	
				-- Se verifica si ya existia el beneficiario
				DECLARE @ExistePersona int = (SELECT count(P.id) FROM Persona P WHERE P.Documento_Identificacion = @Documento_Identificacion)
				DECLARE @ExisteBeneficiario int = (SELECT count(B.id) 
												   FROM Beneficiario B INNER JOIN Persona P ON P.id = B.idPersona 
												   WHERE P.Documento_Identificacion = @Documento_Identificacion and B.Activo = 1)

				IF @ExisteBeneficiario = 1
				BEGIN
					return -100012 -- El usuario ingresado ya existe
				END

				ELSE
					BEGIN
						-- Se verifica que no hayan ya 3 beneficiarios para la cuenta en cuestion
						IF (SELECT COUNT(B.id) 
							FROM Beneficiario B
							INNER JOIN Persona P ON B.id = P.id
							WHERE B.Numero_Cuenta = @Numero_Cuenta and B.Activo = 1) = 3
							BEGIN
								return -100013 -- Ya existen 3 beneficiarios asignados, no puede agregar mas
							END
							
						ELSE
						BEGIN
							INSERT INTO dbo.Persona
							SELECT TID.id, @Nombre, @Tipo_Documento_Identificacion, @Documento_Identificacion, 
									@Telefono1, @Telefono2, @Email, @Fecha_Nacimiento
							FROM TipoID TID
							WHERE TID.Nombre = @Tipo_Documento_Identificacion

							INSERT INTO dbo.Beneficiario
							SELECT P.id, PA.id, PA.Nombre, @Porcentaje, 1, null, @Numero_Cuenta
							FROM Persona P, Parentesco PA
							WHERE P.Documento_Identificacion = @Documento_Identificacion and PA.Detalle = @Parentesco

					    END
				END
			END
			ELSE 
			BEGIN
				return -100016 -- El Numero_Cuenta, Parentesco y TipoID ingresados no es correcto
			END
	END TRY

	BEGIN CATCH
		return ERROR_MESSAGE()

	END CATCH
END
GO

