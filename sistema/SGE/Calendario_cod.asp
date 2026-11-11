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
	intCodCurso		 		= Trim(Request.form("cmbCurso"))
	strDataInicio 			= strAno & "/01/01"
	strDataFim 				= strAno & "/12/31"
	strSituacao				= Trim(Request.form("cmbSituacao"))
	if acao="I" then
		
		
		
		strMensagem = "Registro Salvo com sucesso..."


		sql = "select cod_calendario from sca_Calendario where cod_curso = " & intCodCurso & " and ano_letivo=" & strAno
		rs.open sql, cnn
		if not rs.eof then
			rs.close
			%>
			<script>
				alert("EXISTE UM CALENDARIO PARA O ANO INFORMADO!");
				window.history.back();
			</script>
			<%
			RESPONSE.END
		end if
		rs.close
		
		
		sql = "SET NoCount ON Insert Into sca_Calendario (cod_grupo, nome_calendario, cod_curso, ano_letivo, situacao, data_inicio, data_fim)"          
		sql = sql & " Values ("
		sql = sql & "" & strCodGrupo & ","
		sql = sql & "'" & strNome & "',"
		sql = sql & "" & intCodCurso & ","
		sql = sql & "'" & strAno & "',"
		sql = sql & "'" & strSituacao & "',"
		sql = sql & "'" & strDataInicio & "',"
		sql = sql & "'" & strDataFim & "'); SELECT @@IDENTITY "
		Set rs = cnn.Execute(sql)
		intCodigo = rs(0)
		rs.close

	elseif acao="T" then
		'*****************************************************************
		'todas unidades
		sql = "select codigo from SEG_EMPRESA where COD_GRUPO=" & strCodGrupo & " and BLOQUEIO='N'"
		vetCodTodasEmpresa = null
		rs.open sql, cnn
		if not rs.eof then
			vetCodTodasEmpresa = rs.getRows
		end if
		rs.close
		
		calendarioIncluido = 0
		calendarioAlterado = 0
		if isArray(vetCodTodasEmpresa) then

			sql = "delete SCA_CALENDARIO_DIA_UE"
			sql = sql & " where cod_calendario_ue in "
			sql = sql & " ("
			sql = sql & " select cod_calendario_ue "
			sql = sql & " from SCA_CALENDARIO_UE"
			sql = sql & " where cod_calendario_geral = " & intCodigo 
			sql = sql & " )"
			cnn.execute sql

			sql = "delete SCA_CALENDARIO_UE"
			sql = sql & " where cod_calendario_geral = " & intCodigo 
			cnn.execute sql

			controle = 0
			for i=0 to ubound(vetCodTodasEmpresa,2)

				intCodEmp  	= vetCodTodasEmpresa(0,i) 
				
				if intCodCurso<>0 then
		
					sql = "SET NoCount ON insert [dbo].[SCA_CALENDARIO_UE] (cod_empresa,cod_curso,nome_calendario,ano_letivo,situacao,data_inicio,data_fim,cod_calendario_geral) "
					sql = sql & " select "
					sql = sql & intCodEmp & ","
					sql = sql & intCodCurso & ","
					sql = sql & " 'UE - ' + nome_calendario,"
					sql = sql & " ano_letivo,"
					sql = sql & " situacao,"
					sql = sql & " data_inicio,"
					sql = sql & " data_fim,"
					sql = sql & intCodigo & ""					
					sql = sql & " from [dbo].[SCA_CALENDARIO]"
					sql = sql & " where ano_letivo = " & strAno		
					sql = sql & " and cod_calendario = " & intCodigo
					sql = sql & "  ;SELECT @@IDENTITY "
					Set rs = cnn.Execute(sql)
					intCodCalendario = rs(0)
					rs.close
					
					sql = "  insert [SCA_CALENDARIO_DIA_UE]"
					sql = sql & "  select "
					sql = sql & "  " & intCodCalendario & ""
					sql = sql & "  ,cod_calendario_evento"
					sql = sql & "  ,dia_mes"
					sql = sql & "  ,dia_semana"
					sql = sql & "  ,detalhes"
					sql = sql & "  ,mes"
					sql = sql & "  ,ano "
					sql = sql & "  from [dbo].[SCA_CALENDARIO_DIA] where cod_calendario=" & intCodigo
					cnn.Execute(sql)
					calendarioIncluido = calendarioIncluido + 1
				end if
			next
			strMensagem = "Registro atualizado com sucesso!\n\nResumo: \natualizados -> " & calendarioIncluido 

		end if
		
	elseif acao="A" then
		
		strMensagem = "Registro Alterado com sucesso..."
		
		sql = "Update sca_Calendario Set"
		sql = sql & " nome_calendario = '" & strNome & "',"
		sql = sql & " situacao = '" & strSituacao & "',"
		sql = sql & " data_inicio = '" & strdatainicio & "',"
		sql = sql & " data_fim = '" & strdatafim & "'"
		sql = sql & " Where Cod_calendario = " & intCodigo 
		cnn.execute sql
		GravarLog sql

		sql = "Update SCA_CALENDARIO_UE Set"
		sql = sql & " nome_calendario = '" & strNome & "',"
		sql = sql & " situacao = '" & strSituacao & "',"
		sql = sql & " data_inicio = '" & strdatainicio & "',"
		sql = sql & " data_fim = '" & strdatafim & "'"
		sql = sql & " where Cod_calendario_geral = " & intCodigo 
		
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