Class WebinarFeb.FHIRBundleValidator Extends HS.FHIRServer.Util.BundleValidator
{

ClassMethod ValidateBundle(pResourceObject As %DynamicObject, pFHIRVersion As %String)
{
    do ##super(pResourceObject, pFHIRVersion)
    do ##class(WebinarFeb.FHIRValidation).validate(pResourceObject)
}

}
