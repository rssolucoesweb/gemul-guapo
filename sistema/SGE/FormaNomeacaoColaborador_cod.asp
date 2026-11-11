	<!--
	::	DESENVOLVIDO POR Gemul - Gestor de Município"
	::	Data de Criação...: 23/03/2015
	::	Desenvolvedores...: Asced
	::	Objetivo Pagina...: Cadastro de Forma de Nomeação
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

	'on error resume next
	
	cnn.begintrans

	if strAcao = "I" then  
		
		strMensagem = "Registro Salvo com sucesso..."

		'*****************************************************************
		'todas unidades
		vetCodTodasEmpresa	= split(Session("CodTodasEmpresaGrupo"),",")
		
		'percorre todas unidades
		for i=0 to ubound(vetCodTodasEmpresa)
		
			intCodEmp = vetCodTodasEmpresa(i)
			bolExiste = false

			sql = "SELECT COD_FORMANOMEACAO" 
			sql = sql & " FROM SRH_FORMANOMEACAOCOLABORADOR"
			sql = sql & " WHERE COD_EMPRESA = " & intCodEmp
			sql = sql & " AND 	DESC_FORMANOMEACAO = '" & strDescricao & "'"
			rs.open sql, cnn
			if not RS.EOF then
				bolExiste = true
			end if
			rs.close

			if bolExiste=false then
				sql = "Insert Into SRH_FORMANOMEACAOCOLABORADOR(COD_EMPRESA, DESC_FORMANOMEACAO)"
				sql = sql & " Values ("
				sql = sql & "" & intCodEmp & ","
				sql = sql & "'" & strDescricao & "')"
				cnn.execute sql
				GravarLog sql
			end if
		next
	
	end if

	if err.number = 0 then
	'----------Finaliza tranzação iniciada--------------
		cnn.commitTrans
		%>
		<script>
			alert("<%=strMensagem%>");
			window.location='FormaNomeacaoColaborador_cad.asp';
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