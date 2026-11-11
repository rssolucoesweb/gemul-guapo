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

	nome					 					= Trim(Request.form("nome"))
	celular					 					= Trim(Request.form("celular"))
	senha					 					= Trim(Request.form("senha"))
	email					 					= Trim(Request.form("email"))
	
	pesquisas 									= Trim(Request.Form("chkPesquisa"))
	
	situacao				 					= Trim(Request.form("cmbSituacao"))
	
	' Dados do Usuario
	strUsuario_incl   	= session("usuarioWeb")
	strData_hora_incl 	= formataDataBDAccess(date) & " " & time
	strUsuario_altr   	= session("usuarioWeb")
	strData_hora_altr 	= formataDataBDAccess(date) & " " & time
	
	if acao = "I" then
		sql = "select codigo" 
		sql = sql & " from PES_entrevistador"
		sql = sql & " where nome = '" & nome & "'"
		rs.open sql, cnn
		if rs.eof = false then
			%>
			<script>
				alert("Registro já cadastrado com a mesmo nome. Verifique o codigo de login: <%=rs("codigo")%>!");
				window.location='entrevistador_cad.asp';
			</script>
			<%
			response.end 
		end if	
		rs.close
		
		sql = "select email" 
		sql = sql & " from PES_entrevistador"
		sql = sql & " where email = '" & email & "'"
		rs.open sql, cnn
		if rs.eof = false then
			%>
			<script>
				alert("Existe um entrevistador cadastrado com a mesmo email. Verifique o email: <%=email%>, esse email deverá ser trocado!");
				window.location='entrevistador_cad.asp';
			</script>
			<%
			response.end 
		end if	
		rs.close
		
		strMensagem = "Registro incluido com sucesso..."

		sql = "SET NoCount ON Insert Into PES_entrevistador(nome, celular, senha, email, situacao, usuario_incl,data_hora_incl,usuario_altr,data_hora_altr)"
		sql = sql & " Values ("
		sql = sql & "'" & nome & "',"
		sql = sql & "'" & celular & "',"
		sql = sql & "'" & senha & "',"
		sql = sql & "'" & email & "',"
		sql = sql & "'" & situacao & "',"
		sql = sql & "'" & strUsuario_incl & "',GETDATE(),"
		sql = sql & "'" & strUsuario_incl & "',GETDATE()); SELECT @@IDENTITY"
		Set rs = cnn.Execute(sql)
		intCodigo = rs(0)
		rs.close
		SQL = REPLACE(sql,"SET NoCount ON ","")
		SQL = REPLACE(sql," ; SELECT @@IDENTITY","")
		GravarLog SQL
		if pesquisas<>"" then
			sql = "insert PES_entrevistador_pesquisa (cod_entrevistador, cod_pesquisa, usuario_incl, data_hora_incl)"
			sql = sql & " select " & intCodigo & ",codigo,'" & strUsuario_incl & "',getdate()"
			sql = sql & " from pes_pesquisa"
			sql = sql & " where codigo in (" & pesquisas & ")"
			cnn.Execute(sql)
		end if
		
	elseif acao = "A" then
		strMensagem = "Registro alterado com sucesso..."
		
		sql = "delete from PES_entrevistador_pesquisa"
		sql = sql & " where cod_entrevistador =" & intCodigo
		cnn.Execute(sql)
		
		if pesquisas<>"" then
			sql = "insert PES_entrevistador_pesquisa (cod_entrevistador, cod_pesquisa, usuario_incl, data_hora_incl)"
			sql = sql & " select " & intCodigo & ",codigo,'" & strUsuario_incl & "',getdate()"
			sql = sql & " from pes_pesquisa"
			sql = sql & " where codigo in (" & pesquisas & ")"
			cnn.Execute(sql)
		end if
		
		sql = "update PES_entrevistador set nome = '" & nome & "',"
		sql = sql & " celular = '" & celular& "',"
		sql = sql & " senha = '" & senha & "',"
		sql = sql & " email = '" & email & "',"
		sql = sql & " situacao = '" & situacao & "',"
		sql = sql & " usuario_altr = '" & strUsuario_incl & "',"
		sql = sql & " data_hora_altr = GETDATE()"
		sql = sql & " where codigo =" & intCodigo
		Set rs = cnn.Execute(sql)
		GravarLog SQL
	
	elseif acao = "E" then
		
		strMensagem = "Registro excluido com sucesso..."

		sql = "delete from PES_entrevistador_pesquisa"
		sql = sql & " where cod_entrevistador =" & intCodigo
		cnn.Execute(sql)
		
		sql = "delete PES_entrevistador"
		sql = sql & " where codigo =" & intCodigo
		Set rs = cnn.Execute(sql)
		GravarLog SQL
	end if

	if err.number = 0 then
	'----------Finaliza tranzação iniciada--------------

		cnn.commitTrans
		
		%>
		<script>
			alert("<%=strMensagem%>");
			window.location = "entrevistador_cad.asp";
		</script>			
		<%
		
		response.end
		
	else
		response.redirect "erro.asp?strNumErro=" & err.number & "&strDescErro=" & err.description 
		cnn.rollbacktrans
	end if
%>