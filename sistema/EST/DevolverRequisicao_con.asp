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
        strEmpresaSecaoProduto_submit = "S"
        principal			= "principal.asp"
        intCodEmpresa		= session("CodEmpresa")	
        intSecaoProduto			= Trim(Request.Form("cmbSecaoProduto"))
        if intSecaoProduto = "" then intSecaoProduto = "0"
    %>
    <!--=== Content Part ===-->
    <div class="container content">		
    
      <!-- Grey Panel -->            
      <div class="panel panel-grey">
        <div class="panel-heading">
        	<h3 class="panel-title"><i class="fa fa-tasks"></i>Devolver Solicitação para o Solicitante</h3>
        </div>
        <!-- Inicia o Painel do Formulario -->     
        <div class="panel-body">
             <!-- Inicia o Form -->     
            <div class="panel-body">                                                        
                <form id="frm" name="frm" action="#" method="post">
                    
                  <div class="form-group">
                    <label class="form-label">Se&ccedil;&atilde;o</label>
                    <!--#include file="../includes/inc_cmbSecaoProduto.asp" -->
                  </div>

                  <legend></legend>
                </form>
       	  </div>
   	 	</div>
         	<!-- Fecha o Form -->  
      </div>
   	   
       <!--Table Bordered-->
        <div class="panel panel-grey margin-bottom-40">
            <div class="panel-heading">
                <h3 class="panel-title"><i class="fa fa-globe"></i> Lista Solicitante</h3>
          </div>
            <div class="panel-body">
            	<div class="table-responsive">
                <table class="table table-bordered">
                    <thead>
                        <tr>
                          <th width="3%" bgcolor="#95A5A6">#</th>
                          <th width="7%" bgcolor="#95A5A6">C&oacute;digo</th>
                          <th width="14%" bgcolor="#95A5A6">Data</th>
                          <th width="60%" bgcolor="#95A5A6">Departamento/Unidade</th>
                          <th width="16%" bgcolor="#95A5A6">Solicitante</th>
                      </tr>
                    </thead>
                  <%
                    cont =0

					strMes1 = month(date)-1
					strMes2 = month(date)-2
					strAno1 = year(date)
					strAno2 = year(date)
					
					if month(date) = 1 then
						strMes1 = 12
						strMes2 = 11
						strAno1 = year(getdate())-1
						strAno2 = year(getdate())-1
					end if
					if month(date) = 2 then
						strMes1 = 1
						strMes2 = 12
						strAno1 = year(date)
						strAno2 = year(date)-1
					end if

					sql = "select _r.codigo, _r.dataentrada, _u.USUA_NOME_COMPLETO as nome, _r.obs,"
					sql = sql & " case "
					sql = sql & " 	when _di.codigo is null then _d.descricao "
					sql = sql & " 	else _dd.descricao "
					sql = sql & " 	end as depto "	
					sql = sql & " from est_requisicao _r"
					sql = sql & " inner join SEG_USUARIOS_SISTEMA _u on _u.USUA_CPF = _r.solicitante"
					sql = sql & " inner join EST_departamento _d on _d.codigo = _u.CODIGO_DEPARTAMENTO"
					sql = sql & " left  join EST_departamento _dd				on _dd.codigo = _r.codDepartamento "
					sql = sql & " left  join est_requisicaoDistribuicao _di	on _di.codRequisicao = _r.codigo "
					sql = sql & " where _r.codSituacao = 2 "
					sql = sql & " and _r.cod_secao = " & intSecaoProduto
					sql = sql & " order by 1"
					rs.open sql, cnn
					if rs.eof = false then
                    
                    while not rs.eof
						cont = cont + 1	
			        %>
                    <tbody>
                        <tr>
                            <td><div align="center"><a href="javascript:showTr(1)">[+]</a></td>
                            <td><%=rs("Codigo")%></td>
                            <td><%=trim(rs("dataentrada"))%></td>
                            <td><%=trim(rs("depto"))%></td>
                          	<td align="center" ><%=trim(rs("nome"))%></td> 
                      </tr>
                        <tr id="tr1" style="display:none;">
                          <td colspan="5">
                          	
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
        <!--End Table Bordered-->	
        <!-- Fecha o Painel do Formulario -->        
    </div>
    <!--/container-->		
	<script>
        
        function resultadoConsulta(intCodigo){
                frm.txtCodigo.value=intCodigo
                frm.submit();
            }
    
        function devolver(req){
    
            var men = 'ATENÇÃO: Deseja devolver a solicitação número ' + req + ' para o solicitante?\n';
            if (confirm(men)) {
                var frm = document.getElementById("frm");
                frm.action="devolverRequisicao_cod.asp?req="+req;
                frm.submit();
                return true;
            }else{
                return false;
            }
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