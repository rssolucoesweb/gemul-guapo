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
	sql = "UPDATE SRH_COLABORADOR_FREQUENCIA SET FECHAMENTO = 'S' "
	sql = sql & " WHERE (FECHAMENTO = 'N' or ISNULL(FECHAMENTO,'0') = '0') and Fechamento_devolvido is null "
	sql = sql & " and codReferencia in "
	sql = sql & " ("
	sql = sql & " select codigo from SRH_MODULACAO_REFERENCIA"
	sql = sql & " where dateadd(day,1,data_final) <= getdate()"
	sql = sql & " )"
	cnn.execute sql
	
	strPaginaTitulo                  			= "FaltaFuncionario_cad.asp"
	strPagina						 			= "FaltaFuncionario_cad.asp"
	strExecutarSubmitModulacaoReferencia        = "S"

	strExecutarSubmitProfessorTurma             = "S"
	strExecutarSubmitTurma	 		            = "S"
	strExecutarSubmitDisciplinaProfessorTurma   = "S"
	strSimouNao_submit                          = "S"
	strExecutarSubmitColaborador				= "S"
	strExecutarSubmitColaboradorFrequencia		= "S"

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
	if strOptListarFaltas = "" then strOptListarFaltas = "1"

	if strSimouNao = "" or strSimouNao = "0" then strSimouNao = "N"
	
	strDesabilitaIncluir	= "" 'Desabilita o botão Incluir
	strDesabilitaAlterar 	= "disabled" 'Desabilita o botão Excluir
	strDesabilitaExcluir	= "disabled" 'Desabilita o botão Excluir

	if intCodigo <> "" and intCodigo <> "0"  then
	
		cont =0
		sql = " SELECT CODIGO, "
		sql = sql & " ANO_LETIVO, "
		sql = sql & " Cod_JustificativaFaltas, "
		sql = sql & " SEMESTRE_LETIVO, "
		sql = sql & " DATALANCAMENTO, "
		sql = sql & " DATALANCAMENTOFINAL, "
		sql = sql & " DataDiaLancamento, "
		sql = sql & " TIPO_COLABORADOR, "
		sql = sql & " COD_TURMA, "
		sql = sql & " COD_COLABORADOR, "
		sql = sql & " COD_DISCIPLINA, "
		sql = sql & " NUMERO_FALTA, "
		sql = sql & " JUSTIFICATIVA, "
		sql = sql & " COD_COLABORADORSUBSTITUTO, "
		sql = sql & " NUMERO_AULA, "
		sql = sql & " CONTEUDO_SUBSTITUICAO, COD_TURNO,"
		sql = sql & " SITUACAO as STATUS, "
		sql = sql & " JUSTIFICATIVA_ABONO, tipoLancamento, codReferencia, "
		sql = sql & " FECHAMENTO "
		sql = sql & " from SRH_COLABORADOR_FREQUENCIA "
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
			strOptTipoColaborador     					= Trim(rs("TIPO_COLABORADOR"))
			strJustificativaAbono    					= Trim(rs("JUSTIFICATIVA_ABONO"))
			strJustificativa          					= Trim(rs("JUSTIFICATIVA"))
			strSimouNao               					= trim(rs("STATUS"))
			strFechamento             					= trim(rs("FECHAMENTO"))
			intAnoLetivo								= trim(rs("ANO_LETIVO"))
			strAnoLetivo								= trim(rs("ANO_LETIVO"))
			intSemestre									= trim(rs("SEMESTRE_LETIVO"))
			
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
    <form id="frm" method="post" action="FaltaFuncionario_cad.asp">
    <input name="dtf" type="hidden" id="dtf" class="text" size="10" value="<%=request("dtf")%>" >
    <input name="tpl" type="hidden" id="tpl" class="text" size="10" value="<%=request("tpl")%>" >
    <div class="container content">		
    
      <!-- Grey Panel -->            
      <div class="panel panel-grey">
        <div class="panel-heading">
        	<h3 class="panel-title"><i class="fa fa-tasks"></i>Lançamento de Faltas dos Funcionários</h3>
        </div>
        <!-- Inicia o Painel do Formulario -->     
        <div class="panel-body">
             <!-- Inicia o Form -->     
            <div class="panel-body">                                                        
                
                <div class="form-group">
            	
                	<table width="98%" border="0" cellspacing="0"  align="center" cellpadding="0">
  <tr>
    <td width="245" class="texto1">&nbsp;</td>
    <td width="1062"><input name="txtCodigo" type="hidden" id="txtCodigo" class="text" size="10" value="<%=intCodigo%>" maxlength="10"></td>
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

  </tr>
  <tr>
    <td height="27" class="texto1">Data Inicial do Lan&ccedil;amento</td>
    <td class="texto1"><input name="txtDataLancamento" type="text" class="text" id="txtDataLancamento" onblur="return validaData(this)" onkeypress="return formataCampo(this, 3, 10)" size="11" maxlength="10" value="<%=strDataLancamento%>"  onChange='reloadDtFinal()' title="Click aqui para visualizar o calend&aacute;rio"></td>
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

	if strDataLancamento <> "" and intCodModulacaoReferencia <> "0" and intCodModulacaoReferencia <> "" and intCodigo ="" then

		if cCur(strComparaDataLancamento) < cCur(strComparaDataInicialModulacao) then
			%>
			<script>
				alert("ATENÇÃO: A data informada não confere com o período de referência. Verifique!");
				//window.location='FaltaFuncionario_Cad.asp';
			</script>
			<% 
			
			strDataLancamento = formataDataAP(strDataInicialModulacao)
			strDataLancamentoFinal = formataDataAP(strDataFinalModulacao)
		  	'response.end
		else
			if cCur(strComparaDataLancamento) > cCur(strComparaDataFinalModulacao) then
				%>
				<script>
					alert("ATENÇÃO: A data informada não confere com o período de referência. Verifique!");
					//window.location='FaltaFuncionario_Cad.asp';
				</script>
				<% 
				strDataLancamento = formataDataAP(strDataInicialModulacao)
				strDataLancamentoFinal = formataDataAP(strDataFinalModulacao)
			  	'response.end
			end if
		end if
	end if
	if strDataLancamento <> "" and intCodModulacaoReferencia <> "0" and intCodModulacaoReferencia <> "" then
		if strComparaDataLancamentoFinal<>"" and strComparaDataInicialModulacao<>"" then
			if cCur(strComparaDataLancamentoFinal) < cCur(strComparaDataInicialModulacao) then
				%>
				<script>
					alert("ATENÇÃO: A data informada não confere com o período de referência. Verifique!");
					//window.location='FaltaFuncionario_Cad.asp';
				</script>
				<% 
				strDataLancamento = formataDataAP(strDataInicialModulacao)
				strDataLancamentoFinal = formataDataAP(strDataFinalModulacao)
				'response.end
			end if
		end if
	end if
	%>
    <tr>
        <td height="27" class="texto1">Data Final do Lan&ccedil;amento</td>
        <td class="texto1"><input <%=bloqcampodatafinal%> name="txtDataLancamentoFinal" type="text" class="<%=classcampodatafinal%>" id="txtDataLancamentoFinal" onblur="validaData(this);verificaDatas();" onkeypress="return formataCampo(this, 3, 10)" size="11" maxlength="10" value="<%=strDataLancamentoFinal%>" title="Click aqui para visualizar o calend&aacute;rio"></td>
    </tr>
    <tr>
        <td height="27" class="texto1"> Titular</td>
        <td class="texto1"><!--#include file="../includes/inc_cmdFuncionarioFaltasModulacao.asp" -->
        &nbsp;Colaborador que receber&aacute; as Faltas </td>
    </tr>
    <input  <% if strOptTipoColaborador = "1" then response.Write("checked")%> name="optTipoColaborador" type="hidden" value="1" onClick='submit()'>
        <input <% if strOptTipoColaborador = "0" then response.Write("checked")%> name="optTipoColaborador" type="hidden" value="0" onClick='submit()'>
        <input <%if strTipoLancamento = "D" then response.Write("checked")%>  type="hidden" name="optTipoLancamento" id="optTipoLancamento" value="D" onclick="reloadTpLanc()">
        <input type="hidden" <%if strTipoLancamento = "I" then response.Write("checked")%> name="optTipoLancamento" id="optTipoLancamento" value="I"  onClick="reloadTpLanc()">

  <% 
  if strFuncionarioModular = "S" and intCodProfessor <> "" and intCodProfessor <> "0" then
		sql = " select distinct Situacao_disciplinar, tipoModulacao, M.Ano_Letivo, M.Semestre "
		sql = sql & " from SRH_MODULACAO_DISCIPLINAR_DOCENTE M " 
		sql = sql & " where M.Cod_Colaborador = " & intCodProfessor 
		sql = sql & " and M.Status = 'A' "
		rs.open sql, cnn
		if rs.eof = false then
		    if trim(rs("tipoModulacao")) = "PROFESSOR" then
				strOptTipoColaborador 	= "1"
			else
				strOptTipoColaborador 	= "0"
			end if
			strTipoLancamento 		= rs("Situacao_disciplinar")
			intAnoLetivo			= rs("Ano_Letivo")
			strAnoLetivo			= rs("Ano_Letivo")
			intSemestre				= rs("Semestre")
			''strDesabilitaIncluir	= "" 'Desabilita o botão Incluir
			''strDesabilitaAlterar 	= "disabled" 'Desabilita o botão Excluir
			''strDesabilitaExcluir	= "disabled" 'Desabilita o botão Excluir
		else
			%>
			<script>
				alert("ATENÇÃO: Funcionário ainda não modulado. Verifique!");
				window.location='FaltaFuncionario_Cad.asp';
			</script>
			<%
			response.end 
		end if	
		rs.close

		sql = " select TOP 1 COD_TURNO, COD_FUNCAO "
		sql = sql & " from SRH_MODULACAO_DISCIPLINAR_DOCENTE " 
		sql = sql & " where Status = 'A' and Cod_Colaborador = " & intCodProfessor 
		sql = sql & " ORDER BY ANO_LETIVO "
		rs.open sql, cnn
		if rs.eof = false then
			strCodFuncaoFuncionario 		= rs("COD_FUNCAO")
			strCodTurnoFuncionario			= rs("COD_TURNO")
		end if	
		rs.close
  end if
  if intCodProfessor <> "" and intCodProfessor <> "0"  then
		
		if intCodModulacaoReferencia <> "" then
		
			sql = "select AnoReferencia, SemestreReferencia from SRH_MODULACAO_REFERENCIA WHERE CODIGO = " & intCodModulacaoReferencia
			rs.open sql, cnn
			if rs.eof = false then
				strAnoLetivoReferencia  = rs("AnoReferencia")
				intSemestreReferencia 	= rs("SemestreReferencia")
			end if
			rs.close
			
			if intAnoLetivo = strAnoLetivoReferencia and intSemestre = intSemestreReferencia then
				'Será permitido o lancamento, pois a modulação confere com o período de referencia escolhido.
			else
				%>
				<script>
					alert("ATENÇÃO: Período de REFERÊNCIA não confere com Período de MODULAÇÃO. Verifique!");
					window.location='FaltaFuncionario_Cad.asp';
				</script>
				<%
				response.end 
			end if	
	
		end if

	end if
%>
<input name="txtCodFuncaoFuncionario" type="hidden" id="txtCodFuncaoFuncionario" class="text" size="10" value="<%=strCodFuncaoFuncionario%>" >
<input name="txtCodTurnoFuncionario" type="hidden" id="txtCodTurnoFuncionario" class="text" size="10" value="<%=strCodTurnoFuncionario%>" >
  <input name="txtAnoLetivo" type="hidden" class="text" id="txtAnoLetivo"  value="<%=intAnoLetivo%>">
  <input name="cmbSemestre" type="hidden" class="text" id="cmbSemestre"  value="<%=intSemestre%>"></td>
<%

  if intQtdeFalta <> "0" or Trim(Request("txtJustificativa")) <> "" then
  		if strSimouNao = "S" then 
			strJustificativa=""
		else%>
  <tr>
    <td height="27" class="texto1">Justificativa de Falta</td>
    <td class="texto1"><textarea name="txtJustificativa" cols="60" rows="3" class="text" id="txtJustificativa"><%=strJustificativa%></textarea>
      - Opcional</td>
  </tr>
 	 <% end if %>
   <tr style="display:none">
    <td height="27" class="texto1">Abonar Lan&ccedil;amento? </td>
    <td><!--#include file="../includes/inc_cmbSimouNao.asp" --></td>
  </tr>
  <% end if %>
  <tr>
  <% if strSimouNao = "S" or Trim(Request("txtJustificativaAbono")) <> ""  then %>
    <td height="27" class="texto1">Justificativa do Abono</td>
    <td class="texto1"><textarea name="txtJustificativaAbono" cols="60" rows="3" class="text" id="txtJustificativaAbono"><%=strJustificativaAbono%></textarea>- Descreva o(s) documento(s) que ser&aacute;(&atilde;o) apresentado(s) para justificar o  abono.</td>
  </tr>
  <% end if %>
  <tr>
    <td height="13" class="texto1">&nbsp;</td>
    <td>&nbsp;</td>
  </tr>
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
		sql = sql & " and COD_COLABORADOR = CF.COD_COLABORADOR) AS CODIGO, "
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
		sql = sql & " LEFT JOIN SRH_TURNO TUR ON TUR.Cod_Turno = CF.Cod_Turno " 
		sql = sql & " WHERE CF.TIPO_COLABORADOR = 'F' and cf.CodColaboradorJustificativa is null and CF.COD_EMPRESA = " & session("CodEmpresa")
		if strOptListarFaltas = "1" then
			sql = sql & " and convert(datetime,convert(varchar, cf.DataFalta , 103),103) >= convert(datetime, ' " & strDataInicialModulacao & " ',103)"
			sql = sql & " and convert(datetime,convert(varchar, cf.DataFalta, 103),103) <= convert(datetime, ' " & strDataFinalModulacao & " ',103)"
		else
			sql = sql & " and convert(datetime,convert(varchar, cf.DataDiaLancamento , 103),103) >= convert(datetime, ' " & strDataInicialModulacao & " ',103)"
			sql = sql & " and convert(datetime,convert(varchar, cf.DataDiaLancamento, 103),103) <= convert(datetime, ' " & strDataFinalModulacao & " ',103)"
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
			if trim(strTipoColaborador) = "F" then
			   DescricaoTipoColaborador = "Func."
			else  
			   DescricaoTipoColaborador = "Prof."
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
			frm.action="FaltaFuncionario_cod.asp?enviarFalta=S&acao=ENVIAR&CodRegistroMestre=" + CodRegistroMestre;
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
		frm.action = "FaltaFuncionario_cad.asp?dtf=";
		frm.submit();
	}
	function reloadDtFinal(){
	
		frm.action = "FaltaFuncionario_cad.asp?dtf=s";
		frm.submit();
	}
	function reloadTpLanc(){
	
		frm.action = "FaltaFuncionario_cad.asp?tpl=s";
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
		
		if (frm.txtDataLancamentoFinal.value == "") {
			alert("A Data de Lançamento Final deve ser informada !");
			frm.txtDataLancamentoFinal.focus();
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

		frm.action="FaltaFuncionario_cod.asp?acao=" + acao;
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
</script>    <!--=== End Content Part ===-->
   	<!--#include file="../RodapeModulo.asp"-->
	<!--#include file="../jsModulo.asp"-->
</body>
</html> 