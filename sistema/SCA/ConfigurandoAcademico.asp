<!--
	::	DESENVOLVIDO POR "RS SOLUÇÕES WEB - www.rssolucoesweb.com.br"
	::	Data de Criação...: 02/03/2009
	::	Desenvolvedores...: Sergio Borges - sergiob76@hotmail.com
	::	Objetivo Pagina...: Bimestre
-->
<html>
<head>
<title><%=session("Titulo")%></title>
<link href="../../estilo/css.css" rel="stylesheet" type="text/css">
<style type="text/css">
<!--
.texto1 {font-family: Arial, Helvetica, sans-serif}
.style1 {
	font-family: Arial, Helvetica, sans-serif;
	font-weight: bold;
	font-style: italic;
}
.style8 {font-family: Arial, Helvetica, sans-serif; font-weight: bold; }
-->
</style>
</head>
<body  leftmargin="0" topmargin="0" marginwidth="0" marginheight="0">
<script src="../../js/js_funcoes_gerais.js"></script>
<!--#include file="../../includes/inc_verificaSession.asp"-->
<!--#include file="../../includes/inc_cnn.asp"-->
<!--#include file=topo.asp-->
<!--#include file="../../includes/inc_formatadata.asp"-->
<table width="100%" height="355" border="0"  class="CorFundo" cellpadding="0" cellspacing="0">
  <tr valign="top">
    <td>
	<table  border="0" width="100%" cellspacing="0" cellpadding="0">
      <tr valign="top">
        <td colspan="2" align="center">
		<form id="frm" method="post">
		  <table width="708" border="0" cellpadding="0" cellspacing="0">

            <tr valign="top">
              <td width="700" align="center" class="tituloSistema"><strong><em>CONFIGURANDO CADASTRO INICIAL </em></strong></td>
            </tr>
          </table>
		  <br>
		  <table width="98%" border="0" cellspacing="0" cellpadding="0">
          <tr>
            <td width="703"><input type="button" name="cmdPrincipal" style="cursor:hand"   value="Voltar"  class="botao" onClick="window.location='Configurando.asp'">
              <p align="center">&nbsp;</p>
              <div align="center" class="texto1">
                <table border="0" cellspacing="0" cellpadding="0" width="708">
                  <tr>
                    <td width="708" valign="top"><p><em><strong>01)TRANSPORTE ESCOLAR </strong></em></p>
                      <p><em><strong>Menu - ACAD&Ecirc;MICO&nbsp; &gt;&nbsp; Cadastro Inicial&nbsp; &gt;&nbsp; <u>Transporte Escolar</u></strong><u></u></em></p></td>
                  </tr>
                </table>
              </div>
              <p class="texto1"><strong>Nome da Rota</strong>:&nbsp;Descri&ccedil;&atilde;o da Rota a ser cadastrada.<br>
                <strong>Dist&acirc;ncia percorrida  (km)</strong>: Valor  total em Km.<br>
                <strong>Motorista</strong>: Nome do Motorista  Respons&aacute;vel &ndash; Dever&aacute; estar cadastrado em <strong><em>Recursos Humanos &gt; Cadastro &gt; <u>Colaborador</u></em></strong>,  onde dever&aacute; estar selecionada a categoria de MOTORISTA.<br>
                <strong>Valor</strong>: Informar somente se  necess&aacute;rio.<br>
                <strong>Ve&iacute;culo, placa, cor</strong> : Dados do Ve&iacute;culo em opera&ccedil;&atilde;o  na rota.<br>
                <strong>Data</strong>: Cria&ccedil;&atilde;o da Rota.<br>
                <strong>Observa&ccedil;&atilde;o</strong>: Informa&ccedil;&otilde;es complementares  sobre a rota cadastrada.</p>
              <hr size="1" color="#999999"></p>
              <div align="center" class="texto1">
                <table border="0" cellspacing="0" cellpadding="0" width="708">
                  <tr>
                    <td width="708" valign="top"><p><em><strong>02)SITUA&Ccedil;&Atilde;O ACAD&Ecirc;MICA </strong></em></p>
                      <p><em><strong>Menu - ACAD&Ecirc;MICO&nbsp; &gt;&nbsp; Cadastro Inicial&nbsp; &gt;&nbsp; <u>Situa&ccedil;&atilde;o Acad&ecirc;mica</u></strong><u></u></em></p></td>
                  </tr>
                </table>
              </div>
              <p class="texto1"><strong>Situa&ccedil;&atilde;o </strong>: Descri&ccedil;&atilde;o da Situa&ccedil;&atilde;o.              
              <p class="texto1"><strong>Exemplos de situa&ccedil;&otilde;es acad&ecirc;micas</strong>: ABANDONO, ATIVO, CANCELADO, FORMADO, FORMANDO, PR&Eacute;-MATR&Iacute;CULA,TRANCADO e TRANSFERIDO.
              <hr size="1" color="#999999">
              <div align="center" class="texto1">
                <table border="0" cellspacing="0" cellpadding="0" width="708">
                  <tr>
                    <td width="708" valign="top"><p><em><strong>03)REGIME DE ENSINO </strong></em></p>
                      <p><strong><em>Menu - ACAD&Ecirc;MICO&nbsp; &gt;&nbsp; Cadastro Inicial&nbsp; &gt;&nbsp; <u>Regime de Ensino</u></em></strong></p></td>
                  </tr>
                </table>
              </div>
              <p class="texto1"><strong>Regime de Ensino</strong>: Descri&ccedil;&atilde;o do regime de  ensino da Unidade Escolar. <br>
                <strong>Tipo</strong>: Podendo ser Anual ou  Semestral conforme a marca&ccedil;&atilde;o da op&ccedil;&atilde;o.</p>
              <p class="texto1"><strong>Exemplos de marca&ccedil;&atilde;o</strong>:<br>
                <strong>Marcando ANUAL</strong> &ndash; 01 ano com  4 Bimestres.<br>
                <strong>Marcando SEMESTRAL</strong> &ndash; 06  Meses com 2 Bimestres.<br>
                <strong>Marcando ANUAL E SEMESTRAL</strong> &ndash;  O Sistema Trabalhar&aacute; com os dois regimes ao mesmo tempo.</p>
              <hr size="1" color="#999999">
              <div align="center" class="texto1">
                <table border="0" cellspacing="0" cellpadding="0" width="708">
                  <tr>
                    <td width="708" valign="top"><p><em><strong>04)FORMA DE INGRESSO </strong></em></p>
                      <p><strong><em>Menu - ACAD&Ecirc;MICO&nbsp; &gt;&nbsp; Cadastro Inicial&nbsp; &gt;&nbsp; <u>Forma de Ingresso</u></em></strong></p></td>
                  </tr>
                </table>
              </div>
              <p class="texto1"><strong>Descri&ccedil;&atilde;o</strong>: Descri&ccedil;&atilde;o da forma que o  aluno ingressou na Unidade Escolar.
              <p class="texto1"><strong>Exemplos de formas de  ingresso</strong>: TRANSFERIDO, VETERANO E NOVATO.
              <hr size="1" color="#999999">
              <div align="center" class="texto1">
                <table border="0" cellspacing="0" cellpadding="0" width="708">
                  <tr>
                    <td width="708" valign="top"><p><em><strong>05)MOTIVOS DE AFASTAMENTO </strong></em></p>
                      <p><strong><em>Menu - ACAD&Ecirc;MICO&nbsp; &gt;&nbsp; Cadastro Inicial&nbsp; &gt;&nbsp; <u>Motivos de Afastamento</u></em></strong></p></td>
                  </tr>
                </table>
              </div>
              <p class="texto1"><strong>Motivo</strong>: Descri&ccedil;&atilde;o do motivo em que o  aluno foi afastado.
              <p class="texto1"><strong>Exemplos de Motivos</strong>:
                Mudan&ccedil;a, 
                Familiar etc... 
              <p class="texto1"><strong>Obs</strong>: Dever&aacute; ser  cadastrado conforme a real necessidade de sua unidade escolar.</p>
              <hr size="1" color="#999999">
              <div align="center" class="texto1">
                <table border="0" cellspacing="0" cellpadding="0" width="708">
                  <tr>
                    <td width="708" valign="top"><p><strong><em>06)LEGENDAS DE RESULTADOS</em></strong> </p>
                      <p><strong><em>Menu - ACAD&Ecirc;MICO&nbsp; &gt;&nbsp; Cadastro Inicial&nbsp; &gt;&nbsp; <u>Legendas de Resultados</u></em></strong></p></td>
                  </tr>
                </table>
              </div>
              <p class="texto1"><strong>Descri&ccedil;&atilde;o</strong>: Descri&ccedil;&atilde;o dos resultados utilizado pela unidade escolar.<br>
                      <strong>Desc. Abreviada</strong>: Descri&ccedil;&atilde;o Abreviada dos  resultados utilizado pela unidade escolar. <br>
                      <strong>Crit&eacute;rio:</strong> Crit&eacute;rio que assumir&aacute; a  legenda de resultados sendo j&aacute; definido pelo sistema.
              <p class="texto1"><strong>Rela&ccedil;&atilde;o de crit&eacute;rios pr&eacute;-definidos</strong>:<br>
                <strong>Sem Crit&eacute;rio</strong> &ndash; N&atilde;o utiliza as f&oacute;rmulas para  aprova&ccedil;&atilde;o ou reprova&ccedil;&atilde;o. <br>
                <strong>Aprova&ccedil;&atilde;o</strong> - &nbsp;Utiliza as f&oacute;rmulas para aprova&ccedil;&atilde;o ou reprova&ccedil;&atilde;o gerando  o resultado final do aluno. 
                <strong>Reprova&ccedil;&atilde;o Por Nota</strong> - Utiliza as f&oacute;rmulas para  aprova&ccedil;&atilde;o ou reprova&ccedil;&atilde;o gerando o resultado final do aluno pela Nota. <br>
                <strong>Reprova&ccedil;&atilde;o por Falta</strong> - Utiliza as f&oacute;rmulas para  aprova&ccedil;&atilde;o ou reprova&ccedil;&atilde;o gerando o resultado final do aluno pela Falta. 
              <p class="texto1"><strong>Dispensado</strong> - N&atilde;o utiliza as f&oacute;rmulas para  aprova&ccedil;&atilde;o ou reprova&ccedil;&atilde;o. <br>
  &nbsp; <br>
                <strong>Exemplos de Legendas de  Resultados</strong>:</p>
              <ul class="texto1">
                <li>APROVADO &gt; AP &gt; Aprova&ccedil;&atilde;o&nbsp; </li>
                <li>APROVEITAMENTO &gt; &nbsp;AC &gt;  Sem Crit&eacute;rio&nbsp; </li>
                <li>CURSANDO &gt; CR &gt; Sem Crit&eacute;rio&nbsp; </li>
                <li>DISPENSADO &gt; &nbsp;DI &gt; Sem  Crit&eacute;rio&nbsp; </li>
                <li>REPROVADO POR NOTA &gt; &nbsp;RP  &gt; &nbsp;Reprova&ccedil;&atilde;o Por Nota&nbsp; </li>
                <li>REPROVADO POR FALTA &gt; &nbsp;RF  &gt; &nbsp;Reprova&ccedil;&atilde;o Por Falta&nbsp; </li>
                <li>TRANCAMENTO DE MATRICULA &gt; TM &gt; Sem Crit&eacute;rio&nbsp; </li>
              </ul>
              <hr size="1" color="#999999">
              <div align="center" class="texto1">
                <table border="0" cellspacing="0" cellpadding="0" width="708">
                  <tr>
                    <td width="708" valign="top"><p><em><strong>07)N&Iacute;VEL DE ENSINO </strong></em></p>
                      <p><strong><em>Menu - ACAD&Ecirc;MICO&nbsp; &gt;&nbsp; Cadastro Inicial&nbsp; &gt;&nbsp; <u>N&iacute;vel de Ensino</u></em></strong></p></td>
                  </tr>
                </table>
              </div>
              <p class="texto1"><strong>Grau</strong>:&nbsp; Descri&ccedil;&atilde;o do n&iacute;vel de ensino adotado na  unidade escolar.</p>
              <p class="texto1"><strong>Exemplo</strong>: EDUCA&Ccedil;&Atilde;O B&Aacute;SICA, para as  unidades escolares que oferecem o Ensino Infantil e Fundamental.</p>
              <hr size="1" color="#999999">
              <div align="center" class="texto1">
                <table border="0" cellspacing="0" cellpadding="0" width="708">
                  <tr>
                    <td width="708" valign="top"><p><strong><em>08)EQUIPAMENTOS DID&Aacute;TICOS </em></strong></p>
                      <p><strong><em>Menu - ACAD&Ecirc;MICO&nbsp; &gt;&nbsp; Cadastro Inicial&nbsp; &gt;&nbsp; <u>Equipamentos Did&aacute;ticos</u></em></strong></p></td>
                  </tr>
                </table>
              </div>
              <p class="texto1"><strong>Equipamento</strong>: Descri&ccedil;&atilde;o  do Equipamento dispon&iacute;vel na unidade escolar, podendo ser um aparelho de som,  televis&atilde;o, microfones e projetores etc...&nbsp; <br>
                <strong>Respons&aacute;vel</strong>:&nbsp; Nome do respons&aacute;vel pela guarda do  equipamento.<br>
                <strong>Situa&ccedil;&atilde;o</strong>:&nbsp;<strong>Ativo</strong> - O equipamento  est&aacute; <strong>dispon&iacute;vel</strong> para utiliza&ccedil;&atilde;o do  professor, podendo o mesmo realizar sua loca&ccedil;&atilde;o pelo pr&oacute;prio Sistema. <strong> Inativo</strong> -  O  equipamento est&aacute; <strong>indispon&iacute;vel</strong> para  utiliza&ccedil;&atilde;o do professor, impossibilitando o mesmo de locar e at&eacute; mesmo ser  visualizado.</p>
              <hr size="1" color="#999999">
              <div align="center" class="texto1">
                <table border="0" cellspacing="0" cellpadding="0" width="708">
                  <tr>
                    <td width="708" valign="top"><p><strong><em>09)CADASTRO DE OCORR&Ecirc;NCIAS </em></strong> </p>
                      <p><strong><em>Menu - ACAD&Ecirc;MICO&nbsp; &gt;&nbsp; Cadastro Inicial&nbsp; &gt;&nbsp; <u>Cadastro de Ocorr&ecirc;ncias</u></em></strong></p></td>
                  </tr>
                </table>
              </div>
              <p class="texto1"><strong>Consultar Ocorr&ecirc;ncias</strong>:  Clicando lupa o sistema listar&aacute; todas as ocorr&ecirc;ncias, dando ainda a op&ccedil;&atilde;o para  que o usu&aacute;rio informe parte do nome do aluno para facilitar a localiza&ccedil;&atilde;o da  Ocorr&ecirc;ncia. <br>
                <strong>Aluno</strong>:&nbsp; Clicando na lupa o sistema listar&aacute; os alunos,  selecionando um aluno, o sistema mostrar&aacute; as ocorr&ecirc;ncias vinculada a ele  liberando o cadastro de uma nova.<br>
                <strong>Departamento</strong>:&nbsp; Departamento respons&aacute;vel pela ocorr&ecirc;ncia.&nbsp; <br>
                <strong>Data Ocorr&ecirc;ncia</strong>:&nbsp; Data de lan&ccedil;amento da ocorr&ecirc;ncia.&nbsp; <br>
                <strong>Validade  Ocorr&ecirc;ncia</strong>:&nbsp; Validade do lan&ccedil;amento da  ocorr&ecirc;ncia.<br>
                <strong>Ocorr&ecirc;ncia</strong>: Observa&ccedil;&otilde;es  sobre a ocorr&ecirc;ncia lan&ccedil;ada.</p>
              <hr size="1" color="#999999">
              <div align="center" class="texto1">
                <table border="0" cellspacing="0" cellpadding="0" width="708">
                  <tr>
                    <td width="708" valign="top"><p><strong><em>10)TIPO DE AVALIA&Ccedil;&Atilde;O </em></strong> </p>
                      <p><strong><em>Menu - ACAD&Ecirc;MICO&nbsp; &gt;&nbsp; Cadastro Inicial&nbsp; &gt;&nbsp; <u>Tipo de Avalia&ccedil;&atilde;o</u></em></strong></p></td>
                  </tr>
                </table>
              </div>
              <p class="texto1"><strong>Aqui o usu&aacute;rio monta a formata&ccedil;&atilde;o e as f&oacute;rmulas que  ser&atilde;o utilizadas no boletim/extrato escolar.</strong></p>
              <p class="texto1"><strong>Curso</strong>:&nbsp; Selecione os cursos cadastrados em sua  unidades ex: - EDUCA&Ccedil;&Atilde;O INFANTIL, ENSINO FUNDAMENTAL, ENSINO FUNDAMENTAL EM 09  ANOS, ENSINO M&Eacute;DIO, SUPLETIVO etc... <br>
                <strong>Descri&ccedil;&atilde;o</strong>: Descri&ccedil;&atilde;o da  coluna do componente cadastrado ex: - 1&ordm; BIMESTRE<br>
                <strong>Sigla</strong>: Descri&ccedil;&atilde;o  abreviada do componente cadastrado ex: 1&ordm; BIM <br>
                <strong>Tipo</strong>:&nbsp; Categoria de componentes j&aacute; definidas pelo  sistema ex: - 1&ordm; Bimestre, 2&ordm; Bimestre, 3&ordm; Bimestre, 4&ordm; Bimestre, M&eacute;dia  Provis&oacute;ria, Exame, Conselho de Classe&nbsp; e  Media Final <br>
                <strong>Campo</strong>:&nbsp; Campo no qual ficar&aacute; registrado o componente,  podendo ser assumir uma das 15 op&ccedil;&otilde;es definidas pelo sistema ex: - C1, C2, C3,  C4, C5, C6, C7, C8, C9, C10, C11, C12, C13, C14 e C15&nbsp; <br>
                <strong>F&oacute;rmula</strong>:&nbsp; F&oacute;rmula de c&aacute;lculo que dever&aacute; gerar o valor  do componente ex: - (C1+C2+C3+C4)/4&nbsp; <br>
                <strong>Digitar</strong>:&nbsp; Sim ou N&atilde;o, aqui &eacute; definido se o campo  cadastrado e para lan&ccedil;amento de uma nota ou para apresenta&ccedil;&atilde;o de um resultado. <br>
                <strong>Obs</strong>: Quando o campo  f&oacute;rmula estiver preenchido por uma f&oacute;rmula, a op&ccedil;&atilde;o digitar dever&aacute; ser marcada  como N&atilde;o e Sim caso n&atilde;o esteja sido informada nenhuma f&oacute;rmula.&nbsp; <br>
  &nbsp; <br>
                <strong>Exemplos de f&oacute;rmulas a  ser cadastradas</strong>:&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; <br>
  &nbsp;<br>
                C5 = (C1+C2+C3+C4)/4 <br>
                Somando as notas do 1&ordm;,  2&ordm;, 3&ordm; e 4&ordm; bimestre e as dividindo por 4.<br>
                C7 =  (((C1+C2+C3+C4)/4)+C6)/2<br>
                Somada as nota do 1&ordm;,  2&ordm;, 3&ordm; e 4&ordm; bimestre e as dividindo por 4, sendo esse resultado somado a nota  de recupera&ccedil;&atilde;o e dividido por 2.</p>
              <hr size="1" color="#999999">
              
              <div align="center" class="texto1">
                <table border="0" cellspacing="0" cellpadding="0" width="708">
                  <tr>
                    <td width="708" valign="top"><p><strong><em>11)EMISS&Atilde;O DE DOCUMENTOS </em></strong></p>
                      <p><strong><em>Menu - ACAD&Ecirc;MICO&nbsp; &gt;&nbsp; Cadastro Inicial&nbsp; &gt;&nbsp;<u>Emiss&atilde;o de Documentos </u></em></strong></p></td>
                  </tr>
                </table>
              </div>
              <p class="texto1"><strong>Essa ferramenta foi  projetada para que o pr&oacute;prio usu&aacute;rio possa a desenvolver de forma din&acirc;mica &nbsp;suas documenta&ccedil;&otilde;es internas como Atestados,  Declara&ccedil;&otilde;es e Certificados.</strong></p>
              <p class="texto1"><strong>T&iacute;tulo</strong>:&nbsp; Descri&ccedil;&atilde;o do documento a ser desenvolvido.<br>
                <strong>Departamento</strong>:&nbsp; Departamento a qual pertence o documento.  Caso documento for criado pela Secretaria Geral&nbsp;  somente esse departamento ter&aacute; acesso para manuten&ccedil;&atilde;o e utiliza&ccedil;&atilde;o do documento  criado.</p>
              <p class="texto1">&nbsp;</p>
              <p class="style8"><strong>Segue abaixo os campos  dispon&iacute;veis para cria&ccedil;&atilde;o dos documentos</strong>:</p>
              <p class="style8">Informa&ccedil;&otilde;es Pessoais do Aluno </p>
              <p class="texto1">Nome do Aluno, Matr&iacute;cula  do Aluno, Data Nasc., Cidade de Nascimento, Estado de Nasc., Identidade, CPF,  T&iacute;tulo, de Eleitor, Estado Civil,&nbsp; Pai do  Aluno, M&atilde;e do Aluno e Nacionalidade. <br>
  &nbsp;</p>
              <p class="style8">Dados Escolares </p>
              <p class="texto1">Ano Letivo, Curso Atual,  Per&iacute;odo Atual, Turno Atual, Turma do Aluno, Situa&ccedil;&atilde;o do Aluno, Forma Ingresso,&nbsp; Data da Matr&iacute;cula, Data Cola&ccedil;&atilde;o,&nbsp; Data Certificado,&nbsp; Ano Conclus&atilde;o e&nbsp; Semestre. <br>
  &nbsp;</p>
              <p class="style8">Data atual </p>
              <p class="texto1">Cidade, Dia, M&ecirc;s e Ano. <br>
  &nbsp;</p>
              <p class="style8">Representantes Legais </p>
              <p class="texto1">Secretario(a) e  Diretor(a).&nbsp;&nbsp;&nbsp;&nbsp; <br>
  &nbsp;</p>
              <p class="style8">Autoriza&ccedil;&atilde;o </p>
              <p class="texto1">Autoriza&ccedil;&atilde;o,&nbsp; Data Autoriza&ccedil;&atilde;o,&nbsp; Reconhecimento,&nbsp; Data Reconhecimento e CH Exigida.&nbsp;&nbsp;&nbsp; <br>
  &nbsp;</p>
              <p class="style8">Valida&ccedil;&otilde;es </p>
              <p class="texto1"><strong>Checar posi&ccedil;&atilde;o  financeira:</strong> Somente se o sistema  estiver configurado para trabalhar com o financeiro.&nbsp;&nbsp; <br>
                <strong>Situa&ccedil;&atilde;o cadastral:</strong> o  documento s&oacute; ser&aacute; emitido para alunos com as situa&ccedil;&otilde;es acad&ecirc;micas informadas &ndash;  ex: &nbsp;ATIVO,&nbsp; PR&Eacute;-MATR&Iacute;CULA,&nbsp; CANCELADO,&nbsp;  DESISTENTE e TRANSFERIDO(A). Caso n&atilde;o seja informada nenhuma o sistema  n&atilde;o ir&aacute; validar essa condi&ccedil;&atilde;o.&nbsp; </p>
              <p class="style8">&nbsp;</p>
              <p class="style8">Campos/Comandos Selecionados</p>
              <p class="texto1">Conforme a marca&ccedil;&atilde;o dos  campos, os seguintes comando dever&atilde;o aparecer em seu canto superior direito da tela,  lembrando ainda que&nbsp; tais comando n&atilde;o  poder&aacute; sofrer nenhuma altera&ccedil;&atilde;o em sua estrutura para que funcione corretamente.  Todos os campos selecionados dever&atilde;o ser utilizados no texto do documento. </p>
              <p class="texto1">&nbsp;</p>
              <p align="center" class="texto1">&lt;a id=MATRICULA&gt;&lt;/a&gt;<br>
  &lt;a id=DATANASCIMENTO&gt;&lt;/a&gt;<br>
  &lt;a id=CIDADENASCIMENTO&gt;&lt;/a&gt;<br>
  &lt;a id=UFNASCIMENTO&gt;&lt;/a&gt;<br>
  &lt;a id=IDENTIDADE&gt;&lt;/a&gt;<br>
  &lt;a id=CPF&gt;&lt;/a&gt;<br>
  &lt;a id=TITULO&gt;&lt;/a&gt;<br>
  &lt;a id=ANOLETIVO&gt;&lt;/a&gt;<br>
  &lt;a id=PAI&gt;&lt;/a&gt;<br>
  &lt;a id=MAE&gt;&lt;/a&gt;<br>
  &lt;a id=CURSOATUAL&gt;&lt;/a&gt;<br>
  &lt;a id=PERIODOATUAL&gt;&lt;/a&gt;<br>
  &lt;a id=TURNOATUAL&gt;&lt;/a&gt;<br>
  &lt;a id=TURMAALUNO&gt;&lt;/a&gt;<br>
  &lt;a id=SITUACAOALUNO&gt;&lt;/a&gt;<br>
  &lt;a id=FORMAINGRESSO&gt;&lt;/a&gt;<br>
  &lt;a id=CIDADE&gt;&lt;/a&gt;<br>
  &lt;a id=DIA&gt;&lt;/a&gt;<br>
  &lt;a id=MES&gt;&lt;/a&gt;<br>
  &lt;a id=ANO&gt;&lt;/a&gt;<br>
  &lt;a id=SECRETARIO&gt;&lt;/a&gt;<br>
  &lt;a id=DIRETOR&gt;&lt;/a&gt;<br>
  &lt;a id=DATAMATRICULA&gt;&lt;/a&gt;<br>
  &lt;a id=NACIONALIDADE&gt;&lt;/a&gt;<br>
  &lt;a id=ESTADOCIVIL&gt;&lt;/a&gt;<br>
  &lt;a id=DATACERTIFICADO&gt;&lt;/a&gt;<br>
  &lt;a id=DATACOLACAO&gt;&lt;/a&gt;<br>
  &lt;a id=RECONHECIMENTO&gt;&lt;/a&gt;<br>
  &lt;a id=DATARECONHECIMENTO&gt;&lt;/a&gt;<br>
  &lt;a id=AUTORIZACAO&gt;&lt;/a&gt;<br>
  &lt;a id=DATAAUTORIZACAO&gt;&lt;/a&gt;<br>
  &lt;a id=CH_EXIGIDA&gt;&lt;/a&gt;<br>
  &lt;a id=ANOCONCLUSAO&gt;&lt;/a&gt;<br>
  &lt;a  id=SEMESTRE&gt;&lt;/a&gt; </p>
              <p class="style8">&nbsp;</p>
              <p class="style8">Texto do Documento&nbsp; </p>
              <p class="texto1">A partir de um documento  texto gerado pelo bloco de notas ou Word, voc&ecirc; pode substituir os campos de  forma din&acirc;mica apenas arrastando o comando selecionado com um duplo click. Exemplo de uma estrutura de documento montada pelo usu&aacute;rio: </p>
              <p align="center" class="texto1">&nbsp;</p>
              <p align="center" class="texto1">DECLARA&Ccedil;&Atilde;O<br>
                &nbsp;<br>
                Declaramos para os  devidos fins que o aluno(a) <strong>&lt;a id=NOMEALUNO&gt;&lt;/a&gt;</strong> matriculado com o  n&uacute;mero de matr&iacute;cula n. <strong>&lt;a id=MATRICULA&gt;&lt;/a&gt;</strong> , filho(a) de <strong>&lt;a  id=PAI&gt;&lt;/a&gt;</strong>&nbsp; e <strong>&lt;a  id=MAE&gt;&lt;/a&gt;</strong>, &eacute; aluno (a) regularmente matriculado (a) nesta Unidade de  Ensino, e est&aacute; freq&uuml;entando o <strong>&lt;a id=PERIODOATUAL&gt;&lt;/a&gt;</strong> do <strong>&lt;a  id=CURSOATUAL&gt;&lt;/a&gt;</strong> no turno <strong>&lt;a id=TURNOATUAL&gt;&lt;/a&gt;</strong>&nbsp;&nbsp; no ano letivo de <strong>&lt;a  id=ANOLETIVO&gt;&lt;/a&gt;</strong>.<br>
                &nbsp;</p>
              <hr size="1" color="#999999">
              <div align="center" class="texto1">
                <table border="0" cellspacing="0" cellpadding="0" width="708">
                  <tr>
                    <td width="708" valign="top"><p><em><strong>12)FAIXAS DE HOR&Aacute;RIOS </strong></em></p>
                      <p><strong><em>Menu - ACAD&Ecirc;MICO&nbsp; &gt;&nbsp; Cadastro Inicial&nbsp; &gt;&nbsp; <u>Faixas de Hor&aacute;rios</u></em></strong></p></td>
                  </tr>
                </table>
              </div>
              <p class="texto1"><strong>Ano&nbsp; e Semestre Letivo</strong>: Ser&aacute; informado&nbsp; Ano e Semestre em exerc&iacute;cio das atividades  escolares.<br>
                <strong>Hor&aacute;rio</strong>: Ser&aacute; informada a faixa de hor&aacute;rio praticada  na unidade escolar ex: - 07h00min as 7h50min.<br>
                <strong>Sequ&ecirc;ncia</strong>: 1&ordf; Aula, 2&ordf; Aula, 3&ordf; Aula, 4&ordf; Aula, 5&ordf; Aula e  6&ordf; Aula. <br>
                <strong>Total Aulas</strong>: Quantidade  de aulas ministradas na faixa de hor&aacute;rio informada.<br>
                <strong>Total Minutos</strong>: Total de minutos no intervalo da faixa de  hor&aacute;rio informada.              </p>
              <hr size="1" color="#999999">
              <div align="center" class="texto1">
                <table border="0" cellspacing="0" cellpadding="0" width="708">
                  <tr>
                    <td width="708" height="58" valign="top"><p><strong><em>13)CADASTRO DE DOCUMENTA&Ccedil;&Otilde;ES</em></strong></p>
                      <p><strong><em>Menu - ACAD&Ecirc;MICO&nbsp; &gt;&nbsp; Cadastro Inicial&nbsp; &gt;&nbsp; <u>Cadastro de Documenta&ccedil;&otilde;es</u></em></strong>
                      </td>
                  </tr>
                </table>
              </div>
              <p class="texto1"><strong>Descri&ccedil;&atilde;o</strong>:&nbsp; Descri&ccedil;&atilde;o do documento que dever&aacute; compor a  rela&ccedil;&atilde;o exigida durante a matr&iacute;cula do aluno na unidade escolar.<br>
                <strong>Exemplos de documentos</strong>:  COMPROVANTE DE ENDERE&Ccedil;O, 01 FOTO 3X4, HIST&Oacute;RICO ESCOLAR, CERTID&Atilde;O DE NASCIMENTO.</p>
              <hr size="1" color="#999999">
              <div align="center" class="texto1">
                <table border="0" cellspacing="0" cellpadding="0" width="708">
                  <tr>
                    <td width="708" valign="top"><p><em><strong>14)TABELA DE FERIADOS </strong></em></p>
                      <p><strong><em>Menu - ACAD&Ecirc;MICO&nbsp; &gt;&nbsp; Cadastro Inicial&nbsp; &gt;&nbsp; <u>Tabela de Feriados</u></em></strong></p></td>
                  </tr>
                </table>
              </div>
              <p class="texto1"><strong>Ano&nbsp; e Semestre Letivo</strong>: Ser&aacute; informado o  Ano e Semestre em exerc&iacute;cio das atividades  escolares.<br>
                <strong>Data</strong>:&nbsp; Data do Feriado. <br>
                <strong>Descri&ccedil;&atilde;o</strong>:&nbsp; Descri&ccedil;&atilde;o do feriado a ser cadastrado.</p>
              <hr size="1" color="#999999">
              <div align="center" class="texto1">
                <table border="0" cellspacing="0" cellpadding="0" width="708">
                  <tr>
                    <td width="708" valign="top"><p><em><strong>15)TABELA BIMESTRAL </strong></em></p>
                      <p><strong><em>Menu - ACAD&Ecirc;MICO&nbsp; &gt;&nbsp; Cadastro Inicial&nbsp; &gt;&nbsp; <u>Tabela Bimestral</u></em></strong></p></td>
                  </tr>
                </table>
              </div>
              <p class="texto1"><strong>Ano&nbsp; e Semestre Letivo</strong>: Ser&aacute; informado o Ano e Semestre em exerc&iacute;cio das atividades  escolares.<br>
                <strong>Descri&ccedil;&atilde;o</strong>: Descri&ccedil;&atilde;o da  sequ&ecirc;ncia Bimestral.<br>
                <strong>Per&iacute;odo</strong>:&nbsp; Per&iacute;odo de in&iacute;cio e t&eacute;rmino do bimestre ex:  XX/XX/XXXX a XX/XX/XXXX.              </p>
              <hr size="1" color="#999999">
              <div align="center" class="texto1">
                <table border="0" cellspacing="0" cellpadding="0" width="708">
                  <tr>
                    <td width="708" valign="top"><p><strong><em>16)ENCERRAMENTO DAS ATIVIDADES</em></strong></p>
                      <p><span class="style1">Menu - ACAD&Ecirc;MICO&nbsp; &gt;&nbsp; Cadastro Inicial&nbsp; &gt;&nbsp; <u>Encerrameto das Atividades</u></span></p></td>
                  </tr>
                </table>
              </div>
              <p class="texto1"><strong>Ano&nbsp; e Semestre Letivo</strong>: Ser&aacute; informado&nbsp; Ano e Semestre em exerc&iacute;cio das atividades.<br>
                <strong>Data de  Encerramento</strong>:&nbsp; Data do t&eacute;rmino das  atividades escolares&nbsp; do ano e semestre  informado. acima <br>
                <strong>Bloquear Lancto Notas  Docentes?</strong>&nbsp;&nbsp; Selecione... SIM NAO &ndash;  Habilita ou Desabilita o lan&ccedil;amento de notas pelo professor.<br>
                <strong>Bloquear Lancto Notas  Secretaria?</strong>&nbsp;&nbsp; Selecione... SIM NAO  &ndash;  Habilita ou Desabilita o lan&ccedil;amento de notas pela Secretaria.<br>
                <strong>Bloquear Campo Acumulada  de Faltas?</strong>&nbsp;&nbsp; Selecione... SIM NAO  &ndash;  Habilita ou Desabilita o campo FALTA para lan&ccedil;amento.<br>
                <strong>Bloquear Conte&uacute;do  Program&aacute;tico at&eacute; o m&ecirc;s:</strong>&nbsp;&nbsp; Selecione...  JANEIRO, FEVEREIRO, MAR&Ccedil;O, ABRIL, MAIO, JUNHO, JULHO, AGOSTO, SETEMBRO,  OUTUBRO, NOVEMBRO e DEZEMBRO. <br>
                <strong>Controlar Documenta&ccedil;&atilde;o  de Colaboradores pelo Grau de Instru&ccedil;&atilde;o?</strong>&nbsp;&nbsp;  Selecione... SIM N&Atilde;O&nbsp; - Nesta  op&ccedil;&atilde;o voc&ecirc; pode criar tabela de documenta&ccedil;&atilde;o para o colaborador conforme o grau  de instru&ccedil;&atilde;o, com isso voc&ecirc; ter&aacute; v&aacute;rias tabelas de documentos caso sua op&ccedil;&atilde;o  escolhida seja o SIM. Se for marcado o N&Atilde;O ser&aacute; gerenciada pelo Sistema uma  &uacute;nica tabela.</p>
              <hr size="1" color="#999999">
              <div align="center" class="texto1">
                <table border="0" cellspacing="0" cellpadding="0" width="708">
                  <tr>
                    <td width="708" valign="top"><p><em><strong>17)PROJETOS SOCIAIS</strong></em></p>
                      <p><strong><em>Menu - ACAD&Ecirc;MICO&nbsp; &gt;&nbsp; Cadastro Inicial&nbsp; &gt;&nbsp; <u>Projetos Sociais</u></em></strong></p></td>
                  </tr>
                </table>
              </div>
              <p class="texto1"><strong>Descri&ccedil;&atilde;o do  Projeto</strong>: Nome do projeto a ser  cadastrado.<br>
                <strong>Exemplo de Projeto</strong>: Bolsa  Fam&iacute;lia etc... </p>
              <hr size="1" color="#999999">
              <div align="center" class="texto1">
                <table border="0" cellspacing="0" cellpadding="0" width="708">
                  <tr>
                    <td width="708" valign="top"><p><u><em><strong>18)GRAU DE INSTRU&Ccedil;&Atilde;O </strong></em></u></p>
                      <p><strong><em>Menu - ACAD&Ecirc;MICO&nbsp; &gt;&nbsp; Cadastro Inicial&nbsp; &gt;&nbsp; <u>Grau de Instru&ccedil;&atilde;o</u></em></strong></p></td>
                  </tr>
                </table>
              </div>
              <p class="texto1"><strong>Descri&ccedil;&atilde;o</strong>: Descri&ccedil;&atilde;o  do n&iacute;vel de instru&ccedil;&atilde;o a ser cadastrado. <br>
                <strong>Exemplo de &nbsp;Grau de instru&ccedil;&atilde;o</strong>: N&atilde;o Alfabetizado, Especializa&ccedil;&atilde;o Incompleta, Primeiro Grau, Incompleto, Primeiro Grau Completo, 2&ordm;. Grau Incompleto, 2&ordm;. Grau Completo, Superior Incompleto, Superior Completo, Especializa&ccedil;&atilde;o Completa, Doutorado Incompleto, Doutorado Completo, Mestrado Completo, Mestrado Incompleto e N&atilde;o informado. </p>
              <hr size="1" color="#999999">              <p class="texto1">
                <input type="button" name="cmdPrincipal2" style="cursor:hand"   value="Voltar"  class="botao" onClick="window.location='Configurando.asp'">
              </p></td>
          </tr>
          <tr>
            <td>&nbsp;</td>
          </tr>
          <tr>
            <td>&nbsp;</td>
          </tr>
        </table>
		</form>
		</td>
      </tr>
    </table>
	</td>
  </tr>
</table>
<!--#include file="../rodape.asp"-->
</body>
</html>