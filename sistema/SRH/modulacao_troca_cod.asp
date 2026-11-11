<%
Response.AddHeader "Content-Type", "text/html; charset=utf-8"
Response.AddHeader "Pragma", "no-cache"
response.Charset="utf-8"
%>
<!--#include file="../../includes/inc_verificaSession.asp"-->
<!--#include file="../../includes/inc_cnn.asp"-->
<!--#include file="../../includes/inc_log.asp"-->
<!--#include file="../../includes/inc_formatadata.asp"-->
<%
	'on error resume next
	'----------Inicia uma tranzação--------------
	cnn.begintrans
	acao 									= Trim(Request.QueryString("acao"))

	strCodigoFuncionalAtual  				= Trim(Request.Form("txtCodigoFuncionalAtual"))
	strCodigoFuncionalDestino  				= Trim(Request.Form("txtCodigoFuncionalDestino"))
	
	strCodFuncionarioOrigem					= Trim(Request.Form("txtCodFuncionario"))
	strCodFuncionarioDestino  				= Trim(Request.Form("txtCodFuncionarioDestino"))
	strCodigoModulacaoOrigem  				= Trim(Request.Form("chkOrigem"))
	strCodigoModulacaoDestino  				= Trim(Request.Form("chkDestino"))
	strDataMovimentacaoFinal				= formataDataBD(Trim(Request.Form("txtDataMovimentacao")))
	strDataMovimentacaoInicial				= formataDataBD(DateAdd("d",1,strDataMovimentacaoFinal))
	chkPorPeriodoOrigem		  				= Trim(Request.Form("chkPorPeriodoOrigem"))
	chkPorPeriodoDestino	  				= Trim(Request.Form("chkPorPeriodoDestino"))

'response.write "<br>strCodigoFuncionalAtual:" & strCodigoFuncionalAtual
'response.write "<br>strCodigoFuncionalDestino:" & strCodigoFuncionalDestino
'response.write "<br>strCodColaboradorOrigem:" & strCodFuncionarioOrigem
'response.write "<br>strCodColaboradorDestino:" & strCodFuncionarioDestino
'response.write "<br>strCodigoModulacaoOrigem:" & strCodigoModulacaoOrigem
'response.write "<br>strCodigoModulacaoDestino:" & strCodigoModulacaoDestino
'response.write "<br>chkPorPeriodoOrigem:" & chkPorPeriodoOrigem
'response.write "<br>strDataMovimentacaoFinal:" & strDataMovimentacaoFinal
'response.write "<br>strDataMovimentacaoInicial:" & strDataMovimentacaoInicial
'response.write "<br><br>"
'response.end
	
	sql = "insert into SRH_MODULACAO_DISCIPLINAR_DOCENTE "
	sql = sql & " select "
	sql = sql & "  Ano_Letivo"
	sql = sql & " ,Semestre"
	sql = sql & " ," & strCodFuncionarioDestino
	sql = sql & " ,tipoModulacao"
	sql = sql & " ,Cod_empresa"
	sql = sql & " ,Cod_Curso"
	sql = sql & " ,Cod_periodo"
	sql = sql & " ,Cod_Turno"
	sql = sql & " ,Cod_Turno_Opcional"
	sql = sql & " ,Cod_Disciplina"
	sql = sql & " ,Cod_Funcao"
	sql = sql & " ,Total_Aulas"
	sql = sql & " ,Situacao_disciplinar"
	sql = sql & " ,Status"
	sql = sql & " ,Data_Ativacao"
	sql = sql & " ,Data_Inativacao"
	sql = sql & " ,Cod_Substituicao_Deficit"
	if chkPorPeriodoOrigem<>"" then
		sql = sql & " ,'" & strDataMovimentacaoInicial & "'"
		sql = sql & " ,periodo_final"
	else
		sql = sql & " ,periodo_inicial"
		sql = sql & " ,periodo_final"
	end if
	sql = sql & " ,'" & strDataMovimentacaoInicial & "'"
	sql = sql & " ,DataFinal"		
	if chkPorPeriodoOrigem<>"" then
		sql = sql & " ,'A'"
	else
		sql = sql & " ,'C'"
	end if
	sql = sql & " ,Cod_Substituicao"
	sql = sql & " ,Cod_Modulacao_Substituicao"
	sql = sql & " from SRH_MODULACAO_DISCIPLINAR_DOCENTE"
	sql = sql & " where codigo in (" & strCodigoModulacaoOrigem & ")"
'response.write sql & "<hr>"
	cnn.execute sql
	GravarLog sql

	'-----------------------------------------------------------
	'INATIVAR A MODUÇÃO DE ORIGEM SELECIONADA PARA O COLABORADOR
	'-----------------------------------------------------------
	sql = "update SRH_MODULACAO_DISCIPLINAR_DOCENTE set status='I', dataFinal = '" & strDataMovimentacaoFinal & "' where codigo in (" & strCodigoModulacaoOrigem & ")"
'response.write sql & "<hr>"
	cnn.execute sql
	GravarLog sql

	sql = "update SRH_MODULACAO_DISCIPLINAR_DOCENTE set status='I', dataFinal = '" & strDataMovimentacaoFinal & "', periodo_Final = '" & strDataMovimentacaoFinal & "' where tipo_contratacao = 'A' and codigo in (" & strCodigoModulacaoOrigem & ")"
'response.write sql & "<hr>"
	cnn.execute sql
	GravarLog sql

	if strCodigoModulacaoDestino<>"" then
	
		sql = "insert into SRH_MODULACAO_DISCIPLINAR_DOCENTE "
		sql = sql & " select "
		sql = sql & "  Ano_Letivo"
		sql = sql & " ,Semestre"
		sql = sql & " ," & strCodFuncionarioOrigem
		sql = sql & " ,tipoModulacao"
		sql = sql & " ,Cod_empresa"
		sql = sql & " ,Cod_Curso"
		sql = sql & " ,Cod_periodo"
		sql = sql & " ,Cod_Turno"
		sql = sql & " ,Cod_Turno_Opcional"
		sql = sql & " ,Cod_Disciplina"
		sql = sql & " ,Cod_Funcao"
		sql = sql & " ,Total_Aulas"
		sql = sql & " ,Situacao_disciplinar"
		sql = sql & " ,Status"
		sql = sql & " ,Data_Ativacao"
		sql = sql & " ,Data_Inativacao"
		sql = sql & " ,Cod_Substituicao_Deficit"
		if chkPorPeriodoDestino<>"" then
			sql = sql & " ,'" & strDataMovimentacaoInicial & "'"
			sql = sql & " ,periodo_final"
		else
			sql = sql & " ,periodo_inicial"
			sql = sql & " ,periodo_final"
		end if
		sql = sql & " ,'" & strDataMovimentacaoInicial & "'"
		sql = sql & " ,DataFinal"		
		if chkPorPeriodoDestino<>"" then
			sql = sql & " ,'A'"
		else
			sql = sql & " ,'C'"
		end if
		sql = sql & " ,Cod_Substituicao"
		sql = sql & " ,Cod_Modulacao_Substituicao"
		sql = sql & " from SRH_MODULACAO_DISCIPLINAR_DOCENTE"
		sql = sql & " where codigo in (" & strCodigoModulacaoDestino & ")"
'response.write sql & "<hr>"
		cnn.execute sql
		GravarLog sql	
		
		'-----------------------------------------------------------
		'INATIVAR A MODUÇÃO DE ORIGEM SELECIONADA PARA O COLABORADOR
		'-----------------------------------------------------------
		sql = "update SRH_MODULACAO_DISCIPLINAR_DOCENTE set status='I', dataFinal = '" & strDataMovimentacaoFinal & "' where codigo in (" & strCodigoModulacaoDestino & ")"
		cnn.execute sql
		GravarLog sql
	
		sql = "update SRH_MODULACAO_DISCIPLINAR_DOCENTE set status='I', dataFinal = '" & strDataMovimentacaoFinal & "', periodo_Final = '" & strDataMovimentacaoFinal & "' where tipo_contratacao = 'A' and codigo in (" & strCodigoModulacaoDestino & ")"
		cnn.execute sql
		GravarLog sql
	
	end if
	
	codigo_troca_moducacao = 1
	sql = "select max(codigo_troca_moducacao) as codigo_troca_moducacao from SRH_TROCA_MODULACAO_HISTORICO"
	rs.open sql, cnn
	if not rs.eof then
		if rs("codigo_troca_moducacao") <> "" and not isnull(rs("codigo_troca_moducacao")) then
			codigo_troca_moducacao = rs("codigo_troca_moducacao")+1
		end if
	end if
	rs.close

	sql = "Insert Into SRH_TROCA_MODULACAO_HISTORICO (codigo_troca_moducacao, cod_colaborador_origem, codigo_modulacao_disciplinar_docente_origem, cod_colaborador_destino, codigo_modulacao_disciplinar_docente_destino, data_movimentacao, PorPeriodoOrigem, PorPeriodoDestino, usuario_incl, data_hora_incl) "
	sql = sql & " Values ("
	sql = sql & "" & codigo_troca_moducacao & ","
	sql = sql & "" & strCodFuncionarioOrigem & ","
	sql = sql & "'" & strCodigoModulacaoOrigem & "',"
	sql = sql & "" & strCodFuncionarioDestino & ","
	sql = sql & "'" & strCodigoModulacaoDestino & "',"
	sql = sql & "'" & strDataMovimentacaoFinal & "',"
	sql = sql & "'" & chkPorPeriodoOrigem & "',"
	sql = sql & "'" & chkPorPeriodoDestino & "',"
	sql = sql & "'" & trim(session("usuarioWeb")) & "',"
	sql = sql & "getdate())"
	cnn.execute sql
	GravarLog sql

	strMensagem = "Troca da Modulação efetuada com sucesso!"
	
	if err.number = 0 then
	'----------Finaliza tranzação iniciada--------------
		cnn.commitTrans
		%>
		<script>
			alert("<%=strMensagem%>");
			window.location="modulacao_troca_cad.asp";
		</script>
		<%
		response.end
	else
		cnn.rollbackTrans
		%>
		<script>
			alert("ATENÇÃO: \n\nNão foi possível executar esse procedimento, tente novamente.\nCaso persistir entre em contato com o administrador do sistema.");
			window.location="modulacao_troca_cad.asp";
		</script>
		<%
	end if
%>