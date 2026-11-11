<!--
	::	Data de Criação...: 23/04/2011
	::	Desenvolvedores...: Roberto Barbosa Silva - roberto@rssolucoesweb.com.br
	::	Objetivo Pagina...: Cadastro de Foto Empresa
	::	Data Atualizacao..: 
	::	Motivo Atualizacao: 
-->
<!--#include file="../../../includes/inc_cnn.asp"-->
<%
	'on error resume next
	'----------Inicia uma tranzação--------------
	cnn.begintrans
	
	intCodGrupo					= Trim(Request("CodGrupo"))
	intCodEmpresa				= Trim(Request("CodEmpresa"))
	
	Set objFSO = CreateObject("Scripting.FileSystemObject")
	
	'Cria a pasta de acordo com codigo da Empresa
	PastaFotos = Server.MapPath("../../../Images") & "/Grupo/" & intCodGrupo & "/Empresa/" & intCodEmpresa

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

			sql = "delete From SEG_EMPRESA_FOTO"      
			sql = sql & " where CodEmpresa = " & intCodEmpresa
			cnn.execute sql
	
		  	sql = "Insert Into SEG_EMPRESA_FOTO (CodEmpresa, arquivo)"          
			sql = sql & " Values ("
			sql = sql & "" & intCodEmpresa & ","
			sql = sql & "'" & intCodEmpresa & ".jpg')"
			cnn.execute sql
			
			' SALVO IMAGEM ## G ##
			ImagemTemp = PastaFotos & "\" & intCodEmpresa & ".jpg"
			objUploadedFile.SaveAs ImagemTemp
			
			Set objJpeg = Server.CreateObject("Persits.Jpeg")
			objJpeg.Open ImagemTemp
			objJpeg.Width = 180
			objJpeg.Height = 78
			
			objJpeg.Sharpen 1, 130
			objJpeg.Save ImagemTemp
			Set objJpeg = Nothing
			
			EnvioOk = True
			
 		Next
					
		IF EnvioOk = True THEN	
			strMensagem = "Foto Empresa enviada com sucesso"		
		ELSE
			strMensagem = "Foto Empresa NÃO foi enviada, verifique as informações postadas."		
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
			window.location='Empresa_cad.asp';
		</script>
		<%
		response.end
	else
		response.Write(err.description)
		cnn.rollbacktrans
	end if
%>