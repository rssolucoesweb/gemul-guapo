<!--#include file="../ConfigModulo.asp"-->
<!--#include file="../../includes/inc_verificaSession.asp"-->
<!--#include file="../../includes/inc_cnn.asp"-->
<!--#include file="../../includes/inc_formataData.asp"--> 
<!--#include file="../../includes/inc_replaceRequest.asp"-->
<!--#include file="../includes/inc_CompartilharDadosCadastrais.asp"-->
   <!--=== Breadcrumbs ===-->
	<div class="breadcrumbs">
        <div class="container">
            <h1 class="pull-left">Modulo RH </h1>
            <ul class="pull-right breadcrumb">
                <li>Consulta de Usuários </li>
                <li class="active"><%=session("CodEmpresa")%> - <%=session("EmpresaWeb")%></li>
            </ul>
        </div><!--/container-->
    </div><!--/breadcrumbs-->
    <!--=== End Breadcrumbs ===-->
	<%  
	strConsultar		= Trim(Request("strConsultar"))
  	strUsuario  = ReplaceRequest(trim(request.form("txtUsuario")))
	strNome		= ReplaceRequest(trim(request.form("txtNome")))
	intCodEmpresa = session("CodEmpresa")
	if intCodEmpresa = "" then intCodEmpresa = 0
	strExecutarSubmitEmpresa = "S"
	%>
        <!--=== Content Part ===-->
    <form method="POST" id="frm" action="#">
    <input name="strConsultar" type="hidden" value="S">
    <input name="paginaOrigem" type="hidden" id="paginaOrigem" value="<%=paginaOrigem%>">
    <div class="container content">	
    
      <!-- Grey Panel -->            
      <div class="panel panel-grey">
        <div class="panel-heading">
        	<h3 class="panel-title"><i class="fa fa-tasks"></i>Consulta de Usuários</h3>
        </div>
        
        <!-- Inicia o Painel do Formulario -->     
        <div class="panel-body">
             <!-- Inicia o Form -->     
            <div class="panel-body">    
                                                             
               		
                    <div class="form-group">
                        <label for="inputEmail1" class="col-lg-2 control-label">Usuário</label>
                        <div class="col-lg-10">
                           <input name="txtUsuario" type="text" id="txtUsuario" class="text" size="30" maxlength="50">
                        </div>
                    </div>
                    
                    <div class="form-group">
                        <label for="inputEmail1" class="col-lg-2 control-label">Nome</label>
                        <div class="col-lg-10">
                          <input name="txtNome" type="text" id="txtNome" class="text" size="50" maxlength="50">
                        </div>
                    </div>
                    
                    <legend></legend>
                     <!--#include file="../../includes/inc_botoes_consultaPopap.asp"-->
                
            	</div>
         </div>     
         
         </div>  
           
       <!--Table Bordered-->
        <div class="panel panel-grey margin-bottom-40">
            <div class="panel-heading">
                <h3 class="panel-title"><i class="fa fa-globe"></i> Lista de Usuários</h3>
            </div>
            <div class="panel-body">
                <table width="98%" class="table table-bordered">
              		<thead>
                        <tr>
                            <td width="16%" class="celula"><strong>Usu&aacute;rio</strong></td>
                            <td width="31%" class="celula"><strong>Nome Completo</strong></td>
                            <td width="8%" class="celula"><strong>Situação</strong></td>
                            <td width="8%" class="celula"><strong>Ação</strong></td>
                		</tr>
                    </thead>
                    <%
 					if strConsultar <> "" then
		
			sql = " SELECT Usua_Codg, Usua_Info_senha, Usua_Data_Ativacao, Usua_Stat, USUA_NOME_COMPLETO, SEG_EMPRESA.RAZAOSOCIAL" 
			sql = sql & " FROM SEG_USUARIOS_SISTEMA"
			sql = sql & " LEFT JOIN SEG_EMPRESA ON SEG_EMPRESA.CODIGO=SEG_USUARIOS_SISTEMA.COD_EMPRESA"
			sql = sql & " WHERE 1 = 1"
			sql = sql & " AND SEG_USUARIOS_SISTEMA.COD_EMPRESA = " & intCodEmpresa
			if strUsuario <> ""then
				sql = sql & " AND Usua_Codg LIKE '" &   strUsuario & "%'"
			end if 
			if strNome <> ""then
				sql = sql & " AND USUA_NOME_COMPLETO LIKE '" &   strNome & "%'"
			end if 
					
			sql = sql & " ORDER BY Usua_Codg"
			rs.open sql, cnn
			
			cont=0
			if rs.eof = false then
	
				while not rs.eof
				
				strStatus = trim(rs("Usua_Stat"))
				
				if strStatus = "A" then
					strStatus = "Ativo"
				elseif strStatus = "I" then
					strStatus = "Inativo"
				end if
				
				cont = cont + 1		
				%>
                    <tbody>
                        <tr>
                            <td height="21" class="celula"><%=trim(rs("Usua_Codg"))%></td>
                            <td class="celula"><%=rs("USUA_NOME_COMPLETO")%></td>
                            <td class="celula"><%=strStatus%></td>
                           
                            <td><button class="btn-u btn-u-sea" onclick="resultadoConsulta('<%=rs("Usua_Codg")%>')" type="button"><i class="fa fa-file-text-o"></i></button> 
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
        <%
		
		end if%>
        <!--End Table Bordered-->	
       <!-- Fecha o Painel do Formulario -->    
       	 	</div>
         	<!-- Fecha o Form -->  
      </div>
	  <div id="divRetorno"></div>
       <!-- Fecha o Painel do Formulario -->        
    </div>
    </form>
    <!--/container-->		
<script>
	function resultadoConsulta(strUsuario){
	
		var frm = document.getElementById("frm");
		
		window.opener.frm.txtUsuarioPortal.value=strUsuario;
		window.opener.frm.submit();
		window.close();
	}
</script><!--#include file="../jsModulo.asp"-->
</body>
</html> 



