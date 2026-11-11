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
		var caminho;
		caminho = "Rel_BolsistasDivulgacao_rel.asp"

		frm.action = caminho;
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
	strPaginaTitulo = "Rel_Bolsistas_con.asp"
	
	strExecutarSubmitCurso	  = "S"
	strExecutarSubmitPeriodo  = "S"
	strExecutarSubmitSemestre = "S"
	strExecutarSubmitTurno	  = "S"
	strExecutarSubmitTurma	  = "S"
	
	intCodTurma 			= Trim(Request.Form("cmbTurma"))
	if intCodTurma = "" then intCodTurma = 0
	intCodCurso	 			= Trim(Request.Form("cmbCurso"))
	intCodPeriodo 			= Trim(Request.Form("cmbPeriodo"))
	intCodGrade				= Trim(Request.Form("cmbGrade"))
	strSubTitulo 			= Trim(Request.Form("txtSubTitulo"))

	intCodTurno		 		= Trim(Request.Form("cmbTurno"))
	strAnoLetivo 			= Trim(Request.Form("txtAnoLetivo"))
	if strAnoLetivo			= "" then strAnoLetivo = session("strAnoLetivo")
	intSemestre 			= Trim(Request.Form("cmbSemestre"))

	if trim(intCodTurma) <> "0" then
		sql = "SELECT SCA_TURMA.cod_turma, SCA_TURMA.cod_Semestre ,SCA_TURMA.anoLetivo , SCA_PERIODO.Cod_Curso, SCA_PERIODO.Cod_Periodo, SCA_TURMA.cod_turno, SCA_TURMA.Sala, SCA_TURMA.NomeTurma"
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
			strAnoLetivo = rs("anoLetivo")
		END IF
		rs.close
	end if


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

%>
<form method="post" id="frm" action="#">
<input name="txtTipoRelatorio" type="hidden" value="<%=intTipoRelatorio%>">
<table width="100%" border="0" cellpadding="0" cellspacing="0">
            <tr valign="top">
              <td width="100%" align="center" class="tituloSistema"><%=carregaTituloPaginaASP(strPaginaTitulo)%></td>
            </tr>
  </table>
<br>
	<table width="98%" border="0" align="center" cellpadding="0" cellspacing="2" class="Formulario">
     <tr>
       <td class="texto1">Ano Letivo</td>
       <td><input  name="txtAnoLetivo" type="text" class="text" id="txtAnoLetivo" onBlur="submit()"  value="<%=strAnoLetivo%>" size="5" maxlength="5" onKeyPress="return formataCampo(this,2,10)"></td>
     </tr>
     <tr>
       <td class="texto1">Semestre</td>
       <td><!--#include file="../includes/inc_cmdSemestre.asp"--></td>
     </tr>
     <tr>
      <td width="12%" class="texto1">Curso</td>
      <td width="88%"><span class="texto1"><!--#include file="../includes/inc_cmdCurso.asp"--></span></td>
    </tr>
    <tr>
      <td class="texto1">Per&iacute;odo</td>
      <%
			 	if request.Form("txtHiddenStatus") <> "" then
				   strDesabilitaSerie = "disabled"
				end if
			 %>
      <td colspan="2"><!--#include file="../includes/inc_cmdPeriodo.asp"--></td>
    </tr>
    <tr>
      <td class="texto1">Turno</td>
      <td colspan="2"><!--#include file="../includes/inc_cmdTurno.asp"--></td>
    </tr>
    
    <tr>
      <td class="texto1">Turma</td>
      <td colspan="2"><!--#include file="../includes/inc_cmdTurma.asp"--></td>
    </tr>
       <tr>
         <td class="texto1">Cat. Desconto</td>
         <td colspan="2"><!--#include file="../includes/inc_cmdCategoriaDesconto.asp"--></td>
       </tr>
       <tr>
      <td class="texto1">Situa&ccedil;&atilde;o</td>
      <td colspan="2"><!--#include file="../includes/inc_cmdSituacaoAluno.asp"--></td>
    </tr>
    <tr>
      <td class="texto1">Sub-T&iacute;tulo (Opcional): </td>
      <td colspan="3"><input name="txtSubTitulo" type="text" class="text" id="txtSubTitulo" size="100" maxlength="100" value="<%=strSubTitulo%>">&nbsp;</td>
    </tr>
      <tr>
      <td class="texto1">Ordem</td>
      <td colspan="2">
	  <select name="cmbOrdem" class="Combo" id="cmbOrdem"  style="width:100pt" >
	  <option value="alfabetica" >Alfabetica</option>
	  <option value="matricula" >Matrícula</option>
	  <option value="datamatricula" >Data da Matricula</option>
	  <option value="dataafastamento" >Data de Afastamento</option>
	  <option value="idade" >Idade</option>
	  <option value="bairro" >Bairro</option>
	</select>	  </td>
    </tr>
    <tr>
      <td class="texto1">Quebra p&aacute;gina:</td>
      <td colspan="2"><select name="cmbQuebraPagina" class="Combo" id="cmbQuebraPagina"  style="width:100pt" >
        <option value="NORMAL" >Normal</option>
        <option value="TURMA" >Por Turma</option>
      </select></td>
    </tr>
    
    <tr>
      <td colspan="3"><hr size="1" color="#CCCCCC"></td>
    </tr>
    <tr>
      <td colspan="3"><!--#include file="../../includes/inc_botoes_geraRelatorio.asp"-->&nbsp;</td>
    </tr>
  </table>
</form>
<!--#include file="../rodape.asp"-->
</body>
</html>
