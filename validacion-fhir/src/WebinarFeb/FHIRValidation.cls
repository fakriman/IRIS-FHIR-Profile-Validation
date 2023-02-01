Include HS.FHIRServer

Class WebinarFeb.FHIRValidation [ Abstract ]
{

Parameter SkipIfNoProfileKEY = "/FHIR/Validation/SkipIfNoProfile";

Parameter JavaGatewayPortKEY = "/FHIR/Validation/JavaGatewayPort";

Parameter JavaGatewayServerKEY = "/FHIR/Validation/JavaGatewayServer";

Parameter IGListKEY = "/FHIR/Validation/IGList";

Parameter TerminologyServerKEY = "/FHIR/Validation/TerminologyServer";

Parameter PatientProfileKEY = "/FHIR/Validation/PatientProfile";

Parameter ProfileLocationKEY = "/FHIR/Validation/ProfileLocation";

ClassMethod validate(theResource As %DynamicObject)
{
	#dim skipIfNoProfile As %String = ##class(HS.Registry.Config).GetKeyValue(..#SkipIfNoProfileKEY)
	
	#dim noProfile As %Boolean = ('theResource.%IsDefined("meta") || 'theResource.meta.%IsDefined("profile") || (theResource.meta.profile.%Size() = 0))

	// skipIfNoProfile: only validate if profile is specified
	if +skipIfNoProfile && noProfile
	{
		quit
	}
		
	#dim javaGatewayPort As %String = ##class(HS.Registry.Config).GetKeyValue(..#JavaGatewayPortKEY)
	#dim javaGatewayServer As %String = ##class(HS.Registry.Config).GetKeyValue(..#JavaGatewayServerKEY)
	#dim igList As %String = ##class(HS.Registry.Config).GetKeyValue(..#IGListKEY)
	#dim terminologyServer As %String = ##class(HS.Registry.Config).GetKeyValue(..#TerminologyServerKEY)
	#dim patientProfile As %String = ##class(HS.Registry.Config).GetKeyValue(..#PatientProfileKEY)
	#dim profileLocation As %String = ##class(HS.Registry.Config).GetKeyValue(..#ProfileLocationKEY)
	
	#dim profileToValidateAgainst As %String = ""
	if noProfile 
			&& (theResource.resourceType = "Patient") 
			&& (patientProfile '= "")
	{
		set profileToValidateAgainst = patientProfile
	}	
	
	// check if Java Gateway is up
	#dim sc As %Status = ##class(%Net.Remote.Service).PingGateway(javaGatewayPort, javaGatewayServer)
	if $$$ISERR(sc)
	{
		// assuming this is local gateway, try to start it
		// Alternativa iniciar GW desde SO:
		// Set sc = $ZF(-100,"/ASYNC","/opt/irisapp/jdk-11.0.1/bin/java", "-Xrs", "-Djava.system.class.loader=com.intersystems.gateway.ClassLoader", "-classpath", "/opt/irisapp/validacion-fhir/lib/JavaValidatorFacade.jar:/opt/irisapp/validacion-fhir/lib/validator_cli.jar:/usr/irissys/dev/java/lib/1.8/intersystems-jdbc-3.6.1.jar", "com.intersystems.gateway.JavaGateway", "53272", """fhirsrv:IRIS:%Java Server""", "127.0.0.1") 
		$$$ThrowOnError(##class(%Net.Remote.Service).StartGateway("%Java Server"))
		set sc = $$$OK
	}

	// connect to gateway
	// #dim gw As %Net.Remote.Gateway = ##class(%Net.Remote.Gateway).%New()
	// $$$ThrowOnError(gw.%Connect(javaGatewayServer, javaGatewayPort))
	$$$ThrowOnError($system.external.getGateway("%Java Server"))
	// generate proxy class if it's not present
	set gw = $system.external.getGateway("%Java Server")

	if '$$$comClassDefined("WebinarFeb.JavaValidatorFacade")
	{
		// do ##class(%Net.Remote.Java.JavaGateway).%ExpressImport("SEMeeting2022.JavaValidatorFacade", javaGatewayPort, javaGatewayServer, $$$YES)
		Set status=gw.%Import("WebinarFeb.JavaValidatorFacade",.classes) 
	}

	// create temporary file with the resource
	#dim file As %Stream.FileCharacter = ##class(%Stream.FileCharacter).%New()
	set file.TranslateTable = "UTF8"
	do theResource.%ToJSON(file)
	do file.Flush()

	// run FHIR validator against the file
	#dim json As %String = ""
	try
	{
		$$$FSLog("About to call Java validator...")
		// set json = ##class(WebinarFeb.JavaValidatorFacade).validate(gw, igList, file.Filename, terminologyServer, profileToValidateAgainst)
		set json = ##class(WebinarFeb.JavaValidatorFacade).validate(gw, profileLocation, file.Filename, terminologyServer)
		
	}
	catch ex
	{
		set sc = $get(%objlasterror)  // exception with Java stack here!
		if (sc = "") set sc = ex.AsStatus()
	}
	kill file  // the file gets deleted here as we've never %Save()d it!

	$$$ThrowOnError(sc)


	// assemble error status in case of any severity=error issues
	#dim operationOutcome As %DynamicObject = {}.%FromJSON(json)

	#dim errorStatus As %Status = $$$OK
	#dim iter As %Iterator.Object = operationOutcome.issue.%GetIterator()
	#dim issue As %DynamicObject
	
	while iter.%GetNext(.key, .issue) 
	{
		if (issue.severity = "error")
		{
			#dim oneError As %Status = $$$ERROR($$$GeneralError, issue.details.text, $$$OutcomeWithPath(400, "error", issue.code, issue.expression.%Get(0)))
			
			$$$FHIRAddError(errorStatus, oneError)
			
			If ( $FIND(issue.details.text, "document must have an identifier")  ){
				set errorStatus = $$$OK
			}
		}
	}

	$$$ThrowOnError(errorStatus)
}

}
