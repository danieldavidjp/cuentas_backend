INSERT INTO dbo.ad_procedure (pd_procedure, pd_stored_procedure, pd_base_datos, pd_estado, pd_fecha_ult_mod, pd_archivo)
VALUES (2519, 'sp_operaciones', 'cobis', 'V', GETDATE(), 'sp_operaciones')
GO


INSERT INTO dbo.ad_pro_transaccion (pt_producto, pt_tipo, pt_moneda, pt_transaccion, pt_estado, pt_fecha_ult_mod, pt_procedure, pt_especial)
VALUES (7, 'R', 0, 25190, 'V', GETDATE(), 2519, NULL)
GO


SELECT * FROM ad_pro_transaccion WHERE pt_transaccion=25190

SELECT * FROM cl_ttransaccion WHERE tn_trn_code = 2519


INSERT INTO dbo.cl_ttransaccion (tn_trn_code, tn_descripcion, tn_nemonico, tn_desc_larga)
VALUES (25190, 'g1 Operaciones', 'CTA', 'g1 operaciones')
GO


SELECT * FROM cl_ttransaccion WHERE tn_trn_code = 25190

SELECT * FROM ad_tr_autorizada WHERE ta_transaccion=2519


INSERT INTO dbo.ad_tr_autorizada (ta_producto, ta_tipo, ta_moneda, ta_transaccion, ta_rol, ta_fecha_aut, ta_autorizante, ta_estado, ta_fecha_ult_mod)
VALUES (7, 'R', 0, 25190, 3, GETDATE(), 1, 'V', GETDATE())
GO

INSERT INTO dbo.ad_tr_autorizada (ta_producto, ta_tipo, ta_moneda, ta_transaccion, ta_rol, ta_fecha_aut, ta_autorizante, ta_estado, ta_fecha_ult_mod)
VALUES (7, 'R', 0, 25190, 7, getdate(), 1, 'V', GETDATE())
GO

SELECT * FROM ad_tr_autorizada WHERE ta_transaccion=25190