CREATE TABLE [dbo].[Limite de Credito] (

	[ACCOUNTNUM] bigint NULL, 
	[Cliente] varchar(8000) NULL, 
	[Importe] float NULL, 
	[Limite de Credito] float NULL
);


GO
ALTER TABLE [dbo].[Limite de Credito] ADD CONSTRAINT FK_4f45965f_c5cd_4165_861e_600e637b9e93 FOREIGN KEY ([ACCOUNTNUM]) REFERENCES [dbo].[CustTrans_to_AML]([ACCOUNTNUM]);