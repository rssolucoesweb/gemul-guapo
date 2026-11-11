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
        strPaginaTitulo 		= "FuncaoColaborador_cad.asp"
        intCodigo	 			= Trim(Request.Form("txtCodigo"))
		carregaSubmitFuncao		= "N"
        strDescricao 			= Trim(Request.Form("txtDescricao"))
        strCategoriaFuncao		= Trim(Request.Form("cmbCategoriaFuncao"))
		if strCategoriaFuncao= "" then strCategoriaFuncao = "0"
        strPeriodoFuncao		= Trim(Request.Form("cmbPeriodoFuncao"))
        strSituacaoDisciplinar	= Trim(Request.Form("cmbSituacaoDisciplinar"))
        strModular				= Trim(Request.Form("cmbModular"))
        intCodFuncaoCategoria	= Trim(Request.Form("cmbFuncaoCategoria"))
            lancamento_falta_por	= Trim(Request.Form("lancamento_falta_por"))
        if trim(intCodigo) <> "" then
        
            sql = "SELECT COD_FUNCAO, DESC_FUNCAO, lancamento_falta_por,  Tipo_Funcao, Periodo, Situacao_Disciplinar, Modular, cod_FuncaoCategoria, situacao "
            sql = sql & " FROM SRH_FUNCAOCOLABORADOR"
            sql = sql & " Where Cod_Funcao = " & intCodigo
            rs.open sql, cnn
            
            if rs.eof = false then
                
                intCodigo	 		= rs("COD_FUNCAO")
                strDescricao			= rs("DESC_FUNCAO")
                strCategoriaFuncao		= rs("Tipo_Funcao")
                strPeriodoFuncao		= rs("Periodo")
                strSituacaoDisciplinar	= rs("Situacao_Disciplinar")
                strModular				= rs("Modular")
            	intCodFuncaoCategoria	= rs("cod_FuncaoCategoria")
                strDesabilitaIncluir	= "disabled" 'Desabilita o botão Incluir
                strDesabilitaAlterar 	= "" 'Desabilita o botão Excluir
                strDesabilitaExcluir	= "" 'Desabilita o botão Excluir
                  strSituacao 					= rs("Situacao")
				  lancamento_falta_por= rs("lancamento_falta_por")
   
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
        	<h3 class="panel-title"><i class="fa fa-tasks"></i>Cadastro de Função</h3>
        </div>
        <!-- Inicia o Painel do Formulario -->     
        <div class="panel-body">
             <!-- Inicia o Form -->     
            <div class="panel-body">                                                        
                <form id="frm" method="post">
                	<input name="txtCodigo" type="hidden" id="txtCodigo" class="text" size="10" value="<%=intCodigo%>" maxlength="10">
              
                    <div class="form-group">
                        <label class="form-label">Fun&ccedil;&atilde;o</label>
                        <input name="txtDescricao" type="text" class="form-control" id="txtDescricao" size="70" maxlength="70" value="<%=strDescricao%>">
                    </div>
                     <div class="form-group">
                        <label class="form-label">Função Categoria</label>
                        <!--#include file="../includes/inc_cmbFuncaoCategoria.asp" -->
                    </div>
                    
                     <div class="form-group">
                        <label class="form-label">Tipo</label>
                        <select name="cmbCategoriaFuncao" class="form-control" id="cmbCategoriaFuncao">
                        <option value="0" <%if strCategoriaFuncao = "0" then response.Write("selected") %>>Selecione...</option>
                        <option value="PROFESSOR" <%if strCategoriaFuncao = "PROFESSOR" then response.Write("selected") %>>PROFESSOR</option>
                        <option value="FUNCIONARIO" <%if strCategoriaFuncao = "FUNCIONARIO" then response.Write("selected") %>>FUNCIONARIO</option>
                      </select>
                    </div>
                    
                     <div class="form-group">
                        <label class="form-label">Situa&ccedil;&atilde;o Curricular</label>
                        <select name="cmbSituacaoDisciplinar" class="form-control" id="cmbSituacaoDisciplinar">
                           <option value="0">Selecione...</option>
                           <option value="D" <%if strSituacaoDisciplinar = "D" then response.Write("selected") %>>Disciplinar</option>
                           <option value="I" <%if strSituacaoDisciplinar = "I" then response.Write("selected") %>>Interdisciplinar</option>
                         </select>
                    </div>
                    
                    <div class="form-group">
                        <label class="form-label">Modular</label>
                        <select name="cmbModular" class="form-control" id="cmbModular">
                          <option value="0">Selecione...</option>
                          <option value="S" <%if strModular = "S" then response.Write("selected") %>>Sim</option>
                          <option value="N" <%if strModular = "N" then response.Write("selected") %>>Não</option>
                        </select>
                    </div>
					
					<div class="form-group">
                        <label class="form-label">Lançamento de faltas por</label>
                        <select name="lancamento_falta_por" class="form-control" id="lancamento_falta_por">
                          <option value="AULA" <%if lancamento_falta_por = "AULA" then response.Write("selected") %>>Aula</option>
                          <option value="DIA" <%if lancamento_falta_por = "DIA" then response.Write("selected") %>>Dia</option>
                        </select>
                    </div>
					
                    <div class="form-group">
                        <p>
                          <label class="form-label">Situação</label>
                          <!--#include file="../includes/inc_cmdSituacao.asp" -->
                        </p>
                       
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
                <h3 class="panel-title"><i class="fa fa-globe"></i> Lista Função</h3>
            </div>
            <div class="panel-body">
                <table class="table table-bordered">
                    <thead>
                        <tr>
                          <th width="4%" bgcolor="#95A5A6">Código</th>
                          <th width="33%" bgcolor="#95A5A6">Descrição</th>
                          <th width="33%" bgcolor="#95A5A6">Categoria</th>
                          <th width="14%" bgcolor="#95A5A6">Tipo</th>
                          <th width="5%" bgcolor="#95A5A6">Situação Curricular</th>
                          <th width="5%" bgcolor="#95A5A6">Modular</th>
                          <th width="5%" bgcolor="#95A5A6">Lançamento</th>
						  <th width="5%" bgcolor="#95A5A6">Situação</th>
                          <th width="6%" bgcolor="#95A5A6" align="center"><div align="center">Ação</div></th>
                      </tr>
                    </thead>
                     <tbody>
                    <%
						cont =0
						sql = "SELECT COD_FUNCAO, lancamento_falta_por, DESC_FUNCAO, Tipo_Funcao, Situacao_Disciplinar, Modular, c.descricao as categoria, f.situacao"
						sql = sql & " FROM SRH_FUNCAOCOLABORADOR f left join SRH_FUNCAOCATEGORIA c on c.codigo = f.cod_FuncaoCategoria"
						sql = sql & " Order by situacao, DESC_FUNCAO"
						rs.open sql, cnn
						if rs.eof = false then
						
						while not rs.eof
							cont = cont + 1	
							strModular = ""
						
							if trim(rs("Modular")) = "S" then
								strModular = "Sim"
							end if
							if trim(rs("Modular")) = "N" then
								strModular = "Não"
							end if
							cor = "000000"
							if rs("situacao")="I" then
								cor = "999999"
							end if
							
							%>
							<tr>
								<td><font color="#<%=cor%>"><%=trim(rs("COD_FUNCAO"))%></font></td>
								<td><font color="#<%=cor%>"><%=trim(rs("DESC_FUNCAO"))%></font></td>
								<td><font color="#<%=cor%>"><%=trim(rs("categoria"))%></font>&nbsp;</td>
                                <td><font color="#<%=cor%>"><%=trim(rs("Tipo_Funcao"))%></font></td>
                                <td><font color="#<%=cor%>"><%=trim(rs("Situacao_Disciplinar"))%></font></td>
                                <td><font color="#<%=cor%>"><%=trim(strModular)%></font></td>
                                <td><font color="#<%=cor%>"><%=trim(rs("lancamento_falta_por"))%></font></td>
								<td><font color="#<%=cor%>"><%=trim(rs("situacao"))%></font></td>
								<td align="center" >
								<button class="btn-u btn-u-sea" onclick="resultadoConsulta(<%=trim(rs("COD_FUNCAO"))%>)" type="button"><i class="fa fa-file-text-o"></i></button>                            </td> 
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
                alert("A Função deve ser informada !");
                frm.txtDescricao.focus();
                return false;
            }
			            
			if (frm.cmbSituacaoDisciplinar.value == "0") {
                alert("A Situação Curricular deve ser informada !");
                frm.cmbSituacaoDisciplinar.focus();
                return false;
            }
			
            frm.action="FuncaoColaborador_cod.asp?acao=" + acao;
            frm.submit();
            return true;
        }
    </script>
    <!--=== End Content Part ===-->
   	<!--#include file="../RodapeModulo.asp"-->
	<!--#include file="../jsModulo.asp"-->
</body>
</html> 