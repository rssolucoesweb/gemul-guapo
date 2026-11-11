<%
response.Expires=0
'Não armazena a página em buffer antes de mostra-la na tela'
response.Buffer = false
%>
<!--
	::	DESENVOLVIDO POR "RS SOLUÇÕES WEB - www.rssolucoesweb.com.br"
	::	Data de Criação...: 13/02/2008
	::	Desenvolvedores...: Sergio Borges - sergiob76@hotmail.com
	::	Objetivo Pagina...: Extrato de Notas
-->
<html>
<head>
<title><%=session("Titulo")%> - Grade Curricular</title>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8">
<link type="text/css" rel="stylesheet" href="../../Estilo/Estilo_Impressao.css">
<script src="../../js/js_funcoes_gerais.js"></script>
<body>
<!--#include file="../../includes/inc_verificaSession.asp"-->
<!--#include file="../../includes/inc_cnn.asp"-->
<!--#include file="../../includes/inc_formatadata.asp"-->
<!--#include file="../../includes/inc_Botoes_relatorio.asp"-->
<!--#include file="../../includes/inc_aguarde.asp"-->
<!--#include file="../includes/inc_sqlCodigoEmpresaUsuario.asp"-->
<!--#include file="../includes/inc_CompartilharDadosCadastrais.asp"-->
<%
	dim intPagina
	dim strInfoTurma
	
	strSituacao					= Trim(Request.Form("cmbSituacao"))	
	intCodEmpresaUsuario 	    = TRIM(Request.Form("cmdEmpresaUsuario"))
	strTituloRelatorio  		= "Relatório - Hor&aacute;rio Colaborador ( Especial )"

	sub mostraCabecalho()
	%>
	<!--#include file="../../includes/inc_cabecalhoRelatorio.asp"-->
	<br>
	<table width="98%" border="0" cellspacing="0" cellpadding="0" class="tabela" align="center">
	  <tr bgcolor="#CCCCCC">
	    <td width="5%" height="19" class="celula"><strong>Matricula </strong></td>
        <td width="32%" class="celula"><strong>Colaborador</strong></td>
	    <td width="20%" class="celula"><strong>Unidade</strong></td>
	    <td width="20%" class="celula"><strong>Faixa de Horário - Especial</strong></td>
	  </tr>
	<%
	end Sub
	
	sub fimTabela()
		response.Write("</table>")
	end Sub

	intPagina = 1
	mostraCabecalho
	cont = 0

	sql = " select c.Codigo, c.CodLotacao, c.Nome, c.codFuncional, e.RAZAOSOCIAL from SRH_COLABORADOR C "
	sql = sql & " inner join seg_empresa e on e.codigo = c.codLotacao " 
	sql = sql & " where 1=1 " 
	if intCodEmpresaUsuario <> "" and intCodEmpresaUsuario <> "0" then
		sql = sql & "and c.codlotacao= " & intCodEmpresaUsuario
	end if
	sql = sql & " and c.codigo in (select distinct Cod_Colaborador from APO_PONTOHORARIO_COLABORADOR) "
	if strSituacao <> "" and strSituacao <> "0" then
       sql = sql & " AND C.SITUACAO	= '" & strSituacao & "'"
	end if 
	sql = sql & " order by c.nome "	
	rs.open sql, cnn
	if not rs.eof then 
	
	   While not rs.eof 
	       
  		    %> 
			<tr>
			<td height="29" class="celula"><div align="center">&nbsp;<%=rs("CodFuncional")%></div></td>
            <td class="celula">&nbsp;<%=rs("Nome")%></td>
            <td  class="celula">&nbsp;<%=rs("RAZAOSOCIAL")%>&nbsp;-&nbsp;<%=rs("CodLotacao")%></td>
            <%
			strFaixas = ""
			sql = " SELECT distinct PHC.Cod_Colaborador, PHC. Cod_PontoHorario, "
			sql = sql & " PH.Codigo, PH.Tipo, PH.Hora, PH.Minuto, PH.Segundo, PH.Situacao, TU.Desc_Turno "
			sql = sql & " FROM APO_PONTOHORARIO_COLABORADOR PHC "
			sql = sql & " INNER JOIN APO_PONTOHORARIO PH ON PH.CODIGO = PHC.Cod_PontoHorario "
			sql = sql & " INNER JOIN SRH_TURNO TU ON TU.COD_TURNO = PH.COD_TURNO "
			sql = sql & " WHERE  PHC.Cod_Colaborador = " & trim(rs("Codigo"))
			sql = sql & " order by TU.Desc_Turno, PH.Hora "
			rsaux.open sql, cnn
			if rsaux.eof = false then
				while not rsaux.eof
				
					if trim(rsaux("tipo")) = "E" then
						strNomeTipo = "Entrada"
					else
						strNomeTipo = "Saída"
					end if

					strFaixas = strFaixas & zeroleft(trim(rsaux("Hora")),2) & ":" & zeroleft(trim(rsaux("Minuto")),2) & " - " & trim(strNomeTipo)  & " " & trim(rsaux("Desc_Turno"))& "<BR>"  
					rsaux.movenext
				wend
			end if
			rsaux.close
			strFaixas = strFaixas & CHR(13)
			%>
			<td  class="celula"><%=strFaixas%></td>
	  		</tr> 
		    <%	
			'quantidade de registros da página
			if intQtdeRegistroPorPagina = 28 then
				 intPagina = intPagina + 1
				 intQtdeRegistroPorPagina = 1
				 fimTabela
				 response.write "<pre> </pre>"
				mostraCabecalho
			end if	
			cont = cont + 1
			intQtdeRegistroPorPagina = intQtdeRegistroPorPagina + 1
			rs.movenext
		wend
	end if
	rs.close
%>
<tr>
<td colspan="35" class="celula" align="center"><div align="left">Total de Registros: <%=cont%> </div></td>
</tr>
</table>
<script>
	aguarde.style.display="none";
</script>
</body>
</html>
