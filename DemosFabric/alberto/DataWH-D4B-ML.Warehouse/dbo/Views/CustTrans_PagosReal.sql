-- Auto Generated (Do not modify) D2BCFA1867631E84B86448CFC4F922B8AE71A0A209F2BFABCC0D070E43A96549
create VIEW [dbo].[CustTrans_PagosReal]
as SELECT *
FROM [dataverse_cdsgcg_cds2_workspace_29f750ecf23a477bb1c523dc50d41058].[dbo].[CustTrans_to_AML]
WHERE DATAAREAID='ifa' and Status='Cerrada'