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
        strPaginaTitulo = "ExcessaoModulacao_cad.asp"
        strExcessaoPorUnidade = "S"
        strDesabilitaExcessaoPorUnidade = "disabled"
        
        intCodEmpresa		= session("codEmpresa")
        intCodigo	 		= Trim(Request.Form("txtCodigo"))
        strTipoLancamento	= Trim(Request.Form("cmbTipoLancamento"))
        strDataLancamento	= Trim(Request.Form("cmbDataLancamento"))
        strDataReferencia	= Trim(Request.Form("cmbDataReferencia"))
        strTipoLancamento	= Trim(Request.Form("cmbDataReferencia"))
        strDescricao 		= Trim(Request.Form("txtDescricao"))
        strModularGrupo		= Trim(Request("GerarGrupo"))
    
        strAnoLetivo 			= Trim(Request.Form("txtAnoLetivo"))
        if strAnoLetivo = "" then 	strAnoLetivo = session("strAnoLetivo")
        intSemestre 			= Trim(Request.Form("cmbSemestre"))
        if intSemestre = "" then 	intSemestre  = session("strSemestre")
            
        if trim(intCodigo) <> "" then
        
            sql = "SELECT codigo, Tipo_Lancamento, Data_Lancamento, Data_Referencia, descricao, ano_letivo, semestre"
            sql = sql & " FROM SRH_EXCESSOES_PERIODOMODULACAO"
            sql = sql & " where Cod_Empresa = " & intCodEmpresa		
            sql = sql & " and codigo = " & intCodigo
            rs.open sql, cnn
            
            if rs.eof = false then
                
                strTipoLancamento	= rs("Tipo_Lancamento")
                strDataLancamento	= formatadataAP(rs("Data_Lancamento"))
                strDataReferencia	= formatadataAP(rs("Data_Referencia"))
                strDescricao		= rs("descricao")
                strAnoLetivo 		= Trim(rs("Ano_Letivo"))
                if strAnoLetivo = "" then 	strAnoLetivo = session("strAnoLetivo")
                intSemestre 		= Trim(rs("Semestre"))
                if intSemestre = "" then 	intSemestre  = session("strSemestre")
                strDesabilitaExcessaoPorUnidade = ""
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
        	<h3 class="panel-title"><i class="fa fa-tasks"></i>Cadastro de Exceção Modulação</h3>
        </div>
        <!-- Inicia o Painel do Formulario -->     
        <div class="panel-body">
             <!-- Inicia o Form -->     
            <div class="panel-body">                                                        
                <form id="frm" class="margin-bottom-10" method="post">
                	<input name="txtCodigo" type="hidden" id="txtCodigo" class="text" size="10" value="<%=intCodigo%>" maxlength="10">
              
                    <div class="form-group">
                        <label class="form-label">Ano Letivo</label>
                          <input  name="txtAnoLetivo" type="text" class="form-control" id="txtAnoLetivo" onblur="submit()"  value="<%=strAnoLetivo%>" size="5" maxlength="5" onkeypress="return formataCampo(this,2,10)">
                    </div>
                    
                    <div class="form-group">
                        <label class="form-label">Semestre</label>
                         <!--#include file="../includes/inc_cmdSemestre.asp" -->
                    </div>
                    
                    <div class="form-group">
                        <label class="form-label">Tipo</label>
                         <select name="cmbTipoLancamento" class="form-control" id="cmbTipoLancamento" style="width:100pt">
                            <option value="F" <%if strTipoLancamento = "F" then response.Write("selected") %>>Feriado</option>
                            <option value="R" <%if strTipoLancamento = "R" then response.Write("selected") %>>Reposição</option>
                            <option value="P" <%if strTipoLancamento = "P" then response.Write("selected") %>>Paralisação</option>
                            <option value="M" <%if strTipoLancamento = "M" then response.Write("selected") %>>Mudança Calendário</option>
                            <option value="D" <%if strTipoLancamento = "D" then response.Write("selected") %>>Sábado Letivo</option>
                        </select>
                    </div>
                    
                    <div class="form-group">
                        <label class="form-label">Data Lan&ccedil;amento</label>
                        <input name="txtDataLancamento" type="text" class="form-control" id="txtDataLancamento" onblur="return validaData(this)" onkeypress="return formataCampo(this, 3, 10)" size="11" maxlength="10" value="<%=strDataLancamento%>" title="Click aqui para visualizar o calend&aacute;rio">
                    </div>
                    
                    <div class="form-group">
                        <label class="form-label">Data Reposi&ccedil;&atilde;o</label>
                       <input name="txtDataReferencia" type="text" class="form-control" id="txtDataReferencia" onblur="return validaData(this)" onkeypress="return formataCampo(this, 3, 10)" size="11" maxlength="10" value="<%=strDataReferencia%>" title="Click aqui para visualizar o calend&aacute;rio">
                    </div>
                    
                    <div class="form-group">
                       <label class="form-label">Descri&ccedil;&atilde;o</label>
                       <input name="txtDescricao" type="text" class="form-control" id="txtDescricao" size="40" maxlength="40" value="<%=strDescricao%>">
                    </div>
                    
                    <div class="form-group">
                       <label class="form-label">Gerar Replica&ccedil;&atilde;o</label>
                       <input type="checkbox" name="GerarGrupo" value="S">- Para o Grupo
                    </div>

                    <legend></legend>
                    <!--#include file="../../includes/inc_botoes_cadastro.asp"-->
                </form>
            	</div>
       	 	</div>
         	<!-- Fecha o Form -->  
      </div>
   	   
       <!--Table Bordered-->
        <div class="panel panel-grey margin-bottom-40">
            <div class="panel-heading">
                <h3 class="panel-title"><i class="fa fa-globe"></i> Lista Exceção Modulação</h3>
          </div>
            <div class="panel-body">
                <table class="table table-bordered">
                    <thead>
                        <tr>
                          <th width="5%" bgcolor="#95A5A6">Código</th>
                          <th width="47%" bgcolor="#95A5A6">Descrição</th>
                          <th width="15%" bgcolor="#95A5A6">Tipo</th>
                          <th width="15%" bgcolor="#95A5A6">Data Lan&ccedil;amento</th>
                          <th width="13%" bgcolor="#95A5A6">Data Reposição</th>
                          <th width="5%" bgcolor="#95A5A6" align="center"><div align="center">Ação</div></th>
                      </tr>
                    </thead>
                     <tbody>
                    <%
                    cont =0
					sql = "SELECT codigo, Tipo_Lancamento, Data_Lancamento, Data_Referencia, descricao, ano_letivo, semestre"
					sql = sql & " FROM SRH_EXCESSOES_PERIODOMODULACAO"
					sql = sql & " where Cod_Empresa = " & intCodEmpresa		
					sql = sql & " and ano_letivo = " & strAnoLetivo			
					sql = sql & " Order by Data_Lancamento"
                    rs.open sql, cnn
                    if rs.eof = false then
                    
                    while not rs.eof
                        cont = cont + 1	
						if trim(rs("Tipo_Lancamento")) = "F" then msgTipoLancamento = "Feriado"
						if trim(rs("Tipo_Lancamento")) = "R" then msgTipoLancamento = "Reposição"
						if trim(rs("Tipo_Lancamento")) = "P" then msgTipoLancamento = "Paralisação"
						if trim(rs("Tipo_Lancamento")) = "M" then msgTipoLancamento = "Paralisação"
						if trim(rs("Tipo_Lancamento")) = "D" then msgTipoLancamento = "Sábado Letivo"
                    	%>
                        <tr>
                            <td><%=trim(rs("Codigo"))%></td>
                            <td><%=trim(rs("descricao"))%></td>
                            <td><%=trim(msgTipoLancamento)%></td>
                            <td><%=trim(formatadataAP(rs("Data_Lancamento")))%></td>
                            <td><%=trim(formatadataAP(rs("Data_Referencia")))%></td>
                            <td align="center" >
                            <button class="btn-u btn-u-sea" onclick="resultadoConsulta(<%=trim(rs("Codigo"))%>)" type="button"><i class="fa fa-file-text-o"></i></button>                            </td> 
                        </tr>
                    	<%				
                        rs.movenext
                        wend
                    end if
                    rs.close
                	%>
                    	<tr>
                    		<td colspan="6">Total Registros : <%=cont%></td>
                    	</tr>
                    </tbody>
                </table>
            </div>                      
        </div>
        <!--End Table Bordered-->	
        <!-- Fecha o Painel do Formulario -->        
    </div>
    <!--/container-->		
	<script>
        function porUnidade(codigo){
            window.open("ExcessaoModulacaoUnidade_cad.asp?codExcessao="+codigo,"consulta", "top=0,left=0,height=600,width=800,menubar=no,toolbar=no,scrollbars=yes,status=yes");
        }
        function resultadoConsulta(intCodigo){
        
            var frm = document.getElementById("frm");
            frm.txtCodigo.value=intCodigo;
            frm.submit();
        }
        
        function salvar(acao){
            
            var frm = document.getElementById("frm");
            
            if (frm.txtDescricao.value == "") {
                alert("A Descrição deve ser informada!");
                frm.txtDescricao.focus();
                return false;
            }
            if (frm.txtDataLancamento.value == "") {
                alert("A Data deve ser informada!");
                frm.txtDataLancamento.focus();
                return false;
            }
            
            frm.action="ExcessaoModulacao_cod.asp?acao=" + acao;
            frm.submit();
            return true;
        }
    
    </script>
    <!--=== End Content Part ===-->
   	<!--#include file="../RodapeModulo.asp"-->
	<!--#include file="../jsModulo.asp"-->
</body>
</html> 