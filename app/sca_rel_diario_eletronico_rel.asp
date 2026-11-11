<%
response.Expires=0
'Não armazena a página em buffer antes de mostra-la na tela'
response.Buffer = false
SESSION.Timeout = 1200
Server.ScriptTimeout = 1200
%>
<html>
<head>
<title>GEMUL - Diário eletrônico</title>
<meta http-equiv="content-type" content="text/html; charset=UTF-8">
<link type="text/css" rel="stylesheet" href="css_rel/Estilo_Impressao.css">
<script src="js/js_funcoes_gerais.js"></script>
<script src="js_app/js_barra_movel.js"></script>
</head>
<body>
<!--#include file="includes/inc_verificaSessionApp.asp"-->
<!--#include file="includes/inc_cnn.asp"-->
<!--#include file="includes/inc_formatadata.asp"-->
<!--#include file="includes/inc_Botoes_relatorio.asp"-->
<!--#include file="includes/inc_aguarde.asp"-->

<%
	
	if trim(request("txtAnoLetivo")) = "" then 
		strAnoLetivo = session("strAnoLetivo")
	else
		strAnoLetivo = request("txtAnoLetivo")
	end if
	strQtdeFaltas = request("cmbQtdeFaltas")
	strMes		 		= Trim(Request("cmbMes"))	
    
	
	if strMes = "12" then
	   qtdeDiasMes  = "31"
	else   
		aux=Cdate("01/" & cInt(ZEROLEFT(strMes,2))+1 & "/" & cInt(strAnoLetivo)) - 1
	    qtdeDiasMes = day(aux)
	end if	
	
	'GRAVANDO NO ARQUIVO DE NOTAS
	strGravarOnde = "NOTA"
	msnHistorico  = ""
		
	if  Trim(Request("cmbTurma")) <> "" then
		intCodTurma 			= Trim(Request("cmbTurma"))
		intCodTurmaProfessor	= Trim(Request("cmbTurma"))
	else
		intCodTurma				= Trim(Request("cmbTurmaProfessor"))
		intCodTurmaProfessor	= Trim(Request("cmbTurmaProfessor"))
	end if
	
	if  Trim(Request("cmbDisciplinaTurma")) <> "" then
		intCodDisciplina			= Trim(Request("cmbDisciplinaTurma"))
		intCodDisciplinaTurma		= Trim(Request("cmbDisciplinaTurma"))
	else
		intCodDisciplina			 = Trim(Request("cmbDisciplinaDoProfessor"))
		intCodDisciplinaTurma		 = Trim(Request("cmbDisciplinaDoProfessor"))
	end if
	if intCodTurma = "" then intCodTurma = "0"
	if intCodTurmaProfessor = "" then intCodTurmaProfessor = "0"
	if intCodDisciplina = "" then intCodDisciplina = "0"
	if intCodDisciplinaTurma = "" then intCodDisciplinaTurma = "0"
	intCodTurmaTela				= intCodTurma
	intCodCurso	 				= Trim(Request("cmbCurso"))
	intCodPeriodo 				= Trim(Request("cmbPeriodo"))
	intSemestre 				= Trim(Request("cmbSemestre"))
	strMostraConteudo 		    = Trim(Request.Form("mostraConteudo"))
	intCodTurnoRH           	= Trim(Request("cmbTurnoRH")) 
	
	intCodTurno		 			= Trim(Request("cmbTurno"))
	strAlunos      				= Trim(Request("chkAluno"))
	intCodTipoNota				= Trim(Request("cmbAvaliacao"))
	intCodTipoLancamento		= Trim(Request("cmbTipoLancamento")) '"0" '-->Nota e Falta | "1" '-->Somente Nota	| "2" '-->Somente Falta		
	strNomeNota 		= ""
	strNomeTipoBimestre = ""
	strPosicao 			= ""


	if intCodTurno = "" then

		sql="SELECT Cod_Turno FROM SCA_TURMA"
		sql=sql & " WHERE Cod_Turma =" & intCodTurma
		rs.open sql, cnn
			intCodTurno = rs("Cod_Turno")
		rs.close

	end if

    
	if intSemestre = "3" then 
	   msgSemestre = ""
	else   
	   msgSemestre = "/"& intSemestre
	end if   
	strTituloRelatorio ="Di&aacute;rio de Frequência <br> Referência: " &ucase(monthName(strMes)) & " - " & strAnoLetivo & msgSemestre

	
	strNomedisciplina = ""
	sql = "SELECT DESC_DISCIPLINA FROM SCA_DISCIPLINA"
	sql = sql & " WHERE	COD_DISCIPLINA = " & intCodDisciplina
	rs.open sql, cnn
	if not rs.eof then
		strNomedisciplina = rs("DESC_DISCIPLINA")
	end if
	rs.close
	
	sql = "SELECT DISTINCT SRH_COLABORADOR.CODIGO, SRH_COLABORADOR.NOME AS COLABORADOR, H.CodTurno"
	sql = sql & " FROM SCA_HORARIO_AULA"
	sql = sql & " INNER JOIN SCA_HORARIO H ON H.codigo = SCA_HORARIO_AULA.COD_HORARIO"
	sql = sql & " INNER JOIN SRH_COLABORADOR ON SRH_COLABORADOR.CODIGO = SCA_HORARIO_AULA.COD_COLABORADOR"
	sql = sql & " WHERE	SCA_HORARIO_AULA.ANOLETIVO=" & strAnoLetivo
	sql = sql & " AND		SCA_HORARIO_AULA.SEMESTRE=" & intSemestre
	sql = sql & " AND		SCA_HORARIO_AULA.COD_TURMA=" & intCodTurma
	sql = sql & " AND		SCA_HORARIO_AULA.COD_DISCIPLINA=" & intCodDisciplinaTurma
	sql = sql & " AND 		H.CodTurno =" & intCodTurnoRH
	if session("usuarioWeb") = "SERGIO" then
		'response.write sql
	end if
	rs.open sql, cnn
	if not rs.eof then 
		strProfessor = RS("COLABORADOR")
		intCodColaborador = rs("CODIGO")
		intCodTurnoProfessor = rs("CodTurno")
		rs.close
	else
		rs.close
		strProfessor = "PROFESSOR(A) NÃO INFORMADO NO HORÁRIO DE AULA"
		%>
		<script>
			alert("Não foi encontrado professor para a turma e turno informado.\nVerifique se o horário de aula está lançado!");
			window.history.back();
		</script>		
		<%
		response.end
	end if
	
	
	intQtdeAulasMinistradas = 0
	sql = " select distinct cm.data_aula, pp.numero_aula,0"
	sql = sql & " from dbo.SCA_CONTEUDO_MINISTRADO_PROFESSOR CM "
	sql = sql & " inner join SCA_PLANEJAMENTO_PROFESSOR pp on cm.cod_planejamento_professor = pp.cod_planejamento_professor "
	sql = sql & " where pp.Cod_turma = " & intCodTurma	 
	sql = sql & " and pp.Cod_Disciplina = " & intCodDisciplina
	sql = sql & " and MONTH(cm.data_aula) = " & cInt(ZEROLEFT(strMes,2)) 
	sql = sql & " and YEAR(cm.data_aula) = " & cInt(strAnoLetivo) 
	sql = sql & " and pp.data_aula_extra is null"
	sql = sql & " and pp.Cod_Empresa = " & Session("CodEmpresa") 
	sql = sql & " union all"
	sql = sql & " select distinct 0, cm.data_aula, e.Sequencia "
	sql = sql & " from dbo.SCA_CONTEUDO_MINISTRADO_PROFESSOR CM "
	sql = sql & " inner join SCA_PLANEJAMENTO_PROFESSOR pp on cm.cod_planejamento_professor = pp.cod_planejamento_professor "
	sql = sql & " inner join SCA_HORARIO_AULA_EXTRA e on e.DataLancamento = cm.data_aula and e.Cod_turma = pp.cod_turma and e.Cod_Disciplina = pp.cod_disciplina "'and e.Cod_Colaborador = pp.cod_colaborador"
	sql = sql & " where pp.Cod_turma = " & intCodTurma	 
	sql = sql & " and pp.Cod_Disciplina = " & intCodDisciplina
	sql = sql & " and MONTH(cm.data_aula) = " & cInt(ZEROLEFT(strMes,2)) 
	sql = sql & " and YEAR(cm.data_aula) = " & cInt(strAnoLetivo) 
	sql = sql & " and pp.data_aula_extra is not null"
	sql = sql & " and pp.Cod_Empresa = " & Session("CodEmpresa") 
	'response.write sql
	rsAux1.open sql, cnn, 3, 1
	if not rsAux1.eof then
		intQtdeAulasMinistradas = rsAux1.recordcount
	end if
	rsAux1.close
	
	if intCodDisciplina = "" then intCodDisciplina = "0"
	sql = " select distinct DAY(CM.data_aula), CM.data_aula from dbo.SCA_CONTEUDO_MINISTRADO_PROFESSOR CM" 
	sql = sql & " inner join SCA_PLANEJAMENTO_PROFESSOR pp on cm.cod_planejamento_professor = pp.cod_planejamento_professor"	
	sql = sql & " where pp.Cod_turma = " & intCodTurma	
	sql = sql & " and pp.Cod_Disciplina = " & intCodDisciplina
	sql = sql & " and MONTH(cm.data_aula) = " & cInt(ZEROLEFT(strMes,2))
	sql = sql & " and YEAR(cm.data_aula) = " & cInt(strAnoLetivo)
	sql = sql & " and pp.Cod_Empresa = " & Session("CodEmpresa")
	sql = sql & " order by DAY(cm.data_aula) "
	
	rsAux1.open sql, cnn, 3, 3
	if not rsAux1.eof then
		vetAux1 = rsAux1.getRows
	end if
	rsAux1.close
	
	'------------------------------------------------------------------------------
	'----------------------INICIO DA BUSCA DE AULAS PREVISTAS ---------------------
	'------------------------------------------------------------------------------
	
	function buscaAulasExtrasTurma(cod_disciplina, Cod_Turma, strAnoLetivo, intCodTurno, codCursoAux, cursoAux, codPeriodoAux, periodoAux, codDisciplinaAux, disciplinaAux, turmaAux)

		existeAulaExtra= false
		
		sql = "select distinct DataLancamento, sequencia from SCA_HORARIO_AULA_EXTRA"
		sql = sql & " where month(DataLancamento)=" & strMes
		sql = sql & " and Cod_Turma = " & Cod_Turma 
		sql = sql & " and Cod_Disciplina = " & cod_disciplina 
		sql = sql & " and Cod_Empresa = " & session("CodEmpresa")
		sql = sql & " and AnoLetivo = " & strAnoLetivo 
		'if session("usuarioWeb") = "ROBERTO.JUNIOR" THEN
		''	response.write sql & "<hr>"
		'end if
		rsAux.open sql, cnn
		if rsAux.eof = false then
			existeAulaExtra = true
			vetAulaExtra = rsAux.getRows()
		end if
		rsAux.close

		if existeAulaExtra then
			
			for contAulaExtra=0 to UBound(vetAulaExtra,2)
				dataAulaExtra = vetAulaExtra(0,contAulaExtra)
				sequenciaExtra = vetAulaExtra(1,contAulaExtra)

				estilo_cor_aux = "amarelo"
				codigoPlanejamentoProfAux = 0

				'Seleciona as Aulas Extras
				sql = "select p.data_aula_extra, p.cod_planejamento_professor, p.validado, p.observacao, (select COUNT(*) from SCA_CONTEUDO_MINISTRADO_PROFESSOR where cod_planejamento_professor = p.cod_planejamento_professor) as qtde_conteudo_ministrado"
				sql = sql & " from SCA_PLANEJAMENTO_PROFESSOR p"
				sql = sql & " where p.numero_aula is null"
				sql = sql & " and p.cod_disciplina = " & cod_disciplina
				sql = sql & " and p.cod_turma = " & Cod_Turma
				sql = sql & " and p.anoLetivo = " & strAnoLetivo
				sql = sql & " and p.cod_turno = " & intCodTurno	
				sql = sql & " and p.data_aula_extra='" & formataDataBD(dataAulaExtra) & "'"
				if session("usuarioWeb") = "ROBERTO.JUNIOR" THEN
					response.write sql & "<hr>"
				end if				
				rsAux.open sql, cnn,3,3
				qtde_aux_verifica_erro = 0
				if rsAux.eof = false then
					dataAulaExtra = rsAux("data_aula_extra")
					codigoPlanejamentoProfAux = rsAux("cod_planejamento_professor")
					if trim(intCodDisciplina) = trim(cod_disciplina) and cInt(month(dataAulaExtra)) = cInt(strMes) then
						intQtdeAulasPrevista = intQtdeAulasPrevista + 1
					end if
					qtde_aux_verifica_erro = rsAux.recordcount
				end if
				rsAux.close
			next		
		end if

	end function


	total_aulasPrevistas = 0
	sql = "SELECT d.mes, HA.Cod_Colaborador as codProfessor, HA.ANOLETIVO, HA.Semestre, cu.cod_curso, "
	sql = sql & " CU.Descricao AS curso, P.Cod_Periodo, P.Descricao AS periodo, di.cod_disciplina as cod_disciplina, di.desc_disciplina as disciplina, "
	sql = sql & " Tu.Cod_Turma, Tu.TurmaAluno as turma, d.ano, d.dia_mes"
	sql = sql & " from sca_calendario_dia_ue d "
	sql = sql & " inner join sca_calendario_ue c on c.cod_calendario_ue = d.cod_calendario_ue "
	sql = sql & " inner join sca_calendario_evento e on e.cod_calendario_evento = d.cod_calendario_evento "
	sql = sql & " inner join SCA_HORARIO_AULA HA on ha.AnoLetivo = d.ano and ha.DiaSemana = d.dia_semana and HA.COD_EMPRESA = c.cod_empresa"
	sql = sql & " inner join SCA_HORARIO H ON H.codigo = HA.COD_HORARIO and h.cod_empresa = ha.Cod_Empresa"
	sql = sql & " inner join SCA_TURMA tu on tu.Cod_Turma = ha.Cod_turma"
	sql = sql & " inner join SCA_DISCIPLINA di on di.Cod_Disciplina = ha.Cod_Disciplina"
	sql = sql & " INNER JOIN SCA_GRADECURRICULAR G ON G.COD_GRADECURRICULAR=Tu.COD_GRADECURRICULAR"
	sql = sql & " INNER JOIN SCA_PERIODO P ON P.COD_PERIODO=G.COD_PERIODO"
	sql = sql & " INNER JOIN SCA_CURSO CU ON CU.COD_CURSO=P.COD_CURSO"
	sql = sql & " where c.cod_empresa = " & Session("CodEmpresa")
	sql = sql & " AND HA.ANOLETIVO = " & strAnoLetivo
	sql = sql & " AND HA.SEMESTRE in (" & intSemestre & ")"
	sql = sql & " and d.ano = " & strAnoLetivo
	sql = sql & " and HA.Cod_Colaborador =  " & intCodColaborador
	sql = sql & " and h.CodTurno =  " & intCodTurno
	sql = sql & " and e.letivo='S' " 
	sql = sql & " order by di.desc_disciplina, ha.Cod_turma, d.ano, d.mes, d.dia_mes"
	if session("usuarioWeb") = "SERGIO" then
		'response.write sql
	end if
	RS.OPEN SQL, cnn
	IF NOT RS.EOF THEN
		numero_aula = 1
		ja_imprimiu_turma = "N"
		mostraMensagemNaoliberado = ""
									
		controle = 0
		while not rs.eof
			strDataAula = formataDataAp(rs("dia_mes") & "/" & rs("mes") & "/" & rs("ano"))
			strDataAulaTela = mid(strDataAula,1,5)
			codigoPlanejamentoProf = 0
			if trim(rs("mes")) = trim(strMes) and trim(rs("cod_disciplina")) = trim(intCodDisciplina) and trim(rs("cod_turma")) = trim(intCodTurmaTela) then
				intQtdeAulasPrevista = intQtdeAulasPrevista + 1
			end if
			controle 		= 1
			cod_disciplina 	= trim(rs("cod_disciplina"))
			Cod_Turma 		= trim(rs("Cod_Turma"))
			numero_aula 	= numero_aula + 1

			codCursoAux = rs("cod_curso")
			cursoAux = rs("curso")
			codPeriodoAux = rs("cod_periodo")
			periodoAux = rs("periodo")
			codDisciplinaAux = rs("cod_disciplina")
			disciplinaAux = rs("disciplina")
			turmaAux = rs("turma")

			mesAula = rs("mes")											
			
			rs.movenext
			if not rs.eof then
				codigoProximaDisciplina = rs("cod_disciplina")
				codigoProximaTurma = rs("cod_turma")
			else
				codigoProximaTurma = ""
				codigoProximaDisciplina = ""
			end if
			if trim(Cod_Turma) = trim(intCodTurma) then
				if (trim(codigoProximaTurma) <> trim(Cod_Turma)) or (trim(codigoProximaDisciplina) <> cod_disciplina)  then
					buscaAulasExtrasTurma cod_disciplina, Cod_Turma, strAnoLetivo, intCodTurno,codCursoAux, cursoAux, codPeriodoAux, periodoAux, codDisciplinaAux, disciplinaAux, turmaAux
				end if
			end if
			
		wend
	end if
	rs.close
	
	'------------------------------------------------------------------------------
	'----------------------FIM DA BUSCA DE AULAS PREVISTAS ------------------------
	'------------------------------------------------------------------------------
	
%>
<table width="98%" align="center" height="355" border="0"  class="CorFundo" cellpadding="0" cellspacing="0">
  <tr valign="top">
    <td>
	<table width="100%"  height="325" border="0" cellspacing="0" cellpadding="0">
      <tr valign="top">
        <td colspan="2" align="center">
		<form id="frm" method="post">
		<input type="hidden" name="txtPosicao" value="<%=strPosicao%>">
        <input type="hidden" name="cmbQtdeFaltas" value="<%=strQtdeFaltas%>">
		<input type="HIDDEN" name="txtBimestreAtual" value="<%=strCodBimestre%>">
		<input type="HIDDEN" name="txtData" value="<%=strData%>">
		           <!--#include file="includes/inc_cabecalhoRelatorio.asp"-->
		  <%
			sql = "SELECT TU.NOMETURMA, TU.TURMAALUNO, TU.ANO, TU.ANOLETIVO, T.DESC_TURNO "
			sql = sql & " FROM SCA_TURMA TU"
			sql = sql & " INNER JOIN SCA_TURNO T ON T.COD_TURNO = TU.COD_TURNO "
			sql = sql & " WHERE	TU.COD_EMPRESA = " & Session("CodEmpresa") 
			sql = sql & " AND	TU.COD_TURMA = " & intCodTurma
			rs.open sql, cnn
			if not rs.eof then
		  %>
		  <table width="100%" border="0" cellspacing="0" cellpadding="0" class="tabela">
            <tr bgcolor="#E5E5E5">
              <td width="6%" height="24" class="celula">&nbsp;<strong>Turma:</strong></td>
          		<td width="12%" class="celula"><%=RS("TURMAALUNO")%>&nbsp;&nbsp;<%=RS("NOMETURMA")%></td>
              <td width="7%" class="celula">&nbsp;<strong>Disciplina:</strong></td>
              <td width="23%" class="celula"><%if strNomedisciplina="" then%>Todas do Hor&aacute;rio<%else%><%=strNomedisciplina%><%end if%>&nbsp;</td>
              <td width="12%" class="celula">&nbsp;<strong>Turno:</strong></td>
              <td width="12%" class="celula">&nbsp;<%=RS("DESC_TURNO")%></td>
              	  <td width="7%" class="celula">&nbsp;<strong>Professor(a):</strong></td>
                  <td width="21%" class="celula">&nbsp;<%=strProfessor%></td>
               
            </tr>
          </table>
		  <%
		  end if
		  rs.close
			'**** SELECIONA OS ALUNOS REGULARES E NOTAS E FALTAS
			buscaHistorico = "N"
			if trim(intSemestre) = "3" then
			   if trim(strAnoLetivo) <> trim(session("strAnoLetivo"))  then
				  buscaHistorico = "S"
			   end if
			else
			   if trim(strAnoLetivo) <> trim(session("strAnoLetivo"))  or trim(intSemestre) <> trim(session("strSemestre")) then
				  buscaHistorico = "S"
			   end if	   
			end if

			if buscaHistorico = "N" then
				sql = " SELECT distinct "
				sql = sql & " AD.COD_ALUNO AS CODIGO, " 
				sql = sql & " AD.COD_TURMA_REMANEJAMENTO AS COD_TURMA, "
				sql = sql & " A.NOMEALUNO, "
				sql = sql & " A.MATRICULA, "
				sql = sql & " SA.DESC_SITUACAOALUNO "
				sql = sql & " FROM SCA_ALUNO_DISCIPLINA AD INNER JOIN " 
				sql = sql & " SCA_ALUNO A ON A.CODIGO = AD.COD_ALUNO  INNER JOIN "
				sql = sql & " SCA_SITUACAOALUNO SA ON SA.Cod_SituacaoAluno = A.COD_SITUACAOALUNO "
				
				sql = sql & " WHERE AD.COD_EMPRESA = " & Session("CodEmpresa")
					
				sql = sql & " AND AD.COD_TURMA_REMANEJAMENTO = " & intCodTurma	
				sql = sql & " AND AD.COD_ALUNO in (" & strAlunos & ") "
				sql = sql & " ORDER BY A.NOMEALUNO "

			else   
			   'seleciona os alunos pelo ano e semestres do histórico 			
			   sql = " select DISTINCT A.CODIGO, AT.COD_TURMA, HED.COD_DISCIPLINA, A.NOMEALUNO, A.MATRICULA,  '' AS SEQUENCIA, SA.DESC_SITUACAOALUNO "
			   sql = sql & " from SCA_HISTORICO_ESCOLAR_DISCIPLINA HED "
			   sql = sql & " INNER JOIN SCA_HISTORICO_ESCOLAR HE ON HE.CODIGO = HED.COD_HISTORICO_ESCOLAR "
			   sql = sql & " INNER JOIN SCA_ALUNO A ON A.CODIGO = HE.COD_ALUNO" 'AND A.COD_EMPRESA = HE.COD_EMPRESA "
			   sql = sql & " INNER JOIN SCA_SITUACAOALUNO SA ON SA.COD_SITUACAOALUNO = A.COD_SITUACAOALUNO" 'AND SA.COD_EMPRESA = A.COD_EMPRESA " 
			   sql = sql & " INNER JOIN SCA_ALUNO_TURMA AT ON  AT.COD_ALUNO=A.CODIGO" 'AND AT.COD_EMPRESA = A.COD_EMPRESA "
			   'sql = sql & " WHERE A.COD_EMPRESA = " & Session("CodEmpresa")
			   sql = sql & " WHERE AT.COD_TURMA = " & intCodTurma	
			   sql = sql & " AND HE.ANO_LETIVO = " & strAnoLetivo
			   sql = sql & " AND HE.SEMESTRE = " & intSemestre 
			   sql = sql & " AND HED.COD_DISCIPLINA= " & intCodDisciplina
			   sql = sql & " AND A.CODIGO in (" & strAlunos & ") "
			   sql = sql & " ORDER BY NOMEALUNO "
			end if
			rs.open sql, cnn
			%>		  
		  <table width="100%" border="0" cellspacing="0" cellpadding="0" class="tabela">
          <tr bgcolor="#E5E5E5">
            <td colspan="2" rowspan="2" align="center" class="celula"><strong><%=ucase(monthName(strMes))%></strong></td>
            <td height="24"  colspan="31" align="center" class="celula"><strong><%=ucase(strNomeTipoBimestre)%></strong></td>
            </tr>
          <tr bgcolor="#E5E5E5">
            <td height="24" colspan="31" align="center" class="celula"><strong>FALTA&nbsp;<%=strNomeNota%></strong></td>
          </tr>
          <tr bgcolor="#E5E5E5">
            <td height="19" class="celula"><div align="center"><strong>Matr&iacute;cula</strong></div></td>
            <td class="celula"><div align="center"><strong>Nome do Aluno</strong></div></td>
            
			<%
			if isArray(vetAux1) then
				for j=0 to ubound(vetAux1,2)
				   diaConteudo = vetAux1(0,j) 
				   %>
                   <td class="celula" align="center"><strong><%=ZeroLeft(diaConteudo,2)%></strong></td>
                   <%
				next	

				%>
            	<td class="celula" align="center"><strong>Tot.Fal</strong></td>
            	</tr>
		  		<%

			end if	
		  contLanc = 0
		  while not rs.eof
		  		contLanc = contLanc + 1
				strCodAluno = RS("CODIGO")
				
				  %>
				  <tr>
					<td class="celula" width="6%"><div align="center"><%=rs("MATRICULA")%>
					    <input type="hidden" name="txtCodAluno_<%=contLanc%>" value="<%=rs("CODIGO")%>">
			        </div></td>
					<td class="celula" width="67%">&nbsp;<%=rs("NOMEALUNO") %></td>
                    <%
					AcumuladaFalta = 0
					if isArray(vetAux1) then
						for j=0 to ubound(vetAux1,2)
							
							diaConteudo = vetAux1(0,j) 
							strData = strAnoLetivo & "/" & ZeroLeft(strMes,2) & "/" & ZeroLeft(diaConteudo,0)
                            diaSemana = weekday(strData)
							strCorPodeFazerAvaliacao = ""
							bolFalta = false
							selecionado = "0"
							
							' Consulta a quantidade de Faltas
							sql = " select cod_aluno, cod_disciplina, falta "
							sql = sql & " from SCA_FALTAS_DIARIA "
							sql = sql & " where cod_aluno = " & strCodAluno 
							sql = sql & " And cod_empresa = " & Session("CodEmpresa")
							sql = sql & " And data = '" & strData & "'"
							sql = sql & " and cod_disciplina = " & intCodDisciplina
							rsAux.open sql, cnn	
							if not rsAux.eof then
								while not rsAux.eof
									falta = rsAux("falta")
									if strNomedisciplina = "INTERDISCIPLINAR" then 
										falta = 1
										selecionado = falta
									else
										selecionado = selecionado + falta
									end if
									AcumuladaFalta = AcumuladaFalta + falta
									bolFalta = true
									rsAux.movenext
								wend
							else
								sql = " SELECT count(cod_turma) as total from SCA_HORARIO_AULA "
								sql = sql & " where cod_empresa = " & Session("CodEmpresa")
								sql = sql & " and cod_turma = " & intCodTurma
								sql = sql & " and anoLetivo = " & strAnoLetivo
								sql = sql & " and semestre = " & intSemestre
								sql = sql & " and Cod_Disciplina = " & intCodDisciplina
								sql = sql & " and diasemana = " & trim(diaSemana)
								rs1.OPEN SQL, CNN
								IF NOT rs1.EOF THEN
									TotalMatriz = rs1("total")
									if isnull(rs1("total")) or trim(rs1("total"))="0"  then
									   TotalMatriz = "0"
									end if   
								END IF
								rs1.close
								if TotalMatriz <> "0" and TotalMatriz <> "" then
								   	i=1
									selecionado = ""
									do while i <= clng(TotalMatriz)
										if diaSemana=7 then
											selecionado = "S.L."	
										else
											selecionado = selecionado & "."
										end if
										i = i + 1
									loop
								else
									if diaSemana=7 then
										selecionado = "S.L."	
									else
										selecionado = "."	
									end if
								end if	
							end if
							rsAux.close
							%>
							<td class="celula" width="1%" align="center"><%=selecionado%></td>
							<%
						next
					end if	
					if AcumuladaFalta = 0 then AcumuladaFalta = ""
					%>
 					<td class="celula" width="1%" align="center"><%=AcumuladaFalta%>&nbsp;</td>
                </tr>
			  <%
		  		rs.movenext
		  wend
		  rs.close
		  
		  %>
        </table>
		<input type="hidden" name="strQuantNotasBimAtual" value="<%=strQuantNotas%>">
		<input type="hidden" name="qtdeAluno" value="<%=contLanc%>">
		<input type="hidden" name="cmbPeriodo" value="<%=intCodPeriodo%>">
		<input type="hidden" name="cmbSemestre" value="<%=intSemestre%>">
		<input type="hidden" name="cmbDisciplinaTurma" value="<%=intCodDisciplina%>">
		<input type="hidden" name="chkTipoNota" value="<%=intCodTipoNota%>">
		<input type="hidden" name="cmbTurma" value="<%=intCodTurma%>">
		<input type="hidden" name="cmbTurno" value="<%=intCodTurno%>">
		<input type="hidden" name="chkAluno" value="<%=strAlunos%>">
		<input type="hidden" name="cmbTipoLancamento" value="<%=intCodTipoLancamento%>">
		<input type="hidden" name="cmbCurso" value="<%=intCodCurso%>">

		 <!--Armazena a média que o aluno deve alcançar para ser aprovado na disciplina-->
        <input type="Hidden" name="txtHiddenMediaAprovacao" value="<%=intMediaAprovacao%>"> 
		 <!--Armazena a média que o aluno deve alcançar para ser aprovado na disciplina-->
        <input type="Hidden" name="txtHiddenMediaAprovacaoFinal" value="<%=intMediaAprovacaoFinal%>"> 
        <!--Armazena a média que o aluno deve alcançar para ser aprovado na disciplina-->
        <input type="Hidden" name="txtHiddenTipoFormulaFinal" value="<%=strTipoFormulaFinal%>"> 
        <!--Armazena a média que o aluno deve alcançar para ser aprovado na disciplina-->
        <input type="Hidden" name="txtHiddenFreqMinima" value="<%=intFreqMinima%>"> 
        <!--Verifica se possui recuperação-->
        <input type="Hidden" name="txtHiddenRecuperacao" value="<%=strRecuperacao%>">	
        <!--Verifica se possui recuperação-->
        <input type="Hidden" name="txtHiddenConselho" value="<%=strConselho%>"> 
        <!--Verifica quantas disciplinas o aluno pode ficar de recuperação-->
        <input type="hidden" name="txtHiddenNumDisciplinaRec" value="<%=intNumDisciplinaRec%>"> 
        <!--Verifica quantas disciplinas o aluno pode ficar de prog. parcial-->
        <input type="hidden" name="txtHiddenNumDisciplinaProgParcial" value="<%=intNumDisciplinaProgParcial%>"> 
        <!--Verifica se haverá reprovação por falta para a prog. parcial-->
        <input type="hidden" name="txtHiddenReprovacaoFaltaProgParcial" value="<%=strReprovacaoFaltaProgParcial%>"> 
		<!--Verifica se haverá reprovação por falta para a prog. parcial-->
        <input type="hidden" name="txtHiddenNotaDoTipoEF" value="<%=strNotaDoTipoEF%>">
        <input type="hidden" name="txtQtdeDias" value="<%=qtdeDiasMes%>">
        <input type="hidden" name="cmbMes" value="<%=strMes%>">	
		<%
		
			strParametro = "Rel_DiarioFrequenciaEletronica_con.asp?cmbPeriodo="&intCodPeriodo
			strParametro = strParametro & "&cmbSemestre="&intSemestre
			strParametro = strParametro & "&chkTipoNota="&intCodTipoNota
			strParametro = strParametro & "&cmbTurma="&intCodTurma
			strParametro = strParametro & "&cmbTurmaProfessor="&intCodTurma
			strParametro = strParametro & "&chkAluno="&strAlunos
			strParametro = strParametro & "&cmbTurno="&intCodTurno
			strParametro = strParametro & "&cmbTipoLancamento="&intCodTipoLancamento	
			strParametro = strParametro & "&cmbCurso="&intCodCurso	
			strParametro = strParametro & "&cmbMes="&strMes
			strParametro = strParametro & "&cmbDisciplinaTurma="&intCodDisciplinaTurma
			strParametro = strParametro & "&cmbDisciplinaDoProfessor="&intCodDisciplinaTurma
			
		
		%>
		<div align="center">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</div>
		  <input type="hidden" name="txtAnoLetivo" value="<%=strAnoLetivo%>">
		  <input type="hidden" name="txtSemestre" value="<%=intSemestre%>">
          <input type="hidden" name="txtPaginaRetorno" value="FALTASPROF">
		</form>

			<table width="100%" align="center" class="tabela" border="1" cellspacing="0" cellpadding="0">
			  <tr>
				<td width="30%" height="135" align="center" class="celula"><table width="93%" border="0" cellspacing="0" cellpadding="0">
				  <tr>
					<td height="24">LEGENDA: </td>
				  </tr>
				  <tr>
					<td width="23%" height="19">&quot;.&quot; (ponto) =Acad&ecirc;mico PRESENTE &agrave; aula do dia.</td>
				  </tr>
				  <tr>
					<td height="17">&quot;N&ordm;&quot; (N&uacute;mero) = Total de Falta.</td>
				  </tr>
				  <tr>
					<td height="19">&quot;S.L.&quot; = Sábado letivo.</td>
				  </tr>
				  <tr>
					<td height="31">&nbsp;</td>
				  </tr>
				</table></td>
				<td width="33%" align="center" class="celula" valign="top">
				
				<table width="91%" border="0" cellspacing="0" cellpadding="0">
				  <tr valign="top">
					<td height="23" align="center">PARA USO DA COORDENAÇÃO </td>
				  </tr>
				  <tr>
					<td width="33%" height="17">&nbsp;</td>
				  </tr>
				  <tr>
					<td height="17" align="center">____________________________</td>
				  </tr>
				  <tr>
					<td height="17" align="center">&nbsp;</td>
				  </tr>
				  <tr>
					<td height="17" align="center">&nbsp;</td>
				  </tr>
				  <tr>
					<td height="17" align="center">_________/_________/_________</td>
				  </tr>
				</table></td>
				<td width="37%" align="center" class="celula" valign="top">
				<table width="91%" border="0" cellspacing="0" cellpadding="0">
				  <tr valign="top">
					<td height="23">AULAS PREVISTAS: <%=intQtdeAulasPrevista%> </td>
				  </tr>
				  <tr>
					<td width="33%" height="23">AULAS MINISTRADAS:  <%=intQtdeAulasMinistradas%></td>
				  </tr>
				  <tr>
					<td height="30">DATA:_________/_________/_________ </td>
				  </tr>
				  <tr>
					<td height="17">&nbsp;</td>
				  </tr>
				  <tr>
					<td height="23"><div align="center">____________________________________</div></td>
				  </tr>
				  <tr>
						<td height="17"><div align="center">VISTO DO PROFESSOR</div></td>
				  </tr>
				</table></td>
			  </tr>
			</table>

		</td>
      </tr>
    </table>
    
	</td>
  </tr>
</table>

<%if strMostraConteudo = "S" then %>

	<pre></pre>

	<%
	
	dataInicio = "01/" & strMes & "/" & strAnoLetivo
	dataFim = dateadd("d","-1", dateAdd("m",1,dataInicio))	
	
	
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
	  <tr bgcolor="#CCCCCC">
		<td width="70px" align="center" class="celula"><strong>Data</strong></td>
		<td width="100px" align="center" class="celula"><strong>Professor(a)</strong></td>
		<td width="20px" class="celula"><strong>Aula</strong></td>
		<td class="celula"><strong>Conteúdo Ministrado</strong></td>
		<td width="150px" class="celula"><strong>ConteúdoComplementar</strong></td>
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
	textSabadoAnterior = ""
	sql="SP_rel_conteudo_ministrado " & intCodColaborador & "," & intCodTurma & "," & intCodTurnoRH & "," & intCodDisciplina & ",'" & formatadataBD(dataInicio) & "', '" & formatadataBD(dataFim) & "'"
		'if session("usuarioWeb") = "SERGIO" THEN
			'RESPONSE.WRITE SQL & "<hr>"
		'end if
	rs.open sql, cnn
	if not rs.eof then 
		%>
		  <tr>
			<td colspan="6" class="celula font14">Componente curricular: <strong><%=rs("disciplina")%></strong></td>
		  </tr>
		<%
		While not rs.eof
			
			
			if not isnull(rs("desc_conteudo_ministrado")) then
	  			strDescContMin = rs("desc_conteudo_ministrado")
				if isnull(rs("numero_aula")) then
					ArrayExtra = split(strDescContMin,"|")
					
					for i=0 to UBound(ArrayExtra)-1
						campoSabadoAtual = left(ArrayExtra(i),16)
						
						if trim(campoSabadoAtual) <> trim(textSabadoAnterior) then
							contGeral = contGeral + 1
							contExtra = contExtra + 1
						end if
						textSabadoAnterior = left(ArrayExtra(i),16)
					next
					
					fundoLinha = " bgcolor='#fcfedb' "
				else
					contAula = contAula + 1
					contGeral = contGeral + 1
					fundoLinha = " bgcolor='#FFFFFF' "
				end if
			else
				strDescContMin = ""
			end if
			
			%>
			  <tr <%=fundoLinha%> >
				<td class="celula"><%=rs("data_aula")%></td>
				<td class="celula"><%=rs("professor")%> </td>
				<td class="celula"><%=rs("numero_aula")%></td>
				<td class="celula"><%=replace(strDescContMin,"|","<br>")%></td>
				<td class="celula"><%=rs("desc_conteudo_complementar")%></td>
			  </tr>
			<%

			intQtdeRegistroPorPagina = intQtdeRegistroPorPagina + 1
			textSabadoAnterior = ""
			rs.movenext
		wend
		
		%>
		  <tr>
			<td colspan="5" class="celula">Quantidade de aula: <%=contAula%> | Quantidade de aula sábado letivo: <%=contExtra%> | Total: <%=contAula+contExtra%></td>
		  </tr>
		  
		  <%if strAssinatura="S" then%>
		  <tr height="28">
				<td colspan="5">
					<br>
					<br>
					<table width="100%" border="0" cellspacing="0" cellpadding="0">
					  <tr>
						<td width="50%" align="center">______________________________________</td>
						<td width="50%" align="center">______________________________________</td>
					  </tr>
					  <tr>
						<td align="center" valign="top">Coordenador(a)</td>
						<td align="center" valign="top">Professor(a)</td>
					  </tr>
					</table>					
					<br>
				</td>
			</tr>
			<%end if%>
		 <%
		else
		%>
		  <tr>
			<td height="13" colspan="5" align="center" class="celula"><font color="#993300"><%=session("strMensagemRelatorioNaoEncontrado")%></font></td>
	  </tr>
		<%
	end if
	rs.close
%>
</table>


<% end if %>

<script>
	aguarde.style.display="none";
</script>
</body>
</html>