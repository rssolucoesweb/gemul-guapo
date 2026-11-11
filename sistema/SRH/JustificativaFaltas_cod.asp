<!--
    ::	DESENVOLVIDO POR Asced"
    ::	Data de Criação...: 25/05/2015
    ::	Desenvolvedores...: Roberto Barbosa Silva - roberto@superawebx.com.br
    ::	Objetivo Pagina...: Cadastro Justificativa de Faltas
-->
<!--#include file="../../includes/inc_verificaSession.asp"-->
<!--#include file="../../includes/inc_cnn.asp"-->
<!--#include file="../../includes/inc_log.asp"-->
<%
	'on error resume next
	'----------Inicia uma tranzação--------------
	cnn.begintrans
	acao 				= Trim(Request.QueryString("acao"))
	intCodEmp			= Session("CodEmpresa")
	intCodGrupo			= Session("CodGrupo")
	intCodJustificativa	= Trim(Request.Form("txtCodigo"))
	strDescricao 		= Trim(Request.Form("txtDescricao"))
	strLegenda 			= Trim(Request.Form("txtLegenda"))
	strTotalDias 		= Trim(Request.Form("txtTotalDias"))
    strExigeDocumentacao= Trim(Request.Form("cmbExigeDocumentacao"))
	strSituacao 		= Trim(Request.Form("cmbSituacao"))
			
	if acao="I" then
		
		strMensagem = "Registro Salvo com sucesso..."
		
		sql = "SELECT CODIGO" 
		sql = sql & " FROM SRH_JUSTIFICATIVAFALTAS"
		sql = sql & " WHERE Cod_grupo = " & Session("CodGrupo")	
		sql = sql & " AND 	DESCRICAO = '" & strDescricao & "'"
		rs.open sql, cnn
		if RS.EOF then

			sql = "Insert Into SRH_JUSTIFICATIVAFALTAS(COD_GRUPO, DESCRICAO, LEGENDA, EXIGE_COMPROVACAO, SITUACAO, TOTALDIAS)"
			sql = sql & " Values ("
			sql = sql & "" & intCodGrupo & "," 
			sql = sql & "'" & strDescricao & "',"
			sql = sql & "'" & strLegenda & "',"
			sql = sql & "'" & strExigeDocumentacao & "',"
			sql = sql & "'" & strSituacao & "',"
			sql = sql & "" & strTotalDias & ")"
			
			cnn.execute sql
			GravarLog sql
			
        else
			rs.close
			cnn.rollbackTrans
			%>
			<script>
				alert("ATENÇÃO: Essa Justificativa já está cadastrada.");
				window.location='JustificativaFaltas_cad.asp';
			</script>
			<%
			response.End()
		end if
		rs.close

	elseif acao="A" then

		strMensagem = "Registro Alterado com sucesso..."

		sql = "Update SRH_JUSTIFICATIVAFALTAS Set"
		sql = sql & " DESCRICAO = '" & strDescricao & "',"
		sql = sql & " LEGENDA = '" & strLegenda & "',"
		sql = sql & " EXIGE_COMPROVACAO = '" & strExigeDocumentacao & "',"
		sql = sql & " SITUACAO = '" & strSituacao & "',"
		sql = sql & " TOTALDIAS = " & strTotalDias & ""
		sql = sql & " where CODIGO = " & intCodJustificativa

		cnn.execute sql
		GravarLog sql
		
	else
	
		excluir = "S"
		sql = "SELECT CODIGO" 
		sql = sql & " FROM SRH_COLABORADOR_JUSTIFICATIVA"
		sql = sql & " WHERE Cod_JustificativaFaltas = " & intCodJustificativa
		rs.open sql, cnn
		if not RS.EOF then
			excluir = "N"
		end if
		rs.close
		
		sql = "SELECT CODIGO" 
		sql = sql & " FROM SRH_COLABORADOR_FREQUENCIA"
		sql = sql & " WHERE Cod_JustificativaFaltas = " & intCodJustificativa
		rs.open sql, cnn
		if not RS.EOF then
			excluir = "N"
		end if
		rs.close
		
		if excluir = "S" then
			strMensagem = "Registro Excluido com sucesso..."
			sql = "Delete from SRH_JUSTIFICATIVAFALTAS "
			sql = sql & " where CODIGO = " & intCodJustificativa
			cnn.execute sql
			GravarLog sql
		
		else
			%>
			<script>
				alert("Justificativa não pode ser excluida, tem lançamentos utilizando essa justificativa!");
				window.location='JustificativaFaltas_cad.asp';
			</script>
			<%
			response.end
		end if
		
	end if
	
	if err.number = 0 then
		cnn.commitTrans
		%>
		<script>
			alert("<%=strMensagem%>");
			window.location='JustificativaFaltas_cad.asp';
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