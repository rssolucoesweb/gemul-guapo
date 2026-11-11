<!--#include file="../ConfigModulo.asp"-->
    <!--#include file="../../includes/inc_cnn.asp"-->
	<!--#include file="../menuModulos.asp"-->  
    <!--=== Breadcrumbs ===-->
    <div class="breadcrumbs">
        <div class="container">
            <h1 class="pull-left">Modulo Matrícula</h1>
            <ul class="pull-right breadcrumb">
                <li><a href="Default.asp">Home</a></li>
                <li class="active"><%=session("CodEmpresa")%> - <%=session("EmpresaWeb")%></li>
            </ul>
        </div><!--/container-->
    </div><!--/breadcrumbs-->
    <!--=== End Breadcrumbs ===-->
	<%
	
	strPagina				  = "ValidaReserva_con.asp"
	strExecutarSubmitCurso	  = "S"
	strExecutarSubmitPeriodo  = "S"
	strExecutarSubmitTurno	  = "S"
	strExecutarSubmitTurma	  = "S"
	strExecutarSubmitSemestre = "S"

	strSemestre 	= session("strSemestre")
	strAnoLetivo 	= session("strAnoLetivo")
	strAnoLetivo 	= Trim(Request.Form("txtAnoLetivo"))
	if strAnoLetivo = "" then 	strAnoLetivo = session("strAnoLetivo")
	intSemestre 	= Trim(Request.Form("cmbSemestre"))
	if intSemestre 	= "" then 	intSemestre  = session("strSemestre")
	intCodCurso 	= Trim(Request.Form("cmbCurso"))
	strInscricao 	= Trim(Request("txtInscricao"))
	strNomealuno	= Trim(Request("txtNomealuno"))
	
	if strInscricao <> "" then
	
		sql = "SELECT CODIGO, NOME, PERIODO, Contato, Celular, FonePai, FoneMae"
		sql = sql & " FROM MAT_RESERVA"
		sql = sql & " WHERE  CODIGO = " & strInscricao
		rs.open sql, cnn
		if rs.eof = false then
			strNomealuno 			= Trim(rs("Nome"))
		    strPeriodo 				= Trim(rs("PERIODO"))
			strContato 				= Trim(rs("Contato")) & "    " & Trim(rs("Celular")) 
			strFonePai 				= Trim(rs("FonePai"))
			strFoneMae 				= Trim(rs("FoneMae"))

			strDesabilitaIncluir	= "" 'Desabilita o botão Incluir
			strDesabilitaAlterar 	= "disabled" 'Desabilita o botão Excluir
			strDesabilitaExcluir	= "disabled" 'Desabilita o botão Excluir
		else	
			strDesabilitaIncluir	= "" 'Desabilita o botão Incluir
			strDesabilitaAlterar 	= "disabled" 'Desabilita o botão Excluir
			strDesabilitaExcluir	= "disabled" 'Desabilita o botão Excluir
		end if
		rs.close	

		sql = " select top 1 * from MAT_reserva "
		sql = sql & " where periodo = '" & strPeriodo & "'"
		sql = sql & " AND ISNULL(ATUALIZADO,'N') = 'N' "
		sql = sql & " order by codigo "
		rs.open sql, cnn
		if rs.eof =  false then
		    strInscricao1 				= Trim(rs("Codigo"))
			strNomealuno1 				= Trim(rs("Nome"))
		    strPeriodo1 				= Trim(rs("PERIODO"))
			strContato1 				= Trim(rs("Contato")) & "    " & Trim(rs("Celular")) 
			strFonePai1 				= Trim(rs("FonePai"))
			strFoneMae1 				= Trim(rs("FoneMae"))

			strLogradouro1			= Trim(rs("Logradouro"))
			strNumeroEndereco1		= Trim(rs("NumeroEndereco"))
			strComplementoEndereco1	= Trim(rs("ComplementoEndereco"))
			strBairro1 				= Trim(rs("Bairro"))
			strCidade1 				= Trim(rs("Cidade"))
			strUf1 					= Trim(rs("Uf"))
			
		end if 
		rs.close
		'if intTipoProcesso <> "1" then
			'strInscricao = ""
			'strNomealuno = ""
			'strDesabilitaIncluir	= "disabled" 'Desabilita o botão Incluir
			'strDesabilitaAlterar 	= "disabled" 'Desabilita o botão Excluir
			'strDesabilitaExcluir	= "disabled" 'Desabilita o botão Excluir
		'end if 

	else
		strInscricao = ""
		strNomealuno = ""
		strDesabilitaIncluir	= "disabled" 'Desabilita o botão Incluir
		strDesabilitaAlterar 	= "disabled" 'Desabilita o botão Excluir
		strDesabilitaExcluir	= "disabled" 'Desabilita o botão Excluir
	end if

	intCodTurma 			= Trim(Request.Form("cmbTurma"))
	intCodPeriodo 			= Trim(Request.Form("cmbPeriodo"))
	intCodTurno		 		= Trim(Request.Form("cmbTurno"))
	
	strFiltroSerie 			= "0"
	strFiltroTurno 			= "0"

	if intCodCurso 		= "" then intCodCurso 		= "0"
	if intCodSerie 		= "" then intCodSerie 		= "0"
	if intCodTurno 		= "" then intCodTurno 		= "0"
	if intCodTurma 		= "" then intCodTurma 		= "0"
	%>
 
    <!--=== Content Part ===-->
    <div class="container content">		
    
      <!-- Grey Panel -->            
      <div class="panel panel-grey">
        <div class="panel-heading">
        	<h3 class="panel-title"><i class="fa fa-tasks"></i>Valida Reserva</h3>
        </div>
        <!-- Inicia o Painel do Formulario -->     
        <div class="panel-body">
             <!-- Inicia o Form -->     
            <div class="panel-body">                                                        
                <form id="frm" class="margin-bottom-10" method="post">
                    <div class="form-group">
                        <label class="form-label">Ano Letivo</label>
                         <input  name="txtAnoLetivo" type="text" class="form-control" id="txtAnoLetivo" onBlur="submit()"  value="<%=strAnoLetivo%>" style="width:60pt" size="5" maxlength="5">
                    </div>
                    
                    <div class="form-group">
                        <label class="form-label">Semestre</label>
                         <!--#include file="../includes/inc_cmdSemestre.asp" -->
                    </div>

                    <div class="form-group">
                        <label class="form-label">Inscri&ccedil;&atilde;o</label>
                         <input name="txtInscricao" type="text" class="form-control" id="txtInscricao" value="<%=strInscricao%>" size="30" maxlength="30" onBlur="submit()">
                         <button class="btn-u btn-u-sea" onClick="return abreConsulta('Usuario_con.asp')" type="button"><i class="fa fa-search"></i></button>  
                    </div>
                    
                     <% if strInscricao <> "" then %>
                     <br><br>
                     	 <div class="form-group">
                             <label class="form-label">Reserva Realizada para</label>
                             <strong><%=strPeriodo%></strong>
                   		 </div>
                         
                         <div class="form-group">
                             <label class="form-label">Contato - Telefone(s):</label>
                             Contato:&nbsp;&nbsp;<%=strContato%>&nbsp;-&nbsp;Celular M&atilde;e:&nbsp;&nbsp;<%=strFoneMae%>&nbsp;&nbsp;&nbsp;-&nbsp;Celular Pai:&nbsp;&nbsp;<%=strFonePai%>&nbsp;
                   		 </div>
                     
                    <% end if %>    
                    
                    <div class="form-group">
                        <label class="form-label">Curso</label>
                         <!--#include file="../includes/inc_cmdCurso.asp"-->
                    </div>
                    
                    <div class="form-group">
                        <label class="form-label">Per&iacute;odo</label>
                        <!--#include file="../includes/inc_cmdPeriodo.asp"-->
                    </div>
                    
                     <div class="form-group">
                        <label class="form-label">Turno</label>
                        <!--#include file="../includes/inc_cmdTurno.asp"-->
                    </div>
                    
                     <div class="form-group">
                        <label class="form-label">Turma</label>
                        <!--#include file="../includes/inc_cmdTurma.asp"-->
                    </div>
                    <legend></legend>
                    <!--#include file="../../includes/inc_botoes_cadastro.asp"-->
                </form>
            	</div>
       	 	</div>
         	<!-- Fecha o Form -->  
      </div>

       <!-- Fecha o Painel do Formulario -->        
    </div>
    <!--/container-->		
    <script>
	function salvar(acao){
				
		var frm = document.getElementById("frm");
	
		if (frm.txtInscricao.value == "") {
			alert("A inscrição deve ser informada !");
			frm.txtInscricao.focus();
			return false;
		}
		
		if (frm.cmbTurma.value == "0") {
			alert("A turma deve ser informada !");
			frm.cmbTurma.focus();
			return false;
		}

		if (frm.cmbCurso.value == "0") {
			alert("Curso deve ser informado !");
			frm.cmbCurso.focus();
			return false;
		}

		frm.action="ValidaReserva_cod.asp";
		frm.submit();
		return true;
 	}
	
	function abreConsulta(caminho){
		window.open(caminho,"abreConsulta","top=5,left=5,height=510,width=519,menubar=no,toolbar=no,scrollbars=yes,status=yes");
	}	
</script>
    <!--=== End Content Part ===-->
   	<!--#include file="../RodapeModulo.asp"-->
	<!--#include file="../jsModulo.asp"-->
</body>
</html> 