<%
response.Expires=0
'Não armazena a página em buffer antes de mostra-la na tela'
response.Buffer = true

Response.AddHeader "Content-Type", "text/html; charset=utf-8"
Response.AddHeader "Pragma", "no-cache"
response.Charset="utf-8"
%>
<html>
<head>
<title><%=session("Titulo")%> - Modulação</title>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8">
<link type="text/css" rel="stylesheet" href="../../Estilo/Estilo_Impressao.css">
<script src="../../js/js_funcoes_gerais.js"></script>
<script src="../../js/js_barra_movel.js"></script>
<style type="text/css">
body,td,th {
	font-family: Tahoma;
}
</style>
</head>
<body>
<!--#include file="../../includes/inc_verificaSession.asp"-->
<!--#include file="../../includes/inc_cnn.asp"-->
<!--#include file="../../includes/inc_formatadata.asp"-->

<br>
<%

	dim intPagina
	nomeDocSalvo				= "relatorioModulacaoPorUnidade"
	intCodEmpresaUsuario 	    = TRIM(Request("cmdEmpresaUsuario"))
	strAno	 					= Trim(Request("txtAno"))
	intSemestre 				= Trim(Request("cmbSemestre"))
	stroptOpcao					= Trim(Request("optOpcao")) 
	strAnoLetivo 				= session("strAnoLetivo")
	strSemestre 				= session("strSemestre")
	strFiltro					= Trim(Request("optFiltro")) 
	
	MsgCabecalho = ""
	if stroptOpcao = "0" then
		MsgCabecalho = "<br>DEFICIT"
	elseif stroptOpcao = "1" then
		MsgCabecalho = "<br>MODULA&Ccedil;&Atilde;0 EXCEDIDA"
	elseif stroptOpcao = "2" then
		MsgCabecalho = "<br>MODULA&Ccedil;&Atilde;0 FECHADA"
	elseif stroptOpcao = "3" then
		MsgCabecalho = "<br>TODAS AS SITUA&Ccedil;&Otilde;ES"
	else
		MsgCabecalho = "<br>TODAS AS SITUA&Ccedil;&Otilde;ES"
	end if
	if strFiltro = "P" then
		MsgCabecalho = MsgCabecalho & " - PERÍODO"
	end if
	if strFiltro = "C" then
		MsgCabecalho = MsgCabecalho & " - CONTRATUAL"
	end if	
	if intSemestre = "3" then
	   strMsgSemestre = "Anual"
	else
	   strMsgSemestre = intSemestre
	end if   
	
	strEmpresaSelecionada = ""
	sql = "select RAZAOSOCIAL"
	sql = sql & " from seg_empresa"
	sql = sql & " where codigo = " &  intCodEmpresaUsuario
	sql = sql & " order by RAZAOSOCIAL "
	rs.open sql, cnn
	if not rs.eof then
		strEmpresaSelecionada = rs("RAZAOSOCIAL")
	end if
	rs.close
	strTituloRelatorio = "MAPA DE MODULAÇÃO - " & strAno & "/" & strMsgSemestre & MsgCabecalho
	strExportarWord 	= paginaatual & "?exportar=w&cmdEmpresaUsuario=" & intCodEmpresaUsuario & "&txtAno=" & strAno & "&cmbSemestre=" & intSemestre & "&optOpcao=" & stroptOpcao & "&optFiltro=" & strFiltro & "&cmbFormaNomeacao=" & intCodformanomeacao	& "&cmbFuncao=" & intCodFuncao 
												 								 
	strExportarExcel 	= paginaatual & "?exportar=e&cmdEmpresaUsuario=" & intCodEmpresaUsuario & "&txtAno=" & strAno & "&cmbSemestre=" & intSemestre & "&optOpcao=" & stroptOpcao & "&optFiltro=" & strFiltro & "&cmbFormaNomeacao=" & intCodformanomeacao	& "&cmbFuncao=" & intCodFuncao 
	
	if request("exportar") = "" then 
		%><!--#include file="../../includes/inc_Botoes_relatorio_word_excel.asp"--><%
	end if
	%>
	<%	if request("exportar") = "" then %>
	<!--#include file="../../includes/inc_aguarde.asp"-->
	<%	end if 
	
	
	sub mostraCabecalho()
	%>
	<!--#include file="../../includes/inc_cabecalhoRelatorio.asp"-->
	<br>
	<table width="98%" border="0" cellspacing="0" cellpadding="0" class="tabela" align="center">
	  <tr>
	    <td height="36" colspan="12" align="center" class="celula"><strong><font size="3"><%=strEmpresaSelecionada%></font></strong></td>
      </tr>
        <tr height="28">
           <td align="center" class="celula" colspan="12" bgcolor="#F0F0F0"><strong><font size="+1">PROFESSORES</font></strong></td>
        </tr>
	  <tr bgcolor="#CCCCCC">
	    <td width="2%" rowspan="2" class="celula"><div align="center"><strong>Ord.</strong></div></td>
	    <td width="23%" rowspan="2" class="celula"><div align="center"><strong>Curso</strong></div></td>
	    <td width="6%" rowspan="2" class="celula"><div align="center"><strong>Per&iacute;odo</strong></div></td>
	    <td width="7%" height="76" rowspan="2" align="center" class="celula"><strong>Turno</strong></td>
	    <td width="21%" height="76" rowspan="2" class="celula"><div align="center"><strong>Fun&ccedil;&atilde;o</strong></div></td>
	    <td width="6%" height="76" rowspan="2" align="center" class="celula"><strong>Qtde. de Turmas</strong></td>
	    <td width="8%" height="76" rowspan="2" align="center" class="celula"><strong>Vagas<br>
        (necess&aacute;ria)</strong></td>
        <td width="7%" height="76" rowspan="2" class="celula"><div align="center"><strong>Aulas<br>(necess&aacute;ria) </strong></div></td>
	    <td colspan="2" class="celula"><div align="center"><strong>Vagas/Aulas Moduladas <br>
	    </strong></div></td>
	    <td width="4%" rowspan="2" class="celula"><div align="center"><strong>Saldo</strong></div></td>
 	    <td width="5%" rowspan="2" class="celula"><div align="center"><strong>Tipo<br> de Saldo</strong></div></td>
     </tr>
	  <tr bgcolor="#CCCCCC">
	    <td width="7%" class="celula"><div align="center"><strong>Contratual</strong></div></td>
        <td width="7%" class="celula"><div align="center"><strong>Per&iacute;odo</strong></div></td>
	  </tr>
	  
	<%
	end Sub
	sub mostraCabecalhoFunc()
	%>
	<!--#include file="../../includes/inc_cabecalhoRelatorio.asp"-->
	<br>
	<table width="98%" border="0" cellspacing="0" cellpadding="0" class="tabela" align="center">
	  <tr>
	    <td height="36" colspan="9" align="center" class="celula"><strong><font size="3"><%=strEmpresaSelecionada%></font></strong></td>
      </tr>
		 <tr height="28">
            <td align="center" class="celula" colspan="9" bgcolor="#F0F0F0"><strong><font size="+1">FUNCIONÁRIOS</font></strong></td>
        </tr>
	  <tr bgcolor="#c0c0c0">
	    <td width="20%" rowspan="2" class="celula"><div align="center"><strong>Curso</strong></div></td>
	    <td width="20%" height="49" rowspan="2" class="celula"><div align="center"><strong>Função</strong></div></td>
	    <td width="7%" height="49" rowspan="2" align="center" class="celula"><strong>Turno</strong></td>
	    <td width="13%" height="49" rowspan="2" align="center" class="celula"><strong>Vagas<br>(Necess&aacute;ria)</strong></td>
	    <td height="24" colspan="2" align="center" class="celula"><strong>Vagas Moduladas</strong></td>
	    <td width="10%" rowspan="2" class="celula"><div align="center"><strong>Saldo</strong></div></td>
      </tr>
	  <tr bgcolor="#c0c0c0">
	    <td width="13%" height="25" class="celula"><div align="center"><strong>Contratual</strong></div></td>
	    <td width="13%" class="celula"><div align="center"><strong>Período</strong></div></td>
      </tr>
	  
	<%
	end Sub
	sub fimTabela()
		response.Write("</table>")
	end Sub

	intPagina = 1
	mostraCabecalho
	cont = 0
	

	sql = "SET NOCOUNT ON "
	sql = sql & " CREATE TABLE #temp (CODIGO int,	RAZAOSOCIAL varchar(200),	Cod_curso	int, Curso	varchar(100), Cod_Periodo	int, Periodo	varchar(100),	Cod_Funcao	int,	Desc_Funcao	varchar(100),	situacao_Disciplinar	varchar(1),	Cod_Turno	int, Desc_Turno		varchar(100), Vagasnecessarias int)"
	sql = sql & " insert #temp select " 
	sql = sql & " EMP.CODIGO, " 
	sql = sql & " EMP.RAZAOSOCIAL, "  
	sql = sql & " C.Cod_curso, "  
	sql = sql & " C.Descricao as Curso, "  
	sql = sql & " P.Cod_Periodo, " 
	sql = sql & " P.Descricao as Periodo, " 
	sql = sql & " FC.Cod_Funcao, "  
	sql = sql & " FC.Desc_Funcao, " 
	sql = sql & " FC.situacao_Disciplinar, "
	sql = sql & " TRH.Cod_Turno, " 
	sql = sql & " TRH.Desc_Turno, " 
	sql = sql & " sum(TMF.Total_Vaga_Funcao) as Vagasnecessarias "	
	sql = sql & " from SRH_TURMA_MODULACAO_FUNCAO TMF " 
	sql = sql & " INNER JOIN SCA_TURMA T ON T.Cod_Turma = TMF.Cod_Turma AND T.Situacao = 'A' " 
	sql = sql & " INNER JOIN SCA_GRADECURRICULAR GC ON GC.Cod_GradeCurricular = T.Cod_GradeCurricular AND GC.Situacao = 'A' "
	sql = sql & " INNER JOIN SCA_PERIODO P ON P.Cod_Periodo = GC.Cod_Periodo " 
	sql = sql & " INNER JOIN SCA_CURSO C ON C.Cod_curso = P.Cod_Curso "
	sql = sql & " INNER JOIN srh_TURNO TRH ON TRH.Cod_Turno = TMF.Cod_TurnoFuncao "
	sql = sql & " INNER JOIN SEG_EMPRESA EMP ON EMP.CODIGO = T.Cod_Empresa "
	sql = sql & " INNER JOIN SRH_FUNCAOCOLABORADOR FC ON FC.Cod_Funcao = TMF.Cod_Funcao " 
	sql = sql & " WHERE FC.Cod_grupo = " & session("codGrupo")
	if intCodEmpresaUsuario <> "0" and intCodEmpresaUsuario <> "" then
		sql = sql & " AND T.COD_EMPRESA = " & intCodEmpresaUsuario
	end if
	sql = sql & " AND T.AnoLetivo = " & strAno
	sql = sql & " AND T.Cod_Semestre = " & intSemestre
	sql = sql & " AND FC.Tipo_Funcao = 'PROFESSOR' "
	sql = sql & " GROUP BY EMP.CODIGO, EMP.RAZAOSOCIAL, C.Cod_curso, C.Descricao, P.Cod_Periodo, P.Descricao, FC.Cod_Funcao, FC.Desc_Funcao, FC.situacao_Disciplinar, TRH.Cod_Turno, TRH.Desc_Turno "
	sql = sql & " UNION "
	
	sql = sql & " SELECT "
	sql = sql & " EMP.CODIGO, " 
	sql = sql & " EMP.RAZAOSOCIAL, "  
	sql = sql & " C.Cod_curso, "  
	sql = sql & " C.Descricao as Curso, "  
	sql = sql & " P.Cod_Periodo, " 
	sql = sql & " P.Descricao as Periodo, " 
	sql = sql & " FC.Cod_Funcao, "  
	sql = sql & " FC.Desc_Funcao, " 
	sql = sql & " FC.situacao_Disciplinar, "
	sql = sql & " GCDT.cod_turnoFuncao , tus.Desc_Turno, " 
	sql = sql & " sum(GCDT.Total_Vaga_Funcao) as Vagasnecessarias  "	

	sql = sql & "  FROM SCA_GRADECURRICULARDISCIPLINA GCD "
	sql = sql & "  INNER JOIN SCA_GRADECURRICULAR GC ON GC.Cod_GradeCurricular = GCD.Cod_GradeCurricular AND GC.Situacao = 'A' "
	sql = sql & "  INNER JOIN SCA_PERIODO P ON P.Cod_Periodo = GC.Cod_Periodo INNER JOIN SCA_CURSO C ON C.Cod_curso = P.Cod_Curso "
	sql = sql & "  INNER JOIN SCA_GRADECURRICULARDISCIPLINA_TURNO GCDT ON GCDT.Cod_GradeCurricularDisciplina = GCD.Cod_GradeCurricularDisciplina "
	sql = sql & "  INNER JOIN SRH_FUNCAOCOLABORADOR FC ON FC.Cod_Funcao = GCDT.Cod_Funcao "
	sql = sql & "  INNER JOIN SCA_TURMA T ON GC.Cod_GradeCurricular = T.Cod_GradeCurricular AND T.Situacao = 'A' and GCDT.cod_turno = t.cod_turno "
	sql = sql & "  inner join SCA_TURNO tus on tus.cod_turno = GCDT.cod_turnoFuncao"
	sql = sql & "  INNER JOIN SEG_EMPRESA EMP ON EMP.CODIGO = T.Cod_Empresa "

	sql = sql & " WHERE ISNULL(GCDT.COD_FUNCAO,'0')<>'0' "
	sql = sql & " AND FC.Cod_grupo = " & session("codGrupo")
	if intCodEmpresaUsuario <> "0" and intCodEmpresaUsuario <> "" then
		sql = sql & " AND T.COD_EMPRESA = " & intCodEmpresaUsuario
	end if
	sql = sql & " AND T.AnoLetivo = " & strAno
	sql = sql & " AND T.Cod_Semestre = " & intSemestre
	sql = sql & " AND FC.Tipo_Funcao = 'PROFESSOR' " 
	sql = sql & " GROUP BY EMP.CODIGO, EMP.RAZAOSOCIAL, C.Cod_curso, C.Descricao, P.Cod_Periodo, P.Descricao, FC.Cod_Funcao, FC.Desc_Funcao, FC.situacao_Disciplinar, GCDT.cod_turnoFuncao, tus.Desc_Turno"
	'response.write sql
	'add dia 07/03/2019 para mostrar a substituição (nome nominal)
	sql = sql & " UNION"
	sql = sql & " SELECT DISTINCT EMP.CODIGO, EMP.RAZAOSOCIAL, C.Cod_curso, C.Descricao as Curso, P.Cod_Periodo, P.Descricao as Periodo, FC.Cod_Funcao, FC.Desc_Funcao, FC.situacao_Disciplinar, TRH.Cod_Turno, TRH.Desc_Turno, 0 as Vagasnecessarias "
	sql = sql & " FROM SRH_MODULACAO_DISCIPLINAR_DOCENTE MD"
	sql = sql & " INNER JOIN SEG_EMPRESA EMP ON EMP.CODIGO = MD.Cod_Empresa "
	sql = sql & " INNER JOIN SRH_FUNCAOCOLABORADOR FC ON FC.Cod_Funcao = MD.Cod_Funcao "
	sql = sql & " INNER JOIN SCA_PERIODO P ON P.Cod_Periodo = MD.Cod_Periodo "
	sql = sql & " INNER JOIN SCA_CURSO C ON C.Cod_curso = P.Cod_Curso "
	sql = sql & " INNER JOIN SRH_TURNO TRH ON TRH.Cod_Turno = MD.Cod_Turno "
	sql = sql & " WHERE isnull(MD.Cod_ColaboradorSubstituido,'0') > 0"
	sql = sql & " AND EMP.Cod_grupo = " & session("codGrupo")
	sql = sql & " AND EMP.CODIGO = " & intCodEmpresaUsuario
	sql = sql & " AND MD.Ano_Letivo = " & strAno
	sql = sql & " AND MD.Semestre = " & intSemestre
	sql = sql & " AND MD.tipoModulacao = 'PROFESSOR' "
	
	sql = sql & " 	select CODIGO	,RAZAOSOCIAL	,Cod_curso	,Curso	,Cod_Periodo	,Periodo	,Cod_Funcao	,Desc_Funcao	,situacao_Disciplinar	,Cod_Turno	,Desc_Turno	,sum(Vagasnecessarias) as Vagasnecessarias"
	sql = sql & " from #temp "
	sql = sql & " group by CODIGO	,RAZAOSOCIAL	,Cod_curso	,Curso	,Cod_Periodo	,Periodo	,Cod_Funcao	,Desc_Funcao	,situacao_Disciplinar	,Cod_Turno	,Desc_Turno	"
	sql = sql & " ORDER BY CODIGO, RAZAOSOCIAL, Curso, Periodo, Desc_Funcao, Desc_Turno "
	
	if session("usuarioWeb") = "SERGIO" THEN
			RESPONSE.WRITE SQL & "<hr>"
		end if
	
	rs.open sql, cnn
	if not rs.eof then 
		While not rs.eof 
			
			
			' Quantidade de Turmas
			qtdeTurma = 0
			'disciplinar
			IF RS("situacao_Disciplinar") = "D" THEN
				SQL = "select isnull(COUNT( distinct COD_TURMA),'0') qtdeTurma"
				sql = sql & " from sca_turma t1"
				sql = sql & " INNER JOIN SCA_GRADECURRICULAR GC1 ON GC1.Cod_GradeCurricular = T1.Cod_GradeCurricular and GC1.Situacao = 'A' "
				sql = sql & " INNER JOIN SCA_GRADECURRICULARDISCIPLINA GCD ON GCD.Cod_GradeCurricular = GC1.Cod_GradeCurricular "
				sql = sql & " INNER JOIN SCA_GRADECURRICULARDISCIPLINA_TURNO GCDT ON GCDT.Cod_GradeCurricularDisciplina = GCD.Cod_GradeCurricularDisciplina "
				sql = sql & " and GCDT.cod_turno = t1.cod_turno "
				sql = sql & " INNER JOIN SCA_PERIODO P1 ON P1.Cod_Periodo = GC1.Cod_Periodo "
				sql = sql & " INNER JOIN SCA_CURSO C1 ON C1.Cod_curso = P1.Cod_Curso "
				sql = sql & " INNER JOIN SRH_FUNCAOCOLABORADOR FC ON FC.Cod_Funcao = GCDT.Cod_Funcao "
				sql = sql & " where T1.AnoLetivo = " & strAno
				sql = sql & " AND T1.Cod_Semestre = " & intSemestre
				sql = sql & " AND T1.situacao='A' "
				sql = sql & " AND T1.Situacao_modulacao='A' "
				if intCodEmpresaUsuario <> "0" and intCodEmpresaUsuario <> "" then
					sql = sql & " AND T1.COD_EMPRESA = " & intCodEmpresaUsuario
				end if
				sql = sql & " AND C1.Cod_curso = " & rs("Cod_curso")
				sql = sql & " AND P1.Cod_Periodo = " & rs("Cod_Periodo")
				sql = sql & " AND GCDT.Cod_TurnoFuncao  = " & rs("Cod_Turno")
				sql = sql & " AND GCDT.Cod_Funcao  = " & rs("Cod_Funcao")
				'if rs("Cod_Periodo")=3 then
				'response.write sql & "<hr>"
				'end if
				rsaux.open sql, cnn
				if not rsaux.eof then 
					qtdeTurma = rsaux("qtdeTurma")
				end if
				rsaux.close
			ELSE
			'interdisciplinar
				sql = " select isnull(COUNT( distinct t1.COD_TURMA),'0') qtdeTurma "
				sql = sql & " from sca_turma t1 "
				sql = sql & " INNER JOIN SRH_TURMA_MODULACAO_FUNCAO mf on mf.cod_turma = t1.cod_turma "
				sql = sql & " INNER JOIN SCA_GRADECURRICULARDISCIPLINA GCD ON GCD.Cod_GradeCurricular = t1.Cod_GradeCurricular "
				sql = sql & " INNER JOIN SCA_PERIODO P1 ON P1.Cod_Periodo = t1.Cod_Periodo "
				sql = sql & " INNER JOIN SCA_CURSO C1 ON C1.Cod_curso = P1.Cod_Curso "
				sql = sql & " INNER JOIN SRH_TURNO TRH ON TRH.Cod_Turno = mf.cod_TurnoFuncao"
				sql = sql & " where T1.AnoLetivo = " & strAno
				sql = sql & " AND T1.Cod_Semestre = " & intSemestre
				sql = sql & " AND T1.situacao='A' "
				if intCodEmpresaUsuario <> "0" and intCodEmpresaUsuario <> "" then
					sql = sql & " AND T1.COD_EMPRESA = " & intCodEmpresaUsuario
				end if
				sql = sql & " AND C1.Cod_curso = " & rs("Cod_curso")
				sql = sql & " AND P1.Cod_Periodo = " & rs("Cod_Periodo")
				sql = sql & " AND TRH.Cod_Turno  = " & rs("Cod_Turno")
				'response.write sql & "<hr><hr>"
				rsaux.open sql, cnn
				if not rsaux.eof then 
					qtdeTurma = rsaux("qtdeTurma")
				end if
				rsaux.close
			END IF
			'
			' Aulas árias
			intTotalAulasTurma = 0
			sql = " select isnull(SUM(TMF.Total_Vaga_Funcao),'0') as TotalAulasTurma " 
			sql = sql & " from SRH_TURMA_MODULACAO_FUNCAO TMF "
			sql = sql & " INNER JOIN SCA_TURMA T ON T.Cod_Turma = TMF.Cod_Turma AND T.Situacao = 'A' "
			sql = sql & " INNER JOIN SCA_GRADECURRICULAR GC ON GC.Cod_GradeCurricular = T.Cod_GradeCurricular AND GC.Situacao = 'A' "
			sql = sql & " INNER JOIN SCA_PERIODO P ON P.Cod_Periodo = GC.Cod_Periodo "
			sql = sql & " INNER JOIN SCA_CURSO C ON C.Cod_curso = P.Cod_Curso "
			sql = sql & " INNER JOIN SCA_TURNO TU ON TU.Cod_Turno = T.Cod_Turno" 
			sql = sql & " INNER JOIN SEG_EMPRESA EMP ON EMP.CODIGO = T.Cod_Empresa "
			sql = sql & " INNER JOIN SRH_FUNCAOCOLABORADOR FC ON FC.Cod_Funcao = TMF.Cod_Funcao "
			sql = sql & " where T.AnoLetivo = " & strAno
			sql = sql & " AND T.Cod_Semestre = " & intSemestre
			if intCodEmpresaUsuario <> "0" and intCodEmpresaUsuario <> "" then
				sql = sql & " AND T.COD_EMPRESA = " & intCodEmpresaUsuario
			end if
			sql = sql & " AND C.Cod_curso = " & rs("Cod_curso")
			sql = sql & " AND P.Cod_Periodo = " & rs("Cod_Periodo")
			sql = sql & " AND TMF.Cod_TurnoFuncao = " & rs("Cod_Turno")
			sql = sql & " AND TMF.Cod_Funcao = " & rs("Cod_Funcao") 
		'	response.end
			rsaux.open sql, cnn
			if not rsaux.eof then 
				intTotalAulasTurma = rsaux("TotalAulasTurma")
			end if
			rsaux.close
			
			
			VagasModuladasContratual = "0"
			sql = " select isnull(SUM(Total_Aulas),'0') as Total_Modulado "
			sql = sql & " from SRH_MODULACAO_DISCIPLINAR_DOCENTE MD "
			sql = sql & " WHERE MD.Cod_Empresa = " & intCodEmpresaUsuario
			sql = sql & " and MD.ano_letivo = " & strAno
			sql = sql & " and MD.semestre = " & intSemestre
			sql = sql & " and MD.status = 'A'"
			sql = sql & " and MD.Tipo_Contratacao = 'C'"
			sql = sql & " AND MD.Cod_Funcao = " & rs("Cod_Funcao")  
			sql = sql & " AND MD.Cod_Turno  = " & rs("Cod_Turno")
			sql = sql & " AND MD.Cod_curso = " & rs("Cod_curso") 
			sql = sql & " AND MD.Cod_Periodo  = " & rs("Cod_Periodo") 
			sql = sql & " and isnull(MD.Cod_ColaboradorSubstituido,'0') = 0 "
			
			rsaux.open sql, cnn
			if rsaux.eof = false then
				VagasModuladasContratual = rsaux("Total_Modulado")
				'if VagasModuladasContratual=12 then 
				'	response.write sql
				'end if
			end if
			rsaux.close

			VagasModuladasPeriodo = 0
			sql = " select isnull(SUM(Total_Aulas),'0') as Total_Modulado "
			sql = sql & " from SRH_MODULACAO_DISCIPLINAR_DOCENTE MD  "
			sql = sql & " WHERE MD.Cod_Empresa = " & intCodEmpresaUsuario
			sql = sql & " and MD.ano_letivo = " & strAno
			sql = sql & " and MD.semestre = " & intSemestre
			sql = sql & " and MD.status = 'A'"
			sql = sql & " and MD.Tipo_Contratacao = 'A'"
			sql = sql & " AND MD.Cod_Funcao = " & rs("Cod_Funcao")  
			sql = sql & " AND MD.Cod_Turno  = " & rs("Cod_Turno")
			sql = sql & " AND MD.Cod_curso = " & rs("Cod_curso") 
			sql = sql & " AND MD.Cod_Periodo  = " & rs("Cod_Periodo") 
			sql = sql & " and isnull(MD.Cod_ColaboradorSubstituido,'0') = 0 "
			rsaux.open sql, cnn
			if rsaux.eof = false then
				VagasModuladasPeriodo = rsaux("Total_Modulado")
			end if
			rsaux.close
			
			VagasModuladas = VagasModuladasContratual + VagasModuladasPeriodo
			
			if intTotalAulasTurma = "0" then
				Vagasnecessarias = rs("Vagasnecessarias")
				saldo = rs("Vagasnecessarias") - VagasModuladas
				strTipoSaldo = "Aula(s)"
			else
				Vagasnecessarias = 0
				saldo = intTotalAulasTurma - VagasModuladas
				strTipoSaldo = "Vaga(s)"
			end if

			msgMostraSaldo = ""
			if stroptOpcao = "0" then
				if saldo > 0 then
					strMostraSaldo = "S"
					msgMostraSaldo = "N&atilde;o existe DEFICIT nesta classifica&ccedil;&atilde;o"
				else
					strMostraSaldo = "N"
				end if
			elseif stroptOpcao = "1" then
				if saldo < 0 then
					strMostraSaldo = "S"
					msgMostraSaldo = "N&atilde;o existe EXCESSO DE MODULA&Ccedil;&Atilde;0 nesta classifica&ccedil;&atilde;o"
				else
					strMostraSaldo = "N"
				end if
			elseif stroptOpcao = "2" then
				if saldo = 0 then
					strMostraSaldo = "S"
					msgMostraSaldo = "N&atilde;o existe MODULA&Ccedil;&Atilde;0 FECHADA nesta classifica&ccedil;&atilde;o"
				else
					strMostraSaldo = "N"
				end if
			elseif stroptOpcao = "3" then
				strMostraSaldo = "S"
			else
				strMostraSaldo = "S"
			end if
			
			strMostraRegistro = "S"
			if strFiltro<>"T" then
				strMostraRegistro = "N"
				if  strFiltro="P" and VagasModuladasPeriodo > 0 then 
					strMostraRegistro = "S"
				end if
				if  strFiltro="C" and saldo>0 then
					strMostraRegistro = "S"
				end if
			end if
				
			if strMostraSaldo = "S" or cInt(VagasModuladasPeriodo)>0 then
				if strMostraRegistro = "S" then
				cont = cont + 1
				%>
				  <tr  height="28">
				    <td class="celula"><div align="center"><%=cont%></div></td>
					<td align="left" class="celula"><%=rs("curso")%>&nbsp;</td>
					<td align="center" class="celula" ><%=rs("periodo")%>&nbsp;</td>
					<td align="left" class="celula"><%=rs("Desc_Turno")%>&nbsp;</td>
					<td align="left" class="celula"><%=rs("Desc_Funcao")%>&nbsp;</td>
					<td  class="celula" align="center"><%=qtdeTurma%>&nbsp;</td>
					<td  class="celula" align="center"><%=intTotalAulasTurma%>&nbsp;</td>
					<td  class="celula" align="center"><%=Vagasnecessarias%>&nbsp;</td>
					<td align="center"  class="celula"><%=VagasModuladasContratual%>&nbsp;</td>
					<td align="center"  class="celula"><strong><%=VagasModuladasPeriodo%></strong>&nbsp;</td>
					<td  class="celula" align="center"><%=saldo%>&nbsp;</td>
					<td  class="celula" align="center"><%=strTipoSaldo%>&nbsp;</td>
				</tr>
				<%
				end if
                strMostraModulados = ""
				
                sql = " select c.codigo, c.nome, c.codFuncional, MD.tipo_contratacao, MD.Cod_ColaboradorSubstituido AS Cod_Substituicao "
				sql = sql & " from SRH_MODULACAO_DISCIPLINAR_DOCENTE MD "
                sql = sql & " INNER JOIN SRH_COLABORADOR C ON C.codigo = MD.Cod_Colaborador "
                sql = sql & " WHERE MD.Ano_Letivo = " & strAno
                sql = sql & " AND MD.Semestre = " & intSemestre
                sql = sql & " AND MD.Cod_empresa = " & intCodEmpresaUsuario
                sql = sql & " AND MD.Cod_Curso = " & rs("Cod_curso") 
                sql = sql & " AND MD.Cod_periodo  = " & rs("Cod_Periodo") 
                sql = sql & " AND MD.Cod_Turno  = " & rs("Cod_Turno")
                'sql = sql & " AND MD.Cod_Funcao = " & rs("Cod_Funcao")
				
				sql = sql & " AND " & rs("Cod_Funcao") & " = "
				sql = sql & " (CASE "
				sql = sql & " 	when c.codFuncao_readaptacao is null then MD.Cod_Funcao"
				sql = sql & " 	else c.codFuncao_readaptacao"
				sql = sql & " 	end ) "
				
                sql = sql & " AND MD.Status = 'A' "
				
			    rsaux.open sql, cnn
                if rsaux.eof = false then
                    While not rsaux.eof 
					    
						' Atualiza o inativar por data
						if trim(rsaux("codigo")) <> "" then
					  		
							sql = "select dd.Codigo, dd.periodo_inicial, dd.periodo_final"
							sql = sql & " from SRH_MODULACAO_DISCIPLINAR_DOCENTE dd "
							sql = sql & " inner join SEG_EMPRESA e on e.CODIGO = dd.Cod_empresa "
							sql = sql & " left join SRH_FUNCAOCOLABORADOR f on f.cod_funcao = dd.cod_funcao"
							sql = sql & " left join SCA_disciplina d on d.cod_disciplina = dd.cod_disciplina"
							sql = sql & " left join SRH_TURNO t on t.cod_turno = dd.cod_turno"
							sql = sql & " left join SCA_periodo p on p.cod_periodo = dd.cod_periodo"
							sql = sql & " where dd.Cod_Colaborador = " & trim(rsaux("codigo"))
							sql = sql & " and (dd.ano_letivo = " & strAnoLetivo
							sql = sql & " or dd.ano_letivo = " & strAnoLetivo - 1 & ")"
							sql = sql & " order by dd.ano_letivo desc ,dd.tipo_contratacao desc, dd.codigo"
							rsAux1.open sql, cnn
							if rsAux1.eof = false then
				 
								while not rsaux1.eof
		
									if not isnull(rsaux1("periodo_final")) then
										strPeriodoFinalComparar = replace(formataDataCalc(rsaux1("periodo_final")),"/","")
										strDataAtualComparar 	= replace(formataDataCalc(date),"/","")
									
										if cCur(strPeriodoFinalComparar)<cCur(strDataAtualComparar) then 
											sql = "update SRH_MODULACAO_DISCIPLINAR_DOCENTE set status = 'I' where codigo = " & rsaux1("codigo") 
											cnn.execute sql
										end if
									end if
		
								 rsAux1.movenext
								 wend
							
							end if
							rsAux1.close	
					   end if	       
					  						
						IF not ISNULL(rsaux("Cod_Substituicao")) THEN substituicao = " (sub)"
                        strMostraModulados = strMostraModulados & rsaux("nome") & " - " & rsaux("codFuncional") & substituicao & "<BR>"
						substituicao = ""

                        rsaux.movenext
                    wend
                    %>
                    <tr  height="28" bgcolor="#F0F0F0">
                        <td colspan="4" class="celula"><div align="right">Modulado(s)....</div></td>
                        <td colspan="8" align="left" class="celula"><%=strMostraModulados%></td>
                    </tr>
                    <%
                end if
                rsaux.close
				
			end if
			
			'quantidade de registros da página
			if intQtdeRegistroPorPagina = 30 then
				 intPagina = intPagina + 1
				 intQtdeRegistroPorPagina = 1
				 fimTabela
				%>
				<pre></pre>				
				<%			
				mostraCabecalho
			end if
			
		rs.movenext
		wend
		if cont = "0" and stroptOpcao = "0" OR stroptOpcao = "1" then
			%>
			  <tr>
				<td height="18" colspan="12" class="celula" align="center"><font color="#993300"><%=msgMostraSaldo%></font></td>
			  </tr>
			<%
		end if
	else
		%>
		  <tr>
			<td height="18" colspan="12" class="celula" align="center"><font color="#993300"><%=session("strMensagemRelatorioNaoEncontrado")%></font></td>
		  </tr>
		<%
	end if
	rs.close
%>
</table>
<%

	intPagina = intPagina + 1
	mostraCabecalhoFunc
	cont = 0
	
	sql = " select d.codigo as codigo_SRH_DIRETRIZES, replace(c.Descricao,' ','_') as curso, d.Cod_Turno, t.Desc_Turno as turno, f.Modular,"
	sql = sql & " f.Cod_Funcao, f.Desc_Funcao as funcao, 0 as Vagasnecessarias, ISNULL(VagasOferecidas,'0') as VagasLiberadasDiretriz, "
	sql = sql & " isnull((select count(*) from SRH_COLABORADOR where codLotacao=d.cod_empresa and situacao='A' and codFuncao=d.Codfuncao and CodTurno=d.Cod_Turno),0) as modulados "
	sql = sql & " from SRH_DIRETRIZES d "
	sql = sql & " inner join sca_curso c on c.Cod_curso = d.Cod_Curso "
	sql = sql & " inner join srh_turno t on t.Cod_Turno = d.Cod_Turno and t.Cod_Grupo = " & Session("CodGrupo")
	sql = sql & " inner join SRH_FUNCAOCOLABORADOR f on f.Cod_Funcao = d.Codfuncao "
	sql = sql & " where d.cod_empresa = " & intCodEmpresaUsuario
	sql = sql & " and d.ano_letivo = " & strAno
	sql = sql & " and d.semestre = " & intSemestre
	sql = sql & " and f.Tipo_Funcao = 'FUNCIONARIO' "
	sql = sql & " order by funcao "
	
	rs.open sql, cnn
	if not rs.eof then 
		While not rs.eof 
			'''' Total de Vagas Modulada
			
			Modular = rs("Modular")
			if Modular = "S" then
				strTotalModuladoPeriodo = 0
				strTotalModuladoContrato = 0
				sql = " SELECT tipo_contratacao, ISNULL(SUM(M2.Total_Aulas),'0') as Total_Modulado "   
				sql = sql & " FROM SRH_MODULACAO_DISCIPLINAR_DOCENTE M2 "  
				sql = sql & " INNER JOIN SEG_EMPRESA E2 ON E2.CODIGO = M2.Cod_Empresa  " 
				sql = sql & " INNER JOIN SEG_GRUPO GR2 ON GR2.CODIGO = E2.COD_GRUPO " 
				sql = sql & " WHERE GR2.Codigo = " & Session("CodGrupo")
				sql = sql & " AND M2.Ano_Letivo = " & strAno
				sql = sql & " AND M2.Semestre = " & intSemestre
				sql = sql & " AND M2.tipoModulacao = 'FUNCIONARIO' "
				sql = sql & " AND M2.Cod_Empresa = " & intCodEmpresaUsuario 
				sql = sql & " AND M2.Cod_Funcao = " & trim(rs("Cod_Funcao"))
				sql = sql & " AND M2.Cod_Turno  = " & trim(rs("Cod_Turno"))
				sql = sql & " AND M2.Status = 'A' group by tipo_contratacao"
				rsaux.open sql, cnn
				if rsaux.eof = false then
					while not rsaux.eof 
						if rsaux("tipo_contratacao") = "C" then
							strTotalModuladoContrato = rsaux("Total_Modulado")
						elseif rsaux("tipo_contratacao") = "A" then
							strTotalModuladoPeriodo = rsaux("Total_Modulado")
						end if
						rsaux.movenext
					wend
				end if
				rsaux.close
			else
				strTotalModuladoPeriodo = 0
				strTotalModuladoContrato = rs("modulados")
			end if
			
			saldo = rs("vagasliberadasdiretriz") - strTotalModuladoContrato - strTotalModuladoPeriodo
		
			msgMostraSaldo = ""
			if stroptOpcao = "0" then
				if saldo > 0 then
					strMostraSaldo = "S"
					msgMostraSaldo = "N&atilde;o existe DEFICIT nesta classifica&ccedil;&atilde;o"
				elseif saldo = 0 and  strTotalModuladoPeriodo > 0 then
					strMostraSaldo = "S"
				else
					strMostraSaldo = "N"
				end if
			elseif stroptOpcao = "1" then
				if saldo < 0 then
					strMostraSaldo = "S"
					msgMostraSaldo = "N&atilde;o existe EXCESSO DE MODULA&Ccedil;&Atilde;0 nesta classifica&ccedil;&atilde;o"
				else
					strMostraSaldo = "N"
				end if
			elseif stroptOpcao = "2" then
				if saldo = 0 then
					strMostraSaldo = "S"
					msgMostraSaldo = "N&atilde;o existe MODULA&Ccedil;&Atilde;0 FECHADA nesta classifica&ccedil;&atilde;o"
				else
					strMostraSaldo = "N"
				end if
			elseif stroptOpcao = "3" then
				strMostraSaldo = "S"
			else
				strMostraSaldo = "S"
			end if
'response.write "strMostraSaldo:" & strMostraSaldo
			if strMostraSaldo = "S" then	
				cont = cont + 1
				
				%>
				  <tr height="28">
					<td align="left" class="celula"><%=replace(rs("curso"),"_"," ")%>&nbsp;</td>
					<td align="left" class="celula"><%=rs("funcao")%>&nbsp;</td>
					<td align="left" class="celula"><%=rs("turno")%>&nbsp;</td>
					<td  class="celula" align="center"><%=rs("vagasliberadasdiretriz")%>&nbsp;</td>
					<td  class="celula" align="center"><%=strTotalModuladoContrato%>&nbsp;</td>
					<td  class="celula" align="center"><%=strTotalModuladoPeriodo%>&nbsp;</td>
					<td  class="celula" align="center"><%=saldo%>&nbsp;</td>
				</tr>
 				<%
                strMostraModulados = ""
				if Modular = "S" then
					sql = " select distinct c.codFuncao_readaptacao, c.codigo, c.nome, c.codFuncional, MD.tipo_contratacao, md.Cod_ColaboradorSubstituido AS Cod_Substituicao, r.cod_colaborador as Readaptacao "
					sql = sql & " from SRH_MODULACAO_DISCIPLINAR_DOCENTE MD "
					sql = sql & " INNER JOIN SRH_TURNO TRH ON TRH.Cod_Turno = MD.Cod_Turno "
					sql = sql & " INNER JOIN SRH_COLABORADOR C ON C.codigo = MD.Cod_Colaborador "
					sql = sql & " left join SRH_COLABORADOR_READAPTACAO r on r.cod_colaborador = c.codigo and r.cod_Funcao = c.codFuncao_readaptacao and r.situacao = 'A'"
					sql = sql & " WHERE MD.Ano_Letivo = " & strAno
					sql = sql & " AND MD.Semestre = " & intSemestre
					sql = sql & " AND MD.Cod_empresa = " & intCodEmpresaUsuario
					sql = sql & " AND TRH.Cod_Turno  = " & rs("Cod_Turno")
					sql = sql & " AND " & rs("Cod_Funcao") & " = "
					sql = sql & " (CASE "
					sql = sql & " 	when c.codFuncao_readaptacao is null then MD.Cod_Funcao"
					sql = sql & " 	else c.codFuncao_readaptacao"
					sql = sql & " 	end ) "
					sql = sql & " 	AND MD.Status =  (CASE when c.codFuncao_readaptacao is null then MD.Status else r.situacao end ) "
					sql = sql & " AND MD.Status = 'A' "
				else
					sql = " select distinct c.codFuncao_readaptacao, c.codigo, c.nome, codFuncional, '' as tipo_contratacao, null as Cod_Substituicao, r.cod_colaborador as Readaptacao "
					sql = sql & " from SRH_COLABORADOR c"
					sql = sql & " left join SRH_COLABORADOR_READAPTACAO r on r.cod_colaborador = c.codigo and r.cod_Funcao = c.codFuncao_readaptacao and r.situacao = 'A'"
					sql = sql & " WHERE c.codLotacao = " &  intCodEmpresaUsuario
					sql = sql & " AND c.CodTurno = " & rs("Cod_Turno")
					sql = sql & " AND " & rs("Cod_Funcao") & " = "
					sql = sql & " (CASE "
					sql = sql & " 	when codFuncao_readaptacao is null then codFuncao"
					sql = sql & " 	else codFuncao_readaptacao"
					sql = sql & " 	end ) "
					sql = sql & " 	AND c.situacao =  (CASE when codFuncao_readaptacao is null then c.Situacao else r.situacao end ) "
					sql = sql & " AND c.situacao = 'A' "				
				end if
				'if rs("funcao") = "MERENDEIRO (A) " then 
					'response.write sql & "<hr>"
				'end if
				if ucase(session("usuarioweb"))= "SERGIO" and rs("funcao") = "MERENDEIRO (A)" THEN
					'response.write sql & "<br>"
				END IF
			    rsaux.open sql, cnn
				substituicao = ""
                if rsaux.eof = false then
                    While not rsaux.eof 
						IF not ISNULL(rsaux("Cod_Substituicao")) THEN substituicao = " (sub)"
						IF not ISNULL(rsaux("Readaptacao")) THEN readap = " (readaptação)"
						
                        strMostraModulados = strMostraModulados & rsaux("nome") & " - " & rsaux("codFuncional") & substituicao & readap &"<BR>"
						substituicao = ""
						readap = ""
                        rsaux.movenext
                    wend
                    %>
                    <tr  height="28" bgcolor="#F0F0F0">
                        <td colspan="4" class="celula"><div align="right">Modulado(s)....</div></td>
                        <td colspan="8" align="left" class="celula"><%=strMostraModulados%></td>
                    </tr>
                    <%
					substituicao = ""
                end if
                rsaux.close
				
				
			'quantidade de registros da página
			if intQtdeRegistroPorPagina = 30 then
				 intPagina = intPagina + 1
				 intQtdeRegistroPorPagina = 1
				 fimTabela
				%>
				<pre></pre>				
				<%			
				mostraCabecalho
			end if	
		 end if
			rs.movenext
		wend
		
	else
		%>
		  <tr>
			<td height="18" colspan="11" align="center" class="celula"><font color="#993300"><%=session("strMensagemRelatorioNaoEncontrado")%></font></td>
	  </tr>
		<%
	end if
	rs.close
%>
</table>


<%
	if request("exportar") = "w" then 
		Response.ContentType = "application/vnd.ms-word"
        Response.AddHeader "content-disposition","attachment;filename="&nomeDocSalvo&".doc"
	elseif request("exportar") = "e" then 
		Response.ContentType = "application/vnd.ms-excel"
        Response.AddHeader "content-disposition","attachment;filename="&nomeDocSalvo&".xls"
	end if
%>




<br>
<%	if request("exportar") = "" then %>
<script>
	aguarde.style.display="none";
</script>
<%	end if %>
</body>
</html>
