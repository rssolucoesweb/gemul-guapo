<%@LANGUAGE="VBSCRIPT" CODEPAGE="65001"%> 
<%  
response.Charset = "utf-8" 
response.ContentType = "text/html" 
%>
<!--#include file="includes/inc_verificaSessionApp.asp"-->
<!--#include file="includes/inc_cnn.asp"-->
<!--#include file="includes/inc_log.asp"-->
<!--#include file="includes/inc_formatadata.asp"-->
<%

	'on error resume next
	'----------Inicia uma tranzação--------------
	'cnn.begintrans
	dim C(15)
	
	
	acao 				= Trim(Request.QueryString("acao"))
	intCodEmp			= Session("CodEmpresa")
	strSemestre 		= Trim(Request("cmbSemestre"))
	if trim(request("txtAnoLetivo")) = "" then 
		strAnoLetivo = session("strAnoLetivo")
	else
		strAnoLetivo = request("txtAnoLetivo")
	end if
	intCodCursoTurma	= Trim(Request.Form("cmbCurso"))
	if intCodCursoTurma 	= "" then intCodCursoTurma 		= "0"
	strSituacaoAluno	= Trim(Request.Form("cmbSituacaoAluno"))
	intCodAluno			= Trim(Request.Form("chkAluno"))

	intCodTurma 			= Trim(Request("cmbTurma"))
	intCodTipoCalculo 			= Trim(Request("cmbTipoCalculo"))
	intCodCurso 			= Trim(Request("cmbCurso"))
	
	cnn.begintrans
	
	if acao = "I" then
	
		vetAluno = split(intCodAluno,",")
		for i=0 to ubound(vetAluno)
			
			intCodAluno	= vetAluno(i)
			
			sql = "delete from SCA_NOTAS_FALTAS where cod_aluno=" & intCodAluno
			sql = sql & " and ano_letivo=" & strAnoLetivo 
			cnn.execute sql
			
			sql = "delete SCA_TIPO_AVALIACAO_INDIVIDUAL_ALUNO "
			sql = sql & " where ano_letivo = " & strAnoLetivo
			sql = sql & " and cod_empresa = " & intCodEmp 
			sql = sql & " and cod_aluno = " & intCodAluno 
			cnn.execute sql
			GravarLog sql		
			
			'INSERINDO HISTORICO DE SITUACAO DA TURMA POR ANO/SEMESTRE
			sql = "insert into SCA_TIPO_AVALIACAO_INDIVIDUAL_ALUNO (ano_letivo, cod_empresa, cod_aluno, cod_tipo_calculo, cod_curso, USUARIO_INCL, DATA_HORA_INCL) VALUES ("
			sql = sql & "" & strAnoLetivo & "," 
			sql = sql & "" & intCodEmp & ","
			sql = sql & "" & intCodAluno & "," 
			sql = sql & "" & intCodTipoCalculo & "," 
			sql = sql & "" & intCodCurso & "," 
			sql = sql & "'" & trim(session("usuarioWeb")) & "'," 
			sql = sql & "'"& formataDataBD(date)& " " &time& "')" 
			'response.write sql
			cnn.execute sql
			GravarLog sql
			
			'Gera Ocorrencia Automatica do tipo Protesto
			'parametros:
			'	intCodEmp
			'	intCodDepartamento
			'	intCodAluno
			'	intCodTaxa
			'	intCodBebitoAluno
			'	strDataOcorrencia
			'	strDataValidade
			'	strOcorrencia
			'	strUsuarioIncl
		
			intCodEmp			= intCodEmp
			intCodDepartamento	= Session("CodDeptoUsuario")
			intCodTaxa			= ""
			intCodBebitoAluno	= ""
			strDataOcorrencia	= formatadataBD(date)
			strUsuarioIncl		= trim(session("usuarioWeb"))
			strDataValidade		= ""
			strOcorrencia		= "Inclusão do aluno no critério individual - id: " & intCodTipoCriterioNovo & " - " & strCriterio
			%>
			<!--#include file="includes/inc_lancamentoDeOcorrencia.asp"-->	
			<%	
		next
		
		strMensagem = "Critério individual incluido com sucesso..."
	elseif acao="E" then
		strMensagem = "Critério individual excluido com sucesso!"
		
		sql = "delete from SCA_NOTAS_FALTAS where cod_aluno in (" & intCodAluno  & ")"
		sql = sql & " and ano_letivo=" & strAnoLetivo 
		cnn.execute sql
			
		sql = "delete SCA_TIPO_AVALIACAO_INDIVIDUAL_ALUNO "
		sql = sql & " where ano_letivo = " & strAnoLetivo
		sql = sql & " and cod_empresa = " & intCodEmp 
		sql = sql & " and cod_curso = " & intCodCurso 
		sql = sql & " and cod_aluno in (" & intCodAluno  & ")"
		cnn.execute sql
		GravarLog sql
		
		vetAluno = split(intCodAluno,",")
		for i=0 to ubound(vetAluno)
			intCodAluno	= vetAluno(i)
			
			'Gera Ocorrencia Automatica do tipo Protesto
			'parametros:
			'	intCodEmp
			'	intCodDepartamento
			'	intCodAluno
			'	intCodTaxa
			'	intCodBebitoAluno
			'	strDataOcorrencia
			'	strDataValidade
			'	strOcorrencia
			'	strUsuarioIncl
		
			intCodEmp			= intCodEmp
			intCodDepartamento	= Session("CodDeptoUsuario")
			intCodTaxa			= ""
			intCodBebitoAluno	= ""
			strDataOcorrencia	= formatadataBD(date)
			strUsuarioIncl		= trim(session("usuarioWeb"))
			strDataValidade		= ""
			strOcorrencia		= "Excluido o critério individual"
			%>
			<!--#include file="includes/inc_lancamentoDeOcorrencia.asp"-->	
			<%	
		next
	end if
	
	if err.number = 0 then
	'----------Finaliza tranzação iniciada--------------
		'cnn.rollbackTrans
		cnn.commitTrans
	
		%>
		<script>
			alert("<%=strMensagem%>");
			window.location='sca_criterio_individual.asp?cmbTurma=<%=intCodTurma%>&cmbTipoCriterio=<%=intCodTipoCriterioNovo%>';
		</script>
		<%
		response.end
	else
		cnn.rollbackTrans
		%>
		<script>
			alert("ATENÇÃO: \n\nNão foi possível executar esse procedimento, tente novamente.\nCaso persistir entre em contato com o administrador do sistema.");
			alert('<%=replace(err.description,"'","")%>');
			window.history.back();
		</script>
		<%
	end if
%>