
/****** Script for SelectTopNRows command from SSMS  ******/
DELETE FROM [Sistema_Banco].[dbo].[Evento]
  
DBCC CHECKIDENT ('Evento', RESEED, 0)

DELETE FROM [Sistema_Banco].[dbo].[TipoEvento]
  
DBCC CHECKIDENT ('TipoEvento', RESEED, 0)

DELETE FROM [Sistema_Banco].[dbo].[MovimientoCO]
  
DBCC CHECKIDENT ('MovimientoCO', RESEED, 0)

DELETE FROM [Sistema_Banco].[dbo].TipoMovimientoCO
  
DBCC CHECKIDENT ('TipoMovimientoCO', RESEED, 0)

DELETE FROM [Sistema_Banco].[dbo].[Movimiento]
  
DBCC CHECKIDENT ('Movimiento', RESEED, 0)

DELETE FROM [Sistema_Banco].[dbo].[EstadoCuenta]
  
DBCC CHECKIDENT ('EstadoCuenta', RESEED, 0)

DELETE FROM [Sistema_Banco].[dbo].[CuentaObjetivo]
  
DBCC CHECKIDENT ('CuentaObjetivo', RESEED, 0)  

DELETE FROM [Sistema_Banco].[dbo].[Beneficiario] 

DBCC CHECKIDENT ('Beneficiario', RESEED, 0) 

DELETE FROM [Sistema_Banco].[dbo].[Cuenta_Ahorro]
  
DBCC CHECKIDENT ('Cuenta_Ahorro', RESEED, 0)  

DELETE FROM [Sistema_Banco].[dbo].[Cliente]

DBCC CHECKIDENT ('Cliente', RESEED, 0)

DELETE FROM [Sistema_Banco].[dbo].[Persona]

DBCC CHECKIDENT ('Persona', RESEED, 0) 

DELETE FROM [Sistema_Banco].[dbo].[TipoID]
  
DBCC CHECKIDENT ('TipoID', RESEED, 0)  

DELETE FROM [Sistema_Banco].[dbo].[Parentesco]
  
DBCC CHECKIDENT ('Parentesco', RESEED, 0)  

DELETE FROM [Sistema_Banco].[dbo].[TipoCuentaAhorro]
  
DBCC CHECKIDENT ('TipoCuentaAhorro', RESEED, 0) 

DELETE FROM [Sistema_Banco].[dbo].[Moneda]
  
DBCC CHECKIDENT ('Moneda', RESEED, 0)  

DELETE FROM [Sistema_Banco].[dbo].[TipoMovimiento]
  
DBCC CHECKIDENT ('TipoMovimiento', RESEED, 0)  

USE [Sistema_Banco]
GO

DECLARE	@return_value int

EXEC	@return_value = [dbo].[CASP_CargarDatos]

SELECT	'Return Value' = @return_value

GO

USE [Sistema_Banco]
GO

DECLARE	@return_value int

EXEC	@return_value = [dbo].[SP_Simulacion]

SELECT	'Return Value' = @return_value

GO