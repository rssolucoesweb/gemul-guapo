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
        strEmpresaGrupo_submit = "S"
        strExecutarSubmitColaborador = "S"
        strExecutarSubmitTurno = "S"
        strSubmitFuncao = " onchange='submit()' "
    
        pagina							= "Rel_ModulacaoSituacaoColaborador_con.asp"
        strAnoLetivo 					= session("strAnoLetivo")
        strSemestre 					= session("strSemestre")
        intCodEmpresa 					= Session("CodEmpresa")
        intCodEmpresaGrupo				= Trim(Request.Form("cmbEmpresaGrupo"))
        intCodColaboradorModulacao		= Trim(Request.Form("cmbColaboradorModulacao"))	
        
        strTipoModulacao				= Trim(Request.Form("optTipoModulacao"))
        strDisponibilidade				= Trim(Request.Form("optModulado"))
        
        intCodTurno					 	= Trim(Request.Form("cmbTurno"))
        intCodFuncao					= Trim(Request.Form("cmbFuncao"))
        intSaldoPositivo				= Trim(Request.Form("chkSaldoPositivo"))
        
        if intCodEmpresaGrupo="" then intCodEmpresaGrupo = "0"
        if intCodEmp = "" then intCodEmp = session("codEmpresa")
        if trim(request("cmbSemestre")) = "0" or trim(request("cmbSemestre")) = ""  then 
            intSemestre = session("strSemestre")
        else
            intSemestre = request.Form("cmbSemestre")
        end if
        
        if intCodColaboradorModulacao = "" then intCodColaboradorModulacao = "0"
        if strSituacao = "0" then strSituacao = "A"
        if intCodTurno = "" then intCodTurno = "0"
        if intCodFuncao = "" then intCodFuncao = "0"
        if strDisponibilidade = "" then strDisponibilidade = "Total"
    
    %>
    <form method="post" id="frm" action="#">
    <!--=== Content Part ===-->
    <div class="container content">		
    
      <!-- Grey Panel -->            
      <div class="panel panel-grey">
        <div class="panel-heading">
        	<h3 class="panel-title"><i class="fa fa-tasks"></i>Modulação Disponibilidade</h3>
        </div>
        <!-- Inicia o Painel do Formulario -->     
        <div class="panel-body">
             <!-- Inicia o Form -->     
            <div class="panel-body">                                                        
               
                      
                    <div class="form-group">
                            
                            <table width="100%" border="0" cellspacing="0" cellpadding="0">
                                      <tr>
                                        <td colspan="3" class="TextoForm">&nbsp;</td>
                                        </tr>
                                      <tr>
                                        <td colspan="3" class="TextoForm"></td>
                                        </tr>
                                      <tr> 
                                        <td height="24" colspan="3" bgcolor="#CCCCCC" class="TextoForm"><strong>Dados da Modula&ccedil;&atilde;o</strong></td>
                                        </tr>
                                    <tr>
                                      <td width="283" height="24" class="texto">Unidade Escolar:</td>
                                      <td width="768" height="24"  class="texto"><!--#include file="../includes/inc_cmbEmpresaGrupoDiretrizes.asp"--></td>
                                      <td width="242" align="left" valign="top" >&nbsp;</td>
                                    </tr>
                                    <tr>
                                      <td height="24" class="texto"><span class="texto2">Categoria:</span></td>
                                      <td height="24"  class="texto"><span class="texto2">
                                        <%if strTipo_Funcao <> "FUNCIONARIO" OR intContratadoNivel > 0 THEN%>
                                        <input <%if strTipoModulacao = "PROFESSOR" then response.Write("checked")%>  type="radio" name="optTipoModulacao" id="optTipoModulacao" <%=strDesabilitaProfessor%> value="PROFESSOR" onclick="submit()">
                                        Professor &nbsp;&nbsp;&nbsp;&nbsp;
                                        <%END IF%>
                                        <input type="radio" <%if strTipoModulacao = "FUNCIONARIO" then response.Write("checked")%> name="optTipoModulacao" id="optTipoModulacao" value="FUNCIONARIO"  onClick="submit()">
                                        Funcion&aacute;rio </span></td>
                                      <td align="left" valign="top" >&nbsp;</td>
                                    </tr>
                                    <tr>
                                      <td height="24" class="texto">Turno:</td>
                                      <td height="24"  class="texto"><!--#include file="../includes/inc_cmbTurnoRH.asp" --></td>
                                      <td align="left" valign="top" >&nbsp;</td>
                                    </tr>
                                    <tr>
                                      <td height="24" class="texto">Fun&ccedil;&atilde;o:</td>
                                      <td height="24"  class="texto"><!--#include file="../includes/inc_cmbFuncao.asp" --></td>
                                      <td align="left" valign="top" >&nbsp;</td>
                                    </tr>
                                    <tr>
                                      <td height="24" class="texto">Colaborador com Disponibilidade Contratual:</td>
                                      <td height="24"  class="texto"><input type="checkbox" name="chkSaldoPositivo" value="S" <%if intSaldoPositivo = "S" then response.Write("checked")%> onclick="submit()"></td>
                                      <td align="left" valign="top" >&nbsp;</td>
                                    </tr>
                                   <%if strTipoLancamento = "D" and  strTipoLancamento <> "" then %>
                                   <%end if%>              
                                    <%
                                    IF strTipo_Funcao = "FUNCIONARIO" AND strTipo_FuncaoSelecionadaCombo<>"" and intContratadoNivel <= 0 then
                                        if strTipo_Funcao <> strTipo_FuncaoSelecionadaCombo then
                                            %>
                                            <script>
                                                alert("Não é permitido modular um administrativo como docente.");
                                                window.location="Modulacao_cad.asp?tipoContratacao=C";
                                            </script>
                                            <%
                                            response.end
                                        end if
                                    END IF
                                    %>
                                      </table>
                                      
                            <table width="96%" border="0" cellpadding="0" cellspacing="0" >
                              
                                <tr valign="top">
                                  <td align="left" >
                                    <!-- inicio tabela de cadastro de funcionario -->
                                    
                                    <!-- fim tabela de cadastro de funcionario --></td>
                                </tr>
                                <tr valign="top">
                                  <td height="20" align="center" class="tituloPrincipal"><!--#include file="../../includes/inc_botoes_geraRelatorio.asp"--></td>
                                </tr>
                                <tr valign="top">
                                  <td align="center" class="tituloPrincipal">
                                  <%
                                  if trim(intCodEmpresaGrupo) <> "0" then
                                  
                                    sql = "select c.codigo, c.nome, f.Tipo_Funcao, c.codFuncional, c.cod_nivel, c.situacao, c.cpf, tu.Desc_Turno as turno, "
                                    sql = sql & " c.codFuncao, isnull(n.Descricao,'NAO_INFORMADO') as nivel, f.Desc_Funcao as funcao, ca.desc_categoria as categoria, "
                                    sql = sql & " isnull(n.total_aulas,0) as total_aulas_nivel, c.total_aulas, isnull(c.carga_horario_contratada,0) as carga_horario_contratada, c.cod_empresa"
                                    sql = sql & " from srh_colaborador c"
                                    
                                    if request("cmbNivel")<>"0" and request("cmbNivel")<>"" then
                                        sql = sql & " left join srh_nivel n on n.codigo = " & request("cmbNivel")
                                    else
                                        sql = sql & " left join srh_nivel n on n.codigo = c.cod_nivel"
                                    end if
                                    
                                    sql = sql & " left join SRH_MODULACAO_DISCIPLINAR_DOCENTE DD ON  dd.Cod_Colaborador = C.codigo "
                                    sql = sql & " left join SRH_FUNCAOCOLABORADOR f on f.cod_funcao = c.codfuncao "
                                    sql = sql & " left join SRH_CATEGORIA ca on ca.Cod_Categoria = c.CodCategoria "
                                    sql = sql & " left join SRH_TURNO tu on tu.Cod_Turno = c.CodTurno "
                                    sql = sql & " Where c.codLotacao = " & intCodEmpresaGrupo 
                                    
                                    if strDisponibilidade = "Parcial" then
                                        sql = sql & " And dd.ano_letivo = " & strAnoLetivo
                                    end if
                                    
                                    if intCodColaboradorModulacao <> "0" then
                                        sql = sql & " And c.codigo = " & intCodColaboradorModulacao 
                                    end if
                                    
                                    if strTipoModulacao <> "" then
                                        sql = sql & " And f.Tipo_Funcao = '" & strTipoModulacao & "'"
                                    end if
                                    
                                    if intCodTurno <> "0" then
                                        sql = sql & " And tu.cod_turno = " & intCodTurno
                                    end if
                                    
                                    if intCodFuncao <> "0" then
                                        sql = sql & " And f.cod_funcao = " & intCodFuncao 
                                    end if
                                
                                    sql = sql & " and c.Situacao = 'A'"
                                    sql = sql & " and F.Modular = 'S'"
                                    sql = sql & " order by Nome"
                                    rs.open sql, cnn
                                    if rs.eof = false then
                                        %>
                                      <table width = "100%" border="1" align="center" cellpadding="0" cellspacing="0" bordercolor="#CCCCCC" class="tabela">
                                        <tr bgcolor="#E5E5E5" class="celula">
                                          <td height="26" class="celula"><strong>Professor</strong></td>
                                        <td class="celula"><strong>Categoria</strong></td>
                                        <td class="celula"><strong>Fun&ccedil;&atilde;o</strong></td>
                                        <td class="celula"><strong>Nivel</strong></td>
                                        <td class="celula"><strong>Turno</strong></td>
                                        <td align="center" class="celula"><strong>Contratado</strong></td>
                                        <td width="71" align="center" class="celula"><strong>Modulado</strong></td>
                                        <td width="65" align="center" class="celula"><strong>Saldo</strong></td>
                                        <td width="65" align="center" class="celula"><strong><strong>M&aacute;ximo</strong></strong></td>
                                        <td width="65" align="center" class="celula"><strong>Saldo</strong></td>
                                        </tr>
                                        <%
                                            
                                            intCodCodFuncionalAnt = 0
                                            
                                        while not rs.eof
                                           
                                            
                                            intCodColaborador	= rs("Codigo")
                                            intCodEmp           = rs("Cod_Empresa")
                                            strnome 			= Trim(Rs("nome"))
                                            intCodFuncional		= Trim(Rs("CodFuncional"))
                                            strNivel			= Trim(Rs("nivel"))
                                            if request("cmbNivel")<>"0" and request("cmbNivel")<>"" then	
                                                intCodNivel = request("cmbNivel")
                                            else
                                            intCodNivel			= Trim(Rs("cod_nivel"))
                                            end if
                                            strFuncao			= Trim(Rs("funcao"))
                                            strTurnoContratado	= rs("turno")
                                            strCategoria		= Trim(Rs("categoria"))
                                            intContratado	 	= rs("total_aulas")
                                            intContratadoNivel	= rs("total_aulas_nivel")
                                            strTipo_Funcao		= rs("Tipo_Funcao")
                                            
                                            strDesabilitaProfessor = ""
                                            if strTipo_Funcao = "PROFESSOR" and Trim(Request.Form("optTipoModulacao"))="" then
                                            strTipoModulacao = "PROFESSOR"
                                            end if
                                            if strTipo_Funcao = "FUNCIONARIO" and Trim(Request.Form("optTipoModulacao"))="" then
                                            strTipoModulacao = "FUNCIONARIO"
                                            strDesabilitaProfessor = " disabled "
                                            end if
                                            if strTipo_Funcao <> "FUNCIONARIO" OR intContratadoNivel > 0 THEN
                                                strDesabilitaProfessor = ""
                                            end if	
                                            strCPF  					= Trim(Rs("CPF"))
                                            strSituacaoColaborador 		= rs("situacao")
                                            intCodFuncaoColaborador		= rs("codFuncao")
                                            
                                            ' Atualiza o inativar por data
                                            if trim(rs("codigo")) <> "" then
                                            
                                                sql = "select dd.Codigo, dd.periodo_inicial, dd.periodo_final"
                                                sql = sql & " from SRH_MODULACAO_DISCIPLINAR_DOCENTE dd "
                                                sql = sql & " inner join SEG_EMPRESA e on e.CODIGO = dd.Cod_empresa "
                                                sql = sql & " left join SRH_FUNCAOCOLABORADOR f on f.cod_funcao = dd.cod_funcao"
                                                sql = sql & " left join SCA_disciplina d on d.cod_disciplina = dd.cod_disciplina"
                                                sql = sql & " left join SRH_TURNO t on t.cod_turno = dd.cod_turno"
                                                sql = sql & " left join SRH_TURNO tur on tur.cod_turno = dd.cod_turno_opcional "
                                                sql = sql & " left join SCA_periodo p on p.cod_periodo = dd.cod_periodo"
                                                sql = sql & " where dd.Cod_Colaborador = " & trim(rs("codigo"))
                                                sql = sql & " and (dd.ano_letivo = " & strAnoLetivo
                                                sql = sql & " or dd.ano_letivo = " & strAnoLetivo - 1 & ")"
                                                sql = sql & " order by dd.ano_letivo desc ,dd.tipo_contratacao desc, dd.codigo"
                                                rsAux1.open sql, cnn
                                                if rsAux1.eof = false then
                                                
                                                while not rsaux1.eof
                                                
                                                if not isnull(rsaux1("periodo_final")) then
                                                    strPeriodoFinalComparar = replace(formataDataCalc(rsaux1("periodo_final")),"/","")
                                                    strDataAtualComparar 	= replace(formataDataCalc(date),"/","")
                                                    
                                                    if cCur(strPeriodoFinalComparar)<cCur(strDataAtualComparar) then 
                                                        sql = "update SRH_MODULACAO_DISCIPLINAR_DOCENTE set status = 'I' where codigo = " & rsaux1("codigo") 
                                                        cnn.execute sql
                                                    end if
                                                end if
                                                
                                                rsAux1.movenext
                                                wend
                                            
                                            end if
                                            rsAux1.close	
                                            
                                            end if	
                                                
                                           
                                            intModulado = "0"
                                            if trim(rs("codigo")) <> "" then
                                            
                                                sql = "select isnull(sum(Total_Aulas),0) as modulado, situacao_disciplinar "
                                                sql = sql & " from SRH_MODULACAO_DISCIPLINAR_DOCENTE"
                                                sql = sql & " where Cod_Colaborador = " & trim(rs("codigo"))
                                                sql = sql & " and status = 'A'"
                                                sql = sql & " and cod_turno is not null"
                                                sql = sql & " and ano_letivo = " & strAnoLetivo
                                                sql = sql & " and tipo_contratacao is not null group by situacao_disciplinar"
                                                
                                                rsAux.open sql, cnn
                                                if rsAux.eof = false then
                                                    intModulado = rsAux("modulado")
                                                    
                                                    if isnull(intModulado) then intModulado = "0"
                                                    if trim(rsAux("situacao_disciplinar")) = "I" then
                                                        intModulado = rsAux("modulado") * 21 ' intContratadoNivel
                                                    end if
                                                end if
                                                rsAux.close
                                                
                                            end if
                                            if intCodFuncao = "" then intCodFuncao = "0"
                                        
                                            strSomenteProfessor = ""
                                            if intContratadoNivel = "" then intContratadoNivel = 0
                                            
                                            if cInt(intContratadoNivel) = 14 then
                                                intContratadoMaximo = 20
                                            elseif cInt(intContratadoNivel) = 21 then
                                                intContratadoMaximo = 27
                                            elseif cInt(intContratadoNivel) = 28 then
                                                intContratadoMaximo = 42
                                            elseif cInt(intContratadoNivel) >= 42 then
                                                intContratadoMaximo = 42
                                            end if
                                        
                                        
                                            intSaldoContratado = 0
                                            if intContratado<>"" and intModulado<>"" then
                                                intSaldoContratado = intContratado - intModulado
                                            end if	
                                            
                                            if intSaldoPositivo = "S" then
                                                    
                                                    strCor = "" 
                                                    
                                                    if intSaldoContratado > 0 and intContratadoNivel > 0 then 
                                                        
                                                        strCor = "" 
                                                        
                                                        if cint(intModulado ) < cint(intContratadoNivel) then
                                                            strCor = "#B3B3FF"
                                                        else
                                                            strCor = ""
                                                        end if
                                                        
                                                        if trim(rs("CodFuncional")) <> intCodCodFuncionalAnt then
                                                            intCodCodFuncionalAnt = trim(rs("CodFuncional"))
                                                            
                                                            cont = cont + 1	
                                                            
                                                     %>
                                                    <tr bgcolor="<%=strCor%>">
                                                        <td width="271" class="celula9"><%=trim(rs("CodFuncional"))%> - <%=trim(rs("nome"))%></td>
                                                        <td width="146" class="celula"><%=Trim(Rs("categoria"))%></td>
                                                        <td width="298" class="celula9"><%=strFuncao%></td>
                                                        <td width="183" class="celula9">&nbsp;<%=strNivel%></td>
                                                        <td width="81" class="celula9"><%=strTurnoContratado%></td>
                                                        <td width="97" height="26" align="center" class="celula9"><%=intContratadoNivel%></td>
                                                        <td align="center" class="celula9"><%=intModulado%></td>
                                                        <td align="center" class="celula9"><%=intSaldoContratado%></td>
                                                        <td align="center" class="celula9"><%=intContratadoMaximo%></td>
                                                        <td height="26" align="center" class="celula9"><%=intContratadoMaximo-intModulado%></td>
                                                    </tr>
                                                    <% 
                                                        end if
                                                        
                                                    end if
                                                    
                                            else
                                            
                                                        if trim(rs("CodFuncional")) <> intCodCodFuncionalAnt then
                                                            intCodCodFuncionalAnt = trim(rs("CodFuncional"))
                                                            
                                                            cont = cont + 1	
                                                            %>
                                                            <tr>
                                                                <td width="271" class="celula9"><%=trim(rs("CodFuncional"))%> - <%=trim(rs("nome"))%></td>
                                                                <td width="146" class="celula"><%=Trim(Rs("categoria"))%></td>
                                                                <td width="298" class="celula9"><%=strFuncao%></td>
                                                                <td width="183" class="celula9">&nbsp;<%=strNivel%></td>
                                                                <td width="81" class="celula9"><%=strTurnoContratado%></td>
                                                                <td width="97" height="26" align="center" class="celula9"><%=intContratadoNivel%></td>
                                                                <td align="center" class="celula9"><%=intModulado%></td>
                                                                <td align="center" class="celula9"><%=intSaldoContratado%></td>
                                                                <td align="center" class="celula9"><%=intContratadoMaximo%></td>
                                                                <td height="26" align="center" class="celula9"><%=intContratadoMaximo-intModulado%></td>
                                                            </tr>
                                                            <% 
                                           
                                                end if
                                           end if
                                           
                                           rs.movenext
                                        wend
                                        %>
                                        <tr> 
                                        <td height="21" colspan="11" bgcolor="#E5E5E5" class="celula"><span class="texto">Total Registros :</span> <%=cont%></td>
                                        <%
                                    end if
                                    rs.close
                                     %>
                                    </table> 
                                    <%	
                                 end if	
                                 %>
                                 </td>
                                </tr>
                                <tr valign="top">
                                  <td align="center" class="tituloPrincipal style2">&nbsp;</td>
                                </tr>
                                </table>
                    
                    </div>
    
            	</div>
       	 	</div>
         	<!-- Fecha o Form -->  
      </div>

     <!-- Fecha o Painel do Formulario -->        
    </div>
    </form>
    <!--/container-->		
	<script>
        function gerar(){
            
            var frm = document.getElementById("frm");
            var caminho;
            
            if (frm.cmbEmpresaGrupo.value=="0" && frm.cmbFuncao.value=="0") {
                alert("A Unidade ou a função deve ser informada!");
                frm.cmbEmpresaGrupo.focus();
                return false
            }
            
            caminho = "Rel_ModulacaoSituacaoColaborador_rel.asp"
            frm.action = caminho;
            frm.submit();
            return true;	
        }	
    </script>
    <!--=== End Content Part ===-->
   	<!--#include file="../RodapeModulo.asp"-->
	<!--#include file="../jsModulo.asp"-->
</body>
</html> 