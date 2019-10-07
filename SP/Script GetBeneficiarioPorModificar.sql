
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Austin Hakanson>
-- Create date: <07-10-2019>
-- Description:	<SP para obtener datos de beneficiario a modificar>
-- =============================================
CREATE PROCEDURE CASP_GetBeneficiarioPorModificar
	-- Parametros
	@Numero_Cuenta nvarchar(50),
	@Documento_Identificacion nvarchar(50)
AS
BEGIN

	SET NOCOUNT ON;
    -- Insert statements for procedure here
	SELECT B.Nombre, B.Parentesco, B.Porcentaje, B.Tipo_Documento_Identificacion,
			B.Documento_Identificacion, B.Email, B.Telefono1, B.Telefono2, B.Fecha_Nacimiento
	FROM Beneficiario B
	WHERE B.Numero_Cuenta = @Numero_Cuenta and B.Documento_Identificacion = @Documento_Identificacion
END
GO
