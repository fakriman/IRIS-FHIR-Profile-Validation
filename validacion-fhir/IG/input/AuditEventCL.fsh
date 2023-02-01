Alias: $auditevent = http://minsal.cl/auditevent

Profile: AuditEventCl
Parent: AuditEvent
Id: AuditEventCl
Title: "CL Auditoria"
Description: "Perfil para genererar un recurso que permita desarrollar logs de auditoría en cuanto al acceso y manejo de recursos FHIR"

* type MS
* type ^short = "Tipo/identificación del Evento"
* type ^definition = "Identificador de una familia del evento. Por ejemplo, un elemento de menú, un programa, una regla, una política, un código de función, un nombre de aplicación o una URL. Identifica la función realizada."
* type from http://hl7.org/fhir/ValueSet/audit-event-type (extensible)
* type ^binding.description = "Eventos de auditoría descritos en DICOM"
* type.system  MS


* type.system ^short = "CodeSystem de los códigos para tipo de Evento"
* type.system ^definition = "Es el Sistema de Codificación sugerido por FHIR extensible a necesidades locales"

* type.code = #rest (exactly)
* type.code MS
* type.code ^short = "Código del tipo de registro"
* type.code ^definition = "Se obliga, dado el alcance de los primeros proyectos FHIR a que sea Rest"
* type.display MS
* type.display ^short = "RESTful Operation"
* type.code ^definition = "Display del código del ejemplo"

* subtype 0..* MS
* subtype ^short = "Especificacion mas detallada del evento"
* subtype ^definition = "Nivel mayor de profundidad del evento"
* subtype.system  MS

* subtype.system ^short = "Sistema de Códigos"
* subtype.system ^definition = "Sistema de ejemplo de códigos que describen con mas detalle el evento"
* subtype.code 1.. MS
* subtype from http://hl7.org/fhir/ValueSet/audit-event-sub-type (extensible)
* subtype ^binding.description = "Códigos de DICOM"

* subtype.code ^short = "Codigo"
* subtype.code ^definition = "Codigo del Subtipo"
* subtype.display MS
* subtype.display ^short = "Nombre de la desripción del evento"
* subtype.display ^definition = "Nombre de la desripción del evento"


* action 1..1 MS
* action from  http://hl7.org/fhir/ValueSet/audit-event-action (required)
* action ^binding.description = "Códigos fijos extraídos de DICOM"
* action ^short = "Create| Read/View/Print | Update | Delete | Execute"
* action ^definition = "Código de la acción"
* period 0.. MS


* recorded 1..1 MS
* recorded ^short = "Momento cuando el evento fue guardado"
* recorded ^definition = "Momento cuando el evento fue guardado"

* outcome 0..1 MS
* outcome ^short = "Resultado de la operación"
* outcome from http://hl7.org/fhir/ValueSet/audit-event-outcome
* outcome ^binding.description = "Códigos extraídos de DICOM" 

* agent 1..* MS
* agent ^short = "Quienes actuaron en el evento"
* agent ^definition = "Mínimo debe indicar quien requirió del recurso"
* agent.who 1..1 MS 
* agent.who ^short = "Quien realizó la acción"
* agent.who ^definition = "Referencia al recurso o Identificación de quien realizó la acción"
* agent.requestor ^short = "indicador de si Who es quien requirió la acción"
* agent.requestor ^definition = "indicador de si Who es quien requirió la acción"
* agent.network 0..1 MS
* agent.network ^short = "Ubicación de la Red de la Aplicación"
* agent.network ^definition = "Ubicación de red lógica para la actividad de la aplicación, si la actividad tiene una ubicación de red."
* agent.network.address 1..1 MS
* agent.network.address ^short = "Dirección del Punto de Acceso"
* agent.network.address ^definition = "Un identificador para el tipo de punto de acceso a la red que originó el evento de auditoría."
* agent.network.type 0..1 MS
* agent.network.type ^short = "Código del tipo de identificación"
* agent.network.type ^definition = "Un tipo de identificador para el tipo de punto de acceso a la red que originó el evento de auditoría."
* agent.network.type from http://hl7.org/fhir/ValueSet/network-type (required)
* agent.network.type ^binding.description = "Códigos extraídos de DICOM" 

* source 1..1 MS
* source ^short = "Quien reporta el evento"
* source ^definition = "Sitio en donde se reporta el evento"
* source.observer 1..1 MS 
* source.observer ^short = "Entidad que reporta el evento"
* source.observer ^definition = "Identificación del Observador donde se reportó el evento"


* entity 1..1 MS 
* entity ^short = "Entidad que registra la ocurrencia del Evento"
* entity ^definition = "Entidad que registra la ocurrencia del Evento"
* entity.what 1..1 MS
* entity.what ^short = "Recurso o identificación de la entidad que registra la ocurrencia del evento"
* entity.what ^definition = "Recurso o identificación de la entidad que registra la ocurrencia del evento"


