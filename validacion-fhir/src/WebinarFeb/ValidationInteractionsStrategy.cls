Include HS.HC

Class WebinarFeb.ValidationInteractionsStrategy Extends HS.FHIRServer.Storage.Json.InteractionsStrategy
{

Parameter StrategyKey As %String = "Json";

Parameter StrategyDesc As %String = "All Resources stored in a single table as Json text";

Parameter AllResourcesTypeName As %String [ Internal ] = "Rsrc";

Parameter InteractionsClass As %String = "WebinarFeb.ValidationInteractions";

Parameter ResourceSuperclass As %String = "HS.FHIRServer.Storage.Json.Resource";

Parameter ResourceVersionSuperclass As %String = "HS.FHIRServer.Storage.Json.ResourceVer";

/// A %DynamicObject that contains configuration properties for this instance 
/// (which is both Strategy-Type and MetadataSet specific)
/// The Json strategy configures 4 names for instance-private persistent storage:
/// <br> searchClassesPackage = The package name into which search classes will be generated
/// <br> resourceClassesPackage = The package name into which resource classes will be generated
/// <br> globalRoot = The $name of a global node to be used for instance-private configuration
/// <br> globalTempRoot = The $name of a temporary global node to be used for instance-private configuration.  The
/// data in this node will be reset when the instance is stopped.
Property config As %DynamicObject [ Private ];

/// @API<br>
/// Return a CapabilityStatement metadata resource. The returned content is derived from
/// a strategy-specific means of formulating a CapabilityStatement. An example use of the
/// output might be to store the CapabilityStatement for a given Service.<br>
/// This method should not be confused with the Interactions class LoadMetadata() method,
/// which retrieves the stored CapabilityStatement for the current Service.
Method GetMetadataResource() As %DynamicObject
{
	// Start with the static configuration and add dynamic elements
	#dim capabilityConfig as %DynamicObject = ..GetCapabilityConfig()
	
	// 1) Get Operation list from the OperationHandler
	#dim interactions as HS.FHIRServer.API.Interactions = ..NewInteractionsInstance()
	Set operationProcessorClass = interactions.#OperationHandlerClass
	
	Set operationMap = $$$NewJSONObject
	Do $ClassMethod(operationProcessorClass, "AddSupportedOperations", operationMap)
	Set capabilityConfig.operations = operationMap
	
	
	Return ##class(HS.FHIRServer.Tools.CapabilityStatementBuilder).Build(..schema, ..GetCapabilityTemplate(), capabilityConfig)
}

/// @API - 
/// NOTE: This method is defined in the HS.FHIRServer.Storage.Json.InteractionsStrategy class.  Subclasses may
/// override.
Method GetCapabilityTemplate() As %DynamicObject
{
	Set json = {
		  "resourceType": "CapabilityStatement",
		  "id": "InterSystemsFHIRServer",
		  "meta": {
		    "versionId": "1",
	    	"lastUpdated": ($zdatetime($horolog,3,7))  //replaced at runtime, but must match 'instant' syntax
		  },
		  "url": "<replaced-at-runtime>",
		  "version": "1",
		  "name": "InterSystems FHIR Server CapabilityStatement",
		  "status": "active",
		  "experimental": false,
		  "date": ($zdate($horolog, 3)),
		  "publisher": "InterSystems Corporation",
		  "kind": "instance",
		  "software": {
		    "name": ("InterSystems " _ $select(##class(%ZHSLIB.HealthShareMgr).InstanceType()=$$$HSisHealthShare:"HealthShare Unified Care Record",
		    								##class(%ZHSLIB.HealthShareMgr).InstanceType()=$$$HSisIRISforHealth:"IRIS for Health",
		    								##class(%ZHSLIB.HealthShareMgr).InstanceType()=$$$HSisHealthConnect:"Health Connect",
		    								1:"")),
		    "version": (##class(%ZHSLIB.HealthShareMgr).VersionInfo())
		  },
		  "implementation": {
		    "description": "InterSystems FHIR Server",
		    "url": "<replaced-at-runtime>"
		  },
		  "fhirVersion": "<replaced-by-builder>",
		  "acceptUnknown": "no",
		  "format": [
		    "xml",
		    "json"
		  ],
		  "patchFormat": [
		  	"application/json-patch+json"
		  ],
		  "rest": [
		  ]
	}
	return json
}

Method GetCapabilityConfig() As %DynamicObject
{
	Set json = {
		"general-Documentation": [
			"This object controls the generation of a Metadata resource"
		],
		
		"paramExclude-Documentation": [
			"Each Entry represents a search parameter in the form of:"
			, "   <ResourceType>.<paramName> "
			, "that we do NOT want to support in the generated Metadata resource."
		],

		"paramExclude": [
			"Resource._content",
			"Resource._query"
		],
		
		"resourceDefaults-Documentation": [
			"These are the default values to apply to each resource added to the",
			"Metadata resource."
		
		],
		
		"resourceDefaults": {
			"interactions": [
				"read",
				"vread",
				"create",
				"update",
				"patch",
				"delete",
				"history-instance",
				"search-type"
			],
			"versioning": "versioned",
			"readHistory": false,
			"updateCreate": true,
			"conditionalCreate": true,
			"conditionalRead": "not-supported",
			"conditionalUpdate": true,
			"conditionalDelete": "multiple"
		},
		
		"resourceOverrides-Documentation": [
			"Add an object with a resource name as a key.  Properties of the object",
			"will override the default value for all resources.  The first use is",
			"an override to the CapabilityStatement resource to indicate that only READ is allowed"
		],
		
		"resourceOverrides": {
			"CapabilityStatement": {
				"interactions": [
					"read"
				]
			},
			"Binary": {
	            "interactions": [
	                "read",
	                "vread",
	                "create",
	                "update",
	                "delete",
	                "history-instance",
	                "search-type"
	            ]
			},
			"Resource": {
				"interactions": [
					"transaction"
				]
			}
			
		},
		
		"resourceList-Documentation": [
			"If present, this is the inclusive list of Resources to be supported by this",
			"Metadata object.  If not present, all resources in the schema are included"
		],
		"resourceListX": [
			"Patient", "Encounter"
		]
	
	}
	return json
}

/// @API
/// Returns field metadata for a field corresponding to a search parameter, returns $listbuild(fieldName, isCollection,...)
Method GetFieldMetdata(pSearchParam As HS.FHIRServer.SearchParam) As %CacheString
{
	// Set ^FVAL("GetFieldMetdata") = 1
	//
	set fieldName = ##class(HS.FHIRServer.Util.FHIRQueryUtils).NormalizeParamName(pSearchParam.code)
	quit $listbuild(fieldName, pSearchParam.isMultiValue)
}

/// @API Creates an instance of the Interactions handler object
Method NewInteractionsInstance() As HS.FHIRServer.API.Interactions
{
	// Set ^FVAL("NewInteractionsInstance") = 1
	return $classmethod(..#InteractionsClass,"%New", $this)
}

Method isBitmap(pSearchParam As HS.FHIRServer.SearchParam)
{
	#dim tAllowedElementTypes = ",CodeableConcept,Coding,code,boolean,"
 	#dim tNumConceptsMax = 117 //??

	if $ll(pSearchParam.datatypes)>1 quit 0
	if (pSearchParam.name="address-state")||(pSearchParam.name="address-country") quit 1
	if (pSearchParam.type'="token") quit 0
	set dt=$lg(pSearchParam.datatypes)
	if (tAllowedElementTypes '[ (","_dt_",")) quit 0
	if ..schema.GetValueSetCardinality(pSearchParam.resourceType,pSearchParam.expression)=-1 quit 0
	if ..schema.GetValueSetCardinality(pSearchParam.resourceType,pSearchParam.expression)>tNumConceptsMax quit 0
	quit 1
}

Method MigrateFromPre2020(ByRef options) As %Integer
{
	Set interactions = ..NewInteractionsInstance()
	Set fromStorageClass = $Get(options("storageClass"), "HS.FHIR.vSTU3.Repository.Resource.Abstract")

	Set fromTableName = $translate($piece(fromStorageClass, ".", 1, *-1), ".", "_") _ "." _ $piece(fromStorageClass,".",*)
	Set toTableName = ..GetResourceTable("")
	Set rsrcClassname = ..GetResourceClass("")
	Set versionClassname = ..GetResourceVersionClass("")
	#dim toObj as HS.FHIRServer.Storage.Json.ResourceVer
	
	Set queryString = "SELECT * FROM "_fromTableName _ " order by ResourceType asc, ResourceId asc, VersionId desc"
	w "Cloning from Table: ",fromTableName,!
	#dim tResult as %SQL.StatementResult = ##class(%SQL.Statement).%ExecDirect(,queryString)
	try {
		Set prevKey = ""
			TSTART
		while tResult.%Next() {
			Set resourceType = tResult.%Get("ResourceType")
			Set resourceId = tResult.%Get("ResourceId")
			Set key = $$$BuildRsrcKey(resourceType, resourceId)
			
			if key = prevKey {
				// A lower version of the same resource, include version # in the key
				Set toObj = $classmethod(versionClassname, "%New")
				// w "ver: ",key,!
			} else {
				Set toObj = $classmethod(rsrcClassname, "%New")
				// Only the current resources maintain compartment associations
				Set list = tResult.%Get("Compartments")
				for cix=1:1:$LL(list) {
					Do toObj.Compartments.Insert($LG(list, cix))	
				}
				// w "cur: ",key,!
			}
			Set toObj.Key = key
			Set toObj.ResourceType = resourceType
			Set toObj.ResourceId = resourceId
			
			for name = "VersionId", "Deleted", "LastModified", "Verb", "Format", "ResourceString" {
				Set $Property(toObj, name) = tResult.%Get(name)
			}
			Set inStream = tResult.%Get("ResourceStream")
			if inStream '= "" {
				Set $Property(toObj, name) = inStream
			}
			try {
				$$$ThrowOnError( toObj.%Save()) 
				if key '= prevKey {
					// Index current versions only
					Do interactions.IndexResource(toObj)
				}
				w "Saved: ", key, " | ", toObj.Key, !
			} catch exx {
				w "Save Failed: ", key, " | ", toObj.Key, $system.Status.DisplayError(exx.AsStatus()), !			
			}
			Set prevKey = key
			
		}
		TCOMMIT
	} catch ex {
		TROLLBACK 1
		throw ex
	}
	w "Converted ",tResult.%ROWCOUNT," objects",!
	
	return tResult.%ROWCOUNT
}

}
