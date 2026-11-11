<%@LANGUAGE="VBSCRIPT" CODEPAGE="65001"%> 
<%  
response.Charset = "utf-8" 
response.ContentType = "text/html" 
%>
<!--#include file="includes/inc_verificaSessionApp.asp"-->
<!--#include file="includes/inc_cnn.asp"-->
<!--#include file="includes/inc_log.asp"-->
<!--#include file="includes/inc_formatadata.asp"-->
<%
	'ajax=1 (tela Vincula aluno a rota): responde JSON e não recarrega a tela
	blnAjax = (Request.QueryString("ajax") = "1")

	function vaJson(ByVal t)
		dim i, c, r
		r = ""
		t = t & ""
		for i = 1 to len(t)
			c = mid(t, i, 1)
			if c = "\" then
				r = r & "\\"
			elseif c = """" then
				r = r & "\"""
			elseif AscW(c) < 32 then
				r = r & " "
			elseif AscW(c) > 126 then
				r = r & "\u" & right("000" & lcase(hex(AscW(c))), 4)
			else
				r = r & c
			end if
		next
		vaJson = r
	end function

	sub vaResponde(ByVal ok, ByVal mensagem, ByVal codSolic)
		Response.Clear
		Response.ContentType = "application/json"
		dim strOk
		if ok then strOk = "true" else strOk = "false"
		Response.Write "{""ok"":" & strOk & ",""mensagem"":""" & vaJson(mensagem) & """,""cod_solicitacao"":""" & vaJson(codSolic) & """}"
		Response.End
	end sub

	'Texto para SQL (nome com apóstrofo, ex.: D'ARC, quebrava a inclusão)
	function vaTxt(ByVal v)
		vaTxt = replace(v & "", "'", "''")
	end function

'on error resume next
	'----------Inicia uma tranzação--------------
	cnn.begintrans
	rede = request("rede")
	acao 					= Trim(Request.QueryString("acao"))
	intCodAluno				= Trim(Request("CodAluno"))
	intCodEmpresa 			= Trim(Request("cmbEmpresa"))
	intAnoLetivo	 		= Trim(Request.Form("txtAnoLetivo"))
	intCodRota				= Trim(Request("CodRota"))

	intCodTurno				= Trim(Request("cmbTurno"))
	strCodAluno				= Trim(Request("CodAluno"))
	
	if acao="I" then
		
		strMensagem = "Aluno vinculado com sucesso..."
	
		intCodTurma 		= Trim(Request.Form("txtTurma_" & strCodAluno))
		
		
		IF intCodTurma = "" then		
			cnn.rollbacktrans
			if blnAjax then vaResponde false, "Aluno não alocado no turno selecionado!", ""
			%>
			<script>
				alert("Aluno não alocado no turno selecionado!");
				window.history.back();
			</script>
			<%
			response.end
		END IF		
		
		'limpa vinculo de outras rotas/unidades caso exista, junto com a solicitação de transporte desse vínculo
		'(antes a solicitação antiga ficava gravada sem vínculo)
		sql = "DECLARE @SOLIC TABLE (CODIGO INT);"
		sql = sql & " INSERT INTO @SOLIC SELECT cod_solicitacao_transporte FROM SCA_ROTA_VICULA_ALUNO"
		sql = sql & " WHERE cod_aluno = " & intCodAluno & " AND ano_letivo = " & intAnoLetivo & " AND cod_solicitacao_transporte IS NOT NULL;"
		sql = sql & " DELETE FROM SCA_ROTA_VICULA_ALUNO WHERE cod_aluno = " & intCodAluno & " AND ano_letivo = " & intAnoLetivo & ";"
		sql = sql & " DELETE FROM ste_solicitacao_transporte WHERE codigo IN (SELECT CODIGO FROM @SOLIC)"
		sql = sql & " AND NOT EXISTS (SELECT 1 FROM SCA_ROTA_VICULA_ALUNO V WHERE V.cod_solicitacao_transporte = ste_solicitacao_transporte.codigo);"
		cnn.execute sql
		GravarLog sql

		
		sql = "select NEWID()"
		Set rs = cnn.Execute(sql)
		chave = rs(0)
		rs.close
			
		sql = "select * "
		sql = sql & " from sca_aluno"
		sql = sql & " WHERE codigo = " & intCodAluno
		RS.OPEN SQL, CNN
		IF NOT RS.EOF THEN	
			strNomealuno	       = rs("NOMEALUNO")
			strCPF                 = rs("CPF")
			strDatanascimento      = formatadataBD(rs("DATANASCIMENTO"))
			strMae                 = rs("MAE")
			strSexo                = rs("SEXOALUNO")
			strCep                 = rs("CEPRESIDENCIA")
			strLogradouro          = rs("LOGRADOURO")
			strNumeroEndereco      = rs("NUMERO_ENDERECO")
			strComplementoEndereco = rs("COMP_ENDERECO")
			strBairro              = rs("BAIRROALUNO")
			strCidade              = rs("CIDADERESIDENCIA")
			strUF                  = "GO"
			strEmail               = rs("EMAIL")
			strContato             = rs("FONERESIDENCIAL")
			strCelular             = rs("FONECELULAR")
			strFonePai             = rs("PAIFONE")
			strFoneMae             = rs("MAEFONE")
			strSituacao			   = "D"
		end if
		rs.close
		
		sql = "select codigo, cod_turma "
		sql = sql & " from sca_aluno_turma"
		sql = sql & " WHERE cod_aluno = " & intCodAluno
		sql = sql & " And ano_letivo = " & intAnoLetivo
		sql = sql & " And cod_empresa = " & intCodEmpresa
		sql = sql & " And situacao = 'A' order by 1 desc"
		RS.OPEN SQL, CNN
		IF NOT RS.EOF THEN	
			intCodTurma	       = rs("cod_turma")
		end if
		rs.close

		sql = "SET NoCount ON Insert Into ste_solicitacao_transporte( ano_letivo, chave, cod_aluno, cod_rota, nome, cpf, data_nascimento, mae, sexo, cep, Logradouro, NumeroEndereco,  ComplementoEndereco, bairro, "
		sql = sql & " cidade, uf, email, Contato, Celular, FonePai, FoneMae,"
		sql = sql & " Cod_empresa, Cod_turma, Situacao, data_efetivacao, usuario_efetivacao, usuario_incl, data_hora_incl)"
		sql = sql & " Values ("
		sql = sql & "" & clng(intAnoLetivo) & ","
		sql = sql & "'" & chave & "',"
		sql = sql & "" & intCodAluno & ","
		sql = sql & "" & intCodRota & ","
		sql = sql & "'" & vaTxt(strNomealuno) & "',"
		if strCPF="" then
			sql = sql & "null,"
		else
			sql = sql & "'" & strCPF & "',"
		end if
		sql = sql & "'" & strDatanascimento & "',"
		sql = sql & "'" & vaTxt(strMae) & "',"
		sql = sql & "'" & strSexo & "',"
		sql = sql & "'" & strCep & "',"
		sql = sql & "'" & vaTxt(strLogradouro) & "',"
		
		if 	strNumeroEndereco 	 = "" then
			sql = sql & "NULL,"
		else
			sql = sql & "'" & strNumeroEndereco & "',"
		end if
		
		sql = sql & "'" & vaTxt(strComplementoEndereco) & "',"
		sql = sql & "'" & vaTxt(strBairro) & "',"
		sql = sql & "'" & vaTxt(strCidade) & "',"
		sql = sql & "'" & strUF & "',"
		sql = sql & "'" & vaTxt(strEmail) & "',"
		
		if 	strContato 	 = "" then
			sql = sql & "NULL,"
		else
			sql = sql & "'" & strContato & "',"
		end if
		
		if 	strCelular 	 = "" then
			sql = sql & "NULL,"
		else
			sql = sql & "'" & strCelular & "',"
		end if
		
		if 	strFonePai 	 = "" then
			sql = sql & "NULL,"
		else
			sql = sql & "'" & strFonePai & "',"
		end if
		
		if 	strFoneMae 	 = "" then
			sql = sql & "NULL,"
		else
			sql = sql & "'" & strFoneMae & "',"
		end if
		
		if 	intCodEmpresa 	 = "" then
			sql = sql & "NULL,"
		else
			sql = sql & "" & intCodEmpresa & ","
		end if
		if 	intCodTurma 	 = "" then
			sql = sql & "NULL,"
		else
			sql = sql & "" & intCodTurma & ","
		end if
		sql = sql & "'" & strSituacao & "',"
		sql = sql & "GETDATE(),'" & session("usuarioWeb") & "',"
		sql = sql & "'" & session("usuarioWeb") & "',GETDATE());SELECT @@IDENTITY "
		Set rs = cnn.Execute(sql)
		cod_solicitacao_transporte = rs(0)
		rs.close
		
		strMensagem = "Aluno incluído com sucesso!"
		
		
		sql = "Insert into SCA_ROTA_VICULA_ALUNO (cod_solicitacao_transporte, cod_empresa, cod_aluno, codTurma, ano_letivo, Cod_Rota, usuario_incl, data_hora_incl)"
		sql = sql & " VALUES ("
		sql = sql & " " & cod_solicitacao_transporte & ","
		sql = sql & " " & intCodEmpresa & ","
		sql = sql & " " & intCodAluno & ","
		sql = sql & " " & intCodTurma & ","
		sql = sql & " " & intAnoLetivo & ","
		sql = sql & " " & intCodRota & ","
		sql = sql & " '" & session("usuarioweb") & "',"
		sql = sql & " getdate())"
		'if session("usuarioWeb") = "SERGIO" THEN
		'	RESPONSE.WRITE SQL & "<hr>"
		'end if	
		cnn.execute sql
		GravarLog sql

	elseif acao="E" then
		codSolicitacao = request("cod_solicitacao_transporte")
		
		strMensagem = "Alunos excluído do transporte escolar com sucesso..."
		
		sql = "Delete from SCA_ROTA_VICULA_ALUNO"
		sql = sql & " Where cod_solicitacao_transporte = " & codSolicitacao
		cnn.execute sql
		GravarLog sql
		
		
		sql="DELETE ste_solicitacao_transporte "
		sql = sql & " where codigo = " & codSolicitacao
		cnn.execute sql
		GravarLog sql
	
	end if
	
	if err.number = 0 then
	'----------Finaliza tranzação iniciada--------------
		cnn.commitTrans
		if blnAjax then vaResponde true, strMensagem, cod_solicitacao_transporte & ""
		intCodTurma				= Trim(Request.Form("cmbTurma"))
		%>
		<script>
			alert("<%=strMensagem%>");
			window.location='ste_vincula_aluno_individualCon.asp?rede=<%=rede%>&txtAnoLetivo=<%=intAnoLetivo%>&cmbEmpresa=<%=intCodEmpresa%>&cmbRota=<%=intCodRota%>&cmbTurno=<%=intCodTurno%>&cmbTurma=<%=intCodTurma%>&txtMatricula=<%=server.urlEncode(Trim(Request.Form("txtMatricula")))%>';
		</script>
		<%
		response.end
	else
		cnn.rollbacktrans
		if blnAjax then vaResponde false, "Erro ao gravar: " & err.description, ""
		response.redirect "erro.asp?strNumErro=" & err.number & "&strDescErro=" & err.description 
	end if
%>
