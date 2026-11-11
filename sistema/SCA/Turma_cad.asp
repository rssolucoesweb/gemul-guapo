<!--
	::	DESENVOLVIDO POR "RS SOLUÇÕES WEB - www.rssolucoesweb.com.br" 
	::	Data de Criação...: 13/02/2008
	::	Desenvolvedores...: Sergio Borges - Sergiob76@gmail.com
	::	Objetivo Pagina...: Cadastro de Turma 
-->
<html>
<head>
<title><%=session("Titulo")%></title>
<link href="../../estilo/css.css" rel="stylesheet" type="text/css">
</head>
<body  leftmargin="0" topmargin="0" marginwidth="0" marginheight="0">
<script src="../../js/js_funcoes_gerais.js"></script>
<!--#include file="../../includes/inc_verificaSession.asp"-->
<!--#include file="../../includes/inc_cnn.asp"-->
<!--#include file="../../includes/inc_validaPermissaoPagina.asp"-->
<!--#include file=topo.asp-->
<!--#include file="../../includes/inc_formatadata.asp"-->
<script>
	function resultadoConsulta(intCodigo){
		
		var frm = document.getElementById("frm");
		
		frm.txtCodigo.value=intCodigo;
		frm.action = "Turma_cad.asp?Consulta=Turma";
		frm.submit();
	}

	function salvar(acao){
		
		var frm = document.getElementById("frm");
			
		if (frm.cmbSemestre.value == "0") {
			alert("O Semestre deve ser informada !");
			frm.cmbSemestre.focus();
			return false;
		}
		
		if (frm.cmbTurno.value == "0") {
			alert("O Turno deve ser informado !");
			frm.cmbTurno.focus();
			return false;
		}
		
		if (frm.cmbPeriodo.value == "0") {
			alert("O Período deve ser informado !");
			frm.cmbPeriodo.focus();
			return false;
		}

		if (frm.txtNomeTurma.value == "") {
			alert("O Nome da Turma deve ser informada !");
			frm.txtNomeTurma.focus();
			return false;
		}
		
		if (frm.txtSala.value == "") {
			alert("A Sala deve ser informada !");
			frm.txtSala.focus();
			return false;
		}
		
		if (frm.txtAno.value == "") {
			alert("O Ano criação deve ser informado !");
			frm.txtAno.focus();
			return false;
		}
		if (frm.cmbSemestreCriacao.value == "") {
			alert("O semestre criação deve ser informado !");
			frm.cmbSemestreCriacao.focus();
			return false;
		}
		if (frm.txtCapacidade.value == "") {
			alert("O Capacidade deve ser informada !");
			frm.txtCapacidade.focus();
			return false;
		}
				
		if (frm.txtAnoLetivo.value == "") {
			alert("O Ano Letivo deve ser informado !");
			frm.txtAnoLetivo.focus();
			return false;
		}
		if (frm.txtCapacidade.value < frm.txtVagasMatriculas.value) {
			alert("A Vagas não podem superar a Capacidade da turma !");
			frm.txtCapacidade.focus();
			return false;
		}

		frm.action="Turma_cod.asp?acao=" + acao;
		frm.submit();
		return true;
 	}

</script>
<%
	strPaginaTitulo                  = "Turma_cad.asp"
	strExecutarSubmitCurso	         = "S"
	strExecutarSubmitPeriodo         = "S"
	strExecutarSubmitSemestreCriacao = "S"
	strExecutarSubmitSemestreTodos   = "S"
	strExecutarSubmitTurno	         = "S"
	
	strAnoLetivo 			= session("strAnoLetivo")
	intCodTurma 			= Trim(Request.Form("txtCodigo"))
	strNomeTurma 			= Trim(Request.Form("txtNomeTurma"))
	intCodCurso	 			= Trim(Request.Form("cmbCurso"))
	intCodPeriodo 			= Trim(Request.Form("cmbPeriodo"))
	
	if Trim(Request.Form("cmbSemestre")) <> "0" then
	   intSemestre 			= Trim(Request.Form("cmbSemestre"))
	else
	   intSemestre 			= session("strSemestre")
	end if   
	   
	intCodGrade					= Trim(Request.Form("cmbGrade"))

	intCodTurno		 			= Trim(Request.Form("cmbTurno"))
	strSala		 				= Trim(Request.Form("txtSala"))
	
	intAno		 					= Trim(Request.Form("txtAno"))
	intSemestreCriacao				= Trim(Request.Form("cmbSemestreCriacao"))
	intAnoLetivo 					= Trim(Request.Form("txtAnoLetivo"))
	intCapacidade 					= Trim(Request.Form("txtCapacidade"))
	intCodFichaDescritiva			= Trim(Request.form("cmbFichaDescritiva"))
	strSimouNaoIntegralizacao		= Trim(Request.form("cmbSimouNaoIntegralizacao"))
	strDesvincularCriterioAvaliacao	= Trim(Request.form("cmbDesvincularCriterioAvaliacao"))
	strSituacaoTurma				= Trim(Request.form("cmbSituacaoTurma"))
	intVagasMatriculas				= Trim(Request.form("txtVagasMatriculas"))
	intVagasMatriculasUtilizadas	= Trim(Request.form("txtVagasMatriculasUtilizadas"))


	if strSala <> "" then strSala = ZeroLeft(Trim(strSala),2)
	if intAnoLetivo = "" then intAnoLetivo = strAnoLetivo
	if intSemestre = "" then intSemestre = session("strSemestre")

	if trim(intCodTurma) <> ""  then 
		sql = "SELECT SCA_TURMA.capacidade, SCA_TURMA.nomeTurma, SCA_SEMESTRE.sigla, SCA_TURMA.Cod_Turma, "
		sql = sql & " SCA_TURMA.Cod_GradeCurricular, SCA_TURMA.Cod_Semestre, SCA_TURMA.Cod_Turno, SCA_TURMA.Sala, SCA_TURMA.Ano, "
		sql = sql & " SCA_TURMA.Cod_SemestreCriacao,SCA_TURMA.AnoLetivo, SCA_TURMA.TurmaAluno, SCA_TURMA.Cod_FichaDescritiva, SCA_TURMA.DisponibilizaIntegralizacao,"
		sql = sql & " SCA_GRADECURRICULAR.Cod_Periodo, SCA_PERIODO.Cod_Curso, SCA_TURMA.DesvincularCriterioAvaliacao, SCA_TURMA.situacao, sca_turma.VagasMatriculas, sca_turma.VagasMatriculasUtilizadas"
		sql = sql & " FROM SCA_TURMA "
		sql = sql & " INNER JOIN SCA_GRADECURRICULAR ON SCA_TURMA.Cod_GradeCurricular = dbo.SCA_GRADECURRICULAR.Cod_GradeCurricular "
		sql = sql & " INNER JOIN SCA_PERIODO ON SCA_GRADECURRICULAR.Cod_Periodo = SCA_PERIODO.Cod_Periodo"
		sql = sql & " INNER JOIN SCA_SEMESTRE ON SCA_SEMESTRE.Codigo = SCA_TURMA.Cod_Semestre"
		sql = sql & " WHERE     (SCA_TURMA.Cod_Turma = " & intCodTurma & ") "
		sql = sql & " AND 		(SCA_TURMA.Cod_Empresa = " & Session("CodEmpresa") & ") "
		rs.open sql, cnn
		if rs.eof = false then
			intCodTurma 			= rs("Cod_Turma")
			strNomeTurma 			= rs("NomeTurma")
			intCodCurso	 			= rs("Cod_Curso")
			intCodPeriodo 			= rs("Cod_Periodo")
			intSemestre 			= rs("Cod_Semestre")
			strSiglaSemestre		= rs("sigla")
			intCodGrade				= rs("Cod_GradeCurricular")
			intCodTurno		 		= rs("Cod_Turno")
			strSala		 			= ZeroLeft(rs("Sala"),2)
			intAno		 			= rs("Ano")
			intSemestreCriacao		= rs("Cod_SemestreCriacao")
			
			intAnoLetivo 					= rs("AnoLetivo")
			strTurmaAluno					= rs("TurmaAluno")
			intCapacidade					= rs("Capacidade")
			intCodFichaDescritiva			= rs("Cod_FichaDescritiva")
			strSimouNaoIntegralizacao 		=  rs("DisponibilizaIntegralizacao")
			strDesvincularCriterioAvaliacao	=  rs("DesvincularCriterioAvaliacao")
			strSituacaoTurma				=  rs("Situacao")
			intVagasMatriculas				= rs("VagasMatriculas")
			intVagasMatriculasUtilizadas	= rs("VagasMatriculasUtilizadas")
			
			strSiglaSemestre = intSemestreCriacao
		    if intSemestre = "3" then strSiglaSemestre		= "A"
	
		    strDesabilitaIncluir	= "disabled" 'Desabilita o botão Incluir
			strDesabilitaAlterar 	= "" 'Desabilita o botão Excluir
			strDesabilitaExcluir	= "" 'Desabilita o botão Excluir
		end if 
		rs.close
	else
		IF LEN(trim(strNomeTurma)) = 9 THEN
			strDesabilitaIncluir	= "" 'Desabilita o botão Incluir
		ELSE
			strDesabilitaIncluir	= "disabled" 'Desabilita o botão Incluir
		END IF
		strDesabilitaAlterar 		= "disabled" 'Desabilita o botão Excluir
		strDesabilitaExcluir		= "disabled" 'Desabilita o botão Excluir
		
		IF Trim(Request.Form("txtNomeTurma"))<>"" THEN
			strNomeTurma 			= Trim(Request.Form("txtNomeTurma"))
		END IF
		IF Trim(Request.Form("cmbCurso")) <>"" THEN
			intCodCurso	 			= Trim(Request.Form("cmbCurso"))
		END IF
		IF Trim(Request.Form("cmbPeriodo"))<>"" THEN
			intCodPeriodo 			= Trim(Request.Form("cmbPeriodo"))
		END IF
		IF  Trim(Request.Form("cmbGrade"))<>"" THEN
			intCodGrade				= Trim(Request.Form("cmbGrade"))
		END IF
		IF Trim(Request.Form("cmbTurno"))<>"" THEN
			intCodTurno		 		= Trim(Request.Form("cmbTurno"))
		END IF
		IF Trim(Request.Form("txtSala"))<>"" THEN
			strSala		 			= Trim(Request.Form("txtSala"))
		END IF
		if strSala <> "" then strSala = ZeroLeft(Trim(strSala),2)
		IF Trim(Request.Form("txtAno"))<>"" THEN
			intAno		 			= Trim(Request.Form("txtAno"))
		END IF
		IF Trim(Request.Form("cmbSemestreCriacao"))<>"" THEN
			intSemestreCriacao		 			= Trim(Request.Form("cmbSemestreCriacao"))
		END IF
		IF Trim(Request.Form("txtAnoLetivo"))<>"" THEN
			intAnoLetivo 			= Trim(Request.Form("txtAnoLetivo"))
		END IF
		strSiglaSemestre = intSemestreCriacao
		if intSemestreCriacao = "3" then strSiglaSemestre		= "A"
	end if 
	
	if intCodCurso = "" then intCodCurso = "0"
    if intCodCurso <> "0" then
		strSigla = ""
		sql = "SELECT Sigla"
		sql = sql & " FROM SCA_CURSO"
		SQL = SQL & " WHERE cod_empresa=" & Session("CodEmpresa")
		SQL = SQL & " and cod_curso = " & intCodCurso
		RS.OPEN SQL, CNN		
		IF NOT RS.EOF THEN
			strSigla = RS("sigla")
		END IF
		RS.CLOSE
	end if

	if intCodPeriodo = "" then intCodPeriodo = "0"
	if intCodPeriodo <> "0" then
		strSequencia = ""
		sql = "SELECT Sequencia"
		sql = sql & " FROM SCA_PERIODO"
		SQL = SQL & " WHERE cod_empresa=" & Session("CodEmpresa")
		SQL = SQL & " and cod_periodo = " & intCodPeriodo
		RS.OPEN SQL, CNN		
		IF NOT RS.EOF THEN
			strSequencia = RS("Sequencia")
		END IF
		RS.CLOSE
	end if

%>
<table width="100%" height="355" border="0"  class="CorFundo" cellpadding="0" cellspacing="0">
  <tr valign="top">
    <td>
        <td colspan="2" align="center">
		<form id="frm" method="post" action="Turma_cad.asp">
		  <table width="98%" border="0" cellspacing="0" cellpadding="0">
          <tr>
            <td height="20" colspan="2" align="center" class="titulo"><%=carregaTituloPaginaASP(strPaginaTitulo)%></td>
          </tr>
          <tr>
            <td height="20" colspan="2" align="center" class="titulo">&nbsp;</td>
          </tr>
          <tr>
            <td height="20" colspan="2" bgcolor="#CCCCCC" class="texto1"><strong>Dados da Turma</strong></td>
            </tr>
          <tr>
            <td width="219" class="texto1">&nbsp;</td>
            <td width="1079" ><input name="txtCodigo" type="hidden" id="txtCodigo" class="text" size="10" value="<%=intCodTurma%>" maxlength="10"></td>
          </tr>
          <tr>
            <td class="texto1">Ano Letivo:</td>
            <td ><input onBlur="submit()" name="txtAnoLetivo" type="text" class="text" id="txtAnoLetivo"  value="<%=intAnoLetivo%>" size="5" maxlength="4" onKeyPress="return formataCampo(this,2,4)"></td>
          </tr>
          <tr>
            <td class="texto1">Semestre Letivo:</td>
            <td><!--#include file="../includes/inc_cmdSemestreTodos.asp" --></td>
          </tr>
          <tr>
            <td class="texto1">Curso:</td>
            <td><!--#include file="../includes/inc_cmdCurso.asp" --></td>
          </tr>
          <tr>
            <td height="28" class="texto1">Per&iacute;odo:</td>
            <td><!--#include file="../includes/inc_cmdPeriodo.asp" --></td>
          </tr>
          <tr>
            <td class="texto1">Sala:</td>
            <td><input onBlur="submit()" name="txtSala" type="text" class="text" id="txtSala"  value="<%=strSala%>" size="3" maxlength="2" onKeyPress="return formataCampo(this,2,2)"></td>
          </tr>
          <tr>
            <td height="28" class="texto1">Turno:</td>
            <td><!--#include file="../includes/inc_cmdTurno.asp" --></td>
          </tr>
          
          <tr>
            <td class="texto1">Matriz:</td>
            <td><!--#include file="../includes/inc_cmdGradeCurricular.asp" --></td>
          </tr>
          <tr>
            <td height="27" class="texto1">Ano Cria&ccedil;&atilde;o:</td>
            <td><input  name="txtAno" type="text" class="text" id="txtAno"  value="<%=intAno%>" size="5" maxlength="4" onKeyPress="return formataCampo(this,2,4)"></td>
          </tr>
          <tr>
            <td height="27" class="texto1">Semestre Cria&ccedil;&atilde;o:</td>
            <td><!--#include file="../includes/inc_cmdSemestreCriacao.asp" --></td>
          </tr>
          
		<%
		strNomeTurma = strSigla 
		strNomeTurma = strNomeTurma & strSequencia 
		strNomeTurma = strNomeTurma & strSala 
		strNomeTurma = strNomeTurma & strSiglaTurno 
		strNomeTurma = strNomeTurma & strSiglaSemestre
		if intAno <> "" then
			strNomeTurma = strNomeTurma & right(intAno,2)
		end if
	
		if trim(intCodTurma) = "" then
			IF LEN(trim(strNomeTurma)) = 9 OR LEN(trim(strNomeTurma)) = 10 THEN
				strDesabilitaIncluir= "" 'Desabilita o botão Incluir
			ELSE
				strDesabilitaIncluir= "disabled" 'Desabilita o botão Incluir
			END IF
			strDesabilitaAlterar 	= "disabled" 'Desabilita o botão Excluir
			strDesabilitaExcluir	= "disabled" 'Desabilita o botão Excluir		
		end if
		%>
          <tr>
            <td height="27" class="texto1">Nome da Turma:</td>
            <td><input readonly="true" name="txtNomeTurma" type="text" class="text" id="txtNomeTurma"  value="<%=strNomeTurma%>" size="12" maxlength="10" ></td>
          </tr>
          <tr>
            <td height="27" class="texto1">Capacidade:</td>
            <td><input name="txtCapacidade" type="text" class="text" id="txtCapacidade"  value="<%=intCapacidade%>" size="3" maxlength="2" onKeyPress="return formataCampo(this,2,2)"></td>
          </tr>
          <tr>
            <td height="27" class="texto1">Ficha Descritiva:</td>
            <td><!--#include file="../includes/inc_cmdFichaDescritiva.asp" --></td>
          </tr>
          <tr>
            <td height="27"  class="texto1">Disponibilizar Integraliza&ccedil;&atilde;o:</td>
            <td>
            <select name="cmbSimouNaoIntegralizacao" class="combo" id="cmbSimouNaoIntegralizacao"  style="width:70pt" onchange='' >
              <option value="N" <%if strSimouNaoIntegralizacao = "N" then response.Write("selected") %>>NAO</option>
              <option value="S" <%if strSimouNaoIntegralizacao = "S" then response.Write("selected") %>>SIM</option>
            </select>            </td>
          </tr>
          <tr>
            <td class="texto1">Desvincular Crit&eacute;rio de Avalia&ccedil;&atilde;o:</td>
            <td><select name="cmbDesvincularCriterioAvaliacao" class="combo" id="cmbDesvincularCriterioAvaliacao"  style="width:70pt" onchange='' >
              <option value="N" <%if strDesvincularCriterioAvaliacao = "N" then response.Write("selected") %>>NAO</option>
              <option value="S" <%if strDesvincularCriterioAvaliacao = "S" then response.Write("selected") %>>SIM</option>
            </select></td>
          </tr>
          <tr>
            <td class="texto1">Situa&ccedil;&atilde;o:</td>
            <td><select name="cmbSituacaoTurma" class="combo" id="cmbSituacaoTurma"  style="width:70pt" onchange='' >
              <option value="A" <%if strSituacaoTurma = "A" then response.Write("selected") %>>ATIVA</option>
              <option value="I" <%if strSituacaoTurma = "I" then response.Write("selected") %>>INATIVA</option>
            </select></td>
          </tr>
          <tr>
            <td class="texto1">&nbsp;</td>
            <td><input  name="cmbSituacaoTurmaAnterior" type="hidden" id="cmbSituacaoTurmaAnterior"  value="<%=strSituacaoTurma%>"></td>
          </tr>
          <tr>
            <td height="20" colspan="2" align="left" bgcolor="#CCCCCC" class="texto1"><strong>Vagas Existentes (Novatos)</strong></td>
            </tr>
           <%
			if trim(intCodTurma) <> ""  then 
				intOcupada = 0
				sql = "SELECT  DISTINCT SCA_ALUNO.CODIGO"
				sql = sql & " FROM SCA_ALUNO_TURMA "
				sql = sql & " INNER JOIN SCA_ALUNO ON SCA_ALUNO_TURMA.COD_ALUNO = SCA_ALUNO.CODIGO "
				SQL = SQL & " INNER JOIN SCA_SITUACAOALUNO ON SCA_ALUNO.COD_SITUACAOALUNO = SCA_SITUACAOALUNO.COD_SITUACAOALUNO and SCA_SITUACAOALUNO.COD_EMPRESA = SCA_ALUNO.COD_EMPRESA "
				sql = sql & " INNER JOIN SCA_TURMA ON SCA_ALUNO_TURMA.COD_TURMA = SCA_TURMA.Cod_Turma "
				sql = sql & " where SCA_TURMA.cod_empresa = " & Session("CodEmpresa")	
				sql = sql & " and 	SCA_ALUNO_TURMA.situacao = 'A'"
				sql = sql & " and 	SCA_ALUNO_TURMA.Ano_Letivo = " & intAnoLetivo
				sql = sql & " and 	SCA_ALUNO_TURMA.Semestre in (" & intSemestre & ")"
				sql = sql & " and   SCA_TURMA.COD_TURMA = " & intCodTurma 
				sql = sql & " AND (SCA_SITUACAOALUNO.Desc_SituacaoAluno = 'ATIVO' OR SCA_SITUACAOALUNO.Desc_SituacaoAluno = 'PRÉ-MATRÍCULA') " 
				RSAUX.OPEN SQL, CNN, 3, 1
				IF NOT RSAUX.EOF THEN
					intOcupada = RSAUX.RECORDCOUNT
				END IF
				RSAUX.CLOSE
				intVagasMatriculasUtilizadas = intOcupada
			end if	
		   %> 
          <tr>
            <td height="23" class="texto1">Vagas:</td>
            <td class="texto1"><input name="txtVagasMatriculas" type="text" class="text" id="txtVagasMatriculas"  value="<%=intVagasMatriculas%>" size="3" maxlength="2" onKeyPress="return formataCampo(this,2,2)"> 
            </td>
          </tr>
          <tr>
            <td class="texto1">Vagas Utilizadas:</td>
            <td><input name="txtVagasMatriculasUtilizadas" type="text" class="text"  readonly=false id="txtVagasMatriculasUtilizadas"  value="<%=intVagasMatriculasUtilizadas%>" size="3" maxlength="2"></td>
          </tr>
          <tr>
            <td colspan="2" class="texto1">&nbsp;</td>
          </tr>
          <tr>
            <td colspan="2" headers="20" bgcolor="#CCCCCC" class="texto1"><strong>Regra de cria&ccedil;&atilde;o de uma turma ex: EF 1 01 M 1 05</strong></td>
          </tr>
          <tr>
            <td class="texto1">&nbsp;</td>
            <td class="texto1"><strong>EF</strong>: Sigla do curso definida no cadastro de curso.</td>
          </tr>
          <tr>
            <td class="texto1">&nbsp;</td>
            <td class="texto1"><strong>1</strong>: Per&iacute;odo ou S&eacute;rie</td>
          </tr>
          <tr>
            <td class="texto1">&nbsp;</td>
            <td class="texto1"><strong>01</strong>: N&uacute;mero da Sala de Aula ( 01 a 99 )</td>
          </tr>
          <tr>
            <td class="texto1">&nbsp;</td>
            <td class="texto1"><strong>M</strong>: Sigla do Turno ( &quot;M&quot;atutino, &quot;V&quot;espertino, &quot;N&quot;oturno e &quot;I&quot;ntegral )</td>
          </tr>
          <tr>
            <td class="texto1">&nbsp;</td>
            <td class="texto1"><strong>1</strong>: Semestre de Cria&ccedil;&atilde;o (  &quot;1&quot;&ordm; Semestre, &quot;2&quot;&ordm; Semestre e &quot;A&quot;nual )</td>
          </tr>
          <tr>
            <td class="texto1">&nbsp;</td>
            <td class="texto1"><strong>05</strong>: Ano de Cria&ccedil;&atilde;o</td>
          </tr>
          <tr>
            <td colspan="2" class="texto1">&nbsp;</td>
          </tr>
          <tr>
            <td colspan="2" class="texto1"><!--#include file="../../includes/inc_botoes_cadastro.asp"--></td>
          </tr>
          <tr>
            <td colspan="2" class="texto1">&nbsp;</td>
          </tr>
          <tr>
            <td colspan="2" class="texto1"><%
			cont =0
			sql = "SELECT SCA_TURMA.Cod_Turma, SCA_TURMA.Cod_GradeCurricular, SCA_TURMA.Cod_Semestre, SCA_TURMA.Cod_Turno, SCA_TURNO.Desc_turno, SCA_TURMA.Capacidade,"
			sql = sql & "SCA_TURMA.nomeTurma, SCA_TURMA.Sala, SCA_TURMA.Ano, SCA_TURMA.AnoLetivo, SCA_TURMA.TurmaAluno, SCA_GRADECURRICULAR.cod_agrupamento, "
			sql = sql & " SCA_TURMA.Cod_periodo, PT.Descricao as Periodo "
			sql = sql & " FROM SCA_TURMA "
			sql = sql & " INNER JOIN SCA_TURNO ON SCA_TURNO.cod_empresa = SCA_TURMA.cod_empresa AND SCA_TURNO.cod_turno = SCA_TURMA.cod_turno"
		    sql = sql & " LEFT JOIN SCA_GRADECURRICULAR ON SCA_TURMA.Cod_GradeCurricular = SCA_GRADECURRICULAR.Cod_GradeCurricular "
		    sql = sql & " LEFT JOIN SCA_PERIODO ON SCA_GRADECURRICULAR.Cod_Periodo = SCA_PERIODO.Cod_Periodo"
			sql = sql & " LEFT JOIN SCA_PERIODO PT ON SCA_TURMA.Cod_periodo = PT.Cod_Periodo"
			sql = sql & " where SCA_TURMA.cod_empresa = " & Session("CodEmpresa")			
			sql = sql & " and 	AnoLetivo = " & intAnoLetivo
			'if intSemestre <> "0" then
			   sql = sql & " and 	SCA_TURMA.Cod_Semestre = " & intSemestre	
			'end if
			'if intCodCurso <> "0" then
			 '  sql = sql & " and SCA_PERIODO.Cod_Curso = " & intCodCurso
			'end if  
			'if intCodPeriodo <> "0" then  
			'   sql = sql & " and SCA_GRADECURRICULAR.Cod_Periodo = " & intCodPeriodo
			'end if
			sql = sql & " Order by SCA_TURMA.AnoLetivo, SCA_TURMA.nomeTurma"
			rs.open sql, cnn
							
			if rs.eof = false then
			%>
              <table width="100%" border="1" align="center" cellpadding="0" cellspacing="0" bordercolor="#CCCCCC" class="tabela">
                <tr bgcolor="#E5E5E5">
                  <td width="27%" bgcolor="#E5E5E5" class="celula"><strong>Nome da Turma</strong></td>
                  <td width="18%" bgcolor="#E5E5E5" class="celula"><strong>Período</strong></td>
                  <td width="10%" class="celula"><strong>Sala</strong></td>
                  <td width="8%" height="21" class="celula"><strong>Ano Letivo <span class="TextoForm"></span></strong></td>
                  <td width="5%" class="celula"><strong>Matriz</strong></td>
                  <td width="11%" class="celula"><strong>Semestre Letivo </strong></td>
                  <td width="5%" class="celula"><strong>Turno</strong></td>
                  <td width="16%" class="celula"><strong>Capacidade</strong></td>
                </tr>
                <%
				while not rs.eof
					cont = cont + 1	
					%>
                <tr style="cursor:hand" onMouseOver="return linhaMouseOver(this)" onMouseOut="return linhaMouseOut(this)" onClick="return resultadoConsulta('<%=rs("Cod_Turma")%>')">
                  <td class="celula"><%=trim(rs("NomeTurma"))%></td>
                  <td class="celula"><%=trim(rs("Periodo"))%>&nbsp;</td>
                  <td class="celula"><%=trim(rs("Sala"))%>&nbsp;</td>
                  <td height="20" class="celula"><%=trim(rs("AnoLetivo"))%>&nbsp;</td>
                  <td class="celula"><%=trim(rs("cod_agrupamento"))%>&nbsp;</td>
                  <td height="20" class="celula"><%=trim(rs("Cod_Semestre"))%>&nbsp;</td>
                  <td height="20" class="celula"><%=trim(rs("Desc_turno"))%>&nbsp;</td>
                  <td height="20" class="celula"><%=trim(rs("Capacidade"))%>&nbsp;</td>
                </tr>
                <%				
					rs.movenext
					wend
				  %>
                <tr>
                  <td height="21" colspan="8" bgcolor="#E5E5E5" class="celula">Total Registros : <%=cont%></td>
                </table>
            <%
			  end if
			  rs.close%></td>
          </tr>
          <tr>
            <td colspan="2" class="texto1">&nbsp;</td>
            </tr>
        </table>
		</form>
	
	</td>
  </tr>
</table>
<!--#include file="../rodape.asp"-->
</body>
</html>