function gerar() {

    var frm = document.getElementById("frm");

    if (document.getElementById("cmbTurmaProfessor").value=="0") {
        alert("A turma deve ser informada!");
        document.getElementById("cmbTurmaProfessor").focus();
        return false;
    }

    if (document.getElementById("txtDataInicial").value=="") {
        alert("A Data Início deve ser informada!");
        document.getElementById("txtDataInicial").focus();
        return false;
    }  
    
    if (document.getElementById("txtDataFinal").value=="") {
        alert("A Data Fim deve ser informada!");
        document.getElementById("txtDataFinal").focus();
        return false;
    }     

    frm.action = "sca_rel_conteudo_ministrado_rel.asp"
    frm.submit();
}