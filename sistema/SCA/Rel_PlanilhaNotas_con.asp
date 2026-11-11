<!--
	::	DESENVOLVIDO POR "RS SOLUÇÕES WEB - www.rssolucoesweb.com.br"
	::	Data de Criação...: 13/02/2008
	::	Desenvolvedores...: Roberto Barbosa Silva - robertobs7@hotmail.com
	::	Objetivo Pagina...: Diário de Frequência 
-->
<html>
<head>
<title><%=session("Titulo")%></title>
<link type="text/css" rel="stylesheet" href="../../Estilo/css.css">
</head>
<body  leftmargin="0" topmargin="0" marginwidth="0" marginheight="0">
<script src="../../js/js_funcoes_gerais.js"></script>
<script type="text/javascript" src="../../js/js_dragdrop.js"></script>
<script>

	function gerar(){
		
		var frm = document.getElementById("frm");
        var form = window.document.forms[0];
		var intContMarcado=0;

		if (frm.cmbCurso.value == "0") {
			alert("O Curso deve ser informado !");
			frm.cmbCurso.focus();
			return false;
		}	
		
		if (frm.cmbPeriodo.value == "0") {
			alert("O Periodo deve ser informado !");
			frm.cmbPeriodo.focus();
			return false;
		}
		
		if (frm.cmbSemestre.value == "0") {
			alert("O Semestre deve ser informado !");
			frm.cmbSemestre.focus();
			return false;
		}
		
		if (frm.cmbTurno.value == "0") {
			alert("A Turma deve ser informado !");
			frm.cmbTurno.focus();
			return false;
		}
        
    		

		frm.action = "Rel_PlanilhaNotas_rel.asp";
		frm.submit();
		return true;	
	}	
</script>
<!--#include file="../../includes/inc_verificaSession.asp"-->
<!--#include file="../../includes/inc_cnn.asp"-->
<!--#include file=topo.asp-->
<!--#include file="../../includes/inc_formatadata.asp"-->
<!--#include file="../includes/inc_sqlAlunoTurma.asp"-->
<%
	strPaginaTitulo = "Rel_PlanilhaNotas_con.asp"

	strExecutarSubmitCurso	  = "S"
	strExecutarSubmitPeriodo  = "S"
	strExecutarSubmitSemestre = "S"
	strExecutarSubmitTurno	  = "S"
	strExecutarSubmitTurma	  = "S"

	strOpcaoRelatorio 		= Trim(Request.Form("optOpcao"))

	intCodCurso	 			= Trim(Request.Form("cmbCurso"))
	intCodPeriodo 			= Trim(Request.Form("cmbPeriodo"))
	intCodTurno		 		= Trim(Request.Form("cmbTurno"))
	intCodTurma 			= Trim(Request.Form("cmbTurma"))
	intCodDisciplinaTurma	= Trim(Request.Form("cmbDisciplinaTurma"))
	strMes 					= Trim(Request.Form("cmbMes"))
	strlpp 					= Trim(Request.Form("cmblpp"))
	strclasse               = Trim(Request.Form("cmbTamanhoFonteArial"))
	intCodEstagio		 	= Trim(Request.Form("cmbEstagio"))
	stromiteDadosdoDiario 	= Trim(Request.Form("omiteDadosdoDiario"))
	intCodSituacaoAluno	 	= Trim(Request.Form("cmbSituacaoAluno"))
	if intCodSituacaoAluno 	= "" then intCodSituacaoAluno = "0"
	
	if strMes = "" then strMes = month(date)

	strAnoLetivo 			= Trim(Request("txtAnoLetivo"))
	if strAnoLetivo = "" then 	strAnoLetivo = session("strAnoLetivo")
	intSemestre 			= Trim(Request("cmbSemestre"))
	if intSemestre = "" then 	intSemestre  = session("strSemestre")
	
	strFiltroSerie = "0"
	strFiltroTurno = "0"

	if intCodComp = "" then intCodComp = "0"
	if intCodSerie = "" then intCodSerie = "0"
	if intCodTurno = "" then intCodTurno = "0"
	if intCodTurma = "" then intCodTurma = "0"
	if intCodSemestre = "" then intCodSemestre = "0"
	if intCodTipoLancamento = "" then intCodTipoLancamento = "0"
	if intCodDisciplinaTurma = "" then intCodDisciplinaTurma = "0"
	if intCodNota = "" then intCodNota="0"
	if intCodEstagio = "" then intCodEstagio="0"
	
	' Consulta a Categoria	
	sql = "select codigo "
	sql = sql & " from SRH_COLABORADOR"
	sql = sql & " where codigo_SEG_USUARIOS_SISTEMA = '" & trim(session("usuarioWeb")) & "'"
	sql = sql & " and codLotacao = " & Session("CodEmpresa")
	sql = sql & " and CodCategoria = 1 "'professor
	sql = sql & " and Situacao = 'A'" 'Ativo
	rs.open sql, cnn
	if rs.EOF = false then	
		strVerificaCategoria 		= "Professor"
		intCodColaboradorProfessor 	= trim(rs("codigo"))
		intcategoria="1"
	else
		intcategoria="0"
		strVerificaCategoria = ""
	end if
	rs.close

    if strVerificaCategoria <> "Professor" then
	   intCodDisciplina			= Trim(Request("cmbDisciplinaTurma"))
	   intCodDisciplinaTurma	= Trim(Request.Form("cmbDisciplinaTurma"))
	else
	   intCodDisciplina		    = Trim(Request("cmbDisciplinaDoProfessor"))
	   intCodDisciplinaTurma	= Trim(Request("cmbDisciplinaDoProfessor"))
	end if   

    if strVerificaCategoria <> "Professor" then
		intCodTurma 			= Trim(Request("cmbTurma"))
		intCodTurmaProfessor	= Trim(Request("cmbTurma"))
	else   
		intCodTurma				= Trim(Request("cmbTurmaProfessor"))
		intCodTurmaProfessor	= Trim(Request("cmbTurmaProfessor"))
	end if   


	if trim(intCodTurma) <> "" then
		sql = "SELECT SCA_TURMA.cod_turma, SCA_TURMA.cod_Semestre , SCA_PERIODO.Cod_Curso, SCA_PERIODO.Cod_Periodo, SCA_TURMA.cod_turno, SCA_TURMA.Sala, SCA_TURMA.NomeTurma"
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
			intSemestre = rs("cod_Semestre")
		END IF
		rs.close
	end if

	strSemestre = intSemestre

	'controla os botões
	strDesabilitaIncluir 	= "disabled"
	strDesabilitaExcluir 	= "disabled"
	strDesabilitaAlterar 	= ""
	strDesabilitaLimpar 	= ""

%>
<form method="post" id="frm" action="#">
<input name="cmbCurso" type="hidden" value="<%=intCodCurso%>">
<input name="cmbPeriodo" type="hidden" value="<%=intCodPeriodo%>">
<input name="cmbTurno" type="hidden" value="<%=intCodTurno%>">
<input name="txtTipoRelatorio" type="hidden" value="<%=intTipoRelatorio%>">
<table width="100%" border="0" bgcolor="#FFFFFF" cellpadding="0" cellspacing="0">
            <tr valign="top">
              <td align="center" class="tituloSistema"><%=carregaTituloPaginaASP(strPaginaTitulo)%></td>
            </tr>
  </table>
<table width="98%" border="0" align="center" cellpadding="0" cellspacing="2"  bgcolor="#FFFFFF">
	  <tr>
        <td class="texto1">Ano Letivo:</td>
	    <td colspan="2"><input  name="txtAnoLetivo" type="text" class="text" id="txtAnoLetivo" onBlur="submit()"  value="<%=strAnoLetivo%>" size="5" maxlength="5" onKeyPress="return formataCampo(this,2,10)"></td>
      </tr>
	  <tr>
        <td class="texto1">Semestre:</td>
	    <td colspan="2"><!--#include file="../includes/inc_cmdSemestre.asp" --></td>
      </tr>
    <tr>
      <td width="14%" class="texto1">Turma</td>
        <td>
          <% if strVerificaCategoria <> "Professor" then %>
             <!--#include file="../includes/inc_cmdTurma.asp"-->
          <% else %>	 
             <!--#include file="../includes/inc_cmdTurmaProfessor.asp"-->
          <% end if %>            
         </td>
    </tr>
    <tr>
      <td class="texto1">Disciplina</td>
        <td>
          <% if strVerificaCategoria <> "Professor" then %>
                <!--#include file="../includes/inc_cmbDisciplinaTurma.asp"-->
          <% else %>
                <!--#include file="../includes/inc_cmdDisciplinaDoProfessor.asp"-->			  
          <% end if %>           
         </td>
    </tr>
    <tr>
      <td class="texto1">Situa&ccedil;&atilde;o</td>
      <td colspan="2"><!--#include file="../includes/inc_cmdSituacaoAluno.asp" --></td>
    </tr>
    <tr>
      <td class="texto1">Tamanho da Fonte:</td>
      <td colspan="2"><!--#include file="../includes/inc_cmbTamanhoFonteArial.asp"--></td>
    </tr>
    <tr>
      <td colspan="3">
      <%
	  	IF intCodCurso = "" THEN intCodCurso = 0
		 sql="SELECT DISTINCT TA.BIMESTRE, TAA.DESCRICAO AS AGRUPAMENTO"
             sql=sql & " FROM SCA_TIPO_AVALIACAO_Planilha TA"
             sql=sql & " INNER JOIN SCA_TIPO_AVALIACAO_AGRUPAMENTO TAA ON TAA.CODIGO = TA.BIMESTRE"
             sql=sql & " WHERE	TA.COD_EMPRESA = " & Session("CodEmpresa") 
             sql=sql & " AND	TA.COD_CURSO = " & intCodCurso
             sql=sql & " AND	TA.digitar = 'S'"
             sql=sql & " ORDER BY TA.BIMESTRE"
		     rs.open sql, cnn
             intCont = 0
             if rs.eof = false then
                %>
                <table width="100%" border="0" cellspacing="0" cellpadding="0">
                <tr>
                <td width="14%" class="texto1"><strong>Avaliação</strong></td>
                <td width="86%" class="texto1"><strong></strong></td>
                </tr>
                <%
                while not rs.eof
                   if trim(rs("bimestre")) = "1" or trim(rs("bimestre")) = "2" or trim(rs("bimestre")) = "3" or trim(rs("bimestre")) = "4" then
                      strBim = trim(rs("bimestre")) & "º Bimestre"
                   else
                      strBim = trim(rs("AGRUPAMENTO"))
                   end if
                %>
                <tr>
                <td class="texto1"></td>
                <td class="texto1"><input type="radio" name="chkTipoNota" value="<%=rs("bimestre")%>" <%if strTipoNota = trim(rs("bimestre")) then response.Write("checked")%> ><%=rs("AGRUPAMENTO")%></td>
                </tr>
                <%					
                rs.movenext
                wend
                %>
                </table>
                <%
             end if
             rs.close
		%>      </td>
    </tr>
    
    <tr>
      <td colspan="3"><hr size="1" color="#CCCCCC"></td>
    </tr>
	<tr>
      <td colspan="3" class="texto1">* Melhor visualização e impressão no formato paisagem.</td>
    </tr>
	<tr>
      <td colspan="3" class="texto1">&nbsp;</td>
    </tr>
    <tr>
      <td colspan="3"><!--#include file="../../includes/inc_botoes_geraRelatorio.asp"-->&nbsp;</td>
    </tr>
  </table>
</form>
<!--#include file="../rodape.asp"-->
</body>
</html>
