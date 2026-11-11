<!--#include file="../ConfigModulo.asp"-->
    <!--#include file="../../includes/inc_cnn.asp"-->
	<!--#include file="../menuModulos.asp"-->  
    <!--#include file="../../includes/inc_formatadata.asp"--
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
	strPaginaTitulo = "Curso_cad.asp"

	intCodigo	 		= Trim(Request.Form("txtCodigo"))
	strDescricao 		= Trim(Request.Form("txtDescricao"))
	strDescricaoAntiga	= Replace(Trim(Request("txtDescricaoAntiga")),"'","")
	strDescAbreviada	= Trim(Request.Form("txtDescAbreviada"))
	strDescHistorico	= Trim(Request.Form("txtDescHistorico"))

	strSigla			= Trim(Request.Form("txtSigla"))
	intCodGrau			= Trim(Request.Form("cmbGrau"))
	strhabilitacao		= Request.Form("txthabilitacao")
	strReconhecimento	= Request.Form("txtreconhecimento")
	strAutorizacao		= Request.Form("txtautorizacao")
	strDataReconhecimento= Request.Form("txtDataReconhecimento")
	strDataAutorizacao	= Request.Form("txtDataAutorizacao")
	strCHExigida		= Request.Form("txtCHExigida")
	strsimounao         = Request.Form("cmbSimouNao")
		

    if intCodigo <> "" then
		sql = "SELECT *"
		sql = sql & " FROM SCA_CURSO"
		sql = sql & " Where Cod_curso = " & intCodigo
		sql = sql & " And cod_empresa = " & Session("CodEmpresa")			
		rs.open sql, cnn
		
		if rs.eof = false then
					
			intCodigo	 		= rs("Cod_curso")
			strDescricao 		= rs("Descricao")
			strDescricaoAntiga	= rs("Descricao")
			strDescAbreviada	= rs("Desc_Abreviada")
			strDescHistorico	= rs("Desc_Historico")
			strSigla			= rs("Sigla")
			intCodGrau			= rs("Cod_Grau")
			
			strhabilitacao		= rs("habilitacao")
			strreconhecimento	= rs("reconhecimento")
			strautorizacao		= rs("autorizacao")
	
			strDataReconhecimento= formatadataAP(rs("DataReconhecimento"))
			strDataAutorizacao	 = formatadataAP(rs("DataAutorizacao"))
	
			strCHExigida		 = rs("CH_exigida")
			strSimouNao          = rs("processo_seletivo")
			
			strDesabilitaIncluir	= "" 'Desabilita o botão Incluir
			strDesabilitaAlterar 	= "disabled" 'Desabilita o botão Excluir
			strDesabilitaExcluir	= "disabled" 'Desabilita o botão Excluir
	
		else
			strDesabilitaIncluir	= "" 'Desabilita o botão Incluir
			strDesabilitaAlterar 	= "disabled" 'Desabilita o botão Excluir
			strDesabilitaExcluir	= "disabled" 'Desabilita o botão Excluir
		end if 
		rs.close
	end if	
	%>
    <!--=== Content Part ===-->
    <div class="container content">		
    
      <!-- Grey Panel -->            
      <div class="panel panel-grey">
        <div class="panel-heading">
        	<h3 class="panel-title"><i class="fa fa-tasks"></i>Cadastro de Curso</h3>
        </div>
        <!-- Inicia o Painel do Formulario -->     
        <div class="panel-body">
             <!-- Inicia o Form -->     
            <div class="panel-body">                                                        
                <form id="frm" class="margin-bottom-10" method="post">
                	<input name="txtCodigo" type="hidden" class="text" id="txtCodigo" value="<%=intCodigo%>" size="10">
                    
                    <div class="form-group">
                        <label class="form-label">Descri&ccedil;&atilde;o (Uso Interno)</label>
                         <input name="txtDescricao" type="text" class="form-control" id="txtDescricao" style="width:350pt" value="<%=strDescricao%>" size="80" maxlength="100">
                         <input name="txtDescricaoAntiga" type="hidden" class="text" id="txtDescricaoAntiga" size="40" maxlength="40" value="<%=strDescricaoAntiga%>">
                    </div>
                    
                    <div class="form-group">
                        <label class="form-label">Descri&ccedil;&atilde;o Abreviada (Hor&aacute;rio)</label>
                         <input name="txtDescHistorico" type="text" class="form-control" id="txtDescHistorico" style="width:350pt"  size="20" maxlength="20" value="<%=strDescHistorico%>">
                    </div>
                    
                    <div class="form-group">
                        <label class="form-label">Descri&ccedil;&atilde;o (Hist&oacute;rico) </label>
                       <input name="txtDescHistorico" type="text" class="form-control" id="txtDescHistorico" style="width:350pt" value="<%=strDescHistorico%>" size="80" maxlength="100" >  
                    </div>
                                
                    <div class="form-group">
                        <label class="form-label">Sigla</label>
                        <input name="txtSigla" type="text" class="form-control" id="txtSigla" style="width:100pt" value="<%=strSigla%>" size="80" maxlength="100" >
                    </div>
                    
                    <div class="form-group">
                        <label class="form-label">Grau</label>
                        <!--#include file="../includes/inc_cmbGrau.asp" -->
                    </div>
                    
                    <div class="form-group">
                        <label class="form-label">Habilita&ccedil;&atilde;o</label>
                        <input name="txtHabilitacao" type="text" class="form-control" id="txtHabilitacao" style="width:350pt" size="50" maxlength="100" value="<%=strHabilitacao%>">
                    </div>
                    
                     <div class="form-group">
                        <label class="form-label">Reconhecimento</label>
                        <input name="txtReconhecimento" type="text" class="form-control" id="txtReconhecimento" style="width:100pt" size="50" maxlength="100" value="<%=strReconhecimento%>"> Publica&ccedil;&atilde;o&nbsp;
						<input name="txtDataReconhecimento" type="text" class="form-control" id="txtDataReconhecimento"  style="width:100pt" onBlur="return validaData(this)" onKeyPress="return formataCampo(this, 3, 10)" size="11" maxlength="10" value="<%=strDataReconhecimento%>">             do reconhecimento. 
                    </div>
                    
                    <div class="form-group">
                        <label class="form-label">Autoriza&ccedil;&atilde;o</label>
                        <input name="txtAutorizacao" type="text" class="form-control" id="txtAutorizacao" size="50" style="width:100pt" maxlength="100" value="<%=strAutorizacao%>">Publica&ccedil;&atilde;o&nbsp;
						<input name="txtDataAutorizacao" type="text" class="form-control" id="txtDataAutorizacao"  style="width:100pt" onBlur="return validaData(this)" onKeyPress="return formataCampo(this, 3, 10)" size="11" maxlength="10" value="<%=strDataAutorizacao%>">  da autoriza&ccedil;&atilde;o.
                    </div>
                    
                    <div class="form-group">
                        <label class="form-label">C.H. Exigida</label>
                        <input name="txtCHExigida" type="text" class="form-control" id="txtCHExigida" size="5" style="width:50pt" maxlength="4" value="<%=strCHExigida%>" onKeyPress="return formataCampo(this, 2, 4)">
                    </div>
                    
                    <div class="form-group">
                        <label class="form-label">Prcesso Seletivo</label>
                        <!--#include file="../includes/inc_cmbSimouNao.asp"-->
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
                        <h3 class="panel-title"><i class="fa fa-globe"></i> Lista Curso</h3>
                  </div>
                    <div class="panel-body">
                  <table class="table table-bordered">
                            <thead>
                                <tr>
                                	<th width="3%" bgcolor="#95A5A6">#</th>
                                    <th width="26%" bgcolor="#95A5A6">Descrição</th>
                                    <th width="46%" bgcolor="#95A5A6">Descrição Abreviada</th>
                                    <th width="21%" bgcolor="#95A5A6">Sigla</th>
                                  <th width="4%" bgcolor="#95A5A6" align="center"><div align="center">Ação</div></th>
                                </tr>
                            </thead>
                            <%
							
							
							sql = "SELECT Cod_curso, Descricao, Desc_Abreviada, Sigla, cod_empresa"
							sql = sql & " FROM SCA_CURSO"
							sql = sql & " where cod_empresa = " & Session("CodEmpresa")					
							sql = sql & " Order by cod_empresa, Descricao"
							rs.open sql, cnn
							cont=0
							if rs.eof = false then
							
							while not rs.eof
							cont = cont + 1	
							%>
                            <tbody>
                                <tr>
                                    <td><%=trim(rs("Cod_curso"))%></td>
                                    <td><%=trim(rs("Descricao"))%></td>
                                    <td><%=trim(rs("Desc_Abreviada"))%></td> 
                                    <td><%=trim(rs("Sigla"))%></td> 
                                    <td align="center" >
                                    <button class="btn-u btn-u-sea" onClick="resultadoConsulta(<%=trim(rs("Cod_curso"))%>)" type="button"><i class="fa fa-file-text-o"></i></button> 
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
		
		if (frm.txtDescricao.value == "") {
			alert("A Descrição deve ser informada !");
			frm.txtDescricao.focus();
			return false;
		}
		
		if (frm.txtDescAbreviada.value == "") {
			alert("A Descrição Abreviada deve ser informada !");
			frm.txtDescAbreviada.focus();
			return false;
		}
		
		if (frm.txtSigla.value == "") {
			alert("A Sigla deve ser informada !");
			frm.txtSigla.focus();
			return false;
		}
		
		if (frm.cmbGrau.value == "0") {
			alert("O Grau deve ser informado !");
			frm.cmbGrau.focus();
			return false;
		}
				
		frm.action="Curso_cod.asp?acao=" + acao;
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