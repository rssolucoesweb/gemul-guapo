<%
response.Expires=0
'N�o armazena a p�gina em buffer antes de mostra-la na tela'
response.Buffer = false
%>
<!--
	::	DESENVOLVIDO POR "RS SOLU��ES WEB - www.rssolucoesweb.com.br"
	::	Data de Cria��o...: 13/02/2008
	::	Desenvolvedores...: Sergio Borges - sergiob76@hotmail.com
	::	Objetivo Pagina...: Extrato de Notas
-->
<html>
<head>
<title><%=session("Titulo")%></title>
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
	
	'strSituacao					= Trim(Request.Form("cmbSituacao"))	
	'intCodColaborador				= Trim(Request("txtCodFuncionario"))
	'strAnoLetivo				= Trim(Request("txtAnoLetivo"))
	'intCodEmpresaUsuario 	    = TRIM(Request.Form("cmbEmpresaGrupo"))
	'intCodJustificativaFaltas		= Trim(Request("cmbJustificativaFaltas"))
	strSituacaoPedidoRemocao	= Trim(Request("cmbSituacaoPedidoRemocao"))
	if strSituacaoPedidoRemocao = "" then
		strSituacaoPedidoRemocao	= 0
	end if
	

	strTituloRelatorio  	= "Relatório de Pedido de Remoção"

	sub mostraCabecalho()
	%>
	<!--#include file="../../includes/inc_cabecalhoRelatorio.asp"-->
	<br>
	<table width="98%" border="0" cellspacing="0" cellpadding="0" class="tabela" align="center">
        <tr bgcolor="#CCCCCC">
            <td width="1%" class="celula"><div align="center"><strong>Matr</strong></div></td>
            <td width="10%" class="celula"><div align="center"><strong>Colaborador</strong></div></td>
            <td width="10%" align="center" class="celula"><strong>Unidade</strong></td>
            <td width="5%" align="center" class="celula"><strong>Cargo</strong></td>
            <td width="10%" align="center" class="celula"><strong>Fução</strong></td>
            <td width="10%" align="center" class="celula"><strong>Fução escolhida</strong></td>
            <td width="2%" align="center" class="celula"><strong>Turno</strong></td>
            <td width="2%" align="center" class="celula"><strong>Turno escolhido</strong></td>
            <td width="10%" align="center" class="celula"><strong>1ª Opção</strong></td>
            <td width="10%" class="celula"><div align="center"><strong>2ª Opção</strong></div></td>
            <td width="10%" class="celula"><div align="center"><strong>3ª Opção</strong></div></td>
            <td width="2%" class="celula"><div align="center"><strong>Situação</strong></div></td>
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

	SQL = " select em.razaosocial as escola, F.Desc_Funcao AS FUNCAO, CA.Desc_Cargo AS CARGO, T.Desc_Turno AS TURNO, TE.Desc_Turno AS TURNO_ESCOLHIDO, p.codigo, c.codFuncional,c.nome, p.funcao_escolhida, case when p.COD_EMPRESA_1OPCAO is null then r1.descricao else e1.razaosocial end as opcao1, case when p.COD_EMPRESA_2OPCAO is null then r2.descricao else e2.razaosocial end as opcao2, case when p.COD_EMPRESA_3OPCAO is null then r3.descricao else e3.razaosocial end as opcao3, p.situacao, p.usuario_incl, p.data_hora_incl, p.usuario_altr, p.data_hora_altr "
	SQL = SQL & " from SRH_PEDIDO_REMOCAO P "
	SQL = SQL & " inner join SRH_COLABORADOR C ON C.CODIGO = P.COD_COLABORADOR "
	SQL = SQL & " left join seg_empresa em ON em.codigo = P.COD_EMPRESA "
	SQL = SQL & " left join SRH_TURNO T ON T.COD_TURNO = P.COD_TURNO"
	SQL = SQL & " left join SRH_TURNO TE ON TE.COD_TURNO = P.COD_TURNO_ESCOLHIDO"
	SQL = SQL & " left join seg_empresa e on e.codigo = c.codLotacao and e.cod_grupo=" & Session("CodGrupo")
	SQL = SQL & " left join srh_funcaocolaborador f on f.Cod_Funcao = p.cod_funcao "
	SQL = SQL & " left join srh_cargocolaborador ca on ca.Cod_Cargo = p.Cod_Cargo "
	SQL = SQL & " left join SEG_REGIAO R1 ON R1.CODIGO = P.COD_REGIAO1 "
	SQL = SQL & " left join SEG_REGIAO R2 ON R2.CODIGO = P.COD_REGIAO2 "
	SQL = SQL & " left join SEG_REGIAO R3 ON R3.CODIGO = P.COD_REGIAO3 "
	SQL = SQL & " left join SEG_EMPRESA E1 ON E1.CODIGO = P.COD_EMPRESA_1OPCAO "
	SQL = SQL & " left join SEG_EMPRESA E2 ON E2.CODIGO = P.COD_EMPRESA_2OPCAO "
	SQL = SQL & " left join SEG_EMPRESA E3 ON E3.CODIGO = P.COD_EMPRESA_3OPCAO "
	SQL = SQL & " WHERE P.COD_GRUPO = " & Session("CodGrupo")

	if strSituacaoPedidoRemocao <> "0" then
		sql = sql & " AND P.situacao = '" & strSituacaoPedidoRemocao & "'"
	end if
	sql = sql & " order BY P.DATA_hora_INCL "
	
	strCorLinha = "bgcolor='#EAEAEA'"
	rs.open sql, cnn
	if not rs.eof then 
	   While not rs.eof 
	   		if rs("nome")<>strNome then
				strNome = rs("nome")
			else
				strNome = ""
			end if
			
			if rs("codFuncional")<>codFuncional then
				if strCorLinha = "bgcolor='#EAEAEA'" then
					strCorLinha = " bgcolor='#FFFFFF'"
				else
					strCorLinha = "bgcolor='#EAEAEA'"
				end if
			end if
			
			situacao = "Solicitado"
			if rs("situacao") = "F" then 
				situacao = "Atendido"
			end if
  		    %> 
			<tr <%=strCorLinha%>>
                <td class="celula"><div align="center">&nbsp;<%=rs("codFuncional")%></div></td>
                <td class="celula"><%=strNome%></td>
                <td class="celula"><%=trim(rs("escola"))%></td>
                <td class="celula"><%=trim(rs("cargo"))%></td>
                <td class="celula"><%=trim(rs("funcao"))%></td>
                <td class="celula"><%=trim(rs("funcao_escolhida"))%></td>
                <td class="celula"><%=trim(rs("turno"))%></td>
                <td class="celula"><%=trim(rs("turno_escolhido"))%></td>
                <td class="celula"><%=trim(rs("opcao1"))%></td>
                <td class="celula"><%=trim(rs("opcao2"))%></td>
                <td class="celula"><%=trim(rs("opcao3"))%></td>
                <td  class="celula"><div align="left"><%=situacao%>&nbsp;</div></td>
			</tr>
		    <%	
			'quantidade de registros da p�gina
			if intQtdeRegistroPorPagina = 50 then
				' intPagina = intPagina + 1
				 'intQtdeRegistroPorPagina = 1
				 'fimTabela
				%>
				<!--pre></pre -->				
				<%			
				'mostraCabecalho
			end if	
			cont = cont + 1
			contColaboradorEmpresa = contColaboradorEmpresa + 1
			intQtdeRegistroPorPagina = intQtdeRegistroPorPagina + 1
			strNome = rs("nome")
			codFuncional = rs("codFuncional")
			rs.movenext
		wend
	else
		%>
		  <tr>
			<td colspan="42" class="celula" align="center"><br><br><br><br><font color="#993300"><%=session("strMensagemRelatorioNaoEncontrado")%></font></td>
		  </tr>
		<%
	end if
	rs.close
%>
<tr>
<td colspan="42" class="celula" align="center"><div align="left">Total de Registros: <%=cont%> </div></td>
</tr>
</table>

<script>
	aguarde.style.display="none";
</script>
</body>
</html>
