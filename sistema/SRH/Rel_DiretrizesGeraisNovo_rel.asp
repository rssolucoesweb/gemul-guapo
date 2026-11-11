<%
response.Expires=0
'Não armazena a página em buffer antes de mostra-la na tela'
response.Buffer = false
%>
<!--
	::	DESENVOLVIDO POR "RS SOLUÇÕES WEB - www.rssolucoesweb.com.br"
	::	Data de Criação...: 26/09/2011
	::	Desenvolvedores...: Roberto Barbosa Silva - roberto@rssolucoesweb.com.br
	::	Objetivo Pagina...: Relatório de Diretrizes
-->
<html>
<head>
<title><%=session("Titulo")%> - Grade Curricular</title>
<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1">
<link type="text/css" rel="stylesheet" href="../../Estilo/Estilo_Impressao.css">
<script src="../../js/js_funcoes_gerais.js"></script>
<script src="../../js/js_barra_movel.js"></script></head>
<body>
<!--#include file="../../includes/inc_verificaSession.asp"-->
<!--#include file="../../includes/inc_cnn.asp"-->
<!--#include file="../../includes/inc_formatadata.asp"-->
<!--#include file="../../includes/inc_Botoes_relatorio.asp"-->
<!--#include file="../../includes/inc_aguarde.asp"-->
<br>
<%
	dim intPagina
	
	intCodEmpresa			= session("codEmpresa")
	intCodEmpresaUsuario    = TRIM(Request.Form("cmdEmpresaUsuario"))
	intCodFuncao 			= Trim(Request.Form("cmbFuncao"))
	strSituacao 			= Trim(Request.Form("cmbSituacao"))
	strTipoModulacao 		= Trim(Request.Form("cmbTipoModulacao"))
	strAno	 				= Trim(Request("txtAno"))
	intCodCurso 			= Trim(Request.Form("cmbCurso"))
	strDefiste 				= Trim(Request.Form("chkDefiste"))
	
	if Trim(Request("cmbSemestre")) <> "0" then
		intSemestre 		= Trim(Request("cmbSemestre"))
	else	
		intSemestre 		=  Session("strSemestre")
	end if	
	if intSemestre = "3" then
	   strMsgSemestre = "Anual"
	else
	   strMsgSemestre = intSemestre
	end if   
	   
	if strAno = "" then strAno = session("strAnoLetivo")
	if intSemestre = "" then intSemestre = Session("strSemestre")
	
	strEmpresaSelecionada = ""
	sql = "select RAZAOSOCIAL"
	sql = sql & " from seg_empresa"
	sql = sql & " where codigo = " &  intCodEmpresaUsuario
	sql = sql & " order by RAZAOSOCIAL "
	rs.open sql, cnn
	if not rs.eof then
		strEmpresaSelecionada = rs("RAZAOSOCIAL")
	end if
	rs.close
	strTituloRelatorio = "DIRETRIZ GERAIS<BR> QUANTIDADE DE AULAS"
	sub mostraCabecalho()
	%>
	<!--#include file="../../includes/inc_cabecalhoRelatorio.asp"-->
	<br>
	<table width="98%" border="0" cellspacing="0" cellpadding="0" class="tabela" align="center">
	  <tr>
	    <td height="36" colspan="11" align="center" class="celula"><strong><font size="3"><%=strEmpresaSelecionada%></font></strong></td>
      </tr>
    <tr height="28">
	    <td align="center" class="celula" colspan="11" bgcolor="#F0F0F0"><strong><font size="+1">PROFESSORES</font></strong></td>
    </tr>
	  <tr bgcolor="#CCCCCC">
	    <td width="15%" class="celula"><div align="center"><strong>Curso</strong></div></td>
	    <td width="5%" class="celula"><div align="center"><strong>Per&iacute;odo</strong></div></td>
	    <td width="10%" height="49" align="center" class="celula"><strong>Turno</strong></td>
	    <td width="10%" height="49" class="celula"><div align="center"><strong>Disciplina</strong></div></td>
	    <td width="4%" height="49" align="center" class="celula"><strong>Qtde. de Turmas</strong></td>
	    <td width="8%" height="49" align="center" class="celula"><strong>Vagas<br>(Necess&aacute;ria)</strong></td>
        <td width="8%" height="49" class="celula"><div align="center"><strong>Aulas<br>(Necess&aacute;ria) </strong></div></td>
        <!--td width="8%" height="49" align="center" class="celula"><strong>Vagas<br>(Informada-SME)</strong></td>
	    <td width="8%" height="49" class="celula"><div align="center"><strong>Aulas<br>(Informada-SME)</strong></div></td-->
	    <td width="8%" class="celula"><div align="center"><strong>Vagas Moduladas <br>(Informada-SME)</strong></div></td>
	    <td width="12%" class="celula"><div align="center"><strong>Aulas Moduladas <br>(Informada-SME)</strong></div></td>
        <td width="10%" class="celula"><div align="center"><strong>Por Período <br>(Informada-SME)</strong></div></td>
	    <td width="10%" class="celula"><div align="center"><strong>Saldo</strong></div></td>
      </tr>
	  
	<%
	end Sub
	sub mostraCabecalhoFunc()
	%>
	<!--#include file="../../includes/inc_cabecalhoRelatorio.asp"-->
	<br>
	<table width="98%" border="0" cellspacing="0" cellpadding="0" class="tabela" align="center">
	  <tr>
	    <td height="36" colspan="9" align="center" class="celula"><strong><font size="3"><%=strEmpresaSelecionada%></font></strong></td>
      </tr>
		 <tr height="28">
            <td align="center" class="celula" colspan="9" bgcolor="#F0F0F0"><strong><font size="+1">FUNCIONÁRIOS</font></strong></td>
        </tr>
	  <tr bgcolor="#c0c0c0">
	    <td width="20%" class="celula"><div align="center"><strong>Curso</strong></div></td>
	    <td width="20%" height="49" class="celula"><div align="center"><strong>Função</strong></div></td>
	    <td width="7%" height="49" align="center" class="celula"><strong>Turno</strong></td>
	    <td width="13%" height="49" align="center" class="celula"><strong>Vagas<br>(Necess&aacute;ria)</strong></td>
	    <td width="13%" height="49" class="celula"><div align="center"><strong>Vagas <br>(Informada-SME)</strong></div></td>
	    <td width="13%" class="celula"><div align="center"><strong>Vagas Moduladas <br>(Informada-SME)</strong></div></td>
	    <td width="10%" class="celula"><div align="center"><strong>Saldo</strong></div></td>
      </tr>
	  
	<%
	end Sub
	sub fimTabela()
		response.Write("</table>")
	end Sub

	sql = "execute SP_AtualizaDiretrizGeraisComNecessarias 'PROFESSOR'," & intCodEmpresaUsuario & "," & trim(strAno) & "," & trim(intSemestre)
	cnn.execute sql

	intPagina = 1
	mostraCabecalho
	cont = 0
	sql = "execute SP_MostraDiretrizPadraoModulacao_rel 'PROFESSOR'," & intCodEmpresaUsuario & "," & trim(strAno) & "," & trim(intSemestre)
	rs.open sql, cnn
	if not rs.eof then 
		While not rs.eof 
			
			if rs("TotalVagasTurma") <> rs("VagasLiberadasDiretriz") then cor = "#FFB3B3"
			if rs("TotalAulasTurma") <> rs("AulasLiberadasDiretriz") then cor = "#FFB3B3"

			CorLetraI = ""
			CorLetraF = ""

			if rs("qtdePorPeriodo") > 0 then 
				CorLetraI = "<font color='#0033FF'><strong>"
				CorLetraF = "</strong></font>"
			end if
		
			if strDefiste = "S" then
				if rs("saldo") > 0 then
					strMostraSaldo = "S"
				else
					strMostraSaldo = "N"
				end if
			else
				strMostraSaldo = "S"
			end if
			
		if strMostraSaldo = "S" then
					
					%>
                      <tr  height="28" bgcolor="<%=RS("cor")%>">
                        <td align="left" class="celula"><%=rs("curso")%>&nbsp;</td>
                        <td align="center" class="celula" ><%=rs("periodo")%>&nbsp;</td>
                        <td align="left" class="celula"><%=rs("turno")%>&nbsp;</td>
                        <td align="left" class="celula"><%=rs("disciplina")%>&nbsp;</td>
                        <td  class="celula" align="center"><%=rs("qtdeTurma")%>&nbsp;</td>
                        <td  class="celula" align="center"><%=rs("TotalVagasTurma")%>&nbsp;</td>
                        <td  class="celula" align="center"><%=rs("TotalAulasTurma")%>&nbsp;</td>
                        <!--td  class="celula" align="center"><%'=rs("VagasLiberadasDiretriz")%>&nbsp;</td>
                        <td  class="celula" align="center"><%'=rs("AulasLiberadasDiretriz")%>&nbsp;</td-->
                        <td  class="celula" align="center"><%=rs("VagasModuladas")%>&nbsp;</td>
                        <td  class="celula" align="center"><%=rs("AulasModuladas")%>&nbsp;</td>
                        <td  class="celula" align="center"><%=CorLetraI%><%=rs("qtdePorPeriodo")%><%=CorLetraF%>&nbsp;</td>
                        <td  class="celula" align="center"><%=rs("saldo")%>&nbsp;</td>
                    </tr>
                    <%
			
			
				'quantidade de registros da página
				if intQtdeRegistroPorPagina = 30 then
					 intPagina = intPagina + 1
					 intQtdeRegistroPorPagina = 1
					 fimTabela
					%>
					<pre></pre>				
					<%			
					mostraCabecalho
				end if
			
			end if
		
		rs.movenext
		wend
	
	else
		%>
		  <tr>
			<td height="18" colspan="11" class="celula" align="center"><font color="#993300"><%=session("strMensagemRelatorioNaoEncontrado")%></font></td>
		  </tr>
		<%
	end if
	rs.close
%>
</table>
<%

	intPagina = intPagina + 1
	mostraCabecalhoFunc
	cont = 0
	sql = "execute SP_MostraDiretrizPadraoModulacao_rel 'FUNCIONARIO'," & intCodEmpresaUsuario & "," & trim(strAno) & "," & trim(intSemestre)
'	sql = "execute SP_QtdeAulasDiretrizXfuncionario_turno " & intCodEmpresaUsuario & "," & trim(strAno) & "," & trim(intSemestre)
	rs.open sql, cnn
	if not rs.eof then 
		While not rs.eof 
		
		if strDefiste = "S" then
			if rs("saldo") > 0 then
				strMostraSaldo = "S"
			else
				strMostraSaldo = "N"
			end if
		else
			strMostraSaldo = "S"
		end if
		
		if strMostraSaldo = "S" then	
			saldo = rs("saldo")
					
				%>
				  <tr height="28">
					<td align="left" class="celula"><%=rs("curso")%>&nbsp;</td>
					<td align="left" class="celula"><%=rs("funcao")%>&nbsp;</td>
					<td align="left" class="celula"><%=rs("turno")%>&nbsp;</td>
					<td  class="celula" align="center"><%=rs("vagasliberadasdiretriz")%>&nbsp;</td>
					<td  class="celula" align="center"><%=rs("vagasliberadasdiretriz")%>&nbsp;</td>
					<td  class="celula" align="center"><%=rs("vagasmoduladas")%>&nbsp;</td>
					<td  class="celula" align="center"><%=saldo%>&nbsp;</td>
				</tr>
				<%

			'quantidade de registros da página
			if intQtdeRegistroPorPagina = 30 then
				 intPagina = intPagina + 1
				 intQtdeRegistroPorPagina = 1
				 fimTabela
				%>
				<pre></pre>				
				<%			
				mostraCabecalho
			end if	
		 end if
		 
		rs.movenext
		wend
	
	else
		%>
		  <tr>
			<td height="18" colspan="11" align="center" class="celula"><font color="#993300"><%=session("strMensagemRelatorioNaoEncontrado")%></font></td>
	  </tr>
		<%
	end if
	rs.close
%>
</table>
<br>
<script>
	aguarde.style.display="none";
</script>
</body>
</html>
