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
	intCodDisciplina	= Trim(Request.Form("cmbDisciplina"))
	intCodDiaSemana			= Trim(Request.Form("cmbDiaSemana"))
	
	intAnoLetivo 			= Trim(Request.Form("txtAnoLetivo"))
	if intAnoLetivo = "" then 	intAnoLetivo 			= session("strAnoLetivo")
	intSemestre 			= Trim(Request.Form("cmbSemestre"))
	if intSemestre = "" then 	intSemestre 			= session("strSemestre")



	if strAnoLetivo = "" then strAnoLetivo = session("strAnoLetivo")
	if strSemestre = "" then strSemestre = "0"

	strFiltroSerie = "0"
	strFiltroTurno = "0"


	strTituloRelatorio  	= "MODULAÇÃO SINTÉTICA DOCENTES"

	sub mostraCabecalho()
	%>
	<!--#include file="../../includes/inc_cabecalhoRelatorio.asp"-->
	<br>
	<table width="98%" border="0" cellspacing="0" cellpadding="0" class="tabela" align="center">
	  <tr bgcolor="#CCCCCC">
	    <td width="9%" rowspan="2" align="center" class="celula"><strong>Cod. Colaborador</strong></td>
	    <td width="37%" rowspan="2" align="center" class="celula"><strong>Colaborador</strong></td>
	    <td width="15%" rowspan="2" align="center" class="celula"><strong>N&iacute;vel</strong></td>
	    <td align="center" class="celula"><strong>Carga Hor&aacute;ria </strong></td>
	    <td width="12%" rowspan="2" align="center" class="celula"><strong>Valor Hora Aula</strong></td>
	    <td width="13%" rowspan="2" align="center" class="celula"><strong>Valor Total</strong></td>
      </tr>
	  <tr bgcolor="#CCCCCC">
	    <td width="14%" align="center" class="celula"><strong>Cumprida</strong></td>
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
	
	sql = "SET NOCOUNT ON  select "
	sql = sql & " 	HA.Cod_Colaborador, "
	sql = sql & " 	C.nome AS COLABORADOR, "
	sql = sql & " 	count(*) as CH_cumprida"
	sql = sql & " 	into #temp"
	sql = sql & " 	from SRH_COLABORADOR C "
	sql = sql & " 	inner join SCA_HORARIO_AULA HA on HA.Cod_Colaborador = C.codigo " 
	sql = sql & " 	inner join SCA_HORARIO H on H.codigo = HA.Cod_Horario and H.cod_empresa = HA.Cod_Empresa "
	sql = sql & " 	inner join SCA_DISCIPLINA D on D.Cod_Disciplina = HA.Cod_Disciplina and D.cod_empresa = HA.Cod_Empresa "
	sql = sql & " 	inner join SCA_TURMA T on T.Cod_Turma = HA.Cod_turma and T.AnoLetivo = H.anoLetivo and T.Cod_Semestre = HA.Semestre and T.Cod_Empresa = HA.Cod_Empresa "
	sql = sql & " 	inner join SCA_GRADECURRICULAR G on G.Cod_GradeCurricular = T.Cod_GradeCurricular and D.cod_empresa = HA.Cod_Empresa "
	sql = sql & " 	inner join SCA_GRADECURRICULARDISCIPLINA GD on GD.Cod_GradeCurricular = G.Cod_GradeCurricular and GD.Cod_Disciplina = D.Cod_Disciplina" 
	sql = sql & " WHERE  (C.codLotacao = " & session("CodEmpresa") & " OR C.nome = 'DEFICIT') "
	sql = sql & " and T.COD_EMPRESA = " & session("CodEmpresa")
	
	sql = sql & " and H.anoLetivo =  " & strAnoLetivo 
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

	sql = sql & " 	group by"
	sql = sql & " 	HA.Cod_Colaborador, "
	sql = sql & " 	C.nome, "
	sql = sql & " 	T.NomeTurma, "
	sql = sql & " 	HA.DiaSemana, "
	sql = sql & " 	HA.Sequencia, "
	sql = sql & " 	HA.Tempo, "
	sql = sql & " 	H.horario, "
	sql = sql & " 	d.Desc_Disciplina, "
	sql = sql & " 	GD.Ch_Semanal"
	sql = sql & " select "
	sql = sql & " Cod_Colaborador, "
	sql = sql & " COLABORADOR, "
	sql = sql & " isnull(sum(ch_cumprida),'0') as CH_cumprida"
	sql = sql & " from #temp"
	sql = sql & " group by "
	sql = sql & " Cod_Colaborador, "
	sql = sql & " COLABORADOR"
	sql = sql & " order by COLABORADOR"
	intTotalCHCumprida = 0
	intTotalCHContratada = 0
	intTotalHoraAula = 0
	intSalarioBaseTotal = 0
	intValorTotal = 0
	rs.open sql, cnn
	if not rs.eof then 
		codColaborador = ""
		controle = 0
		intTotalCHCumprida = 0
	  	intSaldo = 0
	  	intTotalHoraAula = 0
		CH_cumprida = 1
		intCHContratadaGeral = 0
		While not rs.eof 
		
			valor_hora_aula = 0
			CH_contratada = 0
			salario_base = 0
			nivel = ""
	
			sql = "select "
			sql = sql & " 	isnull(CF.carga_horario_contratada,'0') as CH_contratada,"
			sql = sql & " 	isnull(CF.salario_base,'0') as salario_base,"
			sql = sql & " 	N.descricao as nivel,"
			sql = sql & " 	isnull(N.valor_hora,'0') as valor_hora_aula "
			sql = sql & " from SRH_COLABORADOR C"
			sql = sql & " inner join SRH_COLABORADOR_FOLHA CF on CF.cod_colaborador = C.codigo and CF.cod_empresa = C.Cod_Empresa"
			sql = sql & " left join SRH_NIVEL N on N.codigo = CF.cod_nivel"
			sql = sql & " WHERE	C.COD_EMPRESA in (17," & session("CodEmpresa") & ")" 'locação o defict - 17 default
			sql = sql & " and C.codigo =  " & rs("cod_colaborador") 
			sql = sql & " and N.tipo_vinculo = 'D'"
			rsaux.open sql, cnn
			if not rsaux.eof then
				valor_hora_aula = rsaux("valor_hora_aula") 
				CH_contratada = rsaux("CH_contratada") 
				salario_base = rsaux("salario_base") 
				nivel = rsaux("nivel") 
			end if
			rsaux.close			
		
			controle = 1
			intTotalCHCumprida = intTotalCHCumprida + rs("CH_cumprida")
			intTotalCHContratada = intTotalCHContratada + CH_contratada
			intTotalHoraAula = intTotalHoraAula + valor_hora_aula
			intSalarioBaseTotal = intSalarioBaseTotal + salario_base
			intValorTotal = intValorTotal + (valor_hora_aula*rs("CH_cumprida"))
			%>
			  <tr>
			    <td align="left" class="celula">&nbsp;<strong><font size="2"><%=rs("cod_colaborador")%></font></strong></td>
			    <td align="left" class="celula">&nbsp;<strong><font size="2"><%=rs("colaborador")%></font></strong></td>
			    <td align="left" class="celula">&nbsp;<strong><font size="2"><%=nivel%></font></strong></td>
			    <td align="right" class="celula"><%=rs("CH_cumprida")%>&nbsp;</td>
			    <td align="right" class="celula"><%=FormatNumber(valor_hora_aula,2)%>&nbsp;</td>
			    <td align="right" class="celula"><%=FormatNumber(valor_hora_aula*rs("CH_cumprida"),2)%></td>
		      </tr>
			<%
			
			intTotalHoraAula = intTotalHoraAula + valor_hora_aula
			intTotalCHCumprida = intTotalCHCumprida + CH_cumprida
			
			intTotalHoraAulaGeral = intTotalHoraAulaGeral + valor_hora_aula
			intTotalCHCumpridaGeral = intTotalCHCumpridaGeral + CH_cumprida
			
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
			
			intSaldo = cInt(intTotalCHContratada) - cInt(intTotalCHCumprida)
			intSalarioBaseSaldo = cCur(intSalarioBaseTotal) - cCur(intTotalHoraAula)
			
			strMostraSaldo = intSaldo
			if cInt(intSaldo) < 0 then
				strMostraSaldo = "<font color='#FF0000'>" & intSaldo & "</font>"
			elseif cInt(intSaldo) > 0 then
				strMostraSaldo = "<font color='#FF0000'>" & intSaldo & "</font>"					
			end if
			strMostraSaldoSalario = intSalarioBaseSaldo
			if cInt(intSalarioBaseSaldo) < 0 then
				strMostraSaldoSalario = "<font color='#FF0000'>" & formatNumber(intSalarioBaseSaldo,2) & "</font>"
			elseif cInt(intSalarioBaseSaldo) > 0 then
				strMostraSaldoSalario = "<font color='#FF0000'>" & formatNumber(intSalarioBaseSaldo,2) & "</font>"					
			end if
			%>
			 <tr bgcolor="#EAEAEA">
			   <td colspan="3" align="right" class="celula"><strong>Total Ministrada&nbsp;</strong></td>
			   <td align="right" class="celula"><strong><%=intTotalCHCumprida%>&nbsp;</strong></td>
			   <td align="right" class="celula"><strong>---&nbsp;</strong></td>
			   <td align="right" class="celula"><strong><%=FormatNumber(intValorTotal,2)%></strong>&nbsp;</td>
		      </tr>
             <tr bgcolor="#EAEAEA">
                <td colspan="3" align="right" class="celula">&nbsp;<strong>Total&nbsp;Contratada&nbsp; </strong></td>
                <td align="right" class="celula"><strong><%=intTotalCHContratada%>&nbsp;</strong></td>
                <td align="right" class="celula"><strong>&nbsp;</strong></td>
                <td align="right" class="celula">&nbsp;</td>
      </tr>
             <tr bgcolor="#EAEAEA">
               <td colspan="3" align="right" class="celula"><strong>Saldo&nbsp;</strong></td>
               <td align="right" class="celula"><strong><%=strMostraSaldo%>&nbsp;</strong></td>
               <td align="right" class="celula"><strong>&nbsp;</strong></td>
               <td align="right" class="celula">&nbsp;</td>
      </tr>
              
              <%			  
	else
		%>
		  <tr>
			<td colspan="6" class="celula" align="center"><br><br><br><br><font color="#993300"><%=session("strMensagemRelatorioNaoEncontrado")%></font></td>
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
