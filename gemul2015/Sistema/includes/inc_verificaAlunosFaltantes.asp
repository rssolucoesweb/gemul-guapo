<%
	'verifica se tem mensagem configurada
	sql = "select m.quantidade_maior, m.mensagem "
	sql = sql & " from SEG_CONFIGURAR_MENSAGEM m "
	sql = sql & " inner join SEG_CONFIGURAR_MENSAGEM_PERFIL p on p.cod_configurar_mensagem = m.codigo "
	sql = sql & " where p.cod_perfil in (" & Session("CodPerfilUsuario") & ")"
	sql = sql & " and m.tipo = 'QUANTIDADE_FALTAS'"
	sql = sql & " and m.cod_grupo = " & session("CodGrupo")
	rsAux.open sql, cnn
	if not rsAux.eof then
		mensagemAlerta = rsAux("mensagem")
		quantidadeMaior = rsAux("quantidade_maior")
	end if
	rsAux.close
	
	msn = ""
	sql = "exec SP_SCA_AlunosFaltantes " & session("strAnoLetivo") & "," & session("strSemestre") & "," & session("codGrupo") & "," & session("codEmpresa") & "," & quantidadeMaior 
	rsAux.open sql, cnn
	if not rsAux.eof then
		msn = mensagemAlerta & "\n"
		while not rsAux.eof
			msn = msn & rsAux("periodo") & " - " & rsAux("matricula") & " - " & rsAux("aluno") & " (" & rsAux("faltas") & " faltas)\n"
			
			rsAux.movenext
		wend
	end if
	rsAux.close
	
	if msn <> "" then
		%>
		<script>
			alert("<%=msn%>");
			window.close();
		</script>
		<%
	end if
%>