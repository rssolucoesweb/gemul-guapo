<%@LANGUAGE="VBSCRIPT" CODEPAGE="65001"%> 
<%  
response.Charset = "utf-8" 
response.ContentType = "text/html" 
%>
<!--#include file="includes/inc_verificaSessionApp.asp"-->
<!--#include file="includes/inc_cnn.asp"-->
<!--#include file="includes/inc_log.asp"-->

<%
	'on error resume next
	'----------Inicia uma tranzação--------------
	cnn.begintrans
	acao 				= Trim(Request.QueryString("acao"))
	
	intCodigo			= Trim(Request.Form("txtCodigo"))
	strDescricao 		= ucase(Trim(Request.Form("txtDescricao")))
	strDescAbreviada	= ucase(Trim(Request.Form("txtDescAbreviada")))
	strDescHistorico	= ucase(Trim(Request.Form("txtDescHistorico")))
	strSituacao         = Trim(Request.Form("cmbSituacao"))
	strUsoHistorico         = Trim(Request.Form("cmbUsoHistorico"))
	
			
	if acao="I" then
	
		strMensagem = "Registro Salvo com sucesso..."
	
		sql = "SELECT Cod_Disciplina" 
		sql = sql & " FROM SCA_DISCIPLINA where desc_disciplina = '" & strDescricao & "'"
		rs.open sql, cnn
		jaexiste = "N"
		if not RS.EOF then
		
			jaexiste = "S"
		
		end if
		rs.close

		if jaexiste = "S" then
			%>
			<script>	
				alert("Disciplina cadastrada com esse mesmo nome, verifique!");
				window.location='Disciplina_cad.asp';
			</script>
			<%
			response.end
		end if

		

		sql = "Insert Into SCA_DISCIPLINA(DESC_Disciplina, Desc_Abreviada, Desc_Historico, uso_historico, Situacao)"
		sql = sql & " Values ("
		sql = sql & "'" & strDescricao & "',"
		sql = sql & "'" & strDescAbreviada & "',"
		sql = sql & "'" & strDescHistorico & "',"
		sql = sql & "'" & strUsoHistorico & "',"
		sql = sql & "'" & strSituacao & "')"
		cnn.execute sql
		GravarLog sql


	elseif acao="A" then
		
		strMensagem = "Registro Alterado com sucesso..."
		sql = "Update SCA_DISCIPLINA Set"
		sql = sql & " DESC_Disciplina = '" & strDescricao & "',"
		sql = sql & " Desc_Abreviada = '" & strDescAbreviada & "',"
		sql = sql & " Desc_Historico = '" & strDescHistorico & "', "
		sql = sql & " uso_historico = '" & strUsoHistorico & "', "
		sql = sql & " Situacao = '" & strSituacao & "' "
		sql = sql & " where COD_Disciplina = " & intCodigo
		cnn.execute sql
		GravarLog sql
		
	else
	
		strMensagem = "Registro Excluido com sucesso..."
		sql = "Delete from SCA_DISCIPLINA "
		sql = sql & " where COD_Disciplina = " & intCodigo
		cnn.execute sql
		GravarLog sql
	
	end if
	
	if err.number = 0 then
	'----------Finaliza tranzação iniciada--------------
		cnn.commitTrans
		%>
		<script>
			alert("<%=strMensagem%>");
			window.location='sca_disciplina.asp';
		</script>
		<%
		response.end
	else
		cnn.rollbackTrans
		erro = replace(err.description,"'","")
		%>
		<script>
			alert("ATENÇÃO: \n\nNão foi possível executar esse procedimento, tente novamente.\nCaso persistir entre em contato com o administrador do sistema.\n\n<%=erro%>");
			window.history.back();
		</script>
		<%
	end if
%>