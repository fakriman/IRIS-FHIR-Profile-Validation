Profile:        CoreEspecialidadCl
Parent:         PractitionerRole
Id:             CoreEspecialidadCl
Title:          "CL RolClinico"
Description:    "Este Perfil ha sido desarrollado para cubrir las necesidades del Caso de Uso de Receta Electrónica. Sin embargo, se ha modelado con el fin de cubrir las necesidades nacionales de un Recurso de Especialidad Médica para la denominación de Prescriptor en Chile"

* active = true

* period ^short = "El período durante el cual el profesional está autorizado a desempeñar estas funciones."
* period ^definition = "El período durante el cual la persona está autorizada a actuar como profesional en estas funciones para la organización."
* period.start ^short = "Fecha y Hora del inicio de las funciones especificadas."
* period.start ^definition = "Fecha y Hora del inicio de las funciones especificadas."
* period.end ^short = "Fecha y Hora del término de las funciones especificadas."
* period.end ^definition = "Fecha y Hora del término de las funciones especificadas."

* practitioner and practitioner.reference MS
* practitioner 1..1
* practitioner ^short = "Referencia al Prestador  especialidad"
* practitioner ^definition = "La referencia al prestador de salud, al cual se le quieren asignar funciones o actividades de especialidad."
* practitioner.reference ^short = "Referencia al uri del recurso Practitioner del prestador en cuestión"
* practitioner.reference ^definition = "La referencia es una URI comunmente, la cual hace referencia al Prestador en cuestion"	
* practitioner.display ^short = "Nombre del prestador de salud"
* practitioner.display ^definition = "Nombre completo del prestador de salud"

* organization and organization.reference MS
* organization 0..1
* organization ^short = "Referencia a la organización donde el presador cumple roles"
* organization ^definition = "La referencia a la organización en donde el prestador individual cumple roles."
* organization.reference ^short = "Referencia al uri del recurso organization del prestador en cuestión"
* organization.reference ^definition = "La referencia es una URI comunmente, la cual hace referencia al organización en cuestion"	
* organization.display ^short = "Nombre de la organización de salud"
* organization.display ^definition = "Nombre completo de la organización de salud"

* location and location.reference MS
* location 0..1
* location ^short = "Referencia a la ubicación donde el presador cumple roles"
* location ^definition = "La referencia a la ubicación en donde el prestador individual cumple roles."
* location.reference ^short = "Referencia al uri del recurso location del prestador en cuestión"
* location.reference ^definition = "La referencia es una URI comunmente, la cual hace referencia a la ubicación en cuestion"	
* location.display ^short = "Nombre de la ubicación"
* location.display ^definition = "Nombre completo de la ubicación de salud"


* specialty MS
* specialty 1..*
* specialty ^short = "Definición de la especialidad médica según DEIS"
* specialty ^definition = "Definición de la especialidad médica según DEIS, en el decreto correspondiete. la tabla sigue siendo extensible ante futuros elementos agregados a esta"
* specialty.coding.code  from VSEspecialidadesDeisCL (required)
* specialty.coding.code ^binding.description = "Códigos de Especialidad DEIS" 




