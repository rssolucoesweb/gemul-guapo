<!--
	::	DESENVOLVIDO POR "RS SOLUÇÕES WEB - www.rssolucoesweb.com.br"
	::	Data de Criação...: 02/03/2009
	::	Desenvolvedores...: Sergio Borges - sergiob76@hotmail.com
	::	Objetivo Pagina...: Bimestre
-->
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<title><%=session("Titulo")%></title>
<link href="../../estilo/css.css" rel="stylesheet" type="text/css">
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
              <td width="700" align="center" class="tituloSistema"><strong><em>7 Passos para implantação da modulação nas unidades escolares</em></strong></td>
            </tr>
          </table>
		  <br>
		  <table width="98%" border="0" cellspacing="0" cellpadding="0">
          <tr>
            <td><input type="button" name="cmdPrincipal" style="cursor:hand"   value="Voltar"  class="botao" onclick="window.location='Configurando.asp'" /></td>
          </tr>
          <tr>
            <td>&nbsp;</td>
          </tr>
          <tr>
            <td><strong>1) Cadastrar   todos os Colaboradores </strong></td>
          </tr>
          
          <tr>
            <td class="texto1">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;Módulo Recursos Humanos &gt; Cadastro &gt; <u><a href="../SRH/Colaborador_cad.asp">Colaborador</a></u></td>
          </tr>
          <tr>
            <td>&nbsp;</td>
          </tr>
          <tr>
            <td ><strong>2) Cadastrar   turmas para ano letivo</strong></td>
          </tr>
          
          <tr>
            <td class="texto1">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;Módulo Acadêmico &gt; Cadastro Curricular   &gt; <u><a href="Turma_cad.asp">Turmas –  Cadastro Avulso</a></u></td>
          </tr>
          <tr>
            <td>&nbsp;</td>
          </tr>
          <tr>
            <td><strong>3) Cadastrar as Faixas de Horário para o ano  letivo</strong></td>
          </tr>
          
          <tr>
            <td class="texto1">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;Módulo Acadêmico &gt; Cadastro Inicial  &gt; <u><a href="Horario_cad.asp">Faixas de Horários</a></u></td>
          </tr>
          <tr>
            <td>&nbsp;</td>
          </tr>
          <tr>
            <td><strong>4) Cadastrar Horário de aula ano letivo</strong></td>
          </tr>
          
          <tr>
            <td class="texto1">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;Módulo Acadêmico &gt; Manutenção &gt; <u><a href="HorarioAula_cad.asp">Horário  de aula -  lançamento</a></u></td>
          </tr>
          <tr>
            <td>&nbsp;</td>
          </tr>
          <tr>
            <td><strong>5) Manutenção  do Elenco Escolar:</strong></td>
          </tr>
          <tr>
            <td>&nbsp;</td>
          </tr>
          <tr>
            <td> Alocação  de Turmas</td>
          </tr>
          
          <tr>
            <td class="texto1">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;Módulo Acadêmico &gt; Cadastro de Alunos &gt; <u><a href="Aluno_cad.asp">Dados Pessoais</a></u></td>
          </tr>
          <tr>
            <td>&nbsp;</td>
          </tr>
          <tr>
            <td>Ativando,  Cancelando  e Transferindo alunos na  Turma</td>
          </tr>
          
          <tr>
            <td class="texto1">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;Módulo Acadêmico &gt; Cadastro de Alunos &gt; <u><a href="ControleSituacaoAluno_cad.asp">Controle  de Situação – Turma</a></u></td>
          </tr>
          <tr>
            <td>&nbsp;</td>
          </tr>
          <tr>
            <td>Controle  de Documentos exigido durante a matrícula do aluno</td>
          </tr>
          
          <tr>
            <td class="texto1">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;Módulo Acadêmico &gt; Cadastro de Alunos &gt; <u><a href="Documentacoes_cad.asp">Documentações Pessoais – Aluno </a></u></td>
          </tr>
          <tr>
            <td>&nbsp;</td>
          </tr>
          <tr>
            <td>Diário  de Classe e Folha de Conteúdo</td>
          </tr>
          
          <tr>
            <td class="texto1">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;Módulo Acadêmico &gt; Relatórios &gt; <u><a href="Rel_DiarioFrequencia_con.asp">Diário de Frequência</a></u></td>
          </tr>
          <tr>
            <td>&nbsp;</td>
          </tr>
          <tr>
            <td>Controle  de notas e faltas - Ficha Acumulativa de notas e faltas (utilizada pelo  professor)</td>
          </tr>
          
          <tr>
            <td class="texto1">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;Módulo Acadêmico &gt; Relatórios &gt; <u><a href="Rel_FichaAcumulativaNotas_con.asp">Ficha acumulativa de notas e faltas </a></u></td>
          </tr>
          <tr>
            <td>&nbsp;</td>
          </tr>
          <tr>
            <td>Emissão  de Documentos – Declarações/Atestados</td>
          </tr>
          
          <tr>
            <td class="texto1">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;Módulo Acadêmico &gt; Cadastro Incial &gt; <u><a href="Documento_cad.asp">Emissão de Documentos</a></u>   Cria o documento<u> </u></td>
          </tr>
          <tr>
            <td>&nbsp;</td>
          </tr>
          <tr>
            <td class="texto1">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;Módulo Acadêmico &gt; Relatórios &gt; <u><a href="Rel_Documentos_con.asp">Emissão de Documentos</a></u>   Imprime o documento<u></u></td>
          </tr>
          <tr>
            <td>&nbsp;</td>
          </tr>
          <tr>
            <td><strong>6) Lançamento  de Notas e Faltas:</strong></td>
          </tr>
          <tr>
            <td>&nbsp;</td>
          </tr>
          <tr>
            <td class="texto1">Lançamento  de Notas e Faltas ( Secretária )</td>
          </tr>
          
          <tr>
            <td class="texto1">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;Módulo Acadêmico &gt; Manutenção &gt;<a href="Notas_con.asp"> <u>Lançamento  de Notas e Faltas</u></a></td>
          </tr>
          <tr>
            <td>&nbsp;</td>
          </tr>
          <tr>
            <td><u>Lançamento</u> de Notas e Faltas ( Professor )</td>
          </tr>
          
          <tr>
            <td class="texto1">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;Módulo Acadêmico &gt; Manutenção &gt; <u><a href="NotasProf_con.asp">Lançamento de Notas - Professor</a></u></td>
          </tr>
          <tr>
            <td>&nbsp;</td>
          </tr>
          <tr>
            <td>Lançamento  Mensal de Faltas – Atualização pelo Horário de Aula</td>
          </tr>
          
          <tr>
            <td class="texto1">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;Módulo Acadêmico &gt; Manutenção &gt; <u><a href="FaltasHorario_con.asp">Lançamento Mensal de Faltas</a></u></td>
          </tr>
          <tr>
            <td>&nbsp;</td>
          </tr>
          <tr>
            <td><strong>7) Fechamento  Curricular para início de um novo ano letivo:</strong></td>
          </tr>
          <tr>
            <td>&nbsp;</td>
          </tr>
          <tr>
            <td>Impressão  da Ata de Resultado Final para arquivamento</td>
          </tr>
          
          <tr>
            <td class="texto1">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;Módulo Acadêmico &gt; Relatório &gt; <u><a href="Rel_NotasFaltas_con.asp">Acumulada  de Notas e Faltas</a></u></td>
          </tr>
          <tr>
            <td>&nbsp;</td>
          </tr>
          <tr>
            <td>Fechamento  do Ano Letivo -  Processo de fechamento do ano letivo só deverá ser  realizado quando a Secretaria estiver com todas as notas e faltas lançadas, esse  processo transfere as notas e faltas com seus respectivos resultados para o  histórico escolar. Rodando essa aplicação de forma desnecessária você terá todo  o lançamento de notas e faltas excluído sem a possibilidade de recuperação.</td>
          </tr>
          
          <tr>
            <td class="texto1">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;Módulo Acadêmico &gt; Manutenção &gt; <u><a href="ATUALIZAHISTORICO_CAD.ASP">Fechamento  Curricular – Atualização </a></u></td>
          </tr>
          
          <tr>
            <td class="texto1"></td>
          </tr>
          <tr>
            <td height="18" class="texto">&nbsp;</td>
          </tr>
          <tr>
            <td>Após o Fechamento do ANO LETIVO acesse o encerramento de Atividades, mude somente o Ano/Semestre, com isso o novo ano letivo   será iniciado</td>
          </tr>
          <tr>
            <td><span class="texto1">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;Módulo Acadêmico &gt; Cadastro Inicial &gt; <u><a href="EncerrametoAtividades_cad.asp">Encerramentos das Atividades</a></u></span></td>
          </tr>
          <tr>
            <td>&nbsp;</td>
          </tr>
          <tr>
            <td><div align="center"><strong><u>Atenção! Essa ordem  possibilita que o auxiliar de secretaria  implemente todas as etapas necessárias  para informatização de sua unidade escolar.</u></strong></div></td>
          </tr>
          <tr>
            <td>&nbsp;</td>
          </tr>
          <tr>
            <td width="703"><hr size="1" color="#999999">              <p class="texto1">
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