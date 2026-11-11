<%@LANGUAGE="VBSCRIPT" CODEPAGE="65001"%> 
<%  
response.Charset = "utf-8" 
response.ContentType = "text/html" 
%>
<!--
	::	DESENVOLVIDO POR "RS SOLUÇÕES WEB - www.rssolucoesweb.com.br"
	::	Data de Criação...: 14/08/2021
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
	intCodigo	 		= Trim(Request.Form("txtCodigo"))
	strDescricao 		= Trim(Request.Form("txtDescricao"))
			
	if acao="I" then
		
		strMensagem = "Registro Salvo com sucesso..."
		existeoTurno = ""
		sql = "SELECT cod_turno " 
		sql = sql & " FROM SCA_TURNO where desc_turno = '" & strDescricao & "'"
		rs.open sql, cnn
		
		if not RS.EOF then
		
			existeoTurno = "S"
		
		end if
		rs.close
		
		if existeoTurno = "S" then
				cnn.rollbackTrans
				%>
				<script>
					alert("ATENÇÃO: \n\nTurno já existe.");
					window.history.back();
				</script>
				<%
				response.end
		end if

		

		sql = "Insert Into SCA_TURNO(DESC_TURNO )"
		sql = sql & " Values ("
		sql = sql & "'" & strDescricao & "')"

	elseif acao="A" then
		
		strMensagem = "Registro Alterado com sucesso..."
		sql = "Update SCA_TURNO Set"
		sql = sql & " DESC_TURNO = '" & strDescricao & "'"
		sql = sql & " where COD_TURNO = " & intCodigo
		
	else

		strMensagem = "Registro Excluido com sucesso..."
		sql = "Delete from SCA_TURNO "
		sql = sql & " where COD_TURNO = " & intCodigo
		
	end if
	
	cnn.execute sql
	GravarLog sql
	if err.number = 0 then
	'----------Finaliza tranzação iniciada--------------
		cnn.commitTrans
		%>
		<script>
			alert("<%=strMensagem%>");
			window.location='sca_turno.asp';
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