<!--
	::	DESENVOLVIDO POR "RS SOLUÇÕES WEB - www.rssolucoesweb.com.br"
	::	Data de Criação...: 05/08/2008
	::	Desenvolvedores...: Roberto Barbosa Silva - robertobs7@gmail.com
	::	Objetivo Pagina...: Selecionar os dados do aluno
-->
<!--#include file="../../includes/inc_cnn.asp"-->
<%
if intCodTurma <> "" then
   sql = "SELECT DISTINCT SRH_COLABORADOR.NOME AS COLABORADOR"
   sql = sql & " FROM SCA_HORARIO_AULA"
   sql = sql & " INNER JOIN SRH_COLABORADOR ON SRH_COLABORADOR.CODIGO = SCA_HORARIO_AULA.COD_COLABORADOR"
   sql = sql & " WHERE	SCA_HORARIO_AULA.ANOLETIVO = " & intAnoLetivoAtual
   sql = sql & " AND		SCA_HORARIO_AULA.SEMESTRE = " & intSemestreAtual
   sql = sql & " AND		SCA_HORARIO_AULA.COD_TURMA = " & intCodTurma
   sql = sql & " AND		SCA_HORARIO_AULA.COD_DISCIPLINA = " & intCodDisciplina
   rsaux.open sql, cnn
   if not rsaux.eof then 
	  strProfessorAssinatura = rsaux("COLABORADOR")
   else
	  strProfessorAssinatura = "PROFESSOR(A) NÃO INFORMADO NO HORÁRIO DE AULA"
   end if
   rsaux.close
end if
%>

<table width="85%" border="0" cellspacing="0" cellpadding="0">
  <tr>
	<td colspan="3" align="left"><strong><%=session("CidadeEmpresaWeb")%>, <%=day(date)%> DE <%=UCASE(monthname(month(date)))%> DE <%=year(date)%>.</strong></td>
    <td align="left">&nbsp;</td>
  </tr>
  
  <tr>
    <td align="center"></td>
    <td align="center"></td>
    <td align="center">&nbsp;</td>
    <td align="center">&nbsp;</td>
  </tr>
  <tr>
    <td align="center"></td>
    <td align="center"></td>
    <td align="center">&nbsp;</td>
    <td align="center">&nbsp;</td>
  </tr>
  <tr>
    
    <td width="9%" align="center"></td>
    <td width="25%" align="center"></td>
	<td width="33%" align="center">________________________________________&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</td>
	<td width="33%" align="center">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;________________________________________</td>
  </tr>
  <tr>
    <td align="center">&nbsp;</td>
    <td align="center">&nbsp;</td>
    <td align="center"><strong><%=session("NomeSecretariaEmpresaWeb")%></strong></td>
	<td align="center"><strong><%=strProfessorAssinatura%></strong></td>
  </tr>
  <tr>
    <td align="center">&nbsp;</td>
    <td align="center"><br /></td>
    <td align="center">Secretaria Geral<br />
    ____/____/________</td>
	<td align="center">Professor<br />
    ____/____/________</td>
  </tr>
</table>

