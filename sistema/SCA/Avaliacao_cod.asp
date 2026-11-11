<!--#include file="../../includes/inc_cnn.asp"-->
<!--#include file="../../includes/inc_formataData.asp"-->
<!--#include file="../../includes/inc_log.asp"-->

<%
'function formataMedia(media)
'			media = replace(media,"1BIM","X")
'			media = replace(media,"2BIM","Y")
'			media = replace(media,"3BIM","Z")
'			media = replace(media,"4BIM","W")
'			media = replace(media,"MA","A")
'			media = replace(media,"MR","R")
'			formataMedia = media	
'end function

strAcao 			= request.QueryString("acao")
intCodCurso 		= Trim(Request.Form("cmbCurso"))
intCodTipoAvaliacao	= Trim(Request.Form("chkTipoAvaliacao"))
intQtd_bimestre    	= Trim(Request.Form("cmbQtd_bimestre"))
strMedia           	= replace(Trim(Request.Form("txtMedia")),",",".")
intFrequencia      	= Trim(Request.Form("txtFrequencia"))
intDuracao         	= Trim(Request.Form("txtDuracao"))
strCC			    = Trim(Request.Form("txtCC"))   
strFormula		    = Trim(Request.Form("txtFMedia"))   
intPeso1Bim 		= Trim(Request.Form("txtHiddenPeso1Bim"))
intPeso2Bim 		= Trim(Request.Form("txtHiddenPeso2Bim"))
intPeso3Bim 		= Trim(Request.Form("txtHiddenPeso3Bim"))
intPeso4Bim 		= Trim(Request.Form("txtHiddenPeso4Bim"))
intPesoEF 			= Trim(Request.Form("txtHiddenPeso5Bim"))
strTipoFormulaFinal		= request.Form("formulaFinal")
strCondicaoEF_notaInicial	= request.Form("condicaoEF_notaInicial")
strCondicaoEF_notaFinal		= request.Form("condicaoEF_notaFinal")
if strTipoFormulaFinal = "EF" then 
	strMediaAprovacaoFinal           	= replace(Trim(Request.Form("txtMediaAprovacaoFinalEF")),",",".")
	strFormulaEF		= Trim(Request.Form("txtFMediaEF"))   
end if
if strTipoFormulaFinal = "REC" then 
	strMediaAprovacaoFinal           	= replace(Trim(Request.Form("txtMediaAprovacaoFinalREC")),",",".")
	strFormulaEF		= Trim(Request.Form("txtFMediaREC"))   
end if

'strFormulaEspecial   	= Trim(Request.Form("txtFormulaEspecial"))
intNumDisciplinaRec         = Trim(Request.Form("txtNumDisciplinaRec"))
intNumDisciplinaProgParcial = Trim(Request.Form("txtNumDisciplinaPorgParcial"))

'on error resume next
cnn.begintrans

if strAcao = "I"then
  strMensagem = session("strMensagemInclusao")	
	'CÓDIGO DO INSERT
	sql="insert into SCA_CRITERIO_AVALIACAO ("
	sql=sql & " cod_curso, cod_empresa, media_aprovacao, media_aprovacao_final, "
	sql=sql & " qtd_aula, frequencia_minima_percentual, "
	sql=sql & " peso_1bim, peso_2bim, peso_3bim, peso_4bim, "
	sql=sql & " peso_ef, formula, formulaEF, num_disciplina_recuperacao, num_disciplina_prog_parcial,cc,tipoFormulaFinal,condicaoEF_notaInicial,condicaoEF_notaFinal) "
	sql=sql & " values(" & intCodCurso & "," & session("CodEmpresa") & ","

	if strMedia <>"" then
		sql=sql & "" & strMedia& ", "
	else
		sql=sql & "NULL, "
	end if

	if strMediaAprovacaoFinal <>"" then
		sql=sql & "" & strMediaAprovacaoFinal& ", "
	else
		sql=sql & "NULL, "
	end if
	if intDuracao <>"" then
		sql=sql & intDuracao & ", "
	else
		sql=sql & "NULL, "
	end if
	
	if intFrequencia <>"" then
		sql=sql & intFrequencia & ", "
	else
		sql=sql & "NULL, "
	end if	
	
	if intPeso1Bim <>"" then
		sql=sql & intPeso1Bim & ", "
	else
		sql=sql & "NULL, "
	end if	
	
	if intPeso2Bim <>"" then
		sql=sql & intPeso2Bim & ", "
	else
		sql=sql & "NULL, "
	end if	
	
	if intPeso3Bim <>"" then
		sql=sql & intPeso3Bim & ", "
	else
		sql=sql & "NULL, "
	end if	
	
	if intPeso4Bim <>"" then
		sql=sql & intPeso4Bim & ", "
	else
		sql=sql & "NULL, "
	end if	
	
	if intPesoEF <>"" then
		sql=sql & intPesoEF & ", "
	else
		sql=sql & "NULL, "
	end if	
	
	if strFormula <>"" then
		sql=sql & "'" & strFormula & "', "
	else
		sql=sql & "NULL, "
	end if
	
	if strFormulaEF <>"" then
		sql=sql & "'" & strFormulaEF & "', "
	else
		sql=sql & "NULL, "
	end if
	
	if intNumDisciplinaRec <>"" then
		sql=sql & intNumDisciplinaRec & ", "
	else
		sql=sql & "NULL, "
	end if
	
	if intNumDisciplinaProgParcial <>"" then
		sql=sql & intNumDisciplinaProgParcial & ", "
	else
		sql=sql & "NULL, "
	end if					

	if strCC <>"" then
		sql=sql & "'" & strCC & "', "
	else
		sql=sql & "NULL, "
	end if					

	if strTipoFormulaFinal <>"" then
		sql=sql & "'" & strTipoFormulaFinal & "', "
	else
		sql=sql & "NULL, "
	end if	
	
	if strCondicaoEF_notaInicial <>"" then
		sql=sql & "" & strCondicaoEF_notaInicial & ", "
	else
		sql=sql & "NULL, "
	end if		
	
	if strCondicaoEF_notaFinal <>"" then
		sql=sql & "" & strCondicaoEF_notaFinal & ")"
	else
		sql=sql & "NULL) "
	end if		
				
	cnn.execute sql
	GravarLog sql
	
	sql = "SELECT max(codigo) as codCriterio"
	sql = sql & " FROM SCA_CRITERIO_AVALIACAO"
	sql = sql & " where cod_empresa = " & Session("CodEmpresa")			
	sql = sql & " And Cod_curso = " & intCodCurso		

	rs.open sql, cnn, 3, 3
	indCodCriterio = rs("codCriterio")
	rs.close
	
	vetAvaliacao = split(intCodTipoAvaliacao,",")			 
	
	for i = 0 to ubound(vetAvaliacao)
		sql = " INSERT INTO SCA_AVALIACAO (cod_empresa,codCriterioAvaliacao,codTipoAvaliacao) VALUES ("
		sql = sql & "" & session("CodEmpresa") & ","
		sql = sql & "" & indCodCriterio  & ","
		sql = sql & "" & vetAvaliacao(i) & ")"
		cnn.execute sql
		GravarLog sql
	next
	
elseif strAcao = "A"then
  	
	strMensagem = session("strMensagemAlteracao")
	'CÓDIGO DO UPDATE
	
	sql="update SCA_CRITERIO_AVALIACAO set"	
	if strMedia <>"" then
		sql=sql & " media_aprovacao='" & strMedia & "',"
	else
		sql=sql & " media_aprovacao=NULL, "
	end if
	
	if strMediaAprovacaoFinal <>"" then
		sql=sql & " media_aprovacao_final='" & strMediaAprovacaoFinal & "',"
	else
		sql=sql & " media_aprovacao=NULL, "
	end if
	
	if intDuracao <>"" then
		sql=sql & " qtd_aula=" & intDuracao & ","
	else
		sql=sql & "qtd_aula=NULL, "
	end if
	if intFrequencia <>"" then
		sql=sql & " frequencia_minima_percentual=" & intFrequencia & ","
	else
		sql=sql & " frequencia_minima_percentual=NULL, "
	end if	

	if intPeso1Bim <>"" then
		sql=sql & " peso_1bim='" & intPeso1Bim & "',"
	else
		sql=sql & " peso_1bim=NULL, "
	end if
	
	if intPeso2Bim <>"" then
		sql=sql & " peso_2bim='" & intPeso2Bim & "',"
	else
		sql=sql & " peso_2bim=NULL, "
	end if
	
	if intPeso3Bim <>"" then
		sql=sql & " peso_3bim='" & intPeso3Bim & "',"
	else
		sql=sql & " peso_3bim=NULL, "
	end if
	
	if intPeso4Bim <>"" then
		sql=sql & " peso_4bim='" & intPeso4Bim & "',"
	else
		sql=sql & " peso_4bim=NULL, "
	end if
		
	if intPesoEF <>"" then
		sql=sql & " peso_EF='" & intPesoEF & "',"
	else
		sql=sql & " peso_EF=NULL, "
	end if
	if strFormula <>"" then
		sql=sql & " formula='" & strFormula & "',"
	else
		sql=sql & " formula=NULL, "
	end if			
	if strFormulaEF <>"" then
		sql=sql & " formulaEF='" & strFormulaEF & "',"
	else
		sql=sql & " formulaEF=NULL, "
	end if
		
	if intNumDisciplinaRec <>"" then
		sql=sql & " num_disciplina_recuperacao='" & intNumDisciplinaRec & "',"
	else
		sql=sql & " num_disciplina_recuperacao=NULL, "
	end if

	if strCC <>"" then
		sql=sql & "CC='" & strCC & "',"
	else
		sql=sql & "CC=NULL, "
	end if					
	if strTipoFormulaFinal <>"" then
		sql=sql & "TipoFormulaFinal='" & strTipoFormulaFinal & "',"
	else
		sql=sql & "TipoFormulaFinal=NULL, "
	end if			
	
	if strCondicaoEF_notaInicial <>"" then
		sql=sql & "condicaoEF_notaInicial = " & strCondicaoEF_notaInicial & ","
	else
		sql=sql & "condicaoEF_notaInicial = NULL, "
	end if		
	
	if strCondicaoEF_notaFinal <>"" then
		sql=sql & "condicaoEF_notaFinal = " & strCondicaoEF_notaFinal & ","
	else
		sql=sql & "condicaoEF_notaFinal = NULL, "
	end if		

	
	if intNumDisciplinaProgParcial <>"" then
		sql=sql & " num_disciplina_Prog_Parcial='" & intNumDisciplinaProgParcial & "'"
	else
		sql=sql & " num_disciplina_Prog_Parcial=NULL "
	end if	
		
	sql=sql & " where cod_curso=" & intCodCurso
	sql=sql & " and cod_empresa=" & session("codEmpresa") 

	cnn.execute sql
	GravarLog sql
	
	sql = "SELECT max(codigo) as codCriterio"
	sql = sql & " FROM SCA_CRITERIO_AVALIACAO"
	sql = sql & " where cod_empresa = " & Session("CodEmpresa")			
	sql = sql & " And Cod_curso = " & intCodCurso		
	rs.open sql, cnn, 3, 3
	indCodCriterio = rs("codCriterio")
	rs.close

	sql = " DELETE FROM SCA_AVALIACAO "
	sql = sql & " WHERE cod_empresa = " & session("CodEmpresa")
	sql = sql & " AND codCriterioAvaliacao = " & indCodCriterio
	cnn.execute sql
	GravarLog sql
	vetAvaliacao = split(intCodTipoAvaliacao,",")			 
	
	for i = 0 to ubound(vetAvaliacao)
		sql = " INSERT INTO SCA_AVALIACAO (cod_empresa,codCriterioAvaliacao,codTipoAvaliacao) VALUES ("
		sql = sql & "" & session("CodEmpresa") & ","
		sql = sql & "" & indCodCriterio  & ","
		sql = sql & "" & vetAvaliacao(i) & ")"
		cnn.execute sql
		GravarLog sql
	next	
	
elseif strAcao = "E"then 
 	strMensagem = session("strMensagemExclusao")
	sql="delete from SCA_CRITERIO_AVALIACAO"
	sql=sql & " WHERE cod_curso=" & intCodCurso
	sql=sql & " AND cod_empresa=" & session("codEmpresa") 
'	sql=sql & " AND ano_letivo=" & session("strAnoLetivo")
'	sql=sql & " AND semestre=" & intCodSemestre
	cnn.execute sql
GravarLog sql
end if

'VERIFICAÇÃO DE ERRO
if err.number = 0 then
	cnn.committrans
	%>
	<script>
		alert("<%=strMensagem%>");
		window.location='Avaliacao_cad.asp?cmbCurso=<%=intCodCurso%>';
	</script>
	<%
	response.end
else
	cnn.rollbacktrans 
	response.redirect "../../erro.asp?strNumErro=" & err.number & "&strDescErro=" & err.description & "&strPaginaErro='modulos/academico/ave_avali_cad.asp'"
end if
%>