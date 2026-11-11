<!--
	::	Data de Criação...: 04/01/2010
	::	Desenvolvedores...: Roberto Barbosa Silva - roberto@rssolucoesweb.com.br
	::	Objetivo Pagina...: Cadastro de Foto Aluno
	::	Data Atualizacao..: 
	::	Motivo Atualizacao: 
-->
<!--#include file="../../includes/inc_cnn.asp"-->
<%
	'on error resume next
	'----------Inicia uma tranzação--------------
	cnn.begintrans
	
	intCodAluno			= Trim(Request("CodAluno"))
	strMatricula		= Trim(Request("Matricula"))
	Set objFSO = CreateObject("Scripting.FileSystemObject")
	
	'Cria a pasta de acordo com codigo da Empresa
	''PastaFotos = Server.MapPath("../../FotoAluno") & "/" & Session("CodEmpresa") Modelo pasta raiz
	PastaFotos = Server.MapPath("../../../FotoAluno") & "/" & Session("CodEmpresa") ' Modelo pasta retroceder um nivel ../ 
	
	IF Not objFSO.FolderExists(PastaFotos) THEN
		''objFSO.CreateFolder(PastaFotos)
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

			sql = "delete from SCA_ALUNO_FOTO"      
			sql = sql & " where CodAluno = " & intCodAluno
			sql = sql & " and Cod_empresa = " & Session("CodEmpresa")
			cnn.execute sql
			
			sql = "Insert Into SCA_ALUNO_FOTO (Cod_empresa, CodAluno, Arquivo)"          
			sql = sql & " Values ("
			sql = sql & "" & Session("CodEmpresa") & ","
			sql = sql & "" & intCodAluno & ","
			sql = sql & "'" & strMatricula & ".jpg')"
			cnn.execute sql
			
			' SALVO IMAGEM ## G ##
			ImagemTemp = PastaFotos & "\" & strMatricula & ".jpg"
			objUploadedFile.SaveAs ImagemTemp
			
			Set objJpeg = Server.CreateObject("Persits.Jpeg")
			objJpeg.Open ImagemTemp
			objJpeg.Width = 172
			objJpeg.Height = 222
			
			objJpeg.Sharpen 1, 130
			objJpeg.Save ImagemTemp
			Set objJpeg = Nothing
			
			EnvioOk = True
			
 		Next
					
		IF EnvioOk = True THEN	
			strMensagem = "Foto do aluno enviada com sucesso"		
		ELSE
			strMensagem = "Foto do aluno NÃO foi enviada, verifique as informações postadas."		
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