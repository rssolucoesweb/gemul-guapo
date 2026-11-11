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
<script src="../../js/js_barra_movel.js"></script></head>
<body>
<p>
  <!--#include file="../../includes/inc_verificaSession.asp"-->
  <!--#include file="../../includes/inc_cnn.asp"-->
  <!--#include file="../../includes/inc_formatadata.asp"-->
  <!--include file="../../includes/inc_Botoes_relatorio.asp"-->
  <!--#include file="../../includes/inc_aguarde.asp"-->
  <br>
  <%
	dim intPagina
	
	intCodAvaliacaoInstitucional   	= Trim(Request.Form("cmbAvaliacaoInstitucional"))
	intCodCurso        	            = Trim(Request.Form("cmbCurso"))
	intCodDisciplina                = Trim(Request.Form("cmbDisciplina"))
	strQuestaoInicial         	    = Trim(Request.Form("txtQuestaoInicial"))
	strQuestaoFinal               	= Trim(Request.Form("txtQuestaoFinal"))
	strTituloRelatorio  	=  " Resumo Quantitativo por Avaliação "

	sub mostraCabecalho()
%>
  <!--#include file="../../includes/inc_cabecalhoRelatorio.asp"-->
</p>
<table "91%" border="0" align="center" cellpadding="0" cellspacing="0">
  <tr>
    <td width="112" class="texto2" height="23" align="center">(<strong>A</strong>) Excelente</td>
    <td width="111" class="texto2" align="center">(<strong>B</strong>) Muito Bom</td>
    <td width="87"  class="texto2" align="center">(<strong>C</strong>) Bom </td>
    <td width="114" class="texto2" align="center">(<strong>D</strong>) Regular</td>
    <td width="111" class="texto2" align="center">(<strong>E</strong>) Insuficiente</td>
  </tr>
  <tr>
    <td height="21" colspan="8" class="texto2" align="center"><strong><%=strNomeAvaliacao%></strong></td>
  </tr>
</table>
<table width="100%" border="0" cellspacing="0" cellpadding="0" class="tabela">
	  <tr bgcolor="#CCCCCC">
	    <% if intCodCurso <> "" and  intCodCurso <> "0" then %> 
	       <td colspan="16" class="celula"><div align="center"><strong><%=rs("descricao")%></strong> - Participantes: <strong><%=intRealizadas%></strong></div></td>
		<% else %>
        <td width="22%" colspan="16" class="celula"><div align="center">Participantes: <strong><%=intRealizadas%></strong></div></td>
		<% end if %>
     </tr>
	  <tr bgcolor="#CCCCCC">
		<td width="5%" class="celula"><div align="center"><strong>Turma</strong></div></td>
		<td width="19%" class="celula"><div align="center"><strong>Disciplina</strong></div></td>
		<td width="16%" class="celula"><div align="center"><strong>Docente</strong></div></td>
		<td width="24%" class="celula"><div align="center"><strong>Coment&aacute;rio</strong></div></td>
	  </tr>
	<%
	end Sub
	
	sub fimTabela()
		response.Write("</table>")
	end Sub
%>
<%
	intPagina = 1
	intQtdeRegistroPorPagina = 1
	cont = 0
	
	if intCodAvaliacaoInstitucional <> "" then 
	   sql = "SELECT Codigo, Cod_empresa, Descricao, Ano_Letivo, Semestre, Tipo_Avaliacao, Tipo_Consulta"
	   sql = sql & " FROM SAV_AVALIACAO_INSTITUCIONAL"
	   sql = sql & " Where Codigo = " & intCodAvaliacaoInstitucional
	   sql = sql & " And cod_empresa = " & Session("CodEmpresa")			
	   rs.open sql, cnn
	   if rs.eof = false then
		  intCodAvaliacao		= rs("Codigo")
		  strNomeAvaliacao		= rs("Descricao")
		  intAnoLetivo			= rs("Ano_Letivo")
		  intSemestre			= rs("Semestre")
		  intTipoAvaliacao		= rs("Tipo_Avaliacao")
		  intTipoConsulta		= rs("Tipo_Consulta")
	   end if 
	   rs.close
	   
	   sql = " select distinct cod_aluno from SAV_AVALIACAO_PERGUNTA_NOTA sav "
   	   sql = sql & " inner join sca_Turma t on t.Cod_turma = sav.Cod_turma "
	   sql = sql & " inner join sca_GradeCurricular g on g.cod_gradecurricular = t.cod_gradecurricular and g.cod_empresa = t.cod_empresa "
	   sql = sql & " inner join sca_Periodo p on p.cod_periodo = g.cod_periodo and p.cod_empresa = g.cod_empresa "
	   sql = sql & " inner join sca_curso c on c.cod_curso = p.cod_curso "
       sql = sql & " where codAvaliacao = " & intCodAvaliacaoInstitucional
	   if intCodCurso <> "" and intCodCurso <> "0" then
	      sql = sql & " and c.cod_curso = " & intCodCurso
	   end if 
	   sql = sql & " and isnull(resposta, '0') <> '0'"
	   rs.open sql, cnn
	   rs.close
	   '
       sql = " select top 1 @@rowcount as Realizadas from SAV_AVALIACAO_PERGUNTA_NOTA sav "
   	   sql = sql & " inner join sca_Turma t on t.Cod_turma = sav.Cod_turma "
	   sql = sql & " inner join sca_GradeCurricular g on g.cod_gradecurricular = t.cod_gradecurricular and g.cod_empresa = t.cod_empresa "
	   sql = sql & " inner join sca_Periodo p on p.cod_periodo = g.cod_periodo and p.cod_empresa = g.cod_empresa "
	   sql = sql & " inner join sca_curso c on c.cod_curso = p.cod_curso "
       sql = sql & " where codAvaliacao = " & intCodAvaliacaoInstitucional
 	   if intCodCurso <> "" and intCodCurso <> "0" then
	      sql = sql & " and c.cod_curso = " & intCodCurso
	   end if
   	   sql = sql & " and isnull(resposta, '0') <> '0'"
	   rs.open sql, cnn
	   if rs.eof = false then
		  intRealizadas		= rs("Realizadas")
	   else
	   	  intRealizadas     = 0
	   end if 
	   rs.close
	   '
	   if intTipoAvaliacao = "1" then
	      sql = "select sav.codAvaliacao, t.cod_turma, t.nometurma, c.cod_curso, c.descricao, d.cod_disciplina, d.desc_disciplina, sav.cod_disciplina, sav.conceito, count(sav.conceito)as total, resposta "
	   else  
 	      sql = "select sav.codAvaliacao, t.cod_turma, t.nometurma, c.cod_curso, c.descricao, sav.conceito, count(sav.conceito)as total, resposta "
       end if
	   sql = sql & " from SAV_AVALIACAO_PERGUNTA_NOTA SAV "
	   sql = sql & " inner join sca_Turma t on t.Cod_turma = sav.Cod_turma "
	   sql = sql & " inner join sca_GradeCurricular g on g.cod_gradecurricular = t.cod_gradecurricular and g.cod_empresa = t.cod_empresa "
	   sql = sql & " inner join sca_Periodo p on p.cod_periodo = g.cod_periodo and p.cod_empresa = g.cod_empresa "
	   sql = sql & " inner join sca_curso c on c.cod_curso = p.cod_curso "
	   if intTipoAvaliacao = "1" then
          sql = sql & " inner join sca_disciplina d on d.cod_disciplina = sav.cod_disciplina and d.cod_empresa = g.Cod_empresa "
	   end if	  
	   sql = sql & " where sav.codAvaliacao = " & intCodAvaliacaoInstitucional
	   sql = sql & " and isnull(resposta, '0') <> '0'"
	   if intCodCurso <> "" and intCodCurso <> "0" then
	      sql = sql & " and c.cod_curso = " & intCodCurso
	   end if   
	   if intCodDisciplina <> "" and intCodDisciplina <> "0" and intTipoAvaliacao = "1" then
	      sql = sql & " and sav.cod_disciplina = " & intCodDisciplina
	   end if   
  	   if strLetraInicial <> "" and strLetraFinal <> "" then
	      sql = sql & " and SUBSTRING(NomeAluno,1,1) >= '" & strQuestaoInicial & "'"
	      sql = sql & " and SUBSTRING(NomeAluno,1,1) <= '" & strQuestaoFinal & "'"
	   end If 
 	   if intTipoAvaliacao = "1" then
	      sql = sql & " group by sav.codAvaliacao, t.cod_turma, t.nometurma, c.cod_curso ,c.descricao, d.cod_disciplina, d.desc_disciplina, sav.cod_disciplina, sav.conceito, resposta "
	   else
	      sql = sql & " group by sav.codAvaliacao, t.cod_turma, t.nometurma, c.cod_curso ,c.descricao,  sav.conceito, resposta "
	   end if
	end if
	rs.open sql, cnn
	if not rs.eof then
       mostraCabecalho
       While not rs.eof
		   if intTipoAvaliacao = "1" then
              strnometurmaDisciplina = trim(rs("nometurma")) & trim(rs("desc_disciplina")) & trim(rs("descricao"))
		      intCodDisciplinaTurma = trim(rs("cod_disciplina"))
		   else
              strnometurmaDisciplina = trim(rs("nometurma")) & trim(rs("descricao"))
		      intCodDisciplinaTurma = "0"
		   end if	  
		   intCodTurma = trim(rs("cod_turma"))
		   '
	   	   sql = "SELECT DISTINCT SRH_COLABORADOR.NOME AS COLABORADOR"
		   sql = sql & " FROM SCA_HORARIO_AULA"
		   sql = sql & " INNER JOIN SRH_COLABORADOR ON SRH_COLABORADOR.CODIGO = SCA_HORARIO_AULA.COD_COLABORADOR"
		   sql = sql & " WHERE	SCA_HORARIO_AULA.ANOLETIVO=" & intAnoLetivo
		   sql = sql & " AND		SCA_HORARIO_AULA.SEMESTRE=" & intSemestre
		   sql = sql & " AND		SCA_HORARIO_AULA.COD_TURMA=" & intCodTurma
		   sql = sql & " AND		SCA_HORARIO_AULA.COD_DISCIPLINA=" & intCodDisciplinaTurma
		   rsaux.open sql, cnn
		   if not rsaux.eof then 
		      strProfessor = rsaux("COLABORADOR")
		   else
		      strProfessor = "********"
		   end if
		   rsaux.close
		   %>
		   <tr>
		   <td class="celula" align="center"><%=rs("nometurma")%>&nbsp;</td>
		   <%if intTipoAvaliacao = "1" then %>
		        <td align="center" class="celula"><%=rs("desc_disciplina")%>&nbsp;</td>
		   <%else%>
		        <td align="center" class="celula">********</td>
		   <%end if%>	 
		   <td align="center" class="celula"><%=strProfessor%></td>
		   <td width="2%" align="center" class="celula"><%=rs("resposta")%>&nbsp;</td>
		   <tr>
		   <%
		   '
	       'quantidade de registros da página
	 	   if intQtdeRegistroPorPagina = 50 then
	          intPagina = intPagina + 1
		      intQtdeRegistroPorPagina = 1
		      fimTabela
		      %>
		      <pre> </pre>				
		      <%			
	          mostraCabecalho
 			end if
	        cont = cont + 1
		    intQtdeRegistroPorPagina = intQtdeRegistroPorPagina + 1
			rs.movenext
		wend
        %> 
		<tr>
		<td colspan="16" class="celula">Quantidade de Registros: <%=cont%></td>
		</tr>
		 <%
	else
		%>
		<tr>

		<td colspan="16" class="celula" align="center"><p><font color="#993300"><%=session("strMensagemRelatorioNaoEncontrado")%></font></p>
		  </td>
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
