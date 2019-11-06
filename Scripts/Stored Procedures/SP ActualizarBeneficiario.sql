USE [Sistema_Banco]
GO

/****** Object:  StoredProcedure [dbo].[CASP_ActualizarBeneficiario]    Script Date: 11/5/2019 6:17:03 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author:		<Austin Hakanson>
-- Create date: <15-09-2019>
-- Description:	<SP para actualizar los datos de 1 usuario>
-- =============================================

CREATE OR ALTER PROCEDURE [dbo].[CASP_ActualizarBeneficiario]

	-- Parametros del potencial NUEVO Beneficiario
	@Numero_Cuenta nvarchar(50),
	@Nombre nvarchar(100),
	@Nuevo_Nombre nvarchar(100),
	@Parentesco nvarchar(100),
	@Porcentaje int,
	@Tipo_Documento_Identificacion nvarchar(100),
	@Nuevo_Tipo_Documento_Identificacion nvarchar(100),
	@Documento_Identificacion nvarchar(50),
	@Nuevo_Documento_Identificacion nvarchar(50),
	@Email nvarchar(100),
	@Telefono1 int,
	@Telefono2 int,
	@Fecha_Nacimiento date
AS
BEGIN

-- Se verifica que los parametros no vengan en NULL

	IF @Nombre IS NULL
	BEGIN
		return -100001
	END

	IF @Nuevo_Nombre IS NULL
	BEGIN
		return -100002
	END

	IF @Parentesco IS NULL
	BEGIN
		return -100003
	END

	IF @Porcentaje IS NULL
	BEGIN
		return -100004
	END

	IF @Tipo_Documento_Identificacion IS NULL
	BEGIN
		return -100005
	END

	IF @Nuevo_Tipo_Documento_Identificacion IS NULL
	BEGIN
		return -100006
	END

	IF @Documento_Identificacion IS NULL
	BEGIN
		return -100007
	END

	IF @Nuevo_Documento_Identificacion IS NULL
	BEGIN
		return -100008
	END

	IF @Email IS NULL
	BEGIN
		return -100009
	END

	IF @Telefono1 IS NULL
	BEGIN
		return -100010
	END

	IF @Telefono2 IS NULL
	BEGIN
		return -100011
	END

	IF @Numero_Cuenta IS NULL
	BEGIN
		return -100012
	END

	IF @Fecha_Nacimiento IS NULL
	BEGIN
		return -100013
	END
	

	IF EXISTS (SELECT CA.id, PA.id, TID.id 
			   FROM CuentaAhorro CA, Parentesco PA, TipoID TID
			   WHERE CA.Numero_Cuenta = @Numero_Cuenta and PA.Detalle = @Parentesco
			   and TID.Nombre = @Nuevo_Tipo_Documento_Identificacion)
	BEGIN

		-- Se calcula la suma de los porcentajes de los beneficiarios
		DECLARE @SumaPorcentaje int

		-- Se calcula la suma de los porcentajes de los beneficiarios restantes
		SELECT @SumaPorcentaje = SUM(B.Porcentaje)
		FROM dbo.Beneficiario B
		INNER JOIN Persona P ON B.idPersona = P.id
		WHERE B.Numero_Cuenta = @Numero_Cuenta AND B.Activo = 1	 AND 
				P.Documento_Identificacion != @Nuevo_Documento_Identificacion

		-- Se verifica que el porcentaje ingresado no sea superior a 100
		IF (@Porcentaje > 100) 
		BEGIN
			return -100014 --  EL porcentaje ingresado es mayor a 100
		END
		
		IF (@Porcentaje + @SumaPorcentaje) <= 100
		BEGIN

			---- Se procede a actualizar la tabla de beneficiarios

			UPDATE Persona
			SET idTipoID = TID.id,
				Nombre = @Nuevo_Nombre,
				Tipo_Documento_Identificacion =  @Nuevo_Tipo_Documento_Identificacion,
				Documento_Identificacion = @Nuevo_Documento_Identificacion,
				Email = @Email,
				Telefono1 = @Telefono1,
				Telefono2 = @Telefono2,
				Fecha_Nacimiento = convert(datetime,@Fecha_Nacimiento, 103)
			FROM CuentaAhorro CA, Parentesco P, TipoID TID, Beneficiario B
			WHERE CA.Numero_Cuenta = @Numero_Cuenta and P.Detalle = @Parentesco
				  and TID.Nombre = @Nuevo_Tipo_Documento_Identificacion
				  and Documento_Identificacion = @Documento_Identificacion

			UPDATE Beneficiario
			SET idPersona = P.id,
				idParentesco = PA.id,
				Parentesco = PA.Nombre,
				Porcentaje = @Porcentaje,
				Activo = 1,
				Fecha_Desactivacion = null,
				Numero_Cuenta = @Numero_Cuenta
			FROM Persona P
			INNER JOIN Parentesco PA ON PA.Detalle = @Parentesco
			WHERE P.Documento_Identificacion = @Nuevo_Documento_Identificacion and
				  idPersona = P.id
				 
		END
		ELSE
			BEGIN
				return -100015 -- Los porcentajes exceden los 100
			END
	END
	ELSE
	BEGIN
		return -100016 -- No se encontro una combinacion Nombre-Numero_Cuenta-Documento_Identificacion que hiciera pareja en la BD					
	END
END
GO

