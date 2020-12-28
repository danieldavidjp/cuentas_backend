USE cobis
GO
CREATE PROCEDURE g1_sp_cuenta_corriente (
	@t_trn				int			= 1,
	@i_saldo			float		= 50,
	@i_numero_cuenta	varchar(10),
	@i_cod_cliente		int,
	@i_operacion		char(1)
)
AS
	declare @w_return	int,
			@w_sp_name	varchar(50)

	select @w_sp_name = 'g1_sp_cuenta_corriente'

	IF @i_operacion = 'I'
	BEGIN
	-- Verificar que no exista ya el numero de cuenta
	SELECT * FROM g1_cuenta_corriente WHERE cc_banco = @i_numero_cuenta;
		IF @@ROWCOUNT > 0
		BEGIN
			exec cobis..sp_cerror
                        @t_from  = @w_sp_name,
                        @i_num   = 105001 -- TODO: crear codigo de error en la bd
                return 1
		END
	-- Si no existe insertamos el registro
	INSERT INTO g1_cuenta_corriente
		(cc_banco,			cc_fecha_creacion, cc_fecha_modificacion,	cc_cliente,		cc_saldo)
	VALUES
		(@i_numero_cuenta,	GETDATE(),			GETDATE(),				@i_cod_cliente, @i_saldo)
	END

	RETURN 0

