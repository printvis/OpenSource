codeunit 80210 "PTE Upgrade part 1"
{
    Subtype = Install;
    trigger OnInstallAppPerCompany()

    begin
        UpgradeLogic.PVS_Job_Sheet_Move_To_UPG();
        UpgradeLogic.PVS_CIM_Controller_Move_To_UPG();
        UpgradeLogic.PVS_CIM_Controller_URL_Move_To_UPG();
        UpgradeLogic.PVS_CIM_Controller_URL_Mapping_Move_To_UPG();
        UpgradeLogic.PVS_Cost_Center_Move_To_UPG();
        UpgradeLogic.PVS_UPG_CIM_Device_Move_To_UPG();
        UpgradeLogic.PVS_UPG_CIM_Setup_Move_To_UPG();
        UpgradeLogic."PVS_Customer_JDF_Intent_Files_Move_To_UPG"();
        UpgradeLogic."PVS_Esko_Setup_Move_To_UPG"();
        UpgradeLogic."PVS_JMF_Known_Messages_Move_To_UPG"();
        UpgradeLogic."PVS_Private_Namespace_Const_Move_To_UPG"();
        UpgradeLogic.PVS_Esko_Manufacturing_Move_To_UPG();
        UpgradeLogic.PVS_Workflow_Partner_Commands_Move_To_UPG();
        UpgradeLogic.PVS_Workflow_Partner_MIME_Buf_Move_To_UPG();
        UpgradeLogic.PVS_Workflow_Partner_Que_Ent_Move_To_UPG();
        UpgradeLogic.PVS_Workflow_Partner_Resp_At_Move_To_UPG();
        UpgradeLogic.PVS_Workflow_Partner_Responses_Move_To_UPG();

        //NOTE Add These lines in for Newer version of CIM
        //PVS_CIM_External_Connector_Log_Move_To_UPG();
        //"PVS_Product_Group_Move_To_UPG"()
        //"PVS_DCM_Moxa_Entry_Move_To_UPG"()
        //"PVS_DCM_Moxa_Status_Move_To_UPG"()
        //"PVS_DCM_Input_Mask_Move_To_UPG"();
    end;

    var
        UpgradeLogic: Codeunit "PTE Upgrade Logic Part 1";
}