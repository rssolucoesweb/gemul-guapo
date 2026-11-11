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
	if acao = "I" then
		email					 					= Trim(Request.form("email")) & ".gemul"
	else
		email					 					= Trim(Request.form("email"))
	end if
	
	pesquisas 									= Trim(Request.Form("chkPesquisa"))
	
	situacao				 					= Trim(Request.form("cmbSituacao"))
	
	strUsuarioPortal = email
	intCodPerfil = 77
		
	' Dados do Usuario
	strUsuario_incl   	= session("usuarioWeb")
	strData_hora_incl 	= formataDataBDAccess(date) & " " & time
	strUsuario_altr   	= session("usuarioWeb")
	strData_hora_altr 	= formataDataBDAccess(date) & " " & time
	
	if acao = "I" then
		sql = "select codigo" 
		sql = sql & " from PES_contratante"
		sql = sql & " where nome = '" & nome & "'"
		rs.open sql, cnn
		if rs.eof = false then
			%>
			<script>
				alert("Registro já cadastrado com a mesmo nome. Verifique o codigo de login: <%=rs("codigo")%>!");
				window.location='contratante_cad.asp';
			</script>
			<%
			response.end 
		end if	
		rs.close
		
		sql = "select email" 
		sql = sql & " from PES_contratante"
		sql = sql & " where email = '" & email & "'"
		rs.open sql, cnn
		if rs.eof = false then
			%>
			<script>
				alert("Existe um contratante cadastrado com a mesmo login. Verifique o login: <%=email%>, deverá ser trocado!");
				window.location='contratante_cad.asp';
			</script>
			<%
			response.end 
		end if	
		rs.close
		
		
		
		if strUsuarioPortal <> "" then
			sql = "SELECT Usua_Codg" 
			sql = sql & " FROM SEG_USUARIOS_SISTEMA"
			sql = sql & " WHERE Usua_Codg = '" & strUsuarioPortal & "'"	
			rs.open sql, cnn
			if not RS.EOF then
				Usua_Codg = rs("Usua_Codg")
				%>
				<script>
					alert("O login <%=Usua_Codg%> esta sendo utilizado, alteramos seu login para <%=Usua_Codg%>.pes .");
				</script>
				<%
				strUsuarioPortal = Usua_Codg & ".pes"
			end if
			rs.close
			
			'insere usuario para acesso no portal
			sql = " Insert into SEG_USUARIOS_SISTEMA (Usua_Codg, Usua_Stat, Usua_Info_Senha, "
			sql = sql & " Usua_Data_Ativacao, CODIGO_DEPARTAMENTO, COD_EMPRESA, "
			sql = sql & " USUA_NOME_COMPLETO, USUA_TELEFONE, USUA_EMAIL, USUA_CPF)" 
			sql = sql & " VALUES("
	
			sql = sql & "'" & strUsuarioPortal & "'," 
			if strSituacao <> "" then
				sql = sql & "'" & strSituacao & "',"
			else
				sql = sql & "null, "
			end if 
			
			sql = sql & "'123456'," 
			sql = sql & "'" & strData_hora_incl & "'," 
			sql = sql & "null,"
			sql = sql & "'" & session("codEmpresa") & "',"
	
			sql = sql & "'" & strnome & "',"
			sql = sql & "'" & strTelefone & "',"
			if stremail <> "" then
				sql = sql & "'" & LCase(stremail) & "',"
			else 
				sql = sql &" null ,"
			end if
			sql = sql & "'" & strCPF & "')"
			cnn.execute sql
			GravarLog sql
			
			sql = " insert into Seg_Acessos_Usuario (Aces_Usua_Codg, Aces_Perf_Codg, Aces_Info_Repasse )"
			sql = sql & " VALUES ('" & strUsuarioPortal & "' , '" & intCodPerfil & "', 'N')"
			cnn.execute sql
			GravarLog sql
			
			sql = " insert into SEG_USUARIOS_EMPRESA (CODIGO_SEG_USUARIOS_SISTEMA, COD_EMPRESA )"
			sql = sql & " VALUES ('" & strUsuarioPortal & "' , '164')"
			cnn.execute sql
			GravarLog sql
		end if

		
		strMensagem = "Registro incluido com sucesso..."

		sql = "SET NoCount ON Insert Into PES_contratante(nome, celular, senha, email, situacao, usuario_incl,data_hora_incl,usuario_altr,data_hora_altr)"
		sql = sql & " Values ("
		sql = sql & "'" & nome & "',"
		sql = sql & "'" & celular & "',"
		sql = sql & "'123456',"
		sql = sql & "'" & strUsuarioPortal & "',"
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
			sql = "insert PES_contratante_pesquisa (cod_contratante, cod_pesquisa, usuario_incl, data_hora_incl)"
			sql = sql & " select " & intCodigo & ",codigo,'" & strUsuario_incl & "',getdate()"
			sql = sql & " from pes_pesquisa"
			sql = sql & " where codigo in (" & pesquisas & ")"
			cnn.Execute(sql)
		end if
		
	elseif acao = "A" then
		strMensagem = "Registro alterado com sucesso..."
		
		sql = "delete from PES_contratante_pesquisa"
		sql = sql & " where cod_contratante =" & intCodigo
		cnn.Execute(sql)
		
		if pesquisas<>"" then
			sql = "insert PES_contratante_pesquisa (cod_contratante, cod_pesquisa, usuario_incl, data_hora_incl)"
			sql = sql & " select " & intCodigo & ",codigo,'" & strUsuario_incl & "',getdate()"
			sql = sql & " from pes_pesquisa"
			sql = sql & " where codigo in (" & pesquisas & ")"
			cnn.Execute(sql)
		end if
		
		sql = "update PES_contratante set nome = '" & nome & "',"
		sql = sql & " celular = '" & celular& "',"
		sql = sql & " situacao = '" & situacao & "',"
		sql = sql & " usuario_altr = '" & strUsuario_incl & "',"
		sql = sql & " data_hora_altr = GETDATE()"
		sql = sql & " where codigo =" & intCodigo
		Set rs = cnn.Execute(sql)
		GravarLog SQL
		
		sql = "update SEG_USUARIOS_SISTEMA set USUA_STAT = '" & situacao & "', usua_nome_completo = '" & nome & "'"
		sql = sql & " where Usua_Codg ='" & strUsuarioPortal & "'"
		Set rs = cnn.Execute(sql)
		GravarLog SQL
		
	elseif acao = "E" then
		
		strMensagem = "Registro excluido com sucesso..."

		sql = "delete from PES_contratante_pesquisa"
		sql = sql & " where cod_contratante =" & intCodigo
		cnn.Execute(sql)
		
		sql = "delete PES_contratante"
		sql = sql & " where codigo =" & intCodigo
		Set rs = cnn.Execute(sql)
		GravarLog SQL
		
		sql = "update SEG_USUARIOS_SISTEMA set USUA_STAT = 'I'"
		sql = sql & " where Usua_Codg ='" & strUsuarioPortal & "'"
		Set rs = cnn.Execute(sql)
		GravarLog SQL
	end if

	if err.number = 0 then
	'----------Finaliza tranzação iniciada--------------

		cnn.commitTrans
		
		%>
		<script>
			alert("<%=strMensagem%>");
			window.location = "contratante_cad.asp";
		</script>			
		<%
		
		response.end
		
	else
		response.redirect "erro.asp?strNumErro=" & err.number & "&strDescErro=" & err.description 
		cnn.rollbacktrans
	end if
%>