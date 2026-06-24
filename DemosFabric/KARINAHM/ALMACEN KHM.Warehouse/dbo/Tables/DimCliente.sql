CREATE TABLE [dbo].[DimCliente] (

	[CodigoGrupoCliente] int NULL, 
	[Nombre_Grupo_Sucursal] varchar(8000) NULL, 
	[CodigoSucursal] int NULL, 
	[CP] int NULL, 
	[Pais] varchar(8000) NULL, 
	[Colonia] varchar(8000) NULL, 
	[Desc_Estado] varchar(8000) NULL, 
	[Codigo_Estado] varchar(8000) NULL, 
	[Desc_Municipio] varchar(8000) NULL, 
	[Codigo_Municipio] smallint NULL, 
	[LAT] float NULL, 
	[LONG] float NULL, 
	[DescripcionServicio] varchar(9) NULL
);