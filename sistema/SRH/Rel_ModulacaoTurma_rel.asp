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
<title><%=session("Titulo")%> - Modulação</title>
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
<!--#include file=../../includes/inc_aguarde.asp-->
<br>
<%
	dim intPagina
	dim strInfoTurma
	

	strSemestre 			= Trim(Request.Form("cmbSemestre"))
	strAnoLetivo 			= Trim(Request.Form("txtAnoLetivo"))

	intCodCurso				= Trim(Request.Form("cmbCurso"))
	intCodTurno		 		= Trim(Request.Form("cmbTurno"))
	intCodTurma 			= Trim(Request.Form("cmbTurma"))
	intCodDisciplina		= Trim(Request.Form("cmbDisciplina"))
	intCodDiaSemana			= Trim(Request.Form("cmbDiaSemana"))
	strDataI				= formatadataAP(request.Form("txtDataI"))
	strDataF				= formatadataAP(request.Form("txtDataF"))
	
	intAnoLetivo 			= Trim(Request.Form("txtAnoLetivo"))
	if intAnoLetivo = "" then 	intAnoLetivo 			= session("strAnoLetivo")
	intSemestre 			= Trim(Request.Form("cmbSemestre"))
	if intSemestre = "" then 	intSemestre 			= session("strSemestre")



	if strAnoLetivo = "" then strAnoLetivo = session("strAnoLetivo")
	if strSemestre = "" then strSemestre = "0"

	strFiltroSerie = "0"
	strFiltroTurno = "0"


	strTituloRelatorio  	= "MODULAÇÃO ANALÍTICA DOCENTES - TURMA"

	sub mostraCabecalho()
	%>
	<!--#include file="../../includes/inc_cabecalhoRelatorio.asp"-->
	<br>
	<table width="98%" border="0" cellspacing="0" cellpadding="0" class="tabela" align="center">
	  <tr bgcolor="#CCCCCC">
	    <td width="32%" rowspan="2" class="celula"><div align="center"><strong>Disciplina</strong></div></td>
	    <td width="44%" rowspan="2" class="celula"><div align="center"><strong>Colaborador</strong></div></td>
	    <td colspan="3" align="center" class="celula"><strong>C. H Semanal </strong></td>
      </tr>
	  <tr bgcolor="#CCCCCC">
	    <td width="8%" align="center" class="celula"><strong>Matriz</strong></td>
	    <td width="8%" align="center" class="celula"><strong>Hor&aacute;rio</strong></td>
        <td width="8%" align="center" class="celula"><strong>Horas</strong></td>
	  </tr>
	  
	<%
	end Sub
	
	sub fimTabela()
		response.Write("</table>")
	end Sub

	intPagina = 1
	mostraCabecalho
	cont = 0
	
	
	teste=""
	sql = "select "
	sql = sql & " 	HA.Cod_Colaborador, "
	sql = sql & " 	C.nome AS COLABORADOR, "
	sql = sql & " 	T.NomeTurma, "
	sql = sql & " 	d.Desc_Disciplina AS Disciplina, "
	sql = sql & " 	H.hora_relogio, "
	sql = sql & " 	HA.Turma_Juncao, "
	sql = sql & " 	isnull(GD.Ch_Semanal,'0') as Matriz, "
	sql = sql & " 	isnull(C.carga_horario_contratada,'0') as Horas_contratada, "
	sql = sql & " 	isnull(C.total_aulas,'0') as Contrato, "
	sql = sql & " 	isnull(C.salario_base,'0') as salario_base, N.descricao as nivel, "
	sql = sql & " 	isnull(N.valor_hora,'0') as valor_hora_aula, "
	sql = sql & " 	isnull(C.percentual_repouso_semanal,'1') as repousosemanal, "
	sql = sql & " 	H.numero_aula, "
	sql = sql & " 	sum(convert(int,h.numero_aula)) AS horario "
	sql = sql & " 	from SRH_COLABORADOR C "
	sql = sql & " 	left join SCA_HORARIO_AULA HA on HA.Cod_Colaborador = C.codigo "
	sql = sql & " 	left join SCA_HORARIO H on H.codigo = HA.Cod_Horario "
	sql = sql & " 	left join SCA_DISCIPLINA D on D.Cod_Disciplina = HA.Cod_Disciplina "
	sql = sql & " 	left join SCA_TURMA T on T.Cod_Turma = HA.Cod_turma "
	sql = sql & " 	left join SCA_GRADECURRICULAR G on G.Cod_GradeCurricular = T.Cod_GradeCurricular "
	sql = sql & " 	left join SCA_GRADECURRICULARDISCIPLINA GD on GD.Cod_GradeCurricular = G.Cod_GradeCurricular and GD.Cod_Disciplina = D.Cod_Disciplina "
	sql = sql & " 	left join SRH_NIVEL N on N.codigo = C.cod_nivel "
	sql = sql & " WHERE  (C.codLotacao = " & session("CodEmpresa") & " OR C.nome = 'DEFICIT') "
	sql = sql & " and T.COD_EMPRESA = " & session("CodEmpresa")
	sql = sql & " and H.anoLetivo =  " & strAnoLetivo 
	sql = sql & " and C.modular = 'S'"
	if strSemestre<> "0" then
		sql = sql & " and H.semestre = " & strSemestre
	end if
	if intCodTurma<>"0" then
		sql = sql & " and T.cod_turma = " & intCodTurma
	end if
	if intCodDisciplina<>"0" then
		sql = sql & " and D.Cod_Disciplina = " & intCodDisciplina
	end if
	if intCodDiaSemana<>"0" then
		sql = sql & " and HA.DiaSemana = " & intCodDiaSemana
	end if
	sql = sql & " 	GROUP BY HA.Cod_Colaborador, C.nome, T.NomeTurma, H.hora_relogio, HA.Turma_Juncao, d.Desc_Disciplina, GD.Ch_Semanal, C.carga_horario_contratada, C.total_aulas, C.salario_base, N.descricao, N.valor_hora, C.percentual_repouso_semanal, H.numero_aula "
	sql = sql & " 	order by  T.NomeTurma, d.Desc_Disciplina "
	
	'response.Write(sql)
	
	rs.open sql, cnn
	if not rs.eof then 
		codColaborador = ""
		controle = 0
		ControleDisciplina = 0
		intTotalContrato = 0
		intTotalMatriz = 0
		intTotalHorario = 0
	  	intTotalHoraAula = 0
		intTotalAulasExtras = 0
        intTotalHoraRelogio	= 0	
		While not rs.eof 

			if not isnull(rs("Contrato")) then 'Contrato
				Contrato = rs("Contrato")
			else
				Contrato = 0
			end if
			
			if not isnull(rs("Matriz")) then 'Matriz
				Matriz = rs("Matriz")
			else
				Matriz	= 0
			end if
			
			if not isnull(rs("Horario")) then 'Horário
				Horario = rs("Horario")
			else
				Horario	= 0
			end if
			if not isnull(rs("hora_relogio")) then
				HoraRelogio = ( rs("hora_relogio") * Horario ) / 60 
			else
				HoraRelogio	= 0
			end if
			'Totalizadores parciais
  		    if trim(ControleDisciplina) = 0 then
			   intTotalMatriz = intTotalMatriz + Matriz
			end if   
			intTotalHorario = intTotalHorario + Horario
			intTotalHoraRelogio = intTotalHoraRelogio + HoraRelogio
			
			' Totalizadores Gerais
			intTotalContratoGeral = intTotalContratoGeral + Contrato
			intTotalMatrizGeral = intTotalMatrizGeral + Matriz
			intTotalHorarioGeral = intTotalHorarioGeral + Horario
			'
			strMostraHorario = Horario
			if cInt(Matriz) = 0  or cInt(Horario) = 0 then
				strMostraHorario = "<font color='#FF0000'>" & Horario & "</font>"
			else	
				if cInt(Matriz) <> cInt(Horario) then
				   strMostraHorario = "<font color='#FF0000'>" & Horario & "</font>"
				end if 
			end if
			if cInt(AulasExtras) < 0 then
				strMostraAulasExtras = "<font color='#FF0000'>" & AulasExtras & "</font>"
			end if
			if controle = 0 then
				%>
				<tr>
				<td colspan="5" align="left" class="celula"><strong><font size="2">&nbsp;<%=rs("Nometurma")%></font></strong></td>
				</tr>
				<%
				controle = 1
            end if
			
			%>
			<tr>
			<%
			if trim(ControleDisciplina) = 0 then
			   %>
			   <td align="center" class="celula"><div align="left">&nbsp;<%=rs("disciplina")%></div></td>
			   <%
			else
			   %>
			   <td align="center" class="celula">&nbsp;</td>
			   <%
			end if   
			%>
			<td align="left" class="celula"><%=rs("Colaborador")%></td>
			<%
			if trim(ControleDisciplina) = 0 then
			   %>
			   <td align="right" class="celula"><%=rs("matriz")%>&nbsp;</td>
			   <%
			else
			   %>
			   <td align="right" class="celula">&nbsp;</td>
			   <%
			end if   
            %>
			<td align="right" class="celula"><%=strMostraHorario%>&nbsp;</td>
			<td align="right" class="celula"><%=round(HoraRelogio,2)%>&nbsp;</td>
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
			Nometurma = trim(rs("Nometurma"))
			disciplina = trim(rs("disciplina"))
			rs.movenext
			if not rs.eof then 
			   Nometurma1 = trim(rs("Nometurma"))
			   disciplina1 = trim(rs("disciplina"))
			else
				intTotalAulasExtras = Contrato - intTotalHorario
			    strMostraSituacao = "<font color='#FF0000'> < ERRO > </font>"
    			if cInt(intTotalMatriz) = cInt(intTotalHorario) then
			   		strMostraSituacao = "<font color='#FF0000'>MODULADO - OK</font>"
				end if   
  				%>
				<tr bgcolor="#EAEAEA">
				<td align="right" class="celula">&nbsp;</td>
				<td align="right" class="celula"><strong>Totais...&nbsp;</strong></td>
				<td align="right" class="celula"><strong><strong><%=intTotalMatriz%>&nbsp;</strong></strong></td>
				<td align="right" class="celula"><strong><strong><%=intTotalHorario%>&nbsp;</strong></strong></td>
				<td align="right" class="celula"><strong><%=round(intTotalHoraRelogio,2)%>&nbsp;</strong></td>
				</tr>
				<tr bgcolor="#EAEAEA">
				<td colspan="3" align="right" class="celula"><div align="center"> <strong>Aulas Contratadas:&nbsp;<%=Contrato%>&nbsp;&nbsp;-&nbsp;&nbsp;Aulas Extra Classe:&nbsp;<%=intTotalAulasExtras%></strong>&nbsp;&nbsp;</div></td>
				<td bgcolor="#EAEAEA" align="right" class="celula"><strong>Situa&ccedil;&atilde;o:</strong></td>
				<td bgcolor="#EAEAEA" align="right" class="celula"><strong><%=strMostraSituacao%></strong>&nbsp;</td>
				</tr>
				<% 
			end if 
			if trim(disciplina) = trim(disciplina1) then
				ControleDisciplina = 1
			else
				ControleDisciplina = 0
			end if	
 
			if trim(Nometurma)<>trim(Nometurma1) then
				intTotalAulasExtras = Contrato - intTotalHorario
			    strMostraSituacao = "<font color='#FF0000'> < ERRO > </font>"
   				if cInt(intTotalMatriz) = cInt(intTotalHorario) then
			   		strMostraSituacao = "<font color='#FF0000'>MODULADO - OK</font>"
				end if   
				%>
				<tr bgcolor="#EAEAEA">
				<td align="right" class="celula">&nbsp;</td>
				<td align="right" class="celula"><strong>Totais...&nbsp;</strong></td>
				<td align="right" class="celula"><strong><strong><%=intTotalMatriz%>&nbsp;</strong></strong></td>
				<td align="right" class="celula"><strong><strong><%=intTotalHorario%>&nbsp;</strong></strong></td>
				<td align="right" class="celula"><strong><%=round(intTotalHoraRelogio,2)%>&nbsp;</strong></td>
				</tr>
				<tr bgcolor="#EAEAEA">
				<td colspan="3" align="right" class="celula"><div align="center"> <strong>Aulas Contratadas:&nbsp;<%=Contrato%>&nbsp;&nbsp;-&nbsp;&nbsp;Aulas Extra Classe:&nbsp;<%=intTotalAulasExtras%></strong>&nbsp;&nbsp;</div></td>
				<td align="right" class="celula"><strong>Situa&ccedil;&atilde;o:</strong></td>
				<td align="right" class="celula"><strong><%=strMostraSituacao%></strong>&nbsp;</td>
				</tr>
				<%
				controle = 0
				intTotalContrato =0
				intTotalMatriz = 0
				intTotalHorario = 0
				intTotalAulasExtras = 0
				intTotalHoraAula = 0
				intTotalHoraRelogio = 0
			end if
		wend
	else
		%>
		<tr>
		  <td colspan="5" class="celula" align="center"><br><br><br><br><font color="#993300"><%=session("strMensagemRelatorioNaoEncontrado")%></font></td>
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
