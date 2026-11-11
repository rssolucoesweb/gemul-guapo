<!--#include file="../ConfigModulo.asp"-->
	<%
	Session("strNomeSistema") 	= "SEC"
	Session("strSistema") 		= "SEC"
	Session("strModulo")		= "SEC" 
	Session("CodModulo") 		= "19" ' Codigo fixo da tabela SEG_MODULO
	%>
    <!--#include file="../../includes/inc_cnn.asp"-->
	<!--#include file="../menuModulos.asp"-->  
    <!--#include file="../includes/inc_buscaGrupoDeEmpresas.asp"-->
    <!--=== Breadcrumbs ===-->
    <div class="breadcrumbs">
        <div class="container">
            <h1 class="pull-left">Modulo Secretario(a)</h1>
            <ul class="pull-right breadcrumb">
                <li><a href="../Default.asp">Home</a></li>
                <li class="active">SEC - Secretario(a)</li>
            </ul>
        </div><!--/container-->
    </div><!--/breadcrumbs-->
    <!--=== End Breadcrumbs ===-->

     <!--=== Content Part ===-->
    <div class="container content">		
    
      <!-- Grey Panel -->            
      <div class="panel panel-grey">
        <div class="panel-heading">
          <h3 class="panel-title"><i class="fa fa-tasks"></i>SEC - Secretario(a)</h3>
            </div>
            <div class="panel-body">
              <p>&nbsp;</p>
              <p>&nbsp;</p>
              <p align="center">
			  
			  <a href="Quantitativo.asp"><img src="../../assets/img/icones/QtdeAlunos.png" width="350" height="221" border="0" /></a>
			  <a href="QuantitativoTurmas.asp"><img src="../../assets/img/icones/quant_turmas.png" width="350" height="221" border="0" /></a>
			  <a href="colaboradores.asp"><img src="../../assets/img/icones/colaboradores.png" width="350" height="221" border="0" /></a>
			  
			  </p>
              <p>&nbsp;</p>
          </div>
      </div>
        <!-- End Grey Panel -->     
    </div>
    <!--/container-->		
    <!--=== End Content Part ===-->
   	<!--#include file="../RodapeModulo.asp"-->
	<!--#include file="../jsModulo.asp"-->
</body>
</html> 