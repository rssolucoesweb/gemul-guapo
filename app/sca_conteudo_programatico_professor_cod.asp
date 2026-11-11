<%@LANGUAGE="VBSCRIPT" CODEPAGE="65001"%> 
<%  
response.Charset = "utf-8" 
response.ContentType = "text/html" 
%>
<!--
	::	DESENVOLVIDO POR "RS SOLUÇÕES WEB - www.rssolucoesweb.com.br"
	::	Data de Criação...: 05/01/2021
	::	Desenvolvedores...: Sergio Borges - Sergiob76@gmail.com
	::	Objetivo Pagina...: Cadastro de conteudo programatico 
-->
<!--#include file="includes/inc_verificaSessionApp.asp"-->
<!--#include file="includes/inc_cnndocumento.asp"-->
<!--#include file="includes/inc_log.asp"-->
<!--#include file="includes/inc_formatadata.asp"-->
<%
	'on error resume next
	'----------Inicia uma tranzação--------------
	cnn.begintrans
	acao 				= Trim(Request.QueryString("acao"))
	intCodEmp			= Session("CodEmpresa")
	
	if Trim(Request.Form("txtAnoLetivo")) <> "" then
	   strAnoLetivo 			= Trim(Request.Form("txtAnoLetivo"))
	else
	   strAnoLetivo = session("strAnoLetivo")   
	end if   

	if Trim(Request.Form("cmbSemestre")) <> "" then
		intSemestre 				= Trim(Request.Form("cmbSemestre"))
	else
		intSemestre 				= session("strSemestre")
    end if	
	
    intCodColaboradorProfessor  = Trim(Request("cmbProfessor"))
	intCodProfessor 	        = Trim(Request("cmbProfessor"))
	intCodTurmaProfessor 	    = Trim(Request("cmbTurmaProfessor"))
    intCodDisciplina		    = Trim(Request("cmbDisciplinaDoProfessor"))
	strDataInicial         		= formatadataBD(Trim(Request("txtDataInicial")))
	strDataFinal         		= formatadataBD(Trim(Request("txtDataFinal")))
    strTotalAulasDia     		= Trim(Request("txtTotalAulasDia"))
    strMes		 	        	= Trim(Request("cmbMes"))
	strDescricao 				= replace(Trim(Request.Form("txtDescricao")),"'"," ")
	intCodigo	 				= Trim(Request.Form("txtCodigo"))
	strData              		= formatadataAP(Trim(Request("txtDataInicial")))
	intCodTurno					= Trim(Request("cmbTurnoDoProfessor"))

	codConteudos					= Trim(Request("chkInserir"))


	if len(strDescricao) > 500 then
	
		%>
		<script>
			alert("ATENÇÃO: \nA quantidade de caracteres digitado para o conteúdo foi ultrapassada, vamos salva-lo com o limite máximo permitido que é de 500 caracteres!");
		</script>
		<%
		strDescricao = left(strDescricao,500)
			
	end if

	if strDataFinal = "" then strDataFinal = strDataInicial
	
	if strMes = "" then strMes="0"
    if strMes <> "0" then
	   acao="C"
	end if   

	strCpfTurmaProfessor = ""
    sql = " Select ISNULL(CPF,'') AS CPF"
	sql = sql & " from SRH_COLABORADOR "
	sql = sql & " where codigo = " & intCodProfessor
	sql = sql & " and Situacao = 'A'" 'Ativo
	rs1.open sql, cnn
	if rs1.eof = false then
		strCpfTurmaProfessor = TRIM(rs1("CPF"))
	end if
	rs1.close
	
	intMesConteudoProgramatico = "1"
	sql = " SELECT top 1 Bloqueia_ConteudoProgramatico, Habilitar_PlanoEnsino "
	sql = sql & " FROM SEG_ENCERRAMENTOATIVIDADES "
	sql = sql & " Where cod_empresa = " & Session("CodEmpresa")
	rs.Open SQL, cnn
	if rs.EOF = false then								
		strHabilitaPlanoEnsino = rs("Habilitar_PlanoEnsino")
		strBloqueiaConteudoProgramatico = rs("Bloqueia_ConteudoProgramatico")
		if isnull(strHabilitaPlanoEnsino) then strHabilitaPlanoEnsino = "N"
		if isnull(intMesConteudoProgramatico) then intMesConteudoProgramatico = "0"
	end if
	rs.close

	if trim(strBloqueiaConteudoProgramatico) <> "0" then

		if trim(strAnoLetivo) & trim(intMesConteudoProgramatico) >=  trim(strAnoLetivo)& trim(month(strDataInicial)) then
			cnn.rollbackTrans
			%>
			<script>
				alert("ATENÇÃO: \n\nMês Bloqueado para Lançamento, procure a Secretaria Geral.");
				window.location='sca_conteudo_programatico_professor.asp';
			</script>
			<%	
			response.End()
		end if
			
	end if
	
	if acao="I" then
	
        ExisteLancamento = False
		sql = " SELECT CODIGO FROM SCA_CONTEUDO "
		sql = sql & " WHERE COD_EMPRESA = " & Session("CodEmpresa")
		sql = sql & " AND ANOLETIVO = " & strAnoLetivo
		sql = sql & " AND SEMESTRE = " & intSemestre
		sql = sql & " AND COD_TURMA = " & intCodTurmaProfessor
		if SESSION("CODGRUPO")="7" THEN
			sql = sql & " AND COD_TURNO = " & intCodTurno
		end if
		sql = sql & " AND COD_DISCIPLINA = " & intCodDisciplina
		sql = sql & " AND convert(datetime,convert(varchar, DATAINICIAL, 103),103) =  convert(datetime, ' " & strData & "',103)"
		rs.open sql, cnn
		if rs.EOF = false then								
 			ExisteLancamento = true		
		end if
		rs.close
		
		if ExisteLancamento then
			cnn.rollbackTrans
			%>
			<script>
				alert("Conteúdo já lançado para essa turma e disciplina. Verifique!");
				window.location='sca_conteudo_programatico_professor.asp?cmbTurmaProfessor=<%=intCodTurmaProfessor%>&cmbDisciplinaDoProfessor=<%=intCodDisciplina%>&cmbProfessor=<%=intCodProfessor%>&cmbTurnoDoProfessor=<%=intCodTurno%>';
			</script>
			<%	
			response.End()
		end if	
		
		strMensagem = "Registro Salvo com sucesso..."
		
		
		sql = "Insert Into SCA_conteudo(Cod_Empresa,AnoLetivo,Semestre,Cod_Disciplina,Cod_Colaborador,Cod_turma,DataInicial,DataFinal,Conteudo,Total_Aulas,Fechamento,cod_turno)"
		sql = sql & " Values ("
		sql = sql & "" & intCodEmp & ","
		sql = sql & "" & strAnoLetivo & ","
		sql = sql & "" & intSemestre & ","

		sql = sql & "" & intCodDisciplina & ","
		sql = sql & "" & intCodColaboradorProfessor & ","
		sql = sql & "" & intCodTurmaProfessor & ","
		sql = sql & "'" & strDataInicial & "',"
		sql = sql & "'" & strDataFinal & "',"
		sql = sql & "'" & strDescricao & "',"
		if 	strTotalAulasDia = "" then
			sql = sql & " null,"
		else
			sql = sql & "" & strTotalAulasDia & ","
		end if
		sql = sql & "'N'," & intCodTurno & ")"


	elseif acao="A" then
		
		strMensagem = "Registro Alterado com sucesso..."
		
		sql = "Update SCA_conteudo Set"
		sql = sql & " conteudo = '" & strDescricao & "',"
		if intCodColaboradorProfessor = "" then
			sql = sql & "data_ultima_interacao = getdate(), Cod_Colaborador_ultima_interacao = null,"
		else
			sql = sql & "data_ultima_interacao = getdate(), Cod_Colaborador_ultima_interacao = " & intCodColaboradorProfessor & ","
		end if
		if strTotalAulasDia = "" then
			sql = sql & "Total_Aulas = null,"
		else
			sql = sql & "Total_Aulas = " & strTotalAulasDia & ","
		end if
		sql = sql & " DataInicial = '" & strDataInicial & "'"
		sql = sql & " where codigo = " & intCodigo
		
	elseif acao="ENVIAR" then
		
		strMensagem = "Registro ENVIADO com sucesso..."
		
		sql = "UPDATE SCA_CONTEUDO SET FECHAMENTO = 'S'"
		if intCodColaboradorProfessor = "" or intCodColaboradorProfessor = "0" then
			sql = sql & " , data_envio = getdate(), Cod_Colaborador_ultimo_envio = null"
		else
			sql = sql & " , data_envio = getdate(), Cod_Colaborador_ultimo_envio = " & intCodColaboradorProfessor
		end if
		sql = sql & " WHERE codigo in (" & codConteudos & ")"

		
	elseif acao="E" then
	
		strMensagem = "Registro Excluido com sucesso..."
		sql = "Delete from SCA_conteudo "
		sql = sql & " WHERE codigo in (" & codConteudos & ")"
		
	end if
	cnn.execute sql
	GravarLog sql
	
	if err.number = 0 then
	'----------Finaliza tranzação iniciada--------------
		cnn.commitTrans
		%>
		<script>
			alert("<%=strMensagem%>");
			window.location='sca_conteudo_programatico_professor.asp?cmbTurmaProfessor=<%=intCodTurmaProfessor%>&cmbDisciplinaDoProfessor=<%=intCodDisciplina%>&cmbProfessor=<%=intCodProfessor%>&cmbTurnoDoProfessor=<%=intCodTurno%>';
        </script>
		<%
		response.end
	else
		cnn.rollbackTrans
		%>
		<script>
			alert("ATENÇÃO: \n\nNão foi possível executar esse procedimento, tente novamente.\nCaso persistir entre em contato com o administrador do sistema.");
			window.location='sca_conteudo_programatico_professor.asp';
		</script>
		<%
	end if
%>