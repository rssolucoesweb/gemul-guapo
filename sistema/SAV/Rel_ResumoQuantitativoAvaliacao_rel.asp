<%
response.Expires=0
'Não armazena a página em buffer antes de mostra-la na tela'
response.Buffer = true
SESSION.Timeout = 1200
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
	intCodTurma 					= Trim(Request.Form("cmbTurma"))
	intCodDisciplinaTurma  			= trim(request("cmbDisciplinaTurma"))
	intCodDisciplinaTitulo			= trim(request("cmbDisciplinaTurma"))
	strQuestaoInicial         	    = Trim(Request.Form("txtQuestaoInicial"))
	strQuestaoFinal               	= Trim(Request.Form("txtQuestaoFinal"))
	strOpcaoGrafico                 = Trim(Request.Form("optOpcaoGrafico"))
	strSimouNao                     = Trim(Request.Form("cmbSimouNao"))
	strTituloRelatorio  			=  " Resumo Quantitativo por Avaliação "
    
	if intCodTurma = "" then intCodTurma = "0"
	if intCodDisciplinaTurma = "" then intCodDisciplinaTurma = "0"
	
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
<%
if strQuestaoInicial <> "" and strQuestaoFinal <> "" then
	sql = "SELECT Codigo, Cod_Avaliacao_Institucional, Subtitulo, Descricao, Tipo_Pergunta"
	sql = sql & " FROM SAV_AVALIACAO_PERGUNTA"
	sql = sql & " Where cod_empresa = " & Session("CodEmpresa")	
	sql = sql & " And Cod_Avaliacao_Institucional = " & intCodAvaliacaoInstitucional
	sql = sql & " and Codigo >=  " & strQuestaoInicial
  	sql = sql & " and Codigo <=  " & strQuestaoFinal
	sql = sql & " Order by Codigo"
	rs1.open sql, cnn
	if rs1.eof = false then
		%>
   		<table width = "100%" border="1" align="center" cellpadding="0" cellspacing="0" bordercolor="#CCCCCC" class="tabela">
        <tr bgcolor="#CCCCCC">
          <td colspan="3" class="celula"><div align="center">Quest&atilde;o(&otilde;es) Avaliada(s) </div></td>
          </tr>
        <tr bgcolor="#CCCCCC">
        <td class="celula"><strong>Cod.Quest&atilde;o</strong></td>
        <td class="celula"><strong>Descri<span class="TextoForm">&ccedil;&atilde;o</span></strong></td>
        <td align="center" class="celula"><strong>Tipo Pergunta <span class="TextoForm"></span></strong></td>
        </tr>
        <%
		
		while not rs1.eof
			if trim(rs1("Subtitulo")) <> "" then
			   %>
			   <tr bgcolor="#CCCCCC">
			   <td colspan="3" class="celula">&nbsp;&nbsp;<%=trim(rs1("Subtitulo"))%></td>
		       </tr>
			   <%
			end if   
			if trim(rs1("Tipo_Pergunta")) = "O" then
			   strTipoPergunta = "Objetiva" 
			elseif trim(rs1("Tipo_Pergunta")) = "D" then
			   strTipoPergunta = "Discursiva" 
			end if
			%>
			<tr>
			<td align="center" class="celula"><%=trim(rs1("Codigo"))%></td>
			<td class="celula"><%=trim(rs1("Descricao"))%></td>
			<td align="center" class="celula"><%=strTipoPergunta%></td>
			</tr>
			<%	
			rs1.movenext
		wend
	    %>
        </table>
        <%
	end if
	rs1.close
end if

if intCodCurso <> "" and intCodCurso <> "0" then
	sql = "SELECT DESCRICAO"
	sql = sql & " FROM SCA_CURSO"
	sql = sql & " Where cod_empresa = " & Session("CodEmpresa")
	sql = sql & " And cod_curso = " &  intCodCurso			
	rs1.open sql, cnn
	if rs1.eof = false then
	  strCurso	= rs1("DESCRICAO")
	else
	 strCurso	= "Erro!"
	end if 
	rs1.close
end if	


%>

<table width="100%" border="0" cellspacing="0" cellpadding="0" class="tabela">
	  <tr bgcolor="#CCCCCC">
	    <% if intCodCurso <> "" and  intCodCurso <> "0" then %> 
	       <td colspan="17" class="celula"><div align="center"><strong><%=strCurso%></strong> - Participantes: <strong><%=intRealizadas%></strong></div></td>
		<% else %>
	       <td colspan="17" class="celula"><div align="center">Participantes: <strong><%=intRealizadas%></strong></div></td>
		<% end if %>
     </tr>
	  <tr bgcolor="#CCCCCC">
		<td class="celula"><div align="center"><strong>Turma</strong></div></td>
		<td class="celula"><strong>Participantes</strong></td>
		<td class="celula"><div align="center"><strong>Disciplina</strong></div></td>
		<td class="celula"><div align="center"><strong>Docente</strong></div></td>
		<td class="celula"><div align="center"><strong>A</strong></div></td>
		<td class="celula"><div align="center"><strong>B</strong></div></td>
		<td class="celula"><div align="center"><strong>C</strong></div></td>
		<td class="celula"><div align="center"><strong>D</strong></div></td>
		<td class="celula"><div align="center"><strong>E</strong></div></td>
		<td class="celula"><div align="center"><strong>N</strong></div></td>
		<td class="celula"><div align="center"><strong>Total</strong></div></td>
		<td class="celula"><div align="center"><strong>Excelente</strong></div></td>
		<td class="celula"><div align="center"><strong>Muito Bom</strong></div></td>
		<td class="celula"><div align="center"><strong>&nbsp;Bom&nbsp;</strong></div></td>
		<td class="celula"><div align="center"><strong>Regular</strong></div></td>
		<td class="celula"><div align="center"><strong>Insuficiente</strong></div></td>
		<td class="celula"><div align="center"><strong>&nbsp;Nulo&nbsp;</strong></div></td>
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
   	   sql = sql & " left join sca_Turma t on t.Cod_turma = sav.Cod_turma "
	   sql = sql & " left join sca_GradeCurricular g on g.cod_gradecurricular = t.cod_gradecurricular and g.cod_empresa = t.cod_empresa "
	   sql = sql & " left join sca_Periodo p on p.cod_periodo = g.cod_periodo and p.cod_empresa = g.cod_empresa "
	   sql = sql & " left join sca_curso c on c.cod_curso = p.cod_curso "
       sql = sql & " where codAvaliacao = " & intCodAvaliacaoInstitucional
	   if intCodCurso <> "" and intCodCurso <> "0" then
	      sql = sql & " and c.cod_curso = " & intCodCurso
	   end if   
	   if intCodTurma <> "" and intCodTurma <> "0" then
	      sql = sql & " and t.cod_turma = " & intCodTurma
	   end if   
	   rs.open sql, cnn
	   rs.close
	   '
       sql = " select top 1 @@rowcount as Realizadas from SAV_AVALIACAO_PERGUNTA_NOTA sav "
   	   sql = sql & " left join sca_Turma t on t.Cod_turma = sav.Cod_turma "
	   sql = sql & " left join sca_GradeCurricular g on g.cod_gradecurricular = t.cod_gradecurricular and g.cod_empresa = t.cod_empresa "
	   sql = sql & " left join sca_Periodo p on p.cod_periodo = g.cod_periodo and p.cod_empresa = g.cod_empresa "
	   sql = sql & " left join sca_curso c on c.cod_curso = p.cod_curso "
       sql = sql & " where codAvaliacao = " & intCodAvaliacaoInstitucional
 	   if intCodCurso <> "" and intCodCurso <> "0" then
	      sql = sql & " and c.cod_curso = " & intCodCurso
	   end if   
	   if intCodTurma <> "" and intCodTurma <> "0" then
	      sql = sql & " and t.cod_turma = " & intCodTurma
	   end if   
	   rs.open sql, cnn
	   if rs.eof = false then
		  intRealizadas		= rs("Realizadas")
	   else
	   	  intRealizadas     = 0
	   end if 
	   rs.close
	   '
	   if intTipoAvaliacao = "1" then
	      sql = "select sav.codAvaliacao, t.cod_turma, t.nometurma, c.cod_curso, d.cod_disciplina, sav.conceito, count(sav.conceito)as total "
	   else  
 	      sql = "select sav.codAvaliacao, t.cod_turma, t.nometurma, c.cod_curso, sav.conceito, count(sav.conceito)as total "
       end if
	   sql = sql & " from SAV_AVALIACAO_PERGUNTA_NOTA SAV "
	   sql = sql & " left join sca_Turma t on t.Cod_turma = sav.Cod_turma "
	   sql = sql & " left join sca_GradeCurricular g on g.cod_gradecurricular = t.cod_gradecurricular and g.cod_empresa = t.cod_empresa "
	   sql = sql & " left join sca_Periodo p on p.cod_periodo = g.cod_periodo and p.cod_empresa = g.cod_empresa "
	   sql = sql & " left join sca_curso c on c.cod_curso = p.cod_curso "
	   if intTipoAvaliacao = "1" then
          sql = sql & " inner join sca_disciplina d on d.cod_disciplina = sav.cod_disciplina and d.cod_empresa = g.Cod_empresa "
	   end if	  
	   sql = sql & " where sav.codAvaliacao = " & intCodAvaliacaoInstitucional
	   if intCodCurso <> "" and intCodCurso <> "0" then
	      sql = sql & " and c.cod_curso = " & intCodCurso
	   end if   
	   if intCodTurma <> "" and intCodTurma <> "0" then
	      sql = sql & " and t.cod_turma = " & intCodTurma
	   end if   
	   if intCodDisciplinaTurma <> "" and intCodDisciplinaTurma <> "0" and intTipoAvaliacao = "1" then
	      sql = sql & " and sav.cod_disciplina = " & intCodDisciplinaTurma
	   end if   
  	   if strQuestaoInicial <> "" and strQuestaoFinal <> "" then
	      sql = sql & " and codItemPergunta >=  " & strQuestaoInicial
	      sql = sql & " and codItemPergunta <=  " & strQuestaoFinal
	   end If 
	   if intTipoAvaliacao = "1" then
	      sql = sql & " group by sav.codAvaliacao, t.cod_turma, t.nometurma, c.cod_curso , d.cod_disciplina, sav.conceito "
	      sql = sql & " order by t.nometurma, c.cod_curso , d.cod_disciplina, sav.conceito "
	   else
	      sql = sql & " group by sav.codAvaliacao, t.cod_turma, t.nometurma, c.cod_curso , sav.conceito "
	      sql = sql & " order by t.nometurma, c.cod_curso ,  sav.conceito "
	   end if
	   rs.open sql, cnn
		if not rs.eof then
		   %> 
		   <tr>
		   <%
		   mostraCabecalho
		   vlinha=0
		   MostraParticipantes = "0"
		   vsomaconceitoTotal=0
		   vsomaconceitA=0
		   vsomaconceitB=0
		   vsomaconceitC=0
		   vsomaconceitD=0
		   vsomaconceitE=0
		   vsomaconceitN=0
		   While not rs.eof
				if vlinha = 0 then
				   if intTipoAvaliacao = "1" then
					  strnometurmaDisciplina = trim(rs("nometurma")) & trim(rs("cod_disciplina"))
					  strnometurma = trim(rs("nometurma"))
					  intCodDisciplinaTurma = trim(rs("cod_disciplina"))
				   else
					  strnometurmaDisciplina = trim(rs("nometurma"))
					  strnometurma = trim(rs("nometurma"))
					  intCodDisciplinaTurma = "0"
				   end if	  
				   intCodTurma = trim(rs("cod_turma"))
				   if isnull(intCodTurma) then intCodTurma = "0"
				   vlinha=1
				   valternativa=1
				   vsomaconceito=0
				   vcalculanotaA=0
				   vcalculanotaB=0
				   vcalculanotaC=0
				   vcalculanotaD=0
				   vcalculanotaE=0
				   vcalculanotaN=0
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
					
				   sql = "select count(*) from (select distinct cod_aluno from SAV_AVALIACAO_PERGUNTA_NOTA sav "
				   sql = sql & " inner join sca_Turma t on t.Cod_turma = sav.Cod_turma "
				   sql = sql & " inner join sca_GradeCurricular g on g.cod_gradecurricular = t.cod_gradecurricular and g.cod_empresa = t.cod_empresa "
				   sql = sql & " inner join sca_Periodo p on p.cod_periodo = g.cod_periodo and p.cod_empresa = g.cod_empresa "
				   sql = sql & " inner join sca_curso c on c.cod_curso = p.cod_curso "
	
				   sql = sql & " where codAvaliacao = " & intCodAvaliacaoInstitucional
				   if intCodCurso <> "" and intCodCurso <> "0" then
					  sql = sql & " and c.cod_curso = " & intCodCurso
				   end if
				   sql = sql & " and t.Cod_turma = " &  intCodTurma
				   sql = sql & ") as realizadas "
				   rsaux.open sql, cnn
				   if rsaux.eof = false then
					  intRealizadasTurma	= rsaux.fields(0).value
				   else
					  intRealizadasTurma    = 0
				   end if 
				   rsaux.close
				   
				   if intTipoAvaliacao = "1" then
					   sql = "SELECT desc_disciplina"
					   sql = sql & " FROM SCA_DISCIPLINA"
					   sql = sql & " Where cod_empresa = " & Session("CodEmpresa")
					   sql = sql & " And cod_disciplina = " &  rs("cod_disciplina")			
					   rsaux.open sql, cnn
					   if rsaux.eof = false then
						  strDisciplina	= rsaux("desc_disciplina")
					   else
						 strDisciplina	= "Erro!"
					   end if 
					   rsaux.close
					end if   

				   if MostraParticipantes = "0" then %>
						 <td class="celula" align="center"><%=rs("nometurma")%>&nbsp;</td>
						 <td align="center" class="celula"><%=intRealizadasTurma%>&nbsp;</td>
						 <% MostraParticipantes = "1" %>
				   <%else%>	 
						 <td align="center" class="celula">&nbsp;</td>
						 <td align="center" class="celula">&nbsp;</td>
				   <%end if%>	 
				   <%if intTipoAvaliacao = "1" then %>
					 <td align="left" class="celula">&nbsp;<%=strDisciplina%>&nbsp;</td>
				   <%else%>
					 <td align="center" class="celula">********</td>
				   <%end if%>	 
				   <td align="center" class="celula"><%=strProfessor%></td>
				   <%
				end if 
				'
				if valternativa = 1 then
				   ok = false
				   if trim(rs("conceito")) = "A" then
					  vcalculanotaA = int(trim(rs("total")))
					  if vcalculanotaA = "0" or vcalculanotaA = "" then
						 vcalculanotaA = 0
					  end if	 
					  ok = true
					  vsomaconceito =  vsomaconceito + int(trim(rs("total")))
					  vsomaconceitoA =  vsomaconceitoA + int(trim(rs("total")))
					  vsomaconceitoTotal =  vsomaconceitoTotal + int(trim(rs("total")))
					  %>
					  <td align="left" class="celula"><div align="center">&nbsp;<%=rs("total")%>&nbsp;</div></td>
					  <%
				   else   
					  %>
					  <td align="left" class="celula"><div align="center">&nbsp;</div></td>
					  <%
				   end if 
				elseif valternativa = 2 then  
				  ok = false
				   if trim(rs("conceito")) = "B" then
					  vcalculanotaB = int(trim(rs("total")))
					  if vcalculanotaB = "0" or vcalculanotaB = "" then
						 vcalculanotaB = 0
					  end if	 
					  ok = true
					  vsomaconceito =  vsomaconceito +  int(trim(rs("total")))
					  vsomaconceitoB =  vsomaconceitoB +  int(trim(rs("total")))
					  vsomaconceitoTotal =  vsomaconceitoTotal +  int(trim(rs("total")))
					  %>
					  <td align="left" class="celula"><div align="center">&nbsp;<%=rs("total")%>&nbsp;</div></td>
					  <%
				   else   
					  %>
					  <td align="left" class="celula"><div align="center">&nbsp;</div></td>
					  <%
				   end if 
				elseif valternativa = 3 then  
				   ok = false
				   if trim(rs("conceito")) = "C" then
					  vcalculanotaC = int(trim(rs("total")))
					  if vcalculanotaC = "0" or vcalculanotaC = "" then
						 vcalculanotaC = 0
					  end if	 
					  ok = true
					  vsomaconceito =  vsomaconceito +  int(trim(rs("total")))
					  vsomaconceitoC =  vsomaconceitoC +  int(trim(rs("total")))
					  vsomaconceitoTotal =  vsomaconceitoTotal +  int(trim(rs("total")))
					  %>
					  <td align="left" class="celula"><div align="center">&nbsp;<%=rs("total")%>&nbsp;</div></td>
					  <%
				   else   
					  %>
					  <td align="left" class="celula"><div align="center">&nbsp;</div></td>
					  <%
				   end if 
				elseif valternativa = 4  then 
				   ok = false
				   if trim(rs("conceito")) = "D" then
					  vcalculanotaD = int(trim(rs("total")))
					  if vcalculanotaD = "0" or vcalculanotaD = "" then
						 vcalculanotaD = 0
					  end if	 
					  ok = true
					  vsomaconceito =  vsomaconceito +  int(trim(rs("total")))
					  vsomaconceitoD =  vsomaconceitoD +  int(trim(rs("total")))
					  vsomaconceitoTotal =  vsomaconceitoTotal +  int(trim(rs("total")))
					  %>
					  <td align="left" class="celula"><div align="center">&nbsp;<%=rs("total")%>&nbsp;</div></td>
					  <%
				   else   
					  %>
					  <td align="left" class="celula"><div align="center">&nbsp;</div></td>
					  <%
				   end if 
				elseif valternativa = 5 then  
				   ok = false
				   if trim(rs("conceito")) = "E" then
					  vcalculanotaE = int(trim(rs("total")))
					  if vcalculanotaE = "0" or vcalculanotaE = "" then
						 vcalculanotaE = 0
					  end if	 
					  ok = true
					  vsomaconceito =  vsomaconceito +  int(trim(rs("total")))
					  vsomaconceitoE =  vsomaconceitoE +  int(trim(rs("total")))
					  vsomaconceitoTotal =  vsomaconceitoTotal +  int(trim(rs("total")))
					  %>
					  <td align="left" class="celula"><div align="center">&nbsp;<%=rs("total")%>&nbsp;</div></td>
					  <%
				   else   
					  %>
					  <td align="left" class="celula"><div align="center">&nbsp;</div></td>
					  <%
				   end if 
				elseif valternativa = 6 then  
				   ok = false
				   if trim(rs("conceito")) = "N" then
					  vcalculanotaN = int(trim(rs("total")))
					  if vcalculanotaN = "0" or vcalculanotaN = "" then
						 vcalculanotaN = 0
					  end if	 
					  ok = true
					  vsomaconceito =  vsomaconceito +  int(trim(rs("total")))
					  vsomaconceitoN =  vsomaconceitoN +  int(trim(rs("total")))
					  vsomaconceitoTotal =  vsomaconceitoTotal +  int(trim(rs("total")))
					  %>
					  <td align="left" class="celula"><div align="center">&nbsp;<%=rs("total")%>&nbsp;</div></td>
					  <%
				   else   
					  %>
					  <td align="left" class="celula">&nbsp;</td>
					  <%
				   end if 
				end if 
				valternativa = valternativa + 1
				if ok then
				   rs.movenext
				end if  
				if not rs.eof then
				   if intTipoAvaliacao = "1" then
					  finalizalinha = trim(rs("nometurma")) & trim(rs("cod_disciplina"))
					  finalizaTurma = trim(rs("nometurma"))
				   else
					  finalizalinha = trim(rs("nometurma"))
					  finalizaTurma = trim(rs("nometurma"))
				   end if  
				   if strnometurma <> finalizaTurma then
					  MostraParticipantes = "0"
				   end if
				   if strnometurmaDisciplina <> finalizalinha then
					  vlinha=0
					  vnotaA = round(( vcalculanotaA * 100 ) / vsomaconceito,1)
					  vnotaB = round(( vcalculanotaB * 100 ) / vsomaconceito,1)
					  vnotaC = round(( vcalculanotaC * 100 ) / vsomaconceito,1)
					  vnotaD = round(( vcalculanotaD * 100 ) / vsomaconceito,1)
					  vnotaE = round(( vcalculanotaE * 100 ) / vsomaconceito,1)
					  vnotaN = round(( vcalculanotaN * 100 ) / vsomaconceito,1)
					   
					  if valternativa = 1 then %>
						<td align="left" class="celula"><div align="center">&nbsp;</div></td>
						<td align="left" class="celula"><div align="center">&nbsp;</div></td>
						<td align="left" class="celula"><div align="center">&nbsp;</div></td>
						<td align="left" class="celula"><div align="center">&nbsp;</div></td>
						<td align="left" class="celula"><div align="center">&nbsp;</div></td>
						<td align="left" class="celula"><div align="center">&nbsp;</div></td>
					  <% end if %>	
					  <% if valternativa = 2 then %>
						<td align="left" class="celula"><div align="center">&nbsp;</div></td>
						<td align="left" class="celula"><div align="center">&nbsp;</div></td>
						<td align="left" class="celula"><div align="center">&nbsp;</div></td>
						<td align="left" class="celula"><div align="center">&nbsp;</div></td>
						<td align="left" class="celula"><div align="center">&nbsp;</div></td>
					  <% end if %>	
					  <% if valternativa = 3 then %>
						<td align="left" class="celula"><div align="center">&nbsp;</div></td>
						<td align="left" class="celula"><div align="center">&nbsp;</div></td>
						<td align="left" class="celula"><div align="center">&nbsp;</div></td>
						<td align="left" class="celula"><div align="center">&nbsp;</div></td>
					  <% end if %>	
					  <% if valternativa = 4 then %>
						<td align="left" class="celula"><div align="center">&nbsp;</div></td>
						<td align="left" class="celula"><div align="center">&nbsp;</div></td>
						<td align="left" class="celula"><div align="center">&nbsp;</div></td>
					  <% end if %>	
					  <% if valternativa = 5 then %>
						<td align="left" class="celula"><div align="center">&nbsp;</div></td>
						<td align="left" class="celula"><div align="center">&nbsp;</div></td>
					  <% end if %>	
					  <% if valternativa = 6 then %>
						<td align="left" class="celula"><div align="center">&nbsp;</div></td>
					  <% end if %>	
	
					  <td align="left" class="celula"><div align="center">&nbsp;<%=vsomaconceito%>&nbsp;</div></td>
					  <td align="left" class="celula"><div align="center">&nbsp;<%=vnotaA%>%&nbsp;</div></td>
					  <td align="left" class="celula"><div align="center">&nbsp;<%=vnotaB%>%&nbsp;</div></td>
					  <td align="left" class="celula"><div align="center">&nbsp;<%=vnotaC%>%&nbsp;</div></td>
					  <td align="left" class="celula"><div align="center">&nbsp;<%=vnotaD%>%&nbsp;</div></td>
					  <td align="left" class="celula"><div align="center">&nbsp;<%=vnotaE%>%&nbsp;</div></td>
					  <td align="left" class="celula"><div align="center">&nbsp;<%=vnotaN%>%&nbsp;</div></td>
					  </tr>
					  <tr>
					  <%
					  valternativa=1
	
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
				   end if
				else
					  vnotaA = round(( vcalculanotaA * 100 ) / vsomaconceito,1)
					  vnotaB = round(( vcalculanotaB * 100 ) / vsomaconceito,1)
					  vnotaC = round(( vcalculanotaC * 100 ) / vsomaconceito,1)
					  vnotaD = round(( vcalculanotaD * 100 ) / vsomaconceito,1)
					  vnotaE = round(( vcalculanotaE * 100 ) / vsomaconceito,1)
					  vnotaN = round(( vcalculanotaN * 100 ) / vsomaconceito,1)
	
				
					  if valternativa = 1 then %>
						<td align="left" class="celula"><div align="center">&nbsp;</div></td>
						<td align="left" class="celula">&nbsp;</td>
						<td align="left" class="celula"><div align="center">&nbsp;</div></td>
						<td align="left" class="celula"><div align="center">&nbsp;</div></td>
						<td align="left" class="celula"><div align="center">&nbsp;</div></td>
						<td align="left" class="celula"><div align="center">&nbsp;</div></td>
						<td align="left" class="celula"><div align="center">&nbsp;</div></td>
					  <% end if %>	
					  <% if valternativa = 2 then %>
						<td align="left" class="celula"><div align="center">&nbsp;</div></td>
						<td align="left" class="celula"><div align="center">&nbsp;</div></td>
						<td align="left" class="celula"><div align="center">&nbsp;</div></td>
						<td align="left" class="celula"><div align="center">&nbsp;</div></td>
						<td align="left" class="celula"><div align="center">&nbsp;</div></td>
					  <% end if %>	
					  <% if valternativa = 3 then %>
						<td align="left" class="celula"><div align="center">&nbsp;</div></td>
						<td align="left" class="celula"><div align="center">&nbsp;</div></td>
						<td align="left" class="celula"><div align="center">&nbsp;</div></td>
						<td align="left" class="celula"><div align="center">&nbsp;</div></td>
					  <% end if %>	
					  <% if valternativa = 4 then %>
						<td align="left" class="celula"><div align="center">&nbsp;</div></td>
						<td align="left" class="celula"><div align="center">&nbsp;</div></td>
						<td align="left" class="celula"><div align="center">&nbsp;</div></td>
					  <% end if %>	
					  <% if valternativa = 5 then %>
						<td align="left" class="celula"><div align="center">&nbsp;</div></td>
						<td align="left" class="celula"><div align="center">&nbsp;</div></td>
					  <% end if %>	
					  <% if valternativa = 6 then %>
						<td align="left" class="celula"><div align="center">&nbsp;</div></td>
					  <% end if %>	
					
					  <td align="left" class="celula"><div align="center">&nbsp;<%=vsomaconceito%>&nbsp;</div></td>
					  <td align="left" class="celula"><div align="center">&nbsp;<%=vnotaA%>%&nbsp;</div></td>
					  <td align="left" class="celula"><div align="center">&nbsp;<%=vnotaB%>%&nbsp;</div></td>
					  <td align="left" class="celula"><div align="center">&nbsp;<%=vnotaC%>%&nbsp;</div></td>
					  <td align="left" class="celula"><div align="center">&nbsp;<%=vnotaD%>%&nbsp;</div></td>
					  <td align="left" class="celula"><div align="center">&nbsp;<%=vnotaE%>%&nbsp;</div></td>
					  <td align="left" class="celula"><div align="center">&nbsp;<%=vnotaN%>%&nbsp;</div></td>
					  </tr>
					  <%
					 
					  vnotaTA = round(( vsomaconceitoA * 100 ) / vsomaconceitoTotal,2)
					  vnotaTB = round(( vsomaconceitoB * 100 ) / vsomaconceitoTotal,2)
					  vnotaTC = round(( vsomaconceitoC * 100 ) / vsomaconceitoTotal,2)
					  vnotaTD = round(( vsomaconceitoD * 100 ) / vsomaconceitoTotal,2)
					  vnotaTE = round(( vsomaconceitoE * 100 ) / vsomaconceitoTotal,2)
					  vnotaTN = round(( vsomaconceitoN * 100 ) / vsomaconceitoTotal,2)
					  %>
					  <tr>
					  <td align="center" class="celula">--------</td>
					  <td align="center" class="celula">&nbsp;</td>
					  <td align="center" class="celula">--------</td>
					  <td align="center" class="celula">Totais:</td>
					  <td align="left" class="celula"><div align="center">&nbsp;<%=vsomaconceitoA%>&nbsp;</div></td>
					  <td align="left" class="celula"><div align="center">&nbsp;<%=vsomaconceitoB%>&nbsp;</div></td>
					  <td align="left" class="celula"><div align="center">&nbsp;<%=vsomaconceitoC%>&nbsp;</div></td>
					  <td align="left" class="celula"><div align="center">&nbsp;<%=vsomaconceitoD%>&nbsp;</div></td>
					  <td align="left" class="celula"><div align="center">&nbsp;<%=vsomaconceitoE%>&nbsp;</div></td>
					  <td align="left" class="celula"><div align="center">&nbsp;<%=vsomaconceitoN%>&nbsp;</div></td>
					  <td align="left" class="celula"><div align="center">&nbsp;<%=vsomaconceitoTotal%>&nbsp;</div></td>
					  <td align="left" class="celula"><div align="center">&nbsp;<%=vnotaTA%>%&nbsp;</div></td>
					  <td align="left" class="celula"><div align="center">&nbsp;<%=vnotaTB%>%&nbsp;</div></td>
					  <td align="left" class="celula"><div align="center">&nbsp;<%=vnotaTC%>%&nbsp;</div></td>
					  <td align="left" class="celula"><div align="center">&nbsp;<%=vnotaTD%>%&nbsp;</div></td>
					  <td align="left" class="celula"><div align="center">&nbsp;<%=vnotaTE%>%&nbsp;</div></td>
					  <td align="left" class="celula"><div align="center">&nbsp;<%=vnotaTN%>%&nbsp;</div></td>
					  </tr>
					  <tr>
					  <%
					  conceito = formatnumber(vnotaTA,2) & " " & formatnumber(vnotaTB) & " " & formatnumber(vnotaTC) & " " & formatnumber(vnotaTD) & " " & formatnumber(vnotaTE) & " " & formatnumber(vnotaTN)
				end if 
			wend
			%> 
			
			 <%
		else
			%>
			<tr>
	
			<td colspan="17" class="celula" align="center"><p><font color="#993300"><%=session("strMensagemRelatorioNaoEncontrado")%></font></p>		  </td>
	  </tr>
			<%
		end if
		rs.close
     end if	
%>
</table>
<% if strSimouNao = "S" then
     if intCodDisciplinaTitulo <> "0" then 
	 	strDisciplinaTitulo =  Chr(13) & Chr(10) & strDisciplina
		strProfessorTitulo =  Chr(13) & Chr(10) & strProfessor
	else 	
	 	strDisciplinaTitulo = ""
		strProfessorTitulo = ""
	end if	
	 
     TituloGrafico =  "Período Letivo: " & intAnoLetivo & "/" & intSemestre & Chr(13) & Chr(10) & strNomeAvaliacao & strDisciplinaTitulo & strProfessorTitulo
   	 if strQuestaoInicial <> "" and strQuestaoFinal <> "" then
	    itensAvaliado = chr(13) & chr(10) & " Item(ens) Avaliado(s):"
		sql = "SELECT Descricao"
		sql = sql & " FROM SAV_AVALIACAO_PERGUNTA"
		sql = sql & " Where cod_empresa = " & Session("CodEmpresa")	
		sql = sql & " And Cod_Avaliacao_Institucional = " & intCodAvaliacaoInstitucional
		sql = sql & " and Codigo >=  " & strQuestaoInicial
		sql = sql & " and Codigo <=  " & strQuestaoFinal
		sql = sql & " Order by Codigo"
		rs1.open sql, cnn
		if rs1.eof = false then
			while not rs1.eof
				itensAvaliado =  trim(itensAvaliado) & chr(13) & chr(10) & "- " & trim(rs1("Descricao")) & "."
				rs1.movenext
			wend
		end if
		rs1.close
		TituloGrafico = TituloGrafico & itensAvaliado
	 end if
   %>
   <!--#include file="../includes/inc_GraficoAvaliacaoInstitucional.asp"-->
<% end if %>   
<script>
	aguarde.style.display="none";
</script>
</body>
</html>