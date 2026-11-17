namespace PrintVis.BoldSign.Common;

using Microsoft.Utilities;
using PrintVis.BoldSign.Configuration;

codeunit 80301 "PVS BS Subscribers"
{
    Access = Internal;
    SingleInstance = true;

    [EventSubscriber(ObjectType::Table, Database::"Service Connection", 'OnRegisterServiceConnection', '', true, false)]
    local procedure ServiceConnectionOnRegisterServiceConnection(var ServiceConnection: Record "Service Connection")
    var
        BoldSignSetup: Record "PVS BS Service Setup";
        BoldSignTok: Label 'BoldSign Setup', Locked = true;
    begin
        BoldSignSetup.Initialize();
        if BoldSignSetup.Enabled then
            ServiceConnection.Status := ServiceConnection.Status::Enabled
        else
            ServiceConnection.Status := ServiceConnection.Status::Disabled;

        ServiceConnection.InsertServiceConnection(ServiceConnection,
            BoldSignSetup.RecordId(),
            BoldSignTok,
            '',
            Page::"PVS BS Service Setup");
    end;

}