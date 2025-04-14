codeunit 80207 StatusChange
{

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"PVS Main", 'OnCaseAfterStatusChange', '', true, true)]
    procedure OnCaseAfterStatusChange(StatusCodeFromRec: Record "PVS Status Code"; StatusCodeToRec: Record "PVS Status Code"; var CaseRec: Record "PVS Case"; var IsHandled: Boolean)
    var
        PlanUnitRec: Record "PVS Job Planning Unit";
        GeneralSetupRec: Record "PVS General Setup";
    begin
        if GeneralSetupRec.FindFirst() then begin
            if GeneralSetupRec.MilestoneOnly <> '' then begin
                PlanUnitRec.SetRange(ID, CaseRec.ID);
                PlanUnitRec.SetRange(Milestone, false);
                if StatusCodeToRec.Code = GeneralSetupRec.MilestoneOnly then begin
                    PlanUnitRec.SetRange("Planning Status", PlanUnitRec."Planning Status"::"Not planned");
                    PlanUnitRec.ModifyAll("Planning Status", PlanUnitRec."Planning Status"::"Reserved")
                end else begin
                    PlanUnitRec.SetRange("Planning Status", PlanUnitRec."Planning Status"::"Reserved");
                    PlanUnitRec.ModifyAll("Planning Status", PlanUnitRec."Planning Status"::"Not planned");
                end;
            end;
        end;
    end;

    [EventSubscriber(ObjectType::Page, Page::"PVS Production Plan", 'OnBeforeSetFilter', '', true, true)]

    procedure OnBeforeSetFilter(var Rec: Record "PVS Job Planning Unit"; PVSProductionPlanSub: Page "PVS Production Plan SUB"; var EnableFilterSelection: Boolean; var SelectPlannedEnabled: Boolean; var SelectCompletedEnabled: Boolean; var SelectBothEnabled: Boolean; var SelectNotPlannedEnabled: Boolean; var TogglePlanJobEnabled: Boolean; var TogglePlanPoolEnabled: Boolean; var Select_Status: Option Planned,Completed,Both,"Not Planned"; var Select_SUB: Option Job,Pool,"None"; var IsHandled: Boolean)
    var
        UserRegistration: Record "User Time Register";
        FilterRec: Record "PVS Job Planning Unit";
        UserMgt: Codeunit "PVS User Management";
        SingleInstance: Codeunit "PVS SingleInstance";
    begin
        Rec.Reset();
        UserMgt.Get_UserRegistration(SingleInstance.Get_Current_Logical_Login_User(), UserRegistration);

        EnableFilterSelection := true;

        case UserRegistration."PVS Prod. Plan Sorting" of
            UserRegistration."pvs prod. plan sorting"::Priority:
                Rec.SetCurrentkey(Rec."Simulation Version", Rec."Capacity Unit", Rec.Active, Rec.Priority, Rec.Ending, Rec.Start);
            UserRegistration."pvs prod. plan sorting"::Manning:
                Rec.SetCurrentkey(Rec."Simulation Version", Rec.Active, Rec."Capacity Resource", Rec.Start, Rec.Ending);
            UserRegistration."pvs prod. plan sorting"::ID:
                Rec.SetCurrentkey(Rec."Simulation Version", Rec.ID, Rec.Job, Rec."Sorting Order");
            UserRegistration."pvs prod. plan sorting"::StartDate:
                Rec.SetCurrentkey(Rec.Start);
        end;

        // Check Single Instance
        // Use Managed Filters or skip those if in LookupUp Mode

        SingleInstance.Get_PlanRec_Filter(FilterRec);
        if FilterRec.HasFilter() then begin
            // Clear Managed Filters
            Rec.SetRange(Rec.Department);
            Rec.SetRange(Rec."Capacity Group");
            Rec.SetRange(Rec."Flow Capacity Group");
            Rec.SetRange(Rec."Capacity Unit");
            Rec.SetRange(Rec."Capacity Resource");
            Rec.SetRange(Rec."Simulation Version", 0);
            Rec.SetRange(Rec.Active, true);
            Rec.SetRange(Rec.Archived, false);
            Rec.SetRange(Rec.Start);
            Rec.SetRange(Rec.Ending);
            Rec.SetRange(Rec."Earliest Start");
            Rec.SetRange(Rec."Finished No Later Than");
            Rec.SetRange(Rec."Planning Status");
            Rec.SetRange(Rec."Hide In Production Plan", false);
            Rec.SetRange(Rec."Show In Production Plan", true);
            Rec.CopyFilters(FilterRec);
            if Rec.FindSet() then;
            EnableFilterSelection := false;
        end else begin
            // Clear Managed Filters
            Rec.SetRange(Rec.Department);
            Rec.SetRange(Rec."Capacity Group");
            Rec.SetRange(Rec."Flow Capacity Group");
            Rec.SetRange(Rec."Capacity Unit");
            Rec.SetRange(Rec."Capacity Resource");
            Rec.SetRange(Rec."Simulation Version", 0);
            Rec.SetRange(Rec.Active, true);
            Rec.SetRange(Rec.Archived, false);
            Rec.SetRange(Rec.Start);
            Rec.SetRange(Rec.Ending);
            Rec.SetRange(Rec."Earliest Start");
            Rec.SetRange(Rec."Finished No Later Than");
            Rec.SetRange(Rec."Planning Status");
            Rec.SetRange(Rec."Hide In Production Plan", false);
            Rec.SetRange(Rec."Show In Production Plan", true);

            // Set Managed Filters
            if UserRegistration."PVS Prod. Plan Department" <> '' then
                Rec.SetRange(Rec.Department, UserRegistration."PVS Prod. Plan Department");

            if UserRegistration."PVS Prod. Plan Capacity Group" <> '' then
                Rec.SetRange(Rec."Capacity Group", UserRegistration."PVS Prod. Plan Capacity Group");

            if UserRegistration."PVS Prod. Plan Capacity Code" <> '' then
                Rec.SetRange(Rec."Capacity Unit", UserRegistration."PVS Prod. Plan Capacity Code");

            if UserRegistration."PVS Prod. Plan Manning Code" <> '' then
                Rec.SetRange(Rec."Capacity Resource", UserRegistration."PVS Prod. Plan Manning Code");

            // Date Filter
            if (UserRegistration."PVS Prod. Plan From Date" <> 0D) and (UserRegistration."PVS Prod. Plan To Date" <> 0D) then begin
                Rec.SetFilter(Rec.Start, '..%1', CreateDatetime(UserRegistration."PVS Prod. Plan To Date", 235959T));
                Rec.SetFilter(Rec.Ending, '%1..', CreateDatetime(UserRegistration."PVS Prod. Plan From Date", 0T));
            end else begin
                if UserRegistration."PVS Prod. Plan From Date" <> 0D then
                    Rec.SetFilter(Rec.Start, '%1..', CreateDatetime(UserRegistration."PVS Prod. Plan From Date", 0T));

                if UserRegistration."PVS Prod. Plan To Date" <> 0D then
                    Rec.SetFilter(Rec.Ending, '..%1', CreateDatetime(UserRegistration."PVS Prod. Plan To Date", 235959T));
            end;

            // Status Filter
            case Select_Status of

                Select_status::Planned:
                    Rec.SetFilter(Rec."Planning Status", '%1|%2|%3|%4', Rec."planning status"::"Variable Planned",
                      Rec."planning status"::Locked, Rec."planning status"::"In Progress", Rec."planning status"::Paused);

                Select_status::Completed:
                    Rec.SetRange(Rec."Planning Status", Rec."planning status"::Completed);

                Select_status::Both:
                    Rec.SetFilter(Rec."Planning Status", '%1|%2|%3|%4|%5', Rec."planning status"::"Variable Planned",
                      Rec."planning status"::Locked, Rec."planning status"::"In Progress",
                      Rec."planning status"::Paused, Rec."planning status"::Completed);

                Select_status::"Not Planned":
                    begin
                        Rec.SetFilter(Rec."Planning Status", '%1|%2', Rec."planning status"::"Not planned", Rec."Planning Status"::Reserved);
                        Rec.SetRange(Rec.Start);
                        Rec.SetRange(Rec.Ending);
                    end;
            end;

            SelectPlannedEnabled := Select_Status <> Select_status::Planned;
            SelectCompletedEnabled := Select_Status <> Select_status::Completed;
            SelectBothEnabled := Select_Status <> Select_status::Both;
            SelectNotPlannedEnabled := Select_Status <> Select_status::"Not Planned";
        end;

        TogglePlanPoolEnabled := Select_SUB <> Select_sub::Pool;
        TogglePlanJobEnabled := Select_SUB <> Select_sub::Job;

        // Filter SUB Pages
        PVSProductionPlanSub.SET_FILTER(Rec, Select_SUB);
        IsHandled := true;
    end;

    [EventSubscriber(ObjectType::Page, Page::"PVS Production Plan SUB", 'OnAfter_SET_FILTER_BeforeFindFirst', '', true, true)]

    procedure OnAfter_SET_FILTER_BeforeFindFirst(var out_Rec: Record "PVS Job Planning Unit"; in_FilterRec: Record "PVS Job Planning Unit"; var Select_SUB: Option Job,Pool,"None")
    begin
        if Select_SUB = Select_sub::Pool then begin
            out_Rec.SetRange(out_Rec."Planning Status");
            out_Rec.SetFilter(out_Rec."Planning Status", '%1|%2', out_Rec."planning status"::"Not planned", out_Rec."Planning Status"::Reserved);
        end;
    end;
}

tableextension 80207 PlanTable extends "PVS Job Planning Unit"
{
    fields
    {
        modify("Planning Status")
        {
            OptionCaption = 'Not planned,Wait,Planned,Locked,In Progress,Paused,Completed,,,,Recalculated,Surcharge';

        }
    }
}

tableextension 80208 GeneralSetup extends "PVS General Setup"
{
    fields
    {
        field(50148; "MilestoneOnly"; Code[20])
        {
            Caption = 'Schedule Milestones Only';
            DataClassification = CustomerContent;
            TableRelation = "PVS Status Code".Code where(User = const(''));
        }
    }
}

pageextension 80207 GeneralSetupPage extends "PVS General Setup"
{
    layout
    {
        addlast(CaseManagement)
        {
            field("MilestoneOnly"; Rec."MilestoneOnly")
            {
                ApplicationArea = All;
                ToolTip = 'If checked, only milestones will be scheduled for the case, all other planning units will be assigned Wait status';
            }
        }
    }
}

pageextension 80208 ProdPlanSubPage extends "PVS Production Plan SUB"
{
    layout
    {
        addbefore(Priority)
        {
            field("Planning Status"; Rec."Planning Status")
            {
                ApplicationArea = All;
            }
        }
    }
}