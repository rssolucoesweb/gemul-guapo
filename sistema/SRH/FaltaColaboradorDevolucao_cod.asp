<!--#include file="../../includes/inc_verificaSession.asp"-->
<!--#include file="../../includes/inc_cnn.asp"-->
<!--#include file="../../includes/inc_log.asp"-->
<!--#include file="../../includes/inc_formatadata.asp"-->
<%
	on error resume next
	'----------Inicia uma tranzação--------------
	cnn.begintrans
	acao 						= Trim(Request.QueryString("acao"))
	devolverFalta 				= Trim(Request.QueryString("devolverFalta"))
	intCodEmp					= Session("CodEmpresa")
	intCodModulacaoReferencia 	= Trim(Request.form("cmbModulacaoReferencia"))
	intCodCodigo 				= Trim(Request.Form("chkCodigo"))
	strOptTipoColaborador     	= Trim(Request("optTipoColaborador"))
	if devolverFalta = "S" then
	
		
		vetCodigo = split(intCodCodigo,",")
		
		for i=0 to ubound(vetCodigo)

			sql = " select codigo from SRH_COLABORADOR_SUBSTITUTO "
			sql = sql & " where Cod_Lancamento_Falta = " & vetCodigo(i)
			sql = sql & " and situacao = 'A'" 
			rs.Open SQL, cnn
			if rs.EOF = false then
				rs.close	
				cnn.rollbackTrans
				%>
				<script type="text/javascript">
					alert("Existe uma substitui\u00e7\u00e3o para esse lan\u00e7amento. Verifique!");
					window.location='FaltaColaboradorDevolucao_cad.asp';
				</script>
				<%
				response.end
			end if
			rs.close
				
			sql = " SELECT CODIGO, "
			sql = sql & " ANO_LETIVO, "
			sql = sql & " SEMESTRE_LETIVO, "
			sql = sql & " Cod_JustificativaFaltas, "
			sql = sql & " codReferencia, "
			sql = sql & " DATALANCAMENTO, "
			sql = sql & " DATALANCAMENTOFINAL, "
			sql = sql & " DataDiaLancamento, "
			sql = sql & " COD_COLABORADOR, "
			sql = sql & " COD_TURMA, "
			sql = sql & " COD_DISCIPLINA, "
			sql = sql & " COD_TURNO "
			sql = sql & " from SRH_COLABORADOR_FREQUENCIA "
			sql = sql & " WHERE COD_EMPRESA = "  & session("CodEmpresa")
			sql = sql & " AND (FECHAMENTO = 'S') "
			sql = sql & " and codigo in (" & vetCodigo(i) & ")"
			rs.open sql, cnn		
			if rs.eof = false then
				strAnoLetivo								= trim(rs("ANO_LETIVO"))
				intSemestre									= trim(rs("SEMESTRE_LETIVO"))
				intCodJustificativaFaltas					= trim(rs("Cod_JustificativaFaltas"))
				intCodModulacaoReferencia 					= trim(rs("codReferencia"))
				strDataLancamento         					= formataDataBD(trim(rs("DATALANCAMENTO")))
				strDataLancamentoFinal        				= formataDataBD(trim(rs("DATALANCAMENTOFINAL")))
				strDataDiaLancamento         				= formataDataBD(trim(rs("DataDiaLancamento")))
				intCodProfessor	         	 				= Trim(rs("COD_COLABORADOR"))
				intCodTurma	         	 					= Trim(rs("COD_TURMA"))
				intCodDisciplina	         	 			= Trim(rs("COD_DISCIPLINA"))
				intCodTurno	         	 					= Trim(rs("COD_TURNO"))
			end if 
			rs.close
	
			sql = "UPDATE SRH_COLABORADOR_FREQUENCIA SET FECHAMENTO = 'N', Fechamento_devolvido='S'  "
			sql = sql & " WHERE COD_EMPRESA = "  & session("CodEmpresa")
			sql = sql & " AND (FECHAMENTO = 'S') "
			sql = sql & " and Cod_JustificativaFaltas = " & intCodJustificativaFaltas
			sql = sql & " and codReferencia = " & intCodModulacaoReferencia
			sql = sql & " and DATALANCAMENTO = '" & strDataLancamento & "'"
			sql = sql & " and DATALANCAMENTOFINAL = '" & strDataLancamentoFinal & "'"
			sql = sql & " and DataDiaLancamento = '" & strDataDiaLancamento & "'"
			sql = sql & " and COD_COLABORADOR = " & intCodProfessor
			
			'response.write sql
			cnn.execute sql
			GravarLog sql
			
		next	
			
		strMensagem = "Registros devolvidos com sucesso..."
	end if   

	if err.number = 0 then
		'----------Finaliza tranzação iniciada--------------
		cnn.commitTrans
		%>
		<script>
			alert("<%=strMensagem%>");
			window.location='FaltaColaboradorDevolucao_cad.asp';
		</script>
		<%
		response.end
	else
		response.redirect "erro.asp?strNumErro=" & err.number & "&strDescErro=" & err.description 
		cnn.rollbacktrans
	end if
%>