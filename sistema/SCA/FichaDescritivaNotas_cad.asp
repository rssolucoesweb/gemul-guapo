<!--
	::	DESENVOLVIDO POR "RS SOLUÇÕES WEB - www.rssolucoesweb.com.br"
	::	Data de Criação...: 04/05/2011
	::	Desenvolvedores...: Roberto Barbosa - roberto@rssolucoesweb.com.br
	::	Objetivo Pagina...: Ficha descritiva - Notas
-->
<html>
<head>
<title><%=session("Titulo")%></title>
<link type="text/css" rel="stylesheet" href="../../Estilo/css.css">
<style type="text/css">
<!--
.style1 {
	color: #FF0000;
	font-weight: bold;
}
-->
</style>
</head>
<body>
<script src="../../js/js_funcoes_gerais.js"></script>
<script type="text/javascript" src="../../js/js_dragdrop.js"></script>
<!--include file="../../includes/inc_verificaSession.asp"-->
<!--#include file="../../includes/inc_cnnDocumento.asp"-->
<!--#include file="../../includes/inc_formatadata.asp"-->
<!--#include file="../includes/inc_sqlAlunoTurma.asp"-->
<!--#include file="../includes/inc_CompartilharDadosCadastrais.asp"-->

<script>
	
	function salvar(acao){
		
		var frm = document.getElementById("frm");
		var form = window.document.forms[0];
		var intContMarcado=0;
		
		frm.action = "FichaDescritivaNotas_cod.asp?acao=" + acao;
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
	
	cont = 0

	sql = "SELECT COD_TURNO, DESC_TURNO"
	sql = sql & " FROM SRH_TURNO"
	SQL = SQL & " WHERE COD_TURNO=" & intCodTurnoRH
	rs.open sql, cnn
	if rs.eof = false then
		strDescricaoTurnoRH = rs("DESC_TURNO")
	end if 
	rs.close


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

		sql = " select DISTINCT TOP 1 FDPN.Codigo, FDPN.COD_TURMA, T.Cod_GradeCurricular "
		sql = sql & " from SCA_FICHA_DESCRITIVA_PERGUNTA_NOTA FDPN "
		sql = sql & " INNER JOIN SCA_FICHA_DESCRITIVA_PERGUNTA FDP ON FDP.codigo = FDPN.Cod_Ficha_Descritiva_Pergunta " 
		sql = sql & " INNER JOIN SCA_FICHA_DESCRITIVA FD ON FD.codigo = FDP.cod_ficha_descritiva "
		sql = sql & " INNER JOIN SCA_TURMA T ON T.Cod_Turma = FDPN.Cod_Turma "
		sql = sql & " where FDPN.Cod_aluno = " & intCodAluno
		sql = sql & " and FDP.cod_ficha_descritiva = " & intCodFichaDescritiva
		sql = sql & " AND T.AnoLetivo = " & intAnoLetivo
		sql = sql & " AND T.Cod_Semestre = " & intSemestre
		sql = sql & " And FDPN.Cod_Turno_Rh = " & intCodTurnoRH
		sql = sql & " ORDER BY FDPN.Codigo DESC "
		rs.open sql, cnn
		if rs.eof = false then
			intcodTurmaVerificacaoFicha = rs("COD_TURMA")
			intcodGradeVerificacaoFicha = rs("Cod_GradeCurricular")
		else
			intcodTurmaVerificacaoFicha = "0"
			intcodGradeVerificacaoFicha = "0"
		end if 
		rs.close
		
		sql = " SELECT TOP 1 AT.COD_TURMA, T.Cod_GradeCurricular " 
		sql = sql & " FROM SCA_ALUNO_TURMA AT " 
		sql = sql & " INNER JOIN SCA_TURMA T ON T.Cod_Turma = AT.Cod_Turma "
		sql = sql & " WHERE AT.COD_ALUNO = " & intCodAluno
		sql = sql & " AND AT.ANO_LETIVO = " & intAnoLetivo
		sql = sql & " AND AT.SEMESTRE = " & intSemestre
		sql = sql & " ORDER BY AT.CODIGO DESC "
		rs.open sql, cnn
		if rs.eof = false then
			intcodTurmaVerificacaoCadastro = rs("COD_TURMA")
			intcodGradeVerificacaoCadastro = rs("Cod_GradeCurricular")
		else
			intcodTurmaVerificacaoCadastro = "0"
			intcodGradeVerificacaoCadastro = "0"
		end if 
		rs.close

		if intcodTurmaVerificacaoFicha <> "0" and intcodTurmaVerificacaoCadastro <> "0" then

			strMudarTurma = "N"
			if intcodTurmaVerificacaoFicha = intcodTurmaVerificacaoCadastro and intcodGradeVerificacaoFicha <> intcodGradeVerificacaoCadastro then
				strMudarTurma = "S" 
			end if
			if intcodTurmaVerificacaoFicha <> intcodTurmaVerificacaoCadastro and intcodGradeVerificacaoFicha <> intcodGradeVerificacaoCadastro then
				strMudarTurma = "S" 
			end if
			if session("codGrupo") = 2 then
				if intcodTurmaVerificacaoFicha <> intcodTurmaVerificacaoCadastro and intcodGradeVerificacaoFicha = intcodGradeVerificacaoCadastro then
					strMudarTurma = "S" 
				end if
			end if
			
			if strMudarTurma = "S"  then
				sql = "  UPDATE SCA_FICHA_DESCRITIVA_PERGUNTA_NOTA SET Cod_Turma = " & intcodTurmaVerificacaoCadastro
				sql = sql & " WHERE COD_ALUNO = " & intCodAluno
				sql = sql & " AND Cod_Turma = " & intcodTurmaVerificacaoFicha
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
		if strCompartilharDados = "S" then
			sql = sql & " WHERE Cod_grupo = " & Session("CodGrupo")	
		else   
			sql = sql & " WHERE cod_empresa=" & Session("CodEmpresa")
		end if   
		sql = sql & " And cod_ficha_descritiva = " & intCodFichaDescritiva
		rs.open sql, cnn
		if rs.eof then
			%>
			<script>
				alert("ATENÇÃO: Não existe CONCEITO definido para essa Ficha Descritiva. Verifique!");
				window.close();
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
	
	if intCodBimestre <> "0" then 
		sql = "SELECT descricao"
		sql = sql & " FROM SCA_bimestre"
		sql = sql & " where cod_empresa = " & Session("CodEmpresa")			
		sql = sql & " and codigo = " & intCodBimestre
		rs.open sql, cnn
			
		if rs.eof = false then
			strDescricaoBimestre			= rs("descricao")
		else
			%>
			<script>
				alert("ATENÇÃO: Bimestre não cadastrado. Verifique!");
				window.close();
			</script>
			<%
			response.end
		end if 
		rs.close
	end if	
	
	if trim(intCodAluno) <> "" then
		strCaminhoFoto = session("strCaminhoRaiz") & "/fotoAluno/semFotoAtivo.gif"
		strFoto =  "<img src='" & strCaminhoFoto & "' width='100' height='110'>"

		sql = "SELECT arquivo "
		sql = sql & " FROM 	SCA_ALUNO_FOTO"
		sql = sql & " Where COD_EMPRESA = " & Session("CodEmpresa")		
		sql = sql & " And 	codAluno = " & intCodAluno
		rs.open sql, cnn
		if rs.eof = false then
			strCaminhoFoto = session("strCaminhoRaiz") & "/fotoAluno/" &  Session("CodEmpresa") & "/" & rs("arquivo")
			strFoto =  "<img src='" & strCaminhoFoto & "' width='100' height='110'>"
		else
			strCaminhoFoto = session("strCaminhoRaiz") & "/fotoAluno/semFoto.gif"
			strFoto =  "<img src='" & strCaminhoFoto & "' width='100' height='110'>"
		end if 
		rs.close
		
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
    <form method="post" id="frm" action="#">
    <input  name="txtCodAluno" type="hidden" class="text" id="txtCodAluno"  value="<%=intCodAluno%>" size="5" maxlength="5">
    <input  name="txtAnoLetivo" type="hidden" class="text" id="txtAnoLetivo"  value="<%=intAnoLetivo%>" size="5" maxlength="5">
    <input  name="txtSemestre" type="hidden" class="text" id="txtSemestre"  value="<%=intSemestre%>" size="5" maxlength="5">
    <input  name="txtFichaDescritiva" type="hidden" class="text" id="txtFichaDescritiva"  value="<%=intCodFichaDescritiva%>" size="5" maxlength="5">
    <input  name="txtTurma" type="hidden" class="text" id="txtTurma"  value="<%=intCodTurma%>" size="5" maxlength="5">
    <input  name="txtDisciplinaDoProfessor" type="hidden" class="text" id="txtDisciplinaDoProfessor"  value="<%=intCodDisciplinaTurma%>" size="5" maxlength="5">
    <input  name="txtProfessor" type="hidden" class="text" id="txtProfessor"  value="<%=intCodProfessor%>" size="5" maxlength="5">
    <input  name="txtBimestre" type="hidden" class="text" id="txtBimestre"  value="<%=intCodBimestre%>" size="5" maxlength="5">
    <input  name="txtCodTurnoRH" type="hidden" class="text" id="txtCodTurnoRH"  value="<%=intCodTurnoRH%>" size="5" maxlength="5">
	<table width="100%" height="355" border="0"  class="CorFundo" cellpadding="0" cellspacing="0">
	<tr valign="top">
	<td  align="center" class="tituloSistema">Ficha Descritiva - <%=strDescricaoBimestre%><br><%=strDescricaoTurnoRH%></td>
	</tr>
	<tr valign="top">
	<td align="center">
 	<table width="98%" border="0" align="center" cellpadding="0" cellspacing="2" class="tabela">
	&nbsp;
    <tr> 
    <td width="100%" height="14" class="celula"><div align="center"><%=strFoto%></div></td>
    </tr>
    <tr>
      <td height="18" align="center" class="celula"  border="1"><%=strObservacoes%></td>
    </tr>
    <tr>
    <td height="247" class="celula"><%

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
			sql = sql & " LEFT JOIN SCA_FICHA_DESCRITIVA_PERGUNTA_NOTA FDPN ON FDPN.Cod_aluno = " & intCodAluno & " and FDPN.Cod_Ficha_Descritiva_Pergunta = FDP.Codigo AND FDPN.Cod_Turma = " & intCodTurma & " AND FDPN.Cod_Bimestre = " & intCodBimestre & " AND FDPN.Cod_Disciplina = " & intCodDisciplinaTurma & " AND FDPN.Cod_Turno_Rh = " & intCodTurnoRH
			if strCompartilharDados = "S" then
				sql = sql & " WHERE FDP.Cod_grupo = " & Session("CodGrupo")	
			else   
				sql = sql & " WHERE FDP.cod_empresa=" & Session("CodEmpresa")
			end if   
			sql = sql & " And FDP.cod_ficha_descritiva = " & intCodFichaDescritiva
			sql = sql & " ORDER BY FDP.Codigo "
	  		rsAux.open sql, cnn
	  		if not rsAux.eof then
                %>
        		<table width = "98%" border="1" align="center" cellpadding="0" cellspacing="0" bordercolor="#CCCCCC" class="tabela">
                    <tr bgcolor="#E5E5E5">
                      <td height="21" class="celula">&nbsp;<strong>MATR&Iacute;CULA:</strong></td>
                      <td height="21" class="celula">&nbsp;<%=strMatricula%></td>
                      <td height="21" class="celula">&nbsp;<strong>NOME:</strong></td>
                      <td height="21" colspan="<%=ContaConceito+2%>" class="celula">&nbsp;<%=strNomealuno%></td>
                    </tr>
                    <tr bgcolor="#E5E5E5">
                    <td width="10%" height="21" class="celula">&nbsp;<strong>TURMA: </strong></td>
                    <td width="24%" height="21" class="celula">&nbsp;<%=strTurma%></td>
                    <td width="11%" height="21" class="celula">&nbsp;<strong>DISCIPLINA</strong>:</td>
                    <td height="21" colspan="<%=ContaConceito+2%>" class="celula">&nbsp;<%=strDisciplina%></td>
                </tr>
		 		<tr bgcolor="#E5E5E5">
                <td height="21" colspan="4" class="celula">&nbsp;</td>
		 		<td width="19%" colspan="<%=ContaConceito+2%>" align="center" class="celula"><strong>Conceito</strong></td>
		 		</tr>
		 		<%
				cont = 0
		 		while not rsAux.eof
				  
						 ' Verifica qual tabela fornecerá o conceito a pergunta
						sql = " SELECT SIGLA "
						sql = sql & " FROM SCA_FICHA_DESCRITIVA_CONCEITO_PERGUNTA "
						if strCompartilharDados = "S" then
							sql = sql & " WHERE Cod_grupo = " & Session("CodGrupo")	
						else   
							sql = sql & " WHERE cod_empresa=" & Session("CodEmpresa")
						end if   
						sql = sql & " And cod_ficha_descritiva = " & intCodFichaDescritiva
						sql = sql & " And cod_pergunta = " & rsaux("Codigo")
						rs1.open sql, cnn
						if not rs1.eof then
							strTabelaConceito = " SCA_FICHA_DESCRITIVA_CONCEITO_PERGUNTA "
						else
							strTabelaConceito = " SCA_FICHA_DESCRITIVA_CONCEITO "
						end if
						rs1.close
						
						sql = " SELECT SIGLA "
						sql = sql & " FROM " & strTabelaConceito
						if strCompartilharDados = "S" then
							sql = sql & " WHERE Cod_grupo = " & Session("CodGrupo")	
						else   
							sql = sql & " WHERE cod_empresa=" & Session("CodEmpresa")
						end if   
						sql = sql & " And cod_ficha_descritiva = " & intCodFichaDescritiva
						if strTabelaConceito = " SCA_FICHA_DESCRITIVA_CONCEITO_PERGUNTA " then
							sql = sql & " And cod_pergunta = " & rsaux("Codigo")
						end if	
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
						if strCompartilharDados = "S" then
							sql = sql & " WHERE Cod_grupo = " & Session("CodGrupo")	
						else   
							sql = sql & " WHERE cod_empresa=" & Session("CodEmpresa")
						end if   
						sql = sql & " And cod_ficha_descritiva = " & intCodFichaDescritiva
						if strTabelaConceito = " SCA_FICHA_DESCRITIVA_CONCEITO_PERGUNTA " then
							sql = sql & " And cod_pergunta = " & rsaux("Codigo")
						end if	
						
						cod_conceito = null
						rs1.open sql, cnn
						if not rs1.eof then
							cod_conceito = rs1.getRows
						end if
						rs1.close

						%>
						 <tr bgcolor="#E5E5E5">
					     <td height="23" colspan="4" class="celula">&nbsp;&nbsp;</td>
						<%                
						nRows = UBound( coluna_conceito, 2 )
						For row = 0 to nRows 
							For col = 0 to UBound( coluna_conceito, 1 ) 
							   %>
							   <td class="celula" align="center"><strong><%=ucase(coluna_conceito(col,row))%></strong></td>
							   <%
							 Next
						Next
						%> 
						<td class="celula" align="center"><strong>Limpar</strong></td>
						</tr>
						<%
		 		
						intCod_Ficha_Descritiva_Pergunta = rsAux("codigo")
						intCodItemAvaliacao = rsAux("codigo")
						strResposta = rsAux("Resposta")	
						strConceito = rsAux("Conceito")	
						
		        
						if trim(rsAux("Subtitulo")) <> "" then
		   	   			   %>
                            <tr>
                            <td bgcolor="#666666" height="21" colspan="<%=ContaConceito+5%>" class="celula"><strong><%=trim(rsAux("Subtitulo"))%></strong></td>
                            </tr>
                            <%
						end if
						%>	
			   			<tr>
			   			<td height="21" colspan="<%=ContaConceito+5%>" class="celula">
                        <input name="chkAvaliacao" type="hidden" id="chkAvaliacao" value="<%=intCodItemAvaliacao%>" checked <%=strDesabilitaAluno%> >
               			<input name="txtCod_Ficha_Descritiva_Pergunta<%=cont%>" value="<%=intCod_Ficha_Descritiva_Pergunta%>"  type="hidden" class="text" id="txtCod_Ficha_Descritiva_Pergunta<%=cont%>" size="5"><%=trim(rsAux("Descricao"))%>               </td>
			   			</tr>
			   			<tr>
  			   			<td height="30" colspan="4" class="celula"><p>
  			   			  <textarea name="txtResposta_<%=cont%>" cols="90" rows="5" class="text" id="txtResposta_<%=cont%>"><%=strResposta%></textarea><br>
                          <span class="style1">Obs.: O Campo permite no Maximo 4.000 caracteres, Fique Atento!  			   			  </span></td>
                        <%    

						nRows = UBound( cod_conceito, 2 )
						For row = 0 to nRows 
							For col = 0 to UBound( cod_conceito, 1 ) 
							   %>
								<td height="30" align="center" class="celula"><input name="txtConceito_<%=cont%>" type="radio" value="<%=ucase(cod_conceito(col,row))%>" <%if trim(strConceito) = trim(ucase(cod_conceito(col,row))) then response.Write("checked")%>></td>			
							   <%
							 Next
						Next
						%> 
                         <td class="celula" align="center"><a href="#" onClick="limpaResposta('txtConceito_<%=cont%>')"  onMouseOut="MM_swapImgRestore()" onMouseOver="MM_swapImage('Image<%=rsAux("codigo")%>','','<%=session("strCaminhoRaiz")%>/images/botao_vermelho_over.gif',1)"><img alt="Clique para Limpar a resposta." align="absmiddle" src="<%=session("strCaminhoRaiz")%>/images/botao_vermelho_normal.gif" name="Image<%=rsAux("codigo")%>" width="26" height="26" border="0"></a></td>         		  		</tr>
			   			<tr>
			   			<td height="30" colspan="<%=ContaConceito+5%>" class="celula">&nbsp;</td>
			   			</tr>
				   		<%
						cont = cont + 1 
						rsAux.movenext
						
						strDesabilitaIncluir = " "
						strDesabilitaAlterar = " Disabled "
						strDesabilitaExcluir = " "
						
		 		wend
 	     		rsAux.close
			else
			   	rsAux.close 	
 	  		end if
			rs.movenext
			%>
			</table>
            <br>
            <%
		wend
	end if
%>
</td>
</tr>
    <tr>
      <td  border="1" class="celula"><%=strRodape%></td>
    </tr>
    <tr>
  <td class="texto1">&nbsp;</td>
</tr>
<tr>
  <td class="texto1">
  <%if intCodFichaDescritiva <> 0 then %>
  <!--#include file="../../includes/inc_botoes_cadastroPopap.asp"-->
  <%end if%>	  </td>
</tr>
<tr>
  <td class="texto1">&nbsp;</td>
</tr>
  </table>
  </td>
  </tr>
  </table>
</form>
</body>
</html>