USE [master]
GO
/****** Object:  Database [Sistema_Banco]    Script Date: 11/4/2019 12:40:32 AM ******/
CREATE DATABASE [Sistema_Banco]
 CONTAINMENT = NONE
 ON  PRIMARY 
( NAME = N'Sistema_Banco', FILENAME = N'C:\Program Files\Microsoft SQL Server\MSSQL15.MSSQLSERVER\MSSQL\DATA\Sistema_Banco.mdf' , SIZE = 73728KB , MAXSIZE = UNLIMITED, FILEGROWTH = 65536KB )
 LOG ON 
( NAME = N'Sistema_Banco_log', FILENAME = N'C:\Program Files\Microsoft SQL Server\MSSQL15.MSSQLSERVER\MSSQL\DATA\Sistema_Banco_log.ldf' , SIZE = 532480KB , MAXSIZE = 2048GB , FILEGROWTH = 65536KB )
 WITH CATALOG_COLLATION = DATABASE_DEFAULT
GO
ALTER DATABASE [Sistema_Banco] SET COMPATIBILITY_LEVEL = 150
GO
IF (1 = FULLTEXTSERVICEPROPERTY('IsFullTextInstalled'))
begin
EXEC [Sistema_Banco].[dbo].[sp_fulltext_database] @action = 'enable'
end
GO
ALTER DATABASE [Sistema_Banco] SET ANSI_NULL_DEFAULT OFF 
GO
ALTER DATABASE [Sistema_Banco] SET ANSI_NULLS OFF 
GO
ALTER DATABASE [Sistema_Banco] SET ANSI_PADDING OFF 
GO
ALTER DATABASE [Sistema_Banco] SET ANSI_WARNINGS OFF 
GO
ALTER DATABASE [Sistema_Banco] SET ARITHABORT OFF 
GO
ALTER DATABASE [Sistema_Banco] SET AUTO_CLOSE OFF 
GO
ALTER DATABASE [Sistema_Banco] SET AUTO_SHRINK OFF 
GO
ALTER DATABASE [Sistema_Banco] SET AUTO_UPDATE_STATISTICS ON 
GO
ALTER DATABASE [Sistema_Banco] SET CURSOR_CLOSE_ON_COMMIT OFF 
GO
ALTER DATABASE [Sistema_Banco] SET CURSOR_DEFAULT  GLOBAL 
GO
ALTER DATABASE [Sistema_Banco] SET CONCAT_NULL_YIELDS_NULL OFF 
GO
ALTER DATABASE [Sistema_Banco] SET NUMERIC_ROUNDABORT OFF 
GO
ALTER DATABASE [Sistema_Banco] SET QUOTED_IDENTIFIER OFF 
GO
ALTER DATABASE [Sistema_Banco] SET RECURSIVE_TRIGGERS OFF 
GO
ALTER DATABASE [Sistema_Banco] SET  DISABLE_BROKER 
GO
ALTER DATABASE [Sistema_Banco] SET AUTO_UPDATE_STATISTICS_ASYNC OFF 
GO
ALTER DATABASE [Sistema_Banco] SET DATE_CORRELATION_OPTIMIZATION OFF 
GO
ALTER DATABASE [Sistema_Banco] SET TRUSTWORTHY OFF 
GO
ALTER DATABASE [Sistema_Banco] SET ALLOW_SNAPSHOT_ISOLATION OFF 
GO
ALTER DATABASE [Sistema_Banco] SET PARAMETERIZATION SIMPLE 
GO
ALTER DATABASE [Sistema_Banco] SET READ_COMMITTED_SNAPSHOT OFF 
GO
ALTER DATABASE [Sistema_Banco] SET HONOR_BROKER_PRIORITY OFF 
GO
ALTER DATABASE [Sistema_Banco] SET RECOVERY FULL 
GO
ALTER DATABASE [Sistema_Banco] SET  MULTI_USER 
GO
ALTER DATABASE [Sistema_Banco] SET PAGE_VERIFY CHECKSUM  
GO
ALTER DATABASE [Sistema_Banco] SET DB_CHAINING OFF 
GO
ALTER DATABASE [Sistema_Banco] SET FILESTREAM( NON_TRANSACTED_ACCESS = OFF ) 
GO
ALTER DATABASE [Sistema_Banco] SET TARGET_RECOVERY_TIME = 60 SECONDS 
GO
ALTER DATABASE [Sistema_Banco] SET DELAYED_DURABILITY = DISABLED 
GO
EXEC sys.sp_db_vardecimal_storage_format N'Sistema_Banco', N'ON'
GO
ALTER DATABASE [Sistema_Banco] SET QUERY_STORE = OFF
GO
USE [Sistema_Banco]
GO
/****** Object:  UserDefinedTableType [dbo].[TipoCliente]    Script Date: 11/4/2019 12:40:33 AM ******/
CREATE TYPE [dbo].[TipoCliente] AS TABLE(
	[Usuario] [nvarchar](100) NULL,
	[Contrasenia] [nvarchar](100) NULL
)
GO
/****** Object:  UserDefinedTableType [dbo].[TipoPersona]    Script Date: 11/4/2019 12:40:33 AM ******/
CREATE TYPE [dbo].[TipoPersona] AS TABLE(
	[Fecha_Nacimiento] [date] NULL,
	[Tipo_Doumento_Identificacion] [nvarchar](100) NULL,
	[Documento_Identificacion] [nvarchar](50) NULL,
	[Email] [nvarchar](100) NULL,
	[Telefono1] [int] NULL,
	[Telefono2] [int] NULL,
	[Nombre] [nvarchar](100) NULL
)
GO
/****** Object:  Table [dbo].[Beneficiario]    Script Date: 11/4/2019 12:40:33 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Beneficiario](
	[id] [int] IDENTITY(1,1) NOT NULL,
	[idPersona] [int] NOT NULL,
	[idParentesco] [int] NOT NULL,
	[Parentesco] [nvarchar](100) NOT NULL,
	[Porcentaje] [int] NOT NULL,
	[Activo] [int] NOT NULL,
	[Fecha_Desactivacion] [date] NOT NULL,
	[Numero_Cuenta] [nvarchar](100) NOT NULL,
 CONSTRAINT [PK_Beneficiario] PRIMARY KEY CLUSTERED 
(
	[id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Cliente]    Script Date: 11/4/2019 12:40:33 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Cliente](
	[id] [int] IDENTITY(1,1) NOT NULL,
	[idPersona] [int] NOT NULL,
	[Usuario] [nvarchar](100) NOT NULL,
	[Contrasenia] [nvarchar](100) NOT NULL,
 CONSTRAINT [PK_Cliente] PRIMARY KEY CLUSTERED 
(
	[id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Cuenta_Ahorro]    Script Date: 11/4/2019 12:40:33 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Cuenta_Ahorro](
	[id] [int] IDENTITY(1,1) NOT NULL,
	[idTipoCuentaAhorro] [int] NOT NULL,
	[idCliente] [int] NOT NULL,
	[Numero_Cuenta] [nvarchar](50) NOT NULL,
	[Saldo] [money] NOT NULL,
	[Fecha_Creacion] [date] NOT NULL,
 CONSTRAINT [PK_Cuenta_Ahorro] PRIMARY KEY CLUSTERED 
(
	[id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[CuentaObjetivo]    Script Date: 11/4/2019 12:40:33 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[CuentaObjetivo](
	[id] [int] IDENTITY(1,1) NOT NULL,
	[idCuenta] [int] NOT NULL,
	[Saldo] [money] NOT NULL,
	[Fecha_Inicio] [date] NOT NULL,
	[Fecha_Final] [date] NOT NULL,
	[Fecha_Ultimo_Credito] [date] NOT NULL,
	[Monto_Ahorro] [money] NOT NULL,
	[Numero_Cuenta] [nvarchar](50) NOT NULL,
	[Descripcion] [nvarchar](100) NOT NULL,
	[Activo] [int] NOT NULL,
 CONSTRAINT [PK_CuentaObjetivo] PRIMARY KEY CLUSTERED 
(
	[id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[EstadoCuenta]    Script Date: 11/4/2019 12:40:33 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[EstadoCuenta](
	[id] [int] IDENTITY(1,1) NOT NULL,
	[idCuenta] [int] NOT NULL,
	[Fecha_Inicio] [date] NOT NULL,
	[Fecha_Final] [date] NOT NULL,
	[Saldo_Inicio] [money] NOT NULL,
	[Saldo_Final] [money] NOT NULL,
	[Saldo_Minimo] [money] NOT NULL,
	[Intereses] [money] NOT NULL,
	[Numero_Cuenta] [nvarchar](50) NOT NULL,
	[QRCH] [int] NOT NULL,
	[QRCA] [int] NOT NULL,
 CONSTRAINT [PK_EstadoCuenta] PRIMARY KEY CLUSTERED 
(
	[id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Moneda]    Script Date: 11/4/2019 12:40:33 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Moneda](
	[id] [int] IDENTITY(1,1) NOT NULL,
	[Nombre] [nvarchar](100) NOT NULL,
	[Simbolo] [nvarchar](3) NOT NULL,
 CONSTRAINT [PK_Moneda] PRIMARY KEY CLUSTERED 
(
	[id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Movimiento]    Script Date: 11/4/2019 12:40:33 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Movimiento](
	[id] [int] IDENTITY(1,1) NOT NULL,
	[idCuenta] [int] NOT NULL,
	[idTipoMovimiento] [int] NOT NULL,
	[Tipo_Movimiento] [nvarchar](100) NOT NULL,
	[Fecha] [date] NOT NULL,
	[Monto] [money] NOT NULL,
	[NuevoSaldo] [money] NOT NULL,
	[Descripcion] [nvarchar](100) NOT NULL,
 CONSTRAINT [PK_Movimiento] PRIMARY KEY CLUSTERED 
(
	[id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[MovimientoCO]    Script Date: 11/4/2019 12:40:33 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[MovimientoCO](
	[id] [int] IDENTITY(1,1) NOT NULL,
	[idCuentaObjetivo] [int] NOT NULL,
	[idTipoMovimientoCO] [int] NOT NULL,
	[Fecha] [date] NOT NULL,
	[Monto] [money] NOT NULL,
	[Descripcion] [nvarchar](100) NOT NULL,
 CONSTRAINT [PK_MovimientoCO] PRIMARY KEY CLUSTERED 
(
	[id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Parentesco]    Script Date: 11/4/2019 12:40:33 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Parentesco](
	[id] [int] IDENTITY(1,1) NOT NULL,
	[Nombre] [nvarchar](100) NOT NULL,
	[Detalee] [nvarchar](100) NOT NULL,
 CONSTRAINT [PK_Parentesco] PRIMARY KEY CLUSTERED 
(
	[id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Persona]    Script Date: 11/4/2019 12:40:33 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Persona](
	[id] [int] IDENTITY(1,1) NOT NULL,
	[idTipoID] [int] NOT NULL,
	[Nombre] [nvarchar](100) NOT NULL,
	[Tipo_Documento_Identificacion] [nvarchar](100) NOT NULL,
	[Documento_Identificacion] [nvarchar](100) NOT NULL,
	[Telefono1] [int] NOT NULL,
	[Telefono2] [int] NOT NULL,
	[Email] [nvarchar](100) NOT NULL,
	[Fecha_Nacimiento] [date] NOT NULL,
 CONSTRAINT [PK_Persona] PRIMARY KEY CLUSTERED 
(
	[id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[TipoCuentaAhorro]    Script Date: 11/4/2019 12:40:33 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[TipoCuentaAhorro](
	[id] [int] IDENTITY(1,1) NOT NULL,
	[idMoneda] [int] NOT NULL,
	[Nombre] [nvarchar](100) NOT NULL,
	[Saldo_Minimo] [money] NOT NULL,
	[Multa_Saldo_Minimo] [money] NOT NULL,
	[Monto_Mensual_Cargos_Servicio] [money] NOT NULL,
	[Maximo_Retiros_Cajero_Humano] [int] NOT NULL,
	[Multa_Exceso_Retiros_Cajero] [money] NOT NULL,
	[Tasa_Interes_Mensual] [int] NULL,
 CONSTRAINT [PK_TipoCuentaAhorro] PRIMARY KEY CLUSTERED 
(
	[id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[TipoID]    Script Date: 11/4/2019 12:40:33 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[TipoID](
	[id] [int] IDENTITY(1,1) NOT NULL,
	[Nombre] [nvarchar](100) NOT NULL,
 CONSTRAINT [PK_TipoID] PRIMARY KEY CLUSTERED 
(
	[id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[TipoMovimiento]    Script Date: 11/4/2019 12:40:33 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[TipoMovimiento](
	[id] [int] IDENTITY(1,1) NOT NULL,
	[Nombre] [nvarchar](100) NOT NULL,
	[TipoDC] [nvarchar](3) NOT NULL,
 CONSTRAINT [PK_TipoMovimiento] PRIMARY KEY CLUSTERED 
(
	[id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[TipoMovimientoCO]    Script Date: 11/4/2019 12:40:33 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[TipoMovimientoCO](
	[id] [int] IDENTITY(1,1) NOT NULL,
	[Nombre] [nvarchar](50) NOT NULL,
 CONSTRAINT [PK_TipoMovimientoCO] PRIMARY KEY CLUSTERED 
(
	[id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[Beneficiario]  WITH CHECK ADD  CONSTRAINT [FK_Beneficiario_Parentesco] FOREIGN KEY([idParentesco])
REFERENCES [dbo].[Parentesco] ([id])
GO
ALTER TABLE [dbo].[Beneficiario] CHECK CONSTRAINT [FK_Beneficiario_Parentesco]
GO
ALTER TABLE [dbo].[Beneficiario]  WITH CHECK ADD  CONSTRAINT [FK_Beneficiario_Persona] FOREIGN KEY([idPersona])
REFERENCES [dbo].[Persona] ([id])
GO
ALTER TABLE [dbo].[Beneficiario] CHECK CONSTRAINT [FK_Beneficiario_Persona]
GO
ALTER TABLE [dbo].[Cliente]  WITH CHECK ADD  CONSTRAINT [FK_Cliente_Persona] FOREIGN KEY([idPersona])
REFERENCES [dbo].[Persona] ([id])
GO
ALTER TABLE [dbo].[Cliente] CHECK CONSTRAINT [FK_Cliente_Persona]
GO
ALTER TABLE [dbo].[Cuenta_Ahorro]  WITH CHECK ADD  CONSTRAINT [FK_Cuenta_Ahorro_Cliente] FOREIGN KEY([idCliente])
REFERENCES [dbo].[Cliente] ([id])
GO
ALTER TABLE [dbo].[Cuenta_Ahorro] CHECK CONSTRAINT [FK_Cuenta_Ahorro_Cliente]
GO
ALTER TABLE [dbo].[Cuenta_Ahorro]  WITH CHECK ADD  CONSTRAINT [FK_Cuenta_Ahorro_TipoCuentaAhorro] FOREIGN KEY([idTipoCuentaAhorro])
REFERENCES [dbo].[TipoCuentaAhorro] ([id])
GO
ALTER TABLE [dbo].[Cuenta_Ahorro] CHECK CONSTRAINT [FK_Cuenta_Ahorro_TipoCuentaAhorro]
GO
ALTER TABLE [dbo].[CuentaObjetivo]  WITH CHECK ADD  CONSTRAINT [FK_CuentaObjetivo_Cuenta_Ahorro] FOREIGN KEY([idCuenta])
REFERENCES [dbo].[Cuenta_Ahorro] ([id])
GO
ALTER TABLE [dbo].[CuentaObjetivo] CHECK CONSTRAINT [FK_CuentaObjetivo_Cuenta_Ahorro]
GO
ALTER TABLE [dbo].[EstadoCuenta]  WITH CHECK ADD  CONSTRAINT [FK_EstadoCuenta_Cuenta_Ahorro] FOREIGN KEY([idCuenta])
REFERENCES [dbo].[Cuenta_Ahorro] ([id])
GO
ALTER TABLE [dbo].[EstadoCuenta] CHECK CONSTRAINT [FK_EstadoCuenta_Cuenta_Ahorro]
GO
ALTER TABLE [dbo].[Movimiento]  WITH CHECK ADD  CONSTRAINT [FK_Movimiento_Cuenta_Ahorro] FOREIGN KEY([idCuenta])
REFERENCES [dbo].[Cuenta_Ahorro] ([id])
GO
ALTER TABLE [dbo].[Movimiento] CHECK CONSTRAINT [FK_Movimiento_Cuenta_Ahorro]
GO
ALTER TABLE [dbo].[Movimiento]  WITH CHECK ADD  CONSTRAINT [FK_Movimiento_TipoMovimiento] FOREIGN KEY([idTipoMovimiento])
REFERENCES [dbo].[TipoMovimiento] ([id])
GO
ALTER TABLE [dbo].[Movimiento] CHECK CONSTRAINT [FK_Movimiento_TipoMovimiento]
GO
ALTER TABLE [dbo].[MovimientoCO]  WITH CHECK ADD  CONSTRAINT [FK_MovimientoCO_CuentaObjetivo] FOREIGN KEY([idCuentaObjetivo])
REFERENCES [dbo].[CuentaObjetivo] ([id])
GO
ALTER TABLE [dbo].[MovimientoCO] CHECK CONSTRAINT [FK_MovimientoCO_CuentaObjetivo]
GO
ALTER TABLE [dbo].[MovimientoCO]  WITH CHECK ADD  CONSTRAINT [FK_MovimientoCO_TipoMovimientoCO] FOREIGN KEY([idTipoMovimientoCO])
REFERENCES [dbo].[TipoMovimientoCO] ([id])
GO
ALTER TABLE [dbo].[MovimientoCO] CHECK CONSTRAINT [FK_MovimientoCO_TipoMovimientoCO]
GO
ALTER TABLE [dbo].[Persona]  WITH CHECK ADD  CONSTRAINT [FK_Persona_TipoID] FOREIGN KEY([idTipoID])
REFERENCES [dbo].[TipoID] ([id])
GO
ALTER TABLE [dbo].[Persona] CHECK CONSTRAINT [FK_Persona_TipoID]
GO
ALTER TABLE [dbo].[TipoCuentaAhorro]  WITH CHECK ADD  CONSTRAINT [FK_TipoCuentaAhorro_Moneda] FOREIGN KEY([idMoneda])
REFERENCES [dbo].[Moneda] ([id])
GO
ALTER TABLE [dbo].[TipoCuentaAhorro] CHECK CONSTRAINT [FK_TipoCuentaAhorro_Moneda]
GO
/****** Object:  StoredProcedure [dbo].[CASP_ActualizarBeneficiario]    Script Date: 11/4/2019 12:40:33 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Austin Hakanson>
-- Create date: <15-09-2019>
-- Description:	<SP para actualizar los datos de 1 usuario>
-- =============================================

CREATE PROCEDURE [dbo].[CASP_ActualizarBeneficiario]

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
/****** Object:  StoredProcedure [dbo].[CASP_CargarDatos]    Script Date: 11/4/2019 12:40:33 AM ******/
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
CREATE PROCEDURE [dbo].[CASP_CargarDatos]

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
		simMoneda nvarchar(3),
		maxRetirosCajeroHumano int,
		multaIncumpleMaxRetirosCajeroHumano money,
		tasaIntereses int
		)

		INSERT INTO @TipoCuentaAhorro_Temporal
		SELECT nombre, saldoMinimo, multaSaldoMinimo, cargosPorServicioMensual,
			   simMoneda, maxRetirosCajeroHumano, multaIncumpleMaxRetirosCajeroHumano, 
			   tasaIntereses
		FROM OPENXML(@hdoc, 'SistemaBanc/TipoCuentaAhorro')
		WITH(
		nombre nvarchar(100) 'nombre',
		saldoMinimo money 'saldoMinimo',
		multaSaldoMinimo money 'multaSaldoMinimo',
		cargosPorServicioMensual money 'cargosPorServicioMensual',
		simMoneda nvarchar(3) 'simMoneda',
		maxRetirosCajeroHumano int 'maxRetirosCajeroHumano',
		multaIncumpleMaxRetirosCajeroHumano money 'multaIncumpleMaxRetirosCajeroHumano',
		tasaIntereses int 'tasaIntereses'
		)
		
		INSERT INTO TipoCuentaAhorro
		SELECT M.id, T.nombre, T.saldoMinimo, T.multaSaldoMinimo, T.cargosPorServicioMensual,
			   T.maxRetirosCajeroHumano, T.multaIncumpleMaxRetirosCajeroHumano, T.tasaIntereses
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

	-- Insercion de Tipo de Movimiento de Cuenta Objetivo
		INSERT INTO TipoMovimientoCO
		VALUES 
		('Depósito'),
		('Redención de la CO')

	END TRY

	BEGIN CATCH
		return @@ERROR * -1
	END CATCH
END
GO
/****** Object:  StoredProcedure [dbo].[CASP_CargarPruebas]    Script Date: 11/4/2019 12:40:33 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[CASP_CargarPruebas]
	-- Add the parameters for the stored procedure here
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
	BEGIN TRY
	
	-- Insercion del tipo de ID
		DECLARE @TipoIDXML xml
		SELECT @TipoIDXML = TID
		FROM OPENROWSET (Bulk 'Y:\Documents\Ing. Computación\IV Semestre\Bases de datos I\IITP\XML\TipoID.xml',Single_BLOB) AS TipoID(TID)

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
		FROM OPENROWSET (BULK 'Y:\Documents\Ing. Computación\IV Semestre\Bases de datos I\IITP\XML\Moneda.xml', SINGLE_BLOB) AS Moneda(M)

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
		FROM OPENROWSET (Bulk 'Y:\Documents\Ing. Computación\IV Semestre\Bases de datos I\IITP\XML\Parentesco.xml', Single_BLOB) AS Parentesco(P)

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

		IF OBJECT_ID('Temporal_TipoCuentaAhorro') IS NOT NULL
		BEGIN 
		DROP TABLE Temporal_TipoCuentaAhorro
		END

		DECLARE @TipoCuentaAhorroXML xml

		SELECT @TipoCuentaAhorroXML = TCA
		FROM OPENROWSET (Bulk 'Y:\Documents\Ing. Computación\IV Semestre\Bases de datos I\IITP\XML\TipoCuentaAhorro.xml', Single_BLOB) AS TipoCuentaAhorro(TCA)

		EXEC sp_xml_preparedocument @hdoc OUTPUT, @TipoCuentaAhorroXML

		SELECT  Nombre, Saldo_Minimo, Multa_Saldo_Minimo, Monto_Mensual_Cargos_Servicio, 
				Maximo_Retiros_Cajero_Humano, Simbolo_Moneda, Multa_Exceso_Retiro_Cajero, Tasa_Interes_Anualizada
		INTO Temporal_TipoCuentaAhorro
		FROM OPENXML (@hdoc, '/SistemaBanc/TipoCuentaAhorro')
		WITH ( 
			Nombre nvarchar(50) 'nombre',
			Saldo_Minimo money 'saldoMinimo',
			Multa_Saldo_Minimo money 'multaSaldoMinimo',
			Monto_Mensual_Cargos_Servicio money 'montoMensual',
			Maximo_Retiros_Cajero_Humano int 'retiros',
			Simbolo_Moneda nvarchar(3) 'simMoneda',
			Multa_Exceso_Retiro_Cajero money 'retirosCajero',
			Tasa_Interes_Anualizada int 'tasaIntereses'
		)

		EXEC sp_xml_removedocument @hdoc

		INSERT INTO TipoCuentaAhorro
		SELECT Moneda.id, Temporal_TipoCuentaAhorro.Nombre, Temporal_TipoCuentaAhorro.Saldo_Minimo,
				Temporal_TipoCuentaAhorro.Multa_Saldo_Minimo, Temporal_TipoCuentaAhorro.Monto_Mensual_Cargos_Servicio,
				Temporal_TipoCuentaAhorro.Maximo_Retiros_Cajero_Humano, Temporal_TipoCuentaAhorro.Multa_Exceso_Retiro_Cajero, 
				Temporal_TipoCuentaAhorro.Tasa_Interes_Anualizada
		FROM Moneda, Temporal_TipoCuentaAhorro
		WHERE Moneda.Simbolo = Temporal_TipoCuentaAhorro.Simbolo_Moneda

		DROP TABLE Temporal_TipoCuentaAhorro

	---- Insercion del Cliente

	--	IF OBJECT_ID('Temporal_Cliente') IS NOT NULL
	--	BEGIN 
	--	DROP TABLE Temporal_Cliente
	--	END

	--	SET NOCOUNT ON

	--	DECLARE @ClienteXML xml

	--	SELECT @ClienteXML = C
	--	FROM OPENROWSET (Bulk 'Y:\Documents\Ing. Computación\IV Semestre\Bases de datos I\IITP\XML\Cliente.xml', Single_BLOB) AS Cliente(C)

	--	EXEC sp_xml_preparedocument @hdoc OUTPUT, @ClienteXML

	--	SELECT  Fecha_Nacimiento, Usuario, Clave, Tipo_Documento_Identificacion, Documento_Identificacion,
	--			Email, Telefono1, Telefono2, Nombre
	--	INTO Temporal_Cliente
	--	FROM OPENXML (@hdoc, '/SistemaBanc/Cliente')
	--	WITH (
	--		Fecha_Nacimiento date 'fechaNacimiento',
	--		Usuario nvarchar(100) 'usuario',
	--		Clave nvarchar(100) 'contrasenia',
	--		Tipo_Documento_Identificacion nvarchar(100) 'tipoDocId',
	--		Documento_Identificacion nvarchar(50) 'docID',
	--		Email nvarchar(100) 'email',
	--		Telefono1 int 'telefono1',
	--		Telefono2 int 'telefono2',
	--		Nombre nvarchar(100) 'nombre'
	--	)

	--	EXEC sp_xml_removedocument @hdoc

	--	INSERT INTO dbo.Persona
	--	SELECT TC.Nombre, TC.Numero_Cuenta, TC.Tipo_Documento_Identificacion, 
	--		   TC.Documento_Identificacion, TC.Telefono1, TC.Telefono2, TC.Email,
	--		   TC.Fecha_Nacimiento
	--	FROM Temporal_Cliente TC

	--	DECLARE @id int
	--	SET @id = SCOPE_IDENTITY()

	--	INSERT INTO dbo.Cliente
	--	SELECT @id, TC.Usuario, TC.Clave
	--	FROM Temporal_Cliente TC

	--	DROP TABLE Temporal_Cliente

	---- Insercion de Cuentas de Ahorro

	--	IF OBJECT_ID('Temporal_CuentaAhorro') IS NOT NULL
	--	BEGIN 
	--	DROP TABLE Temporal_CuentaAhorro
	--	END

	--	SET NOCOUNT ON

	--	DECLARE @CuentaAhorroXML xml

	--	SELECT @CuentaAhorroXML = CA
	--	FROM OPENROWSET (Bulk 'Y:\Documents\Ing. Computación\IV Semestre\Bases de datos I\IITP\XML\CuentaAhorro.xml', Single_BLOB) AS CuentaAhorro(CA)

	--	EXEC sp_xml_preparedocument @hdoc OUTPUT, @CuentaAhorroXML

	--	SELECT  Numero_Cuenta, Saldo, TipoCuentaAhorro, Documento_Identificacion_Cliente
	--	INTO Temporal_CuentaAhorro
	--	FROM OPENXML (@hdoc, '/SistemaBanc/CuentaAhorro')
	--	WITH (
	--		Numero_Cuenta nvarchar(50) 'numCuenta',
	--		Saldo money 'saldo',
	--		TipoCuentaAhorro nvarchar(50) 'idTipoCA',
	--		Documento_Identificacion_Cliente nvarchar(100) 'idCliente'
	--	)

	--	EXEC sp_xml_removedocument @hdoc


	--	INSERT INTO CuentaAhorro
	--	SELECT Temporal_CuentaAhorro.Numero_Cuenta, Temporal_CuentaAhorro.Saldo, TipoCuentaAhorro.id, Cliente.id
	--	FROM TipoCuentaAhorro, Cliente, Temporal_CuentaAhorro
	--	WHERE TipoCuentaAhorro.Nombre = Temporal_CuentaAhorro.TipoCuentaAhorro 
	--		and Cliente.Documento_Identificacion = Temporal_CuentaAhorro.Documento_Identificacion_Cliente

	--	DROP TABLE Temporal_CuentaAhorro

	---- Insercion de Beneficiarios

	--IF OBJECT_ID('Temporal_Beneficiario') IS NOT NULL
	--	BEGIN 
	--		DROP TABLE Temporal_Beneficiario
	--	END

	--	SET NOCOUNT ON

	--	DECLARE @BeneficiarioXML xml
	--	DECLARE @SumaPorcentaje int
		
	--	---- Se crea una tabla con el comando SELECT desde el ROWSET con la direccion del xml a abrir en modo Binary Large Object
	--	SELECT @BeneficiarioXML = B -- Seleccionamos la columna @Beneficiario (alias B)
	--	FROM OPENROWSET (Bulk 'Y:\Documents\Ing. Computación\IV Semestre\Bases de datos I\IITP\XML\Beneficiario.xml', Single_BLOB) AS TablaBeneficiarioXML(B) -- desde el rowset con alias TablaBeneficiarioXML
	--	EXEC sp_xml_preparedocument @hdoc OUTPUT, @BeneficiarioXML

	--	-- Se declaran las tablas variables que se van a necesitar
	--	SELECT  Nombre, Parentesco, Porcentaje, Activo, Fecha_Desactivacion,
	--			Tipo_Documento_Identificacion, Documento_Identificacion, 
	--			Email, Telefono1, Telefono2, Numero_Cuenta, Fecha_Nacimiento
	--	INTO Temporal_Beneficiario
	--	FROM OPENXML (@hdoc, '/SistemaBanc/Cliente')
	--	WITH (
	--		Nombre nvarchar(100) 'nombre',
	--		Parentesco nvarchar(3) 'parentesco',
	--		Porcentaje int 'porcentajeBeneficio',
	--		Activo int 'activo',
	--		Fecha_Desactivacion date 'fechaDesactivo',
	--		Tipo_Documento_Identificacion nvarchar(100) 'tipoDocId',
	--		Documento_Identificacion nvarchar(100) 'docID',
	--		Email nvarchar(100) 'email',
	--		Telefono1 int 'telefono1',
	--		Telefono2 int 'telefono2',
	--		Numero_Cuenta nvarchar(100) 'numCuenta',
	--		Fecha_Nacimiento date 'fechaNacimiento'
	--	)
	
	--	INSERT INTO dbo.Persona
	--	SELECT TB.Nombre, TB.Numero_Cuenta, TB.Tipo_Documento_Identificacion, 
	--		   TB.Documento_Identificacion, TB.Telefono1, TB.Telefono2, TB.Email,
	--		   TB.Fecha_Nacimiento
	--	FROM Temporal_Beneficiario TB

	--	SET @id = SCOPE_IDENTITY()

	--	INSERT INTO dbo.Beneficiario
	--	SELECT @id, TB.Parentesco, TB.Porcentaje, TB.Activo, TB.Fecha_Desactivacion
	--	FROM Temporal_Beneficiario TB

	--	EXEC sp_xml_removedocument @hdoc
		

	---- Insercion de Estados de Cuenta

	--	IF OBJECT_ID('Temporal_EstadoCuenta') IS NOT NULL
	--	BEGIN 
	--	DROP TABLE Temporal_EstadoCuenta
	--	END

	--	SET NOCOUNT ON

	--	DECLARE @EstadoCuentaXML xml

	--	SELECT @EstadoCuentaXML = EC
	--	FROM OPENROWSET (Bulk 'Y:\Documents\Ing. Computación\IV Semestre\Bases de datos I\IITP\XML\EstadoCuenta.xml', Single_BLOB) AS EstadoCuenta(EC)
	--	EXEC sp_xml_preparedocument @hdoc OUTPUT, @EstadoCuentaXML

	--	SELECT  Fecha_Inicio, Fecha_Final, Saldo_Inicial, Saldo_Final, Intereses,
	--			Numero_Cuenta
	--	INTO Temporal_EstadoCuenta
	--	FROM OPENXML (@hdoc, '/SistemaBanc/EstadoCuenta')
	--	WITH (
	--		Fecha_Inicio date 'fechaInicio',
	--		Fecha_Final date 'fechaFinal',
	--		Saldo_Inicial money 'saldoInicial',
	--		Saldo_Final money 'saldoFinal',
	--		Intereses money 'intereses',
	--		Numero_Cuenta nvarchar(50) 'numCuenta'
	--	)

	--	EXEC sp_xml_removedocument @hdoc

	--	INSERT INTO EstadoCuenta
	--	SELECT  CuentaAhorro.id, Temporal_EstadoCuenta.Fecha_Inicio, Temporal_EstadoCuenta.Fecha_Final,
	--			Temporal_EstadoCuenta.Saldo_Inicial, Temporal_EstadoCuenta.Saldo_Final, Temporal_EstadoCuenta.Intereses,
	--			Temporal_EstadoCuenta.Numero_Cuenta
	--	FROM CuentaAhorro, Temporal_EstadoCuenta
	--	WHERE CuentaAhorro.Numero_Cuenta = Temporal_EstadoCuenta.Numero_Cuenta

	--	DROP TABLE Temporal_EstadoCuenta

	END TRY

	BEGIN CATCH
		return @@ERROR * -1
	END CATCH
END
GO
/****** Object:  StoredProcedure [dbo].[CASP_EliminarBeneficiario]    Script Date: 11/4/2019 12:40:33 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Austin Hakanson>
-- Create date: <14-10-2019>
-- Description:	<SP para actualizar los datos de 1 usuario>
-- =============================================

CREATE PROCEDURE [dbo].[CASP_EliminarBeneficiario]

	-- Parametros del potencial NUEVO Beneficiario
	@Numero_Cuenta nvarchar(50),
	@Documento_Identificacion nvarchar(50)
AS
BEGIN

-- Se verifica que los parametros no vengan en NULL

	IF @Documento_Identificacion IS NULL
	BEGIN
		return -100001
	END

	IF @Numero_Cuenta IS NULL
	BEGIN
		return -100002
	END
	
	 -- Se valida que exista el estado de cuenta
	IF EXISTS (SELECT CA.id, P.id
			   FROM CuentaAhorro CA, Persona P
			   WHERE CA.Numero_Cuenta = @Numero_Cuenta and P.Documento_Identificacion = @Documento_Identificacion)
	BEGIN
		DECLARE @idPersona int = (SELECT P.id FROM Persona P WHERE P.Documento_Identificacion = @Documento_Identificacion)

		DELETE FROM Beneficiario
		WHERE idPersona = @idPersona

		DELETE FROM Persona
		WHERE Documento_Identificacion = @Documento_Identificacion

		
	END
	ELSE
	BEGIN
		return -100003 -- No se encontro una cuenta con el numero de cuenta suministrado o el Documento de identificacion es incorrecto
	END
END
GO
/****** Object:  StoredProcedure [dbo].[CASP_EstadosCuentaXNumCuenta]    Script Date: 11/4/2019 12:40:33 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Austin Hakanson>
-- Create date: <07-09-19>
-- Description:	<Se obtiene los estados de cuenta pasando un numero de cuenta como parametro>
-- =============================================
CREATE PROCEDURE [dbo].[CASP_EstadosCuentaXNumCuenta]  
	-- Add the parameters for the stored procedure here
	@NumeroCuenta nvarchar(50)
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;
    -- Insert statements for procedure here
	BEGIN TRY
		if @NumeroCuenta is null
			BEGIN
				return -100001
			END
		else
			BEGIN
			SELECT TOP (8) 
				EC.Fecha_Inicio, 
				EC.Fecha_Final,
			    EC.Saldo_Inicial,
		        EC.Saldo_Final,
				EC.Intereses
			FROM dbo.EstadoCuenta EC
			WHERE EC.Numero_Cuenta = @NumeroCuenta
			ORDER BY
				EC.Fecha_Inicio
			END
	END TRY
	BEGIN CATCH
		RETURN @@ERROR*-1
	END CATCH	   
END
GO
/****** Object:  StoredProcedure [dbo].[CASP_GetBeneficiarioPorModificar]    Script Date: 11/4/2019 12:40:33 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Austin Hakanson>
-- Create date: <07-10-2019>
-- Description:	<SP para obtener datos de beneficiario a modificar>
-- =============================================
CREATE PROCEDURE [dbo].[CASP_GetBeneficiarioPorModificar]
	-- Parametros
	@Numero_Cuenta nvarchar(50),
	@Documento_Identificacion nvarchar(50)
AS
BEGIN

	SET NOCOUNT ON;
    -- Insert statements for procedure here
	SELECT P.Nombre, PA.Detalle, B.Porcentaje, P.Tipo_Documento_Identificacion,
			P.Documento_Identificacion, P.Email, P.Telefono1, P.Telefono2, P.Fecha_Nacimiento
	FROM Parentesco PA, Beneficiario B
	INNER JOIN Persona P ON B.idPersona = P.id
	WHERE B.Numero_Cuenta = @Numero_Cuenta and P.Documento_Identificacion = @Documento_Identificacion
			and PA.Nombre = B.Parentesco
END
GO
/****** Object:  StoredProcedure [dbo].[CASP_GetBeneficiariosRestantes]    Script Date: 11/4/2019 12:40:33 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Austin Hakanson>
-- Create date: <10/6/19>
-- Description:	<SP para obtener beneficiarios distintaos al seleccionado para modificar de una cuenta >
-- =============================================
CREATE PROCEDURE [dbo].[CASP_GetBeneficiariosRestantes]
	-- Parametros
	@Numero_Cuenta nvarchar(50),
	@DocID_Beneficiario_Modificar nvarchar(50)
AS
BEGIN

	SET NOCOUNT ON;

    -- Insert statements for procedure here
	SELECT P.Nombre, B.Porcentaje
	FROM Beneficiario B
	INNER JOIN Persona P ON P.id = B.idPersona
	WHERE P.Documento_Identificacion != @DocID_Beneficiario_Modificar 
		  and B.Numero_Cuenta = @Numero_Cuenta and B.Activo = 1
END
GO
/****** Object:  StoredProcedure [dbo].[CASP_GetBeneficiariosXNumCuenta]    Script Date: 11/4/2019 12:40:33 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[CASP_GetBeneficiariosXNumCuenta]
	@NumeroCuenta nvarchar(50)
AS
BEGIN

	SET NOCOUNT ON;

	SELECT P.Nombre, PA.Detalle as Parentesco, B.Porcentaje, P.Tipo_Documento_Identificacion,
			P.Documento_Identificacion, P.Email, P.Telefono1, P.Telefono2,
			P.Fecha_Nacimiento
	FROM Parentesco PA, Beneficiario B
	INNER JOIN Persona P ON P.id = B.idPersona
	WHERE B.Numero_Cuenta = @NumeroCuenta and B.idParentesco = PA.id and B.Activo = 1
END
GO
/****** Object:  StoredProcedure [dbo].[CASP_GetDatosUsuario]    Script Date: 11/4/2019 12:40:33 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Austin Hakanson>
-- Create date: <09-09-2019>
-- Description:	<Obtencion de datos de usuario>
-- =============================================
CREATE PROCEDURE [dbo].[CASP_GetDatosUsuario] 
	-- Add the parameters for the stored procedure here
	@Usuario nvarchar(100),
	@Clave nvarchar(100)
AS
BEGIN
	
	SET NOCOUNT ON

	BEGIN TRY

		IF @Usuario = ''
		BEGIN
			return -100001
		END

		IF @Clave = ''
		BEGIN
			return -100002
		END

		DECLARE @resultado INT
		-- SET NOCOUNT ON added to prevent extra result sets from
		-- interfering with SELECT statements.
		SET NOCOUNT ON;

		-- Insert statements for procedure here
	
		SELECT CA.Numero_Cuenta, P.Nombre
		FROM dbo.CuentaAhorro CA, dbo.Persona P
		INNER JOIN Cliente C ON C.idPersona = P.id
		WHERE (C.Usuario = @Usuario and C.Contrasenia = @Clave) and (CA.idCliente = C.id)
		
	END TRY

	BEGIN CATCH
		return @@ERROR * -1
	END CATCH
END
GO
/****** Object:  StoredProcedure [dbo].[CASP_GetIdMoneda]    Script Date: 11/4/2019 12:40:33 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Austin Hakanson>
-- Create date: <09-09-2019>
-- Description:	<Procedimiento almacenado para 
-- obtener el id de moneda pasando un simbolo 
-- por paramentro>
-- =============================================
CREATE PROCEDURE	[dbo].[CASP_GetIdMoneda]
	-- Add the parameters for the stored procedure here
	@Simbolo nvarchar(3)
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
	SELECT id
	FROM Moneda
	WHERE @Simbolo = Simbolo
END
GO
/****** Object:  StoredProcedure [dbo].[CASP_GetParentescos]    Script Date: 11/4/2019 12:40:33 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Austin Hakanson>
-- Create date: <4-10-2019>
-- Description:	<SP para obtener los tipos de parentesco para poblar un combo box en capa logica>
-- =============================================
CREATE PROCEDURE [dbo].[CASP_GetParentescos]

AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
	SELECT P.id as ID, P.Detalle as Nombre
	FROM dbo.Parentesco P

END
GO
/****** Object:  StoredProcedure [dbo].[CASP_GetPorcentajesDeCuenta]    Script Date: 11/4/2019 12:40:33 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Austin Hakanson>
-- Create date: <27/09/2019>
-- Description:	<SP para obtener la suma de porcentajes de beneficio de los beneficiarios de una cuenta>
-- =============================================
CREATE PROCEDURE [dbo].[CASP_GetPorcentajesDeCuenta] 
	-- Parametros
	@NumeroCuenta nvarchar(50)

AS
BEGIN

	SET NOCOUNT ON;

	SELECT SUM(B.Porcentaje)
	FROM dbo.Beneficiario B
	WHERE B.Numero_Cuenta = @NumeroCuenta
   
END
GO
/****** Object:  StoredProcedure [dbo].[CASP_GetTiposID]    Script Date: 11/4/2019 12:40:33 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Austin Hakanson>
-- Create date: <4-10-2019>
-- Description:	<SP para obtener los tipos de identificacion para poblar un combo box en capa logica>
-- =============================================
CREATE PROCEDURE [dbo].[CASP_GetTiposID]

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
/****** Object:  StoredProcedure [dbo].[CASP_InicioSesion]    Script Date: 11/4/2019 12:40:33 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Austin Hakanson>
-- Create date: <7-09-2019>
-- Description:	<Validacion de inicio de sesion>
-- =============================================
CREATE PROCEDURE [dbo].[CASP_InicioSesion] 
	-- Add the parameters for the stored procedure here
	@Usuario nvarchar(100),
	@Clave nvarchar(100)
AS
BEGIN
	DECLARE @id int
	SET NOCOUNT ON

	BEGIN TRY

		IF @Usuario = ''
		BEGIN
			SET @Usuario = ' '
			return -100001
		END

		IF @Clave = ''
		BEGIN
			SET @Clave = ' '
			return -100002
		END
		

		IF EXISTS(
		SELECT C.id
		FROM Cliente C, CuentaAhorro CA
		WHERE C.Usuario = @Usuario and C.Contrasenia = @Clave and (CA.idCliente = C.id)
		)
		BEGIN
			return 1
		END
		ELSE
			BEGIN
				return 2
			END
	END TRY

	BEGIN CATCH
		return @@ERROR * -1
	END CATCH
END
GO
/****** Object:  StoredProcedure [dbo].[CASP_InsertarBeneficiario]    Script Date: 11/4/2019 12:40:33 AM ******/
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
CREATE PROCEDURE [dbo].[CASP_InsertarBeneficiario]
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
/****** Object:  StoredProcedure [dbo].[CASP_InsertarCliente]    Script Date: 11/4/2019 12:40:33 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Antony Artavia Palma>
-- Create date: <10/10/2019>
-- Last Modificataion date: <11/10/2019> (Austin)
-- Description:	<SP para ingresar un nuevo usario (Cliente) en la BD>
-- =============================================
CREATE PROCEDURE [dbo].[CASP_InsertarCliente]
	-- Add the parameters for the stored procedure here
	@Fecha_Nacimiento date,
	@Usuario nvarchar(100),
	@Contrasenia nvarchar(100),
	@Tipo_Documento_Identificacion nvarchar(100),
	@Documento_Identificacion nvarchar(50),
	@Email nvarchar(100),
	@Telefono1 int,
	@Telefono2 int,
	@Nombre nvarchar(100)
	
AS
BEGIN
	SET NOCOUNT ON;

	BEGIN TRY
	
		-- Se verifica que los parametros no vengan nulos

		IF @Usuario = NULL
		BEGIN
			return -100001
		END
		
		IF @Contrasenia = NULL
		BEGIN
			return -100002
		END
		
		IF @Tipo_Documento_Identificacion = NULL
		BEGIN
			return -100003
		END

		IF @Documento_Identificacion = NULL
		BEGIN
			return -100004
		END

		IF @Email = NULL
		BEGIN
			return -100005
		END

		IF @Telefono1 = NULL
		BEGIN
			return -100006
		END

		IF @Telefono2 = NULL
		BEGIN
			return -100007
		END

		IF @Nombre = NULL
		BEGIN
			return -100008
		END

		-- Se verifica si ya existia el cliente en la base de datos
		IF EXISTS(SELECT *
					FROM Persona P
					WHERE P.Documento_Identificacion = @Documento_Identificacion)
			BEGIN
				return -100009 -- El Cliente ingresado ya existe
			END
		ELSE
			BEGIN
				INSERT INTO dbo.Persona
				SELECT TID.id, @Nombre, @Tipo_Documento_Identificacion,  @Documento_Identificacion,
					   @Telefono1, @Telefono2, @Email, @Fecha_Nacimiento
				FROM TipoID TID
				WHERE TID.Nombre = @Tipo_Documento_Identificacion

				-- Se guarda el id de la ultima persona agregada
				DECLARE @idAgregado int
				SELECT @idAgregado = max(P.id)
				FROM Persona P

				INSERT INTO dbo.Cliente
				SELECT @idAgregado, @Usuario, @Contrasenia
			END
	END TRY

	BEGIN CATCH
		return @@ERROR * -1
	END CATCH
END
GO
/****** Object:  StoredProcedure [dbo].[SP_GetMovimientosDeEstadoCuenta]    Script Date: 11/4/2019 12:40:33 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Austin Hakanson>
-- Create date: <03-11-2019>
-- Description:	<SP para obtener los movimientos de un estado de cuenta>
-- =============================================
CREATE PROCEDURE [dbo].[SP_GetMovimientosDeEstadoCuenta] 
	
	-- Parametros
	@FechaInicio date,
	@FechaFin date,
	@Numero_Cuenta nvarchar(50)

AS
BEGIN

	SET NOCOUNT ON;

    -- Insert statements for procedure here
	SELECT CA.Numero_Cuenta, M.Tipo_Movimiento, M.Monto, M.NuevoSaldo, M.Descripcion
	FROM Movimiento M
	INNER JOIN Cuenta_Ahorro CA ON CA.id = M.idCuenta
	WHERE M.Fecha >= @FechaInicio and M.Fecha < @FechaFin and CA.Numero_Cuenta = @Numero_Cuenta
END
GO
/****** Object:  StoredProcedure [dbo].[SP_Simulacion]    Script Date: 11/4/2019 12:40:33 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Austin Hakanson>
-- Create date: <10/11/2019>
-- Description:	<SP para hacer la simulacion de actividades>
-- =============================================
CREATE PROCEDURE [dbo].[SP_Simulacion]

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
	Numero_Cuenta nvarchar(100)
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

				UPDATE dbo.Beneficiario
				SET idParentesco = (SELECT PA.id FROM Parentesco PA WHERE PA.Nombre = B.Parentesco),
					Parentesco = B.Parentesco,
					Porcentaje = B.Porcentaje,
					Numero_Cuenta = B.Numero_Cuenta
				FROM Persona P, @BeneficiariosExistentes B
				WHERE idPersona = (SELECT P.id FROM Persona P WHERE P.Documento_Identificacion = B.Documento_Identificacion)
					 and B.id = @lo

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
				SELECT 'Hubo un error al agregar los beneficiarios nuevos'
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

			SET @lo = (SELECT COUNT(CO.sec) FROM @CuentasObjetivoPorAcreditar CO )
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
							WHERE id = (SELECT CO.id
										FROM CuentaObjetivo CO
										INNER JOIN @CuentasObjetivoPorAcreditar C ON CO.id = C.idCuentaObjetivo and C.sec = @lo)
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
					--ELSE
					--BEGIN 
						--SELECT CA.id, CO.Numero_Cuenta, @fechaIteracion, 'No se realizo la transaccion a la cuenta objetivo porque el saldo quedaba negativo'
						--FROM CuentaObjetivo CO
						--INNER JOIN @CuentasObjetivoPorAcreditar C ON CO.id = C.idCuentaObjetivo and C.sec = @lo
						--INNER JOIN Cuenta_Ahorro CA ON CA.Numero_Cuenta = CO.Numero_Cuenta
					--END

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
					Return -100006
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
					Return -100007
				END
		
		END CATCH

		
		SET @fechaIteracion = (SELECT DATEADD(day, 1, @fechaIteracion))
	END

END
GO
USE [master]
GO
ALTER DATABASE [Sistema_Banco] SET  READ_WRITE 
GO
