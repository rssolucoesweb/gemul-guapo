<!--#include file="../ConfigModulo.asp"-->
<!--#include file="../../includes/inc_cnn.asp"-->
<!--#include file="../../includes/inc_formatadata.asp"-->
<!--#include file="../menuModulos.asp"-->
<script src="../../js/js_funcoes_gerais.js"></script>  
    <!--=== Breadcrumbs ===-->
    <div class="breadcrumbs">
        <div class="container">
            <h1 class="pull-left">SCA - Controle Acadêmico</h1>
            <ul class="pull-right breadcrumb">
                <li><a href="Default.asp">Home</a></li>
                <li class="active"><%=session("CodEmpresa")%> - <%=session("EmpresaWeb")%></li>
            </ul>
        </div><!--/container-->
    </div><!--/breadcrumbs-->
    <!--=== End Breadcrumbs ===-->
    <%
		strExecutarSubmitSemestre 					= "S"
		strExecutarSubmitTurma					 	= "S"
		strExecutarSubmitDisciplinaDoProfessor  	= "S"
		strExecutarSubmitProfessor					= "S"
		strPaginaTitulo        	 	= "conteudoProfessor_cad.asp"
	
		' Consulta a Categoria	
		sql = "select codigo "
		sql = sql & " from SRH_COLABORADOR"
		sql = sql & " where codigo_SEG_USUARIOS_SISTEMA = '" & trim(session("usuarioWeb")) & "'"
		sql = sql & " and CodCategoria = 1 "'professor
		sql = sql & " and Situacao = 'A'" 'Ativo
		rs.open sql, cnn
		if rs.EOF = false then	
			strVerificaTipolancamento = "Professor"
		else
			strVerificaTipolancamento = ""
		end if
		rs.close
		
		if Session("Seg_CodCategoria") = "1" then strVerificaTipolancamento = "Professor"
		
		strVerificaRegencia	= Trim(Request.Form("txtVerificaRegencia"))
		ckVerificaRegencia = ""
		if strVerificaRegencia = "S" then ckVerificaRegencia = " checked "	
	
		strHabilitaPlanoEnsino = "N"
		sql = " SELECT top 1 Habilitar_PlanoEnsino, Bloqueia_ConteudoProgramatico "
		sql = sql & " FROM SEG_ENCERRAMENTOATIVIDADES "
		sql = sql & " Where cod_empresa = " & Session("CodEmpresa")
		rs.Open SQL, cnn
		if rs.EOF = false then								
			strHabilitaPlanoEnsino = rs("Habilitar_PlanoEnsino")
			strBloqueiaConteudoProgramatico = rs("Bloqueia_ConteudoProgramatico")
			if isnull(strHabilitaPlanoEnsino) then strHabilitaPlanoEnsino = "N"
			if isnull(strBloqueiaConteudoProgramatico) then strBloqueiaConteudoProgramatico = "0"
		end if
		rs.close
	
		if Trim(Request.Form("txtAnoLetivo")) <> "" then
		   strAnoLetivo 			= Trim(Request.Form("txtAnoLetivo"))
		else
		   strAnoLetivo = session("strAnoLetivo")   
		end if   
	
		if Trim(Request.Form("cmbSemestre")) <> "" then
			intSemestre 				= Trim(Request.Form("cmbSemestre"))
		else
			intSemestre 				= session("strSemestre")
		end if	
		strBloqueio = ""
		if trim(strBloqueiaConteudoProgramatico) <> "0" then
			strAnoLetivo 				= session("strAnoLetivo")   
			intSemestre 				= session("strSemestre")
			strBloqueio                 = " readonly "
		end if	
	
		strOpcaoDesvinculaConteudo	= Trim(Request.Form("optOpcao"))
		intCodProfessor 	        = Trim(Request("cmbProfessor"))
		intCodColaboradorProfessor  = Trim(Request("cmbProfessor"))
	
		intCodTurmaProfessor 	    = Trim(Request("cmbTurmaProfessor"))
		intCodDisciplina		    = Trim(Request.Form("cmbDisciplinaDoProfessor"))
		strDataFinal         		= formatadataAP(date)
		strMes		 	        	= Trim(Request("cmbMes"))
		intCodTurma					= intCodTurmaProfessor
		strSimouNaoTomarPosse 	    = Trim(Request("cmbSimouNaoTomarPosse"))
		
		if Trim(Request("txtDataInicial")) = "" then
		   strDataInicial    	= "" 'formatadataAP(date)
		else   
		   strDataInicial      	= formatadataAP(Trim(Request("txtDataInicial")))
		end if   
	
		if Trim(Request("txtDataInicial")) = "" then
		   strDataFinal   	 =  "" 'formatadataAP(date)
		else   
		   strDataFinal      = formatadataAP(Trim(Request("txtDataFinal")))
		end if   
	 
		strTotalAulasDia     = Trim(Request("txtTotalAulasDia"))
		
		' Valida o ano da data de lançameto com ano Letivo
		if strDataInicial <> "" then 
			if trim(year(strDataInicial)) <> trim(strAnoLetivo) then
				%>
				<script>
					alert("ATENÇÃO: \n\O Ano da Data de Lançamento deve ser igual ao Ano Letivo.");
				</script>
				<%	
				strDataInicial = ""
			end if
		end if
		
		if intCodColaboradorProfessor = "" then intCodColaboradorProfessor = "0"
		if intCodProfessor = "" then intCodProfessor = "0"
		if intCodTurmaProfessor = "" then intCodTurmaProfessor = "0"
		if intCodDisciplina = "" then intCodDisciplina = "0"
	
		sql = "SELECT SCA_TURMA.cod_turma, SCA_TURMA.cod_Semestre , SCA_PERIODO.Cod_Curso, SCA_PERIODO.Cod_Periodo, SCA_TURMA.cod_turno, SCA_TURMA.Sala, SCA_TURMA.NomeTurma"
		sql = sql & " FROM SCA_TURMA "
		sql = sql & " INNER JOIN SCA_GRADECURRICULAR ON SCA_TURMA.Cod_GradeCurricular = SCA_GRADECURRICULAR.Cod_GradeCurricular "
		sql = sql & " INNER JOIN SCA_PERIODO ON SCA_GRADECURRICULAR.Cod_Periodo = SCA_PERIODO.Cod_Periodo"
		SQL = SQL & " WHERE SCA_TURMA.cod_empresa=" & Session("CodEmpresa")
		sql = sql & " AND SCA_TURMA.Cod_Turma= " & intCodTurmaProfessor
		RS.OPEN SQL, CNN
		IF not RS.EOF THEN
			intCodCurso 	= rs("cod_curso")
			intCodPeriodo 	= rs("cod_periodo")
			intCodTurno 	= rs("cod_turno")
			intSemestre 	= rs("cod_Semestre")
			strSemestre 	= rs("cod_Semestre")
	
		END IF
		rs.close
		
		intCodigo 		= Trim(Request.Form("txtCodigo"))
		strDescricao 	= Trim(Request.Form("txtDescricao"))
		strDesabilitaEnvio = " disabled "
			
		if trim(intCodigo) <> "" then
	
			strDesabilitaEnvio = ""
	
			sql = "SELECT *"
			sql = sql & " FROM sca_conteudo"
			sql = sql & " where cod_empresa = " & Session("CodEmpresa")			
			sql = sql & " and codigo = " & intCodigo
			rs.open sql, cnn
			
			if rs.eof = false then
				
				intCodHorario	 		= rs("codigo")
				strDescricao			= rs("conteudo")
				strAnoLetivo	 		= rs("anoletivo")
				intSemestre				= rs("semestre")
				intCodTurmaProfessor	= rs("cod_turma")
				intCodTurma				= rs("cod_turma")
				intCodDisciplina		= rs("cod_disciplina")
				strDataInicial          = formatadataAP(rs("datainicial"))
				strDataFinal            = rs("datafinal")
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
		
		if intCodTurmaProfessor = "" then intCodTurmaProfessor = "0"
	%>
    <!--=== Content Part ===-->
    <div class="container content">		
    
      <!-- Grey Panel -->            
      <div class="panel panel-grey">
        <div class="panel-heading">
        	<h3 class="panel-title"><i class="fa fa-tasks"></i>Conteúdo Programático - Professor</h3>
        </div>
        <!-- Inicia o Painel do Formulario -->     
        <div class="panel-body">
             <!-- Inicia o Form -->     
            <div class="panel-body">                                                        
                <form id="frm" method="post" action="conteudoProfessor_cad.asp">
                	<input name="txtCodigo" value="<%=intCodigo%>" type="hidden">
                	
                    <div class="headline"><h2>Dados Professor</h2></div>
                    
                    <% 	if strVerificaTipolancamento = "" then 
		        		if strOpcaoDesvinculaConteudo = "" then strOpcaoDesvinculaConteudo = "0"
					%>
                    <div class="form-group">
                        <label class="form-label">Tipo Lan&ccedil;amento</label><br>
                        <input <% if strOpcaoDesvinculaConteudo = "0" then response.Write("checked")%> name="optOpcao" type="radio" value="0" onclick='submit()'>Verifica hor&aacute;rio de aula.&nbsp; <br>
    					<input <% if strOpcaoDesvinculaConteudo = "1" then response.Write("checked")%> name="optOpcao" type="radio" value="1" onclick='submit()'>N&atilde;o verifica hor&aacute;rio de aula.</strong>
                    </div>
                    <% end if %>  
                    
                    <div class="form-group">
                        <label class="form-label">Ano Letivo</label>
                        <input <%=strBloqueio%> name="txtAnoLetivo" type="text" class="form-control" id="txtAnoLetivo" onBlur="submit()"  value="<%=strAnoLetivo%>" size="5" maxlength="5" onKeyPress="return formataCampo(this,2,10)">
                    </div>
                    
                     <div class="form-group">
                        <label class="form-label">Semestre</label>
                        <!--#include file="../includes/inc_cmdSemestre.asp" -->
                    </div>
                    
                     <div class="form-group">
                        <label class="form-label">Professor</label>
                        <!--#include file="../includes/inc_cmdProfessor.asp" -->
                    </div>
                    
                    <div class="form-group">
                        <label class="form-label">Data do Lan&ccedil;amento</label>
                        <% if strDesabilitaEnvio = "" then  
                            strBloqueiaData = " readonly "
                          else  
                            strBloqueiaData = " "
                          end if 
                         %>
                         <input <%=strBloqueiaData%> name="txtDataInicial" type="text" class="form-control" id="txtDataInicial" onBlur="submit();" onKeyPress="return formataCampo(this, 3, 10)" size="11" maxlength="10" value="<%=strDataInicial%>" >
                          <% if strHabilitaPlanoEnsino = "N" then %>
                                a
                                <input name="txtDataFinal" type="text" class="form-control" id="txtDataFinal" onBlur="return validaData(this); submit();" onKeyPress="return formataCampo(this, 3, 10)" size="11" maxlength="10" value="<%=strDataFinal%>" >
                          <% end if %> 
                    </div>
                    
                    <div class="form-group">
                        <label class="form-label">Turma</label>
                        <!--#include file="../includes/inc_cmdTurmaProfessor.asp"-->
                    </div>
                    
                    <div class="form-group">
                        <label class="form-label">Disciplina</label>
                        <!--#include file="../includes/inc_cmdDisciplinaDoProfessorConteudo.asp"-->
                    </div>
                    
                     <div class="form-group">
                        <label class="form-label">Verificar Reg&ecirc;ncia</label>
                        <input <%=ckVerificaRegencia%> name="txtVerificaRegencia" id="txtVerificaRegencia" type="checkbox"  onClick='submit()' value="S">
                        - Mostra se existem conte&uacute;do lan&ccedil;ando por outros colaboradores para essa disciplina. / Opcional
                    </div>
                    
                    <% if strHabilitaPlanoEnsino = "S" then %>
                    	<div class="headline"><h2>Conte&uacute;do Program&aacute;tico</h2></div>
                    <%end if%>
                    
                    <%
					 if strHabilitaPlanoEnsino = "S" then
					 
						strConteudo = ""
						sql = "select conteudo_programatico from sca_turma t "
						sql = sql & " inner join sca_gradecurricular gc on t.cod_gradecurricular = gc.cod_gradecurricular "
						sql = sql & " inner join sca_gradecurriculardisciplina gcd on gcd.cod_gradecurricular = gc.cod_gradecurricular and T.situacao='A' "
						sql = sql & " inner join sca_planoensino pe on pe.cod_gradecurricular = gc.cod_gradecurricular and pe.cod_gradecurriculardisciplina = gcd.cod_disciplina and pe.cod_empresa=gc.cod_empresa "
						sql = sql & " where t.cod_empresa = " & Session("CodEmpresa")	
						sql = sql & " and gcd.cod_disciplina = " & intCodDisciplina
						sql = sql & " and t.cod_turma = " & intCodTurmaProfessor
						rs.open sql, cnn
						if rs.eof = false then
							strConteudo	 		= rs("conteudo_programatico")
							if isnull(strConteudo) then strConteudo = ""
						end if 
						rs.close
					end if	
				  %>
                    
                    <div class="form-group">
                        <%=strConteudo%>
                    </div>
                    
                    <% if strHabilitaPlanoEnsino = "S" then 
						if strConteudo <> "" then%>
                        	<div class="form-group">
                            	<div class="headline"><h2>Obs: O quadro acima &eacute; apenas para visualiza&ccedil;&atilde;o, toda inclus&atilde;o dever&aacute; ser feita no cronograma.</h2></div>
                            </div>
                         <% end if 
						end if 
					%>
                    
                    <%
		  			if strDataInicial <> "" and intCodTurmaProfessor <> "0" and intCodDisciplina <> "0" then 
	   			
					sql = " select SCA_HORARIO_AULA.diaSemana, isnull(SCA_HORARIO.numero_aula,'1'), isnull(SCA_HORARIO.numero_aula,'1') * COUNT(SCA_HORARIO_AULA.cod_disciplina) as total_aulas  "
					sql = sql & " from SCA_HORARIO_AULA "
					sql = sql & " inner join SCA_HORARIO on SCA_HORARIO.codigo=SCA_HORARIO_AULA.Cod_Horario " 
					sql = sql & " where SCA_HORARIO_AULA.cod_empresa = " & Session("CodEmpresa")
					sql = sql & " and SCA_HORARIO_AULA.anoletivo = " & strAnoLetivo 
					sql = sql & " and SCA_HORARIO_AULA.cod_turma = " & intCodTurmaProfessor  
					sql = sql & " and SCA_HORARIO_AULA.cod_disciplina = " & intCodDisciplina 
					sql = sql & " and SCA_HORARIO_AULA.diaSemana = " & weekday(strDataInicial) 
					sql = sql & " group by SCA_HORARIO_AULA.diaSemana, SCA_HORARIO.numero_aula "
	
					if strDataInicial <> "" then
						sql = sql & " UNION "
						sql = sql & " select DATEPART(DW, SCA_HORARIO_AULA_EXTRA.DataLancamento) AS diaSemana, isnull(SCA_HORARIO.numero_aula,'1'), isnull(SCA_HORARIO.numero_aula,'1') * COUNT(SCA_HORARIO_AULA_EXTRA.cod_disciplina) as total_aulas  "
						sql = sql & " from SCA_HORARIO_AULA_EXTRA "
						sql = sql & " inner join SCA_HORARIO on SCA_HORARIO.codigo=SCA_HORARIO_AULA_EXTRA.Cod_Horario " 
						sql = sql & " where SCA_HORARIO_AULA_EXTRA.cod_empresa = " & Session("CodEmpresa")
						sql = sql & " and SCA_HORARIO_AULA_EXTRA.anoletivo = " & strAnoLetivo 
						sql = sql & " and SCA_HORARIO_AULA_EXTRA.cod_turma = " & intCodTurmaProfessor  
						sql = sql & " and SCA_HORARIO_AULA_EXTRA.cod_disciplina = " & intCodDisciplina 
						sql = sql & " and SCA_HORARIO_AULA_EXTRA.DataLancamento = '" & formatadataBD(strDataInicial) & "'" 
						sql = sql & " group by SCA_HORARIO_AULA_EXTRA.DataLancamento, SCA_HORARIO.numero_aula "
					end if
					RSAUX.OPEN SQL, CNN
					IF NOT RSAUX.EOF THEN
						if isnull(RSAUX("total_aulas")) then
						   TotalAulaDiaria = 0
						else   
						   TotalAulaDiaria = RSAUX("total_aulas") 
						end if 
					else
						TotalAulaDiaria = 0
					end if
					RSAUX.close
					if TotalAulaDiaria <> 0 then 
					   strTotalAulasDia = TotalAulaDiaria
					end if
					if session("CodGrupo") = "2" then
					   soLeitura = " "
					else
					   soLeitura = " readonly "
					end if   
					%> 
                        <div class="form-group">
                            <label class="form-label">Total de Aulas</label>
                            <input <%=soLeitura%> name="txtTotalAulasDia" type="text" class="form-control" id="txtTotalAulasDia" value="<%=strTotalAulasDia%>" size="2" maxlength="2" > - Hor&aacute;rio de Aulas
                        </div>
                    <% end if  %> 
                    
                    <% if strHabilitaPlanoEnsino = "N" then
						strTipo = "Conte&uacute;do"
					  else
						strTipo = "Cronograma"
					  end if
					 %>
                     
                     <div class="form-group">
                        <label class="form-label"><%=strTipo%></label>
                        <textarea  onkeyup="blocTexto(this.value,'<%=cont%>')"  name="txtDescricao" cols="35" rows="4" class="form-control" id="txtDescricao"><%=strDescricao%></textarea>
						<br /><font color="#FF0000">(caracteres restantes: <span id="cont">500</span>)</font>
                    </div>
                    
                    <div class="form-group">
                        <label>Caso seja informado o m&ecirc;s na op&ccedil;&atilde;o abaixo <strong>&lt; Enviar Programa&ccedil;&atilde;o Did&aacute;tica &gt;</strong>, o mesmo per&iacute;odo e a disciplina ser&aacute; Bloqueado confirmando o <strong>Envio</strong> a Secretaria/Coordena&ccedil;&atilde;o.</label>
                    </div>
                    
                    <div class="form-group">
                        <label class="form-label">Tomar Posse</label>
                        <select name="cmbSimouNaoTomarPosse" class="form-control" id="cmbSimouNaoTomarPosse"  style="width:70pt" onchange='submit()' >
                            <option value="N" <%if strSimouNaoTomarPosse = "N" then response.Write("selected") %>>NAO</option>
                            <option value="S" <%if strSimouNaoTomarPosse = "S" then response.Write("selected") %>>SIM</option>
                        </select>- Transfere conte&uacute;do de um professor para outro conforme mudan&ccedil;a no hor&aacute;rio e aula.
                    </div>
                    
                    <div class="form-group">
                        <label class="form-label">Enviar Programa&ccedil;&atilde;o Did&aacute;tica</label>
                        <!--#include file="../includes/inc_cmbMes.asp"-->
                    </div>
								
                    <legend></legend>
                    <!--#include file="../../includes/inc_botoes_cadastro.asp"-->
				</form>
            	</div>
       	 	</div>
         	<!-- Fecha o Form -->  
      </div>
   	   
       <!--Table Bordered-->
        <div class="panel panel-grey margin-bottom-40">
            <div class="panel-heading">
                <h3 class="panel-title"><i class="fa fa-globe"></i> Lista Conteúdo Programático - Professor</h3>
            </div>
            <div class="panel-body">
            	<div class="table-responsive">
                <table class="table table-bordered">
                    <thead>
                        <tr>
                          <th width="5%" bgcolor="#95A5A6">Turma</th>
                          <th width="11%" bgcolor="#95A5A6">Disciplina</th>
                          <th width="19%" bgcolor="#95A5A6">Professor</th>
                          <th width="18%" bgcolor="#95A5A6">Data/Período</th>
                          <th width="4%" bgcolor="#95A5A6">Aulas</th>
                          <th width="31%" bgcolor="#95A5A6">Conte&uacute;do</th>
                          <th width="7%" bgcolor="#95A5A6">Status</th>
                          <th width="5%" bgcolor="#95A5A6" align="center"><div align="center">Ação</div></th>
                      </tr>
                    </thead>
                    <tbody>
                    <%
                    cont =0
					strCpfTurmaProfessor = ""
					sql = " Select ISNULL(CPF,'') AS CPF"
					sql = sql & " from SRH_COLABORADOR "
					sql = sql & " where codigo = " & intCodColaboradorProfessor
					sql = sql & " and Situacao = 'A'" 'Ativo
					rs1.open sql, cnn
					if rs1.eof = false then
						strCpfTurmaProfessor = TRIM(rs1("CPF"))
					end if
					rs1.close
		
					cont =0
					if intSemestre = "" then intSemestre = session("strSemestre")
					
					sql = "SELECT c.*, t.nometurma, d.Desc_Disciplina, (select nome From SRH_COLABORADOR WHERE codigo = c.cod_colaborador) as nome"
					sql = sql & " FROM SCA_Conteudo c"
					sql = sql & " inner join sca_turma t on t.cod_turma = c.cod_turma and t.cod_empresa = c.cod_empresa"
					sql = sql & " inner join sca_disciplina d on d.Cod_Disciplina = c.Cod_Disciplina and d.cod_empresa = c.cod_empresa"
					sql = sql & " where c.cod_empresa = " & Session("CodEmpresa")			
					sql = sql & " and c.anoletivo = " & strAnoLetivo		
					sql = sql & " and c.semestre in (" & intSemestre & ")"
					if strVerificaRegencia <> "S" then
						sql = sql & " and c.cod_colaborador in (select codigo From SRH_COLABORADOR WHERE cpf = '" & strCpfTurmaProfessor &"')"
					end if
					if intCodTurmaProfessor <> "0" then
						sql = sql & " and c.cod_turma = " & intCodTurmaProfessor
					end if	
					
					if intCodDisciplina <> "0" then
						sql = sql & " and c.Cod_Disciplina = " & intCodDisciplina
					end if	
					sql = sql & " Order by c.anoletivo, c.semestre, t.nometurma, d.Desc_Disciplina, c.datainicial desc"

                    rs.open sql, cnn
                    if rs.eof = false then
                    
                    while not rs.eof
                        cont = cont + 1	
						TotalAulas = TotalAulas + rs("Total_Aulas")	
							
						if strSimouNaoTomarPosse  = "S" and intCodDisciplina <> "0" and intCodColaboradorProfessor <> "0" then
							sql = "UPDATE SCA_CONTEUDO SET Cod_Colaborador = " & intCodColaboradorProfessor
							sql = sql & " WHERE codigo = " & rs("codigo")
							cnn.execute sql
						end if	
						
						if trim(rs("Fechamento")) = "S" then
							strStatus = "<strong><font color='#FF0000'>Enviada</font></strong>"
						else
							strStatus = "<strong>Edi&ccedil;&atilde;o</strong>"
						end if 
						
						if trim(rs("Fechamento")) <> "S" then
						
						else
						
						end if
                    	%>
                        <tr>
                            <td><%=trim(rs("nometurma"))%></td>
                            <td><%=trim(rs("Desc_Disciplina"))%></td>
                            <td><%=trim(rs("nome"))%></td>
                            <td><%=trim(formatadataAP(rs("datainicial")))%>&nbsp;&nbsp;a&nbsp;&nbsp;<%=trim(formatadataAP(rs("datafinal")))%></td>
                            <td><%=rs("Total_Aulas")%></td>
                            <td><%=trim(rs("conteudo"))%></td>
                            <td><%=trim(strStatus)%></td>
                            <td align="center" >
                            <%if trim(rs("Fechamento")) <> "S" then%>
                            	<button class="btn-u btn-u-sea" onClick="resultadoConsulta('<%=rs("codigo")%>')" type="button"><i class="fa fa-file-text-o"></i></button> 
                            <%end if%>
                            </td> 
                        </tr>
                    	<%				
                        rs.movenext
                        wend
                    end if
                    rs.close
                %>
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
        
        function reload(){
            var frm = document.getElementById("frm");
            frm.submit();
        }
        
        function resultadoConsulta(intCodigo){
            var frm = document.getElementById("frm");
            frm.txtCodigo.value=intCodigo;
            frm.submit();
        }
        
        function blocTexto(valor, id)
        {
            quant = 500;
            total = valor.length;
            if(total <= quant)
            {
                resto = quant - total;
                document.getElementById('cont').innerHTML = resto;
            }
            else
            {
                document.getElementById('txtResposta_'+id).value = valor.substr(0,quant);
            }
        }
        
        function salvar(acao){
            
            var frm = document.getElementById("frm");
			
			if (frm.cmbProfessor.value == "0") {
                alert("O Professor deve ser informado !");
                frm.cmbProfessor.focus();
                return false;
            }
			
			 if (frm.txtDataInicial.value == "") {
                alert("A Data Inicial deve ser informada !");
                frm.txtDataInicial.focus();
                return false;
            }
			
			 if (frm.cmbTurmaProfessor.value == "0") {
                alert("A Turma do Professor deve ser Informada !");
                frm.cmbTurmaProfessor.focus();
                return false;
            }
                
            if (frm.cmbDisciplinaDoProfessor.value == "0") {
                alert("A Disciplina do Professor deve ser Informada !");
                frm.cmbDisciplinaDoProfessor.focus();
                return false;
            }
			
            if (frm.txtDescricao.value == "" && frm.cmbMes.value == "0" ) {
                alert("O Conteúdo deve ser informado !");
                frm.txtDescricao.focus();
                return false;
            }
            
		
            if ( acao != "E" ) {
                if (frm.txtTotalAulasDia.value == "" || frm.txtTotalAulasDia.value == "0" ) {
                    alert("O Total de Aulas deve ser informado !");
                    frm.txtTotalAulasDia.focus();
                    return false;
                }
            }
    
            if (frm.cmbSemestre.value == "0") {
                alert("O Semestre deve ser Informado !");
                frm.cmbSemestre.focus();
                return false;
            }
    
           
			
            frm.action="ConteudoProfessor_cod.asp?acao=" + acao;
            frm.submit();
            return true;
        }
    </script>
    <!--=== End Content Part ===-->
   	<!--#include file="../RodapeModulo.asp"-->
	<!--#include file="../jsModulo.asp"-->
</body>
</html> 