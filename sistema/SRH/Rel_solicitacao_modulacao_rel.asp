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
<title><%=session("Titulo")%> - Grade Curricular</title>
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
	
	strAnoLetivo				= Trim(Request("txtAnoLetivo"))
	intCodEmpresaUsuario 	    = TRIM(Request("cmbEmpresaGrupo"))
	
	strTituloRelatorio  	= "Relatório de Solicitação de Modulação<BR><font size='+1'>QUADRO DE PESSOAL E ESTRUTURA FÍSICA</font>"
	
	sub mostraCabecalho()
	%>
	<!--#include file="../../includes/inc_cabecalhoRelatorio.asp"-->
	<br>
	<table width="98%" border="0" cellspacing="0" cellpadding="0" class="tabela" align="center">
        <tr>
          <td colspan="6"  class="celula" align="center" bgcolor="#CCCCCC"><font size="+1"><strong>QUADRO DE PESSOAL</strong></font></td>
        </tr>
  <tr bgcolor="#CCCCCC">
            <td width="5%" class="celula"><div align="center"><strong>Matr&iacute;cula</strong></div></td>
            <td width="23%" class="celula"><div align="center"><strong>Colaborador</strong></div></td>
            <td width="8%" align="center" class="celula"><strong>CH</strong></td>
            <td width="8%" align="center" class="celula"><strong>Função</strong></td>
            <td width="14%" class="celula"><div align="center"><strong>Cargo</strong></div></td>
            <td width="10%" class="celula"><div align="center"><strong>Turno</strong></div></td>
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

	sql = "select isnull(c.nome,'DÉFICIT') as nome, c.codFuncional, e.razaosocial, s.carga_horaria, s.situacao, s.codigo, s.cod_lotacao, isnull(fc.descricao,'NÃO INFORMADA') as categoria, fa.desc_funcao, s.cod_colaborador, s.data_hora_altr, s.cod_funcao, s.cod_cargo, s.cod_FormaNomeacao, s.cod_turno, s.carga_horaria, s.observacao, m.Desc_FormaNomeacao, ca.Desc_Cargo, tu.desc_turno"
	sql = sql & " from SRH_SOLICITACAO_MODULACAO s"
	sql = sql & " left join srh_colaborador c on s.Cod_colaborador = c.codigo"
	sql = sql & " left join SEG_EMPRESA e on e.codigo = s.cod_empresa"
	sql = sql & " left join SRH_FORMANOMEACAOCOLABORADOR m on m.Cod_FormaNomeacao = c.CodFormaNomeacao"
	sql = sql & " left join SRH_CARGOCOLABORADOR ca on ca.Cod_Cargo = c.CodCargo"
	sql = sql & " left join SRH_TURNO tu on tu.Cod_Turno = c.CodTurno"
	sql = sql & " left join SRH_FUNCAOCOLABORADOR fa on fa.Cod_funcao = s.cod_funcao"
	sql = sql & " left join SRH_FUNCAOCATEGORIA fc on fc.codigo = fa.Cod_funcaoCategoria"
	sql = sql & " where s.cod_empresa = "& intCodEmpresaUsuario
	sql = sql & " and s.ano_letivo = " & strAnoLetivo
	sql = sql & " Order by fc.descricao, s.codigo "
	categoria=""
	rs.open sql, cnn
	if not rs.eof then 
	   While not rs.eof   
			IF trim(RS("categoria"))<>trim(categoria) then
			%>
			<tr>
			  <td colspan="6"  class="celula" align="center" bgcolor="#CCCCCC"><strong><%=rs("categoria")%></strong></td>
			</tr>
<%
			end if
  		    %> 
			<tr>
                <td class="celula"><div align="center"><%=rs("codFuncional")%></div></td>
                <td class="celula"><%=rs("nome")%></td>
                <td align="center"  class="celula"><%=rs("carga_horaria")%>&nbsp;</td>			
                <td align="left"  class="celula"><%=rs("desc_funcao")%></td>			
                <td  class="celula"><%=rs("Desc_Cargo")%>&nbsp;</td>
                <td  class="celula"><%=rs("desc_turno")%></td>
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
			categoria = rs("categoria")		
			rs.movenext
		wend
	else
		%>
		  <tr>
			<td colspan="7" class="celula" align="center"><br><br><br><br><font color="#993300"><%=session("strMensagemRelatorioNaoEncontrado")%></font></td>
		  </tr>
		<%
	end if
	rs.close
%>
</table>
	
	<%
	sub mostraCabecalhoEstrutura()
	%>
	<br>
	<table width="98%" border="0" cellspacing="0" cellpadding="0" class="tabela" align="center">
        <tr>
          <td colspan="3"  class="celula" align="center" bgcolor="#CCCCCC"><font size="+1"><strong>ESTRUTURA FÍSICA</strong></font></td>
        </tr>
        <tr bgcolor="#CCCCCC">
            <td width="30%" class="celula"><div align="center"><strong>Descrição</strong></div></td>
            <td width="5%" class="celula"><div align="center"><strong>Quantidade</strong></div></td>
            <td width="10%" align="center" class="celula"><strong>Metragem (m2)</strong></td>
   	 	</tr>
	   <%
	end Sub
	
	sub fimTabela()
		response.Write("</table>")
	end Sub

	intPagina = 1
	mostraCabecalhoEstrutura
	cont = 0
	contColaboradorEmpresa = 0
	intQtdeRegistroPorPagina = 0

	sql = "SELECT e.Codigo, e.Cod_Empresa, e.Cod_Dependencia, e.Quantidade, e.Metragem, df.descricao"
	sql = sql & " FROM SRH_DIRETRIZES_ESTRUTURAFISICA E"
	sql = sql & " INNER JOIN SRH_DEPENDENCIAS_FISICAS DF ON DF.Codigo = E.Cod_Dependencia"
	sql = sql & " WHERE COD_EMPRESA = " & intCodEmpresaUsuario
	sql = sql & " ORDER BY df.descricao "
	rs.open sql, cnn
	if not rs.eof then 
	   While not rs.eof   
	   		%>
			<tr>
            
           	  <td class="celula"><%=trim(rs("DESCRICAO"))%></td>
                <td align="center" class="celula"><%=rs("QUANTIDADE")%></td>
              <td align="center" class="celula"><%=rs("METRAGEM")%></td>
			</tr>
		    <%	
			rs.movenext
		wend
	else
		%>
		  <tr>
			<td colspan="3" class="celula" align="center"><br><br><br><br><font color="#993300"><%=session("strMensagemRelatorioNaoEncontrado")%></font></td>
		  </tr>
		<%
	end if
	rs.close
%>
</table>
<br>
<table width="98%" border="0" cellspacing="0" cellpadding="0" class="tabela" align="center">
    <tr>
      <td colspan="3"  class="celula" align="center" bgcolor="#CCCCCC"><font size="+1"><strong>NÚMERO DE ALUNOS</strong></font></td>
    </tr>
   <%
	contAluno=0
	sql = " select tt.desc_turno as turno, count(*)  as alunos"
	sql = sql & " from sca_aluno a"
	sql = sql & " inner join sca_situacaoaluno	sa on sa.Cod_SituacaoAluno = a.COD_SITUACAOALUNO and sa.Cod_Empresa = a.COD_EMPRESA"
	sql = sql & " inner join sca_aluno_turma		at on at.COD_ALUNO = a.CODIGO and at.COD_EMPRESA = a.COD_EMPRESA"
	sql = sql & " inner join sca_turma			tu on tu.cod_turma = at.COD_TURMA and at.COD_EMPRESA = tu.COD_EMPRESA and tu.anoLetivo = at.ano_letivo"
	sql = sql & " inner join SCA_TURNO			tt on tt.cod_turno = tu.cod_turno"
	sql = sql & " where (sa.Desc_SituacaoAluno = 'ATIVO' OR  sa.Desc_SituacaoAluno = 'PRÉ-MATRÍCULA' )"
	sql = sql & " and at.ANO_LETIVO = " & strAnoLetivo & " and tu.anoletivo=" & strAnoLetivo & ""
	sql = sql & " and tu.situacao = 'A' AND  at.situacao = 'A'"
	sql = sql & " and a.COD_EMPRESA = " & intCodEmpresaUsuario
	sql = sql & " group by tt.desc_turno"
	sql = sql & " order by 1"
	rs.open sql, cnn
	if not rs.eof then 
	   While not rs.eof   
			%>
			<tr>
			
			  <td class="celula"><%=left(rs("turno"),30)%> </td>
				<td align="center" class="celula"><%=rs("alunos")%></td>			
			  </tr>
			<%	
			contAluno = contAluno + rs("alunos")
			rs.movenext
		wend
		%>
			  <td class="celula"><strong>TOTAL DE ALUNOS</strong></td>
				<td align="center" class="celula"><strong><%=contAluno%></strong></td>			
			  </tr>
		<%
	else
		%>
		  <tr>
			<td colspan="3" class="celula" align="center"><br><br><br><br><font color="#993300"><%=session("strMensagemRelatorioNaoEncontrado")%></font></td>
		  </tr>
		<%
	end if
	rs.close
	%>
</table>

<script>
	aguarde.style.display="none";
</script>
</body>
</html>
