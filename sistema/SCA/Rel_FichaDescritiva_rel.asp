<%
response.Expires=0
'Não armazena a página em buffer antes de mostra-la na tela'
response.Buffer = false
strAnoCab = Trim(Request.QueryString("AnoLetivo"))
%>
<!--
	::	DESENVOLVIDO POR "RS SOLUÇÕES WEB - www.rssolucoesweb.com.br"
	::	Data de Criação...: 28/10/2011
	::	Desenvolvedores...: Roberto Barbosa - roberto@rssolucoesweb.com.br
	::	Objetivo Pagina...: Relatorio Ficha Descritiva
-->
<html>
<head>
<title><%=session("Titulo")%></title>
<link type="text/css" rel="stylesheet" href="../../Estilo/Estilo_Impressao.css">
<body>
<script src="../../js/js_funcoes_gerais.js"></script>
<script type="text/javascript" src="../../js/js_dragdrop.js"></script>
<!--#include file="../../includes/inc_verificaSession.asp"-->
<!--#include file="../../includes/inc_cnn.asp"-->
<!--#include file="../../includes/inc_formatadata.asp"-->
<!--#include file="../includes/inc_sqlAlunoTurma.asp"-->
<!--#include file="../includes/inc_CompartilharDadosCadastrais.asp"-->
<!--#include file="../../includes/inc_Botoes_relatorio.asp"-->
<!--#include file="../../includes/inc_cabecalhoRelatorio.asp"-->


	<% 
	
	strExecutarSubmit                   = "S"
	strExecutarSubmitTurma				= "S"
	strReloadDisciplinaQuadro			= "S"
	strPaginaTitulo 					= "FichaDescritivaNotas_cad.asp"
	intCodGrupo							= Trim(session("CodGrupo"))
	intAnoLetivo   					 	= Trim(Request.QueryString("AnoLetivo"))	
	intSemestre   						= Trim(Request.QueryString("Semestre"))	
	intCodAluno							= Trim(Request.QueryString("CodAluno"))
	intCodFichaDescritiva				= Trim(Request.QueryString("CodFichaDescritiva"))
	intCodTurma 						= Trim(Request.QueryString("cmbTurma"))
	intCodDisciplinaTurma				= Trim(Request.QueryString("cmbDisciplinaDoProfessor"))
	intCodProfessor				        = Trim(Request.QueryString("cmbProfessor"))
	intCodTurnoRH				        = Trim(Request.QueryString("cmbTurnoRH"))
	
	if intCodFichaDescritiva 			= "" then intCodFichaDescritiva 	= "0"
	if intCodTurma 						= "" then intCodTurma 				= "0"
	if intCodDisciplinaTurma 			= "" then intCodDisciplinaTurma 	= "0"
	if intCodTurnoRH 					= "" then intCodTurnoRH 			= "0"

	sql = "SELECT COD_TURNO, DESC_TURNO"
	sql = sql & " FROM SRH_TURNO"
	SQL = SQL & " WHERE COD_TURNO=" & intCodTurnoRH
	rs.open sql, cnn
	if rs.eof = false then
		strDescricaoTurnoRH = " - " & rs("DESC_TURNO")
	else
		strDescricaoTurnoRH = ""
	end if 
	rs.close
	
	if intCodGrupo <> "" then 
	
		sql = "SELECT codigo, descricao, Cidade"
		sql = sql & " FROM seg_grupo"
		sql = sql & " Where Codigo = " & intCodGrupo
		rs.open sql, cnn
		
		if rs.eof = false then
			CidadeGrupo = rs("Cidade")
		end if 
		rs.close
	
	end if
	Legenda = "Legenda: "
	sql = " select Sigla, Descricao from SCA_FICHA_DESCRITIVA_CONCEITO "
	sql = sql & " WHERE cod_ficha_descritiva = " & intCodFichaDescritiva
	sql = sql & " UNION "
	sql = sql & " select Sigla, Descricao from SCA_FICHA_DESCRITIVA_CONCEITO_PERGUNTA "
	sql = sql & " WHERE cod_ficha_descritiva = " & intCodFichaDescritiva 
	rs.open sql, cnn
	if rs.eof = false then
		while not rs.eof
			Legenda = Legenda + "   ( " & rs("Sigla") & " ) - " & rs("Descricao") 
			rs.movenext
		wend
	else
		%>
		<script>
			alert("ATENÇÃO: Legenda não Cadastrada. Verifique!");
			window.close();
		</script>
		<%
		response.end
	end if 
	rs.close
	
	sql = " SELECT descricao, codigo"
	sql = sql & " FROM SCA_bimestre"
	sql = sql & " where cod_empresa = " & Session("CodEmpresa")			
	sql = sql & " AND Ano_Letivo = " & strAnoCab 
	sql = sql & " AND semestre = " & intSemestre
	sql = sql & " order by descricao "
	rs.open sql, cnn
	if rs.eof = false then
		vetBimestre = rs.getRows
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
	
	cont = 0
		
	' Busca Tipo da Avalição
	if trim(intCodFichaDescritiva) <> "0" then 
		
		sql = "SELECT Codigo, Cod_empresa, Descricao, Ano_Letivo, Semestre, CodTipoEmpresa, "
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
			intCodTipoEmpresa 		= trim(rs("CodTipoEmpresa"))
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
		end if
		rs.close

	end if
	
	if intCodTipoEmpresa = "" then intCodTipoEmpresa = 0
		
	if intCodTipoEmpresa = 1 then
		
		strAssinatura = ""
	else
		strAssinatura = "____________________________________<br>"
		strAssinatura = strAssinatura & "  Assinatura do(a)  Secret&aacute;rio(a) "
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
    <input  name="txtCodAluno" type="hidden" class="text" id="txtCodAluno"  value="<%=intCodAluno%>" size="5" maxlength="5">
    <input  name="txtAnoLetivo" type="hidden" class="text" id="txtAnoLetivo"  value="<%=intAnoLetivo%>" size="5" maxlength="5">
    <input  name="txtSemestre" type="hidden" class="text" id="txtSemestre"  value="<%=intSemestre%>" size="5" maxlength="5">
    <input  name="txtFichaDescritiva" type="hidden" class="text" id="txtFichaDescritiva"  value="<%=intCodFichaDescritiva%>" size="5" maxlength="5">
    <input  name="txtTurma" type="hidden" class="text" id="txtTurma"  value="<%=intCodTurma%>" size="5" maxlength="5">
    <input  name="txtDisciplinaDoProfessor" type="hidden" class="text" id="txtDisciplinaDoProfessor"  value="<%=intCodDisciplinaTurma%>" size="5" maxlength="5">
    <input  name="txtProfessor" type="hidden" class="text" id="txtProfessor"  value="<%=intCodProfessor%>" size="5" maxlength="5">
   <table width = "98%" border="0" align="center" cellpadding="0" cellspacing="0" class="tabela">
    <tr>
      <td  class="celula">&nbsp;
      
          <%
	if intCodDisciplinaTurma <> "0" then 
		sql = " SELECT SCA_DISCIPLINA.Cod_Disciplina, SCA_DISCIPLINA.Desc_Disciplina as DISCIPLINA, "
	else	
		sql = " SELECT top 1 SCA_DISCIPLINA.Cod_Disciplina, SCA_DISCIPLINA.Desc_Disciplina as DISCIPLINA, "
	end if	
	sql = sql & " SCA_GRADECURRICULARDISCIPLINA.Cod_GradeCurricularDisciplina, "
	sql = sql & " SCA_TURMA.Cod_Turma, SCA_TURMA.NomeTurma"
	sql = sql & " FROM  SCA_TURMA "
	sql = sql & " INNER JOIN SCA_GRADECURRICULAR ON SCA_TURMA.Cod_GradeCurricular = SCA_GRADECURRICULAR.Cod_GradeCurricular "
	sql = sql & " INNER JOIN SCA_GRADECURRICULARDISCIPLINA ON SCA_GRADECURRICULAR.Cod_GradeCurricular = SCA_GRADECURRICULARDISCIPLINA.Cod_GradeCurricular "
	sql = sql & " INNER JOIN SCA_DISCIPLINA ON SCA_GRADECURRICULARDISCIPLINA.Cod_Disciplina = SCA_DISCIPLINA.Cod_Disciplina"
	sql = sql & " WHERE 1=1"
	sql = sql & " AND SCA_TURMA.Cod_Empresa= " & session("CodEmpresa")
	sql = sql & " AND SCA_TURMA.Cod_Turma = " & intCodTurma
	if intCodDisciplinaTurma <> "0" then 
		sql = sql & " AND SCA_DISCIPLINA.Cod_Disciplina = " & intCodDisciplinaTurma
	end if
	sql = sql & " ORDER BY Desc_Disciplina"
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
			sql = " SELECT DISTINCT C.CODIGO, C.NOME FROM SCA_HORARIO_AULA HA"
			sql = sql & " INNER JOIN SRH_COLABORADOR C ON C.CODIGO = HA.Cod_Colaborador"
			sql = sql & " WHERE HA.COD_EMPRESA = " & session("CodEmpresa")
			sql = sql & " AND HA.ANOLETIVO = " & intAnoLetivo 
			sql = sql & " AND HA.SEMESTRE = " & intSemestre
			sql = sql & " AND HA.cod_Turma = " & intCodTurma
			sql = sql & " and HA.Cod_Disciplina = " & intCodDisciplina
			rsAux.open sql, cnn
			if not rsAux.eof then 
				strNome 			= rsAux("NOME")	
			else
				strNome 			= ""
			end if 	
			rsAux.close

			' Consulta as perguntas Descritivas
			sql = " SELECT " 
			sql = sql & " FDP.Codigo, " 
			sql = sql & " FDP.cod_ficha_descritiva, " 
			sql = sql & " FDP.Descricao, " 
			sql = sql & " FDP.Subtitulo, "
			for j=0 to ubound(vetBimestre,2)
 				sql = sql & " ISNULL(FDPN" & j & ".Conceito,'') as Conceito" & j & " , " 
				sql = sql & " FDPN" & j & ".Resposta as Resposta" & j & ", " 
				sql = sql & " ISNULL(CP" & j & ".Sigla,'') AS SIGLA_PERGUNTA" & j & ", " 
				sql = sql & " ISNULL(C" & j & ".SIGLA,'') AS SIGLA" & j & ", " 
				sql = sql & " ISNULL(TU" & j & ".Desc_Turno,'') AS Turno" & j & ", " 
			next
			sql = sql & " '' as CampoTeste " 
			sql = sql & " FROM SCA_FICHA_DESCRITIVA_PERGUNTA FDP " 
			for j=0 to ubound(vetBimestre,2)
				intCodBimestre = vetBimestre(1,j) 
				sql = sql & " LEFT JOIN SCA_FICHA_DESCRITIVA_PERGUNTA_NOTA FDPN" & j & " ON FDPN" & j & ".Cod_aluno = " & intCodAluno & " and FDPN" & j & ".Cod_Ficha_Descritiva_Pergunta = FDP.Codigo AND FDPN" & j & ".Cod_Turma = " & intCodTurma & " AND FDPN" & j & ".Cod_Bimestre = " & intCodBimestre & " AND FDPN" & j & ".Cod_Disciplina = " & intCodDisciplinaTurma
				
				sql = sql & " LEFT JOIN SCA_FICHA_DESCRITIVA_CONCEITO C" & j & " ON C" & j & ".CODIGO = FDPN" & j & ".CONCEITO "
				sql = sql & " LEFT JOIN SCA_FICHA_DESCRITIVA_CONCEITO_PERGUNTA CP" & j & " ON CP" & j & ".CODIGO = FDPN" & j & ".Conceito AND CP" & j & ".Cod_Pergunta = FDPN" & j & ".Cod_Ficha_Descritiva_Pergunta "
				sql = sql & " LEFT JOIN SRH_TURNO TU" & j & " ON TU" & j & ".Cod_Turno = FDPN" & j & ".Cod_Turno_Rh " 
			next
			
			if strCompartilharDados = "S" then
				sql = sql & " WHERE FDP.Cod_grupo = " & Session("CodGrupo")	
			else   
				sql = sql & " WHERE FDP.cod_empresa=" & Session("CodEmpresa")
			end if   
			sql = sql & " And FDP.cod_ficha_descritiva = " & intCodFichaDescritiva
			if intCodTurnoRH <> "0" then
				''sql = sql & " And FDPN0.Cod_Turno_Rh = " & intCodTurnoRH
			end if
			sql = sql & " ORDER BY FDP.Codigo "
					if UCASE(session("usuarioweb"))="SERGIO" then
		response.write sql
		end if

			rsAux.open sql, cnn
			if not rsAux.eof then
                %>
        <table width = "98%" border="0" align="center" cellpadding="0" cellspacing="0" bordercolor="#CCCCCC" class="tabela">
          <tr bgcolor="#E5E5E5">
            <td width="10%" rowspan="3" align="center" class="celula"><%=strFoto%>&nbsp;</td>
            <td height="25" colspan="8" align="center" class="celula"><strong><%=strNomeAvaliacao%><%if intCodTurnoRH <> "0" then response.write " - ( " & rsAux("Turno0") & " )"%></strong></td>
          </tr>
          <tr bgcolor="#E5E5E5">
            <td height="21" class="celula">&nbsp;<strong>MATR&Iacute;CULA:</strong></td>
                        <td height="21" class="celula">&nbsp;<%=strMatricula%></td>
                        <td height="21" class="celula">&nbsp;<strong>NOME:</strong></td>
                        <td height="21" colspan="5" class="celula">&nbsp;<%=strNomealuno%></td>
          </tr>
          <tr bgcolor="#E5E5E5">
            <td width="12%" height="21" class="celula">&nbsp;<strong>TURMA: </strong></td>
                      <td width="24%" height="21" class="celula">&nbsp;<%=strTurma%></td>
                      <td width="11%" height="21" class="celula">&nbsp;<strong>DISCIPLINA</strong>:</td>
                      <td height="21" colspan="5" class="celula">&nbsp;<%=strDisciplina%></td>
          </tr>
          <tr bgcolor="#E5E5E5">
            <td height="21" colspan="5" class="celula"><strong><%=trim(Legenda)%></strong></td>
            <td colspan="5" align="center" class="celula">&nbsp;</td>
          </tr>
          <tr bgcolor="#E5E5E5">
            <td height="21" colspan="5" class="celula">&nbsp;</td>
		 		  <td width="19%" colspan="4" align="center" class="celula"><strong>Conceito</strong></td>
 		  </tr>
          
          <tr bgcolor="#E5E5E5">
            <td height="23" colspan="5" class="celula">&nbsp;&nbsp;</td>
                  <% for j=0 to ubound(vetBimestre,2)
                    intCodBimestre = vetBimestre(1,j) 
                    strCodBimestre = vetBimestre(0,j) 
                   %>
            <td class="celula" align="center"><strong><%=strCodBimestre%></strong></td>
                     <%
                Next
                %> 
          </tr>
          <%
				cont = 0
		 		while not rsAux.eof

					intCod_Ficha_Descritiva_Pergunta = rsAux("codigo")
					intCodItemAvaliacao = rsAux("codigo")
					strDescricao		= trim(rsAux("Descricao"))
					
							
					if trim(rsAux("Subtitulo")) <> "" then
						  %>
						  <tr bgcolor="#E5E5E5">
							<td height="21" colspan="9" class="celula"><strong><%=trim(rsAux("Subtitulo"))%> <%if intCodTurnoRH = "0" then response.write " - ( " & rsAux("Turno0") & " )"%></strong></td>
						  </tr>
						  <%
     			    end if
								%>
					  <tr>
						<td height="21" colspan="5" class="celula"><%=trim(rsAux("Descricao"))%>&nbsp;</td>
					  <%	
					  
					for j=0 to ubound(vetBimestre,2)

						strResposta = rsAux("Resposta"&j)	
						
						if rsAux("SIGLA_PERGUNTA"&j) = "" then	
							strConceito = rsAux("SIGLA"&j)
						else
							strConceito = rsAux("SIGLA_PERGUNTA"&j)
						end if		
						
						if isnull(strConceito) or strConceito = "" then strConceito = "---"
						if isnull(strResposta) or strResposta = "" then strResposta = ""

						%>	
            				<td height="30" class="celula" align="center"><%=trim(strConceito)%>&nbsp;</td>
				   		<%
					next	
					
					
					%>	
          </tr>
          <% 		cont = cont + 1 
					rsAux.movenext
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
      <td  class="celula"><%=strRodape%></td>
    </tr>
</table>

       <table width = "98%" border="0" align="center" cellpadding="0" cellspacing="0" bordercolor="#CCCCCC" class="tabela">
        <tr bgcolor="#CCCCCC">
        <td height="18" colspan="3" class="celula"><strong>INFORMA&Ccedil;&Otilde;ES GERAIS</strong></td>
        </tr>  
        
		 <%
		 
		
		 
		sql = " SELECT FN.Codigo, Cod_Turma, Cod_Ficha_Descritiva_Pergunta, Cod_aluno, Conceito, Resposta, Cod_Bimestre, ISNULL(TU.Desc_Turno,'') AS Turno, "
		sql = sql & " SCA_BIMESTRE.Descricao"
		sql = sql & " FROM SCA_FICHA_DESCRITIVA_PERGUNTA_NOTA  FN"
		sql = sql & " inner join SCA_BIMESTRE on SCA_BIMESTRE.Codigo = FN.Cod_Bimestre "
		sql = sql & " LEFT JOIN SRH_TURNO TU ON TU.Cod_Turno = FN.Cod_Turno_Rh " 
		sql = sql & " WHERE Cod_aluno = " & intCodAluno
		sql = sql & " and Cod_Turma = " & intCodTurma
		sql = sql & " and SCA_BIMESTRE.Ano_letivo = " & strAnoCab
		if intCodTurnoRH <> "0" then
			sql = sql & " And FN.Cod_Turno_Rh = " & intCodTurnoRH
		end if
		sql = sql & " and Resposta <> '' "
		sql = sql & " order by SCA_BIMESTRE.Codigo"
        rs1.open sql, cnn
		
        if not rs1.eof then 
			While not rs1.eof 
			
			intCodBimestre = trim(rs1("Cod_Bimestre"))
			strBimestre = trim(rs1("Descricao"))
			strResposta = trim(rs1("Resposta"))
			if isnull(rs1("Resposta")) then strResposta = ""
        	
			if strResposta <> "" then 
			
			if trim(strBimestreAnt) <> trim(strBimestre) then
				strBimestreAnt = strBimestre
				%>			 
        	<tr> 
          		<td height="21" colspan="3" align="left" class="celula"><strong><%=strBimestre%></strong></td>
         	</tr>
         	<%end if%>
            <tr>
            	<td height="21" colspan="3" align="left" class="celula"><%=strResposta%><%if intCodTurnoRH = "0" then response.write " - ( " & rs1("Turno") & " )"%></td>
            </tr>
         	<%
			end if
				rs1.movenext
		 		wend
        end if 	
        rs1.close%>
            <tr>
              <td height="21" colspan="3" align="left" class="celula">&nbsp;</td>
            </tr>
         <tr>
          <td height="56" colspan="3" align="left" class="celula"><strong><%=CidadeGrupo%>,<%=day(date)%> de <%=ucase(monthname(month(date)))%> de <%=year(date)%></strong></td>
         </tr>
         <%if intCodTipoEmpresa =  1 then %>
         <tr>
           <td height="67" align="center" class="celula">_______________________________________<br>
Assinatura do(a)  Professor(a)</td>
           <td align="center" class="celula">____________________________________<br>
Assinatura do(a)  Coord. Pedag&oacute;gico(a)</td>
         </tr>
         <%end if%>
         <tr>
          <td width="51%" height="67" align="center" class="celula"><p>_______________________________________<br>
          Assinatura do(a)  Professor(a)</p></td>
          <td width="49%" align="center" class="celula"><p>____________________________________<br>
          Assinatura do(a)  Coord. Pedag&oacute;gico(a)</p></td>
        </tr>
        <tr>
          <td height="67" align="center" class="celula"><p>_______________________________________<br>
          Assinatura do(a)  Diretor(a)</p></td>
         <td height="67" align="center" class="celula"><%=strAssinatura%>&nbsp;</tr>
        </table>
<br>
</body>
</html>