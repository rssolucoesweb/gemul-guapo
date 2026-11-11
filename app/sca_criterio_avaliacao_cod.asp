<%@LANGUAGE="VBSCRIPT" CODEPAGE="65001"%> 
<%  
response.Charset = "utf-8" 
response.ContentType = "text/html" 
%>
<!--#include file="includes/inc_verificaSessionApp.asp"-->
<!--#include file="includes/inc_cnn.asp"-->
<!--#include file="includes/inc_log.asp"-->
<!--#include file="includes/inc_formataData.asp"-->

<%
	'on error resume next
	'----------Inicia uma tranzação--------------
	strAcao 			= request.QueryString("acao")
	intCodigo	 		= Trim(Request.Form("txtCodigo"))
	strAnoLetivo 		= Trim(Request.Form("txtAnoLetivo"))
	intCodCurso 		= Trim(Request.Form("cmbCurso"))
	intCodTipoCalculoCriterio	= Trim(Request.Form("cmbTipoCalculoCriterio"))
	
	strMedia           	= replace(Trim(Request.Form("txtMedia")),",",".")
	intFrequencia      	= Trim(Request.Form("txtFrequencia"))
	intDuracao         	= Trim(Request.Form("txtDuracao"))
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

	intNumDisciplinaRec         = Trim(Request.Form("txtNumDisciplinaRec"))
	intNumDisciplinaProgParcial = Trim(Request.Form("txtNumDisciplinaPorgParcial"))

	'on error resume next
	cnn.begintrans

	if strAcao = "I"then
	  strMensagem = session("strMensagemInclusao")	
		'CÓDIGO DO INSERT
		sql="insert into SCA_CRITERIO_AVALIACAO (ano_letivo, "
		sql=sql & " cod_curso, cod_tipo_calculo,  media_aprovacao, media_aprovacao_final, "
		sql=sql & " qtd_aula, frequencia_minima_percentual, "
		sql=sql & " num_disciplina_recuperacao, num_disciplina_prog_parcial,tipoFormulaFinal,condicaoEF_notaInicial,condicaoEF_notaFinal) "
		sql=sql & " values(" & strAnoLetivo & "," & intCodCurso & "," & intCodTipoCalculoCriterio & ","

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
		
		
		
	elseif strAcao = "A"then
		
		strMensagem = session("strMensagemAlteracao")
		'CÓDIGO DO UPDATE
		
		sql="update SCA_CRITERIO_AVALIACAO set"	
		if strMedia <>"" then
			sql=sql & " media_aprovacao='" & strMedia & "',"
		else
			sql=sql & " media_aprovacao=NULL, "
		end if
		
		if strMedia <>"" then
			sql=sql & " media_aprovacao_final='" & strMedia & "',"
		else
			sql=sql & " media_aprovacao_final=NULL, "
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
			
		if intNumDisciplinaRec <>"" then
			sql=sql & " num_disciplina_recuperacao='" & intNumDisciplinaRec & "',"
		else
			sql=sql & " num_disciplina_recuperacao=NULL, "
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
			
		sql=sql & " where codigo=" & intCodigo
		cnn.execute sql
		GravarLog sql
		
	elseif strAcao = "E"then 
		strMensagem = session("strMensagemExclusao")
		sql="delete from SCA_CRITERIO_AVALIACAO"
		sql=sql & " where codigo=" & intCodigo
		cnn.execute sql
		GravarLog sql
	end if
	
	
	if err.number = 0 then
	'----------Finaliza tranzação iniciada--------------
		cnn.commitTrans
		%>
		<script>
			alert("<%=strMensagem%>");
			window.location='sca_criterio_avaliacao.asp';
		</script>
		<%
		response.end
	else
		cnn.rollbackTrans
		%>
		<script>
			alert("ATENÇÃO: \n\nNão foi possível executar esse procedimento, tente novamente.\nCaso persistir entre em contato com o administrador do sistema.");
			window.history.back();
		</script>
		<%
	end if
%>