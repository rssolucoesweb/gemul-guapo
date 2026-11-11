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
        strPaginaTitulo 			= "Nivel_cad.asp"
        intCodGrupo					= Session("CodGrupo")
        intCodigo	 				= Trim(Request.Form("txtCodigo"))
        strDescricao 				= Trim(Request.Form("txtDescricao"))
        strValorHora 				= Trim(Request.Form("txtValorHora"))
        strSituacao 				= Trim(Request.Form("cmbSituacao"))
        strTipoVinculo 				= Trim(Request.Form("cmbTipoVinculo"))
        strSalarioBase 				= Trim(Request.Form("txtSalarioBase"))
        strCarga_Horario_Contratada = Trim(Request.Form("txtCargaHorariaTotal"))
        strTotalAulas		 		= Trim(Request.Form("txtTotalAulas"))
        strMaximoModulado			= Trim(Request.Form("txtMaximoModulado"))
        
        
        strPercentualRepousoSemanal	= Trim(Request.Form("txtPercentualRepousoSemanal"))
        strFatorExtraClasse		 	= Trim(Request.Form("txtFatorExtraClasse"))
        strPermiteSubstituicao      = Trim(Request("cmbPermiteSubstituicao"))
        strPermiteDobras            = Trim(Request("cmbPermiteDobras"))
        
        
        if trim(intCodigo) <> "" then
        
            sql = "SELECT Codigo, Cod_grupo, Descricao, Valor_hora, Situacao, Tipo_Vinculo, tipo_modulacao, Salario_Base, "
            sql = sql & " carga_horario_contratada, total_aulas, PercentualRepousoSemanal, FatorExtraClasse, PermiteSubstituicao, PermiteDobras, MaximoModulado "
            sql = sql & " FROM SRH_NIVEL"
            sql = sql & " where Cod_grupo = " & intCodGrupo			
            sql = sql & " and Codigo = " & intCodigo
            rs.open sql, cnn
            
            if rs.eof = false then
                
                intCodigo	 					= rs("Codigo")
                strDescricao 					= rs("Descricao")
                strValorHora 					= formatNumber(rs("Valor_hora"),2) 
                strSituacao 					= rs("Situacao")
                strTipoVinculo 					= rs("Tipo_Vinculo")
                strTipoModulacao 				= rs("tipo_modulacao")
                
                strPercentualRepousoSemanal 	= rs("PercentualRepousoSemanal")
                strFatorExtraClasse 			= rs("FatorExtraClasse")
                
                if isnull(rs("Salario_Base")) or rs("Salario_Base") = "" then 
                   strSalarioBase = "0"
                else
                   strSalarioBase 		= formatNumber(rs("Salario_Base"),2) 
                end if  
            
                if isnull(rs("carga_horario_contratada")) or rs("carga_horario_contratada") = "" then 
                   strCarga_Horario_Contratada 	= "0"
                else
                   strCarga_Horario_Contratada	= rs("carga_horario_contratada")
                end if   
                        
                if isnull(rs("total_aulas")) or rs("total_aulas") = ""  then 
                    strTotalAulas = "0"
                else	
                    strTotalAulas 		= rs("total_aulas")
                end if
                
                if isnull(rs("MaximoModulado")) or rs("MaximoModulado") = ""  then 
                    strMaximoModulado = "0"
                else	
                    strMaximoModulado 		= rs("MaximoModulado")
                end if
                
                strPermiteSubstituicao 		= rs("PermiteSubstituicao")
                strPermiteDobras 			= rs("Permitedobras")
                
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
        	<h3 class="panel-title"><i class="fa fa-tasks"></i>Nivel</h3>
        </div>
        <!-- Inicia o Painel do Formulario -->     
        <div class="panel-body">
             <!-- Inicia o Form -->     
            <div class="panel-body">                                                        
                    <form method="post" id="frm" action="#">
          
                      <div class="form-group">
                    	<label for="inputEmail1" class="col-lg-2 control-label">Descri&ccedil;&atilde;o:</label>
                        <div class="col-lg-10">
                        	<input name="txtCodigo" type="hidden" id="txtCodigo" class="form-control" size="10" value="<%=intCodigo%>" maxlength="10">
            				<input name="txtDescricao" type="text" class="form-control" id="txtDescricao" size="40" maxlength="40" value="<%=strDescricao%>">
                        </div>
               		 </div>
                     
                     <div class="form-group">
                    	<label for="inputEmail1" class="col-lg-2 control-label">Valor Hora:</label>
                        <div class="col-lg-10">
                        	<input name="txtValorHora" type="text" class="form-control" id="txtValorHora" onkeypress="return currencyFormat(this,event)" size="11" maxlength="10" value="<%=strValorHora%>">
                        </div>
               		 </div>
                     
                     <div class="form-group">
                    	<label for="inputEmail1" class="col-lg-2 control-label">Sal&aacute;rio Base:</label>
                        <div class="col-lg-10">
                        	<input name="txtSalarioBase" type="text" class="form-control" id="txtSalarioBase" onkeypress="return currencyFormat(this,event)" size="11" maxlength="10" value="<%=strSalarioBase%>">
                        </div>
               		 </div>
                     
                     <div class="form-group">
                    	<label for="inputEmail1" class="col-lg-2 control-label">Tipo Modula&ccedil;&atilde;o</label>
                        <div class="col-lg-10">
                        	<!--#include file="../includes/inc_cmbTipoModulacao.asp" -->
                        </div>
               		 </div>
                     
                     <div class="form-group">
                    	<label for="inputEmail1" class="col-lg-2 control-label">Tipo Modula&ccedil;&atilde;o</label>
                        <div class="col-lg-10">
                        	<input name="txtCargaHorariaTotal" type="text" class="form-control" id="txtCargaHorariaTotal" onkeypress="return formataCampo(this, 2, 5)"  size="5" maxlength="5" value="<%=strCarga_Horario_Contratada%>">hs
                        </div>
               		 </div>
                     
                     <div class="form-group">
                    	<label for="inputEmail1" class="col-lg-2 control-label">Aulas Semanais</label>
                        <div class="col-lg-10">
                        	<input name="txtTotalAulas" type="text" class="form-control" id="txtTotalAulas" onkeypress="return formataCampo(this, 2, 5)"  size="5" maxlength="5" value="<%=strTotalAulas%>">
                        </div>
               		 </div>
                     
                     <div class="form-group">
                    	<label for="inputEmail1" class="col-lg-2 control-label">M&aacute;ximo Modulado:</label>
                        <div class="col-lg-10">
                        	<input name="txtMaximoModulado" type="text" class="form-control" id="txtMaximoModulado" onkeypress="return formataCampo(this, 2, 5)"  size="5" maxlength="5" value="<%=strMaximoModulado%>">
                        </div>
               		 </div>
                     
                     <div class="form-group">
                    	<label for="inputEmail1" class="col-lg-2 control-label">Situa&ccedil;&atilde;o :</label>
                        <div class="col-lg-10">
                        	<!--#include file="../includes/inc_cmdSituacao.asp" -->
                        </div>
               		 </div>
                     
                     <div class="form-group">
                    	<label for="inputEmail1" class="col-lg-2 control-label">Tipo Vinculo:</label>
                        <div class="col-lg-10">
                        	<!--#include file="../includes/inc_cmbTipoVinculo.asp" -->
                        </div>
               		 </div>
                     
                     <div class="form-group">
                    	<label for="inputEmail1" class="col-lg-2 control-label">Remunerado:</label>
                        <div class="col-lg-10">
                        	<input name="txtPercentualRepousoSemanal" type="text" class="form-control" id="txtPercentualRepousoSemanal" onkeypress="return currencyFormat(this,event)"  size="5" maxlength="5" value="<%=strPercentualRepousoSemanal%>">% - Repouso Semanal 
                        </div>
               		 </div>
                     
                      <div class="form-group">
                    	<label for="inputEmail1" class="col-lg-2 control-label">Permitir Substitui&ccedil;&atilde;o:</label>
                        <div class="col-lg-10">
                            <select name="cmbPermiteSubstituicao" class="form-control" id="cmbPermiteSubstituicao" style="width:50pt">
                            <option value="N" <%if strPermiteSubstituicao = "N" then response.Write("selected") %>>NAO</option>
                            <option value="S" <%if strPermiteSubstituicao = "S" then response.Write("selected") %>>SIM</option>
                            </select>
                        </div>
               		 </div>
                     
                     <div class="form-group">
                    	<label for="inputEmail1" class="col-lg-2 control-label">Permitir Dobras:</label>
                        <div class="col-lg-10">
                            <select name="cmbPermiteDobras" class="form-control" id="cmbPermiteDobras" style="width:50pt">
                            <option value="N" <%if strPermiteDobras = "N" then response.Write("selected") %>>NAO</option>
                            <option value="S" <%if strPermiteDobras = "S" then response.Write("selected") %>>SIM</option>
                            </select>
                        </div>
               		 </div>
                     
                     <div class="form-group">
                    	<label for="inputEmail1" class="col-lg-2 control-label">C&aacute;lculo Extra Classe:</label>
                        <div class="col-lg-10">
                            <input name="txtFatorExtraClasse" type="text" class="form-control" id="txtFatorExtraClasse" onkeypress="return currencyFormat(this,event)"  size="5" maxlength="5" value="<%=strFatorExtraClasse%>">
                        </div>
               		 </div>
                     
                    <legend></legend>
                    <!--#include file="../../includes/inc_botoes_cadastro.asp"-->
                </form>
            	</div>
       	 	</div>
         	<!-- Fecha o Form -->  
      </div>
     <!-- Fecha o Painel do Formulario -->   
     
            <!--Table Bordered-->
        <div class="panel panel-grey margin-bottom-40">
            <div class="panel-heading">
                <h3 class="panel-title"><i class="fa fa-globe"></i> Lista de Nivel</h3>
            </div>
            <div class="panel-body">
                <table class="table table-bordered">
                    <thead>
                        <tr>
                          <th width="5%" bgcolor="#95A5A6">C&oacute;d.</th>
                          <th width="59%" bgcolor="#95A5A6">Descrição</th>
                          <th width="11%" bgcolor="#95A5A6">Valor Hora</th>
                          <th width="11%" bgcolor="#95A5A6">Salário Base</th>
                          <th width="11%" bgcolor="#95A5A6">Horas Semanais</th>
                          <th width="11%" bgcolor="#95A5A6">Aulas Semanais</th>
                          <th width="11%" bgcolor="#95A5A6">Máximo Modulado</th>
                          <th width="11%" bgcolor="#95A5A6">Tipo Vinculo</th>
                          <th width="11%" bgcolor="#95A5A6">Tipo Modulação</th>
                          <th width="11%" bgcolor="#95A5A6">Repouso Semanal</th>
                          <th width="11%" bgcolor="#95A5A6">Cálculo Extra Classe</th>
                          <th width="11%" bgcolor="#95A5A6">Situação</th>
                          <th width="6%" bgcolor="#95A5A6" align="center"><div align="center">Ação</div></th>
                      </tr>
                    </thead>
                     <tbody>
                    <%
                    cont =0
		
					sql = "SELECT Codigo, Cod_grupo, Descricao, Valor_hora, Situacao, Tipo_Vinculo, Tipo_Modulacao, Salario_Base, "
					sql = sql & " carga_horario_contratada, total_aulas,  PercentualRepousoSemanal, FatorExtraClasse, MaximoModulado "
					sql = sql & " FROM SRH_NIVEL"
					sql = sql & " where Cod_grupo = " & intCodGrupo	
					sql = sql & " Order by Descricao"
                    rs.open sql, cnn
                    if rs.eof = false then
                    
                    while not rs.eof
                        
						cont = cont + 1	
				
						if trim(rs("Situacao")) = "A" then
							strSituacao = "Ativo"
						else
							strSituacao = "Inativo"
						end if
						
						if trim(rs("Tipo_Vinculo")) = "A" then
							strTipoVinculo = "Administrativo"
						else
							strTipoVinculo = "Docente"
						end if
						
						if trim(rs("Tipo_Modulacao")) = "A" then
							strTipoModulacao = "Aulas"
						else
							strTipoModulacao = "Horas"
						end if
						
						if isnull(rs("Salario_Base")) or rs("Salario_Base") = "" then 
						   strSalarioBase = "0"
						else
						   strSalarioBase 		= formatNumber(rs("Salario_Base"),2) 
						end if  
					
						if isnull(rs("carga_horario_contratada")) or rs("carga_horario_contratada") = "" then 
						   strCarga_Horario_Contratada 	= "0"
						else
						   strCarga_Horario_Contratada	= rs("carga_horario_contratada")
						end if   
								
						if isnull(rs("total_aulas")) or rs("total_aulas") = ""  then 
							strTotalAulas = "0"
						else	
							strTotalAulas 		= rs("total_aulas")
						end if
	
						if isnull(rs("MaximoModulado")) or rs("MaximoModulado") = ""  then 
							strMaximoModulado = "0"
						else	
							strMaximoModulado 		= rs("MaximoModulado")
						end if
						
						if isnull(rs("Valor_hora")) or rs("Valor_hora") = ""  then 
							strValor_hora = "0"
						else	
							strValor_hora 		= formatNumber(rs("Valor_hora"),2)
						end if
											
                    	%>
                        <tr>
                            <td><%=rs("Codigo")%></td>
                            <td><%=trim(rs("Descricao"))%></td>
                            <td><div align="right"><%=trim(strValor_hora)%>&nbsp;</div></td>
                            <td><div align="right"><%=trim(formatNumber(strSalarioBase,2))%></div></td>
                            <td><div align="center"><%=trim(strCarga_Horario_Contratada)%></div></td>
                            <td><div align="center"><%=trim(strTotalAulas)%></div></td>
                            <td><div align="center"><%=trim(strMaximoModulado)%></div></td>
                            <td><div align="center"><%=trim(strTipoVinculo)%></div></td>
                            <td><div align="center"><%=trim(strTipoModulacao)%></div></td>
                            <td><%=trim(rs("PercentualRepousoSemanal"))%></td>
                            <td><%=trim(rs("FatorExtraClasse"))%></td>
                            <td><%=trim(strSituacao)%></td>
                            <td align="center"><button class="btn-u btn-u-sea" onclick="resultadoConsulta(<%=rs("Codigo")%>)" type="button"><i class="fa fa-file-text-o"></i></button></td> 
                        </tr>
                    	<%				
                        rs.movenext
                        wend
                    end if
                    rs.close
                	%>
                    <tr>
                        <td colspan="13">Total Registros : <%=cont%></td>
                    </tr>
                    </tbody>
                </table>
            </div>                      
        </div>
        <!--End Table Bordered-->	

          
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
                alert("A Situação deve ser informada !");
                frm.txtDescricao.focus();
                return false;
            }
            
            if (frm.txtValorHora.value == "") {
                alert("O Valor Hora deve ser informado !");
                frm.txtValorHora.focus();
                return false;
            }
            
            if (frm.cmbSituacao.value == "0") {
                alert("A Situação deve ser informada !");
                frm.cmbSituacao.focus();
                return false;
            }
            
            if (frm.cmbTipoVinculo.value == "0") {
                alert("O Tipo Vinculo deve ser informado !");
                frm.cmbTipoVinculo.focus();
                return false;
            }
            
            if (frm.txtPercentualRepousoSemanal.value == "") {
                alert("O Percentual Repouso Semanal deve ser informado !");
                frm.txtPercentualRepousoSemanal.focus();
                return false;
            }
            
            if (frm.txtFatorExtraClasse.value == "") {
                alert("O Fator Extra Classe deve ser informado !");
                frm.txtFatorExtraClasse.focus();
                return false;
            }
            
            frm.action="Nivel_cod.asp?acao=" + acao;
            frm.submit();
            return true;
        }
    </script>
    <!--=== End Content Part ===-->
   	<!--#include file="../RodapeModulo.asp"-->
	<!--#include file="../jsModulo.asp"-->
</body>
</html> 