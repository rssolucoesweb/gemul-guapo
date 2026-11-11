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
        strPaginaTitulo 			= "DiretrizesFisica_cad.asp"
        intCodEmpresa				= session("codEmpresa")
        intCodigo	 				= Trim(Request.Form("txtCodigo"))
		intAnoLetivo	 				= Trim(Request.Form("txtAnoLetivo"))
		if intAnoLetivo = "" then intAnoLetivo = session("strAnoLetivo")
        
        
        if trim(intCodigo) <> "" then
        
            sql = "SELECT *"
            sql = sql & " FROM SRH_DIRETRIZES_ESTRUTURA_FISICA"
            sql = sql & " where Codigo = " & intCodigo
            rs.open sql, cnn
            
            if rs.eof = false then
                
                intCodigo	 					= rs("Codigo")
				intAnoLetivo 					= rs("ano_letivo")
                intCodDependencia				= rs("cod_dependencias_fisicas")
				intCodTipoDependencia			= rs("cod_tipo_dependencias_fisicas")
				
                intComprimento 					= formatNumber(rs("comprimento"),2)
                intLargura	 					= formatNumber(rs("largura"),2)
				intArea	 						= formatNumber(rs("area"),2)
				strSituacao						= rs("situacao")
        
                strDesabilitaIncluir			= "disabled" 'Desabilita o botão Incluir
                strDesabilitaAlterar 			= "" 'Desabilita o botão Excluir
                strDesabilitaExcluir			= "" 'Desabilita o botão Excluir
    
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
        	<h3 class="panel-title"><i class="fa fa-tasks"></i>Diretrizes – Estrutura Física</h3>
        </div>
        <!-- Inicia o Painel do Formulario -->     
        <div class="panel-body">
             <!-- Inicia o Form -->     
            <div class="panel-body">                                                        
                <form id="frm" class="margin-bottom-10" method="post">
                
                    <input name="txtCodigo" type="hidden" id="txtCodigo" class="text" size="10" value="<%=intCodigo%>" maxlength="10">
                    <div class="form-group">
                        <label class="form-label">Ano Letivo</label>
                    	<input name="txtAnoLetivo" type="text" class="form-control" id="txtAnoLetivo"  onKeyPress="return formataCampo(this, 2, 3)" size="5" maxlength="5" value="<%=intAnoLetivo%>">
                    </div>
                    <div class="form-group">
                        <label class="form-label">Depend&ecirc;ncia</label>
                        <!--#include file="../includes/inc_cmbDependenciasFisicas.asp" -->
                    </div>
					
					<div class="form-group">
                        <label class="form-label">Tipo</label>
                        <!--#include file="../includes/inc_cmbTipoDependenciasFisicas.asp" -->
                    </div>
                    
                    
                    <div class="form-group">
                        <label class="form-label">Comprimento (m)</label>
                    	<input name="txtComprimento" type="text" class="form-control" id="txtComprimento"  onKeyPress="return formataCampo(this, 6, 8)" size="8" maxlength="8" value="<%=intComprimento%>">
                    </div>

                    <div class="form-group">
                        <label class="form-label">Largura (m)</label>
                    	<input name="txtLargura" type="text" class="form-control" id="txtLargura"  onKeyPress="return formataCampo(this, 6, 8)" size="8" maxlength="8" value="<%=intLargura%>">
                    </div>

                    <div class="form-group">
                        <label class="form-label">Área (m2)</label>
                    	<input name="txtArea" type="text" class="form-control" id="txtArea"  onKeyPress="return formataCampo(this, 6, 8)" size="8" maxlength="8" value="<%=intArea%>">
                    </div>
					<div class="form-group">
                        <label class="form-label">Situação</label>
                        <!--#include file="../includes/inc_cmbSituacao.asp" -->
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
                <h3 class="panel-title"><i class="fa fa-globe"></i> Lista de Diretrizes – Estrutura Física</h3>
            </div>
            <div class="panel-body">
                <table class="table table-bordered">
                    <thead>
                        <tr>
                          <th width="5%" bgcolor="#95A5A6">Id</th>
                          <th width="30%" bgcolor="#95A5A6">Depend&ecirc;ncias ( Descri&ccedil;&atilde;o )</th>
                          <th width="15%" bgcolor="#95A5A6">Tipo</th>
                          <th width="10%" bgcolor="#95A5A6">Comprimento<br>(m)</th>
                          <th width="10%" bgcolor="#95A5A6">Largura<br>(m)</th>
                          <th width="10%" bgcolor="#95A5A6">Área<br>(m2)</th>
                          <th width="6%" bgcolor="#95A5A6" align="center"><div align="center">Ação</div></th>
                      </tr>
                    </thead>
                     <tbody>
                    <%
                    cont =0
					sql = "SELECT e.Codigo, e.id, df.descricao as dependencia, td.descricao as tipo, e.comprimento, e.largura, e.area"
					sql = sql & " FROM SRH_DIRETRIZES_ESTRUTURA_FISICA E"
					sql = sql & " INNER JOIN SRH_DEPENDENCIAS_FISICAS DF ON DF.Codigo = E.Cod_Dependencias_fisicas"
					sql = sql & " INNER JOIN SRH_TIPO_DEPENDENCIAS_FISICAS TD ON TD.Codigo = E.Cod_tipo_Dependencias_fisicas"
					sql = sql & " WHERE e.COD_EMPRESA = " & intCodEmpresa
					sql = sql & " and e.ano_letivo = " & intAnoLetivo
					sql = sql & " ORDER BY e.id"
                    rs.open sql, cnn
                    if rs.eof = false then
                    
                    while not rs.eof
                        cont = cont + 1
						%>
                        <tr>
                            <td><%=trim(rs("id"))%></td>
                            <td><%=trim(rs("dependencia"))%></td>
							<td><%=trim(rs("tipo"))%></td>
                            <td><%=formatNumber(rs("comprimento"),2)%></td>
							<td><%=formatNumber(rs("largura"),2)%></td>
                            <td><%=formatNumber(rs("area"),2)%></td>
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
                        <td colspan="6">Total Registros : <%=cont%></td>
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
            if (frm.txtAnoLetivo.value == "0") {
                alert("o Ano Letivo deve ser informado!");
                frm.txtAnoLetivo.focus();
                return false;
            }
            if (frm.cmbDependenciasFisicas.value == "0") {
                alert("A Dependência deve ser informada!");
                frm.cmbDependenciasFisicas.focus();
                return false;
            }
			if (frm.cmbTipoDependenciasFisicas.value == "0") {
                alert("O Tipo da Dependência deve ser informada!");
                frm.cmbTipoDependenciasFisicas.focus();
                return false;
            }
    
            
            if (frm.txtComprimento.value == "") {
                alert("O comprimento deve ser informado!");
                frm.txtComprimento.focus();
                return false;
            }
			if (frm.txtLargura.value == "") {
                alert("A largura deve ser informada!");
                frm.txtLargura.focus();
                return false;
            }
			if (frm.txtArea.value == "") {
                alert("A Área deve ser informada!");
                frm.txtArea.focus();
                return false;
            }
            
            frm.action="DiretrizesFisica_cod.asp?acao=" + acao;
            frm.submit();
            return true;
        }
		
		const inputComprimento = document.getElementById('txtComprimento');
		const inputLargura = document.getElementById('txtLargura');
		const inputArea = document.getElementById('txtArea');

		inputComprimento.addEventListener('input', () => {
		  let valor = inputComprimento.value.replace(/\D/g, ''); // Remove tudo que não for número

		  if (valor.length < 3) {
			valor = valor.padStart(3, '0'); // Garante ao menos 3 dígitos (ex: "001")
		  }

		  const parteInteira = valor.slice(0, -2);
		  const parteDecimal = valor.slice(-2);
		  inputComprimento.value = `${parseInt(parteInteira, 10)},${parteDecimal}`;
		});
		
		inputLargura.addEventListener('input', () => {
		  let valor = inputLargura.value.replace(/\D/g, ''); // Remove tudo que não for número

		  if (valor.length < 3) {
			valor = valor.padStart(3, '0'); // Garante ao menos 3 dígitos (ex: "001")
		  }

		  const parteInteira = valor.slice(0, -2);
		  const parteDecimal = valor.slice(-2);
		  inputLargura.value = `${parseInt(parteInteira, 10)},${parteDecimal}`;
		});
		
		inputArea.addEventListener('input', () => {
		  let valor = inputArea.value.replace(/\D/g, ''); // Remove tudo que não for número

		  if (valor.length < 3) {
			valor = valor.padStart(3, '0'); // Garante ao menos 3 dígitos (ex: "001")
		  }

		  const parteInteira = valor.slice(0, -2);
		  const parteDecimal = valor.slice(-2);
		  inputArea.value = `${parseInt(parteInteira, 10)},${parteDecimal}`;
		});
		
		
		function formatarMoeda(input) {
		  let valor = input.value.replace(/\D/g, '');

		  if (valor.length < 3) {
			valor = valor.padStart(3, '0');
		  }

		  const parteInteira = valor.slice(0, -2);
		  const parteDecimal = valor.slice(-2);
		  input.value = `${parseInt(parteInteira, 10)},${parteDecimal}`;
		}

		function calcularArea() {
		  const comp = document.getElementById('txtComprimento').value.replace(',', '.');
		  const larg = document.getElementById('txtLargura').value.replace(',', '.');

		  const compNum = parseFloat(comp);
		  const largNum = parseFloat(larg);

		  if (!isNaN(compNum) && !isNaN(largNum)) {
			const area = (compNum * largNum).toFixed(2).replace('.', ',');
			document.getElementById('txtArea').value = area;
		  } else {
			document.getElementById('txtArea').value = '';
		  }
		}

		const comprimentoInput = document.getElementById('txtComprimento');
		const larguraInput = document.getElementById('txtLargura');

		comprimentoInput.addEventListener('input', () => {
		  formatarMoeda(comprimentoInput);
		  calcularArea();
		});

		larguraInput.addEventListener('input', () => {
		  formatarMoeda(larguraInput);
		  calcularArea();
		});
    </script>
    <!--=== End Content Part ===-->
   	<!--#include file="../RodapeModulo.asp"-->
	<!--#include file="../jsModulo.asp"-->
</body>
</html> 