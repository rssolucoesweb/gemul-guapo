<!--#include file="../ConfigModulo.asp"-->
<!--#include file="../../includes/inc_cnn.asp"-->
<!--#include file="../../includes/inc_formatadata.asp"-->
<!--#include file="../menuModulos.asp"-->
<!--#include file="../includes/inc_sqlAlunoTurma.asp"-->
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
        session("voltarPaginaParaColaboradorModulacao") = ""
        strExecutarSubmitCurso = "S"
        strExecutarSubmitPeriodo = "S"
        strExecutarSubmitTurno = "S"
        strReloadDisciplinaQuadro = "S"
        strEmpresaGrupo_submit = "S"
        strExecutarSubmitColaborador = "S"
        strSubmitFuncao = " onchange='submit()' "
    
        pagina							= "Rel_ModulacaoColaborador_con.asp"
        intCodColaborador				= Trim(Request.form("txtCodFuncionario"))
        intCodFuncional  				= Trim(Request.Form("txtCodigoFuncional"))
        strnome 						= Trim(Request.Form("txtNomeFuncionario"))
        
        if trim(request("txtAnoLetivo")) = "" then 
            strAnoLetivo = session("strAnoLetivo")
        else
            strAnoLetivo = request.Form("txtAnoLetivo")
        end if
        strSemestre 					= session("strSemestre")
        
        intCodEmpresa 					= Session("CodEmpresa")
        intCodEmpresaGrupo				= Trim(Request.Form("cmbEmpresaGrupo"))
        
        intCodFuncao					= Trim(Request.Form("cmbFuncao"))
        intCodPeriodo					= Trim(Request.Form("cmbPeriodo"))
        intCodCursoCombo				= Trim(Request.Form("cmbCursoCombo"))
        intCodColaboradorModulacao		= Trim(Request.Form("cmbColaboradorModulacao"))	
        strPorPeriodo					= Trim(Request.Form("optPorPeriodo"))	
        
        if intCodEmpresaGrupo="" then intCodEmpresaGrupo = "0"
        if intCodEmp = "" then intCodEmp = session("codEmpresa")
        if trim(request("cmbSemestre")) = "0" or trim(request("cmbSemestre")) = ""  then 
            intSemestre = session("strSemestre")
        else
            intSemestre = request.Form("cmbSemestre")
        end if
    
        intCodTurno					 		= Trim(Request.Form("cmbTurno"))
        intCodDisciplina 					= Trim(Request.Form("cmbDisciplina"))
        intTotalAulas 						= Trim(Request.Form("txtTotalAulas"))
        strSituacao							= Trim(Request.Form("cmbSituacao"))	
        strTipoLancamento					= Trim(Request.Form("optTipoLancamento"))	
        strTipoModulacao					= Trim(Request.Form("optTipoModulacao"))	
        strPeriodoInicial					= Trim(Request.Form("txtPeriodoInicial"))	
        strPeriodoFinal						= Trim(Request.Form("txtPeriodoFinal"))	
        intCodTurnoColaborador = intCodTurno
        
        if intCodColaboradorModulacao = "" then intCodColaboradorModulacao = "0"
        if intCodTurnoColaborador = "" then intCodTurnoColaborador = "0"
        if intCodTurno = "" then intCodTurno = "0"
        if intCodFuncao = "" then intCodFuncao = "0"
        if intCodPeriodo = "" then intCodPeriodo = "0"
        if intCodDisciplina = "" then intCodDisciplina = "0"
        if intCodColaborador = "" then intCodColaborador = "0"
        if intCodCursoCombo = "" then intCodCursoCombo = "0"
        if strSituacao = "0" then strSituacao = "A"
            
        if Trim(Request.Form("LocalizarMatricula")) = "S" and intCodFuncional <> "" then
        
            sql = " Select c.codigo, c.nome, c.cpf, f.Tipo_Funcao, c.cod_nivel, c.codFuncao, c.situacao, "
            sql = sql & " c.codFuncional, tu.Desc_Turno as turno, c.cpf, n.Descricao as nivel, f.Desc_Funcao as funcao, "
            sql = sql & " ca.desc_categoria as categoria, isnull(n.total_aulas,0) as total_aulas_nivel, isnull(c.total_aulas,0) as total_aulas, c.cod_empresa"
            sql = sql & " from srh_colaborador c"
            
            if request("cmbNivel")<>"0" and request("cmbNivel")<>"" then
                sql = sql & " left join srh_nivel n on n.codigo = " & request("cmbNivel")
            else
                sql = sql & " left join srh_nivel n on n.codigo = c.cod_nivel"
            end if
            
            sql = sql & " left join SRH_FUNCAOCOLABORADOR f on f.cod_funcao = c.codfuncao"
            sql = sql & " left join SRH_CATEGORIA ca on ca.Cod_Categoria = c.CodCategoria "
            sql = sql & " left join SRH_TURNO tu on tu.Cod_Turno = c.CodTurno "
            sql = sql & " where C.CodFuncional = " & intCodFuncional
            
            rs.open sql, cnn
            if rs.eof = false then
                
                intCodColaborador			= rs("Codigo")
                intCodEmp           		= rs("Cod_Empresa")
                strnome 					= Trim(Rs("nome"))
                intCodFuncional				= Trim(Rs("CodFuncional"))
                strNivel					= Trim(Rs("nivel"))
                strFuncao					= Trim(Rs("funcao"))
                strTurnoContratado			= rs("turno")
                strCategoria				= Trim(Rs("categoria"))
                intContratado	 			= rs("total_aulas")
                intContratadoNivel			= rs("total_aulas_nivel")
                strTipo_Funcao				= rs("Tipo_Funcao")
                strCPF  					= Trim(Rs("CPF"))
                strSituacaoColaborador 		= rs("situacao")
                intCodFuncaoColaborador		= rs("codFuncao")
                
                bolColaboradorEncontrato = "S"
                strDesabilitaIncluir	= "" 'Desabilita o botão Incluir
                strDesabilitaAlterar 	= "disabled" 'Desabilita o botão Excluir
                strDesabilitaExcluir	= "disabled" 'Desabilita o botão Excluir
                
            else
                %>
                    <script>
                        alert("Matrícula não Localizada. Verifique!")
                        window.location='Rel_ColaboradorSubstituto_con.asp';
                    </script>
                <%
                response.end	
            end if
            rs.close
        end if
        
        strSomenteProfessor = ""
        if strTipoModulacao = "FUNCIONARIO" then strSomenteProfessor = "style='display:none'"
        strMostraPeriodo = "style='display:none'"
    
    %>
    <!--=== Content Part ===-->
	<form method="post" id="frm" action="#">
    <input name="txtCarregado" id="txtCarregado" value="<%=strCarregado%>" type="hidden" >
    <div class="container content">		
      <!-- Grey Panel -->            
      <div class="panel panel-grey">
        <div class="panel-heading">
        	<h3 class="panel-title"><i class="fa fa-tasks"></i>Modulação Colaborador</h3>
        </div>
        <!-- Inicia o Painel do Formulario -->     
        <div class="panel-body">
             <!-- Inicia o Form -->     
            <div class="panel-body">                                                        
                    
                    <div class="form-group">
                    
                    	<table width="96%" border="0" cellpadding="0" cellspacing="0" >
                            <tr valign="top">
                              <td align="left" >
                                <!-- inicio tabela de cadastro de funcionario -->
                                <table width="100%" border="0" cellspacing="0" cellpadding="0">
                                  <tr>
                                    <td height="24" colspan="3" bgcolor="#CCCCCC" class="TextoForm"><strong>Dados do Colaborador</strong></td>
                                  </tr>
                                  <tr>
                                    <td class="TextoForm">Matr&iacute;cula Funcional</td>
                                    <td class="TextoForm"><input name="txtCodigoFuncional" type="text" class="form-control" id="txtCodigoFuncional" size="12" maxlength="8" value="<%=intCodFuncional%>"  onKeyPress="return formataCampo(this, 2, 8)">
                                      <input type="checkbox" name="LocalizarMatricula" value="S" onClick='submit()'>
                    Localizar?</td>
                                    <td class="TextoForm">&nbsp;</td>
                                  </tr>
                                  <tr>
                                    <td class="TextoForm">Nome:</td>
                                    <td class="TextoForm">
                                      <input name="txtCodFuncionario" value="<%=intCodColaborador%>" type="hidden" id="txtCodFuncionario" >
                                      <input name="txtCodEmpresa" value="<%=intCodEmp%>" type="hidden" id="txtCodEmpresa" >
                                      <input name="txtcodLotacaoAnterior" value="<%=intcodLotacaoAnterior%>" type="hidden" id="txtcodLotacaoAnterior" >
                                      <input name="txtNomeFuncionario" type="text" class="form-control" id="txtNomeFuncionario" size="50" maxlength="70" value="<%=strNome%>">
                                      <button class="btn-u btn-u-green" onClick="return abreConsultaColaborador('Colaborador_con.asp?PaginaOrigem=colaborador_cad')" type="button"><i class="fa fa-search"></i></button>
                                      </td>
                                    	
                                    <td class="TextoForm">&nbsp;</td>
                                  </tr>
                                  <tr>
                                    <td colspan="3" class="TextoForm">&nbsp;</td>
                                    </tr>
                                  <tr>
                                    <td colspan="3" class="TextoForm"></td>
                                    </tr>
                                  <tr> 
                                    <td height="24" colspan="3" bgcolor="#CCCCCC" class="TextoForm"><strong>Dados da Modula&ccedil;&atilde;o</strong></td>
                                    </tr>
                                  <tr bgcolor="#FFFFCC">
                                    <td height="24" class="texto2"><strong>Tipo</strong></td>
                                    <td height="24" ><span class="TextoForm"><strong>
                                    <input type="radio" name="optPorPeriodo" checked onClick="submit()" value="T" <%if strPorPeriodo ="S" then response.Write("checked")%>>Contratual/Periodo
                                    <input name="optPorPeriodo" type="radio" onClick="submit()" value="C" <%if strPorPeriodo ="C" then response.Write("checked")%>>Contratual
                                    <input type="radio" name="optPorPeriodo" onClick="submit()" value="A"  <%if strPorPeriodo ="A" then response.Write("checked")%>>Por Per&iacute;odo: 
                                      </strong></span></td>
                                    <td align="left" valign="top" ></td>
                                  </tr>
                                  <tr>
                                    <td height="24" class="texto2">Ano Letivo:</td>
                                    <td height="24" >
                                    <input name="txtAnoLetivo" type="text" class="form-control" id="txtAnoLetivo" value="<%=strAnoLetivo%>" size="5" maxlength="5" onKeyPress="return formataCampo(this,2,10)" onBlur='submit()'>                </td>
                                    <td valign="top" align="left" ></td>
                                  </tr>
                                 <tr>
                                <td width="150" height="24" class="texto2">Semestre: </td>
                                <td height="24" ><!--#include file="../includes/inc_cmdSemestre.asp" --></td>
                                <td valign="top" align="left" >            </td>
                                </tr>
                                  <tr>
                                    <td height="24" class="texto2">Categoria:</td>
                                    <td width="896" height="24" class="texto2" >
                                    <%if strTipo_Funcao <> "FUNCIONARIO" OR intContratadoNivel > 0 THEN%>
                                      <input <%if strTipoModulacao = "PROFESSOR" then response.Write("checked")%>  type="radio" name="optTipoModulacao" id="optTipoModulacao" <%=strDesabilitaProfessor%> value="PROFESSOR" onClick="submit()">Professor &nbsp;&nbsp;&nbsp;&nbsp;
                                    <%END IF%>
                                    <input type="radio" <%if strTipoModulacao = "FUNCIONARIO" then response.Write("checked")%> name="optTipoModulacao" id="optTipoModulacao" value="FUNCIONARIO"  onClick="submit()">Funcion&aacute;rio				</td>
                                    <td width="235" align="left" valign="top" ></td>
                                  </tr>
                                <tr>
                                  <td height="24" class="texto">Unidade Escolar:</td>
                                  <td height="24"  class="texto"><!--#include file="../includes/inc_cmbEmpresaGrupoDiretrizes.asp"--></td>
                                  <td align="left" valign="top" >&nbsp;</td>
                                </tr>
                                 <tr <%=strMostraPeriodo%> >
                                  <td height="24" class="texto">Per&iacute;odo:</td>
                                  <td height="24"  class="texto"><span class="TextoForm">
                                    <input name="txtPeriodoInicial" type="text" class="text" id="txtPeriodoInicial" onBlur="return validaData(this)" onKeyPress="return formataCampo(this, 3, 10)" size="11" value="<%=strPeriodoInicial%>" style="cursor:hand" title="Click aqui para visualizar o calend&aacute;rio">
                                    </span>a <span class="TextoForm">
                                      <input name="txtPeriodoFinal" type="text" class="text" id="txtPeriodoFinal" onBlur="return validaData(this)" onKeyPress="return formataCampo(this, 3, 10)" size="11" value="<%=strPeriodoFinal%>" style="cursor:hand" title="Click aqui para visualizar o calend&aacute;rio">
                                      </span></td>
                                  <td align="left" valign="top" >              </td>
                                </tr>
                                 <tr <%=strSomenteProfessor%>>
                                  <td height="24" class="texto">Tipo:</td>
                                  <td height="24"  class="texto"><span class="texto2">
                                    <input <%if strTipoLancamento = "D" then response.Write("checked")%>  type="radio" name="optTipoLancamento" id="optTipoLancamento" value="D" onClick="submit()">
                                    Disciplinar 
                                    &nbsp;&nbsp;&nbsp;&nbsp;
                                    <input type="radio" <%if strTipoLancamento = "I" then response.Write("checked")%> name="optTipoLancamento" id="optTipoLancamento" value="I"  onClick="submit()">
                                    Interdisciplinar</span></td>
                                  <td align="left" valign="top" >&nbsp;</td>
                                 </tr>
                                <tr>
                                  <td height="24" class="texto">Turno:</td>
                                  <td height="24"  class="texto"><!--#include file="../includes/inc_cmbTurnoRH.asp" --></td>
                                  <td align="left" valign="top" >&nbsp;</td>
                                </tr>
                               <%if strTipoLancamento = "D" and  strTipoLancamento <> "" then %>
                                <tr>
                                  <td height="31" class="texto">Curso:</td>
                                  <td height="31"  class="texto"><!--#include file="../includes/inc_cmdCursoModulacaoDiretrizes.asp" --></td>
                                  <td align="left" valign="top" >&nbsp;</td>
                                </tr>
                               <%end if%>
                                <tr>
                                  <td height="31" class="texto">Fun&ccedil;&atilde;o:</td>
                                  <td height="31"  class="texto"><!--#include file="../includes/inc_cmbFuncao.asp" -->&nbsp;</td>
                                  <td align="left" valign="top" >&nbsp;</td>
                                </tr>              
                                <%
                                IF strTipo_Funcao = "FUNCIONARIO" AND strTipo_FuncaoSelecionadaCombo<>"" and intContratadoNivel <= 0 then
                                    if strTipo_Funcao <> strTipo_FuncaoSelecionadaCombo then
                                        %>
                                        <script>
                                            alert("Não é permitido modular um administrativo como docente.");
                                            window.location="Modulacao_cad.asp?tipoContratacao=C";
                                        </script>
                                        <%
                                        response.end
                                    end if
                                END IF
                                %>
                                <tr  <%=strSomenteProfessor%> <%if strTipoLancamento <> "D" then response.Write("style='display:none'")%>>
                                    <td height="32" class="TextoForm">Per&iacute;odo:</td>
                                    <td class="TextoForm">
                                      <!--#include file="../includes/inc_cmdPeriodoModulacaoDiretrizes.asp" -->
                                    <input type="hidden" value="<%=intCodCurso%>" name="cmbCurso" id="cmbCurso">
                                    
                                    <%
                                    if intCodPeriodo<>"0" and intCodPeriodo<>"" then
                                        sql = "EXEC SP_QtdeModulacaoRH_periodo " & intCodEmpresaGrupo & "," & strAnoLetivo & "," & intSemestre & ",'" & strTurno & "','" & strSerie & "','" & strFuncaoCombo & "'"
                                        RSAUX.OPEN SQL, CNN
                                        IF NOT RSAUX.EOF THEN
                                            funcao = RSAUX("TotalAulasTurma")
                                            modulacao = RSAUX("aulasModuladas")
                                            saldo = RSAUX("saldo")
                                            if saldo <= 0 then 
                                                strDesbilitaAulas = "disabled"
                                                saldo = 0
                                            end if
                                        END IF
                                        RSAUX.CLOSE
                                    end if
                                    %>               </td>
                                    <td align="left" valign="top" >&nbsp;</td>
                                </tr>
                                  <tr <%=strSomenteProfessor%> <%if strTipoLancamento <> "D" then response.Write("style='display:none'")%>>
                                    <td height="32" class="TextoForm">Disciplinas:</td>
                                    <td class="TextoForm"><!--#include file="../includes/inc_cmdDisciplinaDiretrizes.asp" -->                </td>
                                    <td align="left" valign="top" >&nbsp;</td>
                                  </tr>
                                  <tr>
                                    <td height="25" class="TextoForm"><span class="texto">Situa&ccedil;&atilde;o:</span></td>
                                    <td class="TextoForm"><select name="cmbSituacao" id="cmbSituacao" style="width:100pt" class="form-control" onChange="submit()">
                                      <option value="0">Selecione...</option>
                                      <option value="A" <%if strSituacao = "A" then response.Write("selected") %>>Ativo</option>
                                      <option value="I" <%if strSituacao = "I" then response.Write("selected") %>>Inativo</option>
                                    </select></td>
                                    <td align="left" valign="top" >&nbsp;</td>
                                  </tr>
                                  <tr>
                                    <td height="25" class="TextoForm"><span class="texto1">Classificar:</span></td>
                                    <td class="TextoForm"><span class="texto1">
                                      <select name="cmbClassificacao" id="cmbClassificacao" class="form-control">
                                        <option <%if strClassificacao = "1" then%> selected <%end if%> value="1">Professor</option>
                                        <option <%if strClassificacao = "2" then%> selected <%end if%> value="2">Unidade</option>
                                        <option <%if strClassificacao = "3" then%> selected <%end if%> value="3">Fun&ccedil;&atilde;o</option>
                                        <option <%if strClassificacao = "4" then%> selected <%end if%> value="4">Per&iacute;odo</option>
                                        <option <%if strClassificacao = "5" then%> selected <%end if%> value="5">Turno</option>
                                        <option <%if strClassificacao = "6" then%> selected <%end if%> value="6">Disciplina</option>
                                      </select>
                                    </span>
                                    <td align="left" valign="top" >&nbsp;</td>
                                  </tr>
                                  </table>
                                <!-- fim tabela de cadastro de funcionario --></td>
                            </tr>
                            <tr valign="top">
                              <td height="20" align="center" class="tituloPrincipal"><!--#include file="../../includes/inc_botoes_geraRelatorio.asp"--></td>
                            </tr>
                            <tr valign="top">
                              <td align="center" class="tituloPrincipal">&nbsp;</td>
                            </tr>
                            <tr valign="top">
                              <td align="center" class="tituloPrincipal">&nbsp;</td>
                            </tr>
                            <tr valign="top">
                              <td align="center" class="tituloPrincipal">
                              <%
                              if trim(intCodEmpresaGrupo) <> "0" or trim(intCodColaborador) <> "0" or strPorPeriodo = "S" then
                              
                                sql = "select dd.Codigo, dd.Situacao_disciplinar, p.Descricao as periodo, t.desc_turno as turno, dd.Total_Aulas, c.codigo, c.codFuncional, "
                                sql = sql & " dd.tipo_contratacao, dd.periodo_inicial, dd.periodo_final, "
                                sql = sql & " dd.Ano_letivo, dd.Semestre, e.RAZAOSOCIAL, "
                                sql = sql & " f.Desc_Funcao as funcao, isnull(dd.Cod_Substituicao,'0') as Cod_Substituicao, "
                                sql = sql & " c.nome, "
                                sql = sql & " d.Desc_Disciplina as disciplina, dd.status, "
                                sql = sql & " TOPC.Desc_Turno AS TurnoOpcional "
                                sql = sql & " from SRH_MODULACAO_DISCIPLINAR_DOCENTE dd "
                                sql = sql & " inner join SEG_EMPRESA e on e.CODIGO = dd.Cod_empresa "
                                sql = sql & " left join SRH_COLABORADOR C ON C .codigo = dd.Cod_Colaborador"
                                sql = sql & " left join SRH_FUNCAOCOLABORADOR f on f.cod_funcao = dd.cod_funcao"
                                sql = sql & " left join SCA_disciplina d on d.cod_disciplina = dd.cod_disciplina"
                                sql = sql & " left join SCA_periodo p on p.cod_periodo = dd.cod_periodo"
                                sql = sql & " left join SCA_Curso CU on CU.Cod_curso = p.Cod_Curso"
                                sql = sql & " left join SRH_TURNO t on t.cod_turno = dd.cod_turno"
                                sql = sql & " left join SRH_TURNO TOPC on TOPC.cod_turno = dd.Cod_turno_opcional"
                                sql = sql & " Where dd.ano_letivo = " & strAnoLetivo
                                sql = sql & " And e.COD_GRUPO = " & Session("CodGrupo")
                                            
                                if strPorPeriodo <> "T" then 
                                    sql = sql & " And dd.tipo_contratacao = '"  & strPorPeriodo & "'"
                                end if
                                
                                if intCodEmpresaGrupo <> "0" then 
                                    sql = sql & " And e.codigo = " & intCodEmpresaGrupo
                                end if
                                
                                if intCodColaborador <> "0" then
                                    sql = sql & " And dd.Cod_Colaborador = " & intCodColaborador	
                                end if
                                
                                if strTipoLancamento <> "" then 
                                    sql = sql & " And dd.Situacao_disciplinar = '" & strTipoLancamento & "'"
                                end if
                                
                                if intCodTurno <> "0" then
                                    sql = sql & " And dd.cod_turno = " & intCodTurno
                                end if
                                
                                if intCodFuncao <> "0" then
                                    sql = sql & " And dd.cod_funcao = " & intCodFuncao 
                                end if
                            
                                if intCodPeriodo <> "0" then
                                    sql = sql & " And dd.cod_periodo = " & intCodPeriodo 
                                end if
                            
                                if intCodCursoCombo <> "0" then
                                    sql = sql & " And CU.Cod_curso = " & intCodCursoCombo 
                                end if
                                
                                if intCodDisciplina <> "0" then
                                    sql = sql & " And dd.cod_disciplina = " & intCodDisciplina 
                                end if
                                        
                                if strSituacao <> "" then
                                    sql = sql & " And dd.status = '" & strSituacao & "'"
                                end if
                                
                                if strTipoModulacao <> "" then
                                    sql = sql & " And dd.tipoModulacao = '" & strTipoModulacao & "'"
                                end if
                                
                                if strClassificacao = "1" then 
                                    sql = sql & " order by c.nome"
                                end if
                                
                                if strClassificacao = "2" then 
                                    sql = sql & " order by RAZAOSOCIAL"
                                end if
                                
                                if strClassificacao = "3" then 
                                    sql = sql & " order by Desc_Funcao"
                                end if
                                
                                if strClassificacao = "4" then 
                                    sql = sql & " order by periodo"
                                end if
                                
                                if strClassificacao = "5" then 
                                    sql = sql & " order by turno"
                                end if
                                
                                if strClassificacao = "6" then 
                                    sql = sql & " order by disciplina"
                                end if
                                
                                'response.Write(sql)
                                'response.End()
                                
                                        
                                rs.open sql, cnn
                                if rs.eof = false then
                                    %>
                                  <table width = "100%" border="1" align="center" cellpadding="0" cellspacing="0" bordercolor="#CCCCCC" class="tabela">
                                    <tr bgcolor="#E5E5E5" class="celula">
                                      <td width="371" class="celula">Professor</td>
                                      <td width="371" height="26" class="celula">Unidade</td>
                                    <td width="456" class="celula">Fun&ccedil;&atilde;o</td>
                                    <td width="132" class="celula">Ano</td>
                                    <td width="132" class="celula">Per&iacute;odo</td>
                                    <td width="132" class="celula">Turno</td>
                                    <td width="132" class="celula">Sit. Disciplinar</td>
                                    <td width="150" class="celula">Disciplina</td>
                                    <td width="42" class="celula">Aulas/Entrada</td>
                                    <td width="42" class="celula">Origem</td>
                                    </tr>
                                    <%
                                    
                                    TotalAulas = "0"
                                    cont = 0
                                    while not rs.eof
                                       cont = cont + 1	
                                       
                                       
                                       ' Atualiza o inativar por data
                                        if trim(rs("codigo")) <> "" then
                                        
                                            sql = "select dd.Codigo, dd.periodo_inicial, dd.periodo_final"
                                            sql = sql & " from SRH_MODULACAO_DISCIPLINAR_DOCENTE dd "
                                            sql = sql & " inner join SEG_EMPRESA e on e.CODIGO = dd.Cod_empresa "
                                            sql = sql & " left join SRH_FUNCAOCOLABORADOR f on f.cod_funcao = dd.cod_funcao"
                                            sql = sql & " left join SCA_disciplina d on d.cod_disciplina = dd.cod_disciplina"
                                            sql = sql & " left join SRH_TURNO t on t.cod_turno = dd.cod_turno"
                                            sql = sql & " left join SRH_TURNO tur on tur.cod_turno = dd.cod_turno_opcional "
                                            sql = sql & " left join SCA_periodo p on p.cod_periodo = dd.cod_periodo"
                                            sql = sql & " where dd.Cod_Colaborador = " & trim(rs("codigo"))
                                            sql = sql & " and (dd.ano_letivo = " & strAnoLetivo
                                            sql = sql & " or dd.ano_letivo = " & strAnoLetivo - 1 & ")"
                                            sql = sql & " order by dd.ano_letivo desc ,dd.tipo_contratacao desc, dd.codigo"
                                            rsAux1.open sql, cnn
                                            if rsAux1.eof = false then
                                            
                                                while not rsaux1.eof
                                                
                                                if not isnull(rsaux1("periodo_final")) then
                                                    strPeriodoFinalComparar = replace(formataDataCalc(rsaux1("periodo_final")),"/","")
                                                    strDataAtualComparar 	= replace(formataDataCalc(date),"/","")
                                                    
                                                    if cCur(strPeriodoFinalComparar)<cCur(strDataAtualComparar) then 
                                                        sql = "update SRH_MODULACAO_DISCIPLINAR_DOCENTE set status = 'I' where codigo = " & rsaux1("codigo") 
                                                        cnn.execute sql
                                                    end if
                                                end if
                                                
                                                rsAux1.movenext
                                                wend
                                        
                                            end if
                                            rsAux1.close	
                                            
                                        end if	
                                            
                                            
                                       strSituacaoDisciplinar = rs("Situacao_disciplinar")
                                       if strSituacaoDisciplinar = "D" then strSituacaoDisciplinar = "Disciplinar"
                                       if strSituacaoDisciplinar = "I" then strSituacaoDisciplinar = "Interdisciplinar"
                                       
                                       if rs("Cod_Substituicao") = "0" then 
                                           strorigem = "CONTRATUAL"	
                                       else				
                                           strorigem = "SUBSTITUICAO"	
                                       end if
                                       
                                       periodo = ""
                                       tipo = "Contratual"
                                       cor = "#FFFFFF"
                                       if rs("tipo_contratacao") = "A" then 
                                            periodo = "&nbsp;(" & formatadataAP(rs("periodo_inicial")) & " a " & formatadataAP(rs("periodo_final")) & ")"
                                            tipo = "Adicional"
                                            cor = "#C6E2FF"
                                            strorigem = "PER&Iacute;ODO"
                                        end if
                                        link = "onClick='return resultadoConsulta(" & rs("codigo") & ")'"
                                        if trim(rs("status")) <> "A" then 
                                            cor = "#C0C0C0"
                                            link = ""
                                        end if
                                        
                                        if rs("Cod_Substituicao") <> "0" then 
                                            cor = "#C0C0C0"
                                            link = ""
                                        end if
                                        
                                        if rs("Situacao_disciplinar") = "I" then
                                            intTAulas = rs("Total_Aulas")*21
                                        else
                                            intTAulas = rs("Total_Aulas")
                                        end if
                                        
                                        if trim(rs("TurnoOpcional")) <> "" then 
                                            strTurno = trim(rs("TurnoOpcional"))
                                        else
                                            strTurno = trim(rs("turno"))
                                        end if
                                        
                                        if strTipoModulacao = "FUNCIONARIO" and  strTurno = "INTEGRAL" then
                                            intTAulas = rs("Total_Aulas")*42
                                        end if 
                                        
                                        
                                        if strNomeAnt = "" then
                                            strNomeAnt = rs("nome")
                                        end if
                                        
                                        if strCodFuncionalAnt = "" then
                                            strCodFuncionalAnt = rs("codFuncional")
                                        end if
                                        
                                        if strNomeAnt = trim(rs("nome")) then
                                            'TotalAulas = TotalAulas + cint(rs("Total_Aulas"))
                                            TotalAulas = TotalAulas + intTAulas
                                        end if
                                        
                                         if strNomeAnt <> trim(rs("nome")) then
                                                
                                                strNome = trim(rs("codFuncional")) & " - " & trim(rs("nome"))
                                            
                                                strNomeAnt = trim(rs("nome"))
                                                strCodFuncionalAnt = trim(rs("codFuncional"))
                                                
                                                
                                                if TotalAulas <> "0" then
                                                %>
                                                <tr>
                                                    <td height="26" colspan="8" align="right" bgcolor="#FFFFCC" class="celula9"><span class="texto">Total :&nbsp;</span></td>
                                                    <td align="center" bgcolor="#FFFFCC" class="celula9"><%=trim(TotalAulas)%>&nbsp;</td>
                                                    <td height="26" bgcolor="#FFFFCC" class="celula9">&nbsp;</td>
                                                </tr>
                                                    <%
                                                    TotalAulas = 0
                                                end if
                                                'TotalAulas = TotalAulas + rs("intTAulas")
                                                TotalAulas = TotalAulas + intTAulas
                                            else
                                        
                                                if cont = 1 then
                                                    strNome = trim(rs("codFuncional")) & " - " & rs("nome")
                                                else
                                                    
                                                    if trim(rs("codFuncional")) <> strCodFuncionalAnt then
                                                        strNome = trim(rs("codFuncional")) & " - " & rs("nome")
                                                    else
                                                        strNome = ""
                                                    end if
                                                end if
                                                
                                            end if	
                                           %>
                                           <tr bgcolor="<%=cor%>" >
                                             <td class="celula9"><%=strNome%>&nbsp;</td>
                                             <td class="celula9"><%=trim(rs("RAZAOSOCIAL"))%>&nbsp;</td>
                                             <td class="celula9"><%=trim(rs("funcao"))%><%=periodo%>&nbsp;</td>
                                             <td class="celula9"><div align="center"><%=trim(rs("Ano_letivo"))%>&nbsp;</div></td>
                                             <td class="celula9"><%=trim(rs("periodo"))%>&nbsp;</td>
                                             <td class="celula9"><%=trim(strTurno)%>&nbsp;</td>
                                             <td class="celula9"><%=strSituacaoDisciplinar%>&nbsp;</td>
                                             <td height="26" class="celula9"><%=trim(rs("disciplina"))%>&nbsp;</td>
                                             <td align="center" class="celula9"><%=intTAulas%>&nbsp;</td>
                                             <td height="26" class="celula9"><%=trim(strorigem)%>&nbsp;</td>
                                            </tr>
                                           <tr>
                                           <%
                                            Total_Aulas = Total_Aulas + intTAulas
                                       rs.movenext
                                    wend
                                    %>
                                     <td height="26" colspan="8" align="right" bgcolor="#FFFFCC" class="celula9"><span class="texto">Total :&nbsp;</span></td>
                                                    <td align="center" bgcolor="#FFFFCC" class="celula9"><%=TotalAulas%></td>
                                             <td height="26" bgcolor="#FFFFCC" class="celula9">&nbsp;</td>
                                                </tr>
                                    <tr> 
                                    <td height="21" colspan="11" class="celula"><span class="texto">Total Registros :</span> <%=cont%></td>
                                    <%
                                end if
                                rs.close
                                 %>
                                </table> 
                                <%	
                             end if	
                             %>
                             </td>
                            </tr>
                            <tr valign="top">
                              <td align="center" class="tituloPrincipal style2">&nbsp;</td>
                            </tr>
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
    
        function abreConsultaColaborador(caminho){
            window.open(caminho,"abreConsulta","top=5,left=5,height=510,width=719,menubar=no,toolbar=no,scrollbars=yes,status=yes");
        }
        
        function gerar(){
            
            var frm = document.getElementById("frm");
            var caminho;
            caminho = "Rel_ModulacaoColaborador_rel.asp"
            
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