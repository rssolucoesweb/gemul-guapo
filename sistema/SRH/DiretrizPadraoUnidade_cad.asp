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
        strExecutarDiretrizPadraoUnidade = "S"
        intDiretrizPadraoUnidade 	= Trim(Request("cmbDiretrizPadraoUnidade"))
    
        strDesabilitaIncluir = "" ' Desabilita o botão Incluir
        strDesabilitaAlterar = "disabled" ' Desabilita o botão Alterar
        strDesabilitaExcluir = "disabled" ' Desabilita o botão Excluir
        strDesabilitaLimpar  = "" ' Habilita o Botão Limpar
        
    %>
    <!--=== Content Part ===-->
    <form id="frm" name="frm" method="post" action="DiretrizPadraoUnidade_cad.asp">
    <div class="container content">		
    
      <!-- Grey Panel -->            
      <div class="panel panel-grey">
            <div class="panel-heading">
                <h3 class="panel-title"><i class="fa fa-tasks"></i>Diretriz Padrão - Unidade</h3>
            </div>
            <!-- Inicia o Painel do Formulario -->     
        	<div class="panel-body">
             <!-- Inicia o Form -->     
                <div class="panel-body">                                                        
    
                        <div class="form-group">
                            <label class="form-label">Diretriz padr&atilde;o parcial</label>
                            <!--#include file="../includes/inc_cmdDiretrizPadraoUnidade.asp" -->
                        </div>
                      
                        <legend></legend>
                        <!--#include file="../../includes/inc_botoes_cadastro.asp"-->
                 <div>	
       	 	</div>
         	<!-- Fecha o Form -->  
      </div>
      	
                <!--Table Bordered-->
        <%IF intDiretrizPadraoUnidade<>"0" and intDiretrizPadraoUnidade<>"" THEN%>
        <div class="panel panel-grey margin-bottom-40">
            <div class="panel-heading">
                <h3 class="panel-title"><i class="fa fa-globe"></i> Lista de Unidade/Empresa</h3>
            </div>
            <div class="panel-body">
                <table class="table table-bordered">
                    <thead>
                        <tr>
                          <th width="3%" bgcolor="#95A5A6"><input name="chkTodos" type="checkbox" value="" onClick="return marcaTodos()"> </th>
                          <th width="8%" bgcolor="#95A5A6">Código</th>
                          <th width="89%" bgcolor="#95A5A6">Empresa</th>
                      </tr>
                    </thead>
                     <tbody>
                    <%
                    cont =0
					sql = "SELECT SEG_EMPRESA.RAZAOSOCIAL, SEG_GRUPO.DESCRICAO as GRUPO, SEG_EMPRESA.COD_GRUPO, SEG_EMPRESA.CODIGO AS COD_EMPRESA"
					sql = sql & " FROM SEG_EMPRESA"
					sql = sql & " LEFT JOIN SEG_GRUPO ON SEG_GRUPO.CODIGO = SEG_EMPRESA.COD_GRUPO"
					sql = sql & " WHERE SEG_EMPRESA.COD_GRUPO = " & session("CodGrupo")
					sql = sql & " Order by SEG_GRUPO.DESCRICAO, SEG_EMPRESA.RAZAOSOCIAL"
                    rs.open sql, cnn
                    if rs.eof = false then
                    
                    while not rs.eof
                        cont = cont + 1	
						strMarca 	= ""
						sql = "SELECT codigo"
						sql = sql & " FROM SRH_DIRETRIZES_PADRAO_UNIDADE"
						sql = sql & " WHERE CodDiretrizPadrao = " & intDiretrizPadraoUnidade
						sql = sql & " AND COD_EMPRESA = " & trim(rs("cod_empresa"))
						RsAux.open sql, cnn
						if RsAux.eof = false then
							strMarca = "checked"
						else
							strMarca = ""
						end if
						
						RsAux.close
						%>
                        <tr>
                            <td><input name="chkEmp"  type="checkbox" value="<%=rs("cod_empresa")%>" <%=strMarca%>></td>
                            <td><%=trim(rs("cod_empresa"))%></td>
                            <td><%=trim(rs("RAZAOSOCIAL"))%></td>
                        </tr>
                    	<%				
                        rs.movenext
                        wend
                    end if
                    rs.close
                	%>
                    <tr>
                        <td colspan="5">Total Registros : <%=cont%></td>
                    </tr>
                    </tbody>
                </table>
            </div>                      
        </div>
        <%end if%>
        <!--End Table Bordered-->	
        <!-- Fecha o Painel do Formulario -->   
             
    </div>
    </div>
    </div>
    <!--/container-->	
    </form>	
	<script>
        function salvar(acao){
        
            var intContMarcado=0;
            var frm = document.getElementById("frm");
    
            if (frm.cmbDiretrizPadraoUnidade.value == "0") {
                alert("A Diretriz deve ser informada!");
                frm.cmbDiretrizPadraoUnidade.focus();
                return false;
            } 
            
            frm.action="DiretrizPadraoUnidade_cod.asp?acao=" + acao;
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

    <!--=== End Content Part ===-->
   	<!--#include file="../RodapeModulo.asp"-->
	<!--#include file="../jsModulo.asp"-->
</body>
</html> 