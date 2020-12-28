USE Cobis
go

if OBJECT_ID('g1_sp_operaciones') is not null
begin
	drop proc g1_sp_operaciones
end

go

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
@i_banco		int				= null,
@i_operacion	char(1),
@t_trn			INT =99 ---25190
)
as 

declare @w_error int
select @w_error = 0


if @i_operacion = 'C' 
begin

	select ca_banco,ca_saldo from g1_cuenta_ahorros WHERE ca_banco = @i_banco
	
	IF @@ROWCOUNT > 0
		BEGIN
			select cc_banco,cc_saldo from g1_cuenta_corriente WHERE cc_banco = @i_banco
		END 

end


return select @w_error