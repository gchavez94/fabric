CREATE TABLE [dbo].[FactVentas] (

	[VENTA_ID] int NULL, 
	[FECHA] datetime2(6) NULL, 
	[SUCURSAL_CLIENTE] int NULL, 
	[ARTICULO] int NULL, 
	[CANTIDAD] int NULL, 
	[SUBTOTAL] int NULL, 
	[IVA] float NULL, 
	[VENDEDOR] int NULL
);