<!--#include file="../ConfigModulo.asp"-->
<!--#include file="../../includes/inc_cnn.asp"-->
<!--#include file="../menuModulos.asp"-->
<!--#include file="../../includes/inc_formatadata.asp"-->
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
strPaginaTitulo     = "Rel_ExtratoEmprestimo_con.asp"
intTipoUsuario      = Trim(Request.Form("optTipoUsuario"))
intCodEmpresa       = Session("CodEmpresa")
intCodAluno         = Trim(Request.Form("txtCodAluno"))
strMatricula        = Trim(Request.Form("txtMatricula"))
strNomeAluno        = Trim(Request.Form("txtNomealuno"))
intCodFuncionario   = Trim(Request.Form("txtCodFuncionario"))
strNomeFuncionario  = Trim(Request.Form("txtNomeFuncionario"))
intCodComunidade    = Trim(Request.Form("txtCodComunidade"))
strNomeComunidade   = Trim(Request.Form("txtNomeComunidade"))

' Colaborador , Aluno e Comunidade
intCodAutoria         = Trim(Request.Form("cmbAutoria"))
strAutor              = Trim(Request.Form("txtAutor"))
strPalavraChave       = Trim(Request.Form("txtPalavraChave"))
strTitulo             = Trim(Request.Form("txtTitulo"))
strCdu                = Trim(Request.Form("txtCdu"))
intCodExemplar        = Trim(Request.Form("txtCodExemplar"))
strDataInicial        = Trim(Request.Form("txtDataInicial"))
strDataFinal          = Trim(Request.Form("txtDataFinal"))
strSituacaoEmprestimo = Trim(Request("cmbSituacaoEmprestimo"))

if intTipoUsuario = "" then intTipoUsuario = 1
  ' Emprestimo Aluno
  if intTipoUsuario = "1" then
    strDescricao  = "ALUNO : "
    strTipoAluno  = "checked"
    intTipoUsuario  = 1
  end if
  ' Emprestimo Professor
  if intTipoUsuario = "2" then
    strDescricao  = "COLABORADOR : "
    strTipoColaborador = "checked"
    intTipoUsuario = 2
  end if
  ' Emprestimo Comunidade
  if intTipoUsuario = "3" then
    strDescricao  = "COMUNIDADE : "
    strTipoComunidade = "checked"
    intTipoUsuario = 3
  end if
  ' Consulta Aluno
  if trim(strMatricula) <> "" then
      sql = " SELECT Codigo, Matricula, Nomealuno"
      sql = sql & " FROM SCA_ALUNO "
      sql = sql & " Where COD_EMPRESA = " & intCodEmpresa
      sql = sql & " And Matricula = " & strMatricula
      rs.open sql, cnn
      if rs.eof = false then
        intCodAluno     = TRIM(rs("Codigo"))
        strMatricula    = TRIM(rs("Matricula"))
        strNomealuno    = TRIM(rs("Nomealuno"))
      else
         %>
         <script>
            alert("Aluno não foi encontrado.");
         </script>
         <%
      end if
      rs.close
  end if
  ' Consulta Colaborador
  if trim(intCodFuncionario) <> "" then
    sql = " Select Codigo, nome, FoneResidencial, FoneComercial, FoneCelular, email"
    sql = sql & " From SRH_COLABORADOR"
    sql = sql & " Where cod_empresa = " & intCodEmpresa
    sql = sql & " and codigo  = " & intCodFuncionario
    rs.open sql, cnn
    if rs.eof = false then
      intCodFuncionario     = TRIM(rs("Codigo"))
      strNomeFuncionario    = TRIM(rs("nome"))
    else
       %>
       <script>
          alert("Funcionário não foi encontrado.");
       </script>
       <%
    end if
    rs.close
  end if
  ' Consulta Comunidade
  if trim(intCodComunidade) <> "" then
    sql = " Select Codigo, nome, FoneResidencial, FoneComercial, FoneCelular, email"
    sql = sql & " From SCB_Comunidade"
    sql = sql & " Where cod_empresa = " & intCodEmpresa
    sql = sql & " and codigo  = " & intCodComunidade
    rs.open sql, cnn
    if rs.eof = false then
      intCodComunidade    = TRIM(rs("Codigo"))
      strNomeComunidade   = TRIM(rs("nome"))
    else
       %>
       <script>
          alert("Comunidade não foi encontrado.");
       </script>
       <%
    end if
    rs.close
  end if
%>
<!--=== Content Part ===-->
<div class="container content">
  <!-- Grey Panel -->
  <div class="panel panel-grey">
    <div class="panel-heading">
      <h3 class="panel-title"><i class="fa fa-tasks"></i>Relatórios Extrato Empréstimo</h3>
    </div>
    <!-- Inicia o Painel do Formulario -->
    <div class="panel-body">
      <!-- Inicia o Form -->
      <div class="panel-body">
        <form id="frm" class="margin-bottom-10" method="post">
          <div class="row">
            <div class="col-lg-4 col-md-4">
              <label for="exampleInputEmail1">Tipo Usu&aacute;rio</label>
              <div class="form-group">
                <input name="optTipoUsuario" type="radio" value="1" <%=strTipoAluno%> onClick="MudaTipoUsuario('1')"> Aluno
                <input name="optTipoUsuario" type="radio" value="2" <%=strTipoColaborador%> onClick="MudaTipoUsuario('2')"> Colaborador
                <input name="optTipoUsuario" type="radio" value="3" <%=strTipoComunidade%> onClick="MudaTipoUsuario('3')"> Comunidade
              </div>
            </div>
          </div>

          <div id="Aba_Aluno">
            <div class="row">
              <div class="col-lg-12 col-md-12">
                <label>Aluno</label>
                <div class="form-group">
                  <input type="hidden"name="txtCodAluno" id="txtCodAluno" maxlength="20" value="<%=intCodAluno%>">
                  <ul class="list-inline">
                    <li>
                      <input type="text" class="form-control" name="txtMatricula" id="txtMatricula" placeholder="Matrícula" maxlength="20" value="<%=strMatricula%>" onKeyPress="return formataCampo(this, 2, 10)" onBlur="submit()">
                    </li>
                    <li>
                      <input type="text" class="form-control" name="txtNomealuno" id="txtNomealuno" placeholder="Nome do aluno" maxlength="50" value="<%=strNomealuno%>"  onKeyPress="return formataCampo(this, 1, 50)">
                    </li>
                    <li>
                      <button class="btn-u btn-u-green" onClick="return abreConsulta('Publicacao_con.asp')" type="button"><i class="fa fa-search"></i></button>
                    </li>
                  </ul>
                </div>
              </div>
            </div>
          </div>

          <div id="Aba_Colaborador">
            <div class="row">
              <div class="col-lg-12 col-md-12">
                <label>Coloborador</label>
                <div class="form-group">
                  <ul class="list-inline">
                    <li>
                      <input type="text" class="form-control" name="txtCodFuncionario" id="txtCodFuncionario" placeholder="Código funcionário" maxlength="20" value="<%=intCodFuncionario%>"  onKeyPress="return formataCampo(this, 2, 6)" onBlur="submit()">
                    </li>
                    <li>
                      <input type="text" class="form-control" name="txtNomeFuncionario" id="txtNomeFuncionario" placeholder="Nome funcionário" maxlength="50" value="<%=strNomeFuncionario%>" onKeyPress="return formataCampo(this, 1, 50)">
                    </li>
                    <li>
                      <button class="btn-u btn-u-green" onClick="return abreConsulta('Publicacao_con.asp')" type="button"><i class="fa fa-search"></i></button>
                    </li>
                  </ul>
                </div>
              </div>
            </div>
          </div>

          <div id="Aba_Comunidade">
            <div class="row">
              <div class="col-lg-12 col-md-12">
                <label>Comunidade</label>
                <div class="form-group">
                  <ul class="list-inline">
                    <li>
                      <input type="text" class="form-control" name="txtCodComunidade" id="txtCodComunidade" placeholder="Código comunidade" maxlength="20" value="<%=intCodComunidade%>"  onKeyPress="return formataCampo(this, 2, 6)" onBlur="submit()">
                    </li>
                    <li>
                      <input type="text" class="form-control" name="txtNomeComunidade" id="txtNomeComunidade" placeholder="Nome comunidade" maxlength="50" value="<%=strNomeComunidade%>" onKeyPress="return formataCampo(this, 1, 50)">
                    </li>
                    <li>
                      <button class="btn-u btn-u-green" onClick="return abreConsulta('Publicacao_con.asp')" type="button"><i class="fa fa-search"></i></button>
                    </li>
                  </ul>
                </div>
              </div>
            </div>
          </div>

          <div class="row">
            <div class="col-lg-4 col-md-4">
              <label for="autoria">Autoria</label>
              <div class="form-group">
                <!--#include file="../includes/inc_cmdAutoria.asp" -->
              </div>
            </div>
          </div>

          <div class="row">
            <div class="col-lg-4 col-md-4">
              <label for="autor">Autor</label>
              <div class="form-group">
                <input type="text" class="form-control" name="txtAutor"  id="txtAutor" maxlength="50" value="<%=strAutor%>" />
              </div>
            </div>
          </div>

          <div class="row">
            <div class="col-lg-4 col-md-4">
              <label for="palavraChave">Palavra Chave</label>
              <div class="form-group">
                <input type="text" class="form-control" name="txtPalavraChave"  id="txtPalavraChave" maxlength="50" value="<%=strAutor%>" />
              </div>
            </div>
          </div>

          <div class="row">
            <div class="col-lg-4 col-md-4">
              <label for="titulo">T&iacute;tulo</label>
              <div class="form-group">
                <input type="text" class="form-control" name="txtTitulo"  id="txtTitulo" maxlength="50" value="<%=strAutor%>" />
              </div>
            </div>
          </div>

          <div class="row">
            <div class="col-lg-4 col-md-4">
              <label for="cdu">CDU</label>
              <div class="form-group">
                <input type="text" class="form-control" name="txtCodCDU"  id="txtCodCDU" maxlength="10" value="<%=strAutor%>" />
              </div>
            </div>
          </div>

          <div class="row">
            <div class="col-lg-4 col-md-4">
              <label for="exemplar">Exemplar</label>
              <div class="form-group">
                <input type="text" class="form-control" name="txtCodExemplar"  id="txtCodExemplar" maxlength="10" value="<%=strAutor%>" />
              </div>
            </div>
          </div>

          <div class="row">
            <div class="col-lg-4 col-md-4">
              <label for="periodo">Per&iacute;odo</label>
              <div class="form-group">
                <ul class="list-inline">
                  <li>
                    <input name="txtDataInicial" type="text" class="form-control" id="txtDataInicial" onBlur="return validaData(this)" onKeyPress="return formataCampo(this, 3, 10)" size="11" value="<%=strDataInicial%>">
                  </li>
                  <li>a</li>
                  <li>
                    <input name="txtDataFinal" type="text" class="form-control" id="txtDataFinal" onBlur="return validaData(this)" onKeyPress="return formataCampo(this, 3, 10)" size="11" value="<%=strDataFinal%>">
                  </li>
                </ul>
              </div>
            </div>
          </div>

          <div class="row">
            <div class="col-lg-4 col-md-4">
              <label for="exampleInputEmail1">Situa&ccedil;&atilde;o do Emprestimo</label>
              <div class="form-group">
                <select class="form-control" name="cmbSituacaoEmprestimo" id="cmbSituacaoEmprestimo">
                  <option value="0">Todos...</option>
                  <option value="E" <%if strSituacaoEmprestimo = "E" then response.Write("selected") %>>Emprestados </option>
                  <option value="D" <%if strSituacaoEmprestimo = "D" then response.Write("selected") %>>Devolvidos</option>
                </select>
              </div>
            </div>
          </div>

          <legend></legend>
          <!--#include file="../../includes/inc_botoes_geraRelatorio.asp"-->
          </form>
      </div>
      <!-- Fecha o Form -->
    </div>
  </div>
</div>

<!--/container-->
<script>
function Descricao(tipo){
  if (document.all["mostraDescricao"+tipo].style.display =="none"){
    document.all["mostraDescricao"+tipo].style.display="block";
    document.all["imgDescricao"+tipo].src="../../images/up.jpg";
  }
  else{
    document.all["mostraDescricao"+tipo].style.display="none";
    document.all["imgDescricao"+tipo].src="../../images/down.jpg";
  }
}

function AbreFecha(Linha,Figura){
  if (Linha.style.display == "block"){
    Linha.style.display = "none";
    Figura.src="<%=session("strCaminhoRaiz")%>/images/plus.bmp"
  }
  else{
    Linha.style.display = "block";
    Figura.src="<%=session("strCaminhoRaiz")%>/images/minus.bmp"
  }
}

function abrirComunidade(){
  window.open("Comunidade_cad.asp","consulta", "top=0,left=0,height=510,width=575,menubar=no,toolbar=no,scrollbars=yes,status=yes");
  return true;
}

function AbaTipoUsuario(){
  Aba_Colaborador.style.display="none"
  Aba_Comunidade.style.display="none"
}

Aba_Aluno.style.display = "block"
Aba_Colaborador.style.display = "none"
Aba_Comunidade.style.display="none"

function MudaTipoUsuario(acao){
  // 1 - Aluno
  // 2 - Colaborador
  // 3 - Comunidade
  var frm = document.getElementById("frm");

  if (acao == 1){
    Aba_Aluno.style.display = "block"
    Aba_Colaborador.style.display = "none"
    Aba_Comunidade.style.display="none"
    frm.txtCodFuncionario.value = '';
    frm.txtNomeFuncionario.value = '';
    frm.txtCodComunidade.value = '';
    frm.txtNomeComunidade.value = '';
  }

  if (acao == 2){
    Aba_Aluno.style.display = "none"
    Aba_Colaborador.style.display = "block"
    Aba_Comunidade.style.display="none"
    frm.txtMatricula.value = '';
    frm.txtNomealuno.value = '';
    frm.txtCodComunidade.value = '';
    frm.txtNomeComunidade.value = '';
  }

  if (acao == 3){
    Aba_Aluno.style.display = "none"
    Aba_Colaborador.style.display = "none"
    Aba_Comunidade.style.display="block"
    frm.txtMatricula.value = '';
    frm.txtNomealuno.value = '';
    frm.txtCodFuncionario.value = '';
    frm.txtNomeFuncionario.value = '';
  }

}

function gerar(){
  var TipoUsuario = 0;
  var frm = document.getElementById("frm");
  if ((frm.optTipoUsuario.checked==false)) {
    alert("O Tipo de Usuario deve ser informado.");
    frm.optTipoUsuario.focus();
    return false;
  }
  frm.action = "Rel_ExtratoEmprestimo_rel.asp";
  frm.submit();
  return true;
}
</script>
<!--=== End Content Part ===-->
  <!--#include file="../RodapeModulo.asp"-->
<!--#include file="../jsModulo.asp"-->
</body>
</html>