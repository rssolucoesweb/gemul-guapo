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
        strPaginaTitulo 	= "DossieColaborador_cad.asp"
        intCodigo	 		= Trim(Request("txtCodigo"))
        intCodFunc	 		= Trim(Request("txtCodFuncionario"))
        strNomeBotaoFoto	= "Incluir Foto"
        strUsuarioPortal 	= Trim(Request("txtUsuarioPortal"))
        strBloqUsu 			= ""
        
        if trim(intCodFunc) <> "" then
        
            sql = "SELECT  * "
            sql = sql & " FROM SRH_COLABORADOR "
            sql = sql & " Where Codigo = " & intCodFunc
            sql = sql & " And codLotacao = " & session("codEmpresa")
            rs.open sql, cnn
            
            if rs.eof = false then
            
                intCodFunc	 		= rs("Codigo")
                strnome 			= Trim(Rs("nome"))
                strdata_admissao  	= formatadataAP(Trim(Rs("data_admissao")))
                
                ' Endereco
                strLogradouro 		= TRIM(rs("Logradouro"))
                strNumero_endereco 	= TRIM(rs("numero_logradouro"))
                strComp_endereco 	= TRIM(rs("Comp_endereco"))
                strBairro 		    = TRIM(rs("Bairro"))
                strCidade	        = TRIM(rs("Cidade"))
                strUfresidencia 	= TRIM(rs("UF"))
                strCep 	            = TRIM(rs("Cep"))
                
                intCodFuncao 	    = TRIM(rs("codFuncao"))
                intCodCargo 	    = TRIM(rs("codCargo"))
                intcodLotacao 	    = TRIM(rs("codLotacao"))
                strCNH 	           	= TRIM(rs("CNH"))
                strCategoriaCNH 	= TRIM(rs("CategoriaCNH"))
                                            
                strFoneResidencial  = Trim(Rs("FoneResidencial"))
                strFoneComercial    = Trim(Rs("FoneComercial"))
                strFoneCelular      = Trim(Rs("FoneCelular"))
                carteira_reservista	= Trim(Rs("carteira_reservista"))
                stremail  			= Trim(Rs("email"))
                strpai  			= Trim(Rs("pai"))
                strmae  			= Trim(Rs("mae"))
                strdata_nascimento  = formataDataAP(Trim(Rs("Data_Nascimento")))
                strnaturalidade  	= Trim(Rs("naturalidade"))
                strnacionalidade  	= Trim(Rs("nacionalidade"))
                strestado_civil  	= Trim(Rs("estado_civil"))
                strconjuge  		= Trim(Rs("conjuge"))
                strnumero_filhos  	= Trim(Rs("numero_filhos"))
                strcpf  			= Trim(Rs("cpf"))
                strrg  				= Trim(Rs("rg"))
                strorgao_expedidor  = Trim(Rs("orgaoExp"))
                strtitulo_eleitor  	= Trim(Rs("titulo_eleitor"))
                strcarteira_trabalho= Trim(Rs("carteira_trabalho"))
                strpis  			= Trim(Rs("pis"))
                strSexo 			= Trim(Rs("Sexo"))
                strSituacao			= Trim(Rs("Situacao"))	
                strDatafastamento	= Trim(Rs("Datafastamento"))
                intCodCategoria		= Trim(Rs("CodCategoria"))	
                intCodGrauInstrucao	= Trim(Rs("CodGrauInstrucao"))
                strCargo			= Trim(Rs("Cargo"))
                strFuncao			= Trim(Rs("Funcao"))
                intCodFuncional		= Trim(Rs("CodFuncional"))
                intCodDepartamento	= Trim(Rs("CodDepartamento"))
                strObs				= Trim(Rs("Obs"))
    
            end if 
            rs.close
            
            strFoto = "Foto"
    
            sql = "SELECT arquivo "
            sql = sql & " FROM 	SRH_COLABORADOR_FOTO"
            sql = sql & " Where COD_EMPRESA = " & session("codEmpresa")
            sql = sql & " And CodColaborador = " & intCodFunc
            rs.open sql, cnn
            if rs.eof = false then
                strCaminhoFoto = session("strCaminhoRaiz") & "/fotoColaborador/" & session("codEmpresa") & "/" & rs("arquivo")
                strFoto =  "<img src='" & strCaminhoFoto & "' width='120' height='130'>"
            end if
            rs.close
    
        end if 
        
        if trim(intCodigo) <> "" then
        
            sql = "SELECT Cod_Colaborador, Cod_empresa, Cod_ColaboradorEventoDossie, "
            sql = sql & " DataPeridoReferencia_Inicio, DataPeridoReferencia_Final, "
            sql = sql & " DataPeriodoAquisicao_Inicio, DataPeriodoAquisicao_Final, "
            sql = sql & "  Averbacoes, Valor "
            sql = sql & " FROM SRH_DOSSIE_COLABORADOR "
            sql = sql & " Where Codigo = " & intCodigo
            sql = sql & " And Cod_empresa = " & session("codEmpresa")
            sql = sql & " And Cod_Colaborador = " & intCodFunc
            rs.open sql, cnn
            
            if rs.eof = false then
                
                ' Dados Dossie
                intCodColaboradorEventoDossie 	= Trim(Rs("Cod_ColaboradorEventoDossie"))
                strPeridoReferencia_Inicio		= formataDataAP(Trim(Rs("DataPeridoReferencia_Inicio")))
                strPeridoReferencia_Final  		= formataDataAP(Trim(Rs("DataPeridoReferencia_Final")))
                strPeriodoAquisicao_Inicio		= formataDataAP(Trim(Rs("DataPeriodoAquisicao_Inicio")))
                strPeriodoAquisicao_Final		= formataDataAP(Trim(Rs("DataPeriodoAquisicao_Final")))
                strAverbacoes					= Trim(Rs("Averbacoes"))
                strValor						= Trim(Rs("Valor"))
                
                if strValor <> "" then
                    strValor = formatnumber(strValor,2)
                end if
                
                
                strDesabilitaIncluir	= "disabled" 'Desabilita o botão Incluir
                strDesabilitaAlterar 	= "" 'Desabilita o botão Excluir
                strDesabilitaExcluir	= "" 'Desabilita o botão Excluir
    
            end if 
            rs.close
            
        else
            strDesabilitaIncluir	= "" 'Desabilita o botão Incluir
            strDesabilitaAlterar 	= "disabled" 'Desabilita o botão Excluir
            strDesabilitaExcluir	= "disabled" 'Desabilita o botão Excluir
        end if 
        
        if intCodFunc = "" then intCodFunc = 0
    
    %>
    <!--=== Content Part ===-->
     <form method="post" id="frm">	
    <div class="container content">		
    
      <!-- Grey Panel -->            
      <div class="panel panel-grey">
        <div class="panel-heading">
        	<h3 class="panel-title"><i class="fa fa-tasks"></i>Dossiê Colaborador</h3>
        </div>
        <!-- Inicia o Painel do Formulario -->     
        <div class="panel-body">
             <!-- Inicia o Form -->     
            <div class="panel-body">                                                        
               
                
                    <div class="form-group">
						
                        <table class="table table-bordered">
                        <tr>
                          <td colspan="6" bgcolor="#CCCCCC" class="TextoForm"><strong>Dados do Colaborador </strong></td>
                          </tr>
                        <tr>
                          <td width="11%" class="TextoForm">Nome:</td>
                          <td colspan="3" class="TextoForm">
                            <input name="txtCodigo" value="<%=intCodigo%>" type="hidden" id="txtCodigo" >
                            <input name="txtCodFuncionario" value="<%=intCodFunc%>" type="hidden" id="txtCodFuncionario" >
                            <input name="txtNomeFuncionario" type="text" class="form-control" id="txtNomeFuncionario" size="50" maxlength="70" value="<%=strNome%>">
                            <button class="btn-u btn-u-green" onClick="return abreConsulta('Colaborador_con.asp'')" type="button"><i class="fa fa-search"></i></button>
                           </td>
                          <td colspan="2" rowspan="7" align="center" class="TextoForm"><table width="120" height="130" border="0" cellpadding="0" cellspacing="0">
                            <tr>
                              <td bgcolor="#FFFFFF" align="center" class="text"><%=strFoto%></td>
                              </tr>
                            </table></td>
                          </tr>
                        <tr>
                          <td height="24" class="TextoForm">Data Nasc.:</td>
                          <td width="25%" class="TextoForm"><input name="txtdata_nascimento" type="text" class="form-control" id="txtdata_nascimento" onBlur="return validaData(this)" onKeyPress="return formataCampo(this, 3, 10)" size="11" value="<%=strdata_nascimento%>"></td>
                          <td width="14%" class="TextoForm">&nbsp;</td>
                          <td width="21%" class="TextoForm">&nbsp;</td>
                          </tr>
                        <tr>
                          <td height="24" class="TextoForm">Sexo:</td>
                          <td class="TextoForm"><select name="cboSexo" class="form-control" id="cboSexo">
                            <option value="0">Selecione...</option>
                            <option value="M" <%if strSexo = "M" then response.Write("selected") %>>Masculino</option>
                            <option value="F" <%if strSexo = "F" then response.Write("selected") %>>Feminino</option>
                            </select></td>
                          <td width="14%" class="TextoForm">Estado Civil:</td>
                          <td width="21%" class="TextoForm"><select name="txtestado_civil" class="form-control" id="txtestado_civil">
                            <option value="0">Selecione...</option>
                            <option value="S" <%if strestado_civil = "S" then response.Write("selected") %>>Solteiro</option>
                            <option value="C" <%if strestado_civil = "C" then response.Write("selected") %>>Casado</option>
                            <option value="V" <%if strestado_civil = "V" then response.Write("selected") %>>Vi&uacute;vo</option>
                            <option value="D" <%if strestado_civil = "D" then response.Write("selected") %>>Desquitado</option>
                            <option value="O" <%if strestado_civil = "O" then response.Write("selected") %>>Outros</option>
                            </select></td>
                          </tr>
                        <tr>
                          <td height="24" class="TextoForm">Telefone:</td>
                          <td class="TextoForm"><input name="txtFoneResidencial" type="text" class="form-control" id="txtFoneResidencial" size="15" maxlength="20" value="<%=strFoneResidencial%>"></td>
                          <td class="TextoForm">Dt. Admiss&atilde;o </td>
                          <td class="TextoForm"><input name="txtdata_admissao" type="text" class="form-control" id="txtdata_admissao" onBlur="return validaData(this)" onKeyPress="return formataCampo(this, 3, 10)" size="11" value="<%=strdata_admissao%>" title="Click aqui para visualizar o calend&aacute;rio"></td>
                          </tr>
                        <tr>
                          <td height="24" class="TextoForm">Comercial:</td>
                          <td class="TextoForm"><input name="txtFoneComercial" type="text" class="form-control" id="txtFoneComercial" size="15" maxlength="20" value="<%=strFoneComercial%>"></td>
                          <td class="TextoForm">Celular:</td>
                          <td class="TextoForm"><input name="txtFoneCelular" type="text" class="form-control" id="txtFoneCelular" size="15" maxlength="20" value="<%=strFoneCelular%>"></td>
                          </tr>
                        <tr>
                          <td height="24" class="TextoForm">Naturalidade:</td>
                          <td class="TextoForm"><input name="txtnaturalidade" type="text" class="form-control" id="txtnaturalidade" size="15" maxlength="50" value="<%=strnaturalidade%>"></td>
                          <td class="TextoForm">Nacionalidade:</td>
                          <td class="TextoForm"><input name="txtnacionalidade" type="text" class="form-control" id="txtnacionalidade" size="15" maxlength="50" value="<%=strnacionalidade%>"></td>
                          </tr>
                        <tr>
                          <td height="25" class="TextoForm">E-mail:</td>
                          <td colspan="3" class="TextoForm"><input name="txtemail" type="text" class="form-control" id="txtemail" size="40" maxlength="70" value="<%=stremail%>"></td>
                        </tr>
                        <tr>
                          <td height="25" class="TextoForm">Cargo</td>
                          <td class="TextoForm"><!--#include file="../includes/inc_cmbCargo.asp" --></td>
                          <td class="TextoForm">Fun&ccedil;&atilde;o:</td>
                          <td class="TextoForm"><!--#include file="../includes/inc_cmbFuncao.asp" --></td>
                          <td width="10%" class="TextoForm">Categoria:</td>
                          <td width="19%" class="TextoForm"><!--#include file="../includes/inc_cmdCategoria.asp" --></td>
                          </tr>
                        <tr>
                          <td height="25" class="TextoForm">Situa&ccedil;&atilde;o:</td>
                          <td class="TextoForm"><!--#include file="../includes/inc_cmdSituacao.asp" --></td>
                          <td class="TextoForm">Grau Instru&ccedil;&atilde;o: </td>
                          <td class="TextoForm"><span class="texto1">
                            <!--#include file="../includes/inc_cmdGrauInstrucao.asp" -->
                            </span></td>
                          <td class="TextoForm">Dt. Afastamento:</td>
                          <td class="TextoForm"><input name="txtDatafastamento" type="text" class="form-control" id="txtDatafastamento" onBlur="return validaData(this)" onKeyPress="return formataCampo(this, 3, 10)" size="11" maxlength="10" value="<%=strDatafastamento%>" title="Click aqui para visualizar o calend&aacute;rio" ></td>
                          </tr>
                        <tr>
                          <td height="25" class="TextoForm">Departamento:</td>
                          <td class="TextoForm"><!--#include file="../includes/inc_cmdDepartamento.asp" --></td>
                          <td class="TextoForm">Lota&ccedil;&atilde;o:</td>
                          <td colspan="3" class="TextoForm">
                            <!--#include file="../includes/inc_cmbLotacao.asp" -->
                            </td>
                          </tr>
                        <tr>
                          <td height="25" class="TextoForm">C&oacute;digo Funcional:</td>
                          <td class="TextoForm"><input name="txtCodigoFuncional" type="text" class="form-control" id="txtCodigoFuncional" size="12" maxlength="8" value="<%=intCodFuncional%>"  onKeyPress="return formataCampo(this, 2, 8)"></td>
                          <td class="TextoForm">CNH</td>
                          <td class="TextoForm"><input name="txtCNH" type="text" class="form-control" id="txtCNH" size="20" maxlength="20" value="<%=strCNH%>"></td>
                          <td class="TextoForm">Cat. CNH:</td>
                          <td class="TextoForm"><input name="txtCategoriaCNH" type="text" class="form-control" id="txtCategoriaCNH" size="5" maxlength="5" value="<%=strCategoriaCNH%>"></td>
                          </tr>
                        <tr>
                          <td height="26" class="TextoForm">Obs:</td>
                          <td colspan="5" class="TextoForm"><input name="txtObs" type="text" class="form-control" id="txtObs" size="70" maxlength="70" value="<%=strObs%>"></td>
                          </tr>
                        <tr>
                          <td height="13" colspan="6" class="TextoForm">&nbsp;</td>
                          </tr>
                        <tr bgcolor="#CCCCCC" id="L1">
                          <td height="15" colspan="6" class="TextoForm"><strong>Dados Dossi&ecirc;</strong></td>
                          </tr>
                        <tr>
                          <td height="23" colspan="6" class="TextoForm">&nbsp;</td>
                          </tr>
                        <tr id="L6">
                          <td height="23" class="TextoForm">Evento Dossie</td>
                          <td colspan="5" class="TextoForm"><!--#include file="../includes/inc_EventoDossie.asp" --></td>
                          </tr>
                        <tr>
                          <td height="23" class="TextoForm">&nbsp;</td>
                          <td colspan="5" class="TextoForm">&nbsp;</td>
                          </tr>
                        <tr>
                          <td height="23" colspan="6" align="center" class="TextoForm">
                          <table width="98%">
                            <tr>
                              <td width="23%" height="20" align="center" bgcolor="#CCCCCC" class="texto"><strong>Per&iacute;odos de Refer&ecirc;ncia</strong></td>
                              <td width="24%" align="center" class="texto" bgcolor="#CCCCCC"><strong>Per&iacute;odo de Aquisi&ccedil;&atilde;o</strong></td>
                              <td width="26%" align="center" class="texto" bgcolor="#CCCCCC"><strong>Averba&ccedil;&otilde;es</strong></td>
                              <td width="14%" align="center" class="texto" bgcolor="#CCCCCC"><strong>Valor R$</strong></td>
                              </tr>
                            <tr>
                              <td align="center" class="TextoForm"><input name="txtPeridoReferencia_Inicio" type="text" class="form-control" id="txtPeridoReferencia_Inicio" onBlur="return validaData(this)" onKeyPress="return formataCampo(this, 3, 10)" value="<%=strPeridoReferencia_Inicio%>" size="10" maxlength="10" title="Click aqui para visualizar o calend&aacute;rio">
                                a
                                <input name="txtPeridoReferencia_Final" type="text" class="form-control" id="txtPeridoReferencia_Final" onBlur="return validaData(this)" onKeyPress="return formataCampo(this, 3, 10)" value="<%=strPeridoReferencia_Final%>" size="10" maxlength="10" title="Click aqui para visualizar o calend&aacute;rio"></td>
                              <td align="center" class="TextoForm">
                              <input name="txtPeriodoAquisicao_Inicio" type="text" class="form-control" id="txtPeriodoAquisicao_Inicio" onBlur="return validaData(this)" onKeyPress="return formataCampo(this, 3, 10)" value="<%=strPeriodoAquisicao_Inicio%>" size="10" maxlength="10" title="Click aqui para visualizar o calend&aacute;rio">
                                a
                                <input name="txtPeriodoAquisicao_Final" type="text" class="form-control" id="txtPeriodoAquisicao_Final" onBlur="return validaData(this)" onKeyPress="return formataCampo(this, 3, 10)" value="<%=strPeriodoAquisicao_Final%>" size="10" maxlength="10" title="Click aqui para visualizar o calend&aacute;rio"></td>
                              <td align="center"><textarea  class="text" rows="3" cols="30" name="txtAverbacoes" id="txtAverbacoes"><%=strAverbacoes%></textarea></td>
                              <td align="center"><input <%=strDesabilitaCampo%> style="text-align: right" name="txtValor" type="text" class="form-control" id="txtValor" onKeyPress="return currencyFormat(this,event)" value="<%=strValor%>" size="15" maxlength="10" ></td>
                              </tr>
                            </table></td>
                          </tr>
                        <tr>
                          <td height="23" class="TextoForm">&nbsp;</td>
                          <td colspan="5" class="TextoForm">&nbsp;</td>
                          </tr>
                        <tr>
                          <td height="23" colspan="6" align="center" class="TextoForm"><%
                            cont =0
                            
                        if intCodFunc <> "0" then 
                            
                            sql = "SELECT Codigo, Cod_Colaborador, Cod_empresa, Cod_ColaboradorEventoDossie, "
                            sql = sql & " DataPeridoReferencia_Inicio, DataPeridoReferencia_Final, DataPeriodoAquisicao_Inicio, DataPeriodoAquisicao_Final, Averbacoes, Valor "
                            sql = sql & " FROM SRH_DOSSIE_COLABORADOR "
                            sql = sql & " Where Cod_empresa = " & session("codEmpresa")
                            sql = sql & " And Cod_Colaborador = " & intCodFunc
                            rs.open sql, cnn
                                            
                            if rs.eof = false then
                            %>
                            <table width = "99%" border="1" align="center" cellpadding="0" cellspacing="0" bordercolor="#CCCCCC" class="tabela">
                              <tr bgcolor="#E5E5E5">
                                <td width="8%" class="celula"><strong>C&oacute;digo </strong></td>
                                <td width="25%" align="center" class="celula"><strong>Per&iacute;odos de Refer&ecirc;ncia</strong></td>
                                <td width="27%" align="center" class="celula"><strong>Per&iacute;odo de Aquisi&ccedil;&atilde;o</strong></td>
                                <td width="27%" align="center" class="celula"><strong>Averba&ccedil;&otilde;es</strong></td>
                                <%if session("NivelPermissao") = "A" then%>
                                <td width="13%" height="21" align="center" class="celula"><strong>Valor R$</strong></td>
                                <%end if%>
                                </tr>
                              <%
                                while not rs.eof
                                    cont = cont + 1	
                                    %>
                              <tr style="cursor:hand" onMouseOver="return linhaMouseOver(this)" onMouseOut="return linhaMouseOut(this)" onClick="return resultadoConsulta('<%=rs("Codigo")%>','<%=rs("Cod_Colaborador")%>')">
                                <td class="celula"><%=rs("Codigo")%></td>
                                <td align="center" class="celula"><%=formataDataAP(rs("DataPeridoReferencia_Inicio"))%> a <%=formataDataAP(rs("DataPeridoReferencia_Final"))%></td>
                                <td align="center" class="celula"><%=formataDataAP(rs("DataPeriodoAquisicao_Inicio"))%> a <%=formataDataAP(rs("DataPeriodoAquisicao_Final"))%></td>
                                <td class="celula"><%=rs("Averbacoes")%>&nbsp;</td>
                                <%if session("NivelPermissao") = "A" then%>
                                <td height="20" align="right" class="celula"><%=formatnumber(trim(rs("Valor")),2)%>&nbsp;</td>
                                <%end if%>
                                </tr>
                              <%				
                                    rs.movenext
                                    wend
                                %>
                              <tr>
                                <td height="21" colspan="5" class="celula">Total Registros : <%=cont%></td>
                              </table>
                            <%
                              end if
                              rs.close
                              
                              end if%></td>
                          </tr>
                        </table>
                    </div>
					
                    <!--#include file="../../includes/inc_botoes_cadastro.asp"-->
                    
                
            	</div>
       	 	</div>
         	<!-- Fecha o Form -->  
      </div>
       <!-- Fecha o Painel do Formulario -->        
    </div>
    </form>
    <!--/container-->		
	<script>
        function resultadoConsulta(intCodigo, intCodFun){
        
            var frm = document.getElementById("frm");
            
            frm.txtCodigo.value=intCodigo;
            frm.txtCodFuncionario.value=intCodFun;
            frm.submit();
        }
        
        function salvar(acao){
        
        var frm = document.getElementById("frm");
        
        if(frm.txtNomeFuncionario.value == ""){
            alert("O Funcionario deve ser informado!");
            frm.txtNomeFuncionario.focus();
            return false		
        }
            
        if(frm.cmbColaboradorEventoDossie.value == "0"){
            alert("O Colaborador Evento Dossie deve ser informado!");
            frm.cmbColaboradorEventoDossie.focus();
            return false		
        }
        
        if(frm.txtPeridoReferencia_Inicio.value == ""){
            alert("A Data Inicio deve ser informada!");
            frm.txtPeridoReferencia_Inicio.focus();
            return false		
        }
        
        if(frm.txtPeridoReferencia_Final.value == ""){
            alert("A Data Fim deve ser informada!");
            frm.txtPeridoReferencia_Final.focus();
            return false		
        }
        
        if(frm.txtPeriodoAquisicao_Inicio.value == ""){
            alert("A Data Aquisicao Inicio deve ser informada!");
            frm.txtPeriodoAquisicao_Inicio.focus();
            return false		
        }
        
        if(frm.txtPeriodoAquisicao_Final.value == ""){
            alert("A Data Aquisicao Fim deve ser informada!");
            frm.txtPeriodoAquisicao_Final.focus();
            return false		
        }
    
        frm.action= "DossieColaborador_cod.asp?acao="+acao;
        frm.submit();
        return true;
        }
    
    </script>
    <!--=== End Content Part ===-->
   	<!--#include file="../RodapeModulo.asp"-->
	<!--#include file="../jsModulo.asp"-->
</body>
</html> 