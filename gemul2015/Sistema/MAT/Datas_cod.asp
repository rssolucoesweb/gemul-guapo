<!--
	::	DESENVOLVIDO POR "RS SOLUÇÕES WEB - www.rssolucoesweb.com.br"
	::	Data de Criação...: 09/12/2008
	::	Desenvolvedores...: Roberto Barbosa Silva - robertobs7@gmail.com
	::	Objetivo Pagina...: Cadastro de Configurações gerais
-->
<!--#include file="../../includes/inc_verificaSession.asp"-->
<!--#include file="../../includes/inc_cnn.asp"-->
<!--#include file="../../includes/inc_log.asp"-->
<!--#include file="../../includes/inc_formataData.asp"-->
<%
	'on error resume next
	'----------Inicia uma tranzação--------------
	dt_inicial_I = formataDataBD(request.form("dt_inicial_I"))
	dt_inicial_II = formataDataBD(request.form("dt_inicial_II"))
	dt_inicial_III = formataDataBD(request.form("dt_inicial_III"))
	dt_inicial_IV = formataDataBD(request.form("dt_inicial_IV"))
	dt_inicial_V = formataDataBD(request.form("dt_inicial_V"))
	dt_inicial_ef = formataDataBD(request.form("dt_inicial_ef"))
	dt_inicial_regra_especial = formataDataBD(request.form("dt_inicial_regra_especial"))
	
	dt_final_I = formataDataBD(request.form("dt_final_I"))
	dt_final_II = formataDataBD(request.form("dt_final_II"))
	dt_final_III = formataDataBD(request.form("dt_final_III"))
	dt_final_IV = formataDataBD(request.form("dt_final_IV"))
	dt_final_V = formataDataBD(request.form("dt_final_V"))
	dt_final_ef = formataDataBD(request.form("dt_final_ef"))
	dt_final_regra_especial = formataDataBD(request.form("dt_final_regra_especial"))
	
	dt_inicial_ei_V = formataDataBD(request.form("dt_inicial_ei_V"))
	dt_inicial_ef_V = formataDataBD(request.form("dt_inicial_ef_V"))
	dt_inicial_minima_ei = formataDataBD(request.form("dt_inicial_minima_ei"))
	
	dt_final_ei_V = formataDataBD(request.form("dt_final_ei_V"))
	dt_final_ef_V = formataDataBD(request.form("dt_final_ef_V"))
	dt_final_minima_ef = formataDataBD(request.form("dt_final_minima_ef"))

	periodo_dinamico = request.Form("periodo_dinamico")
	
	strMensagem = "Registro Alterado com sucesso..."

	
	sql = "Update MAT_periodo_curso Set dt_inicial = '" & dt_inicial_I & "', dt_final = '" & dt_final_I & "' where codigo = 1"
	cnn.execute sql
	GravarLog sql

	sql = "Update MAT_periodo_curso Set dt_inicial = '" & dt_inicial_II & "', dt_final = '" & dt_final_II & "' where codigo = 2"
	cnn.execute sql
	GravarLog sql

	sql = "Update MAT_periodo_curso Set dt_inicial = '" & dt_inicial_III & "', dt_final = '" & dt_final_III & "' where codigo = 3"
	cnn.execute sql
	GravarLog sql

	sql = "Update MAT_periodo_curso Set dt_inicial = '" & dt_inicial_IV & "', dt_final = '" & dt_final_IV & "' where codigo = 9"
	cnn.execute sql
	GravarLog sql

	sql = "Update MAT_periodo_curso Set dt_inicial = '" & dt_inicial_V & "', dt_final = '" & dt_final_V & "' where codigo = 10"
	cnn.execute sql
	GravarLog sql

	sql = "Update MAT_periodo_curso Set dt_inicial = '" & dt_inicial_ef & "', dt_final = '" & dt_final_ef & "' where codigo = 12"
	cnn.execute sql
	GravarLog sql
	
	sql = "Update MAT_periodo_curso Set dt_inicial = '" & dt_inicial_regra_especial & "', dt_final = '" & dt_final_regra_especial & "' where codigo = 13"
	cnn.execute sql
	GravarLog sql

	sql = "Update MAT_periodo_valido_matricula Set dt_inicial = '" & dt_inicial_ei_V & "', dt_final = '" & dt_final_ei_V & "' where codigo = 5"
	cnn.execute sql
	GravarLog sql

	sql = "Update MAT_periodo_valido_matricula Set dt_inicial = '" & dt_inicial_ef_V & "', dt_final = '" & dt_final_ef_V & "' where codigo = 6"
	cnn.execute sql
	GravarLog sql

	sql = "Update MAT_periodo_valido_matricula Set dt_inicial = '" & dt_inicial_minima_ei & "' where codigo = 8"
	cnn.execute sql
	GravarLog sql

	sql = "Update MAT_periodo_valido_matricula Set dt_final = '" & dt_final_minima_ef & "' where codigo = 12"
	cnn.execute sql
	GravarLog sql

	sql = "Update MAT_configuracoes Set periodo_dinamico = '" & periodo_dinamico & "', usuario_incl='"&session("usuarioWeb")&"', data_hora_incl = getdate() where cod_grupo = " & session("CodGrupo")
	cnn.execute sql
	GravarLog sql

	'Log
	sql = "insert MAT_periodo_curso_log"
	sql = sql & " select *, case when (select top 1 isnull(codigo_log,0)+1 from MAT_periodo_curso_log order by codigo_log desc) is null then 1 else	(select  top 1 isnull(codigo_log,0)+1 from MAT_periodo_curso_log order by codigo_log desc) end , '"&session("usuarioWeb")&"', getdate() "
	sql = sql & " from MAT_periodo_curso	"
	cnn.execute sql
	'Log
	sql = "insert MAT_periodo_valido_matricula_log"
	sql = sql & " select *, case when (select top 1 isnull(codigo_log,0)+1 from MAT_periodo_valido_matricula_log order by codigo_log desc) is null then 1 else	(select  top 1 isnull(codigo_log,0)+1 from MAT_periodo_valido_matricula_log order by codigo_log desc) end , '"&session("usuarioWeb")&"', getdate() "
	sql = sql & " from MAT_periodo_valido_matricula	"
	cnn.execute sql	
	'Log
	sql = "insert MAT_configuracoes_log"
	sql = sql & " select *, case when (select top 1 isnull(codigo_log,0)+1 from MAT_configuracoes_log order by codigo_log desc) is null then 1 else	(select  top 1 isnull(codigo_log,0)+1 from MAT_configuracoes_log order by codigo_log desc) end , '"&session("usuarioWeb")&"', getdate() "
	sql = sql & " from MAT_configuracoes	"
	'response.write sql
	cnn.execute sql


	if err.number = 0 then
	'----------Finaliza tranzação iniciada--------------
		%>
		<script>
			alert("<%=strMensagem%>");
			window.location='datas_cad.asp';
		</script>
		<%
		response.end
	else
		%>
		<script>
			alert("ATENÇÃO: \n\nNão foi possível executar esse procedimento, tente novamente.\nCaso persistir entre em contato com o administrador do sistema.");
			window.location='datas_cad.asp';
		</script>
		<%
	end if
%>