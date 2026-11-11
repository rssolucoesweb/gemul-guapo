<!--
	::	DESENVOLVIDO POR "RS SOLUÇÕES WEB - www.rssolucoesweb.com.br"
	::	Data de Criação...: 23/04/2009
	::	Desenvolvedores...: Roberto Barbosa Silva - robertobs7@gmail.com
	::	Objetivo Pagina...: Cadastro de Modelo de Carteirinhas 
-->
<!--#include file="../../includes/inc_cnn.asp"-->
<%
	'on error resume next
	'----------Inicia uma tranzação--------------
	cnn.begintrans
	
	intCodEmp  = Session("CodEmpresa")
	
	Set objFSO = CreateObject("Scripting.FileSystemObject")
	
	'Cria a pasta de acordo com codigo do Imovel
	PastaFotos = Server.MapPath("../../ModeloCarteirinhas") & "\" & intCodEmp
		
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
		
		strDescricao 	= objUpload.Form("txtDescricao")

		For Each objUploadedFile in objUpload.Files
			
			' Pega o nome da carteirinha		
			strModelo = objUpload.GetFileName(objUploadedFile.OriginalPath)
				
			sql = "SELECT Max(Codigo) as MaiorCodigo" 
			sql = sql & " FROM SCA_ModeloCarteirinhas"
			sql = sql & " Where cod_empresa = " & intCodEmp
			rs.open sql, cnn
			
			if not RS.EOF then
				if trim(rs("MaiorCodigo")) <> "" then
					intCodigo 		= cstr(rs("MaiorCodigo")) + 1
					strDestaque		= "N" 
				else
					intCodigo 		= 1	
					strDestaque		= "S" 
				end if
			end if
			rs.close
			
			sql = "Insert Into SCA_ModeloCarteirinhas(Codigo, cod_empresa, Descricao, Modelo, Destaque)"          
			sql = sql & " Values ("
			sql = sql & "" & intCodigo & ","
			sql = sql & "" & intCodEmp & ","
			sql = sql & "'" & strDescricao & "',"
			sql = sql & "'" & strModelo & "',"
			sql = sql & "'" & strDestaque & "')"
			cnn.execute sql
										
			'' SALVO IMAGEM ## G ##
			ImagemTemp = PastaFotos & "\" & strModelo 
			objUploadedFile.SaveAs ImagemTemp
			
			Set objJpeg_g = Server.CreateObject("Persits.Jpeg")
			objJpeg_g.Open ImagemTemp

			'Formato = "horizontal"
			objJpeg_g.Width = 651
			objJpeg_g.Height = 221
		
			'objJpeg_g.Canvas.Print objJpeg_g.Width-280, objJpeg_g.Height-25, "www.fanap.br"
			
			EnvioOk = True
		
 		Next
					
		IF EnvioOk = True THEN	
			strMensagem = "Modelo da Carteirinha enviada com sucesso"	
		ELSE
			strMensagem = "Modelo da Carteirinha NÃO foi enviado, verifique as informações postadas."		
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
			 window.location='ModeloCarteirinhas_cad.asp';
		</script>
		<%
		response.end
	else
		response.Write(err.description)
		cnn.rollbacktrans
	end if
%>