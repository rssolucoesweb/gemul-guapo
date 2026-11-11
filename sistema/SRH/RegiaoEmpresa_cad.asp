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
        intCodRegiao 	= Trim(Request("cmbRegiao"))
		if intCodRegiao = "" then intCodRegiao = "0"
		strPaginaVoltar = "regiao_cad.asp"
	    strMostraBotaoVoltar = "S"
        strDesabilitaIncluir = "" ' Desabilita o botão Incluir
        strDesabilitaAlterar = "disabled" ' Desabilita o botão Alterar
        strDesabilitaExcluir = "disabled" ' Desabilita o botão Excluir
        strDesabilitaLimpar  = "" ' Habilita o Botão Limpar
    %>
    <!--=== Content Part ===-->
    <form id="frm" name="frm" method="post" action="RegiaoEmpresa_cad.asp">
    <div class="container content">		
    
      <!-- Grey Panel -->            
      <div class="panel panel-grey">
        <div class="panel-heading">
        	<h3 class="panel-title"><i class="fa fa-tasks"></i>Região Por Unidade</h3>
        </div>
        <!-- Inicia o Painel do Formulario -->     
        <div class="panel-body">
             <!-- Inicia o Form -->     
            <div class="panel-body">                                                        
                    
                    <div class="form-group">
                        <label class="form-label">Região</label>
                   		<!--#include file="../includes/inc_cmbRegiao.asp"-->
                    </div>
                    
                    <legend></legend>
                    <!--#include file="../../includes/inc_botoes_cadastro.asp"-->
                    
            	</div>
       	 	</div>
         	<!-- Fecha o Form -->  
      </div>
   	   
       <!--Table Bordered-->
       <%IF intCodRegiao<>"0" THEN%>
        <div class="panel panel-grey margin-bottom-40">
            <div class="panel-heading">
                <h3 class="panel-title"><i class="fa fa-globe"></i> Lista Unidades</h3>
            </div>
            <div class="panel-body">
                <table class="table table-bordered">
                    <thead>
                        <tr>
                          <th width="3%" bgcolor="#95A5A6"> <input name="chkTodos" type="checkbox" value="" onclick="return marcaTodos()"> </th>
                          <th width="5%" bgcolor="#95A5A6">Código</th>
                          <th width="53%" bgcolor="#95A5A6">Unidade</th>
                          <th width="39%" bgcolor="#95A5A6">Região Atual</th>
                      </tr>
                    </thead>
                     <tbody>
                    <%
				cont =0
				sql = "SELECT E.RAZAOSOCIAL, E.COD_REGIAO, R.DESCRICAO as REGIAO, E.CODIGO AS COD_EMPRESA "
				sql = sql & " FROM SEG_EMPRESA E"
				sql = sql & " LEFT JOIN SEG_REGIAO R ON R.CODIGO = E.COD_REGIAO"
				sql = sql & " WHERE E.BLOQUEIO='N' AND E.COD_GRUPO = " & Session("CodGrupo")
				sql = sql & " Order by E.RAZAOSOCIAL"
				rs.open sql, cnn
				if rs.eof = false then
                    while not rs.eof
						cont = cont + 1	
						strMarca 	= ""
						if trim(intCodRegiao) = trim(rs("cod_regiao")) then
							strMarca = "checked"
						end if
						strDesabilitar=""
						if not isnull(rs("cod_regiao")) and trim(intCodRegiao) <> trim(rs("cod_regiao")) then
							strDesabilitar = "disabled"
						end if
                    	%>
                        <tr>
                            <td><input <%=strDesabilitar%> name="chkEmp"  type="checkbox"  value="<%=rs("cod_empresa")%>" <%=strMarca%>></td>
                            <td><%=trim(rs("cod_empresa"))%></td>
                            <td><%=trim(rs("RAZAOSOCIAL"))%></td>
                            <td><%=trim(rs("regiao"))%></td>
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
        <%end if%>
        <!--End Table Bordered-->	
        <!-- Fecha o Painel do Formulario -->        
    </div>
    </form>
    <script>
	function salvar(acao){
		
			var intContMarcado=0;
			var frm = document.getElementById("frm");
	
			if (frm.cmbRegiao.value == "0") {
				alert("Região deve ser informada!");
				frm.cmbRegiao.focus();
				return false;
			} 
			
			frm.action="RegiaoEmpresa_cod.asp?acao=" + acao;
			frm.submit();
			return true;	 
	}
	
	function marcaTodos(){
		
		var frm = document.getElementById("frm");
		
		if(frm.chkTodos.checked == true){ 
		  for (var i = 0; i < frm.elements.length; i++) {
					//verifica todos os checkbox
					if (frm.elements[i].type == "checkbox"){				
						frm.elements[i].checked = true;				
					}
		  }
		}else{
		  for (var i = 0; i < frm.elements.length; i++) {
					//verifica todos os checkbox
					if (frm.elements[i].type == "checkbox"){				
						frm.elements[i].checked = false;				
					}
		  }
		}
		return true;
	}
    </script>
    <!--/container-->		
    <!--=== End Content Part ===-->
   	<!--#include file="../RodapeModulo.asp"-->
	<!--#include file="../jsModulo.asp"-->
</body>
</html> 