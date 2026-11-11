<!--#include file="../../includes/inc_verificaSession.asp"-->
<!--#include file="../../includes/inc_cnn.asp"-->
<!--#include file="../../includes/inc_formatadata.asp"-->
<!--#include file="../../includes/inc_log.asp"-->

<%
	'on error resume next
	'----------Inicia uma tranzação--------------
	cnn.begintrans
	
	strCodGrupo		        = Session("CodGrupo")
	acao 				 	= Trim(Request.QueryString("acao"))
	intCodigo	 			= Trim(Request.form("txtCodigo"))
	
	strAno		 			= Trim(Request.form("txtAno"))
	strNome		 			= Trim(Request.form("txtNome"))
	strDataInicio 			= strAno & "/01/01"
	strDataFim 				= strAno & "/12/31"
	strSituacao				= Trim(Request.form("cmbSituacao"))
	
	if acao="I" then
		
		strMensagem = "Registro Salvo com sucesso..."

		sql = "SET NoCount ON Insert Into sca_Calendario (cod_grupo, nome_calendario, ano_letivo, situacao, data_inicio, data_fim)"          
		sql = sql & " Values ("
		sql = sql & "" & strCodGrupo & ","
		sql = sql & "'" & strNome & "',"
		sql = sql & "'" & strAno & "',"
		sql = sql & "'" & strSituacao & "',"
		sql = sql & "'" & strDataInicio & "',"
		sql = sql & "'" & strDataFim & "'); SELECT @@IDENTITY "
		Set rs = cnn.Execute(sql)
		intCodigo = rs(0)
		rs.close

		'--feriados
		sql = "INSERT SCA_CALENDARIO_DIA "
		sql = sql & "select "
		sql = sql & " "&intCodigo&", "
		sql = sql & "	(select cod_calendario_evento from  SCA_CALENDARIO_EVENTO WHERE COD_GRUPO="&strCodGrupo&" AND MARCACAO = 'FERIADO'),"
		sql = sql & "	dia,"
		sql = sql & "	DATEPART(w, cast(case when ano = 0 then "&strAno&" else ano end as varchar) + '-' + cast(mes as varchar)  + '-' + cast(dia as varchar))   ,"
		sql = sql & "	descricao AS detalhes,"
		sql = sql & "	mes,"
		sql = sql & "	cast(case when ano = 0 then "&strAno&" else ano end as varchar) as ano"
		sql = sql & " from SRH_FERIADOS "
		sql = sql & " where (ano="&strAno&" or ano=0)"
		sql = sql & " and (uf='' or uf='GO')	"
		cnn.Execute(sql)
	
		'--dias letivos
		sql = "INSERT SCA_CALENDARIO_DIA "
		sql = sql & " select "
		sql = sql & "	"&intCodigo&","
		sql = sql & "	(select cod_calendario_evento from  SCA_CALENDARIO_EVENTO WHERE COD_GRUPO="&strCodGrupo&" AND MARCACAO = 'DIA_LETIVO'),"
		sql = sql & "	dia,"
		sql = sql & "	dia_Semana,"
		sql = sql & "	'Dia Letivo' AS detalhes,"
		sql = sql & "	mes,"
		sql = sql & "	ano"
		sql = sql & " from SRH_Dia_Util"
		sql = sql & " where ano="&strAno
		sql = sql & " and Fl_Dia_Util = 1"
		sql = sql & " and not cast(case when ano = 0 then "&strAno&" else ano end as varchar) + '-' + cast(mes as varchar)+ '-' + cast(dia as varchar) in ( select cast(case when ano = 0 then "&strAno&" else ano end as varchar) + '-' + cast(mes as varchar)+ '-' + cast(dia as varchar) from SRH_FERIADOS where (ano="&strAno&" or ano=0) and (uf='' or uf='GO') )"
		cnn.Execute(sql)

	
		
	elseif acao="A" then
		
		strMensagem = "Registro Alterado com sucesso..."
		
		sql = "Update sca_Calendario Set"
		sql = sql & " ano_letivo = '" & strAno & "',"
		sql = sql & " nome_calendario = '" & strNome & "',"
		sql = sql & " situacao = '" & strSituacao & "',"
		sql = sql & " data_inicio = '" & strdatainicio & "',"
		sql = sql & " data_fim = '" & strdatafim & "'"
		sql = sql & " Where Cod_calendario = " & intCodigo 
		cnn.execute sql
		GravarLog sql
	else

		strMensagem = "Registro Excluido com sucesso..."
		sql = "Delete from SCA_CALENDARIO_DIA "
		sql = sql & " Where Cod_calendario = " & intCodigo
		cnn.execute sql
		GravarLog sql
		
		sql = "Delete from sca_Calendario "
		sql = sql & " Where Cod_calendario = " & intCodigo
		cnn.execute sql
		GravarLog sql
	
	end if
	
		
	if err.number = 0 then
	'----------Finaliza tranzação iniciada--------------
		cnn.commitTrans
		if acao = "E" then
		%>
		<script>
			alert("<%=strMensagem%>");
			window.location='Calendario_cad.asp';
		</script>
		<%
		else
		%>
		<script>
			alert("<%=strMensagem%>");
			window.location='Calendario_cad.asp?txtCodigoRetorno=<%=intCodigo%>';
		</script>
		<%
		end if
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