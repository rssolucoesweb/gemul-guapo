<!--#include file="../../includes/inc_cnn.asp"-->
<%
	'on error resume next
	'----------Inicia uma tranzação--------------
	cnn.begintrans
	
	intCodAluno		= Trim(Request("CodAluno"))
	IF intCodAluno = "" THEN intCodAluno = 0
	orientacao		= "V" 'vertical
	
	sql = "SELECT matricula FROM sca_aluno "
	sql = sql & " Where Codigo = " & intCodAluno
	rs.open sql, cnn,3,3
	IF Rs.BOF AND Rs.EOF THEN
		rs.close	
		%>
		<script>
			alert("ATENÇÃO: acesse o cadastro do aluno novamente, não foi possível vincular a foto ao aluno.")
			window.close()
		</script>
		<%
		response.end
	ELSE
		strMatricula = rs("matricula")
		rs.close	
	END IF
	
	Set objFSO = CreateObject("Scripting.FileSystemObject")
	
	'Cria a pasta de acordo com codigo da empresa
	PastaFotos = Server.MapPath("../../fotoAluno") & "/" & Session("CodEmpresa")	
		
	IF Not objFSO.FolderExists(PastaFotos) THEN
		objFSO.CreateFolder(PastaFotos)
	END IF
							
	IF Request.ServerVariables("REQUEST_METHOD") = "POST" THEN
		
		EnvioOk = False
		
		'Cria uma instancia do objeto Upload e atribui a variável objUpload.
		set objUpload = server.CreateObject("Dundas.Upload.2")
		
		'Limita em 10 MBytes o tamanho do arquivo
        objUpload.MaxFileSize = 100000000		
		
		'conserva o nome do arquivo original.
		objUpload.UseUniqueNames = true
		
		'Deve ser utilizada antes do método 'SaveAs' utilizado logo abaixo
		objUpload.SaveToMemory
		
		For Each objUploadedFile in objUpload.Files
			
			sql = "delete from SCA_ALUNO_FOTO"      
			sql = sql & " where codAluno=" & intCodAluno
			sql = sql & " and   cod_empresa=" & Session("CodEmpresa")
			cnn.execute sql
			
			sql = "Insert Into SCA_ALUNO_FOTO (cod_empresa, codAluno, caminho, arquivo)"          
			sql = sql & " Values ("
			sql = sql & "" & Session("CodEmpresa") & ","
			sql = sql & "" & intCodAluno & ","
			sql = sql & "'" & PastaFotos & "',"
			sql = sql & "'" & strMatricula & ".jpg')"
			cnn.execute sql
			
			' SALVO IMAGEM ## G ##
			ImagemTemp = PastaFotos & "\" & strMatricula & ".jpg"
			objUploadedFile.SaveAs ImagemTemp
			
			Set objJpeg = Server.CreateObject("Persits.Jpeg")
			objJpeg.Open ImagemTemp
			IF trim(orientacao) = "H" THEN 
				objJpeg.Width = 104
				objJpeg.Height = 77
			ELSE
				objJpeg.Width = 100
				objJpeg.Height = 110
			END IF
			
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