<!--
	::	Empresa...........: RS Soluções web - www.rssolucoesweb.com.br
    ::	Data de Criação...: 23/05/2011
	::	Desenvolvedores...: Roberto Barbosa Silva - roberto@rssolucoesweb.com.br
	::	Objetivo Pagina...: Cadastro de Destaque
	::	Data Atualizacao..: 
	::	Motivo Atualizacao: 
-->
<!--#include file="../../../includes/inc_cnn.asp"-->
<%
	'on error resume next
	'----------Inicia uma tranzação--------------
	cnn.begintrans
	
	strAcao	  			= Trim(Request("acao"))
	intCodEmpresa 		= session("codEmpresa")
		
	if strAcao = "I" then
		
		sql = "SELECT Max(Codigo) as MaiorCodigo" 
		sql = sql & " FROM SIT_Destaque"
		sql = sql & " Where 1=1"
		rs.open sql, cnn
		
		if not RS.EOF then
			if trim(rs("MaiorCodigo")) <> "" then
				uID = cstr(rs("MaiorCodigo")) + 1
			else
				uID = 1	
			end if
		end if
		rs.close
			
	end if
	
	Set objFSO = CreateObject("Scripting.FileSystemObject")
	
	'Cria a pasta de acordo com codigo do Imovel
	PastaEmpresa = Server.MapPath("../../../Destaque")  & "\" & session("codEmpresa")
	
	IF Not objFSO.FolderExists(PastaEmpresa) THEN
		objFSO.CreateFolder(PastaEmpresa)
	END IF
	
	PastaFotos = Server.MapPath("../../../Destaque")  & "/" & session("codEmpresa")  & "\" & uID
	
	IF Not objFSO.FolderExists(PastaFotos) THEN
		objFSO.CreateFolder(PastaFotos)
	END IF
	
							
	IF Request.ServerVariables("REQUEST_METHOD") = "POST" THEN
		
		EnvioOk = False
		
		'Cria uma instancia do objeto Upload e atribui a variável objUpload.
		set objUpload = server.CreateObject("Dundas.Upload.2")
		
		'Limita em 20 MBytes o tamanho do arquivo
        objUpload.MaxFileSize = 200000000
		
		'conserva o nome do arquivo original.
		objUpload.UseUniqueNames = true
		
		'Deve ser utilizada antes do método 'SaveAs' utilizado logo abaixo
		objUpload.SaveToMemory
		
				
		For Each objUploadedFile in objUpload.Files
			
			strDescricao 	=  objUpload.Form("txtDescricao")
			strSite 		=  objUpload.Form("txtSite")
			strLinkNoticia 	=  objUpload.Form("txtLinkNoticia")
	
			sql = "Insert Into SIT_Destaque(Codigo, CodEmpresa, Descricao, Site, LinkNoticia)"          
			sql = sql & " Values ("
			sql = sql & "" & uID & ","
			sql = sql & "" & intCodEmpresa & ","
			
			if strDescricao <> "" then
				sql = sql & "'" & trim(strDescricao) & "',"
			else
				sql = sql & "null,"
			end if
			
			if strSite <> "" then
				sql = sql & "'" & trim(strSite) & "',"
			else
				sql = sql & "null,"
			end if
			
			if strLinkNoticia <> "" then
				sql = sql & "'" & trim(strLinkNoticia) & "')"
			else
				sql = sql & "null)"
			end if
		
			cnn.execute sql
										
			'' SALVO IMAGEM ## G ##
			ImagemTemp = PastaFotos & "\" & uID & "_g.jpg"
			objUploadedFile.SaveAs ImagemTemp
			
			Set objJpeg_g = Server.CreateObject("Persits.Jpeg")
			objJpeg_g.Open ImagemTemp
			Formato = "horizontal"
			objJpeg_g.Width = 136
			objJpeg_g.Height = 192
			
			objJpeg_g.Sharpen 1, 130
			objJpeg_g.Save ImagemTemp
			Set objJpeg_g = Nothing
			
			EnvioOk = True
		
 		Next
					
		IF EnvioOk = True THEN	
			strMensagem = "Foto do Destaque enviada com sucesso"	
		ELSE
			strMensagem = "Foto do Destaque NÃO foi enviada, verifique as informações postadas."		
		END IF
								
		Set objUpload = Nothing
		Set objFSO = Nothing
	
	END IF
		
	if err.number = 0 then
	'----------Finaliza tranzação iniciada--------------
		cnn.commitTrans
		%>
		<script>
			alert("<%=strMensagem%>");
			window.navigate('Destaque_cad.asp');
		</script>
		<%
		response.end
	else
		response.redirect "erro.asp?strNumErro=" & err.number & "&strDescErro=" & err.description 
		cnn.rollbacktrans
	end if
%>