INSERT INTO dbo.ad_procedure (pd_procedure, pd_stored_procedure, pd_base_datos, pd_estado, pd_fecha_ult_mod, pd_archivo)
VALUES (2517, 'g1_sp_cuenta_ahorros', 'cobis', 'V', getdate(), 'cuenta_ahorros')
GO


INSERT INTO dbo.ad_pro_transaccion (pt_producto, pt_tipo, pt_moneda, pt_transaccion, pt_estado, pt_fecha_ult_mod, pt_procedure, pt_especial)
VALUES (7, 'R', 0, 25170, 'V', GETDATE(), 2517, NULL)
GO

INSERT INTO dbo.cl_ttransaccion (tn_trn_code, tn_descripcion, tn_nemonico, tn_desc_larga)
VALUES (25170, 'g1 cuenta ahorro', 'G1CA', 'g1 cuenta ahorro')
GO

INSERT INTO dbo.ad_tr_autorizada (ta_producto, ta_tipo, ta_moneda, ta_transaccion, ta_rol, ta_fecha_aut, ta_autorizante, ta_estado, ta_fecha_ult_mod)
VALUES (7, 'R', 0, 25170, 7, GETDATE(), 1, 'V', GETDATE())
GO


SELECT * FROM ad_tr_autorizada WHERE ta_transaccion=25170