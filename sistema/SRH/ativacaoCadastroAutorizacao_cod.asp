	<!--#include file="../../includes/inc_verificaSession.asp"-->
	<!--#include file="../../includes/inc_cnn.asp"-->
	<!--#include file="../../includes/inc_replaceRequest.asp"-->
	<!--#include file="../../includes/inc_formatadata.asp"-->
	<!--#include file="../../includes/inc_log.asp"-->
	<%
	acao			 	= Trim(Trim(Request("acao")))
	codigo	 			= Trim(Trim(Request("codigo")))

	intCodigo	 		= Trim(Trim(Request("txtCodigo")))
	
	strAnoletivo = Trim(Request("txtAnoLetivo"))
	if strAnoletivo = "" then strAnoletivo = year(date)
	
	
	'on error resume next
	cnn.begintrans
	
	if acao="F" then
		
		strMensagem = "Pedido foi atendido com sucesso..."
		sql = "update SRH_ATIVACAO_CADASTRO set situacao = 'F', usuario_autorizacao = '" & trim(session("usuarioWeb")) & "',data_hora_autorizacao = getdate() where codigo=" & intCodigo
		cnn.execute sql
		GravarLog sql
		
		sql = "select cod_colaborador, cod_empresa from SRH_ATIVACAO_CADASTRO where codigo=" & intCodigo
		rs.open sql, cnn
		if not rs.eof then
			cod_colaborador = rs("cod_colaborador")
			cod_empresa = rs("cod_empresa")
		end if
		rs.close
		
		strMensagem = "Pedido foi atendido com sucesso..."
		sql = "update SRH_COLABORADOR set situacao = 'A', Datafastamento=null where codigo=" & cod_colaborador
		cnn.execute sql
		GravarLog sql
		
		sql = " Insert into SRH_COLABORADOR_OCORRENCIA (cod_Empresa, cod_colaborador, ocorrencia, usuario_incl, data_incl)" 
		sql = sql & " VALUES("
		sql = sql & "" & cod_empresa & "," 
		sql = sql & "" & cod_colaborador & "," 
		sql = sql & "'Cadastro do colaborador foi ativado',"
		sql = sql & "'" & Session("UsuarioWeb") & "',getdate())"
		cnn.execute sql
		GravarLog sql
		
		sql = " Insert into SRH_OCORRENCIA (COD_EMPRESA,COD_COLABORADOR,ANO_LETIVO,SEMESTRE,OCORRENCIA,USUARIO_INCL,DATAOCORRENCIA,SITUACAO_ANTERIOR,SITUACAO_ATUAL)" 
		sql = sql & " VALUES("
		sql = sql & "" & cod_empresa & "," 
		sql = sql & "" & cod_colaborador & "," 
		sql = sql & "" & strAnoletivo & ",3," 
		sql = sql & "'Cadastro do colaborador foi ativado',"
		sql = sql & "'" & Session("UsuarioWeb") & "',getdate(),'I','A')"
		cnn.execute sql
		GravarLog sql
		
		
	elseif acao="N" then
		
		strMensagem = "Pedido NAO foi atendido..."
		sql = "update SRH_ATIVACAO_CADASTRO set situacao = 'N', usuario_autorizacao = '" & trim(session("usuarioWeb")) & "', data_hora_autorizacao = getdate() where codigo=" & intCodigo
		
		cnn.execute sql
		GravarLog sql
		
	end if 
	
	if err.number = 0 then
		'registro serÃ¡ atualizado/incluido com sucesso
		cnn.committrans
		
		%>
		<script>
			alert("<%=strMensagem%>");
			window.location='PedidoAutorizacao_con.asp?cmbTipo=A&cmbSituacaoPedidoRemocao=G';
		</script>
		<%
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