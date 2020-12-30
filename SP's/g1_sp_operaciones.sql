IF OBJECT_ID ('dbo.g1_sp_operaciones') IS NOT NULL
	DROP PROCEDURE dbo.g1_sp_operaciones
GO

CREATE PROC g1_sp_operaciones 
/****************************************************************************/
/*     Archivo:     g1_sp_operaciones.sp								    */
/*     Stored procedure: g1_sp_operaciones                                  */
/*     Base de datos: Cobis											        */
/*     Producto: Capacitacion                                               */
/*     Disenado por:    Jesus garcia                                        */
/*     Fecha de escritura: 28/Dic/2020                                      */
/****************************************************************************/
/*                            IMPORTANTE                                    */
/*    Esta aplicacion es parte de los paquetes bancarios propiedad          */
/*    de COBISCorp.                                                         */
/*    Su uso no    autorizado queda  expresamente   prohibido asi como      */
/*    cualquier    alteracion o  agregado  hecho por    alguno  de sus      */
/*    usuarios sin el debido consentimiento por   escrito de COBISCorp.     */
/*    Este programa esta protegido por la ley de   derechos de autor        */
/*    y por las    convenciones  internacionales   de  propiedad inte-      */
/*    lectual.    Su uso no  autorizado dara  derecho a    COBISCorp para   */
/*    obtener ordenes  de secuestro o  retencion y para  perseguir          */
/*    penalmente a los autores de cualquier   infraccion.                   */
/****************************************************************************/
/*                           PROPOSITO                                      */
/* Consulta, Insercion, actualizacion y eliminacion					        */
/*                                                          			    */
/****************************************************************************/
/*                           MODIFICACIONES                                 */
/*       FECHA          AUTOR           RAZON                               */
/*     28/Dic/2020     Jesus Garcia     Version inicial                     */ 
/*     29/Dic/2020     Daniel Jimenez   Operacion U para consulta           */  
/*     									de cuentas ahorro		            */
/*     30/Dic/2020     Daniel Jimenez   Operacion M consulta transacciones  */      
/****************************************************************************/

(
@i_cuenta		VARCHAR(30),
@i_cuentaD		INT = NULL,
@i_valor		FLOAT = 0.0,
@i_tipoCuenta	CHAR(1) = null,
@i_operacion	char(1),
@t_trn			INT =99 ---25190
)
as 


DECLARE 
	@w_sp_name  varchar(32),
    @t_file     varchar(10) = null,
    @t_debug 	CHAR(1),
    @w_rows 	INT,
    @w_exist	INT -- 1-> Ahorro 2-> Corriente
    


select @w_rows = isnull((select max(tr_id) from g1_transaccion), 0)
select @w_rows = @w_rows + 1


select @t_debug = 'N'
select @w_sp_name = 'sp_direccion_cons'


IF EXISTS(SELECT 1 from g1_cuenta_ahorros WHERE ca_banco = @i_cuenta)
	BEGIN
		SELECT @w_exist = 1
	   
	END
ELSE IF EXISTS(SELECT 1 from g1_cuenta_corriente WHERE cc_banco = @i_cuenta)
	BEGIN
		SELECT @w_exist = 2
		
	END
ELSE	
	BEGIN
		SELECT @w_exist = 0
	END


IF @i_operacion = 'U'

	IF	(@w_exist = 1)
		BEGIN
			SELECT 
				cl_cedula, 
				cl_nombre, 
				cl_apellido,
				ca_banco,
				ca_saldo,
				'A' AS tipo_cuenta
			FROM 
				cliente_taller C, 
				g1_cuenta_ahorros O
			WHERE 
				C.cl_id = O.ca_cliente 
				AND 
				O.ca_banco = @i_cuenta
    	END
    ELSE IF (@w_exist = 2)
     	BEGIN
			SELECT 
				cl_cedula, 
				cl_nombre, 
				cl_apellido,
				cc_banco,
				cc_saldo,
				'C' AS tipo_cuenta
			FROM 
				cliente_taller C, 
				g1_cuenta_corriente O
			WHERE 
				C.cl_id = O.cc_cliente 
				AND 
				O.cc_banco = @i_cuenta
    	END	
    ELSE
    	BEGIN
		exec cobis..sp_cerror					   
			@t_debug  = @t_debug,                        
			@t_file   = @t_file,                       
			@t_from  = @w_sp_name,                       
			@i_num   = 1853 -- La cuenta ya existe                return 1
		END

if @i_operacion = 'C' 
begin
	
	IF (@w_exist = 2)
		BEGIN
			UPDATE g1_cuenta_corriente
				SET 
					cc_saldo = cc_saldo + @i_valor
				WHERE 
					cc_banco = @i_cuenta

					
	    	INSERT INTO g1_transaccion
			    (tr_id,	tr_fecha,	tr_cuenta,		tr_tipo_tr,	tr_tipo_cuenta)
			VALUES
			    (@w_rows,getdate(),	@i_cuenta,		'D',		'Corriente')
			    
		END
		
	ELSE IF (@w_exist = 1)
		BEGIN
	    	UPDATE g1_cuenta_ahorros
				SET 
					ca_saldo = ca_saldo + @i_valor
				WHERE
					ca_banco = @i_cuenta
					
	    	INSERT INTO g1_transaccion
			    (tr_id,	tr_fecha,	tr_cuenta,		tr_tipo_tr,	tr_tipo_cuenta)
			VALUES
			    (@w_rows,getdate(),	@i_cuenta,		'D',		'Ahorro')
		END
	ELSE 
		BEGIN
		exec cobis..sp_cerror					   
			@t_debug  = @t_debug,                        
			@t_file   = @t_file,                       
			@t_from  = @w_sp_name,                       
			@i_num   = 1853 -- La cuenta ya existe                return 1
		END
end

if @i_operacion = 'R' 
begin

  	IF (@w_exist = 2)
		BEGIN
		
			UPDATE g1_cuenta_corriente
				SET 
					cc_saldo = cc_saldo - @i_valor
				WHERE
					cc_banco= @i_cuenta
					
	    	INSERT INTO g1_transaccion
			  (tr_id,	tr_fecha,	tr_cuenta,		tr_tipo_tr,	tr_tipo_cuenta)
			VALUES
			    (@w_rows,getdate(),	@i_cuenta,		'R',		'Corriente')
		END
	ELSE IF (@w_exist = 1)
		BEGIN
	    	UPDATE g1_cuenta_ahorros
				SET 
					ca_saldo = ca_saldo - @i_valor
				WHERE
					ca_banco= @i_cuenta
					
	    	INSERT INTO g1_transaccion
			    (tr_id,	tr_fecha,	tr_cuenta,		tr_tipo_tr,	tr_tipo_cuenta)
			VALUES
			    (@w_rows,getdate(),	@i_cuenta,		'R',		'Ahorro')
		END
	ELSE 
		BEGIN
		exec cobis..sp_cerror					   
			@t_debug  = @t_debug,                        
			@t_file   = @t_file,                       
			@t_from  = @w_sp_name,                       
			@i_num   = 1853 -- La cuenta ya existe                return 1
		END
END

IF @i_operacion = 'M'
BEGIN
	IF (@w_exist <> 0)
		BEGIN
			SELECT
				tr_id,
				tr_fecha,
				tr_cuenta,
				tr_tipo_tr,
				tr_tipo_cuenta
			FROM g1_transaccion
			WHERE tr_cuenta = @i_cuenta
		END
	ELSE 
		BEGIN
		exec cobis..sp_cerror					   
			@t_debug  = @t_debug,                        
			@t_file   = @t_file,                       
			@t_from  = @w_sp_name,                       
			@i_num   = 1853 -- La cuenta ya existe                return 1
		END
END

IF @i_operacion = 'T'
BEGIN
	IF EXISTS(SELECT 1 from g1_cuenta_ahorros WHERE ca_banco = @i_cuentaD)
		BEGIN
		  	IF (@w_exist = 2)
				BEGIN
				
					UPDATE g1_cuenta_corriente
						SET 
							cc_saldo = cc_saldo - @i_valor
						WHERE
							cc_banco= @i_cuenta
							
					UPDATE g1_cuenta_ahorros
						SET 
							ca_saldo = ca_saldo + @i_valor
						WHERE
							ca_banco= @i_cuentaD
							
			    	INSERT INTO g1_transaccion
					  (tr_id,	tr_fecha,	tr_cuenta,		tr_tipo_tr,	tr_tipo_cuenta)
					VALUES
					    (@w_rows,getdate(),	@i_cuenta,		'R',		'Corriente')
					    
			    	INSERT INTO g1_transaccion
					  (tr_id,	tr_fecha,	tr_cuenta,		tr_tipo_tr,	tr_tipo_cuenta)
					VALUES
					    (@w_rows,getdate(),	@i_cuentaD,		'D',		'Ahorro')
				END
			ELSE IF (@w_exist = 1)
				BEGIN
			    	UPDATE g1_cuenta_ahorros
						SET 
							ca_saldo = ca_saldo - @i_valor
						WHERE
							ca_banco= @i_cuenta
							
			    	UPDATE g1_cuenta_ahorros
						SET 
							ca_saldo = ca_saldo + @i_valor
						WHERE
							ca_banco= @i_cuenta		
								
			    	INSERT INTO g1_transaccion
					    (tr_id,	tr_fecha,	tr_cuenta,		tr_tipo_tr,	tr_tipo_cuenta)
					VALUES
					    (@w_rows,getdate(),	@i_cuenta,		'R',		'Ahorro')
					    
			    	INSERT INTO g1_transaccion
					    (tr_id,	tr_fecha,	tr_cuenta,		tr_tipo_tr,	tr_tipo_cuenta)
					VALUES
					    (@w_rows,getdate(),	@i_cuentaD,		'D',		'Ahorro')
				END
		END 
	ELSE IF EXISTS(SELECT 1 from g1_cuenta_corriente WHERE cc_banco = @i_cuentaD)
		BEGIN
		  	IF (@w_exist = 2)
				BEGIN
				
					UPDATE g1_cuenta_corriente
						SET 
							cc_saldo = cc_saldo - @i_valor
						WHERE
							cc_banco= @i_cuenta
							
					UPDATE g1_cuenta_corriente
						SET 
							cc_saldo = cc_saldo + @i_valor
						WHERE
							cc_banco= @i_cuentaD
							
			    	INSERT INTO g1_transaccion
					  (tr_id,	tr_fecha,	tr_cuenta,		tr_tipo_tr,	tr_tipo_cuenta)
					VALUES
					    (@w_rows,getdate(),	@i_cuenta,		'R',		'Corriente')
					    
			    	INSERT INTO g1_transaccion
					  (tr_id,	tr_fecha,	tr_cuenta,		tr_tipo_tr,	tr_tipo_cuenta)
					VALUES
					    (@w_rows,getdate(),	@i_cuentaD,		'D',		'Corriente')
				END
			ELSE IF (@w_exist = 1)
				BEGIN
			    	UPDATE g1_cuenta_ahorros
						SET 
							ca_saldo = ca_saldo - @i_valor
						WHERE
							ca_banco= @i_cuenta
							
			    	UPDATE g1_cuenta_corriente
						SET 
							cc_saldo = cc_saldo + @i_valor
						WHERE
							cc_banco= @i_cuentaD		
								
			    	INSERT INTO g1_transaccion
					    (tr_id,	tr_fecha,	tr_cuenta,		tr_tipo_tr,	tr_tipo_cuenta)
					VALUES
					    (@w_rows,getdate(),	@i_cuenta,		'R',		'Ahorro')
					    
			    	INSERT INTO g1_transaccion
					    (tr_id,	tr_fecha,	tr_cuenta,		tr_tipo_tr,	tr_tipo_cuenta)
					VALUES
					    (@w_rows,getdate(),	@i_cuentaD,		'D',		'Corriente')
				END
		END
	ELSE	
		BEGIN
			SELECT @w_exist = 0
		END
END	
return 0



GO

