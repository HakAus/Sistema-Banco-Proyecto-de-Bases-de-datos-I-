USE [Sistema_Banco]
GO

/****** Object:  StoredProcedure [dbo].[CASP_GetTiposID]    Script Date: 11/5/2019 6:28:52 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author:		<Austin Hakanson>
-- Create date: <4-10-2019>
-- Description:	<SP para obtener los tipos de identificacion para poblar un combo box en capa logica>
-- =============================================
CREATE OR ALTER PROCEDURE [dbo].[CASP_GetTiposID]

AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
	SELECT TID.id, TID.Nombre
	FROM dbo.TipoID TID

END
GO

