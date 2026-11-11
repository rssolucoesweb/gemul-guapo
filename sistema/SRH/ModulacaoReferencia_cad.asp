<!--#include file="../../includes/inc_verificaSession.asp"-->
<!--#include file="../ConfigModulo.asp"-->
<!--#include file="../../includes/inc_cnn.asp"-->
<!--#include file="../../includes/inc_formatadata.asp"-->
<!--#include file="../menuModulos.asp"-->
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
        strPaginaTitulo 		= "ModulacaoReferencia_cad.asp"
        intCodigo	 			= Trim(Request.Form("txtCodigo"))
        intCodGrupo				= Session("CodGrupo")
        strAno	 				= Trim(Request("txtAno"))
        if Trim(Request("cmbSemestre")) <> "0" then
            intSemestre 		= Trim(Request("cmbSemestre"))
        else	
            intSemestre 		=  Session("strSemestre")
        end if	
        strMes		 			= Trim(Request("cmbMes"))
        strDadaInicial			= formataDataAP(Trim(Request.Form("txtDataInicial")))  
        strFinalFinal			= formataDataAP(Trim(Request.Form("txtDataFinal"))) 
        strSituacao				= Trim(Request.Form("cmbSituacao"))
    
        if strAno = "" then strAno = session("strAnoLetivo")
        if intSemestre = "" then intSemestre = Session("strSemestre")
        
        if trim(intCodigo) <> "" then
        
            sql = "SELECT Codigo, Cod_Grupo, AnoReferencia, SemestreReferencia ,MesReferencia, Data_Inicial, Data_Final, Situacao"
            sql = sql & " FROM SRH_MODULACAO_REFERENCIA"
            sql = sql & " where Cod_grupo = " & intCodGrupo			
            sql = sql & " and Codigo = " & intCodigo
            rs.open sql, cnn
        
            if rs.eof = false then
            
                intCodigo	 			= rs("Codigo")
                intCodGrupo				= rs("Cod_grupo")
                strAno 					= rs("AnoReferencia")
                intSemestre 			= rs("SemestreReferencia")
                strMes 					= rs("MesReferencia")
                strDataInicial			= formataDataAP(trim(rs("Data_Inicial")))
                strDataFinal			= formataDataAP(trim(rs("Data_Final")))
                strSituacao				= rs("Situacao")
    
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
        	<h3 class="panel-title"><i class="fa fa-tasks"></i>Frequência - Período de Modulação</h3>
        </div>
        <!-- Inicia o Painel do Formulario -->     
        <div class="panel-body">
             <!-- Inicia o Form -->     
            <div class="panel-body">                                                        
                <form id="frm" method="post">
                	<input name="txtCodigo" type="hidden" id="txtCodigo" class="text" size="10" value="<%=intCodigo%>" maxlength="10">
              
                    <div class="form-group">
                        <label class="form-label">Ano</label>
                        <input  name="txtAno" type="text" class="form-control" id="txtAno" value="<%=strAno%>" size="5" maxlength="5" onkeypress="return formataCampo(this,2,10)" onchange="submit()">
                    </div>
                    
                     <div class="form-group">
                        <label class="form-label">Semestre</label>
                        <!--#include file="../includes/inc_cmdSemestre.asp" -->
                    </div>
                    
                     <div class="form-group">
                        <label class="form-label">Refer&ecirc;ncia</label>
                        <!--#include file="../includes/inc_cmbMes.asp" -->
                    </div>
                    
                     <div class="form-group">
                        <label class="form-label">Periodicidade Inicial</label>
                        <input name="txtDataInicial" type="text" class="form-control" id="txtDataInicial" onblur="return validaData(this)" onkeypress="return formataCampo(this, 3, 10)" size="11" maxlength="10" value="<%=strDataInicial%>" title="Click aqui para visualizar o calend&aacute;rio">
                    </div>
                    
                    <div class="form-group">
                        <label class="form-label">Periodicidade Final</label>
                        <input name="txtDataFinal" type="text" class="form-control" id="txtDataFinal" onblur="return validaData(this)" onkeypress="return formataCampo(this, 3, 10)" size="11" maxlength="10" value="<%=strDataFinal%>" title="Click aqui para visualizar o calend&aacute;rio">
                    </div>
                    
                    <div class="form-group">
                        <label class="form-label">Situa&ccedil;&atilde;o</label>
                        <!--#include file="../includes/inc_cmdSituacao.asp" -->
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
                <h3 class="panel-title"><i class="fa fa-globe"></i> Lista Frequência</h3>
            </div>
            <div class="panel-body">
                <table class="table table-bordered">
                    <thead>
                        <tr>
                          <th width="5%" bgcolor="#95A5A6">Código</th>
                          <th width="15%" bgcolor="#95A5A6">Ano</th>
                          <th width="15%" bgcolor="#95A5A6">Semestre</th>
                          <th width="15%" bgcolor="#95A5A6">Refer&ecirc;ncia</th>
                          <th width="19%" bgcolor="#95A5A6">Data Inicial</th>
                          <th width="18%" bgcolor="#95A5A6">Data Final</th>
                          <th width="9%" bgcolor="#95A5A6">Situa&ccedil;&atilde;o</th>
                          <th width="4%" bgcolor="#95A5A6" align="center"><div align="center">Ação</div></th>
                      </tr>
                    </thead>
                     <tbody>
                    <%
						cont =0
						sql = "SELECT Codigo, Cod_Grupo, AnoReferencia, MesReferencia, Data_Inicial, Data_Final, Situacao"
						sql = sql & " FROM SRH_MODULACAO_REFERENCIA"
						sql = sql & " where Cod_grupo = " & intCodGrupo		
						sql = sql & " and AnoReferencia = " & strAno	
						rs.open sql, cnn
						if rs.eof = false then
						
						while not rs.eof
							cont = cont + 1	
							if trim(intSemestre) = "3" then
							   nomeSemestre = "Anual"
							else  
							   nomeSemestre = intSemestre
							end if  
							%>
							<tr>
								<td><%=trim(rs("Codigo"))%></td>
								<td><%=trim(rs("AnoReferencia"))%></td>
                                <td><%=nomeSemestre%></td>
                                <td><%=ucase(monthname(rs("MesReferencia")))%></td>
                                <td><%=FormataDataAP(rs("Data_Inicial"))%></td>
                                <td><%=FormataDataAP(rs("Data_Final"))%></td>
                                <td><%=trim(rs("SITUACAO"))%></td>
								<td align="center" >
								<button class="btn-u btn-u-sea" onclick="resultadoConsulta(<%=trim(rs("Codigo"))%>)" type="button"><i class="fa fa-file-text-o"></i></button>                            </td> 
							</tr>
							<%				
							rs.movenext
							wend
						end if
						rs.close
						%>
                    	<tr>
                    		<td colspan="8">Total Registros : <%=cont%></td>
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
            
            if (frm.txtAno.value == "") {
                alert("O Ano deve ser informado!");
                frm.txtAno.focus();
                return false;
            }
            
            if (frm.cmbMes.value == "0") {
                alert("O Mês deve ser informado!");
                frm.cmbMes.focus();
                return false;
            }
            
            if (frm.txtDataInicial.value == "") {
                alert("A Periodicidade Inicial deve ser informada !");
                frm.txtPeriodicidadeInicial.focus();
                return false;
            }
            
            if (frm.txtDataFinal.value == "") {
                alert("A Periodicidade Final deve ser informada !");
                frm.txtPeriodicidadeFinal.focus();
                return false;
            }
            
            if (frm.cmbSituacao.value == "0") {
                alert("A Situacao deve ser informada!");
                frm.cmbMes.focus();
                return false;
            }
    
            frm.action="ModulacaoReferencia_cod.asp?acao=" + acao;
            frm.submit();
            return true;
        }
	</script>
    <!--=== End Content Part ===-->
   	<!--#include file="../RodapeModulo.asp"-->
	<!--#include file="../jsModulo.asp"-->
</body>
</html> 