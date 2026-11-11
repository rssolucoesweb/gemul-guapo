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
                <li>Consulta de Funcionários </li>
                <li class="active"><%=session("CodEmpresa")%> - <%=session("EmpresaWeb")%></li>
            </ul>
        </div><!--/container-->
    </div><!--/breadcrumbs-->
    <!--=== End Breadcrumbs ===-->
	<%
        strCPF	 				= Trim(Request("txtcpf"))
        strNome 				= Trim(Request("txtNome"))
        intCodFuncional			= Trim(Request("txtCodigoFuncional"))
        strMostraAtivos			= Trim(Request.Form("MostraAtivos"))
        strMostraOutrasUnidades	= Trim(Request.Form("MostraOutrasUnidades"))
        strMostraAtivos = "S"
    
    %>

    <!--=== Content Part ===-->
	<form method="POST" id="frm" action="#">
    <div class="container content">	
    
      <!-- Grey Panel -->            
      <div class="panel panel-grey">
        <div class="panel-heading">
        	<h3 class="panel-title"><i class="fa fa-tasks"></i>Consulta de Funcion&aacute;rios - Substituto</h3>
        </div>
        
        <!-- Inicia o Painel do Formulario -->     
        <div class="panel-body">
             <!-- Inicia o Form -->     
            <div class="panel-body">    
                                                             
               		
                    <div class="form-group">
                        <label for="inputEmail1" class="col-lg-2 control-label">CPF:</label>
                        <div class="col-lg-10">
                        	<input name="txtcpf" type="text" class="form-control" id="txtcpf" size="15" maxlength="70" value="<%=strCPF%>" onKeyPress="return formataCampo(this,5,14)" onBlur="return validaCPFColaborador(this)">
                        </div>
                    </div>
                    
                    <div class="form-group">
                        <label for="inputEmail1" class="col-lg-2 control-label">C&oacute;digo Funcional:</label>
                        <div class="col-lg-10">
                           <input name="txtCodigoFuncional" type="text" class="form-control" id="txtCodigoFuncional" size="12" maxlength="8" value="<%=intCodFuncional%>"  onKeyPress="return formataCampo(this, 2, 8)">
                        </div>
                    </div>
                    
                    <div class="form-group">
                        <label for="inputEmail1" class="col-lg-2 control-label">Nome do Colaborador:</label>
                        <div class="col-lg-10">
                           <input name="txtnome" type="text" class="form-control" id="txtnome" size="50" maxlength="70" value="<%=strnome%>">
                           
                        </div>
                    </div>
                    
                     <%if Session("NivelPermissao") = "A" and  strCompartilharDados = "S" then %>
                     <div class="form-group">
                        <label for="inputEmail1" class="col-lg-2 control-label">Buscar Dados de Outras Unidades?</label>
                        <div class="col-lg-10">
                           <input type="checkbox" name="MostraOutrasUnidades" value="S" onClick="this.submit()">
                        </div>
                    </div>
                    <% end if %>	  
          			
                     <div class="form-group">
                        <label for="inputEmail1" class="col-lg-2 control-label">Filtrar Ativos?</label>
                        <div class="col-lg-10">
                           <input checked type="checkbox" name="MostraAtivos" value="S" onClick="this.submit()">
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
                <h3 class="panel-title"><i class="fa fa-globe"></i> Lista de Funcionários</h3>
            </div>
            <div class="panel-body">
                <table width="98%" class="table table-bordered">
                    <thead>
                    <tr>
                    <th width="12%" bgcolor="#95A5A6">Código Funcional</th>
                    <th width="31%" bgcolor="#95A5A6">Nome do Colaborador </th>
                    <th width="16%" bgcolor="#95A5A6">Unidade</th>
                    <th width="14%" bgcolor="#95A5A6">Situação</th>
                    <th width="3%" bgcolor="#95A5A6" align="center"><div align="center">Ação</div></th>
                    </tr>
                    </thead>
 					<%
					cont = 0
					sql = " SELECT SRH_COLABORADOR.codigo, SRH_COLABORADOR.CodLotacao, SRH_COLABORADOR.CodFuncional, SRH_COLABORADOR.cpf, SRH_COLABORADOR.nome, SRH_COLABORADOR.situacao, "
					sql = sql & " SRH_COLABORADOR.FoneResidencial, SRH_COLABORADOR.Cidade, SEG_EMPRESA.RAZAOSOCIAL"
					sql = sql & " FROM SRH_COLABORADOR"
					
					if strCompartilharDados = "S" then 
					   sql = sql & " inner join SEG_EMPRESA ON SEG_EMPRESA.CODIGO = SRH_COLABORADOR.CodLotacao "
					else   
					   sql = sql & " inner join SEG_EMPRESA ON SEG_EMPRESA.CODIGO = SRH_COLABORADOR.Cod_empresa "
					end if   
					
					if Session("NivelPermissao") <> "A" then
						sql = sql & " Where SRH_COLABORADOR.CodLotacao = " & session("codEmpresa")
					else
						if strCompartilharDados = "S" then 
							if strMostraOutrasUnidades = "S" then
								sql = sql & " WHERE SEG_EMPRESA.Cod_grupo = " & Session("CodGrupo")	
							else   
								sql = sql & " WHERE SRH_COLABORADOR.CodLotacao = " & Session("CodEmpresa")
							end if 
						else
							sql = sql & " WHERE SRH_COLABORADOR.Cod_empresa = " & Session("CodEmpresa")	  
						end if	
					end if
					
					
					if strCPF <> "" then
						sql = sql & " And SRH_COLABORADOR.cpf = '" & trim(strCPF) & "'"
					end if
					
					if strNome <> "" then
						'sql = sql & " And SRH_COLABORADOR.nome LIke '%" & strNome & "%' COLLATE SQL_Latin1_General_CP1_CI_AI "
						sql = sql & " And SUBSTRING(SRH_COLABORADOR.nome,1,LEN('" & trim(strNome) & "')) =  '" & trim(strNome) & "'"
					end if
					
					if intCodFuncional <> "" then
						sql = sql & " And SRH_COLABORADOR.CodFuncional = " & intCodFuncional
					end if
					
					if strMostraAtivos = "S" then
					   sql = sql & " And SRH_COLABORADOR.Situacao = 'A'"
					end if  
					sql = sql & " And SRH_COLABORADOR.total_aulas  > 0"
					sql = sql & " Order by SRH_COLABORADOR.Nome"
		
					rs.open sql, cnn
					if rs.eof = false then					
						while not rs.eof
					
						   situacao = ""			
						   if trim(rs("situacao")) = "A"  then
							  situacao = "ATIVO"
						   end if	  
						   if trim(rs("situacao")) = "I" then
							  situacao = "INATIVO"
						   end if	
			
						
						cont = cont + 1		
 					%>
                    <tbody>
                        <tr>
                            <td><%=trim(rs("CodFuncional"))%></td>
                            <td><%=trim(rs("NOME"))%></td>
                           	<td><%=trim(rs("RAZAOSOCIAL"))%></td>
                            <% if Session("NivelPermissao") = "A" and strCompartilharDados = "S" then %>
                            	<td><%=situacao%></td>
                          <% end if %>
                            <td><button class="btn-u btn-u-sea" onClick="resultadoConsulta('<%=rs("CodLotacao")%>','<%=rs("Codigo")%>','<%=rs("NOME")%>')" type="button"><i class="fa fa-file-text-o"></i></button> 
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
         	<!-- Fecha o Form -->  
      </div>
	  <div id="divRetorno"></div>
       <!-- Fecha o Painel do Formulario -->        
    </div>
    </form>
    <!--/container-->		
	<script>
        function resultadoConsulta(intCodEmpresa, intCodigo, strNome){
            window.opener.document.getElementById('txtCodEmpresaSubstituto').value = intCodEmpresa;
            window.opener.document.getElementById('txtCodColaboradorSubstituto').value = intCodigo;
            window.opener.document.getElementById('txtNomeColaboradorSubstituto').value =  strNome; 
            window.opener.document.getElementById('frm').submit();
            window.close();
        }
        
    </script>
<!--#include file="../jsModulo.asp"-->
</body>
</html> 