CREATE TABLE [dbo].[FactVentas] (

	[VENTA_ID] bigint NULL, 
	[DimFechaId] date NULL, 
	[DimClienteId] bigint NULL, 
	[DimArticuloId] bigint NULL, 
	[CANTIDAD] bigint NULL, 
	[SUBTOTAL] bigint NULL, 
	[IVA] float NULL, 
	[DimVendedorId] bigint NULL, 
	[Total] float NULL
);