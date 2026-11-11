    <!--
    ::	DESENVOLVIDO POR Asced"
    ::	Data de Criação...: 27/05/2015
    ::	Desenvolvedores...: Roberto Barbosa Silva - roberto@superawebx.com.br
    ::	Objetivo Pagina...: Controle de Acesso
	-->
	<!--#include file="../../includes/inc_verificaSession.asp"-->
	<!--#include file="../../includes/inc_cnn.asp"-->
	<!--#include file="../../includes/inc_replaceRequest.asp"-->
	<!--#include file="../../includes/inc_log.asp"-->
	<%
	
	paginaRetorno			= "Controle_Acesso_Excessoes_cad.asp"
	strAcao					= Trim(Request.QueryString("acao"))
	strUsuarioPortal 		= UCASE(Trim(Trim(Request.Form("txtUsuarioPortal"))))
	intCodEmpresaUsuario 	= Trim(Request("cmdEmpresaUsuario"))
	intCodCategoria			= Trim(Request("cmbCategoria"))	
	intCodFuncao 	  		= TRIM(Request("cmbFuncao"))
	intCodTurno 			= TRIM(Request.Form("cmbTurnoRH"))

	intCodPerfil = Trim(Request.Form("cmbPerfilGrupo"))
	if intCodPerfil <> "" then
		vetPerfil = split(intCodPerfil,",")
	end if

	strInfoRepasse 		= "N"
	
	'on error resume next
	
	cnn.begintrans

	if strAcao = "I" then  

		strMensagem = "Registro Incluído com sucesso!"

		'' Só poderá ter um perfil por turno
		sql = " delete from Seg_Acessos_Usuario_Excessoes"
		sql = sql & " where Aces_Usua_Codg = '" & strUsuarioPortal & "'"
		sql = sql & " and Cod_Turno = " & intCodTurno
		cnn.execute sql
		GravarLog sql
		
		if intCodPerfil<>"" then
			for i=0 to ubound(vetPerfil)
				sql = " insert into Seg_Acessos_Usuario_Excessoes (Aces_Usua_Codg, Aces_Perf_Codg, Cod_empresa, Cod_Categoria, Cod_funcao ,Aces_Info_Repasse, Cod_Turno )"
				sql = sql & " VALUES ('" & strUsuarioPortal & "' , '" & vetPerfil(i) & "'," & intCodEmpresaUsuario & "," & intCodCategoria  & "," & intCodFuncao & ", 'N'," & intCodTurno & ")"
				cnn.execute sql
				GravarLog sql
			next
		else
			cnn.committrans
			%>
			<script>
				alert("Atenção! Pelo Menos um perfil deverá ser informado.");
				window.navigate('Controle_Acesso_Excessoes_cad.asp?txtUsuarioPortal=<%=strUsuarioPortal%>');
			</script>
			<%
			response.end
		end if

	elseif strAcao = "A"then
	
		strMensagem = "Registro Alterado com sucesso!"
			
	elseif strAcao = "E"then 
	
		strMensagem = "Todo perfil extra criado para esse login independente da unidade escolar, foi excluído com sucesso!"
			
		sql = " delete from Seg_Acessos_Usuario_Excessoes"
		sql = sql & " where Aces_Usua_Codg = '" & strUsuarioPortal & "'"
		cnn.execute sql
		GravarLog sql
			
	end if

	if err.number = 0 then
		cnn.committrans
		%>
		<script>
			alert("<%=strMensagem%>");
			window.location='Controle_Acesso_Excessoes_cad.asp?txtUsuarioPortal=<%=strUsuarioPortal%>';
		</script>
		<%
		response.end
	else
		response.redirect "erro.asp?strNumErro=" & err.number & "&strDescErro=" & err.description & "&strPaginaErro='Controle_Acesso_Excessoes_cad.asp'"
		cnn.rollbacktrans
	end if
%>