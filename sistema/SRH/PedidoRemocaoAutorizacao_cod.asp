	<!--#include file="../../includes/inc_verificaSession.asp"-->
	<!--#include file="../../includes/inc_cnn.asp"-->
	<!--#include file="../../includes/inc_replaceRequest.asp"-->
	<!--#include file="../../includes/inc_formatadata.asp"-->
	<!--#include file="../../includes/inc_log.asp"-->
	<%
	acao			 	= Trim(Trim(Request("acao")))
	codigo	 			= Trim(Trim(Request("codigo")))

	intCodigo	 		= Trim(Trim(Request("txtCodigo")))
	
	intCodTurnoEscolhido	= Trim(Trim(Request.Form("cmbTurnoRH")))
	intCodEmpresaEscolhida	= Trim(Trim(Request.Form("cmbUnidadeEscolhida")))
	
	strAnoletivo = Trim(Request("txtAnoLetivo"))
	if strAnoletivo = "" then strAnoletivo = year(date)
	
	
	'on error resume next
	cnn.begintrans
	
	if acao ="G" then
		
		strMensagem = "Pedido foi enviado para autorizacao com sucesso..."

		sql = "update SRH_PEDIDO_REMOCAO set "
		sql = sql & " cod_empresa_escolhida = " & intCodEmpresaEscolhida & ","
		sql = sql & " cod_turno_escolhido = '" & intCodTurnoEscolhido & "',"
		sql = sql & " situacao = 'G',"
		sql = sql & " usuario_altr = '" & trim(session("usuarioWeb")) & "',"
		sql = sql & " data_hora_altr = getdate() "
		sql = sql & " where codigo = " & intCodigo
		cnn.execute sql
		GravarLog sql		
	elseif acao="F" then
		
		strMensagem = "Pedido foi atendido com sucesso..."
		sql = "update SRH_PEDIDO_REMOCAO set situacao = 'F', usuario_autorizacao = '" & trim(session("usuarioWeb")) & "',data_hora_autorizacao = getdate(), usuario_altr = '" & trim(session("usuarioWeb")) & "', data_hora_altr = getdate() where codigo=" & intCodigo
		cnn.execute sql
		GravarLog sql
		
		sql = "select cod_empresa as cod_empresa_anterior, cod_motivo_remocao, observacao, cod_empresa_escolhida, cod_turno_escolhido, cod_colaborador from SRH_PEDIDO_REMOCAO where codigo=" & intCodigo
		rs.open sql, cnn
		if not rs.eof then
			cod_empresa_escolhida = rs("cod_empresa_escolhida")
			cod_turno_escolhido = rs("cod_turno_escolhido")
			cod_colaborador = rs("cod_colaborador")
			cod_empresa_anterior = rs("cod_empresa_anterior")
			cod_motivo_remocao = rs("cod_motivo_remocao")
			observacao = rs("observacao")
		end if
		rs.close
		
		sql = "select codigo_SEG_USUARIOS_SISTEMA from SRH_COLABORADOR where codigo=" & cod_colaborador
		rs.open sql, cnn
		if not rs.eof then
			strUsuarioPortal = rs("codigo_SEG_USUARIOS_SISTEMA")
		end if
		rs.close
		
		strMensagem = "Pedido foi atendido com sucesso..."
		sql = "update SRH_COLABORADOR set codlotacao = " & cod_empresa_escolhida & ", codturno = " & cod_turno_escolhido & " where codigo=" & cod_colaborador
		cnn.execute sql
		GravarLog sql
		
		sql = " insert into SRH_LOTACAOHISTORICO (COD_COLABORADOR, COD_LOTACAO, DATA_ALTERACAO, DataLotacao, USUA_CODG)"
		sql = sql & " VALUES (" & cod_colaborador & "," & cod_empresa_anterior & ", getdate(),'" & formatadataBD(date) & "','" & Session("UsuarioWeb") & "' )"
		cnn.execute sql
		GravarLog sql
		
		sql = " insert into SRH_COLABORADOR_MOTIVO_LOTACAO (COD_COLABORADOR, codigo_motivo, OBSERVACAO, cod_lotacao_atual, cod_lotacao_nova, usuario_incl, data_hora_incl)"
		sql = sql & " VALUES (" & cod_colaborador & "," & cod_motivo_remocao & ",'" & observacao & "'," & cod_empresa_anterior & "," & cod_empresa_escolhida & ",'" & Session("UsuarioWeb") & "',getdate())"
		cnn.execute sql
		GravarLog sql
		
		sql = "Update SEG_USUARIOS_SISTEMA"
		sql = sql & " set cod_empresa = " & cod_empresa_escolhida
		sql = sql & " where Usua_codg = '" & strUsuarioPortal & "'"
		cnn.execute sql
		GravarLog sql
		
		sql = "SELECT COD_EMPRESA FROM SEG_USUARIOS_EMPRESA " 
		sql = sql & " where CODIGO_SEG_USUARIOS_SISTEMA = '"& strUsuarioPortal & "'"
		sql = sql & " AND COD_EMPRESA = " & cod_empresa_escolhida
		rs.open sql,cnn
		if rs.eof = false then
		   JaExiste = True
		else
		   JaExiste = False
		end if		
		rs.close
		
		if JaExiste = False then
		
			sql = "delete SEG_USUARIOS_EMPRESA "
			sql = sql & " where CODIGO_SEG_USUARIOS_SISTEMA = '"& strUsuarioPortal & "'"
			sql = sql & " And COD_EMPRESA = " & cod_empresa_anterior 
			cnn.execute sql
			GravarLog sql

			sql = " insert into SEG_USUARIOS_EMPRESA (CODIGO_SEG_USUARIOS_SISTEMA, COD_EMPRESA )"
			sql = sql & " VALUES ('" & strUsuarioPortal & "' , '" & cod_empresa_escolhida & "')"
			cnn.execute sql
			GravarLog sql
		end if
	elseif acao="N" then
		
		strMensagem = "Pedido NAO foi atendido..."
		sql = "update SRH_PEDIDO_REMOCAO set situacao = 'N', usuario_altr = '" & trim(session("usuarioWeb")) & "', data_hora_altr = getdate() where codigo=" & intCodigo
		
		cnn.execute sql
		GravarLog sql
		
	end if 
	
	if err.number = 0 then
		'registro serÃ¡ atualizado/incluido com sucesso
		cnn.committrans
		if acao = "G" then
		%>
		<script>
			alert("<%=strMensagem%>");
			window.location='PedidoRemocao_con.asp';
		</script>
		<%
		elseif acao = "F" or acao = "N" then
		%>
		<script>
			alert("<%=strMensagem%>");
			window.location='PedidoAutorizacao_con.asp?cmbSituacaoPedidoRemocao=G';
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
		'registro teve problema e nÃ£o serÃ¡ atualizado
		cnn.rollbacktrans
		%>
		<script>
			alert("ATENÃ‡ÃƒO: \n\nNÃ£o foi possÃ­vel executar esse procedimento, tente novamente.\nCaso persistir entre em contato com o administrador do sistema.");
			window.history.back();
		</script>
		<%
	end if
%>