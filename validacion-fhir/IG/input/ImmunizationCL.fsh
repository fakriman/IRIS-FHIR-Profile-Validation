Profile: ImmunizationCL
Parent: Immunization
Id: ImmunizationCL
Title: "CL Inmunización"
Description: "Definición de un evento de inmunización para las necesidades de interoperabilidad en Chile."


* identifier 0..* MS
* identifier ^short = "Identificador(es) por los que se conoce este registro de Inmunización"
* identifier ^definition = "Es el número de identificación del evento donde a un paciente se le administra una vacuna o registro de inmunización" 

* patient 1..1 MS
* patient only Reference (PacienteCl)
* patient ^short = "Quién fue inmunizado"
* patient ^definition = "El paciente que recibió o no recibió la inmunización"

* performer 1..1 MS
* performer ^short = "Quién realizó el evento"
* performer ^definition = "Indica quién realizó el evento de inmunización"
* performer.actor 1..1 MS
* performer.actor only Reference (PrestadorCL or OrganizacionCL)
* performer.actor ^short = "Practicante u organización que realizó la acción"
* performer.actor ^definition = "Practicante u organización que realizó la acción"

* programEligibility 0..* MS
* programEligibility ^short = "Indica la elegibilidad de un paciente para un programa de financiamiento"
* programEligibility ^definition = "Indica la elegibilidad de un paciente para un programa de financiamiento"
* programEligibility from http://hl7.org/fhir/ValueSet/immunization-program-eligibility (example)

* vaccineCode 1..1 MS
* vaccineCode ^short = "Vacuna que se administró o se iba a administrar"
* vaccineCode ^definition = "Vacuna que se administró o se iba a administrar. Se proporciona valores que utilizan en el RNI (Registro Nacional de Inmunizaciones)"
* vaccineCode.extension ^short = "Nombre de vacuna administrada"
* vaccineCode.extension contains TiposVacunaCL named tipov 1..1 

* extension contains NombreCampanaCL named campana 1..1

* lotNumber 0..1 MS
* lotNumber ^short = "Número de lote de la vacuna"
* lotNumber ^definition = "Número de lote del producto de la vacuna"

* expirationDate 1..1 MS
* expirationDate ^short = "Fecha de caducidad de la vacuna"
* expirationDate ^definition = "Fecha de vencimiento del lote de la vacuna"

* protocolApplied 0..1 MS
* protocolApplied ^short = "Protocolo seguido por el proveedor"
* protocolApplied ^definition = "El protocolo (conjunto de recomendaciones) que sigue el proveedor que administró la dosis"
* protocolApplied.doseNumberString 1..1 MS
* protocolApplied.doseNumberString ^short = "Número de dosis dentro de la serie"

* occurrenceDateTime  1..1 MS
* occurrenceDateTime ^short = "Fecha de administración de la vacuna" 
* occurrenceDateTime ^definition = "Fecha y hora en la que se realiza la inmunización o se administra la vacuna"

* recorded 0..1 MS
* recorded ^short = "Cuando la inmunización se capturó por primera vez en el registro del sujeto"
* recorded ^definition = "La fecha en que se registró por primera vez la ocurrencia de la inmunización, potencialmente significativamente después de la ocurrencia del evento"

* status 1..1 MS
* status ^short = "completed | entered-in-error | not-done"
* status ^definition = "Indica el estado actual del evento de inmunización"

* statusReason 0..1 MS
* statusReason ^short = "Razón de no realizarse la inmunización"
* statusReason ^definition = "Indica la razón por la que no se realizó el evento de inmunización"
* statusReason.extension ^short = "Motivo de no realizar la inmunización"
* statusReason.extension contains RazonNOTinmunizacionCL named statusReason 1..1

* reaction 0..* MS
* reaction ^short = "Detalles de una reacción que proviene de la inmunización"
* reaction.date 0..1 
* reaction.date ^short = "Cuándo comenzó la reacción"
* reaction.date ^definition = "Fecha de reacción a la inmunización"

* location 1..1 MS
* location ^short = "Dónde se produjo la inmunización"
* location ^definition = "El lugar donde se produjo la administración de la vacuna"
* location only Reference (LocalizacionCL)

* location.extension ^short = "Extensión para los Sistemas de Salud, por ejemplo: S.S Viña del mar Quillota"
* location.extension contains ServicioSaludCL named ssalud 1..1 



