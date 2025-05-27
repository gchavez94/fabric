-- Auto Generated (Do not modify) 2598E40BF3AC19CE7325F424FF3B80F80BD3339C2CBAAB743E9B175925600D25
CREATE view [dbo].[CustTrans_to_AML_TESTCAMPO]

AS 

SELECT 
            --CTTAML.[CASHDISCCODE],
--CTTAML.[CANCELLEDPAYMENT],
CTTAML.[ACCOUNTNUM],
--CTTAML.[AMOUNTCUR],
CTTAML.[AMOUNTMST],
--CTTAML.[APPROVED],
CTTAML.[CLOSED],
--CTTAML.[CORRECT],
--CTTAML.[CURRENCYCODE],
--CTTAML.[DOCUMENTDATE],
CTTAML.[DUEDATE],
CTTAML.[INVOICE],
--CTTAML.[LASTSETTLEDATE],
--CTTAML.[PAYMMETHOD],
--CTTAML.[PAYMMODE],
--CTTAML.[SETTLEAMOUNTCUR],
CTTAML.[SETTLEAMOUNTMST],
CTTAML.[TRANSDATE],
CTTAML.[TRANSTYPE],
--CTTAML.[TXT],
--CTTAML.[VOUCHER],
CTTAML.[PAYMTERMID],
CTTAML.[DATAAREAID],
CTTAML.[RECID],
CTTAML.[CREATEDDATETIME],
CTTAML.[Status],
--CTTAML.[Dias_Pago],
--CTTAML.[DESCRIPTION],
CTTAML.[NUMOFDAYS],
CTTAML.[CUSTGROUP],
CTTAML.[NAME],
CTTAML.[Morosidad],
--CTTAML.[Dias_Pago_Hoy],
CTTAML.[Dias_Transcurridos_Pago],
CTTAML.[Tipo_de_Factura],

            WH.Fecha_Pronostico_Pago,
            WH.Dias_Pronostico_Pago,
            WH.Prevision_Incobrables_ID,
            WH.Previsión_Incobrables,
            WH.Pronostico_Morosidad_ID,
            WH.Pronostico_Morosidad,
            WH.Clasificacion_de_Riesgo_ID,
            WH.Clasificacion_Riesgo,
            WH.Morosidad as Morosidad2WH,
            WH.NumFecha,
            WH.AgingMostrar
            

FROM [dataverse_cdsgcg_cds2_workspace_29f750ecf23a477bb1c523dc50d41058].[dbo].[CustTrans_to_AML_1] AS CTTAML 
LEFT JOIN [dataverse_cdsgcg_cds2_workspace_29f750ecf23a477bb1c523dc50d41058].[dbo].[CustTrans_to_AML_2WH] AS WH ON CTTAML.RECID= WH.RECID