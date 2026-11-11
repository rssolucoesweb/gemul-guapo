<!--
	::	Data de Criação...: 21/02/2008
	::	Desenvolvedores...: Sergio Borges - sergiob76@hotmail.com
	::	Objetivo Pagina...: pagamento de parcela - baixa de debitos
-->
<!--#include file="../../includes/inc_verificaSession.asp"-->
<!--#include file="../../includes/inc_cnn.asp"-->
<!--#include file="../../includes/inc_formataData.asp"-->
<!--#include file="../../includes/inc_log.asp"-->
<%
	'on error resume next
	'----------Inicia uma tranzação--------------
	cnn.begintrans
	
	strAcao	 				= Trim(Request("acao"))
	strUsuario				= trim(session("usuarioWeb"))
	intCodAluno	 			= Trim(Request("codAluno"))
	strProtocolo 			= Trim(Request("CodProtocolo"))
	strDataEntrega			= formatadataBD(date) & " " & time
	strObs 					= replace(request.form("txtObs"),"'","")
		
	'Localizando o codigo do débito para verificação das regras
	codBebitoAluno = ""
	sql = "select cod_debitoaluno from SCF_PROTOCOLO "
	sql = sql & " where codigo = " & strProtocolo
	sql = sql & " and cod_empresa = " & Session("CodEmpresa")
	rs.open sql, cnn
	if rs.eof = false then
	   codBebitoAluno = Trim(rs("cod_debitoaluno"))
	else
	   cnn.rollbacktrans
	   %>
	   <script>
		  alert("ATENÇÃO:\Não existe Taxa Gerada para esse protocólo. Verifique!");
		  window.close();
	   </script>
	   <%
	   response.End()
	end if
	rs.close	

	strSituacao			= "B" 'Pago
		
	if strAcao = "A" then
	   ' Verificando se o protocolo está em aberto
	   cod_situacao_pagamento = ""
	   sql = "select cod_situacao_pagamento from SCF_DEBITOALUNO"
	   sql = sql & " where codigo = " & codBebitoAluno
	   sql = sql & " and cod_empresa = " & Session("CodEmpresa")
	   rs.open sql, cnn
	   if rs.eof = false then
		  cod_situacao_pagamento = Trim(rs("cod_situacao_pagamento"))
	   end if
	   rs.close	
	   IF trim(cod_situacao_pagamento) = "1"  THEN 
		  cnn.rollbacktrans
		  %>
		  <script>
			 alert("ATENÇÃO:\Esse protocólo ainda não foi Pago. Verifique!");
			 window.close();
		   </script>
		   <%
		   response.End()
		end if
	
		strMensagem 		= "Protocolo baixando com sucesso..."
		sql = "Update SCF_PROTOCOLO Set"
		sql = sql & " Obs = '" & strObs & "',"
		sql = sql & " DataEntrega = '" & strDataEntrega & "',"
		sql = sql & " Usuario_baixa = '" & strUsuario & "',"
		sql = sql & " Situacao = '" & strSituacao & "'"
		sql = sql & " Where Codigo = " & strProtocolo
		strMsnOcorrencia = "Protocolo número: " & strProtocolo & " baixado."
		
	elseif strAcao = "E" then
		strMensagem 		= "Protocolo estornado com sucesso..."
		sql = "Update SCF_PROTOCOLO Set"
		sql = sql & " Obs = null,"
		sql = sql & " DataEntrega = null,"
		sql = sql & " Usuario_baixa = '" & strUsuario & "',"
		sql = sql & " Situacao = 'A'"
		sql = sql & " Where Codigo = " & strProtocolo

		strMsnOcorrencia = "Protocolo número: " & strProtocolo & " estornado."
	elseif strAcao = "EX" then
	   ' Verificando se o protocolo está em aberto
	   cod_situacao_pagamento = ""
	   sql = "select cod_situacao_pagamento from SCF_DEBITOALUNO"
	   sql = sql & " where codigo = " & codBebitoAluno
	   sql = sql & " and cod_empresa = " & Session("CodEmpresa")
	   rs.open sql, cnn
	   if rs.eof = false then
		  cod_situacao_pagamento = Trim(rs("cod_situacao_pagamento"))
	   end if
	   rs.close	
	   IF trim(cod_situacao_pagamento) <> ""  THEN 
		  cnn.rollbacktrans
			%>
			<script>
				alert("ATENÇÃO:\Existe Taxa Gerada para esse protocólo, impossível excluir. Verifique!");
				window.close();
			</script>
			<%
			response.End()
		end if

		strMensagem 		= "Protocolo excluído com sucesso..."

		sql = "DELETE SCF_PROTOCOLO "
		sql = sql & " Where Codigo = " & strProtocolo

		strMsnOcorrencia = "Protocolo número: " & strProtocolo & " excluído."
	end if
	cnn.execute sql
	GravarLog sql		

	'Gera Ocorrencia Automatica do tipo Protesto
	'parametros:
	'	intCodEmp
	'	intCodDepartamento
	'	intCodAluno
	'	intCodTaxa
	'	intCodBebitoAluno
	'	strDataOcorrencia
	'	strDataValidade
	'	strOcorrencia
	'	strUsuarioIncl

	intCodEmp			= session("codEmpresa")
	intCodDepartamento	= Session("CodDeptoUsuario")
	intCodAluno			= intCodAluno
	intCodTaxa			= ""
	intCodBebitoAluno	= ""
	strDataOcorrencia	= formatadataBD(date)
	strUsuarioIncl		= trim(session("usuarioWeb"))
	strDataValidade		= ""
	strOcorrencia		= strMsnOcorrencia
	%>
	<!--#include file="../includes/inc_lancamentoDeOcorrencia.asp"-->	
	<%		
	
	if err.number = 0 then
	'----------Finaliza tranzação iniciada--------------
		cnn.commitTrans
		%>
		<script>
			alert("<%=strMensagem%>");
			window.opener.frm.submit();
			window.close();	
		</script>
		<%
		response.end
	else
		cnn.rollbacktrans
		response.redirect "erro.asp?strNumErro=" & err.number & "&strDescErro=" & err.description 
	end if
%>