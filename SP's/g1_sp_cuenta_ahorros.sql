USE cobis
go
IF OBJECT_ID ('dbo.g1_sp_cuenta_ahorros') IS NOT NULL
	DROP PROCEDURE dbo.g1_sp_cuenta_ahorros
GO

CREATE PROCEDURE g1_sp_cuenta_ahorros
   @s_srv           varchar(30) = NULL,
   @s_ssn           int         = NULL,
   @s_ssn_branch    int         = 0,
   @s_date          datetime    = NULL,
   @s_ofi           smallint    = NULL,
   @s_user          varchar(30) = NULL,
   @s_lsrv				varchar(30) = NULL,
   @s_rol				smallint    = 1,
   @s_term				varchar(10) = NULL,
   @s_org				char(1)     = NULL,
   @s_culture			varchar(10) = 'NEUTRAL',
   @t_file				varchar(14) = NULL,
   @i_operacion			char(1),
   @t_trn				INT =99,
   @i_banco				VARCHAR(30) = NULL,
   @i_fecha_creacion		VARCHAR(30) = NULL,     
   @i_fecha_modificacion	VARCHAR(30) = NULL,
   @i_cliente		VARCHAR(30) = NULL,
   @i_saldo	VARCHAR(30) = NULL
   
  
AS
    declare @w_sp_name       varchar(14)
            
   	select @w_sp_name = 'g1_sp_cuenta_ahorros'
   
            
    IF @i_operacion='I'
    BEGIN
    	INSERT INTO g1_cuenta_ahorros
    		(ca_banco, ca_fecha_creacion, ca_fecha_modificacion, ca_cliente, ca_saldo)
    	VALUES 
    		(@i_banco, getdate(),		  getdate(), @i_cliente, @i_saldo)
    END
    
   return 0