<!--#include file="../../includes/inc_verificaSession.asp"-->
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
        strPaginaTitulo 		= "Rubricas_cad.asp"
        intCodigo	 			= Trim(Request.Form("txtCodigo"))
        intCodGrupo				= Session("CodGrupo")
        strDescricao 			= Trim(Request.Form("txtDescricao"))
        intCodConvenio 			= Trim(Request.Form("cmbConvenios"))
        strTipoRubrica 			= Trim(Request.Form("cmbTipoRubrica"))
        strSituacao 			= Trim(Request.Form("cmbSituacao"))
        strValor				= Trim(Request.Form("txtValor"))
        strTipoCalculo 			= Trim(Request.Form("cmbTipoCalculo"))
        strPeriodicidadeInicial	= formataDataAP(Trim(Request.Form("txtPeriodicidadeInicial")))  
        strPeriodicidadeFinal	= formataDataAP(Trim(Request.Form("txtPeriodicidadeFinal"))) 
        
        if trim(intCodigo) <> "" then
        
            sql = "SELECT Codigo, Cod_grupo, Descricao,"
            sql = sql & " Cod_convenio, Tipo_rubrica, Situacao_rubrica, Valor_rubrica, "
            sql = sql & " Tipo_Calculo, Periodicidade_inicial, Periodicidade_final"
            sql = sql & " FROM SRH_RUBRICA"
            sql = sql & " where Cod_grupo = " & intCodGrupo			
            sql = sql & " and Codigo = " & intCodigo
            rs.open sql, cnn
        
            if rs.eof = false then
            
                intCodigo	 			= rs("Codigo")
                intCodGrupo				= rs("Cod_grupo")
                strDescricao 			= rs("Descricao")
                intCodConvenio 			= rs("Cod_convenio")
                strTipoRubrica 			= rs("Tipo_rubrica")
                strSituacao 			= rs("Situacao_rubrica")
                strValor				= formatNumber(rs("Valor_rubrica"),2) 
                strTipoCalculo			= trim(rs("Tipo_Calculo"))
                strPeriodicidadeInicial	= formataDataAP(trim(rs("Periodicidade_inicial")))
                strPeriodicidadeFinal	= formataDataAP(trim(rs("Periodicidade_final")))
    
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
    %>
    <!--=== Content Part ===-->
    <div class="container content">		
    
      <!-- Grey Panel -->            
      <div class="panel panel-grey">
        <div class="panel-heading">
        	<h3 class="panel-title"><i class="fa fa-tasks"></i>Cadastro de Rubricas Fixas</h3>
        </div>
        <!-- Inicia o Painel do Formulario -->     
        <div class="panel-body">
             <!-- Inicia o Form -->     
            <div class="panel-body">                                                        
                <form id="frm" class="margin-bottom-10" method="post">
                
                    <input name="txtCodigo" type="hidden" id="txtCodigo" class="text" size="10" value="<%=intCodigo%>" maxlength="10">
                    
                    <div class="form-group">
                        <label class="form-label">Descri&ccedil;&atilde;o</label>
                        <input name="txtDescricao" type="text" class="form-control" id="txtDescricao" size="40" maxlength="40" value="<%=strDescricao%>">
                    </div>
                    
                    <div class="form-group">
                        <label class="form-label">Conv&ecirc;nio</label>
                        <!--#include file="../includes/inc_cmbConvenios.asp" -->
                    </div>
                    
                    <div class="form-group">
                        <label class="form-label">Tipo Rubr&iacute;ca</label>
                    	<select name="cmbTipoRubrica" id="cmbTipoRubrica" style="width:100pt" class="form-control">
                          <option value="0">Selecione...</option>
                          <option value="P" <%if strTipoRubrica = "P" then response.Write("selected") %>>Positiva (+)</option>
                          <option value="N" <%if strTipoRubrica = "N" then response.Write("selected") %>>Negativa (-)</option>
                        </select>
                    </div>
                    
                    <div class="form-group">
                        <label class="form-label">Situa&ccedil;&atilde;o </label>
                        <!--#include file="../includes/inc_cmdSituacao.asp" -->
                    </div>
                       
                    <div class="form-group">
                        <label class="form-label">Tipo de Valor</label>
                        <select name="cmbTipoCalculo" id="cmbTipoCalculo" style="width:100pt" class="form-control">
                          <option value="0">Selecione...</option>
                          <option value="M" <%if strTipoCalculo = "M" then response.Write("selected") %>>Moeda Corrente</option>
                          <option value="P" <%if strTipoCalculo = "P" then response.Write("selected") %>>Percentual</option>
                          <option value="Q" <%if strTipoCalculo = "Q" then response.Write("selected") %>>Quantidade</option>
                        </select>
                    </div>
                    
                     <div class="form-group">
                        <label class="form-label">Valor</label>
                        <input name="txtValor" type="text" class="form-control" id="txtValor" onKeyPress="return currencyFormat(this,event)" size="11" maxlength="10" value="<%=strValor%>">
                    </div>
                    
                     <div class="form-group">
                        <label class="form-label">Periodicidade Inicial</label>
                        <input name="txtPeriodicidadeInicial" type="text" class="form-control" id="txtPeriodicidadeInicial" onBlur="return validaData(this)" onKeyPress="return formataCampo(this, 3, 10)" size="11" maxlength="10" value="<%=strPeriodicidadeInicial%>">
                    </div>
                    
                    <div class="form-group">
                        <label class="form-label">Periodicidade Final</label>
                        <input name="txtPeriodicidadeFinal" type="text" class="form-control" id="txtPeriodicidadeFinal" onBlur="return validaData(this)" onKeyPress="return formataCampo(this, 3, 10)" size="11" maxlength="10" value="<%=strPeriodicidadeFinal%>">
                    </div>

                    <legend></legend>
                    <!--#include file="../../includes/inc_botoes_cadastro.asp"-->
                </form>
            	</div>
       	 	</div>
         	<!-- Fecha o Form -->  
      </div>
   	   
       <!--Table Bordered-->
       <%if strCodFunc <> "" and strCodFunc <> "0" then	%> 
        <div class="panel panel-grey margin-bottom-40">
            <div class="panel-heading">
                <h3 class="panel-title"><i class="fa fa-globe"></i> Lista Rubricas Fixas</h3>
            </div>
            <div class="panel-body">
                <table class="table table-bordered">
                    <thead>
                        <tr>
                          <th width="5%" bgcolor="#95A5A6">C&oacute;digo</th>
                          <th width="59%" bgcolor="#95A5A6">Descrição</th>
                          <th width="11%" bgcolor="#95A5A6">Conv&ecirc;nio</th>
                          <th width="11%" bgcolor="#95A5A6">Tipo Rubr&iacute;ca</th>
                          <th width="11%" bgcolor="#95A5A6">Tipo de Valor</th>
                          <th width="11%" bgcolor="#95A5A6">Valor Rubr&iacute;ca</th>
                          <th width="11%" bgcolor="#95A5A6">Data Inicial</th>
                          <th width="11%" bgcolor="#95A5A6">Data Final</th>
                          <th width="11%" bgcolor="#95A5A6">Situa&ccedil;&atilde;o</th>
                          <th width="6%" bgcolor="#95A5A6" align="center"><div align="center">Ação</div></th>
                      </tr>
                    </thead>
                     <tbody>
                    <%
                    cont =0
					sql = "SELECT Codigo, Cod_grupo, Descricao,"
					sql = sql & " Cod_convenio, Tipo_rubrica, Situacao_rubrica, Valor_rubrica, "
					sql = sql & " Tipo_Calculo, Periodicidade_inicial, Periodicidade_final"
					sql = sql & " FROM SRH_RUBRICA"
					sql = sql & " where Cod_grupo = " & intCodGrupo			
                    rs.open sql, cnn
                    if rs.eof = false then
                    
                    while not rs.eof
                        cont = cont + 1
						
						if trim(rs("Situacao_rubrica")) = "A" then
							strSituacao = "Ativo"
						else
							strSituacao = "Inativo"
						end if
						
						if trim(rs("Tipo_rubrica")) = "P" then
							TipoRubrica = "Positiva (+)"
						else
							TipoRubrica = "Negativa (-)"
						end if
	
						if trim(rs("Tipo_Calculo")) = "M" then
							TipoCalculo = "Moeda Corrente"
						elseif trim(rs("Tipo_Calculo")) = "P" then
							TipoCalculo = "Percentual"
						elseif trim(rs("Tipo_Calculo")) = "Q" then
							TipoCalculo = "Quantidade"
						else
						   TipoCalculo = ""	
						end if
						%>
                        <tr>
                            <td><%=trim(rs("Codigo"))%></td>
                            <td><%=trim(rs("Descricao"))%></td>
                            <td><%=trim(rs("Cod_convenio"))%></td>
                            <td><%=trim(TipoRubrica)%></td>
                            <td><%=trim(TipoCalculo)%></td>
                            <td><%=trim(formatNumber(rs("Valor_rubrica"),2))%></td>
                            <td><%=trim(formatadataAP(rs("Periodicidade_inicial")))%></td>
                            <td><%=trim(formatadataAP(rs("Periodicidade_final")))%></td>
                            <td><%=trim(strSituacao)%></td>
                            <td align="center" >
                            <button class="btn-u btn-u-sea" onClick="ExcluirRubrica('<%=rs("Codigo")%>')" type="button"><i class="fa fa-trash-o"></i></button>                            </td> 
                        </tr>
                    	<%				
                        rs.movenext
                        wend
                    end if
                    rs.close
                	%>
                    <tr>
                        <td colspan="10">Total Registros : <%=cont%></td>
                    </tr>
                    </tbody>
                </table>
            </div>                      
        </div>
        <%end if%> 
        <!--End Table Bordered-->	
        <!-- Fecha o Painel do Formulario -->        
    </div>
    <!--/container-->		
	<script>
        function resultadoConsulta(intCodigo){
        
            var frm = document.getElementById("frm");
            frm.txtCodigo.value=intCodigo;
            frm.submit();
        }
        
        function salvar(acao){
            
            var frm = document.getElementById("frm");
            
            if (frm.txtDescricao.value == "") {
                alert("A Situação deve ser informada !");
                frm.txtDescricao.focus();
                return false;
            }
            
            if (frm.cmbConvenios.value == "0") {
                alert("O Convênio deve ser informado !");
                frm.cmbConvenios.focus();
                return false;
            }
        
            if (frm.cmbTipoRubrica.value == "0") {
                alert("O Tipo Rubrica deve ser informado !");
                frm.cmbTipoRubrica.focus();
                return false;
            }
            
            if (frm.cmbSituacao.value == "0") {
                alert("A Situação deve ser informada !");
                frm.cmbSituacao.focus();
                return false;
            }
            
            if (frm.txtValor.value == "") {
                alert("O Valor Rubrica deve ser informado !");
                frm.txtValor.focus();
                return false;
            }
            
            if (frm.cmbTipoCalculo.value == "0") {
                alert("O Tipo de Valor deve ser informado !");
                frm.cmbTipoCalculo.focus();
                return false;
            }
            
            if (frm.txtPeriodicidadeInicial.value == "") {
                alert("A Periodicidade Inicial deve ser informada !");
                frm.txtPeriodicidadeInicial.focus();
                return false;
            }
            
            if (frm.txtPeriodicidadeFinal.value == "") {
                alert("A Periodicidade Final deve ser informada !");
                frm.txtPeriodicidadeFinal.focus();
                return false;
            }
            
            frm.action="Rubricas_cod.asp?acao=" + acao;
            frm.submit();
            return true;
        }
    </script>

    <!--=== End Content Part ===-->
   	<!--#include file="../RodapeModulo.asp"-->
	<!--#include file="../jsModulo.asp"-->
</body>
</html> 