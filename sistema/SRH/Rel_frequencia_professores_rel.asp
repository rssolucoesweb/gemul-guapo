<%
response.Expires=0
response.Buffer = false
%>
<html>
<head>
<title><%=session("Titulo")%> - Grade Curricular</title>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8">
<link type="text/css" rel="stylesheet" href="../../Estilo/Estilo_Impressao.css">
<script src="../../js/js_funcoes_gerais.js"></script>
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
	strAno	 					= Trim(Request("txtAno"))
	intSemestre 				=  Session("strSemestre")
	intCodModulacaoReferencia	= Trim(Request.Form("cmbModulacaoReferencia"))
	intCodCargoCategoria = Trim(Request.Form("tipoRel"))
	if intCodCargoCategoria = "1" then tipoRel = "PROFESSORES"
	if intCodCargoCategoria = "2" then tipoRel = "ADMINISTRATIVOS"
	if intCodCargoCategoria = "5" then tipoRel = "GESTORES"
	intCodEmpresaGrupo			= Trim(Request.Form("cmbEmpresaGrupo"))
	strFiltroFaltas				= Trim(Request.Form("FiltroFaltas"))
	
	if intCodModulacaoReferencia <> "" then
		
		sql = "SELECT Codigo, AnoReferencia, MesReferencia, SemestreReferencia, Data_Inicial, Data_Final"
		sql = sql & " FROM SRH_MODULACAO_REFERENCIA"
		sql = sql & " where Codigo = " & intCodModulacaoReferencia
		rs.open sql, cnn
		if not rs.eof then 
			strMesReferencia =  ucase(monthname(rs("MesReferencia")))
			strMesRef 		 = rs("MesReferencia")
			strAnoRef 		 = rs("AnoReferencia")
			strDtInicial 	 = formatadataBD(rs("Data_Inicial"))
			strDtFinal 		 = formatadataBD(rs("Data_Final"))
			strDtInicialCon 	 = formatadataAP(rs("Data_Inicial"))
			strDtFinalCon 		 = formatadataAP(rs("Data_Final"))
		end if
		rs.close
	
	end if
	
	strTituloRelatorio  		= "Frequência - Extrato Mensal <br>"&tipoRel&"<br>"
	strTituloRelatorio  		= strTituloRelatorio & strMesReferencia & "/" & strAno
	strTituloRelatorio  		= strTituloRelatorio & "<br><font size='-1'>(" & strDtInicialCon & " a " & strDtFinalCon & ")</font>"
	

	sub mostraCabecalho()
	%>
	<!--#include file="../../includes/inc_cabecalhoRelatorio.asp"-->
	<br>
	<table width="98%" border="0" cellspacing="0" cellpadding="0" class="tabela" align="center">
	  <tr bgcolor="#CCCCCC">
        <td width="5%" height="15" align="center" class="celula"><strong>Matrícula </strong></td>
	    <td width="15%" align="center" class="celula"><strong>Nome</strong></td>
	    <td width="3%" align="center" class="celula"><strong>Modulação</strong></td>
	  	<td width="3%" align="center" class="celula"><strong>Turno</strong></td>
		<td width="17%" align="center" class="celula"><strong>Nível</strong></td>
		
		<td width="10%" align="center" class="celula"><strong>Fun&ccedil;&atilde;o</strong></td>
		<td width="16%" align="center" class="celula"><strong>Falta(tipo)</strong></td>
		<td width="4%" align="center" class="celula"><strong>Movimentação</strong></td>
		<td width="3%" align="center" class="celula"><strong>Faltas</strong></td>
		<td width="5%" align="center" class="celula"><strong>Abonadas</strong></td>
		<td width="5%" align="center" class="celula"><strong>Não Abonadas</strong></td>
		<td width="27%" align="center" class="celula"><strong>Observação</strong></td>
	  </tr>
	<%
	end Sub
	
	sub fimTabela()
		response.Write("</table>")
	end Sub
	ordem = request.form("ordem")
	intPagina = 1
	mostraCabecalho
	cont = 0
	contColaboradorEmpresa = 0
	intQtdeRegistroPorPagina = 0
	
	SQL = "set nocount on "
	SQL = SQL & " create table #temp (codigo int, codLotacao int, codLotacaoAnt int, atual varchar(200), anterior varchar(200),codFuncional int, colaborador varchar(100), total_aulas int, carga_horario_contratada int, turno varchar(100), funcao varchar(100), movimentacao date, periodo varchar(100), cod_curso int, curso varchar(100), nivel varchar(100)) "

	SQL = SQL & " insert #temp "

	SQL = SQL & " SELECT C.Codigo, C.codLotacao, null, emp.RAZAOSOCIAL, null, C.codFuncional, C.Nome, C.total_aulas,C.carga_horario_contratada, T.Desc_Turno, F.Desc_Funcao, null as movimentacao, "
	SQL = SQL & " f.periodo, pe.Cod_Curso, isnull(cur.descricao,'ENSINO FUNDAMENTAL 2ª FASE') as curso, n.descricao as nivel	"
	SQL = SQL & " FROM SRH_COLABORADOR C "
	SQL = SQL & " left join SRH_CARGOCOLABORADOR CC on CC.Cod_Cargo = c.CodCargo "
	SQL = SQL & " left Join SRH_TURNO T on T.Cod_Turno = C.CodTurno "
	SQL = SQL & " left join srh_nivel n on n.Codigo = c.Cod_nivel	"
	SQL = SQL & " left Join SRH_REGENCIACOLABORADOR R on R.Codigo = C.Cod_Regencia "
	SQL = SQL & " left Join SRH_FUNCAOCOLABORADOR F on F.Cod_funcao = C.Codfuncao "
	SQL = SQL & " left join sca_periodo pe on replace(pe.Descricao,' ','_') = f.periodo and pe.cod_empresa = " & intCodEmpresaGrupo 
	SQL = SQL & " left join sca_curso cur on cur.cod_curso = pe.cod_curso and cur.cod_empresa = " & intCodEmpresaGrupo 
	SQL = SQL & " left join seg_empresa emp on emp.codigo = c.codLotacao "
	SQL = SQL & " Where C.codLotacao = " & intCodEmpresaGrupo 
	SQL = SQL & " AND C.Situacao = 'A' "
	SQL = SQL & " AND CC.CodCargoCategoria = " & intCodCargoCategoria

	SQL = SQL & " union	"

	SQL = SQL & " SELECT C.Codigo, C.codLotacao, null, emp.RAZAOSOCIAL, null, C.codFuncional, C.Nome, C.total_aulas,C.carga_horario_contratada, T.Desc_Turno, F.Desc_Funcao,	"
	SQL = SQL & " C.DataLotacao as movimentacao, f.periodo, pe.Cod_Curso, isnull(cur.descricao,'ENSINO FUNDAMENTAL 2ª FASE') as curso, n.descricao as nivel"
	SQL = SQL & " FROM SRH_COLABORADOR C "
	SQL = SQL & " left join SRH_CARGOCOLABORADOR CC on CC.Cod_Cargo = c.CodCargo "
	SQL = SQL & " left join srh_nivel n on n.Codigo = c.Cod_nivel	"
	SQL = SQL & " left Join SRH_TURNO T on T.Cod_Turno = C.CodTurno "
	SQL = SQL & " left Join SRH_REGENCIACOLABORADOR R on R.Codigo = C.Cod_Regencia "
	SQL = SQL & " left Join SRH_FUNCAOCOLABORADOR F on F.Cod_funcao = C.Codfuncao "
	SQL = SQL & " left join sca_periodo pe on replace(pe.Descricao,' ','_') = f.periodo and pe.cod_empresa = " & intCodEmpresaGrupo 
	SQL = SQL & " left join sca_curso cur on cur.cod_curso = pe.cod_curso and cur.cod_empresa = " & intCodEmpresaGrupo 
	SQL = SQL & " left join seg_empresa emp on emp.codigo = C.codLotacao "
	SQL = SQL & " Where C.Situacao = 'A' "
	SQL = SQL & " AND CC.CodCargoCategoria = " & intCodCargoCategoria
	SQL = SQL & " AND C.dataLotacao >= '"&strDtInicial&"'"
	SQL = SQL & " AND C.DataLotacao <= '"&strDtFinal&"'" 
	SQL = SQL & " AND C.codLotacao = " & intCodEmpresaGrupo 

	SQL = SQL & " union	"

	SQL = SQL & " SELECT C.Codigo, C.codLotacao, L.cod_Lotacao, emp_atual.RAZAOSOCIAL, emp_ant.RAZAOSOCIAL, C.codFuncional, C.Nome, C.total_aulas,C.carga_horario_contratada, T.Desc_Turno, F.Desc_Funcao,	"
	SQL = SQL & " L.DataLotacao as movimentacao, f.periodo, pe.Cod_Curso, isnull(cur.descricao,'ENSINO FUNDAMENTAL 2ª FASE') as curso, n.descricao as nivel	"
	SQL = SQL & " FROM SRH_COLABORADOR C "
	SQL = SQL & " inner Join SRH_LOTACAOHISTORICO L on L.cod_Colaborador = c.codigo	"
	SQL = SQL & " left join SRH_CARGOCOLABORADOR CC on CC.Cod_Cargo = c.CodCargo "
	SQL = SQL & " left join srh_nivel n on n.Codigo = c.Cod_nivel	"
	SQL = SQL & " left Join SRH_TURNO T on T.Cod_Turno = C.CodTurno "
	SQL = SQL & " left Join SRH_REGENCIACOLABORADOR R on R.Codigo = C.Cod_Regencia "
	SQL = SQL & " left Join SRH_FUNCAOCOLABORADOR F on F.Cod_funcao = C.Codfuncao "
	SQL = SQL & " left join sca_periodo pe on replace(pe.Descricao,' ','_') = f.periodo and pe.cod_empresa = " & intCodEmpresaGrupo 
	SQL = SQL & " left join sca_curso cur on cur.cod_curso = pe.cod_curso and cur.cod_empresa = " & intCodEmpresaGrupo 
	SQL = SQL & " left join seg_empresa emp_atual on emp_atual.codigo = C.codLotacao "
	SQL = SQL & " left join seg_empresa emp_ant on emp_ant.codigo = L.cod_Lotacao "
	SQL = SQL & " Where C.Situacao = 'A' "
	SQL = SQL & " AND CC.CodCargoCategoria = " & intCodCargoCategoria
	SQL = SQL & " AND L.dataLotacao >= '"&strDtInicial&"'" 
	SQL = SQL & " AND L.DataLotacao <= '"&strDtFinal&"'" 
	SQL = SQL & " AND L.cod_lotacao = " & intCodEmpresaGrupo 

	SQL = SQL & " delete #temp "
	SQL = SQL & " where codigo in (	select codigo	from #temp	group by codigo	having count(*)>1	) "
	SQL = SQL & " and movimentacao is null	"

	SQL = SQL & " delete #temp "
	SQL = SQL & " where codigo in (	select codigo	from #temp	group by codigo	having count(*)>1	) "
	SQL = SQL & " and codLotacaoAnt is null	"

	SQL = SQL & " create table #tempHist (cod_LotacaoHistorico int, cod_Colaborador int)"
	SQL = SQL & " insert #tempHist"
	SQL = SQL & " select max(cod_LotacaoHistorico) as cod_LotacaoHistorico, cod_Colaborador"
	SQL = SQL & " from SRH_LOTACAOHISTORICO"
	SQL = SQL & " where dataLotacao >= '"&strDtInicial&"'"
	SQL = SQL & " AND DataLotacao <= '"&strDtFinal&"'"
	SQL = SQL & " group by  cod_Colaborador"

	SQL = SQL & " update t set t.movimentacao = hh.DataLotacao, t.codLotacaoAnt = hh.cod_Lotacao, t.anterior = e.RAZAOSOCIAL"
	SQL = SQL & " from #temp t "
	SQL = SQL & " inner join #tempHist h on t.codigo = h.cod_Colaborador"
	SQL = SQL & " inner join SRH_LOTACAOHISTORICO hh on hh.cod_LotacaoHistorico = h.cod_LotacaoHistorico"
	SQL = SQL & " inner join seg_empresa e on e.codigo = hh.cod_Lotacao"

	SQL = SQL & " create table #tempMod (total int, Cod_Colaborador int, situacao_disciplinar varchar(1))	"

	SQL = SQL & " insert #tempMod "
	SQL = SQL & " select sum(dd.Total_Aulas) as total, dd.Cod_Colaborador, dd.situacao_disciplinar	"
	SQL = SQL & " from SRH_MODULACAO_DISCIPLINAR_DOCENTE dd inner join SEG_EMPRESA e on e.CODIGO = dd.Cod_empresa "
	SQL = SQL & " left join SRH_FUNCAOCOLABORADOR f on f.cod_funcao = dd.cod_funcao	"
	SQL = SQL & " left join SCA_disciplina d on d.cod_disciplina = dd.cod_disciplina"	
	SQL = SQL & " left join SRH_TURNO t on t.cod_turno = dd.cod_turno	"
	SQL = SQL & " left join SRH_TURNO tur on tur.cod_turno = dd.cod_turno_opcional "
	SQL = SQL & " left join SCA_periodo p on p.cod_periodo = dd.cod_periodo	"
	SQL = SQL & " where dd.status = 'A'	"
	SQL = SQL & " and dd.Cod_Colaborador in (select codigo from #temp)	"
	SQL = SQL & " group by dd.Cod_Colaborador, dd.situacao_disciplinar	"

	SQL = SQL & " update #tempMod set total = total * 21 "
	SQL = SQL & " where situacao_disciplinar='I' "

	SQL = SQL & " select t.*, m.total as total_modulado	"
	SQL = SQL & " from #temp t	"
	SQL = SQL & " left join #tempMod m on m.Cod_Colaborador = t.codigo	"

	if ordem = "1" then																						 
		SQL = SQL & " Order By colaborador, funcao, nivel	"
	end if
	if ordem = "2" then																						 
		SQL = SQL & " Order By funcao, colaborador, nivel"
	end if
	if ordem = "3" then																						 
		SQL = SQL & " Order By nivel, colaborador, funcao	"
	end if
'response.write sql
	rs.open sql, cnn
	if not rs.eof then 
		curso = ""
	
			%>
			<tr>
				<td align="center" class="celula" colspan="12" bgcolor="#F0F0F0"><strong><font size="+1"> <%=ucase(rs("atual"))%></font></strong></td>
			</tr> 
			<%
			
	   While not rs.eof 
	   		
			
			'strJustificativas = ""
			'sql = " Select justificativa, justificativa_abono, situacao "
			'sql = sql & " FROM SRH_COLABORADOR_FREQUENCIA  "
			'sql = sql & " Where Cod_empresa = " & intCodEmpresaGrupo 
			'sql = sql & " and convert(datetime,convert(varchar, DATALANCAMENTO , 103),103) >= convert(datetime, ' " & strDtInicial & " ',103)"
			'sql = sql & " and convert(datetime,convert(varchar, DATALANCAMENTO, 103),103) <= convert(datetime, ' " & strDtFinal & " ',103)"
			'sql = sql & " And cod_colaborador  = " & rs("Codigo")
			'sql = sql & " And (justificativa is not null or justificativa_abono is not null)"
			'rsAux.open sql, cnn
			'IF rsAux.EOF = false THEN
		'		While not rsAux.eof 
		'			if not isnull(rsAux("justificativa")) then strJustificativas = strJustificativas & rsAux("justificativa") & "<br>"
		'			if not isnull(rsAux("justificativa_abono")) then strJustificativas = strJustificativas & rsAux("justificativa_abono") & "<br>"
		'			rsAux.movenext
		'		Wend
		'	end if
		'	rsAux.close
			strLicenca = "---"
			faltas = 0
			justificativa_abono = ""
			abonadas = 0
			sql = " SELECT  SUM(CONVERT(INT, CF.NUMERO_FALTA)) AS NUMERO_FALTA, cf.DataLancamento, cf.DataLancamentoFinal, t.Descricao as licenca, justificativa_abono, situacao "
			sql = sql & " from SRH_COLABORADOR_FREQUENCIA CF " 
			sql = sql & " inner join SRH_JUSTIFICATIVAFALTAS t on t.Codigo = cf.Cod_JustificativaFaltas"
			sql = sql & " WHERE CF.TIPO_COLABORADOR <> 'F' and CF.COD_EMPRESA = " & intCodEmpresaGrupo
			sql = sql & " And CF.cod_colaborador  = " & rs("Codigo")
			sql = sql & " And CF.fechamento  = 'S'"
			sql = sql & " and convert(datetime,convert(varchar, cf.DataFalta , 103),103) >= convert(datetime, ' " & strDtInicialCon & " ',103)"
			sql = sql & " and convert(datetime,convert(varchar, cf.DataFalta, 103),103) <= convert(datetime, ' " & strDtFinalCon & " ',103)"
			sql = sql & " group by cf.DataLancamento, cf.DataLancamentoFinal, t.Descricao, justificativa_abono, situacao "
			rsAux.open sql, cnn
			IF rsAux.EOF = false THEN
				strLicenca = ""
				controleJust = 0
				While not rsAux.eof
					controleJust = controleJust + 1
					if not isnull(rsAux("licenca")) then strLicenca = strLicenca & rsAux("licenca") & "<br>" & formatadataAP(rsAux("DataLancamento")) & " a " & formatadataAP(rsAux("DataLancamentoFinal")) & "<br>"
					if rsAux("situacao") = "S" then 
						abonadas = abonadas + rsAux("NUMERO_FALTA")
					end if
					if not isnull(rsAux("justificativa_abono")) then
						if controleJust = 1 then
							justificativa_abono = rsAux("justificativa_abono")
						else
							justificativa_abono = justificativa_abono & "<br>" & rsAux("justificativa_abono")
						end if
						
					end if
					faltas = faltas + rsAux("NUMERO_FALTA")
					rsAux.movenext
				Wend
			end if
			rsAux.close
			
			remocao = formatadataAP(rs("movimentacao"))
			if rs("movimentacao") = "1/1/1900" then remocao = ""
			if rs("movimentacao") = "01/01/1900" then remocao = ""

			strObsAdicionalMov = ""
			strObsAdicional = ""
			
			codLotacaoAtual = rs("codLotacao")
			codLotacaoAnterior = rs("codLotacaoAnt")
			if isnull(codLotacaoAtual) then codLotacaoAtual = "0"
			if isnull(codLotacaoAnterior) then codLotacaoAnterior = "0"
			
			
			if cint(codLotacaoAtual)=cint(intCodEmpresaGrupo) and cint(codLotacaoAnterior)<>cint(intCodEmpresaGrupo) then
				strObsAdicionalMov = "<br>Incluído"
				strObsAdicional = rs("anterior")
			end if
			if cint(codLotacaoAtual)<>cint(intCodEmpresaGrupo) and cint(codLotacaoAnterior)=cint(intCodEmpresaGrupo) then
				strObsAdicionalMov = "<br>Removido"
				strObsAdicional = rs("atual")
			end if
			if isnull(strObsAdicional) or strObsAdicional="" then strObsAdicionalMov=""
			ListaLinha = "S" 
			if strFiltroFaltas = "S" then
				if faltas-abonadas <=0 then ListaLinha = "N"
			end if
			if ListaLinha = "S" then
				%> 
				<tr>
				<td class="celula">&nbsp;<%=rs("codFuncional")%></td>
				<td class="celula">&nbsp;<%=rs("colaborador")%></td>
				<td align="center" class="celula"><%=rs("total_modulado")%></td>
				<td align="center" class="celula">&nbsp;<%=left(rs("Turno"),1)%></td>
				<td class="celula">&nbsp; <%=rs("nivel")%>&nbsp;</td>
				<td class="celula">&nbsp; <%=rs("Funcao")%>&nbsp;</td>	
				<td class="celula" align="center"><%=strLicenca%></td>
				<td align="center"  class="celula"><%=remocao%><%=strObsAdicionalMov%>&nbsp;</td>
				<td align="center"  class="celula"><%=faltas%>&nbsp;</td>
				<td align="center"  class="celula"><%=abonadas%>&nbsp;</td>
				<td align="center"  class="celula"><%=faltas-abonadas%>&nbsp;</td>
				<td align="center"  class="celula"><%=justificativa_abono%>&nbsp;<%=strObsAdicional%></td>
				</tr> 
		    	<%
			end if	
			'quantidade de registros da pÃ¡gina
			if intQtdeRegistroPorPagina = 50 then
				 intPagina = intPagina + 1
				 intQtdeRegistroPorPagina = 1
				 fimTabela
				%>
				<pre></pre>				
				<%			
				mostraCabecalho
			end if
			if ListaLinha = "S" then
				cont = cont + 1
				contColaboradorEmpresa = contColaboradorEmpresa + 1
				intQtdeRegistroPorPagina = intQtdeRegistroPorPagina + 1
			end if
			curso = rs("curso")
			rs.movenext
		wend
		contPeriodo = contPeriodo + 1
	else
		%>
		  <tr>
			<td colspan="11" class="celula" align="center">&nbsp;</td>
	  </tr>
		<%
	end if
	rs.close
%>
<tr>
  <td colspan="12" class="celula"><strong>Quantidade:&nbsp;</strong><%=contColaboradorEmpresa%></td>
</tr>
</table>
<br>
<br>

<p align="center">____________________________________________<br>ASSINATURA DO RESPONSÁVEL PELA FOLHA</p>

<br>
<script>
	aguarde.style.display="none";
</script>
</body>
</html>
