Profile: ClAddress
Parent: Address
Id: cl-address
Title: "CL Address"
Description: "Variable dirección"
* ^version = "1.0.0"
* . ^comment = "Variable dirección"
* . ^short = "Tipo de dato para agragar la dirección de un paciente"
* extension ^slicing.discriminator.type = #value
* extension ^slicing.discriminator.path = "url"
* extension ^slicing.rules = #open
* extension ^definition = "Formato Chileno para la definición de direcciones"

* use 0..1 MS
* use ^short = "Definición del tipo de domicilio home | work | temp | old (requerido)"
* use ^definition = "Se especifica el tipo de dirección notificada. Esto debe ser segun los códigos definidos por HL7 FHIR"
 
* line 0..1 MS
* line ^short = "Calle o avenida, numero y casa o depto"
* line ^definition = "Aquí se escribe toda la dirección completa"

* city ^short = "Campo para Comuna de residencia"
* city ^definition = "Campo para Comuna de residencia."
* city 1..1 MS
* city.extension contains ComunasCl named comunas 1..1  MS
* city.extension ^short = "Código de Comunas"
* city.extension ^definition = "Código de Comunas"
//* city.extension.comunas.valueCode MS

* district ^short = "Campo para Provincia de Residencia"
* district ^definition = "Campo para Provincia de Residencia. Se usa el valueSet de códigos de provicias definidos a nivel naciona."
* district  1..1 MS
* district.extension contains ProvinciasCl named provincias  1..1  MS
* district.extension ^short = "Código de Regiones"
* district.extension ^definition = "Código de Regiones"

* state ^short = "Campo para la Región"
* state ^definition = "Campo Región. Se usa el valueSet de códigos de regiones definidos a nivel naciona."
* state  1..1 MS
* state.extension contains RegionesCl named regiones  1..1  MS
* state.extension ^short = "Código de Regiones"
* state.extension ^definition = "Código de Regiones"


* country ^short = "Campo para País de Residencia"
* country ^definition = "Campo para País de Residencia"
* country 1..1 MS
* country.extension contains CodigoPaises named paises  1..1  MS
* country.extension ^short = "Código de Países"
* country.extension ^definition = "Código de Países"
