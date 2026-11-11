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
	
    strPaginaTitulo 		= "TipoAvaliacao_cad.asp"
    strPagina 				= "TipoAvaliacao_cad.asp"
    strExecutarSubmitCurso 	= "S"
    
	intCodigo 					= Trim(Request.Form("txtCodigo"))
    intCodCurso					= Trim(Request("cmbCurso"))
    strDescricao 				= Trim(Request.Form("txtDescricao"))
    strDescricaoAntiga 			= Trim(Request.Form("txtDescricaoAntiga"))
    strPosicao	 				= Trim(Request.Form("cmbPosicao"))
    strSigla					= Trim(Request.Form("txtSigla"))
    intCodAvaliacaoAgrupamento	= Trim(Request.Form("cmbTipoAvaliacaoAgrupamento"))
    strFormula					= Trim(Request.Form("txtFormula"))
    strDigitar					= Trim(Request.Form("txtDigitar"))
    
    if trim(intCodigo) <> "" then
    
        sql = "SELECT *"
        sql = sql & " FROM SCA_TIPO_AVALIACAO"
        sql = sql & " Where codigo = " & intCodigo
        rs.open sql, cnn
        
        if rs.eof = false then	
            if not isnull(rs("cod_curso")) then intCodCurso				= rs("cod_curso")
            strDescricao				= rs("descricao")
            strDescricaoAntiga			= rs("descricao")
            strSigla					= rs("sigla")
            intCodAvaliacaoAgrupamento				= rs("bimestre")
            strPosicao					= rs("posicao")
            strFormula					= rs("formula")
            strDigitar					= trim(rs("digitar"))
            
            strDesabilitaIncluir		= "" 'Desabilita o botão Incluir
            strDesabilitaAlterar 		= "disabled" 'Desabilita o botão Excluir
            strDesabilitaExcluir		= "disabled" 'Desabilita o botão Excluir
    
        end if 
        rs.close
    else
        strDescricao				= ""
        strDescricaoAntiga			= ""
        strSigla					= ""
        intCodAvaliacaoAgrupamento	= "0"
        strPosicao					= ""
        strFormula					= ""
        strDigitar					= ""
    
        strDesabilitaIncluir		= "" 'Desabilita o botão Incluir
        strDesabilitaAlterar 		= "disabled" 'Desabilita o botão Excluir
        strDesabilitaExcluir		= "disabled" 'Desabilita o botão Excluir
    end if 
    
    %>
    <!--=== Content Part ===-->
    <div class="container content">		
    
      <!-- Grey Panel -->            
      <div class="panel panel-grey">
        <div class="panel-heading">
        	<h3 class="panel-title"><i class="fa fa-tasks"></i>Cadastro Tipo Avaliação</h3>
        </div>
        <!-- Inicia o Painel do Formulario -->     
        <div class="panel-body">
             <!-- Inicia o Form -->     
            <div class="panel-body">                                                        
                <form id="frm" class="margin-bottom-10" method="post">
                	<input name="txtCodigo" type="hidden" class="text" id="txtCodigo" value="<%=intCodFormaIngresso%>" size="10">
                   
                    <div class="form-group">
                        <label class="form-label">Curso</label>
                         <!--#include file="../includes/inc_cmdCurso.asp" -->
                    </div>
                    <div class="form-group">
                        <label  class="form-label">Descrição</label>
                         <input name="txtDescricao" type="text" class="form-control" id="txtDescricao" style="width:350pt" value="<%=strDescricao%>" size="80" maxlength="100">
                         <input name="txtDescricaoAntiga" type="hidden" class="text" id="txtDescricaoAntiga" size="40" maxlength="40" value="<%=strDescricaoAntiga%>">
                    </div>
                    
                    <div class="form-group">
                        <label class="form-label">Sigla</label>
                         <input name="txtSigla" type="text" class="form-control" id="txtSigla" style="width:350pt" value="<%=strSigla%>" size="80" maxlength="100">
                    </div>
                    <div class="form-group">
                        <label class="form-label">Tipo</label>
                        <!--#include file="../includes/inc_cmdTipoAvaliacaoAgrupamento.asp" -->
                    </div>
                    
                    <div class="form-group">
                        <label class="form-label">Campo</label>
                        <select name="cmbPosicao" class="form-control" id="cmbPosicao"  style="width:150pt">
						<%for i=1 to 15%>
                        <option value="<%=i%>" <%if strPosicao = i then response.Write("selected") %>>C<%=i%></option>
                        <%next%>
                      </select>
                    </div>
                    
                     <div class="form-group">
                        <label class="form-label">F&oacute;rmula:</label>
                        <input name="txtFormula" type="text" class="form-control" id="txtFormula" size="40"  style="width:350pt"  maxlength="30" value="<%=strFormula%>">
                    </div>
                    
                     <div class="form-group">
                        <label class="form-label">Digitar:</label>
                        <select name="txtDigitar" class="form-control" id="txtDigitar">
                            <option value="S" <%if trim(strDigitar) = "S" then response.Write("selected") %>>Sim</option>
                            <option value="N" <%if trim(strDigitar) = "N" then response.Write("selected") %>>N&atilde;o</option>
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
                        <h3 class="panel-title"><i class="fa fa-globe"></i> Lista Tipo Avaliação</h3>
                    </div>
                    <div class="panel-body">
                        <table class="table table-bordered">
                            <thead>
                                <tr>
                                    <th width="4%" bgcolor="#95A5A6">Curso</th>
                                    <th width="15%" bgcolor="#95A5A6">Descrição</th>
                                    <th width="14%" bgcolor="#95A5A6">Sigla</th>
                                    <th width="18%" bgcolor="#95A5A6">Tipo</th>
                                    <th width="15%" bgcolor="#95A5A6">Campo</th>
                                    <th width="15%" bgcolor="#95A5A6">F&oacute;rmula</th>
                                    <th width="15%" bgcolor="#95A5A6">Digitar</th>
                                    <th width="4%" bgcolor="#95A5A6" align="center"><div align="center">Ação</div></th>
                                </tr>
                            </thead>
                            <%
							if intCodCurso = "" then intCodCurso = "0"
							
							if intCodCurso <> "0" then
							cont =0
			
							sql = "SELECT SCA_TIPO_AVALIACAO_AGRUPAMENTO.DESCRICAO AS AGRUPAMENTO, SCA_TIPO_AVALIACAO.codigo, SCA_TIPO_AVALIACAO.Descricao, SCA_TIPO_AVALIACAO.Sigla, SCA_TIPO_AVALIACAO.bimestre, SCA_TIPO_AVALIACAO.posicao, SCA_TIPO_AVALIACAO.formula, SCA_TIPO_AVALIACAO.digitar, SCA_CURSO.sigla AS CURSO"
							sql = sql & " FROM SCA_TIPO_AVALIACAO"
							sql = sql & " LEFT JOIN SCA_TIPO_AVALIACAO_AGRUPAMENTO ON SCA_TIPO_AVALIACAO_AGRUPAMENTO.CODIGO = SCA_TIPO_AVALIACAO.BIMESTRE"
							sql = sql & " LEFT JOIN SCA_CURSO ON SCA_CURSO.COD_CURSO = SCA_TIPO_AVALIACAO.COD_CURSO"
							sql = sql & " where SCA_CURSO.COD_CURSO = "& intCodCurso
							sql = sql & " Order by posicao"
							rs.open sql, cnn
							cont=0
							if rs.eof = false then
							
							while not rs.eof

							cont = cont + 1	
							if trim(rs("bimestre")) = "1" or trim(rs("bimestre")) = "2" or trim(rs("bimestre")) = "3" or trim(rs("bimestre")) = "4" then
								bimestre = trim(rs("bimestre")) & "º Bimestre"
							else
								bimestre = trim(rs("AGRUPAMENTO"))
							end if
		
							if not isnull(rs("posicao")) then posicao = trim(rs("posicao"))
					
							%>
                            <tbody>
                                <tr>
                                    <td><%=trim(rs("CURSO"))%></td>
                                    <td><%=trim(rs("descricao"))%></td>
                                    <td><%=trim(rs("sigla"))%></td>
                                    <td><%=bimestre%></td>
                                    <td>C<%=posicao%></td>
                                    <td><%=trim(rs("formula"))%></td>
                                    <td><%=trim(rs("digitar"))%></td>
                                    <td align="center" >
                                    <button class="btn-u btn-u-sea" onClick="resultadoConsulta(<%=trim(rs("codigo"))%>)" type="button"><i class="fa fa-file-text-o"></i></button> 
                                    </td> 
                                </tr>
                            </tbody>
                            <%				
								rs.movenext
								wend
							end if
							rs.close
							
						end if
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
		
		if (frm.cmbCurso.value == "0") {
			alert("O curso deve ser informado !");
			frm.cmbCurso.focus();
			return false;
		}
		
		if (frm.txtDescricao.value == "") {
			alert("A Descrição deve ser informada !");
			frm.txtDescricao.focus();
			return false;
		}
		if (frm.txtSigla.value == "") {
			alert("A Sigla deve ser informada !");
			frm.txtSigla.focus();
			return false;
		}
		if (frm.cmbTipoAvaliacaoAgrupamento.value == "0") {
			alert("Tipo de Agrupamento deve ser informado !");
			frm.cmbTipoAvaliacaoAgrupamento.focus();
			return false;
		}
		frm.action="tipoAvaliacao_cod.asp?acao=" + acao;
		frm.submit();
		
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