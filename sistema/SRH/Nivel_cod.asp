<!--
    ::	DESENVOLVIDO POR Asced"
    ::	Data de Criação...: 28/05/2015
    ::	Desenvolvedores...: Roberto Barbosa Silva - roberto@superawebx.com.br
    ::	Objetivo Pagina...: Cadastro Nivel
-->
<!--#include file="../../includes/inc_verificaSession.asp"-->
<!--#include file="../../includes/inc_cnn.asp"-->
<!--#include file="../../includes/inc_log.asp"-->
<%
	'on error resume next
	'----------Inicia uma tranzação--------------
	cnn.begintrans
	acao 						= Trim(Request.QueryString("acao"))
	intCodGrupo					= Session("CodGrupo")
	intCodigo	 				= Trim(Request.Form("txtCodigo"))
	strDescricao 				= Trim(Request.Form("txtDescricao"))
	strValorHora 				= replace(replace(trim(request.form("txtValorHora")),".",""),",",".")  
	strSituacao 				= Trim(Request.Form("cmbSituacao"))
	strTipoVinculo 				= Trim(Request.Form("cmbTipoVinculo"))
	strTipoModulacao			= Trim(Request.Form("cmbTipoModulacao"))
	strSalarioBase 				= replace(replace(trim(request.form("txtSalarioBase")),".",""),",",".") 
	strCarga_Horario_Contratada = Trim(Request.Form("txtCargaHorariaTotal"))
	strTotalAulas		 		= Trim(Request.Form("txtTotalAulas"))
	strMaximoModulado			= Trim(Request.Form("txtMaximoModulado"))
	strPercentualRepousoSemanal	= replace(replace(trim(request.form("txtPercentualRepousoSemanal")),".",""),",",".")
	strFatorExtraClasse			= replace(replace(trim(request.form("txtFatorExtraClasse")),".",""),",",".")
	strPermiteSubstituicao      = Trim(Request("cmbPermiteSubstituicao"))
	strPermiteDobras            = Trim(Request("cmbPermiteDobras"))

    if strSalarioBase = "" then strSalarioBase = "0"
    if strCarga_Horario_Contratada = "" then strCarga_Horario_Contratada = "0"
    if strTotalAulas = "" then strTotalAulas = "0"
    if strMaximoModulado = "" then strMaximoModulado = "0"
			
	if acao="I" then
		
		strMensagem = "Registro Salvo com sucesso..."
		
		sql = "SELECT Max(Codigo) as MaiorCodigo" 
		sql = sql & " FROM SRH_NIVEL"
		rs.open sql, cnn
		
		if not RS.EOF then
		
			if rs("MaiorCodigo") <> "" then
				intCodNovo = cstr(rs("MaiorCodigo")) + 1
				intCodigo = intCodNovo
			else
				intCodigo = 1	
			end if
		
		end if
		rs.close
		
		sql = "Insert Into SRH_NIVEL(Cod_grupo, Descricao, Valor_hora, Situacao, Tipo_Vinculo, tipo_modulacao,"
		sql = sql & " Salario_Base, carga_horario_contratada, total_aulas, MaximoModulado, PercentualRepousoSemanal, FatorExtraClasse, "
		sql = sql & " PermiteSubstituicao, Permitedobras)"
		sql = sql & " Values ("
		sql = sql & "" & intCodGrupo & ","
		sql = sql & "'" & strDescricao & "',"
		sql = sql & "" & strValorHora & ","
		sql = sql & "'" & strSituacao & "',"
		sql = sql & "'" & strTipoVinculo & "',"
		sql = sql & "'" & strTipoModulacao & "',"
		sql = sql & "" & strSalarioBase & ","
		sql = sql & "" & strCarga_Horario_Contratada & ","
		sql = sql & "" & strTotalAulas & ","
		sql = sql & "" & strMaximoModulado & ","
		sql = sql & "" & strPercentualRepousoSemanal & ","
		sql = sql & "" & strFatorExtraClasse & ","
		sql = sql & "'" & strPermiteSubstituicao & "',"
		sql = sql & "'" & strPermiteDobras & "')"
		cnn.execute sql
		GravarLog sql

		
	elseif acao="A" then
		
		strMensagem = "Registro Alterado com sucesso..."  
		
		sql = "Update SRH_NIVEL Set"
		sql = sql & " Descricao = '" & strDescricao & "',"
		sql = sql & " Valor_hora = " & strValorHora & ","
		sql = sql & " Situacao = '" & strSituacao & "',"
		sql = sql & " Tipo_Vinculo = '" & strTipoVinculo & "',"
		sql = sql & " Tipo_modulacao = '" & strTipoModulacao & "',"
		sql = sql & " Salario_Base = " & strSalarioBase & ","
		sql = sql & " carga_horario_contratada = " & strCarga_Horario_Contratada & ","
		sql = sql & " total_aulas = " & strTotalAulas & ","
		sql = sql & " MaximoModulado = " & strMaximoModulado & ","
		sql = sql & " PercentualRepousoSemanal = " & strPercentualRepousoSemanal & ","
		sql = sql & " FatorExtraClasse = " & strFatorExtraClasse & ","
		sql = sql & " PermiteSubstituicao = '" & strPermiteSubstituicao & "',"
		sql = sql & " Permitedobras = '" & strPermiteDobras & "'"
		sql = sql & " Where Codigo = " & intCodigo
		sql = sql & " And Cod_grupo = " & intCodGrupo
		cnn.execute sql
		GravarLog sql

		sql = "Update SRH_colaborador Set"
		sql = sql & " salario_base = " & strSalarioBase & ","
		sql = sql & " carga_horario_contratada = " & strCarga_Horario_Contratada & ","
		sql = sql & " total_aulas = " & strTotalAulas & ","
		sql = sql & " Fator_Extra_Classe = " & strFatorExtraClasse & ","
		sql = sql & " percentual_repouso_Semanal = " & strPercentualRepousoSemanal
		sql = sql & " Where cod_nivel = " & intCodigo
		sql = sql & " And cod_empresa in (select codigo from seg_empresa where cod_grupo = "& intCodGrupo &")"
		cnn.execute sql
		GravarLog sql

	else
	
		strMensagem = "Registro Excluido com sucesso..."
		sql = "Delete from SRH_NIVEL "
		sql = sql & " Where Codigo = " & intCodigo
		sql = sql & " And Cod_grupo = " & intCodGrupo
		cnn.execute sql
		GravarLog sql


	end if
	
	
	if err.number = 0 then
	'----------Finaliza tranzação iniciada--------------
		cnn.commitTrans
		%>
		<script>
			alert("<%=strMensagem%>");
			window.location='Nivel_cad.asp';
		</script>
		<%
		response.end
	else
		cnn.rollbackTrans
		%>
		<script>
			alert("ATENÇÃO: \n\nNão foi possível executar esse procedimento, tente novamente.\nCaso persistir entre em contato com o administrador do sistema.");
			window.history.back();
		</script>
		<%
	end if
%>