<%
	if trim(mostra_resultado) = "" then
		strResultadoAprovacaoFinal = "Cursando"
		strCorFinal = "#FF9900"
		%>
		<div align="center"><strong>Resultado Final:</strong>&nbsp;<font color="<%=strCorFinal%>"><strong><%=strResultadoAprovacaoFinal%></strong></font></div>
		<%
	else	
	
	
		if strResultadoFinal = "" then
			strResultadoAprovacaoFinal = "Reprovado"
			strCorFinal = "#FF0000"
		else
			strResultadoAprovacaoFinal = "Aprovado"
			strCorFinal = "#0000FF"
		end if
		
		if isnull(intQtdeDisciplinaDependencia) or  trim(intQtdeDisciplinaDependencia) = "0" then
		   intQtdeDisciplinaDependencia = ""
		end if   
		if isnull(intQtdeDisciplinaRecuperacao) or  trim(intQtdeDisciplinaRecuperacao) = "0" then
		   intQtdeDisciplinaRecuperacao = ""
		end if   

		if cCur(strQtdeDiscRepFalta) > 0 then
			strResultadoAprovacaoFinal = "Reprovado" 'reprovado por falta
			strCorFinal = "#FF0000"
		else
			' Exame final
			if cCur(strQtdeDiscRep) > 0 then

				strResultadoAprovacaoFinal = "Reprovado"
				strCorFinal = "#FF0000"
			
				if intQtdeDisciplinaDependencia<>"" then
					if cCur(strQtdeDiscRep) > cCur(intQtdeDisciplinaDependencia) then
						strResultadoAprovacaoFinal = "Reprovado"
						strCorFinal = "#FF0000"
					else
						strResultadoAprovacaoFinal = "Aprovado com Dependência"
						strCorFinal = "#0000FF"
					end if
				end if
			
				if intQtdeDisciplinaRecuperacao<>"" then
					if strQtdeDiscRep > intQtdeDisciplinaRecuperacao then
						strResultadoAprovacaoFinal = "Reprovado"
						strCorFinal = "#FF0000"
					else
						if strTipoResultadoFinal = "D" then
							strResultadoAprovacaoFinal = "Reprovado"
							strCorFinal = "#FF0000"
						else
							strResultadoAprovacaoFinal = "Recuperação"
							strCorFinal = "#FF0000"
						end if	
					end if
				end if
					
				if intQtdeDisciplinaDependencia<>"" then
					if strQtdeDiscRep > intQtdeDisciplinaDependencia then
						strResultadoAprovacaoFinal = "Reprovado"
						strCorFinal = "#FF0000"
					else
						strResultadoAprovacaoFinal = "Aprovado com Dependência"
						strCorFinal = "#0000FF"
					end if
				end if
			
			end if
		
		end if

		if trim(strDesvincularCriterioAvaliacao) = "S" then
			strResultadoAprovacaoFinal = "Aprovado"
			strCorFinal = "#0000FF"
		end if	
		
		if trim(buscaHistorico) = "S" then
			if ucase(strSituacaoaluno) <> "ATIVO"  then
				strResultadoAprovacaoFinal = ucase(strSituacaoaluno)
			else
				strResultadoAprovacaoFinal = strResultadoAprovacaoFinal
			end if
		ELSE
			if ucase(strSituacaoaluno) <> "ATIVO" and ucase(strSituacaoaluno) <> "PRÉ-MATRÍCULA" AND ucase(strSituacaoaluno)<>"" then
				strCorFinal = "#FF0000"
				strResultadoAprovacaoFinal = ucase(strSituacaoaluno)
			end if	
		end if	
		
		strSituacaoPromocao = strResultadoAprovacaoFinal
		
		%>
		<div align="center"><strong>Resultado Final:</strong>&nbsp;<font color="<%=strCorFinal%>"><strong><%=strResultadoAprovacaoFinal%></strong></font></div>
		<%
		
		intCodSituacaoAluno = ""
		sql = "select cod_situacaoaluno from sca_situacaoaluno where desc_situacaoaluno = '" & strSituacaoaluno & "'"
		rsAux.open sql, cnn
		if not rsAux.eof then
			intCodSituacaoAluno = rsAux("cod_situacaoaluno")
		end if
		rsAux.close
		
		intCodSituacaoPromocao = ""
		sql = "SELECT codigo FROM SCA_SITUACAO_PROMOCAO where descricao = '" & strSituacaoPromocao & "'"
		rsAux.open sql, cnn
		if not rsAux.eof then
			intCodSituacaoPromocao = rsAux("codigo")
		end if
		rsAux.close
		
		if TRIM(intCodSituacaoAluno) = "" or isnull(intCodSituacaoAluno) then intCodSituacaoAluno = "0"
		if TRIM(intCodSituacaoPromocao) = "" or isnull(intCodSituacaoPromocao) then intCodSituacaoPromocao = "0"
		
		sql = "delete SCA_ALUNO_RESULTADO_FINAL"
		sql = sql& " where COD_EMPRESA = " & Session("CodEmpresa")
		sql = sql& " and ANO_LETIVO = " & Session("strAnoLetivo")
		sql = sql& " and SEMESTRE = " & Session("strSemestre")
		sql = sql& " and COD_ALUNO = " & intCodAluno
		cnn.execute sql
		
		SQL = "INSERT INTO SCA_ALUNO_RESULTADO_FINAL (COD_EMPRESA,ANO_LETIVO,SEMESTRE,COD_ALUNO,COD_TURMA,COD_SITUACAOALUNO,COD_SITUACAOPROMOCAO,DATA_SITUACAO, RESULTADO_FINAL) VALUES ("
		SQL = SQL & Session("CodEmpresa") & "," & Session("strAnoLetivo") & "," & Session("strSemestre") & "," & intCodAluno & "," & intCodTurma & "," 
		
		IF trim(intCodSituacaoAluno) = "0" THEN
			SQL = SQL & "NULL,"
		ELSE
			SQL = SQL & intCodSituacaoAluno & "," 
		END IF
		
		IF trim(intCodSituacaoPromocao) = "0" THEN
			SQL = SQL & "NULL,"
		ELSE
			SQL = SQL & intCodSituacaoPromocao & ","
		END IF
		SQL = SQL & "getdate(),'" & strResultadoAprovacaoFinal & "')"
		cnn.execute sql
		
	end if
%>