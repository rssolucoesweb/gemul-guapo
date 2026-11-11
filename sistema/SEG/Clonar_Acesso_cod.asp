	<!--
		::	DESENVOLVIDO POR Asced"
		::	Data de Criação...: 26/12/2015
		::	Desenvolvedores...: Roberto Barbosa Silva - roberto@superawebx.com.br
		::	Objetivo Pagina...: Clonar Acesso
	-->
	<!--#include file="../../includes/inc_verificaSession.asp"-->
	<!--#include file="../../includes/inc_cnn.asp"-->
	<!--#include file="../../includes/inc_replaceRequest.asp"-->
	<!--#include file="../../includes/inc_log.asp"-->
	<%
	
	paginaRetorno		= "Configurar_Perfil_cad.asp"
	strAcao				= Trim(Request.QueryString("acao"))
	strUsuarioPortal 	= Trim(Request("txtUsuarioPortal"))
	strUsuarioNovo 		= Trim(Request("txtUsuarioNovo"))
	strInfoRepasse 		= "N"
	
	on error resume next
	
	cnn.begintrans

	if strAcao = "I" then  
		
		strMensagem = "Registro Clonado com sucesso!"
		
		' Deleta todos os acessos exitentes 
		sql = "Delete from Seg_Acessos_Usuario"
		sql = sql & " Where ACES_USUA_CODG = '" & strUsuarioNovo & "'"
		cnn.execute sql
		GravarLog sql
		
		' Consulta os acessos exiteste da  pessoa a ser clonada 
		sql = "SELECT Aces_Usua_Codg, Perf_Codg, Perf_Sist_Sigl, Perf_Desc, SIST_DESC, MOD_DESCRICAO"
		sql = sql & " FROM Seg_Acessos_Usuario, Seg_Perfis_Sistema, Seg_Sistemas_informatica, SEG_MODULO"
		sql = sql & " WHERE Aces_Perf_Codg = Perf_Codg"
		sql = sql & " AND Seg_Sistemas_informatica.MOD_COD = SEG_MODULO.MOD_COD"
		sql = sql & " AND Aces_Usua_Codg = '" & strUsuarioPortal & "'"
		sql = sql & " AND Seg_Perfis_Sistema.Perf_Sist_Sigl = Seg_Sistemas_informatica.SIST_SIGL"
		sql = sql & " ORDER BY Perf_Codg"
		
		rs.open sql, cnn, 3, 3
						
		if rs.eof = false then
			
			while not rs.eof
								
				sql = " insert into Seg_Acessos_Usuario (Aces_Usua_Codg, Aces_Perf_Codg, Aces_Info_Repasse )"
				sql = sql & " VALUES ('" & strUsuarioNovo & "' , '" &  rs("Perf_Codg") & "', '" & strInfoRepasse & "')"
				cnn.execute sql
				GravarLog sql
				rs.movenext
			wend
		end if
			
	
	elseif strAcao = "A"then
	
		strMensagem = "Registro Alterado com sucesso!"
			
	elseif strAcao = "E"then 
	
		strMensagem = "Registro Excluido com sucesso"
			
	end if
		
	if err.number = 0 then
		'registro será atualizado/incluido com sucesso
		cnn.committrans
		%>
		<script>
			alert("<%=strMensagem%>");
			window.location='<%=paginaRetorno%>';
		</script>
		<%
	else
		'registro teve problema e não será atualizado
		cnn.rollbacktrans
		if err.number = -2147217900 then
			%>
			<script>
				alert("Atenção : Esta Informação não pode ser excluida pois existem registros vinculados a ela");
				window.history.back();
			</script>
			<%
		else
			%>
			<script>
				alert("ATENÇÃO: \n\nNão foi possível executar esse procedimento, tente novamente.\nCaso persistir entre em contato com o administrador do sistema.");
				window.history.back();
			</script>
			<%
		end  if 	
	end if
%>