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
	strNotificacao1		= Trim(Request.Form("txtNotificacao1"))
	strNotificacao2		= Trim(Request.Form("txtNotificacao2"))

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
        	<h3 class="panel-title"><i class="fa fa-tasks"></i>Vincula Avisos para Unidade Escolar</h3>
        </div>
        <!-- Inicia o Painel do Formulario -->     
        <div class="panel-body">
             <!-- Inicia o Form -->     
            <div class="panel-body">                                                        
                
                	<input name="txtCodigo" type="hidden" class="text" id="txtCodigo" value="<%=intCodigo%>" size="10">
                    <div class="form-group">
                        <label class="form-label">Aviso n.01</label>
                         <input name="txtNotificacao1" type="text" class="form-control" id="txtNotificacao1" style="width:350pt" value="<%=strNotificacao1%>" size="80" maxlength="100">
                    </div>
                    
                    <div class="form-group">
                        <label class="form-label">Aviso n.02</label>
                         <input name="txtNotificacao2" type="text" class="form-control" id="txtNotificacao2" style="width:350pt" value="<%=strNotificacao2%>" size="80" maxlength="100">
                    </div>
                    <legend></legend>
                    <!--#include file="../../includes/inc_botoes_cadastro.asp"-->
               
            	</div>
       	 	</div>
         	<!-- Fecha o Form -->  
      </div>
   	   
       <!--Table Bordered-->
                <div class="panel panel-grey margin-bottom-40">
                    <div class="panel-heading">
                        <h3 class="panel-title"><i class="fa fa-globe"></i> Lista de Empresas</h3>
                    </div>
                    <div class="panel-body">
                        <table class="table table-bordered">
                            <thead>
                                <tr>
                                  <th width="3%" bgcolor="#95A5A6"><input name="chkTodos" type="checkbox" value="" onClick="return marcaTodos()"></th>
                                    <th width="13%" bgcolor="#95A5A6">Empresa</th>
                                    <th width="27%" bgcolor="#95A5A6">Grupo</th>
                                  <th width="57%" bgcolor="#95A5A6">UnidadeEscolar</th>
                              </tr>
                            </thead>
                            <%
							
							sql = "SELECT SEG_EMPRESA.RAZAOSOCIAL, SEG_GRUPO.DESCRICAO as GRUPO, SEG_EMPRESA.COD_GRUPO, SEG_EMPRESA.CODIGO AS COD_EMPRESA"
							sql = sql & " FROM SEG_EMPRESA"
							sql = sql & " LEFT JOIN SEG_GRUPO ON SEG_GRUPO.CODIGO = SEG_EMPRESA.COD_GRUPO"
							sql = sql & " Order by SEG_GRUPO.DESCRICAO, SEG_EMPRESA.RAZAOSOCIAL"
							rs.open sql, cnn
							cont=0
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
								end if
								RsAux.close
							
							%>
                            <tbody>
                                <tr>
                                    <td><input name="chkEmp"  type="checkbox" value="<%=rs("cod_empresa")%>" <%=strMarca%>></td>
                                    <td><%=trim(rs("cod_empresa"))%></td>
                                    <td><%=trim(rs("grupo"))%></td>
                                    <td><%=trim(rs("RAZAOSOCIAL"))%></tr>
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
     </form>
    <!--/container-->		
    <script>
		function salvar(acao){
			var intContMarcado=0;
			var frm = document.getElementById("frm");
			
			if (frm.txtNotificacao1.value == "") {
				alert("A Notificação 1 deve ser informada!");
				frm.txtNotificacao1.focus();
				return false;
			} 

			frm.action="AvisosEmpresa_cod.asp?acao=" + acao;
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