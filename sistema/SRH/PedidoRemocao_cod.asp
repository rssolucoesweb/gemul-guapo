	<!--#include file="../../includes/inc_verificaSession.asp"-->
	<!--#include file="../../includes/inc_cnn.asp"-->
	<!--#include file="../../includes/inc_replaceRequest.asp"-->
	<!--#include file="../../includes/inc_log.asp"-->
	<%
	acao			 	= Trim(Trim(Request("acao")))
	codigo	 			= Trim(Trim(Request("codigo")))
	intCodigo	 		= Trim(Trim(Request.form("txtCodigo")))
	intCodFuncionario 	= Trim(Trim(Request.Form("txtCodFuncionario")))
	
	
	intCodEmpresaAtual 		= Trim(Trim(Request.Form("txtCodEmpresaAtual")))
	intCodFuncaoAtual 		= Trim(Trim(Request.Form("txtCodFuncaoAtual")))
	intCodCargoAtual 		= Trim(Trim(Request.Form("txtCodCargoAtual")))
	strFuncaoEscolhida 		= Trim(Trim(Request.Form("txtFuncaoEscolhida")))
	intCodTurnoAtual 		= Trim(Trim(Request.Form("txtCodTurnoAtual")))
	intCodTurnoEscolhido	= Trim(Trim(Request.Form("cmbTurnoRH")))
	
	observacao		= Trim(Trim(Request.Form("observacao")))
	strMotivo		= Trim(Trim(Request.Form("cmbMotivo")))
	
	strAnoletivo = Trim(Request("txtAnoLetivo"))
	if strAnoletivo = "" then strAnoletivo = year(date)
	
	
	intCodEmpMarcada 	= Trim(Request.Form("chkEmp"))
	if intCodEmpMarcada <> "" then
		vetUnidade = split(intCodEmpMarcada,", ")
		if isArray(vetUnidade) then
			for i=0 to ubound(vetUnidade)
				if i=0 then cod_empresa_1opcao = vetUnidade(i)
				if i=1 then cod_empresa_2opcao = vetUnidade(i)
				if i=2 then cod_empresa_3opcao = vetUnidade(i)
			next
		end if
	end if
	
	intCodRegMarcada 	= Trim(Request.Form("chkReg"))
	if intCodRegMarcada <> "" then
		vetRegiao = split(intCodRegMarcada,", ")
		if isArray(vetRegiao) then
			for i=0 to ubound(vetRegiao)
				if i=0 then cod_regiao_1opcao = vetRegiao(i)
				if i=1 then cod_regiao_2opcao = vetRegiao(i)
				if i=2 then cod_regiao_3opcao = vetRegiao(i)
			next
		end if
	end if
	
	'on error resume next
	cnn.begintrans
	
	if acao="I" then
		
		strMensagem = "Pedido foi incluido com sucesso..."

		sql = "Insert Into SRH_PEDIDO_REMOCAO(ano_letivo, cod_grupo, cod_empresa, cod_colaborador, cod_cargo, cod_funcao, observacao, cod_motivo_remocao, cod_turno, cod_turno_escolhido, cod_regiao1, cod_regiao2, cod_regiao3, cod_empresa_1opcao, cod_empresa_2opcao, cod_empresa_3opcao, situacao, usuario_incl, data_hora_incl) "
		sql = sql & " Values ("
		sql = sql & "" & strAnoletivo & ","
		sql = sql & "" & session("CodGrupo") & ","
		sql = sql & "" & intCodEmpresaAtual & ","
		sql = sql & "" & intCodFuncionario & ","
		sql = sql & "" & intCodCargoAtual & ","
		sql = sql & "" & intCodFuncaoAtual & ","
		sql = sql & "'" & observacao & "',"
		sql = sql & "" & strMotivo & ","
		sql = sql & "" & intCodTurnoAtual & ","
		sql = sql & "" & intCodTurnoEscolhido & ","
		if cod_regiao_1opcao <> "" then
			sql = sql & "" & cod_regiao_1opcao & ","
		else
			sql = sql & " null,"
		end if
		if cod_regiao_2opcao <> "" then
			sql = sql & "" & cod_regiao_2opcao & ","
		else
			sql = sql & " null,"
		end if
		if cod_regiao_3opcao <> "" then
			sql = sql & "" & cod_regiao_3opcao & ","
		else
			sql = sql & " null,"
		end if
		if cod_empresa_1opcao <> "" then
			sql = sql & "" & cod_empresa_1opcao & ","
		else
			sql = sql & " null,"
		end if
		if cod_empresa_2opcao <> "" then
			sql = sql & "" & cod_empresa_2opcao & ","
		else
			sql = sql & " null,"
		end if
		if cod_empresa_3opcao <> "" then
			sql = sql & "" & cod_empresa_3opcao & ","
		else
			sql = sql & " null,"
		end if
		sql = sql & "'A',"
		sql = sql & "'" & trim(session("usuarioWeb")) & "',"
		sql = sql & "getdate())"
		cnn.execute sql
		GravarLog sql
	elseif acao ="A" then
		
		strMensagem = "Pedido foi alterado com sucesso..."

		sql = "update SRH_PEDIDO_REMOCAO set "
		sql = sql & "cod_empresa = " & intCodEmpresaAtual & ","
		sql = sql & "ano_letivo = " & strAnoletivo & ","
		sql = sql & "cod_cargo = " & intCodCargoAtual & ","
		sql = sql & "cod_funcao = " & intCodFuncaoAtual & ","
		sql = sql & "observacao = '" & observacao & "',"
		sql = sql & "cod_motivo_remocao = " & strMotivo & ","
		sql = sql & "cod_turno = " & intCodTurnoAtual & ","
		sql = sql & "cod_turno_escolhido = '" & intCodTurnoEscolhido & "',"
		if cod_regiao_1opcao <> "" then
			sql = sql & "cod_regiao1 = " & cod_regiao_1opcao & ","
		else
			sql = sql & "cod_regiao1 = null,"
		end if
		if cod_regiao_2opcao <> "" then
			sql = sql & "cod_regiao2 = " & cod_regiao_2opcao & ","
		else
			sql = sql & "cod_regiao2 = null,"
		end if
		if cod_regiao_3opcao <> "" then
			sql = sql & "cod_regiao3 = " & cod_regiao_3opcao & ","
		else
			sql = sql & "cod_regiao3 = null,"
		end if
		if cod_empresa_1opcao <> "" then
			sql = sql & "cod_empresa_1opcao = " & cod_empresa_1opcao & ","
		else
			sql = sql & "cod_empresa_1opcao = null,"
		end if
		if cod_empresa_2opcao <> "" then
			sql = sql & "cod_empresa_2opcao = " & cod_empresa_2opcao & ","
		else
			sql = sql & "cod_empresa_2opcao = null,"
		end if
		if cod_empresa_3opcao <> "" then
			sql = sql & "cod_empresa_3opcao = " & cod_empresa_3opcao & ","
		else
			sql = sql & "cod_empresa_3opcao = null,"
		end if
		sql = sql & "usuario_altr = '" & trim(session("usuarioWeb")) & "',"
		sql = sql & "data_hora_altr = getdate() "
		sql = sql & " where codigo = " & intCodigo
		cnn.execute sql
		GravarLog sql		
	elseif acao="G" then
		
		strMensagem = "Pedido foi enviado para autorização com sucesso..."
		sql = "update SRH_PEDIDO_REMOCAO set situacao = 'G', usuario_altr = '" & trim(session("usuarioWeb")) & "', data_hora_altr = getdate() where codigo=" & codigo
		
		cnn.execute sql
		GravarLog sql
	elseif acao="F" then
		
		strMensagem = "Pedido foi atendido com sucesso..."
		sql = "update SRH_PEDIDO_REMOCAO set situacao = 'F', usuario_altr = '" & trim(session("usuarioWeb")) & "', data_hora_altr = getdate() where codigo=" & codigo
		
		cnn.execute sql
		GravarLog sql
	elseif acao="N" then
		
		strMensagem = "Pedido NÃO foi atendido..."
		sql = "update SRH_PEDIDO_REMOCAO set situacao = 'N', usuario_altr = '" & trim(session("usuarioWeb")) & "', data_hora_altr = getdate() where codigo=" & codigo
		
		cnn.execute sql
		GravarLog sql
		
	elseif acao="E" then
	
		strMensagem = "Pedido foi excluida com sucesso..."
		sql = "delete SRH_PEDIDO_REMOCAO where codigo=" & intCodigo
		
		cnn.execute sql
		GravarLog sql		
	end if 
	
	if err.number = 0 then
		'registro será atualizado/incluido com sucesso
		cnn.committrans
		if acao = "F" OR acao = "G" OR acao = "N" then
		%>
		<script>
			alert("<%=strMensagem%>");
			window.location='PedidoRemocao_con.asp?cmbSituacaoPedidoRemocao=<%=acao%>';
		</script>
		<%
		else
		%>
		<script>
			alert("<%=strMensagem%>");
			window.location='PedidoRemocao_con.asp?cmbSituacaoPedidoRemocao=A';
		</script>
		<%
		end if
	else
		'registro teve problema e não será atualizado
		cnn.rollbacktrans
		%>
		<script>
			alert("ATENÇÃO: \n\nNão foi possível executar esse procedimento, tente novamente.\nCaso persistir entre em contato com o administrador do sistema.");
			window.history.back();
		</script>
		<%
	end if
%>