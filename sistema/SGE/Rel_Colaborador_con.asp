<!--#include file="../ConfigModulo.asp"-->
    <!--#include file="../../includes/inc_cnn.asp"-->
	<!--#include file="../menuModulos.asp"-->  
    <!--#include file="../includes/inc_sqlCodigoEmpresaUsuario.asp"-->
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
		strPaginaTitulo 		= "Rel_Colaborador_con.asp"
		pagina					= "Rel_Colaborador_con.asp"
		strNome			    	= Trim(Request.Form("txtNome"))
		intCodEmpresaUsuario    = request.Form("cmdEmpresaUsuario")
	%>
    <!--=== Content Part ===-->
  
   
    <div class="container content">		
     <form method="post" id="frm" action="#">
     <input  name="txtEmpresasDoGrupo" type="hidden" class="text" id="txtEmpresasDoGrupo"  value="<%=intEmpresasDoGrupo%>" size="70" maxlength="100">
      <!-- Grey Panel -->            
      <div class="panel panel-grey">
        <div class="panel-heading">
        	<h3 class="panel-title"><i class="fa fa-tasks"></i>Relação de Colaboradores</h3>
        </div>
        <!-- Inicia o Painel do Formulario -->     
        <div class="panel-body">
             <!-- Inicia o Form -->     
            <div class="panel-body">                                                        
                
                    <div class="form-group">
                        <label class="form-label">Buscar pelo Nome</label>
                         <input name="txtNome" type="text" class="form-control" id="txtNome" style="width:350pt" value="<%=strNome%>" size="80" maxlength="100" onBlur="submit()"  >
                    </div>

                    <div class="form-group">
                        <label class="form-label">Unidade</label>
                         <!--#include file="../includes/inc_cmdEmpresaUsuario.asp"-->
                    </div>

                    <legend></legend>
                    <!--#include file="../../includes/inc_botoes_geraRelatorio.asp"-->
               
            	</div>
       	 	</div>
         	<!-- Fecha o Form -->  
      </div>
   	   
       <!--Table Bordered-->
                <div class="panel panel-grey margin-bottom-40">
                    <div class="panel-heading">
                        <h3 class="panel-title"><i class="fa fa-globe"></i> Lista Colaboradores</h3>
                    </div>
                    <div class="panel-body">
                        <table class="table table-bordered">
                            <thead>
                                <tr>
                                  <th width="3%" bgcolor="#95A5A6"><input name="chkTodos" type="checkbox" <%=strAbilita%> value="" onClick="return marcaTodos()"></th>
                                    <th width="8%" bgcolor="#95A5A6">C&oacute;digo Func.</th>
                                    <th width="27%" bgcolor="#95A5A6">Nome</th>
                                    <th width="19%" bgcolor="#95A5A6">Local</th>
                                    <th width="23%" bgcolor="#95A5A6">Situa&ccedil;&atilde;o</th>
                                </tr>
                            </thead>
                            <%
							 if trim(strNome) <> "" then
							
								sql = " SELECT SRH_COLABORADOR.Cod_empresa, SRH_COLABORADOR.CodFuncional, SRH_COLABORADOR.CODIGO, SRH_COLABORADOR.NOME, SRH_COLABORADOR.SITUACAO, SEG_EMPRESA.RAZAOSOCIAL "
								sql = sql & " FROM SRH_COLABORADOR "
								sql = sql & " INNER JOIN SEG_EMPRESA ON SEG_EMPRESA.CODIGO = SRH_COLABORADOR.COD_EMPRESA " 
								sql = sql & " WHERE 1=1"
								
								if intCodEmpresaUsuario <> "0" and intCodEmpresaUsuario <> "" then
								   sql = sql & " And SRH_COLABORADOR.Cod_empresa in (" & intCodEmpresaUsuario & ")"
								else
								   sql = sql & " And SRH_COLABORADOR.Cod_empresa in (" & intEmpresasDoGrupo & ")"
								end if   
								
								if strNome <> ""  then 
								   sql = sql & " and SUBSTRING(NOME,1," & LEN(TRIM(strNome)) & ")  = '" & TRIM(strNome) & "'"
								end if			
								
								sql = sql & " Order By NOME"

								rs.open sql, cnn
								if rs.eof = false then
							
								while not rs.eof
								
									strCodigo        = rs("CODIGO")
									
									if trim(rs("SITUACAO")) = "A" then
										strSituacao = "Ativo"
									else
										strSituacao = "Inativo"
									end if

								%>
								<tbody>
									<tr>
										<td><input type="checkbox" id="chkFunc" name="chkFunc" <%=strDesabilitaAluno%> value="<%=rs("CODIGO")%>"></td>
										<td><%=rs("CodFuncional")%></td>
										<td><%=rs("NOME")%></td>
                                        <td><%=rs("RAZAOSOCIAL")%></td>
                                        <td><%=strSituacao%></td>
  								</tr>
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
        </form>   
    </div>
  

    <!--/container-->		
<script>
	
	function marcaTodos(){
	
	   var frm = document.getElementById("frm");
	   
	  if(frm.chkTodos.checked == true){ 
	
		  if(!confirm("Deseja selecionar todos os registros?")){
				return false;    
		  }
		  for (var i = 0; i < frm.elements.length; i++) {
					//verifica todos os checkbox
					if (frm.elements[i].type == "checkbox"){				
						frm.elements[i].checked = true;				
					}
		  }
	  }else{
	  
		 if(!confirm("Deseja desmarcar todos os registros selecionados?")){
				return false;    
		  }
		  for (var i = 0; i < frm.elements.length; i++) {
					//verifica todos os checkbox
					if (frm.elements[i].type == "checkbox"){				
						frm.elements[i].checked = false;				
					}
		  }
	  }
	  
	  return true;
	
	}

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
		frm.action = "Rel_Colaborador_rel.asp";
		frm.submit();
		return true;	
	}	</script>

   <!--=== End Content Part ===-->
   	<!--#include file="../RodapeModulo.asp"-->
	<!--#include file="../jsModulo.asp"-->
</body>
</html> 