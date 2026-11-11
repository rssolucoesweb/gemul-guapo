<!--#include file="../ConfigModulo.asp"-->
<!--#include file="../../includes/inc_cnn.asp"-->
<script type="text/javascript" src="js/ajaxutil.js"> </script>
<script type="text/javascript" src="js/hashTable.js"> </script>
<script type="text/javascript" src="js/Autores.js"></script>

        <!--=== Breadcrumbs ===-->
    <div class="breadcrumbs">
        <div class="container">
            <h1 class="pull-left">Modulo Biblioteca</h1>
            <ul class="pull-right breadcrumb">
                <li>Consulta Autores</li>
                <li class="active"><%=session("CodEmpresa")%> - <%=session("EmpresaWeb")%></li>
            </ul>
        </div><!--/container-->
    </div><!--/breadcrumbs-->
    <!--=== End Breadcrumbs ===-->
	<%
        intCodPublicacao		= Trim(Request.form("CodPublicacao"))
        strtAutores				= Trim(Request.form("txtAutores"))
        strMostraBotaoVincular	= "S"
        
        if intCodAutor = "" then intCodAutor = 0
    %>
    <!--=== Content Part ===-->
    <div class="container content">		
    
      <!-- Grey Panel -->            
      <div class="panel panel-grey">
        <div class="panel-heading">
        	<h3 class="panel-title"><i class="fa fa-tasks"></i>Consulta Autores </h3>
        </div>
        <!-- Inicia o Painel do Formulario -->     
        <div class="panel-body">
             <!-- Inicia o Form -->     
            <div class="panel-body">                                                        
                <form id="frm" class="margin-bottom-10" method="post">
                    <div class="form-group">
                        <label for="exampleInputEmail1">Autores</label>
                         <input name="txtAutores" type="text" class="form-control" id="txtAutores" value="<%=strtAutores%>" size="80" maxlength="100">
                    </div>
                    
                    <div class="form-group" align="right"> 
                         <input type="button" name="cmdIncluir" style="cursor:hand"  value="Consultar Vinculo Virtual"  class="btn btn-u float-shadow" onclick="LerRegistro()">
                    </div>
                    
                    <legend></legend>
                     <!--#include file="../../includes/inc_botoes_consulta1.asp"-->
                </form>
            	</div>
       	 	</div>
         	<!-- Fecha o Form -->  
      </div>
	   <div id="divRetorno"></div>
       <!-- Fecha o Painel do Formulario -->        
    </div>
    <!--/container-->		
	<script>
    
        var ht = new Hashtable();
        
        function AdicionaRegistro(obj, nome)
        {		
            if (obj.checked)
            {
                //alert("Registro selecionado com sucesso!");
                ht.put(obj.value, nome);
            }
            else
            {
                //alert("Registro removido com sucesso!");
                ht.remove(obj.value);
            }
        }	
                
        function resultadoConsulta(){
        
            if (parseInt(ht.size()) == 0) 
            {
                alert("Selecione pelo menos um Autor!");
            }
            else{
                window.opener.frm.txtCodAutor.value = ht.keys();
                window.opener.frm.txtDescAutor.value = ht.values();
                window.close();	
            }
        }	
        
        function Consulta(){
            
            var frm = document.getElementById("frm");
            
            if (frm.txtAutores.value==""){
                alert("O Nome do Autor deve ser informado.");
                frm.txtAutores.focus();
                return false;
            }	
            Pesquisar()
        }
        
        function LerRegistro(){
        
            if (parseInt(ht.size()) == 0) 
            {
                alert("Nenhum Registro foi Selecionado!");
            }
            else{
                alert(ht.values());
            }
        }	
    </script>	
    <!--#include file="../jsModulo.asp"-->
</body>
</html> 