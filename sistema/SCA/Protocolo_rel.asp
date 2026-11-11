<%
response.Expires=0
'Não armazena a página em buffer antes de mostra-la na tela'
response.Buffer = false
%>
<!--
	::	DESENVOLVIDO POR "RS SOLUÇÕES WEB - www.rssolucoesweb.com.br"
	::	Data de Criação...: 26/08/2008
	::	Desenvolvedores...: Roberto Barbosa Silva - robertobs7@gmail.com
	::	Objetivo Pagina...: Emissao de Protocolo
-->
<html>
<head>
<title>Emissão do Protocolo</title>
<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1">
<link type="text/css" rel="stylesheet" href="../../Estilo/Estilo_Impressao.css">
<script src="../../js/js_funcoes_gerais.js"></script>
<script src="../../js/js_barra_movel.js"></script>
</head>
<body>
<!--#include file="../../includes/inc_verificaSession.asp"-->
<!--#include file="../../includes/inc_cnn.asp"-->
<!--#include file="../../includes/inc_formatadata.asp"-->
<!--#include file="../../includes/inc_Botoes_relatorio.asp"-->
<!--#include file="../../includes/inc_log.asp"-->
<br>
<%
	dim intPagina
	
	strTituloRelatorio  	= "Protocolo Nº. "  & Trim(Request("codProtocolo"))
	intCodEmpresa 			= Session("CodEmpresa")
	intCodProtocolo			= Trim(Request("codProtocolo"))
	strMatricula			= Trim(Request.Form("txtMatricula"))
	intCodAluno				= Trim(Request.Form("txtCodAluno"))

    %>
	<!--#include file="../../includes/inc_cabecalhoRelatorio.asp"-->
	<!--#include file="../includes/inc_sqlDadosAlunoDiscriminado.asp"-->
	<%
	
		intNumViaEmitidas		= 1
	
		if trim(intCodAluno	) <> "" then
		   'Localizando o codigo do débito para verificação das regras
		   codBebitoAluno = ""
		   sql = "select cod_debitoaluno from SCF_PROTOCOLO "
		   sql = sql & " where codigo = " & intCodProtocolo
		   sql = sql & " and cod_empresa = " & Session("CodEmpresa")
		   rs.open sql, cnn
		   if rs.eof = false then
		      codBebitoAluno = Trim(rs("cod_debitoaluno"))
		   else
		      %>
		      <script>
  		 	    alert("ATENÇÃO:\Não existe Taxa Gerada para esse protocólo. Verifique!");
				window.history.back();
			  </script>
			  <%
			  response.End()
		   end if
		   rs.close	

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
			  %>
			  <script>
				 alert("ATENÇÃO:\Esse protocólo ainda não foi Pago. Verifique!");
				 window.history.back();
			   </script>
			   <%
			   response.End()
			end if
		
			sql = "SELECT P.CODIGO, "
			sql = sql & " P.DATASOLICITACAO, P.COD_ALUNO, A.NOMEALUNO, A.MATRICULA, T.DESCRICAO AS TAXA, P.DATAVENCIMENTO, "
			sql = sql & " P.DATASOLICITACAO, P.DATAENTREGA, P.SITUACAO, P.COD_DISCIPLINA, P.SITUACAO, DI.DESC_DISCIPLINA, "
			sql = sql & " P.NumeroVias, D.VALORTOTALPAGO, D.DATAPAGAMENTO "
			
			sql = sql & " FROM SCF_PROTOCOLO P"
			sql = sql & " LEFT JOIN SCA_ALUNO A	ON P.COD_ALUNO = A.CODIGO AND P.COD_EMPRESA = A.COD_EMPRESA"
			sql = sql & " LEFT JOIN SCF_TAXA T	ON P.COD_TAXA = T.COD_TAXA AND P.COD_EMPRESA = T.COD_EMPRESA"
			sql = sql & " LEFT JOIN SCA_DISCIPLINA DI ON P.COD_EMPRESA = DI.COD_EMPRESA AND P.COD_DISCIPLINA = DI.COD_DISCIPLINA "
			sql = sql & " LEFT JOIN SCF_DEBITOALUNO D ON D.CODIGO = P.COD_DEBITOALUNO " 
			sql = sql & " WHERE	A.COD_EMPRESA	= " & intCodEmpresa
			sql = sql & " AND P.COD_ALUNO = " & intCodAluno	
			sql = sql & " AND P.CODIGO = " & intCodProtocolo
			sql = sql & " ORDER BY P.DATASOLICITACAO"
			rs.open sql, cnn
			if rs.eof = false then
				strTaxa 			= triM(rs("TAXA"))
				strDescDisciplina  	= trim(rs("DESC_DISCIPLINA"))
				strDataSolicitacao 	= formatadataAP(rs("DATASOLICITACAO"))
				strDataEntrega		= formatadataAP(date)
				strDataVencimento	= formatadataAP(rs("DATAVENCIMENTO"))
				if not isnull(rs("VALORTOTALPAGO")) then
					strValor = rs("VALORTOTALPAGO")
				else
					strValor = 0
				end if	
				strValor = formatnumber(strValor,2)
				strDataPagamento	= formatadataAP(rs("DATAPAGAMENTO"))
				intNumeroVias		= rs("NumeroVias") + 1
				
				sql = "Update SCF_Protocolo Set"
				sql = sql & " DataEntrega = '" & formatadataBD(strDataEntrega)  & " " & time & "',"
				sql = sql & " NumeroVias = " & intNumeroVias & ""
				sql = sql & " WHERE	COD_EMPRESA	= " & intCodEmpresa
				sql = sql & " AND CODIGO = " & intCodProtocolo
				cnn.execute sql
				GravarLog sql

			end if
			rs.close
			
		end if
		%>
		<hr size= "1">
		<table width="100%" border="0">
		<tr valign="top">
		  <td height="54" align="center"><table width="88%" border="0">
            <tr>
              <td width="17%" class="textoRelatorio"><strong>Requerimento: </strong></td>
              <td width="83%" class="textoRelatorio"><%=strTaxa%>&nbsp;-&nbsp;Valor Pago:&nbsp;<%=strValor%>&nbsp;-&nbsp;Data do Pagamento:&nbsp;<%=strDataPagamento%> </td>
            </tr>
			<%if strDescDisciplina <> "" then%>
            <tr>
              <td class="textoRelatorio"><strong>Disciplina:</strong></td>
              <td class="textoRelatorio"><%=strDescDisciplina%>&nbsp;</td>
            </tr>
			<%end if%>
          </table></td>
		  </tr>
		<tr valign="top">
		<td align="center">
		<table width="88%" border="0">
          <tr>
            <td height="22" colspan="2" class="textoRelatorio"><strong>* Solicita&ccedil;&atilde;o do Requerimento: (Justificativas e documenta&ccedil;&atilde;o obrigat&oacute;ria ) </strong></td>
          </tr>
          <tr>
            <td height="28" colspan="2" align="center" class="textoRelatorio">______________________________________________________________________________________________</td>
          </tr>
          <tr>
            <td height="28" colspan="2" align="center" class="textoRelatorio">______________________________________________________________________________________________</td>
          </tr>
          <tr>
            <td height="32" colspan="2" align="center" class="textoRelatorio">______________________________________________________________________________________________</td>
          </tr>
          <tr>
            <td height="31" colspan="2" align="center" class="textoRelatorio">______________________________________________________________________________________________</td>
          </tr>
          <tr>
            <td height="28" colspan="2" align="center" class="textoRelatorio">______________________________________________________________________________________________</td>
          </tr>
          <tr>
            <td height="28" colspan="2" align="center" class="textoRelatorio">______________________________________________________________________________________________</td>
          </tr>
          <tr>
            <td height="28" colspan="2" align="center" class="textoRelatorio">______________________________________________________________________________________________</td>
          </tr>
          <tr>
            <td height="28" colspan="2" align="center" class="textoRelatorio">______________________________________________________________________________________________</td>
          </tr>


          <tr>
            <td height="28" align="center" class="textoRelatorio">__________________________________</td>
            <td align="center" class="textoRelatorio">_______________________________</td>
          </tr>
          <tr>
            <td width="47%" height="19" align="center" class="textoRelatorio">Funcion&aacute;rio</td>
            <td width="53%" align="center" class="textoRelatorio">Requerente</td>
          </tr>
          <tr>
            <td height="23" colspan="2" align="center" class="textoRelatorio">------------------------------------------------------------------------------------------------------------------------</td>
          </tr>
          <tr>
            <td height="19" colspan="2" class="textoRelatorio"><strong>* Parecer: </strong></td>
          </tr>
          <tr>
            <td height="28" colspan="2" align="center" class="textoRelatorio">______________________________________________________________________________________________</td>
          </tr>
          <tr>
            <td height="34" colspan="2" align="center" class="textoRelatorio">______________________________________________________________________________________________</td>
          </tr>
          <tr>
            <td height="32" colspan="2" align="center" class="textoRelatorio">______________________________________________________________________________________________</td>
          </tr>
          <tr>
            <td height="32" colspan="2" align="center" class="textoRelatorio">______________________________________________________________________________________________</td>
          </tr>
          <tr>
            <td height="32" colspan="2" align="center" class="textoRelatorio">______________________________________________________________________________________________</td>
          </tr>
          <tr>
            <td height="32" colspan="2" align="center" class="textoRelatorio">______________________________________________________________________________________________</td>
          </tr>
          <tr>
            <td height="32" colspan="2" align="center" class="textoRelatorio">______________________________________________________________________________________________</td>
          </tr>
          <tr>
            <td height="28" colspan="2" align="center" class="textoRelatorio">______________________________________________________________________________________________</td>
          </tr>
          
          <tr>
            <td height="19" align="center" class="textoRelatorio">&nbsp;</td>
            <td height="19" align="center" class="textoRelatorio">_______________________________</td>
          </tr>
          <tr>
            <td height="19" align="center" class="textoRelatorio">&nbsp;</td>
            <td height="19" align="center" class="textoRelatorio">Respons&aacute;vel pelo Parecer</td>
          </tr>
          <tr>
            <td height="19" colspan="2" align="center" class="textoRelatorio">&nbsp;</td>
          </tr>
        </table></td>
	  </tr>
		<tr valign="top">
		  <td align="center">
		  <table width="88%" border="0">
            <tr>
              <td width="28%" class="textoRelatorio"><strong>Data da Solicita&ccedil;&atilde;o: </strong></td>
              <td width="72%" class="textoRelatorio"><%=strDataSolicitacao%>&nbsp;</td>
            </tr>
            <tr>
              <td class="textoRelatorio"><strong>Data da Entrega Secretaria: </strong></td>
              <td class="textoRelatorio"><%=strDataEntrega%>&nbsp;</td>
            </tr>
            <tr>
              <td class="textoRelatorio"><strong>Data do Vencimento do Processo: </strong></td>
              <td class="textoRelatorio"><%=strDataVencimento%>&nbsp;</td>
            </tr>
            <tr>
              <td class="textoRelatorio"><strong>N&uacute;mero Vias Emitidas: </strong></td>
              <td class="textoRelatorio"><%=intNumeroVias%>&nbsp;</td>
            </tr>
            <tr>
              <td height="19" colspan="2" class="textoRelatorio">&nbsp;</td>
            </tr>
          </table></td>
		  </tr>
	  </table>
	  </td>
	  </tr>
	</table>
</body>
</html>