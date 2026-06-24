CREATE TABLE [dbo].[FactVentas] (

	[IdVenta] bigint NULL, 
	[Fecha] date NULL, 
	[DimClienteId] bigint NULL, 
	[DimArticuloId] bigint NULL, 
	[Cantidad] bigint NULL, 
	[Subtotal] bigint NULL, 
	[Iva] float NULL, 
	[Total] float NULL, 
	[DimVendedorId] bigint NULL
);