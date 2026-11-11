<!--#include file="../../includes/inc_cnn.asp"-->
<%
	intCodigo 		= Trim(Request.Form("chkCodigo"))
	vetCodigo		= split(intCodigo,",")

	strMensagem = "Material Excluido com sucesso..."
	for i=0 to ubound(vetCodigo)
	
			intCodigo	= vetCodigo(i)
			sql = " SELECT Codigo, NomeArquivo"
			sql = sql & " FROM SCA_MaterialAluno"
			sql = sql & " where cod_empresa = " & Session("CodEmpresa")	
			sql = sql & " And Codigo = " & intCodigo
			rs.open sql, cnn
			if rs.eof = false then
			
			while not rs.eof
			
				cont = cont + 1	
						
				strNomeArquivo		= rs("NomeArquivo")
					
				'Exclui PDF
				PastaImagemComum = Server.MapPath("../../MaterialAluno") & "/" & Session("CodEmpresa") & "\" & strNomeArquivo
				
				Set objFSO = CreateObject("Scripting.FileSystemObject")
				
				' Apaga o Arquivo do servidor
				IF objFSO.FileExists(PastaImagemComum) = True THEN objFSO.DeleteFile PastaImagemComum, True
				
				sql = "Delete from SCA_MaterialAluno "
				sql = sql & " where cod_empresa = " & Session("CodEmpresa")	
				sql = sql & " And Codigo = " & intCodigo
				cnn.execute sql
			
				rs.movenext
				wend
					
			end if
			rs.close
		
	next

	if err.number = 0 then
	'----------Finaliza tranzação iniciada--------------
		%>
		<script>
			alert("<%=strMensagem%>");
			window.location='MaterialAulaExcluir_con.asp';
		</script>
		<%
		response.end
	else
		response.redirect "erro.asp?strNumErro=" & err.number & "&strDescErro=" & err.description 
	end if
%>
