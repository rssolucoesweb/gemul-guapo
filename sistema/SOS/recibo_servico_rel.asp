<%@LANGUAGE="VBSCRIPT" CODEPAGE="65001"%> 
<%  
response.Charset = "utf-8" 
response.ContentType = "text/html" 
%> 
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8">
<link href="../../estilo/Estilo_Impressao.css" rel="stylesheet" type="text/css">
<head>
<title><%=session("Titulo")%></title>
</head>
</head>
<body>
<!--#include file="../../includes/inc_cnn.asp"-->
<!--#include file="../../includes/inc_extenso.asp"-->
<!--#include file="../../includes/inc_formataData.asp"-->
<!--#include file="../../includes/inc_Botoes_relatorioPopap.asp"-->
<!--#include file="../../includes/inc_CabecalhoRelatorio.asp"-->
<script src="../../js/barraMovel.js"></script>
<script src="../../js/js_funcoes_gerais.js"></script>
<%
	intCodEmpresa				= Session("CodEmpresa")	
	intCodColaborador			= request.QueryString("CodColaborador")
	intCodLotacao				= request.QueryString("CodLotacao")
	intCodLotacaoAnterior		= request.QueryString("CodLotacaoAnterior")
	
	strTitulo = "LOTAÇÃO"
	
	id						= Trim(Request.QueryString("id"))
    if id = "" then id="0"
	
	if trim(id) <> "" then
		sql = " SELECT e.razaosocial as unidade_solicitante, g.USUA_NOME_COMPLETO as gestor,  r.data, ex.nome as executor, u.USUA_NOME_COMPLETO as nome_solicitante, pri.descricao as prioridade, r.resumo, t.cod_Area,"
		sql = sql & " t.descricao as tipo_servico, a.descricao as area, ta.descricao as andamento, (select top 1 a.data_hora_incl from SOS_REQUISICAO_andamento a where a.cod_requisicao=r.codigo order by a.data_hora_incl desc) as data_andamento, (select top 1 a.parecer from SOS_REQUISICAO_andamento a where a.cod_requisicao=r.codigo order by a.data_hora_incl desc) as parecer"
		sql = sql & " FROM SOS_REQUISICAO r "
		sql = sql & " inner join SEG_EMPRESA e on e.codigo = r.cod_empresa"
		sql = sql & " inner join SOS_TIPO_SERVICO t on t.codigo = r.cod_tipo_servico "
		sql = sql & " inner join SOS_TIPO_ANDAMENTO ta on ta.codigo = r.cod_tipo_andamento"
		sql = sql & " inner join SOS_AREA a on a.codigo = t.cod_area "
		sql = sql & " inner join SEG_USUARIOS_SISTEMA u on u.usua_codg = r.cod_usuario_abertura"
		sql = sql & " inner join SEG_USUARIOS_SISTEMA g on g.usua_codg = a.usua_codg"
		sql = sql & " inner join SOS_PRIORIDADE pri on pri.codigo = r.cod_prioridade"
		sql = sql & " inner join SOS_FUNCIONARIO_EXTERNO ex on ex.codigo = r.cod_funcionario_externo"
		sql = sql & " where r.Codigo = " & id
		rs.open sql, cnn
		if rs.eof = false then
			unidade_solicitante	= rs("unidade_solicitante")
			data				= rs("data")
			gestor				= rs("gestor")
			executor			= rs("executor")
			nome_solicitante	= rs("nome_solicitante")
			prioridade			= rs("prioridade")
			resumo				= rs("resumo")
			tipo_servico		= rs("tipo_servico")
			area				= rs("area")
			andamento			= rs("andamento")
			data_andamento		= rs("data_andamento")
			parecer				= rs("parecer")
		end if 
		rs.close
		
	end if
	%>
		<br />
		<table width="98%"  align="center"class="textoRelatorio">
		  <tr> 
			<td colspan="3" align="center" class="textoRelatorio"></td>
		  </tr>
		  <tr>
		    <td colspan="3" align="center" class="textoRelatorio">&nbsp;</td>
	      </tr>
		  <tr>
			<td colspan="3" align="center" class="textoRelatorio"><h2><p align="center"><strong>ORDEM DE SERVIÇO Nº.: <%=id%></strong></p></h2></td>
		  </tr>
		  <tr>
		    <td colspan="3" align="center">&nbsp;</td>
	      </tr>
		  
		  <tr>
			<td width="166" height="23" class="textoRelatorio">Unidade Escolar: </td>
			<td width="1291" colspan="2" class="textoRelatorio"><strong><%=unidade_solicitante%></strong></td>
		  </tr>
		   <tr>
			<td width="166" height="23" class="textoRelatorio">Requisitante: </td>
			<td width="1291" colspan="2" class="textoRelatorio"><strong><%=nome_solicitante%></strong></td>
		  </tr>

		  <tr>
			<td width="166" height="23" class="textoRelatorio">Data: </td>
			<td width="1291" colspan="2" class="textoRelatorio"><strong><%=data%></strong></td>
		  </tr>

		  <tr>
			<td width="166" height="23" class="textoRelatorio">Área: </td>
			<td width="1291" colspan="2" class="textoRelatorio"><strong><%=area%></strong></td>
		  </tr>

		  <tr>
			<td width="166" height="23" class="textoRelatorio">Tipo de Serviço: </td>
			<td width="1291" colspan="2" class="textoRelatorio"><strong><%=tipo_servico%></strong></td>
		  </tr>

		  <tr>
			<td width="166" height="23" class="textoRelatorio">Resumo: </td>
			<td width="1291" colspan="2" class="textoRelatorio"><strong><%=resumo%></strong></td>
		  </tr>

		  <tr>
			<td width="166" height="23" class="textoRelatorio">Parecer: </td>
			<td width="1291" colspan="2" class="textoRelatorio"><strong><%=parecer%></strong></td>
		  </tr>

		  <tr>
			<td width="166" height="23" class="textoRelatorio">Andamento: </td>
			<td width="1291" colspan="2" class="textoRelatorio"><strong><%=andamento%> em <%=data_andamento%></strong></td>
		  </tr>

		  <tr>
			<td width="166" height="23" class="textoRelatorio">Executor: </td>
			<td width="1291" colspan="2" class="textoRelatorio"><strong><%=executor%></strong></td>
		  </tr>
          
	      </tr>
		    <td colspan="3" class="textoRelatorio">&nbsp;</td>
	      </tr>
		  <tr>
		    <td colspan="3" class="textoRelatorio">&nbsp;</td>
	      </tr>
		  <tr>
		    <td colspan="3" align="center" class="textoRelatorio"><%=Session("CidadeEmpresaWeb")%>, <%=day(date)%> de <%=monthname(month(date))%> de <%=year(date)%></td>
	      </tr>
		  <tr>
		    <td colspan="3" class="textoRelatorio">&nbsp;</td>
	      </tr>
		  <tr>
		    <td colspan="3" class="textoRelatorio">&nbsp;</td>
	      </tr>
		  <tr>
		    <td colspan="3" align="center" class="textoRelatorio">___________________________________</td>
	      </tr>
           <tr>
		    <td colspan="3" align="center" class="textoRelatorio"><strong><%=gestor%></strong></td>
	      </tr>
		  <tr>
		    <td colspan="3" align="center" class="textoRelatorio"><strong>Gestor</strong></td>
	      </tr>
 		  <tr>
		    <td colspan="3" align="center" class="textoRelatorio">&nbsp;</td>
	      </tr>
		  <tr>
		    <td colspan="3" align="center" class="textoRelatorio">- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -</td>
	      </tr>
		   <tr>
		    <td colspan="3" align="center" class="textoRelatorio">&nbsp;</td>
	      </tr>
         <tr>
			<td colspan="3" align="center" class="textoRelatorio"><h2><p align="center"><strong>ORDEM DE SERVIÇO Nº.: <%=id%></strong></p></h2></td>
		  </tr>
		  <tr>
		    <td colspan="3" align="center">&nbsp;</td>
	      </tr>
		  <tr>
		    <td colspan="3" align="center" class="textoRelatorio">Finalizada em: ____/_____/________ </td>
	      </tr>
           <tr>
		    <td colspan="3" align="center" class="textoRelatorio">(  )O.S. EXECUTADA&nbsp;&nbsp;(  )O.S. PARCIALMENTE EXECUTADA&nbsp;&nbsp;(  )O.S. NÃO EXECUTADA</td>
	      </tr>
		   <tr>
		    <td colspan="3" align="center">&nbsp;</td>
	      </tr>
		  <tr>
		    <td colspan="3" align="center" class="textoRelatorio">___________________________________</td>
	      </tr>
           <tr>
		    <td colspan="3" align="center" class="textoRelatorio"><strong><%=nome_solicitante%></strong></td>
	      </tr>
		  <tr>
		    <td colspan="3" align="center" class="textoRelatorio"><strong>Requisitante</strong></td>
	      </tr>
		  <tr>
		    <td colspan="3" align="center">&nbsp;</td>
	      </tr>
		  <tr>
		    <td colspan="3" align="center" class="textoRelatorio">___________________________________</td>
	      </tr>
           <tr>
		    <td colspan="3" align="center" class="textoRelatorio"><strong><%=executor%></strong></td>
	      </tr>

		  <tr>
		    <td colspan="3" align="center" class="textoRelatorio"><strong>Executor</strong></td>
	      </tr>
		</table>
</body>
</html>