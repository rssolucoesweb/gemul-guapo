<!--
	::	DESENVOLVIDO POR "RS SOLUÇÕES WEB - www.rssolucoesweb.com.br"
	::	Data de Criação...: 23/08/2007
	::	Desenvolvedores...: Roberto Barbosa Silva - robertobs7@gmail.com
	::	Objetivo Pagina...: Consulta Vestibular
-->
<html>
<head>
<title><%=session("Titulo")%></title>
<link href="../../estilo/css.css" rel="stylesheet" type="text/css">
<script type="text/JavaScript">
<!--
function MM_swapImgRestore() { //v3.0
  var i,x,a=document.MM_sr; for(i=0;a&&i<a.length&&(x=a[i])&&x.oSrc;i++) x.src=x.oSrc;
}
//-->
</script></head>
<body  leftmargin="0" topmargin="0" marginwidth="0" marginheight="0">
<!--#include file="../../includes/inc_verificaSession.asp"-->
<!--#include file="../../includes/inc_cnn.asp"-->
<!--#include file="../../includes/inc_formatadata.asp"-->
<script src="../../js/js_funcoes_gerais.js"></script>
<script>
   
	function resultadoConsulta(intCodigo){
		window.opener.document.getElementById('txtCodigo').value = intCodigo;
		window.opener.document.getElementById('frm').submit();
		window.close();

	}
	
</script>
<%
	
	strMostraBotaoConsultaRetornar	= "S"			
	strNomeAluno					= Trim(Request("txtNomeAluno"))
	intCodVestibular			    = Trim(Request.QueryString("cmbVestibular"))
	
%>
<form method="POST" id="frm" action="#">
<input type="hidden" name="cmbVestibular" value="<%=intCodVestibular%>">
  <table width="100%" align="center" class="CorFundo" >
    <tr>
      <td width="486" height="85" align="center">
	  <table width="500" border="0" align="center" cellspacing="0" cellpadding="0">
        <tr>
          <td colspan="2" align="center" class="tituloPrincipal">Consulta Vestibular Dados </td>
        </tr>
        <tr>
          <td width="105">&nbsp;</td>
          <td width="395">&nbsp;</td>
        </tr>
        <tr>
          <td height="28"><span class="TextoForm">Nome do Aluno: </span></td>
          <td><input name="txtNomeAluno" type="text" class="text" id="txtNomeAluno" size="50" maxlength="50" value="<%=strNomeAluno%>" /></td>
        </tr>
        <tr>
          <td>&nbsp;</td>
          <td>&nbsp;</td>
        </tr>
        <tr>
          <td colspan="2"><!--#include file="../../includes/inc_botoes_consulta.asp"--></td>
        </tr>
      </table>
        <br>
        <table width = "500" border="1" align="center" cellpadding="0" cellspacing="0" bordercolor="#CCCCCC" class="tabela">
          <tr bgcolor="#E5E5E5">
            <td class="TextoForm"><strong>C&oacute;d </strong></td>
            <td width="54%" bgcolor="#E5E5E5" class="TextoForm"><strong>Nom</strong><strong>e do Aluno </strong></td>
            <td width="16%" bgcolor="#E5E5E5" class="TextoForm"><strong>Identidade</strong></td>
            <td width="16%" bgcolor="#E5E5E5" class="TextoForm"><strong>Data Nasc.</strong></td>
          </tr>
          <%
		    cont =0
			sql = "SELECT Codigo, NomeAluno, Identidade, DataNascimento, Cod_Vestibular"
			sql = sql & " FROM SCA_VESTIBULAR_DADOS"
			sql = sql & " where cod_empresa = " & Session("CodEmpresa")		
			if strNomeAluno <> "" then
			   sql = sql & " and NomeAluno LIKE '" & strNomeAluno & "%'"
			end if
			sql = sql & " and Cod_Vestibular = " & intCodVestibular 
			sql = sql & " order by NomeAluno"
			
			rs.open sql, cnn
			if rs.eof = false then
				while not rs.eof
				cont = cont + 1	
			%>
          <tr bgcolor="#FFFFFF"  style="cursor:hand" onMouseOver="return linhaMouseOver(this)" onMouseOut="return linhaMouseOut(this)"  onClick="return resultadoConsulta('<%=rs("Codigo")%>')">
            <td width="14%" height="26" class="Texto">&nbsp;<%=trim(rs("Codigo"))%></td>
            <td class="Texto"><%=trim(rs("NomeAluno"))%></td>
            <td class="Texto"><%=trim(rs("Identidade"))%></td>
            <td class="Texto"><%=formataDataAp(trim(rs("DataNascimento")))%></td>
          </tr>
          <%				
			rs.movenext
			wend
		  %>
          <tr>
            <td height="21" colspan="6" class="celula"><span class="texto">Total Registros :</span> <%=cont%></td>
            <%
			end if
			rs.close
			%>
         </table></td> 
    </tr>
  </table>
</form>
</body>
</html>
