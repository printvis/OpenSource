/* codeunit 80211 "PTE UPgrade Logic Part 3"
{
    procedure PVS_Job_Sheet_Move_To_UPG()
    var
        PVSJobSheet: Record "PVS Job Sheet";
        UPG: Record "PVS UPG ACAD Job Sheet Ext";
    begin

        UPG.Reset();
        if UPG.IsEmpty then
            exit;

        UPG.Findset(false);
        repeat
            PVSJobSheet.Reset();
            PVSJobSheet.SetRange("Sheet ID", UPG."Sheet ID");
            if PVSJobSheet.FindFirst() then begin
                PVSJobSheet."PVS Mfg. Sheet No." := UPG."PVS Mfg. Sheet No.";
                PVSJobSheet.Modify(false);
            end;
        until UPG.Next() = 0;
    end;

    procedure PVS_CIM_Controller_Move_To_UPG()
    var
        CimController: Record "PVS CIM Controller";
        UPG: Record "PVS UPG CIM Controller";
    begin
        if UPG.IsEmpty then
            exit;
        UPG.FindSet();
        repeat

            CimController.Code := UPG.Code;
            CimController."Workflow Partner Name" := UPG."Workflow Partner Name";
            CimController.Description := UPG.Description;
            CimController."Hot Folder Incoming" := UPG."Hot Folder Incoming";
            CimController."Target URL" := UPG."Target URL";
            CimController.Port := UPG.Port;
            CimController."Receiving Method" := UPG."Receiving Method";
            CimController."Submission Method" := UPG."Submission Method".AsInteger();
            CimController."MIME Packaging" := UPG."MIME Packaging";
            CimController.Closed := UPG.Closed;
            CimController."CIM System" := UPG."CIM System".AsInteger();
            CimController."Receive Detail Level" := UPG."Receive Detail Level";
            CimController."JDF Structure" := UPG."JDF Structure";
            CimController."Workflow Submission" := UPG."Workflow Submission";
            CimController."Private Namespace" := UPG."Private Namespace";
            CimController."Resubmission Allowed" := UPG."Resubmission Allowed";
            CimController."Subscription Method" := UPG."Subscription Method";
            CimController."No. Of Submission Retries" := UPG."No. Of Submission Retries";
            CimController."SM Hot Folder" := UPG."SM Hot Folder";
            CimController."SM File Schema Support" := UPG."SM File Schema Support";
            CimController."SM FTP Schema Support" := UPG."SM FTP Schema Support";
            CimController."SM HTTP Schema Support" := UPG."SM HTTP Schema Support";
            CimController."SM HTTPS Schema Support" := UPG."SM HTTPS Schema Support";
            CimController."SM MIME Packaging Support" := UPG."SM MIME Packaging Support";
            CimController."Sender ID" := UPG."Sender ID";
            CimController."Subscribed To Status" := UPG."Subscribed To Status";
            CimController."Subscribed To Resource" := UPG."Subscribed To Resource";
            CimController."Subscribed To Events" := UPG."Subscribed To Events";
            CimController."Subscribed To Notifications" := UPG."Subscribed To Notifications";
            CimController."Clean Org. Name" := UPG."Clean Org. Name";
            CimController."Paper Media Partioned" := UPG."Paper Media Partioned";
            CimController."Plate Media Partioned" := UPG."Plate Media Partioned";
            CimController."Position Type" := UPG."Position Type";
            CimController."Preview Separation Node" := UPG."Preview Separation Node";
            CimController."Preview Thumbnail Node" := UPG."Preview Thumbnail Node";
            CimController."Preview Sep. Thumbnail Node" := UPG."Preview Sep. Thumbnail Node";
            CimController."Media Intent Dim. Node" := UPG."Media Intent Dim. Node";
            CimController."JDF ProductTypeDetails Value" := UPG."JDF ProductTypeDetails Value";
            CimController."JDF ProductTypeDetails Buildup" := UPG."JDF ProductTypeDetails Buildup";
            CimController."JDF GeneralID ProductClass" := UPG."JDF GeneralID ProductClass";
            CimController."JDF GeneralID ProductionType" := UPG."JDF GeneralID ProductionType";
            CimController."Format Contact Names" := UPG."Format Contact Names";
            CimController."HTTP Use" := UPG."HTTP Use";
            CimController."JMF AcknowledgeURL Attribute" := UPG."JMF AcknowledgeURL Attribute";
            CimController."JMF WatchURL Attribute" := UPG."JMF WatchURL Attribute";
            CimController."JMF ResubmitQueue Supported" := UPG."JMF ResubmitQueue Supported";
            CimController."Job Ticket ID" := UPG."Job Ticket ID";
            CimController."File Type" := UPG."File Type";
            CimController."Special Target URL" := UPG."Special Target URL";
            CimController."JMF Port" := UPG."JMF Port";
            CimController."Status Port" := UPG."Status Port";
            CimController."Auto Count Plant ID" := UPG."Auto Count Plant ID";
            CimController."Use Agfa TicketTemplate" := UPG."Use Agfa TicketTemplate";
            CimController."Use Agfa JobDescriptiveName" := UPG."Use Agfa JobDescriptiveName";
            CimController."Esko Label PrePress Workflow" := UPG."Esko Label PrePress Workflow";
            CimController."Esko Label Production Workflow" := UPG."Esko Label Production Workflow";
            CimController."Status Subscription ID" := UPG."Status Subscription ID";
            CimController."Resource Subscription ID" := UPG."Resource Subscription ID";
            CimController."Event Subscription ID" := UPG."Event Subscription ID";
            CimController."Notification Subscription ID" := UPG."Notification Subscription ID";


            if not CimController.Insert() then;
        until UPG.Next() = 0;
    end;

    procedure PVS_CIM_Controller_URL_Move_To_UPG()
    var
        CimController: Record "PVS CIM Controller URL";
        UPG: Record "PVS UPG CIM Controller URL";
    begin
        if UPG.IsEmpty then
            exit;
        UPG.FindSet();
        repeat

            CimController."Controller Code" := UPG."Controller Code";
            CimController.Code := UPG.Code;
            CimController.Name := UPG.Name;
            CimController.ControllerURL := UPG.ControllerURL;
            CimController.ControllerShortURL := UPG.ControllerShortURL;
            if not CimController.Insert() then;
        until UPG.Next() = 0;
    end;

    procedure "PVS_CIM_Controller_URL_Mapping_Move_To_UPG"()
    var
        CIMControllerURLMapping: Record "PVS CIM Controller URL Mapping";
        UPG: Record "PVS UPG CIM Controller URL Map";
    begin
        if UPG.IsEmpty then
            exit;
        UPG.FindSet();
        repeat

            CIMControllerURLMapping."Device Code" := UPG."Device Code";
            CIMControllerURLMapping."Order Type" := UPG."Order Type";
            CIMControllerURLMapping."Product Group" := UPG."Product Group";
            CIMControllerURLMapping."Customer Group" := UPG."Customer Group";
            CIMControllerURLMapping."Customer No." := UPG."Customer No.";
            CIMControllerURLMapping."Finished Goods Item Group Code" := UPG."Finished Goods Item Group Code";
            CIMControllerURLMapping."Finished Goods Item No." := UPG."Finished Goods Item No.";
            CIMControllerURLMapping."CIM Controller URL Code" := UPG."CIM Controller URL Code";
            if not CIMControllerURLMapping.Insert() then;
        until UPG.Next() = 0;
    end;

    procedure "PVS_Cost_Center_Move_To_UPG"()
    var
        CostCenter: Record "PVS Cost Center";
        UPG: Record "PVS UPG CIM Cost Center Ext";
    begin

        UPG.Reset();
        if UPG.IsEmpty then
            exit;

        if UPG.FindSet() then
            repeat
                CostCenter.Reset();
                CostCenter.SetRange(Code, UPG.Code);
                if CostCenter.FindFirst() then begin

                    CostCenter."PVS CIM Device Code" := UPG."PVS CIM Device Code";
                    CostCenter."PVS Running Ratio Qty." := UPG."PVS Running Ratio Qty.";
                    CostCenter."PVS Running Ratio Seconds" := UPG."PVS Running Ratio Seconds";
                    CostCenter."PVS Esko Press Brand" := UPG."PVS Esko Press Brand".AsInteger();
                    UPG."PVS Esko Print Process" := CostCenter."PVS Esko Print Process".AsInteger();
                    UPG."PVS Machine ID" := CostCenter."PVS Machine ID";

                    CostCenter.Modify(false);
                end;
            until UPG.Next() = 0;


    end;

    procedure PVS_UPG_CIM_Device_Move_To_UPG()

    var
        CIMDevice: Record "PVS CIM Device";
        UPG: Record "PVS UPG CIM Device";
    begin
        if UPG.IsEmpty then
            exit;

        UPG.FindSet();
        repeat

            CIMDevice.Code := UPG.Code;
            CIMDevice.Name := UPG.Name;
            CIMDevice."Controller Code" := UPG."Controller Code";
            CIMDevice."JMF Level" := UPG."JMF Level";
            CIMDevice."Device ID" := UPG."Device ID";
            CIMDevice."Device Type" := UPG."Device Type";
            CIMDevice."Descriptive Name" := UPG."Descriptive Name";
            CIMDevice."Report Total No. of Plates" := UPG."Report Total No. of Plates";
            CIMDevice.Closed := UPG.Closed;
            CIMDevice."Device Sequence" := UPG."Device Sequence";
            CIMDevice."Max Speed" := UPG."Max Speed";
            CIMDevice."External Reference Code" := UPG."External Reference Code";
            CIMDevice."PrePress Job Creation" := UPG."PrePress Job Creation";
            CIMDevice."Bitmap Code Big" := UPG."Bitmap Code Big";
            CIMDevice."Bitmap Code Small" := UPG."Bitmap Code Small";
            CIMDevice.Picture := UPG.Picture;
            CIMDevice.UPC := UPG.UPC;
            CIMDevice.DeviceFamily := UPG.DeviceFamily;
            CIMDevice.FriendlyName := UPG.FriendlyName;
            CIMDevice.Manufacturer := UPG.Manufacturer;
            CIMDevice.ModelDescription := UPG.ModelDescription;
            CIMDevice.ModelName := UPG.ModelName;
            CIMDevice.ModelNumber := UPG.ModelNumber;
            CIMDevice.ICSVersions := UPG.ICSVersions;
            CIMDevice.JDFErrorURL := UPG.JDFErrorURL;
            CIMDevice.JDFInputURL := UPG.JDFInputURL;
            CIMDevice.JDFOutputURL := UPG.JDFOutputURL;
            CIMDevice.JDFVersions := UPG.JDFVersions;
            CIMDevice.JMFSenderID := UPG.JMFSenderID;
            CIMDevice.JMFURL := UPG.JMFURL;
            CIMDevice."Serial No." := UPG."Serial No.";
            CIMDevice.PresentationURL := UPG.PresentationURL;
            CIMDevice.SecureJMFURL := UPG.SecureJMFURL;
            CIMDevice.Directory := UPG.Directory;
            CIMDevice.Type := UPG.Type;
            CIMDevice."Counter Channel" := UPG."Counter Channel";
            CIMDevice."Switches From Channel" := UPG."Switches From Channel";
            CIMDevice."Switches To Channel" := UPG."Switches To Channel";
            CIMDevice."Switches No. Of Channels" := UPG."Switches No. Of Channels";
            CIMDevice."Switches Channels" := UPG."Switches Channels";
            CIMDevice."Enable Switches" := UPG."Enable Switches";
            CIMDevice."AutoCount ID" := UPG."AutoCount ID";
            CIMDevice."AutoCount Plant ID" := UPG."AutoCount Plant ID";
            CIMDevice."Use AutoCount As Machine Cntr" := UPG."Use AutoCount As Machine Cntr";
            if not CIMDevice.Insert() then;
        until UPG.Next() = 0;
    end;

    procedure PVS_CIM_External_Connector_Log_Move_To_UPG()
    var
        CIMExternalConnectorLog: Record "PVS CIM External Connector Log";
        UPG: Record "PVS UPG CIM Ext Connec Log";
    begin
        if UPG.IsEmpty then
            exit;
        UPG.FindSet();
        repeat
            CIMExternalConnectorLog."Entry No." := UPG."Entry No.";
            if not CIMExternalConnectorLog.Insert() then;
        until UPG.Next() = 0;
    end;

    procedure "PVS_Product_Group_Move_To_UPG"()
    var
        ProductGroup: Record "PVS Product Group";
        UPG: Record "PVSUPGCIMProductGroupExt";
    begin
        UPG.Reset();
        if not UPG.FindSet() then
            exit;
        repeat
            ProductGroup.Reset();
            ProductGroup.SetRange(Code, UPG.Code);
            if ProductGroup.FindFirst() then begin
                ProductGroup."PVS Esko ProductType" := UPG."PVS Esko ProductType";
                ProductGroup.Modify(false);
            end;
        until UPG.Next() = 0;
    end;

    procedure PVS_UPG_CIM_Setup_Move_To_UPG()
    var
        CIMSetup: Record "PVS CIM Setup";
        UPG: Record "PVS UPG CIM Setup";
    begin
        if UPG.IsEmpty then
            exit;
        UPG.FindSet();
        repeat

            CIMSetup."KEY" := UPG."KEY";
            CIMSetup."Test Mode" := UPG."Test Mode";
            CIMSetup."Hotfolder Customer Intents" := CIMSetup."Hotfolder Customer Intents";
            CIMSetup."JMF Channel IP" := UPG."JMF Channel IP";
            CIMSetup."JMF Channel Port" := UPG."JMF Channel Port";
            CIMSetup."JMF Channel Domain" := UPG."JMF Channel Domain";
            CIMSetup."WCF OnPremise Port" := UPG."WCF OnPremise Port";
            CIMSetup."HTTP Listener Port" := UPG."HTTP Listener Port";
            CIMSetup."HTTP Status Port" := UPG."HTTP Status Port";
            CIMSetup."JDF Sender ID Suffix" := UPG."JDF Sender ID Suffix";
            CIMSetup."Disable Scheduler in External" := UPG."Disable Scheduler in External";
            CIMSetup."Delete Response History" := UPG."Delete Response History";
            CIMSetup."Retain History Date Formula" := UPG."Retain History Date Formula";
            CIMSetup."JDF Version" := UPG."JDF Version";
            CIMSetup."Max Msg Size For Service Tier" := UPG."Max Msg Size For Service Tier";
            CIMSetup."Max Msg Size To Initiate Async" := UPG."Max Msg Size To Initiate Async";
            CIMSetup."Transform URL To MIME" := UPG."Transform URL To MIME";
            CIMSetup."Test Controller Code" := UPG."Test Controller Code";
            CIMSetup."Test Disable Auto Processing" := UPG."Test Disable Auto Processing";
            CIMSetup."Test Enable Multi-ID Encoding" := UPG."Test Enable Multi-ID Encoding";
            CIMSetup."Test JDF File Blob" := UPG."Test JDF File Blob";
            CIMSetup."Test JDF File Name" := UPG."Test JDF File Name";
            CIMSetup."JDF Descriptive Naming" := UPG."JDF Descriptive Naming";
            CIMSetup."CIM Queue Blocked" := UPG."CIM Queue Blocked";
            CIMSetup."CIM Session ID" := UPG."CIM Session ID";
            CIMSetup."CIM Server Instance ID" := UPG."CIM Server Instance ID";
            CIMSetup."CIM Task ID" := UPG."CIM Task ID";
            CIMSetup."DCM Queue Blocked" := UPG."DCM Queue Blocked";
            CIMSetup."DCM Session ID" := UPG."DCM Session ID";
            CIMSetup."DCM Server Instance ID" := UPG."DCM Server Instance ID";
            CIMSetup."DCM Task ID" := UPG."DCM Task ID";
            CIMSetup."Timer Interval" := UPG."Timer Interval";
            CIMSetup."Messages Received" := UPG."Messages Received";
            CIMSetup."WCF Service Started" := UPG."WCF Service Started";
            CIMSetup."WCF Service Running" := UPG."WCF Service Running";
            CIMSetup."WCF Service Stopped" := UPG."WCF Service Stopped";
            CIMSetup."WCF Service Version" := UPG."WCF Service Version";
            CIMSetup."WCF Service Started As User ID" := UPG."WCF Service Started As User ID";
            CIMSetup."WCF Service IP Address" := UPG."WCF Service IP Address";
            CIMSetup."Timer Interval (DCM)" := UPG."Timer Interval (DCM)";
            CIMSetup."Job Ticket ID" := UPG."Job Ticket ID";
            CIMSetup."Job Ticket File Type" := UPG."Job Ticket File Type";
            CIMSetup.Responsible := UPG.Responsible;
            CIMSetup."Esko JDF Integration Active" := UPG."Esko JDF Integration Active";
            CIMSetup."PVS User Login" := UPG."PVS User Login";
            CIMSetup."PVS User Password" := UPG."PVS User Password";
            CIMSetup."XMPIE Front End Port" := UPG."XMPIE Front End Port";
            CIMSetup."XMPIE Web Service URL" := UPG."XMPIE Web Service URL";
            if not CIMSetup.Insert() then;

        until UPG.Next() = 0;
    end;

    procedure "PVS_Customer_JDF_Intent_Files_Move_To_UPG"()
    var
        CustomerJDFIntentFiles: Record "PVS Customer JDF Intent Files";
        UPG: Record "PVS UPG Cust JDF Intent Files";
    begin
        if UPG.IsEmpty then
            exit;
        UPG.FindSet();
        repeat

            CustomerJDFIntentFiles."Entry No." := UPG."Entry No.";
            CustomerJDFIntentFiles.Status := UPG.Status;
            CustomerJDFIntentFiles."Error Message" := UPG."Error Message";
            CustomerJDFIntentFiles."Processing Time" := UPG."Processing Time";
            CustomerJDFIntentFiles."File Size" := UPG."File Size";
            CustomerJDFIntentFiles.ID := UPG.ID;
            CustomerJDFIntentFiles."File BLOB" := UPG."File BLOB";
            CustomerJDFIntentFiles."File Name" := UPG."File Name";
            CustomerJDFIntentFiles."File Date" := UPG."File Date";
            CustomerJDFIntentFiles."File Time" := UPG."File Time";
            CustomerJDFIntentFiles."Creation Date" := UPG."Creation Date";
            CustomerJDFIntentFiles."Creation Time" := UPG."Creation Time";
            If not CustomerJDFIntentFiles.Insert() then;
        until UPG.Next() = 0;
    end;

    procedure "PVS_Esko_Setup_Move_To_UPG"()
    var
        EskoSetup: Record "PVS Esko Setup";
        UPG: Record "PVS UPG Esko Setup";
    begin
        if UPG.IsEmpty then
            exit;
        UPG.FindSet();
        repeat

            EskoSetup."KEY" := UPG."KEY";
            EskoSetup."AE Connect Server" := UPG."AE Connect Server";
            EskoSetup."AE Connect Port" := UPG."AE Connect Port";
            EskoSetup."Integration Activated" := UPG."Integration Activated";
            EskoSetup."AE Container Share Name" := UPG."AE Container Share Name";
            EskoSetup."Sync Endpoint" := UPG."Sync Endpoint";
            EskoSetup."Processing Endpoint" := UPG."Processing Endpoint";
            EskoSetup."AE Server User Name" := UPG."AE Server User Name";
            EskoSetup."AE Server Password" := UPG."AE Server Password";
            EskoSetup."AE Server Domain" := UPG."AE Server Domain";
            EskoSetup."Default Substrate Queue" := UPG."Default Substrate Queue";
            EskoSetup."CAD Spec. Base Folder Name" := UPG."CAD Spec. Base Folder Name";
            EskoSetup."CAD Spec. ARD Folder Name" := UPG."CAD Spec. ARD Folder Name";
            EskoSetup."CAD Spec. JPG Folder Name" := UPG."CAD Spec. JPG Folder Name";
            EskoSetup."CAD Spec. PDF Folder Name" := UPG."CAD Spec. PDF Folder Name";
            EskoSetup."CAD Spec. Interm. Folder Name" := UPG."CAD Spec. Interm. Folder Name";
            EskoSetup."CAD Spec. Notific. Folder Name" := UPG."CAD Spec. Notific. Folder Name";
            EskoSetup."CAD Spec. Error Folder Name" := UPG."CAD Spec. Error Folder Name";
            EskoSetup."Run List Folder Path" := UPG."Run List Folder Path";
            EskoSetup."Request 3D Previews" := UPG."Request 3D Previews";
            EskoSetup."Incoming Imposition File Mask" := UPG."Incoming Imposition File Mask";
            EskoSetup."Incoming Strct. Dsg. File Mask" := UPG."Incoming Strct. Dsg. File Mask";
            EskoSetup."Allow Mfg Sheets without Job" := UPG."Allow Mfg Sheets without Job";
            EskoSetup."Debug Mode Enabled" := UPG."Debug Mode Enabled";
            EskoSetup."Service Tier Debug Path" := UPG."Service Tier Debug Path";
            EskoSetup."No. Series CAD Specs." := UPG."No. Series CAD Specs.";
            EskoSetup."No. Series Mfg. Sheet" := UPG."No. Series Mfg. Sheet";

            If not EskoSetup.Insert() then;
        until UPG.Next() = 0;
    end;

    procedure "PVS_JMF_Known_Messages_Move_To_UPG"()
    var
        JMFKnownMessages: Record "PVS JMF Known Messages";
        UPG: Record "PVS UPG JMF Known Messages";
    begin
        if UPG.IsEmpty then
            exit;
        UPG.FindSet();
        repeat

            JMFKnownMessages."Controller Code" := UPG."Controller Code";
            JMFKnownMessages.Type := UPG.Type;
            JMFKnownMessages.JMFRole := UPG.JMFRole;
            JMFKnownMessages.Acknowledge := UPG.Acknowledge;
            JMFKnownMessages.Command := UPG.Command;
            JMFKnownMessages.Persistent := UPG.Persistent;
            JMFKnownMessages."Query" := UPG."Query";
            JMFKnownMessages.Registration := UPG.Registration;
            JMFKnownMessages.Signal := UPG.Signal;
            JMFKnownMessages."URLSchema File" := UPG."URLSchema File";
            JMFKnownMessages."URLSchema FTP" := UPG."URLSchema FTP";
            JMFKnownMessages."URLSchema HTTP" := UPG."URLSchema HTTP";
            JMFKnownMessages."URLSchema HTTPS" := UPG."URLSchema HTTPS";

            If not JMFKnownMessages.Insert() then;
        until UPG.Next() = 0;
    end;

    procedure "PVS_Private_Namespace_Const_Move_To_UPG"()
    var
        PrivateNamespaceConst: Record "PVS Private Namespace Const.";
        UPG: Record "PVS UPG Private Namespa Const";
    begin
        if UPG.IsEmpty then
            exit;
        UPG.FindSet();
        repeat

            PrivateNamespaceConst."Controller Code" := UPG."Controller Code";
            PrivateNamespaceConst.Namespace := UPG.Namespace;
            PrivateNamespaceConst."Private Namespace" := UPG."Private Namespace";
            PrivateNamespaceConst."Tag Name" := UPG."Tag Name";
            PrivateNamespaceConst.Value := UPG.Value;
            PrivateNamespaceConst.Description := UPG.Description;
            If not PrivateNamespaceConst.Insert() then;
        until UPG.Next() = 0;
    end;

    procedure "PVS_DCM_Input_Mask_Move_To_UPG"()
    var
        DCMInputMask: Record "PVS DCM Input Mask";
        UPG: Record "PVS UPG DCM Input Mask";
    begin
        if UPG.IsEmpty then
            exit;
        UPG.FindSet();
        repeat

            DCMInputMask."Entry No." := UPG."Entry No.";
            DCMInputMask."Device Code" := UPG."Device Code";
            DCMInputMask."Cost Centre Code" := UPG."Cost Centre Code";
            DCMInputMask."Input Mask" := UPG."Input Mask";
            DCMInputMask."Work Code" := UPG."Work Code";
            DCMInputMask."Input Mask (User)" := UPG."Input Mask (User)";
            DCMInputMask."Include Counter" := UPG."Include Counter";
            DCMInputMask."Device Status" := UPG."Device Status";
            DCMInputMask.Priority := UPG.Priority;
            DCMInputMask."Created By" := UPG."Created By";
            DCMInputMask."Created Date" := UPG."Created Date";
            DCMInputMask."Created Time" := UPG."Created Time";
            DCMInputMask."Modified By" := UPG."Modified By";
            DCMInputMask."Modified Date" := UPG."Modified Date";
            DCMInputMask."Modified Time" := UPG."Modified Time";
            If not DCMInputMask.Insert() then;
        until UPG.Next() = 0;
    end;

    procedure "PVS_DCM_Moxa_Entry_Move_To_UPG"()
    var
        DCMMoxaEntry: Record "PVS DCM Moxa Entry";
        UPG: Record "PVS UPG DCM Moxa Entry";
    begin
        if UPG.IsEmpty then
            exit;
        DCMMoxaEntry.FindSet();
        repeat

            DCMMoxaEntry."Entry No." := UPG."Entry No.";
            DCMMoxaEntry."Data String" := UPG."Data String";
            DCMMoxaEntry."CIM Controller Code" := UPG."CIM Controller Code";
            DCMMoxaEntry."Time Milliseconds" := UPG."Time Milliseconds";
            DCMMoxaEntry."DateTime (Added)" := UPG."DateTime (Added)";
            If not DCMMoxaEntry.Insert() then;
        until UPG.Next() = 0;
    end;

    procedure "PVS_DCM_Moxa_Status_Move_To_UPG"()
    var
        CMMoxaStatus: Record "PVS DCM Moxa Status";
        UPG: Record "PVS UPG DCM Moxa Status";
    begin
        if UPG.IsEmpty then
            exit;
        UPG.FindSet();
        repeat

            CMMoxaStatus."Cost Center Code" := UPG."Cost Center Code";
            CMMoxaStatus."Now Time" := UPG."Now Time";
            CMMoxaStatus.Counter := UPG.Counter;
            CMMoxaStatus.Running := UPG.Running;
            CMMoxaStatus."Running Speed" := UPG."Running Speed";

            if not CMMoxaStatus.Insert() then;
        until UPG.Next() = 0;
    end;

    procedure "PVS_Esko_Manufacturing_Move_To_UPG"()
    var
        EskoManufacturing: Record "PVS Esko Manufacturing";
        UPG: Record "PVS UPG Esko Manufacturing";
    begin
        if UPG.IsEmpty then
            exit;
        UPG.FindSet();
        repeat

            EskoManufacturing."Mfg. Sheet No." := UPG."Mfg. Sheet No.";
            EskoManufacturing."Mfg. File Path" := UPG."Mfg. File Path";
            EskoManufacturing."Mfg. File Name" := UPG."Mfg. File Name";
            EskoManufacturing.Description := UPG.Description;
            EskoManufacturing."Imposition Picture" := UPG."Imposition Picture";
            EskoManufacturing."Sheet Width" := UPG."Sheet Width";
            EskoManufacturing."Sheet Length" := UPG."Sheet Length";
            EskoManufacturing."Artios Board Code" := UPG."Artios Board Code";
            EskoManufacturing."Artios Printing Press" := UPG."Artios Printing Press";
            EskoManufacturing."Artios Die Press" := UPG."Artios Die Press";
            EskoManufacturing."Grain Direction" := UPG."Grain Direction";
            EskoManufacturing."Paper Item No." := UPG."Paper Item No.";
            EskoManufacturing."Plate Item No." := UPG."Plate Item No.";
            EskoManufacturing."Plate Length" := UPG."Plate Length";
            EskoManufacturing."Plate Width" := UPG."Plate Width";

            if not EskoManufacturing.Insert() then;
        until UPG.Next() = 0;
    end;

    procedure "PVS_Workflow_Partner_Commands_Move_To_UPG"()
    var
        WorkflowPartnerCommands: Record "PVS Workflow Partner Commands";
        UPG: Record "PVS UPG Workflow Partner Comma";
    begin
        if UPG.IsEmpty then
            exit;
        UPG.FindSet();
        repeat

            WorkflowPartnerCommands."Entry No." := UPG."Entry No.";
            WorkflowPartnerCommands."Entry Type" := UPG."Entry Type".AsInteger();
            WorkflowPartnerCommands."Device Code" := UPG."Device Code";
            WorkflowPartnerCommands."Item No." := UPG."Item No.";
            WorkflowPartnerCommands.ID := UPG.ID;
            WorkflowPartnerCommands.Job := UPG.Job;
            WorkflowPartnerCommands.Version := UPG.Version;
            WorkflowPartnerCommands."Sheet ID" := UPG."Sheet ID";
            WorkflowPartnerCommands.Command := UPG.Command.AsInteger();
            WorkflowPartnerCommands.Status := UPG.Status;
            WorkflowPartnerCommands."Error Message" := UPG."Error Message";
            WorkflowPartnerCommands.Submitted := UPG.Submitted;
            WorkflowPartnerCommands."Submission Pending" := UPG."Submission Pending";
            WorkflowPartnerCommands."File Name" := UPG."File Name";
            WorkflowPartnerCommands."File BLOB" := UPG."File BLOB";
            WorkflowPartnerCommands.Information := UPG.Information;
            WorkflowPartnerCommands.Text1 := UPG.Text1;
            WorkflowPartnerCommands."Creation Date" := UPG."Creation Date";
            WorkflowPartnerCommands."Creation Time" := UPG."Creation Time";
            WorkflowPartnerCommands."Created By User" := UPG."Created By User";
            WorkflowPartnerCommands."Processing Time" := UPG."Processing Time";
            WorkflowPartnerCommands."Send To Target URL" := UPG."Send To Target URL";
            WorkflowPartnerCommands."Submission Attempts" := UPG."Submission Attempts";
            WorkflowPartnerCommands."Submission Command ID" := UPG."Submission Command ID";
            WorkflowPartnerCommands."Job ID" := UPG."Job ID";
            WorkflowPartnerCommands."Job Part ID" := UPG."Job Part ID";
            WorkflowPartnerCommands."Last Entry No." := UPG."Last Entry No.";
            WorkflowPartnerCommands."Controller Code" := UPG."Controller Code";
            WorkflowPartnerCommands."CIM Controller URL Code" := UPG."CIM Controller URL Code";
            WorkflowPartnerCommands."Esko BackStage Ticket Name" := UPG."Esko BackStage Ticket Name";
            WorkflowPartnerCommands."PVS Esko BackStage Task Type" := UPG."PVS Esko BackStage Task Type".AsInteger();
            WorkflowPartnerCommands."External Status" := UPG."External Status".AsInteger();
            WorkflowPartnerCommands."File To External System" := UPG."File To External System";
            WorkflowPartnerCommands."File From External System" := UPG."File From External System";
            WorkflowPartnerCommands."Last Update From Connector" := UPG."Last Update From Connector";

            if not WorkflowPartnerCommands.Insert() then;
        until UPG.Next() = 0;
    end;

    procedure "PVS_Workflow_Partner_MIME_Buf_Move_To_UPG"()
    var
        WorkflowPartnerMIMEBuf: Record "PVS Workflow Partner MIME Buf.";
        UPG: Record "PVS UPG Workflow Part MIME Buf";
    begin
        if UPG.IsEmpty then
            exit;
        UPG.FindSet();
        repeat
            WorkflowPartnerMIMEBuf.Type := UPG.Type;
            WorkflowPartnerMIMEBuf."Part Acid" := UPG."Part Acid";
            WorkflowPartnerMIMEBuf."Part No." := UPG."Part No.";
            WorkflowPartnerMIMEBuf."Closing Part" := UPG."Closing Part";
            WorkflowPartnerMIMEBuf."Response Entry No." := UPG."Response Entry No.";
            WorkflowPartnerMIMEBuf."Part Body" := UPG."Part Body";
            WorkflowPartnerMIMEBuf."Base64 Encoded" := UPG."Base64 Encoded";
            WorkflowPartnerMIMEBuf."Body Size" := UPG."Body Size";
            WorkflowPartnerMIMEBuf."Content Type" := UPG."Content Type";
            WorkflowPartnerMIMEBuf."File Name" := UPG."File Name";
            If not WorkflowPartnerMIMEBuf.Insert() then;
        until UPG.Next() = 0;
    end;

    procedure "PVS_Workflow_Partner_Que_Ent_Move_To_UPG"()
    var
        WorkflowPartnerQue: Record "PVS Workflow Partner Que. Ent.";
        UPG: Record "PVS UPG Workflow Partner Que.";
    begin
        if UPG.IsEmpty then
            exit;
        UPG.FindSet();
        repeat

            WorkflowPartnerQue."Entry No." := UPG."Entry No.";
            WorkflowPartnerQue.SenderID := UPG.SenderID;
            WorkflowPartnerQue."PVS Device Code" := UPG."PVS Device Code";
            WorkflowPartnerQue."PVS Controller Code" := UPG."PVS Controller Code";
            WorkflowPartnerQue.DeviceID := UPG.DeviceID;
            WorkflowPartnerQue."Event TimeStamp" := UPG."Event TimeStamp";
            WorkflowPartnerQue.JobID := UPG.JobID;
            WorkflowPartnerQue.JobPartID := UPG.JobPartID;
            WorkflowPartnerQue."Event System" := UPG."Event System";
            WorkflowPartnerQue."Queue Status" := UPG."Queue Status";
            WorkflowPartnerQue."Queue Entry Submission Time" := UPG."Queue Entry Submission Time";
            WorkflowPartnerQue."Queue EntryID" := UPG."Queue EntryID";
            WorkflowPartnerQue."Queue Entry Priority" := UPG."Queue Entry Priority";
            WorkflowPartnerQue."Acknowledge Type" := UPG."Acknowledge Type";
            WorkflowPartnerQue.RefID := UPG.RefID;
            WorkflowPartnerQue."File BLOB" := UPG."File BLOB";
            WorkflowPartnerQue."DateTime Received" := UPG."DateTime Received";
            WorkflowPartnerQue."Response Type" := UPG."Response Type";
            WorkflowPartnerQue."Response Sub Type" := UPG."Response Sub Type";
            WorkflowPartnerQue.Status := UPG.Status;
            WorkflowPartnerQue."Error Text" := UPG."Error Text";

            if not WorkflowPartnerQue.Insert() then;
        until UPG.Next() = 0;
    end;

    procedure "PVS_Workflow_Partner_Resp_At_Move_To_UPG"()
    var
        WorkflowPartnerRespAt: Record "PVS Workflow Partner Resp. At.";
        UPG: Record "PVS UPG Workflow Partner Resp";
    begin
        if UPG.IsEmpty then
            exit;
        UPG.FindSet();
        repeat
            WorkflowPartnerRespAt."Entry No." := UPG."Entry No.";
            WorkflowPartnerRespAt."JMF Response Entry No." := UPG."JMF Response Entry No.";
            WorkflowPartnerRespAt."DateTime Received" := UPG."DateTime Received";
            WorkflowPartnerRespAt."File BLOB" := UPG."File BLOB";
            WorkflowPartnerRespAt."File Name" := UPG."File Name";
            WorkflowPartnerRespAt.ContentID := UPG.ContentID;
            WorkflowPartnerRespAt.ContentType := UPG.ContentType;
            WorkflowPartnerRespAt."File Size" := UPG."File Size";
            If not WorkflowPartnerRespAt.Insert() then;
        until UPG.Next() = 0;
    end;

    procedure "PVS_Workflow_Partner_Responses_Move_To_UPG"()
    var
        WorkflowPartnerResponses: Record "PVS Workflow Partner Responses";
        UPG: Record "PVS UPG Workflow Partner Respo";
    begin
        if UPG.IsEmpty then
            exit;
        UPG.FindSet();
        repeat
            WorkflowPartnerResponses."Entry No." := UPG."Entry No.";
            WorkflowPartnerResponses.SenderID := UPG.SenderID;
            WorkflowPartnerResponses."Device Code" := UPG."Device Code";
            WorkflowPartnerResponses."Controller Code" := UPG."Controller Code";
            WorkflowPartnerResponses.DeviceID := UPG.DeviceID;
            WorkflowPartnerResponses."Event TimeStamp" := UPG."Event TimeStamp";
            WorkflowPartnerResponses."JobPhase JobID" := UPG."JobPhase JobID";
            WorkflowPartnerResponses."JobPhase JobPartID" := UPG."JobPhase JobPartID";
            WorkflowPartnerResponses."Event System" := UPG."Event System";
            WorkflowPartnerResponses."PVS ID" := UPG."PVS ID";
            WorkflowPartnerResponses.Job := UPG.Job;
            WorkflowPartnerResponses."Plan ID" := UPG."Plan ID";
            WorkflowPartnerResponses."Item No." := UPG."Item No.";
            WorkflowPartnerResponses."Job Item Entry No." := UPG."Job Item Entry No.";
            WorkflowPartnerResponses."Process ID" := UPG."Process ID";
            WorkflowPartnerResponses."Device TotalProductionCounter" := UPG."Device TotalProductionCounter";
            WorkflowPartnerResponses.ID := UPG.ID;
            WorkflowPartnerResponses."Device Status Text" := UPG."Device Status Text";
            WorkflowPartnerResponses."Device StatusDetails Text" := UPG."Device StatusDetails Text";
            WorkflowPartnerResponses."JobPhase Status Text" := UPG."JobPhase Status Text";
            WorkflowPartnerResponses."JobPhase StatusDetails Text" := UPG."JobPhase StatusDetails Text";
            WorkflowPartnerResponses."JobPhase Amount" := UPG."JobPhase Amount";
            WorkflowPartnerResponses."JobPhase Waste" := UPG."JobPhase Waste";
            WorkflowPartnerResponses.JobPhaseCounter := UPG.JobPhaseCounter;
            WorkflowPartnerResponses."Sheet ID" := UPG."Sheet ID";
            WorkflowPartnerResponses."JobPhase Included" := UPG."JobPhase Included";
            WorkflowPartnerResponses.EmployeeID := UPG.EmployeeID;
            WorkflowPartnerResponses."JobPhase PercentCompleted" := UPG."JobPhase PercentCompleted";
            WorkflowPartnerResponses."JobPhase RestTime" := UPG."JobPhase RestTime";
            WorkflowPartnerResponses."JobPhase Speed" := UPG."JobPhase Speed";
            WorkflowPartnerResponses."JobPhase Start DateTime" := UPG."JobPhase Start DateTime";
            WorkflowPartnerResponses."JobPhase PhaseAmount" := UPG."JobPhase PhaseAmount";
            WorkflowPartnerResponses."JobPhase TotalAmount" := UPG."JobPhase TotalAmount";
            WorkflowPartnerResponses."Device OperationMode" := UPG."Device OperationMode";
            WorkflowPartnerResponses."Device Condition" := UPG."Device Condition";
            WorkflowPartnerResponses."JobPhase End DateTime" := UPG."JobPhase End DateTime";
            WorkflowPartnerResponses."Costing Type" := UPG."Costing Type";
            WorkflowPartnerResponses."Cost Center Code" := UPG."Cost Center Code";
            WorkflowPartnerResponses."Order No." := UPG."Order No.";
            WorkflowPartnerResponses."Item No." := UPG."Item No.";
            WorkflowPartnerResponses."Event Comment" := UPG."Event Comment";
            WorkflowPartnerResponses."Work Code" := UPG."Work Code";
            WorkflowPartnerResponses."Event Text" := UPG."Event Text";
            WorkflowPartnerResponses."Resource Actual Amount" := UPG."Resource Actual Amount";
            WorkflowPartnerResponses."Resource Amount" := UPG."Resource Amount";
            WorkflowPartnerResponses."Resource AvailableAmount" := UPG."Resource AvailableAmount";
            WorkflowPartnerResponses."Resource Level" := UPG."Resource Level";
            WorkflowPartnerResponses."Resource Location" := UPG."Resource Location";
            WorkflowPartnerResponses."Resource ModuleID" := UPG."Resource ModuleID";
            WorkflowPartnerResponses."Resource ModuleIndex" := UPG."Resource ModuleIndex";
            WorkflowPartnerResponses."Resource ResourceName" := UPG."Resource ResourceName";
            WorkflowPartnerResponses."Resource ProcessUsage" := UPG."Resource ProcessUsage";
            WorkflowPartnerResponses."Resource ProductID" := UPG."Resource ProductID";
            WorkflowPartnerResponses."Resource Status" := UPG."Resource Status";
            WorkflowPartnerResponses."Resource Unit" := UPG."Resource Unit";
            WorkflowPartnerResponses.CostCenterID := UPG.CostCenterID;
            WorkflowPartnerResponses.CostCenterName := UPG.CostCenterName;
            WorkflowPartnerResponses.QueueEntryID := UPG.QueueEntryID;
            WorkflowPartnerResponses."ReturnQueueEntry Aborted" := UPG."ReturnQueueEntry Aborted";
            WorkflowPartnerResponses."ReturnQueueEntry Completed" := UPG."ReturnQueueEntry Completed";
            WorkflowPartnerResponses."ReturnQueueEntry Priority" := UPG."ReturnQueueEntry Priority";
            WorkflowPartnerResponses."ReturnQueueEntry URL" := UPG."ReturnQueueEntry URL";
            WorkflowPartnerResponses."Device JMFURL" := UPG."Device JMFURL";
            WorkflowPartnerResponses."File BLOB" := UPG."File BLOB";
            WorkflowPartnerResponses."DateTime Received" := UPG."DateTime Received";
            WorkflowPartnerResponses."File Name" := UPG."File Name";
            WorkflowPartnerResponses."Response Type" := UPG."Response Type";
            WorkflowPartnerResponses."Response Sub Type" := UPG."Response Sub Type";
            WorkflowPartnerResponses."PVS Status" := UPG."PVS Status";
            WorkflowPartnerResponses."Posted To Journal" := UPG."Posted To Journal";
            WorkflowPartnerResponses."Posted DateTime" := UPG."Posted DateTime";
            WorkflowPartnerResponses."Error Text" := UPG."Error Text";
            WorkflowPartnerResponses."Message Status" := UPG."Message Status";
            WorkflowPartnerResponses."File Date" := UPG."File Date";
            WorkflowPartnerResponses."File Time" := UPG."File Time";
            WorkflowPartnerResponses."File Size" := UPG."File Size";
            WorkflowPartnerResponses."Device Type" := UPG."Device Type";
            WorkflowPartnerResponses."Device Manufacturer" := UPG."Device Manufacturer";
            WorkflowPartnerResponses.EmployeeShift := UPG.EmployeeShift;
            WorkflowPartnerResponses.EmployeeCostCenterID := UPG.EmployeeCostCenterID;
            WorkflowPartnerResponses.EmployeeCostCenterName := UPG.EmployeeCostCenterName;
            WorkflowPartnerResponses.EmployeeFirstName := UPG.EmployeeFirstName;
            WorkflowPartnerResponses.EmployeeFamilyName := UPG.EmployeeFamilyName;
            WorkflowPartnerResponses.EmployeeRoleApprentice := UPG.EmployeeRoleApprentice;
            WorkflowPartnerResponses.EmployeeRoleAssistant := UPG.EmployeeRoleAssistant;
            WorkflowPartnerResponses.EmployeeRoleCraftsman := UPG.EmployeeRoleCraftsman;
            WorkflowPartnerResponses.EmployeeRoleCSR := UPG.EmployeeRoleCSR;
            WorkflowPartnerResponses.EmployeeRoleManager := UPG.EmployeeRoleManager;
            WorkflowPartnerResponses.EmployeeRoleMaster := UPG.EmployeeRoleMaster;
            WorkflowPartnerResponses.EmployeeRoleOperator := UPG.EmployeeRoleOperator;
            WorkflowPartnerResponses.EmployeeRoleShiftLeader := UPG.EmployeeRoleShiftLeader;
            WorkflowPartnerResponses.EmployeeRoleStandBy := UPG.EmployeeRoleStandBy;
            WorkflowPartnerResponses."Body Parts In Transit" := UPG."Body Parts In Transit";
            WorkflowPartnerResponses."Original JMF File" := UPG."Original JMF File";
            WorkflowPartnerResponses."Device Status Text Backup" := UPG."Device Status Text Backup";
            WorkflowPartnerResponses."Device StatusDetails Text Back" := UPG."Device StatusDetails Text Back";
            WorkflowPartnerResponses."Device Status Activity Backup" := UPG."Device Status Activity Backup";
            If not WorkflowPartnerResponses.Insert() then;
        until UPG.Next() = 0;
    end;
} */