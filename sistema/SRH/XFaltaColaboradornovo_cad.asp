<!--#include file="../ConfigModulo.asp"-->
<!--#include file="../../includes/inc_cnn.asp"-->
<!--#include file="../../includes/inc_formatadata.asp"-->
<!--#include file="../menuModulos.asp"-->
<!--#include file="../includes/inc_CompartilharDadosCadastrais.asp"-->
<script src="../../js/js_funcoes_gerais.js"></script>  
    <!--=== Breadcrumbs ===-->
    <div class="breadcrumbs">
        <div class="container">
            <h1 class="pull-left">SRH - Recurso Humano</h1>
            <ul class="pull-right breadcrumb">
                <li><a href="Default.asp">Home</a></li>
                <li class="active"><%=session("CodEmpresa")%> - <%=session("EmpresaWeb")%></li>
            </ul>
        </div><!--/container-->
    </div><!--/breadcrumbs-->
    <!--=== End Breadcrumbs ===-->
<%
	'envia todas
	sql = "UPDATE SRH_COLABORADOR_FREQUENCIA SET FECHAMENTO = 'S' "
	sql = sql & " WHERE (FECHAMENTO = 'N' or ISNULL(FECHAMENTO,'0') = '0') and Fechamento_devolvido is null "
	sql = sql & " and codReferencia in "
	sql = sql & " ("
	sql = sql & " select codigo from SRH_MODULACAO_REFERENCIA"
	sql = sql & " where dateadd(day,1,data_final) <= getdate()"
	sql = sql & " )"
	cnn.execute sql

	strPaginaTitulo                  			= "FaltaColaboradorNovo_cad.asp"
	strPagina						 			= "FaltaColaboradorNovo_cad.asp"
	strExecutarSubmitModulacaoReferencia        = "S"

	strExecutarSubmitProfessorTurma             = "S"
	strExecutarSubmitTurma	 		            = "S"
	strExecutarSubmitDisciplinaProfessorTurma   = "S"
	strSimouNao_submit                          = "S"
	strExecutarSubmitColaborador				= "S"
	strExecutarSubmitColaboradorFrequencia		= "S"
	strExecutarSubmitTurnoFaltas				= "S"

	intCodigo           	  					= Trim(Request.Form("txtCodigo"))
	intCodModulacaoReferencia 					= Trim(Request.form("cmbModulacaoReferencia"))
	intCodJustificativaFaltas					= Trim(Request.form("cmbJustificativaFaltas"))
	strDataLancamento         					= Trim(Request("txtDataLancamento"))
	strDataLancamentoFinal        				= Trim(Request("txtDataLancamentoFinal"))
	intCodProfessor	         	 				= Trim(Request("cmbColaboradorFrequencia")) 
	strComparaDataLancamento 					= formataDataCalc(Trim(Request("txtDataLancamento")))
	strTipoLancamento          					= Trim(Request("optTipoLancamento"))
	strOptTipoColaborador     					= Trim(Request("optTipoColaborador"))

	strJustificativaAbono    					= Trim(Request("txtJustificativaAbono"))
	strJustificativa          					= Trim(Request("txtJustificativa"))
	strSimouNao               					= Trim(Request("cmbSimouNao"))
	strFechamento             					= Trim(Request("cmbFechamento"))
	strOptListarFaltas     						= Trim(Request.form("OptListarFaltas"))
	intCodTurnoFaltas 							= Trim(Request.form("cmbTurnoFaltas"))
	
	if strOptListarFaltas = "" then strOptListarFaltas = "1"

	if strSimouNao = "" or strSimouNao = "0" then strSimouNao = "N"
	
	strDesabilitaIncluir	= "" 'Desabilita o botão Incluir
	strDesabilitaAlterar 	= "disabled" 'Desabilita o botão Excluir
	strDesabilitaExcluir	= "disabled" 'Desabilita o botão Excluir
	

	if intCodProfessor <> "" and intCodProfessor <> "0"  then
		IF intCodTurnoFaltas = "" THEN intCodTurnoFaltas = "0"
		if intCodTurnoFaltas<>"0" then
			sql = " select distinct Situacao_disciplinar, tipoModulacao, M.Ano_Letivo, M.Semestre "
			sql = sql & " from SRH_MODULACAO_DISCIPLINAR_DOCENTE M " 
			sql = sql & " INNER JOIN SRH_TURNO TRH	ON TRH.Cod_Turno = M.Cod_Turno"
			sql = sql & " INNER JOIN SCA_TURNO TU		ON SUBSTRING(TRH.Desc_Turno,1,3) = SUBSTRING(TU.Desc_Turno,1,3)"
			sql = sql & " where M.Cod_Colaborador = " & intCodProfessor 
			sql = sql & " and M.Cod_empresa = " & Session("CodEmpresa") 
			sql = sql & " and M.Status = 'A' "
			sql = sql & " and TU.COD_TURNO=" & intCodTurnoFaltas
			rs.open sql, cnn
			if rs.eof = false then
				if trim(rs("tipoModulacao")) = "PROFESSOR"  then
					strOptTipoColaborador 	= "1"
				else
					strOptTipoColaborador 	= "0"
				end if
				strTipoLancamento 		= rs("Situacao_disciplinar")
				strAnoLetivo			= rs("Ano_Letivo")
				intSemestre				= rs("Semestre")
				strDesabilitaIncluir	= "" 'Desabilita o botão Incluir
				strDesabilitaAlterar 	= "disabled" 'Desabilita o botão Excluir
				strDesabilitaExcluir	= "disabled" 'Desabilita o botão Excluir
			else
				intCodProfessor = "0"
				%>
				<script>
					alert("ATENÇÃO: Professor não está modulado no TURNO selecionado. Verifique!");
				</script>
				<%
				bloquearTela	= "S" 'Desabilita o botão Incluir
			end if	
			rs.close
		
			IF bloquearTela	<> "S" THEN
				sql = " select M.DataInicial, M.DataFinal "
				sql = sql & " from SRH_MODULACAO_DISCIPLINAR_DOCENTE M"
				sql = sql & " INNER JOIN SRH_TURNO TRH	ON TRH.Cod_Turno = M.Cod_Turno"
				sql = sql & " INNER JOIN SCA_TURNO TU		ON SUBSTRING(TRH.Desc_Turno,1,3) = SUBSTRING(TU.Desc_Turno,1,3)"
				sql = sql & " where M.cod_colaborador = " & intCodProfessor 
				sql = sql & " and M.cod_empresa = " & Session("CodEmpresa") 
				sql = sql & " and M.status = 'A'"
				sql = sql & " and TU.COD_TURNO=" & intCodTurnoFaltas
				sql = sql & " and '" & formatadataBD(strDataLancamento) & "' between DataInicial and DataFinal"
	
				rs.open sql, cnn
				if rs.eof then
					%>
					<script>
						alert("ATENÇÃO: Professor não está modulado para o PERÍODO informado!");
					</script>
					<%
					bloquearTela	= "S" 'Desabilita o botão Incluir
				end if
				rs.close
			END IF
		end if
		
		if intCodModulacaoReferencia <> "" then
			sql = "select AnoReferencia, SemestreReferencia from SRH_MODULACAO_REFERENCIA WHERE CODIGO = " & intCodModulacaoReferencia
			rs.open sql, cnn
			if rs.eof = false then
				strAnoLetivoReferencia  = rs("AnoReferencia")
				intSemestreReferencia 	= rs("SemestreReferencia")
			end if
			rs.close
		end if
		
	end if
	
	if intCodigo <> "" and intCodigo <> "0"  then
	
		cont =0
		sql = " SELECT F.CODIGO, "
		sql = sql & " F.ANO_LETIVO, "
		sql = sql & " F.Cod_JustificativaFaltas, "
		sql = sql & " F.SEMESTRE_LETIVO, "
		sql = sql & " F.DATALANCAMENTO, "
		sql = sql & " F.DATALANCAMENTOFINAL, "
		sql = sql & " F.DataDiaLancamento, "
		sql = sql & " F.TIPO_COLABORADOR, "
		sql = sql & " F.COD_TURMA, "
		sql = sql & " F.COD_COLABORADOR, "
		sql = sql & " F.COD_DISCIPLINA, "
		sql = sql & " F.NUMERO_FALTA, "
		sql = sql & " F.JUSTIFICATIVA, "
		sql = sql & " F.COD_COLABORADORSUBSTITUTO, "
		sql = sql & " F.NUMERO_AULA, "
		sql = sql & " F.CONTEUDO_SUBSTITUICAO, F.COD_TURNO,"
		sql = sql & " F.SITUACAO as STATUS, "
		sql = sql & " F.JUSTIFICATIVA_ABONO, tipoLancamento, codReferencia, "
		sql = sql & " F.FECHAMENTO, ISNULL(T.COD_TURNO,'0') AS TURNO_SCA "
		sql = sql & " from SRH_COLABORADOR_FREQUENCIA F "
		sql = sql & " LEFT join sca_turma t on t.cod_turma = f.cod_turma "
		sql = sql & " WHERE CODIGO = " & intCodigo
		rs.open sql, cnn
		if rs.eof = false then
		
			intCodigo           	  					= rs("CODIGO")
			intCodModulacaoReferencia 					= trim(rs("codReferencia"))
			intCodJustificativaFaltas					= trim(rs("Cod_JustificativaFaltas"))
			strDataLancamento         					= trim(rs("DATALANCAMENTO"))
			strDataLancamentoFinal        				= trim(rs("DATALANCAMENTOFINAL"))
			intCodProfessor	         	 				= Trim(rs("COD_COLABORADOR"))
			strComparaDataLancamento 					= formataDataCalc(trim(rs("DATALANCAMENTO")))
			strTipoLancamento          					= Trim(rs("tipoLancamento"))
			''if Trim(Request("optTipoColaborador")) = "" then
			strOptTipoColaborador     					= Trim(rs("TIPO_COLABORADOR"))
			'end if
			strJustificativaAbono    					= Trim(rs("JUSTIFICATIVA_ABONO"))
			strJustificativa          					= Trim(rs("JUSTIFICATIVA"))
			strSimouNao               					= trim(rs("STATUS"))
			strFechamento             					= trim(rs("FECHAMENTO"))
			strAnoLetivo								= trim(rs("ANO_LETIVO"))
			intSemestre									= trim(rs("SEMESTRE_LETIVO"))
			intCodTurnoFaltas							= trim(rs("TURNO_SCA"))
			
			strDesabilitaIncluir	= "disabled" 'Desabilita o botão Incluir
			strDesabilitaAlterar 	= "disabled" 'Desabilita o botão Excluir
			strDesabilitaExcluir	= "" 'Desabilita o botão Excluir
		end if	
		rs.close
	end if
	
	if trim(strFechamento) = "S" then
		strDesabilitaIncluir	= "disabled" 'Desabilita o botão Incluir
		strDesabilitaAlterar 	= "disabled" 'Desabilita o botão Excluir
		strDesabilitaExcluir	= "disabled" 'Desabilita o botão Excluir
	end if

	if trim(strDataLancamento) = "" then
		'strDataLancamento = formatadataAP(date)
	end if
	if trim(strDataLancamentoFinal) = "" then
		'strDataLancamentoFinal = formatadataAP(date)
	end if

%>
    <!--=== Content Part ===-->
<form id="frm" method="post" action="FaltaColaboradorNovo_cad.asp">
<input name="dtf" type="hidden" id="dtf" class="text" size="10" value="<%=request("dtf")%>" >
<input name="tpl" type="hidden" id="tpl" class="text" size="10" value="<%=request("tpl")%>" >

    <div class="container content">		
    
      <!-- Grey Panel -->            
      <div class="panel panel-grey">
        <div class="panel-heading">
        	<h3 class="panel-title"><i class="fa fa-tasks"></i>Lançamento de Faltas Professor</h3>
        </div>
        <!-- Inicia o Painel do Formulario -->     
        <div class="panel-body">
             <!-- Inicia o Form -->     
            	<div class="panel-body">                                                        

                    <div class="form-group">
                    
                    	<table width="98%" border="0" cellspacing="0"  align="center" cellpadding="0">
  <tr>
    <td width="245" class="texto1">&nbsp;</td>
    <td width="1062"><input name="txtCodigo" type="hidden" id="txtCodigo" class="text" size="10" value="<%=intCodigo%>" maxlength="10" /></td>
  </tr>
  
  <tr>
    <td height="13" class="texto1">&nbsp;</td>
    <td class="texto1">&nbsp;</td>
  </tr>
  <tr>
    <td height="27" class="texto1">Refer&ecirc;ncia:</td>
    <td class="texto1"><!--#include file="../includes/inc_PeriodoModulacao.asp" -->
      - De: <%=formataDataAP(strDataInicialModulacao)%> a <%=formataDataAP(strDataFinalModulacao)%></td>
  </tr>
  <tr>
    <td height="27" class="texto1">Tipo de Falta</td>
    <td class="texto1"><!--#include file="../includes/inc_cmbJustificativaFaltas.asp" -->
  <input name="txtAnoLetivo" type="hidden" class="text" id="txtAnoLetivo"  value="<%=intAnoLetivo%>">
  <input name="cmbSemestre" type="hidden" class="text" id="cmbSemestre"  value="<%=intSemestre%>"></td>
  </tr>
  <tr>
    <td height="27" class="texto1">Data Inicial do Lan&ccedil;amento</td>
    <td class="texto1"><input name="txtDataLancamento" type="text" class="text" id="txtDataLancamento" onblur="return validaData(this); reloadDtFinal()" onkeypress="return formataCampo(this, 3, 10)" size="11" maxlength="10" value="<%=strDataLancamento%>"  onChange='reloadDtFinal()' title="Click aqui para visualizar o calend&aacute;rio"></td>
  </tr>
  <%
	'calculando da data final
	bloqcampodatafinal=""
	classcampodatafinal = "text"
	if intQtdeFaltas<>0 and strDataLancamento<>"" then
	'  response.Write("intQtdeFaltas:" & intQtdeFaltas)

		strDataLancamentoFinal =  formatadataAP(DateAdd("d", intQtdeFaltas, strDataLancamento))
		bloqcampodatafinal = "readonly"
		classcampodatafinal = "textDesabilita"
	end if
	if intCodigo ="" and request("dtf")="" then 
		'strDataLancamentoFinal = strDataLancamento
		strComparaDataLancamento = formatadataCalc(Trim(strDataLancamento))
	end if

	strComparaDataInicialModulacao 	= formatadataCalc(Trim(strDataInicialModulacao))
	strComparaDataFinalModulacao 	= formatadataCalc(Trim(strDataFinalModulacao))
	strComparaDataLancamentoFinal 	= formatadataCalc(Trim(strDataLancamentoFinal))

	if strDataLancamento <> "" and strDataLancamentoFinal <> "" AND intCodModulacaoReferencia <> "0" and intCodModulacaoReferencia <> "" and intCodigo ="" then

		if cCur(strComparaDataLancamento) < cCur(strComparaDataInicialModulacao) then
			%>
			<script>
				alert("ATENÇÃO: A data informada não confere com o período de referência. Verifique!");
				//window.location='FaltaColaboradorNovo_Cad.asp';
			</script>
			<% 
			strDataLancamento = formataDataAP(strDataInicialModulacao)
			strDataLancamentoFinal = formataDataAP(strDataFinalModulacao)
		  	bloquearTela	= "S"
		else
			if cCur(strComparaDataLancamento) > cCur(strComparaDataFinalModulacao) then
				%>
				<script>
					alert("ATENÇÃO: A data informada não confere com o período de referência. Verifique!");
					//window.location='FaltaColaboradorNovo_Cad.asp';
				</script>
				<% 
				strDataLancamento = formataDataAP(strDataInicialModulacao)
				strDataLancamentoFinal = formataDataAP(strDataFinalModulacao)
			  	bloquearTela	= "S"
			end if
		end if
	end if
	if strDataLancamento <> "" and strDataLancamentoFinal <> "" AND intCodModulacaoReferencia <> "0" and intCodModulacaoReferencia <> "" then
		if cCur(strComparaDataLancamentoFinal) < cCur(strComparaDataInicialModulacao) then
			%>
			<script>
				alert("ATENÇÃO: A data informada não confere com o período de referência. Verifique!");
			</script>
			<% 
			strDataLancamento = formataDataAP(strDataInicialModulacao)
			strDataLancamentoFinal = formataDataAP(strDataFinalModulacao)
			bloquearTela	= "S"
		end if
	end if
	%>
    <tr>
        <td height="27" class="texto1">Data Final do Lan&ccedil;amento</td>
        <td class="texto1"><input <%=bloqcampodatafinal%> name="txtDataLancamentoFinal" type="text" class="<%=classcampodatafinal%>" id="txtDataLancamentoFinal" onblur="validaData(this);verificaDatas();" onkeypress="return formataCampo(this, 3, 10)" size="11" maxlength="10" value="<%=strDataLancamentoFinal%>" title="Click aqui para visualizar o calend&aacute;rio"></td>
    </tr>
    
    <% 
	
	'if strDataLancamento  <>  strDataLancamentoFinal  then %>
        <tr>
          <td height="27" class="texto1">Turno:</td> 
          <td class="texto1"><!--#include file="../includes/inc_cmdTurnoFiltroFaltas.asp" -->
           </td>
        </tr>
    <% 'end if %>
    <tr>
        <td height="27" class="texto1"> Titular:</td>
        <td class="texto1"><!--#include file="../includes/inc_cmdColaboradorFaltasModulacao.asp" -->
        &nbsp;Colaborador modulado que receber&aacute; as Faltas </td>
    </tr>
    
    <tr>
        <td height="55" class="texto1">Tipo Lan&ccedil;amento: </td>
        <td valign="middle" class="texto1">
        <input  <% if strOptTipoColaborador = "1" then response.Write("checked")%> name="optTipoColaborador" type="radio" value="1" onClick='submit()'>
        Professor&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
        <input <% if strOptTipoColaborador = "0" then response.Write("checked")%> name="optTipoColaborador" type="radio" value="0" onClick='submit()'>
        Funcion&aacute;rio<BR>
        <input <%if strTipoLancamento = "D" then response.Write("checked")%>  type="radio" name="optTipoLancamento" id="optTipoLancamento" value="D" onclick="reloadTpLanc()">
        Disciplinar 
        &nbsp;&nbsp;&nbsp;&nbsp;
        <input type="radio" <%if strTipoLancamento = "I" then response.Write("checked")%> name="optTipoLancamento" id="optTipoLancamento" value="I"  onClick="reloadTpLanc()">
        Interdisciplinar</td>
    </tr>
	<% 
	
	'Localizo as faltas interdisciplinar
	if strTipoLancamento = "I" and intCodProfessor <> "" and intCodProfessor <> "0" then 
		%>
	    <tr class="texto1">
        <td height="27" class="texto1">Turmas:</td>
        <td class="texto1">
		<%
		
		sql = " SELECT DISTINCT "
		sql = sql & " HA.cod_turma, " 
		sql = sql & " T.NomeTurma, "
		sql = sql & " '0' as CodColaboradorSubstituido, "
		sql = sql & " '/ Horário' as OrigemLancamento "
		sql = sql & " FROM  SCA_HORARIO_AULA HA "
		sql = sql & " INNER JOIN SCA_TURMA T ON T.cod_turma = HA.cod_turma "  
		sql = sql & " where HA.cod_colaborador = " & intCodProfessor 
		sql = sql & " and T.Situacao = 'A' " 
		sql = sql & " and HA.cod_empresa = " & Session("CodEmpresa") 
		sql = sql & " and HA.anoletivo = " & strAnoLetivo
		sql = sql & " and HA.semestre in (" & intSemestre & ")"
		if intCodTurnoFaltas <> "" and intCodTurnoFaltas <> "0" then
			''sql = sql & " and t.cod_turno = " & intCodTurnoFaltas
		end if

		sql = sql & " UNION "
		
		sql = sql & " SELECT " 
		sql = sql & " (SELECT DISTINCT top 1 HA.cod_turma " 
		sql = sql & " FROM SCA_HORARIO_AULA HA "
		sql = sql & " INNER JOIN SCA_TURMA T ON T.cod_turma = HA.cod_turma "
		sql = sql & " INNER JOIN SCA_TURNO TU ON TU.Cod_Turno = T.Cod_Turno "  
		sql = sql & " INNER JOIN SRH_TURNO TRH ON SUBSTRING(TRH.Desc_Turno,1,3) = SUBSTRING(TU.Desc_Turno,1,3) "  
		sql = sql & " INNER JOIN SCA_GRADECURRICULAR GC ON GC.Cod_GradeCurricular = T.Cod_GradeCurricular " 
		sql = sql & " INNER JOIN SCA_GRADECURRICULARDISCIPLINA GCD ON GCD.Cod_GradeCurricular = GC.Cod_GradeCurricular "  
		sql = sql & " INNER JOIN SCA_PERIODO P ON P.Cod_Periodo = GC.Cod_Periodo " 
		sql = sql & " WHERE HA.AnoLetivo = MD.Ano_Letivo "
		sql = sql & " AND HA.Semestre = MD.Semestre "
		sql = sql & " AND HA.Cod_Colaborador = CS.CodColaboradorSubstituido "
		sql = sql & " AND P.Cod_Curso = MD.Cod_Curso "
		sql = sql & " AND P.Cod_Periodo = MD.Cod_periodo "
		sql = sql & " AND TRH.Cod_Turno = MD.Cod_Turno ) AS cod_turma, "
		
		sql = sql & " (SELECT DISTINCT top 1 NOMETURMA " 
		sql = sql & " FROM SCA_HORARIO_AULA HA "
		sql = sql & " INNER JOIN SCA_TURMA T ON T.cod_turma = HA.cod_turma "
		sql = sql & " INNER JOIN SCA_TURNO TU ON TU.Cod_Turno = T.Cod_Turno "  
		sql = sql & " INNER JOIN SRH_TURNO TRH ON SUBSTRING(TRH.Desc_Turno,1,3) = SUBSTRING(TU.Desc_Turno,1,3) "  
		sql = sql & " INNER JOIN SCA_GRADECURRICULAR GC ON GC.Cod_GradeCurricular = T.Cod_GradeCurricular " 
		sql = sql & " INNER JOIN SCA_GRADECURRICULARDISCIPLINA GCD ON GCD.Cod_GradeCurricular = GC.Cod_GradeCurricular "  
		sql = sql & " INNER JOIN SCA_PERIODO P ON P.Cod_Periodo = GC.Cod_Periodo " 
		sql = sql & " WHERE HA.AnoLetivo = MD.Ano_Letivo "
		sql = sql & " AND HA.Semestre = MD.Semestre "
		sql = sql & " AND HA.Cod_Colaborador = CS.CodColaboradorSubstituido "
		sql = sql & " AND P.Cod_Curso = MD.Cod_Curso "
		sql = sql & " AND P.Cod_Periodo = MD.Cod_periodo "
		sql = sql & " AND TRH.Cod_Turno = MD.Cod_Turno ) AS NomeTurma, "
		
		sql = sql & " isnull(CS.CodColaboradorSubstituido,'0') as CodColaboradorSubstituido, "
		sql = sql & " '/ Substituição' as OrigemLancamento "
		sql = sql & " FROM SRH_MODULACAO_DISCIPLINAR_DOCENTE MD "
		sql = sql & " INNER JOIN SRH_COLABORADOR_SUBSTITUTO CS ON CS.CodColaboradorSubstituto = MD.Cod_Colaborador "
		'and convert(datetime,convert(varchar, CS.DATAINICIAL , 103),103) >= convert(datetime, ' " & strDataInicialModulacao & " ',103) and convert(datetime,convert(varchar, CS.DATAFINAL, 103),103) <= convert(datetime, ' " & strDataFinalModulacao & " ',103) "  
		sql = sql & " LEFT JOIN SRH_TURNO TRH ON TRH.Cod_Turno = MD.Cod_Turno "   
		sql = sql & " LEFT JOIN SCA_TURNO TU ON SUBSTRING(TU.Desc_Turno,1,3) = SUBSTRING(TRH.Desc_Turno,1,3) " 
		sql = sql & " WHERE MD.Cod_Colaborador = " & intCodProfessor
		sql = sql & " and ( "
		sql = sql & " 	(CS.DataInicial BETWEEN '"& FORMATADATABD(strDataInicialModulacao) &"' AND '"& FORMATADATABD(strDataFinalModulacao) &"' or CS.DataFinal BETWEEN '"& FORMATADATABD(strDataInicialModulacao) &"' AND '"& FORMATADATABD(strDataFinalModulacao) &"') "
		sql = sql & " 	or"
		sql = sql & " 	('" & FORMATADATABD(strDataInicialModulacao) & "' BETWEEN CS.DataInicial AND CS.DataFinal   or '"& FORMATADATABD(strDataFinalModulacao) &"' BETWEEN CS.DataInicial AND CS.DataFinal)"
		sql = sql & " )		"
		sql = sql & " and MD.Ano_Letivo = " & strAnoLetivo
		sql = sql & " and MD.Semestre in (" & intSemestre & ")"
		'sql = sql & " AND ( MD.Status = 'A' OR "
		'sql = sql & " AND ISNULL(Cod_Modulacao_Substituicao,'0')<> 0 "  
		sql = sql & " and ISNULL((SELECT DISTINCT top 1 NOMETURMA "   
		sql = sql & " FROM SCA_HORARIO_AULA HA "  
		sql = sql & " INNER JOIN SCA_TURMA T ON T.cod_turma = HA.cod_turma "  
		sql = sql & " INNER JOIN SCA_TURNO TU ON TU.Cod_Turno = T.Cod_Turno "    
		sql = sql & " INNER JOIN SRH_TURNO TRH ON SUBSTRING(TRH.Desc_Turno,1,3) = SUBSTRING(TU.Desc_Turno,1,3) "    
		sql = sql & " INNER JOIN SCA_GRADECURRICULAR GC ON GC.Cod_GradeCurricular = T.Cod_GradeCurricular "   
		sql = sql & " INNER JOIN SCA_GRADECURRICULARDISCIPLINA GCD ON GCD.Cod_GradeCurricular = GC.Cod_GradeCurricular "    
		sql = sql & " INNER JOIN SCA_PERIODO P ON P.Cod_Periodo = GC.Cod_Periodo "   
		sql = sql & " WHERE HA.AnoLetivo = MD.Ano_Letivo "  
		sql = sql & " AND HA.Semestre = MD.Semestre "  
		sql = sql & " AND HA.Cod_Colaborador = CS.CodColaboradorSubstituido "  
		sql = sql & " and HA.cod_empresa = " & Session("CodEmpresa") 
		sql = sql & " AND P.Cod_Curso = MD.Cod_Curso "  
		sql = sql & " AND P.Cod_Periodo = MD.Cod_periodo "  
		sql = sql & " AND TRH.Cod_Turno = MD.Cod_Turno ),'0')<>'0' "  
		if intCodTurnoFaltas <> "" and intCodTurnoFaltas <> "0" then
			''sql = sql & " and tu.cod_turno = " & intCodTurnoFaltas
		end if
		
	if ucase(session("usuarioWeb")) = "SERGIO"  THEN
		'response.write "<hr>2222" & sql
		'response.write "<hr>"
	'response.end	
	end if
		rs.open sql, cnn
		if rs.eof = false then
		
			 while not rs.eof
		
				strDataLancamentoCompara 		= strDataLancamento
				strDataLancamentoFinalCompara 	= strDataLancamentoFinal
				TotalFaltaTurma 				= 0
				strTurmaLocalizada 				= ""
				
				do while true
	
					sql = " SELECT DISTINCT "
					sql = sql & " HA.cod_turma, " 
					sql = sql & " T.NomeTurma, "
					sql = sql & " HA.DiaSemana "
					sql = sql & " FROM  SCA_HORARIO_AULA HA "
					sql = sql & " INNER JOIN SCA_TURMA T ON T.cod_turma = HA.cod_turma "  
					sql = sql & " where ( HA.cod_colaborador = " & intCodProfessor & " or HA.cod_colaborador = " & trim(rs("CodColaboradorSubstituido")) & ")" 
					sql = sql & " and T.Situacao = 'A' " 
					sql = sql & " and HA.cod_empresa = " & Session("CodEmpresa") 
					sql = sql & " and HA.anoletivo = " & strAnoLetivo
					sql = sql & " and HA.semestre in (" & intSemestre & ")"
					sql = sql & " and HA.diasemana = " & weekday(strDataLancamentoCompara) 
					sql = sql & " UNION"
					sql = sql & " SELECT DISTINCT HA.cod_turma, T.NomeTurma, 0 AS DiaSemana "
					sql = sql & " FROM SCA_HORARIO_AULA_EXTRA HA "
					sql = sql & " INNER JOIN SCA_TURMA T ON T.cod_turma = HA.cod_turma "
					sql = sql & " where (HA.cod_colaborador = " & intCodProfessor & " or HA.cod_colaborador = 0) "
					sql = sql & " and T.Situacao = 'A' "
					sql = sql & " and HA.cod_empresa = " & Session("CodEmpresa")
					sql = sql & " and HA.anoletivo = " & strAnoLetivo
					sql = sql & " and HA.semestre in (" & intSemestre & ")"
					sql = sql & " and convert(datetime, HA.DATALANCAMENTO,103) between convert(datetime,convert(varchar, '" & FORMATADATAAP(strDataLancamento) & "' , 103),103) AND convert(datetime,convert(varchar, '" & FORMATADATAAP(strDataLancamentoFinal) & "', 103),103)"
	if ucase(session("usuarioWeb")) = "SERGIO"  THEN
		'response.write sql	
		'response.end
	end if
					rsAux.open sql, cnn
					IF rsAux.EOF = false THEN
						TotalFaltaTurma = TotalFaltaTurma + 1
					end if
					rsAux.close  
					strDataLancamentoCompara = DateAdd("d", 1, strDataLancamentoCompara)
					
						'if strDataLancamentoFinal <> "" then
					if formatadataCalc(Trim(strDataLancamentoCompara)) > formatadataCalc(Trim(strDataLancamentoFinalCompara)) then
						'end if
						exit do
					end if
					
				loop
				
				if TotalFaltaTurma > 0 then
					if strDataLancamento <> strDataLancamentoFinal then 
						strSelecionado = " checked "
						strBloqueiaCK = " Disabled "
					end if
					strTurmaLocalizada = "OK"
					%>
					<input <%=strSelecionado%> <%=strBloqueiaCK%> name="<%=rs("cod_turma")%>" id="<%=rs("cod_turma")%>" type="checkbox" value="<%=TotalFaltaTurma%>"/><%=rs("NomeTurma")%> - <%=TotalFaltaTurma%> Falta(s) <%=rs("OrigemLancamento")%>  <BR>
					<%
				end if
				rs.movenext
				
			wend
			if strTurmaLocalizada = "" then
				%>
                <strong>Turma(s) não localizada para o per&iacute;odo de lan&ccedil;amento informado.</strong> 
            	<%
				bloquearTela	= "S"
			end if 
			%>			</td>
			<%
		else
			%>
			<script>
				alert("ATENÇÃO: Não foi localizado Turmas para Lançamento. Verifique!");
			</script>
			<%
			bloquearTela	= "S"
		end if	
		rs.close
	
	end if
	
	'Localizo as faltas Disciplinares
	if strTipoLancamento = "D" and intCodProfessor <> "" then 
		%>
	    <tr class="texto1">
        <td height="27" class="texto1">Turmas:</td>
        <td class="texto1">
		<%
		
		strTurmaLocalizada  = ""
		
		if strDataLancamento = strDataLancamentoFinal then 
			sql = " SELECT DISTINCT HA.cod_turma, T.NomeTurma, D.Cod_Disciplina, D.Desc_Disciplina, HA.diasemana, HA.Sequencia, '0' as CodColaboradorSubstituido, '' as OrigemLancamento "
		else
			sql = " SELECT DISTINCT HA.cod_turma, T.NomeTurma, D.Cod_Disciplina, D.Desc_Disciplina, '0' as CodColaboradorSubstituido, '' as OrigemLancamento "
		end if
		sql = sql & " FROM SCA_HORARIO_AULA HA " 
		sql = sql & " INNER JOIN SCA_TURMA T ON T.cod_turma = HA.cod_turma " 
		sql = sql & " INNER JOIN SCA_DISCIPLINA D ON D.Cod_Disciplina = HA.Cod_Disciplina " 
		sql = sql & " where HA.cod_colaborador = " & intCodProfessor 
		sql = sql & " and T.Situacao = 'A' " 
		sql = sql & " and HA.cod_empresa = " & Session("CodEmpresa") 
		sql = sql & " and HA.anoletivo = " & strAnoLetivo
		sql = sql & " and HA.semestre in (" & intSemestre & ")"
		if strDataLancamento = strDataLancamentoFinal then 
			sql = sql & " and HA.diasemana = " & weekday(strDataLancamento) 
	    end if
		if intCodTurnoFaltas <> "" and intCodTurnoFaltas <> "0" then
			sql = sql & " and t.cod_turno = " & intCodTurnoFaltas
		end if
		'-
		sql = sql & " UNION "
		'-extra
		if strDataLancamento = strDataLancamentoFinal then 
			sql = sql & " SELECT DISTINCT HA.cod_turma, T.NomeTurma, HA.Cod_Disciplina, D.Desc_Disciplina, '0' as diasemana,'0' as Sequencia, '0' as CodColaboradorSubstituido, '' as OrigemLancamento "
		else
			sql = sql & " SELECT DISTINCT HA.cod_turma, T.NomeTurma, HA.Cod_Disciplina, D.Desc_Disciplina, '0' as CodColaboradorSubstituido, '' as OrigemLancamento "
		end if
		
		sql = sql & " FROM SCA_HORARIO_AULA_EXTRA HA "
		sql = sql & " INNER JOIN SCA_TURMA T ON T.cod_turma = HA.cod_turma "
		sql = sql & " INNER JOIN SCA_DISCIPLINA D ON D.Cod_Disciplina = HA.Cod_Disciplina "
		sql = sql & " where HA.cod_colaborador = " & intCodProfessor 
		sql = sql & " and T.Situacao = 'A' "
		sql = sql & " and HA.cod_empresa = " & Session("CodEmpresa")
		sql = sql & " and HA.anoletivo = " & strAnoLetivo
		sql = sql & " and HA.semestre in (" & intSemestre & ")"
		sql = sql & " and convert(datetime, HA.DATALANCAMENTO,103) between convert(datetime,convert(varchar, '" & FORMATADATAAP(strDataLancamento) & "' , 103),103) AND convert(datetime,convert(varchar, '" & FORMATADATAAP(strDataLancamentoFinal) & "', 103),103)"

		sql = sql & " UNION "
		sql = sql & " SELECT "
 		'
		if strDataLancamento = strDataLancamentoFinal then 
			sql = sql & " (SELECT DISTINCT top 1 HA.COD_TURMA " 
			sql = sql & " FROM SCA_HORARIO_AULA HA "
			sql = sql & " INNER JOIN SCA_TURMA T ON T.cod_turma = HA.cod_turma "
			sql = sql & " INNER JOIN SCA_TURNO TU ON TU.Cod_Turno = T.Cod_Turno "  
			sql = sql & " INNER JOIN SRH_TURNO TRH ON SUBSTRING(TRH.Desc_Turno,1,3) = SUBSTRING(TU.Desc_Turno,1,3) "  
			sql = sql & " INNER JOIN SCA_GRADECURRICULAR GC ON GC.Cod_GradeCurricular = T.Cod_GradeCurricular " 
			sql = sql & " INNER JOIN SCA_GRADECURRICULARDISCIPLINA GCD ON GCD.Cod_GradeCurricular = GC.Cod_GradeCurricular "  
			sql = sql & " INNER JOIN SCA_PERIODO P ON P.Cod_Periodo = GC.Cod_Periodo " 
			sql = sql & " WHERE HA.AnoLetivo = MD.Ano_Letivo "
			sql = sql & " AND HA.Semestre = MD.Semestre "
			sql = sql & " AND HA.Cod_Colaborador = CS.CodColaboradorSubstituido "
			sql = sql & " AND P.Cod_Curso = MD.Cod_Curso "
			sql = sql & " AND P.Cod_Periodo = MD.Cod_periodo "
			sql = sql & " AND HA.Cod_Disciplina = MD.Cod_Disciplina "
			if strDataLancamento = strDataLancamentoFinal then 
				sql = sql & " and HA.diasemana = " & weekday(strDataLancamento) 
			end if
			sql = sql & " AND TRH.Cod_Turno = MD.Cod_Turno ) AS cod_turma, "
			'
			sql = sql & " (SELECT DISTINCT top 1 T.NOMETURMA " 
			sql = sql & " FROM SCA_HORARIO_AULA HA "
			sql = sql & " INNER JOIN SCA_TURMA T ON T.cod_turma = HA.cod_turma "
			sql = sql & " INNER JOIN SCA_TURNO TU ON TU.Cod_Turno = T.Cod_Turno "  
			sql = sql & " INNER JOIN SRH_TURNO TRH ON SUBSTRING(TRH.Desc_Turno,1,3) = SUBSTRING(TU.Desc_Turno,1,3) "  
			sql = sql & " INNER JOIN SCA_GRADECURRICULAR GC ON GC.Cod_GradeCurricular = T.Cod_GradeCurricular " 
			sql = sql & " INNER JOIN SCA_GRADECURRICULARDISCIPLINA GCD ON GCD.Cod_GradeCurricular = GC.Cod_GradeCurricular "  
			sql = sql & " INNER JOIN SCA_PERIODO P ON P.Cod_Periodo = GC.Cod_Periodo " 
			sql = sql & " WHERE HA.AnoLetivo = MD.Ano_Letivo "
			sql = sql & " AND HA.Semestre = MD.Semestre "
			sql = sql & " AND HA.Cod_Colaborador = CS.CodColaboradorSubstituido "
			sql = sql & " AND P.Cod_Curso = MD.Cod_Curso "
			sql = sql & " AND P.Cod_Periodo = MD.Cod_periodo "
			sql = sql & " AND HA.Cod_Disciplina = MD.Cod_Disciplina "
			if strDataLancamento = strDataLancamentoFinal then 
				sql = sql & " and HA.diasemana = " & weekday(strDataLancamento) 
			end if
			sql = sql & " AND TRH.Cod_Turno = MD.Cod_Turno ) AS NomeTurma, "
			'
			sql = sql & " MD.Cod_Disciplina, "
			'
			sql = sql & " D.Desc_Disciplina, "
			'
			sql = sql & " (SELECT DISTINCT top 1 HA.diasemana " 
			sql = sql & " FROM SCA_HORARIO_AULA HA "
			sql = sql & " INNER JOIN SCA_TURMA T ON T.cod_turma = HA.cod_turma "
			sql = sql & " INNER JOIN SCA_TURNO TU ON TU.Cod_Turno = T.Cod_Turno "  
			sql = sql & " INNER JOIN SRH_TURNO TRH ON SUBSTRING(TRH.Desc_Turno,1,3) = SUBSTRING(TU.Desc_Turno,1,3) "  
			sql = sql & " INNER JOIN SCA_GRADECURRICULAR GC ON GC.Cod_GradeCurricular = T.Cod_GradeCurricular " 
			sql = sql & " INNER JOIN SCA_GRADECURRICULARDISCIPLINA GCD ON GCD.Cod_GradeCurricular = GC.Cod_GradeCurricular "  
			sql = sql & " INNER JOIN SCA_PERIODO P ON P.Cod_Periodo = GC.Cod_Periodo " 
			sql = sql & " WHERE HA.AnoLetivo = MD.Ano_Letivo "
			sql = sql & " AND HA.Semestre = MD.Semestre "
			sql = sql & " AND HA.Cod_Colaborador = CS.CodColaboradorSubstituido "
			sql = sql & " AND P.Cod_Curso = MD.Cod_Curso "
			sql = sql & " AND P.Cod_Periodo = MD.Cod_periodo "
			sql = sql & " AND HA.Cod_Disciplina = MD.Cod_Disciplina "
			if strDataLancamento = strDataLancamentoFinal then 
				sql = sql & " and HA.diasemana = " & weekday(strDataLancamento) 
			end if
			sql = sql & " AND TRH.Cod_Turno = MD.Cod_Turno) AS diasemana, "
			'
			sql = sql & " (SELECT DISTINCT top 1 HA.Sequencia " 
			sql = sql & " FROM SCA_HORARIO_AULA HA "
			sql = sql & " INNER JOIN SCA_TURMA T ON T.cod_turma = HA.cod_turma "
			sql = sql & " INNER JOIN SCA_TURNO TU ON TU.Cod_Turno = T.Cod_Turno "  
			sql = sql & " INNER JOIN SRH_TURNO TRH ON SUBSTRING(TRH.Desc_Turno,1,3) = SUBSTRING(TU.Desc_Turno,1,3) "  
			sql = sql & " INNER JOIN SCA_GRADECURRICULAR GC ON GC.Cod_GradeCurricular = T.Cod_GradeCurricular " 
			sql = sql & " INNER JOIN SCA_GRADECURRICULARDISCIPLINA GCD ON GCD.Cod_GradeCurricular = GC.Cod_GradeCurricular  " 
			sql = sql & " INNER JOIN SCA_PERIODO P ON P.Cod_Periodo = GC.Cod_Periodo " 
			sql = sql & " WHERE HA.AnoLetivo = MD.Ano_Letivo "
			sql = sql & " AND HA.Semestre = MD.Semestre "
			sql = sql & " AND HA.Cod_Colaborador = CS.CodColaboradorSubstituido "
			sql = sql & " AND P.Cod_Curso = MD.Cod_Curso "
			sql = sql & " AND P.Cod_Periodo = MD.Cod_periodo "
			sql = sql & " AND HA.Cod_Disciplina = MD.Cod_Disciplina "
			if strDataLancamento = strDataLancamentoFinal then 
				sql = sql & " and HA.diasemana = " & weekday(strDataLancamento) 
			end if
			sql = sql & " AND TRH.Cod_Turno = MD.Cod_Turno) AS Sequencia, "
			'
			sql = sql & " CS.CodColaboradorSubstituido, "
			'
			sql = sql & " '/ Substituição' as OrigemLancamento "
			'
		else
			sql = sql & " (SELECT DISTINCT top 1 HA.COD_TURMA " 
			sql = sql & " FROM SCA_HORARIO_AULA HA "
			sql = sql & " INNER JOIN SCA_TURMA T ON T.cod_turma = HA.cod_turma "
			sql = sql & " INNER JOIN SCA_TURNO TU ON TU.Cod_Turno = T.Cod_Turno "  
			sql = sql & " INNER JOIN SRH_TURNO TRH ON SUBSTRING(TRH.Desc_Turno,1,3) = SUBSTRING(TU.Desc_Turno,1,3) "  
			sql = sql & " INNER JOIN SCA_GRADECURRICULAR GC ON GC.Cod_GradeCurricular = T.Cod_GradeCurricular " 
			sql = sql & " INNER JOIN SCA_GRADECURRICULARDISCIPLINA GCD ON GCD.Cod_GradeCurricular = GC.Cod_GradeCurricular "  
			sql = sql & " INNER JOIN SCA_PERIODO P ON P.Cod_Periodo = GC.Cod_Periodo " 
			sql = sql & " WHERE HA.AnoLetivo = MD.Ano_Letivo "
			sql = sql & " AND HA.Semestre = MD.Semestre "
			sql = sql & " AND HA.Cod_Colaborador = CS.CodColaboradorSubstituido "
			sql = sql & " AND P.Cod_Curso = MD.Cod_Curso "
			sql = sql & " AND P.Cod_Periodo = MD.Cod_periodo "
			sql = sql & " AND HA.Cod_Disciplina = MD.Cod_Disciplina "
			if strDataLancamento = strDataLancamentoFinal then 
				sql = sql & " and HA.diasemana = " & weekday(strDataLancamento) 
			end if
			sql = sql & " AND TRH.Cod_Turno = MD.Cod_Turno ) AS cod_turma, "
			'
			sql = sql & " (SELECT DISTINCT top 1 T.NOMETURMA " 
			sql = sql & " FROM SCA_HORARIO_AULA HA "
			sql = sql & " INNER JOIN SCA_TURMA T ON T.cod_turma = HA.cod_turma "
			sql = sql & " INNER JOIN SCA_TURNO TU ON TU.Cod_Turno = T.Cod_Turno "  
			sql = sql & " INNER JOIN SRH_TURNO TRH ON SUBSTRING(TRH.Desc_Turno,1,3) = SUBSTRING(TU.Desc_Turno,1,3) "  
			sql = sql & " INNER JOIN SCA_GRADECURRICULAR GC ON GC.Cod_GradeCurricular = T.Cod_GradeCurricular " 
			sql = sql & " INNER JOIN SCA_GRADECURRICULARDISCIPLINA GCD ON GCD.Cod_GradeCurricular = GC.Cod_GradeCurricular "  
			sql = sql & " INNER JOIN SCA_PERIODO P ON P.Cod_Periodo = GC.Cod_Periodo " 
			sql = sql & " WHERE HA.AnoLetivo = MD.Ano_Letivo "
			sql = sql & " AND HA.Semestre = MD.Semestre "
			sql = sql & " AND HA.Cod_Colaborador = CS.CodColaboradorSubstituido "
			sql = sql & " AND P.Cod_Curso = MD.Cod_Curso "
			sql = sql & " AND P.Cod_Periodo = MD.Cod_periodo "
			sql = sql & " AND HA.Cod_Disciplina = MD.Cod_Disciplina "
			if strDataLancamento = strDataLancamentoFinal then 
				sql = sql & " and HA.diasemana = " & weekday(strDataLancamento) 
			end if
			sql = sql & " AND TRH.Cod_Turno = MD.Cod_Turno ) AS NomeTurma, "
			'
			sql = sql & " MD.Cod_Disciplina, "
			'
			sql = sql & " D.Desc_Disciplina, "
			'
			sql = sql & " CS.CodColaboradorSubstituido, "
			'
			sql = sql & " '/ Substituição' as OrigemLancamento "
			'
		end if
		sql = sql & " FROM SRH_MODULACAO_DISCIPLINAR_DOCENTE MD "
		sql = sql & " INNER JOIN SRH_COLABORADOR_SUBSTITUTO CS ON CS.CodColaboradorSubstituto = MD.Cod_Colaborador AND CS.Situacao = 'A' " 
		sql = sql & " INNER JOIN SCA_DISCIPLINA D ON D.Cod_Disciplina = MD.Cod_Disciplina " 
		sql = sql & " WHERE MD.Cod_Colaborador = " & intCodProfessor
		sql = sql & " and MD.Ano_Letivo = " & strAnoLetivo
		sql = sql & " and MD.Semestre in (" & intSemestre & ")"
		sql = sql & " AND MD.Status = 'A' "
		sql = sql & " AND ISNULL(Cod_Modulacao_Substituicao,'0')<> 0 "
		sql = sql & " and ISNULL((SELECT DISTINCT top 1 NOMETURMA " 
		sql = sql & " FROM SCA_HORARIO_AULA HA "
		sql = sql & " INNER JOIN SCA_TURMA T ON T.cod_turma = HA.cod_turma "
		sql = sql & " INNER JOIN SCA_TURNO TU ON TU.Cod_Turno = T.Cod_Turno "  
		sql = sql & " INNER JOIN SRH_TURNO TRH ON SUBSTRING(TRH.Desc_Turno,1,3) = SUBSTRING(TU.Desc_Turno,1,3) "  
		sql = sql & " INNER JOIN SCA_GRADECURRICULAR GC ON GC.Cod_GradeCurricular = T.Cod_GradeCurricular " 
		sql = sql & " INNER JOIN SCA_GRADECURRICULARDISCIPLINA GCD ON GCD.Cod_GradeCurricular = GC.Cod_GradeCurricular "  
		sql = sql & " INNER JOIN SCA_PERIODO P ON P.Cod_Periodo = GC.Cod_Periodo " 
		sql = sql & " WHERE HA.AnoLetivo = MD.Ano_Letivo "
		sql = sql & " AND HA.Semestre = MD.Semestre "
		sql = sql & " AND HA.Cod_Colaborador = CS.CodColaboradorSubstituido "
		sql = sql & " AND P.Cod_Curso = MD.Cod_Curso "
		sql = sql & " AND P.Cod_Periodo = MD.Cod_periodo "
		sql = sql & " AND HA.Cod_Disciplina = MD.Cod_Disciplina "
		if strDataLancamento = strDataLancamentoFinal then 
			sql = sql & " and HA.diasemana = " & weekday(strDataLancamento) 
	    end if
		if intCodTurnoFaltas <> "" and intCodTurnoFaltas <> "0" then
			sql = sql & " and t.cod_turno = " & intCodTurnoFaltas
		end if

		sql = sql & " AND TRH.Cod_Turno = MD.Cod_Turno ),'0')<>'0' "
		
		if ucase(session("usuarioWeb")) = "SERGIO"  THEN
			'response.write "<hr>2222" & sql
			'response.write "<hr>"
			'response.end	
		end if
		rs.open sql, cnn
		if rs.eof = false then
		
			 while not rs.eof
			 
				TotalFaltaTurmaDisciplina 		= 0
				intCodHorario 					= 0
				strDataLancamentoCompara 		= strDataLancamento
				strDataLancamentoFinalCompara 	= strDataLancamentoFinal
				
				do while true
	
					sql = " SELECT HA.CODIGO, HA.cod_turma, T.NomeTurma, HA.DiaSemana "
					sql = sql & " FROM SCA_HORARIO_AULA HA " 
					sql = sql & " INNER JOIN SCA_TURMA T ON T.cod_turma = HA.cod_turma " 
					sql = sql & " where ( HA.cod_colaborador = " & intCodProfessor & " or HA.cod_colaborador = " & trim(rs("CodColaboradorSubstituido")) & ")" 
					sql = sql & " and T.Situacao = 'A' " 
					sql = sql & " and HA.cod_empresa = " & Session("CodEmpresa") 
					sql = sql & " and HA.anoletivo = " & strAnoLetivo
					sql = sql & " and HA.semestre in (" & intSemestre & ")"
					sql = sql & " and HA.diasemana = " & weekday(strDataLancamentoCompara) 
					sql = sql & " and HA.cod_turma = " & trim(rs("cod_turma"))
					sql = sql & " and HA.Cod_Disciplina = " & trim(rs("Cod_Disciplina"))
					if strDataLancamento = strDataLancamentoFinal then 
						sql = sql & " and HA.Sequencia = " & trim(rs("Sequencia"))
					end if
					sql = sql & " UNION"
					sql = sql & " SELECT DISTINCT HA.CODIGO, HA.cod_turma, T.NomeTurma, 0 AS DiaSemana "
					sql = sql & " FROM SCA_HORARIO_AULA_EXTRA HA "
					sql = sql & " INNER JOIN SCA_TURMA T ON T.cod_turma = HA.cod_turma "
					sql = sql & " where (HA.cod_colaborador = " & intCodProfessor & " or HA.cod_colaborador = 0) "
					sql = sql & " and T.Situacao = 'A' "
					sql = sql & " and HA.cod_empresa = " & Session("CodEmpresa")
					sql = sql & " and HA.anoletivo = " & strAnoLetivo
					sql = sql & " and HA.semestre in (" & intSemestre & ")"
					sql = sql & " and HA.cod_turma = " & trim(rs("cod_turma"))
					sql = sql & " and HA.DATALANCAMENTO = '" & formatadataBD(strDataLancamentoCompara) & "'"
					'sql = sql & " and convert(datetime, HA.DATALANCAMENTO,103) between convert(datetime,convert(varchar, '" & FORMATADATAAP(strDataLancamento) & "' , 103),103) AND convert(datetime,convert(varchar, '" & FORMATADATAAP(strDataLancamentoFinal) & "', 103),103)"
					if ucase(session("usuarioWeb")) = "SERGIO"  THEN
						'response.write "111<hr>" & sql
						'response.write "<hr>"
						'response.end	
					end if
					rsAux.open sql, cnn
					IF rsAux.EOF = false THEN
						intCodHorario = trim(rsAux("CODIGO"))
						 while not rsAux.eof
							TotalFaltaTurmaDisciplina = TotalFaltaTurmaDisciplina + 1
							rsAux.movenext
						 wend
					end if
					rsAux.close  
					strDataLancamentoCompara = DateAdd("d", 1, strDataLancamentoCompara)
					
					if cCur(formatadataCalc(Trim(strDataLancamentoCompara))) > cCur(formatadataCalc(Trim(strDataLancamentoFinalCompara))) then
						exit do
					end if
					
				loop
				'TURMAS
				
				if TotalFaltaTurmaDisciplina > 0 then
					if strDataLancamento <> strDataLancamentoFinal then 
						strSelecionado = " checked "
						strBloqueiaCK = " Disabled "
					end if
					strTurmaLocalizada = "OK"
					%>
					<input <%=strSelecionado%> <%=strBloqueiaCK%> name="<%=intCodHorario%>" id="<%=intCodHorario%>" type="checkbox" value="<%=TotalFaltaTurmaDisciplina%>"/>&nbsp;<%=rs("Desc_Disciplina")%> ( <%=rs("NomeTurma")%> ) - <%=TotalFaltaTurmaDisciplina%> Falta(s) <% if strDataLancamento = strDataLancamentoFinal then %> / <%=rs("Sequencia")%>. Aula <%end if%> <%=rs("OrigemLancamento")%> <BR>
					<%
				end if
				rs.movenext
				
			wend
			if strTurmaLocalizada = "" then
				%>
                <strong>Disciplina(s) não localizada para o per&iacute;odo de lan&ccedil;amento informado.</strong> 
            	<%
			end if %>			</td>
			<%
		else
			%>
			<script>
				alert("ATENÇÃO: Não foi localizado Turmas para o periodo informado. Verifique!");
			</script>
			<%
			 bloquearTela	= "S"
		end if	
		rs.close
	
	end if	


		%>
        <input name="txtDataFaltasPeriodo" type="hidden" class="text" id="txtDataFaltasPeriodo" value="<%=strDataFaltas%>" size="100">        
        
  <% 
  if intQtdeFalta <> "0" or Trim(Request("txtJustificativa")) <> "" then
  		if strSimouNao = "S" then 
			strJustificativa=""
		else%>
  <tr>
    <td height="64" class="texto1">Justificativa de Falta</td>
    <td class="texto1"><textarea name="txtJustificativa" cols="60" rows="3" class="text" id="txtJustificativa"><%=strJustificativa%></textarea>
      - Opcional</td>
  </tr>
 	 <% end if %>
   <tr>
    <td height="27" class="texto1">Abonar Lan&ccedil;amento? </td>
    <td><!--#include file="../includes/inc_cmbSimouNao.asp" --></td>
  </tr>
  <% end if %>
  <tr>
  <% if strSimouNao = "S" or Trim(Request("txtJustificativaAbono")) <> ""  then %>
    <td height="64" class="texto1">Justificativa do Abono:</td>
    <td class="texto1"><textarea name="txtJustificativaAbono" cols="60" rows="3" class="text" id="txtJustificativaAbono"><%=strJustificativaAbono%></textarea> 
    - Descreva o(s) documento(s) que ser&aacute;(&atilde;o) apresentado(s) para justificar o  abono.</td>
  </tr>
  <% end if %>
  <tr>
    <td height="13" class="texto1">&nbsp;</td>
    <td>&nbsp;</td>
  </tr>
  <%
  	if bloquearTela	= "S" then
		strDesabilitaIncluir = " Disabled "
		strDesabilitaAlterar = " Disabled "
		strDesabilitaExcluir = " Disabled "
	end if					

  %>
  <tr>
    <td colspan="2"><!--#include file="../../includes/inc_botoes_cadastro.asp"--></td>
  </tr>
  <tr>
    <td colspan="2">&nbsp;</td>
  </tr>
  <tr>
    <td colspan="2" class="texto1"> <div align="center"><strong>Listar Faltas</strong><br>
        <input  <% if strOptListarFaltas = "1" then response.Write("checked")%> name="OptListarFaltas" type="radio" value="1" onClick='submit()'>
      Data da Falta&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
      <input <% if strOptListarFaltas = "0" then response.Write("checked")%> name="OptListarFaltas" type="radio" value="0" onClick='submit()'>
      Dia do lancamento (Conferir Lan&ccedil;amento)</div><br></td>
    </tr>
  <tr>
    <td colspan="2">
      <%
	  
	 if trim(strDataLancamento) <> "" or intCodModulacaoReferencia <> "" or intCodModulacaoReferencia <> "0" then
		cont =0

		sql = " SELECT "
		sql = sql & " (SELECT TOP 1 CODIGO from SRH_COLABORADOR_FREQUENCIA " 
		sql = sql & " where ANO_LETIVO = CF.ANO_LETIVO "
		sql = sql & " and SEMESTRE_LETIVO = CF.SEMESTRE_LETIVO "
		sql = sql & " and Cod_JustificativaFaltas = CF.Cod_JustificativaFaltas "
		sql = sql & " and codReferencia = CF.CodReferencia "
		sql = sql & " and DATALANCAMENTO = CF.DATALANCAMENTO "
		sql = sql & " and DATALANCAMENTOFINAL = CF.DATALANCAMENTOFINAL "
		sql = sql & " and DataDiaLancamento = CF.DataDiaLancamento "
		sql = sql & " and COD_COLABORADOR = CF.COD_COLABORADOR "
		sql = sql & " and COD_TURMA = CF.COD_TURMA "
		sql = sql & " and ISNULL(COD_DISCIPLINA,'0') = ISNULL(CF.COD_DISCIPLINA,'0')) AS CODIGO, "
		
		sql = sql & " CF.ANO_LETIVO, " 
		sql = sql & " CF.SEMESTRE_LETIVO, " 
		sql = sql & " CF.Cod_JustificativaFaltas, " 
		sql = sql & " CF.CodReferencia, " 
		sql = sql & " CF.DATALANCAMENTO, " 
		sql = sql & " CF.DATALANCAMENTOFINAL, " 
		sql = sql & " CF.DataDiaLancamento, " 
		sql = sql & " CF.COD_COLABORADOR, " 
		sql = sql & " CF.TIPO_COLABORADOR, " 
		sql = sql & " CF.COD_TURMA, " 
		sql = sql & " T.NOMETURMA, " 
		sql = sql & " C.NOME, " 
		sql = sql & " D.DESC_DISCIPLINA , " 
		sql = sql & " isnull(CF.COD_DISCIPLINA,'0') as COD_DISCIPLINA , " 
		sql = sql & " CS.NOME AS COLABORADOR_SUBSTITUTO, " 
		sql = sql & " CF.NUMERO_AULA, " 
		sql = sql & " CF.CONTEUDO_SUBSTITUICAO, " 
		sql = sql & " CF.COD_TURNO, " 
		sql = sql & " TUR.DESC_TURNO AS TURNO, " 
		sql = sql & " CF.SITUACAO as STATUS, "
		sql = sql & " isnull(CF.fechamento,'') as fechamento,  "
		sql = sql & " SUM(CONVERT(INT, CF.NUMERO_FALTA)) AS NUMERO_FALTA "
		sql = sql & " from SRH_COLABORADOR_FREQUENCIA CF " 
		sql = sql & " LEFT JOIN SCA_TURMA T ON T.COD_TURMA=CF.COD_TURMA  "
		sql = sql & " INNER JOIN SRH_COLABORADOR C ON C.CODIGO = CF.COD_COLABORADOR " 
		sql = sql & " LEFT JOIN SCA_DISCIPLINA D ON D.COD_DISCIPLINA = CF.COD_DISCIPLINA " 
		sql = sql & " LEFT JOIN SRH_COLABORADOR CS ON CS.CODIGO = CF.COD_COLABORADORSUBSTITUTO " 
		sql = sql & " LEFT JOIN SCA_TURNO TUR ON TUR.Cod_Turno = CF.Cod_Turno " 
		sql = sql & " WHERE CF.COD_EMPRESA = " & session("CodEmpresa")
		sql = sql & " AND CF.TIPO_COLABORADOR <> 'F' "
		if strOptListarFaltas = "1" then
			sql = sql & " and convert(datetime,convert(varchar, cf.DataFalta , 103),103) >= convert(datetime, ' " & strDataInicialModulacao & " ',103)"
			sql = sql & " and convert(datetime,convert(varchar, cf.DataFalta, 103),103) <= convert(datetime, ' " & strDataFinalModulacao & " ',103)"
		else
			sql = sql & " and convert(datetime,convert(varchar, cf.DATALANCAMENTO , 103),103) >= convert(datetime, ' " & strDataInicialModulacao & " ',103)"
			sql = sql & " and convert(datetime,convert(varchar, cf.DATALANCAMENTO, 103),103) <= convert(datetime, ' " & strDataFinalModulacao & " ',103)"
		end if
		sql = sql & " group by " 
		sql = sql & " ANO_LETIVO, " 
		sql = sql & " SEMESTRE_LETIVO, " 
		sql = sql & " CF.Cod_JustificativaFaltas, " 
		sql = sql & " CF.CodReferencia, " 
		sql = sql & " CF.DATALANCAMENTO, " 
		sql = sql & " CF.DATALANCAMENTOFINAL, " 
		sql = sql & " CF.DataDiaLancamento, " 
		sql = sql & " CF.COD_COLABORADOR, " 
		sql = sql & " CF.TIPO_COLABORADOR, " 
		sql = sql & " CF.COD_TURMA, " 
		sql = sql & " T.NOMETURMA, " 
		sql = sql & " C.NOME, " 
		sql = sql & " D.DESC_DISCIPLINA , " 
		sql = sql & " CF.COD_DISCIPLINA ,  "
		sql = sql & " CS.NOME , " 
		sql = sql & " CF.NUMERO_AULA,  "
		sql = sql & " CF.CONTEUDO_SUBSTITUICAO,  "
		sql = sql & " CF.COD_TURNO, " 
		sql = sql & " TUR.DESC_TURNO ,  "
		sql = sql & " CF.SITUACAO , "
		sql = sql & " CF.fechamento "
		sql = sql & " order by NOME " 
		'response.write sql
		rs.open sql, cnn
		if rs.eof = false then
   %>
        <table width = "100%" border="1" cellpadding="0" cellspacing="0" bordercolor="#CCCCCC" class="tabela">
          <tr bgcolor="#E5E5E5">
            <td width="7%" class="celula"><div align="center"><strong>Lan&ccedil;amento</strong></div></td>
            <td width="3%" class="celula"><div align="center"><strong>Tipo </strong></div></td>
            <td width="5%" height="21" class="celula"><div align="center"><strong>Exerc&iacute;cio<span class="TextoForm"></span></strong></div></td>
            <td width="4%" class="celula"><div align="center"><strong>Turma</strong></div></td>
            <td width="3%" class="celula"><div align="center"><strong>Turno</strong></div></td>
            <td width="15%" class="celula"><div align="center"><strong>Professor</strong></div></td>
            <td width="6%" class="celula"><div align="center"><strong>Disciplina</strong></div></td>
            <td width="4%" class="celula"><div align="center"><strong>Falta</strong></div></td>
            <td width="14%" class="celula"><div align="center"><strong>Per&iacute;odo Lan&ccedil;amento</strong></div></td>
            <td width="5%" align="center" class="celula"><div align="center"><strong>Situa&ccedil;&atilde;o</strong></div></td>
            <td width="8%" align="center" class="celula"><div align="center"><strong>Falta Enviada</strong></div></td>
            <td width="16%" align="center" class="celula"><div align="center"><strong class="texto1">Enviar Faltas</strong></div></td>
          </tr>
          <%
		  TotalFaltaLancamento = 0
	   while not rs.eof
	   
			cont = cont + 1	
			strDataLancamento          = formatadataAp(rs("DATALANCAMENTO"))
			strDataLancamentoFinal     = formatadataAp(rs("DATALANCAMENTOFINAL"))
			strDataDiaLancamento	   = formatadataAp(rs("DataDiaLancamento"))
			
			strTipoColaborador         = rs("TIPO_COLABORADOR")
			strNomeTurma 			   = rs("NOMETURMA")
			strNomeColaborador   	   = rs("NOME")
			if not isnull(rs("DESC_DISCIPLINA")) then
				strDescDisciplina          = rs("DESC_DISCIPLINA")
			else
				strDescDisciplina          = "Interdisciplinar"
			end if			
			intNumeroFalta             = rs("NUMERO_FALTA")
			strCodProfessorSubstituto  = rs("COLABORADOR_SUBSTITUTO")
			strNumeroAula              = rs("NUMERO_AULA") 
			strConteudoSubstituicao    = rs("CONTEUDO_SUBSTITUICAO")
			if trim(rs("STATUS")) = "S" then
				strSituacao = "ABONO"
			else
				strSituacao = "-----"
			end if
			if trim(strTipoColaborador) = "P" or trim(strTipoColaborador) = "1" then
			   DescricaoTipoColaborador = "Prof."
			else  
			   DescricaoTipoColaborador = "Func."
			end if   
			AnoLetivo = rs("ANO_LETIVO")
			if rs("SEMESTRE_LETIVO") = "3" then
			   nomeSemestre = "Anual"
			else  
			   nomeSemestre = intSemestre
			end if  
			if trim(rs("fechamento")) = "S" then
				strEnviouFalta = "<strong>Sim</strong>"
				strCorlinha = "C1FFC1"
			else
				strEnviouFalta = "Não"
				strCorlinha = "FFFFFF"
			end if
	
			%>	
			<tr bgcolor="#<%=strCorlinha%>" style="cursor:hand" onmouseover="return linhaMouseOver(this)" onmouseout="return linhaMouseOut(this)">
			<td class="celula" onclick="return resultadoConsulta('<%=rs("CODIGO")%>')">&nbsp;<%=strDataDiaLancamento%></td>
			<td class="celula" onclick="return resultadoConsulta('<%=rs("CODIGO")%>')">&nbsp;<%=DescricaoTipoColaborador%></td>
			<td height="20" class="celula" onclick="return resultadoConsulta('<%=rs("CODIGO")%>')">&nbsp;<%=AnoLetivo%>/<%=nomeSemestre%></td>
			<td height="20" class="celula" onclick="return resultadoConsulta('<%=rs("CODIGO")%>')">&nbsp;<%=strNomeTurma%></td>
			<td height="20" class="celula" onclick="return resultadoConsulta('<%=rs("CODIGO")%>')">&nbsp;<%=rs("TURNO")%></td>
			<td height="20" class="celula" onclick="return resultadoConsulta('<%=rs("CODIGO")%>')">&nbsp;<%=strNomeColaborador%></td>
			<td height="20" class="celula" onclick="return resultadoConsulta('<%=rs("CODIGO")%>')">&nbsp;<%=strDescDisciplina%></td>
			<td height="20" class="celula" onclick="return resultadoConsulta('<%=rs("CODIGO")%>')">
			<div align="center">&nbsp;<%=intNumeroFalta%></div></td>
			<td height="20" class="celula" onclick="return resultadoConsulta('<%=rs("CODIGO")%>')">
			<div align="center">&nbsp;<%=strDataLancamento%> a <%=strDataLancamentoFinal%></div></td>
			<td height="20" align="center" class="celula" onclick="return resultadoConsulta('<%=rs("CODIGO")%>')"><%=strSituacao%></td>
			<td align="center" class="celula" onclick="return resultadoConsulta('<%=rs("CODIGO")%>')"><%=strEnviouFalta%></td>
			<td align="center" class="celula">
			<%if trim(rs("fechamento")) <> "S" then%>
			<a href="#" onclick="enviarFaltas('<%=rs("CODIGO")%>')" ><img src="../../assets/img/botao_azul_normal.gif" alt="Enviar faltas" width="26" height="26" border="0"></a>
			<%else%>
			------
			<%end if%></td>
			<%
			
			TotalFaltaLancamento = TotalFaltaLancamento + intNumeroFalta
			strchave = trim(rs("ANO_LETIVO")) & trim(rs("SEMESTRE_LETIVO")) & trim(rs("Cod_JustificativaFaltas")) & trim(rs("codReferencia")) & trim(rs("DATALANCAMENTO")) & trim(rs("DATALANCAMENTOFINAL")) & trim(rs("DataDiaLancamento")) & trim(rs("COD_COLABORADOR")) 
			rs.movenext
			if rs.eof = false then
				strchave1 = trim(rs("ANO_LETIVO")) & trim(rs("SEMESTRE_LETIVO")) & trim(rs("Cod_JustificativaFaltas")) & trim(rs("codReferencia")) & trim(rs("DATALANCAMENTO")) & trim(rs("DATALANCAMENTOFINAL")) & trim(rs("DataDiaLancamento")) & trim(rs("COD_COLABORADOR")) 
			else
				strchave1 = ""
			end if
			if strchave <> strchave1 then
				%>
                </tr>
                <tr bgcolor="#<%=strCorlinha%>" style="cursor:hand" onmouseover="return linhaMouseOver(this)" onmouseout="return linhaMouseOut(this)">
                <td height="20" colspan="12" align="center" class="celula"><strong>Total de Faltas no Lan&ccedil;amento:&nbsp;<%=TotalFaltaLancamento%></strong></td>
                </tr>
                <%
				TotalFaltaLancamento = 0
			end if
			
				
				
		   wend
		   rs.close
		   %>
          <tr>
            <td height="32" colspan="12" class="celula">Total Registros : <%=cont%></td>
          </table>
          <%
			
	else
		   %>
        <table width = "100%" border="1" cellpadding="0" cellspacing="0" bordercolor="#CCCCCC" class="tabela">
          <tr bgcolor="#E5E5E5">
          <tr>
            <td height="32" colspan="11" class="celula"><div align="center">N&atilde;o h&aacute; lan&ccedil;amento dentro dessa refer&ecirc;ncia</div></td>
          </table>
          <%
	end if   
	
	end if
	
	%></tr>
</table>
                        
                  </div>

            	</div>
       	 	</div>
         	<!-- Fecha o Form -->  
      </div>
       <!-- Fecha o Painel do Formulario -->        
    </div>
    </form>
    <!--/container-->	
		<script>
	function enviarFaltas(CodRegistroMestre){
		
		var men = 'ATENÇÃO: Deseja enviar as faltas desses colaboradores selecionados?'
		if (confirm(men)) {
			frm.action="FaltaColaboradorNovo_cod.asp?enviarFalta=S&acao=ENVIAR&CodRegistroMestre=" + CodRegistroMestre;
			frm.submit();
			return true;
		} else {
			return false;
		}
	}

	function dadosSubstituicao()
	{
		
		var frm = document.getElementById("frm");
		
		if (mostraSubstituicao.style.display=="none"){
			mostraSubstituicao.style.display="block"
			frm.imgDadosPessoais.src="<%=session("strCaminhoRaiz")%>/images/down.jpg"
		}
		else{
			mostraSubstituicao.style.display="none"
			frm.imgDadosPessoais.src="<%=session("strCaminhoRaiz")%>/images/up.jpg"
		}
	}
	
	function resultadoConsulta(intCodigo){
	
		var frm = document.getElementById("frm");
		frm.txtCodigo.value=intCodigo;
		frm.action = "FaltaColaboradorNovo_cad.asp?dtf=";
		frm.submit();
	}
	function reloadDtFinal(){
	
		frm.action = "FaltaColaboradorNovo_cad.asp?dtf=s";
		frm.submit();
	}
	function reloadTpLanc(){
	
		frm.action = "FaltaColaboradorNovo_cad.asp?tpl=s";
		frm.submit();
	}
	function salvar(acao){
		
		var frm = document.getElementById("frm");
		
		if (frm.cmbModulacaoReferencia.value == "0") {
			alert("A Referência deve ser informada!");
			frm.cmbModulacaoReferencia.focus();
			return false;
		}

		if (frm.cmbJustificativaFaltas.value == "0") {
			alert("A Justificativa deve ser informada !");
			frm.cmbJustificativaFaltas.focus();
			return false;
		}

		if (frm.txtDataLancamento.value == "") {
			alert("A Data de Lançamento deve ser informada !");
			frm.txtDataLancamento.focus();
			return false;
		}
		if (frm.txtDataLancamento.value == "0") {
			alert("A Data de Lançamento deve ser informada !");
			frm.txtDataLancamento.focus();
			return false;
		}
		
		
		if (frm.cmbTurnoFaltas.value == "0") {
			alert("O Turno deve ser informado !");
			frm.cmbTurnoFaltas.focus();
			return false;
		}

		if (frm.cmbColaboradorFrequencia.value == "0" && acao!="E" ) {
			alert("O Professor Titular deverá ser informado.");
			frm.cmbColaboradorFrequencia.focus();
			return false;
		}

		if (frm.cmbSimouNao.value == "0") {
			alert("Verifique a situação do Abono do Lançamento!");
			frm.cmbSimouNao.focus();
			return false;
		}

		if (frm.cmbSimouNao.value == "S" && frm.txtJustificativaAbono.value=="") {
			alert("Justificativa do abono deve ser informada!");
			frm.txtJustificativaAbono.focus();
			return false;
		}

		frm.action="FaltaColaboradorNovo_cod.asp?acao=" + acao;
		frm.submit();
		return true;
 	}
	
	function verificaDatas(){
		
		var dtini = document.all.txtDataLancamento.value;
		var dtfim = document.all.txtDataLancamentoFinal.value;
		if (dtfim=="") return true;
		
		if ((dtini == '') && (dtfim == '')) {
			return false;
		}
		
		datInicio = new Date(dtini.substring(6,10), 
							 dtini.substring(3,5), 
							 dtini.substring(0,2));
		datInicio.setMonth(datInicio.getMonth() - 1); 
		
		
		datFim = new Date(dtfim.substring(6,10), 
						  dtfim.substring(3,5), 
						  dtfim.substring(0,2));
						 
		datFim.setMonth(datFim.getMonth() - 1); 
	
		if(datInicio <= datFim){
			reloadDtFinal();
			return true;
		} else {
			alert('ATENÇÃO: Data Inicial é maior que Data Final');
			document.all.txtDataLancamentoFinal.focus();
			document.all.txtDataLancamentoFinal.select();
			return false;
		}    
	}
</script>
    <!--=== End Content Part ===-->
   	<!--#include file="../RodapeModulo.asp"-->
	<!--#include file="../jsModulo.asp"-->
</body>
</html> 