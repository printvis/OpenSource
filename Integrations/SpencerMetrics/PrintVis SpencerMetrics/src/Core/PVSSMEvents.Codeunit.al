namespace PrintVis.SpencerMetrics;

codeunit 80291 "PVS SM Events"
{
    Access = Public;

    /// <summary>
    /// Integration event to mock the web request.
    /// </summary>
    /// <param name="in_ServiceAction">The service action.</param>
    /// <param name="out_Response">The response.</param>
    /// <param name="out_Handled">The handled flag.</param>
    [IntegrationEvent(false, false)]
    procedure OnMockWebRequest(in_ServiceAction: Text; var out_Response: Text; var out_Handled: Boolean)
    begin
    end;
}