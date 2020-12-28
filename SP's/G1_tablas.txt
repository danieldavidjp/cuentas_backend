CREATE TABLE g1_cuenta_ahorros
	(
	ca_banco				INT NOT NULL,
	ca_fecha_creacion		DATETIME NOT NULL,
	ca_fecha_modificacion	DATETIME NOT NULL,
	ca_cliente				VARCHAR (30) NOT NULL,
	ca_saldo				FLOAT NOT NULL
	)
GO

CREATE TABLE g1_cuenta_corriente
	(
	cc_banco				INT NOT NULL,
	cc_fecha_creacion		DATETIME NOT NULL,
	cc_fecha_modificacion	DATETIME NOT NULL,
	cc_cliente				VARCHAR (30) NOT NULL,
	cc_saldo				FLOAT NOT NULL
	)
GO


CREATE TABLE g1_transaccion 
	(
		tr_id				int not null,
		tr_fecha			DATETIME NOT NULL,
		tr_cuenta			INT NOT NULL,	--(numero de la cuenta xx_banco)
		tr_tipo_tr			CHAR(1) NOT NULL, --(D,R)
		tr_tipo_cuenta		VARCHAR(30) NOT NULL	--(ahorro,corriente)
	)
GO