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
	cod_tipo_resposta							= Trim(Request.form("cmbTipoResposta"))
	tipo										= Trim(Request.form("cmbTipo"))
	if tipo = "TEXTO" then cod_tipo_resposta = "1"
	cod_pergunta           	  					= Trim(Request.form("cod_pergunta"))
	cod_pesquisa           	  					= Trim(Request.form("cod_pesquisa"))
	
	' Dados do Usuario
	strUsuario_incl   	= session("usuarioWeb")
	strData_hora_incl 	= formataDataBDAccess(date) & " " & time
	strUsuario_altr   	= session("usuarioWeb")
	strData_hora_altr 	= formataDataBDAccess(date) & " " & time
	
	if acao <> "E" then
		if trim(cod_tipo_resposta) <> "" then
			sql = "SELECT nome"
			sql = sql & " FROM PES_tipo_resposta"
			sql = sql & " where codigo = " & cod_tipo_resposta
			rs.open sql, cnn
			if rs.eof = false then
				nome	= rs("nome")
			end if 
			rs.close
		end if
	end if
	
	if acao = "I" then
		existe = "N"
		if trim(cod_tipo_resposta) <> "" then
			sql = "SELECT nome"
			sql = sql & " FROM PES_resposta"
			sql = sql & " where cod_pergunta = " & cod_pergunta
			sql = sql & " and cod_tipo_resposta = " & cod_tipo_resposta
			rs.open sql, cnn
			if rs.eof = false then
				existe = "S"
			end if 
			rs.close
		end if
		if existe = "S" then
			%>
			<script>
				alert("ATENÇÃO: Já existe essa mesma resposta, favor verifique!");
				window.location = "resposta_cad.asp?cod_pesquisa=<%=cod_pesquisa%>&cod_pergunta=<%=cod_pergunta%>";
			</script>
			<%
			response.end
		end if
		
		strMensagem = "Registro incluido com sucesso..."

		sql = "SET NoCount ON Insert Into PES_resposta(cod_pergunta, cod_tipo_resposta, nome,usuario_incl,data_hora_incl,usuario_altr,data_hora_altr)"
		sql = sql & " Values ("
		sql = sql & "" & cod_pergunta & ","
		sql = sql & "" & cod_tipo_resposta & ","
		sql = sql & "'" & nome & "',"
		sql = sql & "'" & strUsuario_incl & "',GETDATE(),"
		sql = sql & "'" & strUsuario_incl & "',GETDATE()); SELECT @@IDENTITY"
		Set rs = cnn.Execute(sql)
		intCodigo = rs(0)
		rs.close
		SQL = REPLACE(sql,"SET NoCount ON ","")
		SQL = REPLACE(sql," ; SELECT @@IDENTITY","")
		GravarLog SQL
		
		'existeCuringa = "N"
		'sql = "SELECT nome"
		'sql = sql & " FROM PES_resposta"
		'sql = sql & " where cod_pergunta = " & cod_pergunta
		'sql = sql & " and cod_tipo_resposta = 1" 'curinga
		'rs.open sql, cnn
		'if not rs.eof then
		'	existeCuringa = "S"
		'end if 
		'rs.close
		
		'if existeCuringa = "N" then
		'	sql = "Insert Into PES_resposta(cod_pergunta, cod_tipo_resposta, nome,usuario_incl,data_hora_incl,usuario_altr,data_hora_altr) values ("
		'	sql = sql & "" & cod_pergunta & ",1,'NÃO OPINARAM','" & strUsuario_incl & "',GETDATE(),'" & strUsuario_incl & "',GETDATE())"
		'	cnn.Execute(sql)
		'end if
		
		sql = "update PES_resposta set ordem = codigo"
		sql = sql & " where cod_pergunta =" & cod_pergunta
		cnn.Execute(sql)

		'sql = "update PES_resposta set ordem = (select max(codigo)+1 from PES_resposta where cod_pergunta =" & cod_pergunta & ")"
		'sql = sql & " where cod_tipo_resposta = 1 and cod_pergunta =" & cod_pergunta
		'cnn.Execute(sql)
		
	elseif acao = "A" then
		
		strMensagem = "Registro alterado com sucesso..."

		sql = "update PES_resposta set nome = '" & nome & "',"
		sql = sql & " cod_pergunta = " & cod_pergunta & ","
		sql = sql & " cod_tipo_resposta = " & cod_tipo_resposta & ","
		sql = sql & " usuario_altr = '" & strUsuario_incl & "',"
		sql = sql & " data_hora_altr = GETDATE()"
		sql = sql & " where codigo =" & intCodigo
		Set rs = cnn.Execute(sql)
		GravarLog SQL
	
	elseif acao = "E" then
		
		strMensagem = "Registro excluido com sucesso..."

		sql = "delete PES_resposta"
		sql = sql & " where codigo =" & intCodigo
		Set rs = cnn.Execute(sql)
		GravarLog SQL
		
	end if
	if err.number = 0 then
	'----------Finaliza tranzação iniciada--------------

		
		%>
		<script>
			alert("<%=strMensagem%>");
			window.location = "resposta_cad.asp?cod_pesquisa=<%=cod_pesquisa%>&cod_pergunta=<%=cod_pergunta%>";
		</script>			
		<%
		
		response.end
		
	else
		response.redirect "erro.asp?strNumErro=" & err.number & "&strDescErro=" & err.description 
	end if
%>