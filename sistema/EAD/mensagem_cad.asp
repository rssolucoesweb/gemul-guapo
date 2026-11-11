<!--#include file="../ConfigModulo.asp"-->
<!--#include file="../../includes/inc_cnn.asp"-->
<!--#include file="../../includes/inc_formatadata.asp"-->
<!--#include file="../menuModulos.asp"-->
<script src="../../js/js_funcoes_gerais.js"></script>  
    <!--=== Breadcrumbs ===-->
    <div class="breadcrumbs">
        <div class="container">
         <%if Session("mobile")<>"S" then%>
            <h1 class="pull-left">EAD - Sistema de Ensino a Distância</h1>
            <ul class="pull-right breadcrumb">
                <li><a href="Default.asp">Home</a></li>
                <li class="active"><%=session("CodEmpresa")%> - <%=session("EmpresaWeb")%></li>
            </ul>
          <%end if%>
        </div><!--/container-->
    </div><!--/breadcrumbs-->
    <!--=== End Breadcrumbs ===-->
	<%
        strPaginaTitulo 			= "atividade_cad.asp"
		cod_colaborador	 			= Session("CodColaborador")
		intCodColaboradorProfessor	= Session("CodColaborador")
		strExecutarSubmitProfessor = "S"
		
        intCodigo	 			= Trim(Request.Form("txtCodigo"))
		titulo		 			= Trim(Request.Form("assunto"))
		texto 					= Trim(Request.Form("texto"))
		cod_turma 				= Trim(Request.Form("cmbTurmaProfessor"))
		intCodTurmaProfessor 	= Trim(Request.Form("cmbTurmaProfessor"))
		intCodProfessor			= Trim(Request.Form("cmbProfessor"))
		
		
		if cod_turma = "" then cod_turma = "0"
		if intCodTurmaProfessor = "" then intCodTurmaProfessor = "0"
		cod_aluno 				= Trim(Request.Form("cmbAlunoTurma"))
			
		strDesabilitaIncluir	= "" 'Desabilita o botão Incluir
		strDesabilitaAlterar 	= "disabled" 'Desabilita o botão Excluir
		strDesabilitaExcluir	= "disabled" 'Desabilita o botão Excluir
        strExecutarSubmitTurma 	= "S" 
		strExecutarSubmitAlunoTurma = "S"
		   
        if trim(intCodigo) <> "" then
        
            sql = "SELECT cod_mensagem, cod_empresa, cod_colaborador, cod_aluno, assunto, descricao, situacao, usuario_incl_aluno, usuario_incl_colaborador, usuario_logado, data_hora_incl"
            sql = sql & " FROM EAD_MENSAGEM"
            sql = sql & " where cod_mensagem = " & intCodigo
            rs.open sql, cnn
            if rs.eof = false then
                intCodigo				= rs("cod_mensagem")
                titulo					= rs("assunto")
				descricao				= rs("descricao")

                strDesabilitaIncluir	= "disabled" 'Desabilita o botão Incluir
                strDesabilitaAlterar 	= "" 'Desabilita o botão Excluir
                strDesabilitaExcluir	= "" 'Desabilita o botão Excluir
    			
            end if 
            rs.close
			
        else
            strDesabilitaIncluir	= "" 'Desabilita o botão Incluir
            strDesabilitaAlterar 	= "disabled" 'Desabilita o botão Excluir
            strDesabilitaExcluir	= "disabled" 'Desabilita o botão Excluir
        end if 
		
	   strAnoLetivo          		= session("strAnoLetivo")
	   intSemestre          		= session("strSemestre")
    %>
    
    
<!--=== Content Part ===-->
    <div class="container content">
        <div class="row">
            <!-- Begin Content -->
            <div class="col-md-12" >     

       		<!-- Inicia o Painel do Formulario -->     

                <form id="frm" class="sky-form  panel-body0" method="post">
                	
                    <input name="txtCodigo" type="hidden" id="txtCodigo" value="<%=intCodigo%>">
                    <input name="cod_colaborador" type="hidden" id="cod_colaborador" value="<%=cod_colaborador%>">
                    <div style="background:#95a5a6;height:40px;padding-top: 8px;" class="panel-title">&nbsp;&nbsp;<font color="#FFFFFF"><i class="fa fa-tasks"></i>&nbsp;Cadastro de Mensagens</font></div>

                    <fieldset>
						<div class="row">
                             <section class="col col-5">
                                <label class="form-label">Turma</label>
                                <label class="input">
                                    <!--#include file="../includes/inc_cmdTurmaEAD.asp" -->
                                </label>
                             </section>
                        </div>
						
						<div class="row">
                             <section class="col col-5">
                                <label class="form-label">Professor</label>
                                <label class="input">
                                    <!--#include file="../includes/inc_cmdProfessorEAD.asp" -->
                                </label>
                             </section>
                        </div>
						
						
						<div class="row">
                             <section class="col col-5">
                                <label class="form-label">Aluno</label>
                                <label class="input">
                                    <!--#include file="../includes/inc_cmdAlunoTurma.asp" -->
                                </label>
                             </section>
                        </div>
                        <div class="row">
                             <section class="col col-12">
                                <label class="form-label">Assunto</label>
                              
                                <label class="input">
                                     <input name="assunto" type="text" class="form-control" id="assunto" size="150" maxlength="250" value="<%=titulo%>">
                                </label>
                             </section>
                        </div>
                        <div class="row">
                             <section class="col col-12">
                                <label class="form-label">Texto</label>
                              
                                <label class="input">
									<textarea name="texto" id="texto" class="form-control"  cols="144" rows="3"><%=texto%></textarea>
                                </label>
                             </section>
                        </div>

                    </fieldset>
					
					<div class="margin-left-40">
                    <!--#include file="../../includes/inc_botoes_cadastro.asp"-->
					</DIV>
                    
                 </form>                
                
			</div>
         	<!-- Fecha o Form -->  
      </div>
   	   
       <!--Table Bordered-->
        <div class="panel panel-grey margin-bottom-40">
            <div class="panel-heading">
                <h3 class="panel-title"><i class="fa fa-globe"></i>Lista de Mensagem</h3>
          	</div>
      		<div class="panel-body">
            	<div class="table-responsive">
                    <table class="table table-bordered">
                        <thead>
                            <tr>
                              <th width="20%" bgcolor="#95A5A6">Aluno</th>
							  <th width="15%" bgcolor="#95A5A6">Assunto</th>
							  <th width="35%" bgcolor="#95A5A6">Texto</th>
                              <th width="15%" bgcolor="#95A5A6">Data Inclusão</th>
                          </tr>
                        </thead>
                         <tbody>
                        <%
                        cont =0
						if cod_aluno = "" then cod_aluno ="0"
                        sql = "SELECT a.nomealuno, m.assunto, m.descricao, m.data_hora_incl, m.usuario_incl_colaborador, m.usuario_incl_aluno"
                        sql = sql & " FROM EAD_MENSAGEM m"
						sql = sql & " left join sca_aluno a on a.codigo = m.cod_aluno"
						sql = sql & " where 1=1"
						if intCodProfessor <> "0" and intCodProfessor <> "" then
							sql = sql & " and	m.cod_colaborador = " & intCodProfessor
						end if
						if cod_aluno <> "0" then
							sql = sql & " and	m.cod_aluno = " & cod_aluno
						end if
						if cod_turma <> "0" then
							sql = sql & " and	m.cod_turma = " & cod_turma
						end if
                        sql = sql & " Order by m.data_hora_incl desc, a.nomealuno"
                        rs.open sql, cnn
                        if rs.eof = false then
							while not rs.eof
								cont = cont + 1
								cor = ""
								if isnull(rs("usuario_incl_colaborador")) then 
									cor = " bgcolor='#FFE4C4'"
								else
									cor = " bgcolor='#FAF0E6'"
								end if
								%>
								<tr <%=cor%>>
									<td><%=trim(rs("nomealuno"))%></td>
									<td><%=trim(rs("assunto"))%></td>
									<td><%=trim(rs("descricao"))%></td>
									<td><%=trim(rs("data_hora_incl"))%></td>
								</tr>
								<%				
								rs.movenext
                            wend
                        end if
                        rs.close
                        %>
                            <tr>
                                <td colspan="4">Total Registros : <%=cont%></td>
                            </tr>
                        </tbody>
                    </table>
                </div>
          	</div>                      
        </div>
        <!--End Table Bordered-->	
        <!-- Fecha o Painel do Formulario -->        
    </div>
    <!--/container-->		
   	   
	<script>
        function salvar(acao){
            
            var frm = document.getElementById("frm");
            
            if (frm.cmbTurmaProfessor.value == "0") {
                alert("A turma deve ser informada!");
                frm.cmbTurmaProfessor.focus();
                return false;
            }
            if (frm.assunto.value == "") {
                alert("O assunto deve ser informado!");
                frm.assunto.focus();
                return false;
            }
			if (frm.texto.value == "") {
                alert("O texto deve ser informado!");
                frm.texto.focus();
                return false;
            }
			
            frm.action="mensagem_cod.asp?acao=" + acao;
            frm.submit();
            return true;
        }
    </script>
    <!--=== End Content Part ===-->
   	<!--#include file="../RodapeModulo.asp"-->
	<!--#include file="../jsModulo.asp"-->
</body>
</html> 