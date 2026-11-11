<!--#include file="../ConfigModulo.asp"-->
    <!--#include file="../../includes/inc_cnn.asp"-->
	<!--#include file="../menuModulos.asp"-->  
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
	strPaginaTitulo = "Disciplina_cad.asp"

	intCodDisciplina	= Trim(Request.Form("txtCodigo"))
	strDescricao 		= Trim(Request.Form("txtDescricao"))
	strDescricaoAntiga	= Trim(Request.Form("txtDescricaoAntiga"))
	strDescAbreviada	= Trim(Request.Form("txtDescAbreviada"))
	strDescHistorico	= Trim(Request.Form("txtDescHistorico"))
		
	if trim(intCodDisciplina) <> "" then
	
		sql = "SELECT COD_Disciplina, DESC_Disciplina, Desc_Abreviada, Desc_historico"
		sql = sql & " FROM SCA_DISCIPLINA"
		sql = sql & " Where COD_Disciplina = " & intCodDisciplina
		
		rs.open sql, cnn
		
		if rs.eof = false then
			
			intCodDisciplina		= rs("COD_Disciplina")
			strDescricao			= rs("DESC_Disciplina")
			strDescricaoAntiga		= rs("DESC_Disciplina")
			strDescAbreviada		= rs("Desc_Abreviada")
			strDescHistorico		= rs("Desc_Historico")
			
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
        	<h3 class="panel-title"><i class="fa fa-tasks"></i>Cadastro de Disciplinas</h3>
        </div>
        <!-- Inicia o Painel do Formulario -->     
        <div class="panel-body">
             <!-- Inicia o Form -->     
            <div class="panel-body">                                                        
                <form id="frm" class="margin-bottom-10" method="post">
                	<input name="txtCodigo" type="hidden" class="text" id="txtCodigo" value="<%=intCodDisciplina%>" size="10">
                    <div class="form-group">
                        <label class="form-label">Descri&ccedil;&atilde;o (Uso Interno)</label>
                         <input name="txtDescricao" type="text" class="form-control" id="txtDescricao" style="width:350pt" value="<%=strDescricao%>" size="80" maxlength="100">
                         <input name="txtDescricaoAntiga" type="hidden" class="text" id="txtDescricaoAntiga" size="40" maxlength="40" value="<%=strDescricaoAntiga%>">
                    </div>
                    
                    <div class="form-group">
                        <label class="form-label">Descri&ccedil;&atilde;o Abreviada (Hor&aacute;rio)</label>
                         <input name="txtDescAbreviada" type="text" class="form-control" id="txtDescAbreviada" style="width:350pt" value="<%=strDescAbreviada%>" size="80" maxlength="100">
                    </div>
                    
                    <div class="form-group">
                        <label class="form-label">Descri&ccedil;&atilde;o (Hist&oacute;rico)</label>
                         <input name="txtDescHistorico" type="text" class="form-control" id="txtDescHistorico" style="width:350pt" value="<%=strDescHistorico%>" size="80" maxlength="100">
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
                        <h3 class="panel-title"><i class="fa fa-globe"></i> Lista Disciplinas</h3>
                    </div>
                    <div class="panel-body">
                        <table class="table table-bordered">
                            <thead>
                                <tr>
                                    <th width="24%" bgcolor="#95A5A6">Descrição (Uso Interno)</th>
                                    <th width="41%" bgcolor="#95A5A6">Descrição (Horário)</th>
                                    <th width="31%" bgcolor="#95A5A6">Descrição (Histórico)</th>
                                  <th width="4%" bgcolor="#95A5A6" align="center"><div align="center">Ação</div></th>
                                </tr>
                            </thead>
                            <%
							sql = "SELECT COD_Disciplina, DESC_Disciplina, Desc_Abreviada, Desc_historico"
							sql = sql & " FROM SCA_DISCIPLINA"
							sql = sql & " Order by DESC_Disciplina"
							rs.open sql, cnn
							cont=0
							if rs.eof = false then
							
							while not rs.eof
							cont = cont + 1	
							%>
                            <tbody>
                                <tr>
                                    <td><%=trim(rs("DESC_Disciplina"))%></td>
                                    <td><%=trim(rs("Desc_Abreviada"))%></td>
                                    <td><%=trim(rs("Desc_Historico"))%></td>
                                    <td align="center" >
                                    <button class="btn-u btn-u-sea" onClick="resultadoConsulta(<%=trim(rs("COD_Disciplina"))%>)" type="button"><i class="fa fa-file-text-o"></i></button> 
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
			alert("A Descrição (Uso interno) deve ser informada !");
			frm.txtDescricao.focus();
			return false;
		}
		
		if (frm.txtDescAbreviada.value == "") {
			alert("A Descrição (Horário) deve ser informada !");
			frm.txtDescAbreviada.focus();
			return false;
		}
		if (frm.txtDescHistorico.value == "") {
			alert("A Descrição (Histórico) Abreviada deve ser informada !");
			frm.txtDescAbreviada.focus();
			return false;
		}
		
		frm.action="Disciplina_cod.asp?acao=" + acao;
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