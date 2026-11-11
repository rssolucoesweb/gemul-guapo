<%@LANGUAGE="VBSCRIPT" CODEPAGE="65001"%> 
<%  
response.Charset = "utf-8" 
response.ContentType = "text/html" 
%>
<!--#include file="includes/inc_verificaSessionApp.asp"-->
<!--#include file="includes/inc_cnn.asp"-->
<!--#include file="includes/inc_log.asp"-->
<!--#include file="includes/inc_formataData.asp"-->

<%
	'on error resume next
	'----------Inicia uma tranzação--------------
	cnn.begintrans
	strAnoLetivo	= Request.Form("txtAnoLetivo")
	strDias	= Request.Form("txtDias")
	if strDias = "" then strDias = 0
	strBloqueio	= Request.Form("cmbBloqueio")
	
	acao = "I"
	sql = "select * from SCA_PLANEJAMENTO_PERIODO where ano_letivo = " & strAnoLetivo
	rs.open sql, cnn
	if not rs.eof then
		acao = "A"
		
	end if
	rs.close
	
	if acao = "I" then
	
		for i=1 to 12
			strDataInicial_primeiro					= formataDataBD(Trim(Request.Form("txtDataInicial_primeiro_" & i)))
			strDataFinal_primeiro					= formataDataBD(Trim(Request.Form("txtDataFinal_primeiro_" & i)))

			strDataInicial_segundo					= formataDataBD(Trim(Request.Form("txtDataInicial_segundo_" & i)))
			strDataFinal_segundo					= formataDataBD(Trim(Request.Form("txtDataFinal_segundo_" & i)))
			
			sql = "Insert Into SCA_PLANEJAMENTO_PERIODO(ano_letivo, mes, data_inicial_primeiro, data_final_primeiro, data_inicial_segundo, data_final_segundo, usuario_incl, data_hora_incl)"
			sql = sql & " Values ("
			sql = sql & "'" & strAnoLetivo & "',"
			sql = sql & "'" & i & "',"
			if strDataInicial_primeiro="" then
				sql = sql & "null,"
			else
				sql = sql & "'" & strDataInicial_primeiro & "',"
			end if
			
			if strDataFinal_primeiro="" then
				sql = sql & "null,"
			else
				sql = sql & "'" & strDataFinal_primeiro & "',"
			end if
			
			if strDataInicial_segundo="" then
				sql = sql & "null,"
			else
				sql = sql & "'" & strDataInicial_segundo & "',"
			end if
			
			if strDataFinal_segundo="" then
				sql = sql & "null,"
			else
				sql = sql & "'" & strDataFinal_segundo & "',"
			end if
			
			sql = sql & "'" &  session("usuarioweb") & "',"
			sql = sql & "getdate())"
			
			cnn.execute sql
			GravarLog sql
		next
	elseif acao = "A" then
		for i=1 to 12
			strDataInicial_primeiro					= formataDataBD(Trim(Request.Form("txtDataInicial_primeiro_" & i)))
			strDataFinal_primeiro					= formataDataBD(Trim(Request.Form("txtDataFinal_primeiro_" & i)))

			strDataInicial_segundo					= formataDataBD(Trim(Request.Form("txtDataInicial_segundo_" & i)))
			strDataFinal_segundo					= formataDataBD(Trim(Request.Form("txtDataFinal_segundo_" & i)))
			
			sql = "update SCA_PLANEJAMENTO_PERIODO set "

			if strDataInicial_primeiro="" then
				sql = sql & "data_inicial_primeiro = null,"
			else
				sql = sql & "data_inicial_primeiro = '" & strDataInicial_primeiro & "',"
			end if
			
			if strDataFinal_primeiro="" then
				sql = sql & "data_final_primeiro = null,"
			else
				sql = sql & "data_final_primeiro = '" & strDataFinal_primeiro & "',"
			end if
			
			if strDataInicial_segundo="" then
				sql = sql & "data_inicial_segundo = null,"
			else
				sql = sql & "data_inicial_segundo = '" & strDataInicial_segundo & "',"
			end if
			
			if strDataFinal_segundo="" then
				sql = sql & "data_final_segundo = null,"
			else
				sql = sql & "data_final_segundo = '" & strDataFinal_segundo & "',"
			end if
			
			sql = sql & " usuario_altr = '" &  session("usuarioweb") & "',"
			sql = sql & " data_hora_altr = getdate() "

			sql = sql & " where ano_letivo = '" & strAnoLetivo & "'"
			sql = sql & " and mes = '" & i & "'"
'response.write sql & "<hr>"
			cnn.execute sql
			GravarLog sql
		next
	end if

	existe_conteudo_ministrado_periodo = false

	sql = "select * from SCA_CONTEUDO_MINISTRADO_PERIODO"
	rs.open sql, cnn
	if rs.eof = false then
		existe_conteudo_ministrado_periodo = true
	end if
	rs.close

	if existe_conteudo_ministrado_periodo then
		sql = "update SCA_CONTEUDO_MINISTRADO_PERIODO"
		sql=sql & " set bloqueio = '" & strBloqueio & "', "
		sql=sql & " quantidade_dias = " & strDias & ", "
		sql=sql & " usuario_altr = '" & session("usuarioweb") & "', "
		sql=sql & " data_hora_altr = getdate()"
		cnn.execute sql
		GravarLog sql
	else
		sql = "insert into SCA_CONTEUDO_MINISTRADO_PERIODO (bloqueio, quantidade_dias, usuario_incl, data_hora_incl) values "
		sql = sql & "('" & strBloqueio & "', " & strDias & ", '" & session("usuarioweb") & "', getdate())"
		cnn.execute sql
		GravarLog sql
	end if

	
	strMensagem = "Registro atualizado com sucesso..."
	
	
	
	if err.number = 0 then
	'----------Finaliza tranzação iniciada--------------
		cnn.commitTrans
		%>
		<script>
			alert("<%=strMensagem%>");
			window.location='sca_planejamento_periodo.asp';
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