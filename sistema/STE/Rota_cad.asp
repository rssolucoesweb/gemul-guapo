	<!--#include file="../ConfigModulo.asp"-->
    <!--#include file="../../includes/inc_cnn.asp"-->
    <!--#include file="../../includes/inc_formatadata.asp"-->
	<!--#include file="../menuModulos.asp"-->  
    <script src="../../js/js_funcoes_gerais.js"></script>
    <!--=== Breadcrumbs ===-->
    <div class="breadcrumbs">
        <div class="container">
            <h1 class="pull-left">Modulo Transporte Escolar</h1>
            <ul class="pull-right breadcrumb">
                <li><a href="Default.asp">Home</a></li>
                <li class="active"><%=session("CodEmpresa")%> - <%=session("EmpresaWeb")%></li>
            </ul>
        </div><!--/container-->
    </div><!--/breadcrumbs-->
    <!--=== End Breadcrumbs ===-->
	<%
		strVinculaRota			= "S"
		strPaginaTitulo 		= "Rota_cad.asp"
		intCodGrupo				= Session("CodGrupo") 
		intCodFuncao			= "2133" 'Codigo Função Motorista
		
		intCodigo		    	= Trim(Request.Form("txtCodigo")) 
		strNomeRota	 			= Trim(Request.Form("txtNome"))
		intDistanciaPercorrida 	= Trim(Request.Form("txtDistanciaPercorrida"))
		intCodColaborador	 	= Trim(Request.Form("cmbColaborador"))
		strValor	 			= Trim(Request.Form("txtValor"))
		strVeiculo	 			= Trim(Request.Form("txtVeiculo"))
		strPlaca	 			= Trim(Request.Form("txtPlaca"))
		strCor	 				= Trim(Request.Form("txtCor"))
		strData	 				= Trim(Request.Form("txtData"))
		strObservacao			= Trim(Request.Form("txtObservacao"))
		strSituacao				= Trim(Request.Form("cmbSituacao"))
		strMotorista			= Trim(Request.Form("txtMotorista"))
		
		if intCodigo <> "" or strNomeRota <> "" then
		
			sql = "SELECT Cod_Rota, Cod_Grupo, Descricao, Motorista, Distancia_percorrida, CodColaborador, Veiculo, Placa, Cor, Data, Observacao, Situacao"
			sql = sql & " FROM SCA_ROTA"
			sql = sql & " where Cod_Grupo = " & Session("CodGrupo") 
			
			if intCodigo <> "" then 
				sql = sql & " and Cod_Rota=" & intCodigo
			end if
			
			if strNomeRota <> "" then 
				sql = sql & " and Descricao = '" & strNomeRota & "'"
			end if
			
			
			rs.open sql, cnn
			if rs.eof = false then
				
				intCodRota	 			= rs("Cod_Rota")
				strNomeRota            	= rs("Descricao")
				intDistanciaPercorrida 	= rs("Distancia_percorrida")
				intCodColaborador	 	= rs("CodColaborador")
				strVeiculo	 			= rs("Veiculo")
				strPlaca	 			= rs("Placa")
				strCor	 				= rs("Cor")
				strData	 				= formatadataAP(rs("Data"))
				strObservacao          	= rs("Observacao")
				strSituacao				= rs("Situacao")
				strMotorista				= rs("Motorista")	
				
				strBloqueia = "readonly"	
				
				strDesabilitaIncluir	= "disabled" 'Desabilita o botão Incluir
				strDesabilitaAlterar 	= "" 'Desabilita o botão Excluir
				strDesabilitaExcluir	= "" 'Desabilita o botão Excluir
			
			else
				
				strBloqueia = ""
				intCodRota	 			= ""
				intDistanciaPercorrida 	= ""
				intCodColaborador	 	= ""
				strVeiculo	 			= ""
				strPlaca	 			= ""
				strCor	 				= ""
				strData	 				= ""
				strObservacao          	= ""
				strSituacao				= ""
				strMotorista			= ""
				
				strDesabilitaIncluir	= "" 'Desabilita o botão Incluir
				strDesabilitaAlterar 	= "disabled" 'Desabilita o botão Excluir
				strDesabilitaExcluir	= "disabled" 'Desabilita o botão Excluir
			
				
			end if
			rs.close
		
		else
			strDesabilitaIncluir	= "" 'Desabilita o botão Incluir
			strDesabilitaAlterar 	= "disabled" 'Desabilita o botão Excluir
			strDesabilitaExcluir	= "disabled" 'Desabilita o botão Excluir
		end if 
		
		if strData = "" then strData = formatadataAP(date)
    %>
     <!--=== Content Part ===-->
    <div class="container content">		
    
      <!-- Grey Panel -->            
      <div class="panel panel-grey">
        <div class="panel-heading">
        	<h3 class="panel-title"><i class="fa fa-tasks"></i>Cadastro de Rota</h3>
        </div>
        <!-- Inicia o Painel do Formulario -->     
        <div class="panel-body">
             <!-- Inicia o Form -->     
            <div class="panel-body">                                                        
                <form id="frm" class="margin-bottom-10" method="post">
                	<input name="txtCodigo" type="hidden" class="text" id="txtCodigo" value="<%=intCodigo%>" size="10">
                    <div class="form-group">
                        <label class="form-label">Nome da Rota</label>
                         <input name="txtNome" type="text" class="form-control" id="txtNome" style="width:350pt" value="<%=strNomeRota%>" size="80" maxlength="100">
                    </div>
                   
                    <div class="form-group">
                        <label class="form-label">Dist&acirc;ncia percorrida</label>
                         <input name="txtDistanciaPercorrida" type="text" class="form-control" id="txtDistanciaPercorrida" onKeyPress="return formataCampo(this, 2, 5)" style="width:50pt" value="<%=intDistanciaPercorrida%>"  maxlength="5">(km)
                    </div>
                    
                    <div class="form-group">
                        <label class="form-label">Motorista <i>(colaborador cadastro na função de motorista)</i></label>
                         <!--#include file="../includes/inc_cmbMotorista.asp" -->
                    </div>
                    <div class="form-group">
                        <label class="form-label">Motorista (externo/sem cadastro)</label>
                         <input name="txtMotorista" type="text" class="form-control" id="txtMotorista" style="width:150pt" value="<%=strMotorista%>" size="80" maxlength="100">
                    </div>
					
                    <div class="form-group">
                        <label class="form-label">Veiculo</label>
                         <input name="txtVeiculo" type="text" class="form-control" id="txtVeiculo" style="width:150pt" value="<%=strVeiculo%>" size="80" maxlength="100">
                    </div>
                    
                    <div class="form-group">
                        <label class="form-label">Placa</label>
                         <input name="txtPlaca" type="text" class="form-control" id="txtPlaca" style="width:150pt" value="<%=strPlaca%>" size="80" maxlength="100">
                    </div>
                    
                    <div class="form-group">
                        <label class="form-label">Cor</label>
                         <input name="txtCor" type="text" class="form-control" id="txtCor" style="width:150pt" value="<%=strCor%>" size="80" maxlength="100">
                    </div>
                    
                     <div class="form-group">
                        <label class="form-label">Data</label>
                         <input name="txtData" type="text" class="form-control" id="txtData" style="width:150pt" value="<%=strData%>"  onBlur="return validaData(this)" onKeyPress="return formataCampo(this, 3, 10)"  size="80" maxlength="100">
                    </div>
                    
                    <div class="form-group">
                        <label class="form-label">Observa&ccedil;&atilde;o:</label>
                         <input name="txtObservacao" type="text" class="form-control" id="txtObservacao" style="width:150pt" value="<%=strObservacao%>" size="80" maxlength="100">
                    </div>
                    
                    <div class="form-group">
                        <label class="form-label">Situação</label>
                        <select name="cmbSituacao" class="form-control" id="cmbSituacao"  style="width:130pt">
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
                        <h3 class="panel-title"><i class="fa fa-globe"></i> Lista de Grupos</h3>
                    </div>
                    <div class="panel-body">
                        <table class="table table-bordered">
                            <thead>
                                <tr>
                                    <th width="5%" bgcolor="#95A5A6">#</th>
                                    <th width="86%" bgcolor="#95A5A6">Descrição</th>
                                    <th width="86%" bgcolor="#95A5A6">Situação</th>
                                    <th width="9%" bgcolor="#95A5A6" align="center"><div align="center">Ação</div></th>
                                </tr>
                            </thead>
                            <%
							sql = "SELECT Cod_Rota, Cod_Grupo, Descricao, Situacao"
							sql = sql & " FROM SCA_ROTA"
							sql = sql & " where Cod_Grupo =  " & Session("CodGrupo") 			
							sql = sql & " Order by Cod_Rota"
				
							rs.open sql, cnn
							cont=0
							if rs.eof = false then
							
							while not rs.eof
							cont = cont + 1	
							%>
                            <tbody>
                                <tr>
                                    <td><%=trim(rs("Cod_Rota"))%></td>
                                    <td><%=trim(rs("Descricao"))%></td>
                                    <td align="center"><%=trim(rs("Situacao"))%></td>
                                    <td align="center" >
                                    <button class="btn-u btn-u-sea" onClick="resultadoConsulta(<%=trim(rs("Cod_Rota"))%>)" type="button"><i class="fa fa-file-text-o"></i></button> 
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
    <!--/container-->		
    <script>
	function salvar(acao){
		
		var frm = document.getElementById("frm");
		
		if (frm.txtNome.value == ""){
			alert("A rota deve ser informada.");
			frm.txtNome.focus();
			return false;
		}	
		
		/*if (frm.txtDistanciaPercorrida.value == ""){
			alert("A distancia percorrida deve ser informada.");
			frm.txtDistanciaPercorrida.focus();
			return false;
		}			
		
		if (frm.cmbColaborador.value == "0"){
			alert("O Colobaorador deve ser informado.");
			frm.cmbColaborador.focus();
			return false;
		}
		
		if (frm.txtVeiculo.value == ""){
			alert("O Veiculo deve ser informado.");
			frm.txtVeiculo.focus();
			return false;
		}
		
		if (frm.txtPlaca.value == ""){
			alert("A Placa deve ser informada.");
			frm.txtPlaca.focus();
			return false;
		}
		
		if (frm.txtCor.value == ""){
			alert("A Cor deve ser informada.");
			frm.txtCor.focus();
			return false;
		}			
		
		if (frm.txtData.value == ""){
			alert("A Data deve ser informada.");
			frm.txtData.focus();
			return false;
		}	
		*/
		frm.action= "Rota_cod.asp?acao=" + acao;
		frm.submit();
		return true;		
				
	}
	
	function resultadoConsulta(intCodigo){
		var frm = document.getElementById("frm");
		frm.txtCodigo.value=intCodigo;
		frm.submit();
	}
	
	function VinculaRota(CodRota){
		window.open("RotaUnidade_cad.asp?CodRota="+frm.txtCodigo.value,"consulta", "top=0,left=0,height=600,width=800,menubar=no,toolbar=no,scrollbars=yes,status=yes");
		return true;
	}
	</script>
    <!--=== End Content Part ===-->
   	<!--#include file="../RodapeModulo.asp"-->
	<!--#include file="../jsModulo.asp"-->
</body>
</html> 