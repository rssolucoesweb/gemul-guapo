<meta http-equiv="content-type" content="text/html; charset=UTF-8">
	<!--#include file="../../includes/inc_verificaSession.asp"-->
	<!--#include file="../../includes/inc_cnn.asp"-->
	<!--#include file="../../includes/inc_replaceRequest.asp"-->
    <!--#include file="../../includes/inc_formatadata.asp"-->
	<!--#include file="../../includes/inc_log.asp"-->
<%
	'on error resume next
	'----------Inicia uma tranzação--------------
	acao 										= Trim(Request.QueryString("acao"))
	intCodEmp									= Session("CodEmpresa")

	intCodigo           	  					= Trim(Request.Form("txtCodigo"))
	tipo										= Trim(Request.form("cmbTipo"))
	cod_pergunta           	  					= Trim(Request.form("cod_pergunta"))
	ordem           	  						= Trim(Request.form("ordem"))
	cod_questionario           	  					= Trim(Request.form("cod_questionario"))
	limite_resposta           	  					= Trim(Request.form("limite_resposta"))
	' Dados do Usuario
	strUsuario_incl   	= session("usuarioWeb")
	strData_hora_incl 	= formataDataBDAccess(date) & " " & time
	strUsuario_altr   	= session("usuarioWeb")
	strData_hora_altr 	= formataDataBDAccess(date) & " " & time
	
	if acao = "I" then
		
		strMensagem = "Registro incluido com sucesso..."
		if tipo <> "TEXTO" then
			for i=1 to limite_resposta
				opcao = request.form("opcao_" & i)
				correta = request.form("cmbCorreta_" & i)
				
				if trim(opcao)<>"" then
					sql = "SET NoCount ON Insert Into EAD_tipo_resposta(cod_pergunta,tipo,nome,situacao,usuario_incl,data_hora_incl)"
					sql = sql & " Values ("
					sql = sql & "" & cod_pergunta & ","
					sql = sql & "'" & tipo & "',"
					sql = sql & "'" & opcao & "','A',"
					sql = sql & "'" & strUsuario_incl & "',GETDATE()); SELECT @@IDENTITY"
					Set rs = cnn.Execute(sql)
					cod_tipo_resposta = rs(0)
					rs.close
					
					sql = "Insert Into EAD_resposta(cod_pergunta, cod_tipo_resposta, correta, nome,ordem,usuario_incl,data_hora_incl,usuario_altr,data_hora_altr)"
					sql = sql & " Values ("
					sql = sql & "" & cod_pergunta & ","
					sql = sql & "" & cod_tipo_resposta & ","
					sql = sql & "'" & correta & "',"
					sql = sql & "'" & opcao & "',"
					sql = sql & "" & i & ","
					sql = sql & "'" & strUsuario_incl & "',GETDATE(),"
					sql = sql & "'" & strUsuario_incl & "',GETDATE())"
					cnn.Execute(sql)
					GravarLog SQL
				end if
			next
		else
			cod_tipo_resposta = 1
			if ordem = "" then ordem = "0"
			sql = "Insert Into EAD_resposta(cod_pergunta, cod_tipo_resposta, correta, nome,ordem, usuario_incl,data_hora_incl,usuario_altr,data_hora_altr)"
			sql = sql & " Values ("
			sql = sql & "" & cod_pergunta & ","
			sql = sql & "" & cod_tipo_resposta & ","
			sql = sql & "'S',"
			sql = sql & "'Resposta curta'," & ordem & ","
			sql = sql & "'" & strUsuario_incl & "',GETDATE(),"
			sql = sql & "'" & strUsuario_incl & "',GETDATE())"
			cnn.Execute(sql)
			GravarLog SQL
		
		end if
	elseif acao = "A" then
	
	elseif acao = "E" then
		strMensagem = "Registro excluido com sucesso..."
		if tipo = "TEXTO" then
			sql = "delete EAD_resposta"
			sql = sql & " where codigo =" & intCodigo
			Set rs = cnn.Execute(sql)
			GravarLog SQL
		else
			
			sql = "delete EAD_tipo_resposta"
			sql = sql & " where tipo<>'TEXTO' AND cod_pergunta =" & cod_pergunta
			Set rs = cnn.Execute(sql)
			GravarLog SQL
			
			sql = "delete EAD_resposta"
			sql = sql & " where cod_tipo_resposta<>1 AND cod_pergunta =" & cod_pergunta
			Set rs = cnn.Execute(sql)
			GravarLog SQL
		end if
	end if
	if err.number = 0 then
	'----------Finaliza tranzação iniciada--------------

		
		%>
		<script>
			alert("<%=strMensagem%>");
			window.location = "resposta_cad.asp?cod_questionario=<%=cod_questionario%>&cod_pergunta=<%=cod_pergunta%>";
		</script>			
		<%
		
		response.end
		
	else
		response.redirect "erro.asp?strNumErro=" & err.number & "&strDescErro=" & err.description 
	end if
%>