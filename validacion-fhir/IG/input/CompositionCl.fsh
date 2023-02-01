Alias: $loinc = http://loinc.org

Profile: DocumentoCl
Parent: Composition
Id: DocumentoCl
Title: "CL Documento"
Description: "Definición de un documento para Resumen de Historia o Registro de Encuentro para Historia Clínica, basado en IPS."


//* text MS
//* identifier MS

* identifier 0..1 MS
* identifier ^short = "Identificador local para recurso de documeto que puede ser distinto para cada versión del mismo"
* identifier ^definition = "Identificador para el recurso que contiene documento, puede ser usado de manera local. Este idetificador es independiente de la versión del documento"
* status MS
* status ^short = "Estado, valores posibles: preliminary | final | amended | entered-in-error"
* status ^definition = "Estado del documento"
* status = #final

//--- loinc que representa el tipo de documento ----
* type from VSTiposDocClinic
* type MS
* type ^short = "Tipo de Documento según especificación de LOINC (Ej para Summarie IPS Loinc = #60591-5"
* type ^definition = "Especifica el tipo de documento al que refiere este Recurso. Si se desea ajustar a IPS debe ser un resumen con código LOINC 60591-5"


//* ---- Paciente ----- 
* subject 1..1 
* subject only Reference(Patient)
* subject MS
* subject ^definition = "Paciente sobre el cual se ha generado este documento. Este debe ser basado en el perfil de paciente Chileno."
* subject ^short = "Paciente sobre el cual se ha generado este documento. Este debe ser basado en el perfil del paciente Chileno."
* subject.reference 1..1 MS
* subject.reference ^short = "Corresponde al paciente"

* encounter 0..1 
* encounter only Reference(Encounter)
* encounter MS
* encounter ^definition = "Contexto en el cual se desarrolló el documento."
* encounter ^short = "Contexto del Documento."
* encounter.reference 1..1 MS
* encounter.reference ^short = "Corresponde al paciente"
* encounter.display MS
* encounter.display ^short = "texto que describe el contexto del documento"
* encounter.display ^definition = "Texto descriptivo que reemplaza el no contar con un recurso a refereciar o con id de encuetro"
* encounter.identifier MS
* encounter.identifier ^short = "Identificador, en formato identifier para el encuentro"
* encounter.identifier ^definition = "Identificador, en su formato correspondiente, que reemplaza el uso de un recurso referenciado en caso de no contar con este"


//* --- Fecha -----
* date MS
* date ^short = "Fecha en la cual se editó el documento"
* date ^definition = "Fecha de edición del documento, cuando este fue modificado por el autor"
//* encounter

//* --- Author : referencia a un practitioner----
* author 1..1 
* author only Reference(Practitioner) 
* author MS
* author ^short = "Quien Ha creado el documento"
* author ^definition = "Identifica al responsable de los datos ingresados al documento, en este caso será el responsable del Resumen."


//* --- Titulo de documento -----
* title MS
* title ^short = "Título del documento generado"
* title ^definition = "Título oficial del documento para que pueda ser legible."

// Validador
* attester 0..* MS
* attester ^short = "Validadores del documento"
* attester ^definition = "Validadores del documento"
  * mode 1..1 MS
  * mode ^short = "Labor del Validador personal|profesional|legal|official"
  * mode from http://hl7.org/fhir/ValueSet/composition-attestation-mode 
  * time 0..1 MS
  * time ^short = "Fecha y Hora de la validación"
  * time ^definition = "Fecha y Hora de la validación"
  * party 0..1 MS
  * party ^short = "Quien validó"
  * party ^definition = "Quien validó"

* section 1.. MS

//----- division de secciones -------
* section ^slicing.discriminator[0].type = #pattern
* section ^slicing.discriminator[=].path = "code"
* section ^slicing.ordered = false
* section ^slicing.rules = #open

* section ^short = "Sección del documento"
* section ^definition = "Sección de notificación de datos clínicos."

* section.code 1.. MS
* section.code from http://hl7.org/fhir/ValueSet/doc-section-codes (example)


//--------- Secciones 
* section contains
    sectionDiagnosticos 0.. MS and
    sectionMedicamentos 0.. MS and
    sectionAlergias 0.. MS and
    sectionObservacionEmbarazo 0.. MS and
    sectionObservacionSignosVitales 0.. MS 
    
  

//------ 1. Diagnosticos------------

* section[sectionDiagnosticos] ^short = "Sección Diagnósticos"
* section[sectionDiagnosticos] ^definition = "Descripción de lista de diagnósticos determinados en el paciente."

* section[sectionDiagnosticos].code MS 
* section[sectionDiagnosticos].code = $loinc#11450-4

* section[sectionDiagnosticos].title 1.. MS

* section[sectionDiagnosticos].entry 1.. MS
* section[sectionDiagnosticos].entry only Reference(Condition)

* section[sectionDiagnosticos].entry ^slicing.discriminator[0].type = #profile
* section[sectionDiagnosticos].entry ^slicing.discriminator[=].path = "resolve()"
* section[sectionDiagnosticos].entry ^slicing.rules = #open
* section[sectionDiagnosticos].entry ^short = "Diagnósticos conocidos actualmente de relevancia para determinaciones clínicas en el paciente."

//------ 2. Medicamentos------------

* section[sectionMedicamentos] ^short = "Sección Medicamentos"
* section[sectionMedicamentos] ^definition = "Descripción de lista de medicamentos activos, consumidos o pendientes del paciente."

* section[sectionMedicamentos].code MS 
* section[sectionMedicamentos].code = $loinc#10160-0

* section[sectionMedicamentos].title 1.. MS

* section[sectionMedicamentos].entry 1.. MS
* section[sectionMedicamentos].entry only Reference(MedicationStatement)

* section[sectionMedicamentos].entry ^slicing.discriminator[0].type = #profile
* section[sectionMedicamentos].entry ^slicing.discriminator[=].path = "resolve()"
* section[sectionMedicamentos].entry ^slicing.rules = #open
* section[sectionMedicamentos].entry ^short = "Referencia al Medicamento Prescrito al paciente."


//------ 3. Alergias------------

* section[sectionAlergias] ^short = "Sección Alergias y Reacciones Adversas"
* section[sectionAlergias] ^definition = "Descripción de lista de Alergias y Eventos Adversos del Paciente, su grado de criticidad."

* section[sectionAlergias].code MS 
* section[sectionAlergias].code = $loinc#48765-2

* section[sectionAlergias].title 1.. MS

* section[sectionAlergias].entry 1.. MS
* section[sectionAlergias].entry only Reference(AllergyIntolerance)

* section[sectionAlergias].entry ^slicing.discriminator[0].type = #profile
* section[sectionAlergias].entry ^slicing.discriminator[=].path = "resolve()"
* section[sectionAlergias].entry ^slicing.rules = #open
* section[sectionAlergias].entry ^short = "Alergias e Intolerancia descrita"

//------ 4. Embarazos------------

* section[sectionObservacionEmbarazo] ^short = "Sección Antecedentes de Embarazo"
* section[sectionObservacionEmbarazo] ^definition = "Descripción de las condiciones clínicas de los embarazos."

* section[sectionObservacionEmbarazo].code MS 
* section[sectionObservacionEmbarazo].code = $loinc#10162-6

* section[sectionObservacionEmbarazo].title 1.. MS

* section[sectionObservacionEmbarazo].entry 1.. MS
* section[sectionObservacionEmbarazo].entry only Reference(Observation)

* section[sectionObservacionEmbarazo].entry ^slicing.discriminator[0].type = #profile
* section[sectionObservacionEmbarazo].entry ^slicing.discriminator[=].path = "resolve()"
* section[sectionObservacionEmbarazo].entry ^slicing.rules = #open
* section[sectionObservacionEmbarazo].entry ^short = "Descripción del antecedente de embarzo"

//------ 4. Signos Vitales y Mediciones Fisiológicas------------

* section[sectionObservacionSignosVitales] ^short = "Sección de Signos Vitales Medidos"
* section[sectionObservacionSignosVitales] ^definition = "Descripción de las mediciones fisiológicas hechas al paciente"

* section[sectionObservacionSignosVitales].code MS 
* section[sectionObservacionSignosVitales].code = $loinc#8716-3

* section[sectionObservacionSignosVitales].title 1.. MS

* section[sectionObservacionSignosVitales].entry 1.. MS
* section[sectionObservacionSignosVitales].entry only Reference(Observation)

* section[sectionObservacionSignosVitales].entry ^slicing.discriminator[0].type = #profile
* section[sectionObservacionSignosVitales].entry ^slicing.discriminator[=].path = "resolve()"
* section[sectionObservacionSignosVitales].entry ^slicing.rules = #open
* section[sectionObservacionSignosVitales].entry ^short = "Descripción del los signos vitales y mediciones desarrolladas"




