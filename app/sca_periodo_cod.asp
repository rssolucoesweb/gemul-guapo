<%@LANGUAGE="VBSCRIPT" CODEPAGE="65001"%> 
<%  
response.Charset = "utf-8" 
response.ContentType = "text/html" 
%>
<!--
	::	DESENVOLVIDO POR "RS SOLUÇÕES WEB - www.rssolucoesweb.com.br"
	::	Data de Criação...: 14/10/2020
	::	Desenvolvedores...: Sergio Borges - sergio@rssolucoesweb.com.br
-->
<!--#include file="includes/inc_verificaSessionApp.asp"-->
<!--#include file="includes/inc_cnn.asp"-->
<!--#include file="includes/inc_log.asp"-->


<%
	on error resume next
	'----------Inicia uma tranzação--------------
	cnn.begintrans
	acao 				= Trim(Request.QueryString("acao"))
	intCodEmp			= Session("CodEmpresa")
	intCodigo			= Trim(Request.Form("txtCodigo"))
	intCodCurso			= Trim(Request.Form("cmbCurso"))
	strDescricao 		= Trim(Request.Form("txtDescricao"))
	strSequencia 		= Trim(Request.Form("txtSequencia"))
	strTipo		 		= Trim(Request.Form("cmbTipo"))
	strMatricula		= Trim(Request.Form("cmbMatricula"))
	strIdadeLimite		= Trim(Request.Form("txtIdadeLimite"))
	
	if acao="I" then
		strTemMesmaSequencia = false
		sql = "SELECT sequencia" 
		sql = sql & " FROM SCA_PERIODO"
		sql = sql & " where cod_curso = " & intCodCurso
		sql = sql & " and sequencia = " & strSequencia
		rs1.open sql, cnn
		if not RS1.EOF then
			strTemMesmaSequencia = true
		end if
		rs1.close

		if strTemMesmaSequencia then
			%>
			<script>
				alert("ATENÇÃO: Já existe essa mesma sequencia para esse mesmo curso, favor verificar as informações cadastradas.\nUm período não pode ter a mesma sequencia em um mesmo curso.");
				window.history.back();
			</script>
			<%
			response.End()
		end if

		strMensagem = "Registro Salvo com sucesso..."
	
		sql = "Insert Into SCA_PERIODO(Cod_Curso, Descricao, Sequencia, tipo, Matricula, idade_limite)"
		sql = sql & " Values ("
		sql = sql & "" & intCodCurso & ","
		sql = sql & "'" & strDescricao & "',"
		sql = sql & "" & strSequencia & ","
		sql = sql & "'" & strTipo & "',"
		sql = sql & "'" & strMatricula & "',"
		sql = sql & "'" & strIdadeLimite & "')"
		cnn.execute sql

	elseif acao="A" then
		
		strMensagem = "Registro Alterado com sucesso..."
		sql = "Update SCA_PERIODO Set"
		sql = sql & " Sequencia = " & strSequencia & ","
		sql = sql & " Tipo = '" & strTipo & "',"
		sql = sql & " Idade_limite = '" & strIdadeLimite & "',"
		sql = sql & " Matricula = '" & strMatricula & "',"
		sql = sql & " Descricao = '" & strDescricao & "'"
		sql = sql & " Where Cod_Periodo = " & intCodigo
		cnn.execute sql
		
	else
	
		strMensagem = "Registro Excluido com sucesso..."
		sql = "Delete from SCA_PERIODO "
		sql = sql & " where Cod_Periodo = " & intCodigo
		cnn.execute sql
		if trim(err.number)="-2147217873" then
			cnn.rollbackTrans
			%>
			<script>
				alert("ATENÇÃO: Registro não pode ser excluido, exite outros registro vinculado a ele.");
				window.history.back();
			</script>
			<%
			response.End()
		end if		
	end if
	
	
	GravarLog sql
	if err.number = 0 then
		'----------Finaliza tranzação iniciada--------------
		cnn.commitTrans
		%>
		<script>
			alert("<%=strMensagem%>");
			window.location='sca_periodo.asp?cmbCurso=<%=intCodCurso%>';
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