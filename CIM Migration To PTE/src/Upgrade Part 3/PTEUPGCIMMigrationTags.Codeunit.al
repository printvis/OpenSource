/* codeunit 80212 "PTE UPG CIM Migration Tags"
{
    Access = Internal;
    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Upgrade Tag", 'OnGetPerCompanyUpgradeTags', '', false, false)]
    local procedure OnGetPerCompanyUpgradeTags(var PerCompanyUpgradeTags: List of [Code[250]]);
    begin
        PerCompanyUpgradeTags.Add(PVS_UPG_CIM_Device_Move_To_UPG_Tag());
        PerCompanyUpgradeTags.Add(PVS_Cost_Center_Move_To_UPG_Tag());
        PerCompanyUpgradeTags.Add(PVS_CIM_Controller_URL_Mapping_Move_To_UPG_Tag());
        PerCompanyUpgradeTags.Add(PVS_CIM_Controller_URL_Move_To_UPG_Tag());
        PerCompanyUpgradeTags.Add(PVS_CIM_Controller_Move_To_UPG_Tag());
        PerCompanyUpgradeTags.Add(PVS_Job_Sheet_Move_To_UPG_Tag());
        PerCompanyUpgradeTags.Add(PVS_DCM_Input_Mask_Move_To_UPG_Tag());
        PerCompanyUpgradeTags.Add(PVS_DCM_Moxa_Status_Move_To_UPG_Tag());
        PerCompanyUpgradeTags.Add(PVS_DCM_Moxa_Entry_Move_To_UPG_Tag());
        PerCompanyUpgradeTags.Add(PVS_Product_Group_Move_To_UPG_Tag());
        PerCompanyUpgradeTags.Add(PVS_Workflow_Partner_Responses_Move_To_UPG_Tag());
        PerCompanyUpgradeTags.Add(PVS_CIM_External_Connector_Log_Move_To_UPG_Tag());
        PerCompanyUpgradeTags.Add(PVS_Workflow_Partner_Resp_At_Move_To_UPG_Tag());
        PerCompanyUpgradeTags.Add(PVS_Workflow_Partner_Que_Ent_Move_To_UPG_Tag());
        PerCompanyUpgradeTags.Add(PVS_Workflow_Partner_MIME_Buf_Move_To_UPG_Tag());
        PerCompanyUpgradeTags.Add(PVS_Workflow_Partner_Commands_Move_To_UPG_Tag());
        PerCompanyUpgradeTags.Add(PVS_Esko_Manufacturing_Move_To_UPG_Tag());
        PerCompanyUpgradeTags.Add(PVS_Private_Namespace_Const_Move_To_UPG_Tag());
        PerCompanyUpgradeTags.Add(PVS_JMF_Known_Messages_Move_To_UPG_Tag());
        PerCompanyUpgradeTags.Add(PVS_Esko_Setup_Move_To_UPG_Tag());
        PerCompanyUpgradeTags.Add(PVS_Customer_JDF_Intent_Files_Move_To_UPG_Tag());
        PerCompanyUpgradeTags.Add(PVS_UPG_CIM_Setup_Move_To_UPG_Tag());
    end;

    procedure PVS_Job_Sheet_Move_To_UPG_Tag(): Code[250]
    begin
        exit('0f0f7b29-2339-4a9f-8fd3-1c71da75e803');
    end;

    procedure PVS_CIM_Controller_Move_To_UPG_Tag(): Code[250]
    begin
        exit('b32cd2a8-43ec-4714-bce5-4e4205b50ed4');
    end;

    procedure PVS_CIM_Controller_URL_Move_To_UPG_Tag(): Code[250]
    begin
        exit('ccbeb07d-d1f6-4908-8198-c855d2605c34');
    end;

    procedure PVS_CIM_Controller_URL_Mapping_Move_To_UPG_Tag(): Code[250]
    begin
        exit('43c85f9a-e133-4418-a6d9-63511154d241');
    end;

    procedure PVS_Cost_Center_Move_To_UPG_Tag(): Code[250]
    begin
        exit('ef90f982-e162-4046-a687-5737e7a67202');
    end;

    procedure PVS_UPG_CIM_Device_Move_To_UPG_Tag(): Code[250]
    begin
        exit('d6a58478-6951-475d-9242-4d6ce56f33c3');
    end;

    procedure PVS_UPG_CIM_Setup_Move_To_UPG_Tag(): Code[250]
    begin
        exit('791c85ec-ab36-4daa-b844-9a3a1dcc029e');
    end;

    procedure PVS_Customer_JDF_Intent_Files_Move_To_UPG_Tag(): Code[250]
    begin
        exit('4cb49ce1-75cc-4e82-b00b-69bb82c193f8');
    end;

    procedure PVS_Esko_Setup_Move_To_UPG_Tag(): Code[250]
    begin
        exit('9c827f61-9a1b-4a7b-9397-7eb3d8259c24');
    end;

    procedure PVS_JMF_Known_Messages_Move_To_UPG_Tag(): Code[250]
    begin
        exit('2c2df192-f2d3-4780-9f07-ef9df5549167');
    end;

    procedure PVS_Private_Namespace_Const_Move_To_UPG_Tag(): Code[250]
    begin
        exit('e9030466-2d20-459f-b259-f060689860cb');
    end;

    procedure PVS_Esko_Manufacturing_Move_To_UPG_Tag(): Code[250]
    begin
        exit('040ddf83-b368-49cf-8d1d-caea66da5616');
    end;

    procedure PVS_Workflow_Partner_Commands_Move_To_UPG_Tag(): Code[250]
    begin
        exit('e95fa742-434e-4b5a-9917-1e9432217457');
    end;

    procedure PVS_Workflow_Partner_MIME_Buf_Move_To_UPG_Tag(): Code[250]
    begin
        exit('fd9cea72-91f7-4213-87c2-8302688952a5');
    end;

    procedure PVS_Workflow_Partner_Que_Ent_Move_To_UPG_Tag(): Code[250]
    begin
        exit('61823dcc-add6-4fc4-ac23-d8be8d60e23c');
    end;

    procedure PVS_Workflow_Partner_Resp_At_Move_To_UPG_Tag(): Code[250]
    begin
        exit('4fe57868-1faa-4f45-9987-61e11e5498ab');
    end;

    procedure PVS_Workflow_Partner_Responses_Move_To_UPG_Tag(): Code[250]
    begin
        exit('cf6775ee-a0d1-489c-a7a1-91a1452f7a9f');
    end;

    procedure PVS_CIM_External_Connector_Log_Move_To_UPG_Tag(): Code[250]
    begin
        exit('5cb16771-41bc-408a-b19e-d583f671fff2');
    end;

    procedure PVS_Product_Group_Move_To_UPG_Tag(): Code[250]
    begin
        exit('72906d9e-99e0-4bd1-bbe8-97524de76625');
    end;

    procedure PVS_DCM_Moxa_Entry_Move_To_UPG_Tag(): Code[250]
    begin
        exit('21cfbd6e-db67-41b0-b9cc-458203ef84b3');
    end;

    procedure PVS_DCM_Moxa_Status_Move_To_UPG_Tag(): Code[250]
    begin
        exit('8228aeef-ced4-46c7-a6e8-425b8db811da');
    end;

    procedure PVS_DCM_Input_Mask_Move_To_UPG_Tag(): Code[250]
    begin
        exit('dc74ab66-4c10-4992-b077-e86cc610cc9d');
    end;
} */