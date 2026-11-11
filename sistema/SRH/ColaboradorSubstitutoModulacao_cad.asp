<!--#include file="../ConfigModulo.asp"-->
<!--#include file="../../includes/inc_cnn.asp"-->
<!--#include file="../../includes/inc_formatadata.asp"-->
<!--#include file="../../includes/inc_formataCPF.asp"-->
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
	'RESPONSE.WRITE SQL
	cnn.execute sql

	sql = " UPDATE SRH_MODULACAO_DISCIPLINAR_DOCENTE  SET Status = 'I' where Ano_Letivo < YEAR(GETDATE()) AND Status = 'A' "
	cnn.execute sql

	' Inativa todas as substituicoes vencidas
	sql = " Update SRH_COLABORADOR_SUBSTITUTO "
	sql = sql & " set SITUACAO = 'I' "
	sql = sql & " where Cod_Grupo = " & Session("CodGrupo")
	sql = sql & " and convert(datetime,convert(varchar, DataFinal, 103),103) < convert(datetime, ' " & date & "',103) "
	sql = sql & " and SITUACAO = 'A' "
	cnn.execute sql

	strPagina						= "ColaboradorSubstitutoModulacao_cad.asp"
	strPaginaTitulo					= "ColaboradorSubstitutoModulacao_cad.asp"
	intCodCodSubistituicao			= Trim(Request("txtCodCodSubistituicao"))
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

	strDataInicial						= Trim(Request("txtDataInicial")) 
	strDataFinal						= Trim(Request("txtDataFinal")) 
	strJustificativa					= Trim(Request.Form("txtJustificativa")) 

	strCPF  							= Trim(Request.Form("txtcpf"))
	intCodFuncional						= Trim(Request.Form("txtCodigoFuncional"))

	intCodFuncional1  					= Trim(Request.Form("txtCodigoFuncional1"))
	intCodFuncional2  					= Trim(Request.Form("txtCodigoFuncional2"))
	
	'Dados carregado pela Justificativa
	strDataLancamentoJustificativa  					= Trim(Request.Form("txtDataLancamentoJustificativa"))
	strDataLancamentoJustificativaFinal  				= Trim(Request.Form("txtDataLancamentoJustificativaFinal"))
	strCodJustificativaFaltas  							= Trim(Request.Form("txtCodJustificativaFaltas"))   
	
	flagJustificativa = ""
	if strCodJustificativaFaltas <> "" and strCodJustificativaFaltas <> "0" then
		strDataInicial						= strDataLancamentoJustificativa
		strDataFinal						= strDataLancamentoJustificativaFinal 
		flagJustificativa = " readonly "
	end if

	intCodTurnoColaboradorSubstituido	= Trim(Request.Form("cmbTurnoColaboradorSubstituido"))
	if intCodTurnoColaboradorSubstituido = "" then intCodTurnoColaboradorSubstituido = "0"

	' Consulta os dados da Subistituição
	if trim(intCodCodSubistituicao) <> "" then
		
		sql = " SELECT CodEmpresaSubstituto, CodColaboradorSubstituto, CodEmpresaSubstituido, CodColaboradorSubstituido, DataInicial, DataFinal, CB.Situacao  "
		sql = sql & " FROM SRH_COLABORADOR_SUBSTITUTO CB"
		sql = sql & " WHERE CB.Situacao = 'A' "
		sql = sql & " AND Cod_Grupo = " & Session("CodGrupo")
		sql = sql & " AND Codigo = " & intCodCodSubistituicao
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
		sql = sql & " FROM SRH_COLABORADOR c"
		sql = sql & " left join SRH_FUNCAOCOLABORADOR f on f.Cod_Funcao = c.codFuncao "
		sql = sql & " Where c.CodFuncional = " & intCodFuncional1
		sql = sql & " And c.Situacao = 'A' "
		sql = sql & " and f.Modular = 'S' " 
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
				window.location = 'ColaboradorSubstitutoModulacao_cad.asp'
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
		sql = sql & " FROM SRH_COLABORADOR c "
		sql = sql & " left join SRH_FUNCAOCOLABORADOR f on f.Cod_Funcao = c.codFuncao "
		sql = sql & " Where c.CodFuncional = " & intCodFuncional2
		sql = sql & " And c.Situacao = 'A'"
		sql = sql & " and f.Modular = 'S' " 
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
			window.location = 'ColaboradorSubstitutoModulacao_cad.asp' 
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
                                <td class="titulo1" align="center" colspan="6"><strong><font size="3">Colaborador Substituto - Modulação</font></strong></td>
                              </tr>
                            
                             
                              <tr>
                                <td height="20" colspan="6" bgcolor="#CCCCCC" class="texto" ><strong> Dados do Substituto - ( Colaborador que assumirá a Modulação )</strong></td>
                                </tr>
                                <td>&nbsp;</td>
                                <td class="titulo1">&nbsp;</td>
                                <td class="titulo1">&nbsp;</td>
                                <td class="titulo1">&nbsp;</td>
                                <td class="titulo1">&nbsp;</td>
                                <td>&nbsp;</td>
                              </tr>
                              <tr>
                                <td width="5%"><span class="TextoForm"><strong>Nome</strong>:</span></td>
                                <td width="37%" class="titulo1"><span class="TextoForm">
                            <input name="txtCodigo" value="<%=intCodigo%>" type="hidden" id="txtCodigo" >
                                  <input name="txtCodCodSubistituicao" value="<%=intCodCodSubistituicao%>" type="hidden" id="txtCodCodSubistituicao" >
                                  <input name="txtCodEmpresaSubstituto" value="<%=intCodEmpresaSubstituto%>" type="hidden" id="txtCodEmpresaSubstituto" >
                                  <input name="txtCodColaboradorSubstituto" value="<%=intCodColaboradorSubstituto%>" type="hidden" id="txtCodColaboradorSubstituto" >
                                  <input name="txtNomeColaboradorSubstituto" type="text" class="text" id="txtNomeColaboradorSubstituto" size="40" readonly maxlength="70" value="<%=strNomeColaboradorSubstituto%>">
                                  <input name="txtDataLancamentoJustificativa" type="hidden" class="text" id="txtDataLancamentoJustificativa" size="40" readonly maxlength="70" value="<%=strDataLancamentoJustificativa%>">
                                  <input name="txtDataLancamentoJustificativaFinal" type="hidden" class="text" id="txtDataLancamentoJustificativaFinal" size="40" readonly maxlength="70" value="<%=strDataLancamentoJustificativaFinal%>">
                                  <input name="txtCodJustificativaFaltas" type="text" class="hidden" id="txtCodJustificativaFaltas" size="40" readonly maxlength="70" value="<%=strCodJustificativaFaltas%>">
                                  <a  href="#" onclick="return abreConsulta('ColaboradorSubstituto_con.asp')" onmouseout="MM_swapImgRestore()" onmouseover="MM_swapImage('Image7','','<%=session("strCaminhoRaiz")%>/images/botao_verde_over.gif',1)"><img alt="Clique para consultar o Colaborador Substituto" src="<%=session("strCaminhoRaiz")%>/images/botao_verde_normal.gif" name="Image7" width="26" height="26" border="0"  align="absmiddle" ></a></span></td>
                                <td width="7%" class="titulo1"><span class="TextoForm"><strong>Matr&iacute;cula Funcional</strong></span>:</td>
                          <td width="20%" class="titulo1"><span class="TextoForm">
                  <input name="txtCodigoFuncional1" type="text" class="text" id="txtCodigoFuncional1" size="12" maxlength="8" value="<%=intCodFuncional1%>"  onKeyPress="return formataCampo(this, 2, 8)">
                                  &nbsp;<strong>*</strong>
                                  <input type="checkbox" name="LocalizarMatricula1" value="S" onClick='submit()'>
                    Localizar?</span></td>
                              <td width="10%" class="titulo1"><strong>CPF:</strong></td>
                              <td width="21%"><input name="txtcpf" type="text" class="text" id="txtcpf" size="15" readonly maxlength="70" value="<%=strCPF%>" />
                              <input name="txtCodigoFuncional" type="hidden"  class="text" id="txtCodigoFuncional" readonly size="12" maxlength="8" value="<%=intCodFuncional%>" >  </td>
                              </tr>
                               <tr>
                                <td colspan="6">&nbsp;</td>
                                </tr>
                              <tr>
                               <td colspan="6" class="titulo1">
                             <%
                            if trim(intCodColaboradorSubstituto) <> "" then
                             
                                cont = 0
                                sql = "select dd.Codigo, dd.Situacao_disciplinar, t.desc_turno as turno, tur.desc_turno as Desc_turno_opcional, dd.Ano_letivo, dd.Semestre, e.RAZAOSOCIAL, (Case when dd.Situacao_disciplinar = 'I' then 21 else dd.Total_Aulas end) as Total_Aulas, "
                                sql = sql & " p.descricao as periodo, d.Desc_Disciplina as disciplina, dd.status, dd.Total_Aulas as saldo, "
                                sql = sql & " f.Desc_Funcao as funcao, isnull(dd.Cod_Substituicao,'0') as Cod_Substituicao, Cod_ColaboradorSubstituido, "
                                sql = sql & " cos.Nome as NomeSubstituido, cos.codfuncional as matricula, Descricao_Motivo "
                                sql = sql & " from SRH_MODULACAO_DISCIPLINAR_DOCENTE dd "
                                sql = sql & " inner join SEG_EMPRESA e on e.CODIGO = dd.Cod_empresa "
                                sql = sql & " left join SRH_FUNCAOCOLABORADOR f on f.cod_funcao = dd.cod_funcao"
                                sql = sql & " left join SCA_disciplina d on d.cod_disciplina = dd.cod_disciplina"
                                sql = sql & " left join SCA_periodo p on p.cod_periodo = dd.cod_periodo"
                                sql = sql & " left join SRH_TURNO t on t.cod_turno = dd.cod_turno"
                                sql = sql & " left join SRH_TURNO tur on tur.cod_turno = dd.cod_turno_opcional "
                                sql = sql & " left join SRH_Colaborador cos on cos.Codigo = dd.Cod_ColaboradorSubstituido "
                                sql = sql & " where dd.Cod_Colaborador = " & intCodColaboradorSubstituto
                                sql = sql & " and dd.status = 'A'"
                                sql = sql & " order by dd.codigo"
								'response.write sql
                                rs.open sql, cnn
                                if rs.eof = false then
                                    %>
                                  <table width = "100%" border="1" align="center" cellpadding="0" cellspacing="0" class="tabela">
                                    <tr bgcolor="#E5E5E5" class="celula">
                                      <td height="29" colspan="12" class="celula"><div align="center"><strong>Modula&ccedil;&atilde;o do Substituto - <%=strNomeColaboradorSubstituto%></strong></div></td>
                                      </tr>
                                    <tr bgcolor="#E5E5E5" class="celula">
                                      <td class="celula">Excluir</td>
                                      <td class="celula">Unidade</td>
                                    <td class="celula">Fun&ccedil;&atilde;o</td>
                                    <td width="96" height="26" class="celula">Per&iacute;odo</td>
                                    <td width="82" class="celula">Turno</td>
                                    <td width="28" class="celula">Ano</td>
                                    <td width="56" class="celula">Semestre</td>
                                    <td class="celula">Situação</td>
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
                    
                                        
                                        turno = rs("turno")
                                        
                                        if not isnull(rs("Desc_turno_opcional")) then
                                            turno = rs("Desc_turno_opcional")
                                        end if
                                        
                                        if isnull(rs("Cod_ColaboradorSubstituido")) then 
                                           strorigem = "CONTRATUAL"	
                                        else				
                                           strorigem = "SUBSTITUICAO"	
                                        end if

                                        if isnull(rs("Descricao_Motivo")) or trim(rs("Descricao_Motivo")) = ""  then 
                                            strDescricaoMotivo = ""
                                        else				
                                            strDescricaoMotivo = " / Motivo: " & trim(rs("Descricao_Motivo"))
                                        end if
					
                                       %>
                                       <tr bgcolor="#FFFFFF">
                                       <td width="33" class="celula" align="center">
                                       <% if strorigem = "SUBSTITUICAO" then %>
                                           <a href="#" onClick="ExcluirSubstituicao('<%=rs("codigo")%>')"  onMouseOut="MM_swapImgRestore()" onMouseOver="MM_swapImage('999','','<%=session("strCaminhoRaiz")%>/images/botao_vermelho_over.gif',1)"><img alt="Clique para excluir a Substituicao " align="absmiddle" src="<%=session("strCaminhoRaiz")%>/images/botao_vermelho_normal.gif" name="Image2" width="15" height="15" border="0"></a>  
                                            
                                             <% else %>
                                       	  ---- 
                                          <% end if %>                                       </td>
                                       <td width="435" class="celula"><strong><font size="-2">&nbsp;<%=ucase(trim(rs("RAZAOSOCIAL")))%></font></strong></td>
                                       <td width="196" class="celula"><strong><font size="-2">&nbsp;<%=ucase(trim(rs("funcao")))%></font></strong></td>
                                       <td height="26" class="celula"><strong><font size="-2">&nbsp;<%=ucase(trim(rs("periodo")))%></font></strong></td>
                                       <td class="celula"><strong><font size="-2">&nbsp;<%=ucase(trim(turno))%></font></strong></td>
                                       <td height="26" class="celula"><strong><font size="-2">&nbsp;<%=ucase(trim(rs("Ano_letivo")))%></font></strong></td>
                                       <td height="26" class="celula"><strong><font size="-2">&nbsp;<%=ucase(trim(strMsgSemestre))%></font></strong></td>
                                       <td width="53" class="celula"><strong><font size="-2">&nbsp;<%=ucase(strSituacaoDisciplinar)%></font></strong></td>
                                       <td width="177" height="26" class="celula"><strong><font size="-2">&nbsp;<%=ucase(trim(rs("disciplina")))%></font></strong></td>
                                       <td width="63" class="celula"><div align="center"><strong><font size="-2"><%=ucase(trim(rs("Total_Aulas")))%>&nbsp;</font></strong></div></td>
                                       <td width="49" class="celula">&nbsp;<strong><font size="-2"><%=ucase(trim(strorigem))%></font></strong></td>
                                       </tr>
                                       <% if strorigem = "SUBSTITUICAO" then %>
                                            <tr bgcolor="#FFFFFF">
                                            <td height="26" colspan="11" align="center" class="celula"><strong><font size="-2">Substituido:&nbsp;<%=ucase(trim(rs("NomeSubstituido")))%> - Matrícula:&nbsp;<%=ucase(trim(rs("matricula")))%><%=ucase(strDescricaoMotivo)%></font></strong></td>
                                            </tr>
                                        <% end if %> 
                                       <%				
                                       rs.movenext
                                    wend
                                    %>
                                 </table>
                              <br>
                                    <%
                                else 
                                    strDesabilitaIncluir 	= "" ' Desabilita o botão Incluir
                                    strDesabilitaAlterar 	= "disabled" ' Desabilita o botão Alterar
                                    %>
                                    <script>
                                        //alert("Colaborador Substituto ainda não Modulado. Verifique!")
                                    </script>
                                    <%
                                end if
                                rs.close
                        
                             end if
                             %>                             </td>
                             </tr>
                              <tr>
                                <td   height="20" colspan="6" bgcolor="#CCCCCC" class="texto"  ><strong>Dados do Substituído - ( Colaborador que disponibilizará a Modulação )</strong></td>
                              </tr>
                              <tr>
                                <td colspan="6">&nbsp;</td>
                                </tr>
                              <tr>
                                <td><span class="TextoForm"><strong>Nome:</strong></span></td>
                                <td><span class="TextoForm">
                                  <input name="txtCodEmpresaSubstituido" value="<%=intCodEmpresaSubstituido%>" type="hidden" id="txtCodEmpresaSubstituido" >
                                  <input name="txtCodColaboradorSubstituido" value="<%=intCodColaboradorSubstituido%>" type="hidden" id="txtCodColaboradorSubstituido" >
                                  <input name="txtNomeColaboradorSubstituido" type="text" class="text" id="txtNomeColaboradorSubstituido" size="40" readonly maxlength="70" value="<%=strNomeColaboradorSubstituido%>">
                                  <a  href="#" onclick="return abreConsulta('<%=paginaConsultaSbstituido%>')" onmouseout="MM_swapImgRestore()" onmouseover="MM_swapImage('Image7','','<%=session("strCaminhoRaiz")%>/images/botao_verde_over.gif',1)"><img alt="Clique para consultar o Colaborador Substituído" src="<%=session("strCaminhoRaiz")%>/images/botao_verde_normal.gif" name="Image7" width="26" height="26" border="0"  align="absmiddle" ></a></span></td>
                                <td><span class="titulo1"><span class="TextoForm"><strong>Matr&iacute;cula Funcional</strong></span>:</span></td>
                                <td colspan="3"><span class="TextoForm">
                                  <input name="txtCodigoFuncional2" type="text" class="text" id="txtCodigoFuncional2" size="12" maxlength="8" value="<%=intCodFuncional2%>"  onKeyPress="return formataCampo(this, 2, 8)">
                    &nbsp;<strong>*</strong>
                    <input type="checkbox" name="LocalizarMatricula2" value="S" onClick='submit()'>
                    Localizar?</span></td>
                              </tr>
                              <tr>
                                <td><span class="TextoForm"><strong>Data Inicial:</strong></span></td>
<td><span class="TextoForm">
                                  <input name="txtDataInicial" type="text" class="text" id="txtDataInicial" onblur="validaData(this);validaSeJaExisteSubstituto('<%=situacaoAlteracao%>');"  onKeyPress="return formataCampo(this, 3, 10)" size="11" value="<%=strDataInicial%>"  style="cursor:hand" title="Click aqui para visualizar o calend&aacute;rio">
                                </span></td>
                                <td><span class="TextoForm"><strong>Data Final:</strong></span></td>
<td><span class="TextoForm">
                                  <input name="txtDataFinal" type="text" class="text" id="txtDataFinal" onblur="validaData(this);verificaDatas();validaSeJaExisteSubstituto('<%=situacaoAlteracao%>');" onkeypress="return formataCampo(this, 3, 10)" size="11" value="<%=strDataFinal%>"  style="cursor:hand" title="Click aqui para visualizar o calendário" />
                                </span></td>
                                <td colspan="2"><div align="center">
                                  <input type="button" name="cmdAbonoFaltas" style="cursor:hand"   value="Abono de Faltas - Últimos Lançamentos" class="btn-u float-shadow" onclick="return 	VisualizarAbonoFaltas('<%=intCodColaboradorSubstituido%>')" />
                                </div></td>
                                </tr>
                              
                                   <tr>
                                     <td><div align="center"><strong>Justificar:</strong></div></td>
                                     <td colspan="4"><textarea onkeyup="blocTexto(this.value,'<%=cont%>')" name="txtJustificativa" cols="60" rows="3" class="text" id="txtJustificativa"><%=strJustificativa%></textarea><font color="#FF0000">(caracteres restantes: <span id="cont">200</span>)</font></td>
                                     <td><div align="center">
                                  <input type="button" name="cmdAbonoFaltas" style="cursor:hand"   value="Modulação" class="btn-u float-shadow" onclick="return 	ChamarModulacao('<%=intCodColaboradorSubstituto%>')" />
                                </div></td>
                                   </tr>  
                                   <tr>
                                     <td colspan="6"><div align="center"></div></td>
                                   </tr>

                              <tr>
                                <td colspan="6">&nbsp;</td>
                                </tr>
                              
                              <tr>
                               <td colspan="6" class="titulo1">
                             <%
                            if trim(intCodColaboradorSubstituido) <> "" then
                             
                                cont = 0
                                sql = "select dd.Codigo, dd.Situacao_disciplinar, t.desc_turno as turno, tur.desc_turno as Desc_turno_opcional, dd.Ano_letivo, dd.Semestre, e.RAZAOSOCIAL, (Case when dd.Situacao_disciplinar = 'I' then 21 else dd.Total_Aulas end) as Total_Aulas, "
                                sql = sql & " p.descricao as periodo, d.Desc_Disciplina as disciplina, dd.status, dd.Total_Aulas as saldo, "
                                sql = sql & " f.Desc_Funcao as funcao, isnull(dd.Cod_Modulacao_Substituicao,'0') as Cod_Substituicao, (Case when dd.Situacao_disciplinar = 'I' and isnull(dd.Saldo_Substituicao,'0')<>'0' then 21 else isnull(dd.Saldo_Substituicao,'0') end) as Saldo_Substituicao "
                                sql = sql & " from SRH_MODULACAO_DISCIPLINAR_DOCENTE dd "
                                sql = sql & " inner join SEG_EMPRESA e on e.CODIGO = dd.Cod_empresa "
                                sql = sql & " left join SRH_FUNCAOCOLABORADOR f on f.cod_funcao = dd.cod_funcao"
                                sql = sql & " left join SCA_disciplina d on d.cod_disciplina = dd.cod_disciplina"
                                sql = sql & " left join SCA_periodo p on p.cod_periodo = dd.cod_periodo"
                                sql = sql & " left join SRH_TURNO t on t.cod_turno = dd.cod_turno"
                                sql = sql & " left join SRH_TURNO tur on tur.cod_turno = dd.cod_turno_opcional "
                                sql = sql & " where dd.Cod_Colaborador = " & intCodColaboradorSubstituido
                                sql = sql & " and dd.status = 'A'"
                                sql = sql & " order by dd.codigo"
								'response.write sql
                                rs.open sql, cnn
                                if rs.eof = false then
                                    %>
                                  <table width = "100%" border="1" align="center" cellpadding="0" cellspacing="0" class="tabela">
                                    <tr bgcolor="#E5E5E5" class="celula">
                                      <td height="29" colspan="14" class="celula"><div align="center"><strong>Modula&ccedil;&atilde;o do Substituido - <%=strNomeColaboradorSubstituido%></strong></div></td>
                                    </tr>
                                    <tr bgcolor="#E5E5E5" class="celula">
                                      <td class="celula">Unidade</td>
                                    <td class="celula">Fun&ccedil;&atilde;o</td>
                                    <td width="95" height="26" class="celula">Per&iacute;odo</td>
                                    <td width="81" class="celula">Turno</td>
                                    <td width="27" class="celula">Ano</td>
                                    <td width="56" class="celula">Semestre</td>
                                    <td class="celula">Situação</td>
                                    <td class="celula">Disciplina</td>
                                    <td class="celula">Total<br>
                                      Modulado</td>
                                    <td class="celula">Origem</td>
                                    <td class="celula">Aulas</td>
                                    <td class="celula">Saldos Atual</td>
                                    <td class="celula">Status da Substituição</td>
                                    </tr>
                                    <%
                                    while not rs.eof
                                       cont = cont + 1	
									   intAulasSubstituicao = trim(request.Form("txtAulasSubstituicao_"& rs("codigo"))) 
									   if intAulasSubstituicao = "" then intAulasSubstituicao = 0
										
										' Novas regras

                                       strSituacaoDisciplinar = rs("Situacao_disciplinar")
                                       if strSituacaoDisciplinar = "D" then strSituacaoDisciplinar = "Disciplinar"
                                       strMsgSemestre = trim(rs("Semestre"))
                                       if strMsgSemestre = "3" then strMsgSemestre = "Anual"

                                        if rs("Cod_Substituicao") = "0" then 
                                           strorigem = "CONTRATUAL"	
                                        else				
                                           strorigem = "SUBSTITUICAO"	
                                        end if
										if rs("Total_Aulas") = rs("Saldo_Substituicao") then 
											strBloqueiaCampo = " readonly "
											strBloqueiaCampo = ""
											intAulasSubstituicao = "0"
										else
											strBloqueiaCampo = ""
										end if
										strSaldoSubstituicao = (rs("Total_Aulas") - rs("Saldo_Substituicao")) - intAulasSubstituicao  
									    turno = rs("turno")
                    
                                       %>
                                       <tr bgcolor="#FFFFFF">
                                         <td width="235" class="celula"><strong><font size="-2">&nbsp;<%=ucase(trim(rs("RAZAOSOCIAL")))%></font></strong></td>
                                       <td width="193" class="celula"><strong><font size="-2">&nbsp;<%=ucase(trim(rs("funcao")))%></font></strong></td>
                                       <td height="26" class="celula"><strong><font size="-2">&nbsp;<%=ucase(trim(rs("periodo")))%></font></strong></td>
                                       <td class="celula"><strong><font size="-2">&nbsp;<%=ucase(trim(turno))%></font></strong></td>
                                       <td height="26" class="celula"><div align="center"><strong><font size="-2">&nbsp;<%=ucase(trim(rs("Ano_letivo")))%></font></strong></div></td>
                                       <td height="26" class="celula"><div align="center"><strong><font size="-2">&nbsp;<%=ucase(trim(strMsgSemestre))%></font></strong></div></td>
                                       <td width="52" class="celula"><div align="center"><strong><font size="-2">&nbsp;<%=ucase(strSituacaoDisciplinar)%></font></strong></div></td>
                                       <td width="175" height="26" class="celula"><strong><font size="-2">&nbsp;<%=ucase(trim(rs("disciplina")))%></font></strong></td>
                                       <td width="63" class="celula"><div align="center"><strong><font size="-2"><%=ucase(trim(rs("Total_Aulas")))%>&nbsp;</font></strong></div></td>
                                       <td width="83" class="celula">&nbsp;<strong><font size="-2"><%=ucase(trim(strorigem))%></font></strong></td>
                                     <td width="34" class="celula"><div align="center">&nbsp;<span class="TextoForm">
                                         <input <%=strBloqueiaCampo%> name="txtAulasSubstituicao_<%=trim(rs("Codigo"))%>" type="text" class="text" id="txtAulasSubstituicao_<%=trim(rs("Codigo"))%>" size="3" maxlength="3" value="<%=intAulasSubstituicao%>"  onkeypress="return formataCampo(this, 2, 2)"/>
                                       </span>&nbsp;</div></td>
                                       <td width="45" class="celula"><div align="center"><strong><font size="-2"><%=strSaldoSubstituicao%></font></strong></div></td>
                                       <td width="125" class="celula">&nbsp;</td>
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
                             %>                             </td>
                             </tr>
							 <%if strNomeColaboradorSubstituto <> "" and strNomeColaboradorSubstituido <> "" then  %>
                              <tr>
                                <td colspan="6" class="texto" align="center">Obs.: Para um melhor entedimento o(a) Professor(a) <strong><%=strNomeColaboradorSubstituto%></strong> estar&aacute; substituindo a(o) professor(a) <strong><%=strNomeColaboradorSubstituido%></strong> no período informado. </span></td>
                              </tr>
                              <%end if%>
                              
                              <tr>
                                <td colspan="6">&nbsp;
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
					
                    %>                                </td>
                              </tr>
                                <tr>
                                <td colspan="6"><!--#include file="../../includes/inc_botoes_cadastro.asp"--></td>
                              </tr>
                               
                    <%
                    
                   ''if strSituacaoSubstituicao<>"" then
				   %>
                         <tr>
                            <td colspan="6">
                              <% 
                               cont1 = 0
                              %>
                                  <table width = "100%" border="1" align="center" cellpadding="0" cellspacing="0" class="tabela">
                                         <tr>
                                        <td height="42" colspan="16" align="center" class="celula"><span class="texto"><strong><font color="#CC0000">Mostrar lançamento?</font><strong>
                                            <select name="cmbSituacaoSubstituicao" class="combo"  onchange="submit()" id="cmbSituacaoSubstituicao" style="width:150pt">
                                              <option value="" <%if strSituacaoSubstituicao = "" then response.Write("selected") %>>Selecione... </option>
                                              <option value="A" <%if strSituacaoSubstituicao = "A" then response.Write("selected") %>>Ativo </option>
                                              <option value="I" <%if strSituacaoSubstituicao = "I" then response.Write("selected") %>>Inativo</option>
                                            </select>
                                        - <strong><font color="#CC0000">Selecionar para mostrar as substituições ativas ou inativas.</font><strong></span></td>
                                      </tr>
                                         

 
                                        <tr bgcolor="#E5E5E5">
                                          <td width="68" rowspan="3" align="center" class="celula"><strong>C</strong><strong>&oacute;d.<br>
                                            Funcional </strong></td>
                                          <td rowspan="3" align="center" class="celula"><strong>Ano</strong></td>
                                          <td rowspan="3" align="center" class="celula"><strong>Semestre</strong></td>
                                          <td rowspan="3" align="center" class="celula"><strong>Per&iacute;odo<br>
                                            In&iacute;cio e Fim</strong></td>
                                          <td colspan="5" class="celula">&nbsp;</td>
                                          <td colspan="2" class="celula">&nbsp;</td>
                                          <td rowspan="3" align="center" class="celula"><strong>Tipo</strong></td>
                                          <td rowspan="3" align="center" class="celula"><strong>Situa&ccedil;&atilde;o</strong></td>
                                          <td colspan="3" rowspan="3" align="center" class="celula"><strong>A&ccedil;&atilde;o</strong></td>
                                        </tr>
                                    <tr bgcolor="#E5E5E5">
                                      <td colspan="5" class="celula"><div align="center"><strong>  Substituto </strong></div></td>
                                      <td colspan="2" class="celula"><div align="center"><strong> Substitu&iacute;do</strong></div></td>
                                    </tr>
                                    <tr bgcolor="#E5E5E5">
                                      <td class="celula"><div align="center"><strong>Colaborador</strong></div></td>
                                      <td class="celula"><div align="center"><strong>Unidade</strong></div></td>
                                      <td class="celula"><div align="center"><strong>Período</strong></div></td>
                                      <td class="celula"><div align="center"><strong>Disciplinas</strong></div></td>
                                      <td class="celula"><div align="center"><strong>Aulas</strong></div></td>
                                      <td class="celula"><div align="center"><strong>Colaborador</strong></div></td>
                                      <td class="celula"><div align="center"><strong>Unidade</strong></div></td>
                                    </tr>
                                    <%
                                    
                                    sql = " SELECT "  
                                    sql = sql & " MD.Codigo, "
                                    sql = sql & " MD.Cod_Empresa as CodEmpresaSubstituto, "
                                    sql = sql & " MDD.Cod_Empresa as CodEmpresaSubstituido, "
                                    sql = sql & " CS.CodFuncional as CodFuncionalSubstituto, "
                                    sql = sql & " CSS.CodFuncional as CodFuncionalSubstituido, "
                                    sql = sql & " CS.Codigo as CodColaboradorSubstituto, "
                                    sql = sql & " CSS.Codigo as CodColaboradorSubstituido, "
                                    sql = sql & " CS.Nome as NomeColaboradorSubstituto, "
                                    sql = sql & " CSS.Nome as NOmeColaboradorSubstituido, "
                                    sql = sql & " ES.RAZAOSOCIAL as Empresa_Substituto, "
                                    sql = sql & " ESS.RAZAOSOCIAL as Empresa_Substituido, "
                                    sql = sql & " MD.DataInicial, "
                                    sql = sql & " MD.DataFinal, "
                                    sql = sql & " MD.Status, "
                                    sql = sql & " MD.Total_Aulas, "
                                    sql = sql & " isnull(JF.Descricao,'--') AS TipoFalta, "
                                    sql = sql & " d.Desc_Disciplina as disciplina, "
                                    sql = sql & " p.descricao as periodo, "
                                    sql = sql & " f.Desc_Funcao as funcao, "
                                    sql = sql & " MD.Ano_letivo, " 
                                    sql = sql & " MD.Semestre "
                                    sql = sql & " FROM SRH_MODULACAO_DISCIPLINAR_DOCENTE MD "
                                    sql = sql & " INNER JOIN SRH_MODULACAO_DISCIPLINAR_DOCENTE MDD ON MDD.CODIGO  = MD.Cod_Modulacao_Substituicao " 
                                    sql = sql & " INNER JOIN SRH_COLABORADOR CS ON CS.CODIGO = MD.Cod_Colaborador  "
                                    sql = sql & " INNER JOIN SRH_COLABORADOR CSS ON CSS.CODIGO = MDD.Cod_Colaborador "
                                    sql = sql & " LEFT JOIN SEG_EMPRESA ES on ES.CODIGO = MD.Cod_Empresa "
                                    sql = sql & " LEFT JOIN SEG_EMPRESA ESS on ESS.CODIGO = MDD.Cod_Empresa "
                                    sql = sql & " LEFT JOIN SRH_JUSTIFICATIVAFALTAS JF ON JF.Codigo = MD.Cod_JustificativaFaltas "
                                    sql = sql & " left join SRH_FUNCAOCOLABORADOR f on f.cod_funcao = MD.cod_funcao "
                                    sql = sql & " left join SCA_disciplina d on d.cod_disciplina = MD.cod_disciplina " 
                                    sql = sql & " left join SCA_periodo p on p.cod_periodo = MD.cod_periodo " 
                                    sql = sql & " left join SRH_TURNO t on t.cod_turno = MD.cod_turno " 
                                    sql = sql & " left join SRH_TURNO tur on tur.cod_turno = MD.cod_turno_opcional " 
                                    sql = sql & " WHERE 1=1 "
									if intCodColaboradorSubstituto = "" or intCodColaboradorSubstituido = "" then
										sql = sql & " and CS.Codigo = 9999999999999 "
									else
                                   		sql = sql & " and ( CS.Codigo = " & intCodColaboradorSubstituto & " or CSS.Codigo = " & intCodColaboradorSubstituido & ")" 
									end if
                                    if strSituacaoSubstituicao = "A" then
                                        sql = sql & " AND MD.Status = 'A'"
                                    end if	
                                    if strSituacaoSubstituicao = "I" then
                                        sql = sql & " AND MD.Status = 'I'"
                                    end if	 
                                    sql = sql & " order by MD.Codigo desc"	
                                    rs.open sql, cnn
                                    if rs.eof = false then
                                    while not rs.eof
                                        cont1 = cont1 + 1	
                                        strMarca 	= ""

                                       strMsgSemestre = trim(rs("Semestre"))
                                       if strMsgSemestre = "3" then strMsgSemestre = "Anual"
                
                                        sit = "<strong>Ativo</strong>"
                                        if rs("Status")="I" then sit = "Inativo"
                                        %>
                                        <tr>
                                        <td align="center" class="celula"><strong><font size="-2">&nbsp;<%=trim(rs("CodFuncionalSubstituto"))%></font></strong></td>
                                        <td width="76" align="center" class="celula"><strong><font size="-2">&nbsp;<%=trim(rs("Ano_letivo"))%></font></strong></td>
                                        <td width="76" align="center" class="celula"><strong><font size="-2">&nbsp;<%=trim(strMsgSemestre)%></font></strong></td>
                                        <td width="76" align="center" class="celula"><strong><font size="-2">&nbsp;<%=trim(formataDataAP(rs("DataInicial")))%><BR>a<BR><%=formataDataAP(trim(rs("DataFinal")))%></font></strong></td>
                                        <td width="141" class="celula"><strong><font size="-2">&nbsp;<%=trim(rs("NomeColaboradorSubstituto"))%></font></strong></td>
                                        <td width="215" class="celula"><strong><font size="-2">&nbsp;<%=trim(rs("Empresa_Substituto"))%></font></strong></td> 
                                        <td width="75" class="celula" align="center"><strong><font size="-2">&nbsp;<%=trim(rs("periodo"))%></font></strong></td>
                                        <td width="186" class="celula"><strong><font size="-2">&nbsp;<%=trim(rs("DISCIPLINA"))%></font></strong></td>
                                        <td width="49" class="celula" align="center"><strong><font size="-2">&nbsp;<%=trim(rs("TOTAL_AULAS"))%></font></strong></td>
                                        <td width="136" class="celula"><strong><font size="-2">&nbsp;<%=trim(rs("NOmeColaboradorSubstituido"))%></font></strong></td>
                                        <td width="119" class="celula"><strong><font size="-2">&nbsp;<%=trim(rs("Empresa_Substituido"))%></font></strong></td>
                                        <td width="30" align="center" class="celula"><strong><font size="-2">&nbsp;<%=trim(rs("TipoFalta"))%></font></strong></td>
                                        <td width="58" align="center" class="celula"><strong><font size="-2">&nbsp;<%=sit%></font></strong></td>
                                        <td width="26" align="center" class="celula">
                                       	<a href="#" onClick="ExcluirSubstituicao('<%=rs("codigo")%>')"  onMouseOut="MM_swapImgRestore()" onMouseOver="MM_swapImage('999','','<%=session("strCaminhoRaiz")%>/images/botao_vermelho_over.gif',1)"><img alt="Clique para excluir a Substituicao " align="absmiddle" src="<%=session("strCaminhoRaiz")%>/images/botao_vermelho_normal.gif" name="Image2" width="26" height="26" border="0"></a>
										</td>
                                        <td width="26" align="center" class="celula">
                                        <% if rs("Status") <> "I" then %>
                                        	<a href="#" onclick="Inativar('<%=rs("codigo")%>')" ><img src="../../images/botao_azul_normal.gif" alt="Inativar Subistituição" width="26" height="26" border="0"></a>
                                        <% else %>
                                        	---
                                        <% end if %>                                        </td>
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
                              </table>                                      </td>
                          </tr>
                          <%if intCodColaboradorSubstituto <> "" and intCodColaboradorSubstituido <> "" then %>
                          <tr>
                            <td colspan="6" class="text"><strong>Substituições listadas:&nbsp;<%=cont1%></strong></td>
                          </tr>
                          <% end if %>
                          <tr>
                            <td colspan="6">&nbsp;</td>
                          </tr>
                    <%'end if%>          
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

	function blocTexto(valor, id)
	{
		quant = 200;
		total = valor.length;
		if(total <= quant)
		{
			resto = quant - total;
			document.getElementById('cont').innerHTML = resto;
		}
		else
		{
			document.getElementById('txtResposta_'+id).value = valor.substr(0,quant);
		}
	}


	function resultadoConsulta(CodSubistituicao){
		frm.txtCodCodSubistituicao.value=CodSubistituicao;
		frm.txtCodigo.value=CodSubistituicao;
		frm.txtCodJustificativaFaltas.value="";
		frm.submit();

	}
	function emitir(codigo,cod_deficit){
		
		var frm = document.getElementById("frm");
		if (cod_deficit=='0')
			frm.action="ColaboradorSubstitutoModulacaoDeficit_rel.asp?CodSubstituicao=" + codigo;
		else
			frm.action="ColaboradorSubstitutoModulacao_rel.asp?CodSubstituicao=" + codigo;
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
				
			frm.action="ColaboradorSubstitutoModulacao_cod.asp?acao="+acao+"&txtCodColaboradorSubstituto="+intCodColaboradorSubstituto+"&txtCodColaboradorSubstituido="+intCodColaboradorSubstituido;
			frm.submit();
			return true;

		} else {
			return false;
		}
	}
	
	function Inativar(codigo){
				
		var men = 'ATENÇÃO: Deseja Inativar essa Substituição ?'
if (confirm(men)) {
				
			frm.action="ColaboradorSubstitutoModulacaoInativar_cad.asp?txtCodigo="+codigo;
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

		if(frm.txtCodColaboradorSubstituido.value == ""){
			alert("O Nome do Funcionario Substituido deve ser informado!");
			frm.txtNomeColaboradorSubstituto.focus();
			return false		
		}
		
		if(frm.txtCodColaboradorSubstituto.value == frm.txtCodColaboradorSubstituido.value){
			alert("O Substituto não pode ser Igual ao Substituido!");
			frm.txtCodColaboradorSubstituto.focus();
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

		if(frm.txtCodJustificativaFaltas.value == ""){
			if(frm.txtJustificativa.value == ""){
				alert("A Justificar o motivo do lancamento sem o devido abono!");
				frm.txtJustificativa.focus();
				return false		
			}
		}

     	frm.cmdIncluir.disabled = true;
		frm.action="ColaboradorSubstitutoModulacao_cod.asp?acao=" + acao;
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
			caminho = "ColaboradorSubstitutoModulacao_cad.asp"
		}	
		if (frm.optTipoModulacao[1].checked) {
			caminho = "ColaboradorSubstitutoDiretrizes_cad.asp"
		}	

		frm.action = caminho;
		frm.submit();
		
		return true;	
	}
	
	function VisualizarAbonoFaltas(CodColaboradorSubstituido){
		if (CodColaboradorSubstituido == ""){
			alert("O Colaborador Substituído deve ser informado.")
			return false;		
		}else{
		window.open("ColaboradorSubstitutoModulacaoAbonoFaltas_con.asp?CodColaboradorSubstituido=" + CodColaboradorSubstituido,"consulta", "top=0,left=0,height=450,width=1100,menubar=no,toolbar=no,scrollbars=yes,status=yes");
		}
	}
	
	function ExcluirSubstituicao(CodigoModulacaoExcluir){
		var acao ="ES";
		var frm = document.getElementById("frm");
		frm.action = "ColaboradorSubstitutoModulacao_cod.asp?acao=" + acao + "&CodigoModulacaoExcluir=" + CodigoModulacaoExcluir;
		frm.submit()
	}
	
	function ChamarModulacao(CodColaboradorSubstituto){
		if (CodColaboradorSubstituto == ""){
			alert("O Colaborador Substituto deve ser informado.")
			return false;		
		}else{
			frm.action= "ModulacaoNovo_cad.asp?txtCodFuncionario="+CodColaboradorSubstituto;
			frm.submit();
		}
	}
		
</script>

    <!--=== End Content Part ===-->
   	<!--#include file="../RodapeModulo.asp"-->
	<!--#include file="../jsModulo.asp"-->
    <% 	if strCodJustificativaFaltas = "" or strCodJustificativaFaltas = "0" then %>
		<!--#include file="../../js/Calendario/Calendario.asp"-->
    <% end if %>
</body>
</html> 