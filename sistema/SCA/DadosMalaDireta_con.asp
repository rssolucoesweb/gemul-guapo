<!--
	::	DESENVOLVIDO POR "RS SOLUÇÕES WEB - www.rssolucoesweb.com.br"
	::	Data de Criação...: 04/02/2009
	::	Desenvolvedores...: Sergio Borges - sergiob76@hotmail.com
	::	Objetivo Pagina...: gerar setransp
-->
<html>
<head>
<title><%=session("Titulo")%></title>
<link type="text/css" rel="stylesheet" href="../../Estilo/css.css"></head>
<body  leftmargin="0" topmargin="0" marginwidth="0" marginheight="0">
<script src="../../js/js_funcoes_gerais.js"></script>
<script type="text/javascript" src="../../js/js_dragdrop.js"></script>
<script>
	function gerar(){
		
		var frm = document.getElementById("frm");
		var caminho;
       	caminho = "DadosMalaDireta_cod.asp"
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
	strPaginaTitulo = "DadosMalaDireta_con.asp"
	strTextoBotaoRel = "Gerar Dados"
	
	strExecutarSubmitSemestre = "S"
	strExecutarSubmitCurso	  = "S"
	strExecutarSubmitPeriodo  = "S"
	strExecutarSubmitTurma	  = "S"
	
	if Trim(Request.Form("txtAnoLetivo")) = "" then 
	   intAnoLetivo 		= session("strAnoLetivo")
	else  
	   intAnoLetivo 		= Trim(Request.Form("txtAnoLetivo"))
	end if   
	if Trim(Request.Form("cmbSemestre")) = "" then
	   intSemestre          = session("strSemestre")
	else   
	   intSemestre 			= Trim(Request.Form("cmbSemestre"))
	end if   
	
	intCodCurso	 			= Trim(Request.Form("cmbCurso"))
	intCodPeriodo 			= Trim(Request.Form("cmbPeriodo"))
	intCodTurma 			= Trim(Request.Form("cmbTurma"))
	intCodSituacaoAluno		= Trim(Request.Form("cmbSituacaoAluno"))
    strOpcaoRelatorio		= Trim(Request.Form("optOpcao"))
	strMes					= Trim(Request.Form("cmbMes"))

	
	if trim(intCodTurma) <> "" then
		sql = "SELECT SCA_TURMA.cod_turma, SCA_TURMA.cod_Semestre , SCA_PERIODO.Cod_Curso, SCA_PERIODO.Cod_Periodo, SCA_TURMA.cod_turno, SCA_TURMA.Sala, SCA_TURMA.NomeTurma, SCA_TURMA.Anoletivo"
		sql = sql & " FROM SCA_TURMA "
		sql = sql & " INNER JOIN SCA_GRADECURRICULAR ON SCA_TURMA.Cod_GradeCurricular = SCA_GRADECURRICULAR.Cod_GradeCurricular "
		sql = sql & " INNER JOIN SCA_PERIODO ON SCA_GRADECURRICULAR.Cod_Periodo = SCA_PERIODO.Cod_Periodo"
		SQL = SQL & " WHERE SCA_TURMA.cod_empresa=" & Session("CodEmpresa")
		sql = sql & " AND SCA_TURMA.Cod_Turma= " & intCodTurma
		RS.OPEN SQL, CNN
		IF not RS.EOF THEN
			intCodCurso 	= rs("cod_curso")
			intCodPeriodo   = rs("cod_periodo")
			intSemestre     = rs("cod_Semestre")
		    intAnoLetivo    = rs("Anoletivo")
		END IF
		rs.close
	end if

	'controla os botões
	strDesabilitaIncluir = "disabled"
	strDesabilitaExcluir = "disabled"
	strDesabilitaAlterar = "disabled"
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
       <td class="texto1">Ano:</td>
       <td colspan="2"><input  name="txtAnoLetivo" type="text" class="text" id="txtAnoLetivo" onBlur="submit()"  value="<%=intAnoLetivo%>" size="5" maxlength="5" onKeyPress="return formataCampo(this,2,10)"></td>
       <td class="texto1"><div align="center">** Download ** </div></td>
     </tr>
     <tr>
       <td class="texto1">Semestre:</td>
       <td colspan="2"><!--#include file="../includes/inc_cmdSemestre.asp"--></td>
       <td class="texto1"><div align="center"><a href="http://www.pimaco.com.br/images/upload/downloads/APMaisV2.0.1-Windows.zip" target="_blank"><strong>PROGRAMA DE EMISS&Atilde;O DE ETIQUETAS </strong></a></div></td>
    </tr>
  
     <tr>
      <td width="12%" class="texto1">Curso:</td>
      <td colspan="2"><span class="texto1"><!--#include file="../includes/inc_cmdCurso.asp"--></span></td>
	   <td class="texto1"><div align="center"><a href="http://www.sisge.com.br/diversos/ET_ENDERECO.pds" target="_blank"></a></div></td>
     </tr>
    <tr>
      <td class="texto1">Per&iacute;odo:</td>
      <%
			 	if request.Form("txtHiddenStatus") <> "" then
				   strDesabilitaSerie = "disabled"
				end if
			 %>
      <td colspan="3"><!--#include file="../includes/inc_cmdPeriodo.asp"--></td>
    </tr>
    
    
    
    <tr>
      <td class="texto1">Turma:</td>
      <td colspan="3"><!--#include file="../includes/inc_cmdTurma.asp"--></td>
    </tr>
    <tr>
      <td class="texto1">Situa&ccedil;&atilde;o</td>
      <td colspan="3"><!--#include file="../includes/inc_cmdSituacaoAluno.asp"--></td>
    </tr>
    <tr>
      <td class="TEXTO1"><strong>Op&ccedil;&atilde;o de Relat&oacute;rio: </strong><br></td>
      <td width="30%" class="TEXTO1"><p><strong>
        <input <% if strOpcaoRelatorio = "0" then response.Write("checked")%> name="optOpcao" type="radio" value="0">
        Aniversariantes&nbsp;&nbsp;
        <!--#include file="../includes/inc_cmbMes.asp"--><!--#include file="../includes/inc_cmbIdade.asp"--><br>
        <input <% if strOpcaoRelatorio = "1" then response.Write("checked")%> name="optOpcao" type="radio" value="1">
      Inadiplentes no Sistema Financeiro </strong></p></td>
      <td width="29%" class="TEXTO1"><strong>
	    <input <% if strOpcaoRelatorio = "2" then response.Write("checked")%> name="optOpcao" type="radio" value="2"> 
	    Documenta&ccedil;&otilde;es Pendentes &nbsp;&nbsp;<br>
        <input <% if strOpcaoRelatorio = "3" then response.Write("checked")%> name="optOpcao" type="radio" value="3">
        Adplentes no Sistema Financeiro<br>
      <br></strong></td>
      <td width="29%" class="TEXTO1"><p><strong>
      <input <% if strOpcaoRelatorio = "4" then response.Write("checked")%> name="optOpcao" type="radio" value="4">
      Boletos de Matr&iacute;culas n&atilde;o Emitidos 
      </strong></p>      </td>
      </tr>
    <tr>
      <td colspan="4"><hr size="1" color="#CCCCCC"></td>
    </tr>
    
    <tr>
      <td class="TEXTO1" colspan="4">&nbsp;</td>
    </tr>
    <tr>
      <td class="TEXTO1" colspan="4">Obs: Os dados Gerados s&atilde;o texto &quot;CSV&quot; que dever&atilde;o ser carregado  e salvo como planilha  XLS.</td>
    </tr>
    <tr>
      <td colspan="4">&nbsp;</td>
    </tr>
    <tr>
      <td colspan="4"><!--#include file="../../includes/inc_botoes_geraRelatorio.asp"-->&nbsp;</td>
    </tr>
  </table>
</form>
<!--#include file="../rodape.asp"-->
</body>
</html>
