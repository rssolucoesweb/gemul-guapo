<!--#include file="../ConfigModulo.asp"-->
    <!--#include file="../../includes/inc_cnn.asp"-->
	<!--#include file="../menuModulos.asp"-->  
    <!--=== Breadcrumbs ===-->
    <div class="breadcrumbs">
        <div class="container">
            <h1 class="pull-left">Modulo Gerencial</h1>
            <ul class="pull-right breadcrumb">
                <li><a href="Default.asp">Home</a></li>
                <li class="active"><%=session("CodEmpresa")%> - <%=session("EmpresaWeb")%></li>
            </ul>
        </div><!--/container-->
    </div><!--/breadcrumbs-->
    <!--=== End Breadcrumbs ===-->
	<%
        strPaginaTitulo = "SituacaoPromocao_cad.asp"
    
        intCodigo				= Trim(Request.Form("txtCodigo"))
        strDescricao 			= Trim(Request.Form("txtDescricao"))
        strDescricaoaAntiga		= Trim(Request.Form("txtDescricaoAntiga"))
        strDescAbreviada		= Trim(Request.Form("txtDescAbreviada"))
            
        if trim(intCodigo) <> "" then
        
            sql = "SELECT codigo, descricao, Desc_Abreviada, criterio"
            sql = sql & " FROM SCA_SITUACAO_PROMOCAO"
            sql = sql & " Where codigo = " & intCodigo
            
            rs.open sql, cnn
            
            if rs.eof = false then
                
                intCodigo	 				= rs("codigo")
                strDescricao				= rs("descricao")
                strDescricaoaAntiga			= rs("descricao")
                strDescAbreviada			= rs("Desc_Abreviada")
                strCriterio					= rs("Criterio")
                
                strDesabilitaIncluir	= "disabled" 'Desabilita o botão Incluir
                strDesabilitaAlterar 	= "disabled" 'Desabilita o botão Excluir
                strDesabilitaExcluir	= "disabled" 'Desabilita o botão Excluir
    
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
        	<h3 class="panel-title"><i class="fa fa-tasks"></i>Cadastro Situação Promoção</h3>
        </div>
        <!-- Inicia o Painel do Formulario -->     
        <div class="panel-body">
             <!-- Inicia o Form -->     
            <div class="panel-body">                                                        
                <form id="frm" class="margin-bottom-10" method="post">
                	<input name="txtCodigo" type="hidden" class="text" id="txtCodigo" value="<%=intCodigo%>" size="10">
                    <div class="form-group">
                        <label class="form-label">Situação</label>
                         <input name="txtDescricao" type="text" class="form-control" id="txtDescricao" style="width:350pt" value="<%=strDescricao%>" size="80" maxlength="100">
                         <input name="txtDescricaoAntiga" type="hidden" class="text" id="txtDescricaoAntiga" size="40" maxlength="40" value="<%=strDescricaoAntiga%>">
                    </div>
                    
                    <div class="form-group">
                        <label class="form-label">Desc. Abreviada</label>
                         <input name="txtDescAbreviada" type="text" class="form-control" id="txtDescAbreviada" style="width:350pt" value="<%=strDescAbreviada%>" size="80" maxlength="100">
                    </div>
                  
                    <div class="form-group">
                        <label class="form-label">Crit&eacute;rio</label>
                        <select name="cmbCriterio" class="form-control" style="width:150pt">
                        <option <%if strCriterio = "SC" or isnull(strCriterio) then response.Write("selected")%> value="SC">Sem Critério</option>
                        <option <%if strCriterio = "AP" then response.Write("selected")%> value="AP">Aprovação</option>
                        <option <%if strCriterio = "RP" then response.Write("selected")%> value="RP">Reprovação Por Nota</option>
                        <option <%if strCriterio = "RF" then response.Write("selected")%> value="RF">Reprovação Por Falta</option>
                        <option <%if strCriterio = "DI" then response.Write("selected")%> value="DI">Dispensado</option>
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
                        <h3 class="panel-title"><i class="fa fa-globe"></i> Lista Situação Promoção</h3>
                    </div>
                    <div class="panel-body">
                        <table class="table table-bordered">
                            <thead>
                                <tr>
                                    <th width="3%" bgcolor="#95A5A6">#</th>
                                    <th width="29%" bgcolor="#95A5A6">Descrição</th>
                                    <th width="28%" bgcolor="#95A5A6">Abreviada</th>
                                    <th width="34%" bgcolor="#95A5A6">Crit&eacute;rio</th>
                                    <th width="6%" bgcolor="#95A5A6" align="center"><div align="center">Ação</div></th>
                                </tr>
                            </thead>
                            <%
							sql = "SELECT codigo, descricao, Desc_Abreviada, criterio"
							sql = sql & " FROM SCA_SITUACAO_PROMOCAO"
							sql = sql & " Order by descricao"
							rs.open sql, cnn
							cont=0
							if rs.eof = false then
							
							while not rs.eof
							cont = cont + 1	
							
							Criterio = ""
							if trim(rs("Criterio")) = "SC" then Criterio = "Sem Critério"
							if trim(rs("Criterio")) = "AP" then Criterio = "Aprovação"
							if trim(rs("Criterio")) = "RP" then Criterio = "Reprovação Por Nota"
							if trim(rs("Criterio")) = "RF" then Criterio = "Reprovação Por Falta"
							if trim(rs("Criterio")) = "DI" then Criterio = "Dispensado"
					
							%>
                            <tbody>
                                <tr>
                                    <td><%=trim(rs("codigo"))%></td>
                                    <td><%=trim(rs("descricao"))%></td>
                                    <td><%=trim(rs("Desc_Abreviada"))%></td>
                                    <td><%=trim(Criterio)%></td>
                                    <td align="center" >
                                    <button class="btn-u btn-u-sea" onClick="resultadoConsulta(<%=trim(rs("codigo"))%>)" type="button"><i class="fa fa-file-text-o"></i></button> 
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
                <!--End Table Bordered-->	
       <!-- Fecha o Painel do Formulario -->        
    </div>
    <!--/container-->		
    <script>
	function salvar(acao){
		
		var frm = document.getElementById("frm");
		
		if (frm.txtDescricao.value == "") {
			alert("A Descrição deve ser informada !");
			frm.txtDescricao.focus();
			return false;
		}
		
		if (frm.txtDescAbreviada.value == "") {
			alert("A Descrição Abreviada deve ser informada !");
			frm.txtDescAbreviada.focus();
			return false;
		}
		
		frm.action="SituacaoPromocao_cod.asp?acao=" + acao;
		frm.submit();
		return true;
		
		}
	
		function resultadoConsulta(intCodigo){
			var frm = document.getElementById("frm");
			frm.txtCodigo.value=intCodigo;
			frm.submit();
		}
	</script>
    <!--=== End Content Part ===-->
   	<!--#include file="../RodapeModulo.asp"-->
	<!--#include file="../jsModulo.asp"-->
</body>
</html> 