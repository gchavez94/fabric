CREATE TABLE [dbo].[DimCliente] (

	[DimClienteId] bigint NULL, 
	[NombreCliente] varchar(8000) NULL, 
	[Sucursal] varchar(8000) NULL, 
	[Pais] varchar(8000) NULL, 
	[Estado] varchar(8000) NULL, 
	[Municipio] varchar(8000) NULL, 
	[Latitud] bigint NULL, 
	[Longitud] bigint NULL
);