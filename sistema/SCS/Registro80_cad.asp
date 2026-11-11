<!--#include file="../ConfigModulo.asp"-->
<!--#include file="../../includes/inc_cnn.asp"-->
<!--#include file="../menuModulos.asp"-->
<script src="../../js/js_funcoes_gerais.js"></script>  
    <!--=== Breadcrumbs ===-->
    <div class="breadcrumbs">
        <div class="container">
            <h1 class="pull-left">Modulo Senso</h1>
            <ul class="pull-right breadcrumb">
                <li><a href="Default.asp">Home</a></li>
                <li class="active"><%=session("CodEmpresa")%> - <%=session("EmpresaWeb")%></li>
            </ul>
        </div><!--/container-->
    </div><!--/breadcrumbs-->
    <!--=== End Breadcrumbs ===-->
	<%
		strFuncao = ""
		strPaginaTitulo 						= "Cadastro de Aluno - V&iacute;nculo (Matr&iacute;cula) - Registro 80"
		
		intCodEmpresa							= Trim(Request("CodEscola"))
		strTipoRegistro							= Trim(Request.Form("txtTipoRegistro"))
		intCodEscolaInep	 					= Trim(Request.Form("txtCodEscolaInep"))
		strIdentificacaoUnicaAlunoInep			= Trim(Request.Form("txtIdentificacaoUnicaAlunoInep"))
		strCodAlunoEntidadeEscola				= Trim(Request.Form("txtCodAlunoEntidadeEscola"))
	
		strCodigoTurma							= Trim(Request.Form("txtCodigoTurma"))
		strCodigoTurmaEntidadeEscola			= Trim(Request.Form("txtCodigoTurmaEntidadeEscola"))
		strCodigoMatriculaAluno					= Trim(Request.Form("txtCodigoMatriculaAluno"))
		strTurmaUnificada						= Trim(Request.Form("cmbTurmaUnificada"))
		strEtapa								= Trim(Request.Form("cmbEtapa"))
		strRecebeEscolarizacaoOutroEspacao		= Trim(Request.Form("cmbRecebeEscolarizacaoOutroEspacao"))
		strTransposteEscolarPublico				= Trim(Request.Form("cmbTransposteEscolarPublico"))
		strPoderPublicoResponsavel				= Trim(Request.Form("cmbPoderPublicoResponsavel"))
		strVansKombis							= Trim(Request.Form("cmbVansKombis"))
		strMicroOnibus							= Trim(Request.Form("cmbMicroOnibus"))
		strOnibus								= Trim(Request.Form("cmbOnibus"))
		strBicicleta							= Trim(Request.Form("cmbBicicleta"))
		strTransporteAnimal						= Trim(Request.Form("cmbTransporteAnimal"))
		strRodoviarioOutro						= Trim(Request.Form("cmbRodoviarioOutro"))
		strCapacidade5Alunos					= Trim(Request.Form("cmbCapacidade5Alunos"))
		strCapacidade5e15Alunos					= Trim(Request.Form("cmbCapacidade5e15Alunos"))
		strCapacidadeAcima35Alunos				= Trim(Request.Form("cmbCapacidadeAcima35Alunos"))
		strTremMetro							= Trim(Request.Form("cmbTremMetro"))
		strFormaIngressoAluno					= Trim(Request.Form("cmbFormaIngressoAluno"))
		
		
		if trim(intCodEmpresa) <> "" then
			 
			sql = "SELECT CodEmpresa, TipoRegistro, CodEscolaInep, IdentificacaoUnicaAlunoInep, CodAlunoEntidadeEscola, "
			sql = sql & " CodigoTurma, CodigoTurmaEntidadeEscola, CodigoMatriculaAluno, TurmaUnificada, Etapa, RecebeEscolarizacaoOutroEspacao, "
			sql = sql & " TransposteEscolarPublico, PoderPublicoResponsavel, VansKombis, MicroOnibus, Onibus, Bicicleta, "
			sql = sql & " TransporteAnimal, RodoviarioOutro, Capacidade5Alunos, Capacidade5e15Alunos, CapacidadeAcima35Alunos, "
			sql = sql & " TremMetro, FormaIngressoAluno"
			sql = sql & " FROM REGISTRO80"
			sql = sql & " WHERE CodEmpresa = " & intCodEmpresa
			rs.open sql, cnn
		
			if rs.eof = false then
			
				intCodEmpresa							= rs("CodEmpresa")
				strTipoRegistro							= rs("TipoRegistro")
				intCodEscolaInep	 					= rs("CodEscolaInep")
				strIdentificacaoUnicaAlunoInep			= rs("IdentificacaoUnicaAlunoInep")
				strCodAlunoEntidadeEscola				= rs("CodAlunoEntidadeEscola")
			
				strCodigoTurma							= rs("CodigoTurma")
				strCodigoTurmaEntidadeEscola			= rs("CodigoTurmaEntidadeEscola")
				strCodigoMatriculaAluno					= rs("CodigoMatriculaAluno")
				strTurmaUnificada						= rs("TurmaUnificada")
				strEtapa								= rs("Etapa")
				strRecebeEscolarizacaoOutroEspacao		= rs("RecebeEscolarizacaoOutroEspacao")
				strTransposteEscolarPublico				= rs("TransposteEscolarPublico")
				strPoderPublicoResponsavel				= rs("PoderPublicoResponsavel")
				strVansKombis							= rs("VansKombis")
				strMicroOnibus							= rs("MicroOnibus")
				strOnibus								= rs("Onibus")
				strBicicleta							= rs("Bicicleta")
				strTransporteAnimal						= rs("TransporteAnimal")
				strRodoviarioOutro						= rs("RodoviarioOutro")
				strCapacidade5Alunos					= rs("Capacidade5Alunos")
				strCapacidade5e15Alunos					= rs("Capacidade5e15Alunos")
				strCapacidadeAcima35Alunos				= rs("CapacidadeAcima35Alunos")
				strTremMetro							= rs("TremMetro")
				strFormaIngressoAluno					= rs("FormaIngressoAluno")
	
				strDesabilitaIncluir		= "" 'Desabilita o botão Incluir
				strDesabilitaAlterar 		= "disabled" 'Desabilita o botão Excluir
				strDesabilitaExcluir		= "disabled" 'Desabilita o botão Excluir
				
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
        	<h3 class="panel-title"><i class="fa fa-tasks"></i>Cadastro de Aluno - V&iacute;nculo (Matr&iacute;cula) - Registro 80</h3>
        </div>
        <!-- Inicia o Painel do Formulario -->     
        <div class="panel-body">
             <!-- Inicia o Form -->     
            <div class="panel-body">                                                        
                <form id="frm" class="margin-bottom-10" method="post">
                    <table width="98%" border="0" cellpadding="0" cellspacing="0">
                <tr valign="top">
                  <td width="98%" align="center" class="tituloSistema"><%=strPaginaTitulo%></td>
                </tr>
              </table>
              <br>
              <table width="98%" border="0" cellspacing="0" cellpadding="0">
              <tr>
                <td height="25" class="texto1">Empresa:</td>
                <td><input style="width:100pt" name="txtCodEmpresa" type="text" class="form-control" id="txtCodEmpresa" size="8" maxlength="8" value="<%=trim(intCodEmpresa)%>"></td>
              </tr>
              <tr>
                <td width="424" height="25" class="texto1">Tipo de Registro</td>
                <td width="857"><input style="width:100pt" name="txtTipoRegistro" type="text" class="form-control" id="txtTipoRegistro" size="2" maxlength="5" value="<%=trim(strTipoRegistro)%>">            </td>
              </tr>
              <tr>
                <td height="25" class="texto1">C&oacute;digo da Escola - Inep</td>
                <td><input style="width:100pt" name="txtCodEscolaInep" type="text" class="form-control" id="txtCodEscolaInep" size="8" maxlength="8" value="<%=trim(intCodEscolaInep)%>"></td>
              </tr>
              <tr>
                <td height="25" class="texto1">              Indentifica&ccedil;&atilde;o &uacute;nicia do aluno (inep)</td>
                <td><input style="width:100pt" name="txtIdentificacaoUnicaAlunoInep" type="text" class="form-control" id="txtIdentificacaoUnicaAlunoInep" size="8" maxlength="8" value="<%=trim(strIdentificacaoUnicaAlunoInep)%>"></td>
              </tr>
              <tr>
                <td height="25" class="texto1">C&oacute;digo do aluno na entidade/Escola</td>
                <td><input style="width:100pt" name="txtCodAlunoEntidadeEscola" type="text" class="form-control" id="txtCodAlunoEntidadeEscola" size="8" maxlength="8" value="<%=trim(strCodAlunoEntidadeEscola)%>"></td>
              </tr>
              <tr>
                <td height="25" class="texto1">C&oacute;digo da Turma Inep</td>
                <td><input style="width:100pt" name="txtCodigoTurma" type="text" class="form-control" id="txtCodigoTurma" size="8" maxlength="8" value="<%=trim(strCodigoTurma)%>"></td>
              </tr>
              <tr>
                <td height="25" class="texto1">C&oacute;digo da Turma na Entidade/escola</td>
                <td><input style="width:100pt" name="txtCodigoTurmaEntidadeEscola" type="text" class="form-control" id="txtCodigoTurmaEntidadeEscola" size="8" maxlength="8" value="<%=trim(strCodigoTurmaEntidadeEscola)%>"></td>
              </tr>
              <tr>
                <td height="25" class="texto1">C&oacute;digo da matr&iacute;cula do Aluno</td>
                <td><input style="width:100pt" name="txtCodigoMatriculaAluno" type="text" class="form-control" id="txtCodigoMatriculaAluno" size="8" maxlength="8" value="<%=trim(strCodigoMatriculaAluno)%>"></td>
              </tr>
              <tr>
                <td height="25" class="texto1">Turma unificada</td>
                <td><select name="cmbTurmaUnificada" id="cmbTurmaUnificada" class="form-control" style="width:100pt" >
                  <option value="0">Selecione...</option>
                  <option <%if strTurmaUnificada = "0" then%> selected <%end if%> value="0">N&atilde;o</option>
                  <option <%if strTurmaUnificada = "1" then%> selected <%end if%> value="1">Sim</option>
                </select></td>
              </tr>
              <tr>
                <td height="25" class="texto1">Etapa do aluno em Turma multietapa / mult / Corre&ccedil;&atilde;o de Fluxo / Eja presencial e  
                  semipresencial - anos iniciais e anos finais / Educa&ccedil;&atilde;o profissional mista - concomitante e subsequente.</td>
                <td><select name="cmbEtapa" id="cmbEtapa" class="form-control" style="width:100pt" >
                  <option value="0">Selecione...</option>
                  <option <%if strEtapa = "0" then%> selected <%end if%> value="0">N&atilde;o</option>
                  <option <%if strEtapa = "1" then%> selected <%end if%> value="1">Sim</option>
                </select></td>
              </tr>
              <tr>
                <td height="25" class="texto1">Recebe escolariza&ccedil;&atilde;o em outro espa&ccedil;o ( diferente da escola)</td>
                <td><select name="cmbRecebeEscolarizacaoOutroEspacao" id="cmbRecebeEscolarizacaoOutroEspacao" class="form-control" style="width:100pt" >
                    <option value="0">Selecione...</option>
                    <option <%if strRecebeEscolarizacaoOutroEspacao = "0" then%> selected <%end if%> value="0">N&atilde;o</option>
                    <option <%if strRecebeEscolarizacaoOutroEspacao = "1" then%> selected <%end if%> value="1">Sim</option>
                  </select></td>
              </tr>
              <tr>
                <td height="25" class="texto1">Transposte escolar p&uacute;blico</td>
                <td><select name="cmbTransposteEscolarPublico" id="cmbTransposteEscolarPublico" class="form-control" style="width:100pt" >
                  <option value="0">Selecione...</option>
                  <option <%if strTransposteEscolarPublico = "0" then%> selected <%end if%> value="0">N&atilde;o</option>
                  <option <%if strTransposteEscolarPublico = "1" then%> selected <%end if%> value="1">Sim</option>
                </select></td>
              </tr>
              <tr>
                <td height="20" class="texto1">Poder Publico respons&aacute;vel pelo tranporte escolar</td>
                <td><select name="cmbPoderPublicoResponsavel" id="cmbPoderPublicoResponsavel" class="form-control" style="width:100pt" >
                  <option value="0">Selecione...</option>
                  <option <%if strPoderPublicoResponsavel = "0" then%> selected <%end if%> value="0">N&atilde;o</option>
                  <option <%if strPoderPublicoResponsavel = "1" then%> selected <%end if%> value="1">Sim</option>
                </select></td>
              </tr>
              <tr>
                <td height="25" class="texto1">Rodavi&aacute;rio - Vans/Kombis</td>
                <td><select name="cmbVansKombis" id="cmbVansKombis" class="form-control" style="width:100pt" >
                  <option value="0">Selecione...</option>
                  <option <%if strVansKombis = "0" then%> selected <%end if%> value="0">N&atilde;o</option>
                  <option <%if strVansKombis = "1" then%> selected <%end if%> value="1">Sim</option>
                </select></td>
              </tr>
              <tr>
                <td height="25" class="texto1">Rodavi&aacute;rio - Micro&ocirc;nibus</td>
                <td><select name="cmbMicroOnibus" id="cmbMicroOnibus" class="form-control" style="width:100pt" >
                  <option value="0">Selecione...</option>
                  <option <%if strMicroOnibus = "0" then%> selected <%end if%> value="0">N&atilde;o</option>
                  <option <%if strMicroOnibus = "1" then%> selected <%end if%> value="1">Sim</option>
                </select></td>
              </tr>
              <tr>
                <td height="25" class="texto1">Rodavi&aacute;rio - &Ocirc;nibus</td>
                <td><select name="cmbOnibus" id="cmbOnibus" class="form-control" style="width:100pt" >
                  <option value="0">Selecione...</option>
                  <option <%if strOnibus = "0" then%> selected <%end if%> value="0">N&atilde;o</option>
                  <option <%if strOnibus = "1" then%> selected <%end if%> value="1">Sim</option>
                </select></td>
              </tr>
              <tr>
                <td height="25" class="texto1">Rodavi&aacute;rio - Bicicleta</td>
                <td><select name="cmbBicicleta" id="cmbBicicleta" class="form-control" style="width:100pt" >
                  <option value="0">Selecione...</option>
                  <option <%if strBicicleta = "0" then%> selected <%end if%> value="0">N&atilde;o</option>
                  <option <%if strBicicleta = "1" then%> selected <%end if%> value="1">Sim</option>
                </select></td>
              </tr>
              <tr>
                <td height="25" class="texto1">Rodavi&aacute;rio - Tra&ccedil;&atilde;o Animal</td>
                <td><select name="cmbTransporteAnimal" id="cmbTransporteAnimal" class="form-control" style="width:100pt" >
                  <option value="0">Selecione...</option>
                  <option <%if strTransporteAnimal = "0" then%> selected <%end if%> value="0">N&atilde;o</option>
                  <option <%if strTransporteAnimal = "1" then%> selected <%end if%> value="1">Sim</option>
                </select></td>
              </tr>
              <tr>
                <td height="25" class="texto1">Rodavi&aacute;rio - Outro</td>
                <td><select name="cmbRodoviarioOutro" id="cmbRodoviarioOutro" class="form-control" style="width:100pt" >
                  <option value="0">Selecione...</option>
                  <option <%if strRodoviarioOutro = "0" then%> selected <%end if%> value="0">N&atilde;o</option>
                  <option <%if strRodoviarioOutro = "1" then%> selected <%end if%> value="1">Sim</option>
                </select></td>
              </tr>
              <tr>
                <td height="25" class="texto1">              Aquavi&aacute;rio/Embarca&ccedil;&atilde;o Capacidade de at&eacute; 5 Alunos </td>
                <td><select name="cmbCapacidade5Alunos" id="cmbCapacidade5Alunos" class="form-control" style="width:100pt" >
                  <option value="0">Selecione...</option>
                  <option <%if strCapacidade5Alunos = "0" then%> selected <%end if%> value="0">N&atilde;o</option>
                  <option <%if strCapacidade5Alunos = "1" then%> selected <%end if%> value="1">Sim</option>
                </select></td>
              </tr>
              <tr>
                <td height="25" class="texto1">Aquavi&aacute;rio/Embarca&ccedil;&atilde;o Capacidade entre 5 a 15 Alunos</td>
                <td><select name="cmbCapacidade5e15Alunos" id="cmbCapacidade5e15Alunos" class="form-control" style="width:100pt" >
                  <option value="0">Selecione...</option>
                  <option <%if strCapacidade5e15Alunos = "0" then%> selected <%end if%> value="0">N&atilde;o</option>
                  <option <%if strCapacidade5e15Alunos = "1" then%> selected <%end if%> value="1">Sim</option>
                </select></td>
              </tr>
              <tr>
                <td height="25" class="texto1">Aquavi&aacute;rio/Embarca&ccedil;&atilde;o Capacidade acima de 35 Alunos </td>
                <td><select name="cmbCapacidadeAcima35Alunos" id="cmbCapacidadeAcima35Alunos" class="form-control" style="width:100pt" >
                  <option value="0">Selecione...</option>
                  <option <%if strCapacidadeAcima35Alunos = "0" then%> selected <%end if%> value="0">N&atilde;o</option>
                  <option <%if strCapacidadeAcima35Alunos = "1" then%> selected <%end if%> value="1">Sim</option>
                </select></td>
              </tr>
              <tr>
                <td height="25" class="texto1">Ferrovi&aacute;rio - Trem/Metr&ocirc;</td>
                <td><select name="cmbTremMetro" id="cmbTremMetro" class="form-control" style="width:100pt" >
                  <option value="0">Selecione...</option>
                  <option <%if strTremMetro = "0" then%> selected <%end if%> value="0">N&atilde;o</option>
                  <option <%if strTremMetro = "1" then%> selected <%end if%> value="1">Sim</option>
                </select></td>
              </tr>
              <tr>
                <td height="25" class="texto1">Forma de ingresso do aluno ( apenas para alunos em escolas federais)</td>
                <td><select name="cmbFormaIngressoAluno" id="cmbFormaIngressoAluno" class="form-control" style="width:100pt" >
                  <option value="0">Selecione...</option>
                  <option <%if strFormaIngressoAluno = "0" then%> selected <%end if%> value="0">N&atilde;o</option>
                  <option <%if strFormaIngressoAluno = "1" then%> selected <%end if%> value="1">Sim</option>
                </select></td>
              </tr>
              <tr>
                <td colspan="2"><!--#include file="../../includes/inc_botoes_cadastro.asp"--></td>
              </tr>
            </table>
            </form>
          	</div>
       	 	</div>
         	<!-- Fecha o Form -->  
      </div>
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
		frm.action="Registro80_cod.asp?acao=" + acao;
		frm.submit();
		return true;
 	}
	</script>
    <!--=== End Content Part ===-->
   	<!--#include file="../RodapeModulo.asp"-->
	<!--#include file="../jsModulo.asp"-->
</body>
</html> 