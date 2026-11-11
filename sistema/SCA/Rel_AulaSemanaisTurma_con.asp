
<!--
	::	DESENVOLVIDO POR "RS SOLUÇÕES WEB - www.rssolucoesweb.com.br"
	::	Data de Criação...: 13/02/2008
	::	Desenvolvedores...: Sergio Borges - sergiob76@hotmail.com
	::	Objetivo Pagina...: Extrato de NOtas
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
		var caminho;

		if (frm.txtAnoLetivo.value=="") {
			alert("Ano Letivo deve ser informado.");
			frm.txtAnoLetivo.focus();
			return false
		}
		if (frm.cmbSemestre.value=="0") {
			alert("Semestre deve ser informado.");
			frm.cmbSemestre.focus();
			return false
		}

		if (frm.cmbCurso.value == "0" && frm.cmbProfessor.value=="0"){
			alert("O Professor ou o curso devem ser informado!");
			frm.cmbCurso.focus();
			return false;
		}

		if (frm.txtOpt[0].checked==true) {
			caminho = 'Rel_AulaSemanaisTurma_rel.asp';
		}
		if (frm.txtOpt[1].checked==true) {
			caminho = 'Rel_AulaSemanaisTurmaExtra_rel.asp?';						
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
	strPaginaTitulo = "Rel_AulaSemanaisTurma_con.asp"
	
	strExecutarSubmitCurso	  = "S"
	strExecutarSubmitPeriodo  = "S"
	strExecutarSubmitTurno	  = "S"
	strExecutarSubmitTurma	  = "S"
	strExecutarSubmitGradeCurricular = "S"

	intAnoLetivo 			= Trim(Request.Form("txtAnoLetivo"))
	if intAnoLetivo = "" then 	intAnoLetivo 			= session("strAnoLetivo")
	strAnoLetivo 			= Trim(Request.Form("txtAnoLetivo"))
	if strAnoLetivo = "" then 	strAnoLetivo 			= session("strAnoLetivo")
	intSemestre 			= Trim(Request.Form("cmbSemestre"))
	if intSemestre = "" then 	intSemestre 			= session("strSemestre")
	
	intCodProfessor 	        = Trim(Request("cmbProfessor"))
	intCodColaboradorProfessor  = Trim(Request("cmbProfessor"))
	intCodTurmaProfessor 	    = Trim(Request("cmbTurmaProfessor"))
	strOpt 					= request("txtOpt")
	intCodigo	 			= Trim(Request.Form("txtCodigo"))
	intCodTurma 			= Trim(Request.Form("cmbTurma"))
	intCodCurso	 			= Trim(Request.Form("cmbCurso"))
	intCodPeriodo 			= Trim(Request.Form("cmbPeriodo"))
	intCodTurno		 		= Trim(Request.Form("cmbTurno"))
	intCodGrade				= Trim(Request.Form("cmbGrade"))
	intCodTurma				= intCodTurmaProfessor

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
	strExecutarSubmitProfessor  = "S"
	strFiltroSerie 			= "0"
	strFiltroTurno 			= "0"

	if intCodCurso 		= "" then intCodCurso 		= "0"
	if intCodSerie 		= "" then intCodSerie 		= "0"
	if intCodTurno 		= "" then intCodTurno 		= "0"
	if intCodTurma 		= "" then intCodTurma 		= "0"
	if intCodProfessor = "" then intCodProfessor = "0"
	if intCodTurmaProfessor = "" then intCodTurmaProfessor = "0"
	if intCodColaboradorProfessor = "" then intCodColaboradorProfessor = "0"
	
	IF intCodColaboradorProfessor <> "0" THEN
		intCodCurso 		= "0"
		intCodSerie 		= "0"
		intCodTurno 		= "0"
		intCodTurma 		= "0"
		intCodTurmaProfessor = "0"
	END IF
%>
<form method="post" id="frm" action="#">
<input name="txtTipoRelatorio" type="hidden" value="<%=intTipoRelatorio%>">
<table width="100%" height="355" border="0"  class="CorFundo" cellpadding="0" cellspacing="0">
		<tr valign="top">
		  <td  align="center" class="tituloSistema"><%=carregaTituloPaginaASP(strPaginaTitulo)%></td>
		</tr>
		<tr valign="top">
		  <td align="center">
<table width="98%" border="0" align="center" cellpadding="0" cellspacing="2" class="Formulario">
  <tr>
    <td width="16%" class="texto1">Ano Letivo: </td>
    <td><input name="txtAnoLetivo" type="text" class="text" id="txtAnoLetivo"  value="<%=intAnoLetivo%>" size="5" maxlength="4" onKeyPress="return formataCampo(this,2,4)"></td>
  </tr>
  <tr>
    <td class="texto1">Semestre:</td>
    <td><!--#include file="../includes/inc_cmdSemestre.asp" --></td>
  </tr>
  <tr>
    <td height="17" colspan="2" class="texto1"><hr size="1" color="#CCCCCC"></td>
    </tr>
  <tr>
    <td class="texto1">Professor</td>
    <td class="texto1"><!--#include file="../includes/inc_cmdProfessor.asp" -->&nbsp;</td>
  </tr>

  <tr>
    <td height="40" class="texto1">ou </td>
    <td class="texto1">&nbsp;</td>
    </tr>
  <tr>
    <td class="texto1">Curso: </td>
    <td class="texto1"><!--#include file="../includes/inc_cmdCurso.asp"--></td>
  </tr>
  <tr>
    <td class="texto1">Per&iacute;odo: </td>
    <td><!--#include file="../includes/inc_cmdPeriodo.asp"--></td>
  </tr>
  <tr>
    <td class="texto1">Grade:</td>
    <td><!--#include file="../includes/inc_cmdGradeCurricular.asp" --></td>
  </tr>
  <tr>
    <td class="texto1">Turno: </td>
    <td><!--#include file="../includes/inc_cmdTurno.asp"--></td>
  </tr>
  <tr>
    <td class="texto1">Turma: </td>
    <td><!--#include file="../includes/inc_cmdTurmaProfessor.asp"--></td>
  </tr>
  <tr>
    <td height="17" colspan="2" class="texto1"><hr size="1" color="#CCCCCC"></td>
    </tr>
  <tr>
    <td class="texto1">Opção de Relatório</td>
    <td class="texto1">

            	<input name="txtOpt" type="radio" class="radio" value="0" <% if strOpt = "" or strOpt = "0" then response.Write("checked")%> style="vertical-align: middle; margin: 5px;">Normal
                &nbsp;&nbsp;&nbsp;&nbsp;
                <input name="txtOpt" type="radio" class="radio" value="1" <% if strOpt = "1" then response.Write("checked")%> style="vertical-align: middle; margin: 5px;">Extra
               
           
    </td>
  </tr>
  <tr>
    <td class="texto1">Omitir Hor&aacute;rios?</td>
    <td><span class="texto1">
      <input type="checkbox" name="txtOmitirHorario" value="S">
    </span></td>
  </tr>

  <tr>
    <td class="texto1">&nbsp;</td>
    <td>&nbsp;</td>
  </tr>
</table>
<br>
	<table width="98%" border="0" align="center" cellpadding="0" cellspacing="2" class="Formulario">
    <tr>
      <td width="88%" colspan="2"><hr size="1" color="#CCCCCC"></td>
    </tr>
    <tr>
      <td colspan="2"><!--#include file="../../includes/inc_botoes_geraRelatorio.asp"-->&nbsp;</td>
    </tr>
  </table>
<br>		  </td>
		</tr>
  </table>

</form>
<!--#include file="../rodape.asp"-->
</body>
</html>
