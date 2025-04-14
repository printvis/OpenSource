/* codeunit 80210 "PTE Upgrade part 3"
{
    Subtype = Upgrade;
    trigger OnUpgradePerCompany()

    begin
        PVS_UPG_CIM_Setup_Move_To_UPG();
        PVS_Customer_JDF_Intent_Files_Move_To_UPG();
        PVS_Esko_Setup_Move_To_UPG();
        PVS_JMF_Known_Messages_Move_To_UPG();
        PVS_Private_Namespace_Const_Move_To_UPG();
        PVS_Esko_Manufacturing_Move_To_UPG();
        PVS_Workflow_Partner_Commands_Move_To_UPG();
        PVS_Workflow_Partner_MIME_Buf_Move_To_UPG();
        PVS_Workflow_Partner_Que_Ent_Move_To_UPG();
        PVS_Workflow_Partner_Resp_At_Move_To_UPG();
        PVS_Workflow_Partner_Responses_Move_To_UPG();
        PVS_CIM_External_Connector_Log_Move_To_UPG();
        PVS_DCM_Input_Mask_Move_To_UPG();
        PVS_Job_Sheet_Move_To_UPG();
        PVS_Product_Group_Move_To_UPG();
        PVS_DCM_Moxa_Entry_Move_To_UPG();
        PVS_DCM_Moxa_Status_Move_To_UPG();
        PVS_CIM_Controller_Move_To_UPG();
        PVS_CIM_Controller_URL_Move_To_UPG();
        PVS_CIM_Controller_URL_Mapping_Move_To_UPG();
        PVS_Cost_Center_Move_To_UPG();
        PVS_UPG_CIM_Device_Move_To_UPG();
    end;

    local procedure PVS_CIM_Controller_Move_To_UPG()
    begin
        if UpgradeTag.HasUpgradeTag(UpgradeTags.PVS_CIM_Controller_Move_To_UPG_Tag()) then
            exit;

        UpgradeLogic.PVS_CIM_Controller_Move_To_UPG();
        UpgradeTag.SetUpgradeTag(UpgradeTags.PVS_CIM_Controller_Move_To_UPG_Tag());
    end;

    local procedure PVS_CIM_Controller_URL_Move_To_UPG()
    begin
        if UpgradeTag.HasUpgradeTag(UpgradeTags.PVS_CIM_Controller_URL_Move_To_UPG_Tag()) then
            exit;

        UpgradeLogic.PVS_CIM_Controller_URL_Move_To_UPG();
        UpgradeTag.SetUpgradeTag(UpgradeTags.PVS_CIM_Controller_URL_Move_To_UPG_Tag());
    end;

    local procedure PVS_CIM_Controller_URL_Mapping_Move_To_UPG()
    begin
        if UpgradeTag.HasUpgradeTag(UpgradeTags.PVS_CIM_Controller_URL_Mapping_Move_To_UPG_Tag()) then
            exit;

        UpgradeLogic.PVS_CIM_Controller_URL_Mapping_Move_To_UPG();
        UpgradeTag.SetUpgradeTag(UpgradeTags.PVS_CIM_Controller_URL_Mapping_Move_To_UPG_Tag());
    end;

    local procedure PVS_Cost_Center_Move_To_UPG()
    begin
        if UpgradeTag.HasUpgradeTag(UpgradeTags.PVS_Cost_Center_Move_To_UPG_Tag()) then
            exit;

        UpgradeLogic.PVS_Cost_Center_Move_To_UPG();
        UpgradeTag.SetUpgradeTag(UpgradeTags.PVS_Cost_Center_Move_To_UPG_Tag());
    end;

    local procedure PVS_UPG_CIM_Device_Move_To_UPG()
    begin
        if UpgradeTag.HasUpgradeTag(UpgradeTags.PVS_UPG_CIM_Device_Move_To_UPG_Tag()) then
            exit;

        UpgradeLogic.PVS_UPG_CIM_Device_Move_To_UPG();
        UpgradeTag.SetUpgradeTag(UpgradeTags.PVS_UPG_CIM_Device_Move_To_UPG_Tag());
    end;

    local procedure PVS_UPG_CIM_Setup_Move_To_UPG()
    begin
        if UpgradeTag.HasUpgradeTag(UpgradeTags.PVS_UPG_CIM_Setup_Move_To_UPG_Tag()) then
            exit;

        UpgradeLogic.PVS_UPG_CIM_Setup_Move_To_UPG();
        UpgradeTag.SetUpgradeTag(UpgradeTags.PVS_UPG_CIM_Setup_Move_To_UPG_Tag());
    end;

    local procedure PVS_Customer_JDF_Intent_Files_Move_To_UPG()
    begin
        if UpgradeTag.HasUpgradeTag(UpgradeTags.PVS_Customer_JDF_Intent_Files_Move_To_UPG_Tag()) then
            exit;

        UpgradeLogic.PVS_Customer_JDF_Intent_Files_Move_To_UPG();
        UpgradeTag.SetUpgradeTag(UpgradeTags.PVS_Customer_JDF_Intent_Files_Move_To_UPG_Tag());
    end;

    local procedure PVS_Esko_Setup_Move_To_UPG()
    begin
        if UpgradeTag.HasUpgradeTag(UpgradeTags.PVS_Esko_Setup_Move_To_UPG_Tag()) then
            exit;

        UpgradeLogic.PVS_Esko_Setup_Move_To_UPG();
        UpgradeTag.SetUpgradeTag(UpgradeTags.PVS_Esko_Setup_Move_To_UPG_Tag());
    end;

    local procedure PVS_JMF_Known_Messages_Move_To_UPG()
    begin
        if UpgradeTag.HasUpgradeTag(UpgradeTags.PVS_JMF_Known_Messages_Move_To_UPG_Tag()) then
            exit;

        UpgradeLogic.PVS_JMF_Known_Messages_Move_To_UPG();
        UpgradeTag.SetUpgradeTag(UpgradeTags.PVS_JMF_Known_Messages_Move_To_UPG_Tag());
    end;

    local procedure PVS_Private_Namespace_Const_Move_To_UPG()
    begin
        if UpgradeTag.HasUpgradeTag(UpgradeTags.PVS_Private_Namespace_Const_Move_To_UPG_Tag()) then
            exit;

        UpgradeLogic.PVS_Private_Namespace_Const_Move_To_UPG();
        UpgradeTag.SetUpgradeTag(UpgradeTags.PVS_Private_Namespace_Const_Move_To_UPG_Tag());
    end;

    local procedure PVS_Esko_Manufacturing_Move_To_UPG()
    begin
        if UpgradeTag.HasUpgradeTag(UpgradeTags.PVS_Esko_Manufacturing_Move_To_UPG_Tag()) then
            exit;

        UpgradeLogic.PVS_Esko_Manufacturing_Move_To_UPG();
        UpgradeTag.SetUpgradeTag(UpgradeTags.PVS_Esko_Manufacturing_Move_To_UPG_Tag());
    end;

    local procedure PVS_Workflow_Partner_Commands_Move_To_UPG()
    begin
        if UpgradeTag.HasUpgradeTag(UpgradeTags.PVS_Workflow_Partner_Commands_Move_To_UPG_Tag()) then
            exit;

        UpgradeLogic.PVS_Workflow_Partner_Commands_Move_To_UPG();
        UpgradeTag.SetUpgradeTag(UpgradeTags.PVS_Workflow_Partner_Commands_Move_To_UPG_Tag());
    end;

    local procedure PVS_Workflow_Partner_MIME_Buf_Move_To_UPG()
    begin
        if UpgradeTag.HasUpgradeTag(UpgradeTags.PVS_Workflow_Partner_MIME_Buf_Move_To_UPG_Tag()) then
            exit;

        UpgradeLogic.PVS_Workflow_Partner_MIME_Buf_Move_To_UPG();
        UpgradeTag.SetUpgradeTag(UpgradeTags.PVS_Workflow_Partner_MIME_Buf_Move_To_UPG_Tag());
    end;

    local procedure PVS_Workflow_Partner_Que_Ent_Move_To_UPG()
    begin
        if UpgradeTag.HasUpgradeTag(UpgradeTags.PVS_Workflow_Partner_Que_Ent_Move_To_UPG_Tag()) then
            exit;

        UpgradeLogic.PVS_Workflow_Partner_Que_Ent_Move_To_UPG();
        UpgradeTag.SetUpgradeTag(UpgradeTags.PVS_Workflow_Partner_Que_Ent_Move_To_UPG_Tag());
    end;

    local procedure PVS_Workflow_Partner_Resp_At_Move_To_UPG()
    begin
        if UpgradeTag.HasUpgradeTag(UpgradeTags.PVS_Workflow_Partner_Resp_At_Move_To_UPG_Tag()) then
            exit;

        UpgradeLogic.PVS_Workflow_Partner_Resp_At_Move_To_UPG();
        UpgradeTag.SetUpgradeTag(UpgradeTags.PVS_Workflow_Partner_Resp_At_Move_To_UPG_Tag());
    end;

    local procedure PVS_Workflow_Partner_Responses_Move_To_UPG()
    begin
        if UpgradeTag.HasUpgradeTag(UpgradeTags.PVS_Workflow_Partner_Responses_Move_To_UPG_Tag()) then
            exit;

        UpgradeLogic.PVS_Workflow_Partner_Responses_Move_To_UPG();
        UpgradeTag.SetUpgradeTag(UpgradeTags.PVS_Workflow_Partner_Responses_Move_To_UPG_Tag());
    end;

    local procedure PVS_CIM_External_Connector_Log_Move_To_UPG()
    begin
        if UpgradeTag.HasUpgradeTag(UpgradeTags.PVS_CIM_External_Connector_Log_Move_To_UPG_Tag()) then
            exit;

        UpgradeLogic.PVS_CIM_External_Connector_Log_Move_To_UPG();
        UpgradeTag.SetUpgradeTag(UpgradeTags.PVS_CIM_External_Connector_Log_Move_To_UPG_Tag());
    end;

    local procedure PVS_Product_Group_Move_To_UPG()
    begin
        if UpgradeTag.HasUpgradeTag(UpgradeTags.PVS_Product_Group_Move_To_UPG_Tag()) then
            exit;

        UpgradeLogic.PVS_Product_Group_Move_To_UPG();
        UpgradeTag.SetUpgradeTag(UpgradeTags.PVS_Product_Group_Move_To_UPG_Tag());
    end;

    local procedure PVS_DCM_Moxa_Entry_Move_To_UPG()
    begin
        if UpgradeTag.HasUpgradeTag(UpgradeTags.PVS_DCM_Moxa_Entry_Move_To_UPG_Tag()) then
            exit;

        UpgradeLogic.PVS_DCM_Moxa_Entry_Move_To_UPG();
        UpgradeTag.SetUpgradeTag(UpgradeTags.PVS_DCM_Moxa_Entry_Move_To_UPG_Tag());
    end;

    local procedure PVS_DCM_Moxa_Status_Move_To_UPG()
    begin
        if UpgradeTag.HasUpgradeTag(UpgradeTags.PVS_DCM_Moxa_Status_Move_To_UPG_Tag()) then
            exit;

        UpgradeLogic.PVS_DCM_Moxa_Status_Move_To_UPG();
        UpgradeTag.SetUpgradeTag(UpgradeTags.PVS_DCM_Moxa_Status_Move_To_UPG_Tag());
    end;

    local procedure PVS_DCM_Input_Mask_Move_To_UPG()
    begin
        if UpgradeTag.HasUpgradeTag(UpgradeTags.PVS_DCM_Input_Mask_Move_To_UPG_Tag()) then
            exit;

        UpgradeLogic.PVS_DCM_Input_Mask_Move_To_UPG();
        UpgradeTag.SetUpgradeTag(UpgradeTags.PVS_DCM_Input_Mask_Move_To_UPG_Tag());
    end;

    local procedure PVS_Job_Sheet_Move_To_UPG()
    begin
        if UpgradeTag.HasUpgradeTag(UpgradeTags.PVS_Job_Sheet_Move_To_UPG_Tag()) then
            exit;

        UpgradeLogic.PVS_Job_Sheet_Move_To_UPG();
        UpgradeTag.SetUpgradeTag(UpgradeTags.PVS_Job_Sheet_Move_To_UPG_Tag());
    end;

    var
        UpgradeLogic: Codeunit "PTE Upgrade Logic Part 3";
        UpgradeTags: Codeunit "PTE UPG CIM Migration Tags";
        UpgradeTag: Codeunit "Upgrade Tag";
} */