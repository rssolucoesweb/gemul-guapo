<%@LANGUAGE="VBSCRIPT" CODEPAGE="65001"%> 
<%  
response.Charset = "utf-8" 
response.ContentType = "text/html" 
response.Expires=0
Server.ScriptTimeOut = 5000
response.Buffer = false
%>
<html>
<head>
<title>GEMUL - Notas disciplina</title>
<meta http-equiv="content-type" content="text/html; charset=UTF-8">
<link type="text/css" rel="stylesheet" href="css_rel/Estilo_Impressao.css">
<style>
	.fonte7 {
		font-size: 7;
		color:blue
	}
</style>
<body>
<!--#include file="includes/inc_verificaSessionApp.asp"-->
<!--#include file="includes/inc_cnn.asp"-->
<!--#include file="includes/inc_formatadata.asp"-->
<!--#include file="includes/inc_Botoes_relatorio.asp"-->	
<!--#include file="includes/inc_aguarde.asp"-->	
<br>
<%
	dim intPagina
	dim strInfoTurma
	strExecutarSubmitCurso	  = "S"
	strExecutarSubmitPeriodo  = "S"
	strExecutarSubmitSemestre = "S"
	strExecutarSubmitTurno	  = "S"
	strExecutarSubmitTurma	  = "S"
	
	intCodTurma 			= Trim(Request.Form("cmbTurma"))
	intCodTurmaQuebra		= Trim(Request.Form("cmbTurma"))
	intCodTurmaQuebra		= Trim(Request.Form("cmbQuebraPagina"))
	intCodDisciplinaTurma   = trim(request("cmbDisciplinaTurma"))
	intCodCurso	 			= Trim(Request.Form("cmbCurso"))
	intCodPeriodo 			= Trim(Request.Form("cmbPeriodo"))
	strSemestre 			= Trim(Request.Form("cmbSemestre"))
	intCodSituacaoAluno		= Trim(Request.Form("cmbSituacaoAluno"))
	strSexo					= Trim(Request.Form("cmbSexo"))
	strOrdem				= Trim(Request.Form("cmbOrdem"))
	strQuebraPagina			= Trim(Request.Form("cmbQuebraPagina"))
	intCodFormaIngresso 	= Trim(Request.Form("cmbFormaIngresso"))
	strAlunoSemSituacao     = Trim(Request.Form("AlunoSemSituacao"))
	strAlunoSemPai     		= Trim(Request.Form("AlunoSemPai"))
	intCodEstagio     		= Trim(Request.Form("cmbEstagio"))
	
	intCodTurno		 		= Trim(Request.Form("cmbTurno"))
	if Trim(Request.Form("txtAnoLetivo")) <> "" then
	   strAnoLetivo 			= Trim(Request.Form("txtAnoLetivo"))
	else
	   strAnoLetivo = session("strAnoLetivo")   
	end if   
	strSubTitulo 			= Trim(Request.Form("txtSubTitulo"))
	strlpp 					= Trim(Request.Form("cmblpp"))
	strclasse               = Trim(Request.Form("cmbTamanhoFonteArial"))
	
	if intQtdeRegistroPorPagina = "" then intQtdeRegistroPorPagina = 1

	strFiltroSerie = "0"
	strFiltroTurno = "0"

	if intCodComp = "" then intCodComp = "0"
	if intCodSerie = "" then intCodSerie = "0"
	if intCodTurno = "" then intCodTurno = "0"
	if intCodTurma = "" then intCodTurma = "0"
	if intCodSemestre = "" then intCodSemestre = "0"

   
	
	if intCodDisciplinaTurma = "" or intCodDisciplinaTurma = "0" then
		if trim(strAnoLetivo) = trim(session("strAnoLetivo")) and trim(strSemestre) =  trim(session("strSemestre")) then
		   strTituloRelatorio = "LIVRO DE MATR&Iacute;CULA<br>" 
		else
		   strTituloRelatorio  = "LIVRO DE MATR&Iacute;CULA<BR>Período Letivo: " & strAnoLetivo & "/" & strSemestre 
		end if   
	else
	    strDescDisciplina    = ""
	  	sql = "SELECT DESC_DISCIPLINA "
		sql = sql & "  FROM SCA_DISCIPLINA "
		SQL = SQL & " WHERE COD_DISCIPLINA = " &  intCodDisciplinaTurma
		RS.OPEN SQL, CNN
		IF not RS.EOF THEN
			strDescDisciplina  =  rs("DESC_DISCIPLINA")
		END IF
		rs.close
        strTituloRelatorio  	= "LIVRO DE MATR&Iacute;CULA: " & strDescDisciplina & "<BR>" & strEstagio
	end if	
	
	if strAlunoSemPai = "S" then
		strTituloRelatorio = strTituloRelatorio & "<BR>** SEM NOME DO PAI **"
	end if

	sub mostraCabecalho()
		%>
		<!--#include file="includes/inc_cabecalhoRelatorio.asp"-->
        <br>
        <table width="100%" border="0" cellspacing="0" cellpadding="0" class="tabela">
		<%
	end Sub
	sub quebraTurma() 
	%>
	  <tr bgcolor="#E2E2E2">
	    <td colspan="5" class="<%=strclasse%>"><strong><%=strInfoTurma%></strong>&nbsp;</td>
      </tr>
	<%
	end Sub	
	sub fimTabela()
		response.Write("</table>")
	end Sub
%>
<%
	intPagina = 1
	cont = 0

	sql = "SELECT DISTINCT SCA_ALUNO.CODIGO, SCA_ALUNO.MATRICULA, SCA_ALUNO.DATAFASTAMENTO, SCA_ALUNO.NOMEALUNO, SCA_ALUNO.DATANASCIMENTO, SCA_ALUNO.CIDADENASCIMENTO, SCA_ALUNO.DATAMATRICULA, "
	sql = sql & " P.DESCRICAO AS PERIODO, C.DESCRICAO AS CURSO, SCA_TURMA.COD_TURMA, SCA_TURMA.NomeTurma, SCA_TURMA.TURMAALUNO, SCA_ALUNO.MAE, SCA_ALUNO.PAI, SCA_ALUNO.FONERESIDENCIAL, SCA_ALUNO.FONECOMERCIAL, SCA_ALUNO.FONECELULAR, SCA_ALUNO.COD_FORMAINGRESSO, SCA_ALUNO.LOGRADOURO, SCA_ALUNO.COMP_ENDERECO, SCA_ALUNO.BAIRROALUNO, SCA_ALUNO.NACIONALIDADE, "
	sql = sql & " isnull(( select top 1 ss.Desc_SituacaoAluno  from SCA_CONTROLE_SITUACAO_ALUNO CS  inner JOIN SCA_SITUACAOALUNO SS ON SS.Cod_SituacaoAluno = CS.COD_SITUACAOALUNO where CS.COD_EMPRESA = SCA_ALUNO_TURMA.COD_EMPRESA and CS.COD_ALUNO = SCA_ALUNO_TURMA.COD_ALUNO  and CS.ANO_LETIVO = SCA_ALUNO_TURMA.ANO_LETIVO order by cs.codigo desc ),'ATIVO') as Desc_SituacaoAluno, "
	sql = sql & " isnull(( select top 1 ss.COD_SituacaoAluno from SCA_CONTROLE_SITUACAO_ALUNO CS inner JOIN SCA_SITUACAOALUNO SS ON SS.Cod_SituacaoAluno = CS.COD_SITUACAOALUNO where CS.COD_EMPRESA = SCA_ALUNO_TURMA.COD_EMPRESA and CS.COD_ALUNO = SCA_ALUNO_TURMA.COD_ALUNO and CS.ANO_LETIVO = SCA_ALUNO_TURMA.ANO_LETIVO order by cs.codigo desc ),'1') as COD_SITUACAOALUNOATUAL, "
	sql = sql & " SCA_TURMA.Cod_FichaDescritiva, TC.DESCRICAO AS TIPO_CRITERIO "
	sql = sql & " FROM SCA_ALUNO "
	sql = sql & " INNER JOIN SCA_ALUNO_TURMA ON SCA_ALUNO_TURMA.COD_ALUNO = SCA_ALUNO.CODIGO "
	sql = sql & " LEFT JOIN SCA_TURMA ON SCA_ALUNO_TURMA.COD_TURMA = SCA_TURMA.Cod_Turma AND SCA_ALUNO_TURMA.ANO_LETIVO = SCA_TURMA.AnoLetivo AND SCA_ALUNO_TURMA.SEMESTRE = SCA_TURMA.Cod_Semestre "
	sql = sql & " AND SCA_ALUNO_TURMA.cod_empresa = SCA_TURMA.cod_empresa "
	sql = sql & " INNER JOIN SCA_GRADECURRICULAR ON SCA_TURMA.Cod_GradeCurricular = SCA_GRADECURRICULAR.Cod_GradeCurricular "
	sql = sql & " LEFT JOIN SCA_GRADECURRICULAR G ON SCA_TURMA.Cod_GradeCurricular = G.Cod_GradeCurricular "
	sql = sql & " LEFT JOIN SCA_PERIODO P ON P.Cod_Periodo = G.Cod_Periodo "
	sql = sql & " LEFT JOIN SCA_CURSO C ON C.Cod_Curso = P.Cod_Curso "
	sql = sql & " LEFT JOIN SCA_TIPO_AVALIACAO_INDIVIDUAL_ALUNO TAI ON TAI.COD_ALUNO = SCA_ALUNO_TURMA.COD_ALUNO AND TAI.ANO_LETIVO = SCA_TURMA.ANOLETIVO "
	sql = sql & " LEFT JOIN SCA_TIPO_CALCULO TC ON TC.codigo = TAI.cod_tipo_CALCULO "
	sql = sql & " where SCA_ALUNO_TURMA.cod_empresa = " & Session("CodEmpresa")
	if intCodTurma <> "0" then
		sql = sql & " and SCA_ALUNO_TURMA.COD_TURMA = " & intCodTurma 
	end if
	if intCodCurso <> "0" then
	  sql = sql & " and P.Cod_Curso = " & intCodCurso
	end if
	if intCodPeriodo <> "0" then
	  sql = sql & " and SCA_TURMA.Cod_Periodo = " & intCodPeriodo
	end if
	if intCodTurno <> "0" then
	  sql = sql & " and SCA_TURMA.COD_TURNO = " & intCodTurno
	end if
	sql = sql & " and SCA_ALUNO_TURMA.ANO_LETIVO = " & strAnoLetivo
	sql = sql & "  and SCA_ALUNO_TURMA.SITUACAO in ('A','T','D','C') "
	sql = sql & "  and SCA_TURMA.situacao = 'A' "

   
   'ordem de classificação do relatorio
   if intCodTurmaQuebra = "TURMA" then
   
	   if strOrdem = "alfabetica" then
		  sql = sql & " Order By sca_turma.NomeTurma, SCA_ALUNO.NOMEALUNO"
	   elseif strOrdem = "matricula" then
		  sql = sql & " Order By sca_turma.NomeTurma, SCA_ALUNO.matricula"
	   elseif strOrdem = "datamatricula" then
		  sql = sql & " Order By sca_turma.NomeTurma, SCA_ALUNO.datamatricula"
	   elseif strOrdem = "dataafastamento" then
	   'verificar qual o campos data afastamento no cadastro
		  sql = sql & " Order By sca_turma.NomeTurma, SCA_ALUNO.DATAFASTAMENTO"
	   elseif strOrdem = "idade" then
		  sql = sql & " Order By sca_turma.NomeTurma, SCA_ALUNO.DATANASCIMENTO"
	   elseif strOrdem = "bairro" then
		  sql = sql & " Order By sca_turma.NomeTurma, SCA_ALUNO.BAIRROALUNO"
	   end if
   else
	   if intCodTurmaQuebra <> "" and  intCodTurmaQuebra <> "0" then
		
		   if strOrdem = "alfabetica" then
			  sql = sql & " Order By SCA_ALUNO.NOMEALUNO"
		   elseif strOrdem = "matricula" then
			  sql = sql & " Order By SCA_ALUNO.MATRICULA"
		   elseif strOrdem = "datamatricula" then
			  sql = sql & " Order By SCA_ALUNO.datamatricula"
		   elseif strOrdem = "dataafastamento" then
			  sql = sql & " Order By SCA_ALUNO.DATAFASTAMENTO"
		   elseif strOrdem = "idade" then
			  sql = sql & " Order By SCA_ALUNO.DATANASCIMENTO"
		   elseif strOrdem = "bairro" then
			  sql = sql & " Order By SCA_ALUNO.BAIRROALUNO"
		   end if
		else
			sql = sql & " Order By SCA_ALUNO.NOMEALUNO"		
		end if   
	end if
	
   
'response.write sql
	rs.open sql, cnn
	if not rs.eof then 
	
		mostraCabecalho
		
		While not rs.eof
			IF intCodTurmaQuebra = "TURMA"  then
				IF intCodTurma <> RS("COD_TURMA") THEN
					if controle = 1 then
					   %>
					   <tr>
					   <td colspan="5" class="<%=strclasse%>">Quantidade de Alunos Por Turma: <%=contPorTurma%></td>
					   </tr>
					   <%
					   contPorTurma = 0
					end if
					if trim(strQuebraPagina) = "TURMA" and controle = 1 then
					   intPagina = intPagina + 1
					   intQtdeRegistroPorPagina = 1
					   fimTabela
					   %>
					   <pre></pre>				
					   <%			
					   mostraCabecalho
					end if
					strInfoTurma =  "<strong>" & RS("NomeTurma") & "</strong> - " & RS("CURSO") & " - " & RS("TURMAALUNO")
					quebraTurma
				END IF
				controle = 1
			else
			%>
			 <tr bgcolor="#E2E2E2">
				<td colspan="5" class="<%=strclasse%>"><%response.write "<strong>" & RS("NomeTurma") & "</strong> - " & RS("CURSO") & " - " & RS("TURMAALUNO")%></td>
			  </tr>
			 <%
			end if
			
			IF intCodTurmaQuebra = "TURMA"  then
			%>
			 <tr bgcolor="#E2E2E2">
				<td colspan="5" class="<%=strclasse%>">&nbsp;</td>
			  </tr>
			<%
			end if
			%>
            <tr>
            <td width="5%" align="center" class="<%=strclasse%>"><div align="center"><strong>Matr&iacute;cula</strong></div></td>
            <td width="8%" class="<%=strclasse%>"><div align="center"><strong>Data de Matr&iacute;cula</strong></div></td>
            <td width="34%" class="<%=strclasse%>"><div align="center"><strong>Nome do Aluno</strong></div></td>
            <td width="7%" class="<%=strclasse%>"><div align="center"><strong>Data Nascimento</strong></div></td>
            <td width="7%" class="<%=strclasse%>"><div align="center"><strong><%=rs("Desc_SituacaoAluno")%></strong>&nbsp;</div></td>
            </tr>
            
            <tr>
            <td class="<%=strclasse%>" align="left"><div align="center"><%=rs("MATRICULA")%>&nbsp;</div></td>
            <td class="<%=strclasse%>" align="left"><div align="center"><%=formatadataAP(rs("DATAMATRICULA"))%>&nbsp;</div></td>
            <td class="<%=strclasse%>" align="left">&nbsp;<%=rs("NOMEALUNO")%>&nbsp;</td>
            <td class="<%=strclasse%>" align="left"><div align="center"><%=formatadataAP(rs("DATANASCIMENTO"))%>&nbsp;</div></td>
            <td class="<%=strclasse%>" align="left"><div align="center"><%=formatadataAP(rs("DATAFASTAMENTO"))%>&nbsp;</div></td>
            </tr>
            <tr>
            <td width="5%" align="center" class="<%=strclasse%>"><div align="right"><strong>&nbsp;Nome da M&atilde;e:</strong></div></td>
            <td colspan="2" class="<%=strclasse%>">&nbsp;<%=rs("MAE")%>&nbsp;</td>
            <td width="7%" class="<%=strclasse%>"><div align="right"><strong>Naturalidade:</strong></div></td>
            <td width="7%" class="<%=strclasse%>">&nbsp;<%=rs("CIDADENASCIMENTO")%>&nbsp;</td>
            </tr>
            
            <tr>
              <td class="<%=strclasse%>" align="left"><div align="right"><strong>&nbsp;Nome do Pai:</strong></div></td>
              <td colspan="2" align="left" class="<%=strclasse%>">&nbsp;<%=rs("PAI")%>&nbsp;</td>
              <td colspan="2" align="left" class="<%=strclasse%>">&nbsp;</td>
            </tr>
            <tr>
            <td class="<%=strclasse%>" align="left"><div align="right"><strong>&nbsp;Endere&ccedil;o:</strong></div></td>
            <td colspan="2" align="left" class="<%=strclasse%>">&nbsp;<%=rs("LOGRADOURO")%>,<%=rs("COMP_ENDERECO")%> - <%=rs("BAIRROALUNO")%>&nbsp;</td>     
            <td align="left" class="<%=strclasse%>"><div align="right"><strong>Nacionalidade:</strong></div></td>
            <td align="left" class="<%=strclasse%>">&nbsp;<%=rs("NACIONALIDADE")%>&nbsp;</td>
            </tr>
			<%
			'quantidade de registros da página
			if int(intQtdeRegistroPorPagina) = int(strlpp) - 1 then
				 intPagina = intPagina + 1
				 intQtdeRegistroPorPagina = 1
				 fimTabela
				%>
				<pre></pre>				
				<%			
				mostraCabecalho
			end if	
			cont = cont + 1
			contPorTurma = contPorTurma + 1
			intQtdeRegistroPorPagina = intQtdeRegistroPorPagina + 1
			intCodTurma = RS("COD_TURMA")
			rs.movenext
		wend
		%>
		  <tr>
			<td colspan="6" class="<%=strclasse%>">Quantidade de Alunos: <%=cont%></td>
		  </tr>
		 <%
	else
		%>
		  <tr>
			<td colspan="6" class="<%=strclasse%>" align="center"><br><br><br><br><font color="#993300"><%=session("strMensagemRelatorioNaoEncontrado")%></font></td>
		  </tr>
		<%
	end if
	rs.close
%>
</table>
        <table width="100%" border="0" cellspacing="0" cellpadding="0" class="tabela">
           <tr>
              <td height="44" colspan="7" align="left" class="celula"><div align="center">
                <p>&nbsp;</p>
                <p>&nbsp;</p>
                <p>____________________________________________<BR>
                <%=session("NomeSecretariaEmpresaWeb")%><BR>
                SECRET&Aacute;RIO(A)</p>
              </div></td>
              <td width="35%" align="left" class="celula"><div align="center">
                <p>&nbsp;</p>
                <p>&nbsp;</p>
                <p>____________________________________________<BR>
                INSPE&Ccedil;&Atilde;O ESCOLAR</p>
              </div></td>
              <td width="35%" align="left" class="celula"><div align="center">
                <p>&nbsp;</p>
                <p>&nbsp;</p>
                <p>____________________________________________<BR>
                <%=session("NomeDiretorEmpresaWeb")%><BR>
                DIRETOR(A)</p>
              </div></td>
            </tr>
            <tr>
              <td height="44" colspan="9" align="left" class="celula"><div align="center"></div>
                  <div align="center"><strong><%=session("CidadeEmpresaWeb")%>, <%=day(date)%> DE <%=UCASE(monthname(month(date)))%> DE <%=year(date)%>.</strong>
                </div></td>
            </tr>
        </table>
<script>
	aguarde.style.display="none";
</script>
</body>
</html>
