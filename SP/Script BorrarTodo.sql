/****** Script for SelectTopNRows command from SSMS  ******/

DELETE FROM [Sistema_Banco].[dbo].[EstadoCuenta]
  
DBCC CHECKIDENT ('EstadoCuenta', RESEED, 0)

DELETE FROM [Sistema_Banco].[dbo].[CuentaObjeto]
  
DBCC CHECKIDENT ('CuentaObjeto', RESEED, 0)  

DELETE FROM [Sistema_Banco].[dbo].[Beneficiario]
  
DBCC CHECKIDENT ('Beneficiario', RESEED, 0)  

DELETE FROM [Sistema_Banco].[dbo].[CuentaAhorro]
  
DBCC CHECKIDENT ('CuentaAhorro', RESEED, 0)  

DELETE FROM [Sistema_Banco].[dbo].[Cliente]
  
DBCC CHECKIDENT ('Cliente', RESEED, 0)  

DELETE FROM [Sistema_Banco].[dbo].[TipoID]
  
DBCC CHECKIDENT ('TipoID', RESEED, 0)  

DELETE FROM [Sistema_Banco].[dbo].[Parentesco]
  
DBCC CHECKIDENT ('Parentesco', RESEED, 0)  

DELETE FROM [Sistema_Banco].[dbo].[TipoCuentaAhorro]
  
DBCC CHECKIDENT ('TipoCuentaAhorro', RESEED, 0) 

DELETE FROM [Sistema_Banco].[dbo].[Moneda]
  
DBCC CHECKIDENT ('Moneda', RESEED, 0)  



