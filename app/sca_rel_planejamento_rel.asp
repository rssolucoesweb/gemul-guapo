<%
response.Expires=0
'Não armazena a página em buffer antes de mostra-la na tela'
response.Buffer = false
SESSION.Timeout = 1200
Server.ScriptTimeout = 1200
%>
<html>
<head>
<title>GEMUL - Planejamento</title>
<meta http-equiv="content-type" content="text/html; charset=UTF-8">
<link type="text/css" rel="stylesheet" href="css_rel/Estilo_Impressao.css">
<script src="js/js_funcoes_gerais.js"></script>
<script src="js_app/js_barra_movel.js"></script>
<style type="text/css">

	.font14 {
		font-size: 14px;
	}

	@media print {

		@page {
			size: A4 landscape;
			margin: 8mm;
		}

		.noPrint {
			display: none !important;
		}

		body {
			margin: 0;
			padding: 0;
			width: 100%;
		}

		table.tabela {
			width: 100% !important;
			table-layout: fixed;

			/*
			 * Importante:
			 * não utilizar collapse na impressão.
			 */
			border-collapse: separate !important;
			border-spacing: 0 !important;

			border-top: 1pt solid #000 !important;
			border-left: 1pt solid #000 !important;
		}

		table.tabela > tbody > tr > td,
		table.tabela > tr > td {
			white-space: normal !important;
			word-wrap: break-word;
			overflow-wrap: break-word;
			vertical-align: top;

			font-size: 8px;
			padding: 2px;

			/*
			 * Cada célula desenha sua borda direita
			 * e inferior.
			 */
			border-top: 0 !important;
			border-left: 0 !important;
			border-right: 1pt solid #000 !important;
			border-bottom: 1pt solid #000 !important;
		}

	}

</style>
</head>
<body>
<!--#include file="includes/inc_verificaSessionApp.asp"-->
<!--#include file="includes/inc_cnn.asp"-->
<!--#include file="includes/inc_formatadata.asp"-->
<!--#include file="includes/inc_Botoes_relatorio.asp"-->
<!--#include file="includes/inc_aguarde.asp"-->
<%
	dim intPagina
	strAssinatura				= trim(request("cmbAssinatura")) 		
	intCodColaborador		= Trim(Request("cmbProfessor"))
	if intCodColaborador = "" then intCodColaborador = "0"
    intCodTurma             = Trim(Request("cmbTurmaProfessor"))
	intCodTurnoTela             = Trim(Request("cmbTurnoDoProfessor"))
	if intCodTurnoTela = "" then intCodTurnoTela = "0"
    intCodDisciplina        = Trim(Request("cmbDisciplinaDoProfessor"))
	if intCodDisciplina = "" then intCodDisciplina = "0"
	strAnoLetivo		 	= Trim(Request.Form("txtAnoLetivo"))
	dataInicio				= trim(request("txtDataInicial")) 		
	dataFim				    = trim(request("txtDataFinal")) 	
	


	'sql="select Cod_Turno from SCA_TURMA where Cod_Turma =" & intCodTurma
	sql="select Cod_Turno, desc_turno "
	sql=sql & " from SRH_TURNO "
	sql=sql & " where Cod_Turno =" & intCodTurnoTela
	rs.open sql, cnn
	if rs.eof = false then
		intCodTurnoTela = rs("Cod_Turno")
		strTurno = rs("desc_turno")
	end if
	rs.close

	if intCodDisciplina <> "0" then
		sql="select desc_disciplina from sca_disciplina"
		sql=sql & " where cod_disciplina =" & intCodDisciplina
		rs.open sql, cnn
		if rs.eof = false then
			strDisciplina = rs("desc_disciplina")
		end if
		rs.close	
	else
		strDisciplina = "Todos"
	end if
	
	strTurma="Todas"
	sql="select tu.NomeTurma, tu.TurmaAluno, pe.Descricao as periodo, cu.Descricao as curso, t.Desc_Turno as turno "
	sql=sql & " from sca_turma tu"
	sql=sql & " inner join SCA_PERIODO pe on pe.Cod_Periodo = tu.Cod_periodo"
	sql=sql & " inner join SCA_curso cu on cu.Cod_curso=pe.Cod_Curso"
	sql=sql & " inner join SCA_turno t on t.Cod_Turno = tu.Cod_Turno"
	sql=sql & " where tu.Cod_Turma=" & intCodTurma
	rs.open sql, cnn
	if rs.eof = false then
		strCurso = rs("curso")
		strPeriodo = rs("periodo")
		strTurma = rs("NomeTurma") & " " & rs("TurmaAluno") & " (" & rs("turno") & ")"
	end if
	rs.close
	
	if dataInicio = "" then
		strTituloRelatorio  	= "Planejamento do(a) Professor(a)<br>"
	else
		strTituloRelatorio  	= "Planejamento do(a) Professor(a)<br>" & formatadataAP(dataInicio) & " a " & formatadataAP(dataFim)
	end if
	
	if intCodColaborador<>"0" then
		sql="select nome "
		sql=sql & " from srh_colaborador"
		sql=sql & " where codigo=" & intCodColaborador
		rs.open sql, cnn
		if rs.eof = false then
			strTituloRelatorio = strTituloRelatorio & "<br><strong>" & rs("nome") & "</strong>"
		end if
		rs.close
	end if
	
	sub mostraCabecalho()
	%>
	<!--#include file="includes/inc_cabecalhoRelatorio.asp"-->
	<br>
    <table width="100%" cellspacing="0" cellpadding="0" class="tabela">
	  <tr>
		<td width="100px" align="left" class="celula"><strong>Curso:</strong> <%=strCurso%></td>
		<td width="100px" align="left" class="celula"><strong>Período:</strong> <%=strPeriodo%></td>
		<%if strTurno<>"" then%>
		<td width="100px" align="left" class="celula"><strong>Turno:</strong> <%=strTurno%></td>
		<%end if%>
		<td width="100px" align="left" class="celula"><strong>Componente curricular:</strong> <%=strDisciplina%></td>
		<td width="100px" align="left" class="celula"><strong>Turma:</strong> <%=strTurma%></td>
	  </tr>
	</table>
	<br>
	<table width="100%" cellspacing="0" cellpadding="0" class="tabela">
	  
	<%
	end Sub
	
	sub linha_cab()
	%>
	
	
	
	  <tr bgcolor="#CCCCCC">
		<td width="4%" align="center" class="celula">
			<strong>Aula</strong>
		</td>

		<td width="6%" align="center" class="celula">
			<strong>Data</strong>
		</td>

		<td width="10%" align="center" class="celula">
			<strong>Professor(a)</strong>
		</td>

		<td width="9%" class="celula">
			<strong>Unidade Temática</strong>
		</td>

		<td width="9%" class="celula">
			<strong>Linguagem<br>Práticas de Linguagens</strong>
		</td>

		<td width="15%" class="celula">
			<strong>Conteúdo</strong>
		</td>

		<td width="10%" class="celula">
			<strong>Conteúdo Complementar</strong>
		</td>

		<td width="17%" class="celula">
			<strong>Metodologia</strong>
		</td>

		<td width="13%" class="celula">
			<strong>Avaliação</strong>
		</td>

		<td width="7%" class="celula">
			<strong>Complemento</strong>
		</td>
	  </tr>
	<%
	end Sub
	
	sub fimTabela()
		response.Write("</table>")
	end Sub
	intQtdeRegistroPorPagina = 0
	intPagina = 1
	mostraCabecalho
	contExtra = 0
	contAula = 0
	contGeral = 0
	disciplina = ""
	
	'sql = "select di.desc_disciplina as disciplina, ig.cod_bimestre, b.Descricao as bimestre, t.cod_turma, t.NomeTurma, t.TurmaAluno, "
	'sql = sql & " c.Descricao as curso, p.Descricao as periodo, tu.Desc_Turno as turno, tp.descricao as unidade_tematica, pp.numero_aula, pp.data_aula_extra, "
	'sql = sql & " ip.descricao as conteudo, ip.complemento, pp.desc_metodologia, pp.desc_avaliacao, pp.desc_conteudo_complementar,"
	'sql = sql & " co.nome as colaborador, coi.nome as colaborador_interacao"
	'sql = sql & " from SCA_PLANEJAMENTO_GERAL pgi"
	'sql = sql & " inner join SCA_PLANEJAMENTO_GERAL pg on pg.cod_planejamento_geral = pgi.cod_planejamento_geral_pai"
	'sql = sql & " inner join SCA_PLANEJAMENTO_PROFESSOR pp on pp.cod_planejamento_geral = pgi.cod_planejamento_geral"
	'sql = sql & " inner join SCA_ITEM_PLANEJAMENTO_PROFESSOR ip on ip.cod_planejamento_professor = pp.cod_planejamento_professor"
	'sql = sql & " inner join SCA_ITEM_PLANEJAMENTO_GERAL ig on ig.cod_item_planejamento_geral = ip.cod_item_planejamento_geral"
	'sql = sql & " inner join SCA_TIPO_PLANEJAMENTO tp on tp.cod_tipo_planejamento_anual = ip.cod_tipo_planejamento"
	'sql = sql & " inner join SCA_PERIODO p on p.Cod_Periodo = pp.cod_periodo"
	'sql = sql & " inner join SCA_CURSO c on c.Cod_curso = p.Cod_Curso"
	'sql = sql & " inner join sca_turma t on t.Cod_Turma = pp.cod_turma"
	'sql = sql & " inner join sca_turno tu on tu.Cod_Turno = pp.cod_turno"
	'sql = sql & " inner join sca_disciplina di on di.cod_disciplina = pp.cod_disciplina"
	'sql = sql & " inner join SCA_BIMESTRE b on b.Codigo = ig.cod_bimestre"
	'sql = sql & " left join SRH_COLABORADOR co on co.codigo = pp.cod_colaborador"
	'sql = sql & " left join SRH_COLABORADOR coi on coi.codigo = pp.cod_colaborador_ultima_interacao"
	'sql = sql & " where 1=1"
	'if intCodColaborador<>"0" then
	'	sql = sql & " and (cod_colaborador=" & intCodColaborador & " or cod_colaborador_ultima_interacao=" & intCodColaborador & ")"
	'end if
	'sql = sql & " and pp.cod_empresa = " & session("codEmpresa")
	'if intCodTurma<>"0" then
	'	sql = sql & " and pp.cod_turma=" & intCodTurma
	'end if
	'if intCodTurno<>"0" then
	'	sql = sql & " and pp.cod_turno=" & intCodTurno
	'end if
	'if intCodDisciplina<>"0" then
	'	sql = sql & " and pp.cod_disciplina=" & intCodDisciplina
	'end if
	'
	'sql = sql & " order by di.desc_disciplina, pp.data_aula_extra, pp.numero_aula, tp.descricao"
	
	if intCodTurnoTela = "0" then
		sql = " SELECT Distinct "
		sql = sql & " 	a.COD_DISCIPLINA, d.desc_disciplina, h.codturno "
		sql = sql & " FROM SCA_HORARIO_AULA a "
		sql = sql & " inner join SCA_HORARIO h on h.codigo = a.cod_horario "
		sql = sql & " inner join sca_disciplina d on d.cod_disciplina = a.cod_disciplina "
		sql = sql & " inner join sca_turma tu on tu.cod_turma = a.cod_turma"
		sql = sql & " WHERE a.anoletivo = "  & strAnoLetivo
		sql = sql & " and a.cod_turma = " & intCodTurma
		if intCodDisciplina <> "0"	 then
			sql = sql & " and a.cod_disciplina = " & intCodDisciplina
		end if
		sql = sql & " order by d.desc_disciplina"
	else
		sql = " SELECT Distinct "
		sql = sql & " 	a.COD_DISCIPLINA, d.desc_disciplina "
		sql = sql & " FROM SCA_HORARIO_AULA a "
		sql = sql & " inner join SCA_HORARIO h on h.codigo = a.cod_horario "
		sql = sql & " inner join sca_disciplina d on d.cod_disciplina = a.cod_disciplina "
		sql = sql & " inner join sca_turma tu on tu.cod_turma = a.cod_turma"
		sql = sql & " WHERE a.anoletivo = "  & strAnoLetivo
		sql = sql & " and a.cod_turma = " & intCodTurma
		if intCodDisciplina <> "0"	 then
			sql = sql & " and a.cod_disciplina = " & intCodDisciplina
		end if
		sql = sql & " order by d.desc_disciplina"
	end if
	if session("usuarioWeb") = "ROBERTO" THEN
				'RESPONSE.WRITE SQL & "<hr>"
				'response.end
			end if
			
	rsAux.open sql, cnn
	if not rsAux.eof then 
		While not rsAux.eof
			if intCodTurnoTela = "0" then 'se não selecionou o turno na tela, será buscado do horário de aula
				intCodTurno = rsAux("codturno")
			else
				intCodTurno = intCodTurnoTela
			end if
			intCodDisciplina = rsAux("COD_DISCIPLINA")
			intCodColaborador = 0
			contExtra = 0
			contAula = 0
			numero_aula_anterior = 0
			sql="SP_rel_planejamento " & intCodColaborador & "," & session("codEmpresa") & "," & intCodTurma & "," & intCodTurno & "," & intCodDisciplina & "," & strAnoLetivo & ",'" & formatadataBD(dataInicio) & "', '" & formatadataBD(dataFim) & "'"
			if session("usuarioWeb") = "ROBERTO" THEN
				RESPONSE.WRITE SQL & "<hr>"
				'response.end
			end if
			rs.open sql, cnn
			if not rs.eof then 
				While not rs.eof
					
					if disciplina<>rs("disciplina") then
						linha_cab
						%>
						  <tr>
							<td colspan="10" class="celula font14">Componente curricular: <strong><%=rs("disciplina")%></strong></td>
						  </tr>
						<%
					end if
					
					extra = rs("data_aula_extra")
					numero_aula = rs("numero_aula")
					
					data_planejamento = formatadataAP(rs("data_planejamento"))
					if not isnull(extra) then 
						data_planejamento = formatadataAP(rs("data_aula_extra"))
						numero_aula = "sábado letivo"
						contExtra = contExtra + 1
						
						%>
						  <tr <%=fundoLinha%> >
							<td rowspan="<%=rs("rowspan")%>" class="celula" align="center"><%=numero_aula%></td>
							<td class="celula" align="center"><%=data_planejamento%></td>
							<td class="celula"><%=rs("professor")%> </td>
							<td class="celula"><%=rs("unidade_tematica_geral")%></td>
							<td class="celula"><%=rs("unidade_tematica")%></td>
							<td class="celula"><%=rs("conteudo")%></td>
							<td class="celula"><%=rs("complemento")%></td>
							<td rowspan="<%=rs("rowspan")%>" class="celula"><%=rs("metodologia")%></td>
							<td rowspan="<%=rs("rowspan")%>" class="celula"><%=rs("avaliacao")%></td>
							<td rowspan="<%=rs("rowspan")%>" class="celula"><%=rs("conteudo_complementar")%></td>
						  
						  </tr>
						<%
					else
						if trim(numero_aula_anterior)<>trim(numero_aula) then
							contAula = contAula + 1
							
							%>
							  <tr <%=fundoLinha%> >
								<td rowspan="<%=rs("rowspan")%>" class="celula" align="center"><%=numero_aula%></td>
								<td rowspan="<%=rs("rowspan")%>" class="celula" align="center"><%=data_planejamento%></td>
								<td rowspan="<%=rs("rowspan")%>" class="celula"><%=rs("professor")%> </td>
								<td class="celula"><%=rs("unidade_tematica_geral")%></td>
								<td class="celula"><%=rs("unidade_tematica")%></td>
								<td class="celula"><%=rs("conteudo")%></td>
								<td class="celula"><%=rs("complemento")%></td>
								<td rowspan="<%=rs("rowspan")%>" class="celula"><%=rs("metodologia")%></td>
								<td rowspan="<%=rs("rowspan")%>" class="celula"><%=rs("avaliacao")%></td>
								<td rowspan="<%=rs("rowspan")%>" class="celula"><%=rs("conteudo_complementar")%></td>
							  
							  </tr>
							<%
						else
							%>
							  <tr <%=fundoLinha%> >
								<td class="celula"><%=rs("unidade_tematica_geral")%></td>
								<td class="celula"><%=rs("unidade_tematica")%></td>
								<td class="celula"><%=rs("conteudo")%></td>
								<td class="celula"><%=rs("complemento")%></td>
							  </tr>
							<%
						
						end if
					end if
					
					disciplina = rs("disciplina")
					numero_aula_anterior = rs("numero_aula")
					if isnull(numero_aula_anterior) then numero_aula_anterior = 0
					intQtdeRegistroPorPagina = intQtdeRegistroPorPagina + 1
					rs.movenext
				wend
			
				%>
		  
			  <%if strAssinatura="S" then%>
			  <tr>
				<td colspan="10" class="celula">Quantidade de aula: <%=contAula%> | Quantidade de aula sábado letivo: <%=contExtra%> | Total: <%=contAula+contExtra%></td>
			  </tr>
			  <tr height="28">
					<td colspan="10" class="celula">
						<br>
						<br>
						<table width="100%" border="0" cellspacing="0" cellpadding="0" style="border: none !important;">
							<tr>
								<td width="50%" align="center" style="border: none !important;">
									______________________________________
								</td>
								<td width="50%" align="center" style="border: none !important;">
									______________________________________
								</td>
							</tr>
							<tr>
								<td align="center" valign="top" style="border: none !important;">
									Coordenador(a)
								</td>
								<td align="center" valign="top" style="border: none !important;">
									Professor(a)
								</td>
							</tr>
						</table>				
						<br>
					</td>
				</tr>
				<%end if%>
				<%
			
			end if
			rs.close
			
			rsAux.movenext
		 wend
		 
	end if
	rsAux.close
%>
</table>
</body>
<script>
	aguarde.style.display="none";
</script>
</html>