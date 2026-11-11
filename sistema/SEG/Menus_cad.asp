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
	strPagina			= "Menus_cad.asp"
	intCodMenu			= Trim(Request("txtCodMenu"))
	strSiglaSistema 	= Trim(Request("cmbSistemas"))
	strSiglaModulo		= Trim(Request("cmbModulosSistema"))
	strDescMenu			= Trim(Request("txtDescMenu"))
	intOrdemMenu 		= Trim(Request("txtOrdemMenu"))
	strSituacao 		= Trim(Request("cmbSituacao"))
		
	if strSiglaSistema <> "" then
		
		sql = "SELECT Sist_Stat, Sist_Desc "
		sql = sql & " FROM SEG_SISTEMAS_INFORMATICA"
		sql = sql & " WHERE Sist_Sigl = '" & strSiglaSistema & "'"
		rs.open sql, cnn
			
		if rs.eof = false then
			strSituacaoSist 	=	Trim(rs("Sist_Stat"))
			strDescSistema		=	Trim(rs("Sist_Desc"))
		end if
		rs.close
	end if
	
	' Busca o Modulo
	if strSiglaSistema <> "" then
		sql = "SELECT Modu_Sist_Sigl, Modu_Sigl, Modu_Desc, Modu_Stat"
		sql = sql & " FROM SEG_MODULOS_SISTEMA"
		sql = sql & " WHERE Modu_Sist_Sigl = '" & strSiglaSistema  & "'"
	
		rs.open sql, cnn
			
		if rs.eof = false then
			strSiglaModulo		=	Trim(rs("Modu_Sigl"))
			strDescModulo		=	Trim(rs("Modu_Desc"))
		end if
		rs.close
	end if
	
	if strSiglaSistema <> "" and strSiglaModulo <> "" and intCodMenu <> "" then
			
			strDesabilitaIncluir = "disabled" 'Desabilita o botão Incluir'
			strDesabilitaAlterar = "" 'Habilita o botão Alterar'
			strDesabilitaExcluir = "" 'Desabilita o botão Excluir'
			strDesabilitaLimpar  = "" 'Habilita o Botão Limpar'
			
			sql = "SELECT Menu_Sist_Sigl, Menu_Modu_Sigl, "
			sql = sql & " Menu_Codg, Menu_Desc, Menu_Numr_Posicao, Sist_Desc, Modu_Desc, Situacao"
			sql = sql & " FROM SEG_MODULOS_SISTEMA, SEG_SISTEMAS_INFORMATICA, SEG_MENUS_SISTEMA"
			sql = sql & " WHERE Menu_Sist_Sigl = Sist_Sigl "
			sql = sql & " AND Menu_Modu_Sigl = Modu_Sigl"
			sql = sql & " AND Menu_Sist_Sigl = '" & strSiglaSistema & "'"
			sql = sql & " AND Menu_Modu_Sigl = '" & strSiglaModulo  & "'"
			sql = sql & " AND Menu_Codg = " & intCodMenu 
			rs.open sql, cnn
			
			if rs.eof = false then
				
				strSiglaSistema 	= ucase(Trim(rs("Menu_Sist_Sigl")))
				strDescSistema 		= Trim(rs("Sist_Desc"))
				strSiglaModulo		= Trim(rs("Menu_Modu_Sigl"))
				strDescMenu			= Trim(rs("Menu_Desc"))
				strDescModulo		= Trim(rs("Modu_Desc"))
				intOrdemMenu		= trim(rs("Menu_Numr_Posicao"))
				strSituacao			= trim(rs("Situacao"))
			
			else

				strDesabilitaIncluir = "disabled"'Desabilita o botão Incluir
				strDesabilitaAlterar = "" 'Desabilita o botão Alterar
				strDesabilitaExcluir = "disabled" 'Desabilita o botão Excluir
				strDesabilitaLimpar  = "" 'Habilita o Botão Limpar
			
				strDescMenu 					= ""
				strDescSistema		 			= ""
				strDescModulo					= ""

			end if
			rs.close
	
	else
	
		strDesabilitaIncluir = ""'Desabilita o botão Incluir
		strDesabilitaAlterar = "disabled" 'Desabilita o botão Alterar
		strDesabilitaExcluir = "disabled" 'Desabilita o botão Excluir
		strDesabilitaLimpar  = "" 'Habilita o Botão Limpar
	
	end if
	%>
     <!--=== Content Part ===-->
    <div class="container content">		
    
      <!-- Grey Panel -->            
      <div class="panel panel-grey">
        <div class="panel-heading">
        	<h3 class="panel-title"><i class="fa fa-tasks"></i>Cadastro de Menus</h3>
        </div>
        <!-- Inicia o Painel do Formulario -->     
        <div class="panel-body">
             <!-- Inicia o Form -->     
            <div class="panel-body">                                                        
                <form id="frm" class="margin-bottom-10" method="post">
                	<input name="txtCodMenu" type="hidden" class="text" id="txtCodMenu"  value="<%=intCodMenu%>" size="10">
                    <label>Sistema</label>
                    <div class="form-group">
                      <!--#include file="../includes/inc_cmdSistemas.asp"-->
                    </div>
                    <label>Módulo</label>
                    <div class="form-group">
                    <!--#include file="../includes/inc_cmdModulosSistema.asp"-->
                    </div>
                    <label>Descrição</label>
                     <div class="form-group">
                    <input id="txtDescMenu" name="txtDescMenu" type="text"  value="<%=strDescMenu%>"  size="50" class="form-control" maxlength="50" width="100" style="width:300pt">
                    </div>
                     <label>Situação</label>
                    <div class="form-group">
							<select name="cmbSituacao" class="form-control" id="cmbSituacao"  style="width:130pt">
                          <option value="A" <%if strSituacao = "A" then response.Write("selected") %>>Ativo</option>
                          <option value="I" <%if strSituacao = "I" then response.Write("selected") %>>Inativo</option>
                        </select>                    </div>
                    <br>
                    <label>Ordem Menu</label>
                    <div class="form-group">
                    	<input id="txtOrdemMenu" name="txtOrdemMenu" type="text"  value="<%=intOrdemMenu%>"  size="10" class="form-control" maxlength="10" width="10" style="width:60pt">
                    </div>
                    <br>
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
                        <h3 class="panel-title"><i class="fa fa-globe"></i> Lista de Menus</h3>
                    </div>
                    <div class="panel-body">
                        <table class="table table-bordered">
                            <thead>
                                <tr>
                                  <th width="17%" align="center"><strong>Sigla Sistema</strong></th>
                                  <th width="34%"><strong>Sigla Modulo</strong></th>
                                  <th width="31%"><strong>Descri&ccedil;&atilde;o Menu</strong></th>
                                  <th width="11%">Descri&ccedil;&atilde;o Menu</th>
                                  <th colspan="1"><div align="center">Ação</div></th>
                                </tr>
                            </thead>
                            <%
							sql = "SELECT Menu_Sist_Sigl, Menu_Modu_Sigl, Menu_Codg, Menu_Desc, Menu_Numr_Posicao"
							sql = sql & " FROM SEG_MENUS_SISTEMA"
							sql = sql & " WHERE Menu_Sist_Sigl = '" & strSiglaSistema  & "'"
							sql = sql & " AND Menu_Modu_Sigl = '" & strSiglaModulo  & "'"
							sql = sql & " ORDER BY Menu_Sist_Sigl, Menu_Modu_Sigl"
							rs.open sql, cnn
							cont=0
							if rs.eof = false then
							
							while not rs.eof
							cont = cont + 1	
							%>
                            <tbody>
                                <tr>
                                    <td><%=trim(rs("Menu_Sist_Sigl"))%></td>
                                    <td><%=trim(rs("Menu_Modu_Sigl"))%></td>
                                    <td><%=trim(rs("Menu_Desc"))%></td>
                                     <td><div align="center"><%=trim(rs("Menu_Numr_Posicao"))%></div></td>
                                    <td > <button class="btn-u btn-u-sea" onClick="return resultadoConsulta('<%=rs("Menu_Sist_Sigl")%>','<%=rs("Menu_Modu_Sigl")%>','<%=rs("Menu_Codg")%>','<%=rs("Menu_Desc")%>')" type="button"><i class="fa fa-file-text-o"></i></button>  
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
		
		if (frm.cmbSistemas.value == "0") {
			alert("O Sistema deve ser informado!");
			frm.cmbSistemas.focus();
			return false;
		} 
		
		if (frm.cmbModulosSistema.value == "0") {
			alert("A Sigla do Modulo deve ser informada!");
			frm.cmbModulosSistema.focus();
			return false;
		} 


		if (frm.txtDescMenu.value == "") {
			alert("A Descrição do Menu deve ser informada!");
			frm.txtDescMenu.focus();
			return false;
		} 
		
		if (frm.txtOrdemMenu.value == "") {
			alert("A Ordem Menu deve ser informada!");
			frm.txtOrdemMenu.focus();
			return false;
		} 

		frm.action="Menus_cod.asp?acao=" + acao;
		frm.submit();
		return true;	 
	
	}
	
	function resultadoConsulta(strSiglaSistema, strSiglaMudulo, intCodMenu, strDescMenu){
		
		var frm = document.getElementById("frm");
		
		frm.cmbSistemas.value=strSiglaSistema;
		frm.cmbModulosSistema.value=strSiglaMudulo;
		frm.txtCodMenu.value=intCodMenu;
		frm.txtDescMenu.value=strDescMenu;
		frm.submit();
		
	}
	
	</script>
    <!--=== End Content Part ===-->
   	<!--#include file="../RodapeModulo.asp"-->
	<!--#include file="../jsModulo.asp"-->
</body>
</html> 