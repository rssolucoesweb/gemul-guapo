<html>
<head>
<title><%=session("Titulo")%></title>
<link href="../../estilo/css.css" rel="stylesheet" type="text/css">
</head>
<body>
<!--#include file="../../includes/inc_verificaLoginAluno.asp"-->
<!--#include file="topo.asp"-->
<!--#include file="../../includes/inc_cnnGedu.asp"-->
<!--#include file="../includes/inc_cmdVerificaAvaliacao.asp"-->
<script src="../../js/js_funcoes_gerais.js"></script>
<script>
	function Descricao(tipo){
		if (document.all["mostraDescricao"+tipo].style.display =="none"){
			document.all["mostraDescricao"+tipo].style.display="block";
			document.all["imgDescricao"+tipo].src="../../images/minus.bmp";
		}
		else{
			document.all["mostraDescricao"+tipo].style.display="none";
			document.all["imgDescricao"+tipo].src="../../images/plus.bmp";
		}
	}
</script>
<table width="100%" height="355" border="0" cellpadding="0" cellspacing="0"  bgcolor="#FFFFFF">
  <tr valign="top">
    <td align="center">
	<form method="post" id="frm">
    <br>
	  <table width="93%"  border="0" cellpadding="0" ce5llspacing="0">
	    <tr bgcolor="#CCCCCC">
	      <td height="19" colspan="2" align="center" class="texto1"><strong>Turma: <%=Session("NomeTurma")%></strong></td>
	      </tr>
	    <tr bgcolor="#CCCCCC">
	      <td height="19" colspan="2" align="center" class="texto1"> <strong>Material do Aluno</strong></td>
	      </tr>
	    <%
			sql = " SELECT distinct SCA_MaterialAluno.CodDisciplinaTurma, SCA_MaterialAluno.CodTurma,"
			sql = sql & " sca_Disciplina.Desc_Disciplina, SCA_MaterialAluno.data"
			sql = sql & " FROM SCA_MaterialAluno "
			sql = sql & " inner join sca_Disciplina on SCA_MaterialAluno.CodDisciplinaTurma = sca_Disciplina.Cod_Disciplina "
			sql = sql & " where SCA_MaterialAluno.Cod_empresa  = " & Session("CodEmpresa")
			sql = sql & " and SCA_MaterialAluno.CodTurma= " & Session("CodTurma")
			sql = sql & " order by data desc"

			rs.open sql,cnn
			if rs.eof = false then

			 while not rs.eof 
		 %>
	    <tr bgcolor="#CCCCCC">
	      <td width="4%" height="22" align="center" style="cursor:hand" onClick="return Descricao('<%=rs("CodDisciplinaTurma")%>')"><img id="imgDescricao<%=rs("CodDisciplinaTurma")%>" src="../../images/plus.bmp"></td>
	      <td width="96%" class="textoAtencao"><strong><%=rs("Desc_Disciplina")%></strong></td>
	      </tr>
	    <tr id="mostraDescricao<%=rs("CodDisciplinaTurma")%>" style="display:none">
	      <td height="72" colspan="2" align="center" bgcolor="#FFFF99" ><%
			
			sql = " SELECT Data, Descricao, NomeArquivo"
			sql = sql & " FROM SCA_MaterialAluno "
			sql = sql & " where SCA_MaterialAluno.Cod_empresa = " & Session("CodEmpresa")		
			sql = sql & " and CodTurma  = " & rs("CodTurma")
			sql = sql & " and CodDisciplinaTurma  = " & rs("CodDisciplinaTurma")	
			rsAux.open sql,cnn
		
			if rsAux.eof = false then
				
				while not rsAux.eof
	   			%>
	        <table width="97%" border="0" cellspacing="0" cellpadding="0">
	          <tr>
	            <td width="10%" height="9" class="texto1"><strong>Data :</strong></td>
	            <td width="90%" class="texto1"><%=rsAux("Data")%></td>
	            </tr>
	          <tr>
	            <td height="21" class="texto1"><strong>Descri&ccedil;&atilde;o :</strong></td>
	            <td class="texto1"><%=rsAux("Descricao")%></td>
	            </tr>
	          <tr>
	            <td height="41" class="texto1"><strong>Arquivo :</strong></td>
	            <td class="texto"><a href="http://www.sisge.com.br/materialaluno/<%=Session("CodEmpresa")%>/<%=rsAux("NomeArquivo")%>" target="_blank"><img src="../../images/pdf_icon.gif" border="0" width="30" height="30"></a></td>
	            </tr>
	          </table>
	        <br>
	        <%  				
				rsAux.movenext
				wend
			end if
			rsAux.close
			%></td>
	      </tr>
	    <%
			rs.movenext
			wend
		end if
		%>
	    </table>
	</form>
	</td>
  </tr>
</table>
<!--#include file="rodape.asp"-->
</body>
</html>