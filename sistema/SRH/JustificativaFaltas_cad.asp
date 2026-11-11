<!--#include file="../../includes/inc_verificaSession.asp"-->
<!--#include file="../ConfigModulo.asp"-->
<!--#include file="../../includes/inc_cnn.asp"-->
<!--#include file="../../includes/inc_formatadata.asp"-->
<!--#include file="../menuModulos.asp"-->
<!--#include file="../includes/inc_CompartilharDadosCadastrais.asp"-->
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
        strPaginaTitulo 	= "JustificativaFaltas_cad.asp"
        intCodJustificativa	= Trim(Request.Form("txtCodigo"))
        strDescricao 		= Trim(Request.Form("txtDescricao"))
        strLegenda 			= Trim(Request.Form("txtLegenda"))
        strTotalDias 		= Trim(Request.Form("txtTotalDias"))
        strExigeDocumentacao= Trim(Request.Form("cmbExigeDocumentacao"))
		strSituacao 		= Trim(Request.Form("cmbSituacao"))
            
        if trim(intCodJustificativa) <> "" then
        
            sql = "SELECT CODIGO, DESCRICAO, LEGENDA, TOTALDIAS, SITUACAO, Exige_Comprovacao "
            sql = sql & " FROM SRH_JUSTIFICATIVAFALTAS"
            sql = sql & " Where CODIGO = " & intCodJustificativa
            rs.open sql, cnn
            
            if rs.eof = false then
                
                intCodJustificativa	 	= rs("CODIGO")
                strDescricao			= rs("DESCRICAO")
                strLegenda				= rs("LEGENDA")
                strTotalDias			= rs("TOTALDIAS")
				strSituacao				= rs("SITUACAO")
				strExigeDocumentacao	= rs("Exige_Comprovacao")
                
                strDesabilitaIncluir	= "disabled" 'Desabilita o botão Incluir
                strDesabilitaAlterar 	= "" 'Desabilita o botão Excluir
                strDesabilitaExcluir	= "" 'Desabilita o botão Excluir
    
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
        	<h3 class="panel-title"><i class="fa fa-tasks"></i>Cadastro de Justificativa</h3>
        </div>
        <!-- Inicia o Painel do Formulario -->     
        <div class="panel-body">
             <!-- Inicia o Form -->     
            <div class="panel-body">                                                        
                <form id="frm" method="post">
                	<input name="txtCodigo" type="hidden" id="txtCodigo" class="text" size="10" value="<%=intCodJustificativa%>" maxlength="10">
              
                    <div class="form-group">
                    <label class="form-label">Justificativa </label>
                        <input name="txtDescricao" type="text" class="form-control" id="txtDescricao" size="70" maxlength="70" value="<%=strDescricao%>">
                    </div>
                    
                    <div class="form-group">
                    <label class="form-label">Legenda </label>
                        <input name="txtLegenda" type="text" class="form-control" id="txtLegenda" size="5" maxlength="5" value="<%=strLegenda%>">
                    </div>
                    
                     <div class="form-group">
                    <label class="form-label">Dias </label>
                        <input name="txtTotalDias" type="text" class="form-control" id="txtTotalDias" size="5" maxlength="5" value="<%=strTotalDias%>">
                    </div>
                    <div class="form-group">
                    <label class="form-label">Exigir Comprovação </label>
                        <select name="cmbExigeDocumentacao" class="form-control" id="cmbExigeDocumentacao">
                           <option value="0">Selecione...</option>
                           <option value="S" <%if strExigeDocumentacao = "S" then response.Write("selected") %>>Sim</option>
                           <option value="N" <%if strExigeDocumentacao = "N" then response.Write("selected") %>>Não</option>
                         </select>
                    </div>
                   
                    <div class="form-group">
                    <label class="form-label">Situação </label>
                        <select name="cmbSituacao" class="form-control" id="cmbSituacao">
                           <option value="0">Selecione...</option>
                           <option value="A" <%if strSituacao = "A" then response.Write("selected") %>>Ativo</option>
                           <option value="I" <%if strSituacao = "I" then response.Write("selected") %>>Inativo</option>
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
                <h3 class="panel-title"><i class="fa fa-globe"></i> Lista de Justificativa</h3>
            </div>
            <div class="panel-body">
                <table class="table table-bordered">
                    <thead>
                        <tr>
                          <th width="5%" bgcolor="#95A5A6">Código</th>
                          <th width="64%" bgcolor="#95A5A6">Descrição</th>
                          <th width="14%" bgcolor="#95A5A6">Legenda</th>
                          <th width="11%" bgcolor="#95A5A6">Comprovação</th>
                          <th width="11%" bgcolor="#95A5A6">Dias</th>
                          <th width="6%" bgcolor="#95A5A6" align="center"><div align="center">Situação</div></th>
                          <th width="6%" bgcolor="#95A5A6" align="center"><div align="center">Ação</div></th>
                      </tr>
                    </thead>
                     <tbody>
                    <%
						cont =0
						sql = "SELECT CODIGO, DESCRICAO, LEGENDA, TOTALDIAS, SITUACAO, Exige_Comprovacao"
						sql = sql & " FROM SRH_JUSTIFICATIVAFALTAS"
						sql = sql & " WHERE Cod_grupo = " & Session("CodGrupo")	
						sql = sql & " Order by DESCRICAO"
						rs.open sql, cnn
						if rs.eof = false then
						
						while not rs.eof
							cont = cont + 1	
							%>
							<tr>
								<td><%=trim(rs("CODIGO"))%></td>
								<td><%=trim(rs("DESCRICAO"))%></td>
                                <td><%=trim(rs("LEGENDA"))%></td>
                                <td><div align="center"><%=trim(rs("Exige_Comprovacao"))%></div></td>
                                <td><%=trim(rs("TOTALDIAS"))%></td>
                                <td><%=trim(rs("SITUACAO"))%></td>
								<td align="center" >
								<button class="btn-u btn-u-sea" onclick="resultadoConsulta(<%=trim(rs("CODIGO"))%>)" type="button"><i class="fa fa-file-text-o"></i></button>                            </td> 
							</tr>
							<%				
							rs.movenext
							wend
						end if
						rs.close
						%>
                    	<tr>
                    		<td colspan="9">Total Registros : <%=cont%></td>
                    	</tr>
                    </tbody>
                </table>
          </div>                      
        </div>
        <!--End Table Bordered-->	
        <!-- Fecha o Painel do Formulario -->        
    </div>
    <!--/container-->		
	<script>
        function resultadoConsulta(intCodigo){
            var frm = document.getElementById("frm");
            
            frm.txtCodigo.value=intCodigo;
            frm.submit();
        }
        
        function salvar(acao){
            
            var frm = document.getElementById("frm");
            
            if (frm.txtDescricao.value == "") {
                alert("A Justificativa deve ser informada !");
                frm.txtDescricao.focus();
                return false;
            }
            if (frm.txtLegenda.value == "") {
                alert("A Legenda deve ser informada !");
                frm.txtLegenda.focus();
                return false;
            }
             if (frm.txtTotalDias.value == "") {
                alert("Dias deve ser informado !");
                frm.txtTotalDias.focus();
                return false;
            } 
			if (frm.cmbSituacao.value == "0") {
                alert("Situação deve ser informada !");
                frm.cmbSituacao.focus();
                return false;
            }
            frm.action="JustificativaFaltas_cod.asp?acao=" + acao;
            frm.submit();
            return true;
        }
    </script>
    <!--=== End Content Part ===-->
   	<!--#include file="../RodapeModulo.asp"-->
	<!--#include file="../jsModulo.asp"-->
</body>
</html> 