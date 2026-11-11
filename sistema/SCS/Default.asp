<!--#include file="../ConfigModulo.asp"-->
	<%
	Session("strNomeSistema") 	= "SCS"
	Session("strSistema") 		= "SCS"
	Session("strModulo")		= "SCS" 
	Session("CodModulo") 		= "16" ' Codigo fixo da tabela SEG_MODULO
	%>
    <!--#include file="../../includes/inc_cnn.asp"-->
	<!--#include file="../menuModulos.asp"-->  
    <!--=== Breadcrumbs ===-->
    <div class="breadcrumbs">
        <div class="container">
            <h1 class="pull-left">Modulo Sistema Controle Senso</h1>
            <ul class="pull-right breadcrumb">
                <li><a href="../Default.asp">Home</a></li>
                <li class="active">SCS - Sistema Controle Senso</li>
            </ul>
        </div><!--/container-->
    </div><!--/breadcrumbs-->
    <!--=== End Breadcrumbs ===-->

     <!--=== Content Part ===-->
    <div class="container content">		
    
      <!-- Grey Panel -->            
      <div class="panel panel-grey">
        <div class="panel-heading">
          <h3 class="panel-title"><i class="fa fa-tasks"></i>SCS - Sistema Controle Senso</h3>
            </div>
            <div class="panel-body">
              <p>&nbsp;</p>
              <p>&nbsp;</p>
              <p align="center">SCS - Sistema Controle Senso</p>
          </div>
          <!-- Inicia o Form -->     
            <div class="panel-body">                                                        
                <div class="form-group">
                    <label for="exampleInputEmail1"><a href="Registro00_con.asp">Cadastro de Escola - Indentifica&ccedil;&atilde;o - Registro 00</a></strong></label> <br />
                    <label for="exampleInputEmail1"><a href="Registro10_con.asp">Cadastro de Escola - Caracteriza&ccedil;&atilde;o e Infraestrutura - Registro 10</a></strong></label> <br />
                    <label for="exampleInputEmail1"><a href="Registro20_con.asp">Cadastro de Turma - Registro 20</a></strong></label> <br />
                    <label for="exampleInputEmail1"><a href="Registro30_con.asp">Cadatro de Profissional Escola em Sala de Aula - Registro 30</a> </strong></label> <br />
                    <label for="exampleInputEmail1"><a href="Registro40_con.asp">Cadastro de Profissional Escolar em Sala de Aula - Documentos e Endere&ccedil;o - Registro 40</a></strong></label> <br />
                    <label for="exampleInputEmail1"><a href="Registro50_con.asp">Cadastro de Profissional Escolar em Sala de Aula - Dados Vari&aacute;veris - Registro 50</a></strong></label> <br />
                    <label for="exampleInputEmail1"><a href="Registro51_con.asp">Cadastro de Profissional Escolar em Sala de Aula - Dados de Doc&ecirc;ncia - Registro 51</a></strong></label> <br />
                    <label for="exampleInputEmail1"><a href="Registro60_con.asp">Cadastro de Aluno - Indentifica&ccedil;&atilde;o - Regsitro 60</a></strong></label> <br />
                    <label for="exampleInputEmail1"><a href="Registro70_con.asp">Cadastro de Aluno - Documentos e Endere&ccedil;o - Registro 70</a></strong></label> <br />
                    <label for="exampleInputEmail1"><a href="Registro80_con.asp">Cadastro de Aluno - V&iacute;nculo (Matr&iacute;cula) - Registro 80</a></strong></label> <br />
                </div>
       	 	</div>
         	<!-- Fecha o Form -->  
      </div>
        <!-- End Grey Panel -->     
    </div>
    <!--/container-->		
    <!--=== End Content Part ===-->
   	<!--#include file="../RodapeModulo.asp"-->
	<!--#include file="../jsModulo.asp"-->
</body>
</html> 