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
        paginaOrigem			= Trim(Request("paginaOrigem"))
        strTipo					= Trim(Request.QueryString("Tipo"))
        strCPF	 				= Trim(Request("txtcpf"))
        strNome 				= Trim(Request("txtAluno"))
        intCodFuncional			= Trim(Request("txtCodigoFuncional"))
        strMostraAtivos			= Trim(Request.Form("MostraAtivos"))
        strMostraOutrasUnidades	= Trim(Request.Form("MostraOutrasUnidades"))
        intCodformanomeacao		= Trim(Request.Form("cmbFormaNomeacao"))
        intCodCategoria			= Trim(Request.Form("cmbCategoria"))
		strPagina				= "ColaboradorUE_con.asp"
    %>
    <!--=== Content Part ===-->
    <form method="POST" id="frm" action="#">
    <input name="paginaOrigem" type="hidden" id="paginaOrigem" value="<%=paginaOrigem%>">
    <div class="container content">	
    
      <!-- Grey Panel -->            
      <div class="panel panel-grey">
        <div class="panel-heading">
        	<h3 class="panel-title"><i class="fa fa-tasks"></i>Consulta de Funcionários da Unidade Ensino</h3>
        </div>
        
        <!-- Inicia o Painel do Formulario -->     
        <div class="panel-body">
             <!-- Inicia o Form -->     
            <div class="panel-body">    
                                                             
               		
                    <div class="form-group">
                        <label for="inputEmail1" class="col-lg-2 control-label">CPF</label>
                        <div class="col-lg-10">
                          <input name="txtcpf" type="text" class="form-control" id="txtcpf" size="15" maxlength="15" value="<%=strCPF%>"  onKeyPress="return formataCampo(this, 5, 15)">
                        </div>
                    </div>
                    
                    <div class="form-group">
                        <label for="inputEmail1" class="col-lg-2 control-label">Matr&iacute;cula Funcional</label>
                        <div class="col-lg-10">
                           <input name="txtCodigoFuncional" type="text" class="form-control" id="txtCodigoFuncional" size="15" maxlength="20" value="<%=intCodFuncional%>"  onKeyPress="return formataCampo(this, 2, 10)">
                        </div>
                    </div>
                    
                    <div class="form-group">
                        <label for="inputEmail1" class="col-lg-2 control-label">Nome do Colaborador</label>
                        <div class="col-lg-10">
                          <input name="txtAluno" type="text" class="form-control" id="txtAluno" size="50" maxlength="50" value="<%=strNome%>" />
                        </div>
                    </div>
                    
                    <div class="form-group">
                        <label for="inputEmail1" class="col-lg-2 control-label">Filtrar Ativos ?</label>
                        <div class="col-lg-10">
                           <input type="checkbox" name="MostraOutrasUnidades" value="S" onclick="this.submit()">
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
                          <th width="16%" bgcolor="#95A5A6">Categoria</th>
                          <th width="24%" bgcolor="#95A5A6">Unidade</th>
        		<% if Session("NivelPermissao") = "A" and strCompartilharDados = "S" then %>
                            	<th width="14%" bgcolor="#95A5A6">Situação</th>
                      <% end if %>	
                            <th width="3%" bgcolor="#95A5A6" align="center"><div align="center">Ação</div></th>
                </tr>
                    </thead>
 					<%
		
		
			cont = 0
			sql = " SELECT SRH_COLABORADOR.codigo, SRH_COLABORADOR.CodFuncional, SRH_CATEGORIA.Desc_Categoria, SRH_COLABORADOR.cpf, SRH_COLABORADOR.nome, SRH_COLABORADOR.situacao, "
			sql = sql & " SRH_COLABORADOR.FoneResidencial, SRH_COLABORADOR.Cidade, SEG_EMPRESA.RAZAOSOCIAL"
			sql = sql & " FROM SRH_COLABORADOR"
		    sql = sql & " left join SEG_EMPRESA ON SEG_EMPRESA.CODIGO = SRH_COLABORADOR.CodLotacao "
			sql = sql & " left join SRH_CATEGORIA ON SRH_CATEGORIA.Cod_Categoria = SRH_COLABORADOR.CodCategoria "
			sql = sql & " left join SRH_FUNCAOCOLABORADOR f on f.Cod_Funcao = SRH_COLABORADOR.codFuncao "
			sql = sql & " Where SRH_COLABORADOR.CodLotacao = " & session("codEmpresa")
			
			if strCPF <> "" then
				sql = sql & " And SRH_COLABORADOR.cpf = '" & trim(strCPF) & "'"
			end if
			
			if strNome <> "" then
				sql = sql & " And SRH_COLABORADOR.nome LIke '%" & strNome & "%' COLLATE SQL_Latin1_General_CP1_CI_AI "
				'sql = sql & " And SUBSTRING(SRH_COLABORADOR.nome,1,LEN('" & trim(strNome) & "')) =  '" & trim(strNome) & "'"
			end if
			
			if intCodFuncional <> "" then
				sql = sql & " And SRH_COLABORADOR.CodFuncional = " & intCodFuncional
			end if
			
			if strMostraAtivos = "S" then
			   sql = sql & " And SRH_COLABORADOR.Situacao = 'A'"
			end if  
			sql = sql & " Order by SRH_COLABORADOR.Nome"
			'response.write sql
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
					%>
                    <tbody>
                        <tr>
                            <td><%=trim(rs("CodFuncional"))%></td>
                            <td><%=trim(rs("NOME"))%></td>
                           	<td><%=trim(rs("Desc_Categoria"))%></td>
                            <td><%=trim(rs("RAZAOSOCIAL"))%></td>
                            <% if Session("NivelPermissao") = "A" and strCompartilharDados = "S" then %>
                            	<td><%=situacao%></td>
                          <% end if %>
                            <td><button class="btn-u btn-u-sea" onclick="resultadoConsulta('<%=rs("Codigo")%>','<%=rs("NOME")%>','<%=paginaOrigem%>')" type="button"><i class="fa fa-file-text-o"></i></button> 
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
     function resultadoConsulta(intCodigo, strNome, paginaOrigem){
        window.opener.document.getElementById('txtCarregado').value = "";
		window.opener.document.getElementById('frm').action="colaboradorUE_cad.asp";
        window.opener.document.getElementById('txtCodFuncionario').value = intCodigo;
        window.opener.document.getElementById('txtNomeFuncionario').value =  strNome; 
        window.opener.document.getElementById('frm').submit();
        window.close();
        
     }
    </script> 
<!--#include file="../jsModulo.asp"-->
</body>
</html> 