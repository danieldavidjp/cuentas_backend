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
@i_banco		int,
@i_valor		FLOAT,
@i_operacion	char(1),
@t_trn			INT =99 ---25190
)
as 

declare @w_error int
select @w_error = 0

DECLARE @w_tipo_cuenta varchar 


if @i_operacion = 'C' 
begin

	SELECT 
		cl_cedula, 
		cl_nombre, 
		cl_apellido,
		cc_banco,cc_saldo
	FROM 
		cliente_taller C, 
		g1_cuenta_corriente O
	WHERE 
	C.cl_id = O.cc_cliente 
	AND 
	O.cc_banco = @i_banco
	
	SELECT @w_tipo_cuenta = 'Corriente'
	
	IF @@ROWCOUNT < 1
		BEGIN
		   SELECT 
				cl_cedula, 
				cl_nombre, 
				cl_apellido,
				ca_banco,ca_saldo
			FROM 
				cliente_taller C, 
				g1_cuenta_ahorros O
			WHERE 
			C.cl_id = O.ca_cliente 
			AND 
			O.ca_banco = @i_banco
			
			SELECT @w_tipo_cuenta = 'Ahorro'
		END 
end

if @i_operacion = 'R' 
begin

	SELECT 
		cl_cedula, 
		cl_nombre, 
		cl_apellido,
		cc_banco,cc_saldo
	FROM 
		cliente_taller C, 
		g1_cuenta_corriente O
	WHERE 
	C.cl_id = O.cc_cliente 
	AND 
	O.cc_banco = @i_banco
	
	SELECT @w_tipo_cuenta = 'Corriente'
	
	IF @@ROWCOUNT < 1
		BEGIN
		   SELECT 
				cl_cedula, 
				cl_nombre, 
				cl_apellido,
				ca_banco,ca_saldo
			FROM 
				cliente_taller C, 
				g1_cuenta_ahorros O
			WHERE 
			C.cl_id = O.ca_cliente 
			AND 
			O.ca_banco = @i_banco
			
			SELECT @w_tipo_cuenta = 'Ahorro'
		END 
END

return select @w_error
GO
