<%
response.Expires=0
'Não armazena a página em buffer antes de mostra-la na tela'
response.Buffer = false
%>
<html>
<head>
<title><%=session("Titulo")%> </title>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8">
<link type="text/css" rel="stylesheet" href="../../Estilo/Estilo_Impressao.css">
<script src="../../js/js_funcoes_gerais.js"></script>
<script src="../../js/js_barra_movel.js"></script>
<style type="text/css">
<!--
.style1 {
	color: #FF0000;
	font-weight: bold;
}
-->
</style>
</head>
<body>
<!--#include file="../../includes/inc_verificaSession.asp"-->
<!--#include file="../../includes/inc_cnn.asp"-->
<!--#include file="../../includes/inc_formatadata.asp"-->
<!--  include file="../../includes/inc_Botoes_relatorio.asp"-->
<!--#include file=../../includes/inc_aguarde.asp-->
<br>
<%
	dim intPagina


	strDataInicialModulacao=request.Form("txtDataInicial")
	strDataFinalModulacao=request.Form("txtDataFinal")
	strCodFunc=request.Form("txtCodigoFuncional")
	
	
	strCod_empresa 					= Session("CodEmpresa")
	%>
<!--include file="../../includes/inc_apontamento.asp"-->
<%	


	sub mostraCabecalho(nome_func, codi_func)
	%>
	<!--#include file="../../includes/inc_cabecalhoRelatorio.asp"-->
	<br>
    <%
		cargo = ""
		funcao = ""
		turno=""
		sql = " select cc.desc_cargo, fc.Desc_Funcao, t.desc_turno"
		sql = sql & " from srh_colaborador c"
		sql = sql & " inner join SRH_CARGOCOLABORADOR cc on cc.cod_cargo=c.codCargo"
		sql = sql & " inner join SRH_FUNCAOCOLABORADOR fc on fc.cod_funcao=c.codfuncao inner join SRH_TURNO t on t.cod_turno = c.codturno"
		sql = sql & " where codFuncional=" & codi_func
		rsAux.open sql, cnn
		if not rsAux.eof then
			cargo = rsAux("desc_cargo")
			funcao = rsAux("Desc_Funcao")
			turno = rsAux("desc_turno")
		end if
		rsAux.close
	%>
	<table width="98%" border="0" cellspacing="0" cellpadding="0" class="tabela" align="center">
      <tr >
        <td colspan="3" height="30" align="center" class="celula"><strong><font size="+1"><%=ucase(nome_func)%> - <%=codi_func%></font></strong><br><font size="2">Cargo: <%=cargo%> - Função: <%=funcao%> - Turno: <%=turno%></font></td>
      </tr>
	  <tr bgcolor="#CCCCCC">
	    <td width="7%" align="center" class="celula"><strong>Unidade</strong></td>
	    <td width="7%" class="celula"><div align="center"><strong>Data</strong></div></td>
	    <td width="7%" height="15" class="celula"><div align="center"><strong>Registro de Ponto</strong></div></td>
      </tr>
	  <%
	end Sub
	
	sub fimTabela()
		response.Write("</table>")
	end Sub

	DataInicial = Trim(Request("txtDataInicial"))
	DataFinal = Trim(Request("txtDataFinal"))

	strTituloRelatorio  	= "BATIDA DE PONTO <BR> Per&iacute;odo de: " & formatadataAP(Trim(strDataInicialModulacao)) & " a " & formatadataAP(Trim(strDataFinalModulacao))

	intPagina = 1


	if trim(strCodFunc) <> ""  then
	
	    MarcaColaborador = "0"

		sql = " SELECT f.data, f.hora, E.CODIGO, E.RAZAOSOCIAL, func.NOME_FUNC, func.codi_func"
		sql = sql & " FROM gemul5.dbo.COLETA f INNER JOIN SEG_EMPRESA E ON E.CODIGO = F.COLETOR "
		sql = sql & " INNER JOIN gemul5.dbo.FUNCIONARIOS func on func.codi_func = f.codi_func  "
		sql = sql & " WHERE f.codi_func  = " & strCodFunc
		sql = sql & " And data between '" & formatadataBD(Trim(strDataInicialModulacao)) & "' and '" & formatadataBD(Trim(strDataFinalModulacao)) & "'"
		sql = sql & " order by E.RAZAOSOCIAL, f.data, f.hora"
		'response.write sql
		cont = 0
		rs.open sql, cnn
		if rs.eof = false then
			mostraCabecalho rs("NOME_FUNC"), rs("codi_func")

			while not rs.eof
				%>
				  <tr >
				    <td align="center" class="celula">&nbsp;<%=rs("RAZAOSOCIAL")%> - <%=rs("codigo")%></td>
					<td align="center" height="19" class="celula"><strong><%=formatadataAP(rs("data"))%></strong></td>
					<td align="center" class="celula"><div align="center"><%=rs("hora")%>&nbsp;</div></td>
				  </tr>
                 <%
				'quantidade de registros da página
				if intQtdeRegistroPorPagina = 50 then
					 intPagina = intPagina + 1
					 intQtdeRegistroPorPagina = 1
					 fimTabela
					%>
					<pre></pre>				
					<%			
					mostraCabecalho
				end if	
				cont = cont + 1
				DATA = RS("DATA") 
				rs.movenext	
				
			wend
		else
			%>
			<script>
				alert("Sem registro de ponto!");
				window.history.back();
			</script>
			<%
			response.end
		end if 
		rs.close
	end if 
%>
</table>

<script>
	aguarde.style.display="none";
</script>
<!--include file="../../includes/inc_apontamento_remove.asp"-->
</body>
</html>