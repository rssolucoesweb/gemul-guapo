<!--
	::	DESENVOLVIDO POR "RS SOLUÇÕES WEB - www.rssolucoesweb.com.br"
	::	Data de Criação...: 13/02/2008
	::	Desenvolvedores...: Sergio Borges - sergiob76@hotmail.com
	::	Objetivo Pagina...: Extrato de NOtas
-->
<html>
<head>
<title><%=session("Titulo")%></title>
<link type="text/css" rel="stylesheet" href="../../Estilo/css.css"></head>
<body  leftmargin="0" topmargin="0" marginwidth="0" marginheight="0">
<script src="../../js/js_funcoes_gerais.js"></script>
<script type="text/javascript" src="../../js/js_dragdrop.js"></script>
<!--#include file="../../js/Calendario/Calendario.asp"-->
<script>
	function gerar(){
	
		var form = document.getElementById("frm");
		var intContMarcado=0;
		var data1 = frm.txtDataInicial.value;
		var data2 = frm.txtDataFinal.value;

		if (frm.txtDataInicial.value == "") {
			alert("A Data Inicial deve ser informada !");
			frm.txtDataInicial.focus();
			return false;
		}

		if (frm.txtDataFinal.value == "") {
			alert("A Data Final deve ser informada !");
			frm.txtDataFinal.focus();
			return false;
		}

		if ( parseInt( data2.split( "/" )[2].toString() + data2.split( "/" )[1].toString() + data2.split( "/" )[0].toString() ) < parseInt( data1.split( "/" )[2].toString() + data1.split( "/" )[1].toString() + data1.split( "/" )[0].toString() ) )
		{  
			alert("A Data Final e maior que a Data Inicial !");
			frm.txtDataFinal.focus();
			return false;
		}

		
		if (frm.cmbSemestre.value == 0){
			alert("O Semestre deve ser informado!");
			frm.cmbSemestre.focus();
			return false;
		}

		//*****verifica se o chkTipoNota foi selecionado
		intContMarcado==0
		for (var i = 0; i < form.elements.length; i++) {
			//verifica todos os checkbox
			if (form.elements[i].type == "radio"){
				if (form.elements[i].name == "chkTipoNota"){
					//verifica se o checkbox está marcado
					if (form.elements[i].checked){
						intContMarcado = intContMarcado + 1;
					}
				}
			}
		}
		
		if (intContMarcado==0){
			alert("A avaliação deve ser informada!");
			return false;
		}

		frm.action = "Rel_MapaRendimento_rel.asp";
		frm.submit();
		return true;	
	}	
</script>
<!--#include file="../../includes/inc_verificaSession.asp"-->
<!--#include file="../../includes/inc_cnn.asp"-->
<!--#include file=topo.asp-->
<!--#include file="../../includes/inc_formatadata.asp"-->
<!--#include file="../../js/Calendario/Calendario.asp"-->
<%
	strPaginaTitulo = "Rel_MapaRendimento_con.asp"

	strExecutarSubmitCurso	  = "S"
	strExecutarSubmitPeriodo  = "S"
	strExecutarSubmitSemestre = "S"
	strExecutarSubmitTurno	  = "S"
	
	strAnoLetivo 			= session("strAnoLetivo")
	intSemestre  			= session("strSemestre")
	intCodCurso	 			= Trim(Request.Form("cmbCurso"))
	intCodTurma 			= Trim(Request.Form("cmbTurma"))
	intCodSituacaoAluno     = Trim(Request.Form("cmbSituacaoAluno"))
	intSemestre 			= Trim(Request.Form("cmbSemestre"))
	strDataInicial  		= Trim(Request.Form("txtDataInicial"))
	strDataFinal  			= Trim(Request.Form("txtDataFinal"))
	strlpp 					= Trim(Request.Form("cmblpp"))
	strclasse               = Trim(Request.Form("cmbTamanhoFonteArial"))

	strFiltroSerie = "0"
	strFiltroTurno = "0"

	if intCodSemestre = "" then intCodSemestre = "0"

	'controla os botões
	strDesabilitaIncluir = "disabled"
	strDesabilitaExcluir = "disabled"
	strDesabilitaAlterar = ""
	strDesabilitaLimpar = ""

%>
<form method="post" id="frm" action="#">
<input name="txtTipoRelatorio" type="hidden" value="<%=intTipoRelatorio%>">
<table width="100%" height="355" border="0"  class="CorFundo" cellpadding="0" cellspacing="0">
		<tr valign="top">
		  <td width="700" align="center" class="tituloSistema"><%=carregaTituloPaginaASP(strPaginaTitulo)%></td>
		</tr>
		<tr valign="top">
		  <td align="center">
<br>
	<table width="98%" border="0" align="center" cellpadding="0" cellspacing="2" class="Formulario">
	  <tr>
        <td class="texto1">Ano Letivo:</td>
	    <td colspan="2"><input  name="txtAnoLetivo" type="text" class="text" id="txtAnoLetivo" onBlur="submit()"  value="<%=strAnoLetivo%>" size="5" maxlength="5" onKeyPress="return formataCampo(this,2,10)"></td>
	    </tr>
	  <tr>
        <td class="texto1">Semestre:</td>
	    <td colspan="2"><!--#include file="../includes/inc_cmdSemestre.asp" --></td>
	    </tr>
     <tr>
      <td width="16%" class="texto1">Curso:</td>
      <td width="84%"><span class="texto1">
        <!--#include file="../includes/inc_cmdCurso.asp"--></span></td>
    </tr>
     <tr>
       <td class="texto1">Turma:</td>
       <td colspan="2" class="texto1"><!--#include file="../includes/inc_cmdTurma.asp"--></td>
     </tr>
     <tr>
       <td class="texto1">Situa&ccedil;&atilde;o Acad&ecirc;mica:</td>
       <td colspan="2" class="texto1"><!--#include file="../includes/inc_cmdSituacaoAluno.asp"--></td>
     </tr>
     <tr>
      <td class="texto1">Per&iacute;odo de Apura&ccedil;&atilde;o:</td>
       <td colspan="2" class="texto1"><input name="txtDataInicial" type="text" class="text" id="txtDataInicial" onKeyPress="return formataCampo(this, 3, 10)" size="11" maxlength="10" value="<%=strDataInicial%>" onBlur='Submit()' title="Click aqui para visualizar o calend&aacute;rio">
 a
<input name="txtDataFinal" type="text" class="text" id="txtDataFinal"  onKeyPress="return formataCampo(this, 3, 10)" size="11" maxlength="10" value="<%=strDataFinal%>" onBlur='Submit()' title="Click aqui para visualizar o calend&aacute;rio"> </td>
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
      <td colspan="4" class="texto1">&nbsp;</td>
    </tr>
    <tr>
      <td colspan="4" class="texto1">
      
      
     <%IF intCodCurso = "" THEN intCodCurso = 0
 	 sql="SELECT DISTINCT TA.CODIGO, TA.DESCRICAO, TA.BIMESTRE, TAA.DESCRICAO AS AGRUPAMENTO"
	 sql=sql & " FROM SCA_CRITERIO_AVALIACAO CA"
	 sql=sql & " INNER JOIN SCA_AVALIACAO A ON A.CODCRITERIOAVALIACAO = CA.CODIGO AND A.COD_EMPRESA = CA.COD_EMPRESA"
	 sql=sql & " INNER JOIN SCA_TIPO_AVALIACAO TA ON A.CODTIPOAVALIACAO = TA.CODIGO AND A.COD_EMPRESA = TA.COD_EMPRESA AND CA.COD_CURSO = TA.COD_CURSO"
	 sql=sql & " INNER JOIN SCA_TIPO_AVALIACAO_AGRUPAMENTO TAA ON TAA.CODIGO = TA.BIMESTRE"
	 sql=sql & " WHERE	CA.COD_EMPRESA = " & Session("CodEmpresa") 
	 sql=sql & " AND		CA.COD_CURSO = " & intCodCurso
	 sql=sql & " AND		TA.digitar = 'S'"
	 sql=sql & " ORDER BY TA.BIMESTRE"
	 rs.open sql, cnn
	 intCont = 0
	 if rs.eof = false then
	 	%>
		<table width="50%" border="0" cellspacing="0" cellpadding="0">
	    <tr>
		<td class="texto1"><strong>Avaliação</strong></td>
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
		<td class="texto1"><input type="radio" name="chkTipoNota" value="<%=rs("codigo")%>"><%=rs("descricao")%></td>
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
      <td colspan="3"><!--#include file="../../includes/inc_botoes_geraRelatorio.asp"-->&nbsp;</td>
    </tr>
  </table>
<br>
<br>		  </td>
		</tr>
  </table>

</form>
<!--#include file="../rodape.asp"-->
</body>
</html>
