CREATE TABLE [dbo].[StagingVentas] (

	[Source.Name] varchar(8000) NULL, 
	[VENTA_ID] bigint NULL, 
	[FECHA] date NULL, 
	[SUCURSAL_CLIENTE] bigint NULL, 
	[ARTICULO] bigint NULL, 
	[CANTIDAD] bigint NULL, 
	[SUBTOTAL] bigint NULL, 
	[IVA] float NULL, 
	[VENDEDOR] bigint NULL
);