<!--
	::	DESENVOLVIDO POR "RS SOLUÇÕES WEB - www.rssolucoesweb.com.br"
	::	Data de Criação...: 14/09/2007
	::	Desenvolvedores...: Sergio Borges - sergiob76@hotmail.com
	::	Objetivo Pagina...: Consulta de Aluno 
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
	function resultadoConsulta(intCodigo, strMatricula, Nome){
	
			window.opener.document.getElementById('txtCodAluno').value = intCodigo;
			window.opener.document.getElementById('txtMatricula').value =  strMatricula; 
			window.opener.document.getElementById('txtNomealuno').value =  Nome; 
			window.opener.document.getElementById('frm').submit();
			window.close();
	}
</script>
<%
	strAluno				= Trim(Request("txtAluno"))
	strMatricula			= Trim(Request("txtMatricula"))
	strcpf					= Trim(Request("txtcpf"))
	strConsultar			= Trim(Request("strConsultar"))
	strMostraTurmas			= Trim(Request.Form("MostraTurmas"))
%>
<form method="POST" id="frm" action="#">
<input name="strConsultar" type="hidden" value="S">
  <table width="100%" align="left" class="CorFundo" >
    <tr>
      <td width="486" height="85" align="center">
	  <table width="486" border="0" cellspacing="0" cellpadding="0">
          <tr>
            <td colspan="2" align="center" class="tituloPrincipal">Consulta Aluno </td>
          </tr>
          <tr>
            <td width="125">&nbsp;</td>
            <td width="352">&nbsp;</td>
          </tr>
          <tr>
            <td height="28"><span class="TextoForm">Matr&iacute;cula: </span></td>
            <td><span class="texto1">
              <input name="txtMatricula" type="text" class="text" id="txtMatricula" size="15" maxlength="20" value="<%=strMatricula%>"  onKeyPress="return formataCampo(this, 2, 10)">
            </span></td>
          </tr>
          <tr>
            <td height="28"><span class="TextoForm">Nome:   </span></td>
            <td><input name="txtAluno" type="text" class="text" id="txtAluno" size="50" maxlength="50" value="<%=strAluno%>" /></td>
          </tr>
          <tr>
            <td height="28"><span class="TextoForm">C.p.f:</span></td>
            <td><span class="texto1">
              <input name="txtcpf" type="text" class="text" id="txtMatricula2" size="15" maxlength="15" value="<%=strcpf%>"  onKeyPress="return formataCampo(this, 5, 15)">
            </span></td>
          </tr>
          <tr>
            <td height="28"><span class="TextoForm">Visualizar Turma? </span></td>
            <td><input type="checkbox" name="MostraTurmas" value="S" onClick="this.submit()"></td>
          </tr>
          <tr>
            <td colspan="2"><!--#include file="../../includes/inc_botoes_consultaPopap.asp"--></td>
          </tr>
        </table>
		<br>
		<table width = "521" border="1" align="center" cellpadding="0" cellspacing="0" bordercolor="#CCCCCC" class="tabela">
		  <tr bgcolor="#E5E5E5">
			<td class="TextoForm"><strong>Matr&iacute;c.</strong></td>
			<td width="49%" bgcolor="#E5E5E5" class="TextoForm"><strong>Nom</strong><strong>e do Aluno </strong></td>
			<%if strMostraTurmas = "S" then %>
			 	<td width="17%" bgcolor="#E5E5E5" class="TextoForm"><strong>Turma</strong></td>
			<%end if%>	 
		    <td width="19%" bgcolor="#E5E5E5" class="TextoForm"><strong>Situa&ccedil;&atilde;o</strong></td>
		  </tr>
		  <%
			cont =0
			strCpf 		= replace(replace(strCpf,".",""),"-","")

			if strConsultar <> "" then
				sql = "SELECT "
				sql = sql & "     A.CODIGO,"
				sql = sql & "     A.MATRICULA,"
				sql = sql & "     A.NOMEALUNO,"
				sql = sql & "     CC.COD_EMPRESA,"
				sql = sql & "     A.DATAMATRICULA,"
				sql = sql & "     SA.DESC_SITUACAOALUNO,"
				sql = sql & "     CC.ANO_LETIVO,"
				sql = sql & "     A.DATAFASTAMENTO,"
				sql = sql & "     CC.UNIDADE"
				sql = sql & " FROM SCA_ALUNO A"
				sql = sql & " OUTER APPLY ("
				sql = sql & "     SELECT TOP 1"
				sql = sql & "         C.COD_EMPRESA,"
				sql = sql & "         C.COD_SITUACAOALUNO,"
				sql = sql & "         E.RAZAOSOCIAL AS UNIDADE, C.ANO_LETIVO"
				sql = sql & "     FROM SCA_CONTROLE_SITUACAO_ALUNO C"
				sql = sql & "     INNER JOIN SEG_EMPRESA E ON E.CODIGO = C.COD_EMPRESA"
				sql = sql & "     WHERE "
				sql = sql & "         C.COD_ALUNO = A.CODIGO"
				sql = sql & "         AND C.ANO_LETIVO <= " & trim(session("strAnoLetivo"))
				sql = sql & "         AND C.COD_EMPRESA = " & trim(Session("CodEmpresa"))
				sql = sql & "     ORDER BY C.CODIGO DESC"
				sql = sql & " ) CC"
				sql = sql & " left JOIN SCA_SITUACAOALUNO SA "
				sql = sql & "     ON SA.Cod_SituacaoAluno = CC.COD_SITUACAOALUNO"
				sql = sql & " where 1=1"
				sql = sql & "         AND CC.COD_EMPRESA = " & trim(Session("CodEmpresa"))
				if strMatricula <> "" then
					sql = sql & " and A.MATRICULA = '" & strMatricula & "'"
				end if
				if strcpf <> "" then
					sql = sql & " and A.CPF = '" & strcpf & "'"
				end if
				if strAluno <> "" then
					sql = sql & " and A.NOMEALUNO COLLATE Latin1_General_CI_AI  LIKE '%" & strAluno & "%'"
				end if
				sql = sql & " order by A.NOMEALUNO "
				rs.open sql, cnn
				if rs.eof = false then
					while not rs.eof
						cont = cont + 1
						if strMostraTurmas = "S" then
							strNometurma = ""
							sql = "SELECT TOP 1 AT.COD_TURMA,  T.NOMETURMA FROM SCA_ALUNO_TURMA AT "
							sql = sql & " INNER JOIN SCA_TURMA T ON T.COD_TURMA = AT.COD_TURMA AND T.COD_EMPRESA = AT.COD_EMPRESA "
							sql = sql & " WHERE COD_ALUNO = " & rs("CODIGO")
							sql = sql & " ORDER BY AT.codigo DESC "
							rsaux.open sql, cnn
							if rsaux.eof = false then
								strNometurma = rsaux("NOMETURMA")
							end if	
							rsaux.close	
						end if	
						%>
						 
						  <tr bgcolor="#FFFFFF"  style="cursor:hand" onMouseOver="return linhaMouseOver(this)" onMouseOut="return linhaMouseOut(this)"  onClick="return resultadoConsulta('<%=rs("CODIGO")%>','<%=rs("MATRICULA")%>','<%=rs("NOMEALUNO")%>')">
							<td width="15%" height="26" class="Texto">&nbsp;<%=trim(rs("MATRICULA"))%></td>
							<td class="Texto">&nbsp;<%=trim(rs("NOMEALUNO"))%>&nbsp;</td>
							<%if strMostraTurmas = "S" then %>
						         <td class="Texto"><%=strNometurma%>&nbsp;</td>
							<%end if%>	 
						    <td class="Texto"><%=trim(rs("DESC_SITUACAOALUNO"))%>&nbsp;</td>
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
			end if
			%>
	</table>
	</td> 
    </tr>
  </table>
</form>
</body>
</html>