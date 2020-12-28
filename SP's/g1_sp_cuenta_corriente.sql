USE cobis
GO
CREATE PROCEDURE g1_sp_cuenta_corriente (
	@s_ssn			int = NULL,
	@s_user			login = NULL,
	@s_sesn			int = NULL,
	@s_term			varchar(32) = NULL,
	@s_date			datetime = NULL,
	@s_srv			varchar(30) = NULL,
	@s_lsrv			varchar(30) = NULL, 
	@s_rol			smallint = NULL,
	@s_ofi			smallint = NULL,
	@s_org_err		char(1) = NULL,
	@s_error		int = NULL,
	@s_sev			tinyint = NULL,
	@s_msg			descripcion = NULL,
	@s_org			char(1) = NULL,
	@t_debug		char(1) = 'N',
	@t_file			varchar(14) = null,
	@t_from			varchar(32) = null,
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
						@t_debug  = @t_debug,
                        @t_file   = @t_file,
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

