CREATE OR REPLACE FUNCTION asis.ft_vacacion_det_ime (
  p_administrador integer,
  p_id_usuario integer,
  p_tabla varchar,
  p_transaccion varchar
)
RETURNS varchar AS
$body$
/**************************************************************************
 SISTEMA:		Sistema de Asistencia
 FUNCION: 		asis.ft_vacacion_det_ime
 DESCRIPCION:   Funcion que gestiona las operaciones basicas (inserciones, modificaciones, eliminaciones de la tabla 'asis.tvacacion_det'
 AUTOR: 		 (admin.miguel)
 FECHA:	        30-12-2019 13:41:59
 COMENTARIOS:
***************************************************************************
 HISTORIAL DE MODIFICACIONES:
#ISSUE				FECHA				AUTOR				DESCRIPCION
 #0				30-12-2019 13:41:59								Funcion que gestiona las operaciones basicas (inserciones, modificaciones, eliminaciones de la tabla 'asis.tvacacion_det'
 #25			14-08-2020 15:28:39		MMV						Refactorizacion vacaciones

 ***************************************************************************/

DECLARE

	v_nro_requerimiento    	integer;
	v_parametros           	record;
	v_id_requerimiento     	integer;
	v_resp		            varchar;
	v_nombre_funcion        text;
	v_mensaje_error         text;
	v_id_vacacion_det	integer;
    v_tiempo            integer;

BEGIN

    v_nombre_funcion = 'asis.ft_vacacion_det_ime';
    v_parametros = pxp.f_get_record(p_tabla);

	/*********************************
 	#TRANSACCION:  'ASIS_VDE_INS'
 	#DESCRIPCION:	Insercion de registros
 	#AUTOR:		admin.miguel
 	#FECHA:		30-12-2019 13:41:59
	***********************************/

	if(p_transaccion='ASIS_VDE_INS')then

        begin
        	--Sentencia de la insercion
        	select va.tiempo into v_tiempo
        	from asis.tvacacion_det va
        	where va.id_vacacion_det = v_parametros.id_vacacion_det;

            if v_tiempo = 8 then
                update asis.tvacacion_det set
                                            tiempo = 4
                where id_vacacion_det = v_parametros.id_vacacion_det;
            end if;
        	if v_tiempo = 4 then
                update asis.tvacacion_det set
                                              tiempo = 8
        	    where id_vacacion_det = v_parametros.id_vacacion_det;
            end if;
			--Definicion de la respuesta
			v_resp = pxp.f_agrega_clave(v_resp,'mensaje','Vacación detalle almacenado(a) con exito (id_vacacion_det'||v_id_vacacion_det||')');
            v_resp = pxp.f_agrega_clave(v_resp,'id_vacacion_det',v_id_vacacion_det::varchar);

            --Devuelve la respuesta
            return v_resp;

		end;


	else

    	raise exception 'Transaccion inexistente: %',p_transaccion;

	end if;

EXCEPTION

	WHEN OTHERS THEN
		v_resp='';
		v_resp = pxp.f_agrega_clave(v_resp,'mensaje',SQLERRM);
		v_resp = pxp.f_agrega_clave(v_resp,'codigo_error',SQLSTATE);
		v_resp = pxp.f_agrega_clave(v_resp,'procedimientos',v_nombre_funcion);
		raise exception '%',v_resp;

END;
$body$
LANGUAGE 'plpgsql'
VOLATILE
CALLED ON NULL INPUT
SECURITY INVOKER
COST 100;

ALTER FUNCTION asis.ft_vacacion_det_ime (p_administrador integer, p_id_usuario integer, p_tabla varchar, p_transaccion varchar)
  OWNER TO postgres;