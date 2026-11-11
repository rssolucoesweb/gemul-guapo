<!--
	::	Empresa...........: RS Soluções web - www.rssolucoesweb.com.br
    ::	Data de Criação...: 19/05/2011
	::	Desenvolvedores...: Roberto Barbosa Silva - roberto@rssolucoesweb.com.br
	::	Objetivo Pagina...: Cadastro de Foto do Album
	::	Data Atualizacao..: 
	::	Motivo Atualizacao: 
-->
<!--#include file="../../../includes/inc_cnn.asp"-->
<!--#include file="../../../includes/inc_formatadata.asp"-->
<%
	'on error resume next
	'----------Inicia uma tranzação--------------
	cnn.begintrans
	
	intCodAlbum 	 = request("CodAlbum")
	orientacao		 = request("orientacao")
	
	Set objFSO = CreateObject("Scripting.FileSystemObject")
	
	'Cria a pasta de acordo com codigo do Imovel
	PastaEmpresa = Server.MapPath("../../../FotoAlbum")  & "\" & session("codEmpresa")
	
	IF Not objFSO.FolderExists(PastaEmpresa) THEN
		objFSO.CreateFolder(PastaEmpresa)
	END IF
	
	PastaFotos = Server.MapPath("../../../FotoAlbum")  & "/" & session("codEmpresa")  & "\" & intCodAlbum
	
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
		
		strDescricao =  objUpload.Form("Descricao")
				
		For Each objUploadedFile in objUpload.Files

			sql = "SELECT Count(*) As Total" 
			sql = sql & " FROM SIT_AlbumFoto"
			sql = sql & " Where CodAlbum = " & intCodAlbum
			rs.open sql, cnn
			
			if not RS.EOF then
				if rs("Total") <> "" then
					qFotos = Rs("Total")
				end if
			end if
			rs.close
			
			if trim(qFotos) = "" or  isNull(qFotos) then
				qFotos = 0 
			end if
			
			if trim(qFotos) = 0  then
				tDestaque	= "1"
			else
				tDestaque	= "0"
			end if
			
			sql = "SELECT Max(id) as MaiorCodigo" 
			sql = sql & " FROM SIT_AlbumFoto"
			sql = sql & " Where CodAlbum = " & intCodAlbum
			rs.open sql, cnn
			
			if not RS.EOF then
				if trim(rs("MaiorCodigo")) <> "" then
					uID = cstr(rs("MaiorCodigo")) + 1
				else
					uID = 1	
				end if
			end if
			rs.close
			
			' Busca maior ordem
			sql = "SELECT Max(Ordem) as MaiorOrdem" 
			sql = sql & " FROM SIT_AlbumFoto"
			sql = sql & " Where CodAlbum = " & intCodAlbum
			rs.open sql, cnn,3,3
			
			if not RS.EOF then
				if trim(rs("MaiorOrdem")) <> "" then
					intOrdem 		= cstr(rs("MaiorOrdem")) + 1
				else
					intOrdem 		= 1	
				end if
			end if
			rs.close
			
			sql = "Insert Into SIT_AlbumFoto(id, CodAlbum, Descricao, Destaque, orientacao, Ordem)"          
			sql = sql & " Values ("
			sql = sql & "" & uID & ","
			sql = sql & "" & intCodAlbum & ","
			
			if strDescricao <> "" then
				sql = sql & "'" & trim(strDescricao) & "',"
			else
				sql = sql & "null,"
			end if
			
			sql = sql & "" & tDestaque & ","
			sql = sql & "'" & orientacao & "',"
			sql = sql & "" & intOrdem & ")"
			cnn.execute sql
			GravarLog sql, nomePagina(request.ServerVariables("SCRIPT_NAME"))
										
			'' SALVO IMAGEM ## G ##
			ImagemTemp = PastaFotos & "\" & uID & "_g.jpg"
			objUploadedFile.SaveAs ImagemTemp
			
			Set objJpeg_g = Server.CreateObject("Persits.Jpeg")
			objJpeg_g.Open ImagemTemp

			if trim(orientacao) = "H" then
				Formato = "horizontal"
				objJpeg_g.Width = 400
				objJpeg_g.Height = 600
			else
				Formato = "vertical"
				objJpeg_g.Width = 600
				objJpeg_g.Height = 400
			end if
			
			'Colocando texto sobre imagem
			objJpeg_g.Canvas.Font.Color = &HFFFFFF' branco
			objJpeg_g.Canvas.Font.Family = "Tahoma"
			objJpeg_g.Canvas.Font.Bold = True
			objJpeg_g.Canvas.Font.Size = 18
			
			IF trim(orientacao) = "H" THEN 
				'objJpeg_g.Canvas.Print objJpeg_g.Width-280, objJpeg_g.Height-25, "MRJ M. Importados"
			else
				'objJpeg_g.Canvas.Print objJpeg_g.Width-215, objJpeg_g.Height-25, "MRJ M. Importados"
			END IF
			
			objJpeg_g.Sharpen 1, 130
			objJpeg_g.Save ImagemTemp
			Set objJpeg_g = Nothing
							
			objFSO.CopyFile ImagemTemp, Replace(ImagemTemp, "_g.jpg", "_m.jpg"), True
			objFSO.CopyFile ImagemTemp, Replace(ImagemTemp, "_g.jpg", "_p.jpg"), True
										
			'' SALVO IMAGEM ## M ##
			ImagemTemp_m = PastaFotos & "\" & uID & "_m.jpg"
			Set objJpeg_m = Server.CreateObject("Persits.Jpeg")
			objJpeg_m.Open ImagemTemp_m
			
			IF trim(orientacao) = "H" THEN 
				objJpeg_m.Width = 133
				objJpeg_m.Height = 200								
			ELSE
				objJpeg_m.Width = 200
				objJpeg_m.Height = 133
			END IF
			
			objJpeg_m.Sharpen 1, 130
			objJpeg_m.Save ImagemTemp_m
			Set objJpeg_m = Nothing
		
			'' SALVO IMAGEM ## P ##
			ImagemTemp_p = PastaFotos & "\" & uID & "_p.jpg"
			Set objJpeg_p = Server.CreateObject("Persits.Jpeg")
			objJpeg_p.Open ImagemTemp_p
			
			IF trim(orientacao) = "H" THEN 
				objJpeg_p.Width = 67
				objJpeg_p.Height = 100
			ELSE
				objJpeg_p.Width = 100
				objJpeg_p.Height = 67
			END IF
			
			objJpeg_p.Sharpen 1, 130
			objJpeg_p.Save ImagemTemp_p
			Set objJpeg_p = Nothing
			
			if uID = 1 then
				FotoDestaque = uID 
				sql = "Update SIT_Album Set "
				sql = sql & " fotoDestaque = '" & FotoDestaque & "'"
				sql = sql & " Where CodAlbum = " & intCodAlbum
				cnn.execute sql
				GravarLog sql, nomePagina(request.ServerVariables("SCRIPT_NAME"))
			end if
	
			EnvioOk = True
		
 		Next
					
		IF EnvioOk = True THEN	
			strMensagem = "Foto do Album enviada com sucesso"	
		ELSE
			strMensagem = "Foto do Album NÃO foi enviada, verifique as informações postadas."		
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
			 window.location='AlbumFoto_cad.asp?CodAlbum=<%=intCodAlbum%>';
		</script>
		<%
		response.end
	else
		response.Write(err.description)
		cnn.rollbacktrans
	end if
%>