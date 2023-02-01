Include HS.FHIRServer

Class WebinarFeb.ValidationInteractions Extends HS.FHIRServer.Storage.Json.Interactions
{

Parameter ResourceValidatorClass = "WebinarFeb.FHIRResourceValidator";

// Parameter OperationHandlerClass As %String = "HS.FHIRServer.Storage.BuiltInOperations";

// Parameter OperationHandlerClass As %String = "WebinarFeb.FHIROperationHandler";

// Parameter BatchHandlerClass As %String = "HS.FHIRServer.Storage.Json.BundleProcessor";

Parameter BatchHandlerClass As %String = "WebinarFeb.FHIRBundleProcessor";

/// %inTransactionFlag is a global variable indicating that we are processing a Bundle
///   if set, FHIRResourceValidator skips validation of Bundle entries
Method StartTransactionBundle(pBundleTransactionId As %Integer)
{
	do ##super(pBundleTransactionId)
	set %inTransactionFlag = $$$YES
}

Method EndTransactionBundle()
{
	kill %inTransactionFlag
	do ##super()
}

}
