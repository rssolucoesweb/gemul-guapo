<!--
	::	DESENVOLVIDO POR "RS SOLUÇÕES WEB - www.rssolucoesweb.com.br"
	::	Data de Criação...: 28/07/2008
	::	Desenvolvedores...: Sergio Borges - sergiob76@hotmail.com
	::	Objetivo Pagina...: Horario de Aula
-->
<html>
<head>
<title><%=session("Titulo")%></title>
<link type="text/css" rel="stylesheet" href="../../Estilo/css.css">
<script type="text/JavaScript">
<!--
function MM_preloadImages() { //v3.0
  var d=document; if(d.images){ if(!d.MM_p) d.MM_p=new Array();
    var i,j=d.MM_p.length,a=MM_preloadImages.arguments; for(i=0; i<a.length; i++)
    if (a[i].indexOf("#")!=0){ d.MM_p[j]=new Image; d.MM_p[j++].src=a[i];}}
}
//-->
</script>
</head>
<body  leftmargin="0" topmargin="0" marginwidth="0" marginheight="0" onLoad="MM_preloadImages('<%=session("strCaminhoRaiz")%>/images/botao_verde_over.gif')">
<script src="../../js/js_funcoes_gerais.js"></script>
<script type="text/javascript" src="../../js/js_dragdrop.js"></script>
<!--#include file="../../includes/inc_verificaSession.asp"-->
<!--#include file="../../includes/inc_cnn.asp"-->
<!--#include file=topo.asp-->
<!--#include file="../../includes/inc_formatadata.asp"-->
<!--#include file="../includes/inc_sqlAlunoTurma.asp"-->
<!--#include file="../includes/inc_CompartilharDadosCadastrais.asp"-->
<script>
	
	function Descricao(tipo){
		if (document.all["mostraDescricao"+tipo].style.display =="none"){
			document.all["mostraDescricao"+tipo].style.display="block";
			document.all["imgDescricao"+tipo].src="../../images/up.jpg";
		}
		else{
			document.all["mostraDescricao"+tipo].style.display="none";
			document.all["imgDescricao"+tipo].src="../../images/down.jpg";
		}
	}	
	
	function resultadoConsulta(intCodigo){
		
		var frm = document.getElementById("frm");
		frm.txtCodigo.value=intCodigo;
		frm.submit();
	}

	function salvar(acao){
		
		var frm = document.getElementById("frm");
		
		if (frm.cmbTurma.value == 0){
			alert("Turma deve ser informada.");
			frm.cmbTurma.focus();
			return false;
		}
		
		if (frm.cmbDisciplinaGrade.value == 0){
			alert("Disciplina deve ser informada.");
			frm.cmbDisciplinaGrade.focus();
			return false;
		}

		if (frm.cmbHorario.value == 0){
			alert("Horário deve ser informada.");
			frm.cmbHorario.focus();
			return false;
		}
	
		if (frm.cmbSequenciaAula.value == 0){
			alert("A sequencia deve ser informada.");
			frm.cmbSequenciaAula.focus();
			return false;
		}
		
		if (frm.cmbDiaSemana.value == 0){
			alert("A Sequência de aulas no Dia deve ser informada.");
			frm.cmbDiaSemana.focus();
			return false;
		}
		
		if (frm.cmbTempoAula.value == 0){
			alert("O Tempo Aula deve ser informada.");
			frm.cmbTempoAula.focus();
			return false;
		}

		
		<% if strHorarioData = "N" then %>

			if (frm.cmbDiaSemana.value == 0){
				alert("Dia da Semana deve ser informado.");
				frm.cmbDiaSemana.focus();
				return false;
			}
		<% end if %>	

		if (frm.cmbTempoAula.value == 0){
			alert("Tempo deve ser informado.");
			frm.cmbTempoAula.focus();
			return false;
		}
				
		frm.action="HorarioAula_cod.asp?acao="+acao;
		frm.submit();
		return true;
 	}
</script>
<%
	%>
	<script>
        alert("Horário de Aula - Lançamento Avulso em MANUNTENÇÃO. Por favor usar - Horário de Aula - Lançamento por Disciplina. Em caso de dúvida entre em contato com nosso suporte!");
        window.location.href ='HorarioAulaNovo_cad.asp'
    </script>
    <%
    response.end

	strPagina						= "HorarioAula_cad.asp"
	strPaginaTitulo 				= "HorarioAula_cad.asp"
	strCompartilharDados 			= "S"
	strExecutarSubmitSemestre 		= "S"
	strExecutarSubmitCurso	  		= "S"
	strExecutarSubmitTurma	  		= "S"
	strDisciplina_Disabled    		= "onchange='submit()'"
	strExecutarSubmitProfessorGeral = ""
	
	strAnoLetivo 			= Trim(Request.Form("txtAnoLetivo"))
	if strAnoLetivo = "" then 	strAnoLetivo = session("strAnoLetivo")
	intSemestre 			= Trim(Request.Form("cmbSemestre"))
	if intSemestre = "" or intSemestre = "0" then 	intSemestre  = session("strSemestre")
	
	intCodigo	 			= Trim(Request.Form("txtCodigo"))
	intCodCurso				= Trim(Request("cmbCurso"))
	intCodTurma 			= Trim(Request.Form("cmbTurma"))
	intCodProfessor		 	= Trim(Request.Form("cmbProfessor"))
	intCodSequenciaAula	 	= Trim(Request.Form("cmbSequenciaAula"))
	intCodDiaSemana			= Trim(Request.Form("cmbDiaSemana"))
	intCodGrade				= Trim(Request.Form("cmbGrade"))
	intCodDisciplinaGrade	= Trim(Request.Form("cmbDisciplinaGrade"))
	intCodTempoAula			= Trim(Request.Form("cmbTempoAula"))
	intSequeciaAulaMes		= Trim(Request.Form("cmbSequeciaAulaMes"))
	intCodProfessor			= Trim(Request.Form("cmbProfessor"))
	intCodProfessorGeral	= Trim(Request.Form("cmbProfessorGeral"))
	intCodHorario			= Trim(Request.Form("cmbHorario"))
	intCodTurmaJuncao 		= Trim(Request.Form("cmbTurmaJuncao"))
	strData	 				= Trim(Request.Form("txtData"))
	
	if intCodDisciplinaGrade = "" then intCodDisciplinaGrade = "0"
	IF intCodTurmaJuncao = "" then intCodTurmaJuncao = "0"
	
	strHorarioData = "N"
	sql = " SELECT top 1 Horario_Aula_Diario"
	sql = sql & " FROM SEG_ENCERRAMENTOATIVIDADES "
	sql = sql & " Where cod_empresa = " & Session("CodEmpresa")
	rs.Open SQL, cnn
	if rs.EOF = false then								
		strHorarioData = rs("Horario_Aula_Diario")
		if isnull(strHorarioData) then strHorarioData = "N"
	end if
	rs.close
		
	if trim(intCodigo) <> "" then
	
		sql = "SELECT	HA.COD_TURMA, P.COD_CURSO, P.COD_PERIODO, T.COD_TURNO, HA.TEMPO, HA.DATA, HA.DIASEMANA, "
		sql = sql & " HA.COD_COLABORADOR, HA.COD_DISCIPLINA, G.COD_GRADECURRICULAR, HA.COD_HORARIO, HA.SEQUENCIA, HA.TEMPO, Turma_Juncao, Colaborador_Outras_Unidades, TipoAula "
		sql = sql & " FROM	SCA_HORARIO_AULA HA"
		sql = sql & " INNER JOIN SCA_HORARIO H ON H.COD_EMPRESA=HA.COD_EMPRESA AND H.CODIGO=HA.COD_HORARIO"
		sql = sql & " INNER JOIN SCA_TURMA T ON T.COD_EMPRESA=HA.COD_EMPRESA AND T.COD_TURMA=HA.COD_TURMA"
		sql = sql & " INNER JOIN SCA_GRADECURRICULAR G ON G.COD_EMPRESA=T.COD_EMPRESA AND G.COD_GRADECURRICULAR=T.COD_GRADECURRICULAR"
		sql = sql & " INNER JOIN SCA_PERIODO P ON P.COD_EMPRESA=T.COD_EMPRESA AND P.COD_PERIODO=G.COD_PERIODO"
		if strCompartilharDados = "S" then
		   sql = sql & " LEFT JOIN SRH_COLABORADOR C ON C.CODIGO=HA.COD_COLABORADOR"
		else   
		   sql = sql & " LEFT JOIN SRH_COLABORADOR C ON C.COD_EMPRESA=HA.COD_EMPRESA AND C.CODIGO=HA.COD_COLABORADOR"
		end if   
		sql = sql & " LEFT JOIN SCA_DISCIPLINA D ON D.COD_EMPRESA=HA.COD_EMPRESA AND D.COD_DISCIPLINA=HA.COD_DISCIPLINA"
		sql = sql & " WHERE	1=1 "
		if strCompartilharDados = "S" then
			'sql = sql & " AND C.CODLOTACAO	= " & Session("CodEmpresa")
		else    
			sql = sql & " AND HA.COD_EMPRESA	= " & Session("CodEmpresa")
		end if   
		sql = sql & " AND	HA.CODIGO		= " & intCodigo
		rs.open sql, cnn
		if rs.eof = false then
			
			intCodTurma 			= Trim(rs("cod_Turma"))
				
			if Trim(rs("Colaborador_Outras_Unidades")) = "S" then
			   intCodProfessorGeral 	= Trim(rs("COD_COLABORADOR"))
			   intCodProfessor 			= "0"
			else
			   intCodProfessor 			= Trim(rs("COD_COLABORADOR"))
			   intCodProfessorGeral 	= "0"
			end if    
			
			intCodSequenciaAula	 		= Trim(rs("Sequencia"))
			strData						= formatadataAP(Trim(rs("Data")))
			intCodDiaSemana				= Trim(rs("DiaSemana"))
			intSequeciaAulaMes	 		= Trim(rs("TipoAula"))
				
			if trim(intCodDisciplinaGrade) = "0" then
				
				if not isnull(Trim(rs("COD_DISCIPLINA"))) then 
					intCodDisciplinaGrade	= Trim(rs("COD_DISCIPLINA"))
				end if
			end if
			
			intCodTempoAula			= Trim(rs("Tempo"))
			intCodHorario			= Trim(rs("COD_HORARIO"))
			intCodTurmaJuncao 		= Trim(rs("Turma_Juncao"))
			strDesabilitaIncluir	= "disabled" 'Desabilita o botão Incluir
			strDesabilitaAlterar 	= "" 'Desabilita o botão Excluir
			strDesabilitaExcluir	= "" 'Desabilita o botão Excluir
		else
			strDesabilitaIncluir	= "" 'Desabilita o botão Incluir
			strDesabilitaAlterar 	= "disabled" 'Desabilita o botão Excluir
			strDesabilitaExcluir	= "disabled" 'Desabilita o botão Excluir
		end if 
		rs.close
	else
		strDesabilitaIncluir	= "" 'Desabilita o botão Incluir
		strDesabilitaAlterar 	= "disabled" 'Desabilita o botão Excluir
		strDesabilitaExcluir	= "disabled" 'Desabilita o botão Excluir
	end if 

	if intCodTurma 		= "" then intCodTurma 		= "0"
	
	if trim(intCodTurma) <> "0" then
		sql = "SELECT SCA_GRADECURRICULAR.Cod_GradeCurricular, SCA_TURMA.cod_turma, SCA_TURMA.cod_Semestre , SCA_PERIODO.Cod_Curso, SCA_PERIODO.Cod_Periodo, SCA_TURMA.cod_turno, SCA_TURMA.Sala, SCA_TURMA.NomeTurma"
		sql = sql & " FROM SCA_TURMA "
		sql = sql & " INNER JOIN SCA_GRADECURRICULAR ON SCA_TURMA.Cod_GradeCurricular = SCA_GRADECURRICULAR.Cod_GradeCurricular "
		sql = sql & " INNER JOIN SCA_PERIODO ON SCA_GRADECURRICULAR.Cod_Periodo = SCA_PERIODO.Cod_Periodo"
		SQL = SQL & " WHERE SCA_TURMA.cod_empresa=" & Session("CodEmpresa")
		sql = sql & " AND SCA_TURMA.Cod_Turma= " & intCodTurma
		RS.OPEN SQL, CNN
		IF not RS.EOF THEN
			intCodCurso 	= rs("cod_curso")
			intCodPeriodo = rs("cod_periodo")
			intCodTurno = rs("cod_turno")
			'intSemestre = rs("cod_Semestre")
			intCodGrade = rs("Cod_GradeCurricular")
		END IF
		rs.close
	end if
	
	if intCodProfessor 	= "" then intCodProfessor 	= "0"
	if intCodProfessorGeral 	= "" then intCodProfessorGeral 	= "0"
	
	%>
    <!--
	'VALIDA O CONTEUDO DO PROFESSOR ESTA FECHADO
	IF intCodProfessor <> "0" THEN
		sql = "select top 1 CODIGO"
		sql = sql & " from SCA_Conteudo"
		sql = sql & " where cod_colaborador = " & intCodProfessor
		sql = sql & " and cod_turma = " & intCodTurma
		sql = sql & " and Cod_Disciplina = " & intCodDisciplinaGrade
		sql = sql & " and (fechamento <> 'S' OR fechamento IS NULL)	"
		RS.OPEN SQL, CNN
		IF not RS.EOF THEN
			strDesabilitaIncluir = " DISABLED "
			strDesabilitaAlterar = " DISABLED "
			strDesabilitaExcluir = " DISABLED "
			if not isnull(rs("CODIGO")) then
				%>
				<script>
					alert("Existe conteudo programático em edição para este colaborador, favor fechá-lo.");
				</script>
				
			end if
		END IF
		rs.close
	END IF
	-->
<form method="post" id="frm" action="HorarioAula_cad.asp">
<input name="txtCodigo" type="hidden" id="txtCodigo" value="<%=intCodigo%>">
<table width="100%" height="355" border="0"  class="CorFundo" cellpadding="0" cellspacing="0">
            <tr valign="top">
              <td  align="center" class="tituloSistema"><%=carregaTituloPaginaASP(strPaginaTitulo)%></td>
            </tr>
		<tr valign="top">
		  <td align="center">
  <table width="98%" border="0" align="center" cellpadding="0" cellspacing="2" class="Formulario">
    <tr>
      <td height="12"><span class="texto1">Ano Letivo:</span></td>
      <td><input  name="txtAnoLetivo" type="text" class="text" id="txtAnoLetivo" onBlur="submit()"  value="<%=strAnoLetivo%>" size="5" maxlength="5" onKeyPress="return formataCampo(this,2,10)"></td>
    </tr>
    <tr> 
      <td width="16%" height="12"><span class="texto1">Semestre:</span></td>
      <td><!--#include file="../includes/inc_cmdSemestre.asp" --></td>
    </tr>
    
    <tr>
      <td class="texto1">Curso:</td>
      <td><span class="texto1">
        <!--#include file="../includes/inc_cmdCurso.asp"-->
      </span></td>
    </tr>
    <tr> 
      <td class="texto1">Turma: </td>
      <td><!--#include file="../includes/inc_cmdTurma.asp"--></td>
    </tr>
    <tr>
      <td class="texto1">Disciplina:</td>
      <td class="texto1"><!--#include file="../includes/inc_cmdDisciplinaGrade.asp"-->
      &nbsp;*</td>
    </tr>
    
    <%
	if trim(intCodTurma) <> "0" and  trim(intCodDisciplinaGrade) <> "0" then
		sql = " SELECT count(cod_turma) as total from SCA_HORARIO_AULA "
		sql = sql & " where cod_empresa = " & Session("CodEmpresa")
		sql = sql & " and cod_turma = " & intCodTurma
		sql = sql & " and anoLetivo = " & strAnoLetivo
		sql = sql & " and semestre = " & intSemestre
		sql = sql & " and Cod_Disciplina = " & intCodDisciplinaGrade
		sql = sql & " GROUP BY cod_turma "
		RSAUX.OPEN SQL, CNN
		IF NOT RSAUX.EOF THEN
			TotalHorario = RSAUX("total")
			if isnull(RSAUX("total")) then
			   TotalHorario = "0"
			end if   
		END IF
		RSAUX.CLOSE
		
		'BUSCA SE A TURMA POSSUI MATRIZ CADASTRADA
		Matriz = "NÃO"
		sql = " SELECT "
		sql = sql & " SUM(GD.Ch_Semanal) as total "
		sql = sql & " FROM SCA_TURMA T "
		sql = sql & " INNER JOIN SCA_GRADECURRICULAR G ON G.Cod_GRADECURRICULAR = T.COD_GRADECURRICULAR AND G.SITUACAO = 'A' "
		sql = sql & " INNER JOIN SCA_GRADECURRICULARDISCIPLINA GD ON GD.Cod_GradeCurricular = G.Cod_GRADECURRICULAR "
		sql = sql & " WHERE T.COD_EMPRESA = " & Session("CodEmpresa")
		sql = sql & " AND COD_TURMA = " & intCodTurma
		sql = sql & " and Cod_Disciplina = " & intCodDisciplinaGrade
		RSAUX.OPEN SQL, CNN
		IF NOT RSAUX.EOF THEN
			TotalMatriz = RSAUX("total")
			if isnull(RSAUX("total")) then
			   TotalMatriz = "0"
			end if   
		END IF
		RSAUX.CLOSE
		SaldoAulas =  TotalHorario - TotalMatriz
		if SaldoAulas < 0 then StatusSaldo = "** Incompleto **"
		if SaldoAulas = 0 then StatusSaldo = "** OK! **"
		if SaldoAulas > 0 then StatusSaldo = "** Carga Horária Execedida, Verifique! **"
		
	else	
		if SaldoAulas = "" then StatusSaldo = ""
	end if
	%>
    <tr>
      <td class="texto1">Hor&aacute;rio: </td>
      <td class="texto1"><!--#include file="../includes/inc_cmdHorario.asp"-->
      &nbsp;*</td>
    </tr>
    <tr>
      <td class="texto1">Sequ&ecirc;ncia de aulas no Dia: </td>
      <td class="texto1"><!--#include file="../includes/inc_cmdSequenciaAula.asp"-->
      &nbsp;*</td>
      </tr>
    <% if strHorarioData  = "S" then %>
       	<tr>
          <td class="texto1">Data: </td>
          <td class="texto1"><input name="txtData" type="text" class="text" id="txtData" onBlur="submit(); validaData(this)" onKeyPress="return formataCampo(this, 3, 10)" size="11" maxlength="10" value="<%=strData%>"></td>
        </tr>
    	<%
		if Trim(Request.Form("txtData")) <> "" then  intCodDiaSemana = weekday(Trim(Request.Form("txtData")))
	else %>
        <tr>
          <td class="texto1">Dia da Semana: </td>
          <td class="texto1"><!--#include file="../includes/inc_cmdDiaSemana.asp"-->
          &nbsp;*</td>
        </tr>
        <tr>
          <td class="texto1">Sequ&ecirc;ncia de aulas no M&ecirc;s:</td>
          <td class="texto1"><select name="cmbSequeciaAulaMes" id="cmbSequeciaAulaMes" class="combo" style="width:150pt">
              <option value="1">Semanal</option>
              <option <%if intSequeciaAulaMes="2" then response.Write("selected") %> value="2">Mensal ( 1ª Semana )</option>
              <option <%if intSequeciaAulaMes="3" then response.Write("selected") %> value="3">Mensal ( 2ª Semana )</option>
              <option <%if intSequeciaAulaMes="4" then response.Write("selected") %> value="4">Mensal ( 3ª Semana )</option>
              <option <%if intSequeciaAulaMes="5" then response.Write("selected") %> value="5">Mensal ( 4ª Semana )</option>
              <option <%if intSequeciaAulaMes="6" then response.Write("selected") %> value="6">Quinzenal ( 1ª Quinzena )</option>
              <option <%if intSequeciaAulaMes="7" then response.Write("selected") %> value="7">Quinzenal ( 2ª Quinzena )</option>
            </select>
            &nbsp;*  Ser&aacute; usado apenas para identificar quando uma aula informada n&atilde;o for semanal.</td>
        </tr>
        
        <%
	end if %>    
    
    <tr class="texto1">
      <td class="texto1">Tempo: </td>
      <td class="texto1"><select name="cmbTempoAula" id="cmbTempoAula" class="combo" style="width:150pt">
        <option value="0">Selecione...</option>
		<option <%if intCodTempoAula="1" then response.Write("selected") %> value="1">1º tempo (antes do intervalo)</option>
		<option <%if intCodTempoAula="2" then response.Write("selected") %> value="2">2º tempo (depois do intervalo)</option>
      </select>
      &nbsp;*</td>
    </tr>
        <tr>
          <td class="texto1">Professor(a): </td>
          <td class="texto1"><!--#include file="../includes/inc_cmdProfessorAtivo.asp"-->&nbsp;*</td>
        </tr>
    <tr>
      <td class="texto1">Jun&ccedil;&atilde;o de Turmas: </td>
      <td class="texto1"><!--#include file="../includes/inc_cmdTurmaJuncao.asp"--></td>
    </tr>
    
    
	
			<tr bgcolor="#CCCCCC">
			  <td height="20" colspan="2" class="TextoForm">Buscar Professor de Outras Unidades?</td>
			  </tr>
           <tr>
			  <td class="texto1">Professor(a): </td>
			  <td class="texto1"><!--#include file="../includes/inc_cmdProfessorGeral.asp"--></td>
			</tr>
    <tr>
      <td class="texto1">&nbsp;</td>
      <td class="texto1">&nbsp;</td>
    </tr>
    <tr bgcolor="#E5E5E5" class="celula">
      <td colspan="2" class="texto1"><div align="center"><strong>Status do Lan&ccedil;amento</strong> ( Matriz Curricular:&nbsp;<span class="texto1"><strong><%=TotalMatriz%></strong></span>&nbsp;-&nbsp; Hor&aacute;rio de Aula:&nbsp;<span class="texto1"><strong><%=TotalHorario%></strong></span>&nbsp;) = Saldo:&nbsp;<span class="texto1"><strong><%=SaldoAulas%></strong></span>&nbsp; - <span class="texto1"><strong><%=StatusSaldo%></strong></span>&nbsp;</div></td>
      </tr>
    <tr>
      <td class="texto1">&nbsp;</td>
      <td class="texto1">&nbsp;</td>
    </tr>
    <tr> 
      <td class="texto1">&nbsp;</td>
      <td class="texto1">Obs: Todos campos marcados com (*) permitir&aacute; altera&ccedil;&atilde;o durante a manuten&ccedil;&atilde;o do hor&aacute;rio. </td>
    </tr>
    <tr> 
      <td colspan="2" class="texto1"><hr size="1" color="#CCCCCC"></td>
    </tr>
    <tr> 
      <td colspan="2" class="texto1"><!--#include file="../../includes/inc_botoes_cadastro.asp"--></td>
    </tr>
    <tr> 
       	<td colspan="2" class="texto1">
		
		<% IF intCodCurso<> "0" OR intCodTurma<> "0" then
			cont =0
			sql = "SELECT	HA.CODIGO, P.DESCRICAO AS PERIODO, T.NOMETURMA, H.HORARIO, HA.TEMPO, HA.DATA, HA.DIASEMANA, HA.SEQUENCIA, C.NOME AS PROFESSOR, D.DESC_DISCIPLINA, TJ.NOMETURMA AS TURMAJUNCAO "
			sql = sql & " FROM	SCA_HORARIO_AULA HA"
			sql = sql & " INNER JOIN SCA_HORARIO H ON H.COD_EMPRESA=HA.COD_EMPRESA AND H.CODIGO=HA.COD_HORARIO"
			sql = sql & " INNER JOIN SCA_TURMA T ON T.COD_EMPRESA=HA.COD_EMPRESA AND T.COD_TURMA=HA.COD_TURMA"
			sql = sql & " INNER JOIN SCA_GRADECURRICULAR G ON G.COD_EMPRESA=T.COD_EMPRESA AND G.COD_GRADECURRICULAR=T.COD_GRADECURRICULAR"
			sql = sql & " INNER JOIN SCA_PERIODO P ON P.COD_EMPRESA=T.COD_EMPRESA AND P.COD_PERIODO=G.COD_PERIODO"
			if strCompartilharDados = "S" then
			   sql = sql & " LEFT JOIN SRH_COLABORADOR C ON C.CODIGO=HA.COD_COLABORADOR"
			else   
			   sql = sql & " LEFT JOIN SRH_COLABORADOR C ON C.COD_EMPRESA = HA.COD_EMPRESA AND C.CODIGO=HA.COD_COLABORADOR"
			end if   
			sql = sql & " LEFT  JOIN SCA_DISCIPLINA D ON D.COD_EMPRESA=HA.COD_EMPRESA AND D.COD_DISCIPLINA=HA.COD_DISCIPLINA"
			sql = sql & " LEFT JOIN SCA_TURMA TJ ON TJ.COD_EMPRESA=HA.COD_EMPRESA AND TJ.COD_TURMA=HA.TURMA_JUNCAO"
			sql = sql & " WHERE	1=1"
			
			if strCompartilharDados = "S" then
				'sql = sql & "AND C.CODLOTACAO	= " & Session("CodEmpresa")
			else   
				sql = sql & " AND	HA.COD_EMPRESA	= " & Session("CodEmpresa")
			end if   
			
			sql = sql & " AND		HA.ANOLETIVO	= " & strAnoLetivo
			sql = sql & " AND		HA.SEMESTRE		in (" & intSemestre & ")"
			sql = sql & " AND		P.COD_CURSO		= " & intCodCurso
			if intCodTurno <> "0" then
				sql = sql & " AND		T.COD_TURNO		= " & intCodTurno
			end if
			if intcodPeriodo <> "0" then
				sql = sql & " AND		G.COD_PERIODO	= " & intcodPeriodo
			end if
			if intCodTurma <> "0" then
				sql = sql & " AND		T.COD_TURMA		= " & intCodTurma
			end if
			sql = sql & " Order by HA.ANOletivo, HA.semestre, P.DESCRICAO, T.NOMETURMA, HA.DIASEMANA, H.horario "
			
			rs.open sql, cnn
			if rs.eof = false then
			%>
                <table width = "99%" border="1" align="center" cellpadding="0" cellspacing="0" bordercolor="#CCCCCC" class="tabela">
                  <tr bgcolor="#E5E5E5">
                    <td width="6%" class="celula"><strong>Per&iacute;odo  </strong></td>
                    <td width="4%" class="celula"><strong><strong>Turma</strong></strong></td>
                    <td width="16%" height="21" class="celula"><strong>Hor&aacute;rio<span class="TextoForm"></span></strong></td>
                    <td width="10%" class="celula"><strong>Sequencia</strong></td>
                    <td width="8%" class="celula"><strong>Tempo<span class="TextoForm"></span></strong></td>
    <% if strHorarioData = "S" then %>
                    	<td width="9%" class="celula"><strong>Data <span class="TextoForm"></span></strong></td>
                    <% end if %>
                    <td width="8%" class="celula"><strong>Dia Semana <span class="TextoForm"></span></strong></td>
                    <td width="13%" class="celula"><strong>Disciplina</strong></td>
                    <td width="17%" class="celula"><strong>Professor(a)<span class="TextoForm"></span></strong></td>
                    <td width="8%" class="celula"><strong>Jun&ccedil;&atilde;o </strong></td>
                  </tr>
                  <%
				while not rs.eof
					cont = cont + 1	
					
					If rs("diasemana") mod 2 = 0 then
						strCor = "#FFFFCC"
					Else
						strCor = "#CCCCCC"
					End if
									
					if cint(rs("diasemana")) <> "0"  then
						strDiadaSemana = WeekDayName(trim(rs("diasemana")))
					else
						strDiadaSemana = trim(rs("diasemana"))
					end if
					
					
					if cint(rs("diasemana")) <> "0"  then
						strDiadaSemana = WeekDayName(trim(rs("diasemana")))
					else
						strDiadaSemana = trim(rs("diasemana"))
					end if
					
					%>
                  <tr bgcolor="<%=strCor%>" style="cursor:hand" onMouseOver="return linhaMouseOver(this)" onMouseOut="return linhaMouseOut(this)" onClick="return resultadoConsulta('<%=rs("codigo")%>')">
                    <td class="celula"><%=rs("periodo")%></td>
                    <td class="celula"><%=rs("nometurma")%></td>
                    <td height="20" class="celula"><%=trim(rs("horario"))%></td>
                    <td class="celula"><%=trim(rs("sequencia"))%>&ordf; Aula </td>
                    <td class="celula"><%=trim(rs("tempo"))%>º</td>
                    <% if strHorarioData = "S" then %>
                    	<td class="celula"><%=trim(formatadataAP(rs("data")))%></td>
                    <% end if %>
                    <td class="celula"><%=strDiadaSemana%></td>
                    <td class="celula"><%=trim(rs("DESC_DISCIPLINA"))%>&nbsp;</td>
                    <% if isnull(rs("PROFESSOR")) then %>
                    	<td class="celula"> ** Deficit **</td>
                    <% else %>    
                    	<td class="celula"><%=trim(rs("PROFESSOR"))%>&nbsp;</td>
                    <% end if %>    
                    <td width="1%" class="celula"><div align="center"><%=trim(rs("TURMAJUNCAO"))%>&nbsp;</div></td>
                  </tr>
                  <%				
					rs.movenext
					wend
				  %>
                  <tr>
                    <td height="21" colspan="10" class="celula">Total Registros : <%=cont%></td>
                  </table>
            <%
			  end if
			  rs.close
			  
			end if%>		</td>
    </tr>
  </table>
  		  </td>
		</tr>
  </table>
</form>
<!--#include file="../rodape.asp"-->
</body>
</html>