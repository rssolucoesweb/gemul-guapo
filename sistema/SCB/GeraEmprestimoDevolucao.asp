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
strDesabilitaGerarEmprestimo  = ""
intQtdeJaReservada    = 0
strPagina             = "GeraEmprestimoDevolucao.asp"
intCodEmpresa         = Session("CodEmpresa")
intTipoUsuario        = Trim(Request.Form("optTipoUsuario"))
intCodAluno           = Trim(Request.Form("txtCodAluno"))
strMatricula          = Trim(Request.Form("txtMatricula"))
strNomeAluno          = Trim(Request.Form("txtNomealuno"))
intCodFuncionario     = Trim(Request.Form("txtCodFuncionario"))
strNomeFuncionario    = Trim(Request.Form("txtNomeFuncionario"))
intCodComunidade      = Trim(Request.Form("txtCodComunidade"))
strNomeComunidade     = Trim(Request.Form("txtNomeComunidade"))
strDataAtual          = formataDataAP(date)

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
    sql = " SELECT SCA_ALUNO.Codigo, SCA_ALUNO.Matricula, SCA_ALUNO.Nomealuno, SCA_SITUACAOALUNO.Desc_SituacaoAluno"
    sql = sql & " FROM SCA_ALUNO "
    sql = sql & " LEFT JOIN SCA_SITUACAOALUNO ON SCA_SITUACAOALUNO.Cod_SituacaoAluno = SCA_ALUNO.COD_SITUACAOALUNO AND SCA_SITUACAOALUNO.Cod_Empresa = SCA_ALUNO.COD_EMPRESA "
    sql = sql & " Where SCA_ALUNO.COD_EMPRESA = " & intCodEmpresa
    sql = sql & " And SCA_ALUNO.Matricula = " & left(strMatricula,9)
    rs.open sql, cnn
    if rs.eof = false then
      intCodAluno     = TRIM(rs("Codigo"))
      strMatricula    = TRIM(rs("Matricula"))
      strNomealuno    = TRIM(rs("Nomealuno"))
      if rs("Desc_SituacaoAluno") <> "ATIVO" And rs("Desc_SituacaoAluno") <> "PRÉ-MATRÍCULA" then
        strDesabilitaGerarEmprestimo   = "disabled"
      end if
	  response.write "<br>1: " & strDesabilitaGerarEmprestimo
  else
    %>
    <script>
       alert("Aluno não foi encontrado ou Inativo.");
       window.history.back();
    </script>
   <%
   response.end
  end if
  rs.close
end if



' Consulta Colaborador
if trim(intCodFuncionario) <> "" then
  sql = " Select Codigo, nome, FoneResidencial, FoneComercial, FoneCelular, email"
  sql = sql & " From SRH_COLABORADOR"
  sql = sql & " Where cod_empresa = " & intCodEmpresa
  sql = sql & " and codigo  = " & intCodFuncionario
  sql = sql & " and situacao  = 'A'"
  rs.open sql, cnn

  if rs.eof = false then
    intCodFuncionario     = TRIM(rs("Codigo"))
    strNomeFuncionario    = TRIM(rs("nome"))
  else
    %>
    <script>
     alert("Funcionário não foi encontrado ou Inativo.");
     window.history.back();
    </script>
    <%
    response.end
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

if intTipoUsuario <> "" then
  sql = "SELECT Cod_TipoUsuario, Nome, QtdeExemplar, Valor"
  sql = sql & " FROM SCB_TIPOUSUARIO"
  sql = sql & " where Cod_empresa = " & session("codEmpresa")
  sql = sql & " and Cod_TipoUsuario = " & intTipoUsuario
  rs.open sql, cnn
  if rs.eof = false then
    intQtdeExemplar   = TRIM(rs("QtdeExemplar"))
    strTipoNomeUsuario  = TRIM(rs("Nome"))
  end if
  rs.close
end if
%>
<!--=== Content Part ===-->
<div class="container content">
  <!-- Grey Panel -->
  <div class="panel panel-grey">
    <div class="panel-heading">
      <h3 class="panel-title"><i class="fa fa-tasks"></i>Cadastro de Empréstimo / Devolução</h3>
    </div>
    <!-- Inicia o Painel do Formulario -->
    <div class="panel-body">
      <!-- Inicia o Form -->
      <div class="panel-body">
        <form id="frm" method="post">

          <div class="row">
            <div class="col-lg-4 col-md-4">
              <label for="tipoUsuario">Tipo Usu&aacute;rio</label>
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
                    <button class="btn-u btn-u-green" onClick="return abreConsulta('../SCA/Aluno_con.asp')" type="button"><i class="fa fa-search"></i></button>
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
                  <button class="btn-u btn-u-green" onClick="return abreConsulta('../SRH/Colaborador_con.asp')" type="button"><i class="fa fa-search"></i></button>
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
                <button class="btn-u btn-u-green" onClick="return abreConsulta('Comunidade_con.asp')" type="button"><i class="fa fa-search"></i></button>
              </li>
            </ul>
          </div>
        </div>
      </div>
    </div>

    <div class="form-group">
      <table width="98%" border="0" cellspacing="0" cellpadding="0">
        <tr>
          <td>
            <%
            if intCodAluno <> "" or intCodFuncionario <> "" or intCodComunidade <> ""  then
            cont =0
            sql = " SELECT SCB_Emprestimo.Cod_Emprestimo, SCA_ALUNO.Matricula, SCB_Emprestimo.Cod_aluno,"
            sql = sql & " SCA_ALUNO.NOMEALUNO, SRH_COLABORADOR.Codigo as CodColaborador, SRH_COLABORADOR.Nome as Colaborador, "
            sql = sql & " SCB_Comunidade.Codigo, SCB_Comunidade.Nome, SCF_DEBITOALUNO.cod_situacao_pagamento "
            sql = sql & " FROM SCB_Emprestimo "
            sql = sql & " left JOIN SCA_ALUNO ON SCB_Emprestimo.Cod_aluno = SCA_ALUNO.Codigo "
            sql = sql & " left JOIN SRH_COLABORADOR ON SCB_Emprestimo.Cod_Colaborador = SRH_COLABORADOR.Codigo "
            sql = sql & " left JOIN SCB_Comunidade ON SCB_Emprestimo.Cod_Comunidade = SCB_Comunidade.Codigo "
            sql = sql & " left join SCF_DEBITOALUNO ON SCF_DEBITOALUNO.Codigo = SCB_Emprestimo.Cod_DebitoAluno "
            sql = sql & " WHERE SCB_Emprestimo.Situacao = 'E'"
            sql = sql & " AND SCB_Emprestimo.Cod_Empresa =  " & Session("CodEmpresa")

            if intTipoUsuario = 1 then
              sql = sql & " AND SCB_Emprestimo.Cod_aluno =  " & intCodAluno
            end if

            if intTipoUsuario = 2 then
              sql = sql & " AND SCB_Emprestimo.Cod_Colaborador =  " & intCodFuncionario
            end if

            if intTipoUsuario = 3 then
              sql = sql & " AND SCB_Emprestimo.Cod_Comunidade =  " & intCodComunidade
            end if
            rs.open sql, cnn

            if rs.eof = false then
            While not rs.eof

            cont = cont + 1

            strCodigoEmprestimo = rs("Cod_Emprestimo")
            intCodSituacaoPagamento = rs("cod_situacao_pagamento")

            if intTipoUsuario = 1 then
              intCodigo   = rs("Matricula")
              strNome   = rs("NOMEALUNO")
            end if

            if intTipoUsuario = 2 then
              intCodigo   = rs("CodColaborador")
              strNome   = rs("Colaborador")
            end if

            if intTipoUsuario = 3 then
              intCodigo   = rs("Codigo")
              strNome   = rs("Nome")
            end if
            %>
            <table width="98%" align="center" cellpadding="0" cellspacing="0"  bordercolor="#CCCCCC" class="tabela">
              <tr bgcolor="#E5E5E5">
                <td width="3%" height="20" class="celula" align="center" style="cursor:hand" onClick="AbreFecha(L<%=cont%>,F<%=cont%>)"><img src="<%=session("strCaminhoRaiz")%>/images/plus.bmp" id="F<%=cont%>"></td>
                <td class="celula">&nbsp;&nbsp;&nbsp;&nbsp;<strong><%=strDescricao%><%=intCodigo%>&nbsp;- <%=strNome%> - Empr&eacute;stimo n.: <%=strCodigoEmprestimo%></strong></td>
              </tr>
              <tr id="L<%=cont%>" style="display:none" >
                <td height="64" class="celula"><img src="../../images/pesquisa.jpg" width="95" height="109"></td>
                <td valign="top" align="center" class="celula"><!-- inicio parcela-->
                  <table width="100%" border="0" cellspacing="0" cellpadding="0" class="tabela">
                    <tr valign="top" bgcolor="#E5E5E5" >
                      <td width="27" align="center" class="celula"><strong>S</strong></td>
                      <td width="47" align="center" class="celula"><strong>Exe.</strong></td>
                      <td width="365" class="celula"><strong>Titulo</strong></td>
                      <td class="celula"><strong>Autores</strong></td>
                      <td class="celula"><strong>CDU</strong></td>
                      <td align="center" class="celula"><strong>Data Devolu&ccedil;&atilde;o</strong></td>
                      <td align="center" class="celula"><strong>Campus</strong></td>
                    </tr>
                    <%

                    sql = "select PE.Cod_Publicacao, E.Cod_Emprestimo,  I.cod_item, I.DataDevolucao, P.Titulo, "
                    sql = sql & " P.SubTitulo, P.Cod_CDU, PE.Cod_PublicacaoExemplares, LG.descricao AS Campus  "
                    sql = sql & " from scb_emprestimo E"
                    sql = sql & " Inner join SCB_EmprestimoItens I on I.Cod_Emprestimo = E.Cod_Emprestimo"
                    sql = sql & " inner join SCB_PUBLICACAOEXEMPLARES PE on PE.Cod_PublicacaoExemplares = I.Cod_PublicacaoExemplares"
                    sql = sql & " inner join SCB_PUBLICACAO P on P.Cod_Publicacao = PE.Cod_Publicacao"
                    sql = sql & " left join SCB_LOCALIZACAOGEOGRAFICA LG on LG.Codigo = PE.Cod_LocalizacaoGeografica "
                    sql = sql & " where e.cod_empresa = " & Session("CodEmpresa")
                    sql = sql & " and e.Cod_Emprestimo = " & rs("Cod_Emprestimo")
                    sql = sql & " and I.status = 'A'" 'somente os ativos
                    rs1.open sql, cnn

                    if rs1.eof = false then

                    CodEmprestimo = rs1("Cod_Emprestimo")

                    while not rs1.eof

                    strDescAutor = ""

                    intQtdeJaReservada = intQtdeJaReservada + 1

                        ' Consulta os Autores
                        sql = " SELECT SCB_PUBLICACAOAUTORES.Cod_Autor, SCB_AUTORES.Nome_Autor "
                        sql = sql & " FROM SCB_PUBLICACAOAUTORES INNER JOIN SCB_AUTORES "
                        sql = sql & " ON (SCB_PUBLICACAOAUTORES.Cod_Autor = SCB_AUTORES.Cod_Autor) "
                        sql = sql & " WHERE SCB_PUBLICACAOAUTORES.Cod_Publicacao = " & rs1("Cod_Publicacao")
                        rsAux.open sql, cnn

                        if rsAux.eof = false then
                        while not rsAux.eof

                        if trim(strDescAutor) = "" then
                        strDescAutor  = rsAux("Nome_Autor")
                        else
                        strDescAutor  = strDescAutor & " | " & rsAux("Nome_Autor")
                        end if
                        rsAux.movenext

                        wend
                        end if
                        rsAux.close


                        ' Testa se o Exemplar esta em atraso usuário possui publicação vencida
                        sql = " select i.DataDevolucao from scb_emprestimo e "
                        sql = sql & " inner join scb_emprestimoitens i on e.Cod_Emprestimo = i.Cod_Emprestimo "
                        sql = sql & " where e.cod_empresa = " & session("codEmpresa")
                        sql = sql & " and i.Status = 'A' "
                        sql = sql & " and e.situacao = 'E' "
                        sql = sql & " and convert(datetime,convert(varchar, i.DataDevolucao, 103),103) <  convert(datetime, ' " & strDataAtual & "',103)"
                        sql = sql & " and i.Cod_PublicacaoExemplares = " & rs1("Cod_PublicacaoExemplares")

                        if trim(intCodAluno) <> "" then
                        sql = sql & " and       e.cod_Aluno = " & intCodAluno
                        end if

                        if trim(intCodColaborador) <> "" then
                        sql = sql & " and       e.cod_Colaborador = " & intCodColaborador
                        end if

                        if trim(intCodComunidade) <> "" then
                        sql = sql & " and         e.cod_Comunidade = " & intCodComunidade
                        end if
                        rsAux.open sql, cnn

                        if rsAux.eof = false then
                        strExisteExemplarAtrasado = "True"
                        end if
                        rsAux.close

                        ' Verifica se a Data de Devolução e menor do que a data atual
                        if strExisteExemplarAtrasado = "True" then
                        if session("NivelPermissao") = "A" then
                                strDesabilitaRenovacao  = "" 'Habilita o botão Incluir
                                strDesabilitaPrincipal = "" 'Habilita o botão Incluir
                                else
                                if  isnull(intCodSituacaoPagamento)  then   'Verifica se a parcela referente a multa foi paga
                                    strDesabilitaRenovacao = "disabled" 'Desabilita o botão Incluir
                                    strDesabilitaPrincipal = "disabled" 'Desabilita o botão Incluir
                                    else
                                    strDesabilitaRenovacao = "" 'Desabilita o botão Incluir
                                    strDesabilitaPrincipal = "" 'Desabilita o botão Incluir
                                    end if
                                    end if
                                    else
                            strDesabilitaRenovacao  = "" 'Habilita o botão Incluir
                            strDesabilitaPrincipal = "" 'Habilita o botão Incluir
                            end if
                            %>
                            <tr>
                              <td align="center" class="celula"><input type="checkbox" name="chkCodExemplar" value="<%=rs1("Cod_PublicacaoExemplares")%>" <%=selecionado%>></td>
                              <td height="21" align="center" class="celula"><%=rs1("Cod_PublicacaoExemplares")%></td>
                              <td class="celula"><%=rs1("Titulo")%></td>
                              <td width="190" class="celula"><%=strDescAutor%></td>
                              <td width="112" class="celula"><%=rs1("Cod_CDU")%></td>
                              <td width="71" align="center" class="celula"><%=formataDataAP(rs1("DataDevolucao"))%>&nbsp;</td>
                              <td width="70" align="center" class="celula"><%=rs1("Campus")%>&nbsp;</td>
                            </tr>
                            <%
                            rs1.movenext
                            wend
                            else

                            sql = "Delete from scb_emprestimo "
                            sql = sql & " where Cod_Emprestimo = " & rs("Cod_Emprestimo")
                            cnn.execute sql

                            end if
                            rs1.close
                            strTipoUsuario = 1
                            %>
                            <tr>
                              <td height="28" colspan="7" align="center" class="celula" ><input name="cmdConfima" type="button"  class="botao" id="cmdConfima" style="cursor:hand" onClick="GerarDevolucao()"   value="Confirma Devolu&ccedil;&atilde;o" <%=strDesabilitaPrincipal%>>&nbsp;
                                <input name="cmdRenovacaoAutomatica" type="button"  class="botao" id="cmdRenovacaoAutomatica" style="cursor:hand" onClick="RenovacaoAutomatica()"   value="Renova&ccedil;&atilde;o Automat&iacute;ca" <%=strDesabilitaRenovacao%>></td>
                              </tr>
                              <%if intTipoUsuario = 1 then %>
                              <tr>
                                <td height="28" align="center" class="celula" ><img style="cursor:hand" onClick="return Descricao('<%=intTipoUsuario%>')" id="imgDescricao<%=intTipoUsuario%>" src="../../images/down.jpg"></td>
                                <td height="28" colspan="6" class="celula" ><strong>Outros Dados...</strong></td>
                              </tr>
                              <%end if%>
                              <tr id="mostraDescricao<%=intTipoUsuario%>" style="display:none">
                                <td height="28" colspan="7" align="center" class="celula" ><!--#include file="../includes/inc_sqlDadosAluno.asp" --></td>
                              </tr>
                            </table></td>
                          </tr>
                        </table>
                        <br>
                        <%
                        rs.movenext
                        wend
                        end if
                        rs.close
                        end if
						
					if 	cint(intQtdeJaReservada)<>0 and cint(intQtdeExemplar)<>0 then
						if cint(intQtdeJaReservada) >= cint(intQtdeExemplar)  then
							strDesabilitaGerarEmprestimo  = "disabled" 'Desabilita o botão Excluir
						end if
					end if
					
                    if strExisteExemplarAtrasado = "True"  then
						strDesabilitaGerarEmprestimo  = "disabled" 'Desabilita o botão Excluir
                    end if
					
                    if intTipoUsuario = 1 then
						if trim(strMatricula) = "" then strDesabilitaGerarEmprestimo = "disabled"
                    end if
					
                    if intTipoUsuario = 2 then
						if trim(intCodFuncionario) = "" then strDesabilitaGerarEmprestimo = "disabled"
                    end if
                    if intTipoUsuario = 3 then
						if trim(intCodComunidade) = "" then strDesabilitaGerarEmprestimo = "disabled"
                    end if
                    %>
                    </td>
                  </tr>
                </table>
              </div>
              <legend></legend>
              <input type="button" name="cmdGerarEmprestimo" style="cursor:hand"   value="Gerar Emprestimo" class="btn-u float-shadow" <%=strDesabilitaGerarEmprestimo%> onClick="GerarEmprestimo()">
              <input type="button" name="cmdLimpar"  style="cursor:hand"  value="Limpar"  class="btn-u btn-u-orange float-shadow" <%=strDesabilitaLimpar%> onClick="window.location='<%=strPagina%>'">
              <input type="button" name="cmdPrincipal" style="cursor:hand"   value="Principal"  class="btn-u btn-u-default float-shadow" <%=strDesabilitaPrincipal%> onClick="window.location='Default.asp'"></td>
            </form>
          </div>
        </div>
        <!-- Fecha o Form -->
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

function ConsultaPreReserva(){
  frm.action="ConfirmaPreReserva_cad.asp";
  frm.submit();
  return true;
}

function abrirComunidade(){
  window.open("Comunidade_cad.asp","consulta", "top=0,left=0,height=510,width=575,menubar=no,toolbar=no,scrollbars=yes,status=yes");
  return true;
}

function AbaTipoUsuario(){
  Aba_Colaborador.style.display="none"
  Aba_Comunidade.style.display="none"
}

Aba_Aluno.style.display = "block";
Aba_Colaborador.style.display = "none";
Aba_Comunidade.style.display="none";

function MudaTipoUsuario(acao){
  // 1 - Aluno
  // 2 - Colaborador
  // 3 - Comunidade
  if (acao == 1){
    Aba_Aluno.style.display = "block";
    Aba_Colaborador.style.display = "none";
    Aba_Comunidade.style.display="none";
    frm.txtCodFuncionario.value = '';
    frm.txtNomeFuncionario.value = '';
    frm.txtCodComunidade.value = '';
    frm.txtNomeComunidade.value = '';
  }
  if (acao == 2){
    Aba_Aluno.style.display = "none";
    Aba_Colaborador.style.display = "block";
    Aba_Comunidade.style.display="none";
    frm.txtMatricula.value = '';
    frm.txtNomealuno.value = '';
    frm.txtCodComunidade.value = '';
    frm.txtNomeComunidade.value = '';
  }
  if (acao == 3){
    Aba_Aluno.style.display = "none";
    Aba_Colaborador.style.display = "none";
    Aba_Comunidade.style.display="block";
    frm.txtMatricula.value = '';
    frm.txtNomealuno.value = '';
    frm.txtCodFuncionario.value = '';
    frm.txtNomeFuncionario.value = '';
  }
}

function ConsultaEmprestimo(){
  var TipoUsuario = 0;
  if ((frm.optTipoUsuario.checked==false)){
    alert("O Tipo de Usuario deve ser informado.");
    frm.optTipoUsuario.focus();
    return false;
  }

  if (frm.optTipoUsuario[0].checked){
    TipoUsuario = frm.optTipoUsuario[0].value
    if (frm.txtMatricula.value == "") {
      alert("A Matricula deve ser informado !");
      frm.txtMatricula.focus();
      return false;
    }
  }

  if (frm.optTipoUsuario[1].checked){
    TipoUsuario = frm.optTipoUsuario[1].value
    if (frm.txtCodFuncionario.value == "") {
      alert("O Coloborador deve ser informado !");
      frm.txtCodFuncionario.focus();
      return false;
    }
  }

  if (frm.optTipoUsuario[2].checked){
    TipoUsuario = frm.optTipoUsuario[2].value
    if (frm.txtCodComunidade.value == "") {
      alert("A Comunidade deve ser informada !");
      frm.txtCodComunidade.focus();
      return false;
    }
  }
  frm.submit();
  return true;
}

function GerarDevolucao(acao){
  var intContMarcado=0;
  var intCodidgo="0";
  for (var i = 0; i < frm.elements.length; i++){
    //verifica todos os checkbox
    if (frm.elements[i].name.substring(0,19) == "chkCodExemplar"){
      if (frm.elements[i].checked) {
        intContMarcado = intContMarcado + 1;
        intCodidgo = intCodidgo + "," + frm.elements[i].value;
      }
    }
  }
  if (intContMarcado==0){
    alert("Pelo meno um Exemplar deve ser selecionado, Verifique!");
    return false;
  }
  frm.action="GerarDevolucao_cod.asp?acao=" + acao;
  frm.submit();
  return true;
}

function RenovacaoAutomatica(acao){

  var intContMarcado=0;
  var intCodidgo="0";

  for (var i = 0; i < frm.elements.length; i++){
    //verifica todos os checkbox
    if (frm.elements[i].name.substring(0,19) == "chkCodExemplar"){
      if (frm.elements[i].checked) {
        intContMarcado = intContMarcado + 1;
        intCodidgo = intCodidgo + "," + frm.elements[i].value;
      }
    }
  }
  if (intContMarcado==0){
    alert("Pelo meno um Exemplar deve ser selecionado, Verifique!");
    return false;
  }
  frm.action="GerarRenovacao_cod.asp?acao=" + acao;
  frm.submit();
  return true;
}

function GerarEmprestimo(){
  var TipoUsuario = 0;
  if ((frm.optTipoUsuario.checked==false)) {
    alert("O Tipo de Usuario deve ser informado.");
    frm.optTipoUsuario.focus();
    return false;
  }
  if (frm.optTipoUsuario[0].checked){
    TipoUsuario = frm.optTipoUsuario[0].value
    if (frm.txtMatricula.value == "") {
      alert("A Matricula deve ser informado !");
      frm.txtMatricula.focus();
      return false;
    }
  }

  if (frm.optTipoUsuario[1].checked){
    TipoUsuario = frm.optTipoUsuario[1].value
    if (frm.txtCodFuncionario.value == "") {
      alert("O Coloborador deve ser informado !");
      frm.txtCodFuncionario.focus();
      return false;
    }
  }

  if (frm.optTipoUsuario[2].checked){
    TipoUsuario = frm.optTipoUsuario[2].value
    if (frm.txtCodComunidade.value == "") {
      alert("A Comunidade deve ser informada !");
      frm.txtCodComunidade.focus();
      return false;
    }
  }
  var caminho;
  caminho = "GerarEmprestimo_cad.asp?TipoUsuario=" + TipoUsuario + "&Matricula=" + frm.txtMatricula.value + "&CodFuncionario=" + frm.txtCodFuncionario.value + "&CodComunidade=" + frm.txtCodComunidade.value;
  window.open(caminho,"","top=0,left=0, height=527,width=900,menubar=no,toolbar=no,scrollbars=yes,status=yes");
  return true;
}

function abreConsulta(caminho){
  window.open(caminho,"abreConsulta","top=5,left=5,height=510,width=700,menubar=no,toolbar=no,scrollbars=yes,status=yes");
}
</script>
<!--=== End Content Part ===-->
<!--#include file="../RodapeModulo.asp"-->
<!--#include file="../jsModulo.asp"-->
</body>
</html>