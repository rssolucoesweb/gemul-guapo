<!--#include file="../ConfigModulo.asp"-->
<!--#include file="../../includes/inc_verificaSession.asp"-->
<!--#include file="../../includes/inc_cnn.asp"-->
<!--#include file="../../includes/inc_formatadata.asp"-->
<!--#include file="../../js/Calendario/Calendario.asp"-->
<!--#include file="../menuModulos.asp"-->
<script src="../../js/js_funcoes_gerais.js"></script>  
    <!--=== Breadcrumbs ===-->
    <div class="breadcrumbs">
        <div class="container">
            <h1 class="pull-left">SCA - Controle Acadêmico</h1>
            <ul class="pull-right breadcrumb">
                <li><a href="Default.asp">Home</a></li>
                <li class="active"><%=session("CodEmpresa")%> - <%=session("EmpresaWeb")%></li>
            </ul>
        </div><!--/container-->
    </div><!--/breadcrumbs-->
    <!--=== End Breadcrumbs ===-->
    <%

    strExecutarSubmitSemestre 	= "S"
    strPaginaTitulo 			= "CalendarioEvento_cad.asp"
    intCodigo	 				= Trim(Request("txtCodigo"))
    
    if trim(intCodigo) <> "" then
    
        sql = "SELECT *"
        sql = sql & " FROM sca_Calendario_Evento"
        sql = sql & " Where Cod_calendario_evento = " & intCodigo
        rs.open sql, cnn
        
        if rs.eof = false then
            
            intCodigo	 		= rs("Cod_calendario_evento")
            strNome	 			= rs("Nome")
            strLetivo	 		= rs("Letivo")
            strSituacao 		= rs("Situacao")
            strCor		    	= trim(rs("cor"))
            
            strDesabilitaIncluir	= "disabled" 'Desabilita o botão Incluir
            strDesabilitaAlterar 	= "" 'Desabilita o botão Excluir
            strDesabilitaExcluir	= "" 'Desabilita o botão Excluir
            BotaoSeguimento		 	= "" 'Desabilita o botão Excluir
            
        end if 
        rs.close
    else
        strDesabilitaIncluir	= "" 'Desabilita o botão Incluir
        strDesabilitaAlterar 	= "disabled" 'Desabilita o botão Excluir
        strDesabilitaExcluir	= "disabled" 'Desabilita o botão Excluir
        BotaoSeguimento		 = "disabled" 'Desabilita o botão Excluir
    end if 
    
  
    %>
     <!--=== Content Part ===-->
    <div class="container content">		
    
      <!-- Grey Panel -->            
      <div class="panel panel-grey">
        <div class="panel-heading">
        	<h3 class="panel-title"><i class="fa fa-tasks"></i>Evento do Calendário </h3>
        </div>
        <!-- Inicia o Painel do Formulario -->     
        <div class="panel-body">
             <!-- Inicia o Form -->     
            <div class="panel-body">                                                        
                <form id="frm" class="margin-bottom-10" method="post">
                	<input name="txtCodigo" type="hidden" id="txtCodigo" class="text" size="10" value="<%=intCodigo%>" maxlength="10">
                    <div class="form-group">
                      <label class="form-label">Nome</label>
                         <input  name="txtNome" type="text" class="form-control" id="txtNome" value="<%=strNome%>" size="70" maxlength="70" >
                    </div>
                   
                    <div class="form-group">
                        <label class="form-label">Letivo</label>
                         <select name="cmbLetivo" class="form-control" id="cmbLetivo"  style="width:90pt" >
						  <option value="0">Selecione...</option>
						  <option value="S" <%if strLetivo = "S" then response.Write("selected") %>>SIM</option>
						  <option value="N" <%if strLetivo = "N" then response.Write("selected") %>>NÃO</option>
						</select>
                    </div>
                    
                    <div class="form-group">
                        <label class="form-label" >Cor</label>
                         <input  name="txtCor" type="text" class="form-control" id="txtCor" value="<%=strCor%>" size="15" maxlength="10" >
                    </div>
                    <div class="form-group">
                        <label class="form-label" >Situação</label>
                         <select name="cmbSituacao" class="form-control" id="cmbSituacao"  style="width:90pt">
						  <option value="0">Selecione...</option>
						  <option value="A" <%if strSituacao = "A" then response.Write("selected") %>>ATIVO</option>
						  <option value="I" <%if strSituacao = "I" then response.Write("selected") %>>INATIVO</option>
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
                        <h3 class="panel-title"><i class="fa fa-globe"></i> Lista de Eventos para o Calendário</h3>
                    </div>
                    <div class="panel-body">
                    	<div class="table-responsive">
                        <table class="table table-bordered">
                            <thead>
                                <tr>
                                    <th width="4%" bgcolor="#95A5A6">C&oacute;d</th>
                                    <th width="35%" bgcolor="#95A5A6">Nome</th>
                                    <th width="10%" bgcolor="#95A5A6">Letivo</th>
									<th width="10%" bgcolor="#95A5A6">Cor</th>
                                    <th width="18%" bgcolor="#95A5A6">Situa&ccedil;&atilde;o</th>
                                  <th width="15%" bgcolor="#95A5A6" align="center"><div align="center">Ação</div></th>
                              </tr>
                            </thead>
                            <%
							cont = 0
		
							sql = "SELECT *"
							sql = sql & " FROM sca_Calendario_evento"
							sql = sql & " where cod_grupo = " & Session("CodGrupo")			
							sql = sql & " ORDER BY cod_Calendario_evento "
							rs.open sql, cnn
							if rs.eof = false then
							
							while not rs.eof
								
								cont = cont + 1	
								letivo = rs("letivo")
								
								if letivo = "S" then letivo = "SIM"
								if letivo = "N" then letivo = "NÃO"
								
								situacao = rs("situacao")
								if situacao = "A" then situacao = "ATIVO"
								if situacao = "I" then situacao = "INATIVO"
							%>
                            <tbody>
                                <tr>
                                    <td><%=trim(rs("cod_Calendario_evento"))%></td>
                                    <td><%=rs("nome")%></td>
                                    <td align="center"><%=trim(letivo)%></td>
                                    <td align="center" bgcolor="<%=rs("cor")%>"><%=rs("cor")%></td>
									<td align="center"><%=situacao%></td>
                                    <td align="center" >
                                    <button class="btn-u btn-u-sea" onclick="resultadoConsulta(<%=trim(rs("cod_Calendario_evento"))%>)" type="button"><i class="fa fa-file-text-o"></i></button> 
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
                </div>
                <!--End Table Bordered-->	
       <!-- Fecha o Painel do Formulario -->        
    </div>
    <!--/container-->		
    <!--=== End Content Part ===-->
	<script>
        function resultadoConsulta(intCodigo){
            
            var frm = document.getElementById("frm");
            
            frm.txtCodigo.value=intCodigo
            frm.submit();
        }
        function salvar(acao){
                
			var frm = document.getElementById("frm");
			
			
			if (frm.txtNome.value == "") {
				alert("Nome do evento deve ser informado!");
				frm.txtNome.focus();
				return false;
			}
			
			if (frm.cmbLetivo.value == "0") {
				alert("Evento letivo deve ser informado!");
				frm.cmbLetivo.focus();
				return false;
			}
			if (frm.txtCor.value == "") {
				alert("Cor do evento deve ser informada!");
				frm.txtCor.focus();
				return false;
			}
			if (frm.cmbSituacao.value == "0") {
				alert("Situação deve ser informada!");
				frm.cmbSituacao.focus();
				return false;
			}
							
			frm.action="CalendarioEvento_cod.asp?acao=" + acao;
			frm.submit();
			return true;
            
        }
    </script>
   	<!--#include file="../RodapeModulo.asp"-->
	<!--#include file="../jsModulo.asp"-->
</body>
</html> 