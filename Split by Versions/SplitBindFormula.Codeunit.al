Codeunit 80280 "Split bind"
{

    trigger OnRun()
    begin
        SingleInstance.Get_Current_CalcUnitDetailRec(JobCalculationDetail); // Get the Current Calc. Detail record

        SingleInstance.Get_SheetRecTmp(JobSheetTemp);
        SingleInstance.Get_ProcessRecTmp(JobProcessTemp);
        SingleInstance.Get_JobItemRecTmp(JobItemTemp);

        JobCalculationDetail."Qty. Calculated" := 0; // Clear the field to be calculated

        // If the same report is used for multible formulas:

        case JobCalculationDetail."Formula Code" of
            // Example Formulas
            8199:
                Formula_8199(); //Printing
            8200:
                Formula_8200(); //Paper
            8201:
                Formula_8201(); //Setup
        end;

        SingleInstance.Set_Current_CalcUnitDetailRec(JobCalculationDetail); // Push back the result
    end;

    var
        JobSheetTemp: Record "PVS Job Sheet" temporary;
        JobItemTemp: Record "PVS Job Item" temporary;
        JobItemRec: Record "PVS Job Item";
        JobProcessTemp: Record "PVS Job Process" temporary;
        JobCalculationDetail: Record "PVS Job Calculation Detail";
        JobCalculationDetailTemp: Record "PVS Job Calculation Detail" temporary;
        SingleInstance: Codeunit "PVS SingleInstance";

    local procedure Formula_8199() //Printing
    var
        CalcMgt: Codeunit "PVS Formula Management";
        Local_Job: Record "PVS Job";
        CalcUnitRec: Record "PVS Job Calculation Unit";
        QtyResult: Integer;
        StartScrap: Integer;
        ChangeScrap: Integer;
    begin
        QtyResult := 0;

        if not Local_Job.Get(JobCalculationDetail.ID, JobCalculationDetail.Job, JobCalculationDetail.Version) then
            exit;
        if not CalcUnitRec.Get(JobCalculationDetail.ID, JobCalculationDetail.Job, JobCalculationDetail.Version, JobCalculationDetail."Unit Entry No.") then
            exit;
        if not JobSheetTemp.Get(JobCalculationDetail."Sheet ID") then
            exit;
        if not JobProcessTemp.Get(JobSheetTemp."First Process ID") then
            exit;
        JobItemRec.Reset();
        JobItemRec.SetRange("Sheet ID", JobSheetTemp."Sheet ID");
        if not JobItemRec.FindFirst() then
            exit;

        if JobItemRec."Additional Version" = true then begin
            if not CalcMgt.Standard_Formula_Rutine(155, JobCalculationDetail, CalcUnitRec, Local_Job, JobSheetTemp, JobProcessTemp, false) then
                exit;
            QtyResult := JobCalculationDetail."Qty. Calculated"
        end else begin
            if not CalcMgt.Standard_Formula_Rutine(22, JobCalculationDetail, CalcUnitRec, Local_Job, JobSheetTemp, JobProcessTemp, false) then
                exit;
            QtyResult := JobCalculationDetail."Qty. Calculated"
        end;

        JobCalculationDetail."Qty. Calculated" := QtyResult;
    end;

    local procedure Formula_8200() //Paper
    var
        FormulaRec: Record "PVS Calculation Formula";
        CalcMgt: Codeunit "PVS Formula Management";
        Local_Job: Record "PVS Job";
        CalcUnitRec: Record "PVS Job Calculation Unit";
        QtyResult: Integer;
        StartScrap: Integer;
        ChangeScrap: Integer;
    begin
        QtyResult := 0;
        StartScrap := 0;
        ChangeScrap := 0;

        FormulaRec.get(8200);
        if FormulaRec."Formula Demands" <> 20 then begin
            FormulaRec."Formula Demands" := 20;
            FormulaRec.Modify();
        end;


        if not Local_Job.Get(JobCalculationDetail.ID, JobCalculationDetail.Job, JobCalculationDetail.Version) then
            exit;
        if not CalcUnitRec.Get(JobCalculationDetail.ID, JobCalculationDetail.Job, JobCalculationDetail.Version, JobCalculationDetail."Unit Entry No.") then
            exit;
        if not JobSheetTemp.Get(JobCalculationDetail."Sheet ID") then
            exit;
        if not JobProcessTemp.Get(JobSheetTemp."First Process ID") then
            exit;
        JobItemRec.Reset();
        JobItemRec.SetRange("Sheet ID", JobSheetTemp."Sheet ID");
        if not JobItemRec.FindFirst() then
            exit;

        if JobItemRec."Additional Version" = true then begin
            if not CalcMgt.Standard_Formula_Rutine(145, JobCalculationDetail, CalcUnitRec, Local_Job, JobSheetTemp, JobProcessTemp, false) then
                exit;
            QtyResult := JobCalculationDetail."Qty. Calculated";
        end else begin
            if not CalcMgt.Standard_Formula_Rutine(14, JobCalculationDetail, CalcUnitRec, Local_Job, JobSheetTemp, JobProcessTemp, false) then
                exit;
            QtyResult := JobCalculationDetail."Qty. Calculated";
        end;

        JobCalculationDetail."Qty. Calculated" := QtyResult;
    end;

    local procedure Formula_8201() //Setup
    var
        CalcMgt: Codeunit "PVS Formula Management";
        Local_Job: Record "PVS Job";
        CalcUnitRec: Record "PVS Job Calculation Unit";
        QtyResult: Integer;
        StartScrap: Integer;
        ChangeScrap: Integer;
    begin
        QtyResult := 0;

        if not Local_Job.Get(JobCalculationDetail.ID, JobCalculationDetail.Job, JobCalculationDetail.Version) then
            exit;
        if not CalcUnitRec.Get(JobCalculationDetail.ID, JobCalculationDetail.Job, JobCalculationDetail.Version, JobCalculationDetail."Unit Entry No.") then
            exit;
        if not JobSheetTemp.Get(JobCalculationDetail."Sheet ID") then
            exit;
        if not JobProcessTemp.Get(JobSheetTemp."First Process ID") then
            exit;
        JobItemRec.Reset();
        JobItemRec.SetRange("Sheet ID", JobSheetTemp."Sheet ID");
        if not JobItemRec.FindFirst() then
            exit;

        if (JobItemRec."Common Text" = true) AND (JobItemRec."Additional Version" = true) then begin
            QtyResult := 0;
        end else begin
            QtyResult := 1;
        end;

        JobCalculationDetail."Qty. Calculated" := QtyResult;
    end;


    [EventSubscriber(ObjectType::Codeunit, Codeunit::"PVS Page Management", 'OnAfter_Job_Item_Input_Unit', '', true, true)]
    procedure OnAfter_Job_Item_Input_Unit(in_Rec: Record "PVS Job Item"; SheetRec: Record "PVS Job Sheet"; in_UNIT: Code[20]; xSheetRec: Record "PVS Job Sheet")
    var
        CalcUnit: Record "PVS Job Calculation Unit";
        CalcUnitDetail: Record "PVS Job Calculation Detail";
        CalcUnitSetup: Record "PVS Calculation Unit Setup";
        UpdateDesc: Text[100];
        Position: Integer;
    begin
        CalcUnit.SetRange("ID", in_Rec."ID");
        CalcUnit.SetRange("Job", in_Rec."Job");
        CalcUnit.SetRange("Version", in_Rec."Version");
        CalcUnit.SetRange("Sheet ID", in_Rec."Sheet ID");
        CalcUnit.SetRange("Job Item No.", in_Rec."Job Item No.");
        If CalcUnit.FindSet() then
            repeat
                UpdateDesc := '';
                Position := 0;
                if in_Rec."Split Version" <> '' then begin
                    CalcUnitSetup.Reset();
                    CalcUnitSetup.SetRange("Code", CalcUnit.Unit);
                    CalcUnitSetup.SetRange("Type", CalcUnitSetup."Type"::"Price Unit");
                    if CalcUnitSetup.FindFirst() then begin
                        case CalcUnitSetup."Process Type" OF
                            CalcUnitSetup."Process Type"::Platesetter:
                                begin
                                    if (in_Rec."Common Text" = true) and (in_Rec."Additional Version" = true) then
                                        CalcUnit.Delete(true);
                                    if (in_Rec."Common Text" = false) and (in_Rec."Additional Version" = false) then begin
                                        CalcUnit."Process Group" := In_Rec."Split Version";
                                        CalcUnit.Modify(true);
                                    end;
                                end;
                            CalcUnitSetup."Process Type"::PrePress:
                                begin
                                    if (in_Rec."Common Text" = true) and (in_Rec."Additional Version" = true) then
                                        CalcUnit.Delete(true);
                                    if (in_Rec."Common Text" = false) and (in_Rec."Additional Version" = false) then begin
                                        CalcUnit."Process Group" := In_Rec."Split Version";
                                        CalcUnit.Modify(true);
                                    end;
                                end;
                            else
                                CalcUnit."Process Group" := in_Rec."Split Version";
                                CalcUnit.Modify(true);
                        end;
                    end;
                end;
            until CalcUnit.Next() = 0;
    end;
}