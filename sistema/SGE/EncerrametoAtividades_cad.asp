<!--#include file="../ConfigModulo.asp"-->
    <!--#include file="../../includes/inc_cnn.asp"-->
	<!--#include file="../menuModulos.asp"-->  
    <!--#include file="../../includes/inc_formatadata.asp"-->
    <script src="../../js/js_funcoes_gerais.js"></script>
    <!--=== Breadcrumbs ===-->
    <div class="breadcrumbs">
        <div class="container">
            <h1 class="pull-left">Modulo Gerencial</h1>
            <ul class="pull-right breadcrumb">
                <li><a href="Default.asp">Home</a></li>
                <li class="active"><%=session("CodEmpresa")%> - <%=session("EmpresaWeb")%></li>
            </ul>
        </div><!--/container-->
    </div><!--/breadcrumbs-->
    <!--=== End Breadcrumbs ===-->
	<%
        strPaginaTitulo 				= "EncerrametoAtividades_cad.asp"
        intCodigo	 					= Trim(Request.Form("txtCodigo"))
		
        intAno							= Trim(Request.Form("txtAno"))
        intSemestre						= Trim(Request.Form("cmbSemestre"))
        strDataEncerramento				= Trim(Request.Form("txtDataEncerramento"))
        strSimouNaoDocente				= Trim(Request.Form("cmbSimouNaoDocente"))
        strSimouNaoSecretaria    		= Trim(Request.Form("cmbSimouNaoSecretaria"))
        strSimouNaoCampoAcumuladaFalta 	= Trim(Request.Form("cmbSimouNaoCampoAcumuladaFalta"))
        strMes							= Trim(Request("cmbMes"))
            
        if trim(intCodigo) <> "" then
        
            sql = "SELECT Codigo, cod_empresa, ano_letivo, semestre, data_encerramento, Bloqueia_NotasDocente, Bloqueia_NotasSecretaria, Bloqueia_CampoAcumuladaFalta, Bloqueia_ConteudoProgramatico"
            sql = sql & " FROM SEG_ENCERRAMENTOATIVIDADES"
            sql = sql & " where cod_empresa = " & Session("CodEmpresa")			
            sql = sql & " and codigo = " & intCodigo
            rs.open sql, cnn
            
            if rs.eof = false then
                
                intCodigo						= rs("Codigo")
                intAno							= rs("ano_letivo")
                intSemestre						= rs("semestre")
                strDataEncerramento				= formataDataAP(rs("data_encerramento"))
                strSimouNaoDocente				= rs("Bloqueia_NotasDocente")
                strSimouNaoSecretaria			= rs("Bloqueia_NotasSecretaria")
                strSimouNaoCampoAcumuladaFalta	= rs("Bloqueia_CampoAcumuladaFalta")
                strMes							= rs("Bloqueia_ConteudoProgramatico")
                
                strDesabilitaIncluir	= "disabled" 'Desabilita o botão Incluir
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
        	<h3 class="panel-title"><i class="fa fa-tasks"></i>Cadastro Encerramento das Atividades</h3>
        </div>
        <!-- Inicia o Painel do Formulario -->     
        <div class="panel-body">
             <!-- Inicia o Form -->     
            <div class="panel-body">                                                        
                <form id="frm" class="margin-bottom-10" method="post">
                	<input name="txtCodigo" type="hidden" class="text" id="txtCodigo" value="<%=intCodigo%>" size="10">
                    
                    <div class="form-group">
                        <label class="form-label">Ano</label>
                         <input name="txtAno" type="text" onKeyPress="return formataCampo(this,2,4)" class="form-control" id="txtAno" style="width:50pt" value="<%=intAno%>" size="80" maxlength="100" onBlur="submit()">
                    </div>
                    
                    <div class="form-group">
                        <label class="form-label">Semestre</label>
                         <!--#include file="../includes/inc_cmdSemestreTodos.asp" -->
                    </div>
					
                     <div class="form-group">
                        <label class="form-label">Data de Encerramento</label>
                         <input name="txtDataEncerramento" type="text" class="form-control" id="txtDataEncerramento" style="width:100pt" value="<%=strDataEncerramento%>" size="80" maxlength="100" onBlur="return validaData(this)" onKeyPress="return formataCampo(this, 3, 10)" >
                    </div>
                    
                     <div class="form-group">
                        <label class="form-label">Bloqueia Lancto Notas Docentes?</label>
                        <select name="cmbSimouNaoDocente" class="form-control" id="cmbSimouNaoDocente"  style="width:70pt" onchange='' >
                            <option value="0">Selecione...</option>
                            <option value="S" <%if strSimouNaoDocente = "S" then response.Write("selected") %>>SIM</option>
                            <option value="N" <%if strSimouNaoDocente = "N" then response.Write("selected") %>>NAO</option>
                        </select>
                    </div>
                    
                    <div class="form-group">
                        <label class="form-label"> Bloqueia Lancto Notas Secretaria?</label>
                        <select name="cmbSimouNaoSecretaria" class="form-control" id="cmbSimouNaoSecretaria"  style="width:70pt" onchange='' >
                            <option value="0">Selecione...</option>
                            <option value="S" <%if strSimouNaoSecretaria = "S" then response.Write("selected") %>>SIM</option>
                            <option value="N" <%if strSimouNaoSecretaria = "N" then response.Write("selected") %>>NAO</option>
                        </select>
                    </div>
                    
                     <div class="form-group">
                        <label class="form-label">Bloquear Conte&uacute;do Program&aacute;tico at&eacute; o m&ecirc;s:</label>
                         <!--#include file="../includes/inc_cmbMes.asp"-->
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
                        <h3 class="panel-title"><i class="fa fa-globe"></i> Lista Encerrameto das Atividades</h3>
                    </div>
                    <div class="panel-body">
                        <table class="table table-bordered">
                            <thead>
                                <tr>
                                    <th width="3%" bgcolor="#95A5A6">Ano</th>
                                    <th width="41%" bgcolor="#95A5A6">Semestre</th>
                                    <th width="47%" bgcolor="#95A5A6">Data de Encerramento</th>
                                    <th width="9%" bgcolor="#95A5A6" align="center"><div align="center">Ação</div></th>
                                </tr>
                            </thead>
                            <%
							
							cont =0
							sql = "SELECT Codigo, cod_empresa, ano_letivo, semestre, data_encerramento"
							sql = sql & " FROM SEG_ENCERRAMENTOATIVIDADES"
							sql = sql & " where cod_empresa = " & Session("CodEmpresa")			
							sql = sql & " Order by ano_letivo"
							rs.open sql, cnn
							if rs.eof = false then
							
							while not rs.eof
							cont = cont + 1	
							%>
                            <tbody>
                                <tr>
                                    <td><%=trim(rs("ano_letivo"))%></td>
                                    <td><%=trim(rs("semestre"))%></td>
                                    <td><%=formataDataAP(trim(rs("data_encerramento")))%></td> 
                                    <td align="center" >
                                    <button class="btn-u btn-u-sea" onClick="resultadoConsulta(<%=trim(rs("Codigo"))%>)" type="button"><i class="fa fa-file-text-o"></i></button> 
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
	function resultadoConsulta(intCodigo){
	
		var frm = document.getElementById("frm");
		
		frm.txtCodigo.value=intCodigo;
		frm.submit();
	}
	
	function salvar(acao){
		
		var frm = document.getElementById("frm");
		
		if (frm.txtAno.value == "") {
			alert("O Ano letivo deve ser informado!");
			frm.txtAno.focus();
			return false;
		}
		
		if (frm.cmbSemestre.value == "0") {
			alert("O Semestre deve ser informado!");
			frm.cmbSemestre.focus();
			return false;
		}
		
		if (frm.txtDataEncerramento.value == "") {
			alert("A Data de Encerramento deve ser informada!");
			frm.txtDataEncerramento.focus();
			return false;
		}
		
		frm.action="EncerrametoAtividades_cod.asp?acao=" + acao;
		frm.submit();
		return true;
 	}
	
	alert("ATENÇÃO: \nEssa aplicação tem a função de ALTERAR o  ANO e o SEMESTRE letivo,\n o seu uso indevido poderá causar INCONSISTÊNCIA em suas informações.\n\nUSAR SOMENTE APÓS FECHAMENTO DO SEU ANO OU SEMESTRE");

</script>

    <!--=== End Content Part ===-->
   	<!--#include file="../RodapeModulo.asp"-->
	<!--#include file="../jsModulo.asp"-->
</body>
</html> 