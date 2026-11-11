<!--
	::	DESENVOLVIDO POR "RS SOLUÇÕES WEB - www.rssolucoesweb.com.br"
	::	Data de Criação...: 09/10/2008
	::	Desenvolvedores...: Roberto Barbosa Silva - robertobs7@gmail.com
	::	Objetivo Pagina...: Cadastro de Vestibular Dados
-->
<!--#include file="../../includes/inc_verificaSession.asp"-->
<!--#include file="../../includes/inc_formataData.asp"-->
<!--#include file="../../includes/inc_cnn.asp"-->
<!--#include file="../../includes/inc_log.asp"-->
<%
	'on error resume next
	'----------Inicia uma tranzação--------------
	cnn.begintrans

	acao 						= Trim(Request.QueryString("acao"))
	strAnoLetivo 				= Trim(Request.Form("txtAnoLetivo"))
	intSemestre 				= Trim(Request.Form("cmbSemestre"))
	intCodVestibularDisciplina	= Trim(Request("cmbVestibularDisciplina"))

	
	intCodEmp					= Session("CodEmpresa")
	intCodigo	 				= Trim(Request.Form("txtCodigo"))
	intTipoProcesso				= Trim(Request("cmbTipoProcesso"))
	strDescricao				= Trim(Request("txtDescricao"))
	strData						= FORMATADATABD(Trim(Request("txtData")))
	strDataVencimento			= FORMATADATABD(Trim(Request("txtDataVencimento")))
	strHorario					= Trim(Request("txtHorario"))
	strCampus					= Trim(Request("txtCampus"))
	strSituacao					= Trim(Request("optSituacao"))
	strValorVestibular          = Replace(Replace(Trim(Request("txtValorVestibular")),".",""),",",".")
	strSimouNao         		= Trim(Request.Form("cmbSimouNao"))
	intNumeroVaga				= Trim(Request.Form("txtNumeroVaga"))
			
	if acao="I" then
	
	    if strSimouNao = "S" then
			cnn.rollbackTrans
			%>
			<script>
				alert("ATENÇÃO: O Evento só poderá ser publicado após a análise do Financeiro.");
				window.history.back();
			</script>
			<%
			response.end
        end if
		
		strMensagem = "Registro Salvo com sucesso..."
		
		sql = "Insert Into SCA_VESTIBULAR(Cod_Empresa, TipoProcesso, Descricao, Data, Horario, Campus, "
		sql = sql & " ano_letivo, semestre, CodVestibularDisciplina, situacao, Valor_Vestibular,"
		sql = sql & " dataVencimento, PublicarWeb, NumeroVaga) "
		sql = sql & " Values ("
		sql = sql & "" & intCodEmp & ","
		sql = sql & "" & intTipoProcesso & ","
		sql = sql & "'" & strDescricao & "',"
		sql = sql & "'" & strData & "',"
		sql = sql & "'" & strHorario & "',"
		sql = sql & "'" & strCampus & "',"
		sql = sql & "" & strAnoLetivo & ","
		sql = sql & "" & intSemestre & ","
		sql = sql & "" & intCodVestibularDisciplina & ","
		sql = sql & "'" & strSituacao & "',"
		sql = sql & "" & strValorVestibular & ","
		sql = sql & "'" & strDataVencimento & "',"
		sql = sql & "'" & strSimouNao & "',"
		sql = sql & "" & intNumeroVaga & ")"
					
	elseif acao="A" then
		
		strMensagem = "Registro Alterado com sucesso..."
			
		sql = "Update SCA_VESTIBULAR Set"
		sql = sql & " TipoProcesso = " & intTipoProcesso & ","
		sql = sql & " Descricao = '" & strDescricao & "',"
		sql = sql & " Data = '" & strData & "',"
		sql = sql & " DataVencimento = '" & strDataVencimento & "',"
		sql = sql & " Horario = '" & strHorario & "',"
		sql = sql & " Campus = '" & strCampus & "',"
		sql = sql & " CodVestibularDisciplina = " & intCodVestibularDisciplina & ","
		sql = sql & " Situacao = '" & strSituacao & "',"
		if 	strValorVestibular= "" then
			sql = sql & "Valor_Vestibular = 0, "
		else
			sql = sql & "Valor_Vestibular = '" & strValorVestibular & "',"
		end if

		sql = sql & " NumeroVaga = " & intNumeroVaga & ","
		sql = sql & " PublicarWeb = '" & strSimouNao & "'"
		sql = sql & " Where Cod_Empresa = " & intCodEmp
		sql = sql & " And Codigo = " & intCodigo
		
	else

		strMensagem = "Registro Excluido com sucesso..."
		
		sql = "Delete from SCA_VESTIBULAR "
		sql = sql & " Where Cod_Empresa = " & intCodEmp
		sql = sql & " And Codigo = " & intCodigo
		
	end if
	
	cnn.execute sql
	
	GravarLog sql
if err.number = 0 then
	'----------Finaliza tranzação iniciada--------------
		cnn.commitTrans
		%>
		<script>
			alert("<%=strMensagem%>");
			window.navigate('Vestibular_cad.asp');
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