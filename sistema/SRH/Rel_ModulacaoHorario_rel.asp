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


	strTituloRelatorio  	= "MODULAÇÃO ANALÍTICA DOCENTES"

	sub mostraCabecalho()
	%>
	<!--#include file="../../includes/inc_cabecalhoRelatorio.asp"-->
	<br>
	<table width="98%" border="0" cellspacing="0" cellpadding="0" class="tabela" align="center">
	  <tr bgcolor="#CCCCCC">
	    <td width="7%" rowspan="2" align="center" class="celula"><strong>Turma</strong></td>
	    <td width="13%" rowspan="2" align="center" class="celula"><strong>Hor&aacute;rio</strong></td>
	    <td width="8%" rowspan="2" align="center" class="celula"><strong>Dia Semana</strong></td>
	    <td width="7%" rowspan="2" align="center" class="celula"><strong>Per&iacute;odo</strong></td>
	    <td width="23%" rowspan="2" class="celula"><div align="center"><strong>Disciplina</strong></div></td>
	    <td colspan="2" align="center" class="celula"><strong>C. H Semanal </strong></td>
	    <td width="8%" rowspan="2" align="center" class="celula"><strong> Vr H.A x Total aulas </strong></td>
	    <td width="8%" rowspan="2" align="center" class="celula"><strong>Vr. a Receber c/ RSR </strong></td>
      </tr>
	  <tr bgcolor="#CCCCCC">
	    <td width="4%" align="center" class="celula"><strong>Aulas</strong></td>
        <td width="4%" align="center" class="celula"><strong>Horas</strong></td>
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
	
	sql = "select "
	sql = sql & " 	HA.Cod_Colaborador, "
	sql = sql & " 	C.nome AS COLABORADOR, "
	sql = sql & " 	T.NomeTurma, "
	sql = sql & " 	HA.DiaSemana, "
	sql = sql & " 	HA.Sequencia, "
	sql = sql & " 	HA.Tempo, H.horario, H.numero_aula, H.hora_relogio, HA.Turma_Juncao, "
	sql = sql & " 	d.Desc_Disciplina AS Disciplina, "
	sql = sql & " 	isnull(GD.Ch_Semanal,'0') as CH_cumprida"
	sql = sql & " from SRH_COLABORADOR C"
	sql = sql & " left join SCA_HORARIO_AULA HA on HA.Cod_Colaborador = C.codigo "
	sql = sql & " left join SCA_HORARIO H on H.codigo = HA.Cod_Horario and H.cod_empresa = HA.Cod_Empresa"
	sql = sql & " left join SCA_DISCIPLINA D on D.Cod_Disciplina = HA.Cod_Disciplina and D.cod_empresa = HA.Cod_Empresa"
	sql = sql & " left join SCA_TURMA T on T.Cod_Turma = HA.Cod_turma and T.AnoLetivo = H.anoLetivo and T.Cod_Semestre = HA.Semestre and T.Cod_Empresa = HA.Cod_Empresa"
	sql = sql & " left join SCA_GRADECURRICULAR G on G.Cod_GradeCurricular = T.Cod_GradeCurricular and D.cod_empresa = HA.Cod_Empresa"
	sql = sql & " left join SCA_GRADECURRICULARDISCIPLINA GD on GD.Cod_GradeCurricular = G.Cod_GradeCurricular and GD.Cod_Disciplina = D.Cod_Disciplina"
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
	sql = sql & " order by C.nome, HA.DiaSemana"
	rs.open sql, cnn
	if not rs.eof then 
		codColaborador = ""
		controle = 0
		intTotalCHCumprida = 0
		intTotalHoraRelogioCumprida = 0
	  	intSaldo = 0
	  	intTotalHoraAula = 0
	  	intTotalHoraAulaRSR = 0
		CH_cumprida = 1
		intCHContratadaGeral = 0
		While not rs.eof 

            if isnull(rs("Turma_Juncao")) then
			    'if not isnull(rs("CH_cumprida")) then   'Matríz Curricular
		        '   	NumeroAulas = rs("CH_cumprida")
		    	'else
		       	'	NumeroAulas	= 1
		    	'end if
				
			    if not isnull(rs("numero_aula")) then 'Horário
		           	NumeroAulas = rs("numero_aula")
		    	else
		       		NumeroAulas	= 1
		    	end if
				
		    	CalculaNumeroaulas = (CH_cumprida * numeroAulas)
				   
				if not isnull(rs("hora_relogio")) then
		       		HoraRelogio = rs("hora_relogio") / 60
		    	else
		       		HoraRelogio	= 0
		    	end if
 			else
				NumeroAulas	= 0
				HoraRelogio	= 0
				CalculaNumeroaulas = 0
			end if	
			
			if trim(rs("cod_colaborador"))<>trim(codColaborador) and controle = 1 then
			
				intSaldo = cInt(intCHContratada) - cInt(intTotalCHCumprida)
				intSaldoHoras = cInt(Horas_contratada) - cInt(intTotalHoraRelogioCumprida)
				intSaldoAulas = cInt(Aulas_contratada) - cInt(intTotalCHCumprida)
				intSalarioBaseSaldo = cCur(intSalarioBase) - cCur(intTotalHoraAulaRSR)
				
				intSaldoGeral = intSaldoGeral + intSaldo
				intSalarioBaseSaldoGeral = intSalarioBaseSaldoGeral + intSalarioBaseSaldo
				intCHContratadaGeral = intCHContratadaGeral + Aulas_contratada
				intSalarioBaseContratadoGeral = intSalarioBaseContratadoGeral + intSalarioBase 

				strMostraSaldo = intSaldo
				if cInt(intSaldo) <> 0 then
					strMostraSaldo = "<font color='#FF0000'>" & intSaldo & "</font>"
				end if
				strMostraSaldoSalario = intSalarioBaseSaldo
				if cInt(intSalarioBaseSaldo) <> 0 then
					strMostraSaldoSalario = "<font color='#FF0000'>" & formatNumber(intSalarioBaseSaldo,2) & "</font>"
				end if

				strMostraSaldoHoras = intSaldoHoras
				if cInt(strMostraSaldoHoras) <> 0 then
					strMostraSaldoHoras = "<font color='#FF0000'>" & strMostraSaldoHoras & "</font>"
				end if
				
				strMostraSaldoAulas = intSaldoAulas
				if cInt(strMostraSaldoAulas) <> 0 then
					strMostraSaldoAulas = "<font color='#FF0000'>" & strMostraSaldoAulas & "</font>"
				end if

			   %>
			 <tr bgcolor="#EAEAEA">
			   <td colspan="5" align="right" class="celula"><strong>Total Ministrado&nbsp;</strong></td>
			   <td align="right" class="celula"><strong><strong><%=intTotalCHCumprida%></strong>&nbsp;</strong></td>
			   <td align="right" class="celula"><strong><%=ROUND(intTotalHoraRelogioCumprida,2)%>&nbsp;</strong></td>
			   <td align="right" class="celula"><strong><%=FormatNumber(intTotalHoraAula,2)%></strong></td>
			   <td align="right" class="celula"><strong><%=FormatNumber(intTotalHoraAulaRSR,2)%>&nbsp;</strong></td>
	  </tr>
			 <tr bgcolor="#EAEAEA">
			   <td colspan="5" align="right" class="celula"><strong>Total Contratado&nbsp;</strong></td>
			   <td align="right" class="celula"><strong><strong><%=Aulas_contratada%>&nbsp;</strong></strong></td>
			   <td align="right" class="celula"><strong><%=Horas_contratada%>&nbsp;</strong></td>
			   <td align="right" class="celula">&nbsp;</td>
			   <td align="right" class="celula"><strong><strong><%=FormatNumber(intSalarioBase,2)%></strong>&nbsp;</strong></td>
      </tr>
			 <tr bgcolor="#EAEAEA">
			   <td colspan="5" align="right" class="celula"><strong>Saldo. (Total Contratado - Total Ministrado )&nbsp;</strong></td>
			   <td align="right" class="celula"><strong><%=strMostraSaldoAulas%>&nbsp;</strong></td>
			   <td align="right" class="celula"><strong><strong><%=strMostraSaldoHoras%></strong>&nbsp;</strong></td>
			   <td align="right" class="celula">&nbsp;</td>
			   <td align="right" class="celula"><strong><strong><%=strMostraSaldoSalario%></strong>&nbsp;</strong></td>
      </tr>
			 
		<%  if strDataI <> "" and strDataF <> "" then 
  				intTotalSubstituicoes = 0
				sql = "select CF.cod_empresa, CF.ano_letivo, CF.semestre_letivo, C.CodFuncional, C.nome, sum(convert(int,numero_aula)) as aula "
				sql = sql & " 	from dbo.SRH_COLABORADOR_FREQUENCIA CF "
				sql = sql & " 	INNER JOIN SRH_COLABORADOR C ON C.CODIGO = CF.COD_COLABORADORSUBSTITUTO "
				sql = sql & " 	LEFT JOIN SCA_TURMA T ON T.COD_EMPRESA = CF.COD_EMPRESA AND T.COD_TURMA = CF.COD_TURMA " 
				sql = sql & " 	LEFT JOIN SCA_GRADECURRICULAR G ON G.COD_EMPRESA=T.COD_EMPRESA AND G.COD_GRADECURRICULAR=T.COD_GRADECURRICULAR " 
				sql = sql & " 	LEFT JOIN SCA_PERIODO P ON P.COD_EMPRESA=T.COD_EMPRESA AND P.COD_PERIODO=G.COD_PERIODO " 
				sql = sql & " 	LEFT JOIN SCA_CURSO CU ON CU.COD_EMPRESA=T.COD_EMPRESA AND CU.COD_CURSO=P.COD_CURSO "
				sql = sql & "   WHERE  (C.codLotacao = " & session("CodEmpresa") & " OR C.nome = 'DEFICIT') "
				sql = sql & " 	AND CF.NUMERO_AULA <> 0 "
				sql = sql & " 	AND CF.COD_COLABORADORSUBSTITUTO = " & rs("cod_colaborador")
	            sql = sql & " AND CF.FECHAMENTO = 'S' "  ' se o movimento estiver fechado
				sql = sql & " and convert(datetime,convert(varchar, CF.DATALANCAMENTO, 103),103) >=  convert(datetime, ' " & strDataI & "',103)"
				sql = sql & " and convert(datetime,convert(varchar, CF.DATALANCAMENTO, 103),103) <=  convert(datetime, ' " & strDataF & "',103)"
				sql = sql & " 	group by CF.cod_empresa, ano_letivo, semestre_letivo, c.nome, C.CodFuncional " 
				sql = sql & " 	order by c.nome "
				rsaux.open sql, cnn
				if not rsaux.eof then
					intTotalSubstituicoes = rsaux("aula") 
				end if
				rsaux.close	
				
				intTotalFaltas = 0
				sql = "select CF.cod_empresa, CF.ano_letivo, CF.semestre_letivo, C.CodFuncional, C.nome, sum(convert(int,numero_falta)) as falta "
				sql = sql & " 	from dbo.SRH_COLABORADOR_FREQUENCIA CF "
				sql = sql & " 	INNER JOIN SRH_COLABORADOR C ON C.CODIGO = CF.COD_COLABORADOR"
				sql = sql & " 	LEFT JOIN SCA_TURMA T ON T.COD_EMPRESA = CF.COD_EMPRESA AND T.COD_TURMA = CF.COD_TURMA " 
				sql = sql & " 	LEFT JOIN SCA_GRADECURRICULAR G ON G.COD_EMPRESA=T.COD_EMPRESA AND G.COD_GRADECURRICULAR=T.COD_GRADECURRICULAR " 
				sql = sql & " 	LEFT JOIN SCA_PERIODO P ON P.COD_EMPRESA=T.COD_EMPRESA AND P.COD_PERIODO=G.COD_PERIODO " 
				sql = sql & " 	LEFT JOIN SCA_CURSO CU ON CU.COD_EMPRESA=T.COD_EMPRESA AND CU.COD_CURSO=P.COD_CURSO "
				sql = sql & "   WHERE  (C.codLotacao = " & session("CodEmpresa") & " OR C.nome = 'DEFICIT') "
				sql = sql & " 	AND CF.NUMERO_FALTA <> 0 "
				sql = sql & " 	AND CF.COD_COLABORADOR = " & rs("cod_colaborador")
				sql = sql & "   AND CF.SITUACAO <> 'S' "  'se não estiver abonada
	            sql = sql & "   AND CF.FECHAMENTO = 'S' "  ' se o movimento estiver fechado
 				sql = sql & " and convert(datetime,convert(varchar, CF.DATALANCAMENTO, 103),103) >=  convert(datetime, ' " & strDataI & "',103)"
				sql = sql & " and convert(datetime,convert(varchar, CF.DATALANCAMENTO, 103),103) <=  convert(datetime, ' " & strDataF & "',103)"
				sql = sql & " 	group by CF.cod_empresa, ano_letivo, semestre_letivo, c.nome, C.CodFuncional " 
				sql = sql & " 	order by c.nome "
				rsaux.open sql, cnn
				if not rsaux.eof then
					intTotalFaltas = rsaux("Falta") 
				end if
				rsaux.close	
				 %>
				
					<tr bgcolor="#EAEAEA">
					<td colspan="9" align="right" class="celula"><font color='##0000FF'><div align="right"><strong>Período de&nbsp;<%=strDataI%>&nbsp;à&nbsp;<%=strDataF%>&nbsp; -  Faltas:&nbsp;<%=intTotalFaltas%>&nbsp;- Substitui&ccedil;&otilde;es:&nbsp;<%=intTotalSubstituicoes%>&nbsp; </strong></div><font></td>
        <% end if %>
      </tr>
			 
              <%
			  controle = 1
			  intTotalCHCumprida = 0
			  intTotalHoraRelogioCumprida = 0
			  intSaldo = 0
			  intTotalHoraAula = 0
			  intTotalHoraAulaRSR = 0
			end if
            if trim(rs("cod_colaborador"))<>trim(codColaborador) then
			
				valor_hora_aula = 0 
				Aulas_contratada = 0
				Horas_contratada = 0
				salario_base = 0
				nivel = ""

				sql = "select "
				sql = sql & " 	isnull(C.carga_horario_contratada,'0') as Horas_contratada,"
				sql = sql & " 	isnull(C.total_aulas,'0') as Aulas_contratada,"
				sql = sql & " 	isnull(C.salario_base,'0') as salario_base,"
				sql = sql & " 	N.descricao as nivel,"
				sql = sql & " 	isnull(N.valor_hora,'0') as valor_hora_aula, "
				sql = sql & " 	isnull(C.percentual_repouso_semanal,'1') as repousosemanal "
				sql = sql & " from SRH_COLABORADOR C"
				sql = sql & " left join SRH_NIVEL N on N.codigo = C.cod_nivel"
				sql = sql & " WHERE  (C.codLotacao = " & session("CodEmpresa") & " OR C.nome = 'DEFICIT') "
				sql = sql & " and C.codigo =  " & rs("cod_colaborador") 
				sql = sql & " and N.tipo_vinculo = 'D'"
				rsaux.open sql, cnn
				if not rsaux.eof then
					valor_hora_aula = rsaux("valor_hora_aula")
					Aulas_contratada = rsaux("Aulas_contratada")
					Horas_contratada = rsaux("Horas_contratada")
					Aulas_contratadaGeral = Aulas_contratadaGeral + rsaux("Aulas_contratada")
					Horas_contratadaGeral = Horas_contratadaGeral + rsaux("Horas_contratada")
					salario_base = rsaux("salario_base") 
					nivel = rsaux("nivel") 
					percentualrepousosemanal = rsaux("repousosemanal") 
				end if
				rsaux.close	
				
				%>
				<tr>
					<td colspan="9" align="left" class="celula"><strong><font size="2">&nbsp;<%=rs("cod_colaborador")%>&nbsp;-&nbsp;<%=rs("colaborador")%>&nbsp;(<%=nivel%>)</font></strong></td>
				</tr>
				<%
				controle = 1
				intSalarioBase = salario_base
			end if
			
			valor_hora_total_aula = valor_hora_aula * HoraRelogio 
			valor_hora_aulaRSR = ( valor_hora_aula * HoraRelogio ) * percentualrepousosemanal
			
			
		    intSalarioBaseMinistradoGeral = intSalarioBaseMinistradoGeral + valor_hora_aulaRSR


			%>
			  <tr>
			    <td align="left" class="celula">&nbsp;<%=rs("nometurma")%></td>
			    <td align="left" class="celula">&nbsp;<%=rs("horario")%></td>
			    <td align="left" class="celula">&nbsp;<%=WeekDayName(rs("DiaSemana"))%></td>
			    <td align="left" class="celula">&nbsp;<%=rs("tempo")%> Tempo</td>
			    <td align="left" class="celula">&nbsp;<%=rs("disciplina")%></td>
			    <td align="right" class="celula"><%=CalculaNumeroaulas%>&nbsp;</td>
			    <td align="right" class="celula"><%=ROUND(HoraRelogio,2)%>&nbsp;</td>
			    <td align="right" class="celula"><%=FormatNumber(valor_hora_total_aula,2)%></td>
			    <td align="right" class="celula"><%=FormatNumber(valor_hora_aulaRSR,2)%>&nbsp;</td>
		      </tr>
			<%
			intTotalHoraAula = intTotalHoraAula + (valor_hora_aula * HoraRelogio )
			intTotalHoraAulaGeral = intTotalHoraAulaGeral + intTotalHoraAula
			intTotalCHCumprida = intTotalCHCumprida + CalculaNumeroaulas
			intTotalCHCumpridaGeral = intTotalCHCumpridaGeral + CalculaNumeroaulas
			intTotalHoraAulaGeral = intTotalHoraAulaGeral + valor_hora_aula
			
			intTotalHoraRelogioCumprida = intTotalHoraRelogioCumprida + HoraRelogio
			intTotalHoraRelogioCumpridaGeral = intTotalHoraRelogioCumpridaGeral + HoraRelogio
			intTotalHoraAulaRSR = intTotalHoraAula  * percentualrepousosemanal
		
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
			codColaborador = trim(rs("cod_colaborador"))
			rs.movenext
		wend
		
		contPeriodo = contPeriodo + 1
			
		intSaldo = cInt(intCHContratada) - cInt(intTotalCHCumprida)
		intSalarioBaseSaldo = cCur(intSalarioBase) - cCur(intTotalHoraAulaRSR)
			
		strMostraSaldo = intSaldo
		if cInt(intSaldo) <> 0 then
			strMostraSaldo = "<font color='#FF0000'>" & intSaldo & "</font>"
		end if
		strMostraSaldoSalario = intSalarioBaseSaldo
		if cInt(intSalarioBaseSaldo) <> 0 then
			strMostraSaldoSalario = "<font color='#FF0000'>" & formatNumber(intSalarioBaseSaldo,2) & "</font>"
		end if
		strSalarioBaseContratadoGeral = intSalarioBaseContratadoGeral
		if intSalarioBaseContratadoGeral <> 0 then
			strSalarioBaseContratadoGeral = formatNumber(intSalarioBaseContratadoGeral,2)
		end if
		strSalarioBaseMinistradoGeral = intSalarioBaseMinistradoGeral
		if intSalarioBaseMinistradoGeral <> 0 then
			strSalarioBaseMinistradoGeral = formatNumber(strSalarioBaseMinistradoGeral,2)
		end if
		
		%>
		 <tr bgcolor="#EAEAEA">
		   <td colspan="5" align="right" class="celula"><strong>Total Ministrado&nbsp;</strong></td>
		   <td align="right" class="celula"><strong><%=intTotalCHCumprida%>&nbsp;</strong></td>
		   <td align="right" class="celula"><%=ROUND(intTotalHoraRelogioCumprida,2)%>&nbsp;</td>
		   <td align="right" class="celula"><strong><%=FormatNumber(intTotalHoraAula,2)%></strong></td>
		   <td align="right" class="celula"><strong><%=FormatNumber(intTotalHoraAulaRSR,2)%>&nbsp;</strong></td>
		</tr>
        <tr bgcolor="#EAEAEA">
           <td colspan="5" align="right" class="celula"><strong>Total Contratado&nbsp;</strong></td>
           <td align="right" class="celula"><strong><strong><%=Aulas_contratada%></strong>&nbsp;</strong></td>
           <td align="right" class="celula"><strong><%=Horas_contratada%></strong>&nbsp;</td>
           <td align="right" class="celula">&nbsp;</td>
           <td align="right" class="celula"><strong><strong><%=FormatNumber(intSalarioBase,2)%></strong>&nbsp;</strong></td>
        </tr>
        <tr bgcolor="#EAEAEA">
          <td colspan="5" align="right" class="celula"><strong>Saldo. (Total Contratado - Total Ministrado )</strong></td>
          <td align="right" class="celula"><strong><%=strMostraSaldoAulas%>&nbsp;</strong></td>
          <td align="right" class="celula"><strong><%=strMostraSaldoHoras%>&nbsp;</strong></td>
          <td align="right" class="celula">&nbsp;</td>
          <td align="right" class="celula"><strong><strong><%=strMostraSaldoSalario%></strong>&nbsp;</strong></td>
        </tr>
        <%
		intSaldoGeral = cInt(intCHContratadaGeral) - cInt(intTotalCHCumpridaGeral)
		intSaldoHoraRelogioGeral = cCur(Horas_contratadaGeral) - cCur(intTotalHoraRelogioCumpridaGeral)
		intSaldoSalarioGeral = cCur(intSalarioBaseContratadoGeral) - cCur(intSalarioBaseMinistradoGeral)

		strMostraSaldoGeral = intSaldoGeral
		if cInt(intSaldoGeral) <> 0 then
			strMostraSaldGeral = "<font color='#FF0000'>" & intSaldoGeral & "</font>"
		end if
		strMostraSaldoHoraRelogioGeral = intSaldoHoraRelogioGeral
		if intSaldoHoraRelogioGeral <> 0 then
			strMostraSaldoHoraRelogioGeral = "<font color='#FF0000'>" & formatNumber(strMostraSaldoHoraRelogioGeral,2) & "</font>"
		end if
		strMostraSaldoSalarioGeral = intSaldoSalarioGeral
		if intSaldoSalarioGeral <> 0 then
			strMostraSaldoSalarioGeral = "<font color='#FF0000'>" & formatNumber(intSaldoSalarioGeral,2) & "</font>"
		end if
		
		if strDataI <> "" and strDataF <> "" then 
  				intTotalSubstituicoes = 0
				sql = "select CF.cod_empresa, CF.ano_letivo, CF.semestre_letivo, C.CodFuncional, C.nome, sum(convert(int,numero_aula)) as aula "
				sql = sql & " 	from dbo.SRH_COLABORADOR_FREQUENCIA CF "
				sql = sql & " 	INNER JOIN SRH_COLABORADOR C ON C.CODIGO = CF.COD_COLABORADORSUBSTITUTO "
				sql = sql & " 	LEFT JOIN SCA_TURMA T ON T.COD_EMPRESA = CF.COD_EMPRESA AND T.COD_TURMA = CF.COD_TURMA " 
				sql = sql & " 	LEFT JOIN SCA_GRADECURRICULAR G ON G.COD_EMPRESA=T.COD_EMPRESA AND G.COD_GRADECURRICULAR=T.COD_GRADECURRICULAR " 
				sql = sql & " 	LEFT JOIN SCA_PERIODO P ON P.COD_EMPRESA=T.COD_EMPRESA AND P.COD_PERIODO=G.COD_PERIODO " 
				sql = sql & " 	LEFT JOIN SCA_CURSO CU ON CU.COD_EMPRESA=T.COD_EMPRESA AND CU.COD_CURSO=P.COD_CURSO "
				sql = sql & "   WHERE  (C.codLotacao = " & session("CodEmpresa") & " OR C.nome = 'DEFICIT') "
				sql = sql & " 	AND CF.NUMERO_AULA <> 0 "
				sql = sql & " 	AND CF.COD_COLABORADORSUBSTITUTO = " & trim(codColaborador)
	            sql = sql & " AND CF.FECHAMENTO = 'S' "  ' se o movimento estiver fechado
				sql = sql & " and convert(datetime,convert(varchar, CF.DATALANCAMENTO, 103),103) >=  convert(datetime, ' " & strDataI & "',103)"
				sql = sql & " and convert(datetime,convert(varchar, CF.DATALANCAMENTO, 103),103) <=  convert(datetime, ' " & strDataF & "',103)"
				sql = sql & " 	group by CF.cod_empresa, ano_letivo, semestre_letivo, c.nome, C.CodFuncional " 
				sql = sql & " 	order by c.nome "
				rsaux.open sql, cnn
				if not rsaux.eof then
					intTotalSubstituicoes = rsaux("aula") 
				end if
				rsaux.close	
				
				intTotalFaltas = 0
				sql = "select CF.cod_empresa, CF.ano_letivo, CF.semestre_letivo, C.CodFuncional, C.nome, sum(convert(int,numero_falta)) as falta "
				sql = sql & " 	from dbo.SRH_COLABORADOR_FREQUENCIA CF "
				sql = sql & " 	INNER JOIN SRH_COLABORADOR C ON C.CODIGO = CF.COD_COLABORADOR"
				sql = sql & " 	LEFT JOIN SCA_TURMA T ON T.COD_EMPRESA = CF.COD_EMPRESA AND T.COD_TURMA = CF.COD_TURMA " 
				sql = sql & " 	LEFT JOIN SCA_GRADECURRICULAR G ON G.COD_EMPRESA=T.COD_EMPRESA AND G.COD_GRADECURRICULAR=T.COD_GRADECURRICULAR " 
				sql = sql & " 	LEFT JOIN SCA_PERIODO P ON P.COD_EMPRESA=T.COD_EMPRESA AND P.COD_PERIODO=G.COD_PERIODO " 
				sql = sql & " 	LEFT JOIN SCA_CURSO CU ON CU.COD_EMPRESA=T.COD_EMPRESA AND CU.COD_CURSO=P.COD_CURSO "
				sql = sql & "   WHERE  (C.codLotacao = " & session("CodEmpresa") & " OR C.nome = 'DEFICIT') "
				sql = sql & " 	AND CF.NUMERO_FALTA <> 0 "
				sql = sql & " 	AND CF.COD_COLABORADOR = " & trim(codColaborador)
				sql = sql & "   AND CF.SITUACAO <> 'S' "  'se não estiver abonada
	            sql = sql & "   AND CF.FECHAMENTO = 'S' "  ' se o movimento estiver fechado
 				sql = sql & " and convert(datetime,convert(varchar, CF.DATALANCAMENTO, 103),103) >=  convert(datetime, ' " & strDataI & "',103)"
				sql = sql & " and convert(datetime,convert(varchar, CF.DATALANCAMENTO, 103),103) <=  convert(datetime, ' " & strDataF & "',103)"
				sql = sql & " 	group by CF.cod_empresa, ano_letivo, semestre_letivo, c.nome, C.CodFuncional " 
				sql = sql & " 	order by c.nome "
				rsaux.open sql, cnn
				if not rsaux.eof then
					intTotalFaltas = rsaux("Falta") 
				end if
				rsaux.close	
				 %>
				
					<tr bgcolor="#EAEAEA">
					<td colspan="9" align="right" class="celula"><font color='##0000FF'><div align="right"><strong>Período de&nbsp;<%=strDataI%>&nbsp;à&nbsp;<%=strDataF%>&nbsp; -  Faltas:&nbsp;<%=intTotalFaltas%>&nbsp;- Substitui&ccedil;&otilde;es:&nbsp;<%=intTotalSubstituicoes%>&nbsp; </strong></div><font></td>
        <% end if %>

	     <tr bgcolor="#FFFFFF">
		   <td colspan="9" align="right" class="celula">&nbsp;</td>
         </tr>
		 <tr bgcolor="#EAEAEA">
		   <td colspan="5" align="right" class="celula"><strong>Total Geral Ministrado&nbsp;</strong></td>
		   <td align="right" class="celula"><strong><%=intTotalCHCumpridaGeral%>&nbsp;</strong></td>
		   <td align="right" class="celula"><strong><%=ROUND(intTotalHoraRelogioCumpridaGeral,2)%>&nbsp;</strong></td>
		   <td align="right" class="celula">&nbsp;</td>
		   <td align="right" class="celula"><strong><%=strSalarioBaseMinistradoGeral%>&nbsp;</strong></td>
		</tr>
        <tr bgcolor="#EAEAEA">
            <td colspan="5" align="right" class="celula">&nbsp;<strong>Total&nbsp;Geral Contratado&nbsp; </strong></td>
            <td align="right" class="celula"><strong><%=intCHContratadaGeral%>&nbsp;</strong></td>
            <td align="right" class="celula"><strong><%=Horas_contratadaGeral%></strong>&nbsp;</td>
            <td align="right" class="celula">&nbsp;</td>
            <td align="right" class="celula"><strong><strong><%=strSalarioBaseContratadoGeral%></strong>&nbsp;</strong></td>
        </tr>
        <tr bgcolor="#EAEAEA">
            <td colspan="5" align="right" class="celula"><strong>Saldo Geral&nbsp;</strong></td>
            <td align="right" class="celula"><strong><%=strMostraSaldoGeral%>&nbsp;</strong></td>
            <td align="right" class="celula"><strong><%=strMostraSaldoHoraRelogioGeral%>&nbsp;</strong></td>
            <td align="right" class="celula">&nbsp;</td>
            <td align="right" class="celula"><strong><strong><%=strMostraSaldoSalarioGeral%></strong>&nbsp;</strong></td>
        </tr>
        <%			  
	else
		%>
		<tr>
		  <td colspan="9" class="celula" align="center"><br><br><br><br><font color="#993300"><%=session("strMensagemRelatorioNaoEncontrado")%></font></td>
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
