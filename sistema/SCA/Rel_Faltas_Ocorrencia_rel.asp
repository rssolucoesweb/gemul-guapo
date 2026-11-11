<%
response.Expires=0
'Não armazena a página em buffer antes de mostra-la na tela'
response.Buffer = false
%>
<!--
	::	DESENVOLVIDO POR "RS SOLUÇÕES WEB - www.rssolucoesweb.com.br"
	::	Data de Criação...: 13/02/2008
	::	Desenvolvedores...: Sergio Borges - sergiob76@hotmail.com
	::	Objetivo Pagina...: Extrato de Notas/Ocorrencia
-->
<html>
<head>
<title><%=session("Titulo")%> - Alunos</title>
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
<!--#include file="../../includes/inc_aguarde.asp"-->
<br>
<%
	dim intPagina
	dim strInfoTurma
	strExecutarSubmitCurso	  = "S"
	strExecutarSubmitPeriodo  = "S"
	strExecutarSubmitSemestre = "S"
	strExecutarSubmitTurno	  = "S"
	strExecutarSubmitTurma	  = "S"
	
    strCodAluno			    = Trim(Request("txtCodAluno"))
	if  Trim(Request("chkAluno"))<>"" then
		strCodAluno = Trim(Request("chkAluno"))
	end if
	strPeriodoInicial					= Trim(Request.Form("txtPeriodoInicial"))	
	strPeriodoFinal						= Trim(Request.Form("txtPeriodoFinal"))	
	intCodTurma							= Trim(Request.Form("cmbTurma"))	
	strAnoLetivo 						= Trim(Request.Form("txtAnoLetivo"))
	if strAnoLetivo = "" then 	strAnoLetivo = session("strAnoLetivo")
	intSemestre 			= Trim(Request.Form("cmbSemestre"))
	if intSemestre = "" then 	intSemestre  = session("strSemestre")

	if intCodSemestre = "" then intCodSemestre = "0"

	strClasse = "celula"
	
sub mostraAluno(strNomeAluno, strMatricula, strNomeTurma, strDescricaoTurno, strSituacaoaluno, strDescricaoCurso, strDescricaoPeriodo)

	%>
	<br>
	<table width="90%" border="0" cellspacing="0" cellpadding="0" align="center">

        <tr>
        <td colspan="4"><div align="center"><strong>Dados referente: <%=strAnoLetivo%>  </strong></div></td>
        </tr>
      <tr>
        <td width="8%">Aluno(a):</td>
        <td width="63%">&nbsp;<strong><%=strNomeAluno%></strong></td>
        <td width="14%">Matr&iacute;cula:</td>
        <td width="15%">&nbsp;<strong><%=strMatricula%></strong></td>
      </tr>
      <tr>
        <td>Curso:</td>
        <td>&nbsp;<strong><%=strDescricaoCurso%></strong></td>
        <td>Turma:</td>
        <td>&nbsp;<strong><%=strNomeTurma%></strong></td>
      </tr>
      <tr>
        <td>Per&iacute;odo:</td>
        <td>&nbsp;<strong><%=strDescricaoPeriodo%></strong></td>
        <td>Turno:</td>
        <td>&nbsp;<strong><%=strDescricaoTurno%></strong></td>
      </tr>
    </table>
      
	<%
	end Sub
	sub mostraCabecalho(strNomeAluno, strMatricula, strNomeTurma, strDescricaoTurno, strSituacaoaluno, strDescricaoCurso, strDescricaoPeriodo)
	%>
	<!--#include file="../../includes/inc_cabecalhoRelatorio.asp"-->
    <br>
    <%
    mostraAluno strNomeAluno, strMatricula, strNomeTurma, strDescricaoTurno, strSituacaoaluno, strDescricaoCurso, strDescricaoPeriodo
	%>
	<br>
	<table width="100%" border="0" cellspacing="0" cellpadding="0" class="tabela">
	  <tr bgcolor="#CCCCCC">
		<td width="10%" class="<%=strclasse%>"><div align="center"><strong>Data/Falta</strong></div></td>
		<td width="51%" class="<%=strclasse%>"><div align="center"><strong>Ocorrência</strong></div></td>
		<td width="22%" class="<%=strclasse%>"><div align="center"><strong>Usuário</strong></div></td>
		<td width="17%" class="<%=strclasse%>"><div align="center"><strong>Atualização</strong></div></td>
	  </tr>
      
	<%
	end Sub
	sub fimTabela()
		response.Write("</table>")
	end Sub

	strlpp = 40
	
	sql = "select f.*, a.nomealuno, a.matricula"
	sql = sql & " from [dbo].[SCA_OCORRENCIA_FALTAS] f "
	sql = sql & " inner join sca_aluno a on a.codigo = f.cod_aluno"
	sql = sql & " where a.cod_empresa = " & session("CodEmpresa")	
	sql = sql & " and a.codigo in (" & strCodAluno & ")"
	if strPeriodoInicial<>"" and strPeriodoFinal<>"" then
		sql = sql & " and f.dataocorrencia between '" & formatadataBD(strPeriodoInicial)& "' and '" & formatadataBD(strPeriodoFinal)& "'"
		periodo = "<font color='#0000CC' size='-1'>" & formatadataAP(strPeriodoInicial)& " a " & formatadataAP(strPeriodoFinal) & "</font>"
	end if
	sql = sql & " order by a.nomealuno, f.DATAOCORRENCIA"
	'response.Write(sql)
	rs.open sql, cnn
	if not rs.eof then 
		
		cont = 0
		strMatricula = ""
		While not rs.eof
			intCodAluno = rs("cod_Aluno")
			if strMatricula<>rs("matricula") then
				if cont <> 0 then
					intPagina = intPagina + 1
					intQtdeRegistroPorPagina = 1
					fimTabela
					%>
					<pre></pre>				
					<%
				end if
				
				strNome 		 = rs("nomealuno")
				strMatricula 	 = rs("matricula")	
				
				sql = "SELECT SCA_ALUNO_TURMA.CODIGO AS CODALUNOTURMA, NOMETURMA, "
				sql = sql & " SCA_ALUNO.NOMEALUNO, SCA_ALUNO_TURMA.SEQUENCIA, SCA_ALUNO_TURMA.COD_TURMA, "
				sql = sql & " SCA_GRADECURRICULAR.Cod_Periodo, SCA_SITUACAOALUNO.Desc_SituacaoAluno, TUR.Desc_Turno, SCA_PERIODO.Descricao AS DESC_PERIODO , SCA_CURSO.Descricao"
				sql = sql & " FROM SCA_ALUNO_TURMA "
				sql = sql & " INNER JOIN SCA_ALUNO ON SCA_ALUNO_TURMA.COD_ALUNO = SCA_ALUNO.CODIGO "
				sql = sql & " INNER JOIN SCA_TURMA ON SCA_ALUNO_TURMA.COD_TURMA = SCA_TURMA.Cod_Turma "
				sql = sql & " INNER JOIN SCA_GRADECURRICULAR ON SCA_TURMA.Cod_GradeCurricular = SCA_GRADECURRICULAR.Cod_GradeCurricular"
				sql = sql & " INNER JOIN SCA_PERIODO ON SCA_PERIODO.Cod_Periodo = SCA_GRADECURRICULAR.Cod_Periodo"
				sql = sql & " INNER JOIN SCA_CURSO ON SCA_CURSO.Cod_CURSO = SCA_PERIODO.Cod_CURSO"				
				sql = sql & " INNER JOIN SCA_SITUACAOALUNO ON SCA_SITUACAOALUNO.Cod_SituacaoAluno = SCA_ALUNO.COD_SITUACAOALUNO"
				sql = sql & " INNER JOIN SCA_TURNO TUR ON TUR.Cod_TURNO = SCA_TURMA.Cod_TURNO"
				sql = sql & " where SCA_TURMA.cod_empresa = " & Session("CodEmpresa")			
				sql = sql & " and 	SCA_ALUNO_TURMA.COD_TURMA = " & intCodTurma
				sql = sql & " and	SCA_ALUNO_TURMA.situacao = 'A'"
				sql = sql & " AND   SCA_ALUNO.CODIGO =" & intCodAluno
				rsaux.open sql, cnn
				if not rsaux.eof then
					strNomeAluno 	 = strNome
					strNomeTurma 	 = rsaux("NOMETURMA")
					strDescricaoTurno= rsaux("DESC_TURNO")
					strSituacaoaluno = rsaux("DESC_SITUACAOALUNO")
					strDescricaoCurso = rsaux("Descricao")
					strDescricaoPeriodo = rsaux("DESC_PERIODO")
				end if
				rsaux.close

				strTituloRelatorio  	= "FALTAS/OCORRÊNCIAS<br>" & periodo
				
				intPagina = 1
				
				mostraCabecalho strNomeAluno, strMatricula, strNomeTurma, strDescricaoTurno, strSituacaoaluno, strDescricaoCurso, strDescricaoPeriodo
				
			end if
			%>
			  <tr>
				<td class="<%=strclasse%>" align="left"><%=formatadataAP(rs("dataocorrencia"))%>&nbsp;</td>
				<td class="<%=strclasse%>" align="left"><%=rs("OCORRENCIA")%>&nbsp;</td>
				<td class="<%=strclasse%>" align="left"><%=rs("USUARIO_INCL")%>&nbsp;</td>
			    <td class="<%=strclasse%>" align="left"><%=rs("DATA_HORA_INCL")%>&nbsp;</td>
			  </tr>
			<%
			'quantidade de registros da página
			if int(intQtdeRegistroPorPagina) = int(strlpp) then
				 intPagina = intPagina + 1
				 intQtdeRegistroPorPagina = 1
				 fimTabela
				%>
				<pre>&nbsp;</pre>				
				<%			
				mostraCabecalho
			end if	
			cont = cont + 1
			intQtdeRegistroPorPagina = intQtdeRegistroPorPagina + 1
			rs.movenext
		wend
	else
		mostraCabecalho
		%>
		  <tr>
			<td colspan="5" class="<%=strclasse%>" align="center"><br><br><br><br><font color="#993300"><%=session("strMensagemRelatorioNaoEncontrado")%></font></td>
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
