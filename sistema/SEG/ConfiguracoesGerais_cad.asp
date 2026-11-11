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
	strPagina		 				= "ConfiguracoesGerais_cad.asp"
	intCodigo	 					= Trim(Request.Form("txtCodigo"))
	strMesPrimeiroSemestre			= Trim(Request.Form("txtMesPrimeiroSemestre"))
	strMesPrimeiroSegundo			= Trim(Request.Form("txtMesPrimeiroSegundo"))
	strFinanceiro					= Trim(Request.Form("cmbFinanceiro"))
		
	if trim(intCodigo) <> "" then
	
		sql = "SELECT Codigo, cod_empresa, mes_encerra_primeiro_semestre, mes_encerra_segundo_semestre, checar_financeiro"
		sql = sql & " FROM SEG_CONFIGURACOESGERAIS"
		sql = sql & " where cod_empresa = " & Session("CodEmpresa")			
		sql = sql & " and codigo = " & intCodigo
		rs.open sql, cnn
		
		if rs.eof = false then
			
			intCodigo						= rs("Codigo")
			strMesPrimeiroSemestre			= rs("mes_encerra_primeiro_semestre")
			strMesPrimeiroSegundo			= rs("mes_encerra_segundo_semestre")
			strFinanceiro					= TRIM(rs("checar_financeiro"))
			
			strDesabilitaIncluir	= "disabled" 'Desabilita o botão Incluir
			strDesabilitaAlterar 	= "" 'Desabilita o botão Excluir
			strDesabilitaExcluir	= "disabled" 'Desabilita o botão Excluir

		end if 
		rs.close
	else
		strDesabilitaIncluir	= "" 'Desabilita o botão Incluir
		strDesabilitaAlterar 	= "disabled" 'Desabilita o botão Excluir
		strDesabilitaExcluir	= "disabled" 'Desabilita o botão Excluir
	end if 
	%>
     <!--=== Content Part ===-->
    <div class="container content">		
    
      <!-- Grey Panel -->            
      <div class="panel panel-grey">
        <div class="panel-heading">
        	<h3 class="panel-title"><i class="fa fa-tasks"></i>Configurações Gerais</h3>
        </div>
        <!-- Inicia o Painel do Formulario -->     
        <div class="panel-body">
             <!-- Inicia o Form -->     
            <div class="panel-body">                                                        
                <form id="frm" class="margin-bottom-10" method="post">
                	<input name="txtCodigo" type="hidden" class="text" id="txtCodigo" value="<%=intCodigo%>" size="10">
                    <div class="form-group">
                        <label class="form-label">Mês Encerra Primeiro Semestre </label>
                         <input name="txtMesPrimeiroSemestre" type="text" class="form-control" id="txtMesPrimeiroSemestre" value="<%=strMesPrimeiroSemestre%>" size="80" maxlength="100" style="width:130pt">
                    </div>
                   
                    <div class="form-group">
                        <label class="form-label">Mês Encerra Segundo Semestre </label>
                         <input name="txtMesPrimeiroSegundo" type="text" class="form-control" id="txtMesPrimeiroSegundo" value="<%=strMesPrimeiroSegundo%>" size="80" maxlength="100" style="width:130pt">
                    </div>
                    
                    <div class="form-group">
                        <label class="form-label">checar Financeiro</label>
                        <select name="cmbFinanceiro" class="form-control" id="cmbFinanceiro"  style="width:130pt">
                           <option value="0">Selecione...</option>
                           <option value="S" <%if strFinanceiro = "S" then response.Write("selected") %>>Sim</option>
                          <option value="N" <%if strFinanceiro = "N" then response.Write("selected") %>>Não</option>
                        </select>
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
                        <h3 class="panel-title"><i class="fa fa-globe"></i>Lista de Configurações Gerais</h3>
                    </div>
                    <div class="panel-body">
                        <table class="table table-bordered">
                            <thead>
                                <tr>
                                    <th width="5%" bgcolor="#95A5A6">C&oacute;digo</th>
                                    <th width="21%" bgcolor="#95A5A6">Mês Encerra Primeiro Semestre</th>
                                    <th width="29%" bgcolor="#95A5A6">Mês Encerra Segundo Semestre</th>
                                    <th width="36%" bgcolor="#95A5A6">Checar Financeiro</th>
                                  <th width="9%" bgcolor="#95A5A6" align="center"><div align="center">Ação</div></th>
                              </tr>
                            </thead>
                            <%
							sql = "SELECT Codigo, cod_empresa, mes_encerra_primeiro_semestre, mes_encerra_segundo_semestre, checar_financeiro"
							sql = sql & " FROM SEG_CONFIGURACOESGERAIS"
							sql = sql & " where cod_empresa = " & Session("CodEmpresa")			
							sql = sql & " Order by codigo"
							rs.open sql, cnn
							cont=0
							if rs.eof = false then
							
							while not rs.eof
							cont = cont + 1	
							
							strFinanceiro = trim(rs("checar_financeiro"))
					
							if strFinanceiro = "S" then
								strFinanceiro = "Sim"
							else
								strFinanceiro = "Não"
							end if
							%>
                            <tbody>
                                <tr>
                                    <td><%=rs("Codigo")%></td>
                                    <td><%=rs("mes_encerra_primeiro_semestre")%></td>
                                    <td ><%=rs("mes_encerra_segundo_semestre")%></td>
                                    <td ><%=strFinanceiro%></td>
                                    <td align="center" >
                                    <button class="btn-u btn-u-sea" onClick="resultadoConsulta(<%=trim(rs("Codigo"))%>)" type="button"><i class="fa fa-file-text-o"></i></button>  
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
    <!--/container-->		
    <script>
		function salvar(acao){
		
			var frm = document.getElementById("frm");
			
			if (frm.txtMesPrimeiroSemestre.value == "") {
				alert("O Primeiro mês do semestre deve ser informado!");
				frm.txtMesPrimeiroSemestre.focus();
				return false;
			}
			
			if (frm.txtMesPrimeiroSegundo.value == "") {
				alert("O Segundo mês do semestre deve ser informado!");
				frm.txtMesPrimeiroSegundo.focus();
				return false;
			}
			
			if (frm.cmbFinanceiro.value == "0") {
				alert("Checa Financeico deve ser informado!");
				frm.cmbFinanceiro.focus();
				return false;
			}
			
			frm.action="ConfiguracoesGerais_cod.asp?acao=" + acao;
			frm.submit();
			return true;
		}
	
		function resultadoConsulta(intCodigo){
			var frm = document.getElementById("frm");
			frm.txtCodigo.value=intCodigo;
			frm.submit();
		}
	</script>
    <!--=== End Content Part ===-->
   	<!--#include file="../RodapeModulo.asp"-->
	<!--#include file="../jsModulo.asp"-->
</body>
</html> 