<!--#include file="../ConfigModulo.asp"-->
<!--#include file="../../includes/inc_cnn.asp"-->
<!--#include file="../../includes/inc_formatadata.asp"-->
<!--#include file="../menuModulos.asp"-->
<!--#include file="../includes/inc_sqlAlunoTurma.asp"-->
<!--#include file="../../js/Calendario/Calendario.asp"-->
<script src="../../js/js_funcoes_gerais.js"></script>  
    <!--=== Breadcrumbs ===-->
    <div class="breadcrumbs">
        <div class="container">
            <h1 class="pull-left">APO - Apontamento</h1>
            <ul class="pull-right breadcrumb">
                <li><a href="Default.asp">Home</a></li>
                <li class="active"><%=session("CodEmpresa")%> - <%=session("EmpresaWeb")%></li>
            </ul>
        </div><!--/container-->
    </div><!--/breadcrumbs-->
    <!--=== End Breadcrumbs ===-->
	<%	intCodColaboradorProfessor=0
		if Session("NivelPermissao") <> "A" then
			sql = "select codigo "
			sql = sql & " from SRH_COLABORADOR"
			sql = sql & " where codigo_SEG_USUARIOS_SISTEMA = '" & trim(session("usuarioWeb")) & "'"
			'sql = sql & " and (CodCategoria = 1 or CodCategoria = 8)"'professor  
			sql = sql & " and Situacao = 'A'" 'Ativo
			rs.open sql, cnn
			if rs.EOF = false then	
				intCodColaboradorProfessor 	= rs("codigo")
			end if
			rs.close
		end if
		intCodEmpresaUsuario       	= Trim(Request("cmdEmpresaUsuario"))
		if intCodEmpresaUsuario="" then intCodEmpresaUsuario ="0"
        strPaginaTitulo 			= "Rel_Apontamento_con.asp"
        strDataInicial         		= Trim(Request("txtDataInicial"))
        strDataFinal            	= Trim(Request("txtDataFinal"))
    %>
    <!--=== Content Part ===-->
    <form method="post" id="frm" action="rel_apontamento_con.asp">
    <div class="container content">		
      <!-- Grey Panel -->            
      <div class="panel panel-grey">
        <div class="panel-heading">
        	<h3 class="panel-title"><i class="fa fa-tasks"></i>Relatório de Apontamento</h3>
        </div>
        <!-- Inicia o Painel do Formulario -->     
        <div class="panel-body">
             <!-- Inicia o Form -->     
            <div class="panel-body">                                                        
                    <div class="form-group">
                        <label class="form-label">Unidade</label>
                    	<!--#include file="../includes/inc_cmdEmpresaUsuario.asp"-->
                    </div>
                                        
                    <div class="form-group">
                        <label class="form-label">Per&iacute;odo</label>
                    	<input name="txtDataInicial" type="text" class="form-control" id="txtDataInicial" onblur="return validaData(this); submit();" onkeypress="return formataCampo(this, 3, 10)" size="11" maxlength="10" value="<%=strDataInicial%>" title="Click aqui para visualizar o calend&aacute;rio">
                        &aacute;
                        <input name="txtDataFinal" type="text" class="form-control" id="txtDataFinal" onblur="return validaData(this);" onkeypress="return formataCampo(this, 3, 10)" size="11" maxlength="10" value="<%=strDataFinal%>" title="Click aqui para visualizar o calend&aacute;rio">
                    </div>

                    <legend></legend>
                    <!--#include file="../../includes/inc_botoes_geraRelatorio.asp"-->
                
            	</div>
       	 	</div>
         	<!-- Fecha o Form -->  
      </div>
      <%IF intCodEmpresaUsuario="" THEN intCodEmpresaUsuario = "0"%>
   	   <%IF intCodEmpresaUsuario<>"0" THEN%>
       <!--Table Bordered-->
        <div class="panel panel-grey margin-bottom-40">
            <div class="panel-heading">
                <h3 class="panel-title"><i class="fa fa-globe"></i> Lista de Colaboradores</h3>
            </div>
            <div class="panel-body">
                <table class="table table-bordered">
                    <thead>
                        <tr>
                          <th width="3%" bgcolor="#95A5A6"><%if intCodEmpresaUsuario<>"0" then %><input type="checkbox" name="chkTodos" onclick="return MarcaTodosColaborador(this.checked)"><%end if%></th>
                          <th width="6%" bgcolor="#95A5A6">Cod. Funcional</th>
                          <th width="53%" bgcolor="#95A5A6">Nome</th>
                          <th width="38%" bgcolor="#95A5A6">Unidade</th>
                      </tr>
                    </thead>
                     <tbody>
                    <%
                    cont =0
					sql = " SELECT DISTINCT C.CODIGO, C.CODFUNCIONAL, C.NOME, F.COD_COLABORADOR as faixa, PM.codi_func as coleta, e.razaosocial"
					sql = sql & " from SRH_COLABORADOR C"
					sql = sql & " left join seg_empresa e ON e.codigo=c.codLotacao "
					sql = sql & " left join gemul5.dbo.COLETA PM ON C.codFuncional = PM.codi_func "
					sql = sql & " left join APO_FAIXA_HORARIO_COLABORADOR F ON F.COD_COLABORADOR = C.CODIGO "
					sql = sql & " where c.SITUACAO='A'"
					if intCodColaboradorProfessor<>"0" then
						sql = sql & " and c.codigo=" & intCodColaboradorProfessor
					end if
					sql = sql & " and C.CodLotacao in (select codigo from seg_empresa where cod_Grupo=" & Session("CodGrupo") & ")"
					if intCodEmpresaUsuario<>"0" then
						sql = sql & " and C.codLotacao = " & intCodEmpresaUsuario
					end if
					'if strDataInicial<>"" and strDataFinal<>"" then 
					'	sql = sql & " and (PM.data between '" & formatadataBD(strDataInicial) & "' and '" & formatadataBD(strDataFinal) & "' or PM.data is null)"
					'end if
					sql = sql & " Order By C.NOME"
                    rs.open sql, cnn
                    if rs.eof = false then
                    
                    while not rs.eof
                        cont = cont + 1
						coleta = "S"
						if isnull(rs("coleta")) then coleta = "N"
						faixa = "S"
						if isnull(rs("faixa")) then faixa = "N"
						mensagemFaixa=""
						bloqueio = ""
						if faixa = "N" then
							mensagemFaixa = "<font size='-2' color='#0099FF'>[Colaborador sem faixa de horário]</font>&nbsp;&nbsp;"
							bloqueio = "disabled"
						end if
						mensagemColeta=""
						if coleta = "N" then
							mensagemColeta = "<font size='-2' color='#0099FF'>[Colaborador sem batida de ponto]</font>&nbsp;&nbsp;"
							bloqueio = ""
						end if
						mensagemFace = ""
						sql = "select imagem_facial from gemul5.dbo.funcionarios where codi_func = " & rs("CODFUNCIONAL")
						rsAux.open sql, cnn
                    	if rsAux.eof = false then
							if isnull(rsAux("imagem_facial")) then
								mensagemFace = "<font size='-2' color='#990000'>[Colaborador sem biometria facial]</font>&nbsp;&nbsp;"
								bloqueio = ""
							end if
						end if
						rsAux.close
				    	%>

                        <tr >
                            <td><input type="checkbox" id="chkFunc" <%=bloqueio%> name="chkFunc" <%=strDesabilitaAluno%> value="<%=rs("codigo")%>"></td>
                            <td><%=trim(rs("CODFUNCIONAL"))%></td>
                            <td><%=rs("NOME")%><br><%=mensagemFaixa%><%=mensagemColeta%><%=mensagemFace%></td>
                            <td><%=trim(rs("razaosocial"))%>&nbsp;</td>
                        </tr>
                    	<%				
                        rs.movenext
                        wend
                    end if
                    rs.close
                	%>
                    <tr>
                        <td colspan="6">Total Registros: <%=cont%></td>
                    </tr>
                    </tbody>
                </table>
            </div>                      
        </div>
        <!--End Table Bordered-->	
        <!-- Fecha o Painel do Formulario -->        
        <%END IF%>
    </div>
    </form>
    <!--/container-->		
    <script>
        function gerar(){
            
            var frm = document.getElementById("frm");
            var form = window.document.forms[0];
            var intContMarcado=0;

            if (frm.txtDataInicial.value==""){
				alert("Período inicial deve ser informado!")	;
				frm.txtDataInicial.focus();
				return false
			}
            if (frm.txtDataFinal.value==""){
				alert("Período final deve ser informado!")	;
				frm.txtDataFinal.focus();
				return false
			}
    
            //*****verifica se um aluno foi selecionado
            intContMarcado=0;
            for (var i = 0; i < form.elements.length; i++) {
                //verifica todos os checkbox
                if (form.elements[i].type == "checkbox"){
                    if (form.elements[i].name == "chkFunc"){
                        //verifica se o checkbox está marcado
                        if (form.elements[i].checked){
                            intContMarcado = intContMarcado + 1;
                        }
                    }
                }
            }	
            
            if (intContMarcado==0){
                alert("Colaborador deve ser selecionado!");
                return false;
            }
			
            frm.action = "Rel_Apontamento_rel.asp";
            frm.submit();
            return true;	
        }
		
		function MarcaTodosColaborador(valor){
			var form = window.document.forms[0];
			var i;
			
			
			for (var i = 0; i < form.elements.length; i++) {
				//verifica todos os checkbox
				if (form.elements[i].type == "checkbox"){
					//verifica se o checkbox está marcado
					if (form.elements[i].disabled==false) {
						form.elements[i].checked=valor;
					}
				}
			}
		}
    </script>
    <!--=== End Content Part ===-->
   	<!--#include file="../RodapeModulo.asp"-->
	<!--#include file="../jsModulo.asp"-->
</body>
</html> 