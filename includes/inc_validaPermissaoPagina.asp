<%
'VALIDAÇÃO PERMISSÃO DA PAGINA ACESSADA
'**************************************
set rsAcesso  = Server.CreateObject("adodb.recordset")
'-------------------------------------
'-- RECUPERA O NOME DA PÁGINA ACESSADA
'-------------------------------------
strCaminhoPaginaAcessada = REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(Request.ServerVariables("path_info"),"/Sistema/SAV/",""),"/Sistema/SCA/",""),"/Sistema/SCB/",""),"/Sistema/SCC/",""),"/Sistema/SCF/",""),"/Sistema/SCP/",""),"/Sistema/SEG/",""),"/Sistema/SGC/",""),"/Sistema/SGE/",""),"/Sistema/SRH/","")

'verifica se a unidade escolar foi selecionada anteriormente
if trim(session("usuarioWeb")) = "" then
	%>
	<script>
		alert("ATENÇÃO: Seu acesso expirou, favor acessar o sistema novamente para seu perfil ser validado!");
		window.close();
	</script>
	<%
end if


strUsuarioAtual 		 = TRIM(session("usuarioWeb"))

sql= "select _psii.ITEM_INFO_URL"
sql=sql & " from SEG_ACESSOS_USUARIO _au"
sql=sql & " inner join SEG_PERFIS_SISTEMA _ps on _ps.PERF_CODG = _au.ACES_PERF_CODG"
sql=sql & " inner join SEG_PERFIS_ITENS_SISTEMA _psi on _psi.PITE_PERF_CODG = _ps.PERF_CODG"
sql=sql & " inner join SEG_ITENS_SISTEMA _psii on _psii.ITEM_CODG = _psi.PITE_ITEM_CODG"
sql=sql & " where _au.ACES_USUA_CODG = '" & strUsuarioAtual & "'"
sql=sql & " and _psii.ITEM_INFO_URL LIKE '" & strCaminhoPaginaAcessada & "%'"
rsAcesso.open sql, cnn
if rsAcesso.eof then
	rsAcesso.close
	%>
	<script>
		alert("Usuário não tem permissão para acessar essa página.");
		window.close();
	</script>
	<%	
	response.End()
else
	rsAcesso.close
end if

%>