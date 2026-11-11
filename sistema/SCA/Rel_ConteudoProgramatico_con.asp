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
		
		if (frm.cmbSemestre.value == "0") {
			alert("O Semestre deve ser informado !");
			frm.cmbSemestre.focus();
			return false;
		}
		
		if (frm.txtDataInicial.value == "") {
			alert("A Data Inicial deve ser Informada !");
			frm.txtDataInicial.focus();
			return false;
		}

		if (frm.txtDataFinal.value == "") {
			alert("A Data Final deve ser Informada !");
			frm.txtDataFinal.focus();
			return false;
		}

		frm.action = "Rel_ConteudoProgramatico_rel.asp";
		frm.submit();
		
		return true;	
	}	
</script>
<!--#include file="../../includes/inc_verificaSession.asp"-->
<!--#include file="../../includes/inc_cnn.asp"-->
<!--#include file=topo.asp-->
<!--#include file="../../includes/inc_formatadata.asp"-->
<%
	strPaginaTitulo = "Rel_ConteudoProgramatico_con.asp"

	strExecutarSubmitSemestre 				= "S"
	strExecutarSubmitCurso	  				= "S"
	strExecutarSubmitPeriodo  				= "S"
	strExecutarSubmitProfessor				= "S"
	strExecutarSubmitTurma	  				= "S"
	strExecutarSubmitDisciplinaDoProfessor  = "S"

	if trim(request("txtAnoLetivo")) = "" then 
		strAnoLetivo = session("strAnoLetivo")
		intAnoLetivo = session("strAnoLetivo")
	else
		strAnoLetivo = request.Form("txtAnoLetivo")
		intAnoLetivo = request.Form("txtAnoLetivo")
	end if
	if trim(request("cmbSemestre")) = "0" or trim(request("cmbSemestre")) = ""  then 
		intSemestre = session("strSemestre")
	    strSemestre = session("strSemestre")
	else
		intSemestre = request.Form("cmbSemestre")
	    strSemestre = request.Form("cmbSemestre")
	end if
	
	intCodCurso	 			= Trim(Request("cmbCurso"))
	intCodPeriodo 			= Trim(Request("cmbPeriodo"))
	intCodDisciplina		= Trim(Request("cmbDisciplinaDoProfessor"))
	intCodDisciplinaTurma	= Trim(Request("cmbDisciplinaDoProfessor"))

	intCodTurma				= Trim(Request("cmbTurmaProfessor"))
	intCodTurmaProfessor	= Trim(Request("cmbTurmaProfessor"))
	
    intCodColaboradorProfessor 	= Trim(Request("cmbProfessor"))
	intCodProfessor 	        = Trim(Request("cmbProfessor"))

	strDataInicial         		= Trim(Request("txtDataInicial"))
	strDataFinal            	= Trim(Request("txtDataFinal"))
	intCodEstagio     			= Trim(Request.Form("cmbEstagio"))
	strlpp 					= Trim(Request.Form("cmblpp"))
	strclasse               = Trim(Request.Form("cmbTamanhoFonteArial"))

   	if intCodComp = "" then intCodComp = "0"
	if intCodColaboradorProfessor = "" then intCodColaboradorProfessor = "0"
	if intCodTurma = "" then intCodTurma = "0"
	'if intCodDisciplina= "" then intCodDisciplina = "0"


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

	'controla os botões
	strDesabilitaIncluir 	= "disabled"
	strDesabilitaExcluir 	= "disabled"
	strDesabilitaAlterar 	= "disabled"
	strDesabilitaLimpar 	= ""

%>
<form method="post" id="frm" action="#">
<input name="txtAno" type="hidden" value="<%=intAnoLetivo%>">
<input name="txtSemestre" type="hidden" value="<%=intSemestre%>">
<table width="100%" border="0" cellpadding="0" cellspacing="0">
            <tr valign="top">
              <td align="center" class="tituloSistema"><%=carregaTituloPaginaASP(strPaginaTitulo)%></td>
            </tr>
  </table>
<br>
	<table width="98%" border="0" align="center" cellpadding="0" cellspacing="2" class="Formulario">
     
              <tr>
            <td width="146" class="texto1">Ano Letivo:</td>
            <td width="832"><input  name="txtAnoLetivo" type="text" class="text" id="txtAnoLetivo" onBlur="submit()"  value="<%=strAnoLetivo%>" size="5" maxlength="5" onKeyPress="return formataCampo(this,2,10)"></td>
          </tr>
          <tr>
            <td class="texto1">Semestre:</td>
            <td><!--#include file="../includes/inc_cmdSemestre.asp" --></td>
          </tr>
        </tr>
          <tr>
            <td class="texto1">Professor:</td>
            <td><!--#include file="../includes/inc_cmdProfessorConteudoRel.asp" --></td>
          </tr>
        <tr>
        <td width="9%" class="texto1">Curso:</td>
        <td><span class="texto1">
        <!--#include file="../includes/inc_cmdCursoConteudoRel.asp"-->
        - Opcional</span></td>
        </tr>
        <tr>
        <td class="texto1">Per&iacute;odo/Módulo:</td>
        <td colspan="3" class="texto1"><!--#include file="../includes/inc_cmdPeriodoConteudoRel.asp"-->
        <span class="texto1">- Opcional</span></td>
            <tr>
              <td width="14%" class="texto1">Turma</td>
                <td>
                    <!--#include file="../includes/inc_cmdTurmaConteudoRel.asp"-->
                </td>
            </tr>
        <tr>
          <td class="texto1">Disciplina</td>
            <td>
                    <!--#include file="../includes/inc_cmdDisciplinaConteudoRel.asp"-->			  
              </td>
        </tr>
           <tr>
           <td class="texto1">Est&aacute;gio: </td>
           <td class="texto1"><!--#include file="../includes/inc_cmdEstagio.asp"--></td>
           </tr>
           <tr>
            <td><span class="texto1">Data/Per&iacute;odo:</span></td>
            <td><span class="texto1">
              <input name="txtDataInicial" type="text" class="text" id="txtDataInicial" onBlur="return validaData(this); submit();" onKeyPress="return formataCampo(this, 3, 10)" size="11" maxlength="10" value="<%=strDataInicial%>">
              a
              <input name="txtDataFinal" type="text" class="text" id="txtDataFinal" onBlur="return validaData(this); submit();" onKeyPress="return formataCampo(this, 3, 10)" size="11" maxlength="10" value="<%=strDataFinal%>">
            </span></td>
          </tr>
            <tr>
              <td class="texto1">Linhas por P&aacute;gina: </td>
              <td colspan="3"><!--#include file="../includes/inc_cmbLinhaPorPagina.asp"--></td>
            </tr>
            <tr>
              <td class="texto1">Tamanho da Fonte:</td>
              <td colspan="3"><!--#include file="../includes/inc_cmbTamanhoFonteArial.asp"--></td>
            </tr>
          <tr>
            <td colspan="2"  class="texto1">&nbsp;</td>
          </tr>
    <tr>
      <td colspan="3"><!--#include file="../../includes/inc_botoes_geraRelatorio.asp"-->&nbsp;</td>
    </tr>
  </table>
</form>
<!--#include file="../rodape.asp"-->
</body>
</html>
