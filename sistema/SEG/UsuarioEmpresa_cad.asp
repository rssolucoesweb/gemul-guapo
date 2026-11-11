<!--#include file="../ConfigModulo.asp"-->
    <!--#include file="../../includes/inc_cnn.asp"-->
	<!--#include file="../menuModulos.asp"-->  
    <!--=== Breadcrumbs ===-->
    <div class="breadcrumbs">
        <div class="container">
            <h1 class="pull-left">Modulo Seguran&ccedil;a</h1>
            <ul class="pull-right breadcrumb">
                <li><a href="Default.asp">Home</a></li>
                <li class="active"><%=session("CodEmpresa")%> - <%=session("EmpresaWeb")%></li>
            </ul>
        </div><!--/container-->
    </div><!--/breadcrumbs-->
    <!--=== End Breadcrumbs ===-->
	<%
		strPagina			= "UsuarioEmpresa_cad.asp"
        intCodGrupo 		= Trim(Request("cmdGrupo"))
        if intCodGrupo = "" then intCodGrupo = 0
        strUsuarioPortal 	= Trim(Request("txtUsuarioPortal"))
    
        strDesabilitaIncluir = "" ' Desabilita o botão Incluir
        strDesabilitaAlterar = "disabled" ' Desabilita o botão Alterar
        strDesabilitaExcluir = "disabled" ' Desabilita o botão Excluir
        strDesabilitaLimpar  = "" ' Habilita o Botão Limpar
        
    %>
     <!--=== Content Part ===-->
     <form id="frm" class="margin-bottom-10" method="post">
    <div class="container content">		
    
      <!-- Grey Panel -->            
      <div class="panel panel-grey">
        <div class="panel-heading">
        	<h3 class="panel-title"><i class="fa fa-tasks"></i>Vincula Usu&aacute;rio a Empresa</h3>
        </div>
        <!-- Inicia o Painel do Formulario -->     
        <div class="panel-body">
             <!-- Inicia o Form -->     
            <div class="panel-body">                                                        
              
                <div class="form-group">
                    <label >Usuário</label>
                    <input name="txtUsuarioPortal" type="text" class="form-control" id="txtUsuarioPortal" value="<%=strUsuarioPortal%>" size="30" maxlength="30" onBlur="submit()" style="width:200pt">
                    <button class="btn-u btn-u-sea" onClick="return abreConsulta('Usuario_con.asp')" type="button"><i class="fa fa-search"></i></button>  
                </div>
                
                <legend></legend>
                <!--#include file="../../includes/inc_botoes_cadastro.asp"-->

            	</div>
       	 	</div>
         	<!-- Fecha o Form -->  
      </div>
   	   
       <%IF strUsuarioPortal <> "" THEN%>
        <!--Table Bordered-->
        <div class="panel panel-grey margin-bottom-40">
            <div class="panel-heading">
                <h3 class="panel-title"><i class="fa fa-globe"></i> Lista de Empresas</h3>
            </div>
            <div class="panel-body">
                <table class="table table-bordered">
                    <thead>
                        <tr>
                          <th width="3%" bgcolor="#95A5A6"><input name="chkTodos" type="checkbox" value="" onClick="return marcaTodos()"> </th>
                            <th width="8%" bgcolor="#95A5A6">Empresa</th>
                            <th width="21%" bgcolor="#95A5A6">Grupo</th>
                            <th width="63%" bgcolor="#95A5A6">Unidade/Empresa</th>
                            <th width="5%" bgcolor="#95A5A6">Gestor</th>
                      </tr>
                    </thead>
                    <%
                    
                sql = "SELECT SEG_EMPRESA.RAZAOSOCIAL, SEG_GRUPO.DESCRICAO as GRUPO, SEG_EMPRESA.COD_GRUPO, SEG_EMPRESA.CODIGO AS COD_EMPRESA"
                sql = sql & " FROM SEG_EMPRESA"
                sql = sql & " LEFT JOIN SEG_GRUPO ON SEG_GRUPO.CODIGO = SEG_EMPRESA.COD_GRUPO"
                sql = sql & " Order by SEG_GRUPO.DESCRICAO, SEG_EMPRESA.RAZAOSOCIAL"
                rs.open sql, cnn
                if rs.eof = false then
                    while not rs.eof
                    cont = cont + 1	
                    
                        cont = cont + 1	
                        strMarca 	= ""
                        sql = "SELECT CODIGO_SEG_USUARIOS_SISTEMA, NIVEL_PERMISSAO"
                        sql = sql & " FROM SEG_USUARIOS_EMPRESA"
                        sql = sql & " WHERE CODIGO_SEG_USUARIOS_SISTEMA = '" & strUsuarioPortal & "'"
                        sql = sql & " AND COD_EMPRESA = " & trim(rs("cod_empresa"))
                        RsAux.open sql, cnn
                        if RsAux.eof = false then
                            strMarca = "checked"
                            
                            if isnull(RsAux("NIVEL_PERMISSAO")) then
                                strMarcaPermissao = ""
                            else
                                strMarcaPermissao = "checked"
                            end if
                        else
                            strMarcaPermissao = ""
                        end if
                        RsAux.close
                       %>
                    <tbody>
                        <tr>
                            <td><input name="chkEmp"  type="checkbox" value="<%=rs("cod_empresa")%>" <%=strMarca%>></td>
                            <td><%=trim(rs("cod_empresa"))%></td>
                            <td><%=trim(rs("grupo"))%></td>
                            <td><%=trim(rs("RAZAOSOCIAL"))%></td>
                            <td><input name="chkNivelPermissao_<%=trim(rs("cod_empresa"))%>"  type="checkbox" value="A" <%=strMarcaPermissao%>></tr>
                    </tbody>
                    <%				
                        rs.movenext
                        wend
                    end if
                    rs.close
                %>
                </table>
                <legend></legend>
                <!--#include file="../../includes/inc_botoes_cadastro.asp"-->
            </div>                      
        </div>
        <%end if%>
        <!--End Table Bordered-->	
        <!-- Fecha o Painel do Formulario -->        
    </div>
     </form>
    <!--/container-->		
    <script>
	function salvar(acao){
		
			var intContMarcado=0;
			var frm = document.getElementById("frm");
	
			if (frm.txtUsuarioPortal.value == "") {
				alert("O usuário deve ser informado!");
				frm.txtUsuarioPortal.focus();
				return false;
			} 
			
			frm.action="UsuarioEmpresa_cod.asp?acao=" + acao;
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
		
		function abreConsulta(caminho){
			window.open(caminho,"abreConsulta","top=5,left=5,height=600,width=1000,menubar=no,toolbar=no,scrollbars=yes,status=yes");
		}	
	</script>
    <!--=== End Content Part ===-->
   	<!--#include file="../RodapeModulo.asp"-->
	<!--#include file="../jsModulo.asp"-->
</body>
</html> 