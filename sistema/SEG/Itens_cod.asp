<!--
	::	DESENVOLVIDO POR Gemul - Gestor de Município"
	::	Data de Criação...: 26/01/2015
	::	Desenvolvedores...: Asced
	::	Objetivo Pagina...: Cadastro de Itens
-->
<!--#include file="../../includes/inc_verificaSession.asp"-->
<!--#include file="../../includes/inc_cnn.asp"-->
<!--#include file="../../includes/inc_formataData.asp"-->
<!--#include file="../../includes/inc_replaceRequest.asp"-->
<%
	on error resume next
	'----------Inicia uma tranzação--------------
	cnn.begintrans
	
	acao 				= Trim(Request.QueryString("acao"))
	intCodItem			= Trim(Request("txtCodItem"))
	strSiglaSistema 	= Trim(Request("cmbSistemas"))
	strSiglaModulo		= Trim(Request("cmbModulosSistema"))
	intCodMenu			= Trim(Request("cmbMenu"))
	
	strDescItem			= Trim(Request("txtDescItem"))
	strNome				= Trim(Request("txtNome"))
	strURL				= Trim(Request("txtURL")) 
	strURL_NOVO			= Trim(Request("txtURL_NOVO")) 
	intNumPosicao		= Trim(Request("txtNumPosicao"))	
	strSituacao			= Trim(Request.Form("cmbSituacao"))
	
	if acao="I" then
		
		strMensagem = "Registro Incluído com sucesso"

		sql = "SELECT max(Item_Codg) as NovoCodItem From SEG_ITENS_SISTEMA"  
		rs.open sql,cnn
		
		if rs.eof = false then
			if isnull(rs("NovoCodItem")) = false then
				intCodItem = cint(rs("NovoCodItem")) + 1
			else
				intCodItem = 1
			end if
		else
			intCodItem = 1
		end if		
		rs.close		
		
		sql = "Insert Into SEG_ITENS_SISTEMA(Item_Codg,  Item_Sist_Sigl , Item_Nome, Item_Desc, Item_Stat, Item_Numr_Posicao, "
		sql = sql & " ITEM_INFO_PERMISSAO, ITEM_INFO_URL,ITEM_INFO_URL_NOVO, ITEM_INFO_PARAMETRO,"
		sql = sql & " Item_Menu_Modu_Sigl, Item_Menu_Codg )"
		sql = sql & " Values ("
		sql = sql & "" & intCodItem & ","
		sql = sql & "'" & strSiglaSistema & "',"
		sql = sql & "'" & strNome & "',"
		sql = sql & "'" & strDescItem & "',"
		sql = sql & "'" & strSituacao & "',"
		sql = sql & "" & intNumPosicao & ","
		sql = sql & " null, " 
		sql = sql & "'" & strURL & "',"
		sql = sql & "'" & strURL_NOVO & "',"
		sql = sql & " null, " 
		sql = sql & "'" & strSiglaModulo & "',"
		sql = sql & "'" & intCodMenu & "')"
	
		
	elseif acao="A" then
	
		strMensagem = "Registro Alterado com sucesso!"
		
		sql = "update SEG_ITENS_SISTEMA set"
		sql = sql & " Item_Sist_Sigl = '" & strSiglaSistema & "',"
		sql = sql & " Item_Nome = '" & strNome & "',"
		sql = sql & " ITEM_INFO_URL = '" & strURL & "',"
		sql = sql & " ITEM_INFO_URL_NOVO = '" & strURL_NOVO & "',"
		sql = sql & " Item_Desc = '" & strDescItem & "',"
		sql = sql & " Item_Stat = '" & strSituacao & "',"
		sql = sql & " Item_Numr_Posicao = " & intNumPosicao & ","
		sql = sql & " Item_Menu_Modu_Sigl = '" & strSiglaModulo & "',"
		sql = sql & " Item_Menu_Codg = '" & intCodMenu & "'"
		sql = sql & " Where Item_Codg = " & intCodItem
			
	elseif acao = "E"then 
			
		strMensagem = "Registro Excluido com sucesso"
		
		sql = "Delete From SEG_ITENS_SISTEMA"
		sql = sql & " Where Item_Codg = " & intCodItem
	
	end if
	
	cnn.execute sql
	
	if err.number = 0 then
	'----------Finaliza tranzação iniciada--------------
		cnn.commitTrans
		%>
		<script>
			alert("<%=strMensagem%>");
  		    window.location = 'Itens_cad.asp?cmbSistemas=<%=strSiglaSistema%>';
		</script>
		<%
		response.end
	else
		response.redirect "erro.asp?strNumErro=" & err.number & "&strDescErro=" & err.description 
		cnn.rollbacktrans
	end if
%>