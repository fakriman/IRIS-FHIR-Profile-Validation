Profile:        DiagnosticoCl
Parent:         Condition
Id:             CoreDiagnosticoCl
Title:          "CL Condición-Diagnóstico"
Description:    "Condicion o Diagnósticos de Pacientes para Registro Clínico Electrónico"



* clinicalStatus 1..1 MS
* clinicalStatus ^short = "El estatus en el cual se encuentra la condición: active| recurrece | relapse | inactive | remission | resolved"
* clinicalStatus  from 	http://hl7.org/fhir/ValueSet/condition-clinical (required)
* clinicalStatus ^binding.description = "Códigos requeridos por HL7-FHIR"
* clinicalStatus ^definition = "El estatus en el cual se encuentra la condición de un Paciente"

* verificationStatus ^short = "Estado de verificación de la condición o Diagnóstico"
* verificationStatus ^definition = "Estado de verificación de la condición o Diagnóstico"
* verificationStatus from http://hl7.org/fhir/ValueSet/condition-ver-status (required)
* verificationStatus ^binding.description = "unconfirmed | provisional | differential | confirmed | refuted | entered-in-error"


//---paciente
* subject only Reference(PacienteCl)
* subject MS
* subject.reference 1.. MS
* subject.identifier and subject.display MS

* subject ^short = "Paciente sobre al que corresponde la condición." 
* subject ^definition = "Paciente sobre al que corresponde la condición." 
  * reference ^short = "Referencia al recurso del Paciente al cual se indica el diagnóstico o condicón"
  * identifier ^short = "Identificador del paciente"
  * display ^short = "Texto alternativo para el recurso"
/*
* code 1..1 MS 
* code from $CIE10VS (preferred)
*/



//----Code



* code 1..1 MS
  

* code ^definition = "Identificación de la condición, el problema o el diagnóstico o registro del \"problema ausente\" o de los \"problemas desconocidos\"."
* code ^short = "Condición de la persona en Código o no conocido"
* code ^comment = "Se agregan los códigos no conocido o no presente"

* code from VSDiagnosticosSCT (preferred)
* code ^short = "Códigos de SOMED-CT y adicionales de ausente o desconocido"
* code ^definition = "Códigos de toda la Terminología."
* code ^binding.extension.url = "http://hl7.org/fhir/StructureDefinition/elementdefinition-bindingName"
* code ^binding.extension.valueString = "DiagnosticosSCT + Ausente o Desconocido"
* code ^binding.description = "Diagósticos en SNOMED-CT. El ValueSet trae toda la terminología + Problema Ausente o Desconocido"
  * coding.code MS
  * coding.code ^short = "Códoigo del diagnóstico o problema"
  * coding.code ^definition = "Códoigo del diagnóstico o problema"
  * coding.system MS
  * coding.system ^short = "Dominio de los códigos declarados"
  * coding.system ^definition = "Dominio de los códigos declarados"
  * coding.display MS
  * coding.display ^short = "Glosa del código en la terminología."
  * coding.display ^definition = "Glosa del código en la terminología."
  
  * text 1..1 MS
  * text ^short = "Se debe al menos notificar el diagnóstico o Problema en Texto"
  * text ^definition = "Se debe al menos notificar el diagnóstico o Problema en Texto"

* onset[x] MS
* onset[x] ^short = "Fecha para determinación Diagnóstica a definir entre fecha única o período"
* onset[x] ^definition = "Fecha o rango de fechas en que se definió el diagnóstico o se determinó la condición"
//* onset[x] ^slicing.discriminator.type = #type
//* onset[x] ^slicing.discriminator.path = "$this"
//* onset[x] ^slicing.rules = #closed
//* onset[x] contains onsetDateTime 0..1 MS and onsetPeriod 0..1 MS
* onset[x] only dateTime or Period

* onset[x] ^type[0].extension.url = "http://hl7.org/fhir/StructureDefinition/elementdefinition-type-must-support"
* onset[x] ^type[=].extension.valueBoolean = true

* onset[x] ^type[+].extension.url = "http://hl7.org/fhir/StructureDefinition/elementdefinition-type-must-support"
* onset[x] ^type[=].extension.valueBoolean = true
	

/*
* onsetDateTime[onsetDateTime] ^short = "Fecha y Hora de determinación de diagnóstico o condición"
* onsetDateTime[onsetDateTime] ^definition = "Fecha y Hora de determinación de diagnóstico o condición"
* onsetDateTime[onsetDateTime] ^sliceName = "onsetDateTime"
* onsetDateTime[onsetDateTime] ^mustSupport = true
* onsetPeriod[onsetPeriod] only Period
* onsetPeriod[onsetPeriod] ^short = "Periodo de tiempo en el cual de definió el Diagnóstico o Condición"
* onsetPeriod[onsetPeriod] ^definition = "Periodo de tiempo en el cual de definió el Diagnóstico o Condición"
* onsetPeriod[onsetPeriod] ^sliceName = "onsetPeriod"
* onsetPeriod[onsetPeriod] ^mustSupport = true
*/