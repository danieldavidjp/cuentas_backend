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
/****************************************************************************/

(
@i_cuenta		int,
@i_cuentaD		int,
@i_valor		FLOAT,
@i_operacion	char(1),
@t_trn			INT =99 ---25190
)
as 


DECLARE 
	@w_sp_name  varchar(32),
    @t_file     varchar(10) = null,
    @t_debug 	CHAR(1)


select @t_debug = 'N'
select @w_sp_name = 'sp_direccion_cons'

if @i_operacion = 'C' 
begin
	
	IF EXISTS ( SELECT 
					cc_saldo 
   				FROM 
					g1_cuenta_corriente
				WHERE 
					cc_banco = @i_cuenta)
		BEGIN
		
			UPDATE g1_cuenta_corriente
				SET 
					cc_saldo = cc_saldo + @i_valor
				WHERE 
					cc_banco = @i_cuenta
		END
	ELSE IF EXISTS( SELECT 
					ca_saldo 
   				FROM 
					g1_cuenta_ahorros
				WHERE 
					ca_banco = @i_cuenta)
		BEGIN
	    	UPDATE g1_cuenta_ahorros
				SET 
					ca_saldo = ca_saldo + @i_valor
				WHERE
					ca_banco = @i_cuenta
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

  	IF EXISTS ( SELECT 
					cc_saldo 
   				FROM 
					g1_cuenta_corriente
				WHERE 
					cc_banco = @i_cuenta)
		BEGIN
		
			UPDATE g1_cuenta_corriente
				SET 
					cc_saldo = cc_saldo - @i_valor
				WHERE
					cc_banco= @i_cuenta
		END
	ELSE IF EXISTS( SELECT 
					ca_saldo 
   				FROM 
					g1_cuenta_ahorros
				WHERE 
					ca_banco = @i_cuenta)
		BEGIN
	    	UPDATE g1_cuenta_ahorros
				SET 
					ca_saldo = ca_saldo - @i_valor
				WHERE
					ca_banco= @i_cuenta
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

return 0

GO

