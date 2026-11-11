<%
	Function PaginaPermitida(pagina)
		Dim paginas, i
		
		paginas = Array( _
			"transporte.asp", _
			"atendimento.asp", _
			"academico.asp", _
			"esporte.asp", _
			"tutorial.asp", _
			"matricula.asp", _
			"planejamento.asp", _
			"sca_planejamento_professor.asp", _
			"sca_planejamento_professor_aula.asp", _
			"sca_conteudo_ministrado.asp", _
			"sca_conteudo_ministrado_aula.asp", _
			"mat_efetivacaoCon.asp", _
			"efetivacaoAluno_con.asp", _
			"sca_historico_escolar.asp", _
			"sca_lancamento_notas.asp" _
		)
		
		For i = 0 To UBound(paginas)
			If LCase(pagina) = LCase(paginas(i)) Then
				PaginaPermitida = True
				Exit Function
			End If
		Next
		
		PaginaPermitida = False
	End Function

	if pagina_atual <>"" then 

		pagina_nome = Mid(Split(pagina_atual,"?")(0), InStrRev(Split(pagina_atual,"?")(0),"/")+1)
		
		If Not PaginaPermitida(pagina_nome) Then
			usuarioTemAcesso = "N"
			
			'VERIFICA SE O USUARIO TEM PERMISSÃO PARA ACESSA A PAGINA ATUAL'
			sql = "SELECT ISS.ITEM_CODG "
			sql = sql & " FROM SEG_ACESSOS_USUARIO AC"
			sql = sql & " INNER JOIN SEG_PERFIS_ITENS_SISTEMA PP ON PP.PITE_PERF_CODG = AC.ACES_PERF_CODG"
			sql = sql & " INNER JOIN SEG_ITENS_SISTEMA ISS ON ISS.ITEM_CODG = PP.PITE_ITEM_CODG"
			sql = sql & " WHERE AC.ACES_USUA_CODG='" & session("usuarioWeb")& "'"
			sql = sql & " AND ISS.ITEM_INFO_URL_NOVO like '%" & pagina_nome & "%'"
			sql = sql & " AND ISS.ITEM_STAT='A'"
			rs.open sql, cnn
			if not rs.eof then
				usuarioTemAcesso = "S"
			end if
			rs.close
					
			if usuarioTemAcesso = "N" then
				if session("usuarioWeb")="SERGIO" then
				%>
				<script>
					//alert('<%=pagina_nome%>');
				</script>	
				<%
				end if
				%>
				<script>
					//alert("Atenção: Você não tem acesso a essa funcionalidade!");
					//window.history.back()
				</script>	
				<%
				
				'response.End()
			end if
		end if
	end if
%>