<!--#include file="../ConfigModulo.asp"-->
    <!--#include file="../../includes/inc_cnn.asp"-->
        <!--=== Breadcrumbs ===-->
      
<div class="breadcrumbs">
        <div class="container">
            <h1 class="pull-left">Modulo Biblioteca</h1>
            <ul class="pull-right breadcrumb">
                <li>Cadastro de CDU</li>
                <li class="active"><%=session("CodEmpresa")%> - <%=session("EmpresaWeb")%></li>
            </ul>
        </div><!--/container-->
    </div><!--/breadcrumbs-->
    <!--=== End Breadcrumbs ===-->
	<%
        strCodCDU				= Trim(Request.Form("txtCodigo"))
        strDescricao 			= Trim(Request.Form("txtDescricao"))
        intCodAreaConhecimento 	= Trim(Request.Form("cmbAreaConhecimento"))
            
        if trim(strCodCDU) <> "" then
        
            sql = "SELECT Cod_cdu, Nome_cdu, Cod_AreaConhecimento"
            sql = sql & " FROM SCB_CDU"
            sql = sql & " Where Cod_cdu = '" & strCodCDU & "'"
            sql = sql & " And Cod_empresa = " & session("codEmpresa")
	        rs.open sql, cnn
            
            if rs.eof = false then
                
                intCodConhecimento		= rs("Cod_cdu")
                strDescricao			= rs("Nome_cdu")
                intCodAreaConhecimento	= rs("Cod_AreaConhecimento")
                
                strDesabilitaIncluir	= "disabled" 'Desabilita o botão Incluir
                strDesabilitaAlterar 	= "" 'Desabilita o botão Excluir
                strDesabilitaExcluir	= "" 'Desabilita o botão Excluir
    		 else
				strDesabilitaIncluir	= "" 'Desabilita o botão Incluir
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
        	<h3 class="panel-title"><i class="fa fa-tasks"></i>Cadastro de CDU</h3>
        </div>
        <!-- Inicia o Painel do Formulario -->     
        <div class="panel-body">
             <!-- Inicia o Form -->     
            <div class="panel-body">                                                        
                <form id="frm" class="margin-bottom-10" method="post">
                    <div class="form-group">
                        <label for="exampleInputEmail1">Código </label>
                         <input name="txtCodigo" type="text" id="txtCodigo" class="form-control" size="50" value="<%=strCodCDU%>" style="width:130pt"  maxlength="100" onChange="submit()">
                    </div>
                    <div class="form-group">
                        <label for="exampleInputEmail1">Nome</label>
                         <input name="txtDescricao" type="text" class="form-control" id="txtDescricao" style="width:300pt" value="<%=strDescricao%>" size="80" maxlength="100">
                    </div>
                   
                    <div class="form-group">
                        <label for="exampleInputEmail1"> Area Conhecimento</label>
                         <!--#include file="../includes/inc_cmdAreaConhecimento.asp" -->
                    </div>
                    <legend></legend>
                    <!--#include file="../../includes/inc_botoes_cadastroPopap.asp"-->
                </form>
            	</div>
       	 	</div>
         	<!-- Fecha o Form -->  
      </div>
   	   
       <!--Table Bordered-->
                <div class="panel panel-grey margin-bottom-40">
                    <div class="panel-heading">
                        <h3 class="panel-title"><i class="fa fa-globe"></i> Lista de CDU</h3>
                    </div>
                    <div class="panel-body">
                        <table class="table table-bordered">
                            <thead>
                                <tr>
                                    <th width="26%" bgcolor="#95A5A6">#</th>
                                    <th width="65%" bgcolor="#95A5A6">Descrição</th>
                                  	<th width="9%" bgcolor="#95A5A6" align="center"><div align="center">Ação</div></th>
                                </tr>
                            </thead>
                            <%
							sql = " SELECT SCB_CDU.Cod_cdu, SCB_CDU.Nome_cdu, "
							sql = sql & " SCB_CDU.Cod_AreaConhecimento, SCB_AreaConhecimento.Nome_Conhecimento "
							sql = sql & " FROM SCB_CDU INNER JOIN SCB_AreaConhecimento "
							sql = sql & " ON (SCB_CDU.Cod_AreaConhecimento = SCB_AreaConhecimento.Cod_Conhecimento) " 
							sql = sql & " AND (SCB_CDU.Cod_Empresa = SCB_AreaConhecimento.Cod_Empresa) "
							sql = sql & " Where SCB_CDU.Cod_empresa = " & session("codEmpresa")
							sql = sql & " ORDER BY SCB_CDU.Cod_cdu "
							rs.open sql, cnn
							cont=0
							if rs.eof = false then
							
							while not rs.eof
							cont = cont + 1	
							%>
                            <tbody>
                                <tr>
                                    <td><%=trim(rs("Cod_cdu"))%></td>
                                    <td><%=trim(rs("Nome_cdu"))%></td>
                                    <td align="center" >
                                    <button class="btn-u btn-u-sea" onClick="resultadoConsulta('<%=trim(rs("Cod_cdu"))%>')" type="button"><i class="fa fa-file-text-o"></i></button> 
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
    function resultadoConsulta(intCodigo){
        frm.txtCodigo.value=intCodigo;
        frm.submit();
    }
    
    function salvar(acao){
        
        var frm = document.getElementById("frm");
        
        if (frm.txtCodigo.value == "") {
            alert("A Código CDU deve ser informada !");
            frm.txtCodigo.focus();
            return false;
        }
        
        if (frm.txtDescricao.value == "") {
            alert("A Descrição deve ser informada !");
            frm.txtDescricao.focus();
            return false;
        }
        
        if (frm.cmbAreaConhecimento.value == "0") {
            alert("A Area do conhecimento ser informada !");
            frm.cmbAreaConhecimento.focus();
            return false;
        }
        
        frm.action="cdu_cod.asp?acao=" + acao;
        frm.submit();
        return true;
    }
    </script>
    <!--#include file="../jsModulo.asp"-->
</body>
</html> 