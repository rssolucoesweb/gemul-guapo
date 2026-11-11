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
        strExecutarSubmitRotaTransporteescolar = "SIM"
        
        intCodRota = Trim(Request.Form("cmbRota"))
        
        if intCodRota = "" then intCodRota = "0"
        
        strDesabilitaIncluir = "" ' Desabilita o botão Incluir
        strDesabilitaAlterar = "disabled" ' Desabilita o botão Alterar
        strDesabilitaExcluir = "disabled" ' Desabilita o botão Excluir
        strDesabilitaLimpar  = "" ' Habilita o Botão Limpar
    %>
    <!--=== Content Part ===-->
    <div class="container content">		
    
      <!-- Grey Panel -->            
      <div class="panel panel-grey">
        <div class="panel-heading">
        	<h3 class="panel-title"><i class="fa fa-tasks"></i>Vincula Rata a Empresa</h3>
        </div>
        <!-- Inicia o Painel do Formulario -->     
        <div class="panel-body">
             <!-- Inicia o Form -->     
            <div class="panel-body">                                                        
                 <form method="post" id="frm">
                    <label>Rota</label>
                    <div class="form-group">
                      <!--#include file="../includes/inc_cmdRota.asp"-->
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
                        <h3 class="panel-title"><i class="fa fa-globe"></i> Lista de Sistemas</h3>
                    </div>
                    <div class="panel-body">
                        <table class="table table-bordered">
                            <thead>
                                <tr>
                                    <th width="3%" bgcolor="#95A5A6">#</th>
                                  <th width="10%" bgcolor="#95A5A6">Empresa</th>
                                  <th width="13%" bgcolor="#95A5A6">Grupo</th>
                                  <th width="74%" bgcolor="#95A5A6">Unidade/Empresa</th>
                              </tr>
                            </thead>
                            
                             <%IF intCodRota<>"0" THEN%>
                            <%
							sql = "SELECT SEG_EMPRESA.RAZAOSOCIAL, SEG_GRUPO.DESCRICAO as GRUPO, SEG_EMPRESA.COD_GRUPO, SEG_EMPRESA.CODIGO AS COD_EMPRESA"
							sql = sql & " FROM SEG_EMPRESA"
							sql = sql & " INNER JOIN SEG_GRUPO ON SEG_GRUPO.CODIGO = SEG_EMPRESA.COD_GRUPO"
							sql = sql & " WHERE SEG_EMPRESA.COD_GRUPO = " & Session("CodGrupo") 
							sql = sql & " Order by SEG_GRUPO.DESCRICAO, SEG_EMPRESA.RAZAOSOCIAL"
							rs.open sql, cnn
							cont=0
							if rs.eof = false then
							
							while not rs.eof
								
								cont = cont + 1	
								strMarca 	= ""
								
								sql = "SELECT CodRota, CodEmpresa"
								sql = sql & " FROM SCA_ROTA_VICULA_EMPRESA"
								sql = sql & " WHERE CodRota = " & intCodRota
								sql = sql & " AND CodEmpresa = " & trim(rs("cod_empresa"))
								RsAux.open sql, cnn
								if RsAux.eof = false then
									strMarca = "checked"
									
									if isnull(RsAux("CodRota")) then
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
                                    <td><input name="chkEmpresa"  type="checkbox" value="<%=rs("cod_empresa")%>" <%=strMarca%>></td>
                                    <td><%=trim(rs("cod_empresa"))%></td>
                                    <td><%=trim(rs("grupo"))%></td>
                                    <td><%=trim(rs("RAZAOSOCIAL"))%></td>
                            </tbody>
                            <%				
								rs.movenext
								wend
							end if
							rs.close
							
						end if
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
            var form = window.document.forms[0];
            var intContMarcado=0;
            
            if (frm.cmbRota.value=="") {
                alert("A Rota deve ser informada.");
                frm.cmbRota.focus();
                return false
            }
                        
            //*****verifica se um aluno foi selecionado
            intContMarcado=0;
            for (var i = 0; i < form.elements.length; i++) {
                //verifica todos os checkbox
                if (form.elements[i].type == "checkbox"){
                    if (form.elements[i].name == "chkEmpresa"){
                        //verifica se o checkbox está marcado
                        if (form.elements[i].checked){
                            intContMarcado = intContMarcado + 1;
                        }
                    }
                }
            }	
            
            if (intContMarcado==0){
                alert("Pelo menos uma Empresa deve ser informada!");
                return false;
            }
                
            frm.action= "RotaEmpresa_cod.asp?acao=" + acao;
            frm.submit();
            return true;
    }
    </script>
    <!--=== End Content Part ===-->
   	<!--#include file="../RodapeModulo.asp"-->
	<!--#include file="../jsModulo.asp"-->
</body>
</html> 