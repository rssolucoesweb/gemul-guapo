<!--#include file="../../includes/inc_verificaSession.asp"-->
<!--#include file="../ConfigModulo.asp"-->
<!--#include file="../../includes/inc_cnn.asp"-->
<!--#include file="../../includes/inc_formatadata.asp"-->
<!--#include file="../menuModulos.asp"-->
<!--#include file="../includes/inc_sqlAlunoTurma.asp"-->
<script src="../../js/js_funcoes_gerais.js"></script>  
	<%
        strPaginaTitulo = "Rel_Justificativa_con.asp"
        pagina = "Rel_Justificativa_con.asp"
        strExecutarSubmitCurso	  = "S"
        strExecutarSubmitPeriodo  = "S"
        strExecutarSubmitTurno	  = "S"
        strExecutarSubmitTurma	  = "S"
        strExecutarSubmitGradeCurricular = "S"
    
	intCodEmpresaGrupo	 	    = TRIM(Request.Form("cmbEmpresaGrupo"))
	strAnoLetivo	= Trim(Request("txtAnoLetivo"))
	if strAnoLetivo = "" then
		if Trim(Request("txtAnoLetivo"))  = "" then
			strAnoLetivo	= session("strAnoLetivo")
		else
			strAnoLetivo	= Trim(Request("txtAnoLetivo"))
		end if
	else
		strAnoLetivo	= Trim(Request("txtAnoLetivo"))
	end if
	
	intCodColaborador				= Trim(Request("txtCodFuncionario"))
	intCodJustificativaFaltas		= Trim(Request("cmbJustificativaFaltas"))
	intTipoColaborador				= Trim(Request("cmbTipoColaborador"))
	strNome							= Trim(Request("txtNomeFuncionario"))
	strcpf  						= Trim(Request.Form("txtcpf"))
	intCodFuncional  				= Trim(Request.Form("txtCodigoFuncional"))
	if Trim(Request.form("txtCodFuncionario")) = "" then
		intCodColaborador 					= Trim(Request("txtCodFuncionario"))
	else
		intCodColaborador 					= Trim(Request.form("txtCodFuncionario"))
	end if	
	
	if intAnoLetivo = "" then intAnoLetivo = session("strAnoLetivo")
	
	if intCodFuncional <> "" then
		sql = "select c.codigo, c.nome, c.cpf, f.Tipo_Funcao, c.cod_nivel, c.codFuncao, c.situacao, c.codFuncional, tu.Desc_Turno as turno, c.cpf, n.Descricao as nivel, f.Desc_Funcao as funcao, ca.desc_categoria as categoria, isnull(n.total_aulas,0) as total_aulas_nivel, isnull(c.total_aulas,0) as total_aulas, c.cod_empresa"
		sql = sql & " from srh_colaborador c"
		sql = sql & " left join srh_nivel n on n.codigo = c.cod_nivel"
		sql = sql & " left join SRH_FUNCAOCOLABORADOR f on f.cod_funcao = c.codfuncao"
		sql = sql & " left join SRH_CATEGORIA ca on ca.Cod_Categoria = c.CodCategoria "
		sql = sql & " left join SRH_TURNO tu on tu.Cod_Turno = c.CodTurno "
		sql = sql & " INNER JOIN SEG_EMPRESA E ON E.CODIGO = C.CODLOTACAO "
		sql = sql & " where C.CodFuncional = " & intCodFuncional
		sql = sql & " And C.Situacao = 'A'"
		sql = sql & " and E.COD_GRUPO = " & session("codGrupo")
		if session("NivelPermissao") = "A" then
		else
			sql = sql & " and c.codLotacao = " & session("codEmpresa")
		end if
		rs.open sql, cnn
		if rs.eof = false then
			intCodColaborador	= rs("Codigo")
			intCodEmp           = rs("Cod_Empresa")
			strnome 			= Trim(Rs("nome"))
			intCodFuncional		= Trim(Rs("CodFuncional"))

			
		else
			%>
				<script>
				alert("Matrícula não Localizada. Verifique!")
				window.location='Rel_Justificativa_con.asp';
			</script>
<%
			response.end	
		end if
		rs.close
	end if
%>
    
<div class="wrapper">

	<div class="breadcrumbs">
        <div class="container">
            <h1 class="pull-left">SCA - Controle Acadêmico</h1>
            <ul class="pull-right breadcrumb">
                <li><a href="../SCA/Default.asp">Home</a></li>
                <li class="active"><%=session("CodEmpresa")%> - <%=session("EmpresaWeb")%></li>
            </ul>
        </div><!--/container-->
    </div><!--/breadcrumbs-->

    <!--=== Content Part ===-->
    <div class="container content">
        <div class="row">
            <!-- Begin Content -->
            <div class="col-md-12" >
                <!-- General Unify Forms -->
            <form action="#" id="frm"  class="sky-form  panel-body">
                  <input name="txtCodFuncionario" value="<%=intCodColaborador%>" type="hidden" id="txtCodFuncionario" >
                  <input name="txtCodEmpresa" value="<%=intCodEmp%>" type="hidden" id="txtCodEmpresa" >
                  <input name="txtcodLotacaoAnterior" value="<%=intcodLotacaoAnterior%>" type="hidden" id="txtcodLotacaoAnterior" >
                
                <input name="txtTipoRelatorio" type="hidden" value="<%=intTipoRelatorio%>">
                    <header class="panel-title"><font color="#FFFFFF"><i class="fa fa-tasks"></i>&nbsp;Relatório de Unidades</font></header>
                    
                    <fieldset>
                   	 <div class="row">


                        <section class="col col-12">
                            <label class="label">Tipo de Unidade</label>
                            <label class="input">
                            	<!--#include file="../includes/inc_cmbTipoEmpresa.asp" -->
                            </label>
                        </section>

                      </div>
                      
                      
                    </fieldset>
                    

                      
					 <legend></legend>
                    <!--#include file="../../includes/inc_botoes_geraRelatorio.asp"-->
                </form>
                <!-- End Responsive Grid System -->
            </div>
            <!-- End Content -->
            
        </div>          
    </div><!--/container-->     
    <!--=== End Content Part ===-->

</div><!--/End Wrapepr-->
    
   
	<script>
    
		function gerar(){
				
			var frm = document.getElementById("frm");
			
			frm.action = "Rel_Unidades_rel.asp";
			frm.submit();
			return true;	
		}
			
		function abreConsultaColaborador(caminho){
			window.open(caminho,"abreConsulta","top=5,left=5,height=510,width=719,menubar=no,toolbar=no,scrollbars=yes,status=yes");
		}
    </script>
    
    <!--=== End Content Part ===-->
   	<!--#include file="../RodapeModulo.asp"-->
	<!--#include file="../jsModulo.asp"-->
</body>
</html> 