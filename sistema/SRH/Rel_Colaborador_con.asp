<!--#include file="../ConfigModulo.asp"-->
<!--#include file="../../includes/inc_cnn.asp"-->
<!--#include file="../../includes/inc_formatadata.asp"-->
<!--#include file="../menuModulos.asp"-->
<!--#include file="../includes/inc_sqlAlunoTurma.asp"-->
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
        strPaginaTitulo = "Rel_Colaborador_con.asp"
        strSituacao					= Trim(Request.Form("cmbSituacao"))	
        strNadaConsta      			= Trim(Request("cmbNadaConsta"))
        strMes		 	        	= Trim(Request("cmbMes"))
        intCodCategoria				= Trim(Request.Form("cmbCategoria"))	
		intCodCargoCategoria		= Trim(Request.Form("cmbCargoCategoria"))	
        intCodDepartamento			= Trim(Request.Form("cmbDepartamento"))
        strClassificacao			= request.Form("cmbClassificacao")
        intCodCargo 	    		= TRIM(Request.Form("cmbCargo"))
        intCodFuncao 	   		 	= TRIM(Request.Form("cmbFuncao"))
        intCodGrauInstrucao			= Trim(Request.Form("cmbGrauInstrucao"))	
        intcodLotacao 	    		= TRIM(Request.Form("cmbLotacao"))
        intCodFormaNomeacao 		= TRIM(Request.Form("cmbFormaNomeacao"))
        intCodEmpresaUsuario 	    = TRIM(Request.Form("cmdEmpresaUsuario"))
    %>
    <!--=== Content Part ===-->
    <div class="container content">		
    
      <!-- Grey Panel -->            
      <div class="panel panel-grey">
        <div class="panel-heading">
        	<h3 class="panel-title"><i class="fa fa-tasks"></i>Relação de Colaboradores</h3>
        </div>
        <!-- Inicia o Painel do Formulario -->     
        <div class="panel-body">
             <!-- Inicia o Form -->     
            <div class="panel-body">                                                        
                <form method="post" id="frm" action="#">
                <input name="txtTipoRelatorio" type="hidden" value="<%=intTipoRelatorio%>">
                <div class="form-group">
                	
                    <table width="98%" border="0" align="center" cellpadding="0" cellspacing="2" class="Formulario">
                     <tr>
                       <td colspan="5" class="texto1"><strong>Configurando Filtros:</strong></td>
                       </tr>
                     <tr>
                       <td class="texto1">&nbsp;</td>
                       <td colspan="4">&nbsp;</td>
                     </tr>
                     <%'if Session("NivelPermissao") = "A" then%>
                          <tr>
                          <td class="texto1">Unidade:</td>
                          <td colspan="4"><!--#include file="../includes/inc_cmdEmpresaUsuario.asp" --></td>
                          </tr>
                     <%' end if %>	  
                     <tr>
                       <td class="texto1">Categoria do Cargo:</td>
                       <td colspan="4"><!--#include file="../includes/inc_cmbCargoCategoria.asp" --></td>
                     </tr>
                     <tr>
                       <td class="texto1">Cargo:</td>
                       <td colspan="4"><!--#include file="../includes/inc_cmbCargo.asp" --></td>
                     </tr>
                     <tr>
                       <td class="texto1">Fun&ccedil;&atilde;o:</td>
                       <td colspan="4"><!--#include file="../includes/inc_cmbFuncao.asp" --></td>
                     </tr>
                     <tr>
                       <td class="texto1">Turno:</td>
                       <td colspan="4"><!--#include file="../includes/inc_cmbTurnoRH.asp" --></td>
                     </tr>
                     <tr>
                       <td class="texto1">Grau de Instru&ccedil;&atilde;o: </td>
                       <td colspan="4"><!--#include file="../includes/inc_cmdGrauInstrucaoColaborador.asp" --></td>
                     </tr>
                     
                     <tr>
                       <td class="texto1">Lota&ccedil;&atilde;o:</td>
                       <td colspan="4"><!--#include file="../includes/inc_cmbLotacao.asp" --></td>
                     </tr>
                     <tr>
                       <td class="texto1">Nomea&ccedil;&atilde;o:</td>
                       <td colspan="4"><!--#include file="../includes/inc_cmbFormaNomeacao.asp" --></td>
                     </tr>
                     
                     <tr>
                       <td width="14%" class="texto1">Categoria:</td>
                       <td colspan="4"><span class="texto1">
                        <!--#include file="../includes/inc_cmdCategoria.asp" -->
                       </span></td>
                       </tr>
                     <tr>
                       <td class="texto1">Departamento:</td>
                       <td colspan="4"><!--#include file="../includes/inc_cmdDepartamento.asp" --></td>
                     </tr>
                     <tr>
                       <td class="texto1">Situa&ccedil;&atilde;o:</td>
                       <td colspan="4"><!--#include file="../includes/inc_cmdSituacao.asp" --></td>
                     </tr>
                     <!--
                     <tr>
                       <td class="texto1">Checar Nada Consta?</td>
                       <td colspan="4"><select name="cmbNadaConsta" class="combo"  onChange="submit()" id="cmbNadaConsta" style="width:50pt">
                        <option value="N" <%if strNadaConsta = "N" then response.Write("selected") %>>NAO</option>
                        <option value="S" <%if strNadaConsta = "S" then response.Write("selected") %>>SIM</option>
                        </select></td>
                     </tr>
                     -->
                      <%if strNadaConsta = "S" then%>
                         <tr>
                           <td class="texto1">Referência:</td>
                           <td colspan="4"><!--#include file="../includes/inc_cmbMes.asp"--></td>
                         </tr>
                     <% end if %>    
                     <tr>
                       <td class="texto1">Classificar:</td>
                       <td colspan="4"><span class="texto1">
                         <select name="cmbClassificacao" id="cmbClassificacao" onchange="submit()" class="form-control">
                           <option  value="0">Selecione...</option>
                           <option <%if strClassificacao = "NOM" then%> selected <%end if%> value="NOM">Nome do Colaborador</option>
                           <option <%if strClassificacao = "DAD" then%> selected <%end if%> value="DAD">Data de Admissão</option>
                           <option <%if strClassificacao = "BAI" then%> selected <%end if%> value="BAI">Bairro</option>
                           <option <%if strClassificacao = "CID" then%> selected <%end if%> value="CID">Cidade</option>
                           <option <%if strClassificacao = "DNA" then%> selected <%end if%> value="DNA">Data de Nascimento</option>
                           <option <%if strClassificacao = "FUN" then%> selected <%end if%> value="FUN">Função</option> 
                           <option <%if strClassificacao = "DEP" then%> selected <%end if%> value="DEP">Departamento</option>
                        </select>
                       </span></td>
                     </tr>
					 <tr>
                       <td class="texto1">Somente Readaptação:</td>
                       <td colspan="4"><span class="texto1">
                         <input type="checkbox" name="readaptacao" value="S"> 
                       </span></td>
                     </tr>
                     <tr>
                       <td class="texto1">Data de Admiss&atilde;o:</td>
                       <td colspan="4"><span class="texto1">
                         <input name="txtDataInicialAdmissao" type="text" class="text" id="txtDataInicialAdmissao" onblur="return validaData(this); submit();" onkeypress="return formataCampo(this, 3, 10)" size="11" maxlength="10" value="<%=strDataInicialAdmissao%>" title="Click aqui para visualizar o calend&aacute;rio">
                &aacute;
                <input name="txtDataFinalAdmissao" type="text" class="text" id="txtDataFinalAdmissao" onblur="return validaData(this); submit();" onkeypress="return formataCampo(this, 3, 10)" size="11" maxlength="10" value="<%=strDataFinalAdmissao%>" title="Click aqui para visualizar o calend&aacute;rio">
                 Obs.: Para data ser mostrada, deve ser marcado a coluna para o Relat&oacute;rio.</span></td>
                     </tr>
                     <tr>
                       <td class="texto1">Data de Lota&ccedil;&atilde;o:</td>
                       <td colspan="4"><span class="texto1">
                         <input name="txtDataInicialLotacao" type="text" class="text" id="txtDataInicialLotacao" onblur="return validaData(this); submit();" onkeypress="return formataCampo(this, 3, 10)" size="11" maxlength="10" value="<%=strDataInicialLotacao%>" title="Click aqui para visualizar o calend&aacute;rio">
                &aacute;
                <input name="txtDataFinalLotacao" type="text" class="text" id="txtDataFinalLotacao" onblur="return validaData(this); submit();" onkeypress="return formataCampo(this, 3, 10)" size="11" maxlength="10" value="<%=strDataFinalLotacao%>" title="Click aqui para visualizar o calend&aacute;rio">
                Obs.: Para data ser mostrada, deve ser marcado a coluna para o Relat&oacute;rio.</span></td>
                     </tr>
                     <tr>
                       <td class="texto1">Data de Afastamento </td>
                       <td colspan="4"><span class="texto1">
                         <input name="txtDataInicialAfastamento" type="text" class="text" id="txtDataInicialAfastamento" onblur="return validaData(this); submit();" onkeypress="return formataCampo(this, 3, 10)" size="11" maxlength="10" value="<%=strDataInicialAfastamento%>" title="Click aqui para visualizar o calend&aacute;rio">
                &aacute;
                <input name="txtDataFinalAfastamento" type="text" class="text" id="txtDataFinalAfastamento" onblur="return validaData(this); submit();" onkeypress="return formataCampo(this, 3, 10)" size="11" maxlength="10" value="<%=strDataFinalAfastamento%>" title="Click aqui para visualizar o calend&aacute;rio">
                Obs.: Para data ser mostrada, deve ser marcado a coluna para o Relat&oacute;rio.</span></td>
                     </tr>
                     <tr>
                       <td colspan="5" class="texto1">&nbsp;</td>
                     </tr>
                     <tr>
                       <td colspan="5" class="texto1"><div align="center"><strong>Configurando Colunas para o Relat&oacute;rio </strong></div></td>
                     </tr>
                     <tr>
                       <td colspan="5" class="texto1">&nbsp;</td>
                     </tr>
                     <tr>
                       <td colspan="5" class="texto1"><div align="center"></div></td>
                       </tr>
                     
                      <tr>
                       <td width="25%" height="20" class="texto1"><input type="checkbox" checked name="filtro31" value="S">&nbsp;<strong>Cód. Funcional</strong></td>
					   <td width="25%" height="20" class="texto1"><input type="checkbox" name="filtro15" value="S">&nbsp;Conjuge</td>
					   <td width="25%" height="20" class="texto1"><input type="checkbox" name="filtro27" value="S">&nbsp;Grau de Instru&ccedil;&atilde;o</td>
					   <td width="25%" height="20" class="texto1"><input type="checkbox" name="filtro20" value="S">&nbsp;R.G/Org&atilde;o Expedidor</td>
                     </tr>
					 <tr>
                       <td width="25%" height="20" class="texto1"><input type="checkbox" disabled checked name="nome" value="S">&nbsp;<strong>Nome</strong></td>
					   <td width="25%" height="20" class="texto1"><input type="checkbox" name="filtro01" value="S">&nbsp;Data de Admiss&atilde;o </td>
					   <td width="25%" height="20" class="texto1"><input type="checkbox" name="filtro33" value="S">&nbsp;Login Sistema</td>
					   <td width="25%" height="20" class="texto1"><input type="checkbox" name="filtro41" value="S">&nbsp;Readaptação</td>
           
                     
					 </tr>
					 <tr>
                       <td width="25%" height="20" class="texto1"><input type="checkbox" name="filtro03" value="S">&nbsp;Bairro</td>
					   <td width="25%" height="20" class="texto1"><input type="checkbox" name="filtro24" value="S">&nbsp;Data de Afastamento</td>
					   <td width="25%" height="20" class="texto1"><input type="checkbox" name="filtro10" value="S">&nbsp;M&atilde;e</td>
					   <td width="25%" height="20" class="texto1"><input type="checkbox" name="filtro21" value="S">&nbsp;Reservista</td>
                     </tr>
					 <tr>
                       <td width="25%" height="20" class="texto1"><input type="checkbox" name="filtro17" value="S">&nbsp;C.P.F</td>
					   <td width="25%" height="20" class="texto1"><input type="checkbox" name="filtro11" value="S">&nbsp;Data de Nascimento</td>
					   <td width="25%" height="20" class="texto1"><input type="checkbox" name="filtro13" value="S">&nbsp;Nacionalidade</td>
					   <td width="25%" height="20" class="texto1"><input type="checkbox" name="filtro36" value="S">&nbsp;Remo&ccedil;&atilde;o</td>
				
                     </tr>
					 <tr>
                       <td width="25%" height="20" class="texto1"><input type="checkbox" name="filtro34" value="S">&nbsp;Campo de Assinatura </td>
					   <td width="25%" height="20" class="texto1"><input type="checkbox" name="filtro39" value="S">&nbsp;Data Lota&ccedil;&atilde;o</td>
					   <td width="25%" height="20" class="texto1"><input type="checkbox" name="filtro12" value="S">&nbsp;Naturalidade</td>
					   <td width="25%" height="20" class="texto1"><input type="checkbox" name="filtro22" value="S">&nbsp;Sexo</td>
					   
                     </tr>
					 <tr>
                       <td width="25%" height="20" class="texto1"><input type="checkbox" name="filtro28" value="S">&nbsp;Cargo</td>
					   <td width="25%" height="20" class="texto1"><input type="checkbox" name="filtro30" value="S">&nbsp;Departamento</td>
					   <td width="25%" height="20" class="texto1"><input type="checkbox" name="filtro38" value="S">&nbsp;Nível</td>
					   <td width="25%" height="20" class="texto1"><input type="checkbox" name="filtro25" value="S">&nbsp;Situa&ccedil;&atilde;o</td>
                     </tr>
					 <tr>
                       <td width="25%" height="20" class="texto1"><input type="checkbox" name="filtro19" value="S">&nbsp;Carteira de Trabalho</td>
					   <td width="25%" height="20" class="texto1"><input type="checkbox" name="filtro08" value="S">&nbsp;Email</td>
					   <td width="25%" height="20" class="texto1"><input type="checkbox" name="filtro35" value="S">&nbsp;Nomeação</td>
					   <td width="25%" height="20" class="texto1"><input type="checkbox" name="filtro18" value="S">&nbsp;T&iacute;tulo de Eleitor</td>
                     </tr>
					 <tr>
                       <td width="25%" height="20" class="texto1"><input type="checkbox" name="filtro26" value="S">&nbsp;Categoria</td>
					   <td width="25%" height="20" class="texto1"><input type="checkbox" name="filtro02" value="S">&nbsp;Endere&ccedil;o</td>
					   <td width="25%" height="20" class="texto1"><input type="checkbox" name="filtro16" value="S">&nbsp;N&uacute;mero de Filhos</td>
					   <td width="25%" height="20" class="texto1"><input type="checkbox" name="filtro37" value="S">&nbsp;Turno</td>
                     </tr>
					 <tr>
                       <td width="25%" height="20" class="texto1"><input type="checkbox" name="filtro07" value="S">&nbsp;Celular</td>
					   <td width="25%" height="20" class="texto1"><input type="checkbox" name="filtro14" value="S">&nbsp;Estado Civil </td>
					   <td width="25%" height="20" class="texto1"><input type="checkbox" name="filtro32" value="S">&nbsp;Observa&ccedil;&otilde;es</td>
					   <td width="25%" height="20" class="texto1"><input type="checkbox" name="filtro40" value="S">&nbsp;Unidade Escolar</td>
                     </tr>
					 <tr>
                       <td width="25%" height="20" class="texto1"><input type="checkbox" name="filtro05" value="S">&nbsp;Cep</td>
					   <td width="25%" height="20" class="texto1"><input type="checkbox" name="filtro06" value="S">&nbsp;Fone Res./Com.</td>
					   <td width="25%" height="20" class="texto1"><input type="checkbox" name="filtro23" value="S">&nbsp;P.I.S</td>
					   <td width="25%" height="20" class="texto1"></td>
                     </tr>
					 <tr>
                       <td width="25%" height="20" class="texto1"><input type="checkbox" name="filtro04" value="S">&nbsp;Cidade/UF</td>
					   <td width="25%" height="20" class="texto1"><input type="checkbox" name="filtro29" value="S">&nbsp;Fun&ccedil;&atilde;o</td>
					   <td width="25%" height="20" class="texto1"><input type="checkbox" name="filtro09" value="S">&nbsp;Pai</td>
					   <td width="25%" height="20" class="texto1"></td>
                     </tr>
                     
                    <tr>
                      <td class="texto1">&nbsp;</td>
                      <td colspan="5">&nbsp;</td>
                    </tr>
                    <tr>
                      <td colspan="6"><hr size="1" color="#CCCCCC"></td>
                    </tr>
                    <tr>
                      <td colspan="6"><!--#include file="../../includes/inc_botoes_geraRelatorio.asp"-->&nbsp;</td>
                    </tr>
                  </table>
  
                </div>
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
            
            var frm = document.getElementById("frm");
            
            frm.action = "Rel_Colaborador_rel.asp";
            frm.submit();
            return true;	
        }	
    </script>
    <!--=== End Content Part ===-->
   	<!--#include file="../RodapeModulo.asp"-->
	<!--#include file="../jsModulo.asp"-->
</body>
</html> 