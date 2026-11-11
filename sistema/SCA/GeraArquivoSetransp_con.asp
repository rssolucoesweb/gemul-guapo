<!--
	::	DESENVOLVIDO POR "RS SOLUÇÕES WEB - www.rssolucoesweb.com.br"
	::	Data de Criação...: 04/02/2009
	::	Desenvolvedores...: Sergio Borges - sergiob76@hotmail.com
	::	Objetivo Pagina...: gerar setransp
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
		
		var caminho;
		var frm = document.getElementById("frm");
		
		if (frm.optOpcao[0].checked==false && frm.optOpcao[1].checked==false) {
			alert("Opção (gerar relatorio ou arquivo) deve ser informada !");
			frm.optOpcao[0].focus();
			return false;
		}	
		
		if (frm.optOpcao[0].checked) {
			caminho = "GeraArquivoSetransp_rel.asp"
		}	
		
		if (frm.optOpcao[1].checked) {
			caminho = "GeraArquivoSetransp_cod.asp"
		}	

		frm.action = caminho;
		frm.submit();
		return true;	
	}	
</script>
<!--#include file="../../includes/inc_verificaSession.asp"-->
<!--#include file="../../includes/inc_cnn.asp"-->
<!--#include file=topo.asp-->
<!--#include file="../../includes/inc_formatadata.asp"-->
<%
	strPaginaTitulo = "GeraArquivoSetransp_con.asp"
	strTextoBotaoRel = " ou Arquivo"
	
	strExecutarSubmitCurso	  = "S"
	strExecutarSubmitPeriodo  = "S"
	strExecutarSubmitSemestre = "S"
	strExecutarSubmitTurno	  = "S"
	strExecutarSubmitTurma	  = "S"
	
	intCodTurma 			= Trim(Request.Form("cmbTurma"))
	intCodCurso	 			= Trim(Request.Form("cmbCurso"))
	intCodPeriodo 			= Trim(Request.Form("cmbPeriodo"))
	intSemestre 			= Trim(Request.Form("cmbSemestre"))
	intCodGrade				= Trim(Request.Form("cmbGrade"))
	strSexo					= Trim(Request.Form("cmbSexo"))
	strSimouNao			    = Trim(Request.Form("cmbSimouNao"))

	intCodTurno		 		= Trim(Request.Form("cmbTurno"))
	intCodPlanoPagamento	= Trim(Request.Form("cmbPlanoPagamento"))
	strSala		 			= Trim(Request.Form("txtSala"))
	intAno		 			= Trim(Request.Form("txtAno"))
	intAnoLetivo 			= Trim(Request.Form("txtAnoLetivo"))

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

	strOpcaoRelatorio		= Trim(Request.Form("optOpcao"))

	strFiltroSerie = "0"
	strFiltroTurno = "0"

	if strSexo = "" then strSexo = "0"
	if intCodComp = "" then intCodComp = "0"
	if intCodSerie = "" then intCodSerie = "0"
	if intCodTurno = "" then intCodTurno = "0"
	if intCodTurma = "" then intCodTurma = "0"
	if intCodSemestre = "" then intCodSemestre = "0"
	if intCodTipoLancamento = "" then intCodTipoLancamento = "0"
	if intCodDisciplinaTurma = "" then intCodDisciplinaTurma = "0"
	if intCodNota = "" then intCodNota="0"

	'controla os botões
	strDesabilitaIncluir = "disabled"
	strDesabilitaExcluir = "disabled"
	strDesabilitaAlterar = ""
	strDesabilitaLimpar = ""

%>
<form method="post" id="frm" action="#">
<input name="txtTipoRelatorio" type="hidden" value="<%=intTipoRelatorio%>">
<table width="708" border="0" cellpadding="0" cellspacing="0">
            <tr valign="top">
              <td width="700" align="center" class="tituloSistema"><%=carregaTituloPaginaASP(strPaginaTitulo)%></td>
            </tr>
  </table>
<br>
	<table width="98%" border="0" align="center" cellpadding="0" cellspacing="2" class="Formulario">
     <tr>
       <td class="texto1"><strong>Op&ccedil;&atilde;o: </strong></td>
      <td width="36%" class="texto1"><strong>
         <input <% if strOpcaoRelatorio = "0" then response.Write("checked")%> name="optOpcao" type="radio" value="0">
         Gerar Relat&oacute;rio&nbsp;&nbsp;&nbsp;&nbsp; <br>
  		 <input <% if strOpcaoRelatorio = "1" then response.Write("checked")%> name="optOpcao" type="radio" value="1">
         Gerar Arquivo<br>
       </strong></td>
       <td width="52%" class="texto1" valign="top">&nbsp;</td>
     </tr>
     <tr>
      <td width="12%" class="texto1">Curso</td>
      <td colspan="2"><span class="texto1"><!--#include file="../includes/inc_cmdCurso.asp"--></span></td>
    </tr>
    <tr>
      <td class="texto1">Per&iacute;odo</td>
      <%
			 	if request.Form("txtHiddenStatus") <> "" then
				   strDesabilitaSerie = "disabled"
				end if
			 %>
      <td colspan="3"><!--#include file="../includes/inc_cmdPeriodo.asp"--></td>
    </tr>
    <tr>
      <td class="texto1">Semestre</td>
      <td colspan="3"><!--#include file="../includes/inc_cmdSemestre.asp"--></td>
    </tr>
    <tr>
      <td class="texto1">Turno</td>
      <td colspan="3"><!--#include file="../includes/inc_cmdTurno.asp"--></td>
    </tr>
    
    <tr>
      <td class="texto1">Turma</td>
      <td colspan="3"><!--#include file="../includes/inc_cmdTurma.asp"--></td>
    </tr>
    <tr>
      <td class="texto1">Situa&ccedil;&atilde;o</td>
      <td colspan="3"><!--#include file="../includes/inc_cmdSituacaoAluno.asp"--></td>
    </tr>
    <tr>
	<tr>
      <td class="texto1">C&oacute;digo do Setransp </td>
      <td colspan="3"><!--#include file="../includes/inc_cmbSimouNao.asp"--></td>
    </tr>
      <td colspan="4" class="TEXTO1"><br>
      Obs: Melhor impressão na orientação do papel em paisagem.<br></td>
    </tr>
    <tr>
      <td colspan="4"><hr size="1" color="#CCCCCC"></td>
    </tr>
    <tr>
      <td colspan="4"><!--#include file="../../includes/inc_botoes_geraRelatorio.asp"-->&nbsp;</td>
    </tr>
  </table>
</form>
<!--#include file="../rodape.asp"-->
</body>
</html>
