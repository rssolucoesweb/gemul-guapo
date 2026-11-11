<!--#include file="../ConfigModulo.asp"-->
<!--#include file="../../includes/inc_cnn.asp"-->
<!--#include file="../../includes/inc_formatadata.asp"-->
<%
	intCodGrupo				= Session("CodGrupo") 
	intCodRota 				= Trim(Request("CodRota"))
	
	intCodigo	 			= Trim(Request.Form("txtCodigo"))
	intCodEmpresaUsuario 	= Trim(Request.Form("cmdEmpresaUsuario"))
	strHoraSaida			= Trim(Request.form("txtHoraSaida"))
	strHoraChegada 			= Trim(Request.Form("txtHoraChegada"))
	
	if intCodRota <> "" then
	
		sql = "SELECT Cod_Rota, Cod_Grupo, Descricao, Distancia_percorrida, CodColaborador, Veiculo, Placa, Cor, Data, Observacao"
		sql = sql & " FROM SCA_ROTA"
		sql = sql & " where Cod_Grupo = " & Session("CodGrupo") 	
		sql = sql & " and Cod_Rota=" & intCodRota
		
		rs.open sql, cnn
		if rs.eof = false then
			intCodRota	 			= rs("Cod_Rota")
			strNomeRota            	= rs("Descricao")
		end if
		rs.close
	
	end if 
	
	if intCodRota = "" then intCodRota = "0"
	
	
	if trim(intCodRota) <> "" and intCodEmpresaUsuario <> "" then
		
		sql = "SELECT CodRota, CodEmpresa, HoraSaida, HoraChegada"
		sql = sql & " FROM SCA_ROTA_VICULA_EMPRESA"
		sql = sql & " Where CodRota = " & intCodRota	
		sql = sql & " And CodEmpresa = " & intCodEmpresaUsuario
		sql = sql & " Order by CodRota"
		rs.open sql, cnn
		
		if rs.eof = false then
			
			intCodRota	 				= rs("CodRota")
			intCodEmpresaUsuario		= rs("CodEmpresa")
			strHoraSaida			    = rs("HoraSaida")
			strHoraChegada			    = rs("HoraChegada")
			
			strDesabilitaIncluir		= "disabled" 'Desabilita o botão Incluir
			strDesabilitaAlterar 		= "" 'Desabilita o botão Excluir
			strDesabilitaExcluir		= "" 'Desabilita o botão Excluir
		
		else
		
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
%>
     <!--=== Content Part ===-->
      
  
<div class="container content">		
    
      <!-- Grey Panel -->            
      <div class="panel panel-grey">
        <div class="panel-heading">
        	<h3 class="panel-title"><i class="fa fa-tasks"></i>Vincula Rota a Unidade</h3>
        </div>
        
        <!-- Inicia o Painel do Formulario -->     
        <div class="panel-body">
             <!-- Inicia o Form -->     
            <div class="panel-body">                                                        
                 <form method="post" id="frm" action="#">
                
                	 <div class="form-group">
                        <label for="inputEmail1" class="col-lg-2 control-label">Rota</label>
                        <div class="col-lg-10">
                          <input name="txtCodRota" type="text" id="txtCodRota" class="form-control" size="5" value="<%=intCodRota%>" maxlength="5" style="width:50pt">
                          <input name="txtNomeRota" type="text" class="form-control" id="txtNomeRota" size="30" maxlength="30" value="<%=strNomeRota%>"  style="width:100pt">
                        </div>
                    </div>
                     
                      <div class="form-group">
                    	<label for="inputEmail1" class="col-lg-2 control-label">Unidade</label>
                        <div class="col-lg-10">
                        	<!--#include file="../includes/inc_cmdEmpresaUsuario.asp" -->
                        </div>
               		 </div>
                     
                      <div class="form-group">
                    	<label for="inputEmail1" class="col-lg-2 control-label">Hora Chegada</label>
                        <div class="col-lg-10">
                        	<input name="txtHoraChegada" type="text" class="form-control" id="txtHoraChegada" style="width:150pt" value="<%=strHoraChegada%>" size="80" maxlength="100">
                        </div>
               		 </div>
                     
                     <div class="form-group">
                    	<label for="inputEmail1" class="col-lg-2 control-label">Hora Saida</label>
                        <div class="col-lg-10">
                        	<input name="txtHoraSaida" type="text" class="form-control" id="txtHoraSaida" style="width:150pt" value="<%=strHoraSaida%>" size="80" maxlength="100">
                        </div>
               		 </div>
                   
                    <legend></legend>
                    <!--#include file="../../includes/inc_botoes_cadastroPopap.asp"-->
                </form>
            	</div>
       	 	</div>
         	<!-- Fecha o Form -->  
      </div>
   	   
       <!--Table Bordered-->
                <div class="panel panel-grey margin-bottom-40">
                    <div class="panel-heading">
                        <h3 class="panel-title"><i class="fa fa-globe"></i> Lista Rota a Unidade</h3>
                    </div>
                    <div class="panel-body">
                        <table class="table table-bordered">
                            <thead>
                                <tr>
                                    <th width="5%" bgcolor="#95A5A6">Rota</th>
                                    <th width="86%" bgcolor="#95A5A6">Unidade</th>
                                    <th width="86%" bgcolor="#95A5A6">Hora Saida</th>
                                    <th width="86%" bgcolor="#95A5A6">Hora Chegada</th>
                                    <th width="9%" bgcolor="#95A5A6" align="center"><div align="center">Ação</div></th>
                                </tr>
                            </thead>
                            <%
							sql = "SELECT CodRota, CodEmpresa, HoraSaida, HoraChegada, se.RAZAOSOCIAL as Empresa"
							sql = sql & " FROM SCA_ROTA_VICULA_EMPRESA RV"
							sql = sql & " INNER JOIN SEG_EMPRESA se ON se.CODIGO = RV.CodEmpresa"
							sql = sql & " Where CodRota = " & intCodRota			
							sql = sql & " Order by CodRota"
							rs.open sql, cnn
							cont=0
							if rs.eof = false then
							
							while not rs.eof
							cont = cont + 1	
							%>
                            <tbody>
                                <tr>
                                    <td><%=trim(rs("CodRota"))%></td>
                                    <td><%=trim(rs("Empresa"))%></td>
                                    <td ><%=trim(rs("HoraSaida"))%></td>
                                    <td ><%=trim(rs("HoraChegada"))%></td>
                                    <td >
                                    <button class="btn-u btn-u-sea" onClick="resultadoConsulta(<%=trim(rs("CodRota"))%>)" type="button"><i class="fa fa-file-text-o"></i></button> 
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
	<script>
	function resultadoConsulta(CodRata, CodEmpresa){
		var frm = document.getElementById("frm");
		frm.txtCodRota.value=CodRata;
		frm.cmdEmpresaUsuario.value=CodEmpresa;
		frm.submit();
	}
	
	function salvar(acao){
		
		var frm = document.getElementById("frm");
		
		if (frm.cmdEmpresaUsuario.value == "") {
			alert("A Unidade deve ser informada !");
			frm.cmdEmpresaUsuario.focus();
			return false;
		}
		
		if (frm.txtHoraSaida.value == "") {
			alert("A Hora Saida deve ser informada !");
			frm.txtHoraSaida.focus();
			return false;
		}
		
		if (frm.txtHoraChegada.value == "") {
			alert("A Hora Chegada deve ser informada !");
			frm.txtHoraChegada.focus();
			return false;
		}
		
		frm.action="RotaUnidade_cod.asp?acao=" + acao;
		frm.submit();
		return true;
 	}

</script>
	<!--#include file="../jsModulo.asp"-->
</body>
</html> 