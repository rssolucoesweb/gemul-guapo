<%
if trim(strMostraResultadoFinal) = "" then
	strResultadoAprovacaoFinal = "Cursando"
	strCorFinal = "#FF9900"
	%>
	<div align="center"><strong>Resultado Final:</strong>&nbsp;<font color="<%=strCorFinal%>"><strong><%=strResultadoAprovacaoFinal%></strong></font></div>
	<%
else	
	if strResultadoFinal = "" then
		strResultadoAprovacaoFinal = "Cursando"
		strCorFinal = "#FF9900"
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

	' Exame final
	if strQtdeDiscRep > 0 then

		strResultadoAprovacaoFinal = "Reprovado"
		strCorFinal = "#FF0000"
	
		if strTipoFormulaFinal = "EF" then
			if intQtdeDisciplinaDependencia<>"" then
				if strQtdeDiscRep > intQtdeDisciplinaDependencia then
					strResultadoAprovacaoFinal = "Reprovado"
					strCorFinal = "#FF0000"
				else
					strResultadoAprovacaoFinal = "Aprovado com Dependência"
				end if
			end if
	
		'recuperacao
		elseif strTipoFormulaFinal = "REC" then
			
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
				end if
			end if
		end if
    else
		if strResultadoFinal = "" then
			strResultadoAprovacaoFinal = "Cursando"
			strCorFinal = "#FF9900"
		else
			strResultadoAprovacaoFinal = "Aprovado"
			strCorFinal = "#0000FF"
		end if
	end if
	if strDesvincularCriterioAvaliacao = "S" then
		strResultadoAprovacaoFinal = "Aprovado"
		strCorFinal = "#0000FF"
	end if	
	if buscaHistorico <> "S" then
		if ucase(strSituacaoaluno) <> "ATIVO" and ucase(strSituacaoaluno) <> "PRÉ-MATRÍCULA" then
			strCorFinal = "#FF0000"
			strResultadoAprovacaoFinal = ucase(strSituacaoaluno)
		end if	
	end if	
	%>
	<div align="center"><strong>Resultado Final:</strong>&nbsp;<font color="<%=strCorFinal%>"><strong><%=strResultadoAprovacaoFinal%></strong></font></div>
	<%
end if
%>