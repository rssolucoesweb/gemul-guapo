<%
response.Expires=0
'Não armazena a página em buffer antes de mostra-la na tela'
response.Buffer = false
%>
<!--
	::	DESENVOLVIDO POR "RS SOLUÇÕES WEB - www.rssolucoesweb.com.br"
	::	Data de Criação...: 13/02/2008
	::	Desenvolvedores...: Sergio Borges - sergiob76@hotmail.com
	::	Objetivo Pagina...: Extrato de Notas
-->
<html>
<head>
<title><%=session("Titulo")%> - Mapa Verificação de Contéudo Programatio</title>
<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1">
<link type="text/css" rel="stylesheet" href="../../Estilo/Estilo_Impressao.css">
<script src="../../js/js_funcoes_gerais.js"></script>
<script src="../../js/js_barra_movel.js"></script>
<style type="text/css">
<!--
.style1 {color: #FF0000}
-->
</style>
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

	strSemestre 				= Trim(Request.Form("cmbSemestre"))
	strAnoLetivo 				= Trim(Request.Form("txtAnoLetivo"))
	strOpcaoRelatorio 			= Trim(Request.Form("optOpcao"))
	intCodCurso	 				= Trim(Request.Form("cmbCurso"))
	intCodTurma 				= Trim(Request.Form("cmbTurma"))
	
	if strAnoLetivo = "" then strAnoLetivo = session("strAnoLetivo")
	if strSemestre = "" then strSemestre = "0"

	strFiltroSerie = "0"
	strFiltroTurno = "0"

	strTituloRelatorio  	= "Verificação de Conteúdo Programático "


	sub mostraCabecalho()
	%>
	<!--#include file="../../includes/inc_cabecalhoRelatorio.asp"-->
	<br>
	<table width="98%" border="0" cellspacing="0" cellpadding="0" class="tabela" align="center">
	  <tr bgcolor="#CCCCCC">
	    <td width="24%" rowspan="2" class="celula"><strong>Professor</strong></td>
	    <td width="6%" rowspan="2" class="celula"><strong>Turma</strong></td>
	    <td width="23%" rowspan="2" class="celula"><strong>Disciplina</strong></td>
	    <td height="15" colspan="13" class="celula"><div align="center"><strong>Total de Aulas Mensal (Conte&uacute;do)</strong></div></td>
	    <td width="3%" rowspan="2" class="celula"><strong>Matriz</strong></td>
	    <td width="4%" rowspan="2" class="celula"><strong>Saldo</strong></td>
      </tr>
	  <tr bgcolor="#CCCCCC">
	    <td width="4%" height="15" class="celula">Jan</td>
        <td width="3%" class="celula">Fev</td>
        <td width="3%" class="celula">Mar</td>
        <td width="3%" class="celula">Abr</td>
        <td width="3%" class="celula">Mai</td>
        <td width="3%" class="celula">Jun</td>
        <td width="3%" class="celula">Jul</td>
        <td width="3%" class="celula">Ago</td>
        <td width="3%" class="celula">Set</td>
        <td width="3%" class="celula">Out</td>
        <td width="3%" class="celula">Nov</td>
        <td width="3%" class="celula">Dez</td>
        <td width="3%" class="celula">Total</td>
	  </tr>
	  
	<%
	end Sub
	
	sub fimTabela()
		response.Write("</table>")
	end Sub

	intPagina = 1
	mostraCabecalho
	cont = 0
	totalCh_Semanal = 0
	totalCh_Mensal = 0
	totalCh_Anual = 0
	contPeriodo = 0
	
	strSemanasLetivas = "0"
	sql = " SELECT top 1 Semanas_Letivas "
	sql = sql & " FROM SEG_ENCERRAMENTOATIVIDADES "
	sql = sql & " Where cod_empresa = " & Session("CodEmpresa")
	rs.Open SQL, cnn
	if rs.EOF = false then								
		strSemanasLetivas = rs("Semanas_Letivas")
		if isnull(strSemanasLetivas) then strSemanasLetivas = "0"
	end if
	rs.close
	
	sql = " SELECT distinct "
	sql = sql & " C.CODIGO, "
	sql = sql & " C.NOME AS PROFESSOR, " 
	sql = sql & " CU.DESCRICAO AS CURSO, " 
	sql = sql & " P.DESCRICAO AS PERIODO, " 
	sql = sql & " T.NOMETURMA, " 
	sql = sql & " D.DESC_DISCIPLINA AS DISCIPLINA, "
	
	sql = sql & " (SELECT ISNULL(sum(total_aulas),'0') as TotalConteudo " 
	sql = sql & " FROM SCA_CONTEUDO " 
	sql = sql & " WHERE COD_EMPRESA = HA.COD_EMPRESA "
	sql = sql & " AND COD_TURMA = HA.COD_TURMA "
	sql = sql & " and Cod_Disciplina = HA.COD_DISCIPLINA "
	if 	strOpcaoRelatorio = "E" then
		sql = sql & " and FECHAMENTO = 'S' "
	elseif strOpcaoRelatorio = "N" then	
		sql = sql & " and FECHAMENTO <> 'S' "
	end if	
	sql = sql & " AND MONTH(DATAINICIAL)=1 ) AS TOTAL_JANEIRO, "
	
	sql = sql & " (SELECT ISNULL(sum(total_aulas),'0') as TotalConteudo " 
	sql = sql & " FROM SCA_CONTEUDO " 
	sql = sql & " WHERE COD_EMPRESA = HA.COD_EMPRESA "
	sql = sql & " AND COD_TURMA = HA.COD_TURMA "
	sql = sql & " and Cod_Disciplina = HA.COD_DISCIPLINA "
	if 	strOpcaoRelatorio = "E" then
		sql = sql & " and FECHAMENTO = 'S' "
	elseif strOpcaoRelatorio = "N" then	
		sql = sql & " and FECHAMENTO <> 'S' "
	end if	
	sql = sql & " AND MONTH(DATAINICIAL)=2 ) AS TOTAL_FEVEREIRO, "
	
	sql = sql & " (SELECT ISNULL(sum(total_aulas),'0') as TotalConteudo "
	sql = sql & " FROM SCA_CONTEUDO " 
	sql = sql & " WHERE COD_EMPRESA = HA.COD_EMPRESA "
	sql = sql & " AND COD_TURMA = HA.COD_TURMA "
	sql = sql & " and Cod_Disciplina = HA.COD_DISCIPLINA "
	if 	strOpcaoRelatorio = "E" then
		sql = sql & " and FECHAMENTO = 'S' "
	elseif strOpcaoRelatorio = "N" then	
		sql = sql & " and FECHAMENTO <> 'S' "
	end if	
	sql = sql & " AND MONTH(DATAINICIAL)=3 ) AS TOTAL_MARCO, "
	
	sql = sql & " (SELECT ISNULL(sum(total_aulas),'0') as TotalConteudo "
	sql = sql & " FROM SCA_CONTEUDO " 
	sql = sql & " WHERE COD_EMPRESA = HA.COD_EMPRESA "
	sql = sql & " AND COD_TURMA = HA.COD_TURMA "
	sql = sql & " and Cod_Disciplina = HA.COD_DISCIPLINA "
	if 	strOpcaoRelatorio = "E" then
		sql = sql & " and FECHAMENTO = 'S' "
	elseif strOpcaoRelatorio = "N" then	
		sql = sql & " and FECHAMENTO <> 'S' "
	end if	
	sql = sql & " AND MONTH(DATAINICIAL)=4 ) AS TOTAL_ABRIL, "
	
	sql = sql & " (SELECT ISNULL(sum(total_aulas),'0') as TotalConteudo " 
	sql = sql & " FROM SCA_CONTEUDO " 
	sql = sql & " WHERE COD_EMPRESA = HA.COD_EMPRESA "
	sql = sql & " AND COD_TURMA = HA.COD_TURMA "
	sql = sql & " and Cod_Disciplina = HA.COD_DISCIPLINA "
	if 	strOpcaoRelatorio = "E" then
		sql = sql & " and FECHAMENTO = 'S' "
	elseif strOpcaoRelatorio = "N" then	
		sql = sql & " and FECHAMENTO <> 'S' "
	end if	
	sql = sql & " AND MONTH(DATAINICIAL)=5 ) AS TOTAL_MAIO, "
	
	sql = sql & " (SELECT ISNULL(sum(total_aulas),'0') as TotalConteudo " 
	sql = sql & " FROM SCA_CONTEUDO " 
	sql = sql & " WHERE COD_EMPRESA = HA.COD_EMPRESA "
	sql = sql & " AND COD_TURMA = HA.COD_TURMA "
	sql = sql & " and Cod_Disciplina = HA.COD_DISCIPLINA "
	if 	strOpcaoRelatorio = "E" then
		sql = sql & " and FECHAMENTO = 'S' "
	elseif strOpcaoRelatorio = "N" then	
		sql = sql & " and FECHAMENTO <> 'S' "
	end if	
	sql = sql & " AND MONTH(DATAINICIAL)=6 ) AS TOTAL_JUNHO, "
	
	sql = sql & " (SELECT ISNULL(sum(total_aulas),'0') as TotalConteudo " 
	sql = sql & " FROM SCA_CONTEUDO " 
	sql = sql & " WHERE COD_EMPRESA = HA.COD_EMPRESA "
	sql = sql & " AND COD_TURMA = HA.COD_TURMA "
	sql = sql & " and Cod_Disciplina = HA.COD_DISCIPLINA "
	if 	strOpcaoRelatorio = "E" then
		sql = sql & " and FECHAMENTO = 'S' "
	elseif strOpcaoRelatorio = "N" then	
		sql = sql & " and FECHAMENTO <> 'S' "
	end if	
	sql = sql & " AND MONTH(DATAINICIAL)=7 ) AS TOTAL_JULHO, "
	
	sql = sql & " (SELECT ISNULL(sum(total_aulas),'0') as TotalConteudo " 
	sql = sql & " FROM SCA_CONTEUDO " 
	sql = sql & " WHERE COD_EMPRESA = HA.COD_EMPRESA "
	sql = sql & " AND COD_TURMA = HA.COD_TURMA "
	sql = sql & " and Cod_Disciplina = HA.COD_DISCIPLINA "
	if 	strOpcaoRelatorio = "E" then
		sql = sql & " and FECHAMENTO = 'S' "
	elseif strOpcaoRelatorio = "N" then	
		sql = sql & " and FECHAMENTO <> 'S' "
	end if	
	sql = sql & " AND MONTH(DATAINICIAL)=8 ) AS TOTAL_AGOSTO, "
	
	sql = sql & " (SELECT ISNULL(sum(total_aulas),'0') as TotalConteudo " 
	sql = sql & " FROM SCA_CONTEUDO " 
	sql = sql & " WHERE COD_EMPRESA = HA.COD_EMPRESA "
	sql = sql & " AND COD_TURMA = HA.COD_TURMA "
	sql = sql & " and Cod_Disciplina = HA.COD_DISCIPLINA "
	if 	strOpcaoRelatorio = "E" then
		sql = sql & " and FECHAMENTO = 'S' "
	elseif strOpcaoRelatorio = "N" then	
		sql = sql & " and FECHAMENTO <> 'S' "
	end if	
	sql = sql & " AND MONTH(DATAINICIAL)=9 ) AS TOTAL_SETEMBRO, "
	
	sql = sql & " (SELECT ISNULL(sum(total_aulas),'0') as TotalConteudo " 
	sql = sql & " FROM SCA_CONTEUDO " 
	sql = sql & " WHERE COD_EMPRESA = HA.COD_EMPRESA "
	sql = sql & " AND COD_TURMA = HA.COD_TURMA "
	sql = sql & " and Cod_Disciplina = HA.COD_DISCIPLINA "
	if 	strOpcaoRelatorio = "E" then
		sql = sql & " and FECHAMENTO = 'S' "
	elseif strOpcaoRelatorio = "N" then	
		sql = sql & " and FECHAMENTO <> 'S' "
	end if	
	sql = sql & " AND MONTH(DATAINICIAL)=10 ) AS TOTAL_OUTUBRO, "
		
	sql = sql & " (SELECT ISNULL(sum(total_aulas),'0') as TotalConteudo " 
	sql = sql & " FROM SCA_CONTEUDO " 
	sql = sql & " WHERE COD_EMPRESA = HA.COD_EMPRESA "
	sql = sql & " AND COD_TURMA = HA.COD_TURMA "
	sql = sql & " and Cod_Disciplina = HA.COD_DISCIPLINA "
	if 	strOpcaoRelatorio = "E" then
		sql = sql & " and FECHAMENTO = 'S' "
	elseif strOpcaoRelatorio = "N" then	
		sql = sql & " and FECHAMENTO <> 'S' "
	end if	
	sql = sql & " AND MONTH(DATAINICIAL)=11 ) AS TOTAL_NOVEMBRO, "
		
	sql = sql & " (SELECT ISNULL(sum(total_aulas),'0') as TotalConteudo " 
	sql = sql & " FROM SCA_CONTEUDO " 
	sql = sql & " WHERE COD_EMPRESA = HA.COD_EMPRESA "
	sql = sql & " AND COD_TURMA = HA.COD_TURMA "
	sql = sql & " and Cod_Disciplina = HA.COD_DISCIPLINA "
	if 	strOpcaoRelatorio = "E" then
		sql = sql & " and FECHAMENTO = 'S' "
	elseif strOpcaoRelatorio = "N" then	
		sql = sql & " and FECHAMENTO <> 'S' "
	end if	
	sql = sql & " AND MONTH(DATAINICIAL)=12 ) AS TOTAL_DEZEMBRO, "
	
	sql = sql & " (SELECT "  
	sql = sql & " SUM(GD.Ch_Semanal) as total "  
	sql = sql & " FROM SCA_TURMA T "
	sql = sql & " INNER JOIN SCA_GRADECURRICULAR G ON G.Cod_GRADECURRICULAR = T.COD_GRADECURRICULAR AND G.SITUACAO = 'A' "
	sql = sql & " INNER JOIN SCA_GRADECURRICULARDISCIPLINA GD ON GD.Cod_GradeCurricular = G.Cod_GRADECURRICULAR  "
	sql = sql & " WHERE T.COD_EMPRESA = HA.COD_EMPRESA "
	sql = sql & " AND COD_TURMA = HA.COD_TURMA "
	sql = sql & " and Cod_Disciplina = HA.COD_DISCIPLINA) * " & strSemanasLetivas & " AS  TOTAL_MATRIZ, "
	
	sql = sql & " (SELECT ISNULL(sum(total_aulas),'0') as TotalConteudo " 
	sql = sql & " FROM SCA_CONTEUDO  "
	sql = sql & " WHERE COD_EMPRESA = HA.COD_EMPRESA "
	sql = sql & " AND COD_TURMA = HA.COD_TURMA "
	if 	strOpcaoRelatorio = "E" then
		sql = sql & " and FECHAMENTO = 'S' "
	elseif strOpcaoRelatorio = "N" then	
		sql = sql & " and FECHAMENTO <> 'S' "
	end if	
	sql = sql & " and Cod_Disciplina = HA.COD_DISCIPLINA)  AS TOTAL_CONTEUDO, "
	
	sql = sql & " ((SELECT  " 
	sql = sql & " SUM(GD.Ch_Semanal) as total  " 
	sql = sql & " FROM SCA_TURMA T " 
	sql = sql & " INNER JOIN SCA_GRADECURRICULAR G ON G.Cod_GRADECURRICULAR = T.COD_GRADECURRICULAR AND G.SITUACAO = 'A' "
	sql = sql & " INNER JOIN SCA_GRADECURRICULARDISCIPLINA GD ON GD.Cod_GradeCurricular = G.Cod_GRADECURRICULAR " 
	sql = sql & " WHERE T.COD_EMPRESA = HA.COD_EMPRESA "
	sql = sql & " AND COD_TURMA = HA.COD_TURMA "
	sql = sql & " and Cod_Disciplina = HA.COD_DISCIPLINA) *  " & strSemanasLetivas & "  ) "
	sql = sql & " - "
	sql = sql & " (SELECT ISNULL(sum(total_aulas),'0') as TotalConteudo  "
	sql = sql & " FROM SCA_CONTEUDO " 
	sql = sql & " WHERE COD_EMPRESA = HA.COD_EMPRESA "
	sql = sql & " AND COD_TURMA = HA.COD_TURMA "
	if 	strOpcaoRelatorio = "E" then
		sql = sql & " and FECHAMENTO = 'S' "
	elseif strOpcaoRelatorio = "N" then	
		sql = sql & " and FECHAMENTO <> 'S' "
	end if	
	sql = sql & " and Cod_Disciplina = HA.COD_DISCIPLINA)  AS SALDO "
	
	sql = sql & " FROM SCA_HORARIO_AULA HA  "
	sql = sql & " INNER JOIN SCA_HORARIO H ON H.CODIGO=HA.COD_HORARIO " 
	sql = sql & " INNER JOIN SCA_TURMA T ON T.COD_TURMA=HA.COD_TURMA " 
	sql = sql & " INNER JOIN SCA_GRADECURRICULAR G ON G.COD_GRADECURRICULAR=T.COD_GRADECURRICULAR " 
	sql = sql & " INNER JOIN SCA_PERIODO P ON P.COD_PERIODO=G.COD_PERIODO " 
	sql = sql & " INNER JOIN SCA_CURSO CU ON CU.COD_CURSO=P.COD_CURSO " 
	sql = sql & " INNER JOIN SRH_COLABORADOR C ON C.CODIGO=HA.COD_COLABORADOR " 
	sql = sql & " INNER JOIN SCA_DISCIPLINA D ON D.COD_DISCIPLINA=HA.COD_DISCIPLINA " 
	sql = sql & " WHERE HA.COD_EMPRESA = " & session("CodEmpresa")
	sql = sql & " AND HA.ANOLETIVO = " & strAnoLetivo  
	sql = sql & " AND HA.SEMESTRE= " & strSemestre
    if intCodCurso <> "0" then
	   sql = sql & " and CU.Cod_Curso = " & intCodCurso
    end if
    if intCodTurma <> "0" then
	   sql = sql & " and T.COD_TURMA = " & intCodTurma
    end if
	sql = sql & " ORDER BY C.NOME, CU.DESCRICAO,T.NOMETURMA "	
	rs.open sql, cnn
	
	if not rs.eof then 
	    marcaProfessor = "1"
		While not rs.eof 
		
			%>
			  <tr height="28">
                <% if marcaProfessor = "1" then
					marcaProfessor = "2"
					%> 
			    	<td align="left" class="celula"><%=rs("PROFESSOR")%>&nbsp;</td>
                <% else %>
                	<td align="left" class="celula">&nbsp;</td>
                <% end if %>        
			    <td align="left" class="celula"><%=rs("NOMETURMA")%>&nbsp;</td>
			    <td align="left" class="celula"><%=rs("DISCIPLINA")%>&nbsp;</td>
                <% if strSemestre = "1" or strSemestre = "3" then %>
                    <td align="left" class="celula"><div align="center"><%=rs("TOTAL_JANEIRO")%>&nbsp;</div></td>
                    <td align="left" class="celula"><div align="center"><%=rs("TOTAL_FEVEREIRO")%>&nbsp;</div></td>
                    <td align="left" class="celula"><div align="center"><%=rs("TOTAL_MARCO")%>&nbsp;</div></td>
                    <td align="left" class="celula"><div align="center"><%=rs("TOTAL_ABRIL")%>&nbsp;</div></td>
                    <td align="left" class="celula"><div align="center"><%=rs("TOTAL_MAIO")%>&nbsp;</div></td>
                    <td align="left" class="celula"><div align="center"><%=rs("TOTAL_JUNHO")%>&nbsp;</div></td>
                <% else %> 
                	<td align="left" class="celula"><div align="center" class="style1">--------</div></td>
                	<td align="left" class="celula"><div align="center" class="style1">--------</div></td>
                    <td align="left" class="celula"><div align="center" class="style1">--------</div></td>
                    <td align="left" class="celula"><div align="center" class="style1">--------</div></td>
                    <td align="left" class="celula"><div align="center" class="style1">--------</div></td>
                    <td align="left" class="celula"><div align="center" class="style1">--------</div></td>
                <% end if %>
                <% if strSemestre = "2" or strSemestre = "3" then %>
                	<td align="left" class="celula"><div align="center"><%=rs("TOTAL_JULHO")%>&nbsp;</div></td>
		        	<td align="left" class="celula"><div align="center"><%=rs("TOTAL_AGOSTO")%>&nbsp;</div></td>
		        	<td align="left" class="celula"><div align="center"><%=rs("TOTAL_SETEMBRO")%>&nbsp;</div></td>
		        	<td align="left" class="celula"><div align="center"><%=rs("TOTAL_OUTUBRO")%>&nbsp;</div></td>
		        	<td align="left" class="celula"><div align="center"><%=rs("TOTAL_NOVEMBRO")%>&nbsp;</div></td>
		        	<td align="left" class="celula"><div align="center"><%=rs("TOTAL_DEZEMBRO")%>&nbsp;</div></td>
                <% else %> 
                	<td align="left" class="celula"><div align="center" class="style1">--------</div></td>
                	<td align="left" class="celula"><div align="center" class="style1">--------</div></td>
                    <td align="left" class="celula"><div align="center" class="style1">--------</div></td>
                    <td align="left" class="celula"><div align="center" class="style1">--------</div></td>
                    <td align="left" class="celula"><div align="center" class="style1">--------</div></td>
                    <td align="left" class="celula"><div align="center" class="style1">--------</div></td>
    			<% end if %>
		        <td align="left" class="celula"><div align="center"><%=rs("TOTAL_CONTEUDO")%>&nbsp;</div></td>
		        <td align="left" class="celula"><div align="center"><%=rs("TOTAL_MATRIZ")%>&nbsp;</div></td>
		        <td align="left" class="celula"><div align="center"><strong><%=rs("TOTAL_CONTEUDO") - rs("TOTAL_MATRIZ")%></strong>&nbsp;</div></td>
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
			intQtdeRegistroPorPagina = intQtdeRegistroPorPagina + 1
			imprimeNomeProfessor = rs("PROFESSOR")
			rs.movenext
			if not rs.eof then
			  	if trim(imprimeNomeProfessor) <> trim(rs("PROFESSOR")) then
			   		marcaProfessor = "1"
				end if
			end if		
		wend
		contPeriodo = contPeriodo + 1
	else
		%>
		  <tr>
			<td colspan="18" class="celula" align="center"><br><br><br><br><font color="#993300"><%=session("strMensagemRelatorioNaoEncontrado")%></font></td>
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