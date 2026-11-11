<!--#include file="../ConfigModulo.asp"-->
<!--#include file="../../includes/inc_cnn.asp"-->
<!--#include file="../../includes/inc_formatadata.asp"-->
<!--#include file="../../includes/inc_formataCPF.asp"-->
<!--#include file="../../js/Calendario/Calendario.asp"-->
<!--#include file="../menuModulos.asp"-->
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
	
	' Inativa todas as Modulacoes Vencidas vencidas
	sql = " Update SRH_MODULACAO_DISCIPLINAR_DOCENTE "
	sql = sql & " set status = 'I' "
	sql = sql & " where convert(datetime,convert(varchar, DataFinal, 103),103) < convert(datetime, ' " & date & "',103) "
	cnn.execute sql

	' Inativa todas as substituicoes vencidas
	sql = " Update SRH_COLABORADOR_SUBSTITUTO "
	sql = sql & " set SITUACAO = 'I' "
	sql = sql & " where Cod_Grupo = " & Session("CodGrupo")
	sql = sql & " and convert(datetime,convert(varchar, DataFinal, 103),103) < convert(datetime, ' " & date & "',103) "
	sql = sql & " and SITUACAO = 'A' "
	cnn.execute sql

	strPagina						= "ColaboradorSubstitutoNovo_cad.asp"
	strPaginaTitulo					= "ColaboradorSubstitutoNovo_cad.asp"
	intCodCodSubistituicao			= Trim(Request("txtCodCodSubistituicao"))
	strSituacaoSubstituicao			= Trim(Request("cmbSituacaoSubstituicao"))
	strSituacaoSubstituicao			= Trim(Request("cmbSituacaoSubstituicao"))

	strDesabilitaIncluir 	= "" ' Desabilita o botão Incluir
	strDesabilitaAlterar 	= "disabled" ' Desabilita o botão Alterar
	strDesabilitaExcluir 	= "disabled" ' Desabilita o botão Excluir
	strDesabilitaLimpar  	= "" ' Habilita o Botão Limpar
	
	intCodigo						= Trim(Request("txtCodigo"))
	strAnoLetivo 					= session("strAnoLetivo")
	strSemestre 					= session("strSemestre")
	
	' Colaborador Substituto
	intCodEmpresaSubstituto			= Trim(Request("txtCodEmpresaSubstituto"))
	intCodColaboradorSubstituto		= Trim(Request("txtCodColaboradorSubstituto"))
	strNomeColaboradorSubstituto	= Trim(Request("txtNomeColaboradorSubstituto"))
	
	'Colaborador Substituido
	intCodEmpresaSubstituido			= Trim(Request("txtCodEmpresaSubstituido"))
	intCodColaboradorSubstituido		= Trim(Request("txtCodColaboradorSubstituido"))
	strNomeColaboradorSubstituido		= Trim(Request("txtNomeColaboradorSubstituido")) 
	situacaoAlteracao = ""

	strDataInicial						= Trim(Request.Form("txtDataInicial")) 
	strDataFinal						= Trim(Request.Form("txtDataFinal")) 

	strCPF  							= Trim(Request.Form("txtcpf"))
	intCodFuncional						= Trim(Request.Form("txtCodigoFuncional"))

	intCodFuncional1  					= Trim(Request.Form("txtCodigoFuncional1"))
	intCodFuncional2  					= Trim(Request.Form("txtCodigoFuncional2"))

	intCodTurnoColaboradorSubstituido	= Trim(Request.Form("cmbTurnoColaboradorSubstituido"))
	if intCodTurnoColaboradorSubstituido = "" then intCodTurnoColaboradorSubstituido = "0"

	' Consulta os dados da Subistituição
	if trim(intCodCodSubistituicao) <> "" then
		
		sql = " SELECT CodEmpresaSubstituto, CodColaboradorSubstituto, CodEmpresaSubstituido, CodColaboradorSubstituido, DataInicial, DataFinal, CB.Situacao  "
		sql = sql & " FROM SRH_COLABORADOR_SUBSTITUTO CB"
		sql = sql & " WHERE CB.Situacao = 'A' "
		sql = sql & " AND Cod_Grupo = " & Session("CodGrupo")
		sql = sql & " AND Codigo = " & intCodCodSubistituicao
		'response.write sql
		rs.open sql, cnn
		if rs.eof = false then
			
			' Colaborador Substituto
			intCodEmpresaSubstituto			= Trim(rs("CodEmpresaSubstituto"))
			intCodColaboradorSubstituto		= Trim(rs("CodColaboradorSubstituto"))
			
			'Colaborador Substituido
			intCodEmpresaSubstituido		= Trim(rs("CodEmpresaSubstituido"))
			intCodColaboradorSubstituido	= Trim(rs("CodColaboradorSubstituido"))

			strDataInicial    				= formatadataAP(rs("DataInicial"))
			strDataFinal     				= formatadataAP(rs("DataFinal"))
			strSituacaoSubstituicao			= Trim(rs("situacao"))

			strDesabilitaIncluir 	= "disabled" ' Desabilita o botão Incluir
			strDesabilitaAlterar 	= "" ' Desabilita o botão Alterar
			strDesabilitaExcluir 	= "disabled" ' Desabilita o botão Excluir
			strDesabilitaLimpar  	= "" ' Habilita o Botão Limpar
			
			situacaoAlteracao = "ALTERACAO"
		end if 
		rs.close
		
	end if
	
	' Consulta dados do Colaborador Substituto
	' Pelo codigo funcional
	if Trim(Request.Form("LocalizarMatricula1")) = "S" and intCodFuncional1 <> "" then
	
		sql = "SELECT * "
		sql = sql & " FROM 	SRH_COLABORADOR"
		sql = sql & " Where CodFuncional = " & intCodFuncional1
		sql = sql & " And total_aulas  > 0"
		sql = sql & " And Situacao = 'A'"
		'response.Write(sql)		
		rs.open sql, cnn
		if rs.eof = false then
			intCodColaboradorSubstituto		= Trim(Rs("codigo"))
			intCodEmpresaSubstituto			= Trim(rs("codLotacao"))
			strNomeColaboradorSubstituto	= Trim(Rs("nome"))
			strCPF  						= formataCPFap(Trim(Rs("CPF")))
			intCodFuncional					= Trim(Rs("CodFuncional"))
            if rs("email") <> "" and isnull(rs("email")) = false then
                strEmail                    = trim(rs("email"))
            end if
		else
		%>
		<script>
			alert("Matrícula não Localizada, colaborador não contempla as regras para modulação. Verifique!")
			window.navigate('ColaboradorSubstitutoNovo_cad.asp')
		</script>
	    <%
		response.end	
		end if
		rs.close
	end if
	
	' Pelo codigo do colaborador
	if trim(intCodColaboradorSubstituto) <> "" then

		sql = "SELECT  * "
		sql = sql & " FROM SRH_COLABORADOR "
		sql = sql & " Where Codigo = " & intCodColaboradorSubstituto
	
		rs.open sql, cnn
		if rs.eof = false then
			intCodColaboradorSubstituto		= Trim(rs("codigo"))
			intCodEmpresaSubstituto			= Trim(rs("codLotacao"))
			strNomeColaboradorSubstituto	= Trim(Rs("nome"))
			strCPF  						= formataCPFap(Trim(Rs("CPF")))
			intCodFuncional					= Trim(Rs("CodFuncional"))
            if rs("email") <> "" and isnull(rs("email")) = false then
                strEmail                    = trim(rs("email"))
            end if
		end if 
		rs.close
		
	end if

	
	' Consulta dados do Colaborador Substituido
	' Pelo codigo funcional
	if Trim(Request.Form("LocalizarMatricula2")) = "S" and intCodFuncional2 <> "" then
	
		sql = "SELECT * "
		sql = sql & " FROM 	SRH_COLABORADOR"
		sql = sql & " Where CodFuncional = " & intCodFuncional2
		sql = sql & " And total_aulas  > 0"
		sql = sql & " And Situacao = 'A'"
		rs.open sql, cnn
		if rs.eof = false then
			intCodColaboradorSubstituido		= Trim(Rs("codigo"))
			intCodEmpresaSubstituido			= Trim(rs("codLotacao"))
			strNomeColaboradorSubstituido		= Trim(Rs("nome"))
			intCodTurnoColaboradorSubstituido	= Trim(rs("CodTurno"))
		else
		%>
		<script>
			alert("Matrícula não Localizada, colaborador não contempla as regras para modulação. Verifique!")
			window.navigate('ColaboradorSubstitutoNovo_cad.asp')
		</script>
	    <%
		response.end	
		end if
		rs.close
	end if
	
	' Pelo codigo do colaborador
	situacao_disciplinar_colaborador = ""
	if trim(intCodColaboradorSubstituido) <> "" then
		
		sql = "SELECT  c.nome, c.codigo, f.situacao_disciplinar "
		sql = sql & " FROM SRH_COLABORADOR c inner join srh_funcaocolaborador f on f.Cod_Funcao = c.codfuncao "
		sql = sql & " Where c.Codigo = " & intCodColaboradorSubstituido
		rs.open sql, cnn
		if rs.eof = false then
			strNomeColaboradorSubstituido		= Trim(Rs("nome"))
			intCodColaboradorSubstituido		= Trim(Rs("codigo"))
			situacao_disciplinar_colaborador  	= rs("situacao_disciplinar")
		end if 
		rs.close
		
	end if
	
	if session("codGrupo") = "2" then
		paginaConsultaSbstituido = "ColaboradorSubstituido_con.asp"
	else
		paginaConsultaSbstituido = "ColaboradorSubstituidoModulacao_con.asp"
	end if
	if strSituacaoSubstituicao = "0" or strSituacaoSubstituicao = "" then strSituacaoSubstituicao = "A"
%>

    <!--=== Content Part ===-->
    <div class="container content">		
    <input name ="txtHiddenEmailColaboradorSubstituto" type="hidden" value="<%=strEmail%>" />
      <!-- Grey Panel -->            
      <div class="panel panel-grey">
        <div class="panel-heading">
        	<h3 class="panel-title"><i class="fa fa-tasks"></i>Colaborador Substituto - Modulação</h3>
        </div>
        <!-- Inicia o Painel do Formulario -->     
        <div class="panel-body">
             <!-- Inicia o Form -->     
            <div class="panel-body">                                                        
                <form id="frm" name="frm" method="post">
        		<input type="hidden" name="txtMensagemJaExiste" id="txtMensagemJaExiste" value="" />
                

                  <div class="form-group">
                    	
                  <!-- INICIO PAGINA	-->
                  
                    <table width="100%" height="355" border="0"  class="CorFundo" cellpadding="0" cellspacing="0">
                        <input name ="txtHiddenEmailColaboradorSubstituto" type="hidden" value="<%=strEmail%>" />
                      <tr valign="top">
                        <td>
                        <table width="100%"  height="325" border="0" cellspacing="0" cellpadding="0">
                          <tr valign="top">
                            <td colspan="2" align="center">
                            <form id="frm" name="frm" method="post">
                            <input type="hidden" name="txtMensagemJaExiste" id="txtMensagemJaExiste" value="" />
                            <!-- INICIO PAGINA	-->
                                <table width="100%" align="center">
                              <tr>
                                <td class="titulo1" align="center" colspan="4">&nbsp;</td>
                              </tr>
                              <tr>
                                <td class="titulo1" align="center" colspan="4"><strong><font size="3">Colaborador Substituto - Modulação</font></strong></td>
                              </tr>
                            
                             
                              <tr>
                                <td height="20" colspan="4" bgcolor="#CCCCCC" class="texto" ><strong> Colaborador Substituto</strong></td>
                                </tr>
                              <tr>
                                <td class="label" ><span class="TextoForm">Nome:</span></td>
                                <td width="46%" class="titulo1"><span class="TextoForm">
                                  <input name="txtCodigo" value="<%=intCodigo%>" type="hidden" id="txtCodigo" >
                                  <input name="txtCodCodSubistituicao" value="<%=intCodCodSubistituicao%>" type="hidden" id="txtCodCodSubistituicao" >
                                  <input name="txtCodEmpresaSubstituto" value="<%=intCodEmpresaSubstituto%>" type="hidden" id="txtCodEmpresaSubstituto" >
                                  <input name="txtCodColaboradorSubstituto" value="<%=intCodColaboradorSubstituto%>" type="hidden" id="txtCodColaboradorSubstituto" >
                                  <input name="txtNomeColaboradorSubstituto" type="text" class="text" id="txtNomeColaboradorSubstituto" size="50" readonly maxlength="70" value="<%=strNomeColaboradorSubstituto%>">
                                  <a  href="#" onclick="return abreConsulta('ColaboradorSubstituto_con.asp')" onmouseout="MM_swapImgRestore()" onmouseover="MM_swapImage('Image7','','<%=session("strCaminhoRaiz")%>/images/botao_verde_over.gif',1)"><img alt="Clique para consultar o Colaborador Substituto" src="<%=session("strCaminhoRaiz")%>/images/botao_verde_normal.gif" name="Image7" width="26" height="26" border="0"  align="absmiddle" ></a></span></td>
                                <td width="16%" class="titulo1"><span class="TextoForm"><strong>Matr&iacute;cula Funcional</strong></span>:</td>
                                <td width="29%" class="titulo1"><span class="TextoForm">
                                  <input name="txtCodigoFuncional1" type="text" class="text" id="txtCodigoFuncional1" size="12" maxlength="8" value="<%=intCodFuncional1%>"  onKeyPress="return formataCampo(this, 2, 8)">
                                  &nbsp;<strong>*</strong>
                                  <input type="checkbox" name="LocalizarMatricula1" value="S" onClick='submit()'>
                    Localizar?</span></td>
                              </tr>
                              <tr>
                                <td class="label" >CPF:</td>
                                <td colspan="3" class="titulo1">
                                <input name="txtcpf" type="text" class="text" id="txtcpf" size="15" readonly maxlength="70" value="<%=strCPF%>">            </td>
                              </tr>
                              <tr>
                                <td class="label" >&nbsp;</td>
                                <td colspan="3" class="titulo1">
                                  <input name="txtCodigoFuncional" type="hidden"  class="text" id="txtCodigoFuncional" readonly size="12" maxlength="8" value="<%=intCodFuncional%>" >            </td>
                              </tr>
                              <tr>
                               <td colspan="4" class="titulo1">
                             <%
                            if trim(intCodColaboradorSubstituto) <> "" then
                             
                                cont = 0
                                sql = "select dd.Codigo, dd.Situacao_disciplinar, t.desc_turno as turno, tur.desc_turno as Desc_turno_opcional, dd.Ano_letivo, dd.Semestre, e.RAZAOSOCIAL, (Case when dd.Situacao_disciplinar = 'I' then 21 else dd.Total_Aulas end) as Total_Aulas, "
                                sql = sql & " p.descricao as periodo, d.Desc_Disciplina as disciplina, dd.status, dd.Total_Aulas as saldo, "
                                sql = sql & " f.Desc_Funcao as funcao, isnull(dd.Cod_Substituicao,'0') as Cod_Substituicao "
                                sql = sql & " from SRH_MODULACAO_DISCIPLINAR_DOCENTE dd "
                                sql = sql & " inner join SEG_EMPRESA e on e.CODIGO = dd.Cod_empresa "
                                sql = sql & " left join SRH_FUNCAOCOLABORADOR f on f.cod_funcao = dd.cod_funcao"
                                sql = sql & " left join SCA_disciplina d on d.cod_disciplina = dd.cod_disciplina"
                                sql = sql & " left join SCA_periodo p on p.cod_periodo = dd.cod_periodo"
                                sql = sql & " left join SRH_TURNO t on t.cod_turno = dd.cod_turno"
                                sql = sql & " left join SRH_TURNO tur on tur.cod_turno = dd.cod_turno_opcional "
                                sql = sql & " where dd.Cod_Colaborador = " & intCodColaboradorSubstituto
                                sql = sql & " and dd.ano_letivo = " & strAnoLetivo
                                sql = sql & " and dd.status = 'A'"
                                sql = sql & " order by dd.codigo"
                                rs.open sql, cnn
                                if rs.eof = false then
                                    %>
                                  <table width = "100%" border="1" align="center" cellpadding="0" cellspacing="0" class="tabela">
                                    <tr bgcolor="#E5E5E5" class="celula">
                                      <td height="21" colspan="11" class="celula"><div align="center"><strong>Modula&ccedil;&atilde;o Disciplinar / Substituto - <%=strNomeColaboradorSubstituto%></strong></div></td>
                                      </tr>
                                    <tr bgcolor="#E5E5E5" class="celula">
                                      <td class="celula">Unidade</td>
                                    <td class="celula">Fun&ccedil;&atilde;o</td>
                                    <td width="59" height="26" class="celula">Per&iacute;odo</td>
                                    <td width="36" class="celula">Turno</td>
                                    <td width="29" class="celula">Ano</td>
                                    <td width="71" class="celula">Semestre</td>
                                    <td class="celula">Sit. Disciplinar</td>
                                    <td class="celula">Disciplina</td>
                                    <td class="celula">Total<br>
                                      Modulado</td>
                                    <td class="celula">Origem</td>
                                    </tr>
                                    <%
                                    while not rs.eof
                                       cont = cont + 1	
                                       Asubstituir = trim(request.Form("txt"& rs("codigo")&cont)) 
                                       strSituacaoDisciplinar = rs("Situacao_disciplinar")
                                       strSituacaoCampo = ""
                                       classCampo 		= "text"
                                       if strSituacaoDisciplinar = "D" then strSituacaoDisciplinar = "Disciplinar"
                                       if strSituacaoDisciplinar = "I" then 
                                            strSituacaoDisciplinar = "Interdisciplinar"
                                            strSituacaoCampo = "readonly"
                                            classCampo = "textDisabled"
                                       end if
                                       if rs("saldo") = 0 then
                                            strSituacaoCampo = "disabled"
                                            classCampo = "textDisabled"				   	
                                       end if
                                       strMsgSemestre = trim(rs("Semestre"))
                                       if strMsgSemestre = "3" then strMsgSemestre = "Anual"
                    
                                        TotalAulasSubstituidas = "0"
                                        sql = " select isnull(sum(MD.Total_Aulas),'0') as Total_Aulas_Substituidas "
                                        sql = sql & " from SRH_MODULACAO_DISCIPLINAR_DOCENTE MD"  
                                        sql = sql & " INNER JOIN SRH_COLABORADOR_SUBSTITUTO CS ON CS.Codigo = MD.Cod_Substituicao "
                                        sql = sql & " where MD.Cod_Modulacao_Substituicao = " & trim(rs("Codigo")) 
                                        sql = sql & " AND CS.Situacao = 'A' " 
                                        'response.write sql 
                                        rs1.open sql, cnn, 3, 3
                                        if rs1.eof = false then
                                            TotalAulasSubstituidas = trim(rs1("Total_Aulas_Substituidas")) 
                                        end if
                                        rs1.close
                                        
                                        turno = rs("turno")
                                        
                                        if not isnull(rs("Desc_turno_opcional")) then
                                            turno = rs("Desc_turno_opcional")
                                        end if
                                        
                                        if rs("Cod_Substituicao") = "0" then 
                                           strorigem = "CONTRATUAL"	
                                        else				
                                           strorigem = "SUBSTITUICAO"	
                                        end if
                    
                                       %>
                                       <tr bgcolor="#FFFFFF" class="celula" >
                                         <td width="389" class="celula9">&nbsp;<%=trim(rs("RAZAOSOCIAL"))%></td>
                                       <td width="108" class="celula9">&nbsp;<%=trim(rs("funcao"))%></td>
                                       <td height="26" class="celula9">&nbsp;<%=trim(rs("periodo"))%></td>
                                       <td class="celula9">&nbsp;<%=trim(turno)%></td>
                                       <td height="26" class="celula9">&nbsp;<%=trim(rs("Ano_letivo"))%></td>
                                       <td height="26" class="celula9">&nbsp;<%=trim(strMsgSemestre)%></td>
                                       <td width="87" class="celula9">&nbsp;<%=strSituacaoDisciplinar%></td>
                                       <td width="281" height="26" class="celula9">&nbsp;<%=trim(rs("disciplina"))%></td>
                                       <td width="59" class="celula9">
                                         <div align="center"><%=trim(rs("Total_Aulas"))%>&nbsp;</div></td>
                                       <td width="171" class="celula9">&nbsp;<strong><%=trim(strorigem)%></strong></td>
                                       </tr>
                                       <%				
                                       rs.movenext
                                    wend
                                    %>
                                    </table>
                                    <br>
                                    <%
                                else 
                                    strDesabilitaIncluir 	= "disabled" ' Desabilita o botão Incluir
                                    strDesabilitaAlterar 	= "disabled" ' Desabilita o botão Alterar
                                    %>
                                    <script>
                                        alert("Colaborador Substituido ainda não Modulado. Verifique!")
                                    </script>
                                    <%
                                end if
                                rs.close
                        
                             end if
                             %> 
                             </td>
                             </tr>
                              <tr>
                                <td   height="20" colspan="4" bgcolor="#CCCCCC" class="texto"  ><strong> Colaborador Substituido</strong></td>
                              </tr>
                              <tr>
                                <td><span class="TextoForm">Nome:</span></td>
                                <td><span class="TextoForm">
                                  <input name="txtCodEmpresaSubstituido" value="<%=intCodEmpresaSubstituido%>" type="hidden" id="txtCodEmpresaSubstituido" >
                                  <input name="txtCodColaboradorSubstituido" value="<%=intCodColaboradorSubstituido%>" type="hidden" id="txtCodColaboradorSubstituido" >
                                  <input name="txtNomeColaboradorSubstituido" type="text" class="text" id="txtNomeColaboradorSubstituido" size="50" readonly maxlength="70" value="<%=strNomeColaboradorSubstituido%>">
                                  <a  href="#" onclick="return abreConsulta('<%=paginaConsultaSbstituido%>')" onmouseout="MM_swapImgRestore()" onmouseover="MM_swapImage('Image7','','<%=session("strCaminhoRaiz")%>/images/botao_verde_over.gif',1)"><img alt="Clique para consultar o Colaborador Substituído" src="<%=session("strCaminhoRaiz")%>/images/botao_verde_normal.gif" name="Image7" width="26" height="26" border="0"  align="absmiddle" ></a></span></td>
                                <td><span class="titulo1"><span class="TextoForm"><strong>Matr&iacute;cula Funcional</strong></span>:</span></td>
                                <td><span class="TextoForm">
                                  <input name="txtCodigoFuncional2" type="text" class="text" id="txtCodigoFuncional2" size="12" maxlength="8" value="<%=intCodFuncional2%>"  onKeyPress="return formataCampo(this, 2, 8)">
                    &nbsp;<strong>*</strong>
                    <input type="checkbox" name="LocalizarMatricula2" value="S" onClick='submit()'>
                    Localizar?</span></td>
                              </tr>
                              <tr>
                                <td><span class="TextoForm">Data Inicial:</span></td>
                                <td colspan="3"><span class="TextoForm">
                                  <input name="txtDataInicial" type="text" class="text" id="txtDataInicial" onblur="validaData(this);validaSeJaExisteSubstituto('<%=situacaoAlteracao%>');"  onKeyPress="return formataCampo(this, 3, 10)" size="11" value="<%=strDataInicial%>"  style="cursor:hand" title="Click aqui para visualizar o calend&aacute;rio">
                                </span></td>
                              </tr>
                              <tr>
                                <td><span class="TextoForm">Data Final:</span></td>
                                <td colspan="3"><span class="TextoForm">
                                  <input name="txtDataFinal" type="text" class="text" id="txtDataFinal" onblur="validaData(this);verificaDatas();validaSeJaExisteSubstituto('<%=situacaoAlteracao%>');" onkeypress="return formataCampo(this, 3, 10)" size="11" value="<%=strDataFinal%>"  style="cursor:hand" title="Click aqui para visualizar o calend&aacute;rio">
                                  </span></td>
                              </tr>
                               <tr>
                                 <td colspan="4">
                                 <%
                    
                                 if trim(intCodColaboradorSubstituido) <> "" then
                                    cont = 0
                                    sql = "SELECT top 5 (SELECT TOP 1 CODIGO from SRH_COLABORADOR_FREQUENCIA where ANO_LETIVO = CF.ANO_LETIVO and SEMESTRE_LETIVO = CF.SEMESTRE_LETIVO and Cod_JustificativaFaltas = CF.Cod_JustificativaFaltas and codReferencia = CF.CodReferencia and DATALANCAMENTO = CF.DATALANCAMENTO and DATALANCAMENTOFINAL = CF.DATALANCAMENTOFINAL and DataDiaLancamento = CF.DataDiaLancamento and COD_COLABORADOR = CF.COD_COLABORADOR and COD_TURMA = CF.COD_TURMA and ISNULL(COD_DISCIPLINA,'0') = ISNULL(CF.COD_DISCIPLINA,'0')) AS CODIGO, CF.ANO_LETIVO, CF.SEMESTRE_LETIVO, CF.Cod_JustificativaFaltas, CF.CodReferencia, CF.DATALANCAMENTO, CF.DATALANCAMENTOFINAL, CF.DataDiaLancamento, CF.COD_COLABORADOR, CF.TIPO_COLABORADOR, CF.COD_TURMA, T.NOMETURMA, C.NOME, D.DESC_DISCIPLINA , isnull(CF.COD_DISCIPLINA,'0') as COD_DISCIPLINA , CS.NOME AS COLABORADOR_SUBSTITUTO, CF.NUMERO_AULA, CF.CONTEUDO_SUBSTITUICAO, CF.COD_TURNO, TUR.DESC_TURNO AS TURNO, CF.SITUACAO as STATUS, isnull(CF.fechamento,'') as fechamento, SUM(CONVERT(INT, CF.NUMERO_FALTA)) AS NUMERO_FALTA from SRH_COLABORADOR_FREQUENCIA CF LEFT JOIN SCA_TURMA T ON T.COD_TURMA=CF.COD_TURMA INNER JOIN SRH_COLABORADOR C ON C.CODIGO = CF.COD_COLABORADOR LEFT JOIN SCA_DISCIPLINA D ON D.COD_DISCIPLINA = CF.COD_DISCIPLINA LEFT JOIN SRH_COLABORADOR CS ON CS.CODIGO = CF.COD_COLABORADORSUBSTITUTO LEFT JOIN SCA_TURNO TUR ON TUR.Cod_Turno = CF.Cod_Turno" 
                                    sql = sql & " WHERE CF.COD_COLABORADOR = " & intCodColaboradorSubstituido
                                    sql = sql & " and CF.SITUACAO='S'"
                                    sql = sql & " and CF.fechamento='S'"
                                    sql = sql & " group by ANO_LETIVO, SEMESTRE_LETIVO, CF.Cod_JustificativaFaltas, CF.CodReferencia, CF.DATALANCAMENTO, CF.DATALANCAMENTOFINAL, CF.DataDiaLancamento, CF.COD_COLABORADOR, CF.TIPO_COLABORADOR, CF.COD_TURMA, T.NOMETURMA, C.NOME, D.DESC_DISCIPLINA , CF.COD_DISCIPLINA , CS.NOME, CF.NUMERO_AULA, CF.CONTEUDO_SUBSTITUICAO, CF.COD_TURNO, TUR.DESC_TURNO , CF.SITUACAO , CF.fechamento order by NOME, CF.CodReferencia desc"
                    
                    
                                    rs.open sql, cnn
                                    if rs.eof = false then
                                        %>
                                        <table width = "100%" border="0" cellpadding="0" cellspacing="0" bordercolor="#CCCCCC" class="tabela">
                                        <tr bgcolor="#E5E5E5"><td width="2%" class="celula" align="center">
                                        <table width = "100%" border="1" cellpadding="0" cellspacing="0" bordercolor="#CCCCCC" class="tabela">
                                        <tr bgcolor="#E5E5E5">
                                          <td height="21" colspan="10" class="celula"><div align="center"><strong>Abonos de Faltas / &Uacute;ltimos lan&ccedil;amentos - <%=strNomeColaboradorSubstituido%></strong> </div></td>
                                          </tr>
                                        <tr bgcolor="#E5E5E5">
                                        <td width="6%" class="celula"><strong>Lan&ccedil;amento</strong></td>
                                        <td width="3%" class="celula"><strong>Tipo </strong></td>
                                        <td width="6%" height="21" class="celula"><strong>Exerc&iacute;cio<span class="TextoForm"></span></strong></td>
                                        <td width="5%" class="celula"><strong>Turma</strong></td>
                                        <td width="5%" class="celula"><strong>Turno</strong></td>
                                        <td width="11%" class="celula"><strong>Disciplina</strong></td>
                                        <td width="3%" class="celula"><strong>Falta</strong></td>
                                        <td width="13%" class="celula"><strong>Per&iacute;odo Lan&ccedil;amento</strong></td>
                                        <td width="8%" align="center" class="celula"><strong>Situa&ccedil;&atilde;o</strong></td>
                                        <td width="9%" align="center" class="celula"><strong>Falta Enviada</strong></td>
                                        </tr>
                                        <%
                                         while not rs.eof
                                       
                                            cont = cont + 1	
                                            strDataLancamento          = formatadataAp(rs("DATALANCAMENTO"))
                                            strDataLancamentoFinal     = formatadataAp(rs("DATALANCAMENTOFINAL"))
                                            strDataDiaLancamento	   = formatadataAp(rs("DataDiaLancamento"))
                                            
                                            strTipoColaborador         = rs("TIPO_COLABORADOR")
                                            strNomeTurma 			   = rs("NOMETURMA")
                                            if not isnull(rs("DESC_DISCIPLINA")) then
                                                strDescDisciplina          = rs("DESC_DISCIPLINA")
                                            else
                                                strDescDisciplina          = "Interdisciplinar"
                                            end if			
                                            intNumeroFalta             = rs("NUMERO_FALTA")
                                            strNumeroAula              = rs("NUMERO_AULA") 
                                            strConteudoSubstituicao    = rs("CONTEUDO_SUBSTITUICAO")
                                            if trim(rs("STATUS")) = "S" then
                                                strSituacao = "ABONO"
                                            else
                                                strSituacao = "-----"
                                            end if
                                            if trim(strTipoColaborador) = "P" then
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
                                                <td class="celula">&nbsp;<%=strDataDiaLancamento%></td>
                                                <td class="celula">&nbsp;<%=DescricaoTipoColaborador%></td>
                                                <td height="20" class="celula">&nbsp;<%=AnoLetivo%>/<%=nomeSemestre%></td>
                                                <td height="20" class="celula">&nbsp;<%=strNomeTurma%></td>
                                                <td height="20" class="celula">&nbsp;<%=rs("TURNO")%></td>
                                                <td height="20" class="celula">&nbsp;<%=strDescDisciplina%></td>
                                                <td height="20" class="celula">&nbsp;<%=intNumeroFalta%></td>
                                                <td height="20" class="celula">&nbsp;<%=strDataLancamento%> - <%=strDataLancamentoFinal%></td>
                                                <td height="20" align="center"><%=strSituacao%></td>
                                                <td align="center" class="celula"><%=strEnviouFalta%></td>
                                              </tr>
                                              <%				
                                                rs.movenext
                                          wend
                                          %>
                                          </table>
                                          </td>
                                          </tr>
                                        </table>
                                          <%   
                                    end if  
                                    rs.close 
                                end if
                                %>             
                                </td>
                               </tr>
                            <tr>
                            <td height="38" colspan="4"><br>
                             <%
                             if intCodColaboradorSubstituto = "" then intCodColaboradorSubstituto = "0"
                             strTemSaldoAinda = "N"
                             if intCodColaboradorSubstituido <> "" then
                                %>
                                <table width = "100%" border="1" align="center" cellpadding="0" cellspacing="0" bordercolor="#CCCCCC" class="tabela">
                                <tr bgcolor="#E5E5E5" class="celula">
                                <td height="21" colspan="13" class="celula"><div align="center"><strong>Modula&ccedil;&atilde;o Disciplinar / Hor&aacute;rio - <%=strNomeColaboradorSubstituido%></strong></div></td>
                                </tr>
                                <tr bgcolor="#E5E5E5" class="celula">
                                <td height="21" colspan="13" class="celula"><div align="center"><strong>Informe o Turno:&nbsp;&nbsp;
                                        <!--#include file="../includes/inc_cmbTurnoColaboradorSubstituido.asp" --> 
                                </strong></div></td>
                                </tr>
                                <%
                                totalTelaDigitado = 0
                                sql = " SELECT "
                                sql = sql & " HA.Cod_turma, " 
                                sql = sql & " T.NOMETURMA, " 
                                sql = sql & " P.Tipo AS SITUACAO_DISCIPLINAR, " 
                                sql = sql & " TRH.DESC_TURNO AS TURNO, "
                                sql = sql & " TRH.Cod_Turno, " 
                                sql = sql & " '' AS DESC_TURNO_OPCIONAL, " 
                                sql = sql & " HA.ANOLETIVO, " 
                                sql = sql & " HA.SEMESTRE, " 
                                sql = sql & " E.RAZAOSOCIAL, " 
                                sql = sql & " P.DESCRICAO AS PERIODO, "
                                sql = sql & " P.COD_PERIODO, "  
                                sql = sql & " ( CASE WHEN P.Tipo = 'I' and F.Situacao_Disciplinar = 'D' then D.DESC_DISCIPLINA WHEN P.Tipo = 'I' and F.Situacao_Disciplinar = 'I' then '' else D.DESC_DISCIPLINA end ) AS DISCIPLINA, "
                                sql = sql & " ( CASE WHEN P.Tipo = 'I' and F.Situacao_Disciplinar = 'D' then D.Cod_Disciplina WHEN P.Tipo = 'I' and F.Situacao_Disciplinar = 'I' then '' else D.Cod_Disciplina end ) AS Cod_Disciplina, "
                                sql = sql & " F.DESC_FUNCAO AS FUNCAO, "
                                sql = sql & " F.Situacao_Disciplinar AS Situacao_Disciplinar, " 
                                sql = sql & " ( CASE WHEN P.Tipo = 'I' and F.Situacao_Disciplinar = 'I' then '1' else COUNT(HA.CODIGO) end ) AS TOTAL_AULAS, "
                                sql = sql & " ( CASE WHEN P.Tipo = 'I' and F.Situacao_Disciplinar = 'I' then '1' else COUNT(HA.CODIGO) end ) AS SALDO, "
                                sql = sql & " 'A' AS STATUS " 
                                sql = sql & " FROM SCA_HORARIO_AULA HA "
                                sql = sql & " INNER JOIN SEG_EMPRESA E ON E.CODIGO = HA.COD_EMPRESA "
                                sql = sql & " INNER JOIN SCA_TURMA T ON T.Cod_Turma = HA.Cod_turma "
                                sql = sql & " INNER JOIN SCA_TURNO TU ON TU.COD_TURNO = T.COD_TURNO " 
                                sql = sql & " INNER JOIN SRH_TURNO TRH ON SUBSTRING(TRH.Desc_Turno,1,3) = SUBSTRING(TU.Desc_Turno,1,3) AND TRH.COD_GRUPO = " & session("codGrupo")  
                                sql = sql & " INNER JOIN SCA_GRADECURRICULAR G ON G.Cod_GradeCurricular = T.Cod_GradeCurricular "
                                sql = sql & " INNER JOIN SCA_PERIODO P ON P.COD_PERIODO = G.COD_PERIODO " 
                                sql = sql & " INNER JOIN SCA_DISCIPLINA D ON D.COD_DISCIPLINA = HA.COD_DISCIPLINA " 
                                sql = sql & " INNER JOIN SRH_COLABORADOR C ON C.CODIGO = HA.COD_COLABORADOR " 
                                sql = sql & " LEFT JOIN SRH_FUNCAOCOLABORADOR F ON F.COD_FUNCAO = C.CODFUNCAO "
                                sql = sql & " WHERE HA.ANOLETIVO = " & strAnoLetivo 
                                sql = sql & " AND HA.Semestre = 3 " 
                                sql = sql & " AND HA.COD_COLABORADOR = " & intCodColaboradorSubstituido
                                sql = sql & " AND T.Situacao = 'A' " 
                                'sql = sql & " AND TRH.Cod_Turno = " & intCodTurnoColaboradorSubstituido  
                                sql = sql & " GROUP BY HA.Cod_turma, T.NOMETURMA, P.Tipo, TRH.DESC_TURNO, TRH.Cod_Turno, HA.ANOLETIVO, HA.SEMESTRE, E.RAZAOSOCIAL, P.DESCRICAO, P.COD_PERIODO, ( CASE WHEN P.Tipo = 'I' and F.Situacao_Disciplinar = 'D' then D.DESC_DISCIPLINA WHEN P.Tipo = 'I' and F.Situacao_Disciplinar = 'I' then '' else D.DESC_DISCIPLINA end ), ( CASE WHEN P.Tipo = 'I' and F.Situacao_Disciplinar = 'D' then D.Cod_Disciplina WHEN P.Tipo = 'I' and F.Situacao_Disciplinar = 'I' then '' else D.Cod_Disciplina end ), F.DESC_FUNCAO, F.Situacao_Disciplinar " 
                                sql = sql & " ORDER BY E.RAZAOSOCIAL, P.DESCRICAO "	
                                'response.write sql
                                'response.end
                                rs.open sql, cnn
                                if rs.eof = false then
                                    %>
                                    <tr bgcolor="#E5E5E5" class="celula">
                                      <td class="celula">Unidade</td>
                                    <td class="celula">Fun&ccedil;&atilde;o</td>
                                    <td width="58" class="celula">Turma</td>
                                    <td width="58" height="26" class="celula">Per&iacute;odo</td>
                                    <td width="36" class="celula">Turno</td>
                                    <td width="28" class="celula">Ano</td>
                                    <td class="celula">Sit. Disciplinar</td>
                                    <td class="celula">Disciplina</td>
                                    <td width="65" class="celula"><div align="center">Total<br>Modulado</div></td>
                                    <td width="73" class="celula"><div align="center">Total em<br>
                                      Substitui&ccedil;&atilde;o</div></td>
                                    <td width="73" class="celula">Saldo p/ Substitui&ccedil;&atilde;o</td>
                                    <td width="56" class="celula">Substituir</td>
                                    <td width="94" class="celula">Status</td>
                                    </tr>
                                    <%
                                    strRequestSubstituicoes = ""
                                    SomaAsubstituir = 0
                                    cont = 0
                                    while not rs.eof
                                       cont = cont + 1	
                                       strTipoSituacao = rs("Situacao_disciplinar")
                                       Asubstituir = ""
                                       intCodigoModulacao = "0"
                                       sql = " SELECT top 1 codigo FROM SRH_MODULACAO_DISCIPLINAR_DOCENTE "
                                       sql = sql & " WHERE Cod_Colaborador = " & intCodColaboradorSubstituido
                                       sql = sql & " and Ano_Letivo = " & trim(rs("ANOLETIVO"))
                                       sql = sql & " and Semestre = " & trim(rs("SEMESTRE"))
                                       sql = sql & " and Cod_periodo = " & trim(rs("COD_PERIODO"))
                                       if trim(rs("Cod_Turno")) <> "4" then 
                                         sql = sql & " and Cod_Turno = " & trim(rs("Cod_Turno")) 
                                       else
                                         ''''''sql = sql & " and Cod_Turno = " & intCodTurnoColaboradorSubstituido
                                      end if
                                       sql = sql & " AND status = 'A' "
                                       rs1.open sql, cnn
                                       if rs1.eof = false then
                                           Asubstituir = trim(request.Form("txt"& rs1("codigo") & "_" & cont & "_" & trim(rs("Cod_Turma")) & "_" & trim(rs("Cod_Disciplina")))) 
                                           intCodigoModulacao = trim(rs1("codigo"))
                                           strmsgStatusModulacao = " "
                                       else
                                           ''Asubstituir = ""
                                           strmsgStatusModulacao = " <font color='#FF0000'>Modula&ccedil;&atilde;o n&atilde;o<br>confere com hor&aacute;rio</font> "
                                       end if 
                                       rs1.close
                    
                                       strSituacaoDisciplinar = rs("Situacao_disciplinar")
                                       strSituacaoCampo = ""
                                       classCampo 		= "text"
                                       if strSituacaoDisciplinar = "D" then strSituacaoDisciplinar = "Disciplinar"
                                       if strSituacaoDisciplinar = "I" then 
                                            strSituacaoDisciplinar = "Interdisciplinar"
                                            strSituacaoCampo = "readonly"
                                            classCampo = "textDisabled"
                                      end if
                    
                                       if rs("saldo") = 0 then
                                            strSituacaoCampo = "disabled"
                                            classCampo = "textDisabled"				   	
                                       end if
                                       
                                       strMsgSemestre = trim(rs("Semestre"))
                                       if strMsgSemestre = "3" then strMsgSemestre = "Anual"
                    
                                        TotalAulasSubstituidas = "0"
                                        sql = " select isnull(sum(Total_Aulas),'0') as Total_Aulas_Substituidas "
                                        sql = sql & " from SRH_COLABORADOR_SUBSTITUTO CS " 
                                        sql = sql & " INNER JOIN SCA_TURMA T ON T.Cod_Turma = CS.Cod_turma "  
                                        sql = sql & " INNER JOIN SCA_GRADECURRICULAR G ON T.Cod_GRADECURRICULAR = G.Cod_GRADECURRICULAR "
                                        sql = sql & " INNER JOIN SCA_TURNO TU ON TU.COD_TURNO = T.COD_TURNO " 
                                        sql = sql & " INNER JOIN SRH_TURNO TRH ON SUBSTRING(TRH.Desc_Turno,1,3) = SUBSTRING(TU.Desc_Turno,1,3) AND TRH.COD_GRUPO = " & session("codGrupo") 
                                        sql = sql & " where cs.codColaboradorSubstituido = " & intCodColaboradorSubstituido 
                                        sql = sql & " AND cs.Situacao = 'A' " 
                                        sql = sql & " AND TRH.Cod_Turno = " & trim(rs("Cod_Turno")) 
                                        sql = sql & " AND G.Cod_Periodo = " & trim(rs("COD_PERIODO")) 
                                        rs1.open sql, cnn, 3, 3
                                        if rs1.eof = false then
                                            TotalAulasSubstituidas = rs1("Total_Aulas_Substituidas") 
                                        end if
                                        rs1.close
                                        
                                        turno = rs("turno")
                                        TurnoSubstituicao = rs("Cod_Turno")
                                       
                                        'Realiza o bloqueio do campo apenas quando for interdisciplinar caso o substituto já tenha modulacao no mesmo periodo
                                        sql = " select codigo from SRH_MODULACAO_DISCIPLINAR_DOCENTE " 
                                        sql = sql & " where Cod_Colaborador = " & intCodColaboradorSubstituido 
                                        sql = sql & " AND status = 'A' " 
                                        sql = sql & " and codigo = " & intCodigoModulacao 
                                        sql = sql & " and Cod_Turno in (select distinct cod_turno from SRH_MODULACAO_DISCIPLINAR_DOCENTE " 
                                        sql = sql & " 				 where Cod_Colaborador = " & intCodColaboradorSubstituto & " and Situacao_disciplinar = 'I' AND status = 'A')"
                                        'response.write sql & "<br>"
                                        rs1.open sql, cnn, 3, 3
                                        if rs1.eof = false then
                                            'strBloquearCampo = " readonly "
                                            strmsgStatus = " <font color='#FF0000'>Substituto já Modulado</font> "
                                        else
                                            strBloquearCampo = " "
                                            strmsgStatus = " "
                                        end if
                                        rs1.close
                                        
                                        strRazaoSocial_substituir		= trim(rs("RAZAOSOCIAL"))
                                        strFuncao_substituir 			= trim(rs("FUNCAO"))
                                        strNometurma_substituir 		= trim(rs("Nometurma"))
                                        strPeriodo_substituir 			= trim(rs("periodo"))
                                        strTurno_substituir 			= trim(rs("turno"))
                                        strAnoletivo_substituir 		= trim(rs("Anoletivo"))
                                        strDisciplina_substituir 		= trim(rs("disciplina"))
                                        strSaldo_substituir 			= clng(strSaldo_substituir) + clng(trim(rs("saldo")))
                                        
                                        strRequestSubstituicoes = strRequestSubstituicoes & "txt" & trim(intCodigoModulacao) & "_" & trim(cont) & "_" & trim(rs("Cod_Turma")) & "_" & trim(rs("Cod_Disciplina")) & ","
                                       
                                        if trim(Asubstituir) <> "" then 
                                           if cint(trim(Asubstituir)) <> cint(trim(rs("saldo"))) then
                                                Asubstituir = ""
                                                %>
                                                <script>
                                                    frm.txt<%=intCodigoModulacao & cont%>.value='';
                                                    alert("Valor Informado não autorizado. Verifique!")
                                                    frm.txt<%=intCodigoModulacao & cont%>.focus();
                                                </script>
                                                <%
                                            else
                                                SomaAsubstituir = SomaAsubstituir + cint(trim(Asubstituir))
                                            end if
                                        end if
                                       
                                        '
                                        'Testa o total modulado do substituto para que o mesmo nao exceda por turno
                                        '
                                        CalculaTotalModuladoSubstitutoTurno = "0"
                                        sql = " select isnull(sum(Case when Situacao_disciplinar = 'I' then 21 else Total_Aulas end),'0') as Total_Modulado_Substituto " 
                                        sql = sql & " from SRH_MODULACAO_DISCIPLINAR_DOCENTE " 
                                        sql = sql & " where Cod_Colaborador = " & intCodColaboradorSubstituto
                                        sql = sql & " and ano_letivo = " & strAnoLetivo
                                        sql = sql & " and Cod_Turno = " & TurnoSubstituicao
                                        sql = sql & " and Status='A' "
                                        'response.write sql
                                        'response.end
                                        rs1.open sql, cnn, 3, 3
                                        if rs1.eof = false then
                                            CalculaTotalModuladoSubstitutoTurno = trim(rs1("Total_Modulado_Substituto")) 
                                        end if
                                        rs1.close
                                        
                                        sql = " select Total_Aulas from SRH_COLABORADOR_SUBSTITUTO "
                                        sql = sql & " WHERE Cod_Turma = " & trim(rs("Cod_Turma"))
                                        if trim(situacao_disciplinar_colaborador) = "D" then
                                            sql = sql & " and Cod_Disciplina = " & trim(rs("Cod_Disciplina")) 
                                        else
                                            sql = sql & " and Cod_Disciplina = 0"
                                        end if
                                        sql = sql & " and Situacao = 'A' "
                                        
                                        'if session("UsuarioWeb") = "CLEOVIS" THEN
                                            'response.write sql & "<hr>"
                                        'END IF
                    
                                        rs1.open sql, cnn, 3, 3
                                        if rs1.eof = false then
                                            'strBloquearCampo = " readonly "
                                            strmsgStatus = " <font color='#FF0000'>" & rs1("Total_Aulas") & " Aula(s)</font> "
                                        end if
                                        rs1.close
                                        Asubstituir = request("txt"&cont)
                                        if Asubstituir <>"" then totalTelaDigitado = totalTelaDigitado + Asubstituir
                                        %>
                                       <tr bgcolor="#FFFFFF" class="celula" >
                                       <td width="383" class="celula9">&nbsp;<%=strRazaoSocial_substituir%></td>
                                       <td width="106" class="celula9">&nbsp;<%=strFuncao_substituir%></td>
                                       <td class="celula9"><strong><%=strNometurma_substituir%></strong></td>
                                       <td height="26" class="celula9">&nbsp;<%=strPeriodo_substituir%></td>
                                       <td class="celula9">&nbsp;<%=strTurno_substituir%></td>
                                       <td height="26" class="celula9">&nbsp;<%=strAnoletivo_substituir%></td>
                                       <td width="86" class="celula9">&nbsp;<%=strSituacaoDisciplinar%></td>
                                       <td width="168" height="26" class="celula9">&nbsp;<%=strDisciplina_substituir%></td>
                                       <td class="celula9" align="center">----</td>
                                       <td class="celula9" align="center">----</td>
                                       <td class="celula9" align="center">----</td>
                                       <td height="26" class="celula9" align="center">&nbsp;<input <%=strBloquearCampo%>  name="txt<%=cont%>" id="txt<%=cont%>" type="text" class="<%=classCampo%>" onkeypress="return formataCampo(this,2,2)" size="2" value="<%=Asubstituir%>"  onBlur='submit()'></td>
                                       <td class="celula9" align="center"><%=strmsgStatus%><%=strmsgStatusModulacao%>&nbsp;</td>
                                       <%
                                        vchave1 = left(strNometurma_substituir,3) & strTurno_substituir
                                        rs.movenext
                                        if rs.eof = false then
                                            vchave2 = left(trim(rs("Nometurma")),3) & trim(rs("turno"))
                                        else
                                            vchave2 = ""
                                        end if
                                        
                                        if vchave1 <> vchave2 then
                                            saldoSubstituicao  = strSaldo_substituir - TotalAulasSubstituidas
											'
											if strTurno_substituir = "INTEGRAL" then
												if saldoSubstituicao < "0" then 
													saldoSubstituicao = "0"
													strTemSaldoAindaIntegral = "N"
												end if
											end if
											'
                                            %>
                                          </tr>
                                          <tr bgcolor="#FFFFFF" class="celula" >
                                            <td height="26" colspan="8" class="celula9"><div align="right">Totais...&nbsp;&nbsp;&nbsp;</div></td>
                                            <td class="celula9" align="center">&nbsp;<%=strSaldo_substituir%></td>
                                            <td class="celula9" align="center">&nbsp;<%=trim(TotalAulasSubstituidas)%></td>
                                            <td class="celula9" align="center">&nbsp;<strong><%=trim(saldoSubstituicao)%></strong></td>
                                            <td height="26" class="celula9" align="center">&nbsp;</td>
                                            <td class="celula9" align="center">&nbsp;</td>
                                            </tr>
                                            <%
                                            strSaldo_substituir = 0
                                            if trim(saldoSubstituicao) <= "0" and strTemSaldoAinda = "N" then
                                                strDesabilitaIncluir 	= "disabled" ' Desabilita o botão Incluir
                                                strDesabilitaAlterar 	= "disabled" ' Desabilita o botão Alterar
                                            else
												strTemSaldoAinda = "S"
                                                strDesabilitaIncluir 	= "" ' Desabilita o botão Incluir
                                                strDesabilitaAlterar 	= "disabled" ' Desabilita o botão Alterar
											end if
                                        end if
                                        totalModulacaoTelaSubtituto = clng(CalculaTotalModuladoSubstitutoTurno) + clng(SomaAsubstituir)
                                        IF  strTipoSituacao = "I" THEN
 										    strDesabilitaIncluir 	= "" ' Desabilita o botão Incluir


                                            if (clng(CalculaTotalModuladoSubstitutoTurno) + clng(SomaAsubstituir)) > 22 then
                                            
                                                strDesabilitaIncluir 	= "disabled" ' Desabilita o botão Incluir
                                                strDesabilitaAlterar 	= "disabled" ' Desabilita o botão Alterar
                                                
                                                %>
                                                <script>
                                                    alert("Modulação excedida no turno <%=turno%> para esse Substituto.");
                                                </script>
                                                <%
                                                strDesabilitaIncluir 	= "disabled" ' Desabilita o botão Incluir
                                                strDesabilitaAlterar 	= "disabled" ' Desabilita o botão Alterar
                                            end if
                                       END IF
                                       IF  strTipoSituacao = "D" THEN
                                            if (clng(CalculaTotalModuladoSubstitutoTurno) + clng(SomaAsubstituir)) > 26 then
                                            
                                                strDesabilitaIncluir 	= "disabled" ' Desabilita o botão Incluir
                                                strDesabilitaAlterar 	= "disabled" ' Desabilita o botão Alterar
                                                
                                                %>
                                                <script>
                                                    alert("Modulação excedida no turno <%=turno%> para esse Substituto.");
                                                </script>
                                                <%
                                                strDesabilitaIncluir 	= "disabled" ' Desabilita o botão Incluir
                                                strDesabilitaAlterar 	= "disabled" ' Desabilita o botão Alterar
                                            end if
                                       END IF
									   ''
									   if strTemSaldoAindaIntegral = "N" then
											strDesabilitaIncluir 	= "disabled" ' Desabilita o botão Incluir
											strDesabilitaAlterar 	= "disabled" ' Desabilita o botão Alterar
									   end if
									   ''
                                    wend	
                                    strRequestSubstituicoes = left(trim(strRequestSubstituicoes),len(trim(strRequestSubstituicoes))-1)
                                    %>
                                    <input name="txtRequestSubstituicoes" type="hidden" id="txtRequestSubstituicoes" class="text" value="<%=strRequestSubstituicoes%>">
                                  <%
                                    '
                                    'Testa se o Colaborador substituto e o mesmo que o substituido
                                    '
                                    if trim(intCodColaboradorSubstituto) <> "" and trim(intCodColaboradorSubstituido) <> "" then
                                        if trim(intCodColaboradorSubstituto) = trim(intCodColaboradorSubstituido) then
                                            strDesabilitaIncluir 	= "disabled" ' Desabilita o botão Incluir
                                            strDesabilitaAlterar 	= "disabled" ' Desabilita o botão Alterar
                                            %>
                                            <script>
                                                alert("O Colaborador Substituto não poderá ser o mesmo que o Substituido. Verifique!")
                                                window.location='ColaboradorSubstitutoNovo_cad.asp';
                                            </script>
                                            <%
                                            response.end
                                        end if
                                    end if
                                    '
                                    'Testa o total modulado do substituto para que o mesmo nao exceda por turno
                                    '
                                    CalculaTotalModuladoSubstituto = "0"
                                    sql = " select isnull(sum(Case when Situacao_disciplinar = 'I' then 21 else Total_Aulas end),'0') as Total_Modulado_Substituto " 
                                    sql = sql & " from SRH_MODULACAO_DISCIPLINAR_DOCENTE " 
                                    sql = sql & " where Cod_Colaborador = " & intCodColaboradorSubstituto
                                    sql = sql & " and ano_letivo = " & strAnoLetivo
                                    sql = sql & " and Status='A' "
                                    rs1.open sql, cnn, 3, 3
                                    if rs1.eof = false then
                                        CalculaTotalModuladoSubstituto = trim(rs1("Total_Modulado_Substituto")) 
                                    end if
                                    rs1.close
                                    'response.write CalculaTotalModuladoSubstituto & " - Substituir: " & SomaAsubstituir
                                    
                                    if (clng(CalculaTotalModuladoSubstituto) + clng(SomaAsubstituir)) > 42 then
                                    
                                        strDesabilitaIncluir 	= "disabled" ' Desabilita o botão Incluir
                                        strDesabilitaAlterar 	= "disabled" ' Desabilita o botão Alterar
                                        
                                        %>
                                        <script>
                                            alert("Modulação excedida para esse Substituto.");
                                        </script>
                                        <%
                                    end if
                                    
                                else 
                                    strDesabilitaIncluir 	= "disabled" ' Desabilita o botão Incluir
                                    strDesabilitaAlterar 	= "disabled" ' Desabilita o botão Alterar
                                end if
                                rs.close
                                %>
                                </table>
                                <br>
                                <%
                             end if
                            
                             %>
                              </td>
                              </tr>
                              <%if strNomeColaboradorSubstituto <> "" and strNomeColaboradorSubstituido <> "" then  %>
                              <tr>
                                <td colspan="4" class="texto" align="center">Obs.: Para um melhor entedimento o(a) Professor(a) <strong><%=strNomeColaboradorSubstituto%></strong> estar&aacute; substituindo a(o) professor(a) <strong><%=strNomeColaboradorSubstituido%></strong> no período informado. </span></td>
                              </tr>
                              <%end if%>
                              
                              <tr>
                                <td colspan="4">&nbsp;
                    <%
                    
                    'response.write "<br>intCodColaboradorSubstituto:" & intCodColaboradorSubstituto
                    'response.write "<br>intCodColaboradorSubstituido:" & intCodColaboradorSubstituido
                    
                    if intCodColaboradorSubstituto = "" or intCodColaboradorSubstituto = "0" then 
                        strDesabilitaIncluir 	= "disabled"
                        strDesabilitaAlterar 	= "disabled" 
                    end if
                    if intCodColaboradorSubstituido = "" or intCodColaboradorSubstituido = "0" then
                        strDesabilitaIncluir 	= "disabled"
                        strDesabilitaAlterar 	= "disabled" 
                    end if
                    
                    strSituacaoSubstituicao = request("cmbSituacaoSubstituicao")
	if intCodCodSubistituicao<>"" then
		strDesabilitaIncluir 	= "disabled" ' Desabilita o botão Incluir
		strDesabilitaAlterar 	= "disabled" ' Desabilita o botão Alterar
		strDesabilitaExcluir 	= "disabled" ' Desabilita o botão Excluir
		strDesabilitaLimpar  	= "" ' Habilita o Botão Limpar
	end if
					
                    %>
                                </td>
                              </tr>
                                <tr>
                                <td colspan="4"><!--#include file="../../includes/inc_botoes_cadastro.asp"--></td>
                              </tr>
                               <tr>
                                <td colspan="4">&nbsp;</td>
                              </tr>
                    
                            <tr>
                                <td height="20" colspan="4"  align="center" class="texto" ><strong><font color="#CC0000">Mostrar lançamento?</font><strong><select name="cmbSituacaoSubstituicao" class="combo"  onChange="submit()" id="cmbSituacaoSubstituicao" style="width:150pt">
                                <option value="" <%if strSituacaoSubstituicao = "" then response.Write("selected") %>>Selecione...  </option>
                                <option value="A" <%if strSituacaoSubstituicao = "A" then response.Write("selected") %>>Ativo  </option>
                                <option value="I" <%if strSituacaoSubstituicao = "I" then response.Write("selected") %>>Inativo</option>
                            </select> - <strong><font color="#CC0000">Selecionar para mostrar as substituições ativas ou inativas.</font><strong></td>
                                
                              </tr>
                    <%
                    
                    if strSituacaoSubstituicao<>"" then%>
                             <tr>
                                <td colspan="4">
                                  <% 
                                   cont1 = 0
                                  %>
                                      <table width = "100%" border="1" align="center" cellpadding="0" cellspacing="0" class="tabela">
                                        <tr bgcolor="#E5E5E5">
                                          <td width="20" rowspan="2" align="center" class="celula">                        
                                            <input type="checkbox" name="chkTodos" onclick="return MarcaTodos(this.checked)">                  </td>
                                          <td width="68" rowspan="2" align="center" class="celula"><strong>C</strong><strong>&oacute;d.<br>
                                            Funcional </strong></td>
                                          <td rowspan="2" align="center" class="celula"><strong>Per&iacute;odo<br>
                                            In&iacute;cio e Fim</strong></td>
                                          <td colspan="5" class="celula"><div align="center"><strong>  Substituto </strong></div></td>
                                          <td colspan="2" class="celula"><div align="center"><strong> Substitu&iacute;do</strong></div></td>
                                          <td rowspan="2" align="center" class="celula"><strong>Tipo</strong></td>
                                          <td rowspan="2" align="center" class="celula"><strong>Situa&ccedil;&atilde;o</strong></td>
                                          <td colspan="3" rowspan="2" align="center" class="celula"><strong>A&ccedil;&atilde;o</strong></td>
                                          </tr>
                                        <tr bgcolor="#E5E5E5">
                                          <td class="celula"><div align="center"><strong>Professor</strong></div></td>
                                          <td class="celula"><div align="center"><strong>Unidade</strong></div></td>
                                          <td class="celula"><div align="center"><strong>Turma</strong></div></td>
                                          <td class="celula"><div align="center"><strong>Disciplinas</strong></div></td>
                                          <td class="celula"><div align="center"><strong>Aulas</strong></div></td>
                                          <td class="celula"><div align="center"><strong>Professor</strong></div></td>
                                          <td class="celula"><div align="center"><strong>Unidade</strong></div></td>
                                        </tr>
                                        <%
                                        sql = " SELECT CB.Codigo, CB.Cod_Empresa, CB.Cod_Grupo, CodEmpresaSubstituto, C.CodFuncional, CSS.CodFuncional as SUB_CodSubstituido, "
                                        sql = sql & " CodColaboradorSubstituto, CodEmpresaSubstituido, ESUBT.RAZAOSOCIAL AS EMP_SUBSTITUTO, ESUBI.RAZAOSOCIAL AS EMP_SUBSTITUIDO, "
                                        sql = sql & " CodColaboradorSubstituido, DataInicial, DataFinal, CB.Situacao, T.NOMETURMA AS TURMA, D.DESC_ABREVIADA AS DISCIPLINA, CB.TOTAL_AULAS, "
                                        sql = sql & " isnull(CSS.nome,'--') as NomeSubstituido, C.nome as NomeSubstituto, isnull(TF.Descricao,'--') AS TipoFalta"
                                        sql = sql & " FROM SRH_COLABORADOR_SUBSTITUTO CB"
                                        sql = sql & " left join SRH_COLABORADOR C on C.codigo = CB.CodColaboradorSubstituto "
                                        sql = sql & " left join SRH_COLABORADOR CSS on CSS.codigo = CB.CodColaboradorSubstituido	"
                                        sql = sql & " left join SEG_EMPRESA ESUBT on ESUBT.codigo = CB.CodEmpresaSubstituto	"
                                        sql = sql & " left join SEG_EMPRESA ESUBI on ESUBI.codigo = CB.CodEmpresaSubstituido "
                                        sql = sql & " LEFT JOIN SRH_COLABORADOR_FREQUENCIA CF ON CF.codigo = CB.Cod_Lancamento_Falta "
                                        sql = sql & " LEFT JOIN SRH_JUSTIFICATIVAFALTAS TF ON TF.Codigo = CF.Cod_JustificativaFaltas "
                                        sql = sql & " LEFT JOIN SCA_TURMA T ON T.Cod_Turma = CB.Cod_turma "					
                                        sql = sql & " LEFT JOIN SCA_DISCIPLINA D ON D.COD_DISCIPLINA = CB.COD_DISCIPLINA " 
                                        sql = sql & " WHERE CB.Cod_Grupo = " & Session("CodGrupo")
                                        'sql = sql & " and ( CB.CodColaboradorSubstituto = " & intCodColaboradorSubstituto & " or CB.CodColaboradorSubstituto = " & intCodColaboradorSubstituido & ")" 
                                         sql = sql & " AND year(CB.DataInicial) = " & strAnoLetivo
                                        if strSituacaoSubstituicao = "A" then
                                            sql = sql & " AND CB.Situacao = 'A'"
                                        end if	
                                        if strSituacaoSubstituicao = "I" then
                                            sql = sql & " AND CB.Situacao = 'I'"
                                        end if	 
                                        sql = sql & " order by CB.Codigo desc"
                                        'response.write sql
                                        rs.open sql, cnn
                                        if rs.eof = false then
                                        while not rs.eof
                                            cont1 = cont1 + 1	
                                            strMarca 	= ""
                                            
                                            if intCodCodSubistituicao = trim(rs("Codigo"))then 
                                                strMarca = "checked"
                                            else
                                                strMarca = ""
                                            end if
                                            sit = "<strong>Ativo</strong>"
                                            if rs("situacao")="I" then sit = "Inativo"
                                            %>
                                            <tr>
                                            <td class="celula" align="center"><input name="chkCodSubistituicao"  type="checkbox" value="<%=rs("Codigo")%>" <%=strMarca%>></td>
                                            <td align="center" class="celula" style="cursor:hand" onclick="return resultadoConsulta('<%=rs("Codigo")%>')" onmouseover="return linhaMouseOver(this)" onmouseout="return linhaMouseOut(this)"><span class="texto3"><%=trim(rs("CodFuncional"))%></span></td>
                                            <td width="76" align="center" class="celula" style="cursor:hand" onclick="return resultadoConsulta('<%=rs("Codigo")%>')" onmouseover="return linhaMouseOver(this)" onmouseout="return linhaMouseOut(this)"><%=trim(formataDataAP(rs("DataInicial")))%><BR>a<BR><%=formataDataAP(trim(rs("DataFinal")))%></td>
                                            <td width="141" class="celula"style="cursor:hand" onclick="return resultadoConsulta('<%=rs("Codigo")%>')" onmouseover="return linhaMouseOver(this)" onmouseout="return linhaMouseOut(this)"><%=trim(rs("NomeSubstituto"))%>&nbsp;</td>
                                            <td width="215" class="celula"style="cursor:hand" onclick="return resultadoConsulta('<%=rs("Codigo")%>')" onmouseover="return linhaMouseOver(this)" onmouseout="return linhaMouseOut(this)"><%=trim(rs("EMP_SUBSTITUTO"))%></td> 
                                            <td width="75" class="celula"style="cursor:hand" onclick="return resultadoConsulta('<%=rs("Codigo")%>')" onmouseover="return linhaMouseOver(this)" onmouseout="return linhaMouseOut(this)" align="center"><%=trim(rs("TURMA"))%>&nbsp;</td>
                                            <td width="186" class="celula"style="cursor:hand" onclick="return resultadoConsulta('<%=rs("Codigo")%>')" onmouseover="return linhaMouseOver(this)" onmouseout="return linhaMouseOut(this)"><%=trim(rs("DISCIPLINA"))%>&nbsp;</td>
                                            <td width="49" class="celula"style="cursor:hand" onclick="return resultadoConsulta('<%=rs("Codigo")%>')" onmouseover="return linhaMouseOver(this)" onmouseout="return linhaMouseOut(this)" align="center"><%=trim(rs("TOTAL_AULAS"))%>&nbsp;</td>
                                            <td width="136" class="celula"style="cursor:hand" onclick="return resultadoConsulta('<%=rs("Codigo")%>')" onmouseover="return linhaMouseOver(this)" onmouseout="return linhaMouseOut(this)"><strong><%=trim(rs("NomeSubstituido"))%></strong></td>
                                            <td width="119" class="celula"style="cursor:hand" onclick="return resultadoConsulta('<%=rs("Codigo")%>')" onmouseover="return linhaMouseOver(this)" onmouseout="return linhaMouseOut(this)"><strong><%=trim(rs("EMP_SUBSTITUIDO"))%></strong>&nbsp;</td>
                                            <td width="30" align="center" class="celula"style="cursor:hand" onclick="return resultadoConsulta('<%=rs("Codigo")%>')" onmouseover="return linhaMouseOver(this)" onmouseout="return linhaMouseOut(this)"><strong><%=trim(rs("TipoFalta"))%></strong></td>
                                            <td width="58" align="center" class="celula"style="cursor:hand" onclick="return resultadoConsulta('<%=rs("Codigo")%>')" onmouseover="return linhaMouseOver(this)" onmouseout="return linhaMouseOut(this)"><%=sit%></td>
                                            <td width="26" align="center" class="celula"><a href="#" onclick="Excluir('E','<%=rs("CodColaboradorSubstituto")%>','<%=rs("CodColaboradorSubstituido")%>')" ><img src="../../images/botao_vermelho_normal.gif" alt="Excluir Colaborador Subistituto" width="26" height="26" border="0"></a></td>
                                            <td width="26" align="center" class="celula"><a href="#" onclick="Inativar('INATIVAR')" ><img src="../../images/botao_azul_normal.gif" alt="Inativar Subistituição" width="26" height="26" border="0"></a></td>
                                            <td width="39" align="center" class="celula"><a href="#" onclick="emitir('<%=rs("Codigo")%>','<%=rs("CodColaboradorSubstituido")%>')" ><img src="../../images/impressora_on.gif" width="26" height="26" alt="Emissão da Substituição"></a></td>
                                          </tr>
                                            <%	
                                                cont = cont + 1
                                                rs.movenext
                                            wend
                                          else
                                          %>
                                            <center>
                                            <strong><%=strMensagemNaoEncontrado%></strong>
                                            </center>
                                            <%		
                                            end if
                                            rs.close
                                            
                                          %>
                                        </table>
                                      </td>
                              </tr>
                              <%if intCodColaboradorSubstituto <> "" and intCodColaboradorSubstituido <> "" then %>
                              <tr>
                                <td colspan="4" class="text"><strong>Substituições listadas:&nbsp;<%=cont1%></strong></td>
                              </tr>
                              <% end if %>
                              <tr>
                                <td colspan="4">&nbsp;</td>
                              </tr>
                    <%end if%>          
                            </table>
                          <!-- FIM PAGINA 	-->
                          <input name="totalModulacaoTelaSubstituto" type="hidden" value="<%=totalModulacaoTelaSubtituto%>" >
                          <input name="totalTelaDigitado" type="hidden" value="<%=totalTelaDigitado%>" >
                          <input name="tipoSituacao" type="hidden" value="<%=strTipoSituacao%>" >
                            </form>
                            </td>
                          </tr>
                        </table>
                        </td>
                      </tr>
                    </table>
                      
                  <!-- FIM PAGINA 	-->
                  </div>
                  <input name="totalModulacaoTelaSubstituto" type="hidden" value="<%=totalModulacaoTelaSubtituto%>" >
                  <input name="totalTelaDigitado" type="hidden" value="<%=totalTelaDigitado%>" >
                  <input name="tipoSituacao" type="hidden" value="<%=strTipoSituacao%>" >
                </form>
            	</div>
       	 	</div>
         	<!-- Fecha o Form -->  
      </div>
        <!-- Fecha o Painel do Formulario -->        
    </div>
    <!--/container-->		
	<script src="../../js/js_funcoes_gerais.js"></script>
    <script type="text/javascript" language="javascript" src="js/ajaxutil.js"></script>
    <script type="text/javascript" language="javascript" src="js/jquery.js"></script>
    <script type="text/javascript" language="javascript" src="js/mascara.js"></script>
    <script type="text/javascript" language="javascript" src="js/ajax.js?1=1"></script>
    <script>

	function resultadoConsulta(CodSubistituicao){
		frm.txtCodCodSubistituicao.value=CodSubistituicao;
		frm.txtCodigo.value=CodSubistituicao;
		frm.submit();

	}
	function emitir(codigo,cod_deficit){
		
		var frm = document.getElementById("frm");
		if (cod_deficit=='0')
			frm.action="ColaboradorSubstitutoDeficit_rel.asp?CodSubstituicao=" + codigo;
		else
			frm.action="ColaboradorSubstituto_rel.asp?CodSubstituicao=" + codigo;
		frm.submit();
	}

	function marcaTodos(valor){
		
		var form = window.document.forms[0];
		var i;
		for (var i = 0; i < form.elements.length; i++) {
			//verifica todos os checkbox
			if (form.elements[i].type == "checkbox"){
				//verifica se o checkbox está marcado
				form.elements[i].checked=valor;
			}
		}
	}
	
	function Excluir(acao,intCodColaboradorSubstituto,intCodColaboradorSubstituido){
		
		var intContMarcado =0;
		var intCodSubistituicao = "0";

		var frm = document.getElementById("frm");
	
		for (var i = 0; i < frm.elements.length; i++) 
		{
			//verifica todos os checkbox
			if (frm.elements[i].name.substring(0,19) == "chkCodSubistituicao"){				
				if (frm.elements[i].checked) {
					intContMarcado = intContMarcado + 1;
					intCodSubistituicao = intCodSubistituicao + "," + frm.elements[i].value;
				}
			}
		}
		
		if (intContMarcado==0){
			alert("ATENÇÃO: Pelo menos uma Substituição deve ser selecionada, Verifique!");
			return false;
		}
		
		var men = 'ATENÇÃO: Deseja realmente excluir esta Substituição'
		if (confirm(men)) {
				
			frm.action="ColaboradorSubstitutoNovo_cod.asp?acao="+acao+"&txtCodColaboradorSubstituto="+intCodColaboradorSubstituto+"&txtCodColaboradorSubstituido="+intCodColaboradorSubstituido;
			frm.submit();
			return true;

		} else {
			return false;
		}
	}
	
	function Inativar(acao){
		
		var intContMarcado =0;
		var intCodSubistituicao = "0";

		var frm = document.getElementById("frm");
	
		for (var i = 0; i < frm.elements.length; i++) 
		{
			//verifica todos os checkbox
			if (frm.elements[i].name.substring(0,19) == "chkCodSubistituicao"){				
				if (frm.elements[i].checked) {
					intContMarcado = intContMarcado + 1;
					intCodSubistituicao = intCodSubistituicao + "," + frm.elements[i].value;
				}
			}
		}
		
		if (intContMarcado==0){
			alert("ATENÇÃO: Pelo menos uma Substituição deve ser selecionada, Verifique!");
			return false;
		}
	
		
		var men = 'ATENÇÃO: Deseja Inativar essa Substituição ?'
		if (confirm(men)) {
				
			frm.action="ColaboradorSubstitutoNovoInativar_cad.asp?acao=" + acao;
			frm.submit();
			return true;

		} else {
			return false;
		}
	}

	function salvar(acao){
		
		var frm = document.getElementById("frm");
		
		if(frm.txtNomeColaboradorSubstituto.value == ""){
			alert("O Nome do Funcionario Substituto deve ser informado!");
			frm.txtNomeColaboradorSubstituto.focus();
			return false		
		}
		
		if(frm.txtDataInicial.value == ""){
			alert("A Data Inicial deve ser informada!");
			frm.txtDataInicial.focus();
			return false		
		}
	
		if(frm.txtDataFinal.value == ""){
			alert("A Data Final deve ser informada!");
			frm.txtDataFinal.focus();
			return false		
		}
		
		if(frm.txtDataInicial.value.substring(6,10) != <%=year(date)%>){
			alert("A Data Inicial deve ser dentro do ano atual!");
			frm.txtDataFinal.focus();
			return false		
		}

		if(frm.txtDataFinal.value.substring(6,10) != <%=year(date)%>){
			alert("A Data Final deve ser dentro do ano atual!");
			frm.txtDataFinal.focus();
			return false		
		}
		
		var total = 0;
		total = parseInt(frm.totalModulacaoTelaSubstituto.value,10)+parseInt(frm.totalTelaDigitado.value,10);
		var totalI = 0;
		totalI = parseInt(total,10)-21;
		var totalD = 0;
		totalD = parseInt(total,10)-25;
		
		if (total > 21 && frm.tipoSituacao.value == "I"){
			alert("Modulação excedida para o turno. \n\nExcedido: " + totalI);
			return false;	
		}
		if(total > 25 && frm.tipoSituacao.value == "D"){
			alert("Modulação excedida para o turno. \n\nExcedido: " + totalD);
			return false;	
		}
			
		
		var intContMarcado =0;
		var frm = document.getElementById("frm");
	
		frm.cmdIncluir.disabled = true;
		frm.action="ColaboradorSubstitutoNovo_cod.asp?acao=" + acao;
		frm.submit();
		return true;

	}	
	
	function verificaDatas(){
		
		var dtini = document.all.txtDataInicial.value;
		var dtfim = document.all.txtDataFinal.value;
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
			return true;
		} else {
			alert('ATENÇÃO: Data Inicial é maior que Data Final');
			document.all.txtDataFinal.focus();
			document.all.txtDataFinal.select();
			return false;
		}    
	}
	
	function gerar(){
		
		var caminho;
		var frm = document.getElementById("frm");
		
		if (frm.optTipoModulacao[0].checked) {
			caminho = "ColaboradorSubstitutoNovo_cad.asp"
		}	
		if (frm.optTipoModulacao[1].checked) {
			caminho = "ColaboradorSubstitutoDiretrizes_cad.asp"
		}	

		frm.action = caminho;
		frm.submit();
		
		return true;	
	}
	
		
</script>

    <!--=== End Content Part ===-->
   	<!--#include file="../RodapeModulo.asp"-->
	<!--#include file="../jsModulo.asp"-->
</body>
</html> 