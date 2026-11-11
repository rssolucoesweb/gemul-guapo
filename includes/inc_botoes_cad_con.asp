<% if session("UsuarioWeb") = "USUARIO.TESTE" then
	strDesabilitaIncluir = " Disabled "
	strDesabilitaAlterar = " Disabled "
	strDesabilitaExcluir = " Disabled "
end if
%>
<table width="100%" border="0" cellspacing="0" cellpadding="0">
    <tr>
        <td>
		<input type="button" name="cmdConsultar" style="cursor:hand"   value="Consultar" class="btn btn-u btn-u-blue float-shadow" onclick="submit()">
		<input type="button" name="cmdIncluir" style="cursor:hand"   value="Incluir" class="btn btn-u float-shadow" onclick="return salvar('I')">
		<input type="button" name="cmdLimpar"  style="cursor:hand"  value="Limpar"  class="btn btn-u btn-u-orange float-shadow" onclick="return limpar('<%=strPagina%>')">
		<input type="button" name="cmdPrincipal" style="cursor:hand"   value="Principal"  class="btn btn-u btn-u-brown float-shadow" onClick="window.location='default.asp'">
    	</td> 
    </tr>
</table>