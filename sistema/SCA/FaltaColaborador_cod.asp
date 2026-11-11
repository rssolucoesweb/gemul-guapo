<!--
	::	DESENVOLVIDO POR "RS SOLUÇÕES WEB - www.rssolucoesweb.com.br"
	::	Data de Criação...: 14/08/2007
	::	Desenvolvedores...: Roberto Barbosa Silva - robertobs7@gmail.com
	::	Objetivo Pagina...: Cadastro de Turma
-->
<!--#include file="../../includes/inc_verificaSession.asp"-->
<!--#include file="../../includes/inc_cnn.asp"-->
<!--#include file="../../includes/inc_log.asp"-->
<!--#include file="../../includes/inc_formatadata.asp"-->
<%
	'on error resume next
	'----------Inicia uma tranzação--------------
	cnn.begintrans
	acao 						= Trim(Request.QueryString("acao"))
	intCodEmp					= Session("CodEmpresa")
	intCodJustificativaFaltas	= Trim(Request.form("cmbJustificativaFaltas"))
	intCodModulacaoReferencia 	= Trim(Request.form("cmbModulacaoReferencia"))
	intCodigo           	  	= Trim(Request.Form("txtCodigo"))	
	intAnoLetivo 			  	= session("strAnoLetivo")
	intSemestre               	= session("strSemestre")
	strDataLancamento        	= formatadataBD(Trim(Request("txtDataLancamento")))
	strDataLancamentoFinal    	= formatadataBD(Trim(Request("txtDataLancamentoFinal")))
	strOptTipoColaborador     	= Trim(Request("optTipoColaborador"))
	
	if Trim(Request("optTipoColaborador")) = "1" then
	   intTipoColaborador         = "P"
	   intCodProfessor	          = Trim(Request("cmbProfessorTurma")) 
	   intCodTurma		          = Trim(Request("cmbTurmaProfessor"))
	   intCodDisciplina	          = Trim(Request("cmbDisciplinaProfessorTurma"))
	else
	   intCodProfessor            = Trim(Request("cmbColaboradorAtivos")) 
	   intTipoColaborador         = "F"
	end if   
	

	strTipoLancamento         = Trim(Request("txtLancamentoDisciplinar"))
	intQtdeFalta              = Trim(Request("txtQtdeFalta"))
	strJustificativa          = Trim(Request("txtJustificativa"))
	intCodProfessorSubstituto = Trim(Request("cmbProfessorSubstituto"))
	intQtdeAula               = Trim(Request("cmbQtdeAula"))
	strConteudoSubstituicao   = Trim(Request("txtConteudoSubstituicao"))
	strSimouNao               = Trim(Request("cmbSimouNao"))
    strJustificativaAbono     = Trim(Request("txtJustificativaAbono"))
    strFechamento             = Trim(Request("cmbFechamento"))
	strDataI			      = formatadataAP(request.Form("txtDataI"))
	strDataF				  = formatadataAP(request.Form("txtDataF"))
	strDataFaltasPeriodo	  = request.Form("txtDataFaltasPeriodo")
	intCod_rubrica			  = ""
	vetDataFaltasPeriodo		= split(strDataFaltasPeriodo,",")

    if intCodTurma = "" then intCodTurma = "0"
    if intCodDisciplina = "" then intCodDisciplina = "0"
	
	if strSimouNao = "" then
	   strSimouNao = "N"
	end if 
	  
	if acao="I" then
		
		strFechamento = "N"
		strMensagem = "Registro Salvo com sucesso..."
		
		if strTipoLancamento = "D" then
	
			for i=0 to ubound(vetDataFaltasPeriodo)
				
				strDataDiaLancamento = vetDataFaltasPeriodo(i)
				strAno = year(strDataDiaLancamento)
				
				'-----------------------------------------------------------------------------------------
				' Faltas do Colaborador
				'-----------------------------------------------------------------------------------------
				if strOptTipoColaborador = 0 then 
					intQtdeFalta = 1 
				end if
				
				'-----------------------------------------------------------------------------------------
				' Consulta Faltas do Professor no Horario de Aula
				'-----------------------------------------------------------------------------------------
				if strOptTipoColaborador = 1 then 
				
					sql = " select COUNT(SCA_HORARIO_AULA.codigo) as Total from SCA_HORARIO_AULA "
					sql = sql & " inner join SCA_HORARIO on SCA_HORARIO.codigo=SCA_HORARIO_AULA.Cod_Horario "
					sql = sql & " where SCA_HORARIO_AULA.cod_empresa =  " & session("CodEmpresa")
					sql = sql & " and SCA_HORARIO_AULA.anoletivo = " & strAno
					sql = sql & " and SCA_HORARIO_AULA.Semestre = " & intSemestre
					sql = sql & " and DiaSemana = " & weekDay(strDataDiaLancamento)
					
					if trim(intCodProfessor) <> "0" then
						sql = sql & " and SCA_HORARIO_AULA.Cod_Colaborador = " & intCodProfessor 
					end if
				
					if trim(intCodTurma) <> "0" then
						sql = sql & " and SCA_HORARIO_AULA.cod_turma = " & intCodTurma
					end if
				
					if trim(intCodDisciplina) <> "0" then
						sql = sql & " and SCA_HORARIO_AULA.Cod_Disciplina = " & intCodDisciplina
					end if
				
					RS1.OPEN SQL, CNN
					IF RS1.EOF = FALSE THEN
						  intQtdeFalta = trim(rs1("Total"))
					end if
					rs1.close
				
				end if
				
				sql = "Insert Into SRH_COLABORADOR_FREQUENCIA(cod_empresa, Cod_JustificativaFaltas, CodReferencia, ano_letivo, semestre_letivo, Datalancamento, DataLancamentoFinal, DataDiaLancamento, "
				sql = sql & " tipo_colaborador, cod_turma, cod_colaborador, cod_disciplina, numero_falta, "
				sql = sql & " justificativa, cod_colaboradorsubstituto, numero_aula, Conteudo_substituicao ,"
				sql = sql & " cod_rubrica, situacao, justificativa_abono, fechamento )"
				sql = sql & " Values ("
				sql = sql & "" & intCodEmp & ","
				sql = sql & "" & intCodJustificativaFaltas & ","
				sql = sql & "" & intCodModulacaoReferencia & ","
				
				if intAnoLetivo <> "" then
					sql = sql & "" & intAnoLetivo & ","
				else 
					sql = sql &" null ,"
				end if
				
				if intSemestre <> "" then
					sql = sql & "" & intSemestre & ","
				else 
					sql = sql &" null ,"
				end if
				
				if strDataLancamento <> "" then
					sql = sql & "'" & strDataLancamento & "',"
				else 
					sql = sql &" null ,"
				end if
				
				if strDataLancamentoFinal <> "" then
					sql = sql & "'" & strDataLancamentoFinal & "',"
				else 
					sql = sql &" null ,"
				end if
				
				if strDataDiaLancamento <> "" then
					sql = sql & "'" & formatadataBD(strDataDiaLancamento) & "',"
				else 
					sql = sql &" null ,"
				end if
			
				if intTipoColaborador <> "" then
					sql = sql & "'" & intTipoColaborador & "',"
				else 
					sql = sql &" null ,"
				end if
				
				if intCodTurma <> "" then
					sql = sql & "" & intCodTurma & ","
				else 	
					sql = sql &" null ,"
				end if
				
				if intCodProfessor <> "" then
					sql = sql & "" & intCodProfessor & ","
				else 
					sql = sql &" null ,"
				end if
				
				if intCodDisciplina <> "" then
					sql = sql & "" & intCodDisciplina & ","
				else 
					sql = sql &" null ,"
				end if
				
				if intQtdeFalta <> "" then
					sql = sql & "" & intQtdeFalta & ","
				else 
					sql = sql &" 0,"
				end if
				
				if strJustificativa <> "" then
					sql = sql & "'" & strJustificativa & "',"
				else 
					sql = sql &" null ,"
				end if
				
				if intCodProfessorSubstituto <> "" then
					sql = sql & "" & intCodProfessorSubstituto & ","
				else 
					sql = sql &" null ,"
				end if
				
				if intQtdeAula <> "" then
					sql = sql & "" & intQtdeAula & ","
				else 
					sql = sql &" null ,"
				end if
				
				if strConteudoSubstituicao <> "" then
					sql = sql & "'" & strConteudoSubstituicao & "',"
				else 
					sql = sql &" null ,"
				end if
				
				if intCod_rubrica <> "" then
					sql = sql & "" & intCod_rubrica & ","
				else 
					sql = sql &" null ,"
				end if
		
				if strSimouNao <> "" then
					sql = sql & "'" & strSimouNao & "',"
				else 
					sql = sql &" null ,"
				end if
				
				if strJustificativaAbono <> "" then
					sql = sql & "'" & strJustificativaAbono & "',"
				else 
					sql = sql &" null ,"
				end if
				
				if strFechamento <> "" then
					sql = sql & "'" & strFechamento & "')"
				else 
					sql = sql &" null )"
				end if
			
				cnn.execute sql
				GravarLog sql
			
			next
		else
			sql = "Insert Into SRH_COLABORADOR_FREQUENCIA(cod_empresa, Cod_TipoFalta, CodReferencia, ano_letivo, semestre_letivo, Datalancamento, DataLancamentoFinal, DataDiaLancamento, "
			sql = sql & " tipo_colaborador, cod_turma, cod_colaborador, cod_disciplina, numero_falta, "
			sql = sql & " justificativa, cod_colaboradorsubstituto, numero_aula, Conteudo_substituicao ,"
			sql = sql & " cod_rubrica, situacao, justificativa_abono, fechamento )"
			sql = sql & " Values ("
			sql = sql & "" & intCodEmp & ","
			sql = sql & "" & intCodJustificativaFaltas & ","
			sql = sql & "" & intCodModulacaoReferencia & ","
			
			if intAnoLetivo <> "" then
				sql = sql & "" & intAnoLetivo & ","
			else 
				sql = sql &" null ,"
			end if
			
			if intSemestre <> "" then
				sql = sql & "" & intSemestre & ","
			else 
				sql = sql &" null ,"
			end if
			
			if strDataLancamento <> "" then
				sql = sql & "'" & strDataLancamento & "',"
			else 
				sql = sql &" null ,"
			end if
			
			if strDataLancamentoFinal <> "" then
				sql = sql & "'" & strDataLancamentoFinal & "',"
			else 
				sql = sql &" null ,"
			end if
			
			if strDataLancamento <> "" then
				sql = sql & "'" & strDataLancamento & "',"
			else 
				sql = sql &" null ,"
			end if
		
			if intTipoColaborador <> "" then
				sql = sql & "'" & intTipoColaborador & "',"
			else 
				sql = sql &" null ,"
			end if
			
			if intCodTurma <> "" then
				sql = sql & "" & intCodTurma & ","
			else 	
				sql = sql &" null ,"
			end if
			
			if intCodProfessor <> "" then
				sql = sql & "" & intCodProfessor & ","
			else 
				sql = sql &" null ,"
			end if
			
			if intCodDisciplina <> "" then
				sql = sql & "" & intCodDisciplina & ","
			else 
				sql = sql &" null ,"
			end if
			
			if intQtdeFalta <> "" then
				sql = sql & "" & intQtdeFalta & ","
			else 
				sql = sql &" 0,"
			end if
			
			if strJustificativa <> "" then
				sql = sql & "'" & strJustificativa & "',"
			else 
				sql = sql &" null ,"
			end if
			
			if intCodProfessorSubstituto <> "" then
				sql = sql & "" & intCodProfessorSubstituto & ","
			else 
				sql = sql &" null ,"
			end if
			
			if intQtdeAula <> "" then
				sql = sql & "" & intQtdeAula & ","
			else 
				sql = sql &" null ,"
			end if
			
			if strConteudoSubstituicao <> "" then
				sql = sql & "'" & strConteudoSubstituicao & "',"
			else 
				sql = sql &" null ,"
			end if
			
			if intCod_rubrica <> "" then
				sql = sql & "" & intCod_rubrica & ","
			else 
				sql = sql &" null ,"
			end if
	
			if strSimouNao <> "" then
				sql = sql & "'" & strSimouNao & "',"
			else 
				sql = sql &" null ,"
			end if
			
			if strJustificativaAbono <> "" then
				sql = sql & "'" & strJustificativaAbono & "',"
			else 
				sql = sql &" null ,"
			end if
			
			if strFechamento <> "" then
				sql = sql & "'" & strFechamento & "')"
			else 
				sql = sql &" null )"
			end if
		
			cnn.execute sql
			GravarLog sql
		end if
		
			
	elseif acao="A" then
		
		strMensagem = "Registro Alterado com sucesso..."
		
		sql = "Update SRH_COLABORADOR_FREQUENCIA Set"
		sql = sql & " Cod_TipoFalta = " & intCodJustificativaFaltas & ","
		sql = sql & " ano_letivo = " & intAnoLetivo & ","
		sql = sql & " semestre_letivo = " & intSemestre & ","
		sql = sql & " Datalancamento = '" & strDataLancamento & "',"
		sql = sql & " DataLancamentoFinal = '" & strDataLancamentoFinal & "',"
		
		if intCodTurma <> "" then
		   sql = sql & " cod_turma = " & intCodTurma & ","
		else   
		   sql = sql & " cod_turma = null,"
		end if   

		if intCodProfessor <> "" then
		   sql = sql & " cod_colaborador = " & intCodProfessor & ","
		else
		   sql = sql & " cod_colaborador = null,"
		end if   

		if intCodDisciplina <> "" then
		   sql = sql & " cod_disciplina = " & intCodDisciplina & ","
		else   
		   sql = sql & " cod_disciplina = null,"
		end if   

		if strJustificativa <> "" then
		    sql = sql & " justificativa = '" & strJustificativa & "',"
		else
		    sql = sql & " justificativa = null,"
		end if	

		if intQtdeFalta <> "" then
		   sql = sql & " numero_falta = " & intQtdeFalta & ","
		end if   

	    if intCodProfessorSubstituto <> "" then	   
		   sql = sql & " cod_colaboradorsubstituto = " & intCodProfessorSubstituto & ","
		else   
		   sql = sql & " cod_colaboradorsubstituto = null,"
		end if   

		if intQtdeAula <> "" then	   
		   sql = sql & " numero_aula = " & intQtdeAula & ","
		end if 

		if strConteudoSubstituicao <> "" then	   
		   sql = sql & " Conteudo_substituicao = '" & strConteudoSubstituicao & "',"
		else
		   sql = sql & " Conteudo_substituicao = null,"
		end if  

		if strSimouNao <> "" then	   
		   sql = sql & " situacao = '" & strSimouNao & "',"
		else
		   sql = sql & " situacao = null,"
		end if  

    	if strJustificativaAbono <> "" then	   
		   sql = sql & " justificativa_abono = '" & strJustificativaAbono & "',"
		else
		   sql = sql & " justificativa_abono = null,"
		end if   

     	if strFechamento <> "" then	   
		   sql = sql & " fechamento = '" & strFechamento & "'"
		else
		   sql = sql & " fechamento = null"
		end if   

 		sql = sql & " where codigo = " & intCodigo
		cnn.execute sql
        GravarLog sql

	else
		
		strMensagem = "Registro Excluido com sucesso..."
		
		sql = "Delete from SRH_COLABORADOR_FREQUENCIA "
		sql = sql & " where codigo = " & intCodigo
	    cnn.execute sql
        GravarLog sql
	
	end if
	
	if strFechamento = "S" then
	   sql = "UPDATE SRH_COLABORADOR_FREQUENCIA SET FECHAMENTO = 'S' "
	   sql = sql & " WHERE COD_EMPRESA = "  & session("CodEmpresa")
       sql = sql & " AND (FECHAMENTO = 'N' or ISNULL(FECHAMENTO,'0') = '0') "
	   sql = sql & " and convert(datetime,convert(varchar, DATALANCAMENTO, 103),103) >=  convert(datetime, ' " & strDataI & "',103)"
       sql = sql & " and convert(datetime,convert(varchar, DATALANCAMENTO, 103),103) <=  convert(datetime, ' " & strDataF & "',103)"
	   cnn.execute sql
       GravarLog sql
	end if   

	if err.number = 0 then
		'----------Finaliza tranzação iniciada--------------
		cnn.commitTrans
		%>
		<script>
			alert("<%=strMensagem%>");
			window.location='FaltaColaborador_cad.asp';
		</script>
		<%
		response.end
	else
		response.redirect "erro.asp?strNumErro=" & err.number & "&strDescErro=" & err.description 
		cnn.rollbacktrans
	end if
%>