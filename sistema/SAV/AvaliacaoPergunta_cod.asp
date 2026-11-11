	<!--
	::	DESENVOLVIDO POR Gemul - Gestor de Município"
	::	Data de Criação...: 23/03/2015
	::	Desenvolvedores...: Asced
	::	Objetivo Pagina...: Cadastro Questão
	-->
	<!--#include file="../../includes/inc_verificaSession.asp"-->
	<!--#include file="../../includes/inc_cnn.asp"-->
	<!--#include file="../../includes/inc_replaceRequest.asp"-->
	<!--#include file="../../includes/inc_log.asp"-->
	<%
	
	paginaRetorno					= "AvaliacaoInstitucional_cad.asp"
	strAcao 						= Request.QueryString("acao")
	
	intCodEmp						= Session("CodEmpresa")
	intCodigo						= Trim(Request.Form("txtCodigo"))
	intCodAvaliacaoInstitucional	= Trim(Request.Form("cmbAvaliacaoInstitucional"))
	strSubtitulo 					= Trim(Request.Form("txtSubtitulo"))
	strDescricao 					= Trim(Request.Form("txtDescricao"))
	strTipoPerguntaAvaliacao		= Trim(Request.Form("cmbTipoPerguntaAvaliacao"))

	'on error resume next
	
	cnn.begintrans

	if strAcao = "I" then  
		
		strMensagem = "Questão Salva com sucesso..."
		
		sql = "SELECT Max(Codigo) as MaiorCodigo" 
		sql = sql & " FROM SAV_AVALIACAO_PERGUNTA"
		sql = sql & " Where Cod_Empresa = " & intCodEmp
		rs.open sql, cnn
		
		if not RS.EOF then
			if rs("MaiorCodigo") <> "" then
				intCodNovo = cstr(rs("MaiorCodigo")) + 1
				intCodigo = intCodNovo
			else
				intCodigo = 1	
			end if
		else
			intCodigo = 1
		end if
		rs.close


		sql = "Insert Into SAV_AVALIACAO_PERGUNTA(Codigo, Cod_Empresa, Cod_Avaliacao_Institucional, Subtitulo, Descricao, Tipo_Pergunta)"
		sql = sql & " Values ("
		sql = sql & "" & intCodigo & ","
		sql = sql & "" & intCodEmp & ","
		sql = sql & "'" & intCodAvaliacaoInstitucional & "',"
		sql = sql & "'" & strSubtitulo & "',"
		sql = sql & "'" & strDescricao & "',"
		sql = sql & "'" & strTipoPerguntaAvaliacao & "')"
		cnn.execute sql
		GravarLog sql
		
		
	elseif strAcao = "A"then
	
		strMensagem = "Questão Alterada com sucesso..."
		
		sql = "Update SAV_AVALIACAO_PERGUNTA Set"
		sql = sql & " Subtitulo = '" & strSubtitulo & "',"
		sql = sql & " Descricao = '" & strDescricao & "',"
		sql = sql & " Tipo_Pergunta = '" & strTipoPerguntaAvaliacao & "'"
		sql = sql & " Where Codigo = " & intCodigo
		sql = sql & " And cod_empresa = " & intCodEmp
		sql = sql & " And Cod_Avaliacao_Institucional = " & intCodAvaliacaoInstitucional
		cnn.execute sql
		GravarLog sql
			
	elseif strAcao = "E"then 
			
		strMensagem = "Questão Excluida com sucesso..."
		
		sql = "Delete from SAV_AVALIACAO_PERGUNTA "
		sql = sql & " Where Codigo = " & intCodigo
		sql = sql & " And cod_empresa = " & intCodEmp
		sql = sql & " And Cod_Avaliacao_Institucional = " & intCodAvaliacaoInstitucional
		cnn.execute sql
		GravarLog sql
	
	end if
	
	if err.number = 0 then
	'----------Finaliza tranzação iniciada--------------
		cnn.commitTrans
		%>
		<script>
			alert("<%=strMensagem%>");
			window.location='AvaliacaoPergunta_cad.asp';
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