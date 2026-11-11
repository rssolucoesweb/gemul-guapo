<%strNomeDaPaginaPortal = "Menu Principal"%>
<!--#include file="topo.asp"-->
<!--#include file="../../../includes/inc_cnn.asp"-->
<%
	'busca depto
	session("codDepartamentoAtual") = "0"
	if trim(session("strUsuario"))<>"" then
		'acessa o cadastra de senha
		sql = " SELECT cod_departamento"
		sql = sql & " FROM PRO_UsuarioDepartamento" 
		sql = sql & " WHERE cpf_SEG_usuarios = " & session("strUsuario")
		rs.open sql , cnn		
		if not rs.eof then	
			session("codDepartamentoAtual") = rs("cod_departamento")
		end if
		rs.close		
	end if		
%>
<table width="900" border="0" align="center" cellpadding="0" cellspacing="0">
  <tr>
    <td height="365" bgcolor="#FFFFFF">&nbsp;</td>
  </tr>
</table>
<!--#include file="rodape.asp"-->
</body>
</html>