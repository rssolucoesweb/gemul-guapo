<!--
	::	Empresa...........: RS Soluções web - www.rssolucoesweb.com.br
    ::	Data de Criação...: 19/05/2011
	::	Desenvolvedores...: Roberto Barbosa Silva - roberto@rssolucoesweb.com.br
	::	Objetivo Pagina...: Noticia Fotos
	::	Data Atualizacao..: 
	::	Motivo Atualizacao: 
-->
<!--#include file="../../../includes/inc_cnn.asp"-->
<!--#include file="../../../includes/inc_formatadata.asp"-->
<%
	'on error resume next
	'----------Inicia uma tranzação--------------
	cnn.begintrans
	
	intCodNoticia		= Trim(Request("CodNoticia"))
		
	Set objFSO = CreateObject("Scripting.FileSystemObject")
	
	'Cria a pasta de acordo com codigo do Empresa
	PastaEmpresa = Server.MapPath("../../../FotoNoticia")  & "\" & session("codEmpresa")
	
	IF Not objFSO.FolderExists(PastaEmpresa) THEN
		objFSO.CreateFolder(PastaEmpresa)
	END IF
	
	PastaFotos = Server.MapPath("../../../FotoNoticia")  & "/" & session("codEmpresa")  & "\" & intCodNoticia
	
	IF Not objFSO.FolderExists(PastaFotos) THEN
		objFSO.CreateFolder(PastaFotos)
	END IF
							
	IF Request.ServerVariables("REQUEST_METHOD") = "POST" THEN
		
		EnvioOk = False
		
		'Cria uma instancia do objeto Upload e atribui a variável objUpload.
		set objUpload = server.CreateObject("Dundas.Upload.2")
		
		'Limita em 20KBytes o tamanho do arquivo / Valor Original: 'Limita em 20 MBytes o tamanho do arquivo = 200000000
        objUpload.MaxFileSize = 200000000 
		
		'conserva o nome do arquivo original.
		objUpload.UseUniqueNames = true
		
		'Deve ser utilizada antes do método 'SaveAs' utilizado logo abaixo
		objUpload.SaveToMemory
		
		For Each objUploadedFile in objUpload.Files

			sql = " Delete from SIT_NoticiaFoto"      
			sql = sql & " Where CodNoticia = " & intCodNoticia
			cnn.execute sql
			GravarLog sql, nomePagina(request.ServerVariables("SCRIPT_NAME"))
			
			sql = "Insert Into SIT_NoticiaFoto (CodNoticia, Arquivo)"          
			sql = sql & " Values ("
			sql = sql & "" & intCodNoticia & ","
			sql = sql & "'" & intCodNoticia & ".jpg')"
			cnn.execute sql
			GravarLog sql, nomePagina(request.ServerVariables("SCRIPT_NAME"))
	
			' SALVO IMAGEM ## G ##
			ImagemTemp = PastaFotos & "\" & intCodNoticia & ".jpg"
			objUploadedFile.SaveAs ImagemTemp
			
			Set objJpeg = Server.CreateObject("Persits.Jpeg")
			objJpeg.Open ImagemTemp
			objJpeg.Width = 199
			objJpeg.Height = 143
			
			objJpeg.Sharpen 1, 130
			objJpeg.Save ImagemTemp
			Set objJpeg = Nothing
			
			EnvioOk = True
			
 		Next
					
		IF EnvioOk = True THEN	
			strMensagem = "Foto do Noticia enviada com sucesso"		
		ELSE
			strMensagem = "Foto do Noticia NÃO foi enviada, verifique as informações postadas."		
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
			window.opener.frm.submit();
			window.close();			 
		</script>
		<%
		response.end
	else
		response.Write(err.description)
		cnn.rollbacktrans
	end if
%>