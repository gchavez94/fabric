CREATE TABLE [dbo].[CustTable] (

	[PAYMTERMID] varchar(8000) NULL, 
	[LINEDISC] varchar(8000) NULL, 
	[PARTYCOUNTRY] varchar(8000) NULL, 
	[ACCOUNTNUM] bigint NULL, 
	[BANKACCOUNT] bigint NULL, 
	[CREDITMAX] bigint NULL, 
	[CREDITRATING] varchar(8000) NULL, 
	[CURRENCY] varchar(8000) NULL, 
	[CUSTGROUP] varchar(8000) NULL, 
	[PARTY] bigint NULL, 
	[RFC_MX] varchar(8000) NULL, 
	[DATAAREAID] varchar(8000) NULL, 
	[RECID] bigint NULL, 
	[NAME] varchar(8000) NULL, 
	[Cliente Prov] varchar(8000) NULL
);


GO
ALTER TABLE [dbo].[CustTable] ADD CONSTRAINT FK_e70ba4cf_8454_4ff0_8430_403f984709b8 FOREIGN KEY ([ACCOUNTNUM]) REFERENCES [dbo].[CustTrans_to_AML]([ACCOUNTNUM]);