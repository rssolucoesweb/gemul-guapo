<%
response.Expires=0
'N?o armazena a p?gina em buffer antes de mostra-la na tela'
response.Buffer = false
server.ScriptTimeout = 5000
%>
<!--
	::	DESENVOLVIDO POR "RS SOLU??ES WEB - www.rssolucoesweb.com.br"
	::	Data de Cria??o...: 13/02/2008
	::	Desenvolvedores...: Sergio Borges - sergiob76@hotmail.com
	::	Objetivo Pagina...: Extrato de Notas
-->
<html>
<head>
<title><%=session("Titulo")%> - Aluno/nomes iguais</title>
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
<!--#include file=../../includes/inc_aguarde.asp-->
<br>
<%
	dim intPagina
	dim vetAlunosPeriodo
	
	intAnoLetivoAtual	 	= Trim(Request.Form("txtAnoLetivo"))
	intSemestreAtual	 	= Trim(Request.Form("cmbSemestre"))
	intCodSituacaoAluno		= Trim(Request.Form("cmbSituacaoAluno"))
	'intCodEmpresaGrupo		= Trim(Request.Form("cmbEmpresaGrupo"))
		
	strFiltroSerie = "0"
	strFiltroTurno = "0"
	
	dim strAnoCab
	strAnoCab = intAnoLetivoAtual
	
	if intCodSituacaoAluno <> "" then
	
		sql = "SELECT COD_SITUACAOALUNO, DESC_SITUACAOALUNO"
		sql = sql & " FROM SCA_SITUACAOALUNO"
		sql = sql & " WHERE COD_SITUACAOALUNO=" & intCodSituacaoAluno
		rs.open sql, cnn
		if rs.eof = false then
			strSITUACAOALUNO 		= Trim(rs("DESC_SITUACAOALUNO"))
		end if
		rs.close
	end if
	
	if strSITUACAOALUNO <> "" then
		strTituloRelatorio  	= "RELAÇÃO DE ALUNOS "& strSITUACAOALUNO &" / NOMES IGUAIS"
	else
		strTituloRelatorio  	= "RELAÇÃO DE ALUNOS / NOMES IGUAIS"
	end if
	
	sql = " set nocount on create table #temp (nome varchar(200), cod_empresa int, unidade varchar(200), linhas int)"

	sql = sql & " insert #temp"
	sql = sql & " SELECT "
	sql = sql & "     A.NOMEALUNO,"
	sql = sql & "     CC.COD_EMPRESA,"
	sql = sql & "     CC.UNIDADE,0"
	sql = sql & " FROM SCA_ALUNO A"
	sql = sql & " OUTER APPLY ("
	sql = sql & "     SELECT TOP 1"
	sql = sql & "         C.COD_EMPRESA,"
	sql = sql & "         C.COD_SITUACAOALUNO,"
	sql = sql & "         E.RAZAOSOCIAL AS UNIDADE, C.ANO_LETIVO"
	sql = sql & "     FROM SCA_CONTROLE_SITUACAO_ALUNO C"
	sql = sql & "     INNER JOIN SEG_EMPRESA E ON E.CODIGO = C.COD_EMPRESA"
	sql = sql & "     WHERE "
	sql = sql & "         C.COD_ALUNO = A.CODIGO"
	sql = sql & "         AND C.ANO_LETIVO <= " & trim(session("strAnoLetivo"))
	sql = sql & "     ORDER BY C.CODIGO DESC"
	sql = sql & " ) CC"
	sql = sql & " left JOIN SCA_SITUACAOALUNO SA "
	sql = sql & "     ON SA.Cod_SituacaoAluno = CC.COD_SITUACAOALUNO"
	sql = sql & " where 1=1"
	if trim(strSITUACAOALUNO) <> "" then
		sql = sql & " and SA.desc_situacaoaluno = '" & trim(strSITUACAOALUNO) & "'"
	end if	
	
	sql = sql & " and a.nomealuno in (select a.nomealuno"
	sql = sql & " 					from sca_aluno a"
	sql = sql & " 					inner join sca_situacaoaluno s on s.cod_situacaoaluno = a.cod_situacaoaluno where 1=1"
	if trim(strSITUACAOALUNO) <> "" then	
		sql = sql & " 					and s.desc_situacaoaluno = '" & trim(strSITUACAOALUNO) & "'"
	end if
	sql = sql & " 					group by a.nomealuno, s.desc_situacaoaluno"
	sql = sql & " 					having count(*)>1"
	sql = sql & " 					)"

	sql = sql & " create table #linhas (nome varchar(200), linhas int)"

	sql = sql & " insert #linhas"
	sql = sql & " select distinct nome, count(*)"
	sql = sql & " from #temp"
	sql = sql & " group by nome"

	sql = sql & " update t set t.linhas = l.linhas"
	sql = sql & " from #temp t"
	sql = sql & " inner join #linhas l on l.nome = t.nome"

	sql = sql & " select *, "
	sql = sql & " ("
	sql = sql & " 	select top 1 isnull(a.mae,'') + "
	sql = sql & " 	case"
	sql = sql & " 		when isnull(a.foneresidencial,'') = isnull(a.fonecelular,'') then ' | ' + isnull(a.fonecelular,'')"
	sql = sql & " 		when isnull(a.foneresidencial,'') = '(62) 0000-0000' then ' '"
	sql = sql & " 		when isnull(a.fonecelular,'') = '(62) 0000-0000' then ' '"
	sql = sql & " 		else isnull(a.foneresidencial,'') + ' | ' + isnull(a.fonecelular,'')"
	sql = sql & " 		end as mae"
	sql = sql & " 	from sca_aluno a"
	sql = sql & " 	where a.nomealuno = t.nome "
	sql = sql & " ) as mae "
	sql = sql & " from #temp t "
	sql = sql & " order by t.nome"
	
	
	
	vetAlunos = null
	rs.open sql, cnn
	if not rs.eof then
		vetAlunos = rs.getRows
	end if
	rs.close
	if not isArray(vetAlunos) then
		%>
		<script>
			alert("ATENÇÃO FOI ENCONTRADO INFORMAÇÕES PARA ESSE RELATÓRIO!");
		</script>
		<%
	end if

		
	sub mostraCabecalho()
	%>
	<!--#include file="../../includes/inc_cabecalhoRelatorioGrupo.asp"-->
	<br>
		<%
	end Sub
	
	sub fimTabela()
		response.Write("</table>")
	end Sub
	
	intPagina = 1
	mostraCabecalho
	intTotalAlunoGeralTodos = 0
	strNome = ""
	cor = ""
	%>
    <table width="98%" border="0"  cellpadding="0" cellspacing="0" align="center" class="tabela">
      <tr> 
        <td width="35%" bgcolor="#CCCCCC" class="celula" align="center"><strong>ALUNO</strong></td>
        <td bgcolor="#CCCCCC" class="celula" align="center"><strong>UNIDADE</strong></td>
        <td bgcolor="#CCCCCC" class="celula" align="center"><strong>MÃE / TELEFONE</strong></td>
      </tr>
	  <%    	
		for y=0 to ubound(vetAlunos,2) %>
            
			<%if vetAlunos(0,y)<>strNome then%>
				<%
                if cor = "bgcolor='#D2E9FF'" then
                    cor = ""
                else
                    cor = "bgcolor='#D2E9FF'"
                end if
                %>

                <tr <%=cor%>>
                    <td class="celula"  rowspan="<%=vetAlunos(3,y)%>"><%=vetAlunos(0,y)%></td>
                    <td class="celula" ><%=vetAlunos(2,y)%></td>
                    <td class="celula" ><%=vetAlunos(4,y)%></td>
                </tr>
			<%else%>
                <tr <%=cor%>>
                    <td class="celula" ><%=vetAlunos(2,y)%></td>
                    <td class="celula" ><%=vetAlunos(4,y)%></td>
                </tr>
			<%end if%>
			<%
			strNome = vetAlunos(0,y)
			intTotalAlunoGeralTodos = intTotalAlunoGeralTodos + 1
        next
		%>
      <tr>
        <td colspan="3" bgcolor="#CCCCCC" class="celula"><strong>Registros listados: <%=intTotalAlunoGeralTodos%></strong></td>
      </tr>
	</table>

<script>
	aguarde.style.display="none";
</script>
</body>
</html>
