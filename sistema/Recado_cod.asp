<!--
	::	DESENVOLVIDO POR "RS SOLUÇÕES WEB - www.rssolucoesweb.com.br"
	::	Data de Criação...: 28/11/2009
	::	Desenvolvedores...: Roberto Barbosa Silva - roberto@rssolucoesweb.com.br
	::	Objetivo Pagina...: Cadastro de Recados
-->
<!--#include file="../includes/inc_verificaSession.asp"-->
<!--#include file="../includes/inc_cnnDocumento.asp"-->
<!--#include file="../includes/inc_replaceRequest.asp"-->
<!--#include file="../includes/inc_formataData.asp"-->
<%
	'on error resume next
	acao 						= Trim(Request.QueryString("acao"))
	intCodGrupoRecado			= Trim(Request.Form("cmbGrupoRecado"))
	intCodEmpresaRecado			= Trim(Request.Form("cmbEmpresaRecado"))
	intCodDepartamentoRecado	= Trim(Request.Form("cmbDepartamentoRecado"))
	strPara						= Trim(Request.Form("cmbUsuarioRecado"))
	strDe						= Trim(Request.Form("txtDe"))
	strAssunto  				= Replace(Trim(Request.Form("txtAssunto")),"'","")
	strRecado	 				= Replace(Trim(Request.Form("txtRecado")),"'","")
	strData			 			= formataDataBD(Trim(Request.Form("txtDataRecado")))
	strHora			 			= Trim(Request("txtHora"))
	strStatus					= 1
	
	'----------Inicia uma tranzação--------------
	cnn.begintrans
	
	if acao="I" then
		
			strMensagem = strMensagem & "Recado Enviado com sucesso..."
			
			sql = " select DISTINCT CODIGO_SEG_USUARIOS_SISTEMA "
			sql = sql & " FROM SEG_USUARIOS_EMPRESA "
			sql = sql & " INNER JOIN SEG_EMPRESA ON SEG_EMPRESA.CODIGO = SEG_USUARIOS_EMPRESA.COD_EMPRESA "
			sql = sql & " INNER JOIN SEG_USUARIOS_SISTEMA ON SEG_USUARIOS_SISTEMA.USUA_CODG = SEG_USUARIOS_EMPRESA.CODIGO_SEG_USUARIOS_SISTEMA"
			sql = sql & " LEFT JOIN SEG_GRUPO  ON SEG_EMPRESA.COD_GRUPO = SEG_GRUPO.CODIGO "
			sql = sql & " WHERE 1=1 "
			sql = sql & " And USUA_STAT = 'A'"
			
			if intCodEmpresaRecado <> "0" then 
				sql = sql & " AND SEG_USUARIOS_EMPRESA.COD_EMPRESA = " & intCodEmpresaRecado
			end if
			
			if intCodGrupoRecado <> "0" then
				sql = sql & " AND SEG_GRUPO.codigo = " & intCodGrupoRecado
			end if
			
			if intCodDepartamentoRecado <> "0" then
				sql = sql & " AND SEG_USUARIOS_SISTEMA.CODIGO_DEPARTAMENTO = " & intCodDepartamentoRecado
			end if
			
			if strPara <> "" and strPara <> "0" then
				sql = sql & " AND CODIGO_SEG_USUARIOS_SISTEMA = '" & strPara & "'"
			end if
			vetRecado = null
			rs.open sql, cnn
			if not rs.eof then
				vetRecado = rs.getRows
			end if
			rs.close
			
			if isArray(vetRecado) then
				controle = 0
				for i=0 to ubound(vetRecado,2)
				
					strPara  	= vetRecado(0,i)
					
					sql = "Insert Into SEG_Recados(De, Para, Assunto, recado, data, hora, status )"
					sql = sql & " Values ("
					sql = sql & "'" & strDe & "',"
					sql = sql & "'" & strPara & "',"
					sql = sql & "'" & strAssunto & "',"
					if strRecado <> "" then
						sql = sql & "'" & strRecado & "',"
					else
						sql = sql & " null, " 
					end if
					sql = sql & "'" & strData & "',"
					sql = sql & "'" & strHora & "',"
					sql = sql & "" & strStatus & ")"
					cnn.execute sql
					
				next
			
				vetRecado = null
			end if
			
	elseif acao="A" then
		intCodRecado	= Trim(Request("intCodRecado"))
		
		strMensagem = "Recado Lido com sucesso..."
		sql = "Update SEG_Recados set status = 2 "'lido
		sql = sql & " Where CodRecado = " & intCodRecado
		cnn.execute sql
		
	end if
	
	if err.number = 0 then
	'----------Finaliza tranzação iniciada--------------
		cnn.commitTrans
		if acao="A" then
		%>
		<script>
			window.opener.frm.submit();
			window.close();	
		</script>
		<%
		else
		%>
		<script>
			alert("<%=strMensagem%>");
			window.location='Recado_cad.asp';
		</script>
		<%
		end if
		response.end
	else
		response.redirect "erro.asp?strNumErro=" & err.number & "&strDescErro=" & err.description 
		cnn.rollbacktrans
	end if
%>