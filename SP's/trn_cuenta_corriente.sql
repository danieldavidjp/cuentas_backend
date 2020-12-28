SELECT TOP 10 * FROM ad_procedure WHERE pd_procedure = 2518

INSERT INTO dbo.ad_procedure 
		(pd_procedure, pd_stored_procedure, 		pd_base_datos, 	pd_estado, 	pd_fecha_ult_mod, 	pd_archivo)
VALUES 	(2518, 			'g1_sp_cuenta_corriente', 	'cobis', 		'V', 		GETDATE(), 			'c_corriente.sp')
GO

INSERT INTO dbo.ad_pro_transaccion (pt_producto, pt_tipo, pt_moneda, pt_transaccion, pt_estado, pt_fecha_ult_mod, pt_procedure, pt_especial)
VALUES (7, 'R', 0, 2518, 'V', GETDATE(), 2518, NULL)
GO

SELECT * FROM ad_pro_transaccion WHERE pt_transaccion = 2518

SELECT * FROM cl_ttransaccion WHERE tn_trn_code = 2518

INSERT INTO dbo.cl_ttransaccion (tn_trn_code, tn_descripcion, tn_nemonico, tn_desc_larga)
VALUES (2518, 'cuenta corriente', 'G1CC', 'sp cuenta corriente')
GO
SELECT * FROM cl_ttransaccion WHERE tn_trn_code = 2518

SELECT * FROM ad_tr_autorizada WHERE ta_transaccion=2518

//REEMPLAZAMOS EL NUMERO DE TRANSACCION DEL SP
INSERT INTO dbo.ad_tr_autorizada (ta_producto, ta_tipo, ta_moneda, ta_transaccion, ta_rol, ta_fecha_aut, ta_autorizante, ta_estado, ta_fecha_ult_mod)
VALUES (7, 'R', 0, 2518, 3, GETDATE(), 1, 'V', GETDATE())
GO

INSERT INTO dbo.ad_tr_autorizada (ta_producto, ta_tipo, ta_moneda, ta_transaccion, ta_rol, ta_fecha_aut, ta_autorizante, ta_estado, ta_fecha_ult_mod)
VALUES (7, 'R', 0, 2518, 7, getdate(), 1, 'V', GETDATE())
GO

SELECT * FROM ad_tr_autorizada WHERE ta_transaccion=2518