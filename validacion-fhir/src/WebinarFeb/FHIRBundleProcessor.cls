Class WebinarFeb.FHIRBundleProcessor Extends HS.FHIRServer.Storage.Json.BundleProcessor
{

/// Class that provides the FHIR Bundle resource validation logic for this Bundle processing
/// class. The class is intended to handle Bundle-specific validation, i.e., the rules
/// applying to transaction, batch, document, and message Bundles.
Parameter BundleValidatorClass = "WebinarFeb.FHIRBundleValidator";

}
