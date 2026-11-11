	<!--
	::	DESENVOLVIDO POR Gemul - Gestor de Município"
	::	Data de Criação...: 23/03/2015
	::	Desenvolvedores...: Asced
	::	Objetivo Pagina...: Cadastro de Situação
	-->
	<!--#include file="../../includes/inc_verificaSession.asp"-->
	<!--#include file="../../includes/inc_cnn.asp"-->
	<!--#include file="../../includes/inc_replaceRequest.asp"-->
	<!--#include file="../../includes/inc_log.asp"-->
	<%
	
	paginaRetorno		= "Situacao_cad.asp"
	strAcao 			= Request.QueryString("acao")
	
	intCodEmp			= Session("CodEmpresa")
	intCodigo	 		= Trim(Request.Form("txtCodigo"))
	strDescricao 		= Trim(Request.Form("txtDescricao"))
	strDescricaoAntiga	= Trim(Request.Form("txtDescricaoAntiga"))
	strPeriodo	 		= Trim(Request.Form("txtPeriodo"))

	strAnoLetivo 			= Trim(Request.Form("txtAnoLetivo"))
	if strAnoLetivo = "" then 	strAnoLetivo = session("strAnoLetivo")
	intSemestre 			= Trim(Request.Form("cmbSemestre"))
	if intSemestre = "" then 	intSemestre  = session("strSemestre")



	'on error resume next
	
	cnn.begintrans

	if strAcao = "I" then  
		
		'*****************************************************************
		'Todas Unidades
		vetCodTodasEmpresa	= split(Session("CodTodasEmpresaGrupo"),", ")

		'percorre todas unidades
		for i=0 to ubound(vetCodTodasEmpresa)
		
			intCodEmp = vetCodTodasEmpresa(i)
			bolExiste = false
	
			sql = "SELECT DESCRICAO " 
			sql = sql & " FROM SCA_BIMESTRE"
			sql = sql & " where ano_letivo = " & strAnoLetivo
			sql = sql & " and DESCRICAO = '" & strDescricaoAntiga & "'"
			rs.open sql, cnn
			if not RS.EOF then
				bolExiste = true
			end if
			rs.close
			
			if bolExiste=false then
			
				strMensagem = "Registro Salvo com sucesso..."
				
				bolExisteNoAnoUnidade = false
				sql = "SELECT DESCRICAO " 
				sql = sql & " FROM SCA_BIMESTRE"
				sql = sql & " where ano_letivo = " & strAnoLetivo
				sql = sql & " and DESCRICAO = '" & strDescricao & "'"
				rs.open sql, cnn
				if not RS.EOF then
					bolExisteNoAnoUnidade = true
				end if
				rs.close
				
				if bolExiste=false then
					sql = "Insert Into SCA_BIMESTRE(ANO_LETIVO, SEMESTRE, DESCRICAO, PERIODO)"
					sql = sql & " Values ("
					sql = sql & "" & strAnoLetivo & ","
					sql = sql & "" & intSemestre & ","
					sql = sql & "'" & strDescricao & "',"
					sql = sql & "'" & strPeriodo & "')"
					cnn.execute sql
				end if
			else
				
				strMensagem = "Registro Alterado com sucesso..."
				
				sql = "Update SCA_BIMESTRE Set"
				sql = sql & " DESCRICAO = '" & strDescricao & "',"
				sql = sql & " PERIODO = '" & strPeriodo & "'"
				sql = sql & " where DESCRICAO = '" & strDescricaoAntiga & "'"
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
			window.location='Bimestre_cad.asp';
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