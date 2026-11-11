<!--
    ::	DESENVOLVIDO POR Asced"
    ::	Data de Criação...: 28/05/2015
    ::	Desenvolvedores...: Roberto Barbosa Silva - roberto@superawebx.com.br
    ::	Objetivo Pagina...: Cadastro Fechamento Folha - Gerar Folha
-->
<!--#include file="../../includes/inc_verificaSession.asp"-->
<!--#include file="../../includes/inc_cnn.asp"-->
<!--#include file="../../includes/inc_log.asp"-->
<!--#include file="../../includes/inc_formatadata.asp"-->
<%
	 'on error resume next
	'----------Inicia uma tranzação--------------
	cnn.begintrans
	
	acao 				= Trim(Request.QueryString("acao"))
	intCodEmp			= Session("CodEmpresa")
	intCodTipoFolha		= Trim(Request("cmbTipoFolha"))
	strMes				= Trim(Request("cmbMes"))
	strAno				= Trim(Request("cmbAno"))
	
	if acao="I" then
		
		strMensagem = "Folha gerada com sucesso..."
		
		sql = "INSERT SRH_COLABORADOR_FOLHA_ESPELHO"
		sql = sql & " select "
		sql = sql & " SRH_COLABORADOR_FOLHA.Cod_empresa,"
		sql = sql & " '" & strMes & "',"
		sql = sql & " '" & strAno & "',"
		sql = sql & " Cod_colaborador,"
		sql = sql & " Cod_nivel,"
		sql = sql & " salario_base,"
		sql = sql & " carga_horario_contratada,"
		sql = sql & " total_aulas,"
		sql = sql & " percentual_quinquenio,"
		sql = sql & " quantidade_quinquenio"
		sql = sql & " from SRH_COLABORADOR_FOLHA"
		sql = sql & " inner join SRH_COLABORADOR on SRH_COLABORADOR.codigo = SRH_COLABORADOR_FOLHA.cod_colaborador and SRH_COLABORADOR.cod_empresa = SRH_COLABORADOR_FOLHA.cod_empresa"
		sql = sql & " where SRH_COLABORADOR.situacao = 'A'and SRH_COLABORADOR.cod_empresa = " & intCodEmp
		cnn.execute sql
		GravarLog sql

		sql = "insert SRH_FOLHA_COLABORADOR"
		sql = sql & " select "
		sql = sql & " SRH_RUBRICA_COLABORADOR_FIXA.Cod_empresa,"
		sql = sql & " SRH_RUBRICA_COLABORADOR_FIXA.cod_colaborador,"
		sql = sql & " " & intCodTipoFolha & " as Cod_TipoFolha,"
		sql = sql & " '" & strMes & "',"
		sql = sql & " '" & strAno & "',"
		sql = sql & " SRH_RUBRICA_COLABORADOR_FIXA.Cod_rubrica,"
		sql = sql & " SRH_RUBRICA.Tipo_rubrica,"
		sql = sql & " SRH_RUBRICA.Percentual_rubrica,"
		sql = sql & " SRH_RUBRICA.Valor_rubrica"
		sql = sql & " from SRH_RUBRICA_COLABORADOR_FIXA"
		sql = sql & " inner join SRH_RUBRICA ON SRH_RUBRICA.CODIGO = SRH_RUBRICA_COLABORADOR_FIXA.COD_RUBRICA"
		sql = sql & " where SRH_RUBRICA_COLABORADOR_FIXA.cod_empresa = "&intCodEmp
		cnn.execute sql
		GravarLog sql

		sql = "insert SRH_FOLHA_COLABORADOR"
		sql = sql & " select "
		sql = sql & " SRH_RUBRICA_COLABORADOR_AVULSA.Cod_empresa,"
		sql = sql & " SRH_RUBRICA_COLABORADOR_AVULSA.cod_colaborador,"
		sql = sql & " SRH_RUBRICA_COLABORADOR_AVULSA.Cod_TipoFolha,"
		sql = sql & " '" & strMes & "',"
		sql = sql & " '" & strAno & "',"
		sql = sql & " SRH_RUBRICA_COLABORADOR_AVULSA.Cod_rubrica,"
		sql = sql & " SRH_RUBRICA.Tipo_rubrica,"
		sql = sql & " SRH_RUBRICA.Percentual_rubrica,"
		sql = sql & " SRH_RUBRICA.Valor_rubrica"
		sql = sql & " from SRH_RUBRICA_COLABORADOR_AVULSA"
		sql = sql & " inner join SRH_RUBRICA ON SRH_RUBRICA.CODIGO = SRH_RUBRICA_COLABORADOR_AVULSA.COD_RUBRICA"
		sql = sql & " where SRH_RUBRICA_COLABORADOR_AVULSA.cod_empresa = "&intCodEmp
		sql = sql & " and SRH_RUBRICA_COLABORADOR_AVULSA.mes = "&strMes
		sql = sql & " and SRH_RUBRICA_COLABORADOR_AVULSA.ano = "&strAno
		sql = sql & " and SRH_RUBRICA_COLABORADOR_AVULSA.Cod_TipoFolha = "&intCodTipoFolha	
		cnn.execute sql
		GravarLog sql
		
	elseif acao="A" then

	else
	
	end if

	if err.number = 0 then
	'----------Finaliza tranzação iniciada--------------
		cnn.commitTrans
		%>
		<script>
			alert("<%=strMensagem%>");
			window.location='FechamentoFolha_cad.asp';
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