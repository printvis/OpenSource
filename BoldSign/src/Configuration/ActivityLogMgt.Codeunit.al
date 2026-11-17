namespace PrintVis.BoldSign.Configuration;

using Microsoft.Utilities;

codeunit 80318 "PVS BS Activity Log Mgt."
{
    Access = Public;

    /// <summary>
    /// Logs activity with the status Success
    /// </summary>
    /// <param name="Document">The document for which to log the activity</param>
    /// <param name="ActivityDescription">Description of the activity performed</param>
    /// <param name="ActivityMessage">Additional message about the activity</param>
    procedure LogSuccess(RelatedVariant: Variant; ActivityDescription: Text[250]; ActivityMessage: Text[250])
    begin
        this.LogActivity(RelatedVariant, ActivityDescription, 0, ActivityMessage);
    end;

    /// <summary>
    /// Logs activity with the status Failed
    /// </summary>
    /// <param name="RelatedVariant">The variant for which to log the activity</param>
    /// <param name="ActivityDescription">Description of the activity performed</param>
    /// <param name="ActivityMessage">Additional message about the activity</param>
    procedure LogFailure(RelatedVariant: Variant; ActivityDescription: Text[250]; ActivityMessage: Text[250])
    begin
        this.LogActivity(RelatedVariant, ActivityDescription, 1, ActivityMessage);
    end;

    /// <summary>
    /// Logs activity with the specified activity description and status
    /// </summary>
    /// <param name="RelatedVariant">The variant for which to log the activity</param>
    /// <param name="ActivityDescription">Description of the activity performed</param>
    /// <param name="ActivityStatus">Status of the activity (Success/Failed)</param>
    /// <param name="ActivityMessage">Additional message about the activity</param>
    local procedure LogActivity(RelatedVariant: Variant; ActivityDescription: Text[250]; ActivityStatus: Option; ActivityMessage: Text[250])
    var
        ActivityLog: Record "Activity Log";
    begin
        ActivityLog.LogActivity(RelatedVariant,
            ActivityStatus,
            '',
            ActivityDescription,
            ActivityMessage);
    end;
}
