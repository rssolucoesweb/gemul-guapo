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

   /* if (document.getElementById("cmbDisciplinaDoProfessor").value=="0") {
        alert("A Disciplina deve ser informada!");
        document.getElementById("cmbDisciplinaDoProfessor").focus();
        return false;
    }   
    */


    frm.action = "sca_rel_planejamento_rel.asp"
    frm.submit();
}