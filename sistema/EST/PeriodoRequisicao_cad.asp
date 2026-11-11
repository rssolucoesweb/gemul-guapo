<!--#include file="../ConfigModulo.asp"-->
<!--#include file="../../includes/inc_cnn.asp"-->
<!--#include file="../../includes/inc_formatadata.asp"-->
<!--#include file="../menuModulos.asp"-->
<script src="../../js/js_funcoes_gerais.js"></script>  
    <!--=== Breadcrumbs ===-->
    <div class="breadcrumbs">
        <div class="container">
            <h1 class="pull-left">EST - Controle Almoxarifado</h1>
            <ul class="pull-right breadcrumb">
                <li><a href="Default.asp">Home</a></li>
                <li class="active"><%=session("CodEmpresa")%> - <%=session("EmpresaWeb")%></li>
            </ul>
        </div><!--/container-->
    </div><!--/breadcrumbs-->
    <!--=== End Breadcrumbs ===-->
	<%  
        strPaginaLimpar 	= "periodoRequisicao_cad.asp"
        strSubmitDepto 		= "S" 
        principal			= "principal.asp"
        intCodEmpresa		= session("CodEmpresa")	
        
        intCodDepartamento	= Trim(Request("cmbDepartamento"))
        if intCodDepartamento = "" then intCodDepartamento = "0"
        
        intDiaInicialFiltro	= Trim(Request("cmbDiaInicialFiltro"))
        if intDiaInicialFiltro = "" then intDiaInicialFiltro = "0"
        
        intDiaFinalFiltro	= Trim(Request("cmbDiaFinalFiltro"))
        if intDiaFinalFiltro = "" then intDiaFinalFiltro = "0"
        
        strSituacao	= Trim(Request("cmbSituacao"))
        if strSituacao = "" then strSituacao = "T"
    
        strDesabilitaIncluir 	= "" 'Desabilita o botão Incluir
        strDesabilitaAlterar 	= "disabled" 'Desabilita o botão Excluir
        strDesabilitaExcluir 	= "" 'Desabilita o botão Excluir
        strLiberaAlteracao		= "S"
    %>
    <!--=== Content Part ===-->
    <div class="container content">		
    
      <!-- Grey Panel -->            
      <div class="panel panel-grey">
        <div class="panel-heading">
        	<h3 class="panel-title"><i class="fa fa-tasks"></i>Período de Requisição </h3>
        </div>
        <!-- Inicia o Painel do Formulario -->     
        <div class="panel-body">
             <!-- Inicia o Form -->     
            <div class="panel-body">                                                        
                <form id="frm" name="frm" action="PeriodoRequisicao_cad.asp" method="post">
                	
                  <div class="form-group">
                        <label class="form-label">Unidade</label>
                        <!--#include file="../includes/inc_cmbDepartamentoEstoque.asp" -->
                  </div>
                  
                  <div class="form-group">
                    <label class="form-label">Situa&ccedil;&atilde;o</label>
                    <select name="cmbSituacao" id="cmbSituacao" class="form-control" onChange="submit()">
                        <option <%if strSituacao = "T" then response.Write("selected")%> value="T">Todos</option>
                        <option <%if strSituacao = "M" then response.Write("selected")%> value="M">Marcados</option>
                        <option <%if strSituacao = "N" then response.Write("selected")%> value="N">Não Marcados</option>
              		</select>
                  </div>
                  
                  <div class="form-group">
                        <label class="form-label">Per&iacute;odo</label>
                        <!--#include file="../includes/inc_cmbDiaInicialFiltro.asp"-->&nbsp;a&nbsp;<!--#include file="../includes/inc_cmbDiaFinalFiltro.asp"-->
                  </div>
                  
                  <div class="form-group">
                        <label class="form-label">Liberar entre os dias</label>
                        <!--#include file="../includes/inc_cmbDiaInicial.asp"-->&nbsp;a&nbsp;<!--#include file="../includes/inc_cmbDiaFinal.asp"-->
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
                <h3 class="panel-title"><i class="fa fa-globe"></i> Lista de Unidades</h3>
          </div>
            <div class="panel-body">
            	<div class="table-responsive">
                <table class="table table-bordered">
                    <thead>
                        <tr>
                          <th width="66%" bgcolor="#95A5A6">Unidades</th>
                          <th width="34%" bgcolor="#95A5A6">Per&iacute;odo Liberado</th>
                      </tr>
                    </thead>
                  <%
                    sql = "SELECT "
					sql = sql & " 	_d.codigo, "
					sql = sql & " 	upper(_d.descricao) as descricao,"
					sql = sql & " 	_r.DIA_FINAL,"
					sql = sql & " 	_r.DIA_INICIAL, _r.codigo as codLib"
					sql = sql & " from EST_departamento _d"
					sql = sql & " left join EST_LIBERA_REQUISICAO _r on _r.COD_DEPARTAMENTO = _d.CODIGO and _r.COD_EMPRESA = _d.COD_EMPRESA"
					sql = sql & " where _d.cod_Empresa = " & session("Codempresa")
					if intDiaInicialFiltro<>"0" then
						sql = sql & " and _r.DIA_INICIAL=" & intDiaInicialFiltro
					end if
					if intCodDepartamento<>"0" then
						sql = sql & " and _d.codigo=" & intCodDepartamento
					end if
					if intDiaFinalFiltro<>"0" then
						sql = sql & " and _r.DIA_FINAL=" & intDiaFinalFiltro
					end if
					if strSituacao="M" then
						sql = sql & " and _r.codigo is not null"
					end if
					if strSituacao="N" then
						sql = sql & " and _r.codigo is null"
					end if
					sql = sql & " order by "
					sql = sql & " 	_d.descricao "
					rs.open sql, cnn
					if rs.eof = false then
						strCorLinha = "#CCCCCC"
                    	while not rs.eof
							if strCorLinha = "#CCCCCC" then
								strCorLinha = "#FFFFFF"
							else
								strCorLinha = "#CCCCCC"
							end if
							if isnull(rs("DIA_INICIAL")) then
								periodo = "&nbsp;"
							else
								periodo = rs("DIA_INICIAL") & " a " & rs("DIA_FINAL")
							end if
							if isnull(rs("codLib")) then
								selecionado = ""
							else
								selecionado = "checked"
							end if
			        %>
                        <tbody>
                            <tr bgcolor="<%=strCorLinha%>">
                                <td><input  name="chkDepartamentoEmpresa" id="chkDepartamentoEmpresa" <%=selecionado%> type="checkbox" value="<%=rs("codigo")%>"><%=rs("descricao")%></td>
                                <td><%=periodo%></td>
                               </tr>
                        </tbody>
                    <%				
                        rs.movenext
                        wend
                    end if
                    rs.close
                %>
                </table>
                </div>
            </div>                      
        </div>
        <!--End Table Bordered-->	
        <!-- Fecha o Painel do Formulario -->        
    </div>
    <!--/container-->		
	<script>
    
        function resultadoConsulta(intCodigo){
                frm.cmbDepartamento.value=intCodigo
                frm.submit();
            }
        function consultar(intCodigo){
                frm.txtCodRequisicao.value=intCodigo
                frm.submit();
            }
    
        function salvar(acao){
            
            var frm = document.getElementById("frm");
            
            if (acao=="I") {
                if (frm.cmbDiaInicial.value == "0") {
                    alert("Dia Inicial deve ser informado!");
                    frm.cmbDiaInicial.focus();
                    return false;
                }
        
                if (frm.cmbDiaFinal.value == "") {
                    alert("Dia Final deve ser informado!");
                    frm.cmbDiaFinal.focus();
                    return false;
                }
            }
            if (parseInt(frm.cmbDiaInicial.value) > parseInt(frm.cmbDiaFinal.value)) {
                alert("Dia inicial não pode ser maior que dia final!");
                frm.cmbDiaInicial.focus();
                return false;
            }
            
            frm.action="periodorequisicao_cod.asp?acao=" + acao;
            frm.submit();
            return true;
        }
    </script>
    <!--=== End Content Part ===-->
   	<!--#include file="../RodapeModulo.asp"-->
	<!--#include file="../jsModulo.asp"-->
</body>
</html> 