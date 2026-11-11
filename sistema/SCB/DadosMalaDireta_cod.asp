	<%
    response.Expires=0
    'Não armazena a página em buffer antes de mostra-la na tela'
    response.Buffer = true
    server.ScriptTimeout = 5000
	%>
	<!--#include file="../ConfigModulo.asp"-->
    <!--#include file="../../includes/inc_verificaSession.asp"-->
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

	'on error resume next
	'------------------
	'PASTA DO ARQUIVO
	'------------------
	strDia = day(date)
	strMes = month(date)
	if len(day(date)) < 2 then strDia = "0" & day(date)
	if len(month(date)) < 2 then strMes = "0" & month(date)

	strNomeArquivo		= "ACERVO.TXT"
	strPastaArquivos	= server.MapPath("../../ControleAcessoAlunos")
	strPastaArquivos 	= strPastaArquivos & "\" & Session("CodEmpresa")
	
	Set file = Server.CreateObject("Scripting.FileSystemObject")

	'Cria a pasta de acordo com codigo do Imovel
	Pasta = Server.MapPath("../../ControleAcessoAlunos") & "\" & Session("CodEmpresa")
	IF Not file.FolderExists(Pasta) THEN
		file.CreateFolder(Pasta)
	END IF

	strCaminho = strPastaArquivos & "\" & strNomeArquivo
	if not file.FileExists(strCaminho) then
		Set outfile = file.CreateTextFile(strCaminho, True) 'Parâmetros: Caminho, OverWrite'
	else
		Set outfile = file.OpenTextFile(strCaminho, 2) 'Parâmetros: Caminho, Tipo de Abertura'
	end if
	
	strPaginaTitulo = "DadosMalaDireta_con.asp"
	
	strOpcaoRelatorio		= Trim(Request.Form("optOpcao"))
	strCdu 	                = Trim(Request.Form("txtCdu"))
	strSimouNao             = Trim(Request.Form("cmbSimouNao"))

	sql = " SELECT "
	sql = sql & " PE.COD_PUBLICACAOEXEMPLARES AS REGISTRO, "
	sql = sql & " P.TITULO, "
	sql = sql & " P.EDICAOPUBLICACAO AS EDICAO, "
	sql = sql & " P.ANOPUBLICACAO AS PUBLICACAO, "
	sql = sql & " P.VOLUMEPUBLICACAO AS VOLUME, "
	sql = sql & " A.NOME_AUTOR AS AUTOR, "
	sql = sql & " E.NOME_EDITORA AS EDITORA, "
	sql = sql & " P.COD_CDU AS CDU, "
	sql = sql & " P.ISBN, "
	sql = sql & " SUBSTRING(UPPER(A.NOME_AUTOR),1,3) AS INICIAIS_AUTOR, "
	sql = sql & " SUBSTRING(LOWER(P.TITULO),1,3) AS INICIAIS_TITULO "
	sql = sql & " FROM SCB_PUBLICACAOEXEMPLARES PE "
	sql = sql & " INNER JOIN SCB_PUBLICACAO P ON P.COD_PUBLICACAO = PE.COD_PUBLICACAO "
	sql = sql & " INNER JOIN SCB_PUBLICACAOAUTORES PA ON PA.COD_PUBLICACAO = P.COD_PUBLICACAO "
	sql = sql & " INNER JOIN SCB_AUTORES A ON A.COD_AUTOR = PA.COD_AUTOR "
	sql = sql & " INNER JOIN SCB_EDITORAS E ON E.COD_EDITORA = P.COD_EDITORA "
	sql = sql & " where substring(p.cod_cdu,1,"& len(strCdu)& ") = '" & strCdu & "'" 
	if strSimouNao = "S" then 
       sql = sql & " and P.ETIQUETA = 'N' "
	end if   
	sql = sql & " order by P.COD_CDU "
	rs.open sql, cnn 
	if not rs.eof then  
       strLinha1 = "" 
	   While not rs.eof 
	     seleciona = ""
	     if seleciona = "" then
 		    strLinha2 = trim(rs("REGISTRO")) & ";"
		    strLinha2 = strLinha2 & trim(rs("TITULO")) & ";" 
		    strLinha2 = strLinha2 & trim(rs("EDICAO")) & ";" 
		    strLinha2 = strLinha2 & trim(rs("PUBLICACAO")) & ";"
		    strLinha2 = strLinha2 & trim(rs("VOLUME")) &  ";"  

		    strLinha2 = strLinha2 & trim(rs("AUTOR")) &  ";"  
			strLinha2 = strLinha2 & trim(rs("EDITORA")) &  ";"  
		    strLinha2 = strLinha2 & trim(rs("CDU")) & ";" 
		    strLinha2 = strLinha2 & trim(rs("ISBN")) & ";"
		    strLinha2 = strLinha2 & trim(rs("INICIAIS_AUTOR")) & ";" 
			strLinha2 = strLinha2 & trim(rs("INICIAIS_TITULO")) & ";" 
	        if strLinha1 = "" then		
               strLinha1="REGISTRO;TITULO;EDICAO;PUBLICACAO;VOLUME;AUTOR;EDITORA;CDU;ISBN;INICIAIS_AUTOR; INICIAIS_TITULO;"
		       outfile.WriteLine(strLinha1)
		    end if	
 		    outfile.WriteLine(strLinha2)
		 end if	
		 rs.movenext
	   wend

	end if
	rs.close
	%>
     <!--=== Content Part ===-->
    <div class="container content">		
      <!-- Grey Panel -->            
      <div class="panel panel-grey">
        <div class="panel-heading">
        	<h3 class="panel-title"><i class="fa fa-tasks"></i>Dados para Mala Direta</h3>
        </div>
        <!-- Inicia o Painel do Formulario -->     
        <div class="panel-body">
             <!-- Inicia o Form -->     
            <div class="panel-body" align="center">                                                        
                <form id="frm" class="margin-bottom-10" method="post">
                  <div class="form-group">
                        <label fclass="form-label">
                        <div align="center">Clique com o bot&atilde;o direito do mouse no &iacute;cone abaixo<br />
                          e escolha a op&ccedil;&atilde;o  &quot;salvar destino como...&quot;</div>
                        </label>
                  		<legend></legend>
                        <div align="center"><a href="http://www.sisge.com.br/ControleAcessoAlunos/<%=Session("CodEmpresa")%>/<%=strNomeArquivo%>" target="_blank"><img src="../../assets/img/salvar.gif"><br>
                              <strong><%=strNomeArquivo%></strong></a>
                            </div>
                    </div>
                </form>
            	</div>
       	 	</div>
         	<!-- Fecha o Form -->  
      </div>
    
    </div>
   	<!--#include file="../RodapeModulo.asp"-->
	<!--#include file="../jsModulo.asp"-->
</body>
</html> 