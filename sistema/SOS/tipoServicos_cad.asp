<!--#include file="../ConfigModulo.asp"-->
<!--#include file="../../includes/inc_cnn.asp"-->
<!--#include file="../../includes/inc_formatadata.asp"-->
<!--#include file="../menuModulos.asp"-->
<script src="../../js/js_funcoes_gerais.js"></script>  
    <!--=== Breadcrumbs ===-->
    <div class="breadcrumbs">
        <div class="container">
         <%if Session("mobile")<>"S" then%>
            <h1 class="pull-left">OS - Ordem de Serviço</h1>
            <ul class="pull-right breadcrumb">
                <li><a href="Default.asp">Home</a></li>
                <li class="active"><%=session("CodEmpresa")%> - <%=session("EmpresaWeb")%></li>
            </ul>
           <%end if%>
        </div><!--/container-->
    </div><!--/breadcrumbs-->
    <!--=== End Breadcrumbs ===-->
	<%
        strPaginaTitulo = "tipoServico_cad.asp"
    
        intCodigo 			= Trim(Request.Form("txtCodigo"))
        intCodArea		 	= Trim(Request.Form("cmbArea"))
        intCodPrioridade 	= Trim(Request.Form("cmbPrioridade"))
        strDescricao 		= Trim(Request.Form("txtDescricao"))
        strItem 			= Trim(Request.Form("txtItem"))
            
        if trim(intCodigo) <> "" then
        
            sql = "SELECT CODIGO, COD_AREA, DESCRICAO, ITEM, cod_prioridade"
            sql = sql & " FROM SOS_TIPO_SERVICO"
            sql = sql & " where CODIGO = " & intCodigo
            rs.open sql, cnn
            
            if rs.eof = false then
                
                intCodigo	 			= rs("codigo")
				strItem		 			= rs("item")
                strDescricao			= rs("descricao")
                intCodArea				= rs("cod_area")	
                intCodPrioridade		= rs("cod_prioridade")	
				
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
        
        <div class="row">
            <!-- Begin Content -->
            <div class="col-md-12" >     
        
            <!-- Inicia o Painel do Formulario -->     
        
                <form id="frm" class="sky-form  panel-body0" method="post">
                    
                    <input name="txtCodigo" type="hidden" id="txtCodigo" class="text" size="10" value="<%=intCodigo%>" maxlength="10">
                    
                    <div style="background:#95a5a6;height:40px;padding-top: 8px;" class="panel-title">&nbsp;&nbsp;<font color="#FFFFFF"><i class="fa fa-tasks"></i>&nbsp;Cadastro de Tipo de Serviço</font></div>
        
                    <fieldset>
                        <div class="row">
                             <section class="col col-12">
                                <label class="form-label">Descrição</label>
                              
                                <label class="input">
                                    <input name="txtDescricao" type="text" class="form-control" id="txtDescricao" size="70" maxlength="70" value="<%=strDescricao%>">
                                </label>
                             </section>
                        </div>
                        <div class="row">
                             <section class="col col-12">
                                <label class="form-label">Cod.Item</label>
                              
                                <label class="input">
                                    <input name="txtItem" type="text" class="form-control" id="txtItem" size="5" maxlength="5" value="<%=stritem%>">
                                </label>
                             </section>
                        </div>
                        <div class="row">
                             <section class="col col-12">
                                <label class="form-label">Área</label>
                              
                                <label class="input">
                                    <!--#include file="../includes/inc_cmbArea.asp" -->
                                </label>
                             </section>
                        </div>
                        
                        <div class="row" style="display:none">
                             <section class="col col-12">
                                <label class="form-label">Prioridade</label>
                              
                                <label class="input">
                                    <!--#include file="../includes/inc_cmbPrioridade.asp" -->
                                </label>
                             </section>
                        </div>
                        
                        
				    </fieldset>
    				
                    <div class="margin-left-40">
                    <!--#include file="../../includes/inc_botoes_cadastro.asp"-->
					</DIV>
                          
                </form>
            	</div>
       	 	</div>
         	<!-- Fecha o Form -->  
      </div>
   	   
       <!--Table Bordered-->
        <div class="panel panel-grey margin-bottom-40">
            <div class="panel-heading">
                <h3 class="panel-title"><i class="fa fa-globe"></i> Lista tipo de serviços</h3>
            </div>
            <div class="panel-body">
                <table class="table table-bordered">
                    <thead>
                        <tr>
                           <th width="23%" bgcolor="#95A5A6">Área</th>
                         <th width="54%" bgcolor="#95A5A6">Item/Serviço</th>
                          <th width="5%" bgcolor="#95A5A6" align="center"><div align="center">Ação</div></th>
                      </tr>
                    </thead>
                     <tbody>
                    <%
                    cont =0
					sql = "SELECT ts.item, ts.codigo, ts.descricao, a.Descricao as area, ts.Cod_area, p.descricao as prioridade"
					sql = sql & " FROM SOS_TIPO_SERVICO TS"
					sql = sql & " left join SOS_AREA A on a.Codigo = ts.Cod_area"
					sql = sql & " left join SOS_PRIORIDADE P on p.Codigo = ts.Cod_prioridade"
					sql = sql & " WHERE TS.Cod_grupo = " & Session("CodGrupo")	
					sql = sql & " Order by ts.cod_area, ts.item, a.descricao, ts.descricao"
                    rs.open sql, cnn
                    if rs.eof = false then
                    
                    while not rs.eof
                        cont = cont + 1	
                    	%>
                        <tr>
                            <td><%=trim(rs("Cod_area"))%>. <%=trim(rs("area"))%></td>
                            <td><%=trim(rs("item"))%>.&nbsp;<%=trim(rs("descricao"))%></td>
                            <td align="center" >
                            <button class="btn-u btn-u-sea" onclick="resultadoConsulta(<%=trim(rs("codigo"))%>)" type="button"><i class="fa fa-file-text-o"></i></button>                            
                            </td> 
                        </tr>
                    	<%				
                        rs.movenext
                        wend
                    end if
                    rs.close
                	%>
                    	<tr>
                    		<td colspan="4">Total Registros : <%=cont%></td>
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
                alert("Descrição deve ser informado!");
                frm.txtDescricao.focus();
                return false;
            }
            if (frm.txtItem.value == "") {
                alert("Item deve ser informado!");
                frm.txtItem.focus();
                return false;
            }
            if (frm.cmbArea.value == "0") {
                alert("Área deve ser informado!");
                frm.cmbArea.focus();
                return false;
            }/*
            if (frm.cmbPrioridade.value == "0") {
                alert("Prioridade deve ser informada!");
                frm.cmbPrioridade.focus();
                return false;
            }
            */
            frm.action="tipoServicos_cod.asp?acao=" + acao;
            frm.submit();
            return true;
        }
    
    </script>
    <!--=== End Content Part ===-->
   	<!--#include file="../RodapeModulo.asp"-->
	<!--#include file="../jsModulo.asp"-->
</body>
</html> 