codeunit 80292 "PVS SM Install"
{
    Access = Internal;
    Subtype = Install;


    trigger OnInstallAppPerDatabase()
    var
        MyAppInfo: ModuleInfo;
    begin
        NavApp.GetCurrentModuleInfo(MyAppInfo);
        this.AllowHttpRequests(MyAppInfo.Id);
    end;


    local procedure AllowHttpRequests(in_AppID: Guid)
    var
        NAVAppSetting: Record "NAV App Setting";
    begin
        if NAVAppSetting.Get(in_AppID) then begin
            NAVAppSetting."Allow HttpClient Requests" := true;
            NAVAppSetting.Modify();
        end else begin
            Clear(NAVAppSetting);
            NAVAppSetting."App ID" := in_AppID;
            NAVAppSetting."Allow HttpClient Requests" := true;
            NAVAppSetting.Insert();
        end;
    end;
}