<%
response.Expires=0
'Não armazena a página em buffer antes de mostra-la na tela'
response.Buffer = false
%>
<!--
	::	DESENVOLVIDO POR "RS SOLUÇÕES WEB - www.rssolucoesweb.com.br"
	::	Data de Criação...: 10/03/2008
	::	Desenvolvedores...: Roberto Barbosa - roberto@rssolucoesweb.com.br
	::	Objetivo Pagina...: Relatorio Extrato do Evento
-->
<html>
<head>
<title><%=session("Titulo")%> - Frequência do Envento</title>
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
	
	strCodAluno				= Trim(Request("txtCodAluno"))
	strclasse               = Trim(Request.Form("cmbTamanhoFonteArial"))
	strSimouNao             = Trim(Request.Form("cmbSimouNao")) 
	
	if strCodAluno = "" then
		strCodAluno			=	Trim(Request.form("chkAluno"))
	end if
	
	
	strTituloRelatorio  	= "EXTRATOS DE ATIVIDADES COMPLEMENTARES <br>"
	
	if strCodAluno <> "" then   
		vetCodAluno = split(strCodAluno,",")			 
	end if
		
	
	sub mostraCabecalho()
	%>
	
	<!--#include file="../../includes/inc_cabecalhoRelatorio.asp"-->
	<!--#include file="../includes/inc_sqlDadosAlunoDiscriminado.asp"-->
	<table width="100%" border="0">
  	<tr>
    <td align="center">
	<table width="98%" border="0" cellspacing="0" cellpadding="0" class="tabela">
	  <tr bgcolor="#CCCCCC">
		<td width="7%" align="center" class="<%=strclasse%>"><strong>Ano/Sem</strong></td>
		<td width="65%" class="<%=strclasse%>"><strong>Evento Realizado </strong></td>
		<td width="17%" align="center" class="<%=strclasse%>"><p><strong> C.H Cumprida</strong></p></td>
		</tr>
	<%
	end Sub
	
	sub fimTabela()
		response.Write("</table>")
	end Sub
%>
<%
	intPagina = 1
	
	for intContador = 0 to ubound(vetCodAluno)
	
	intCodAluno			= trim(vetCodAluno(intContador))
	mostraCabecalho
	
	cont = 0
	intTotalCargaHoraria = 0 
	intTotalFrequenciaCH = 0 
	
		'
	' Verificando a alocação do aluno
	sql = "SELECT TOP 1 SCA_CURSO.Cod_Curso, SCA_TURMA.COD_SEMESTRE, SCA_TURMA.COD_TURMA, SCA_TURMA.ANOLETIVO, SCA_GRADECURRICULAR.COD_AGRUPAMENTO, SCA_TURMA.Cod_GradeCurricular, SCA_GRADECURRICULAR.AnoReferencia, SCA_GRADECURRICULAR.SemestreReferencia, SCA_TURMA.Nometurma "
	sql = sql & " FROM SCA_ALUNO_TURMA " 
	sql = sql & " INNER JOIN SCA_ALUNO ON SCA_ALUNO_TURMA.COD_ALUNO = SCA_ALUNO.CODIGO " 
	sql = sql & " INNER JOIN SCA_TURMA ON SCA_ALUNO_TURMA.COD_TURMA = SCA_TURMA.Cod_Turma  AND SCA_ALUNO_TURMA.ANO_LETIVO = SCA_TURMA.AnoLetivo AND SCA_ALUNO_TURMA.SEMESTRE = SCA_TURMA.Cod_Semestre AND SCA_ALUNO_TURMA.cod_empresa = SCA_TURMA.cod_empresa "
	sql = sql & " INNER JOIN SCA_GRADECURRICULAR ON SCA_TURMA.Cod_GradeCurricular = SCA_GRADECURRICULAR.Cod_GradeCurricular INNER JOIN SCA_PERIODO ON SCA_PERIODO.Cod_Periodo = SCA_GRADECURRICULAR.Cod_Periodo "
	sql = sql & " and SCA_PERIODO.cod_empresa = SCA_GRADECURRICULAR.cod_empresa "
	sql = sql & " INNER JOIN SCA_CURSO ON SCA_CURSO.Cod_Curso = SCA_PERIODO.Cod_Curso and SCA_CURSO.cod_empresa = SCA_PERIODO.cod_empresa "
	sql = sql & " where SCA_TURMA.cod_empresa = " & Session("CodEmpresa")
	sql = sql & " and 	SCA_ALUNO.CODIGO = " & intCodAluno
	sql = sql & " order by SCA_ALUNO_TURMA.CODIGO DESC "
	rs.open sql, cnn
	if not rs.eof then
	   	intCodCurso   					= rs("cod_curso") 
	   	intCodTurma    					= rs("COD_TURMA")
		intCodGradeagrupamento          = rs("COD_AGRUPAMENTO")
		if intsemestre = "0" then
	   	   intSemestre    = rs("COD_SEMESTRE")
		end if
	    if intAnoLetivo = "" then   
	 	   intAnoLetivo   = rs("ANOLETIVO")
		end if 
		if isnull(rs("COD_AGRUPAMENTO")) then
			%>
			<script>
				alert("ATENÇÃO: Código de agrupamento não vinculado a grade curricular n. <%=trim(rs("Cod_GradeCurricular") & " - " & rs("AnoReferencia") & "/" & rs("SemestreReferencia"))%> turma <%=trim(rs("Nometurma"))%>, procure a Secretaria Geral.");
				window.history.back();
			</script>
			<%
		end if
	else
		%>
        <script>
			alert("ATENÇÃO: O Aluno ainda não foi alocado em uma turma, verifique!");
			window.history.back();
		</script>
        <%
	end if
	rs.close

	sql = "SELECT ED.CODIGO, ED.COD_CURSO, ED.COD_DISCIPLINA, ED.CARGA_HORARIA, D.DESC_DISCIPLINA "
	sql = sql & " FROM SCA_EVENTO_DISCIPLINA ED "
	sql = sql & " INNER JOIN SCA_DISCIPLINA D ON D.COD_DISCIPLINA = ED.COD_DISCIPLINA AND D.COD_EMPRESA = ED.COD_EMPRESA "
	sql = sql & " WHERE ED.COD_EMPRESA = " & Session("CodEmpresa")	
	sql = sql & " AND ED.COD_CURSO = " & intCodCurso			
	sql = sql & " AND ED.COD_AGRUPAMENTO = " & intCodGradeagrupamento			
	sql = sql & " Order by D.DESC_DISCIPLINA"
	rs.open sql, cnn
	if rs.eof = false then
	   	if isnull(rs("cod_curso")) or rs("cod_curso") = "" or rs("cod_curso") = "0" then
		  	%>
        	<script>
				alert("ATENÇÃO: Valor Inválido para a Carga Horária, verifique!");
				window.history.back();
			</script>
        	<%
	   	end if

		strCargaHorariaCurricular	    = rs("CARGA_HORARIA")
		strDesc_Disciplina		        = rs("DESC_DISCIPLINA")

	else
		%>
        <script>
			alert("ATENÇÃO: Disciplina Complementar ainda não foi Cadastrada, verifique!");
			window.history.back();
		</script>
        <%
	end if 
	rs.close

	
	sql = " Select EV.Ano_letivo, EV.Semestre, EV.Evento, EV.CargaHoraria, FR.FrequenciaCH, FR.Descricao_Evento  "
	sql = sql & " From SCA_SEMINARIO_EVENTO_FREQUENCIA FR "
	sql = sql & " inner join SCA_SEMINARIO_EVENTO EV on  EV.Codigo = FR.Cod_Seminario_Evento "
	sql = sql & " Where Cod_empresa = " & session("CodEmpresa")
	sql = sql & " And Cod_Aluno = " & intCodAluno
	sql = sql & " order by EV.Ano_letivo, EV.Semestre, FR.Descricao_Evento "
	rs.open sql, cnn
	if rs.eof = false then

	while not rs.eof
	
		intTotalCargaHoraria = intTotalCargaHoraria + rs("CargaHoraria")
		intTotalFrequenciaCH = intTotalFrequenciaCH + rs("FrequenciaCH")
	  %>
	  <tr>
	    <td class="<%=strclasse%>" align="center"><%=rs("Ano_letivo")%>/<%=rs("Semestre")%>&nbsp;</td>
	    <td class="<%=strclasse%>" align="left"><%=rs("Evento")%></td>
	    <td align="center" class="<%=strclasse%>"><%=rs("FrequenciaCH")%></td>
	    </tr>
	  <% if strSimouNao = "S" and trim(rs("Descricao_Evento"))<>"" then %>	
	     <tr>
		   <td class="<%=strclasse%>" align="center">&nbsp;</td>
		   <td colspan="2" align="left" class="<%=strclasse%>">Atividade:&nbsp;<%=rs("Descricao_Evento")%> </td>
		   </tr>
	  <% end if	   
	  rs.movenext
	wend
	
			strAproveitamento  = (intTotalFrequenciaCH * 100)/strCargaHorariaCurricular
			strNota = (strAproveitamento / 10)

		%>
		  <tr>
		    <td height="24" colspan="4" class="<%=strclasse%>" align="center">
			<table width="33%" border="0">
              <tr>
                <td width="62%">Carga Horaria de Eventos : </td>
                <td width="38%"><%=strCargaHorariaCurricular%>h&nbsp;</td>
              </tr>
              <tr>
                <td>Carga Horaria Cumprida : </td>
                <td><%=intTotalFrequenciaCH%>h</td>
              </tr>
              <tr>
                <td>Aproveitamento : </td>
                <td><%=formatnumber(strAproveitamento,0)%>%</td>
              </tr>
              <tr>
                <td>Nota : </td>
                <td><%=formatnumber(strNota,1)%></td>
              </tr>
            </table></td>
	    </tr>
		 <%
	else
		%>
		  <tr>
			<td colspan="4" class="<%=strclasse%>" align="center"><br><br><br><br><font color="#993300"><%=session("strMensagemRelatorioNaoEncontrado")%></font></td>
		  </tr>
		<%
	end if
	rs.close
	
	intPagina = intPagina + 1
%>
</table>

<%if  ubound(vetCodAluno) then %>
<pre></pre>
<%end if %>
<%next
%>

	</td>
  </tr>
</table>

<script>
	aguarde.style.display="none";
</script>
</body>
</html>
