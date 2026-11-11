function gerar() {

    var frm = document.getElementById("frm");

   if (document.getElementById("cmbTurmaProfessor").value=="0") {
        alert("A turma deve ser informada!");
        document.getElementById("cmbTurmaProfessor").focus();
        return false;
   }
   if (document.getElementById("cmbTurnoDoProfessor").value=="0") {
        alert("Turno deve ser informado!");
        document.getElementById("cmbTurnoDoProfessor").focus();
        return false;
    }
	
	if (document.getElementById("cmbMes").value=="0") {
        alert("Mês deve ser informado!");
        document.getElementById("cmbMes").focus();
        return false;
    }

    frm.action = "sca_rel_total_aulas_mensal_rel.asp"
    frm.submit();
}