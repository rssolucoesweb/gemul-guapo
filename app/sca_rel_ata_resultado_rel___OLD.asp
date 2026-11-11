<%
response.Expires=0
'Não armazena a página em buffer antes de mostra-la na tela'
response.Buffer = false
SESSION.Timeout = 1200
Server.ScriptTimeout = 1200
%>
<html>
<head>
<title><%=session("Titulo")%> - Ata de Resultado Finais</title>
<meta http-equiv="content-type" content="text/html; charset=UTF-8">
<link type="text/css" rel="stylesheet" href="css_rel/Estilo_Impressao.css">
<style>
	.fonte7 {
		font-size: 7;
		color:blue
	}
</style>
<script src="js/js_funcoes_gerais.js"></script>
<script src="js/js_barra_movel.js"></script>
</head>
<body>
<!--#include file="includes/inc_verificaSessionApp.asp"-->
<!--#include file="includes/inc_cnn.asp"-->
<!--#include file="includes/inc_formatadata.asp"-->
<!--#include file="includes/inc_sqlAlunoTurmaTodasSituacoes.asp"-->
<!--#include file="includes/inc_Botoes_relatorio.asp"-->
<!--#include file="includes/inc_aguarde.asp"-->
<br>
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


	sql="select frequencia_minima_percentual, media_aprovacao, num_disciplina_prog_parcial  from SCA_CRITERIO_AVALIACAO"
	sql=sql & " where	cod_curso	= "&intCodCurso
	sql=sql & " and ano_letivo = " & strAnoLetivo
	rs.open sql, cnn
	if not rs.eof then
		intFreqMinima         = rs("frequencia_minima_percentual")
		intMediaAprovacao 			= rs("media_aprovacao")
		intQtdeDisciplinaDependencia = rs("num_disciplina_prog_parcial")
		rs.close
	else
		rs.close
		%>
		<script>
			alert("O critério de avaliação não foi criado para esse curso.");
			window.location="sca_criterio_avaliacao.asp?intCodCurso=<%=intCodCurso%>";
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

	sub mostraCabecalho(cod_grade)
	%>
	<!--#include file="includes/inc_cabecalhoRelatorio.asp"-->
	<br>

    <table width="100%" border="0" cellspacing="0" cellpadding="0" class="tabela">
        <tr>
          <td colspan="7" align="left" class="celula"><div align="center"><br>AOS <%=day(date)%> DIAS DO MÊS DE <%=UCASE(monthname(month(date)))%> DE<%=year(date)%>, TERMINOU-SE O PROCESSO DE APURAÇÃO DAS NOTAS FINAIS DOS ALUNOS RELACIONADOS ABAIXO:</div><br></td>
       </tr>
    </table>

<table width="100%" border="0" cellspacing="0" cellpadding="0" class="tabela">

        <% 
		sql = " SELECT D.Cod_Disciplina, D.Desc_Abreviada,  isnull(GCD.Omitir_Criterio,'N') as Omitir_Criterio "
		sql = sql & " FROM SCA_GRADECURRICULARDISCIPLINA GCD "
		sql = sql & " INNER JOIN SCA_DISCIPLINA D ON GCD.Cod_Disciplina = D.COD_Disciplina "
		SQL = SQL & " WHERE GCD.COD_GRADECURRICULAR = " & cod_grade
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
				alert("Atenção! Matriz curricular não cadastrada. Verifique!");
				window.history.back();
			</script>
			<%
			response.end
		end if
		rsAux1.close
		
		intFrequenciaMinimaPerc = intFreqMinima
	
		if marca = 1 then 
			marca = 0
			%>
			<tr bgcolor="#CCCCCC">
				<td height="29" colspan="<%=7 + colunaComplemento%>" class="celula"><strong>Turma:&nbsp;<%=rs("TurmaAluno")%>&nbsp;&nbsp;<%=rs("NomeTurma")%>&nbsp;-&nbsp;Curso:&nbsp;<%=rs("Curso")%> </strong></td>
			</tr>
			<% 
		end if 
		%>
	  	<tr bgcolor="#CCCCCC">
            <td width="3%" class="celula"><div align="center"><strong>Ordem</strong></div></td>
            <td width="5%" class="celula"><div align="center"><strong>Matr&iacute;cula</strong></div></td>
            <td width="27%" class="celula"><strong>&nbsp;&nbsp;Nome do Aluno</strong></td>
            <td width="8%" class="celula"><div align="left"><strong>Sit. Acad&ecirc;mica</strong></div></td>
            <%
            if isArray(vetAux1) then
                colunaComplemento = ubound(vetAux1,2)
                for j=0 to ubound(vetAux1,2)
                   strDisciplinaAbreviada = vetAux1(1,j) 
                   %>
                   <td width="6%" align="center" class="celula"><strong><%=strDisciplinaAbreviada%></strong></td>
                   <%
                next	
                %>
                <!--td width="4%" align="center" class="celula"><strong>FALTAS</strong></td-->
                <td width="4%" align="center" class="celula"><strong>RESULTADO</strong></td>
                <%
            end if	
            %>
	  </tr> 
	<%
	end Sub
	
	sub fimTabela()
		response.Write("</table>")
	end Sub

	intPagina = 1
	IntOrd = 1

	sql = sqlAlunoTurma(intCodTurma, "")
	IF ucase(SESSION("USUARIOWEB")) = "SERGIO" THEN
		'response.write sql
	END IF
	rs.open sql, cnn
	if not rs.eof then 
		'
		marca = 1
		mostraCabecalho TRIM(rs("Cod_GradeCurricular"))
		'
		sql = " SELECT D.Cod_Disciplina, D.Desc_Abreviada, isnull(GCD.Omitir_Criterio,'N') as Omitir_Criterio "
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
				alert("Atenção: Matriz curricular n. <%=TRIM(rs("Cod_GradeCurricular"))%> não cadastrada. Verifique!");
				window.history.back();
			</script>
			<%
			response.end
		end if
		rsAux1.close

		While not rs.eof
			
			Media = "0"
			Situacao = "----"
			SituacaoFinal = "<font color='#FF0000'>----</fonte>"
			if trim(strAnoLetivo)<>trim(session("strAnoLetivo")) then
				'busca historico
				sql = " select hd.media,"
				sql = sql & " isnull(hd.falta01,0) + "
				sql = sql & " isnull(hd.falta02,0) + "
				sql = sql & " isnull(hd.falta03,0) + "
				sql = sql & " isnull(hd.falta04,0) + "
				sql = sql & " isnull(hd.falta05,0) + "
				sql = sql & " isnull(hd.falta06,0) + "
				sql = sql & " isnull(hd.falta07,0) + "
				sql = sql & " isnull(hd.falta08,0) + "
				sql = sql & " isnull(hd.falta09,0) + "
				sql = sql & " isnull(hd.falta10,0) + "
				sql = sql & " isnull(hd.falta11,0) + "
				sql = sql & " isnull(hd.falta12,0) + "
				sql = sql & " isnull(hd.falta13,0) + "
				sql = sql & " isnull(hd.falta14,0) + "
				sql = sql & " isnull(hd.falta15,0) as faltas,"
				sql = sql & " hd.cod_disciplina, D.DESC_Disciplina, hd.Situacao,"
				sql = sql & " hd.carga_horaria as Ch_Anual"
				sql = sql & " from SCA_HISTORICO_ESCOLAR h"
				sql = sql & " inner join SCA_HISTORICO_ESCOLAR_DISCIPLINA hd on hd.cod_historico_escolar = h.codigo"
				sql = sql & " INNER JOIN SCA_DISCIPLINA D ON D.Cod_Disciplina = hd.COD_Disciplina "
				sql = sql & " where h.cod_aluno = " & TRIM(rs("CODIGO"))
				sql = sql & " and h.ano_letivo=" & strAnoLetivo
				sql = sql & " Order by D.DESC_Disciplina "
			else
				sql = " SELECT "
				sql = sql & " replace(FORMAT( NF.MEDIA, '##.0' ),'.',',') as MEDIA, "
				sql = sql & " ISNULL(NF.FALTA01,0)+ISNULL(NF.FALTA02,0)+ISNULL(NF.FALTA03,0) as FALTAS, "
				'sql = sql & " 			( "
				'sql = sql & " 			select count(distinct data) from sca_faltas_diaria "
				'sql = sql & " 			where COD_ALUNO = NF.cod_aluno  "
				'sql = sql & " 			and cod_disciplina = NF.Cod_Disciplina"
				'sql = sql & " 			and ano_letivo = " & strAnoLetivo
				'sql = sql & " 			) AS FALTAS, "
				sql = sql & " 			NF.Cod_Disciplina, D.DESC_Disciplina, NF.Situacao, ("
				sql = sql & " select distinct d.Ch_Anual "
				sql = sql & " from SCA_GRADECURRICULARDISCIPLINA d"
				sql = sql & " inner join SCA_GRADECURRICULAR g on g.Cod_GradeCurricular = d.Cod_GradeCurricular"
				sql = sql & " inner join SCA_ALUNO_DISCIPLINA ad on ad.COD_GRADECURRICULARDISCIPLINA = d.COD_GRADECURRICULARDISCIPLINA "
				sql = sql & " where ad.cod_aluno =  " & TRIM(rs("CODIGO"))
				sql = sql & " and d.cod_disciplina = NF.Cod_Disciplina" 
				sql = sql & " ) as Ch_Anual  "  
				
				sql = sql & " FROM SCA_NOTAS_FALTAS NF " 
				sql = sql & " INNER JOIN SCA_DISCIPLINA D ON D.Cod_Disciplina = NF.COD_Disciplina "
				sql = sql & " WHERE NF.COD_ALUNO = " & TRIM(rs("CODIGO"))
				sql = sql & " AND NF.ANO_LETIVO = " & strAnoLetivo
				sql = sql & " AND NF.SEMESTRE = " & intSemestre
				
				sql = sql & " Order by D.Cod_Disciplina "
			end if
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
			'sql = "select ta.codigo, tc.descricao as tipo_criterio"
			'sql = sql & " from SCA_TIPO_AVALIACAO_INDIVIDUAL_ALUNO ta inner join SCA_TIPO_CRITERIO tc on tc.codigo = ta.cod_tipo_criterio" 
			'sql = sql & " where ta.ano_letivo = " & strAnoLetivo
			'sql = sql & " and ta.cod_empresa = " & session("CodEmpresa")
			'sql = sql & " and ta.cod_curso = " & TRIM(rs("Cod_Curso"))
			'sql = sql & " and ta.cod_aluno = " & TRIM(rs("CODIGO"))
			'rsAux.open sql, cnn
			'if not rsAux.eof then
			'	tipo_criterio		  = "&nbsp;<span class='fonte7'><strong>(" & rsAux("tipo_criterio") & ")</strong></span>"
			'end if
			'rsAux.close
			%>
			<tr>
                <td class="celula" align="left"><div align="center"><%=IntOrd%>&nbsp;</div></td>
                <td class="celula" align="left"><div align="center"><%=rs("MATRICULA")%></div></td>
                <td align="left" class="celula">&nbsp;&nbsp;<%=rs("NOMEALUNO")%> <%=tipo_criterio%></td>
                <td align="left" class="celula">&nbsp;&nbsp;<%=strSituacaoAluno%></td>
				<%
                if isArray(vetAux1) then
					
					Faltas = 0
					SituacaoFinalRF = ""
					SituacaoFinalNT = "AP"
					strQtdeDiscRep = 0
					controle_vet = 0
					strQtdeDiscRepFalta = 0
					for j=0 to ubound(vetAux1,2)
						strExisteDisciplina = "N"
						
						Omitir_Criterio = vetAux1(2,j)
                    		
						if isArray(vetAux2) then
							k = 0
							Media = "0"
							Situacao = "----"
							achou_nota_lancada = ""
							do while k <= ubound(vetAux2,2)
                    							
								if vetAux1(0,j) = vetAux2(2,k) then
									strExisteDisciplina = "S"
									Media = vetAux2(0,k)
									MediaFinal = vetAux2(0,k)
									Situacao = vetAux2(4,k)
									if isnull(Situacao) then Situacao = "AP"

									if Situacao <> "AP" then
										if Situacao = "RF" then
											SituacaoFinalNT = "<font color='#FF0000'>" & Situacao & "</font>"
											strQtdeDiscRepFalta = strQtdeDiscRepFalta + 1
										else
											SituacaoFinalNT = "<font color='#FF0000'>" & Situacao & "</font>"
										end if
									end if
									'Verifica reprovacao por falta
									strCHDisciplina = vetAux2(5,k)
									if vetAux2(1,k)<>"" and vetAux2(1,k)<>"0" and strCHDisciplina<>"" then
										strPercFaltasPorDisciplina = (vetAux2(1,k) * 100)/strCHDisciplina
									end if
									
									'if rs("MATRICULA") = "202101892" then
									'	response.write  "<hr><br>MediaFinal:" & MediaFinal
									'	response.write  "<br>intMediaAprovacao:" & intMediaAprovacao
									'	response.write  "<br>strQtdeDiscRep:" & strQtdeDiscRep
									'	response.write  "<br>Situacao:" & Situacao
									'	
									'end if
									
									if not isnull(MediaFinal) and MediaFinal<>"" then
										if cCur(MediaFinal) < cCur(intMediaAprovacao) then
											if rs("DesvincularCriterioAvaliacao") = "S" or Omitir_Criterio="S" then
											else
												strQtdeDiscRep = strQtdeDiscRep + 1
												reprovou_por_nota = "S"
											end if
											
										end if
									end if
									
									
									
									if clng(strPercFaltasPorDisciplina) > cLng(intFreqMinima) then 
										SituacaoFinalRF = "<font color='#FF0000'>RF</font>"
										
										sql = "select codigo from SCA_ALUNO_APROVADO_CONSELHO "
										sql = sql & " where cod_aluno = " & TRIM(rs("CODIGO")) 
										sql = sql & " and cod_turma = " & intCodTurma
										rsAux1.open sql, cnn
										if not rsAux1.eof then
											SituacaoFinalRF = "<font color='#097a12'>AP</font>"
											strQtdeDiscRepFalta = 0
										end if
										rsAux1.close
										
									end if 
									IF strQtdeDiscRepFalta>0 THEN
										
										sql = "select codigo from SCA_ALUNO_APROVADO_CONSELHO "
										sql = sql & " where cod_aluno = " & TRIM(rs("CODIGO")) 
										sql = sql & " and cod_turma = " & intCodTurma
										rsAux1.open sql, cnn
										if not rsAux1.eof then
											SituacaoFinalRF = "<font color='#097a12'>AP</font>"
											strQtdeDiscRepFalta = 0
										end if
										rsAux1.close
										
									END IF
									
									Faltas = Faltas + vetAux2(1,k)
									if rs("DesvincularCriterioAvaliacao") = "S" or Omitir_Criterio="S" then
										%>
										<td align="center" class="celula">&nbsp;</td>
										<%
										SituacaoFinalNT = "AP"
										achou_nota_lancada = "S"
										SituacaoFinalRF = ""
									else
										IF TRIM(Media) <> "" AND TRIM(Media) <> "---" THEN Media = FORMATNUMBER(Media,1)
										if strSituacaoAluno <> "" then
										%>
										<td align="center" class="celula">&nbsp;</td>
										<%
										else
										%>
										<td align="center" class="celula"><strong><%=Media%></strong></td>
										<%
										end if
										achou_nota_lancada = "S"
									end if
									
									exit do
								end if
								
								k = k + 1
								
							loop
							
							IF achou_nota_lancada = "" THEN
								%>
								<td align="center" class="celula">&nbsp;</td>
								<%
							end if
						else
							if rs("DesvincularCriterioAvaliacao") = "S" or Omitir_Criterio = "S" then
								%>
								<td align="center" class="celula">&nbsp;</td>
								<%
							else
								%>
								<td align="center" class="celula">----</td>
								<%
							end if
						end if
						controle_vet = controle_vet + 1 
                    next

				end if
				SituacaoFinal = SituacaoFinalNT
				if SituacaoFinalRF <> "" then SituacaoFinal = SituacaoFinalRF
				
				if strSituacaoAluno <> "" then Faltas = "----"
				
				
				if reprovou_por_nota = "S" then
					if strQtdeDiscRep > intQtdeDisciplinaDependencia then
						SituacaoFinal = "<font color='#FF0000'>RN</font>"
					else
						SituacaoFinal = "AP"
					end if
				end if
				
				
				
				if strSituacaoAluno <> "" then SituacaoFinal = "---"
				%>
				<td align="center" class="celula"><strong><%=SituacaoFinal%></strong></td>
			</tr>
			<%
			Faltas = 0
			'quantidade de registros da página
			if intQtdeRegistroPorPagina = 25 then
				 intPagina = intPagina + 1
				 intQtdeRegistroPorPagina = 1
				 fimTabela
				%>
				<pre></pre>				
				<%			
				marca = 1 
				mostraCabecalho TRIM(rs("Cod_GradeCurricular"))
				'mostraCabecalho
			end if	
			intQtdeRegistroPorPagina = intQtdeRegistroPorPagina + 1
			IntOrd = IntOrd + 1
			VchaveTurma = trim(rs("COD_TURMA"))
			cod_grade = TRIM(rs("Cod_GradeCurricular"))
			rs.movenext
			if not rs.eof then
			  	if VchaveTurma <> trim(rs("COD_TURMA")) then
				  	marca = 1
				end if
            else				
				marca = 0
			end if

			if marca = 1 then
			     IntOrd = 1
				 intPagina = intPagina + 1
				 intQtdeRegistroPorPagina = 1
				 fimTabela
				%>
				<pre></pre>				
				<%			
				mostraCabecalho cod_grade
			end if
		wend
		%>
        <table width="100%" border="0" cellspacing="0" cellpadding="0" class="tabela">
             <tr>
              <td height="44" colspan="9" align="left" class="celula"><div align="center"></div>
                  <div align="center"><strong>E, PARA CONSTAR, EU <%=session("NomeSecretariaEmpresaWeb")%>, SECRETÁRIO(A), LAVREI A PRESENTE ATA QUE VAI ASSINADA POR MIM E
PELO(A) GESTOR(A) DESTA INSTITUIÇÃO DE ENSINO.
                </div></td>
            </tr>
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
                <%=session("NomeDiretorEmpresaWeb")%><BR>
                DIRETOR(A)</p>
              </div></td>
              <td width="35%" align="left" class="celula"><div align="center">
                <p>&nbsp;</p>
                <p>&nbsp;</p>
                <p>____________________________________________<BR>
                INSPE&Ccedil;&Atilde;O ESCOLAR</p>
              </div></td>
            </tr>
            <tr>
              <td height="44" colspan="9" align="left" class="celula"><div align="center"></div>
                  <div align="center"><strong><%=session("CidadeEmpresaWeb")%>, <%=day(date)%> DE <%=UCASE(monthname(month(date)))%> DE <%=year(date)%>.</strong>
                </div></td>
            </tr>
        </table>
        <%
	else
	    mostraCabecalho 0
		%>
		  <tr>
			<td colspan="<%=7 + colunaComplemento%>" class="celula" align="center"><font color="#993300"><%=session("strMensagemRelatorioNaoEncontrado")%></font></td>
		  </tr>
  <%
	end if
	rs.close
%>
</table>

<script>
	aguarde.style.display="none";
</script>
</body>
</html>
