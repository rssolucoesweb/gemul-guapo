<!--#include file="../ConfigModulo.asp"-->
<!--#include file="../../includes/inc_cnn.asp"-->
<!--#include file="../../includes/inc_formatadata.asp"-->
<!--#include file="../menuModulos.asp"-->
<script src="../../js/js_funcoes_gerais.js"></script>  
    <!--=== Breadcrumbs ===-->
    <div class="breadcrumbs">
        <div class="container">
            <h1 class="pull-left">EST - Controle Almoxarifado</h1>
            <ul class="pull-right breadcrumb">
                <li><a href="Default.asp">Home</a></li>
                <li class="active"><%=session("CodEmpresa")%> - <%=session("EmpresaWeb")%></li>
            </ul>
        </div><!--/container-->
    </div><!--/breadcrumbs-->
    <!--=== End Breadcrumbs ===-->
	<%  
        StrReloadSistema	= "S"
        principal			= "principal.asp"
        intCodEmpresa		= session("CodEmpresa")	
        strNumero			= Trim(Request.Form("txtNumero"))
        intCodSituacaoRequisicao	 		= Trim(Request.Form("cmbSituacaoRequisicao"))
        if intCodSituacaoRequisicao = "" then intCodSituacaoRequisicao = "0"
        intCodDepartamento	 		= Trim(Request.Form("cmbDepartamento"))
        if intCodDepartamento = "" then intCodDepartamento = "0"	
        strConsultar	= request("strConsultar")
        strSubmitDepto = "N"
        strDataI 		= formatadataBD(request("txtDataI"))
        strDataF 		= formatadataBD(request("txtDataF"))
    %>
    <!--=== Content Part ===-->
    <div class="container content">		
    
      <!-- Grey Panel -->            
      <div class="panel panel-grey">
        <div class="panel-heading">
        	<h3 class="panel-title"><i class="fa fa-tasks"></i>Consultar Solicitações</h3>
        </div>
        <!-- Inicia o Painel do Formulario -->     
        <div class="panel-body">
             <!-- Inicia o Form -->     
            <div class="panel-body">                                                        
                <form id="frm" name="frm" action="ConsultaRequisicao_con.asp" method="post">
                <input name="strConsultar" value="s" type="hidden">
                	
                  <div class="form-group">
                    <label class="form-label">C&oacute;d. Solicita&ccedil;&atilde;o</label>
                    <input name="txtNumero" type="text" class="form-control" id="txtNumero" size="7" maxlength="10" value="<%=strNumero%>"  onKeyPress="return formataCampo(this,2,5)">
                  </div>
                  
                  <div class="form-group">
                    <label class="form-label">Per&iacute;odo</label>
                    <input name="txtDataI" id="txtDataI" type="text" class="form-control" onBlur="return validaData(this)" onKeyPress="return formataCampo(this, 3, 10)" value="<%=strDataI%>" size="10" maxlength="10">
                    a
                    <input name="txtDataF" id="txtDataF" type="text" class="form-control" onBlur="return validaData(this)" onKeyPress="return formataCampo(this, 3, 10)" value="<%=strDataF%>" size="10" maxlength="10">
                  </div>
                  
                  <div class="form-group">
                    <label class="form-label">Depto./Unidade</label>
                    <!--#include file="../includes/inc_cmbDepartamentoEstoque.asp"-->
                  </div>
                  
                  <div class="form-group">
                    <label class="form-label">Situa&ccedil;&atilde;o</label>
                    <!--#include file="../includes/inc_cmbSituacaoRequisicao.asp"-->
                  </div>

                  <legend></legend>
				  <input name="Submit" type="button" onClick="resultadoConsulta()" class="btn btn-u float-shadow" id="button" value="   Consultar Solicita&ccedil;&otilde;es   ">
                </form>
       	  </div>
   	 	</div>
         	<!-- Fecha o Form -->  
      </div>
   	   
       <!--Table Bordered-->
       <%if strConsultar="s" then %>
        <div class="panel panel-grey margin-bottom-40">
            <div class="panel-heading">
                <h3 class="panel-title"><i class="fa fa-globe"></i> Lista Solicitações</h3>
          </div>
            <div class="panel-body">
            	<div class="table-responsive">
                <table class="table table-bordered">
                    <thead>
                        <tr>
                          <th width="3%" bgcolor="#95A5A6">#</th>
                          <th width="7%" bgcolor="#95A5A6">C&oacute;d.</th>
                          <th width="33%" bgcolor="#95A5A6">Departamento/Unidade</th>
                          <th width="15%" bgcolor="#95A5A6">Solicitante</th>
                          <th width="11%" bgcolor="#95A5A6">Situa&ccedil;&atilde;o</th>
                          <th width="11%" bgcolor="#95A5A6">Autorizado Por</th>
                          <th width="10%" bgcolor="#95A5A6">Liberada Por</th>
                          <th width="10%" bgcolor="#95A5A6">Emitir</th>
                      </tr>
                    </thead>
                  <%
                    cont =0

					sql = "select _r.codigo, _r.obs, _u.USUA_NOME_COMPLETO as usuario_solicitante, _r.dataEntrada, "
					sql = sql & " case "
					sql = sql & " 	when _di.codigo is null then _d.descricao "
					sql = sql & " 	else _dd.descricao "
					sql = sql & " 	end as depto, "	
					sql = sql & " 	_s.descricao as situacao, _uaa.USUA_NOME_COMPLETO as usuario_autorizacao, _r.data_autorizacao, _ua.USUA_NOME_COMPLETO as usuario_liberacao, _r.data_liberacao, _r.codSituacao"
					sql = sql & " from est_requisicao _r"
					sql = sql & " LEFT join SEG_USUARIOS_SISTEMA _u on _u.USUA_CPF = _r.solicitante"
					sql = sql & " LEFT join SEG_USUARIOS_SISTEMA _ua on _ua.USUA_CPF = _r.usuario_liberacao"
					sql = sql & " LEFT join SEG_USUARIOS_SISTEMA _uaa on _uaa.USUA_CPF = _r.usuario_autorizacao"
					sql = sql & " LEFT join EST_departamento _d on _d.codigo = _u.CODIGO_DEPARTAMENTO"
					sql = sql & " left  join EST_departamento _dd				on _dd.codigo = _r.codDepartamento "
					sql = sql & " left  join est_requisicaoDistribuicao _di	on _di.codRequisicao = _r.codigo "
					sql = sql & " LEFT join EST_situacao _s on _s.codigo = _r.codSituacao"
					sql = sql & " where 1=1"
					sql = sql & " and _r.CodEmpresa = " & session("CodEmpresa")	
					
					if intCodDepartamento<>"0" then
						sql = sql & " and _d.codigo = " & intCodDepartamento
					end if
					
					if intCodSituacaoRequisicao<>"0" then
						sql = sql & " and _r.codSituacao = " & intCodSituacaoRequisicao
					end if
					
					if strNumero<>"" then
						sql = sql & " and _r.codigo = " & strNumero
					end if
					
					if strDataI<>"" and strDataF<>"" then
						sql = sql & " and _r.dataEntrada between '" & strDataI & "' and '" & strDataF & "'"
					end if
					
					sql = sql & " order by _r.data_liberacao, _r.data_autorizacao, _r.codigo"
					rs.open sql, cnn
					
					if rs.eof = false then
                    
                    while not rs.eof
						cont = cont + 1	
			        %>
                    <tbody>
                        <tr>
                        <td><div align="center"><a href="javascript:showTr(1)">[+]</a></div></td>
                        <td><%=rs("Codigo")%></td>
                        <td><%=trim(rs("depto"))%></td>
                        <td><%=trim(rs("usuario_solicitante"))%><br><%=trim(Rs("dataEntrada"))%></td>
                        <td><%=trim(rs("situacao"))%></td>
                        <td><%=trim(rs("usuario_autorizacao"))%><br><%=trim(Rs("data_autorizacao"))%></td>
                        <td><%=trim(rs("usuario_liberacao"))%><br><%=trim(Rs("data_liberacao"))%></td>
                        <td><%if rs("codSituacao")="4" then%><input class="btn btn-u float-shadow" type="button" name="button2" id="button2" value="Imprimir" onClick="window.location='Rel_SolicitacaoAutorizada_rel.asp?req=<%=rs("codigo")%>'"><%end if%>                        </td>
                        </tr>
                        <tr id="tr1" style="display:none;">
                          <td colspan="8">
                          
                          	<!-- execucao -->
							<%if not isnull(rs("obs")) then%>
                           	<table class="table table-bordered">
                              <tr bgcolor="#FFB7B7">
                                <td width="26%" rowspan="2" align="center"><STRONG>Observa&ccedil;&atilde;o/Justificativa</STRONG></td>
                                <td rowspan="2" align="left" class="celula"><%=rs("obs")%>&nbsp;</td>
                              </tr>
                             </table>
                             <%end if%>
                             
                          	<table class="table table-bordered">
                              <tr>
                                <td width="19%" rowspan="2" align="center"><STRONG>Material</STRONG></td>
                                <td width="10%" rowspan="2" align="center"><STRONG>Unidade</STRONG></td>
                                <td width="17%" rowspan="2" align="center"><STRONG>Grupo</STRONG></td>
                                <td width="20%" rowspan="2" align="center"><STRONG>Subgrupo</STRONG></td>
                                <td colspan="3" align="center"><STRONG>Quantidade</STRONG></td>
                              </tr>
                              <tr>
                                <td width="9%" align="center"><strong>Solicitada</strong></td>
                                <td width="9%" align="center"><strong>Autorizada</strong></td>
                                <td width="16%" align="center"><strong>Liberada</strong></td>
                              </tr>
                              <%
                            sql = "  select	_p.DESCRICAO as produto,_rp.codigo, _rp.codProduto,_up.descricao as unidade,_s.descricao as secao, _g.DESCRICAO as grupo,_sg.DESCRICAO as subgrupo,_rp.quantidade,"
                            sql = sql & " 	_rp.quantidade_autorizada, _rp.quantidade_liberada,"
                            sql = sql & " 		_p.QTD_ATUAL_ESTOQUE"									
                            sql = sql & " from EST_RequisicaoProduto _rp"
                            sql = sql & " inner join EST_PRODUTO _p on _p.codigo = _rp.codProduto"
                            sql = sql & " left join EST_UNIDADE_PRODUTO _up on _up.codigo = _p.COD_UNIDADE"
                            sql = sql & " left join EST_SUBGRUPO_PRODUTO _sg on _sg.codigo = _p.COD_SUBGRUPO"
                            sql = sql & " left join EST_GRUPO_PRODUTO _g on _g.codigo = _sg.COD_GRUPO_PRODUTO"
                            sql = sql & " left join EST_SECAO_PRODUTO _S on _S.codigo = _P.COD_SECAO AND _S.COD_EMPRESA = _P.COD_EMPRESA"
                            sql = sql & " where _rp.codRequisicao = "& rs("codigo")
                            IF Session("CodSecao")<>"0" THEN
                                sql = sql & " and _p.COD_SECAO = "& Session("CodSecao")
                            END IF
                            sql = sql & " order by 1"
                            rsAux.open sql, cnn
                            if not rsAux.eof then
                                while not rsAux.eof
                                  classCampo = "text"
                                  readOnly = ""
                                  if rsAux("quantidade_autorizada") = "0" then
                                    classCampo = "textDesabilitado"
                                    readOnly = "readonly"
                                  end if
                                  
                                  if rs("codSituacao")="1" then
                                      quantidade_autorizada = ""
                                      quantidade_liberada = ""
                                  elseif rs("codSituacao")="2" then
                                      quantidade_autorizada = rsAux("quantidade_autorizada")
                                      quantidade_liberada = ""
                                  else
                                      quantidade_autorizada = rsAux("quantidade_autorizada")
                                      quantidade_liberada = rsAux("quantidade_liberada")
                                  end if
                                  
                                  %>
                                  <tr>
                                    <td  class="celula"><%=rsAux("produto")%></td>
                                    <td class="celula"><%=rsAux("unidade")%>&nbsp;</td>
                                    <td class="celula"><%=rsAux("grupo")%>&nbsp;</td>
                                    <td class="celula"><%=rsAux("subgrupo")%>&nbsp;</td>
                                    <td class="celula" align="center"><%=rsAux("quantidade")%>&nbsp;</td>
                                    <td class="celula" align="center"><%=quantidade_autorizada%>&nbsp;</td>
                                    <td class="celula" align="center"><%=quantidade_liberada%>&nbsp;</td>
                                  </tr>
                                   <%
                                  rsAux.movenext
                                wend
                            end if
                            rsAux.close
                              %>
                            </table>
                          
                          
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
        </div>
        <%end if%>
        <!--End Table Bordered-->	
        <!-- Fecha o Painel do Formulario -->        
    </div>
    <!--/container-->		
<script>
	
	function resultadoConsulta(){
		if (frm.txtNumero.value==""){
			if (frm.txtDataI.value == "") {
				alert("A Data inicial deve ser informada!");
				frm.txtDataI.focus();
				return false;
			}
			if (frm.txtDataF.value == "") {
				alert("A Data final deve ser informada!");
				frm.txtDataF.focus();
				return false;
			}
		}
		frm.submit();
	}
	
	function showTr(id){
		var elemento = document.getElementById("tr" + id);
		if(elemento.style.display == ''){
			elemento.style.display = 'none';
		}else{
			elemento.style.display = '';
		}
	}

</script>

    <!--=== End Content Part ===-->
   	<!--#include file="../RodapeModulo.asp"-->
	<!--#include file="../jsModulo.asp"-->
</body>
</html> 