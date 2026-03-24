pageextension 80420 "PTE CalcUnit Lookup on Copy" extends "PVS Calculation Unit Setup"
{
    layout
    {
        addafter(Canceled)
        {
            field("Lookup on Copy"; Rec."Lookup on Copy")
            {
                ApplicationArea = All;
                Enabled = LookupOnCopyVisible;
                ToolTip = 'Specifies whether this calculation unit is looked up and re-inserted when copying, instead of being copied as-is.';
            }
        }
    }

    trigger OnAfterGetCurrRecord()
    begin
        UpdateLookupOnCopyVisibility();
    end;

    local procedure UpdateLookupOnCopyVisibility()
    begin
        LookupOnCopyVisible := not Rec."List Of Units";
    end;

    var
        LookupOnCopyVisible: Boolean;

}
