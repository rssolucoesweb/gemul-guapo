<%
RESPONSE.Write("RELATORIO EM DESENVOLVIMENTO")
RESPONSE.END

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
<title>Boletim Escolar</title>
<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1">
<link type="text/css" rel="stylesheet" href="../../Estilo/Estilo_Impressao.css">
<script src="../../js/js_funcoes_gerais.js"></script>
<script src="../../js/js_barra_movel.js"></script>
</head>
<body>
<!--#include file="../../includes/inc_verificaSession.asp"-->
<!--#include file="../../includes/inc_cnn.asp"-->
<!--#include file="../../includes/inc_formatadata.asp"-->
<!--#include file="../includes/inc_sqlAlunoTurma.asp"-->
<!--#include file="../../includes/inc_Botoes_relatorio.asp"-->
<!--#include file="../../includes/inc_aguarde.asp"-->
<br>
<form method="POST" name="form_escola" action="boletim.asp">
<%
	'recebe os alunos selecionados e converte para um vetor'
	chkAluno = Trim(Request.Form("chkAluno"))
	if chkAluno <>"" then
		vetAlunos = split(chkAluno,",")
	end if
	'de acordo com os alunos selecionados'
	for intContAluno = 0 to ubound(vetAlunos)
%>
<table border="0" width="100%" height="100%" align="center">

<!--include file="../../includes/inc_cabecalhoRelatorioBoletim.asp"-->
<tr>
<%
intTipoAluno = Trim(Request.Form("cmbTipoAluno")) 
intContBoletim = intContBoletim + 1
intTipoRelatorio = 1'Trim(Request.Form("txtTipoRelatorio")) 

'intTipoRelatorio = 2 --> colégio militar

'nome das colunas do relatório
if intTipoRelatorio = 2 then
	'COLÉGIO MILITAR
	strNomeProvaFinal = "R.E."
ELSE
	strNomeProvaFinal = "PROVA<BR>FINAL"
end if

if intCodSemestre = "" then intCodSemestre=0

if intContBoletim = 2 then
	%>
	<td><hr size="1" color="#CCCCCC"></td>
	<tr></tr>
	<%
end if
%>
<td valign="top">

<table border="0" width="95%" align="center">
  <tr>
    <td width="5%" align="left" height="54">
    <img border="0" src="../../imagens/brasao.jpg" width="36" height="41">
    </td>
    <td width="35%" align="left" height="54">
    <b><%=session("strNomeEstadoResponsavel")%><BR><%=session("strNomeSecretariaResponsavel")%><br>
    </b>
 	<%=ucase(Session("strNomeEscola"))%>
    </td>
    <td width="60%" align="left" height="54">
    <p align="center"><b>EXTRATO DE NOTAS E FALTAS <br>
    </b><b><br>
    <%=trim(strNomeComposicao)%></b></p>
    </td>
  </tr>
</table>
<table border="0" width="95%" cellspacing="0" bordercolor="#000000" align="center">
  <tr>
    <td colspan="5">
       NOME DO ALUNO (A):
      <% = ucase(strNomeAluno) %>
    </td>
  </tr>
  <tr>
    <td width="23%">

     MATRÍCULA:
	<%=strMatAluno%>
    </td>
    <td width="19%">
    N.CHAM.:
	<%=intSequencia%>
    </td>
    <td width="32%">
      DATA DE EMISSÃO:
     <%=formataDataAP(date)%>
    </td>
    <td colspan="2">
    </td>
  </tr>
  <tr>
    <td>
      TURNO:
       <%=ucase(strNomeTurno)%>
    </td>
    <td>
     TURMA:
    <%=ucase(strNomeTurma)%>
    </td>
    <td>
    SÉRIE:<%=strNomeSerie%>
    </td>
    <td width="12%">
    ANO LETIVO:<%=strAnoLetivo%>
    </td>
	<%if intCodComp = "208" or intCodComp = "143" or intCodComp = "508" or intCodComp = "443" then%>
    <td width="14%">SEMESTRE:<%=strSemestre%></td>
	<%end if%>
  </tr>
</table>
        <table width="95%" align="center" cellspacing="0" class="tabela" >
          <tr> 
            <td rowspan="2" align="center" class="celula" > <p style="word-spacing: 0; margin-bottom: 0">DISCIPLINAS</p></td>
            <td class="celula" align="center" colspan="2" >1º. BIMESTRE</td>
            <td class="celula" align="center" colspan="2" >2º. BIMESTRE</td>
            <%if intTipoRelatorio=2 then 'campos disponíveis apenas para o colégio militar%>
            <td rowspan="2" align="center" class="celula">MS1</td>
            <td rowspan="2" align="center" class="celula">1&ordf; RS</td>
            <%end if%>
            <%if strEja = "N" then%>
            <td class="celula" align="center" colspan="2" >3º. BIMESTRE</td>
            <td class="celula" align="center" colspan="2" >4º. BIMESTRE</td>
            <%if intTipoRelatorio=2 then 'campos disponíveis apenas para o colégio militar%>
            <td rowspan="2" align="center" class="celula" >MS2</td>
            <td rowspan="2" align="center" class="celula" >2&ordf; RS</td>
            <%end if%>
            <td rowspan="2" align="center" class="celula" >MA</td>
            <%end if%>
            <td rowspan="2" align="center" class="celula" ><%=strNomeProvaFinal%></td>
            <td rowspan="2" align="center" class="celula" >CONS.</td>
            <!--<td width="6%" rowspan="2" align="center" class="celula">CONSELHO</td>-->
            <td rowspan="2" align="center" class="celula" >MÉDIA<br>
              FINAL</td>
            <td rowspan="2" align="center" class="celula" >TOTAL<br>
              FALTAS</td>
          </tr>
          <tr> 
            <td align="center" class="celula" >NOTAS</td>
            <td align="center" class="celula" >FALTAS</td>
            <td align="center" class="celula" >NOTAS</td>
            <td align="center" class="celula" >FALTAS</td>
            <%if strEja = "N" then%>
            <td align="center" class="celula" >NOTAS</td>
            <td align="center" class="celula" >FALTAS</td>
            <td align="center" class="celula" >NOTAS</td>
            <td align="center" class="celula" >FALTAS</td>
            <%end if%>
          </tr>
          <%
				'recupera as disciplinas da composição escolhida'
				strSql = "SELECT D.COD_DISCIPLINA, D.DESC_DISCIPLINA"
				strSql = strSql & " FROM SCA_DISCIPLINA D"
				strSql = strSql & " INNER JOIN SCA_GRADECURRICULARDISCIPLINA GD ON D.COD_DISCIPLINA = GD.COD_DISCIPLINA"
				strSql = strSql & " INNER JOIN SCA_GRADECURRICULAR G ON G.COD_GRADECURRICULAR = GD.COD_GRADECURRICULAR AND G.COD_EMPRESA = D.COD_EMPRESA"
				strSql = strSql & " WHERE	D.COD_EMPRESA = "
				strSql = strSql & " AND		G.COD_PERIODO = "

				strSql = "SELECT APE_disciplinas.descricao, APE_disciplinas.codigo, APE_qd_curricular_disciplina.codigo_sia_turno, APE_qd_curricular_disciplina.codigo_sia_unid_ensino, APE_qd_curricular_disciplina.ano_letivo"
				strSql = strSql & " FROM APE_disciplinas INNER JOIN APE_qd_curricular_disciplina ON APE_disciplinas.codigo = APE_qd_curricular_disciplina.codigo_ape_disciplina"
				strSql = strSql & " WHERE APE_qd_curricular_disciplina.codigo_ape_serie=" & intCodSerie
				strSql = strSql & " AND APE_qd_curricular_disciplina.codigo_sia_turno=" & intCodTurno
				strSql = strSql & " AND APE_qd_curricular_disciplina.codigo_sia_unid_ensino=" & strCodigoSia
				strSql = strSql & " AND APE_qd_curricular_disciplina.ano_letivo=" & strAnoLetivo
				strSql = strSql & " AND APE_qd_curricular_disciplina.semestre=" & intCodSemestre
'				if intTipoAluno = "2" then
'					'Alunos com dependencia
'					strSql = strSql & " and APE_disciplinas.codigo in ("
'					strSql = strSql & "	SELECT ave_aluno_dependencia.codigo_ape_disciplina FROM ave_aluno_dependencia"
'					strSql = strSql & " WHERE ave_aluno_dependencia.codigo_ave_aluno_ano_letivo=" & vetAlunos(intContAluno)
'					strSql = strSql & " AND ave_aluno_dependencia.codigo_sia_unid_ensino=" & strCodigoSia
'					strSql = strSql & " AND ave_aluno_dependencia.ano_letivo=" & strAnoLetivo
'					strSql = strSql & " AND ave_aluno_dependencia.semestre=" & intCodSemestre
'					strSql = strSql & " AND ave_aluno_dependencia.codigo_ave_turma=" & intCodTurma
'					strSql = strSql & " AND ave_aluno_dependencia.codigo_status=0"	
'					strSql = strSql & " )"
'				end if
				strSql = strSql & " ORDER BY APE_disciplinas.codigo"
				response.write strSql
				response.End()
				rsaux.open strSql,cnn
				
				intQtdeDisciplinas = 0
				
				intQtdFaltas_Total_1 = 0
				intQtdFaltas_Total_3 = 0
				intQtdFaltas_Total_5 = 0
				intQtdFaltas_Total_7 = 0
				intQtdFaltas_Total	 = 0
				
				intNota_Total_1 = 0
				intNota_Total_2 = 0
				intNota_Total_3 = 0
				intNota_Total_4 = 0
				intNota_Total_5 = 0
				intNota_Total_6 = 0
				intNota_Total_7 = 0
				intNota_Total_8 = 0
				intNota_Total_9 = 0
				intNota_Total_10 = 0
				intNota_Total_11 = 0
				intNota_Total_12 = 0
				intNota_Total_13 = 0
				intNota_Total_14 = 0
				intNota_Total_15 = 0
				intNota_Total_16 = 0				

				if not rsaux.eof then
					strCodDisciplinas = ""
					strDisciplinas=""
					while not rsaux.eof
						if strDisciplinas <>"" then strDisciplinas = strDisciplinas & ","
						strDisciplinas = strDisciplinas & rsaux("codigo")
						
						intCodDisciplina  = rsaux("codigo")
						strNomeDisciplina = rsaux("descricao")
						
						
						intQtdeDisciplinas = intQtdeDisciplinas +1
						bolOptativa = false
						'***** VERIFICA SE A DISCIPLINA É OPTATIVA PARA O ALUNO
						sql = "SELECT APE_disciplina_optativa.codigo_ape_disciplinas"
						sql=sql & " 	FROM APE_disciplina_optativa"
						sql=sql & " 	WHERE APE_disciplina_optativa.codigo_sia_unid_ensino=" & session("strCodigoSia")
						sql=sql & " 	AND APE_disciplina_optativa.ano_letivo=" & session("strAnoLetivo")
						sql=sql & " 	AND APE_disciplina_optativa.semestre=" & intCodSemestre						
						sql=sql & " 	AND APE_disciplina_optativa.codigo_ape_serie=" & intCodSerie 
						sql=sql & " 	AND APE_disciplina_optativa.codigo_ape_disciplinas=" & intCodDisciplina 
						sql=sql & " 	AND APE_disciplina_optativa.codigo_ave_aluno_ano_letivo=" & vetAlunos(intContAluno)					
						rsAux2.open sql, cnn
						if rsAux2.eof = false then 		
							'A DISCIPLINA É OPTATIVA PARA O ALUNO
							'NÃO DEVERÁ SER CONTADA AO FAZER A MÉDIA DAS NOTAS DE TODAS AS DISCIPLINAS DO BIMESTRE
							intQtdeDisciplinas = intQtdeDisciplinas - 1	
							bolOptativa = true					
						end if
						rsAux2.close
						'*****						

						'inicializando notas'
						intNota_1 = "-"
						intNota_2 = "-"
						intNota_3 = "-"
						intNota_4 = "-"
						intNota_5 = "-"
						intNota_6 = "-"
						intNota_7 = "-"
						intNota_8 = "-"
						intNota_9 = "-"
						intNota_10 = "-"
						intNota_11 = "-"
						intNota_12 = "-"
						intNota_13 = "-"
						intNota_14 = "-"
						intNota_15 = "-"
						intNota_16 = "-"
						
						'inicializando as faltas'
						intQtdFaltas_1 = 0
						intQtdFaltas_3 = 0
						intQtdFaltas_5 = 0
						intQtdFaltas_7 = 0
						intQtdFaltas_TotalDisciplina = 0

						'recupera as notas do aluno escolhido para cada disciplina cursada'
						strSql = "SELECT DISTINCT AVE_boletim_escolar.falta as qtdFaltas, "
						strSql = strSql & " AVE_boletim_escolar.codigo_ape_disciplina as codigo_disciplina, "
						strSql = strSql & " AVE_boletim_escolar.nota, AVE_boletim_escolar.codigo_status_boletim_escolar as status,"
						strSql = strSql & " AVE_aluno_turma.codigo_ave_turma"
						strSql = strSql & " FROM (AVE_aluno_ano_letivo INNER JOIN AVE_boletim_escolar"
						strSql = strSql & " ON (AVE_aluno_ano_letivo.semestre = AVE_boletim_escolar.semestre)"
						strSql = strSql & " AND (AVE_aluno_ano_letivo.ano_letivo = AVE_boletim_escolar.ano_letivo)"
						strSql = strSql & " AND (AVE_aluno_ano_letivo.codigo_sia_unid_ensino = AVE_boletim_escolar.codigo_sia_unid_ensino)"
						strSql = strSql & " AND (AVE_aluno_ano_letivo.codigo_ave_aluno = AVE_boletim_escolar.codigo_ave_aluno_ano_letivo))"
						strSql = strSql & " INNER JOIN AVE_aluno_turma ON (AVE_aluno_ano_letivo.semestre = AVE_aluno_turma.semestre)"
						strSql = strSql & " AND (AVE_aluno_ano_letivo.ano_letivo = AVE_aluno_turma.ano_letivo)"
						strSql = strSql & " AND (AVE_aluno_ano_letivo.codigo_sia_unid_ensino = AVE_aluno_turma.codigo_sia_unid_ensino)"
						strSql = strSql & " AND (AVE_aluno_ano_letivo.codigo_ave_aluno = AVE_aluno_turma.codigo_ave_aluno_ano_letivo)"
						strSql = strSql & " WHERE AVE_boletim_escolar.codigo_ape_disciplina = " & intCodDisciplina 
						strSql = strSql & " and AVE_boletim_escolar.codigo_sia_unid_ensino = " & strCodigoSia 
						strSql = strSql & " and (((AVE_boletim_escolar.codigo_ape_serie)=" & intCodSerie & ")"
						strSql = strSql & " and ((AVE_aluno_ano_letivo.ano_letivo)="& strAnoLetivo &")"
						strSql = strSql & " AND ((ave_aluno_turma.codigo_ave_turma)=" & intCodTurma & ")"
						strSql = strSql & " AND ((AVE_aluno_ano_letivo.codigo_ave_aluno)=" &  vetAlunos(intContAluno) & "))"

						if intCodSemestre <> "0" and intCodSemestre <>"" then
							strSql= strSql & " and AVE_boletim_escolar.semestre=" & intCodSemestre
						end if
						'response.write strsql
						'response.End()
						rsaux1.open strSql,cnn

						if not rsaux1.eof then
							while not rsaux1.eof
								if not isnull(rsaux1("qtdFaltas")) then
									select case rsaux1("status")
										case "1" intQtdFaltas_1 = rsaux1("qtdFaltas")
												 intQtdFaltas_Total_1 = intQtdFaltas_Total_1 + intQtdFaltas_1
												 intQtdFaltas_TotalDisciplina = intQtdFaltas_TotalDisciplina + intQtdFaltas_1
										case "3" intQtdFaltas_3 = rsaux1("qtdFaltas")
												 intQtdFaltas_Total_3 = intQtdFaltas_Total_3 + intQtdFaltas_3
												 intQtdFaltas_TotalDisciplina = intQtdFaltas_TotalDisciplina + intQtdFaltas_3
										case "5" intQtdFaltas_5 = rsaux1("qtdFaltas")
												 intQtdFaltas_Total_5 = intQtdFaltas_Total_5 + intQtdFaltas_5
												 intQtdFaltas_TotalDisciplina = intQtdFaltas_TotalDisciplina + intQtdFaltas_5
										case "7" intQtdFaltas_7 = rsaux1("qtdFaltas")
												 intQtdFaltas_Total_7 = intQtdFaltas_Total_7 + intQtdFaltas_7
												 intQtdFaltas_TotalDisciplina = intQtdFaltas_TotalDisciplina + intQtdFaltas_7
									end select
								end if
								if not isnull(rsaux1("nota")) then
									select case rsaux1("status")
										case "1" 
											intNota_1 = formatnumber(rsaux1("nota"),1)
											booResultadoFinal = "S"		
											if not bolOptativa then intNota_Total_1 = intNota_Total_1 + intNota_1
										case "2" 
											intNota_2 = formatnumber(rsaux1("nota"),1)
											if not bolOptativa then intNota_Total_2 = intNota_Total_2 + intNota_2
										case "3" 
											intNota_3 = formatnumber(rsaux1("nota"),1)
											if not bolOptativa then intNota_Total_3 = intNota_Total_3 + intNota_3
											if strEja = "S" then
												booResultadoFinal = "S"
											end if
											
										case "4" 
											intNota_4 = formatnumber(rsaux1("nota"),1)
											if not bolOptativa then intNota_Total_4 = intNota_Total_4 + intNota_4
										case "5" 
											intNota_5 = formatnumber(rsaux1("nota"),1)
											if not bolOptativa then intNota_Total_5 = intNota_Total_5 + intNota_5
										case "6" 
											intNota_6 = formatnumber(rsaux1("nota"),1)
											if not bolOptativa then intNota_Total_6 = intNota_Total_6 + intNota_6
										case "7" 
											intNota_7 = formatnumber(rsaux1("nota"),1)
											if not bolOptativa then intNota_Total_7 = intNota_Total_7 + intNota_7
											booResultadoFinal = "S"												 
										case "8" 
											intNota_8 = formatnumber(rsaux1("nota"),1)
											if not bolOptativa then intNota_Total_8 = intNota_Total_8 + intNota_8
										case "9" 
											intNota_9 = formatnumber(rsaux1("nota"),1)
											if not bolOptativa then intNota_Total_9 = intNota_Total_9 + intNota_9
										case "10" 
											intNota_10 = formatnumber(rsaux1("nota"),1)
											if not bolOptativa then intNota_Total_10 = intNota_Total_10 + intNota_10
										case "11" 
											intNota_11 = formatnumber(rsaux1("nota"),1)
											if not bolOptativa then intNota_Total_11 = intNota_Total_11 + intNota_11
										case "12" 
											intNota_12 = formatnumber(rsaux1("nota"),1)
											if not bolOptativa then intNota_Total_12 = intNota_Total_12 + intNota_12
										case "13" 
											intNota_13 = formatnumber(rsaux1("nota"),1)
											if not bolOptativa then intNota_Total_13 = intNota_Total_13 + intNota_13
										case "14" 
											intNota_14 = formatnumber(rsaux1("nota"),1)
											if not bolOptativa then intNota_Total_14 = intNota_Total_14 + intNota_14
										case "15" 
											intNota_15 = formatnumber(rsaux1("nota"),1)
											if not bolOptativa then intNota_Total_15 = intNota_Total_15 + intNota_15
										case "16" 
											intNota_16 = formatnumber(rsaux1("nota"),1)
											if not bolOptativa then intNota_Total_16 = intNota_Total_16 + intNota_16
										
									end select
								end if
								rsaux1.movenext
							wend
						end if						
						rsaux1.close
						intQtdFaltas_Total = intQtdFaltas_Total + intQtdFaltas_TotalDisciplina
						
						%>
          <tr> 
            <td class="celula" ><left><%=strNomeDisciplina%> </left></td>
            <td class="celula" align="center"><%=intNota_1%></td>
            <td class="celula" align="center"><%=intQtdFaltas_1%></td>
            <td class="celula" align="center"><%=intNota_3%></td>
            <td class="celula" align="center"><%=intQtdFaltas_3%></td>
            <%if intTipoRelatorio=2 then 'campos disponíveis apenas para o colégio militar%>
            <td class="celula" align="center"><%=intNota_15%></td>
            <td class="celula" align="center"><%=intNota_12%></td>
            <%end if%>
            <%if strEja = "N" then%>
            <td class="celula" align="center"><%=intNota_5%></td>
            <td class="celula" align="center"><%=intQtdFaltas_5%></td>
            <td class="celula" align="center"><%=intNota_7%></td>
            <td class="celula" align="center"><%=intQtdFaltas_7%></td>
            <%if intTipoRelatorio=2 then 'campos disponíveis apenas para o colégio militar%>
            <td class="celula" align="center"><%=intNota_16%></td>
            <td class="celula" align="center"><%=intNota_14%></td>
            <%end if%>
            <td class="celula" align="center"><%=intNota_13%></td>
            <%end if%>
            <td class="celula" align="center"><%=intNota_9%></td>
            <td class="celula" align="center"><%=intNota_10%></td>
            <!--<td class="celula" align="right"><%=intNota_10%></td>-->
            <td class="celula" align="center"><%=intNota_11%></td>
            <td class="celula" align="center"><%=intQtdFaltas_TotalDisciplina%></td>
          </tr>
          <%

						rsaux.movenext
					wend
				else
				end if
				rsaux.close

				if intQtdeDisciplinas = 0 then intQtdeDisciplinas=1
%>
          <tr> 
            <td class="celula" align="center">M&eacute;dias/Faltas</td>
			<td class="celula" align="center"><%=formatNumber(intNota_Total_1/intQtdeDisciplinas,1)%></td>
            <td class="celula" align="center"><%=intQtdFaltas_Total_1%></td>
            <td align="center" class="celula"><%=formatNumber(intNota_Total_3/intQtdeDisciplinas,1)%></td>
            <td class="celula" align="center"><%=intQtdFaltas_Total_3%></td>
            <%if intTipoRelatorio=2 then 'campos disponíveis apenas para o colégio militar%>
            <td class="celula" align="center"><%=formatNumber(intNota_Total_15/intQtdeDisciplinas,1)%></td>
            <td class="celula" align="center">-</td>
            <%end if%>
            <%if strEja = "N" then%>
            <td class="celula" align="center"><%=formatNumber(intNota_Total_5/intQtdeDisciplinas,1)%></td>
            <td class="celula" align="center"><%=intQtdFaltas_Total_5%></td>
            <td align="center" class="celula"><%=formatNumber(intNota_Total_7/intQtdeDisciplinas,1)%></td>
            <td class="celula" align="center"><%=intQtdFaltas_Total_7%></td>
            <%if intTipoRelatorio=2 then 'campos disponíveis apenas para o colégio militar%>
            <td class="celula" align="center"><%=formatNumber(intNota_Total_16/intQtdeDisciplinas,1)%></td>
            <td class="celula" align="center">-</td>
            <%end if%>
            <td class="celula" align="center"><%=formatNumber(intNota_Total_13/intQtdeDisciplinas,1)%></td>
            <%end if%>
            <td class="celula" align="center">-</td>
            <td class="celula" align="center">-</td>
            <td align="center" class="celula"><%=formatNumber(intNota_Total_11/intQtdeDisciplinas,1)%></td>
			<td align="center" class="celula"><em></em><%=intQtdFaltas_Total%></td>
          </tr>
        </table>

 <table width="95%" border="0" align="center" cellspacing="0">
 <%if intTipoAluno = "1" then%>
  <tr>
    <td width="36%" align="left" bordercolorlight="#FFFFFF" bordercolordark="#FFFFFF">
		<%
		'recupera as disciplinas que o aluno está em dependência'
		strSql = "SELECT distinct APE_disciplinas.descricao, ave_aluno_dependencia.codigo_ave_aluno_ano_letivo"
		strSql = strSql & " FROM APE_disciplinas INNER JOIN ave_aluno_dependencia"
		strSql = strSql & " ON APE_disciplinas.codigo = ave_aluno_dependencia.codigo_ape_disciplina"
		strSql = strSql & " where ave_aluno_dependencia.codigo_status = 0"
		strSql = strSql & " and ave_aluno_dependencia.codigo_ave_aluno_ano_letivo=" & vetAlunos(intContAluno)
		strSql = strSql & " and ave_aluno_dependencia.ano_letivo=" & strAnoLetivo 
		strSql = strSql & " and ave_aluno_dependencia.codigo_sia_unid_ensino = " & strCodigoSia

		'if intCodSemestre<>"" and intCodSemestre<>"0" then
			strSql = strSql & " and ave_aluno_dependencia.semestre = " & intCodSemestre 
		'end if				
		strRelacaoDisciplinas=""
		rsaux.open strSql, cnn
		if not rsaux.eof then
			while not rsaux.eof
				if strRelacaoDisciplinas<>"" then strRelacaoDisciplinas = strRelacaoDisciplinas & ", "
				strRelacaoDisciplinas = strRelacaoDisciplinas & rsaux("descricao")
				rsaux.movenext
			wend
		end if		
		rsaux.close

	if strRelacaoDisciplinas<>"" then
	%>
	* Aluno(a) em Prog. Parcial em <%=strRelacaoDisciplinas%>.
 	<%
 	end if
 	%>
    &nbsp;&nbsp;&nbsp;</td>
		
 <% 
 end if
 
 if booResultadoFinal = "S" or strSituacaoAluno <>"N" then
 	if intTipoAluno <> "2" then
		
		if strSituacaoAluno <> "Normal" then
			strResultadoFinal = strSituacaoAluno				
		else
			strResultadoFinal = strNomePromocao				
		end if		
		
	else
		intCodigoSituacaoAlunoDep = verificaSituacaoPromocaoAlunoDep(intCodTurma, intCodSerie, vetAlunos(intContAluno), strDisciplinas,intCodSemestre, strEja)
		sql="select descricao from ave_situacao_promocao where codigo = " & intCodigoSituacaoAlunoDep
		rsaux.open sql, cnn
		if rsaux.eof = false then
			strResultadoFinal = rsaux("descricao")
		end if
		rsaux.close
			
	end if
	
	%>
    <td width="64%" align="right" bordercolorlight="#FFFFFF" bordercolordark="#FFFFFF">Resultado Final:&nbsp;<%=strResultadoFinal%>&nbsp;&nbsp;</td>
 <%
 end if
 %>

  </tr>
</table>

 </td>
</tr>
<%
'end if
'rs.close

if intContBoletim = 1 and intContAluno = ubound(vetAlunos) then
	%>
	</table>
	<%
end if

if intContBoletim = 2 then
	intContTotal = intContTotal + intContBoletim
	%>
	</table>
	<%
		if intContTotal <> (ubound(vetAlunos) + 1) then
			response.write "<pre></pre>"
			response.write "<table border='0' width='100%' height='100%' align='center'>"
		end if
		intContBoletim = 0
end if

next
%>
</form>
</html>
<script>
	aguarde.style.display="none";
</script>