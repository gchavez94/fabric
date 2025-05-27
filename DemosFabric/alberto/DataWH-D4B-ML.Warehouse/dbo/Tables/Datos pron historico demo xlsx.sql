CREATE TABLE [dbo].[Datos pron historico demo xlsx] (

	[Fecha] date NULL, 
	[Esperado] float NULL, 
	[Pronóstico] float NULL, 
	[Real] float NULL, 
	[Pronostico_Historico] float NULL
);


GO
ALTER TABLE [dbo].[Datos pron historico demo xlsx] ADD CONSTRAINT FK_4474f06c_1d58_4ab7_b823_b3f21558422e FOREIGN KEY ([Fecha]) REFERENCES [dbo].[Calendario_Trad]([Date]);