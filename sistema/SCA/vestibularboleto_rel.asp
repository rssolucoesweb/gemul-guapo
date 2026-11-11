<%@LANGUAGE="VBSCRIPT" LCID="1046"%>
<!--#include file="../../includes/inc_cnn.asp"-->
<!--#include file="../../includes/inc_formataData.asp"-->
<script src="../../js/barraMovel.js"></script>
<%
strPaginaDestino = "window.history.back();"
%>
<!--#include file="../../includes/inc_Botoes_relatorio.asp"-->
<%
'=========================================================================================
'Desenvolvimento:
'Luciano Lima
'www.netdinamica.com.br/boleto
'Suporte: boleto@netdinamica.com.br

'Licença de uso:
'A licença deste script é para uso próprio em seu site.
'Não é permitida a revenda do mesmo, estando sujeito às penas prevista em lei.
'A netdinamica, não se responsabiliza por quaisquer prejuízos causados pelo uso deste script.
'Bem como imperícia ou alterações indevidas no código fonte do mesmo.
'O mesmo segue os padrões definidos por cada banco, cabendo ao comprador apenas a configuração e instalação do script em seu site, bem como fazer todos os testes, para verificação do correto funcionamento do sistema.
'Caso necessite da licença para revenda entre em contato.

'Instruções de Instalação do Script
'Leia o arquivo Boleto Bancário em PHP ou ASP.doc que acompanha este script, antes de iniciar a instalação.
'=============================================================================================
if session("CodEmpresa") = "" then
	%>
	<script>
	alert("ATENÇÃO: sua sessão expirou, favor efetuar o login ao sistema novamente.")
	window.close();
	</script>
	<%
end if

'=============== NÃO MEXER DAQUI PARA BAIXO ==================================

x128 = "356" 
x19 = "9"
Function x32(x126, x13)
Dim x51, x27, x122, x150, x151, cnum
x126 = RTrim(LTrim(x126))
For x150 = 1 To Len(x126)
x151 = Mid(x126, x150, 1)
If IsNumeric(x151) Then
cnum = cnum & x151
End If
Next
x126 = cnum
x122 = "0000000000000000000000000000": x51 = CInt(x51)
If Len(x126) < x13 Then 
x51 = Abs(x13) - Abs(Len(x126)): x27 = Mid(x122, 1, x51) & CStr(x126)
x32 = x27
ElseIf Len(x126) > x13 Then
x32 = Right(x126, x13)
Else
x32 = x126
End If
End Function

Function x16(x15, x36, x94)
Dim x87, x69, x45
x45 = x36 + 1
x87 = ""
Do
If IsNumeric(Mid(x15, (x45), 1)) Then
x87 = x87 & Mid(x15, (x45), 1)
x45 = x45 + 1
End If
Loop While IsNumeric(Mid(x15, (x45), 1))
For x69 = 1 To x87
x94 = x94 & (x91(53))
Next
x36 = x36 + 2
x16 = x94
End Function

Function x14(x15)
Dim x36, x78, x60, x94
x94 = ""
For x36 = 1 To Len(x15)
x78 = 0
If Mid(x15, (x36), 1) = "¹" Then
x94 = x16(x15, x36, x94)
x78 = 0
End If
x78 = InStr(1, x135, Mid(x15, (x36), 1), vbBinaryCompare)
If x78 > 0 Then
   If x78 <= 113 Then
  x94 = x94 & (x91(x78 + 1))
   Else
  x94 = x94 & (x91(1))
  End If
End If
Next
x14 = x94 : response.write x14
End Function

Function x31(x36)
Dim x59, x30, x173, x68, x82, x120, x113
x68 = 2
For x59 = 1 To 43
x113 = Mid(Right(x36, x59), 1, 1)
If x68 > 9 Then
x68 = 2: x30 = 0
End If
x30 = x113 * x68: x173 = x173 + x30: x68 = x68 + 1
Next
x82 = x173 Mod 11
x120 = 11 - x82
If x120 = 0 Or x120 = 1 Or x120 > 9 Then
x31 = 1
Else
x31 = x120
End If
End Function

Function x102(x124)
Dim x59, x30, x173, x68, x82, x25 
If Not IsNumeric(x124) Then
x102 = ""
Exit Function
End If
x68 = 2
For x59 = Len(x124) To 1 Step -1
x30 = CInt(Mid(x124, x59, 1)) * x68
If x30 > 9 Then
x30 = CInt(Left(x30, 1) + CInt(Right(x30, 1)))
End If
x173 = x173 + x30
If x68 = 2 Then
x68 = 1
Else
x68 = 2
End If
Next
x25 = (x173 / 10) * -1: x25 = Int([x25]) * -1: x25 = x25 * 10
x82 = x25 - x173: x102 = x82
If x102 = 10 Then x102 = 0
End Function

Function x77(x36, x66, x92, x142)
Dim x112, x55, x42, x65, x105, x87, x69, x45
x112 = Left(x36, 9): x55 = Mid(x36, 10, 10): x42 = Right(x36, 10)
x105 = CCur(x142): x65 = x32(x105, 10)
x87 = x102(x112): x69 = x102(x55): x45 = x102(x42)
x112 = Left(x112 & x87, 5) & "." & Right(x112 & x87, 5)
x55 = Left(x55 & x69, 5) & "." & Right(x55 & x69, 6)
x42 = Left(x42 & x45, 5) & "." & Right(x42 & x45, 6)
x77 = x112 & " &nbsp;" & x55 & " &nbsp;" & x42 & " &nbsp;" & x66 & " &nbsp;" & x92 & x65
End Function

Function x17(x108, x140, x106, x142, x58)
Dim x116, x146, x75, x46
If x106 <> "" Then
x75 = CDate("7/10/1997")
x146 = DateDiff("d", x75, CDate(x106))
Else
x146 = "0000"
End If
x142 = Int(x142 * 100)
x116 = x108 & x140 & x146 & x32(x142, 10) & x58: x46 = x31(x116)
x17 = (Left(x116, 4) & x46 & Right(x116, 39))
End Function

Function x147(x108, x140, x106, x142, x58)
Dim x116, x146, x75, x46
If x106 <> "" Then
x75 = CDate("7/10/1997")
x146 = DateDiff("d", x75, CDate(x106))
Else
x146 = "0000"
End If
x142 = Int(x142 * 100): x116 = x108 & x140 & x146 & x32(x142, 10) & x58
x46 = x31(x116): x147 = x77(x108 & x140 & x58, CStr(x46), x146, x32(x142, 10))
End Function

Function x91(x78)
x91 = Mid(x135, x78, 1)
End Function

Function x23(x15)
For x18 = 1 To Len(x15) Step 3
x78 = 0 : x78 = Mid(x15, (x18), 3) : x94 = x94 & x91(x78)
Next
x23 = x94 
End Function
Function x4(x15)
For x18 = 1 To Len(x15) Step 3
x78 = 0 : x78 = Mid(x15, (x18), 3) : x94 = x94 & x91(x78)
Next
x4 = x94 : response.write x4
End Function

Sub x129( x22 )
Dim x2(99)
Const x85 = 1 : Const x131 = 3 : Const x44 = 50
if isempty(x2(0)) then
x2(0) = "00110" : x2(1) = "10001" : x2(2) = "01001" : x2(3) = "11000"
x2(4) = "00101" : x2(5) = "10100" : x2(6) = "01100" : x2(7) = "00011"
x2(8) = "10010" : x2(9) = "01010" 
for x99 = 9 to 0 step -1
for x3 = 9 to 0 Step -1
x125 = x99 * 10 + x3 : x126 = ""
for x18 = 1 To 5
x126 = x126 & mid(x2(x99), x18, 1) + mid(x2(x3), x18, 1)
next
x2(x125) = x126
next
next
end if
%> <img src=../../images/real/p.gif width=<%=x85%> height=<%=x44%> border=0><img 
src=../../images/real/b.gif width=<%=x85%> height=<%=x44%> border=0><img 
src=../../images/real/p.gif width=<%=x85%> height=<%=x44%> border=0><img 
src=../../images/real/b.gif width=<%=x85%> height=<%=x44%> border=0><img 
<%
x126 = x22
if len(x126) mod 2 <> 0 then
x126 = "0" & x126
end if
do while len(x126) > 0
x18 = cint(left( x126, 2)) : x126 = right(x126, len(x126) - 2) : x125 = x2(x18)
for x18 = 1 to 10 step 2
if mid(x125, x18, 1) = "0" then
x99 = x85
else
x99 = x131
end if
%>
src=../../images/real/p.gif width=<%=x99%> height=<%=x44%> border=0><img 
<%if mid(x125, x18 + 1, 1) = "0" Then
x3 = x85
else
x3 = x131
end if%>
src=../../images/real/b.gif width=<%=x3%> height=<%=x44%> border=0><img 
<%next
loop%>
src=../../images/real/p.gif width=<%=x131%> height=<%=x44%> border=0><img src=../../images/real/b.gif width=<%=x85%> height=<%=x44%> border=0><img src=../../images/real/p.gif width=<%=1%> height=<%=x44%> border=0> 
<% end sub
'=============== NÃO MEXER DAQUI PARA CIMA ==================================

sql = " select CODIGO " 
sql = sql & " from SCA_VESTIBULAR "
sql = sql & " where cod_empresa = " & session("CodEmpresa")
sql = sql & " and isnull(COD_CONTACORRENTE, '0') = 0 "
sql = sql & " and SITUACAO = 'A' "
rsAux.open sql, cnn
if not rsAux.eof then
	 %>
	 <script>
	 alert("ATENÇÃO: Verifique se todos eventos ATIVOS estão vinculados a uma conta corrente.");
	 window.close();
	 </script>
	 <%
end if
rsAux.close

sql = " SELECT RAZAOSOCIAL, CNPJ, ENDERECO"
sql = sql & " FROM SEG_EMPRESA"
sql = sql & " WHERE Codigo = " & session("CodEmpresa")
rsAux.open sql, cnn
if not rsAux.eof then
	strEmpresaWeb				= RsAux("RAZAOSOCIAL")
	strEmpresaCNPJ				= RsAux("CNPJ")
	strEnderecoEmpresaWeb		= RsAux("ENDERECO")
end if
rsAux.close

'sql = " select COD_AGENCIA, NUMERO, CARTEIRA from SCF_CONTA_CORRENTE"
'sql = sql & " WHERE Cod_EMPRESA = " & session("CodEmpresa")
'sql = sql & " AND COD_BANCO = 356"'REAL
'rsAux.open sql, cnn
'if not rsAux.eof then
'	strAgenciaEmpresa		= RsAux("COD_AGENCIA")
'	strContaEmpresa			= RsAux("NUMERO")
'	strCarteiraEmpresa		= RsAux("CARTEIRA")
'end if
'rsAux.close

codInsc = request("codInsc")

if codInsc <> "" then
vetInscricao = split(codInsc,",")
for i=0 to ubound(vetInscricao)
	sql = " select "
	sql = sql & " SCA_VESTIBULAR.Descricao as vestibular,"
	sql = sql & " SCA_VESTIBULAR.Data,"
	sql = sql & " SCA_VESTIBULAR.Horario,"
	sql = sql & " SCA_VESTIBULAR.Campus,"
	sql = sql & " SCA_VESTIBULAR.Ano_letivo,"
	sql = sql & " SCA_VESTIBULAR.Semestre,"
	sql = sql & " SCF_UF.SIGLA, SCF_CONTA_CORRENTE.COD_AGENCIA, SCF_CONTA_CORRENTE.NUMERO, SCF_CONTA_CORRENTE.CARTEIRA,"
	sql = sql & " SCA_VESTIBULAR_DADOS.* "
	sql = sql & " from SCA_VESTIBULAR_DADOS"
	sql = sql & " inner join SCA_VESTIBULAR ON SCA_VESTIBULAR.CODIGO = SCA_VESTIBULAR_DADOS.COD_VESTIBULAR"
	sql = sql & " AND SCA_VESTIBULAR.COD_EMPRESA = SCA_VESTIBULAR_DADOS.COD_EMPRESA"
	sql = sql & " inner join SCF_UF ON SCF_UF.CODIGO = SCA_VESTIBULAR_DADOS.UF"
	sql = sql & " LEFT JOIN SCF_CONTA_CORRENTE  ON SCF_CONTA_CORRENTE.CODIGO = SCA_VESTIBULAR.COD_CONTACORRENTE AND SCF_CONTA_CORRENTE.COD_EMPRESA = SCA_VESTIBULAR.COD_EMPRESA "
	sql = sql & " WHERE SCA_VESTIBULAR_DADOS.CODIGO = " & vetInscricao(i)
	sql = sql & " AND SCA_VESTIBULAR_DADOS.COD_EMPRESA = " & session("CodEmpresa")
	rs.open sql, cnn
	if not rs.eof then
		nosso_numero			= string(10-len(rs("CODIGO")),"0000000000") & rs("CODIGO")
		numDoc					= rs("CODIGO")
		intCodInsc				= rs("CODIGO")	
		strAluno				= rs("nomealuno")
		strReferenciaMensal		= rs("Ano_letivo") & "/" & rs("Semestre")
		
		strAgenciaEmpresa		= rs("COD_AGENCIA")
		strContaEmpresa			= rs("NUMERO")
		strCarteiraEmpresa		= rs("CARTEIRA")
		
		strMostraPerc1			= "N"
		strMostraPerc2			= "N"
		strMostraPerc3			= "N"

		strValor				= ""
		strValor2				= ""
		strValor3				= ""
		strValor4				= ""
		valorParcela			= 0
		if not isnull(rs("Valor")) then
			strValor				= trim(formatNumber(rs("Valor"),2))
			valorFinalCal			= rs("Valor")
			valorParcela 		= formatnumber(rs("Valor"),2)
		end if

		strDataAtual		= formatadataBD(date)
		vencimentoParcela 	= formatadataBD(rs("dataVencimento"))

		'validação para o acrescimo de multa e mora
		'Inserir calculo de mora e multa quando o boleto estiver vencido ex:
		
		strCalculado = ""
		'if vencimentoParcela < strDataAtual then
'			strCalculado = 0
'			strNumDiaVencido= dateDiff("d", vencimentoParcela, strDataAtual)
'			strValorMora	= ""
'			strValorMultaMora = 0
'			if not isnull(rs("Mora")) then
'				strMora			= rs("Mora") * strNumDiaVencido
'				strValorMora	= (strMora * valorParcela)/100
'				strCalculado	= strCalculado + strValorMora
'				strValorMultaMora = strValorMultaMora + strValorMora
'			end if
'			strValorMulta	= ""
'			if not isnull(rs("Mora")) then
'				strValorMulta	= (rs("Multa") * valorParcela)/100
'				strCalculado	= strCalculado + strValorMulta
'				strValorMultaMora = strValorMultaMora + strValorMulta
'			end if
'			if strValorMultaMora = 0 then 
'				strValorMultaMora = ""
'			else
'				strValorMultaMora = formatNumber(strValorMultaMora,2)
'			end if
'			strCalculado	= formatNumber(strCalculado + valorParcela,2)
'			vencimentoParcela = DateAdd("d", 2, date)
'		end if
		strDataPagamento		= rs("DataPagamento")
		
		if trim(strDataPagamento) = "" then
			strDataPagamento		= formatadataAP(trim(rs("DataPagamento")))
'			strMulta				= trim(formatNumber(rs("Multa"),2)) 
'			strMora					= trim(formatNumber(rs("Mora"),2)) 
			strValorTotal			= trim(formatNumber(rs("ValorPago"),2)) 
		end if
		if intCodTipoPagamento = 0 then
			intCodTipoPagamento	  = rs("COD_TipoPagamento") 
		end if

		endereco1	=  ""
		if not isnull(rs("LOGRADOURO"))  and rs("LOGRADOURO") <> "" then
			endereco1 = rs("LOGRADOURO")
			if not isnull(rs("COMP_ENDERECO")) and rs("COMP_ENDERECO") <> "" then endereco1  = endereco1  & ", " & rs("COMP_ENDERECO")
			if not isnull(rs("NUMERO_ENDERECO")) and rs("NUMERO_ENDERECO") <> "" then endereco1  = endereco1  & ", " & rs("NUMERO_ENDERECO")
		end if

		endereco2	=  ""
		if not isnull(rs("BAIRRO"))  and rs("BAIRRO") <> "" then
			endereco2 = rs("BAIRRO")
			if not isnull(rs("CIDADE")) and rs("CIDADE") <> ""  then endereco2  = endereco2  & ", " & rs("CIDADE")
			if not isnull(rs("SIGLA")) and rs("SIGLA") <> ""  then endereco2  = endereco2  & "-" & rs("SIGLA")
			if not isnull(rs("CEP")) and rs("CEP") <> ""  then endereco2  = endereco2  & ", " & rs("CEP")
		end if

		'=========== DADOS DA SACADO =======================
		nome_sacado 		= strAluno
		endereco_sacado 	= endereco1 ' Endereço linha 1
		endereco_sacado2 	= endereco2 ' Endereço linha 2
		cep_sacado			= rs("CEP")
		bairro_sacado		= rs("BAIRRO")
		cidade_sacado		= rs("CIDADE")
		estado_sacado		= rs("SIGLA")			
		
		'================INSTRUÇÕES DO BOLETO ==============
		instrucoes1 = rs("vestibular")
		instrucoes2 = "Data: " & rs("Data") & " - Horário: " & rs("Horario")
		instrucoes3 = "Campus: " & rs("Campus")
		instrucoes4 = "Ano Letivo/Semestre: " & rs("Ano_letivo") & "/" & rs("Semestre")
		instrucoes5 = ""
		
'		if trim(vencimento1)<>"" then
'			if strMostraPerc1 = "S" then 
'				strMostraPerc1 = "(" & String(4-len(FORMATNUMBER((((valor1*100)/valorFinalCal)-100)*-1,1)), "0") & FORMATNUMBER((((valor1*100)/valorFinalCal)-100)*-1,1) & "%)"
'			else
'				strMostraPerc1 = "............"			
'			end if
'			instrucoes4 = "<BR>- Pagamento até " & FORMATADATAAP(vencimento1) & ".................." & strMostraPerc1 & "............... R$ " & FORMATNUMBER(valor1,2)
'		end if
'		if trim(vencimento2)<>"" then
'			if strMostraPerc2 = "S" then 
'				strMostraPerc2 = "(" & String(4-len(FORMATNUMBER((((valor2*100)/valorFinalCal)-100)*-1,1)), "0") & FORMATNUMBER((((valor2*100)/valorFinalCal)-100)*-1,1) & "%)"
'			else
'				strMostraPerc2 = "............"			
'			end if
'			instrucoes4 = instrucoes4 & "<br>de " & FORMATADATAAP(DateAdd("d", 1, vencimento1)) & " a " & FORMATADATAAP(vencimento2)  & ".................." & strMostraPerc2 & "............... R$ " & FORMATNUMBER(valor2,2)
'		end if
'		if trim(vencimento3)<>"" then
'			if strMostraPerc3 = "S" then 
'				strMostraPerc3 = "(" & String(4-len(FORMATNUMBER((((valor3*100)/valorFinalCal)-100)*-1,1)), "0") & FORMATNUMBER((((valor3*100)/valorFinalCal)-100)*-1,1) & "%)"
'			else
'				strMostraPerc3 = "............"			
'			end if
'			instrucoes5 = "de " & FORMATADATAAP(DateAdd("d", 1, vencimento2)) & " a " & FORMATADATAAP(vencimento3)  & ".................."& strMostraPerc3 &"............... R$ " & FORMATNUMBER(valor3,2)
'		end if
'		if trim(vencimento4)<>"" then
'			strMostraPerc4 = ".............."
'			instrucoes5 = instrucoes5 & "<br>de " & FORMATADATAAP(DateAdd("d", 1, vencimento3)) & " a " & FORMATADATAAP(vencimento4)  & ".................." & strMostraPerc4 & "............... R$ " & FORMATNUMBER(valor4,2)
'		end if
'		instrucoes5 = instrucoes5 & "<br>(" & rs("numeroVia")+1 & "ª via)"
	 else
		 %>
		 <script>
		 alert("ATENÇÃO: Boleto não pode ser gerado, NÃO foram encontradas informações sobre o aluno.");
		 </script>
		 <%
	end if
	rs.close


'=========== DADOS DO SACADO (QUEM PAGA O BOLETO) ==============================
x109 = nome_sacado ' Nome do Sacado
x70 = endereco_sacado ' Endereço do sacado
x79 = bairro_sacado ' Bairro do sacado
x74 = cep_sacado ' Cep do sacado
x67 = cidade_sacado ' Cidade do sacado
x28 = estado_sacado ' Estado do sacado

'============INSTRUÇÕES DO BOLETO ================================================
x80= instrucoes1 ' Instrucoes linha 1
x171= instrucoes2 ' Instrucoes linha 2
x130= instrucoes3 ' Instrucoes linha 3
x97=  instrucoes4 ' Instrucoes linha 4
x73= instrucoes5 ' Instrucoes linha 5


'===========DADOS DO CEDENTE (EMISSOR DO BOLETO)===================================
x136= strEmpresaWeb ' Nome do Cedente
x49= strEmpresacnpj ' CNPJ Cedente
x56= strEnderecoEmpresaWeb ' Endereço do Cedente
x83 = strAgenciaEmpresa ' Numero da Agencia s/ Digito
x64 = strContaEmpresa ' Numero da Conta /s Digito
x10 = strCarteiraEmpresa ' Carteira

'==========DADOS DO BOLETO A SER GERADO ===========================================
x81 = nosso_numero ' Nosso Numero
x89 = numDoc ' numero do Documento
x101 = formatNumber(valorParcela,2) ' Valor do Boleto
x33 = formatadataAP(vencimentoParcela)  ' Data Vencimento (Para contra apresentação, deixe o valor em branco, x33 = "" )

'==========OUTRAS INFORMAÇÕES ======================================================
x34=  "DM"' Especie Documento
x174= "N"' Aceite
x98 = "" ' Quantidade
x160= "" ' Especie
x163= "" ' Uso do Banco

'=============== NÃO MEXER DAQUI PARA BAIXO ==================================

x11= x136
If x10 = "57" Then
x81 = x32(x81, 13)
Else
x81 = x32(x81, 7)
End If
if x89 = "" then x89 = x81
x119 = CStr(x81) ' formata o número do banco igual ao numero do pedido.
x83 = x32(x83, 4)
x64 = x32(x64, 7)
x121 = x102(x119 & x83 & x64)
x100 = x64
x127 = x83 & "/" & x100 & "/" & x121
x5 = x83 & x64 & x121 & x32(x119, 13)
x123 = x17(x128, x19, x33, CCur(x101), x5)
x57 = x147(x128, x19, x33, CCur(x101), x5)
x104 = x119
if x33 = "" then x33 = "Contra Apresentação"

'=============== NÃO MEXER DAQUI PARA CIMA ==================================

%>
<!DOCTYPE HTML PUBLIC '-//W3C//DTD HTML 4.0 Transitional//EN'>
<HTML>
<HEAD>
<TITLE>Boleto Banco REAL</TITLE><META http-equiv=Content-Type content=text/html; charset=windows-1252 charset=windows-1252><meta name=GENERATOR content=NetDinamica><style type=text/css><META NAME="keywords" CONTENT="Boleto, Dinamico, PHP, ASP, Itau, Bradesco, HSBC, Real, Banespa, Unibanco, Banco do Brasil, Sistemas, Sites, Cobrança Bancaria"><META NAME="description" CONTENT="Sistema para criação de boletos on-lines código fonte em PHP ou ASP, como usar boletos bancarios."> 
<!--.cp {  font: bold 10px Arial; color: black}
<!--.ti {  font: 9px Arial, Helvetica, sans-serif}
<!--.ld { font: bold 15px Arial; color: #000000}
<!--.ct { FONT: 9px "Arial Narrow"; COLOR: #000033}
<!--.cn { FONT: 9px Arial; COLOR: black }
<!--.bc { font: bold 22px Arial; color: #000000 }
--></style> 
</HEAD>
<BODY bgColor=#ffffff text=#000000 leftmargin="0" topMargin=0 rightMargin=0>
<table width=666 cellspacing=0 cellpadding=0 border=0><tr><td valign=top class=cp><DIV ALIGN="CENTER">Instruções 
de Impressão</DIV></TD></TR><TR><TD valign=top class=ti><DIV ALIGN="CENTER">Imprimir 
em impressora jato de tinta (ink jet) ou laser em qualidade normal. (Não use modo 
econômico). <BR>Utilize folha A4 (210 x 297 mm) ou Carta (216 x 279 mm) - Corte 
na linha indicada<BR></DIV></td></tr></table><br><table cellspacing=0 cellpadding=0 width=666 border=0><TBODY><TR><TD class=ct width=666><img height=1 src=../../images/real/6.gif width=665 border=0></TD></TR><TR><TD class=ct width=666><div align=right><b class=cp>Recibo 
do Sacado&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</b></div></TD></tr></tbody></table><table width=666 cellspacing=5 cellpadding=0 border=0><tr><td width=41></TD></tr></table><table width=666 cellspacing=5 cellpadding=0 border=0 align=Default><tr> 
<td width=41>&nbsp;</td><td class=ti width=455> 
<%response.write x11 & "<br>" : response.write x56 & "<br>" : response.write x52 & "<br>"
response.write x71 & "<br>" : response.write x168 %> </td><td align=RIGHT width=150 class=ti> 
<div align=right></div></td></tr></table><BR><TABLE CELLSPACING=0 CELLPADDING=0 WIDTH=666 BORDER=0><TBODY><TR><TD CLASS=cp WIDTH=136><DIV ALIGN=left><IMG SRC=../../images/real/logo-real.jpg WIDTH="135" HEIGHT="36"></DIV></TD><TD WIDTH=4 VALIGN=bottom><IMG HEIGHT=22 SRC=../../images/real/3.gif WIDTH=2 BORDER=0></TD><TD CLASS=cpt  WIDTH=63 VALIGN=bottom><DIV ALIGN=center><FONT CLASS=bc>356-5</FONT></DIV></TD><TD WIDTH=4 VALIGN=bottom><IMG HEIGHT=22 SRC=../../images/real/3.gif WIDTH=2 BORDER=0></TD><TD CLASS=ld ALIGN=right WIDTH=459 VALIGN=bottom><SPAN CLASS=ld> 
<%=x57%>&nbsp;&nbsp;&nbsp;&nbsp; </SPAN></TD>
</TR><TR><TD COLSPAN=5><IMG HEIGHT=2 SRC=../../images/real/2.gif WIDTH=666 BORDER=0></TD></TR></TBODY></TABLE><table cellspacing=0 cellpadding=0 border=0><tbody><tr><td class=ct valign=top width=7 height=13><img height=13 src=../../images/real/1.gif width=1 border=0></td><td class=ct valign=top width=298 height=13>Cedente</td><td class=ct valign=top width=7 height=13><img height=13 src=../../images/real/1.gif width=1 border=0></td><td class=ct valign=top width=126 height=13>Agência/Código 
do Cedente</td><td class=ct valign=top width=7 height=13><img height=13 src=../../images/real/1.gif width=1 border=0></td><td class=ct valign=top width=34 height=13>Espécie</td><td class=ct valign=top width=7 height=13><img height=13 src=../../images/real/1.gif width=1 border=0></td><td class=ct valign=top width=53 height=13>Quantidade</td><td class=ct valign=top width=7 height=13><img height=13 src=../../images/real/1.gif width=1 border=0></td><td class=ct valign=top width=120 height=13>Nosso 
número</td></tr><tr><td class=cp valign=top width=7 height=12><img height=12 src=../../images/real/1.gif width=1 border=0></td><td class=cp valign=top width=298 height=12> 
<%=x136%> </td><td class=cp valign=top width=7 height=12><img height=12 src=../../images/real/1.gif width=1 border=0></td><td class=cp valign=top width=126 height=12> <%=x127%> </td><td class=cp valign=top width=7 height=12><img height=12 src=../../images/real/1.gif width=1 border=0></td><td class=cp valign=top  width=34 height=12> 
<%=x160%> </td><td class=cp valign=top width=7 height=12><img height=12 src=../../images/real/1.gif width=1 border=0></td><td class=cp valign=top  width=53 height=12> 
<%=x98%> </td><td class=cp valign=top width=7 height=12><img height=12 src=../../images/real/1.gif width=1 border=0></td><td class=cp valign=top align=right width=120 height=12> 
<%=x104%>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;  </td>
</tr><tr><td valign=top width=7 height=1><img height=1 src=../../images/real/2.gif width=7 border=0></td><td valign=top width=298 height=1><img height=1 src=../../images/real/2.gif width=298 border=0></td><td valign=top width=7 height=1><img height=1 src=../../images/real/2.gif width=7 border=0></td><td valign=top width=126 height=1><img height=1 src=../../images/real/2.gif width=126 border=0></td><td valign=top width=7 height=1><img height=1 src=../../images/real/2.gif width=7 border=0></td><td valign=top width=34 height=1><img height=1 src=../../images/real/2.gif width=34 border=0></td><td valign=top width=7 height=1><img height=1 src=../../images/real/2.gif width=7 border=0></td><td valign=top width=53 height=1><img height=1 src=../../images/real/2.gif width=53 border=0></td><td valign=top width=7 height=1><img height=1 src=../../images/real/2.gif width=7 border=0></td><td valign=top width=120 height=1><img height=1 src=../../images/real/2.gif width=120 border=0></td></tr></tbody></table><table cellspacing=0 cellpadding=0 border=0><tbody><tr><td class=ct valign=top width=7 height=13><img height=13 src=../../images/real/1.gif width=1 border=0></td><td class=ct valign=top colspan=3 height=13>Número 
do documento</td><td class=ct valign=top width=7 height=13><img height=13 src=../../images/real/1.gif width=1 border=0></td><td class=ct valign=top width=132 height=13>CPF/CNPJ</td><td class=ct valign=top width=7 height=13><img height=13 src=../../images/real/1.gif width=1 border=0></td><td class=ct valign=top width=134 height=13>Vencimento</td><td class=ct valign=top width=7 height=13><img height=13 src=../../images/real/1.gif width=1 border=0></td><td class=ct valign=top width=180 height=13>Valor 
documento</td></tr><tr><td class=cp valign=top width=7 height=12><img height=12 src=../../images/real/1.gif width=1 border=0></td><td class=cp valign=top colspan=3 height=12> 
<%=x89%> </td><td class=cp valign=top width=7 height=12><img height=12 src=../../images/real/1.gif width=1 border=0></td><td class=cp valign=top width=132 height=12> 
<%= x49%> </td><td class=cp valign=top width=7 height=12><img height=12 src=../../images/real/1.gif width=1 border=0></td><td class=cp valign=top width=134 height=12> 
<%=x33%> </td><td class=cp valign=top width=7 height=12><img height=12 src=../../images/real/1.gif width=1 border=0></td><td class=cp valign=top align=right width=180 height=12> 
<%=x101%>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; </td>
</tr><tr><td valign=top width=7 height=1><img height=1 src=../../images/real/2.gif width=7 border=0></td><td valign=top width=113 height=1><img height=1 src=../../images/real/2.gif width=113 border=0></td><td valign=top width=7 height=1><img height=1 src=../../images/real/2.gif width=7 border=0></td><td valign=top width=72 height=1><img height=1 src=../../images/real/2.gif width=72 border=0></td><td valign=top width=7 height=1><img height=1 src=../../images/real/2.gif width=7 border=0></td><td valign=top width=132 height=1><img height=1 src=../../images/real/2.gif width=132 border=0></td><td valign=top width=7 height=1><img height=1 src=../../images/real/2.gif width=7 border=0></td><td valign=top width=134 height=1><img height=1 src=../../images/real/2.gif width=134 border=0></td><td valign=top width=7 height=1><img height=1 src=../../images/real/2.gif width=7 border=0></td><td valign=top width=180 height=1><img height=1 src=../../images/real/2.gif width=180 border=0></td></tr></tbody></table><table cellspacing=0 cellpadding=0 border=0><tbody><tr><td class=ct valign=top width=7 height=13><img height=13 src=../../images/real/1.gif width=1 border=0></td><td class=ct valign=top width=113 height=13>(-) 
Desconto / Abatimentos</td><td class=ct valign=top width=7 height=13><img height=13 src=../../images/real/1.gif width=1 border=0></td><td class=ct valign=top width=112 height=13>(-) 
Outras deduções</td><td class=ct valign=top width=7 height=13><img height=13 src=../../images/real/1.gif width=1 border=0></td><td class=ct valign=top width=113 height=13>(+) 
Mora / Multa</td><td class=ct valign=top width=7 height=13><img height=13 src=../../images/real/1.gif width=1 border=0></td><td class=ct valign=top width=113 height=13>(+) 
Outros acréscimos</td><td class=ct valign=top width=7 height=13><img height=13 src=../../images/real/1.gif width=1 border=0></td><td class=ct valign=top width=180 height=13>(=) 
Valor cobrado</td></tr><tr><td class=cp valign=top width=7 height=12><img height=12 src=../../images/real/1.gif width=1 border=0></td><td class=cp valign=top align=right width=113 height=12></td><td class=cp valign=top width=7 height=12><img height=12 src=../../images/real/1.gif width=1 border=0></td><td class=cp valign=top align=right width=112 height=12></td><td class=cp valign=top width=7 height=12><img height=12 src=../../images/real/1.gif width=1 border=0></td><td class=cp valign=top align=right width=113 height=12></td><td class=cp valign=top width=7 height=12><img height=12 src=../../images/real/1.gif width=1 border=0></td><td class=cp valign=top align=right width=113 height=12></td><td class=cp valign=top width=7 height=12><img height=12 src=../../images/real/1.gif width=1 border=0></td><td class=cp valign=top align=right width=180 height=12></td></tr><tr><td valign=top width=7 height=1><img height=1 src=../../images/real/2.gif width=7 border=0></td><td valign=top width=113 height=1><img height=1 src=../../images/real/2.gif width=113 border=0></td><td valign=top width=7 height=1><img height=1 src=../../images/real/2.gif width=7 border=0></td><td valign=top width=112 height=1><img height=1 src=../../images/real/2.gif width=112 border=0></td><td valign=top width=7 height=1><img height=1 src=../../images/real/2.gif width=7 border=0></td><td valign=top width=113 height=1><img height=1 src=../../images/real/2.gif width=113 border=0></td><td valign=top width=7 height=1><img height=1 src=../../images/real/2.gif width=7 border=0></td><td valign=top width=113 height=1><img height=1 src=../../images/real/2.gif width=113 border=0></td><td valign=top width=7 height=1><img height=1 src=../../images/real/2.gif width=7 border=0></td><td valign=top width=180 height=1><img height=1 src=../../images/real/2.gif width=180 border=0></td></tr></tbody></table><table cellspacing=0 cellpadding=0 border=0><tbody><tr><td class=ct valign=top width=7 height=13><img height=13 src=../../images/real/1.gif width=1 border=0></td><td class=ct valign=top width=659 height=13>Sacado</td></tr>
    <tr>
      <td class=cp valign=top width=7 height=12><img height=12 src=../../images/real/1.gif width=1 border=0></td>
	  <td class=cp valign=top height=12><%=x109 %></td>
    </tr>
    <tr>
      <td class=cp valign=top width=7 height=12><img height=12 src=../../images/real/1.gif width=1 border=0>
	  <td class=cp valign=top height=12><%=x70 & " - " & x79 %></td>
    </tr>
    <tr><td class=cp valign=top width=7 height=12><img height=12 src=../../images/real/1.gif width=1 border=0></td><td class=cp valign=top width=659 height=12><%= x74 & " - " & x67 & " - " & x28 %></td></tr><tr><td valign=top width=7 height=1><img height=1 src=../../images/real/2.gif width=7 border=0></td><td valign=top width=659 height=1><img height=1 src=../../images/real/2.gif width=659 border=0></td></tr></tbody></table>
<table cellspacing=0 cellpadding=0 border=0><tbody><tr><td class=ct  width=7 height=12></td><td class=ct  width=510 >Instruções</td><td class=ct  width=10 height=12></td><td class=ct  width=139 >Autenticação 
mecânica</td></tr><tr><td  width=7 ></td><td  width=510 ></td><td  width=10 ></td><td  width=139 ></td></tr></tbody></table><table cellspacing=0 cellpadding=0 width=666 border=0><tbody><tr><td width=7></td><td  width=500 class=cp> 
<%response.write x12 & "<br>" : response.write x20 & "<br>"
response.write x48 & "<br>" : response.write x21 & "<br>" : response.write x1%> 
</td><td width=159></td></tr></tbody></table><table cellspacing=0 cellpadding=0 width=666 border=0><tr><td class=ct width=666></td></tr><tbody><tr><td class=ct width=666> 
<div align=right>Corte na linha pontilhada&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</div></td></tr><tr><td class=ct width=666><img height=1 src=../../images/real/6.gif width=665 border=0></td></tr></tbody></table><br><br><table cellspacing=0 cellpadding=0 width=666 border=0><tbody><tr><td class=cp width=137><div align=left><img src=../../images/real/logo-real.jpg WIDTH="136" HEIGHT="36"></div></td><td width=4 valign=bottom><img height=22 src=../../images/real/3.gif width=2 border=0></td><td class=cpt  width=62 valign=bottom><div align=center><font class=bc>356-5</font></div></td><td width=4 valign=bottom><img height=22 src=../../images/real/3.gif width=2 border=0></td><td class=ld align=right width=459 valign=bottom><span class=ld> 
<%=x57%>&nbsp;&nbsp;&nbsp;&nbsp; </span></td>
</tr><tr><td colspan=5><img height=2 src=../../images/real/2.gif width=666 border=0></td></tr></tbody></table><table cellspacing=0 cellpadding=0 border=0><tbody><tr><td class=ct valign=top width=7 height=13><img height=13 src=../../images/real/1.gif width=1 border=0></td><td class=ct valign=top width=472 height=13>Local 
de pagamento</td><td class=ct valign=top width=7 height=13><img height=13 src=../../images/real/1.gif width=1 border=0></td><td class=ct valign=top width=180 height=13>Vencimento</td></tr><tr><td class=cp valign=top width=7 height=12><img height=12 src=../../images/real/1.gif width=1 border=0></td><td class=cp valign=top width=472 height=12>Pagável 
em qualquer Banco até o vencimento</td><td class=cp valign=top width=7 height=12><img height=12 src=../../images/real/1.gif width=1 border=0></td><td class=cp valign=top align=right width=180 height=12> 
<%=x33%>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; </td>
</tr><tr><td valign=top width=7 height=1><img height=1 src=../../images/real/2.gif width=7 border=0></td><td valign=top width=472 height=1><img height=1 src=../../images/real/2.gif width=472 border=0></td><td valign=top width=7 height=1><img height=1 src=../../images/real/2.gif width=7 border=0></td><td valign=top width=180 height=1><img height=1 src=../../images/real/2.gif width=180 border=0></td></tr></tbody></table><table cellspacing=0 cellpadding=0 border=0><tbody><tr><td class=ct valign=top width=7 height=13><img height=13 src=../../images/real/1.gif width=1 border=0></td><td class=ct valign=top width=472 height=13>Cedente</td><td class=ct valign=top width=7 height=13><img height=13 src=../../images/real/1.gif width=1 border=0></td><td class=ct valign=top width=180 height=13>Agência/Código 
cedente</td></tr><tr><td class=cp valign=top width=7 height=12><img height=12 src=../../images/real/1.gif width=1 border=0></td><td class=cp valign=top width=472 height=12> 
<%=x136%> </td><td class=cp valign=top width=7 height=12><img height=12 src=../../images/real/1.gif width=1 border=0></td><td class=cp valign=top align=right width=180 height=12> 
<%=x127%>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; </td>
</tr><tr><td valign=top width=7 height=1><img height=1 src=../../images/real/2.gif width=7 border=0></td><td valign=top width=472 height=1><img height=1 src=../../images/real/2.gif width=472 border=0></td><td valign=top width=7 height=1><img height=1 src=../../images/real/2.gif width=7 border=0></td><td valign=top width=180 height=1><img height=1 src=../../images/real/2.gif width=180 border=0></td></tr></tbody></table><table cellspacing=0 cellpadding=0 border=0><tbody><tr><td class=ct valign=top width=7 height=13> 
<img height=13 src=../../images/real/1.gif width=1 border=0></td><td class=ct valign=top width=113 height=13>Data 
do documento</td><td class=ct valign=top width=7 height=13> <img height=13 src=../../images/real/1.gif width=1 border=0></td><td class=ct valign=top width=163 height=13>N<u>o</u> 
documento</td><td class=ct valign=top width=7 height=13> <img height=13 src=../../images/real/1.gif width=1 border=0></td><td class=ct valign=top width=62 height=13>Espécie 
doc.</td><td class=ct valign=top width=7 height=13> <img height=13 src=../../images/real/1.gif width=1 border=0></td><td class=ct valign=top width=34 height=13>Aceite</td><td class=ct valign=top width=7 height=13> 
<img height=13 src=../../images/real/1.gif width=1 border=0></td><td class=ct valign=top width=72 height=13>Data 
processamento</td><td class=ct valign=top width=7 height=13> <img height=13 src=../../images/real/1.gif width=1 border=0></td><td class=ct valign=top width=180 height=13>Nosso 
número</td></tr><tr><td class=cp valign=top width=7 height=12><img height=12 src=../../images/real/1.gif width=1 border=0></td><td class=cp valign=top  width=113 height=12><div align=left> 
<%=date()%> </div></td><td class=cp valign=top width=7 height=12><img height=12 src=../../images/real/1.gif width=1 border=0></td><td class=cp valign=top width=163 height=12> 
<%=x89%> </td><td class=cp valign=top width=7 height=12><img height=12 src=../../images/real/1.gif width=1 border=0></td><td class=cp valign=top  width=62 height=12><div align=left> 
<%=x34%> </div></td><td class=cp valign=top width=7 height=12><img height=12 src=../../images/real/1.gif width=1 border=0></td><td class=cp valign=top  width=34 height=12><div align=left> 
<%=x174%> </div></td><td class=cp valign=top width=7 height=12><img height=12 src=../../images/real/1.gif width=1 border=0></td><td class=cp valign=top  width=72 height=12><div align=left> 
<%=date()%> </div></td><td class=cp valign=top width=7 height=12><img height=12 src=../../images/real/1.gif width=1 border=0></td><td class=cp valign=top align=right width=180 height=12> 
<%=x104%>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; </td>
</tr><tr><td valign=top width=7 height=1><img height=1 src=../../images/real/2.gif width=7 border=0></td><td valign=top width=113 height=1><img height=1 src=../../images/real/2.gif width=113 border=0></td><td valign=top width=7 height=1> 
<img height=1 src=../../images/real/2.gif width=7 border=0></td><td valign=top width=163 height=1><img height=1 src=../../images/real/2.gif width=163 border=0></td><td valign=top width=7 height=1> 
<img height=1 src=../../images/real/2.gif width=7 border=0></td><td valign=top width=62 height=1><img height=1 src=../../images/real/2.gif width=62 border=0></td><td valign=top width=7 height=1> 
<img height=1 src=../../images/real/2.gif width=7 border=0></td><td valign=top width=34 height=1><img height=1 src=../../images/real/2.gif width=34 border=0></td><td valign=top width=7 height=1> 
<img height=1 src=../../images/real/2.gif width=7 border=0></td><td valign=top width=72 height=1><img height=1 src=../../images/real/2.gif width=72 border=0></td><td valign=top width=7 height=1> 
<img height=1 src=../../images/real/2.gif width=7 border=0></td><td valign=top width=180 height=1> 
<img height=1 src=../../images/real/2.gif width=180 border=0></td></tr></tbody></table><table cellspacing=0 cellpadding=0 border=0><tbody><tr> 
<td class=ct valign=top width=7 height=13> <img height=13 src=../../images/real/1.gif width=1 border=0></td><td class=ct valign=top COLSPAN="3" height=13>Uso 
do banco</td><td class=ct valign=top height=13 width=7> 
<img height=13 src=../../images/real/1.gif width=1 border=0></td><td class=ct valign=top width=83 height=13>Carteira</td><td class=ct valign=top height=13 width=7> 
<img height=13 src=../../images/real/1.gif width=1 border=0></td><td class=ct valign=top width=53 height=13>Espécie</td><td class=ct valign=top height=13 width=7> 
<img height=13 src=../../images/real/1.gif width=1 border=0></td><td class=ct valign=top width=123 height=13>Quantidade</td><td class=ct valign=top height=13 width=7> 
<img height=13 src=../../images/real/1.gif width=1 border=0></td><td class=ct valign=top width=72 height=13> 
Valor Documento</td><td class=ct valign=top width=7 height=13><img height=13 src=../../images/real/1.gif width=1 border=0></td><td class=ct valign=top width=180 height=13>(=) 
Valor documento</td></tr><tr> <td class=cp valign=top width=7 height=12><img height=12 src=../../images/real/1.gif width=1 border=0></td><td valign=top class=cp height=12 COLSPAN="3"><div align=left> 
<%=x163%> </div></td><td class=cp valign=top width=7 height=12><img height=12 src=../../images/real/1.gif width=1 border=0></td><td class=cp valign=top  width=83> 
<div align=left> <%=x10%> </div></td><td class=cp valign=top width=7 height=12><img height=12 src=../../images/real/1.gif width=1 border=0></td><td class=cp valign=top  width=53><div align=left> 
<%=x160%> </div></td><td class=cp valign=top width=7 height=12><img height=12 src=../../images/real/1.gif width=1 border=0></td><td class=cp valign=top  width=123> 
<%=x98%> </td><td class=cp valign=top width=7 height=12><img height=12 src=../../images/real/1.gif width=1 border=0></td><td class=cp valign=top  width=72> 
<%=x101%> </td><td class=cp valign=top width=7 height=12> <img height=12 src=../../images/real/1.gif width=1 border=0></td><td class=cp valign=top align=right width=180 height=12> 
<%=x101%>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; </td>
</tr><tr><td valign=top width=7 height=1> <img height=1 src=../../images/real/2.gif width=7 border=0></td><td valign=top width=7 height=1><img height=1 src=../../images/real/2.gif width=75 border=0></td><td valign=top width=7 height=1><img height=1 src=../../images/real/2.gif width=7 border=0></td><td valign=top width=31 height=1><img height=1 src=../../images/real/2.gif width=31 border=0></td><td valign=top width=7 height=1> 
<img height=1 src=../../images/real/2.gif width=7 border=0></td><td valign=top width=83 height=1><img height=1 src=../../images/real/2.gif width=83 border=0></td><td valign=top width=7 height=1> 
<img height=1 src=../../images/real/2.gif width=7 border=0></td><td valign=top width=53 height=1><img height=1 src=../../images/real/2.gif width=53 border=0></td><td valign=top width=7 height=1> 
<img height=1 src=../../images/real/2.gif width=7 border=0></td><td valign=top width=123 height=1><img height=1 src=../../images/real/2.gif width=123 border=0></td><td valign=top width=7 height=1> 
<img height=1 src=../../images/real/2.gif width=7 border=0></td><td valign=top width=72 height=1><img height=1 src=../../images/real/2.gif width=72 border=0></td><td valign=top width=7 height=1> 
<img height=1 src=../../images/real/2.gif width=7 border=0></td><td valign=top width=180 height=1><img height=1 src=../../images/real/2.gif width=180 border=0></td></tr></tbody> 
</table><table cellspacing=0 cellpadding=0 width=666 border=0><tbody><tr><td align=right width=10><table cellspacing=0 cellpadding=0 border=0 align=left><tbody> 
<tr> <td class=ct valign=top width=7 height=13><img height=13 src=../../images/real/1.gif width=1 border=0></td></tr><tr> 
<td class=cp valign=top width=7 height=12><img height=12 src=../../images/real/1.gif width=1 border=0></td></tr><tr> 
<td valign=top width=7 height=1><img height=1 src=../../images/real/2.gif width=1 border=0></td></tr></tbody></table></td><td valign=top width=468 rowspan=5><font class=ct>Instruções 
(Texto de responsabilidade do cedente)</font><br><span class=cp> <%response.write x80 & "<br>" : response.write x171 & "<br>"
response.write x130 & "<br>" : response.write x97 & "<br>" : response.write x73%> 
</span></td><td align=right width=188><table cellspacing=0 cellpadding=0 border=0><tbody><tr><td class=ct valign=top width=7 height=13><img height=13 src=../../images/real/1.gif width=1 border=0></td><td class=ct valign=top width=180 height=13>(-) 
Desconto / Abatimentos</td></tr><tr> <td class=cp valign=top width=7 height=12><img height=12 src=../../images/real/1.gif width=1 border=0></td><td class=cp valign=top align=right width=180 height=12></td></tr><tr> 
<td valign=top width=7 height=1><img height=1 src=../../images/real/2.gif width=7 border=0></td><td valign=top width=180 height=1><img height=1 src=../../images/real/2.gif width=180 border=0></td></tr></tbody></table></td></tr><tr><td align=right width=10> 
<table cellspacing=0 cellpadding=0 border=0 align=left><tbody><tr><td class=ct valign=top width=7 height=13><img height=13 src=../../images/real/1.gif width=1 border=0></td></tr><tr><td class=cp valign=top width=7 height=12><img height=12 src=../../images/real/1.gif width=1 border=0></td></tr><tr><td valign=top width=7 height=1> 
<img height=1 src=../../images/real/2.gif width=1 border=0></td></tr></tbody></table></td><td align=right width=188><table cellspacing=0 cellpadding=0 border=0><tbody><tr><td class=ct valign=top width=7 height=13><img height=13 src=../../images/real/1.gif width=1 border=0></td><td class=ct valign=top width=180 height=13>(-) 
Outras deduções</td></tr><tr><td class=cp valign=top width=7 height=12> <img height=12 src=../../images/real/1.gif width=1 border=0></td><td class=cp valign=top align=right width=180 height=12></td></tr><tr><td valign=top width=7 height=1><img height=1 src=../../images/real/2.gif width=7 border=0></td><td valign=top width=180 height=1><img height=1 src=../../images/real/2.gif width=180 border=0></td></tr></tbody></table></td></tr><tr><td align=right width=10> 
<table cellspacing=0 cellpadding=0 border=0 align=left><tbody><tr><td class=ct valign=top width=7 height=13> 
<img height=13 src=../../images/real/1.gif width=1 border=0></td></tr><tr><td class=cp valign=top width=7 height=12><img height=12 src=../../images/real/1.gif width=1 border=0></td></tr><tr><td valign=top width=7 height=1><img height=1 src=../../images/real/2.gif width=1 border=0></td></tr></tbody></table></td><td align=right width=188> 
<table cellspacing=0 cellpadding=0 border=0><tbody><tr><td class=ct valign=top width=7 height=13><img height=13 src=../../images/real/1.gif width=1 border=0></td><td class=ct valign=top width=180 height=13>(+) 
Mora / Multa</td></tr><tr><td class=cp valign=top width=7 height=12><img height=12 src=../../images/real/1.gif width=1 border=0></td>
<td class=cp valign=top align=right width=180 height=12><%=strValorMultaMora%>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; </td>
</tr><tr> 
<td valign=top width=7 height=1> <img height=1 src=../../images/real/2.gif width=7 border=0></td><td valign=top width=180 height=1> 
<img height=1 src=../../images/real/2.gif width=180 border=0></td></tr></tbody></table></td></tr><tr><td align=right width=10><table cellspacing=0 cellpadding=0 border=0 align=left><tbody><tr> 
<td class=ct valign=top width=7 height=13><img height=13 src=../../images/real/1.gif width=1 border=0></td></tr><tr><td class=cp valign=top width=7 height=12><img height=12 src=../../images/real/1.gif width=1 border=0></td></tr><tr><td valign=top width=7 height=1><img height=1 src=../../images/real/2.gif width=1 border=0></td></tr></tbody></table></td><td align=right width=188> 
<table cellspacing=0 cellpadding=0 border=0><tbody><tr> <td class=ct valign=top width=7 height=13><img height=13 src=../../images/real/1.gif width=1 border=0></td><td class=ct valign=top width=180 height=13>(+) 
Outros acréscimos</td></tr><tr> <td class=cp valign=top width=7 height=12><img height=12 src=../../images/real/1.gif width=1 border=0></td><td class=cp valign=top align=right width=180 height=12></td></tr><tr><td valign=top width=7 height=1><img height=1 src=../../images/real/2.gif width=7 border=0></td><td valign=top width=180 height=1><img height=1 src=../../images/real/2.gif width=180 border=0></td></tr></tbody></table></td></tr><tr><td align=right width=10><table cellspacing=0 cellpadding=0 border=0 align=left><tbody><tr><td class=ct valign=top width=7 height=13><img height=13 src=../../images/real/1.gif width=1 border=0></td></tr><tr><td class=cp valign=top width=7 height=12><img height=12 src=../../images/real/1.gif width=1 border=0></td></tr></tbody></table></td><td align=right width=188><table cellspacing=0 cellpadding=0 border=0><tbody><tr><td class=ct valign=top width=7 height=13><img height=13 src=../../images/real/1.gif width=1 border=0></td><td class=ct valign=top width=180 height=13>(=) 
Valor cobrado</td></tr><tr><td class=cp valign=top width=7 height=12><img height=12 src=../../images/real/1.gif width=1 border=0></td>
<td class=cp valign=top align=right width=180 height=12><%=strCalculado%>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; </td>
</tr></tbody> 
</table></td></tr></tbody></table><table cellspacing=0 cellpadding=0 width=666 border=0><tbody><tr><td valign=top width=666 height=1><img height=1 src=../../images/real/2.gif width=666 border=0></td></tr></tbody></table><table cellspacing=0 cellpadding=0 border=0><tbody><tr><td class=ct valign=top width=7 height=13><img height=13 src=../../images/real/1.gif width=1 border=0></td><td class=ct valign=top width=659 height=13>Sacado</td></tr><tr><td class=cp valign=top width=7 height=12><img height=12 src=../../images/real/1.gif width=1 border=0></td><td class=cp valign=top width=659 height=12> 
<%=x109 %> </td></tr></tbody></table><table cellspacing=0 cellpadding=0 border=0><tbody><tr><td class=cp valign=top width=7 height=12><img height=12 src=../../images/real/1.gif width=1 border=0></td><td class=cp valign=top width=659 height=12> 
<%=x70 & " - " & x79 %> </td></tr></tbody></table><table cellspacing=0 cellpadding=0 border=0><tbody><tr><td class=ct valign=top width=7 height=13><img height=13 src=../../images/real/1.gif width=1 border=0></td><td class=cp valign=top width=472 height=13> 
<%= x74 & " - " & x67 & " - " & x28 %> </td><td class=ct valign=top width=7 height=13><img height=13 src=../../images/real/1.gif width=1 border=0></td><td class=ct valign=top width=180 height=13>Cód. 
baixa</td></tr><tr><td valign=top width=7 height=1><img height=1 src=../../images/real/2.gif width=7 border=0></td><td valign=top width=472 height=1><img height=1 src=../../images/real/2.gif width=472 border=0></td><td valign=top width=7 height=1><img height=1 src=../../images/real/2.gif width=7 border=0></td><td valign=top width=180 height=1><img height=1 src=../../images/real/2.gif width=180 border=0></td></tr></tbody></table><TABLE cellSpacing=0 cellPadding=0 border=0 width=666><TBODY><TR><TD class=ct  width=7 height=12></TD><TD class=ct  width=409 >Sacador/Avalista</TD><TD class=ct  width=250 ><div align=right>Autenticação 
mecânica - <b class=cp>Ficha de Compensação&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</b><span class="cp">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</span></div></TD></TR><TR><TD class=ct  colspan=3 ></TD></tr></tbody></table><TABLE cellSpacing=0 cellPadding=0 width=666 border=0><TBODY><TR><TD vAlign=bottom align=left height=50> 
<%x129( x123 )%> </TD></tr></tbody></table><TABLE cellSpacing=0 cellPadding=0 width=666 border=0><TR><TD class=ct width=666></TD></TR><TBODY><TR><TD class=ct width=666><div align=right>Corte 
na linha pontilhad<span class="cp">a&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</span><span class="cp">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</span><span class="cp">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</span></div></TD></TR><TR><TD class=ct width=666><img height=1 src=../../images/real/6.gif width=665 border=0></TD></tr></tbody></table>
</BODY></HTML>
<%
	
	next
else
 %>
 <script>
 alert("ATENÇÃO: Boleto não pode ser gerado.");
 window.close();
 </script>
 <%
end if
%>