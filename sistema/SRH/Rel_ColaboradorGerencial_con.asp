<!--#include file="../ConfigModulo.asp"-->
<!--#include file="../../includes/inc_cnn.asp"-->
<!--#include file="../../includes/inc_formatadata.asp"-->
<!--#include file="../menuModulos.asp"-->
<!--#include file="../includes/inc_sqlAlunoTurma.asp"-->
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
        strPaginaTitulo 		= "Rel_ColaboradorGerencial_con.asp"
        pagina					= "Rel_ColaboradorGerencial_con.asp"
        strNome			    	= Trim(Request.Form("txtNome"))
        intCodEmpresaUsuario    = request.Form("cmdEmpresaUsuario")
        
        if intCodEmpresaUsuario = "" then intCodEmpresaUsuario = "0"
    %>

    <!--=== Content Part ===-->
    <form method="post" id="frm" action="#">
    <div class="container content">		
    
      <!-- Grey Panel -->            
      <div class="panel panel-grey">
        <div class="panel-heading">
        	<h3 class="panel-title"><i class="fa fa-tasks"></i>Consultar Colaboradores</h3>
        </div>
        <!-- Inicia o Painel do Formulario -->     
        <div class="panel-body">
             <!-- Inicia o Form -->     
            <div class="panel-body">                                                        
			
					  <div class="form-group">
                    	<label for="inputEmail1" class="col-lg-2 control-label">Buscar pelo Nome</label>
                        <div class="col-lg-10">
                        	<input  name="txtNome" type="text" class="form-control" id="txtNome" onblur="submit()"  value="<%=strNome%>" size="70" maxlength="100">
                        </div>
               		 </div>
                     
                     <div class="form-group">
                    	<label for="inputEmail1" class="col-lg-2 control-label">Unidade</label>
                        <div class="col-lg-10">
                        	<!--#include file="../includes/inc_cmdEmpresaUsuario.asp"-->
                        </div>
               		 </div>
                     
                     <input  name="txtEmpresasDoGrupo" type="hidden" class="text" id="txtEmpresasDoGrupo"  value="<%=intEmpresasDoGrupo%>" size="70" maxlength="100">
                 
                    <legend></legend>
                    <!--#include file="../../includes/inc_botoes_geraRelatorio.asp"-->
                
            	</div>
       	 	</div>
         	<!-- Fecha o Form -->  
      </div>
      
       <!--Table Bordered-->
       <%if trim(strNome) <> "" or intCodEmpresaUsuario <> "0" then%>
        <div class="panel panel-grey margin-bottom-40">
            <div class="panel-heading">
                <h3 class="panel-title"><i class="fa fa-globe"></i> Lista de Colaboradores</h3>
            </div>
            <div class="panel-body">
                <table class="table table-bordered">
                    <thead>
                        <tr>
                          <th width="3%" bgcolor="#95A5A6"><input type="checkbox" name="chkTodos" onclick="return MarcaTodos(this.checked)"></th>
                          <th width="9%" bgcolor="#95A5A6">C&oacute;digo Func</th>
                          <th width="35%" bgcolor="#95A5A6">Nome</th>
                          <th width="42%" bgcolor="#95A5A6">Local</th>
                          <th width="11%" bgcolor="#95A5A6">Situa&ccedil;&atilde;o</th>
                      </tr>
                    </thead>
                     <tbody>
                    <%
                    cont =0

					sql = " SELECT SRH_COLABORADOR.Cod_empresa, SRH_COLABORADOR.CodFuncional, "
					sql = sql & " SRH_COLABORADOR.CODIGO, SRH_COLABORADOR.NOME, SRH_COLABORADOR.SITUACAO, SEG_EMPRESA.RAZAOSOCIAL , SRH_COLABORADOR.codLotacao"
					sql = sql & " FROM SRH_COLABORADOR "
					sql = sql & " INNER JOIN SEG_EMPRESA ON SEG_EMPRESA.CODIGO = SRH_COLABORADOR.codLotacao " 
					sql = sql & " WHERE 1=1"
				
					if intCodEmpresaUsuario <> "0" then
					   sql = sql & " And SRH_COLABORADOR.codLotacao in (" & intCodEmpresaUsuario & ")"
					end if   
					
					if strNome <> ""  then 
					   sql = sql & " and SUBSTRING(NOME,1," & LEN(TRIM(strNome)) & ")  = '" & TRIM(strNome) & "'"
					end if			
					
					sql = sql & " Order By NOME"

                    rs.open sql, cnn
                    if rs.eof = false then
                    
                    while not rs.eof
                        cont = cont + 1
						
						if trim(rs("SITUACAO")) = "A" then
							strSituacao = "Ativo"
						else
							strSituacao = "Inativo"
						end if
				    	%>
                        <tr>
                            <td><input type="checkbox" id="chkFunc" name="chkFunc" <%=strDesabilitaAluno%> value="<%=rs("CODIGO")%>"></td>
                            <td><%=rs("CodFuncional")%></td>
                            <td><%=rs("NOME")%></td>
                            <td><%=rs("RAZAOSOCIAL")%></td>
                            <td><%=strSituacao%></td>
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
    </form>
    <!--/container-->		
	<script>
        function gerar(){
        
            var frm = document.getElementById("frm");
            var form = window.document.forms[0];
            var intContMarcado=0;
    
            //*****verifica se um aluno foi selecionado
            intContMarcado=0;
            for (var i = 0; i < form.elements.length; i++) {
                //verifica todos os checkbox
                if (form.elements[i].type == "checkbox"){
                    if (form.elements[i].name == "chkFunc"){
                        //verifica se o checkbox está marcado
                        if (form.elements[i].checked){
                            intContMarcado = intContMarcado + 1;
                        }
                    }
                }
            }	
            if (intContMarcado==0){
                alert("Colaborador deve ser selecionado!");
                return false;
            }
            frm.action = "Rel_ColaboradorGerencial_rel.asp";
            frm.submit();
            return true;	
        }
    </script>

    <!--=== End Content Part ===-->
   	<!--#include file="../RodapeModulo.asp"-->
	<!--#include file="../jsModulo.asp"-->
</body>
</html> 