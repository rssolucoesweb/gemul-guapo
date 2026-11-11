<%
response.Expires=0
'Não armazena a página em buffer antes de mostra-la na tela'
response.Buffer = false
%>
<!--
	::	DESENVOLVIDO POR "RS SOLUÇÕES WEB - www.rssolucoesweb.com.br"
	::	Data de Criação...: 13/02/2008
	::	Desenvolvedores...: Sergio Borges - sergiob76@hotmail.com
	::	Objetivo Pagina...: Extrato de OS
-->
<html>
<head>
<title><%=session("Titulo")%> - OS</title>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8">
<link type="text/css" rel="stylesheet" href="../../Estilo/Estilo_Impressao.css">
<script src="../../js/js_funcoes_gerais.js"></script>
<script src="../../js/js_barra_movel.js"></script>
</head>
<body>
<!--#include file="../../includes/inc_verificaSession.asp"-->
<!--#include file="../../includes/inc_cnn.asp"-->
<!--#include file="../../includes/inc_formatadata.asp"-->
<!--#include file="../../includes/inc_Botoes_relatorio.asp"-->
<!--#include file="../../includes/inc_aguarde.asp"-->
<!--#include file="../includes/inc_sqlCodigoEmpresaUsuario.asp"-->
<!--#include file="../includes/inc_CompartilharDadosCadastrais.asp"-->
<br>
<%
	dim intPagina
	dim strInfoTurma
	
	intCodArea				= Trim(Request("cmbArea"))
	intCodTipoServicoOS		= Trim(Request("cmbTipoServicoOS"))
	intCodTipoAndamento		= Trim(Request("cmbTipoAndamento"))
	intCodExecutor			= Trim(Request("cmbExecutor"))
	intCodEmpresa			= Trim(Request("cmdEmpresaUsuario"))

	strTituloRelatorio = "Relação Ordem de Serviços"

	sub mostraCabecalho()
	%>
	<!--#include file="../../includes/inc_cabecalhoRelatorio.asp"-->
	<br>
	<table width="98%" border="0" cellspacing="0" cellpadding="0" class="tabela" align="center">
	  <tr bgcolor="#CCCCCC">
	    	<td width="25%" class="celula"><div align="center"><strong>Unidade </strong></div></td>
    	<td width="10%" class="celula"><div align="center"><strong>Departamento</strong></div></td>
		    	<td width="20%" align="center" class="celula"><strong>Tipo de Serviço</strong></td>
			<td width="10%" align="center" class="celula"><strong>Usuário Abertura</strong></td>
			<td width="10%" align="center" class="celula"><div align="center"><strong>Andamento</strong></div></td>
		<td width="10%" align="center" class="celula"><div align="center"><strong>Usuário Destino</strong></div></td>
		<td width="8%" class="celula"><div align="center"><strong>Data</strong></div></td>
   	  </tr>
	   <%
	end Sub
	
	sub fimTabela()
		response.Write("</table>")
	end Sub

	intPagina = 1
	mostraCabecalho
	cont = 0
	contColaboradorEmpresa = 0
	intQtdeRegistroPorPagina = 0
	
	sql = " select	e.RAZAOSOCIAL as empresa, "
	sql = sql & " 		a.descricao as area, "
	sql = sql & " 		tp.descricao as tipo,"
	sql = sql & " 		r.Cod_Usuario_Abertura as usuario_abertura,"
	sql = sql & " 		ta.Descricao as andamento,"
	sql = sql & " 		ex.nome as usuario_destino,"
	sql = sql & " 		r.data"
	sql = sql & " from [dbo].[SOS_REQUISICAO] r"
	sql = sql & " inner join seg_empresa e					on e.codigo = r.cod_empresa"
	sql = sql & " inner join SOS_TIPO_SERVICO tp			on tp.Codigo = r.cod_tipo_servico and tp.cod_grupo = e.cod_grupo"
	sql = sql & " inner join SOS_AREA a						on a.Codigo = tp.cod_Area and a.cod_grupo = tp.cod_grupo"
	sql = sql & " inner join SOS_TIPO_ANDAMENTO ta			on ta.Codigo = r.cod_tipo_andamento and a.cod_grupo = ta.cod_grupo"
	sql = sql & " left join SOS_FUNCIONARIO_EXTERNO ex 		on ex.Codigo = r.Cod_funcionario_externo and ex.cod_grupo = a.cod_grupo"
	sql = sql & " where e.cod_grupo = " & session("CodGrupo")

	if intCodArea <> "0" then
	   sql = sql & " AND a.codigo = '" & intCodArea & "'"
	end if 
	if intCodTipoServicoOS <> "0" then
	   sql = sql & " AND r.cod_tipo_servico = '" & intCodTipoServicoOS & "'"
	end if 
	if intCodTipoAndamento <> "0" then
	   sql = sql & " AND r.cod_tipo_andamento = '" & intCodTipoAndamento & "'"
	end if 
	if intCodExecutor <> "0" then
	   sql = sql & " AND r.Cod_funcionario_externo = '" & intCodExecutor & "'"
	end if 
	if intCodEmpresa <> "0" then
	   sql = sql & " AND r.cod_empresa = '" & intCodEmpresa & "'"
	end if 
	sql = sql & " ORDER BY 1,2,r.data " 
	'response.write sql
	rs.open sql, cnn
	if not rs.eof then 
	   somaParcial = 0
	   somaParcialTotal = 0
	   While not rs.eof 
  		    %> 
			<tr>
				<td align="left" class="celula">&nbsp;<%=rs("empresa")%></td>
				<td class="celula">&nbsp;<%=rs("area")%></td>
					<td  class="celula">&nbsp;<%=rs("tipo")%></td>			
				<td  class="celula"><div align="left"><%=rs("usuario_abertura")%>&nbsp;</div></td>
				<td  class="celula"><div align="left"><%=rs("andamento")%>&nbsp;</div></td>
			<td  class="celula"><div align="left"><%=rs("usuario_destino")%>&nbsp;</div></td>
			<td  class="celula"><div align="left"><%=rs("data")%>&nbsp;</div></td>
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
			contColaboradorEmpresa = contColaboradorEmpresa + 1
			intQtdeRegistroPorPagina = intQtdeRegistroPorPagina + 1
			rs.movenext
		wend

	else
		%>
		  <tr>
			<td colspan="37" class="celula" align="center"><br><br><br><br><font color="#993300"><%=session("strMensagemRelatorioNaoEncontrado")%></font></td>
		  </tr>
		<%
	end if
	rs.close
%>
<tr>
<td colspan="37" class="celula" align="center"><div align="left">Total de Registros: <%=cont%> </div></td>
</tr>
</table>

<script>
	aguarde.style.display="none";
</script>
</body>
</html>
