<!DOCTYPE html>
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
    <meta http-equiv="X-UA-Compatible" content="IE=10, IE=edge">
    <meta name="viewport" content="width=device-width, initial-scale=1, maximum-scale=1, user-scalable=no" />
    <link href="css/bootstrap.css" rel="stylesheet" />
    <link href="css/bootstrap-theme.min.css" rel="stylesheet" />
    <link href="css/geral.css" rel="stylesheet" />
    <title>Matrícula 2022 - Abadia</title>

    <script>
		function consultarReserva(){
			frm.action = "consultaReserva.asp?consultar=S"
			frm.submit()	
		}
	</script>
    
    
</head>
<!--#include file="includes/inc_cnn.asp"-->
<!--#include file="includes/inc_formatadata.asp"-->
<body>
<form id="frm" name="frm" method="post" action="consultaReserva.asp">
<%			
	consultar 				= request("consultar")
	strCurso 				= request("cmbCurso")
	if strCurso = "" then strCurso = "0"
	strPeriodo 				= request("cmbPeriodo")
	if strPeriodo = "" then strPeriodo = "0"
	intCodRegiao 			= request("cmbRegiao")
	if intCodRegiao = "" then intCodRegiao = "0"
	strNome 				= replace(request("Aluno"),"'","´")
	strNumero 				= request("numero")
	if not isNumeric(strNumero) then strNumero = ""
	
	Session("CodGrupo") = 7

	if strNumero<>"" and consultar = "S" then
		sql = "SELECT r.Codigo, r.inscricao, r.nome, r.data_nascimento, r.mae, r.bairro, r.Periodo, r.Contato, r.curso, rs.cod_regiao, rs.cod_setores"
		sql = sql & " FROM MAT_Reserva r"
		sql = sql & " left join MAT_setores s on s.descricao = r.bairro and s.cod_grupo=" & Session("CodGrupo")
		sql = sql & " left join MAT_regiao_setores rs on rs.cod_setores = s.codigo"
		sql = sql & " where r.Situacao = 'R'"
		sql = sql & " AND ISNULL(r.ATUALIZADO,'N') = 'N'"
		SQL = SQL & " AND r.inscricao = '" & strNumero  &"'"
		rsAux.open sql, cnn
		if not rsAux.eof then
			strCurso 				= replace(rsAux("curso")," ","_")
			if strCurso = "" then strCurso = "0"
			strPeriodo 				= rsAux("periodo")
			if strPeriodo = "" then strPeriodo = "0"
			intCodRegiao 			= rsAux("cod_regiao")
			if intCodRegiao = "" then intCodRegiao = "0"	
			strNome = 	rsAux("nome")
		end if
		rsAux.close
	elseif strNome<>"" and consultar = "S" then
		sql = "SELECT r.Codigo, r.inscricao, r.nome, r.data_nascimento, r.mae, r.bairro, r.Periodo, r.Contato, r.curso, rs.cod_regiao, rs.cod_setores"
		sql = sql & " FROM MAT_Reserva r"
		sql = sql & " left join MAT_setores s on s.descricao = r.bairro and s.cod_grupo=" & Session("CodGrupo")
		sql = sql & " left join MAT_regiao_setores rs on rs.cod_setores = s.codigo"
		sql = sql & " where r.Situacao = 'R'"
		sql = sql & " AND ISNULL(r.ATUALIZADO,'N') = 'N'"
		SQL = SQL & " AND r.nome = '" & strNome & "'"
		rsAux.open sql, cnn
		if not rsAux.eof then
			strCurso 				= replace(rsAux("curso")," ","_")
			if strCurso = "" then strCurso = "0"
			strPeriodo 				= rsAux("periodo")
			if strPeriodo = "" then strPeriodo = "0"
			intCodRegiao 			= rsAux("cod_regiao")
			if intCodRegiao = "" then intCodRegiao = "0"		
		end if
		rsAux.close
	end if
%>


	<div class="container-fluid topo" style="background-color:#FFF">
            <div class="row" >
	            <div class="col-md-6 imgTopo">
                    <img id="logoAparecida" src="img/logomarca-topo-abadia.png" alt="Abadia" vspace="15" style="margin:auto" />
                </div>
                <div class="col-md-6 imgTopo">
                    <img id="logoGemul" src="img/logomarca-topo-gemul.png" alt="Gemul - Gestor de Municípios" vspace="15" style="margin:auto" />
                </div>
	        </div>
    </div>
	
    <ol class="breadcrumb">
        <div class="container">
           <div class="row">
                <div class="col-lg-10">
                    <li><a href="index.html" class="active">&laquo;&nbsp;Voltar</a></li>
                </div>
                <div class="col-lg-2 col-md-2 obrigatorio">
                    * campo obrigatório
                </div>
            </div>
        </div>
    </ol>

    <div class="container">
         <div class="box-categorias">
            <!-- Data de nascimento, Telefone contato, Celular pai, Celular mãe, Celular responsável -->
            <div class="row">
                <div class="row marginb5px">
                    <div class="passo-titulo"> 
                        <h2>&nbsp;&nbsp;<strong><font color="#990000">Matr&iacute;cula Informatizada 2022 </font></strong></h2>
                        <h3>&nbsp;&nbsp;<font color="#990000">Consulta de Cadastro de Reserva</font></h3>
                    </div>
                </div>    
            </div>
        </div>

		<div class="box-categorias">
			<div class="row">
            	<div class="row marginb10px">
                    <div class="passo-titulo"> <h3> Filtros </h3></div>
                </div>
            </div>
            <div class="row">
           		<div class="col-md-3">
                    <div class="form-group">
                        <label for="Aluno"><span class="obrigatorio">*</span><strong>Número da Reserva</strong></label>
                        <input id="Numero" type="text" name="Numero" class="form-control" aria-describedby="helpAluno" maxlength="20" value="<%=strNumero%>" />
                    </div>
                </div>
            </div>
            <div class="row">
           		<div class="col-md-3">
                    <div class="form-group">
                    <strong>Ou</strong>
                    </div>
                </div>
            </div>
			<div class="row">
           		<div class="col-md-12">
                  <div class="form-group">
                        <label for="Aluno"><span class="obrigatorio">*</span><strong>Nome Completo do Aluno</strong></label>
                        <input id="Aluno" type="text" name="Aluno" class="form-control" aria-describedby="helpAluno" maxlength="100" value="<%=strNome%>" />
                    </div>
                </div>
            </div>
            
            <div class="row btn-ajuste marginb20px">
                <input type="button" name="btnConsultar" id="btnConsultar" value=" Consultar Reserva " class="btn btn-large btn-info" onClick="consultarReserva()" />
                <input type="button" name="btnLimpar" id="btnLimpar" value=" Limpar " class="btn btn-large btn-warning" onClick="window.location='consultaReserva.asp'" />
            </div>
		</div>     
        <%if consultar = "S" then%>  
        <div class="box-categorias">
            <div class="row">
                
                <div class="row marginb10px">
                    <div class="passo-titulo"> <h3> Resultado da consulta de cadastro de reserva </h3></div>
                </div>
            </div>       
            
            <div class="row">
                
                <div class="col-md-12">
                <font size="-1">
                <%
                
                sql = "SELECT r.Codigo, r.chave, r.inscricao, r.nome, re.descricao as regiao, r.periodo, r.curso"
                sql = sql & " FROM MAT_Reserva r "
				sql = sql & " left join MAT_setores s on s.descricao = r.bairro and s.cod_grupo=" & Session("CodGrupo")
				sql = sql & " left join MAT_regiao_setores rs on rs.cod_setores = s.codigo"
				sql = sql & " left join MAT_regiao re on rs.cod_regiao = re.codigo "
                sql = sql & " where r.Situacao = 'R'"
                sql = sql & " AND ISNULL(r.ATUALIZADO,'N') = 'N'"
                if intCodRegiao <> "0" then
                    SQL = SQL & " AND rs.cod_regiao  = " & intCodRegiao
                end if
                if strPeriodo <> "0" then
                    SQL = SQL & " AND r.periodo = '" & replace(strPeriodo,"_"," ") & "'"
                end if
                if strCurso <> "0" then
                    SQL = SQL & " AND r.curso = '" & replace(strCurso,"_"," ") & "'"
                end if
                sql = sql & " order by r.codigo"
                rs.open sql, cnn
                if not rs.eof then 
                    %>
                    <table class="table table-striped">
                      <thead>
                        <tr>
                          <th width="3%" scope="col">Ordem</th>
                          <th width="3%" scope="col">Inscrição</th>
                          <th width="25%" scope="col">Nome do Aluno</th>
                          <th width="20%" scope="col">Curso</th>
                          <th width="20%" scope="col">Período</th>
                          <th width="13%" scope="col">Região</th>
						  <th width="5%" scope="col">Emitir</th>
                        </tr>
                      </thead>
                      <tbody>
                    <%
					cont = 0
                    while not rs.eof 
						cont = cont + 1
						if uCase(strNome) = uCase(rs("nome")) then
						idKey = rs("chave")
                        %>
                        <tr>
                          <th scope="row"><font color="#0000CC"><%=cont%></font></th>
                          <td><font color="#0000CC"><strong><%=RS("inscricao")%></strong></font></td>
                          <td><font color="#0000CC"><strong><%=RS("nome")%></strong></font></td>
                          <td><font color="#0000CC"><strong><%=rs("curso")%></strong></font></td>
                          <td><font color="#0000CC"><strong><%=RS("periodo")%></strong></font></td>
                          <td><font color="#0000CC"><strong><%=RS("regiao")%></strong></font></td>
						  <td><a href="matricula-gemul-infantil/Comprovante_reserva.asp?m=n&cv=<%=idKey%>"><img id="ImprimirComprovante" src="img/imprimir.png" alt="Comprovante" vspace="15" style="margin:auto"></a></td>
                        </tr>
                        <%
						end if
                        rs.movenext
                    wend
                end if
                rs.close
                   %>
                  </tbody>
                </table>
                    
               </font>
    
              </div>
                
           </div>
      	</div> 
        <%elseif consultar = "S" then%>
		<div class="container">
           <div class="row">
                <div class="obrigatorio">
                    * campo(s) obrigatório(s) não foram informados!
                </div>
            </div>
        </div>
		<%end if%>
    </div>

    <script src="js/jquery-2.1.3.min.js"></script>
    <script src="js/bootstrap.min.js"></script>
    <script src="js/index.js"></script>
    <script type="text/javascript">
        $(document).ready(function () {
            index.inicialize();
        });
    </script>
</form>
</body>
</html>