<%
response.Expires=0
'Não armazena a página em buffer antes de mostra-la na tela'
response.Buffer = false
%>
<html>
<head>
<title><%=session("Titulo")%></title>
<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1">
<link type="text/css" rel="stylesheet" href="../../Estilo/Estilo_Impressao.css">
<script src="../../js/js_funcoes_gerais.js"></script>
</head>
<body>
<!--#include file="../../includes/inc_verificaSession.asp"-->
<!--#include file="../../includes/inc_cnn.asp"-->
<!--#include file="../../includes/inc_formatadata.asp"-->
<!--#include file="../../includes/inc_aguarde.asp"-->
<br>
<%
	dim intPagina
	strCod_empresa 			= Session("CodEmpresa")
	intCodCurso 			= Trim(Request.Form("cmbCurso"))
	intCodTipoEmpresa 		= Trim(Request.Form("cmbTipoEmpresa"))
	
	strTituloRelatorio = "Mapa Geral de Inscrições"
	
	sub mostraCabecalho(vetPeriodo)
	%>
	<!--#include file="../../includes/inc_cabecalhoRelatorio.asp"-->
	<br>
	<table width="100%" border="0" cellspacing="0" cellpadding="0" class="tabela">
      <tr bgcolor="#CCCCCC">
	<%if isArray(vetPeriodo) then
		controle = 0%>
        <td width="28%" height="16" class="celula"><strong>Escola</strong></td>
		<%for i=0 to ubound(vetPeriodo,2)%>
        <td align="center" class="celula"><strong><%=vetPeriodo(0,i)%></strong></td>
        <%next%>
        <td align="center" class="celula"><strong>TOTAL</strong></td>
    <%end if%>
      </tr>
      <%
	end Sub
	
	sub fimTabela()
		response.Write("</table>")
	end Sub

	intPagina = 1
	intQtdeRegistroPorPagina = 1
	
	cont = 0
	
	curso = request.Form("cmbTipoCurso")
	vetPeriodo = null
	IF curso = "EDUCACAO INFANTIL" THEN curso = "EDUCAÇÃO INFANTIL"
	
	sql = "select distinct Descricao as serie"
	sql = sql & " from SCA_PERIODO"
	sql = sql & " where Cod_Curso in (select Cod_Curso from SCA_CURSO where left(Descricao,18) = '" & curso & "')"
	sql = sql & " and cod_empresa in (select codigo from seg_empresa where cod_grupo=7)"
	rs.open sql, cnn
	if not rs.eof then
		vetPeriodo = rs.getRows
	end if
	rs.close

	mostraCabecalho vetPeriodo
	
	SQL = "execute SP_MapaDeSolicitacoes '" & curso & "'"
	vetMapa = null
	rs.open sql, cnn
	if not rs.eof then
		vetMapa = rs.getRows
	end if
	rs.close
		
	if isArray(vetMapa) then
		for i=0 to ubound(vetMapa,2)
			total = 0
		%>
            <tr>
                <td class="celula" align="left">&nbsp;<%=vetMapa(0,i) %></td>
                <% for j=2 to ubound(vetPeriodo,2)+2 %>
                <td class="celula" align="center"><%=vetMapa(j,i) %>&nbsp;</td>
                <% 
						if not isnull(vetMapa(j,i)) then total = total + vetMapa(j,i)
					next%> 
                <td class="celula" align="center"><%=total %>&nbsp;</td>
                
            </tr>
		<%
		next
	end if
	%>
    </table>
    <br>
<script>
	aguarde.style.display="none";
</script>
</body>
</html>
