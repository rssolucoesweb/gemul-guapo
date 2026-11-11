<!--
	::	SIGE
	::	Data de Criação...: 10/09/2004
	::	Desenvolvedores...: Roberto Barbosa Silva - Roberto.barbosa@see.go.gov.br
	::	Objetivo Pagina...: Códigos Inserir, Alterar e Excluir da página sia_SalaAula_cad.asp
	::	Data Atualizacao..: 
	::	Motivo Atualizacao: 
-->
<!--#include file="../../includes/inc_cnn.asp"-->
<!--#include file="../../includes/inc_formataData.asp"-->
<!--#include file="../../includes/inc_replaceRequest.asp"-->
<!--#include file="../../includes/inc_log.asp"-->

<%
	
on error resume next
	cnn.begintrans
	acao = Trim(Request.QueryString("acao"))
	
	intCodambiente_ue			= Trim(Request.form("txtHiddenCodigo"))
	intCodUnidEnsino 			= session("strCodigoSIA")
	intCodAmbiente				= "27"' Codigo da Sala de Aula
	intCodFuncionalidade		= "1" ' Codigo Pedagogico
	strNumNomeSalaDescricao		= ReplaceRequest(Trim(Request.form("txtNumNomeSalaDescricao")))
	strFuncaoOriginal			= ReplaceRequest(Trim(Request.form("txtFuncaoOriginal")))
	strComprimento				= ReplaceRequest(Trim(Request.form("txtComprimento")))
	strLargura					= ReplaceRequest(Trim(Request.form("txtLargura")))
	strPeDireito				= ReplaceRequest(Trim(Request.form("txtPeDireito")))
	strArea    					= ReplaceRequest(Trim(Request.form("txtArea")))
	strCapacidade 			= ReplaceRequest(Trim(Request.form("txtCapacidade")))
	strSituacao					= Trim(Request.Form("cmbSituacao"))
		
	' Dados do Imovel
	intCodigoImovel				= Trim(Request.Form("txtCodigoImovel"))
	intCodOutroImovel			= Trim(Request.Form("cmbImovel"))
	
	if intCodigoImovel = "" then intCodigoImovel = "0"
	if intCodOutroImovel = "" then intCodOutroImovel = "0"

	' Usuario 
	strUsuario_incl 			= session("strUsuario")
	strData_hora_incl 			= formataDataBd(date) & " " & time
	strUsuario_altr 			= session("strUsuario")
	strData_hora_altr			= formataDataBd(date) & " " & time
	
	
	
		
	if acao="I" then
	
		strMensagem = session("strMensagemInclusao")
		
		' Faz o incremento do codigo
		sql = "SELECT Max(Codigo) as Maior" 
		sql = sql & " FROM SIA_ambiente_ue"
		sql = sql & " where codigo_sia_unid_ensino = " & intCodUnidEnsino
		sql = sql & " and codigo <> 999 "
		
		rs.OPEN SQL, CNN
		
		if not RS.EOF then
			if rs("Maior") <> "" then 
				intCodambiente_ue  = cstr(rs("Maior")) + 1
				if intCodambiente_ue = 999 then intCodambiente_ue = intCodambiente_ue + 1
			else
				intCodambiente_ue = 1	
			end if
		end if 				
		rs.close
		
		sql = "Insert Into SIA_ambiente_ue ( codigo, codigo_sia_unid_ensino, codigo_sia_func_ambiente, codigo_sia_conj_ambiente," 
		sql = sql & " descricao, funcao_original, outra_funcao_original, comprimento, largura, area, capacidade, pe_direito, "
		sql = sql & " quantidade, inst_eletrica_funcionamento, circ_independente_forca_ilum," 
		sql = sql & " qtd_tomadas, qtd_lampadas, ilum_2x40_8m, menor_grau_iluminacao_fluorte, maior_grau_iluminacao_fluorte," 
		sql = sql & " ilamp_100_6m, menor_grau_iluminacao_incand, maior_grau_iluminacao_incand, comp_area_abert_janela,"
		sql = sql & " alt_area_abert_janela, comp_area_elemento_vazado, alt_area_elemento_vazado, existe_ventilacao_cruzada," 
		sql = sql & " existe_grade_protecao_porta, existe_grade_protecao_janela, altura_barra_protecao_lavavel, codigo_status, "
		sql = sql & " usuario_incl, data_hora_incl, usuario_altr, data_hora_altr )"     
		sql = sql & " Values ("
		
		if intCodambiente_ue <> "" then
			sql = sql & "" & intCodambiente_ue & ","
		else
			sql = sql & "null,"
		end if
		
		if intCodUnidEnsino <> "" then
			sql = sql & "" & intCodUnidEnsino & ","
		else
			sql = sql & "null,"
		end if
		
		if intCodAmbiente <> "" then
			sql = sql & "" & intCodAmbiente & ","
		else
			sql = sql & "null,"
		end if
		
		if intCodFuncionalidade <> "" then
			sql = sql & "" & intCodFuncionalidade & ","
		else
			sql = sql & "null,"
		end if
		
		if strNumNomeSalaDescricao <> "" then
			sql = sql & "'" & strNumNomeSalaDescricao & "',"
		else
			sql = sql & "null,"
		end if
		
		if strFuncaoOriginal <> "" then
			sql = sql & "'" & strFuncaoOriginal & "',"
		else
			sql = sql & "null,"
		end if
		
		sql = sql & "" & "null, " 'outra_funcao_original
	
		if strComprimento <> "" then
			sql = sql & "'" & strComprimento & "',"
		else
			sql = sql & "null,"
		end if
		
		if strLargura <> "" then
			sql = sql & "'" & strLargura & "',"
		else
			sql = sql & "null,"
		end if
		
		if strArea <> "" then
			sql = sql & "'" & strArea & "',"
		else
			sql = sql & "null,"
		end if
	
		if strCapacidade <> "" then
			sql = sql & "" & strCapacidade & ","
		else
			sql = sql & "null,"
		end if
		
		if strPeDireito <> "" then
			sql = sql & "'" & strPeDireito & "',"
		else
			sql = sql & "null,"
		end if
		
		sql = sql & "null, null, null, null, null, null, null, null, null, null,"
		sql = sql & "null, null, null, null, null, null, null, null, null,"
		
		if strSituacao <> "" then
			sql = sql & "" & strSituacao & ","
		else
			sql = sql & "null,"
		end if
	
		' Usuario
		if strUsuario_incl <> "" then
			sql = sql & "'" & strUsuario_incl & "',"
		else
			sql = sql & "null,"
		end if
		
		if strData_hora_incl <> "" then
			sql = sql & "'" & strData_hora_incl & "',"
		else
			sql = sql & "null,"
		end if
	
		' Campos nulos para campo Usuario Alteracao e data Alteracao
		sql = sql & "" & "null, null" & ")"
		
		cnn.execute sql
GravarLog sql
'------------------Grava  dados Imoveis ----------------------------------
		
		if intCodOutroImovel <> "0" then 
		
			' Faz o incremento do codigo
			sql = "SELECT Max(Codigo) as Maior" 
			sql = sql & " FROM SIA_sala_outro_imovel"
			sql = sql & " where codigo_sia_unid_ensino = " & intCodUnidEnsino
			
			rs.OPEN SQL, CNN
			
			if not RS.EOF then
				if rs("Maior") <> "" then 
					intCodigoImovel = cstr(rs("Maior")) + 1
				else
					intCodigoImovel = 1	
				end if
			end if 
			rs.close
	
			sql = "Insert Into SIA_sala_outro_imovel( codigo, codigo_sia_outro_imovel, codigo_sia_ambiente_ue, codigo_sia_unid_ensino," 
			sql = sql & " usuario_incl, data_incl, usuario_altr, data_altr)"     
			sql = sql & " Values ("
			
			if intCodigoImovel <> "" then
				sql = sql & "" & intCodigoImovel & ","
			else
				sql = sql & "null,"
			end if
			
			if intCodOutroImovel <> "" then
				sql = sql & "" & intCodOutroImovel & ","
			else
				sql = sql & "null,"
			end if
	
			if intCodambiente_ue <> "" then
				sql = sql & "" & intCodambiente_ue & ","
			else
				sql = sql & "null,"
			end if
			
			if intCodUnidEnsino <> "" then
				sql = sql & "" & intCodUnidEnsino & ","
			else
				sql = sql & "null,"
			end if
		
			' Usuario
			if strUsuario_incl <> "" then
				sql = sql & "'" & strUsuario_incl & "',"
			else
				sql = sql & "null,"
			end if
			
			if strData_hora_incl <> "" then
				sql = sql & "'" & strData_hora_incl & "',"
			else
				sql = sql & "null,"
			end if
		
			' Campos nulos para campo Usuario Alteracao e data Alteracao
			sql = sql & "" & "null, null" & ")"
		
			cnn.execute sql
GravarLog sql
end if 
				
	elseif acao="A" then
	
		if strSituacao = "6" then 'inativa'
			'verificar se existem turmas cadastradas para esta esta sala no ano corrente'
			sql = "SELECT SIA_ambiente_ue.descricao, AVE_turma.nome"
			sql = sql & " FROM SIA_ambiente_ue INNER JOIN AVE_turma ON (SIA_ambiente_ue.codigo_sia_unid_ensino = AVE_turma.codigo_sia_unid_ensino) AND (SIA_ambiente_ue.codigo = AVE_turma.num_sala)"
			sql = sql & " WHERE AVE_turma.ano_letivo=" & session("strAnoLetivo") & " AND AVE_turma.codigo_sia_unid_ensino=" & intCodUnidEnsino
			sql = sql & " and SIA_ambiente_ue.codigo = " & intCodambiente_ue
			if intCodSemestre <> "" and intCodSemestre <> "0" then
				sql = sql & " and AVE_turma.semestre = " & intCodSemestre
			end if
		
			rs.open sql, cnn
			if not rs.eof then
				turmas = ""
				while not rs.eof 
					if turmas <> "" then turmas = turmas + "/"
					turmas = turmas + rs("nome")
					rs.movenext
				wend
				rs.close
				%>
				<script>
						alert("Esta sala possui vínculo com a(s) turma(s): " + "<%=turmas%>" + " neste ano letivo. Para inativá-la é necessário inicialmente excluir este(s) vínculo(s)!")
						window.history.back();
				</script>
			<% 
			response.end
			end if
			rs.close
		end if
		strMensagem = session("strMensagemAlteracao")	
			
		sql = " Update SIA_ambiente_ue Set"
			
		if strNumNomeSalaDescricao <> "" then
			sql = sql & " descricao = '" & strNumNomeSalaDescricao & "',"
		else
			sql = sql & " descricao = null," 
		end if
		
		if strFuncaoOriginal <> "" then
			sql = sql & " funcao_original = '" & strFuncaoOriginal & "',"
		else
			sql = sql & " funcao_original = null," 
		end if
		
		if strComprimento <> "" then
			sql = sql & " comprimento = '" & strComprimento & "',"
		else
			sql = sql & " comprimento = null," 
		end if
		
		if strLargura <> "" then
			sql = sql & " largura = '" & strLargura & "',"
		else
			sql = sql & " largura = null," 
		end if
		
		if strArea <> "" then
			sql = sql & " area = '" & strArea & "',"
		else
			sql = sql & " area = null," 
		end if
		
		if strCapacidade <> "" then
			sql = sql & " capacidade = " & strCapacidade & ","
		else
			sql = sql & " capacidade = null," 
		end if
		
		if strPeDireito <> "" then
			sql = sql & " pe_direito = '" & strPeDireito & "',"
		else
			sql = sql & " pe_direito = null," 
		end if
		
		if strSituacao <> "" then
			sql = sql & " codigo_status = " & strSituacao & ","
		else
			sql = sql & " codigo_status = null," 
		end if
		
		' Usuario
		If strUsuario_altr <> "" then
			sql = sql & " usuario_altr = '" & strUsuario_altr & "',"
		else
			sql = sql & " usuario_altr = null,"
		end if 
	
		if strdata_hora_altr <> "" then
			sql = sql & " data_hora_altr = '" & strdata_hora_altr & "'"
		else
			sql = sql & " data_hora_altr = null"
		end if 
	
		sql = sql & " WHERE codigo = " & intCodambiente_ue
		sql = sql & " AND codigo_sia_unid_ensino = " & intCodUnidEnsino

		cnn.execute sql
GravarLog sql
'---------------Altera dados Imoveis------------------------------------------
		if intCodOutroImovel <> "0" then 
	
			sql = "Select  codigo"
			sql = sql & " FROM SIA_sala_outro_imovel"
			sql = sql & " WHERE codigo = " & intCodigoImovel
			
			rs.OPEN SQL, CNN,3,1
			
			if not RS.EOF then
	
				sql = " Update SIA_sala_outro_imovel Set"
				
				if intCodImovel <> "0" then
					sql = sql & " codigo_sia_outro_imovel = " & intCodOutroImovel & ","
				else
					sql = sql & " codigo_sia_outro_imovel = null," 
				end if
					
				' Usuario
				If strUsuario_altr <> "" then
					sql = sql & " usuario_altr = '" & strUsuario_altr & "',"
				else
					sql = sql & " usuario_altr = null,"
				end if 
			
				if strdata_hora_altr <> "" then
					sql = sql & " data_altr = '" & strdata_hora_altr & "'"
				else
					sql = sql & " data_altr = null"
				end if 
				
				sql = sql & " WHERE codigo = " & intCodigoImovel
				sql = sql & " AND codigo_sia_unid_ensino = " & intCodUnidEnsino
				
				cnn.execute sql
GravarLog sql
else
				rs.close
				' Faz o incremento do codigo
				sql = "SELECT Max(Codigo) as Maior" 
				sql = sql & " FROM SIA_sala_outro_imovel"
				sql = sql & " where codigo_sia_unid_ensino = " & intCodUnidEnsino
		
				rs.OPEN SQL, CNN
				
				if not RS.EOF then
					if rs("Maior") <> "" then 
						intCodigoImovel = cstr(rs("Maior")) + 1
					else
						intCodigoImovel = 1	
					end if
				end if 
				rs.close
			
				sql = "Insert Into SIA_sala_outro_imovel( codigo, codigo_sia_outro_imovel, codigo_sia_ambiente_ue, codigo_sia_unid_ensino," 
				sql = sql & " usuario_incl, data_incl, usuario_altr, data_altr)"     
				sql = sql & " Values ("
				
				if intCodigoImovel <> "" then
					sql = sql & "" & intCodigoImovel & ","
				else
					sql = sql & "null,"
				end if
				
				if intCodOutroImovel <> "" then
					sql = sql & "" & intCodOutroImovel & ","
				else
					sql = sql & "null,"
				end if
		
				if intCodambiente_ue <> "" then
					sql = sql & "" & intCodambiente_ue & ","
				else
					sql = sql & "null,"
				end if
				
				if intCodUnidEnsino <> "" then
					sql = sql & "" & intCodUnidEnsino & ","
				else
					sql = sql & "null,"
				end if
			
				' Usuario
				if strUsuario_incl <> "" then
					sql = sql & "'" & strUsuario_incl & "',"
				else
					sql = sql & "null,"
				end if
				
				if strData_hora_incl <> "" then
					sql = sql & "'" & strData_hora_incl & "',"
				else
					sql = sql & "null,"
				end if
			
				' Campos nulos para campo Usuario Alteracao e data Alteracao
				sql = sql & "" & "null, null" & ")"
			
				cnn.execute sql
GravarLog sql
end if 
		
		end if			

	else
		'verificar se existem turmas cadastradas para esta esta sala no ano corrente'
		sql = "SELECT SIA_ambiente_ue.descricao, AVE_turma.nome, ave_turma.ano_letivo"
		sql = sql & " FROM SIA_ambiente_ue INNER JOIN AVE_turma ON (SIA_ambiente_ue.codigo_sia_unid_ensino = AVE_turma.codigo_sia_unid_ensino) AND (SIA_ambiente_ue.codigo = AVE_turma.num_sala)"
		sql = sql & " WHERE AVE_turma.codigo_sia_unid_ensino=" & intCodUnidEnsino
		sql = sql & " and SIA_ambiente_ue.codigo = " & intCodambiente_ue
	
		rs.open sql, cnn
		if not rs.eof then
			rs.close
			%>
			<script>
					alert("Não é permitido excluir esta sala. Ela possui vínculo com turma(s).")
					window.history.back();
			</script>
		<% 
		response.end
		end if
		rs.close
		
		strMensagem = session("strMensagemExclusao")
	
		if intCodImovel <> "0" then 
			' Dados Imoveis
			sql = "Delete From SIA_sala_outro_imovel"
			sql = sql & " WHERE codigo = " & intCodigoImovel
			sql = sql & " AND codigo_sia_unid_ensino = " & intCodUnidEnsino
			cnn.execute sql
			GravarLog sql
end if
			
		sql = "Delete From SIA_ambiente_ue"
		sql	= sql & " WHERE codigo = " & intCodambiente_ue
		sql = sql & " AND codigo_sia_unid_ensino = " & intCodUnidEnsino
	
		cnn.execute sql
		GravarLog sql
end if
		
	if err.number = 0 then
		cnn.commitTrans
		%>
		<script>
			alert("<%=strMensagem%>");
			window.location='sia_SalaAula_cad.asp';
		</script>
		<%
		response.end
	else
		response.redirect "../../erro.asp?strNumErro=" & err.number & "&strDescErro=" & err.description & "&strPaginaErro='modulos/redeFisica/sia_SalaAula_cad.asp'"
		cnn.rollbacktrans
	end if
%>