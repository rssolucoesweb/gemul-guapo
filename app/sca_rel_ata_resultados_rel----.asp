<%
response.Expires=0
SESSION.Timeout = 1200
Server.ScriptTimeout = 1200
%>
<!--#include file="includes/inc_verificaSessionApp.asp"-->
<!--#include file="includes/inc_cnn.asp"-->
<!--#include file="includes/inc_formatadata.asp"-->
<%
	dim intPagina
	dim strInfoTurma

	strAnoLetivo 			= request.form("txtAnoLetivo")
	intSemestre 			= Trim(Request.Form("cmbSemestre"))

	intCodCurso	 			= Trim(Request.Form("cmbCurso"))
	intCodPeriodo 			= Trim(Request.Form("cmbPeriodo"))
	intCodTurma 			= Trim(Request.Form("cmbTurma"))
	intCodTurno		 		= Trim(Request.Form("cmbTurno"))
	strSituacaoDisciplina   = Trim(Request.Form("cmbSituacaoDisciplina"))


	sql="select frequencia_minima_percentual from SCA_CRITERIO_AVALIACAO"
	sql=sql & " where	cod_empresa = "&Session("CodEmpresa") 
	sql=sql & " and		cod_curso	= "&intCodCurso
	rs.open sql, cnn
	if not rs.eof then
		intFreqMinima         = rs("frequencia_minima_percentual")
		rs.close
	else
		rs.close
		%>
		<script>
			alert("O critério de avaliação não foi criado para esse curso.");
			window.location="Avaliacao_cad.asp?intCodCurso=<%=intCodCurso%>";
		</script>
		<%
		response.end
	end if

    if intSemestre = "3" then 
		msgTitulo = "<br>Período Letivo: " & strAnoLetivo
	else
		msgTitulo = "<br>Período Letivo: " & strAnoLetivo & "/" & intSemestre
	end if 
	strTituloRelatorio  	= "ATA DE RESULTADO FINAIS " & msgTitulo

	sub mostraCabecalho()
	%>
	<!--#include file="includes/inc_cabecalhoRelatorio.asp"-->
	<br>
	<div class="table-responsive-lg">
    <table width="100%" border="0" cellspacing="0" cellpadding="0" class="tabela">
        <tr>
          <td colspan="7" align="left" class="celula10"><div align="center"><br>AOS <%=day(date)%> DIAS DO MÊS DE <%=UCASE(monthname(month(date)))%> DE<%=year(date)%>, TERMINOU-SE O PROCESSO DE APURAÇÃO DAS NOTAS FINAIS DOS ALUNOS RELACIONADOS ABAIXO:</div><br></td>
       </tr>
    </table>
	</div>
	<div class="table-responsive-lg">
<table width="100%" border="0" cellspacing="0" cellpadding="0" class="tabela" align="center">

        <% 
		sql = " SELECT D.Cod_Disciplina, D.Desc_Abreviada, D.DESC_Disciplina "
		sql = sql & " FROM SCA_GRADECURRICULARDISCIPLINA GCD "
		sql = sql & " INNER JOIN SCA_DISCIPLINA D ON GCD.Cod_Disciplina = D.COD_Disciplina "
		SQL = SQL & " WHERE GCD.COD_GRADECURRICULAR = " & TRIM(rs("Cod_GradeCurricular"))
		sql = sql & " Order by D.Cod_Disciplina "
		rsAux1.open sql, cnn, 3, 3
		if not rsAux1.eof then
			vetAux1 = rsAux1.getRows
			if isArray(vetAux1) then
				colunaComplemento = ubound(vetAux1,2)
			else
				colunaComplemento = 0
			end if
		else
			%>
			<script>
				alert("Atenção! Matriz curricular n. <%=TRIM(rs("Cod_GradeCurricular"))%> não cadastrada. Verifique!");
				window.location="Rel_NotasDisciplinaResumo_con.asp";
			</script>
			<%
			response.end
		end if
		rsAux1.close
		
		sql="SELECT frequencia_minima_percentual"
		sql=sql & " FROM SCA_CRITERIO_AVALIACAO"
		sql=sql & " WHERE	COD_EMPRESA = " & session("codEmpresa")
		sql=sql & " AND		COD_CURSO = " & intCodCurso
		rsAux1.open sql, cnn, 3, 1
		if not rs.eof then
			intFrequenciaMinimaPerc = rsAux1("frequencia_minima_percentual")
			rsAux1.close
		else
			rsAux1.close
			%>
				<script>
						alert("ATENÇÃO: Não foi encontrado critério de avaliação");
						window.location="<%=pagina_atual%>";
				</script>
			<%
			response.end
		end if	
		
		'
		if marca = 1 then 
			marca = 0
			%>
			<tr bgcolor="#CCCCCC">
				<td height="29" colspan="<%=7 + colunaComplemento%>" class="celula10"><strong>Turma:&nbsp;<%=rs("TurmaAluno")%>&nbsp;&nbsp;<%=rs("NomeTurma")%>&nbsp;-&nbsp;Curso:&nbsp;<%=rs("Curso")%> </strong></td>
			</tr>
			<% 
		end if 
		%>
	  	<tr bgcolor="#CCCCCC">
            <td width="3%" class="celula10"><div align="center"><strong>Ordem</strong></div></td>
            <td width="5%" class="celula10"><div align="center"><strong>Matr&iacute;cula</strong></div></td>
            <td width="27%" class="celula10"><strong>&nbsp;&nbsp;Nome do Aluno</strong></td>
            <td width="8%" class="celula10"><div align="left"><strong>Sit. Acad&ecirc;mica</strong></div></td>
            <%
            if isArray(vetAux1) then
                colunaComplemento = ubound(vetAux1,2)
                for j=0 to ubound(vetAux1,2)
                   strDisciplinaAbreviada = vetAux1(1,j) 
                   %>
                   <td width="6%" align="center" class="celula10"><strong><%=strDisciplinaAbreviada%></strong></td>
                   <%
                next	
                %>
                <td width="4%" align="center" class="celula10"><strong>FALTAS</strong></td>
                <td width="4%" align="center" class="celula10"><strong>RESULTADO</strong></td>
                <%
            end if	
            %>
	  </tr> 
	<%
	end Sub
	
	sub fimTabela()
		response.Write("</table></div>")
	end Sub

	intPagina = 1
	IntOrd = 1

	sql = "SELECT DISTINCT SCA_ALUNO.CODIGO, SCA_ALUNO.MATRICULA, SCA_ALUNO.NOMEALUNO, SCA_TURMA.COD_TURMA, SCA_TURMA.NomeTurma, SCA_TURMA.TurmaAluno, SCA_TURMA.Cod_GradeCurricular, SA.DESC_SITUACAOALUNO, SCA_CURSO.Descricao as Curso, SCA_PERIODO.DESCRICAO AS PERIODO, SCA_TURNO.DESC_TURNO AS TURNO, ISNULL(SCA_TURMA.DesvincularCriterioAvaliacao,'S') as DesvincularCriterioAvaliacao, SCA_CURSO.Cod_Curso"
	sql = sql & " FROM SCA_ALUNO_TURMA "
	sql = sql & " INNER JOIN SCA_ALUNO ON SCA_ALUNO_TURMA.COD_ALUNO = SCA_ALUNO.CODIGO "
	sql = sql & " INNER JOIN SCA_TURMA ON (SELECT TOP 1 COD_TURMA FROM SCA_ALUNO_TURMA WHERE COD_ALUNO = SCA_ALUNO.CODIGO AND SCA_ALUNO_TURMA.Ano_Letivo = " & strAnoLetivo & " and SCA_ALUNO_TURMA.Semestre in (" & intSemestre & ") ORDER BY CODIGO DESC) = SCA_TURMA.Cod_Turma "
	sql = sql & " INNER JOIN SCA_GRADECURRICULAR ON SCA_TURMA.Cod_GradeCurricular = SCA_GRADECURRICULAR.Cod_GradeCurricular"
	sql = sql & " INNER JOIN SCA_PERIODO ON SCA_PERIODO.Cod_Periodo = SCA_GRADECURRICULAR.Cod_Periodo "
	sql = sql & " INNER JOIN SCA_CURSO ON SCA_CURSO.Cod_Curso = SCA_PERIODO.Cod_Curso "
    sql = sql & " LEFT JOIN SCA_SITUACAOALUNO SA ON SA.COD_SITUACAOALUNO = SCA_ALUNO.COD_SITUACAOALUNO " 
	sql = sql & " LEFT JOIN SCA_TURNO ON SCA_TURNO.Cod_Turno = SCA_TURMA.Cod_Turno "
	sql = sql & " WHERE	SCA_ALUNO_TURMA.Ano_Letivo = " & strAnoLetivo
	sql = sql & " and 	SCA_ALUNO_TURMA.Semestre in (" & intSemestre & ")"
	if intCodCurso <> "0" then
	  sql = sql & " and SCA_CURSO.Cod_Curso = " & intCodCurso
	end if
	if intCodPeriodo <> "0" then
	  sql = sql & " and SCA_GRADECURRICULAR.Cod_Periodo = " & intCodPeriodo
	end if
	if intCodTurno <> "0" then
	  sql = sql & " and SCA_TURMA.COD_TURNO = " & intCodTurno
	end if
	if intCodTurma <> "0" then
	  sql = sql & " and SCA_TURMA.COD_TURMA = " & intCodTurma
	end if
	sql = sql & " Order By SCA_TURMA.NomeTurma, SCA_ALUNO.NOMEALUNO"
	response.write sql
	rs.open sql, cnn
	if not rs.eof then 
		'
		marca = 1
		mostraCabecalho
		'
		sql = " SELECT D.Cod_Disciplina, D.Desc_Abreviada, D.DESC_Disciplina "
		sql = sql & " FROM SCA_GRADECURRICULARDISCIPLINA GCD "
		sql = sql & " INNER JOIN SCA_DISCIPLINA D ON GCD.Cod_Disciplina = D.COD_Disciplina "
		SQL = SQL & " WHERE GCD.COD_GRADECURRICULAR = " & TRIM(rs("Cod_GradeCurricular"))
		sql = sql & " Order by D.Cod_Disciplina "
		rsAux1.open sql, cnn, 3, 3
		if not rsAux1.eof then
			vetAux1 = rsAux1.getRows
			if isArray(vetAux1) then
				colunaComplemento = ubound(vetAux1,2)
			else
				colunaComplemento = 0
			end if
		else
			%>
			<script>
				alert("Atenção! Matriz curricular n. <%=TRIM(rs("Cod_GradeCurricular"))%> não cadastrada. Verifique!");
				window.location="<%=pagina_atual%>";
			</script>
			<%
			response.end
		end if
		rsAux1.close

		While not rs.eof
		
			Media = "0"
			Situacao = "----"
			SituacaoFinal = "<font color='#FF0000'>----</fonte>"

			sql = " SELECT "
			sql = sql & " replace(FORMAT( NF.MEDIA, '##.0' ),'.',',') as MEDIA, "
			sql = sql & " 			( "
			sql = sql & " 			select count(distinct data) from sca_faltas_diaria "
			sql = sql & " 			where COD_ALUNO = NF.cod_aluno  "
			sql = sql & " 			and cod_disciplina = NF.Cod_Disciplina"
			sql = sql & " 			and ano_letivo = " & strAnoLetivo
			sql = sql & " 			) AS FALTAS, "
			sql = sql & " 			NF.Cod_Disciplina, D.DESC_Disciplina, NF.Situacao, ("
			sql = sql & " select d.Ch_Anual "
			sql = sql & " from SCA_GRADECURRICULARDISCIPLINA d"
			sql = sql & " inner join SCA_GRADECURRICULAR g on g.Cod_GradeCurricular = d.Cod_GradeCurricular"
			sql = sql & " inner join SCA_ALUNO_DISCIPLINA ad on ad.COD_GRADECURRICULARDISCIPLINA = d.COD_GRADECURRICULARDISCIPLINA "
			sql = sql & " where g.cod_empresa = " & session("codEmpresa")
			sql = sql & " and ad.cod_aluno =  " & TRIM(rs("CODIGO"))
			sql = sql & " and d.cod_disciplina = NF.Cod_Disciplina" 
			sql = sql & " ) as Ch_Anual  "  
			
			sql = sql & " FROM SCA_NOTAS_FALTAS NF " 
			sql = sql & " INNER JOIN SCA_DISCIPLINA D ON D.Cod_Disciplina = NF.COD_Disciplina "
			sql = sql & " WHERE NF.COD_ALUNO = " & TRIM(rs("CODIGO"))
			sql = sql & " AND NF.ANO_LETIVO = " & strAnoLetivo
			sql = sql & " AND NF.SEMESTRE = " & intSemestre
			sql = sql & " Order by D.Cod_Disciplina "
			rsAux1.open sql, cnn, 3, 3
			
			if not rsAux1.eof then
				vetAux2 = rsAux1.getRows
			else
				vetAux2 = "0"
			end if
			rsAux1.close
			
			strSituacaoAluno = ""
			if trim(strAnoLetivo)<>trim(session("strAnoLetivo")) then
				sql = " select sa.desc_situacaoaluno"
				sql = sql & " from SCA_CONTROLE_SITUACAO_ALUNO_FECHAMENTO F "
				sql = sql & " inner JOIN SCA_SITUACAOALUNO sa ON sa.cod_situacaoaluno = F.cod_situacaoaluno_atual "
				sql = sql & " where f.cod_aluno = " & TRIM(rs("CODIGO"))
				sql = sql & " and f.ano_letivo = " & strAnoLetivo 
				rsAux.open sql, cnn
				if not rsAux.eof then
					strSituacaoAluno		  = rsAux("desc_situacaoaluno")
				end if
				rsAux.close
				
				if strSituacaoAluno = "ATIVO" then
					strSituacaoAluno = ""
				end if
				
			else
				if trim(rs("DESC_SITUACAOALUNO")) = "ATIVO" then
					strSituacaoAluno = ""
				else
					strSituacaoAluno = trim(rs("DESC_SITUACAOALUNO"))
				end if
			end if
			
			
			
			tipo_criterio=""
			sql = "select ta.codigo, tc.descricao as tipo_criterio"
			sql = sql & " from SCA_TIPO_AVALIACAO_INDIVIDUAL_ALUNO ta inner join SCA_TIPO_CRITERIO tc on tc.codigo = ta.cod_tipo_criterio" 
			sql = sql & " where ta.ano_letivo = " & strAnoLetivo
			sql = sql & " and ta.cod_empresa = " & session("CodEmpresa")
			sql = sql & " and ta.cod_curso = " & TRIM(rs("Cod_Curso"))
			sql = sql & " and ta.cod_aluno = " & TRIM(rs("CODIGO"))
			rsAux.open sql, cnn
			if not rsAux.eof then
				tipo_criterio		  = "&nbsp;<span class='fonte7'><strong>(" & rsAux("tipo_criterio") & ")</strong></span>"
			end if
			rsAux.close
			%>
			<tr>
                <td class="celula10" align="left"><div align="center"><%=IntOrd%>&nbsp;</div></td>
                <td class="celula10" align="left"><div align="center"><%=rs("MATRICULA")%></div></td>
                <td align="left" class="celula10">&nbsp;&nbsp;<%=rs("NOMEALUNO")%> <%=tipo_criterio%></td>
                <td align="left" class="celula10">&nbsp;&nbsp;<%=strSituacaoAluno%></td>
				<%
                if isArray(vetAux1) then
					
					Faltas = 0
					SituacaoFinalRF = ""
					SituacaoFinalNT = "AP"
                    for j=0 to ubound(vetAux1,2)
					
						strExisteDisciplina = "N"
						
						if isArray(vetAux2) then
							k = 0
							Media = "0"
							Situacao = "----"
							do while k <= ubound(vetAux2,2)
							
								if vetAux1(0,j) = vetAux2(2,k) then
									strExisteDisciplina = "S"
									Media = vetAux2(0,k)
									Situacao = vetAux2(4,k)
									if vetAux2(4,k) <> "AP" then
										SituacaoFinalNT = "<font color='#FF0000'>" & Situacao & "</fonte>"
									end if
									'Verifica reprovacao por falta
									strCHDisciplina = vetAux2(5,k)
									strPercFaltasPorDisciplina = (vetAux2(1,k) * 100)/strCHDisciplina
									if clng(strPercFaltasPorDisciplina) > cLng(intFreqMinima) then 
										SituacaoFinalRF = "<font color='#FF0000'>RF</font>"
									end if 
									Faltas = vetAux2(1,k)
									if rs("DesvincularCriterioAvaliacao") = "S" then
									%>
									<td align="center" class="celula10">&nbsp;</td>
									<%
										SituacaoFinalNT = "AP"
									else
									%>
									<td align="center" class="celula10"><strong><%=Media%></strong></td>
									<%
									end if
									exit do
								end if
								
								k = k + 1
								
							loop
							
						else
							if rs("DesvincularCriterioAvaliacao") = "S" then
								%>
								<td align="center" class="celula10">&nbsp;</td>
								<%
							else
								%>
								<td align="center" class="celula10">----</td>
								<%
							end if
						end if
						
                    next

				end if
				SituacaoFinal = SituacaoFinalNT
				if SituacaoFinalRF <> "" then SituacaoFinal = SituacaoFinalRF
				if strSituacaoAluno <> "" then SituacaoFinal = "<font color='#FF0000'>----</fonte>"
				
				%>
				<td align="center" class="celula10"><strong><%=Faltas%></strong></td>
				<td align="center" class="celula10"><strong><%=SituacaoFinal%> </strong></td>
  </tr>
			<%
			'quantidade de registros da página
			if intQtdeRegistroPorPagina = 25 then
				 'intPagina = intPagina + 1
				 'intQtdeRegistroPorPagina = 1
				 'fimTabela
				%>
				<!--pre></pre-->				
				<%			
				'marca = 1
				'mostraCabecalho
			end if	
			intQtdeRegistroPorPagina = intQtdeRegistroPorPagina + 1
			IntOrd = IntOrd + 1
			VchaveTurma = trim(rs("COD_TURMA"))
			rs.movenext
			if not rs.eof then
			  	if VchaveTurma <> trim(rs("COD_TURMA")) then
				  	marca = 1
				end if
            else				
				marca = 0
			end if

			if marca = 1 then
			     'IntOrd = 1
				 'intPagina = intPagina + 1
				 'intQtdeRegistroPorPagina = 1
				 'fimTabela
				%>
				<!--pre></pre-->				
				<%			
				'mostraCabecalho
			end if
		wend
		%>
		<div class="table-responsive-lg">
        <table width="100%" border="0" cellspacing="0" cellpadding="0" class="tabela">
             <tr>
              <td height="44" colspan="9" align="left" class="celula10"><div align="center"></div>
                  <div align="center"><strong>E, PARA CONSTAR, EU <%=session("NomeSecretariaEmpresaWeb")%>, SECRETÁRIO(A), LAVREI A PRESENTE ATA QUE VAI ASSINADA POR MIM E
PELO(A) GESTOR(A) DESTA INSTITUIÇÃO DE ENSINO.
                </div></td>
            </tr>
           <tr>
              <td height="44" colspan="7" align="left" class="celula10"><div align="center">
                <p>&nbsp;</p>
                <p>&nbsp;</p>
                <p>____________________________________________<BR>
                <%=session("NomeSecretariaEmpresaWeb")%><BR>
                SECRET&Aacute;RIO(A)</p>
              </div></td>
              <td width="35%" align="left" class="celula10"><div align="center">
                <p>&nbsp;</p>
                <p>&nbsp;</p>
                <p>____________________________________________<BR>
                <%=session("NomeDiretorEmpresaWeb")%><BR>
                DIRETOR(A)</p>
              </div></td>
              <td width="35%" align="left" class="celula10"><div align="center">
                <p>&nbsp;</p>
                <p>&nbsp;</p>
                <p>____________________________________________<BR>
                INSPE&Ccedil;&Atilde;O ESCOLAR</p>
              </div></td>
            </tr>
            <tr>
              <td height="44" colspan="9" align="left" class="celula10"><div align="center"></div>
                  <div align="center"><strong><%=session("CidadeEmpresaWeb")%>, <%=day(date)%> DE <%=UCASE(monthname(month(date)))%> DE <%=year(date)%>.</strong>
                </div></td>
            </tr>
        </table>
		</div>
        <%
	else
	    mostraCabecalho
		%>
		  <tr>
			<td colspan="<%=7 + colunaComplemento%>" class="celula10" align="center"><font color="#993300"><%=session("strMensagemRelatorioNaoEncontrado")%></font></td>
		  </tr>
  <%
	end if
	rs.close
%>
</table>
</div>
