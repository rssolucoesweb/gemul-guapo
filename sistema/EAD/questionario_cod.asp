<meta http-equiv="content-type" content="text/html; charset=UTF-8">
	<!--#include file="../../includes/inc_verificaSession.asp"-->
	<!--#include file="../../includes/inc_cnn.asp"-->
	<!--#include file="../../includes/inc_replaceRequest.asp"-->
    <!--#include file="../../includes/inc_formatadata.asp"-->
	<!--#include file="../../includes/inc_log.asp"-->
<%
	'on error resume next
	'----------Inicia uma tranzação--------------
	cnn.begintrans
	acao 										= Trim(Request.QueryString("acao"))
	intCodEmp									= Session("CodEmpresa")
	intCodigo           	  					= Trim(Request.Form("txtCodigo"))

	nome										= Trim(Request.form("nome"))
	cod_turma	 								= Trim(Request.Form("turma"))
	descricao									= Trim(Request.form("descricao"))
	data_entrega								= formataDataBD(Trim(Request.form("data_entrega")))
	situacao									= Trim(Request.form("cmbSituacao"))
	limite				 						= Trim(Request.form("limite"))
	if limite = "" then limite = "0"
	
	' Dados do Usuario
	strUsuario_incl   	= session("usuarioWeb")
	strData_hora_incl 	= formataDataBDAccess(date) & " " & time
	strUsuario_altr   	= session("usuarioWeb")
	strData_hora_altr 	= formataDataBDAccess(date) & " " & time
	
	if acao = "I" then
		
		
		if cod_turma = "" then
		%>
			<script>
				alert("A turma deve ser selecionada!")
			</script>
		<%
			response.end
		end if
		strMensagem = "Registro incluido com sucesso..."
		
		sql = "SET NoCount ON Insert Into EAD_questionario(cod_empresa,nome,descricao,situacao,data_entrega,limite_resposta,usuario_incl,data_hora_incl,usuario_altr,data_hora_altr)"
		sql = sql & " Values ("
		sql = sql & "" & session("codEmpresa") & ","
		sql = sql & "'" & nome & "',"
		sql = sql & "'" & descricao & "',"
		sql = sql & "'" & situacao & "',"
		if data_entrega = "" then
			sql = sql & "null,"
		else
			sql = sql & "'" & data_entrega & "',"
		end if
		sql = sql & "" & limite & ","
		sql = sql & "'" & strUsuario_incl & "',GETDATE(),"
		sql = sql & "'" & strUsuario_incl & "',GETDATE()); SELECT @@IDENTITY"
		Set rs = cnn.Execute(sql)
		intCodQuestionario = rs(0)
		rs.close
		SQL = REPLACE(sql,"SET NoCount ON ","")
		SQL = REPLACE(sql," ; SELECT @@IDENTITY","")
		GravarLog SQL
		
		sql = "insert EAD_questionario_turma (cod_questionario, cod_turma, usuario_incl, data_hora_incl)"
		sql = sql & " select "
		sql = sql & "" & intCodQuestionario & " as cod_questionario"
		sql = sql & " ,cod_turma"
		sql = sql & " ,'" & strUsuario_incl & "' as usuario_incl,GETDATE()"
		sql = sql & " from sca_turma"
		sql = sql & " where cod_turma in (" & cod_turma & ")"
		cnn.Execute(sql)
		
	elseif acao = "A" then
		
		strMensagem = "Registro alterado com sucesso..."

		sql = "update EAD_questionario set nome = '" & nome & "',"
		sql = sql & " descricao = '" & descricao & "',"
		if data_entrega = "" then
			sql = sql & "data_entrega = null,"
		else
			sql = sql & "data_entrega = '" & data_entrega & "',"
		end if
		sql = sql & " limite_resposta = " & limite & ","
		sql = sql & " situacao = '" & situacao & "',"
		sql = sql & " usuario_altr = '" & strUsuario_incl & "',"
		sql = sql & " data_hora_altr = GETDATE()"
		sql = sql & " where codigo =" & intCodigo
		Set rs = cnn.Execute(sql)
		GravarLog SQL
	
	elseif acao = "E" then
		
		strMensagem = "Registro excluido com sucesso..."

		sql = "delete"
		sql = sql & " from EAD_questionario_turma"
		sql = sql & " where cod_questionario = " & intCodigo
		cnn.Execute(sql)
		GravarLog SQL	
		
		sql = "delete"
		sql = sql & " from EAD_resultado_respostas_texto"
		sql = sql & " where cod_resultado_respostas in ("
		sql = sql & " select codigo from EAD_resultado_respostas"
		sql = sql & " where cod_resultado in (select codigo from EAD_resultado where cod_questionario =" & intCodigo & "))"
		cnn.Execute(sql)
		GravarLog SQL	
		
		sql = "delete"
		sql = sql & " from EAD_resultado_respostas"
		sql = sql & " where cod_resultado in (select codigo from EAD_resultado where cod_questionario =" & intCodigo & ")"
		cnn.Execute(sql)
		GravarLog SQL
		
		sql = "delete EAD_resposta"
		sql = sql & " where cod_pergunta in (select codigo from EAD_pergunta where cod_questionario =" & intCodigo & ")"
		Set rs = cnn.Execute(sql)
		GravarLog SQL
		
		sql = "delete EAD_pergunta"
		sql = sql & " where cod_questionario =" & intCodigo
		Set rs = cnn.Execute(sql)
		GravarLog SQL
		
		sql = "delete EAD_questionario"
		sql = sql & " where codigo =" & intCodigo
		Set rs = cnn.Execute(sql)
		GravarLog SQL
		
	elseif acao = "R" then
		
		strMensagem = "Respostas excluidas com sucesso..."
		sql = "delete"
		sql = sql & " from EAD_resultado_respostas_texto"
		sql = sql & " where cod_resultado_respostas in ("
		sql = sql & " select codigo from EAD_resultado_respostas"
		sql = sql & " where cod_resultado in (select codigo from EAD_resultado where cod_questionario =" & intCodigo & "))"
		cnn.Execute(sql)
		GravarLog SQL	
		
		sql = "delete"
		sql = sql & " from EAD_resultado_respostas"
		sql = sql & " where cod_resultado in (select codigo from EAD_resultado where cod_questionario =" & intCodigo & ")"
		cnn.Execute(sql)
		GravarLog SQL	

		sql = "delete"
		sql = sql & " from EAD_resultado where cod_questionario = " & intCodigo
		cnn.Execute(sql)
		GravarLog SQL	
	end if

	if err.number = 0 then
	'----------Finaliza tranzação iniciada--------------

		cnn.commitTrans
		
		%>
		<script>
			alert("<%=strMensagem%>");
			window.location = "questionario_cad.asp";
		</script>			
		<%
		
		response.end
		
	else
		response.redirect "erro.asp?strNumErro=" & err.number & "&strDescErro=" & err.description 
		cnn.rollbacktrans
	end if
%>