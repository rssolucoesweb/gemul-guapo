<script>
		function salvar(acao){
		
		var frm = document.getElementById("frm");
		var form = window.document.forms[0];
		var intContMarcado=0;
		
		frm.action = "sca_ficha_descritiva_aluno_cod.asp?acao=" + acao;
		frm.submit();
		return true;	
	}

	function limpaResposta(campo){
		var ele = document.getElementsByName(campo);
		for(var i=0;i<ele.length;i++)
			ele[i].checked = false;
	}
</script>
<%
	acao = "I"

		strExecutarSubmit                   = "S" 
	strExecutarSubmitTurma				= "S"
	strReloadDisciplinaQuadro			= "S"
	strPaginaTitulo 					= "FichaDescritivaNotas_cad.asp"
	intAnoLetivo   					 	= Trim(Request.QueryString("AnoLetivo"))	
	intCodBimestre						= Trim(Request.QueryString("cmbBimestre"))
	intSemestre   						= Trim(Request.QueryString("Semestre"))	
	intCodAluno							= Trim(Request.QueryString("CodAluno"))
	intCodFichaDescritiva				= Trim(Request.QueryString("CodFichaDescritiva"))
	intCodTurma 						= Trim(Request.QueryString("cmbTurma"))
	intCodDisciplinaTurma				= Trim(Request.QueryString("cmbDisciplinaDoProfessor"))
	intCodProfessor				        = Trim(Request.QueryString("cmbProfessor"))
	intCodTurnoRH				        = Trim(Request.QueryString("cmbTurnoRH"))
	
	if intCodFichaDescritiva 			= "" then intCodFichaDescritiva 	= "0"
	if intCodTurma 						= "" then intCodTurma 					= "0"
	if intCodDisciplinaTurma 			= "" then intCodDisciplinaTurma 		= "0"
	if intCodTurnoRH 			= "" then intCodTurnoRH 		= "0"
	cont = 0

	sql = "SELECT COD_TURNO, DESC_TURNO"
	sql = sql & " FROM SRH_TURNO"
	SQL = SQL & " WHERE COD_TURNO=" & intCodTurnoRH
	rs.open sql, cnn
	if rs.eof = false then
		strDescricaoTurnoRH	= rs("DESC_TURNO")
	end if 
	rs.close
	
	if intCodTurnoRH = "" or intCodTurnoRH = "0" then
	%>
		<script>
			alert("Turno não foi carregado!")
			window.close();
		</script>
	<%
	response.end
	end if


	' Quantidade conceito
	if intCodFichaDescritiva <> "0" then 
		
		sql = "SELECT count(Codigo) as total"
		sql = sql & " FROM SCA_FICHA_DESCRITIVA_CONCEITO"
		sql = sql & " Where cod_ficha_descritiva = " & intCodFichaDescritiva
		rs.open sql, cnn
		
		if rs.eof = false then
			intQtdeConceito = rs("total")
		end if 
		rs.close
		
	end if
	if intCodFichaDescritiva <> "0" and intCodTurma <> "0" then

		sql = " select DISTINCT TOP 1 FDPN.Codigo, FDPN.COD_TURMA, T.Cod_GradeCurricular, FDPN.Cod_Turno_Rh "
		sql = sql & " from SCA_FICHA_DESCRITIVA_PERGUNTA_NOTA FDPN "
		sql = sql & " INNER JOIN SCA_FICHA_DESCRITIVA_PERGUNTA FDP ON FDP.codigo = FDPN.Cod_Ficha_Descritiva_Pergunta " 
		sql = sql & " INNER JOIN SCA_FICHA_DESCRITIVA FD ON FD.codigo = FDP.cod_ficha_descritiva "
		sql = sql & " INNER JOIN SCA_TURMA T ON T.Cod_Turma = FDPN.Cod_Turma "
		sql = sql & " where FDPN.Cod_aluno = " & intCodAluno
		sql = sql & " and FDP.cod_ficha_descritiva = " & intCodFichaDescritiva
		sql = sql & " AND T.AnoLetivo = " & intAnoLetivo
		sql = sql & " AND T.Cod_Semestre = " & intSemestre
		sql = sql & " ORDER BY FDPN.Codigo DESC "
		if session("usuarioWeb") = "SERGIO" THEN
			'RESPONSE.WRITE sql & "<hr>"
		end if
		rs.open sql, cnn
		if rs.eof = false then
			intcodTurmaVerificacaoFicha = rs("COD_TURMA")
		else
			intcodTurmaVerificacaoFicha = "0"
		end if 
		rs.close
		
		sql = " SELECT TOP 1 AT.COD_TURMA, T.Cod_GradeCurricular, t.cod_turno " 
		sql = sql & " FROM SCA_ALUNO_TURMA AT " 
		sql = sql & " INNER JOIN SCA_TURMA T ON T.Cod_Turma = AT.Cod_Turma "
		sql = sql & " WHERE AT.COD_ALUNO = " & intCodAluno
		sql = sql & " AND AT.ANO_LETIVO = " & intAnoLetivo
		sql = sql & " AND AT.SEMESTRE = " & intSemestre
		sql = sql & " ORDER BY AT.CODIGO DESC "
		rs.open sql, cnn
		if rs.eof = false then
			intcodTurmaVerificacaoCadastro = rs("COD_TURMA")
		else
			intcodTurmaVerificacaoCadastro = "0"
		end if 
		rs.close
		

				'if session("usuarioWeb") = "SERGIO" THEN
				'	RESPONSE.WRITE "intcodTurmaVerificacaoFicha:" & intcodTurmaVerificacaoFicha & "<br>"
				'	RESPONSE.WRITE "intcodTurmaVerificacaoCadastro:" & intcodTurmaVerificacaoCadastro & "<br>"
				'end if

		if intcodTurmaVerificacaoFicha <> "0" and intcodTurmaVerificacaoCadastro <> "0" then

			strMudarTurma = "N"
			if intcodTurmaVerificacaoFicha <> intcodTurmaVerificacaoCadastro then
				strMudarTurma = "S" 
			end if
			
			if strMudarTurma = "S"  then
				sql = "  UPDATE SCA_FICHA_DESCRITIVA_PERGUNTA_NOTA SET Cod_Turno_Rh = " & intCodTurnoRH & ",Cod_Turma = " & intcodTurmaVerificacaoCadastro
				sql = sql & " WHERE COD_ALUNO = " & intCodAluno
				sql = sql & " AND Cod_Turma = " & intcodTurmaVerificacaoFicha
				if session("usuarioWeb") = "SERGIO" THEN
					'RESPONSE.WRITE SQL & "<hr>"
				end if
				cnn.execute SQL
			end if
		end if
		
	end if
			
	' Busca Tipo da Avalição
	if intCodFichaDescritiva <> "0" then 
		
		sql = "SELECT Codigo, Cod_empresa, Descricao, Ano_Letivo, Semestre, "
		sql = sql & " Observacoes, rodape"
		sql = sql & " FROM SCA_FICHA_DESCRITIVA"
		sql = sql & " Where Codigo = " & intCodFichaDescritiva
		rs.open sql, cnn
		
		if rs.eof = false then

			intCodAvaliacao			= rs("Codigo")
			strNomeAvaliacao		= rs("Descricao")
			strAnoLetivo			= rs("Ano_Letivo")
			strSemestre				= rs("Semestre")
			strObservacoes			= rs("Observacoes")
			strRodape				= rs("rodape")
		
		end if 
		rs.close
		
		sql = " SELECT CODIGO "
		sql = sql & " FROM SCA_FICHA_DESCRITIVA_CONCEITO "
		sql = sql & " where cod_ficha_descritiva = " & intCodFichaDescritiva
		rs.open sql, cnn
		if rs.eof then
			%>
			<script>
				alert("ATENÇÃO: Não existe CONCEITO definido para essa Ficha Descritiva. Verifique!");
			</script>
			<%
			response.end
		else
		    ContaConceito = 0
			While not rs.eof 
				ContaConceito = ContaConceito + 1
				rs.movenext
			wend
		end if
		rs.close

	end if
	if intCodBimestre = "" then intCodBimestre = "0"
	if intCodBimestre <> "0" then 
		sql = "SELECT descricao"
		sql = sql & " FROM SCA_bimestre"
		sql = sql & " where codigo = " & intCodBimestre
		rs.open sql, cnn
			
		if rs.eof = false then
			strDescricaoBimestre			= rs("descricao")
		else
			%>
			<script>
				alert("ATENÇÃO: Bimestre não cadastrado. Verifique!");
			</script>
			<%
			response.end
		end if 
		rs.close
	end if	
	
	if trim(intCodAluno) <> "" then
		strCaminhoFoto = session("strCaminhoRaiz") & "/fotoAluno/semFotoAtivo.gif"
		strFoto = "img/aluno-sem-foto.png"

		SQL="SELECT BASE64 FROM SCA_ALUNO_FOTO WHERE COD_ALUNO=" & intCodAluno
		RS.OPEN SQL, cnn
		IF RS.EOF = FALSE THEN
			strFoto = RS("BASE64")
		END IF
		RS.CLOSE

		
	   	sql = "SELECT MATRICULA, NOMEALUNO from sca_aluno "
	   	sql = sql & " Where codigo = " & intCodAluno				
	   	rs.open sql, cnn
  	   	if rs.eof = false then
	      strMatricula				= rs("MATRICULA")
	      strNomealuno				= rs("NOMEALUNO")
	   end if
	   rs.close	  
	end if 

%>

<!-- the #js-page-content id is needed for some plugins to initialize -->
<main id="js-page-content" role="main" class="page-content">
<form id="frm" method="post" action="sca_ficha_descritiva_alunoCon.asp">
	
	<input  name="txtCodAluno" type="hidden" class="text" id="txtCodAluno"  value="<%=intCodAluno%>" size="5" maxlength="5">
    <input  name="txtAnoLetivo" type="hidden" class="text" id="txtAnoLetivo"  value="<%=intAnoLetivo%>" size="5" maxlength="5">
    <input  name="txtSemestre" type="hidden" class="text" id="txtSemestre"  value="<%=intSemestre%>" size="5" maxlength="5">
    <input  name="txtFichaDescritiva" type="hidden" class="text" id="txtFichaDescritiva"  value="<%=intCodFichaDescritiva%>" size="5" maxlength="5">
    <input  name="txtTurma" type="hidden" class="text" id="txtTurma"  value="<%=intCodTurma%>" size="5" maxlength="5">
    <input  name="txtDisciplinaDoProfessor" type="hidden" class="text" id="txtDisciplinaDoProfessor"  value="<%=intCodDisciplinaTurma%>" size="5" maxlength="5">
    <input  name="txtProfessor" type="hidden" class="text" id="txtProfessor"  value="<%=intCodProfessor%>" size="5" maxlength="5">
    <input  name="txtBimestre" type="hidden" class="text" id="txtBimestre"  value="<%=intCodBimestre%>" size="5" maxlength="5">
    <input  name="txtCodTurnoRH" type="hidden" class="text" id="txtCodTurnoRH"  value="<%=intCodTurnoRH%>" size="5" maxlength="5">
	
	<ol class="breadcrumb page-breadcrumb">
		<li class="breadcrumb-item"><a href="javascript:void(0);"><%=sistema%></a></li>
		<li class="breadcrumb-item"><%=modulo%></li>
		<li class="breadcrumb-item active"><%=pagina%></li>
		<li class="position-absolute pos-top pos-right d-none d-sm-block"><%=session("data_hoje")%></li>
	</ol>
	<div class="subheader">
		<h1 class="subheader-title">
			<i class='subheader-icon fal fa-edit'></i> <%=pagina%>
			<small>
				<%=descricao_pagina%>
			</small>
		</h1>
	</div>
	<div class="row">
		<div class="col-xl-12">
			<div id="panel-8" class="panel">
                <div class="panel-hdr">
					<h2>
						<%=strNomeAvaliacao%> | <%=strDescricaoBimestre%> - <%=strDescricaoTurnoRH%><span class="fw-300"><i></i></span>
					</h2>
					<div class="panel-toolbar">
						<button class="btn btn-panel ni ni-chevron-down" data-action="panel-collapse" data-toggle="tooltip" data-offset="0,10" data-original-title="Recolher"></button>
						<button class="btn btn-panel ni ni-size-fullscreen" data-action="panel-fullscreen" data-toggle="tooltip" data-offset="0,10" data-original-title="Tela cheia"></button>
					</div>
				</div>
				<div class="panel-container show">
					<div class="panel-content">
						<%if mensagem_alerta_pagina<>"" then%>
						<div class="panel-tag">
							<%=mensagem_alerta_pagina%>
						</div>
						<%end if%>
						
						<input name="txtCodigo" type="hidden" id="txtCodigo" value="<%=intCodigo%>">
						<div class="row">
							<div class="col-sm-2">
								<div class="form-group">
									<img id="fotoAluno" src="<%=strFoto %>" style="border:1px solid #999999; width:50%;" />
								</div>
							</div>
							<div class="col-sm-10">
								<div class="form-group">
									<label class="form-label">Observação:</label>
									 <%=strObservacoes%>
								</div>
							</div>
						</div>
						
						<div class="row">
							
							<div class="col-sm-12">
								<div class="form-group">
									
									<%

									if intCodDisciplinaTurma <> "0" then 
										sql = " SELECT D.Cod_Disciplina, D.Desc_Disciplina as DISCIPLINA, "
									else	
										sql = " SELECT top 1 D.Cod_Disciplina, D.Desc_Disciplina as DISCIPLINA, "
									end if	
									sql = sql & " GCD.Cod_GradeCurricularDisciplina, "
									sql = sql & " T.Cod_Turma, T.NomeTurma, "
									sql = sql & " ( SELECT DISTINCT TOP 1 NOME FROM SCA_HORARIO_AULA HA "
									sql = sql & " 		INNER JOIN SRH_COLABORADOR C ON C.CODIGO = HA.Cod_Colaborador " 
									sql = sql & " 		WHERE HA.COD_EMPRESA = T.COD_EMPRESA "
									sql = sql & " 		AND HA.ANOLETIVO = T.AnoLetivo " 
									sql = sql & " 		AND HA.SEMESTRE = T.Cod_Semestre "
									sql = sql & " 		AND HA.cod_Turma = T.Cod_Turma "
									sql = sql & " 		and HA.Cod_Disciplina = D.Cod_Disciplina ) AS NOME " 
									sql = sql & " FROM  SCA_TURMA T "
									sql = sql & " INNER JOIN SCA_GRADECURRICULAR GC ON GC.Cod_GradeCurricular = T.Cod_GradeCurricular "
									sql = sql & " INNER JOIN SCA_GRADECURRICULARDISCIPLINA GCD ON GCD.Cod_GradeCurricular = GC.Cod_GradeCurricular "
									sql = sql & " INNER JOIN SCA_DISCIPLINA D ON GCD.Cod_Disciplina = D.Cod_Disciplina"
									sql = sql & " WHERE 1=1"
									sql = sql & " AND T.Cod_Empresa= " & session("CodEmpresa")
									sql = sql & " AND T.Cod_Turma = " & intCodTurma
									if intCodDisciplinaTurma <> "0" then 
										sql = sql & " AND D.Cod_Disciplina = " & intCodDisciplinaTurma
									end if
									sql = sql & " ORDER BY D.Desc_Disciplina"
									rs.open sql, cnn
									if not rs.eof then 
											
										While not rs.eof 
											
											strCodTurma			= rs("Cod_Turma") 
											strTurma			= rs("NomeTurma")
											if intCodDisciplinaTurma <> "0" then 
											   intCodDisciplina 	= rs("Cod_Disciplina")
											   strDisciplina 		= rs("DISCIPLINA")
											else   
											   intCodDisciplina 	= "0"
											   strDisciplina 		= "** InterDisciplinar **"
											end if
											if isnull(trim(rs("NOME"))) then 
												strNome 			= ""
											else
												strNome 			= rs("NOME")	
											end if 	

											' Consulta as perguntas Descritivas
											
											sql = " SELECT " 
											sql = sql & " FDP.Codigo, " 
											sql = sql & " FDP.cod_ficha_descritiva, " 
											sql = sql & " FDP.Descricao, " 
											sql = sql & " FDP.Subtitulo, "
											sql = sql & " ISNULL(FDPN.Conceito,'') as Conceito, " 
											sql = sql & " FDPN.Resposta, "
											sql = sql & " FDPN.Cod_Turno_Rh "
											sql = sql & " FROM SCA_FICHA_DESCRITIVA_PERGUNTA FDP " 
											sql = sql & " LEFT JOIN SCA_FICHA_DESCRITIVA_PERGUNTA_NOTA FDPN ON FDPN.Cod_aluno = " & intCodAluno & " "
											sql = sql & " and FDPN.Cod_Ficha_Descritiva_Pergunta = FDP.Codigo AND FDPN.Cod_Turma = " & intCodTurma & " "
											sql = sql & " AND FDPN.Cod_Bimestre = " & intCodBimestre & " AND FDPN.Cod_Disciplina = " & intCodDisciplinaTurma & " "
											sql = sql & " AND FDPN.Cod_Turno_Rh = " & intCodTurnoRH
											sql = sql & " where FDP.cod_ficha_descritiva = " & intCodFichaDescritiva
											sql = sql & " ORDER BY FDP.Codigo "
											'response.write sql
											rsAux.open sql, cnn
											if not rsAux.eof then
												%>
												
											<div class="table-responsive-lg">	
												<table class="table table-bordered table-hover m-0">
													<thead class="thead-themed">
													  <tr>
														<th><strong>Matr&iacute;cula</strong></th>
														<th><strong>Aluno</strong></th>
														<th><strong>Turma</strong></th>
														<th><strong>Disciplina</strong></th>
													  </tr>
													</thead>
													<tbody>
													
													<tr>
														<td><%=strMatricula%></td>
														<td><%=strNomealuno%></td>
														<td><%=strTurma%></td>
														<td><%=strDisciplina%></td>
													</tr>
												</table>
													
												<table class="table table-bordered table-hover m-0">
													<thead class="thead-themed">
													  <tr>
														<th colspan="4">&nbsp;</th>
														<th colspan="<%=ContaConceito+2%>"><strong>Conceito</strong></th>
													  </tr>
													</thead>
													<tbody>
																	
												<%
												cont = 0
												while not rsAux.eof
												  
														 ' Verifica qual tabela fornecerá o conceito a pergunta
														sql = " SELECT DESCRICAO "
														sql = sql & " FROM SCA_FICHA_DESCRITIVA_CONCEITO_PERGUNTA "
														sql = sql & " WHERE cod_ficha_descritiva = " & intCodFichaDescritiva
														sql = sql & " And cod_pergunta = " & rsaux("Codigo")
														rs1.open sql, cnn
														if not rs1.eof then
															strTabelaConceito = " SCA_FICHA_DESCRITIVA_CONCEITO_PERGUNTA "
														else
															strTabelaConceito = " SCA_FICHA_DESCRITIVA_CONCEITO "
														end if
														rs1.close
														
														sql = " SELECT DESCRICAO "
														sql = sql & " FROM " & strTabelaConceito
														sql = sql & " WHERE cod_ficha_descritiva = " & intCodFichaDescritiva
														if strTabelaConceito = " SCA_FICHA_DESCRITIVA_CONCEITO_PERGUNTA " then
															sql = sql & " And cod_pergunta = " & rsaux("Codigo")
														end if	
														
														'response.write sql
														
														coluna_conceito = null
														ContaConceitoPergunta = 0
														rs1.open sql, cnn
														if not rs1.eof then
															coluna_conceito = rs1.getRows
															ContaConceitoPergunta = UBound( coluna_conceito, 2 ) + 1
															ContaConceito = ContaConceitoPergunta + (intQtdeConceito - ContaConceitoPergunta  )
														else
															ContaConceito = intQtdeConceito
														end if
														rs1.close
										 
														sql = " SELECT codigo "
														sql = sql & " FROM " & strTabelaConceito
														sql = sql & " WHERE cod_ficha_descritiva = " & intCodFichaDescritiva
														if strTabelaConceito = " SCA_FICHA_DESCRITIVA_CONCEITO_PERGUNTA " then
															sql = sql & " And cod_pergunta = " & rsaux("Codigo")
														end if	
														
														cod_conceito = null
														rs1.open sql, cnn
														if not rs1.eof then
															cod_conceito = rs1.getRows
														end if
														rs1.close

														
														if mostrou_conceito = "" then
															%>
															 <tr>
																 <td colspan="4" class="celula">&nbsp;&nbsp;</td>
																<%                
																nRows = UBound( coluna_conceito, 2 )
																For row = 0 to nRows 
																	For col = 0 to UBound( coluna_conceito, 1 ) 
																	   %>
																	   <td align="center"><strong><%=ucase(coluna_conceito(col,row))%></strong></td>
																	   <%
																	   titulo_conceito_impresso = ucase(coluna_conceito(col,row))
																	 Next
																Next
																%> 
																<td align="center">&nbsp;</td>
															</tr>
															<%
															mostrou_conceito =""
														end if
														
														intCod_Ficha_Descritiva_Pergunta = rsAux("codigo")
														intCodItemAvaliacao = rsAux("codigo")
														strResposta = rsAux("Resposta")	
														strConceito = rsAux("Conceito")	
														
												
														if trim(rsAux("Subtitulo")) <> "" then
														   %>
															<tr>
															<td bgcolor="#d7f6ca" height="21" colspan="<%=ContaConceito+5%>"><strong><%=trim(rsAux("Subtitulo"))%></strong></td>
															</tr>
															<%
														end if
														%>	
														<tr>
														<td  bgcolor="#CCF5FE" height="21" colspan="<%=ContaConceito+5%>">
														<input name="chkAvaliacao" type="hidden" id="chkAvaliacao" value="<%=intCodItemAvaliacao%>" checked <%=strDesabilitaAluno%> >
														<input name="txtCod_Ficha_Descritiva_Pergunta<%=cont%>" value="<%=intCod_Ficha_Descritiva_Pergunta%>"  type="hidden" class="text" id="txtCod_Ficha_Descritiva_Pergunta<%=cont%>" size="5"><%=trim(rsAux("Descricao"))%>               </td>
														</tr>
														<tr>
														<td height="30" colspan="4"><p>
														  <textarea name="txtResposta_<%=cont%>" cols="90" rows="5" class="form-control" id="txtResposta_<%=cont%>"><%=strResposta%></textarea><br>
														  <span class="style1">Obs.: O Campo permite no Maximo 4.000 caracteres, Fique Atento!</span></td>
														<%    

														nRows = UBound( cod_conceito, 2 )
														For row = 0 to nRows 
															For col = 0 to UBound( cod_conceito, 1 ) 
															   %>
																<td height="30" align="center"><input name="txtConceito_<%=cont%>" type="radio" value="<%=ucase(cod_conceito(col,row))%>" <%if trim(strConceito) = trim(ucase(cod_conceito(col,row))) then response.Write("checked")%>></td>			
															   <%
															 Next
														Next
														%> 
														 <td align="center">
														 <button onClick="limpaResposta('txtConceito_<%=cont%>')" type="button" class="btn btn-outline-warning">Limpar Resposta</button>
														 </td>         		  		
														</tr>
														
														<%
														cont = cont + 1 
														rsAux.movenext
														acao = "IE"
												wend
												rsAux.close
											else
												rsAux.close 	
											end if
											rs.movenext
											%>
											</table>
											</div>
											<%
										wend
									end if
								%>
							
								</div>
							</div>
												
						</div>	
						<br>
						<div class="frame-wrap">
							<%if intCodFichaDescritiva <> 0 then %>
								<!--#include file="includes/inc_botoes_cadastroPopap.asp"-->
							<%end if%>
						</div>
							
					</div>
				</div>
			</div>
		</div>
	</div>
	
	
	</form>
</main>
<!-- this overlay is activated only when mobile menu is triggered -->
<div class="page-content-overlay" data-action="toggle" data-class="mobile-nav-on"></div>