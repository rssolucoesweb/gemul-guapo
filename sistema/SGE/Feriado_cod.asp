	<!--
	::	DESENVOLVIDO POR Gemul - Gestor de Município"
	::	Data de Criação...: 23/03/2015
	::	Desenvolvedores...: Asced
	::	Objetivo Pagina...: Cadastro de Situação
	-->
	<!--#include file="../../includes/inc_verificaSession.asp"-->
	<!--#include file="../../includes/inc_cnn.asp"-->
	<!--#include file="../../includes/inc_replaceRequest.asp"-->
    <!--#include file="../../includes/inc_formatadata.asp"-->
	<!--#include file="../../includes/inc_log.asp"-->
	<%
	
	paginaRetorno		= "Situacao_cad.asp"
	strAcao 			= Request.QueryString("acao")
	
	intCodEmp			= Session("CodEmpresa")
	intCodigo	 		= Trim(Request.Form("txtCodigo"))
	strDescricao 		= Trim(Request.Form("txtDescricao"))
	strDescricaoAntiga	= Trim(Request.Form("txtDescricaoAntiga"))
	strData				= formatadataBD(Trim(Request.Form("txtData")))

	strAnoLetivo 			= Trim(Request.Form("txtAnoLetivo"))
	if strAnoLetivo = "" then 	strAnoLetivo = session("strAnoLetivo")
	intSemestre 			= Trim(Request.Form("cmbSemestre"))
	if intSemestre = "" then 	intSemestre  = session("strSemestre")

	'on error resume next
	
	cnn.begintrans

	if strAcao = "I" then  
		
		'*****************************************************************
		'todas unidades
		vetCodTodasEmpresa	= split(Session("CodTodasEmpresaGrupo"),",")
		
		'percorre todas unidades
		for i=0 to ubound(vetCodTodasEmpresa)
		
			intCodEmp = vetCodTodasEmpresa(i)
			bolExiste = false
		
			sql = "SELECT codigo, data, descricao"
			sql = sql & " FROM SCA_Feriado"
			sql = sql & " where cod_empresa = " & intCodEmp			
			sql = sql & " and ano_letivo = " & strAnoLetivo
			sql = sql & " and semestre = " & intSemestre
			sql = sql & " and descricao = '" & strDescricaoAntiga & "'"
			rs.open sql, cnn
			if not RS.EOF then
				bolExiste = true
			end if
			rs.close
			
			if bolExiste=false then
			
				strMensagem = "Registro Salvo com sucesso..."
		
				sql = "Insert Into SCA_FERIADO(COD_EMPRESA, ANO_LETIVO, SEMESTRE, DESCRICAO, DATA)"
				sql = sql & " Values ("
				sql = sql & "" & intCodEmp & ","
				sql = sql & "" & strAnoLetivo & ","
				sql = sql & "" & intSemestre & ","
				sql = sql & "'" & strDescricao & "',"
				sql = sql & "'" & strData & "')"
				cnn.execute sql
			else
			
				strMensagem = "Registro Alterado com sucesso..."
				sql = "Update SCA_FERIADO Set"
				sql = sql & " DESCRICAO = '" & strDescricao & "',"
				sql = sql & " DATA = '" & strData & "'"
				sql = sql & " where cod_empresa = " & intCodEmp			
				sql = sql & " and ano_letivo = " & strAnoLetivo
				sql = sql & " and semestre = " & intSemestre
				sql = sql & " and descricao = '" & strDescricaoAntiga & "'"
				cnn.execute sql
		
			end if
			
		next
	
	end if

	if err.number = 0 then
	'----------Finaliza tranzação iniciada--------------
		cnn.commitTrans
		%>
		<script>
			alert("<%=strMensagem%>");
			window.location='Feriado_cad.asp';
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