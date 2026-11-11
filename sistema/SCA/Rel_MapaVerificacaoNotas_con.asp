<!--
	::	DESENVOLVIDO POR "RS SOLUÇÕES WEB - www.rssolucoesweb.com.br"
	::	Data de Criação...: 19/07/2011
	::	Desenvolvedores...: Roberto Barbosa Silva - roberto@rssolucoesweb.com.br
	::	Objetivo Pagina...: Mapa Verificação de Notas
    ::	Obs...............: Hoje Aniversario do meu filho gustavo
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
				
		frm.action = "Rel_MapaVerificacaoNotas_rel.asp";
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
	strPaginaTitulo 		  = "Rel_MapaVerificacaoNotas_con.asp"
	strExecutarSubmitCurso	  = "S"
	strExecutarSubmitPeriodo  = "S"
	strExecutarSubmitSemestre = "S"
	strExecutarSubmitTurno	  = "S"
	strEmpresaGrupo_submit    = "S"
	
	intCodEmpresaGrupo		    = Trim(Request.Form("cmbEmpresaGrupo"))
	strAnoLetivo 				= Trim(Request.Form("txtAnoLetivo"))
	intSemestre 				= Trim(Request.Form("cmbSemestre"))
	intCodCurso	 				= Trim(Request.Form("cmbCurso"))
	intCodDisciplinaCurso		= Trim(Request.Form("cmbDisciplinaCurso"))
	strTipoNota	 				= Trim(Request.Form("chkTipoNota"))

	if strAnoLetivo = "" then 	strAnoLetivo = session("strAnoLetivo")
	if intSemestre = "" then 	intSemestre  = session("strSemestre")

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
		  <td align="center" class="tituloSistema"><%=carregaTituloPaginaASP(strPaginaTitulo)%></td>
		</tr>
	<tr valign="top">
	<td align="center">
	<br>
	<table width="98%" border="0" align="center" cellpadding="0" cellspacing="2" class="Formulario">
	  
	  <tr>
	    <td class="texto1">Unidade:</td>
	    <td> <!--#include file="../includes/inc_cmbEmpresaGrupo.asp"--></td>
	    </tr>
	  <tr>
        <td width="13%" class="texto1">Ano Letivo:</td>
	    <td width="87%"><input  name="txtAnoLetivo" type="text" class="text" id="txtAnoLetivo" onBlur="submit()"  value="<%=strAnoLetivo%>" size="5" maxlength="5" onKeyPress="return formataCampo(this,2,10)"></td>
	    </tr>
	  <tr>
	    <td class="texto1">Semestre:</td>
	    <td><!--#include file="../includes/inc_cmdSemestre.asp" --></td>
	    </tr>
	  <tr>
	    <td class="texto1">Curso:</td>
	    <td><span class="texto1">
	      <!--#include file="../includes/inc_cmdCurso.asp"-->
	    </span></td>
	    </tr>
	  <tr>
	    <td class="texto1">Disciplina:</td>
	    <td><!--#include file="../includes/inc_cmbDisciplinaCurso.asp"--></td>
	    </tr>
	  <tr>
	    <td class="texto1">&nbsp;</td>
	    <td>&nbsp;</td>
	    </tr>
        <%IF intCodCurso <> "0" THEN%>
	  	<tr>
	    <td class="texto1">Crit&eacute;rio:</td>
	    <td>
         <%end if%>
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
            <tr bgcolor="#CCCCCC">
              <td height="19" class="texto1"><strong>Bimestre</strong></td>
              <td class="texto1"><strong>Avalia&ccedil;&atilde;o</strong></td>
            </tr>
            <%
			while not rs.eof
			
			   if trim(rs("bimestre")) = "1" or trim(rs("bimestre")) = "2" or trim(rs("bimestre")) = "3" or trim(rs("bimestre")) = "4" then
				  strBim = trim(rs("bimestre")) & "&ordm; Bimestre"
			   else
				  strBim = trim(rs("AGRUPAMENTO"))
			   end if
				%>
				<tr>
				  <td class="texto1"><%=strBim%></td>
				  <td class="texto1"><input type="radio" name="chkTipoNota" value="<%=rs("codigo")%>">
					<%=rs("descricao")%></td>
				</tr>
				<%					
			rs.movenext
			wend
			%>
          </table>
          <%
	 end if
	 rs.close
	 %>
     </td>
	    </tr>
	  <tr>
	    <td colspan="2" align="center" class="texto1">&nbsp;</td>
	    </tr>
    <tr>
      <td colspan="2"><hr size="1" color="#CCCCCC"></td>
    </tr>
    <tr>
      <td colspan="2"><!--#include file="../../includes/inc_botoes_geraRelatorio.asp"-->&nbsp;</td>
    </tr>
  </table>
<br>
<br>
</td>
</tr>
</table>
</form>
<!--#include file="../rodape.asp"-->
</body>
</html>
