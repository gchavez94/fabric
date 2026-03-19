CREATE TABLE [dbo].[StagingVentasMenudeo] (

	[Source.Name] varchar(8000) NULL, 
	[VENTA_ID] bigint NULL, 
	[FECHA] date NULL, 
	[SUCURSAL_CLIENTE] bigint NULL, 
	[ARTICULO] bigint NULL, 
	[CANTIDAD] bigint NULL, 
	[SUBTOTAL] bigint NULL, 
	[IVA] bigint NULL, 
	[VENDEDOR] bigint NULL
);