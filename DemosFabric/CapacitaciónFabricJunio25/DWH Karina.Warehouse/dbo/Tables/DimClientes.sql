CREATE TABLE [dbo].[DimClientes] (

	[CodigoGrupoCliente] bigint NULL, 
	[Nombre Grupo] varchar(8000) NULL, 
	[Sucursal] varchar(8000) NULL, 
	[DimClienteId] bigint NULL, 
	[CP] varchar(8000) NULL, 
	[Pais] varchar(8000) NULL, 
	[Colonia] varchar(8000) NULL, 
	[Desc_Estado] varchar(8000) NULL, 
	[Codigo_Estado] varchar(8000) NULL, 
	[Desc_Municipio] varchar(8000) NULL, 
	[Codigo_Municipio] bigint NULL, 
	[LAT] bigint NULL, 
	[LONG] bigint NULL, 
	[InfoComplementariaCliente.NivelDeServicio] varchar(8000) NULL, 
	[InfoComplementariaCliente.Region] varchar(8000) NULL, 
	[URL Web] varchar(8000) NULL
);