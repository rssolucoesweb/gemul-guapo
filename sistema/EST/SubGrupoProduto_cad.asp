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
        strEmpresaSecaoProduto_submit = "S"
        principal			= "principal.asp"
        strOnChangeGrupo	= "S" 
        intCodigo 			= Trim(Request.Form("txtCodigo"))
        strDescricao 		= Trim(Request.Form("txtDescricao"))
        intCodGrupoProduto	= Trim(Request("cmbGrupoProduto"))
        intCodEmpresa		= session("CodEmpresa")
        strSituacao	 		= Trim(Request.Form("cmbSituacao"))
        intSecaoProduto			= Trim(Request.Form("cmbSecaoProduto"))
        if intSecaoProduto = "" then intSecaoProduto = "0"
    
        if trim(intCodigo) <> "" then
        
            sql = "SELECT S.CODIGO, S.DESCRICAO,S.Situacao,S.COD_GRUPO_PRODUTO"
            sql = sql & " FROM EST_SUBGRUPO_PRODUTO S"
            sql = sql & " inner join EST_GRUPO_PRODUTO G on G.codigo = S.COD_GRUPO_PRODUTO"
            sql = sql & " Where S.Codigo = " & intCodigo
            sql = sql & " and G.cod_secao = " & intSecaoProduto
            sql = sql & " and G.cod_empresa = " & intCodEmpresa
    
            rs.open sql, cnn
            
            if rs.eof = false then
                
                intCodigo	 		= rs("Codigo")
                strDescricao		= rs("Descricao")
                intCodGrupoProduto	= rs("COD_GRUPO_PRODUTO")	
                strSituacao			= rs("Situacao")
                            
                strDesabilitaIncluir	= "disabled" 'Desabilita o botão Incluir
                strDesabilitaAlterar 	= "" 'Desabilita o botão Excluir
                strDesabilitaExcluir	= "" 'Desabilita o botão Excluir
    
            end if 
            rs.close
        else
            strDesabilitaIncluir	= "" 'Desabilita o botão Incluir
            strDesabilitaAlterar 	= "disabled" 'Desabilita o botão Excluir
            strDesabilitaExcluir	= "disabled" 'Desabilita o botão Excluir
            BotaoPDF   				= "disabled"
        end if 
    %>
    <!--=== Content Part ===-->
    <div class="container content">		
    
      <!-- Grey Panel -->            
      <div class="panel panel-grey">
        <div class="panel-heading">
        	<h3 class="panel-title"><i class="fa fa-tasks"></i>Cadastro de SubGrupo</h3>
        </div>
        <!-- Inicia o Painel do Formulario -->     
        <div class="panel-body">
             <!-- Inicia o Form -->     
            <div class="panel-body">                                                        
                <form id="frm" class="margin-bottom-10" method="post">
                	
                  <input name="txtCodigo" type="hidden" id="txtCodigo" class="text" size="10" value="<%=intCodigo%>" maxlength="10">
                    
                  <div class="form-group">
                    <label class="form-label">Se&ccedil;&atilde;o</label>
                    <!--#include file="../includes/inc_cmbSecaoProduto.asp" -->
                  </div>
                  
                  <div class="form-group">
                    <label class="form-label">Grupo</label>
                    <!--#include file="../includes/inc_cmbGrupoProduto.asp"-->
                  </div>
                  
                  <div class="form-group">
                    <label class="form-label">Descri&ccedil;&atilde;o</label>
                    <input name="txtDescricao" type="text" class="form-control" id="txtDescricao" size="40" maxlength="40" value="<%=strDescricao%>">
                  </div>
                  
                  
                  <div class="form-group">
                    <label class="form-label">Situa&ccedil;&atilde;o</label>
                    <select name="cmbSituacao" class="form-control" id="cmbSituacao">
                        <option value="0">Selecione...</option>
                        <option value="A" <%if strSituacao = "A" then response.Write("selected") %>>Ativo</option>
                        <option value="I" <%if strSituacao = "I" then response.Write("selected") %>>Inativo</option>
                    </select>
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
                <h3 class="panel-title"><i class="fa fa-globe"></i> Lista SubGrupo</h3>
          </div>
            <div class="panel-body">
            	<div class="table-responsive">
                <table class="table table-bordered">
                    <thead>
                        <tr>
                          <th width="9%" bgcolor="#95A5A6">C&oacute;digo</th>
                          <th width="83%" bgcolor="#95A5A6">Descrição</th>
                          <th width="8%" bgcolor="#95A5A6" align="center"><div align="center">Ação</div></th>
                      </tr>
                    </thead>
                  <%
                    cont =0
					if intCodGrupoProduto = "" then intCodGrupoProduto = "0"
					
					sql = "SELECT S.Codigo,  S.Descricao, S.Situacao"
					sql = sql & " FROM EST_SUBGRUPO_PRODUTO S"
					sql = sql & " inner join EST_GRUPO_PRODUTO G on G.codigo = S.COD_GRUPO_PRODUTO"
					sql = sql & " where  G.cod_secao = " & intSecaoProduto
					sql = sql & " and G.cod_empresa = " & intCodEmpresa
				    rs.open sql, cnn
                    if rs.eof = false then
                    
                    while not rs.eof
					cont = cont + 1	
			        %>
                    <tbody>
                        <tr>
                            <td><%=trim(rs("Codigo"))%></td>
                            <td><%=trim(rs("Descricao"))%></td>
                          <td align="center" >
                            <button class="btn-u btn-u-sea" onClick="resultadoConsulta(<%=trim(rs("Codigo"))%>)" type="button"><i class="fa fa-file-text-o"></i></button> 
                          </td> 
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
                frm.txtCodigo.value=intCodigo
                frm.submit();
            }
    
        function salvar(acao){
            
            var frm = document.getElementById("frm");
            
            if (frm.txtDescricao.value == "") {
                alert("A Descrição deve ser informada !");
                frm.txtDescricao.focus();
                return false;
            }
            
            if (frm.cmbGrupoProduto.value == "0") {
                alert("Grupo deve ser informado!");
                frm.cmbGrupoProduto.focus();
                return false;
            }
            
            if (frm.cmbSituacao.value == "0") {
                alert("A Situação deve ser informada !");
                frm.cmbSituacao.focus();
                return false;
            }
            
            frm.action="SubGrupoProduto_cod.asp?acao=" + acao;
            frm.submit();
            return true;
        }
    </script>
    <!--=== End Content Part ===-->
   	<!--#include file="../RodapeModulo.asp"-->
	<!--#include file="../jsModulo.asp"-->
</body>
</html> 