function marksCalc () {
	var marksform = document.forms["marksform"];
	var s1Ftest = marksform.elements.s1Ftest.value;
	var s1Ess = marksform.elements.s1Ess.value;
	var s1Ther = marksform.elements.s1Ther.value;
	var s2Ftest = marksform.elements.s2Ftest.value;
	var s2test = marksform.elements.s2test.value;
	var s2Ther = marksform.elements.s2Ther.value;
	var s2Ess = marksform.elements.s2Ess.value;
	var Marks = s1Ftest*0.075 + s1Ther*0.075 + s1Ess*0.15 + s2Ftest*0.075 + s2test*0.075 + s2Ther*0.3 + s2Ess*0.25;
	var totalMarks = Math.round(Marks)
//	return totalMarks;
//  	if (totalMarks < 50){
//	var grade = fail; }



document.getElementById('totalMarks').innerHTML = "Total Marks "+totalMarks +" %";

//document.getElementById('grade').innerHTML = "grade "+grade;
}