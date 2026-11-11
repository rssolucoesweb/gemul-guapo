<!--
    ::	DESENVOLVIDO POR..: 1995 C.M - Soluções em Informática. 
    ::	Data de Criação...: 31/03/2015
    ::	Desenvolvedores...: Diretor Executivo: Cléovis Araujo - gestoreducacional@gestoreducacional.com.br
    ::	Objetivo Pagina...: Cadastro de Grupo
-->
<!--#include file="../../includes/inc_verificaSession.asp"-->
<!--#include file="../../includes/inc_cnn.asp"-->
<!--#include file="../../includes/inc_replaceRequest.asp"-->
<!--#include file="../../includes/inc_log.asp"-->
<%
	on error resume next
	'----------Inicia uma tranzação--------------
	cnn.begintrans
	
	acao 				= Trim(Request.QueryString("acao"))
	strSiglaSistema 	= Trim(Request("cmbSistemas"))
	intCodPerfil		= Trim(Request("cmbPerfil"))
	strSiglaModulo		= Trim(Request("cmbModulosSistema"))
	intCodMenu			= Trim(Request("cmbMenu"))
	intItemCodigo 		= Trim(Request.Form("chkInserir"))
	
	strMensagem = "Registro Alterado com sucesso!"
	
	' Exclui todos os Perfil Itens antes
	sql = " Delete from Seg_Perfis_Itens_Sistema "
	sql = sql & " Where Pite_perf_Codg = " & intCodPerfil
	sql = sql & " and pite_item_codg in"
	sql = sql & " (SELECT SEG_ITENS_SISTEMA.ITEM_CODG FROM SEG_ITENS_SISTEMA INNER JOIN SEG_MENUS_SISTEMA ON (SEG_ITENS_SISTEMA.ITEM_MENU_MODU_SIGL = SEG_MENUS_SISTEMA.MENU_MODU_SIGL) AND (SEG_ITENS_SISTEMA.ITEM_MENU_CODG = SEG_MENUS_SISTEMA.MENU_CODG) AND (SEG_ITENS_SISTEMA.ITEM_SIST_SIGL = SEG_MENUS_SISTEMA.MENU_SIST_SIGL) "
	sql = sql & " WHERE Seg_Menus_Sistema.Menu_Codg = " & intCodMenu 
	sql = sql & " and Seg_Menus_Sistema.menu_modu_sigl = '" & strSiglaModulo & "'"
	sql = sql & " and Seg_Menus_Sistema.menu_sist_sigl = '" & strSiglaSistema & "')"
	cnn.execute sql
	GravarLog sql
	
	if intItemCodigo <> "" then 
		
		if acao="I" then
			
			strMensagem = "Registro Cadastrado com sucesso!"
				
			if intItemCodigo <> "" then   
				vetCodigoItem = split(intItemCodigo,",")			 
			end if
			
			' Laço para inserção dos itens
			intConTipo = 0
				 
			for intContador = 0 to ubound(vetCodigoItem)
			
				strCodItem 			= trim(vetCodigoItem(intContador))
				strTipoPermissao 	= Trim(Request.Form("chkTipoPermissao_" & strCodItem))
				
				sql = " Insert into SEG_PERFIS_ITENS_SISTEMA (Pite_perf_Codg, Pite_Item_Codg, Pite_Info_Permissao )"
				sql = sql & " VALUES ("
				sql = sql & " " & intCodPerfil & ","
				sql = sql & " " & strCodItem & ","
				
				if strTipoPermissao <> "" then 
					sql = sql & "'" & strTipoPermissao & "')"
				else
					sql = sql & "" & "null)"
				end if 	
			
				cnn.execute sql
				GravarLog sql
				
			next
			
		elseif acao="A" then
		
			
		elseif acao = "E"then 
				
			strMensagem = "Registro Excluido com sucesso"
						
			if intItemCodigo <> "" then   
				vetCodigoItem = split(intItemCodigo,",")			 
			end if
			
			' Laço para inserção dos itens
			intConTipo = 0
			
			For intContador = 0 to ubound(vetCodigoItem)	 
			
				sql = " Delete from SEG_PERFIS_ITENS_SISTEMA"
				sql = sql & " Where Pite_perf_Codg = " & intCodPerfil
				sql = sql & " and Pite_Item_Codg = " & vetCodigoItem(intContador)
				cnn.execute sql
				GravarLog sql
			next	 	
		
		end if
	
	end if
	
	if err.number = 0 then
	'----------Finaliza tranzação iniciada--------------
		cnn.commitTrans
		%>
		<script>
			alert("<%=strMensagem%>");
  		    window.location = 'Configurar_Perfil_cad.asp';
		</script>
		<%
		response.end
	else
		response.redirect "erro.asp?strNumErro=" & err.number & "&strDescErro=" & err.description 
		cnn.rollbacktrans
	end if
%>