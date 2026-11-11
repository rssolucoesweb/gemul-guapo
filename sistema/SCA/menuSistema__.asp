<!--#include file="../includes/inc_validaPermissao.asp"-->
<script>
function teste()
{
qtdSelect = document.getElementsByTagName("select");
for (i = 0; i < qtdSelect.length; i++)
{
    objSelect = qtdSelect[i];
    objSelect.style.visibility = "visible";
   }

}
</script>
<%
strNomeSistema 	= Session("strNomeSistema") 	
Sistema 		= Session("strSistema") 
Modulo 			= Session("strModulo") 

'select para contar a quantidade de menus que irá existir
strPerfil =  validaPermissao(session("usuarioweb"), Sistema)

'carrega menu do sistema
sql = "SELECT DISTINCT SEG_MENUS_SISTEMA.MENU_DESC,  SEG_MENUS_SISTEMA.MENU_NUMR_POSICAO, SEG_MENUS_SISTEMA.MENU_CODG "
sql = sql & " FROM SEG_MENUS_SISTEMA INNER JOIN (SEG_ITENS_SISTEMA INNER JOIN SEG_PERFIS_ITENS_SISTEMA ON SEG_ITENS_SISTEMA.ITEM_CODG = SEG_PERFIS_ITENS_SISTEMA.PITE_ITEM_CODG) ON (SEG_MENUS_SISTEMA.MENU_SIST_SIGL = SEG_ITENS_SISTEMA.ITEM_SIST_SIGL) AND (SEG_MENUS_SISTEMA.MENU_MODU_SIGL = SEG_ITENS_SISTEMA.ITEM_MENU_MODU_SIGL) AND (SEG_MENUS_SISTEMA.MENU_CODG = SEG_ITENS_SISTEMA.ITEM_MENU_CODG) "
sql = sql & " WHERE     (SEG_PERFIS_ITENS_SISTEMA.PITE_PERF_CODG in (" & strPerfil &")) "
sql = sql & " AND (SEG_MENUS_SISTEMA.MENU_SIST_SIGL = '" & Sistema & "')"
sql = sql & " AND SEG_MENUS_SISTEMA.MENU_MODU_SIGL = '"& Modulo & "'"
sql = sql & " AND SEG_ITENS_SISTEMA.ITEM_STAT='A' "
sql = sql & "  ORDER BY SEG_MENUS_SISTEMA.MENU_NUMR_POSICAO"
rs.open sql, cnn
if rs.eof then
	rs.close
	%>
	<script>
		alert("Usuário sem permissões no sistema!"); 
		window.history.back();
	</script>
	 <%
  response.End()
else
	%>
	<div id="menu">
	<%
		while not rs.eof
			%>
			<img src="../../images/divisor.gif" alt="barra" />
			<a href="#" onClick="return clickreturnvalue()" onMouseover="dropdownmenu('hidden', this, event, '<%=trim(rs("MENU_DESC"))%>')"><%=trim(rs("MENU_DESC"))%></a>
			<%
			rs.movenext
		wend
		rs.close
	%>
		<img src="../../images/divisor.gif" alt="barra" />	
	</div>
	<%
	'carrega sub menu do sistema
	sql = "SELECT SEG_ITENS_SISTEMA.ITEM_DESC, SEG_ITENS_SISTEMA.ITEM_INFO_URL, SEG_ITENS_SISTEMA.ITEM_NUMR_POSICAO, SEG_MENUS_SISTEMA.MENU_NUMR_POSICAO, SEG_MENUS_SISTEMA.MENU_DESC "
	sql = sql & " FROM SEG_MENUS_SISTEMA INNER JOIN (SEG_PERFIS_SISTEMA INNER JOIN (SEG_ITENS_SISTEMA INNER JOIN SEG_PERFIS_ITENS_SISTEMA ON SEG_ITENS_SISTEMA.ITEM_CODG = SEG_PERFIS_ITENS_SISTEMA.PITE_ITEM_CODG) ON SEG_PERFIS_SISTEMA.PERF_CODG = SEG_PERFIS_ITENS_SISTEMA.PITE_PERF_CODG) ON SEG_MENUS_SISTEMA.MENU_CODG = SEG_ITENS_SISTEMA.ITEM_MENU_CODG "
	sql = sql & " WHERE (((SEG_PERFIS_SISTEMA.PERF_CODG) In (" & strPerfil &")) "
	sql = sql & " AND ((SEG_ITENS_SISTEMA.ITEM_SIST_SIGL)='"& Sistema & "') "
	sql = sql & " AND ((SEG_ITENS_SISTEMA.ITEM_MENU_MODU_SIGL)='" & Modulo & "')) "
	sql = sql & " GROUP BY SEG_ITENS_SISTEMA.ITEM_DESC, SEG_ITENS_SISTEMA.ITEM_INFO_URL, SEG_ITENS_SISTEMA.ITEM_NUMR_POSICAO, SEG_MENUS_SISTEMA.MENU_NUMR_POSICAO, SEG_MENUS_SISTEMA.MENU_DESC "
	sql = sql & " ORDER BY SEG_MENUS_SISTEMA.MENU_NUMR_POSICAO, SEG_ITENS_SISTEMA.ITEM_NUMR_POSICAO "
	strMenuDesc = ""
	rs.open sql, cnn
	if not rs.eof then
		while not rs.eof
			if trim(strMenuDesc) <> trim(rs("MENU_DESC")) then
				if trim(strMenuDesc) <> "" then
					%>
					</div>
					<% 
				end if
				%>
				<div id="<%=trim(rs("MENU_DESC"))%>" class="anylinkcss" >
				<%
			end if
			%>
			<a href="<%=trim(rs("ITEM_INFO_URL"))%>"><%=trim(rs("ITEM_DESC"))%></a>
			<%
			strMenuDesc = trim(rs("MENU_DESC"))
			rs.movenext
		wend
	end if
	rs.close
end if


%>