codeunit 80211 "PTE UPgrade Logic Part 1"
{
    procedure PVS_Job_Sheet_Move_To_UPG()
    var
        PVSJobSheet: Record "PVS Job Sheet";
        UPG: Record "PVS UPG ACAD Job Sheet Ext";
    begin
        if PVSJobSheet.IsEmpty then
            exit;
        repeat

            UPG."Sheet ID" := PVSJobSheet."Sheet ID";
            UPG."PVS Mfg. Sheet No." := PVSJobSheet."Mfg Sheet No.";
            if not UPG.Insert() then;
        until PVSJobSheet.Next() = 0;
    end;

    procedure PVS_CIM_Controller_Move_To_UPG()
    var
        CimController: Record "PVS CIM Controller";
        UPG: Record "PVS UPG CIM Controller";
    begin
        if CimController.IsEmpty then
            exit;
        CimController.FindSet();
        repeat

            UPG.Code := CimController.Code;
            UPG."Workflow Partner Name" := CimController."Workflow Partner Name";
            UPG.Description := CimController.Description;
            UPG."Hot Folder Incoming" := CimController."Hot Folder Incoming";
            UPG."Target URL" := CimController."Target URL";
            UPG.Port := CimController.Port;
            UPG."Receiving Method" := CimController."Receiving Method";
            UPG."Submission Method" := CimController."Submission Method";
            UPG."MIME Packaging" := CimController."MIME Packaging";
            UPG.Closed := CimController.Closed;
            UPG."CIM System" := CimController."CIM System";
            UPG."Receive Detail Level" := CimController."Receive Detail Level";
            UPG."JDF Structure" := CimController."JDF Structure";
            UPG."Workflow Submission" := CimController."Workflow Submission";
            UPG."Private Namespace" := CimController."Private Namespace";
            UPG."Resubmission Allowed" := CimController."Resubmission Allowed";
            UPG."Subscription Method" := CimController."Subscription Method";
            UPG."No. Of Submission Retries" := CimController."No. Of Submission Retries";
            UPG."SM Hot Folder" := CimController."SM Hot Folder";
            UPG."SM File Schema Support" := CimController."SM File Schema Support";
            UPG."SM FTP Schema Support" := CimController."SM FTP Schema Support";
            UPG."SM HTTP Schema Support" := CimController."SM HTTP Schema Support";
            UPG."SM HTTPS Schema Support" := CimController."SM HTTPS Schema Support";
            UPG."SM MIME Packaging Support" := CimController."SM MIME Packaging Support";
            UPG."Sender ID" := CimController."Sender ID";
            UPG."Subscribed To Status" := CimController."Subscribed To Status";
            UPG."Subscribed To Resource" := CimController."Subscribed To Resource";
            UPG."Subscribed To Events" := CimController."Subscribed To Events";
            UPG."Subscribed To Notifications" := CimController."Subscribed To Notifications";
            UPG."Clean Org. Name" := CimController."Clean Org. Name";
            UPG."Paper Media Partioned" := CimController."Paper Media Partioned";
            UPG."Plate Media Partioned" := CimController."Plate Media Partioned";
            UPG."Position Type" := CimController."Position Type";
            UPG."Preview Separation Node" := CimController."Preview Separation Node";
            UPG."Preview Thumbnail Node" := CimController."Preview Thumbnail Node";
            UPG."Preview Sep. Thumbnail Node" := CimController."Preview Sep. Thumbnail Node";
            UPG."Media Intent Dim. Node" := CimController."Media Intent Dim. Node";
            UPG."JDF ProductTypeDetails Value" := CimController."JDF ProductTypeDetails Value";
            UPG."JDF ProductTypeDetails Buildup" := CimController."JDF ProductTypeDetails Buildup";
            UPG."JDF GeneralID ProductClass" := CimController."JDF GeneralID ProductClass";
            UPG."JDF GeneralID ProductionType" := CimController."JDF GeneralID ProductionType";
            UPG."Format Contact Names" := CimController."Format Contact Names";
            UPG."HTTP Use" := CimController."HTTP Use";
            upg."JMF AcknowledgeURL Attribute" := CimController."JMF AcknowledgeURL Attribute";
            UPG."JMF WatchURL Attribute" := CimController."JMF WatchURL Attribute";
            UPG."JMF ResubmitQueue Supported" := CimController."JMF ResubmitQueue Supported";
            UPG."Job Ticket ID" := CimController."Job Ticket ID";
            UPG."File Type" := CimController."File Type";
            UPG."Special Target URL" := CimController."Special Target URL";
            upg."JMF Port" := CimController."JMF Port";
            UPG."Status Port" := CimController."Status Port";
            UPG."Auto Count Plant ID" := CimController."Auto Count Plant ID";
            UPG."Use Agfa TicketTemplate" := CimController."Use Agfa TicketTemplate";
            UPG."Use Agfa JobDescriptiveName" := CimController."Use Agfa JobDescriptiveName";
            UPG."Esko Label PrePress Workflow" := CimController."Esko Label PrePress Workflow";
            UPG."Esko Label Production Workflow" := CimController."Esko Label Production Workflow";

            //NOTE Add These lines in for Newer version of CIM
            //UPG."Status Subscription ID" := CimController."Status Subscription ID";
            //UPG."Resource Subscription ID" := CimController."Resource Subscription ID";
            //UPG."Event Subscription ID" := CimController."Event Subscription ID";
            //UPG."Notification Subscription ID" := CimController."Notification Subscription ID";


            if not UPG.Insert() then;
        until CimController.Next() = 0;
    end;

    procedure PVS_CIM_Controller_URL_Move_To_UPG()
    var
        CimController: Record "PVS CIM Controller URL";
        UPG: Record "PVS UPG CIM Controller URL";
    begin
        if CimController.IsEmpty then
            exit;
        CimController.FindSet();
        repeat

            UPG."Controller Code" := CimController."Controller Code";
            UPG.Code := CimController.Code;
            UPG.Name := CimController.Name;
            UPG.ControllerURL := CimController.ControllerURL;
            UPG.ControllerShortURL := CimController.ControllerShortURL;
            if not UPG.Insert() then;
        until CimController.Next() = 0;
    end;

    procedure "PVS_CIM_Controller_URL_Mapping_Move_To_UPG"()
    var
        CIMControllerURLMapping: Record "PVS CIM Controller URL Mapping";
        UPG: Record "PVS UPG CIM Controller URL Map";
    begin
        if CIMControllerURLMapping.IsEmpty then
            exit;
        CIMControllerURLMapping.findset();
        repeat

            UPG."Device Code" := CIMControllerURLMapping."Device Code";
            UPG."Order Type" := CIMControllerURLMapping."Order Type";
            UPG."Product Group" := CIMControllerURLMapping."Product Group";
            UPG."Customer Group" := CIMControllerURLMapping."Customer Group";
            UPG."Customer No." := CIMControllerURLMapping."Customer No.";
            UPG."Finished Goods Item Group Code" := CIMControllerURLMapping."Finished Good Item Group Code";
            UPG."Finished Goods Item No." := CIMControllerURLMapping."Finished Good Item No.";
            UPG."CIM Controller URL Code" := CIMControllerURLMapping."CIM Controller URL Code";
            if not UPG.Insert() then;
        until CIMControllerURLMapping.Next() = 0;
    end;

    procedure "PVS_Cost_Center_Move_To_UPG"()
    var
        CostCenter: Record "PVS Cost Center";
        UPG: Record "PVS UPG CIM Cost Center Ext";
    begin
        if CostCenter.IsEmpty then
            exit;
        repeat

            UPG.Code := CostCenter.Code;
            UPG."PVS CIM Device Code" := CostCenter."CIM Device Code";
            UPG."PVS Running Ratio Qty." := CostCenter."Running Ratio Quantity";
            UPG."PVS Running Ratio Seconds" := CostCenter."Running Ratio Seconds";
            UPG."PVS Esko Press Brand" := CostCenter."Esko Press Brand";
            //NOTE Add These lines in for Newer version of CIM
            //UPG."PVS Esko Print Process" := CostCenter."Esko Print Process";
            //UPG."PVS Machine ID" := CostCenter."Machine ID";  

            if not UPG.Insert() then;
        until CostCenter.Next() = 0;
    end;

    procedure PVS_UPG_CIM_Device_Move_To_UPG()

    var
        CIMDevice: Record "PVS CIM Device";
        UPG: Record "PVS UPG CIM Device";
    begin
        if CIMDevice.IsEmpty then
            exit;
        CIMDevice.findset();
        repeat

            UPG.Code := CIMDevice.Code;
            UPG.Name := CIMDevice.Name;
            UPG."Controller Code" := CIMDevice."Controller Code";
            UPG."JMF Level" := CIMDevice."JMF Level";
            UPG."Device ID" := CIMDevice."Device ID";
            UPG."Device Type" := CIMDevice."Device Type";
            UPG."Descriptive Name" := CIMDevice."Descriptive Name";
            //NOTE Add These lines in for Newer version of CIM
            // UPG."Report Total No. of Plates" := CIMDevice."Report Total No. of Plates";
            UPG.Closed := CIMDevice.Closed;
            UPG."Device Sequence" := CIMDevice."Device Sequence";
            UPG."Max Speed" := CIMDevice."Max Speed";
            UPG."External Reference Code" := CIMDevice."External Reference Code";
            UPG."PrePress Job Creation" := CIMDevice."PrePress Job Creation";
            UPG."Bitmap Code Big" := CIMDevice."Bitmap Code Big";
            UPG."Bitmap Code Small" := CIMDevice."Bitmap Code Small";
            UPG.Picture := CIMDevice.Picture;
            UPG.UPC := CIMDevice.UPC;
            UPG.DeviceFamily := CIMDevice.DeviceFamily;
            UPG.FriendlyName := CIMDevice.FriendlyName;
            UPG.Manufacturer := CIMDevice.Manufacturer;
            UPG.ModelDescription := CIMDevice.ModelDescription;
            UPG.ModelName := CIMDevice.ModelName;
            UPG.ModelNumber := CIMDevice.ModelNumber;
            UPG.ICSVersions := CIMDevice.ICSVersions;
            UPG.JDFErrorURL := CIMDevice.JDFErrorURL;
            UPG.JDFInputURL := CIMDevice.JDFInputURL;
            UPG.JDFOutputURL := CIMDevice.JDFOutputURL;
            UPG.JDFVersions := CIMDevice.JDFVersions;
            UPG.JMFSenderID := CIMDevice.JMFSenderID;
            UPG.JMFURL := CIMDevice.JMFURL;
            upg."Serial No." := CIMDevice."Serial No.";
            UPG.PresentationURL := CIMDevice.PresentationURL;
            UPG.SecureJMFURL := CIMDevice.SecureJMFURL;
            UPG.Directory := CIMDevice.Directory;
            UPG.Type := CIMDevice.Type;
            UPG."Counter Channel" := CIMDevice."Counter Channel";
            UPG."Switches From Channel" := CIMDevice."Switches From Channel";
            UPG."Switches To Channel" := CIMDevice."Switches To Channel";
            UPG."Switches No. Of Channels" := CIMDevice."Switches No. Of Channels";
            UPG."Switches Channels" := CIMDevice."Switches Channels";
            UPG."Enable Switches" := CIMDevice."Enable Switches";
            UPG."AutoCount ID" := CIMDevice."AutoCount ID";
            UPG."AutoCount Plant ID" := CIMDevice."AutoCount Plant ID";
            UPG."Use AutoCount As Machine Cntr" := CIMDevice."Use AutoCount As Machine Cntr";
            if not UPG.Insert() then;
        until CIMDevice.Next() = 0;
    end;
    //NOTE Add This for Newer version of CIM
    //  procedure PVS_CIM_External_Connector_Log_Move_To_UPG()
    //  var
    //      CIMExternalConnectorLog: Record "PVS CIM External Connector Log";
    //      UPG: Record "PVS UPG CIM Ext Connec Log";
    //  begin
    //      if CIMExternalConnectorLog.IsEmpty then
    //          exit;
    //          CIMExternalConnectorLog.findset();
    //      repeat

    //          UPG."Entry No." := CIMExternalConnectorLog."Entry No.";

    //          if not UPG.Insert() then;
    //      until CIMExternalConnectorLog.Next() = 0;
    //  end;  
    //NOTE Add This for Newer version of CIM
    // procedure "PVS_Product_Group_Move_To_UPG"()
    //     var
    //         ProductGroup: Record "PVS Product Group";
    //         UPG: Record "PVSUPGCIMProductGroupExt";
    //     begin
    //         if ProductGroup.IsEmpty then
    //             exit;
    //         repeat

    //             UPG.Code := ProductGroup.Code;
    //             UPG."PVS Esko ProductType" := ProductGroup."Esko ProductType";
    //             If not UPG.Insert() then;
    //         until ProductGroup.Next() = 0;
    //     end; 
    procedure PVS_UPG_CIM_Setup_Move_To_UPG()
    var
        CIMSetup: Record "PVS CIM Setup";
        UPG: Record "PVS UPG CIM Setup";
    begin
        if CIMSetup.IsEmpty then
            exit;
        CIMSetup.findset();
        repeat

            UPG."KEY" := CIMSetup."KEY";
            UPG."Test Mode" := CIMSetup."Test Mode";
            UPG."Hotfolder Customer Intents" := CIMSetup."Hotfolder Customer Intents";
            UPG."JMF Channel IP" := CIMSetup."JMF Channel IP";
            UPG."JMF Channel Port" := CIMSetup."JMF Channel Port";
            UPG."JMF Channel Domain" := CIMSetup."JMF Channel Domain";
            UPG."WCF OnPremise Port" := CIMSetup."WCF OnPremise Port";
            UPG."HTTP Listener Port" := CIMSetup."HTTP Listener Port";
            UPG."HTTP Status Port" := CIMSetup."HTTP Status Port";
            UPG."JDF Sender ID Suffix" := CIMSetup."JDF Sender ID Suffix";
            //NOTE Add This for Newer version of CIM
            //UPG."Disable Scheduler in External" := CIMSetup."Disable Scheduler in External";
            UPG."Delete Response History" := CIMSetup."Delete Response History";
            UPG."Retain History Date Formula" := CIMSetup."Retain History Date Formula";
            UPG."JDF Version" := CIMSetup."JDF Version";
            UPG."Max Msg Size For Service Tier" := CIMSetup."Max Msg Size For Service Tier";
            UPG."Max Msg Size To Initiate Async" := CIMSetup."Max Msg Size To Initiate Async";
            UPG."Transform URL To MIME" := CIMSetup."Transform URL To MIME";
            UPG."Test Controller Code" := CIMSetup."Test Controller Code";
            UPG."Test Disable Auto Processing" := CIMSetup."Test Disable Auto Processing";
            UPG."Test Enable Multi-ID Encoding" := CIMSetup."Test Enable Multi-ID Encoding";
            //NOTE Add This for Newer version of CIM
            //UPG."Test JDF File Blob" := CIMSetup."Test JDF File Blob";
            //UPG."Test JDF File Name" := CIMSetup."Test JDF File Name";
            UPG."JDF Descriptive Naming" := CIMSetup."JDF Descriptive Naming";
            UPG."CIM Queue Blocked" := CIMSetup."CIM Queue Blocked";
            UPG."CIM Session ID" := CIMSetup."CIM Session ID";
            UPG."CIM Server Instance ID" := CIMSetup."CIM Server Instance ID";
            UPG."CIM Task ID" := CIMSetup."CIM Task ID";
            UPG."DCM Queue Blocked" := CIMSetup."DCM Queue Blocked";
            UPG."DCM Session ID" := CIMSetup."DCM Session ID";
            UPG."DCM Server Instance ID" := CIMSetup."DCM Server Instance ID";
            UPG."DCM Task ID" := CIMSetup."DCM Task ID";
            UPG."Timer Interval" := CIMSetup."Timer Interval";
            UPG."Messages Received" := CIMSetup."Messages Received";
            UPG."WCF Service Started" := CIMSetup."WCF Service Started";
            UPG."WCF Service Running" := CIMSetup."WCF Service Running";
            UPG."WCF Service Stopped" := CIMSetup."WCF Service Stopped";
            UPG."WCF Service Version" := CIMSetup."WCF Service Version";
            UPG."WCF Service Started As User ID" := CIMSetup."WCF Service Started As User ID";
            UPG."WCF Service IP Address" := CIMSetup."WCF Service IP Address";
            UPG."Timer Interval (DCM)" := CIMSetup."Timer Interval (DCM)";
            UPG."Job Ticket ID" := CIMSetup."Job Ticket ID";
            UPG."Job Ticket File Type" := CIMSetup."Job Ticket File Type";
            UPG.Responsible := CIMSetup.Responsible;
            UPG."Esko JDF Integration Active" := CIMSetup."Esko JDF Integration Active";
            //NOTE Add This for Newer version of CIM
            //UPG."PVS User Login" := CIMSetup."PVS User Login";
            //UPG."PVS User Password" := CIMSetup."PVS User Password";
            //UPG."XMPIE Front End Port" := CIMSetup."XMPIE Front End Port";
            //UPG."XMPIE Web Service URL" := CIMSetup."XMPIE Web Service URL";
            if not UPG.Insert() then;

        until CIMSetup.Next() = 0;
    end;

    procedure "PVS_Customer_JDF_Intent_Files_Move_To_UPG"()
    var
        CustomerJDFIntentFiles: Record "PVS Customer JDF Intent Files";
        UPG: Record "PVS UPG Cust JDF Intent Files";
    begin
        if CustomerJDFIntentFiles.IsEmpty then
            exit;
        CustomerJDFIntentFiles.findset();
        repeat

            UPG."Entry No." := CustomerJDFIntentFiles."Entry No.";
            UPG.Status := CustomerJDFIntentFiles.Status;
            UPG."Error Message" := CustomerJDFIntentFiles."Error Message";
            UPG."Processing Time" := CustomerJDFIntentFiles."Processing Time";
            UPG."File Size" := CustomerJDFIntentFiles."File Size";
            UPG.ID := CustomerJDFIntentFiles.ID;
            UPG."File BLOB" := CustomerJDFIntentFiles."File BLOB";
            UPG."File Name" := CustomerJDFIntentFiles."File Name";
            UPG."File Date" := CustomerJDFIntentFiles."File Date";
            UPG."File Time" := CustomerJDFIntentFiles."File Time";
            UPG."Creation Date" := CustomerJDFIntentFiles."Creation Date";
            UPG."Creation Time" := CustomerJDFIntentFiles."Creation Time";
            If not UPG.Insert() then;
        until CustomerJDFIntentFiles.Next() = 0;
    end;

    procedure "PVS_Esko_Setup_Move_To_UPG"()
    var
        EskoSetup: Record "PVS Esko Setup";
        UPG: Record "PVS UPG Esko Setup";
    begin
        if EskoSetup.IsEmpty then
            exit;
        EskoSetup.findset();
        repeat

            UPG."KEY" := EskoSetup."KEY";
            UPG."AE Connect Server" := EskoSetup."AE Connect Server";
            UPG."AE Connect Port" := EskoSetup."AE Connect Port";
            UPG."Integration Activated" := EskoSetup."Integration Activated";
            UPG."AE Container Share Name" := EskoSetup."AE Container Share Name";
            UPG."Sync Endpoint" := EskoSetup."Synchronization Endpoint";
            UPG."Processing Endpoint" := EskoSetup."Processing Endpoint";
            UPG."AE Server User Name" := EskoSetup."AE Server Username";
            UPG."AE Server Password" := EskoSetup."AE Server Password";
            UPG."AE Server Domain" := EskoSetup."AE Server Domain";
            UPG."Default Substrate Queue" := EskoSetup."Default Substrate Queue";
            UPG."CAD Spec. Base Folder Name" := EskoSetup."CAD Spec Base Folder Name";
            UPG."CAD Spec. ARD Folder Name" := EskoSetup."CAD Spec ARD Folder Name";
            UPG."CAD Spec. JPG Folder Name" := EskoSetup."CAD Spec JPG Folder Name";
            UPG."CAD Spec. PDF Folder Name" := EskoSetup."CAD Spec PDF Folder Name";
            UPG."CAD Spec. Interm. Folder Name" := EskoSetup."CAD Spec Interm. Folder Name";
            UPG."CAD Spec. Notific. Folder Name" := EskoSetup."CAD Spec Notific. Folder Name";
            UPG."CAD Spec. Error Folder Name" := EskoSetup."CAD Spec Error Folder Name";
            UPG."Run List Folder Path" := EskoSetup."RunList Folder Path";
            UPG."Request 3D Previews" := EskoSetup."Request 3D Previews";
            UPG."Incoming Imposition File Mask" := EskoSetup."Incoming Imposition File Mask";
            UPG."Incoming Strct. Dsg. File Mask" := EskoSetup."Incoming Strct. Dsg. File Mask";
            UPG."Allow Mfg Sheets without Job" := EskoSetup."Allow Mfg Sheets without Job";
            UPG."Debug Mode Enabled" := EskoSetup."Debug Mode Enabled";
            UPG."Service Tier Debug Path" := EskoSetup."Service-Tier Debug Path";
            UPG."No. Series CAD Specs." := EskoSetup."NoSeries CAD Spec";
            UPG."No. Series Mfg. Sheet" := EskoSetup."NoSeries Mfg Sheet";

            If not UPG.Insert() then;
        until EskoSetup.Next() = 0;
    end;

    procedure "PVS_JMF_Known_Messages_Move_To_UPG"()
    var
        JMFKnownMessages: Record "PVS JMF Known Messages";
        UPG: Record "PVS UPG JMF Known Messages";
    begin
        if JMFKnownMessages.IsEmpty then
            exit;
        JMFKnownMessages.FindSet();
        repeat

            UPG."Controller Code" := JMFKnownMessages."Controller Code";
            UPG.Type := JMFKnownMessages.Type;
            UPG.JMFRole := JMFKnownMessages.JMFRole;
            UPG.Acknowledge := JMFKnownMessages.Acknowledge;
            UPG.Command := JMFKnownMessages.Command;
            UPG.Persistent := JMFKnownMessages.Persistent;
            UPG."Query" := JMFKnownMessages."Query";
            UPG.Registration := JMFKnownMessages.Registration;
            UPG.Signal := JMFKnownMessages.Signal;
            UPG."URLSchema File" := JMFKnownMessages."URLSchema File";
            UPG."URLSchema FTP" := JMFKnownMessages."URLSchema FTP";
            UPG."URLSchema HTTP" := JMFKnownMessages."URLSchema HTTP";
            UPG."URLSchema HTTPS" := JMFKnownMessages."URLSchema HTTPS";

            If not UPG.Insert() then;
        until JMFKnownMessages.Next() = 0;
    end;

    procedure "PVS_Private_Namespace_Const_Move_To_UPG"()
    var
        PrivateNamespaceConst: Record "PVS Private Namespace Const.";
        UPG: Record "PVS UPG Private Namespa Const";
    begin
        if PrivateNamespaceConst.IsEmpty then
            exit;
        PrivateNamespaceConst.FindSet();
        repeat

            UPG."Controller Code" := PrivateNamespaceConst."Controller Code";
            UPG.Namespace := PrivateNamespaceConst.Namespace;
            UPG."Private Namespace" := PrivateNamespaceConst."Private Namespace";
            UPG."Tag Name" := PrivateNamespaceConst."Tag Name";
            UPG.Value := PrivateNamespaceConst.Value;
            UPG.Description := PrivateNamespaceConst.Description;
            If not UPG.Insert() then;
        until PrivateNamespaceConst.Next() = 0;
    end;

    procedure "PVS_DCM_Input_Mask_Move_To_UPG"()
    var
        DCMInputMask: Record "PVS DCM Input Mask";
        UPG: Record "PVS UPG DCM Input Mask";
    begin
        if DCMInputMask.IsEmpty then
            exit;
        DCMInputMask.FindSet();
        repeat

            UPG."Entry No." := DCMInputMask."Entry No.";
            UPG."Device Code" := DCMInputMask."Device Code";
            UPG."Cost Centre Code" := DCMInputMask."Cost Centre Code";
            UPG."Input Mask" := DCMInputMask."Input Mask";
            UPG."Work Code" := DCMInputMask."Work Code";
            UPG."Input Mask (User)" := DCMInputMask."Input Mask (User)";
            UPG."Include Counter" := DCMInputMask."Include Counter";
            UPG."Device Status" := DCMInputMask."Device Status";
            UPG.Priority := DCMInputMask.Priority;
            UPG."Created By" := DCMInputMask."Created By";
            UPG."Created Date" := DCMInputMask."Created Date";
            UPG."Created Time" := DCMInputMask."Created Time";
            UPG."Modified By" := DCMInputMask."Modified By";
            UPG."Modified Date" := DCMInputMask."Modified Date";
            UPG."Modified Time" := DCMInputMask."Modified Time";
            If not UPG.Insert() then;
        until DCMInputMask.Next() = 0;
    end;

    //NOTE Add This for Newer version of CIM
    // procedure "PVS_DCM_Moxa_Entry_Move_To_UPG"()
    // var
    //     DCMMoxaEntry: Record "PVS DCM Moxa Entry";
    //     UPG: Record "PVS UPG DCM Moxa Entry";
    // begin
    //     if DCMMoxaEntry.IsEmpty then
    //         exit;
    //     DCMMoxaEntry.FindSet();
    //     repeat
    //         
    //         UPG."Entry No." := DCMMoxaEntry."Entry No.";
    //         UPG."Data String" := DCMMoxaEntry."Data String";
    //         UPG."CIM Controller Code" := DCMMoxaEntry."CIM Controller Code";
    //         UPG."Time Milliseconds" := DCMMoxaEntry."Time Milliseconds";
    //         UPG."DateTime (Added)" := DCMMoxaEntry."DateTime (Added)";
    //         If not UPG.Insert() then;
    //     until DCMMoxaEntry.Next() = 0;
    // end;

    //NOTE Add This for Newer version of CIM
    // procedure "PVS_DCM_Moxa_Status_Move_To_UPG"()
    // var
    //     CMMoxaStatus: Record "PVS DCM Moxa Status";
    //     UPG: Record "PVS UPG DCM Moxa Status";
    // begin
    //     if CMMoxaStatus.IsEmpty then
    //         exit;
    //     CMMoxaStatus.FindSet();
    //     repeat
    //         
    //         UPG."Cost Center Code" := CMMoxaStatus."Cost Center Code";
    //         UPG."Now Time" := CMMoxaStatus."Now Time";
    //         UPG.Counter := CMMoxaStatus.Counter;
    //         UPG.Running := CMMoxaStatus.Running;
    //         UPG."Running Speed" := CMMoxaStatus."Running Speed";

    //         if not UPG.Insert() then;
    //     until CMMoxaStatus.Next() = 0;
    // end;
    procedure "PVS_Esko_Manufacturing_Move_To_UPG"()
    var
        EskoManufacturing: Record "PVS Esko Manufacturing";
        UPG: Record "PVS UPG Esko Manufacturing";
    begin
        if EskoManufacturing.IsEmpty then
            exit;
        EskoManufacturing.FindSet();
        repeat

            UPG."Mfg. Sheet No." := EskoManufacturing."Mfg. Sheet No.";
            UPG."Mfg. File Path" := EskoManufacturing."Mfg. File Path";
            UPG."Mfg. File Name" := EskoManufacturing."Mfg. File Name";
            UPG.Description := EskoManufacturing.Description;
            UPG."Imposition Picture" := EskoManufacturing."Imposition Picture";
            UPG."Sheet Width" := EskoManufacturing."Sheet Width";
            UPG."Sheet Length" := EskoManufacturing."Sheet Length";
            UPG."Artios Board Code" := EskoManufacturing."Artios Board Code";
            UPG."Artios Printing Press" := EskoManufacturing."Artios Printing Press";
            UPG."Artios Die Press" := EskoManufacturing."Artios Die Press";
            UPG."Grain Direction" := EskoManufacturing."Grain Direction";
            UPG."Paper Item No." := EskoManufacturing."Paper Item No.";
            UPG."Plate Item No." := EskoManufacturing."Plate Item No.";
            UPG."Plate Length" := EskoManufacturing."Plate Length";
            UPG."Plate Width" := EskoManufacturing."Plate Width";

            If not UPG.Insert() then;
        until EskoManufacturing.Next() = 0;
    end;

    procedure "PVS_Workflow_Partner_Commands_Move_To_UPG"()
    var
        WorkflowPartnerCommands: Record "PVS Workflow Partner Commands";
        UPG: Record "PVS UPG Workflow Partner Comma";
    begin
        if WorkflowPartnerCommands.IsEmpty then
            exit;
        WorkflowPartnerCommands.FindSet();
        repeat

            UPG."Entry No." := WorkflowPartnerCommands."Entry No.";
            UPG."Entry Type" := WorkflowPartnerCommands."Entry Type";
            UPG."Device Code" := WorkflowPartnerCommands."Device Code";
            UPG."Item No." := WorkflowPartnerCommands."Item No.";
            UPG.ID := WorkflowPartnerCommands.ID;
            UPG.Job := WorkflowPartnerCommands.Job;
            UPG.Version := WorkflowPartnerCommands.Version;
            UPG."Sheet ID" := WorkflowPartnerCommands."Sheet ID";
            UPG.Command := WorkflowPartnerCommands.Command;
            UPG.Status := WorkflowPartnerCommands.Status;
            UPG."Error Message" := WorkflowPartnerCommands."Error Message";
            UPG.Submitted := WorkflowPartnerCommands.Submitted;
            UPG."Submission Pending" := WorkflowPartnerCommands."Submission Pending";
            UPG."File Name" := WorkflowPartnerCommands."File Name";
            UPG."File BLOB" := WorkflowPartnerCommands."File BLOB";
            //NOTE Add This for Newer version of CIM
            //UPG.Information := WorkflowPartnerCommands.Information;
            //UPG.Text1 := WorkflowPartnerCommands.Text1;
            UPG."Creation Date" := WorkflowPartnerCommands."Creation Date";
            UPG."Creation Time" := WorkflowPartnerCommands."Creation Time";
            UPG."Created By User" := WorkflowPartnerCommands."Created By User";
            UPG."Processing Time" := WorkflowPartnerCommands."Processing Time";
            UPG."Send To Target URL" := WorkflowPartnerCommands."Send To Target URL";
            UPG."Submission Attempts" := WorkflowPartnerCommands."Submission Attempts";
            UPG."Submission Command ID" := WorkflowPartnerCommands."Submission Command ID";
            UPG."Job ID" := WorkflowPartnerCommands."Job ID";
            UPG."Job Part ID" := WorkflowPartnerCommands."Job Part ID";
            UPG."Last Entry No." := WorkflowPartnerCommands."Last Entry No.";
            UPG."Controller Code" := WorkflowPartnerCommands."Controller Code";
            UPG."CIM Controller URL Code" := WorkflowPartnerCommands."CIM Controller URL Code";
            UPG."Esko BackStage Ticket Name" := WorkflowPartnerCommands."Esko BackStage Ticket Name";
            //NOTE Add This for Newer version of CIM
            //UPG."PVS Esko BackStage Task Type" := WorkflowPartnerCommands."PVS Esko BackStage Task Type";
            //UPG."External Status" := WorkflowPartnerCommands."External Status";
            //UPG."File To External System" := WorkflowPartnerCommands."File To External System";
            //UPG."File From External System" := WorkflowPartnerCommands."File From External System";
            //UPG."Last Update From Connector" := WorkflowPartnerCommands."Last Update From Connector";

            if not UPG.Insert() then;
        until WorkflowPartnerCommands.Next() = 0;
    end;

    procedure "PVS_Workflow_Partner_MIME_Buf_Move_To_UPG"()
    var
        WorkflowPartnerMIMEBuf: Record "PVS Workflow Partner MIME Buf.";
        UPG: Record "PVS UPG Workflow Part MIME Buf";
    begin
        if WorkflowPartnerMIMEBuf.IsEmpty then
            exit;
        WorkflowPartnerMIMEBuf.FindSet();
        repeat

            UPG.Type := WorkflowPartnerMIMEBuf.Type;
            UPG."Part Acid" := WorkflowPartnerMIMEBuf."Part Acid";
            UPG."Part No." := WorkflowPartnerMIMEBuf."Part No";
            UPG."Closing Part" := WorkflowPartnerMIMEBuf."Closing Part";
            UPG."Response Entry No." := WorkflowPartnerMIMEBuf."Response Entry No";
            UPG."Part Body" := WorkflowPartnerMIMEBuf."Part Body";
            UPG."Base64 Encoded" := WorkflowPartnerMIMEBuf."Base64 Encoded";
            UPG."Body Size" := WorkflowPartnerMIMEBuf."Body Size";
            UPG."Content Type" := WorkflowPartnerMIMEBuf."ContentType";
            UPG."File Name" := WorkflowPartnerMIMEBuf."FileName";
            If not UPG.Insert() then;
        until WorkflowPartnerMIMEBuf.Next() = 0;
    end;

    procedure "PVS_Workflow_Partner_Que_Ent_Move_To_UPG"()
    var
        WorkflowPartnerQue: Record "PVS Workflow Partner Que. Ent.";
        UPG: Record "PVS UPG Workflow Partner Que.";
    begin
        if WorkflowPartnerQue.IsEmpty then
            exit;
        WorkflowPartnerQue.FindSet();
        repeat

            UPG."Entry No." := WorkflowPartnerQue."Entry No.";
            UPG.SenderID := WorkflowPartnerQue.SenderID;
            //NOTE Add This for Newer version of CIM
            //UPG."PVS Device Code" := WorkflowPartnerQue."Device Code";
            //UPG."PVS Controller Code" := WorkflowPartnerQue."Controller Code";
            UPG.DeviceID := WorkflowPartnerQue.DeviceID;
            UPG."Event TimeStamp" := WorkflowPartnerQue."Event TimeStamp";
            UPG.JobID := WorkflowPartnerQue.JobID;
            UPG.JobPartID := WorkflowPartnerQue.JobPartID;
            UPG."Event System" := WorkflowPartnerQue."Event System";
            UPG."Queue Status" := WorkflowPartnerQue."Queue Status";
            UPG."Queue Entry Submission Time" := WorkflowPartnerQue."Queue Entry Submission Time";
            UPG."Queue EntryID" := WorkflowPartnerQue."Queue EntryID";
            UPG."Queue Entry Priority" := WorkflowPartnerQue."Queue Entry Priority";
            UPG."Acknowledge Type" := WorkflowPartnerQue."Acknowledge Type";
            UPG.RefID := WorkflowPartnerQue.RefID;
            UPG."File BLOB" := WorkflowPartnerQue."File BLOB";
            UPG."DateTime Received" := WorkflowPartnerQue."DateTime Recieved";
            UPG."Response Type" := WorkflowPartnerQue."Response Type";
            UPG."Response Sub Type" := WorkflowPartnerQue."Response Sub Type";
            UPG.Status := WorkflowPartnerQue."PVS Status";
            UPG."Error Text" := WorkflowPartnerQue."PVS Error Text";

            if not UPG.Insert() then;
        until WorkflowPartnerQue.Next() = 0;
    end;

    procedure "PVS_Workflow_Partner_Resp_At_Move_To_UPG"()
    var
        WorkflowPartnerRespAt: Record "PVS Workflow Partner Resp. At.";
        UPG: Record "PVS UPG Workflow Partner Resp";
    begin
        if WorkflowPartnerRespAt.IsEmpty then
            exit;
        WorkflowPartnerRespAt.FindSet();
        repeat
            UPG."Entry No." := WorkflowPartnerRespAt."Entry No.";
            UPG."JMF Response Entry No." := WorkflowPartnerRespAt."JMF Response Entry No.";
            UPG."DateTime Received" := WorkflowPartnerRespAt."DateTime Received";
            UPG."File BLOB" := WorkflowPartnerRespAt."File BLOB";
            UPG."File Name" := WorkflowPartnerRespAt."FileName";
            UPG.ContentID := WorkflowPartnerRespAt.ContentID;
            UPG.ContentType := WorkflowPartnerRespAt.ContentType;
            UPG."File Size" := WorkflowPartnerRespAt."File Size";
            If not UPG.Insert() then;
        until WorkflowPartnerRespAt.Next() = 0;
    end;

    procedure "PVS_Workflow_Partner_Responses_Move_To_UPG"()
    var
        WorkflowPartnerResponses: Record "PVS Workflow Partner Responses";
        UPG: Record "PVS UPG Workflow Partner Respo";
    begin
        if WorkflowPartnerResponses.IsEmpty then
            exit;
        WorkflowPartnerResponses.FindSet();
        repeat
            UPG."Entry No." := WorkflowPartnerResponses."Entry No.";
            UPG.SenderID := WorkflowPartnerResponses.SenderID;
            UPG."Device Code" := WorkflowPartnerResponses."PVS Device Code";
            UPG."Controller Code" := WorkflowPartnerResponses."PVS Controller Code";
            UPG.DeviceID := WorkflowPartnerResponses.DeviceID;
            UPG."Event TimeStamp" := WorkflowPartnerResponses."Event TimeStamp";
            UPG."JobPhase JobID" := WorkflowPartnerResponses."JobPhase JobID";
            UPG."JobPhase JobPartID" := WorkflowPartnerResponses."JobPhase JobPartID";
            UPG."Event System" := WorkflowPartnerResponses."Event System";
            UPG."PVS ID" := WorkflowPartnerResponses."PVS ID";
            UPG.Job := WorkflowPartnerResponses."PVS Job";
            UPG."Plan ID" := WorkflowPartnerResponses."PVS PlanID";
            UPG."Item No." := WorkflowPartnerResponses."PVS Item No.";
            UPG."Job Item Entry No." := WorkflowPartnerResponses."PVS Job Item Entry No.";
            UPG."Process ID" := WorkflowPartnerResponses."PVS ProcessID";
            UPG."Device TotalProductionCounter" := WorkflowPartnerResponses."Device TotalProductionCounter";
            UPG.ID := WorkflowPartnerResponses.ID;
            UPG."Device Status Text" := WorkflowPartnerResponses."Device Status Text";
            UPG."Device StatusDetails Text" := WorkflowPartnerResponses."Device StatusDetails Text";
            UPG."JobPhase Status Text" := WorkflowPartnerResponses."JobPhase Status Text";
            UPG."JobPhase StatusDetails Text" := WorkflowPartnerResponses."JobPhase StatusDetails Text";
            UPG."JobPhase Amount" := WorkflowPartnerResponses."JobPhase Amount";
            UPG."JobPhase Waste" := WorkflowPartnerResponses."JobPhase Waste";
            UPG.JobPhaseCounter := WorkflowPartnerResponses.JobPhaseCounter;
            //NOTE Add This for Newer version of CIM
            // UPG."Sheet ID" := WorkflowPartnerResponses."Sheet ID";
            UPG."JobPhase Included" := WorkflowPartnerResponses."JobPhase Included";
            UPG.EmployeeID := WorkflowPartnerResponses.EmployeeID;
            UPG."JobPhase PercentCompleted" := WorkflowPartnerResponses."JobPhase PercentCompleted";
            UPG."JobPhase RestTime" := WorkflowPartnerResponses."JobPhase RestTime";
            UPG."JobPhase Speed" := WorkflowPartnerResponses."JobPhase Speed";
            UPG."JobPhase Start DateTime" := WorkflowPartnerResponses."JobPhase Start DateTime";
            UPG."JobPhase PhaseAmount" := WorkflowPartnerResponses."JobPhase PhaseAmount";
            UPG."JobPhase TotalAmount" := WorkflowPartnerResponses."JobPhase TotalAmount";
            UPG."Device OperationMode" := WorkflowPartnerResponses."Device OperationMode";
            UPG."Device Condition" := WorkflowPartnerResponses."Device Condition";
            UPG."JobPhase End DateTime" := WorkflowPartnerResponses."JobPhase End DateTime";
            UPG."Costing Type" := WorkflowPartnerResponses."pvs Costing Type";
            UPG."Cost Center Code" := WorkflowPartnerResponses."pvs Cost Center Code";
            UPG."Order No." := WorkflowPartnerResponses."pvs Order No.";
            UPG."Item No." := WorkflowPartnerResponses."pvs Item No.";
            UPG."Event Comment" := WorkflowPartnerResponses."Event Comment";
            UPG."Work Code" := WorkflowPartnerResponses."Work Code";
            UPG."Event Text" := WorkflowPartnerResponses."Event Text";
            UPG."Resource Actual Amount" := WorkflowPartnerResponses."Resource Actual Amount";
            UPG."Resource Amount" := WorkflowPartnerResponses."Resource Amount";
            UPG."Resource AvailableAmount" := WorkflowPartnerResponses."Resource AvailableAmount";
            UPG."Resource Level" := WorkflowPartnerResponses."Resource Level";
            UPG."Resource Location" := WorkflowPartnerResponses."Resource Location";
            UPG."Resource ModuleID" := WorkflowPartnerResponses."Resource ModuleID";
            UPG."Resource ModuleIndex" := WorkflowPartnerResponses."Resource ModuleIndex";
            UPG."Resource ResourceName" := WorkflowPartnerResponses."Resource ResourceName";
            UPG."Resource ProcessUsage" := WorkflowPartnerResponses."Resource ProcessUsage";
            UPG."Resource ProductID" := WorkflowPartnerResponses."Resource ProductID";
            UPG."Resource Status" := WorkflowPartnerResponses."Resource Status";
            UPG."Resource Unit" := WorkflowPartnerResponses."Resource Unit";
            UPG.CostCenterID := WorkflowPartnerResponses.CostCenterID;
            UPG.CostCenterName := WorkflowPartnerResponses.CostCenterName;
            UPG.QueueEntryID := WorkflowPartnerResponses.QueueEntryID;
            UPG."ReturnQueueEntry Aborted" := WorkflowPartnerResponses."ReturnQueueEntry Aborted";
            UPG."ReturnQueueEntry Completed" := WorkflowPartnerResponses."ReturnQueueEntry Completed";
            UPG."ReturnQueueEntry Priority" := WorkflowPartnerResponses."ReturnQueueEntry Priority";
            UPG."ReturnQueueEntry URL" := WorkflowPartnerResponses."ReturnQueueEntry URL";
            UPG."Device JMFURL" := WorkflowPartnerResponses."Device JMFURL";
            UPG."File BLOB" := WorkflowPartnerResponses."File BLOB";
            UPG."DateTime Received" := WorkflowPartnerResponses."DateTime Recieved";
            UPG."File Name" := WorkflowPartnerResponses."FileName";
            UPG."Response Type" := WorkflowPartnerResponses."Response Type";
            UPG."Response Sub Type" := WorkflowPartnerResponses."Response Sub Type";
            UPG."PVS Status" := WorkflowPartnerResponses."PVS Status";
            UPG."Posted To Journal" := WorkflowPartnerResponses."PVS Posted to Journal";
            UPG."Posted DateTime" := WorkflowPartnerResponses."PVS Posted Date Time";
            UPG."Error Text" := WorkflowPartnerResponses."PVS Error Text";
            UPG."Message Status" := WorkflowPartnerResponses."PVS Message Status";
            UPG."File Date" := WorkflowPartnerResponses."File Date";
            UPG."File Time" := WorkflowPartnerResponses."File Time";
            UPG."File Size" := WorkflowPartnerResponses."File Size";
            UPG."Device Type" := WorkflowPartnerResponses."Device Type";
            UPG."Device Manufacturer" := WorkflowPartnerResponses."Device Manufacturer";
            UPG.EmployeeShift := WorkflowPartnerResponses.EmployeeShift;
            UPG.EmployeeCostCenterID := WorkflowPartnerResponses.EmployeeCostCenterID;
            UPG.EmployeeCostCenterName := WorkflowPartnerResponses.EmployeeCostCenterName;
            UPG.EmployeeFirstName := WorkflowPartnerResponses.EmployeeFirstName;
            UPG.EmployeeFamilyName := WorkflowPartnerResponses.EmployeeFamilyName;
            UPG.EmployeeRoleApprentice := WorkflowPartnerResponses.EmployeeRoleApprentice;
            UPG.EmployeeRoleAssistant := WorkflowPartnerResponses.EmployeeRoleAssistant;
            UPG.EmployeeRoleCraftsman := WorkflowPartnerResponses.EmployeeRoleCraftsman;
            UPG.EmployeeRoleCSR := WorkflowPartnerResponses.EmployeeRoleCSR;
            UPG.EmployeeRoleManager := WorkflowPartnerResponses.EmployeeRoleManager;
            UPG.EmployeeRoleMaster := WorkflowPartnerResponses.EmployeeRoleMaster;
            UPG.EmployeeRoleOperator := WorkflowPartnerResponses.EmployeeRoleOperator;
            UPG.EmployeeRoleShiftLeader := WorkflowPartnerResponses.EmployeeRoleShiftLeader;
            UPG.EmployeeRoleStandBy := WorkflowPartnerResponses.EmployeeRoleStandBy;
            UPG."Body Parts In Transit" := WorkflowPartnerResponses."Bodyparts In-Transit";
            UPG."Original JMF File" := WorkflowPartnerResponses."Original JMF File";
            UPG."Device Status Text Backup" := WorkflowPartnerResponses."Device Status Text Backup";
            UPG."Device StatusDetails Text Back" := WorkflowPartnerResponses."Device StatusDetails Text Back";
            UPG."Device Status Activity Backup" := WorkflowPartnerResponses."Device Status Activity Backup";
            If not UPG.Insert() then;
        until WorkflowPartnerResponses.Next() = 0;
    end;
}