<!--#include file="../../includes/inc_cnn.asp"-->
<%
	'on error resume next
	'----------Inicia uma tranzação--------------
	cnn.begintrans
	
	intCodEmpresa			= Trim(Request("CodEmpresa"))
	intCodGrupo				= Trim(Request("CodGrupo"))
	
	Set objFSO = CreateObject("Scripting.FileSystemObject")
	
	'Cria a pasta de acordo com codigo da Empresa
	PastaFotos = Server.MapPath("../../LogoMarcas") & "/" & intCodEmpresa
		
	IF Not objFSO.FolderExists(PastaFotos) THEN
		objFSO.CreateFolder(PastaFotos)
	END IF
							
							
	IF Request.ServerVariables("REQUEST_METHOD") = "POST" THEN
		
		EnvioOk = False
		
		'Cria uma instancia do objeto Upload e atribui a variável objUpload.
		set objUpload = server.CreateObject("Dundas.Upload.2")
		
		'Limita em 20KBytes o tamanho do arquivo / Valor Original: 'Limita em 20 MBytes o tamanho do arquivo = 200000000
        objUpload.MaxFileSize = 20000 
		
		'conserva o nome do arquivo original.
		objUpload.UseUniqueNames = true
		
		'Deve ser utilizada antes do método 'SaveAs' utilizado logo abaixo
		objUpload.SaveToMemory
		
		For Each objUploadedFile in objUpload.Files

			strLogoMarca = intCodEmpresa & ".jpg"
						
			sql = " Update SEG_EMPRESA set "
			sql = sql & " LOGOMARCA = '" & strLogoMarca & "'"
			sql = sql & " Where CODIGO = " & intCodEmpresa
			sql = sql & " And COD_GRUPO = " & intCodGrupo
			cnn.execute sql
	
			' SALVO IMAGEM ## G ##
			ImagemTemp = PastaFotos & "\" & strLogoMarca
			objUploadedFile.SaveAs ImagemTemp
			
			Set objJpeg = Server.CreateObject("Persits.Jpeg")
			objJpeg.Open ImagemTemp
			objJpeg.Width = 85
			objJpeg.Height = 103
			
			objJpeg.Sharpen 1, 130
			objJpeg.Save ImagemTemp
			Set objJpeg = Nothing
			
			EnvioOk = True
			
 		Next
					
		IF EnvioOk = True THEN	
			strMensagem = "Logo Marca enviada com sucesso"		
		ELSE
			strMensagem = "Logo Marca NÃO foi enviada, verifique as informações postadas."		
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