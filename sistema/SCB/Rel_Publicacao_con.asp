	<!--#include file="../ConfigModulo.asp"-->
    <!--#include file="../../includes/inc_cnn.asp"-->
	<!--#include file="../menuModulos.asp"-->  
    <!--=== Breadcrumbs ===-->
    <div class="breadcrumbs">
        <div class="container">
            <h1 class="pull-left">Modulo Biblioteca</h1>
            <ul class="pull-right breadcrumb">
                <li><a href="Default.asp">Home</a></li>
                <li class="active"><%=session("CodEmpresa")%> - <%=session("EmpresaWeb")%></li>
            </ul>
        </div><!--/container-->
    </div><!--/breadcrumbs-->
    <!--=== End Breadcrumbs ===-->
	<%
        strPaginaTitulo = "Rel_Publicacao_con.asp"
        
        intCodLocalizacaoGeografica = Trim(Request.Form("cmbLocalizacaoGeografica"))
        strSituacao					= Trim(Request.Form("cmbSituacao"))	
        intCodCategoria				= Trim(Request.Form("cmbCategoria"))	
        intCodDepartamento			= Trim(Request.Form("cmbDepartamento"))
        intCodCdu					= Trim(Request.Form("txtCodCDU"))
        intCodTipoPublicacao		= Trim(Request.Form("cmbTipoPublicacao"))
        intCodCursoPrimeiraOpcao 	= Trim(Request.Form("cmbCursoPrimeiraOpcao"))
        intCodCursoPrimeiraOpcao 	= Trim(Request.Form("cmbCursoPrimeiraOpcao"))
        intCodAreaConhecimento 		= Trim(Request.Form("cmbAreaConhecimento"))
        strClassificacao			= request.Form("cmbClassificacao")
        strTipoRelatorio			= Trim(Request.Form("cmbTipoRelatorio"))
    %>
    <!--=== Content Part ===-->
    <div class="container content">		
    
      <!-- Grey Panel -->            
      <div class="panel panel-grey">
        <div class="panel-heading">
        	<h3 class="panel-title"><i class="fa fa-tasks"></i>Relatório Publicação</h3>
        </div>
        <!-- Inicia o Painel do Formulario -->     
        <div class="panel-body">
             <!-- Inicia o Form -->     
            <div class="panel-body">                                                        
                <form id="frm" class="margin-bottom-10" method="post">
                <div class="form-group">
                <label class="form-label">Localiza&ccedil;&atilde;o Geogr&aacute;fica</label>
                    <!--#include file="../includes/inc_cmbLocalizacaoGeografica.asp" -->
                 </div>
                <div class="form-group">
                <label class="form-label">Autoria</label>
                    <!--#include file="../includes/inc_cmdAutoria.asp" -->
                 </div>
                <div class="form-group">
                <label class="form-label">Autor</label>
                    <input name="txtAutor" type="text" class="form-control" style="width:250pt"  id="txtAutor" size="50" maxlength="50" value="<%=strAutor%>" />
                 </div>
                 <div class="form-group">
                 <label class="form-label">Palavra Chave</label>
                 	<input name="txtPalavraChave" type="text" class="form-control" style="width:250pt"  id="txtPalavraChave" size="50" maxlength="50" value="<%=strPalavraChave%>" />
                 </div>
                 <div class="form-group">
                 <label class="form-label"> T&iacute;tulo:</label>
                 	<input name="txtTitulo" type="text" class="form-control" style="width:250pt"  id="txtTitulo" size="50" maxlength="50" value="<%=strTitulo%>" />
                 </div>
                 
                 <div class="form-group">
                 <label class="form-label"> Curso</label>
                 	<!--#include file="../includes/inc_cmdCursoPrimeraOpcao.asp" -->
                 </div>
                 
                  <div class="form-group">
                 <label class="form-label">Classifica&ccedil;&atilde;o da Pub. no Curso:</label>
                 	<select name="cmbClassificacaoCurso" id="cmbClassificacaoCurso" class="form-control" style="width:250pt">
                    <option <%if strClassificacaoCurso = "B" then%> selected <%end if%> value="B">B&aacute;sica</option>
                    <option <%if strClassificacaoCurso = "C" then%> selected <%end if%> value="C">Complementar</option>
                  </select>
                 </div>
                 
                 <div class="form-group">
                 <label class="form-label"> Cdu</label>
                 	<input name="txtCodCDU" type="text" id="txtCodCDU" class="form-control" size="70" maxlength="70" style="width:100pt">
                 </div>
                 
                  <div class="form-group">
                 <label class="form-label"> &Aacute;rea do conhecimento</label>
                 	<!--#include file="../includes/inc_cmdAreaConhecimento.asp" -->
                 </div>
                 
                 <div class="form-group">
                 <label class="form-label">Tipo Publica&ccedil;&atilde;o</label>
                 	<!--#include file="../includes/inc_cmdTipoPublicacao.asp" -->
                 </div>
                 
                 <div class="form-group">
                 <label class="form-label">Classificando por:</label>
                 	<select name="cmbClassificacao" id="cmbClassificacao" class="form-control" style="width:250pt">
                   <option <%if strClassificacao = "TIT" then%> selected <%end if%> value="TIT">Título</option>
                   <option <%if strClassificacao = "CDU" then%> selected <%end if%> value="CDU">C.D.U</option>
                   <option <%if strClassificacao = "TITCDU" then%> selected <%end if%> value="TITCDU">Titulo e C.D.U</option>
                  </select>
                 </div>
                 
                 <legend></legend>
                 
                 <div class="form-group">
	                 <label>Configurando Colunas para o Relat&oacute;rio </label>
                 </div>
                 
                 <div class="form-group">
                 <label class="form-label"> Dados da Publica&ccedil;&atilde;o:</label>
                 	<input type="checkbox" name="filtro01" value="S"> 01).Tipo de Publica&ccedil;&atilde;o 
                    <input type="checkbox" name="filtro02" value="S"> 02).Autoria
                    <input type="checkbox" name="filtro03" value="S"> 03).Editora
                    <input type="checkbox" name="filtro04" value="S"> 04).C.D.U
                    <input type="checkbox" name="filtro05" value="S"> 05).Periodicidade
                    <input type="checkbox" name="filtro06" value="S"> 06).Autores
                    <input type="checkbox" name="filtro07" value="S"> 07).Palavras Chaves 
                    <input type="checkbox" name="filtro08" value="S"> 08).Sub-T&iacute;tulo
                    <input type="checkbox" name="filtro09" value="S"> 09).Local de Publica&ccedil;&atilde;o
                    <input type="checkbox" name="filtro10" value="S"> 10).Ano de Publica&ccedil;&atilde;o 
                    <input type="checkbox" name="filtro11" value="S"> 11).Edi&ccedil;&atilde;o
                    <input type="checkbox" name="filtro12" value="S"> 12).Volume
                    <input type="checkbox" name="filtro13" value="S"> 13).ISBN
                    <input type="checkbox" name="filtro14" value="S"> 14).Data de Inclus&atilde;o
                    <input type="checkbox" name="filtro15" value="S"> 15).Gerar Etiquetas
                    <input type="checkbox" name="filtro16" value="S"> 16). P&aacute;ginas
                    <input type="checkbox" name="filtro17" value="S"> 17).Origem
                    <input type="checkbox" name="filtro18" value="S"> 18).Destino
                    <input type="checkbox" name="filtro19" value="S"> 19).Resumo
                    <input type="checkbox" name="filtro20" value="S"> 20).&Uacute;ltimo Exemplar
                    <input type="checkbox" name="filtro21" value="S"> 21).Quant. de Exemplar
                 </div>
                 <div class="form-group">
                 <label class="form-label"> Dados Complementares:</label>
                    <input type="checkbox" name="filtro22" value="S"> 22).Data do Contrato 
                    <input type="checkbox" name="filtro23" value="S"> 23).Contato
                    <input type="checkbox" name="filtro24" value="S"> 24).Endere&ccedil;o
                    <input type="checkbox" name="filtro25" value="S"> 25).Bairro
                    <input type="checkbox" name="filtro26" value="S"> 26).Cidade
                    <input type="checkbox" name="filtro27" value="S"> 27).UF
                    <input type="checkbox" name="filtro28" value="S"> 28).CEP
                    <input type="checkbox" name="filtro29" value="S"> 29).N&uacute;mero
                    <input type="checkbox" name="filtro30" value="S"> 30).Email
                 </div>
                <legend></legend>
                <!--#include file="../../includes/inc_botoes_geraRelatorio.asp"-->
                </form>
            	</div>
       	 	</div>
         	<!-- Fecha o Form -->  
      </div>
       <!-- Fecha o Painel do Formulario -->        
    </div>
    <!--/container-->		
   <script>
		function gerar(){
		frm.action = "Rel_Publicacao_rel.asp";
		frm.submit();
		return true;	
	}	
	</script>
    <!--=== End Content Part ===-->
   	<!--#include file="../RodapeModulo.asp"-->
	<!--#include file="../jsModulo.asp"-->
</body>
</html> 